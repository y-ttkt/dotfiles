#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="${ROOT_DIR}/Brewfile"

if ! command -v brew >/dev/null 2>&1; then
  echo "[ERROR] Homebrew (brew) not found."
  echo "Install Homebrew first, then rerun:"
  echo "  make brew"
  exit 1
fi

echo "[INFO] Running: brew bundle --file \"${BREWFILE}\""
brew bundle --file "${BREWFILE}"
