// electron-builder afterPack hook.
//
// Purpose: when prepare-seed has baked memories into userdata/, the bundled
// first-launch seed (joes-boat.json + joes-boat-uploads/) is dead weight
// because seedJoesBoat() only runs when the DB is empty. Detect that case
// from the packaged app layout and delete the redundant resources.
//
// If userdata/ is absent (plain build path), leaves everything in place so
// first-launch seeding still works.

const fs = require('fs');
const path = require('path');

exports.default = async function afterPack(context) {
  const appDir = path.join(context.appOutDir, `${context.packager.appInfo.productFilename}.app`);
  const resourcesDir = path.join(appDir, 'Contents', 'Resources');

  // 1. Drop redundant Joe's Boat seed if userdata is populated.
  const userdataDb = path.join(resourcesDir, 'userdata', 'spherelink.db');
  if (fs.existsSync(userdataDb)) {
    let trimmed = 0;
    for (const p of [
      path.join(resourcesDir, 'resources', 'joes-boat-uploads'),
      path.join(resourcesDir, 'resources', 'joes-boat.json'),
    ]) {
      if (fs.existsSync(p)) {
        fs.rmSync(p, { recursive: true, force: true });
        trimmed++;
      }
    }
    if (trimmed) console.log(`  • afterPack: removed ${trimmed} redundant seed resource(s)`);
  }

  // 2. Trim non-English locales from Electron Framework (Spherelink is en-only).
  const electronResources = path.join(
    appDir, 'Contents', 'Frameworks', 'Electron Framework.framework', 'Versions', 'A', 'Resources'
  );
  if (fs.existsSync(electronResources)) {
    let removed = 0;
    for (const entry of fs.readdirSync(electronResources)) {
      if (entry.endsWith('.lproj') && entry !== 'en.lproj') {
        fs.rmSync(path.join(electronResources, entry), { recursive: true, force: true });
        removed++;
      }
    }
    if (removed) console.log(`  • afterPack: trimmed ${removed} non-English locales`);
  }
};
