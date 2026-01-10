#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v stow >/dev/null 2>&1; then
  echo "[ERROR] stow not found. Run: make brew"
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <package...>"
  echo "Example: $0 zsh git"
  exit 1
fi

echo "[INFO] stow dry-run packages: $*"
cd "${ROOT_DIR}"
stow --dotfiles -n -v -t "${HOME}" "$@"
