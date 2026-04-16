// Seeds Joe's Boat into an empty database on first launch.
// Reads resources/joes-boat.json from the app bundle and inserts rows into SQLite.
// Assets are NOT copied — they are served directly from the bundled resources
// via the path resolver fallback in data-store.js.
const fs = require('fs');
const path = require('path');

function resolveSeedJsonPath() {
  // Packaged: process.resourcesPath/resources/joes-boat.json
  const packaged = path.join(process.resourcesPath || '', 'resources', 'joes-boat.json');
  if (fs.existsSync(packaged)) return packaged;
  // Dev: <repo>/desktop/resources/joes-boat.json
  return path.join(__dirname, '..', '..', 'resources', 'joes-boat.json');
}

function seedJoesBoat(store) {
  const seedPath = resolveSeedJsonPath();
  if (!fs.existsSync(seedPath)) {
    throw new Error(`Seed data not found at ${seedPath}`);
  }
  const seed = JSON.parse(fs.readFileSync(seedPath, 'utf8'));

  // Insert memory
  const memResult = store.db.prepare(
    'INSERT INTO memories (name, description, created_at, updated_at) VALUES (?, ?, ?, ?)'
  ).run(seed.memory.name, seed.memory.description || '', seed.memory.createdAt, seed.memory.createdAt);
  const memoryId = memResult.lastInsertRowid;

  const oldToNewSphere = {};
  const soundMap = {};

  // Spheres (already in correct order in the JSON)
  for (const s of seed.spheres) {
    const sResult = store.db.prepare(
      'INSERT INTO spheres (memory_id, caption, panorama_path, thumb_path, default_zoom, guid, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)'
    ).run(memoryId, s.caption, s.panoramaFile, s.thumbFile, s.defaultZoom, String(s.oldId), s.createdAt);
    oldToNewSphere[s.oldId] = sResult.lastInsertRowid;
  }

  // Markers
  for (const s of seed.spheres) {
    const newSphereId = oldToNewSphere[s.oldId];
    for (const m of s.markers) {
      store.db.prepare(
        'INSERT INTO markers (sphere_id, x, y, width, height, tooltip_content, tooltip_position, content, guid, embedded_photo_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
      ).run(
        newSphereId, m.x, m.y, m.width, m.height,
        m.tooltip ? m.tooltip.content : null,
        m.tooltip ? m.tooltip.position : 'right bottom',
        m.content || '', String(m.oldId), m.embeddedPhotoFile
      );
    }
  }

  // Portals
  for (const s of seed.spheres) {
    const fromId = oldToNewSphere[s.oldId];
    for (const p of s.portals) {
      const toId = oldToNewSphere[p.toSphereOldId];
      if (!toId) continue;
      store.db.prepare(
        'INSERT INTO portals (from_sphere_id, to_sphere_id, polygon_px, fill, stroke, stroke_transparency, stroke_width, tooltip_content, tooltip_position, fov_lat, fov_lng) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
      ).run(
        fromId, toId, JSON.stringify(p.polygonPx),
        p.fill, p.stroke, p.strokeTransparency, p.strokeWidth,
        p.tooltip ? p.tooltip.content : null,
        p.tooltip ? p.tooltip.position : 'right bottom',
        p.fovLat, p.fovLng
      );
    }
  }

  // Default memory sound
  if (seed.defaultSound) {
    const snd = seed.defaultSound;
    const sndResult = store.db.prepare(
      'INSERT INTO sounds (name, file_path, volume, loops) VALUES (?, ?, ?, ?)'
    ).run(snd.name, snd.file, snd.volume, snd.loops);
    soundMap[snd.oldId] = sndResult.lastInsertRowid;
    store.db.prepare(
      'INSERT INTO sound_contexts (context_type, context_id, sound_id) VALUES (?, ?, ?)'
    ).run('Memory', memoryId, sndResult.lastInsertRowid);
  }

  // Sphere-level sounds
  for (const s of seed.spheres) {
    if (!s.sound) continue;
    let newSoundId = soundMap[s.sound.oldId];
    if (!newSoundId) {
      const sndResult = store.db.prepare(
        'INSERT INTO sounds (name, file_path, volume, loops) VALUES (?, ?, ?, ?)'
      ).run(s.sound.name, s.sound.file, s.sound.volume, s.sound.loops);
      newSoundId = sndResult.lastInsertRowid;
      soundMap[s.sound.oldId] = newSoundId;
    }
    store.db.prepare(
      'INSERT INTO sound_contexts (context_type, context_id, sound_id) VALUES (?, ?, ?)'
    ).run('Sphere', oldToNewSphere[s.oldId], newSoundId);
  }

  console.log(`Seeded Joe's Boat: memory ${memoryId}, ${seed.spheres.length} spheres`);
  return memoryId;
}

module.exports = { seedJoesBoat };
