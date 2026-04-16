# Spherelink (webapp)

Create a virtual tour of your most cherished memories.

www.spherelink.io

This is the original Rails multi-user web application. For the standalone desktop app see [`../desktop/`](../desktop/).

## Running locally

```sh
bundle install
rails db:setup
rails s
```

Requires Ruby (see `.ruby-version`), PostgreSQL, and ImageMagick.

## Backups

The 2024 Heroku shutdown backup is stored under `backup/` as reference:

- `backup/2024-backup.dump` — `pg_dump` binary format
- `backup/2024-backup-unpacked.sql` — human-readable unpacked SQL
