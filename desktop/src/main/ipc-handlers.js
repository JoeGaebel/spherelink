const { ipcMain, dialog } = require('electron');
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');

let sharp;
try {
  sharp = require('sharp');
} catch (e) {
  console.warn('sharp not available, image processing disabled');
}

function registerHandlers(store) {
  // ── Memories ──

  ipcMain.handle('memory:list', () => {
    const memories = store.listMemories();
    return memories.map(m => {
      const sphereCount = store.db.prepare('SELECT COUNT(*) as count FROM spheres WHERE memory_id = ?').get(m.id).count;
      return { ...m, sphereCount };
    });
  });

  ipcMain.handle('memory:get', (event, id) => {
    const memory = store.getMemory(id);
    return store.formatMemoryForFrontend(memory);
  });

  ipcMain.handle('memory:create', (event, name) => {
    const memory = store.createMemory(name);
    return store.formatMemoryForFrontend(memory);
  });

  ipcMain.handle('memory:update', (event, id, fields) => {
    return store.updateMemory(id, fields);
  });

  ipcMain.handle('memory:delete', (event, id) => {
    store.deleteMemory(id);
  });

  // ── Spheres ──

  ipcMain.handle('sphere:create', async (event, memoryId, caption, sourcePath) => {
    const guid = crypto.randomUUID();
    const sphereDir = path.join(store.panoramasDir, guid);
    fs.mkdirSync(sphereDir, { recursive: true });

    const ext = path.extname(sourcePath).toLowerCase();
    const panoramaPath = path.join(sphereDir, `panorama${ext}`);
    const thumbPath = path.join(sphereDir, 'thumb.jpg');

    if (sharp) {
      // Resize panorama to max 5000px width, optimize
      await sharp(sourcePath)
        .resize({ width: 5000, withoutEnlargement: true })
        .jpeg({ quality: 80 })
        .toFile(panoramaPath);

      // Generate 80x80 thumbnail
      await sharp(sourcePath)
        .resize(80, 80, { fit: 'cover' })
        .jpeg({ quality: 80 })
        .toFile(thumbPath);
    } else {
      // Fallback: just copy the file
      fs.copyFileSync(sourcePath, panoramaPath);
      fs.copyFileSync(sourcePath, thumbPath);
    }

    // Store paths relative to data dir for portability
    const relPanorama = path.relative(store.dataDir, panoramaPath);
    const relThumb = path.relative(store.dataDir, thumbPath);

    const sphere = store.createSphere(memoryId, caption, relPanorama, relThumb, guid);
    sphere.portals = [];
    sphere.markers = [];
    sphere.sound = null;
    return store.formatSphereForFrontend(sphere);
  });

  ipcMain.handle('sphere:get', (event, id) => {
    return store.getSphere(id);
  });

  ipcMain.handle('sphere:delete', (event, id) => {
    const sphere = store.deleteSphere(id);
    return sphere ? store.formatSphereForFrontend({ ...sphere, portals: [], markers: [], sound: null }) : null;
  });

  ipcMain.handle('sphere:zoom', (event, sphereId, zoom) => {
    store.updateZoom(sphereId, zoom);
  });

  // ── Markers ──

  ipcMain.handle('marker:create', async (event, data) => {
    let embeddedPhotoPath = null;

    if (data.photoSourcePath) {
      const guid = crypto.randomUUID();
      const photoDir = path.join(store.photosDir, guid);
      fs.mkdirSync(photoDir, { recursive: true });
      const destPath = path.join(photoDir, 'photo.jpg');

      if (sharp) {
        await sharp(data.photoSourcePath)
          .resize({ width: 1400, withoutEnlargement: true })
          .jpeg({ quality: 75 })
          .toFile(destPath);
      } else {
        fs.copyFileSync(data.photoSourcePath, destPath);
      }
      embeddedPhotoPath = path.relative(store.dataDir, destPath);
    }

    const marker = store.createMarker({
      sphereId: data.sphereId,
      x: data.x,
      y: data.y,
      width: data.width,
      height: data.height,
      tooltipContent: data.tooltipContent,
      tooltipPosition: data.tooltipPosition,
      content: data.content,
      guid: data.guid,
      embeddedPhotoPath,
    });
    return store.formatMarkerForFrontend(marker);
  });

  ipcMain.handle('marker:delete', (event, id) => {
    const marker = store.deleteMarker(id);
    return marker ? store.formatMarkerForFrontend(marker) : null;
  });

  // ── Portals ──

  ipcMain.handle('portal:create', (event, data) => {
    const portal = store.createPortal(data);
    return store.formatPortalForFrontend(portal);
  });

  ipcMain.handle('portal:delete', (event, id) => {
    store.deletePortal(id);
  });

  // ── Dialogs ──

  ipcMain.handle('dialog:openFile', async (event, options) => {
    const result = await dialog.showOpenDialog(options);
    if (result.canceled || result.filePaths.length === 0) return null;
    return result.filePaths[0];
  });

  ipcMain.handle('dialog:openDirectory', async (event, options) => {
    const result = await dialog.showOpenDialog({ ...options, properties: ['openDirectory'] });
    if (result.canceled || result.filePaths.length === 0) return null;
    return result.filePaths[0];
  });

  // ── Data path ──

  ipcMain.handle('app:getDataPath', () => store.dataDir);
}

module.exports = { registerHandlers };
