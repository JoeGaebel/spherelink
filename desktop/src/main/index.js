const { app, BrowserWindow, ipcMain, Menu, shell, dialog } = require('electron');
const path = require('path');
const fs = require('fs');
const DataStore = require('./data-store');
const { registerHandlers } = require('./ipc-handlers');
const { seedJoesBoat } = require('./seed-joes-boat');
const importEngine = require('./import-engine');

let mainWindow;
let store;

// When packaged, keep user data INSIDE the .app bundle so the application is
// fully portable — zip/copy the .app and all memories travel with it.
// In dev, fall back to ~/Spherelink/data/ since process.resourcesPath points
// at Electron's own Resources dir (which we do not want to pollute).
const dataDir = app.isPackaged
  ? path.join(process.resourcesPath, 'userdata')
  : path.join(app.getPath('home'), 'Spherelink', 'data');

function resolveBundleUploadsDir() {
  const packaged = path.join(process.resourcesPath || '', 'resources', 'joes-boat-uploads');
  if (fs.existsSync(packaged)) return packaged;
  const dev = path.join(__dirname, '..', '..', 'resources', 'joes-boat-uploads');
  if (fs.existsSync(dev)) return dev;
  return null;
}

function navigateTo(page, params) {
  if (!mainWindow || mainWindow.isDestroyed()) return;
  mainWindow.loadFile(path.join(__dirname, '..', 'renderer', page), { query: params || {} });
}

function updateTitle(subtitle) {
  if (!mainWindow || mainWindow.isDestroyed()) return;
  mainWindow.setTitle(subtitle ? `${subtitle} — Spherelink` : 'Spherelink');
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    minWidth: 900,
    minHeight: 600,
    title: 'Spherelink',
    webPreferences: {
      preload: path.join(__dirname, '..', 'preload', 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
    },
  });

  mainWindow.loadFile(path.join(__dirname, '..', 'renderer', 'index.html'));

  mainWindow.webContents.on('console-message', (event, level, message, line, sourceId) => {
    const prefix = ['LOG', 'WARN', 'ERROR'][level] || 'LOG';
    console.log(`[RENDERER ${prefix}] ${message}`);
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

function buildMenu() {
  const isMac = process.platform === 'darwin';

  const template = [
    ...(isMac ? [{
      label: app.name,
      submenu: [
        { role: 'about' },
        { type: 'separator' },
        { role: 'hide' },
        { role: 'hideOthers' },
        { role: 'unhide' },
        { type: 'separator' },
        { role: 'quit' },
      ],
    }] : []),
    {
      label: 'File',
      submenu: [
        {
          label: 'New Memory',
          accelerator: 'CmdOrCtrl+N',
          click: async () => {
            const memory = store.createMemory('Untitled Memory');
            navigateTo('editor.html', { id: memory.id });
          },
        },
        {
          label: 'Import from Backup…',
          click: () => { navigateTo('import.html'); },
        },
        { type: 'separator' },
        {
          label: 'Show Data Folder',
          accelerator: 'CmdOrCtrl+Shift+D',
          click: () => { shell.openPath(dataDir); },
        },
        { type: 'separator' },
        {
          label: 'Back to Memory List',
          accelerator: 'CmdOrCtrl+L',
          click: () => { navigateTo('index.html'); },
        },
        { type: 'separator' },
        isMac ? { role: 'close' } : { role: 'quit' },
      ],
    },
    {
      label: 'Edit',
      submenu: [
        { role: 'undo' },
        { role: 'redo' },
        { type: 'separator' },
        { role: 'cut' },
        { role: 'copy' },
        { role: 'paste' },
        { role: 'selectAll' },
      ],
    },
    {
      label: 'View',
      submenu: [
        { role: 'togglefullscreen' },
        { type: 'separator' },
        { role: 'reload' },
        { role: 'toggleDevTools' },
        { type: 'separator' },
        { role: 'resetZoom' },
        { role: 'zoomIn' },
        { role: 'zoomOut' },
      ],
    },
    {
      label: 'Window',
      submenu: [
        { role: 'minimize' },
        { role: 'zoom' },
        ...(isMac ? [
          { type: 'separator' },
          { role: 'front' },
        ] : [
          { role: 'close' },
        ]),
      ],
    },
  ];

  Menu.setApplicationMenu(Menu.buildFromTemplate(template));
}

app.whenReady().then(() => {
  // Explicitly set the dock icon at runtime. macOS's Info.plist
  // CFBundleIconFile is normally sufficient, but unsigned Electron apps
  // sometimes get a generic icon in the Dock / Cmd+Tab switcher until the
  // Dock is restarted. Setting it here forces the packaged photosphere icon.
  if (process.platform === 'darwin' && app.dock) {
    const iconPath = app.isPackaged
      ? path.join(process.resourcesPath, 'icon.icns')
      : path.join(__dirname, '..', '..', 'build', 'icon.png');
    if (fs.existsSync(iconPath)) {
      try { app.dock.setIcon(iconPath); } catch (_e) { /* non-fatal */ }
    }
  }

  const bundleUploadsDir = resolveBundleUploadsDir();
  store = new DataStore(dataDir, bundleUploadsDir);
  registerHandlers(store);

  // Seed Joe's Boat on first launch if database is empty.
  const memCount = store.db.prepare('SELECT COUNT(*) as count FROM memories').get().count;
  if (memCount === 0) {
    try {
      seedJoesBoat(store);
    } catch (e) {
      console.error("Failed to seed Joe's Boat:", e.message);
    }
  }

  // Navigation handler
  ipcMain.handle('app:navigate', (event, page, params) => {
    navigateTo(page, params);
  });

  // Window title handler
  ipcMain.handle('app:setTitle', (event, subtitle) => {
    updateTitle(subtitle);
  });

  // ── Import from backup ──

  ipcMain.handle('import:pickSql', async () => {
    const result = await dialog.showOpenDialog(mainWindow, {
      title: 'Select SQL dump (unpacked)',
      properties: ['openFile'],
      filters: [{ name: 'SQL', extensions: ['sql'] }, { name: 'All Files', extensions: ['*'] }],
    });
    if (result.canceled || result.filePaths.length === 0) return null;
    return result.filePaths[0];
  });

  ipcMain.handle('import:pickUploads', async () => {
    const result = await dialog.showOpenDialog(mainWindow, {
      title: 'Select uploads directory',
      properties: ['openDirectory'],
    });
    if (result.canceled || result.filePaths.length === 0) return null;
    return result.filePaths[0];
  });

  ipcMain.handle('import:preview', (event, sqlPath) => {
    try {
      return { ok: true, preview: importEngine.preview(sqlPath) };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('import:run', async (event, args) => {
    const { sqlPath, uploadsDir, assetsDir } = args;
    try {
      const summary = importEngine.importAll(store, {
        sqlPath,
        uploadsDir,
        assetsDir,
        onProgress: (p) => {
          if (mainWindow && !mainWindow.isDestroyed()) {
            mainWindow.webContents.send('import:progress', p);
          }
        },
      });
      return { ok: true, summary };
    } catch (err) {
      console.error('Import failed:', err);
      return { ok: false, error: err.message };
    }
  });

  buildMenu();
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  app.quit();
});

app.on('before-quit', () => {
  if (store) store.close();
});
