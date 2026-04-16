// RESERVED: kept as the starting point for a future "Import from SQL backup" UI
// phase. Not currently wired to any menu item or IPC handler. Paths it
// references (parsed-memories.json, webapp/backup/2024-backup-unpacked.sql)
// are no longer bundled with the desktop app, so this code will need to be
// reworked against a runtime-selected backup directory when the import UI is
// built.
const path = require('path');
const fs = require('fs');
const DataStore = require('./data-store');

function importJoesBoat(store, backupDir) {
  // Try packaged location, then dev location for parsed-memories.json
  let parsedPath = path.join(__dirname, '..', '..', 'parsed-memories.json');
  if (!fs.existsSync(parsedPath)) {
    parsedPath = path.join(process.resourcesPath, 'app', 'parsed-memories.json');
  }
  const allMemories = JSON.parse(fs.readFileSync(parsedPath, 'utf8'));
  const boat = allMemories.find(m => m.id === 2);
  if (!boat) throw new Error("Joe's Boat not found in parsed data");

  const uploadsDir = path.join(backupDir, 'uploads');
  // Try dev location, then packaged for SQL dump
  let sqlPath = path.join(__dirname, '..', '..', '..', 'backup', '2024-backup-unpacked.sql');
  if (!fs.existsSync(sqlPath)) {
    sqlPath = path.join(process.resourcesPath, 'backup', '2024-backup-unpacked.sql');
  }

  // Parse created_at from SQL for sphere ordering
  const sql = fs.readFileSync(sqlPath, 'utf8');
  const sphereMatch = sql.match(/COPY "public"\."spheres" \(([^)]+)\) FROM stdin;\n([\s\S]*?)\n\\\./);
  const cols = sphereMatch[1].split(', ').map(c => c.replace(/"/g, ''));
  const rows = sphereMatch[2].split('\n').filter(r => r.trim());
  const sphereData = {};
  rows.forEach(r => {
    const vals = r.split('\t');
    const obj = {};
    cols.forEach((c, i) => obj[c] = vals[i]);
    sphereData[parseInt(obj.id)] = obj;
  });

  // Check if already imported
  const existing = store.db.prepare("SELECT id FROM memories WHERE name = 'Joe''s Boat'").get();
  if (existing) {
    console.log("Joe's Boat already imported, skipping");
    return existing.id;
  }

  // Create memory
  const memResult = store.db.prepare(
    "INSERT INTO memories (name, description, created_at, updated_at) VALUES (?, ?, ?, ?)"
  ).run(boat.name, '', '2017-06-05 07:15:47', '2017-06-05 07:15:47');
  const memoryId = memResult.lastInsertRowid;

  const oldToNewSphere = {};

  // Sort spheres by created_at
  const sortedSpheres = [...boat.spheres].sort((a, b) => {
    const aDate = sphereData[a.id] ? sphereData[a.id].created_at : '9999';
    const bDate = sphereData[b.id] ? sphereData[b.id].created_at : '9999';
    return aDate.localeCompare(bDate);
  });

  for (const sphere of sortedSpheres) {
    const oldId = sphere.id;
    const filename = sphere.panorama.replace('./images/', '');
    const srcDir = path.join(uploadsDir, 'sphere', 'panorama', String(oldId));

    // Copy panorama
    const panoramaDir = path.join(store.panoramasDir, String(oldId));
    fs.mkdirSync(panoramaDir, { recursive: true });

    const srcPanorama = path.join(srcDir, filename);
    const destPanorama = path.join(panoramaDir, filename);
    if (fs.existsSync(srcPanorama)) {
      fs.copyFileSync(srcPanorama, destPanorama);
    }

    // Copy thumb
    const thumbFilename = 'thumb_' + filename;
    const srcThumb = path.join(srcDir, thumbFilename);
    const destThumb = path.join(panoramaDir, thumbFilename);
    if (fs.existsSync(srcThumb)) {
      fs.copyFileSync(srcThumb, destThumb);
    }

    const relPanorama = path.relative(store.dataDir, destPanorama);
    const relThumb = fs.existsSync(destThumb) ? path.relative(store.dataDir, destThumb) : relPanorama;
    const createdAt = sphereData[oldId] ? sphereData[oldId].created_at : '2017-01-01';

    const sResult = store.db.prepare(
      'INSERT INTO spheres (memory_id, caption, panorama_path, thumb_path, default_zoom, guid, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)'
    ).run(memoryId, sphere.caption, relPanorama, relThumb, sphere.defaultZoom || 50, String(oldId), createdAt);

    oldToNewSphere[oldId] = sResult.lastInsertRowid;
  }

  // Import portals (second pass, after all spheres are created)
  for (const sphere of sortedSpheres) {
    const newFromId = oldToNewSphere[sphere.id];
    for (const portal of sphere.portals) {
      const newToId = oldToNewSphere[portal.to_sphere_id];
      if (!newToId) continue; // skip portals to spheres not in this memory

      const polygonPx = portal.polygon_px;
      // Extract raw values from the portal's svgStyle
      const strokeMatch = (portal.svgStyle.stroke || '').match(/rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)/);
      let strokeHex = '#ff0032';
      let strokeTransparency = 80;
      if (strokeMatch) {
        const r = parseInt(strokeMatch[1]).toString(16).padStart(2, '0');
        const g = parseInt(strokeMatch[2]).toString(16).padStart(2, '0');
        const b = parseInt(strokeMatch[3]).toString(16).padStart(2, '0');
        strokeHex = `#${r}${g}${b}`;
        strokeTransparency = Math.round(parseFloat(strokeMatch[4]) * 100);
      }
      const fillMatch = (portal.svgStyle.fill || '').match(/url\(#(\w+)\)/);
      const fill = fillMatch ? fillMatch[1] : 'points';
      const strokeWidthMatch = (portal.svgStyle['stroke-width'] || '').match(/(\d+)/);
      const strokeWidth = strokeWidthMatch ? parseInt(strokeWidthMatch[1]) : 2;

      store.db.prepare(
        'INSERT INTO portals (from_sphere_id, to_sphere_id, polygon_px, fill, stroke, stroke_transparency, stroke_width, tooltip_content, tooltip_position, fov_lat, fov_lng) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
      ).run(
        newFromId, newToId, JSON.stringify(polygonPx),
        fill, strokeHex, strokeTransparency, strokeWidth,
        portal.tooltip ? portal.tooltip.content : null,
        portal.tooltip ? portal.tooltip.position : 'right bottom',
        portal.fov_lat || 0, portal.fov_lng || 0
      );
    }
  }

  // Import markers
  for (const sphere of sortedSpheres) {
    const newSphereId = oldToNewSphere[sphere.id];
    for (const marker of sphere.markers) {
      const oldMarkerId = marker.id.replace('marker-', '');
      let embeddedPhotoPath = null;

      // Copy embedded photo if it exists in backup
      const photoSrcDir = path.join(uploadsDir, 'marker', 'embedded_photo', oldMarkerId);
      if (fs.existsSync(photoSrcDir)) {
        const photos = fs.readdirSync(photoSrcDir);
        if (photos.length > 0) {
          const photoDir = path.join(store.photosDir, oldMarkerId);
          fs.mkdirSync(photoDir, { recursive: true });
          const destPhoto = path.join(photoDir, photos[0]);
          fs.copyFileSync(path.join(photoSrcDir, photos[0]), destPhoto);
          embeddedPhotoPath = path.relative(store.dataDir, destPhoto);
        }
      }

      store.db.prepare(
        'INSERT INTO markers (sphere_id, x, y, width, height, tooltip_content, tooltip_position, content, guid, embedded_photo_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
      ).run(
        newSphereId, marker.x, marker.y, marker.width || 32, marker.height || 32,
        marker.tooltip ? marker.tooltip.content : null,
        marker.tooltip ? marker.tooltip.position : 'right bottom',
        marker.content || '', oldMarkerId, embeddedPhotoPath
      );
    }
  }

  // Import sounds
  const soundMap = {};
  if (boat.defaultSound) {
    const sndFilename = boat.defaultSound.url.replace('./sounds/', '');
    const oldSoundId = boat.defaultSound.id.replace('sound-', '');
    const srcSound = path.join(uploadsDir, 'sound', 'file', oldSoundId, sndFilename);
    const destDir = path.join(store.soundsDir, oldSoundId);
    fs.mkdirSync(destDir, { recursive: true });
    const destSound = path.join(destDir, sndFilename);
    if (fs.existsSync(srcSound)) fs.copyFileSync(srcSound, destSound);

    const sndResult = store.db.prepare(
      'INSERT INTO sounds (name, file_path, volume, loops) VALUES (?, ?, ?, ?)'
    ).run(boat.defaultSound.name, path.relative(store.dataDir, destSound), boat.defaultSound.volume, boat.defaultSound.loops);
    soundMap[boat.defaultSound.id] = sndResult.lastInsertRowid;

    // Link to memory
    store.db.prepare('INSERT INTO sound_contexts (context_type, context_id, sound_id) VALUES (?, ?, ?)').run('Memory', memoryId, sndResult.lastInsertRowid);
  }

  // Sphere-level sounds
  for (const sphere of sortedSpheres) {
    if (sphere.sound) {
      const sndFilename = sphere.sound.url.replace('./sounds/', '');
      const oldSoundId = sphere.sound.id.replace('sound-', '');
      let newSoundId = soundMap[sphere.sound.id];

      if (!newSoundId) {
        const srcSound = path.join(uploadsDir, 'sound', 'file', oldSoundId, sndFilename);
        const destDir = path.join(store.soundsDir, oldSoundId);
        fs.mkdirSync(destDir, { recursive: true });
        const destSound = path.join(destDir, sndFilename);
        if (fs.existsSync(srcSound)) fs.copyFileSync(srcSound, destSound);

        const sndResult = store.db.prepare(
          'INSERT INTO sounds (name, file_path, volume, loops) VALUES (?, ?, ?, ?)'
        ).run(sphere.sound.name, path.relative(store.dataDir, destSound), sphere.sound.volume, sphere.sound.loops);
        newSoundId = sndResult.lastInsertRowid;
        soundMap[sphere.sound.id] = newSoundId;
      }

      store.db.prepare('INSERT INTO sound_contexts (context_type, context_id, sound_id) VALUES (?, ?, ?)').run('Sphere', oldToNewSphere[sphere.id], newSoundId);
    }
  }

  console.log(`Imported Joe's Boat: memory ${memoryId}, ${sortedSpheres.length} spheres`);
  return memoryId;
}

module.exports = { importJoesBoat };
