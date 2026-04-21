# Claude Code notes for Spherelink

## Headless Electron: OK for build scripts, not for ad-hoc inspection

The desktop app ships a committed build-time Electron script — `desktop/scripts/prepare-seed.js`, invoked via `npm run prepare-seed` — that runs Electron headlessly on purpose so that native modules (`better-sqlite3`, `sharp`) load against the same ABI the packaged app will use. **This works fine.** It terminates cleanly via `app.exit()` and is part of the documented build pipeline. Use it as the docs describe.

What you should NOT do is reach for `npx electron -e "..."` or `./node_modules/.bin/electron -e "..."` as an ad-hoc scripting shell for tasks that don't actually need Electron APIs — e.g. poking at a SQL dump, inspecting the SQLite DB, reformatting a JSON file. Those belong in plain Node:

```
node -e "..."                               # plain Node scripts
npx tsx -e "..."                            # TypeScript scripts
node --experimental-strip-types -e "..."    # inline TS without tsx
```

**Why the distinction matters.** A committed script like `prepare-seed.js` is well-shaped: it wraps work inside `app.whenReady().then(...)` and calls `app.exit(0)` on every code path. Ad-hoc `-e` invocations routinely forget one of those and hang waiting on display resources that will never arrive in a headless / SSH context. A hung electron subprocess blocks the Claude Code Bash tool, which blocks the turn, which blocks follow-ups until the OpenClaw watchdog trips (15 min) or someone runs `cc --unstick`.

If you genuinely need Electron APIs for something new (testing IPC handlers, native modules that only load under Electron): factor the pure-logic portion into a plain Node-importable module and exercise *that*. If you truly can't separate them, write a committed script in `desktop/scripts/` modeled on `prepare-seed.js` (same `app.whenReady` / `app.exit` shape, same exit-on-every-path discipline) rather than a one-off `-e` invocation.

## Incident reference

2026-04-20: A CC turn hung for 40+ minutes on `npx electron -e` commands that were parsing a SQL dump via `./src/main/sql-dump-parser`. Three attempts all deadlocked; the Claude Bash tool's 2-min timeout never fired (likely pipe-buffer deadlock against `2>&1 | tail -40`). The OpenClaw watchdog was added afterward to catch this class of hang. The lesson was specifically about *ad-hoc* headless Electron invocations — not about the committed `prepare-seed` build script, which has always run cleanly.
