# dnvim setup

Portable Neovim (NvChad) in Docker. Install once on any machine, then run `dnvim <file>`.

**Docker image:** [`angeljuarez77/dnvim`](https://hub.docker.com/r/angeljuarez77/dnvim)

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| [Docker](https://docs.docker.com/get-docker/) | Docker Desktop (macOS/Windows) or Docker Engine (Linux) |
| Python 3 | Used by the `dnvim` launcher to resolve file paths (`python3` on PATH) |
| Git | Optional — used to detect your project root when opening files |

---

## One-time setup (new machine)

### 1. Install Docker

- **macOS / Windows:** [Docker Desktop](https://docs.docker.com/desktop/)
- **Linux:** [Docker Engine](https://docs.docker.com/engine/install/)

Verify:

```bash
docker --version
```

### 2. Install the `dnvim` launcher

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/angeljuarez77/dotfiles/main/bin/dnvim \
  -o ~/.local/bin/dnvim
chmod +x ~/.local/bin/dnvim
```

### 3. Add `~/.local/bin` to your PATH

**zsh** (`~/.zshrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

**bash** (`~/.bashrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Reload your shell:

```bash
source ~/.zshrc   # or source ~/.bashrc
```

### 4. Pull the image

```bash
docker pull angeljuarez77/dnvim:latest
```

### 5. Verify

```bash
command -v dnvim
docker run --rm --entrypoint nvim angeljuarez77/dnvim:latest --version
```

You should see `NVIM v0.12.x` printed.

---

## Usage

```bash
dnvim                         # open nvim in the current directory
dnvim README.md               # open a file
dnvim src/components/App.tsx  # open a file anywhere in a git repo
dnvim .                       # open nvim with the current directory as workspace
```

### What happens under the hood

1. `dnvim` finds your **git project root** (or the file's parent directory if not in a repo).
2. That directory is mounted into the container at `/workspace`.
3. Neovim opens your file with **nvim-tree** showing the full project tree.
4. Your host **UID/GID** are passed in so new files keep correct ownership.

---

## Setup from this dotfiles repo

If you already have this repository cloned:

```bash
./install
```

That symlinks `bin/dnvim` to `~/.local/bin/dnvim` (see `install.conf.yaml`). Then pull the image:

```bash
docker pull angeljuarez77/dnvim:latest
```

---

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DNVIM_IMAGE` | `angeljuarez77/dnvim:latest` | Override the Docker image |
| `PUID` / `PGID` | auto (`id -u` / `id -g`) | Set automatically by the launcher |

Example — pin a specific version:

```bash
export DNVIM_IMAGE=angeljuarez77/dnvim:0.2.0
```

---

## What's included in the image

Everything is pre-installed at build time — no downloads on first launch.

- Ubuntu 24.04 + Neovim 0.12
- NvChad v2.5 (Lazy.nvim plugins)
- LSP servers: TypeScript, ESLint, Lua, HTML, CSS, JSON, Bash, typos
- Formatters: Prettier, Stylua
- Treesitter parsers
- Node.js 22, global ESLint + Prettier
- FiraCode Nerd Font

---

## Troubleshooting

### `dnvim: command not found`

`~/.local/bin` is not on your PATH. Add it (step 3 above) and reload your shell.

### `Cannot connect to the Docker daemon`

Docker is not running. Start Docker Desktop or the Docker service:

```bash
# Linux
sudo systemctl start docker
```

### `python3: command not found`

Install Python 3. The launcher uses it to resolve absolute file paths.

### Permission errors on saved files

The launcher passes your UID/GID automatically. If files are still owned by root, confirm you are running `dnvim` (not `docker run` directly without `-e PUID` / `-e PGID`).

### Slow first `docker pull`

The image includes Neovim, all plugins, LSP servers, and fonts. The initial pull is a one-time download (~1–2 GB depending on layers).

---

## Building the image yourself

From this repository:

```bash
docker build -f docker/Dockerfile -t angeljuarez77/dnvim:latest .
export DNVIM_IMAGE=angeljuarez77/dnvim:latest
```

See also [`docker/README.md`](docker/README.md) for compose and local development options.

---

## CI (maintainers)

Pushes to `main` that touch the Docker image or Neovim config trigger [`.github/workflows/dnvim.yml`](.github/workflows/dnvim.yml), which rebuilds and pushes `angeljuarez77/dnvim:latest` to Docker Hub.

Add these [repository secrets](https://github.com/angeljuarez77/dotfiles/settings/secrets/actions):

| Secret | Value |
|--------|-------|
| `DOCKERHUB_USERNAME` | `angeljuarez77` |
| `DOCKERHUB_TOKEN` | A Docker Hub [access token](https://hub.docker.com/settings/security) |
