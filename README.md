# Spherelink

Create virtual tours of your most cherished memories.

This repo contains two independent applications:

| Directory   | What it is                              | Runs independently |
|-------------|-----------------------------------------|--------------------|
| `webapp/`   | Original Rails web application          | `cd webapp && bundle && rails s` |
| `desktop/`  | Standalone Electron desktop app         | `cd desktop && npm install && npm start` |

The desktop app ships with **Joe's Boat** baked in as the default memory — no server, account, or setup needed. See [`desktop/README.md`](desktop/README.md) for details.

The webapp is the legacy multi-user Rails version preserved for reference. See [`webapp/README.md`](webapp/README.md).

![sau](https://user-images.githubusercontent.com/9356287/96946459-26491480-152c-11eb-850e-25d5c3378294.png)
