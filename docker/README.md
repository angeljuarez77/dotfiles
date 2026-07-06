# dnvim

Portable Neovim (NvChad) in Docker.

**Image:** [`angeljuarez77/dnvim`](https://hub.docker.com/r/angeljuarez77/dnvim)

> **Setting up on a new machine?** See **[SETUP.md](../SETUP.md)** for step-by-step instructions.

## Quick usage

```bash
dnvim                    # open nvim in current directory
dnvim README.md          # open a file; nvim-tree shows the project tree
dnvim src/app.ts         # mounts git root (or file's directory) as workspace
```

`dnvim` automatically:

- Mounts your **git project root** (or the file's directory) into the container
- Opens **nvim-tree** on startup so you can explore the project
- Maps your host UID/GID so created files keep correct ownership

## What's baked into the image

- Ubuntu 24.04 + Neovim 0.12
- NvChad v2.5 + all Lazy plugins
- Mason LSP servers (ts_ls, eslint, lua_ls, …) and formatters (prettier, stylua)
- Treesitter parsers
- Node.js 22, global ESLint + Prettier
- FiraCode Nerd Font

No first-run downloads — ready immediately after `docker pull`.

CI pushes `angeljuarez77/dnvim:latest` to Docker Hub on every merge to `main` (see `.github/workflows/dnvim.yml`).

## Build locally

```bash
docker build -f docker/Dockerfile -t angeljuarez77/dnvim:latest .
```

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DNVIM_IMAGE` | `angeljuarez77/dnvim:latest` | Docker image to run |
| `PUID` / `PGID` | auto | Set automatically by `bin/dnvim` |
