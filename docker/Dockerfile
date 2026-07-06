FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color \
    EDITOR=nvim \
    DNVIM_CONTAINER=1 \
    PUID=1000 \
    PGID=1000

# System deps, Neovim (PPA), Node.js 22, clipboard support
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    unzip \
    build-essential \
    ripgrep \
    fd-find \
    xclip \
    fontconfig \
    software-properties-common \
    gosu \
    && add-apt-repository -y ppa:neovim-ppa/unstable \
    && apt-get update \
    && apt-get install -y --no-install-recommends neovim \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g eslint prettier \
    && apt-get purge -y software-properties-common \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Nerd Font for NvChad icons
RUN mkdir -p /usr/share/fonts/truetype/firacode \
    && curl -fsSL -o /tmp/firacode.zip \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip" \
    && unzip -q /tmp/firacode.zip -d /usr/share/fonts/truetype/firacode \
    && rm /tmp/firacode.zip \
    && fc-cache -fv

# Non-root user for sane file ownership on mounted volumes
RUN userdel -r ubuntu 2>/dev/null || true \
    && groupadd -g "${PGID}" nvim \
    && useradd -m -u "${PUID}" -g nvim -s /bin/bash nvim

COPY home/.config/nvim/ /home/nvim/.config/nvim/

RUN chown -R nvim:nvim /home/nvim

# Bake plugins and Treesitter parsers (via Lazy sync)
RUN gosu nvim nvim --headless "+Lazy! sync" +qa!

# Bake Mason LSP servers and formatters
RUN DNVIM_BAKE=1 gosu nvim nvim --headless \
      "+Lazy! load mason.nvim" \
      "+lua require('configs.bootstrap').mason()" \
      +qa! \
    && for pkg in bash-language-server css-lsp eslint-lsp html-lsp json-lsp \
      lua-language-server typescript-language-server typos-lsp stylua prettier; do \
      test -f "/home/nvim/.local/share/nvim/mason/packages/${pkg}/mason-receipt.json"; \
    done

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nvim"]
