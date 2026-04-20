// Imports all memories (with their spheres, portals, markers, sounds) from a
// Rails pg_dump unpacked SQL file plus a CarrierWave-style uploads directory.
//
// Inputs:
//   store        - DataStore instance
//   sqlPath      - absolute path to the unpacked .sql dump
//   uploadsDir   - absolute path to the CarrierWave uploads dir, which should
//                  contain subdirs: sphere/panorama/{id}/, marker/embedded_photo/{id}/,
//                  sound/file/{id}/
//   onProgress   - optional callback({ phase, current, total, message })
//
// User-table data (users, microposts, delayed_jobs) is never read — no PII
// lands in the SQLite DB.
//
// Path layout inside userData (mirrors the source uploads dir and matches
// Joe's Boat seed convention — paths are stored relative to store.dataDir):
//   sphere/panorama/{old_id}/{filename}
//   sphere/panorama/{old_id}/thumb_{filename}
//   marker/embedded_photo/{old_id}/{filename}
//   sound/file/{old_id}/{filename}

const fs = require('fs');
const path = require('path');
const { parseDump, parsePolygonYaml } = require('./sql-dump-parser');

// Memories with these exact names are excluded from the packaged seed. Used to
// drop test/scratch entries so they don't ship in the built app.
const EXCLUDED_MEMORY_NAMES = new Set([
  'dylans-face',
  'New Memory',
  'Boat 2',
  'mem2',
  'dylan',
]);

function preview(sqlPath) {
  const sql = fs.readFileSync(sqlPath, 'utf8');
  const tables = parseDump(sql, ['memories', 'spheres']);
  const spheresByMemory = {};
  for (const s of tables.spheres) {
    const mid = s.memory_id;
    spheresByMemory[mid] = (spheresByMemory[mid] || 0) + 1;
  }
  return {
    memoryCount: tables.memories.length,
    sphereCount: tables.spheres.length,
    memories: tables.memories.map(m => ({
      id: m.id,
      name: m.name,
      sphereCount: spheresByMemory[m.id] || 0,
      created_at: m.created_at,
    })),
  };
}

function copyIfExists(src, dest) {
  if (!fs.existsSync(src)) return false;
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(src, dest);
  return true;
}

// Rewrites <img src="/assets/foo-HASH.ext"> references. Rails asset-pipeline
// fingerprints filenames with a hex hash (e.g. "joesface-e3322...jpg"). We
// strip the hash to recover the original filename and look for it in
// assetsDir. If found, copy into userdata under marker/asset/{filename} and
// rewrite src to "{{ASSET:marker/asset/{filename}}}" — a placeholder resolved
// at read time by data-store.js into a file:// URL. If not found, strip the
// img tag so the popup isn't left with a broken image reference.
function rewriteRailsAssetImgs(html, assetsDir, store, summary) {
  if (!html) return html;
  return html.replace(/<img\b([^>]*)src=["']\/assets\/([^"']+)["']([^>]*)\/?>/gi, (match, before, assetPath, after) => {
    const m = assetPath.match(/^(.*)-[0-9a-f]{32,}(\.[^.]+)$/i);
    const basename = m ? m[1] + m[2] : assetPath;
    if (assetsDir) {
      const src = path.join(assetsDir, basename);
      if (fs.existsSync(src)) {
        const destDir = path.join(store.dataDir, 'marker', 'asset');
        const dest = path.join(destDir, basename);
        fs.mkdirSync(destDir, { recursive: true });
        if (!fs.existsSync(dest)) fs.copyFileSync(src, dest);
        const rel = path.relative(store.dataDir, dest).split(path.sep).join('/');
        return `<img${before}src="{{ASSET:${rel}}}"${after}>`;
      }
    }
    summary.missingAssets.push(`asset: ${assetPath}`);
    return '';
  });
}

function importAll(store, { sqlPath, uploadsDir, assetsDir, onProgress }) {
  const progress = onProgress || (() => {});
  const sql = fs.readFileSync(sqlPath, 'utf8');

  progress({ phase: 'parsing', current: 0, total: 1, message: 'Parsing SQL dump…' });
  const tables = parseDump(sql, [
    'memories', 'spheres', 'portals', 'markers', 'sounds', 'sound_contexts',
  ]);

  // Pre-index rows for fast lookup
  const spheresByMem = new Map();
  for (const s of tables.spheres) {
    if (!spheresByMem.has(s.memory_id)) spheresByMem.set(s.memory_id, []);
    spheresByMem.get(s.memory_id).push(s);
  }
  const markersBySphere = new Map();
  for (const m of tables.markers) {
    if (!markersBySphere.has(m.sphere_id)) markersBySphere.set(m.sphere_id, []);
    markersBySphere.get(m.sphere_id).push(m);
  }
  const portalsByFrom = new Map();
  for (const p of tables.portals) {
    if (!portalsByFrom.has(p.from_sphere_id)) portalsByFrom.set(p.from_sphere_id, []);
    portalsByFrom.get(p.from_sphere_id).push(p);
  }
  const soundById = new Map();
  for (const s of tables.sounds) soundById.set(s.id, s);

  // Sound contexts can be looked up by (context_type, context_id)
  const soundContextByCtx = new Map();
  for (const sc of tables.sound_contexts) {
    soundContextByCtx.set(`${sc.context_type}:${sc.context_id}`, sc);
  }

  const summary = {
    memoriesImported: 0,
    spheresImported: 0,
    portalsImported: 0,
    markersImported: 0,
    soundsImported: 0,
    missingAssets: [],
    errors: [],
  };

  const allMemories = tables.memories;
  const memories = allMemories.filter(m => !EXCLUDED_MEMORY_NAMES.has(m.name));
  const skippedCount = allMemories.length - memories.length;
  if (skippedCount > 0) {
    progress({
      phase: 'parsing',
      current: 0,
      total: 1,
      message: `Skipping ${skippedCount} excluded memory/memories`,
    });
  }
  let memIdx = 0;

  for (const mem of memories) {
    memIdx++;
    progress({
      phase: 'importing',
      current: memIdx,
      total: memories.length,
      message: `Importing "${mem.name}" (${memIdx}/${memories.length})…`,
    });

    try {
      const memoryOldId = mem.id;
      const spheresForMem = spheresByMem.get(memoryOldId) || [];
      // Sort spheres by created_at, matching the rest of the app's conventions
      spheresForMem.sort((a, b) => (a.created_at || '').localeCompare(b.created_at || ''));

      // Wrap per-memory work in a single DB transaction
      const runMemory = store.db.transaction(() => {
        const memResult = store.db.prepare(
          'INSERT INTO memories (name, description, created_at, updated_at) VALUES (?, ?, ?, ?)'
        ).run(mem.name || 'Untitled Memory', mem.description || '', mem.created_at, mem.updated_at || mem.created_at);
        const newMemoryId = memResult.lastInsertRowid;
        summary.memoriesImported++;

        const oldToNewSphere = new Map();
        const sphereSoundMap = new Map(); // old sound id → new sound id (for dedupe)

        // ── Spheres + panorama/thumb assets ──
        for (const s of spheresForMem) {
          const filename = s.panorama;
          const srcDir = path.join(uploadsDir, 'sphere', 'panorama', s.id);
          const destDir = path.join(store.dataDir, 'sphere', 'panorama', s.id);

          const srcPanorama = filename ? path.join(srcDir, filename) : null;
          const destPanorama = filename ? path.join(destDir, filename) : null;
          if (srcPanorama && !copyIfExists(srcPanorama, destPanorama)) {
            summary.missingAssets.push(`panorama: ${srcPanorama}`);
          }

          const thumbFilename = filename ? `thumb_${filename}` : null;
          const srcThumb = thumbFilename ? path.join(srcDir, thumbFilename) : null;
          const destThumb = thumbFilename ? path.join(destDir, thumbFilename) : null;
          let thumbExists = false;
          if (srcThumb) thumbExists = copyIfExists(srcThumb, destThumb);

          const relPanorama = destPanorama ? path.relative(store.dataDir, destPanorama) : null;
          const relThumb = thumbExists ? path.relative(store.dataDir, destThumb) : relPanorama;

          const sphereResult = store.db.prepare(
            'INSERT INTO spheres (memory_id, caption, panorama_path, thumb_path, default_zoom, guid, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)'
          ).run(
            newMemoryId,
            s.caption || 'Untitled Sphere',
            relPanorama,
            relThumb,
            s.default_zoom != null ? parseInt(s.default_zoom, 10) : 50,
            s.guid || String(s.id),
            s.created_at
          );
          oldToNewSphere.set(s.id, sphereResult.lastInsertRowid);
          summary.spheresImported++;

          // ── Markers for this sphere ──
          const markers = markersBySphere.get(s.id) || [];
          for (const m of markers) {
            let embeddedPhotoPath = null;
            if (m.embedded_photo) {
              const photoSrcDir = path.join(uploadsDir, 'marker', 'embedded_photo', m.id);
              const photoSrc = path.join(photoSrcDir, m.embedded_photo);
              const photoDestDir = path.join(store.dataDir, 'marker', 'embedded_photo', m.id);
              const photoDest = path.join(photoDestDir, m.embedded_photo);
              if (copyIfExists(photoSrc, photoDest)) {
                embeddedPhotoPath = path.relative(store.dataDir, photoDest);
              } else {
                summary.missingAssets.push(`marker photo: ${photoSrc}`);
              }
            }

            store.db.prepare(
              'INSERT INTO markers (sphere_id, x, y, width, height, tooltip_content, tooltip_position, content, guid, embedded_photo_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
            ).run(
              oldToNewSphere.get(s.id),
              m.x != null ? parseFloat(m.x) : 0,
              m.y != null ? parseFloat(m.y) : 0,
              m.width != null ? parseFloat(m.width) : 32,
              m.height != null ? parseFloat(m.height) : 32,
              m.tooltip_content || null,
              m.tooltip_position || 'right bottom',
              rewriteRailsAssetImgs(m.content, assetsDir, store, summary) || '',
              m.guid || String(m.id),
              embeddedPhotoPath
            );
            summary.markersImported++;
          }

          // ── Sphere-level sound ──
          const ctxKey = `Sphere:${s.id}`;
          if (soundContextByCtx.has(ctxKey)) {
            const sc = soundContextByCtx.get(ctxKey);
            const newSoundId = ensureSound(store, sc.sound_id, sphereSoundMap, soundById, uploadsDir, summary);
            if (newSoundId) {
              store.db.prepare(
                'INSERT INTO sound_contexts (context_type, context_id, sound_id) VALUES (?, ?, ?)'
              ).run('Sphere', oldToNewSphere.get(s.id), newSoundId);
            }
          }
        }

        // ── Portals (after all spheres in this memory exist) ──
        for (const s of spheresForMem) {
          const fromNew = oldToNewSphere.get(s.id);
          const portals = portalsByFrom.get(s.id) || [];
          for (const p of portals) {
            const toNew = oldToNewSphere.get(p.to_sphere_id);
            if (!toNew) continue; // destination sphere not in this memory — skip

            const polygon = parsePolygonYaml(p.polygon_px);
            store.db.prepare(
              'INSERT INTO portals (from_sphere_id, to_sphere_id, polygon_px, fill, stroke, stroke_transparency, stroke_width, tooltip_content, tooltip_position, fov_lat, fov_lng) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
            ).run(
              fromNew,
              toNew,
              JSON.stringify(polygon),
              p.fill || 'points',
              p.stroke || '#ff0032',
              p.stroke_transparency != null ? parseInt(p.stroke_transparency, 10) : 80,
              p.stroke_width != null ? parseInt(p.stroke_width, 10) : 2,
              p.tooltip_content || null,
              p.tooltip_position || 'right bottom',
              p.fov_lat != null ? parseFloat(p.fov_lat) : 0,
              p.fov_lng != null ? parseFloat(p.fov_lng) : 0
            );
            summary.portalsImported++;
          }
        }

        // ── Memory-level sound ──
        const memCtxKey = `Memory:${memoryOldId}`;
        if (soundContextByCtx.has(memCtxKey)) {
          const sc = soundContextByCtx.get(memCtxKey);
          const newSoundId = ensureSound(store, sc.sound_id, sphereSoundMap, soundById, uploadsDir, summary);
          if (newSoundId) {
            store.db.prepare(
              'INSERT INTO sound_contexts (context_type, context_id, sound_id) VALUES (?, ?, ?)'
            ).run('Memory', newMemoryId, newSoundId);
          }
        }
      });

      runMemory();
    } catch (err) {
      summary.errors.push({ memory: mem.name, message: err.message });
    }
  }

  progress({ phase: 'done', current: memories.length, total: memories.length, message: 'Import complete' });
  return summary;
}

// Copies the sound asset (if needed), inserts into sounds table (if not already
// imported in this run), and returns the new sound id. Returns null if the
// source sound row doesn't exist in the dump.
function ensureSound(store, oldSoundId, sphereSoundMap, soundById, uploadsDir, summary) {
  if (sphereSoundMap.has(oldSoundId)) return sphereSoundMap.get(oldSoundId);
  const soundRow = soundById.get(oldSoundId);
  if (!soundRow) return null;

  let relPath = null;
  if (soundRow.file) {
    const src = path.join(uploadsDir, 'sound', 'file', oldSoundId, soundRow.file);
    const destDir = path.join(store.dataDir, 'sound', 'file', oldSoundId);
    const dest = path.join(destDir, soundRow.file);
    if (copyIfExists(src, dest)) {
      relPath = path.relative(store.dataDir, dest);
    } else {
      summary.missingAssets.push(`sound: ${src}`);
      relPath = path.relative(store.dataDir, dest); // store expected path anyway
    }
  }

  const result = store.db.prepare(
    'INSERT INTO sounds (name, file_path, volume, loops) VALUES (?, ?, ?, ?)'
  ).run(
    soundRow.name || '',
    relPath,
    soundRow.volume != null ? parseInt(soundRow.volume, 10) : 50,
    soundRow.loops != null ? parseInt(soundRow.loops, 10) : 999
  );
  const newId = result.lastInsertRowid;
  sphereSoundMap.set(oldSoundId, newId);
  summary.soundsImported++;
  return newId;
}

module.exports = { preview, importAll };
