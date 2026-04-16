const Database = require('better-sqlite3');
const path = require('path');
const fs = require('fs');

class DataStore {
  constructor(dataDir, bundleUploadsDir) {
    this.dataDir = dataDir;
    // Read-only fallback dir for bundled assets (e.g. Joe's Boat seed).
    // DB paths that don't resolve under dataDir will be looked up here.
    this.bundleUploadsDir = bundleUploadsDir || null;
    this.panoramasDir = path.join(dataDir, 'panoramas');
    this.photosDir = path.join(dataDir, 'photos');
    this.soundsDir = path.join(dataDir, 'sounds');

    // Ensure directories exist
    for (const dir of [dataDir, this.panoramasDir, this.photosDir, this.soundsDir]) {
      if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    }

    this.db = new Database(path.join(dataDir, 'spherelink.db'));
    this.db.pragma('journal_mode = WAL');
    this.db.pragma('foreign_keys = ON');
    this.initSchema();
  }

  initSchema() {
    this.db.exec(`
      CREATE TABLE IF NOT EXISTS memories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL DEFAULT 'Untitled Memory',
        description TEXT DEFAULT '',
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        updated_at TEXT NOT NULL DEFAULT (datetime('now'))
      );

      CREATE TABLE IF NOT EXISTS spheres (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        memory_id INTEGER NOT NULL,
        caption TEXT NOT NULL DEFAULT 'Untitled Sphere',
        panorama_path TEXT,
        thumb_path TEXT,
        default_zoom INTEGER NOT NULL DEFAULT 50,
        guid TEXT,
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        FOREIGN KEY (memory_id) REFERENCES memories(id) ON DELETE CASCADE
      );

      CREATE TABLE IF NOT EXISTS markers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sphere_id INTEGER NOT NULL,
        tooltip_content TEXT,
        tooltip_position TEXT,
        content TEXT,
        x REAL,
        y REAL,
        width REAL DEFAULT 32,
        height REAL DEFAULT 32,
        guid TEXT,
        embedded_photo_path TEXT,
        FOREIGN KEY (sphere_id) REFERENCES spheres(id) ON DELETE CASCADE
      );

      CREATE TABLE IF NOT EXISTS portals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        from_sphere_id INTEGER NOT NULL,
        to_sphere_id INTEGER,
        polygon_px TEXT,
        fill TEXT DEFAULT 'points',
        stroke TEXT DEFAULT '#ff0032',
        stroke_transparency INTEGER DEFAULT 80,
        stroke_width INTEGER DEFAULT 2,
        tooltip_content TEXT,
        tooltip_position TEXT DEFAULT 'right bottom',
        fov_lat REAL DEFAULT 0,
        fov_lng REAL DEFAULT 0,
        FOREIGN KEY (from_sphere_id) REFERENCES spheres(id) ON DELETE CASCADE,
        FOREIGN KEY (to_sphere_id) REFERENCES spheres(id) ON DELETE SET NULL
      );

      CREATE TABLE IF NOT EXISTS sounds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        file_path TEXT,
        volume INTEGER DEFAULT 50,
        loops INTEGER DEFAULT 999
      );

      CREATE TABLE IF NOT EXISTS sound_contexts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        context_type TEXT NOT NULL,
        context_id INTEGER NOT NULL,
        sound_id INTEGER NOT NULL,
        FOREIGN KEY (sound_id) REFERENCES sounds(id) ON DELETE CASCADE
      );
    `);
  }

  // ── Memories ──

  listMemories() {
    return this.db.prepare('SELECT * FROM memories ORDER BY created_at DESC').all();
  }

  getMemory(id) {
    const memory = this.db.prepare('SELECT * FROM memories WHERE id = ?').get(id);
    if (!memory) return null;

    const spheres = this.db.prepare('SELECT * FROM spheres WHERE memory_id = ? ORDER BY created_at ASC').all(id);
    for (const sphere of spheres) {
      sphere.portals = this.db.prepare('SELECT * FROM portals WHERE from_sphere_id = ?').all(sphere.id);
      sphere.markers = this.db.prepare('SELECT * FROM markers WHERE sphere_id = ?').all(sphere.id);
      const sc = this.db.prepare("SELECT s.* FROM sounds s JOIN sound_contexts sc ON s.id = sc.sound_id WHERE sc.context_type = 'Sphere' AND sc.context_id = ?").get(sphere.id);
      sphere.sound = sc || null;
    }

    const defaultSound = this.db.prepare("SELECT s.* FROM sounds s JOIN sound_contexts sc ON s.id = sc.sound_id WHERE sc.context_type = 'Memory' AND sc.context_id = ?").get(id);
    memory.defaultSound = defaultSound || null;
    memory.spheres = spheres;
    return memory;
  }

  createMemory(name) {
    const result = this.db.prepare('INSERT INTO memories (name) VALUES (?)').run(name || 'Untitled Memory');
    return this.getMemory(result.lastInsertRowid);
  }

  updateMemory(id, fields) {
    const sets = [];
    const vals = [];
    if (fields.name !== undefined) { sets.push('name = ?'); vals.push(fields.name); }
    if (fields.description !== undefined) { sets.push('description = ?'); vals.push(fields.description); }
    if (sets.length === 0) return;
    sets.push("updated_at = datetime('now')");
    vals.push(id);
    this.db.prepare(`UPDATE memories SET ${sets.join(', ')} WHERE id = ?`).run(...vals);
    const mem = this.db.prepare('SELECT * FROM memories WHERE id = ?').get(id);
    return { name: mem.name, description: mem.description };
  }

  deleteMemory(id) {
    // Clean up files for all spheres in this memory
    const spheres = this.db.prepare('SELECT * FROM spheres WHERE memory_id = ?').all(id);
    for (const sphere of spheres) {
      this._cleanupSphereFiles(sphere);
    }
    this.db.prepare('DELETE FROM memories WHERE id = ?').run(id);
  }

  // ── Spheres ──

  createSphere(memoryId, caption, panoramaPath, thumbPath, guid) {
    const result = this.db.prepare(
      'INSERT INTO spheres (memory_id, caption, panorama_path, thumb_path, guid) VALUES (?, ?, ?, ?, ?)'
    ).run(memoryId, caption, panoramaPath, thumbPath, guid);
    return this.db.prepare('SELECT * FROM spheres WHERE id = ?').get(result.lastInsertRowid);
  }

  getSphere(id) {
    return this.db.prepare('SELECT * FROM spheres WHERE id = ?').get(id);
  }

  deleteSphere(id) {
    const sphere = this.db.prepare('SELECT * FROM spheres WHERE id = ?').get(id);
    if (sphere) this._cleanupSphereFiles(sphere);
    // Also clean up marker photos
    const markers = this.db.prepare('SELECT * FROM markers WHERE sphere_id = ?').all(id);
    for (const m of markers) {
      if (m.embedded_photo_path) this._tryUnlink(path.join(this.dataDir, m.embedded_photo_path));
    }
    this.db.prepare('DELETE FROM spheres WHERE id = ?').run(id);
    return sphere;
  }

  updateZoom(sphereId, zoom) {
    this.db.prepare('UPDATE spheres SET default_zoom = ? WHERE id = ?').run(zoom, sphereId);
  }

  // ── Markers ──

  createMarker(data) {
    const guid = data.guid || require('crypto').randomUUID();
    const result = this.db.prepare(
      'INSERT INTO markers (sphere_id, x, y, width, height, tooltip_content, tooltip_position, content, guid, embedded_photo_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    ).run(data.sphereId, data.x, data.y, data.width || 32, data.height || 32, data.tooltipContent || null, data.tooltipPosition || 'right bottom', data.content || '', guid, data.embeddedPhotoPath || null);
    return this.db.prepare('SELECT * FROM markers WHERE id = ?').get(result.lastInsertRowid);
  }

  deleteMarker(id) {
    const marker = this.db.prepare('SELECT * FROM markers WHERE id = ?').get(id);
    if (marker && marker.embedded_photo_path) {
      this._tryUnlink(path.join(this.dataDir, marker.embedded_photo_path));
    }
    this.db.prepare('DELETE FROM markers WHERE id = ?').run(id);
    return marker;
  }

  // ── Portals ──

  createPortal(data) {
    const result = this.db.prepare(
      'INSERT INTO portals (from_sphere_id, to_sphere_id, polygon_px, fill, stroke, stroke_transparency, stroke_width, tooltip_content, tooltip_position, fov_lat, fov_lng) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    ).run(
      data.fromSphereId, data.toSphereId,
      JSON.stringify(data.polygonPx),
      data.fill || 'points', data.stroke || '#ff0032',
      data.strokeTransparency ?? 80, data.strokeWidth ?? 2,
      data.tooltipContent || null, data.tooltipPosition || 'right bottom',
      data.fovLat ?? 0, data.fovLng ?? 0
    );
    return this.db.prepare('SELECT * FROM portals WHERE id = ?').get(result.lastInsertRowid);
  }

  deletePortal(id) {
    this.db.prepare('DELETE FROM portals WHERE id = ?').run(id);
  }

  // ── Sounds ──

  createSound(name, filePath, volume, loops) {
    const result = this.db.prepare('INSERT INTO sounds (name, file_path, volume, loops) VALUES (?, ?, ?, ?)').run(name, filePath, volume || 50, loops || 999);
    return this.db.prepare('SELECT * FROM sounds WHERE id = ?').get(result.lastInsertRowid);
  }

  linkSound(contextType, contextId, soundId) {
    this.db.prepare('INSERT INTO sound_contexts (context_type, context_id, sound_id) VALUES (?, ?, ?)').run(contextType, contextId, soundId);
  }

  // ── Helpers ──

  _cleanupSphereFiles(sphere) {
    if (sphere.panorama_path) this._tryUnlink(path.join(this.dataDir, sphere.panorama_path));
    if (sphere.thumb_path) this._tryUnlink(path.join(this.dataDir, sphere.thumb_path));
  }

  _tryUnlink(filePath) {
    try { fs.unlinkSync(filePath); } catch (e) { /* ignore */ }
  }

  // ── Format for Frontend ──
  // Converts DB records into the JSON shape the PSV frontend expects

  formatMemoryForFrontend(memory) {
    if (!memory) return null;
    return {
      id: memory.id,
      name: memory.name,
      description: memory.description,
      private: false,
      spheres: memory.spheres.map(s => this.formatSphereForFrontend(s)),
      defaultSound: memory.defaultSound ? this.formatSoundForFrontend(memory.defaultSound) : null,
    };
  }

  formatSphereForFrontend(sphere) {
    return {
      id: sphere.id,
      caption: sphere.caption,
      defaultZoom: sphere.default_zoom,
      panorama: this._toFileUrl(sphere.panorama_path),
      thumb: this._toFileUrl(sphere.thumb_path),
      createdAt: sphere.created_at,
      portals: sphere.portals.map(p => this.formatPortalForFrontend(p)),
      markers: sphere.markers.map(m => this.formatMarkerForFrontend(m)),
      sound: sphere.sound ? this.formatSoundForFrontend(sphere.sound) : null,
    };
  }

  formatMarkerForFrontend(marker) {
    const result = {
      id: `marker-${marker.id}`,
      x: marker.x,
      y: marker.y,
      width: marker.width || 32,
      height: marker.height || 32,
      image: './images/pin2.png',
    };
    if (marker.tooltip_content) {
      result.tooltip = { content: marker.tooltip_content, position: marker.tooltip_position || 'right bottom' };
    }
    // Replace <!--IMGHERE--> with actual img tag
    let content = marker.content || '';
    if (content.includes('<!--IMGHERE-->') && marker.embedded_photo_path) {
      content = content.replace('<!--IMGHERE-->', `<img src="${this._toFileUrl(marker.embedded_photo_path)}">`);
    } else {
      content = content.replace('<!--IMGHERE-->', '');
    }
    if (content) result.content = content;
    return result;
  }

  formatPortalForFrontend(portal) {
    const polygonPx = typeof portal.polygon_px === 'string' ? JSON.parse(portal.polygon_px) : portal.polygon_px;
    const hex = portal.stroke || '#ff0032';
    const r = parseInt(hex.slice(1, 3), 16);
    const g = parseInt(hex.slice(3, 5), 16);
    const b = parseInt(hex.slice(5, 7), 16);
    const opacity = (portal.stroke_transparency ?? 80) / 100;

    const result = {
      id: `portal-${portal.id}`,
      polygon_px: polygonPx,
      to_sphere_id: portal.to_sphere_id,
      from_sphere_id: portal.from_sphere_id,
      fov_lat: portal.fov_lat || 0,
      fov_lng: portal.fov_lng || 0,
      svgStyle: {
        fill: `url(#${portal.fill || 'points'})`,
        stroke: `rgba(${r}, ${g}, ${b}, ${opacity})`,
        'stroke-width': `${portal.stroke_width || 2}px`,
      },
    };
    if (portal.tooltip_content) {
      result.tooltip = { content: portal.tooltip_content, position: portal.tooltip_position || 'right bottom' };
    }
    return result;
  }

  formatSoundForFrontend(sound) {
    return {
      id: `sound-${sound.id}`,
      name: sound.name,
      volume: sound.volume,
      loops: sound.loops,
      url: this._toFileUrl(sound.file_path),
    };
  }

  _toFileUrl(relativePath) {
    if (!relativePath) return '';
    return 'file://' + this._resolveAsset(relativePath);
  }

  // Resolves a DB-stored relative asset path.
  // Prefers userData (writable, user edits win) and falls back to bundle (seed assets).
  _resolveAsset(relativePath) {
    const userPath = path.join(this.dataDir, relativePath);
    if (fs.existsSync(userPath)) return userPath;
    if (this.bundleUploadsDir) {
      const bundlePath = path.join(this.bundleUploadsDir, relativePath);
      if (fs.existsSync(bundlePath)) return bundlePath;
    }
    return userPath; // default (may not exist yet)
  }

  close() {
    this.db.close();
  }
}

module.exports = DataStore;
