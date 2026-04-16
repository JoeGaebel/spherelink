const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('spherelinkAPI', {
  // Memories
  listMemories: () => ipcRenderer.invoke('memory:list'),
  getMemory: (id) => ipcRenderer.invoke('memory:get', id),
  createMemory: (name) => ipcRenderer.invoke('memory:create', name),
  updateMemory: (id, fields) => ipcRenderer.invoke('memory:update', id, fields),
  deleteMemory: (id) => ipcRenderer.invoke('memory:delete', id),

  // Spheres
  createSphere: (memoryId, caption, filePath) => ipcRenderer.invoke('sphere:create', memoryId, caption, filePath),
  getSphere: (id) => ipcRenderer.invoke('sphere:get', id),
  deleteSphere: (id) => ipcRenderer.invoke('sphere:delete', id),
  updateZoom: (sphereId, zoom) => ipcRenderer.invoke('sphere:zoom', sphereId, zoom),

  // Markers
  createMarker: (data) => ipcRenderer.invoke('marker:create', data),
  deleteMarker: (id) => ipcRenderer.invoke('marker:delete', id),

  // Portals
  createPortal: (data) => ipcRenderer.invoke('portal:create', data),
  deletePortal: (id) => ipcRenderer.invoke('portal:delete', id),

  // Dialogs
  showOpenDialog: (options) => ipcRenderer.invoke('dialog:openFile', options),
  showOpenDirectory: (options) => ipcRenderer.invoke('dialog:openDirectory', options),

  // App
  getDataPath: () => ipcRenderer.invoke('app:getDataPath'),

  // Navigation
  navigate: (page, params) => ipcRenderer.invoke('app:navigate', page, params),

  // Window
  setTitle: (subtitle) => ipcRenderer.invoke('app:setTitle', subtitle),
});
