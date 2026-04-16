const { app, BrowserWindow, ipcMain, Menu, shell } = require('electron');
const path = require('path');
const fs = require('fs');
const DataStore = require('./data-store');
const { registerHandlers } = require('./ipc-handlers');
const { seedJoesBoat } = require('./seed-joes-boat');

let mainWindow;
let store;

const dataDir = path.join(app.getPath('home'), 'Spherelink', 'data');

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
