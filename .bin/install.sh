#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# =========================
# Defaults
# =========================
DEFAULT_REPO="yusuke/dotfiles"
DEFAULT_REF="main"
DEFAULT_DIR="$HOME/dotfiles"
DEFAULT_PACKAGES="zsh git"

# =========================
# Logging
# =========================
log()  { printf "\033[1;32m[dotfiles]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[dotfiles]\033[0m %s\n" "$*" >&2; }
err()  { printf "\033[1;31m[dotfiles]\033[0m %s\n" "$*" >&2; }
die()  { err "$*"; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1; }
is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }

# =========================
# Prereqs
# =========================
ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    return 0
  fi
  warn "Xcode Command Line Tools が未導入です。インストールを開始します。"
  warn "インストール完了後、もう一度この install.sh を実行してください。"
  xcode-select --install || true
  exit 1
}

install_homebrew() {
  local tmp
  tmp="$(mktemp -d)"
  log "Homebrew installer をダウンロードします…"
  curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" \
    -o "${tmp}/brew-install.sh"
  log "Homebrew installer を実行します…"
  /bin/bash "${tmp}/brew-install.sh"
}

eval_brew_shellenv() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    die "brew が見つかりません。Homebrew の導入に失敗している可能性があります。"
  fi
}

repo_https_url() {
  local repo="$1"
  printf "https://github.com/%s.git" "$repo"
}

ensure_exec_bits() {
  # Makefileが呼ぶ .bin/* が実行可能でないと詰まるので念のため
  if [[ -d ".bin" ]]; then
    chmod +x .bin/*.sh 2>/dev/null || true
  fi
}

# =========================
# Args
# =========================
REPO="$DEFAULT_REPO"
REF="$DEFAULT_REF"
DIR="$DEFAULT_DIR"
PACKAGES="$DEFAULT_PACKAGES"
UPDATE=0
SKIP_BREW_INSTALL=0
SKIP_MAKE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="${2:-}"; shift 2;;
    --ref) REF="${2:-}"; shift 2;;
    --dir) DIR="${2:-}"; shift 2;;
    --packages) PACKAGES="${2:-}"; shift 2;;
    --update) UPDATE=1; shift;;
    --skip-brew-install) SKIP_BREW_INSTALL=1; shift;;
    --skip-make) SKIP_MAKE=1; shift;;
    *) die "Unknown option: $1";;
  esac
done

[[ -n "$REPO" ]] || die "--repo is required"

# =========================
# Main
# =========================
is_macos || die "このスクリプトは macOS 向けです。"
[[ "$EUID" -ne 0 ]] || die "root での実行は避けてください。"

log "repo=${REPO}, ref=${REF}, dir=${DIR}, packages=${PACKAGES}"

ensure_xcode_clt

# git が無いならここで止める（CLT入れれば通常入る）
need_cmd git || die "git が見つかりません。Command Line Tools の導入後に再実行してください。"

# まず clone（HTTPS）
URL="$(repo_https_url "$REPO")"

if [[ -e "$DIR" ]]; then
  if [[ "$UPDATE" -eq 1 && -d "$DIR/.git" ]]; then
    log "既存ディレクトリを更新します: $DIR"
    (cd "$DIR" && git remote set-url origin "$URL" && git fetch --all --tags)
  else
    die "既に存在します: $DIR
安全のため中断しました。
- 別の --dir を指定するか
- 既存を使うなら --update を付けてください。"
  fi
else
  log "HTTPS で clone します: $URL"
  git clone "$URL" "$DIR"
fi

cd "$DIR"

# ref をチェックアウト（branch/tag/commit 対応）
log "ref をチェックアウトします: $REF"
git checkout -q "$REF" 2>/dev/null || {
  # commit hash 等で checkout できなければ fetch して再試行
  git fetch --all --tags
  git checkout "$REF"
}

# brew を用意（brew bundle は make brew で動く想定だが、brew 自体が無いと詰まる）
if ! need_cmd brew; then
  if [[ "$SKIP_BREW_INSTALL" -eq 1 ]]; then
    die "brew がありません。--skip-brew-install のため中断します。"
  fi
  install_homebrew
fi
eval_brew_shellenv

# make が無いと Makefile 使えない（通常CLTで入る）
need_cmd make || die "make が見つかりません。Command Line Tools の導入後に再実行してください。"

# .bin scripts の実行権限（念のため）
ensure_exec_bits

if [[ "$SKIP_MAKE" -eq 1 ]]; then
  warn "--skip-make のため、ここで終了します（cloneのみ）。"
  exit 0
fi

# Makefile を使って一括（brew -> link -> doctor）
log "make install を実行します…"
make install PACKAGES="$PACKAGES"

log "🎉インストールが成功しました🎉"
