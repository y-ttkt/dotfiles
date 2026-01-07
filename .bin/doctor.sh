#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] doctor start"

# 1) 必須コマンド
for cmd in git stow; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[WARN] missing command: $cmd (suggest: make brew)"
  else
    echo "[OK]   command: $cmd"
  fi
done

if command -v brew >/dev/null 2>&1; then
  echo "[OK]   command: brew"
else
  echo "[WARN] missing command: brew (Homebrew not installed yet)"
fi

# 2) ローカル専用ファイル（存在しなくても動くが、gitはcommitできない想定）
if [[ -f "${HOME}/.gitconfig.local" ]]; then
  echo "[OK]   ~/.gitconfig.local exists"
else
  echo "[WARN] ~/.gitconfig.local not found (with useConfigOnly=true you may not be able to commit)"
fi

if [[ -f "${HOME}/.zshrc.local" ]]; then
  echo "[OK]   ~/.zshrc.local exists"
else
  echo "[INFO] ~/.zshrc.local not found (optional)"
fi

if [[ -f "${HOME}/.zprofile.local" ]]; then
  echo "[OK]   ~/.zprofile.local exists"
else
  echo "[INFO] ~/.zprofile.local not found (optional)"
fi

# 3) stowリンクの状態（代表だけ）
check_link () {
  local path="$1"
  if [[ -L "$path" ]]; then
    echo "[OK]   symlink: $path -> $(readlink "$path")"
  elif [[ -e "$path" ]]; then
    echo "[WARN] exists but not symlink: $path"
  else
    echo "[INFO] not found: $path"
  fi
}

check_link "${HOME}/.zshrc"
check_link "${HOME}/.zprofile"
check_link "${HOME}/.gitconfig"

echo "[INFO] doctor done"
