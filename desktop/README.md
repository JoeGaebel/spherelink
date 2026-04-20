# Spherelink (desktop)

Standalone Electron app for viewing and editing 360° panoramic memory tours. Runs entirely offline with an embedded SQLite database — no server, account, or cloud dependencies.

The app ships with **Joe's Boat** pre-loaded as the default memory on first launch. Additional memories can be imported at runtime (File → Import from Backup…) or baked directly into the built `.app` at build time.

## Develop

```sh
npm install
npm start
```

Requires Node 18+ and a working build toolchain for native modules (`better-sqlite3`, `sharp`).

In dev, user data lives at `~/Spherelink/data/` (outside the source tree).

## Build a distributable

### Plain build — empty app, Joe's Boat seeds on first launch

```sh
npm run build:mac     # macOS arm64 (current default in electron-builder.yml)
npm run build:win     # Windows (untested)
npm run build:linux   # Linux (untested)
```

The output lands in `dist/mac-arm64/Spherelink.app`.

### Build with memories pre-loaded (two-step)

Run the build-time importer against a Rails `pg_dump` + CarrierWave uploads directory, then build:

```sh
npm run prepare-seed -- \
  --sql=/path/to/backup-unpacked.sql \
  --uploads=/path/to/uploads \
  --assets=/path/to/rails/app/assets/images

npm run build:mac
```

- `--sql` — required. Path to the unpacked `pg_dump` SQL file (text format, not `.dump`).
- `--uploads` — required. CarrierWave uploads root; expected subdirs `sphere/panorama/{id}/`, `marker/embedded_photo/{id}/`, `sound/file/{id}/`.
- `--assets` — optional. Rails asset-pipeline images dir, used to resolve fingerprinted `<img src="/assets/foo-HASH.jpg">` references inside marker HTML. If omitted, the script auto-detects a sibling `webapp/app/assets/images/` directory. Any unresolved asset is stripped from the marker content and logged as a missing asset.

Exclusions: a hard-coded allowlist in `desktop/src/main/import-engine.js` (`EXCLUDED_MEMORY_NAMES`) drops specific test / scratch memories by exact name before import. Edit that set to change what gets packaged.

`prepare-seed` writes a fully populated `userdata/` into `desktop/build-userdata/` (gitignored). `electron-builder` then bundles that as `Spherelink.app/Contents/Resources/userdata/`, so the first launch finds memories already present and skips the Joe's Boat seed.

If you have a binary `.dump` instead of unpacked SQL, convert first:

```sh
pg_restore -f backup-unpacked.sql backup.dump
```

Full end-to-end example (run from `desktop/`):

```sh
# 1. Unpack the binary dump (if needed)
pg_restore -f ../2024-backup-unpacked.sql ../2024-backup.dump

# 2. Populate desktop/build-userdata/ with SQLite DB + panoramas + photos + sounds
npm run prepare-seed -- \
  --sql=../2024-backup-unpacked.sql \
  --uploads=../spherelink-backup-2026-04-13-15-49-32/uploads

# 3. Build the .app (will pick up build-userdata/ automatically)
npm run build:mac
```

The resulting `dist/mac-arm64/Spherelink.app` contains every imported memory and is fully portable (see Portability section).

## Portability

**When packaged, user data lives *inside* the `.app` bundle**, at `Spherelink.app/Contents/Resources/userdata/`. This means:

- Zip the `.app` → unzip elsewhere → all memories travel with it.
- No internet access required at any point after install.
- No user-account data. No telemetry. No cloud sync.

### Important caveats

- **Don't install to `/Applications`.** That directory is group-writable only by `admin`; the running app can't write back to itself there. Keep the `.app` in a user-writable location (Desktop, `~/Applications/`, external drive, etc.).
- **Quit cleanly before zipping/copying.** SQLite WAL mode creates `-wal` / `-shm` sidecar files; capturing them mid-write can lead to a torn state. `Cmd+Q` flushes and closes. The build-time `prepare-seed` script explicitly checkpoints WAL before exiting for this same reason.
- **Don't code-sign the `.app` without rethinking this.** Writing inside a signed bundle invalidates its signature. If you ever need signed distribution, user data should move back to `~/Library/Application Support/Spherelink/` and portability becomes an opt-in feature.
- **Unsigned warning on first launch.** Dismiss with:
  ```sh
  xattr -dr com.apple.quarantine /path/to/Spherelink.app
  ```

## Import from Backup (runtime UI)

File → Import from Backup… lets you point the running app at a `pg_dump` unpacked SQL file and an uploads directory. It parses the dump, copies assets, and inserts all memories into the local SQLite database inside the bundle.

- User-table data (users, microposts, delayed_jobs) is never read — no PII lands in the DB.
- Imports are non-idempotent: running twice creates duplicate memories. The UI flags name collisions before you commit.
- Rails asset-pipeline `<img src="/assets/…">` tags inside marker HTML are stripped during import (they can't resolve inside Electron). CarrierWave-uploaded marker photos are preserved.

## Layout

```
desktop/
├── src/
│   ├── main/                   # Electron main process
│   │   ├── index.js            # entry point, menu, window lifecycle
│   │   ├── data-store.js       # SQLite schema + reads/writes; path resolver
│   │   ├── ipc-handlers.js     # renderer ↔ main IPC
│   │   ├── seed-joes-boat.js   # first-launch seed (only if DB is empty)
│   │   ├── import-engine.js    # SQL dump + uploads → SQLite + assets
│   │   └── sql-dump-parser.js  # PG COPY-format parser + YAML polygon decoder
│   ├── preload/                # contextBridge shim
│   └── renderer/               # HTML + JS (memory list, viewer, editor, import wizard)
├── resources/                  # bundled read-only into the .app
│   ├── joes-boat.json          # seed memory + spheres + markers + portals + sounds
│   └── joes-boat-uploads/      # panoramas, marker photos, sounds
├── scripts/
│   └── prepare-seed.js         # build-time importer
├── build-userdata/             # (gitignored) produced by prepare-seed, bundled by builder
├── build/                      # icons etc. used by electron-builder
├── package.json
└── electron-builder.yml
```

## How Joe's Boat seeding works

On first launch, `index.js` checks whether the SQLite DB is empty. If so, it calls `seedJoesBoat(store)`, which inserts rows pointing at bundled asset paths like `sphere/panorama/3/marina.jpg`.

Assets are **not** copied into the user data dir. The path resolver in `data-store.js` (`_resolveAsset`) checks the user data dir first and falls back to the bundled `resources/joes-boat-uploads/` when the file isn't there. This means:

- Viewing Joe's Boat reads directly from the `.app` bundle.
- Editing a sphere or marker in Joe's Boat writes the new asset to the user data dir; the bundle remains untouched.
- Deleting Joe's Boat removes the DB rows; the bundled files are left alone (and do not reappear unless the app is reinstalled or `userdata/` is cleared).

If the `userdata/` directory is pre-populated at build time via `prepare-seed`, the DB isn't empty on first launch and Joe's Boat seeding is skipped.

## Data-folder hierarchy (packaged)

```
Spherelink.app/Contents/Resources/
├── resources/                   # read-only bundled defaults
│   ├── joes-boat.json
│   └── joes-boat-uploads/
└── userdata/                    # user-writable; pre-baked if built with prepare-seed
    ├── spherelink.db
    ├── sphere/panorama/…/       # imported panoramas + thumbs
    ├── marker/embedded_photo/…/ # imported marker photos
    └── sound/file/…/            # imported sounds
```

Menu item **File → Show Data Folder** opens whichever path is currently in use (inside the bundle when packaged, `~/Spherelink/data/` in dev).
