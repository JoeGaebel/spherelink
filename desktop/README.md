# Spherelink (desktop)

Standalone Electron app for viewing and editing 360° panoramic memory tours. Runs entirely offline with an embedded SQLite database — no server, account, or dependencies beyond the installer.

The app ships with **Joe's Boat** pre-loaded as the default memory on first launch.

## Develop

```sh
npm install
npm start
```

Requires Node 18+ and a working build toolchain for native modules (`better-sqlite3`, `sharp`).

## Build a distributable

```sh
npm run build:mac       # macOS arm64 (current default in electron-builder.yml)
npm run build:win       # Windows (untested)
npm run build:linux     # Linux (untested)
```

The output lands in `dist/`.

## Layout

```
desktop/
├── src/
│   ├── main/                  # Electron main process
│   │   ├── index.js           # entry point, menu, window lifecycle
│   │   ├── data-store.js      # SQLite schema + reads/writes
│   │   ├── ipc-handlers.js    # renderer ↔ main IPC
│   │   ├── seed-joes-boat.js  # first-launch seed (hardcoded)
│   │   └── import-backup.js   # RESERVED: future import-UI phase
│   ├── preload/               # contextBridge shim
│   └── renderer/              # HTML + JS (viewer + editor)
├── resources/                 # bundled into the .app
│   ├── joes-boat.json         # Joe's Boat memory + spheres + markers + portals + sounds
│   └── joes-boat-uploads/     # panoramas, marker photos, sounds
├── build/                     # icons etc. used by electron-builder
├── package.json
└── electron-builder.yml
```

## How Joe's Boat seeding works

On first launch, `index.js` checks whether the SQLite DB is empty. If so, it calls `seedJoesBoat(store)`, which inserts rows pointing at bundled asset paths like `sphere/panorama/3/marina.jpg`.

Assets are **not** copied into the user data dir. The path resolver in `data-store.js` (`_resolveAsset`) checks the user data dir first and falls back to the bundled `resources/joes-boat-uploads/` when the file isn't there. This means:

- Viewing Joe's Boat reads directly from the `.app` bundle.
- Editing a sphere or marker in Joe's Boat writes the new asset to the user data dir; the bundle remains untouched.
- Deleting Joe's Boat removes the DB rows; the bundle is left alone (and does not reappear unless the app is reinstalled or the user clears the data dir).

User data lives under `~/Spherelink/data/`.

## Import from backup (future)

`src/main/import-backup.js` is retained as the starting point for a future "Import from SQL backup" UI. It is not currently wired to any menu item or IPC handler.
