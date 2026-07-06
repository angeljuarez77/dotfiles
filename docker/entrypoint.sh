#!/usr/bin/env bash
set -euo pipefail

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"
NVIM_USER="nvim"
NVIM_HOME="/home/${NVIM_USER}"

# Remap nvim user UID/GID to match host when mounting volumes
if [[ "$(id -u "${NVIM_USER}")" != "${PUID}" ]] || [[ "$(id -g "${NVIM_USER}")" != "${PGID}" ]]; then
  groupmod -o -g "${PGID}" "${NVIM_USER}"
  usermod -o -u "${PUID}" -g "${PGID}" "${NVIM_USER}"
  chown -R "${PUID}:${PGID}" "${NVIM_HOME}"
fi

# Default to nvim when docker CMD is overridden (e.g. `docker run image foo.ts`)
if [[ $# -eq 0 ]]; then
  set -- nvim
elif [[ "$1" != "nvim" ]]; then
  set -- nvim "$@"
fi

if [[ "$(id -u)" == "0" ]]; then
  exec gosu "${NVIM_USER}" "$@"
else
  exec "$@"
fi
