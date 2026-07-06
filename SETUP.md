# dnvim setup

Portable Neovim (NvChad) in Docker. Install once on any machine, then run `dnvim <file>`.

Works on **Linux**, **macOS**, and **Windows** (via Docker Desktop).

**Docker image:** [`angeljuarez77/dnvim`](https://hub.docker.com/r/angeljuarez77/dnvim) — `linux/amd64` + `linux/arm64`

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| [Docker](https://docs.docker.com/get-docker/) | Docker Desktop (macOS/Windows) or Docker Engine (Linux) |
| **Nerd Font on your terminal** | Required for icons (see [Terminal font](#terminal-font-required)) |
| Git | Optional — detects your project root when opening files |

---

## Terminal font (required)

NvChad uses **Nerd Font icons** in the statusline, nvim-tree, and plugins. If you see **boxes with question marks** (`□`), your **host terminal** is not using a Nerd Font.

Fonts installed inside the Docker image do **not** affect your display — only the font configured in iTerm2, Terminal, Cursor, Windows Terminal, etc.

### Quick fix (macOS / Linux)

From this repo:

```bash
./bin/install-nerd-font
```

Or if you use dotbot:

```bash
./install   # links FiraCode Nerd Font to ~/Library/Fonts
```

Then set your terminal font to **`FiraCode Nerd Font`** (not plain "Fira Code"):

| App | Where to set it |
|-----|-----------------|
| **iTerm2** | Settings → Profiles → Text → Font |
| **Terminal.app** | Settings → Profile → Font |
| **Cursor / VS Code** | Settings → `terminal.integrated.fontFamily` → `FiraCode Nerd Font` |
| **Windows Terminal** | Settings → Profiles → Appearance → Font face |
| **Alacritty / Kitty** | `font.normal.family` in config |

Restart the terminal after changing the font.

Run `dnvim-doctor` to verify your setup.

---

## macOS

### 1. Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/)

### 2. Install the launcher

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/angeljuarez77/dotfiles/main/bin/dnvim \
  -o ~/.local/bin/dnvim
chmod +x ~/.local/bin/dnvim
```

Add to `~/.zshrc` (or `~/.bashrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 3. Pull and run

```bash
docker pull angeljuarez77/dnvim:latest
dnvim README.md
```

**Apple Silicon (M1/M2/M3):** the image includes an `arm64` build. **Intel Macs** use `amd64`.

---

## Linux

### 1. Install [Docker Engine](https://docs.docker.com/engine/install/)

Add your user to the `docker` group so `sudo` isn't required:

```bash
sudo usermod -aG docker "$USER"
newgrp docker
```

### 2. Install the launcher

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/angeljuarez77/dotfiles/main/bin/dnvim \
  -o ~/.local/bin/dnvim
chmod +x ~/.local/bin/dnvim
```

Add to `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 3. Pull and run

```bash
docker pull angeljuarez77/dnvim:latest
dnvim README.md
```

The launcher passes your UID/GID so files created in the container keep correct ownership.

---

## Windows

Docker Desktop runs Linux containers, so the same image is used on all platforms.

### 1. Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)

Enable **WSL 2** backend when prompted (recommended).

### 2. Install the launcher (PowerShell)

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\bin" | Out-Null
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/angeljuarez77/dotfiles/main/bin/dnvim.ps1" `
  -OutFile "$env:USERPROFILE\bin\dnvim.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/angeljuarez77/dotfiles/main/bin/dnvim.cmd" `
  -OutFile "$env:USERPROFILE\bin\dnvim.cmd"
```

Add `%USERPROFILE%\bin` to your [user PATH](https://learn.microsoft.com/en-us/windows/win32/procthread/environment-variables).

Open a **new** terminal, then:

```powershell
docker pull angeljuarez77/dnvim:latest
dnvim README.md
```

### Alternative: Git Bash or WSL

If you use **Git Bash** or **WSL**, install the bash launcher instead (same as Linux/macOS) and run `dnvim` from that shell.

---

## Usage (all platforms)

```bash
dnvim                         # open nvim in the current directory
dnvim README.md               # open a file
dnvim src/components/App.tsx  # open a file anywhere in a git repo
```

### What happens under the hood

1. `dnvim` finds your **git project root** (or the file's parent directory).
2. That directory is mounted into the container at `/workspace`.
3. Neovim opens your file with **nvim-tree** showing the project tree.
4. On Linux/macOS, your **UID/GID** are passed through for correct file ownership.

---

## Setup from this dotfiles repo (macOS / Linux)

```bash
./install
docker pull angeljuarez77/dnvim:latest
```

This symlinks `bin/dnvim` to `~/.local/bin/dnvim`.

---

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DNVIM_IMAGE` | `angeljuarez77/dnvim:latest` | Override the Docker image |
| `PUID` / `PGID` | auto on Unix; `1000` on Windows | Container user mapping |

---

## What's included in the image

Everything is pre-installed at build time — no downloads on first launch.

- Ubuntu 24.04 + Neovim 0.12
- NvChad v2.5 (Lazy.nvim plugins)
- LSP servers: TypeScript, ESLint, Lua, HTML, CSS, JSON, Bash, typos
- Formatters: Prettier, Stylua
- Treesitter parsers
- Node.js 22, global ESLint + Prettier
- FiraCode Nerd Font (inside the image — **your terminal still needs a Nerd Font**; see above)

---

## Troubleshooting

### `dnvim: command not found`

The launcher directory is not on your PATH. Revisit the install step for your OS.

### `Cannot connect to the Docker daemon`

Docker is not running. Start Docker Desktop, or on Linux:

```bash
sudo systemctl start docker
```

### `no matching manifest for linux/arm64`

Pull again after the latest CI build finishes (image is multi-arch). Or build locally:

```bash
docker build -f docker/Dockerfile -t angeljuarez77/dnvim:latest .
```

### Permission errors on saved files (Linux)

Confirm you are using `dnvim` (not a raw `docker run` without `PUID`/`PGID`).

### Windows path / drive errors

Run `dnvim` from PowerShell or Git Bash with Docker Desktop running. Paths like `C:\Users\you\project` are mounted automatically.

### Icons show as boxes / question marks

Your **terminal** needs a Nerd Font — not the container. See [Terminal font](#terminal-font-required).

```bash
# macOS / Linux
./bin/install-nerd-font
dnvim-doctor
```

On Windows, install [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip), install the `.ttf` files, then set **Windows Terminal** font to `FiraCode Nerd Font`.

---

## Building the image yourself

```bash
docker build -f docker/Dockerfile -t angeljuarez77/dnvim:latest .
```

See [`docker/README.md`](docker/README.md) for compose and local development.

---

## CI (maintainers)

Pushes to `main` that touch the Docker image or Neovim config trigger [`.github/workflows/dnvim.yml`](.github/workflows/dnvim.yml), which builds **linux/amd64** and **linux/arm64** and pushes `angeljuarez77/dnvim:latest`.

Repository secrets: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` ([Docker Hub access token](https://hub.docker.com/settings/security)).
