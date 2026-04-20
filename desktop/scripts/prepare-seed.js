// Build-time seed preparation.
//
// Runs under Electron (so native modules like better-sqlite3 and sharp load
// against the same ABI the packaged app will use) and imports a Rails SQL
// backup + uploads directory into a staging folder (desktop/build-userdata/).
// electron-builder's extraResources mapping then bundles that folder as
// `userdata/` inside the packaged .app, making the built app pre-loaded with
// all memories.
//
// Usage:
//   npx electron scripts/prepare-seed.js --sql=<path> --uploads=<path>
//
// Output:
//   desktop/build-userdata/
//     spherelink.db            (SQLite DB, WAL checkpointed)
//     sphere/panorama/.../*    (panoramas + thumbs)
//     marker/embedded_photo/.../*
//     sound/file/.../*

const { app } = require('electron');
const fs = require('fs');
const path = require('path');

function parseArgs(argv) {
  const out = {};
  for (const arg of argv) {
    const m = arg.match(/^--([^=]+)=(.*)$/);
    if (m) out[m[1]] = m[2];
  }
  return out;
}

function rimraf(dir) {
  if (!fs.existsSync(dir)) return;
  fs.rmSync(dir, { recursive: true, force: true });
}

app.whenReady().then(() => {
  try {
    const args = parseArgs(process.argv.slice(2));
    const sqlPath = args.sql;
    const uploadsDir = args.uploads;

    // assetsDir holds Rails asset-pipeline images referenced by marker HTML
    // (e.g. /assets/foo-HASH.jpg). If not provided, auto-detect the sibling
    // webapp/app/assets/images directory.
    let assetsDir = args.assets;
    if (!assetsDir) {
      const guess = path.resolve(__dirname, '..', '..', 'webapp', 'app', 'assets', 'images');
      if (fs.existsSync(guess)) assetsDir = guess;
    }

    if (!sqlPath || !uploadsDir) {
      console.error('Usage: npx electron scripts/prepare-seed.js --sql=<path> --uploads=<path> [--assets=<path>]');
      app.exit(2);
      return;
    }
    if (!fs.existsSync(sqlPath)) {
      console.error(`SQL file not found: ${sqlPath}`);
      app.exit(2);
      return;
    }
    if (!fs.existsSync(uploadsDir)) {
      console.error(`Uploads directory not found: ${uploadsDir}`);
      app.exit(2);
      return;
    }

    const buildUserdataDir = path.resolve(__dirname, '..', 'build-userdata');
    console.log(`Preparing seed at ${buildUserdataDir}`);
    console.log(`  SQL:     ${sqlPath}`);
    console.log(`  Uploads: ${uploadsDir}`);
    if (assetsDir) console.log(`  Assets:  ${assetsDir}`);

    // Start from a clean slate so builds are deterministic.
    rimraf(buildUserdataDir);
    fs.mkdirSync(buildUserdataDir, { recursive: true });

    const DataStore = require('../src/main/data-store');
    const importEngine = require('../src/main/import-engine');

    const store = new DataStore(buildUserdataDir, null);

    const t0 = Date.now();
    const summary = importEngine.importAll(store, {
      sqlPath,
      uploadsDir,
      assetsDir,
      onProgress: (p) => {
        if (p.phase === 'importing') {
          process.stdout.write(`  [${p.current}/${p.total}] ${p.message}\n`);
        }
      },
    });
    const elapsed = Date.now() - t0;

    // Checkpoint the WAL so the -wal / -shm files become empty and the .db
    // file on disk is self-contained for bundling.
    try {
      store.db.pragma('wal_checkpoint(TRUNCATE)');
    } catch (e) {
      console.warn('WAL checkpoint failed (non-fatal):', e.message);
    }
    store.close();

    // Remove any empty WAL/SHM sidecars left behind so the bundle is tidy.
    for (const sidecar of ['spherelink.db-wal', 'spherelink.db-shm']) {
      const p = path.join(buildUserdataDir, sidecar);
      try {
        const stat = fs.statSync(p);
        if (stat.size === 0) fs.unlinkSync(p);
      } catch (_e) { /* not present, ignore */ }
    }

    console.log('');
    console.log(`Seed prepared in ${elapsed}ms:`);
    console.log(`  memories:  ${summary.memoriesImported}`);
    console.log(`  spheres:   ${summary.spheresImported}`);
    console.log(`  portals:   ${summary.portalsImported}`);
    console.log(`  markers:   ${summary.markersImported}`);
    console.log(`  sounds:    ${summary.soundsImported}`);
    if (summary.missingAssets.length) {
      console.log(`  missing assets: ${summary.missingAssets.length}`);
      for (const a of summary.missingAssets.slice(0, 5)) console.log(`    - ${a}`);
      if (summary.missingAssets.length > 5) console.log(`    …and ${summary.missingAssets.length - 5} more`);
    }
    if (summary.errors.length) {
      console.log(`  errors: ${summary.errors.length}`);
      for (const e of summary.errors) console.log(`    - ${e.memory}: ${e.message}`);
      app.exit(1);
      return;
    }
    console.log('');
    console.log('Next step: npm run build:mac');
    app.exit(0);
  } catch (err) {
    console.error('Prepare-seed failed:', err);
    app.exit(1);
  }
});
