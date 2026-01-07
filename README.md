# dotfiles

Bootstrap a new macOS machine with Homebrew apps and symlinked dotfiles (via GNU Stow).

## What this does

- Ensures **Xcode Command Line Tools** are installed (prompts if missing)
- Installs **Homebrew** if needed
- Clones this **public** repository via **HTTPS**
- Runs `make all`:
  - `brew bundle` (install apps from `Brewfile`)
  - `stow` (apply dotfiles packages, default: `zsh git`)
  - basic checks via `doctor`

## Quick install (one-liner)

> **Note:** This executes a remote script. Review `install.sh` before running if you prefer.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/y-ttkt/dotfiles/main/install.sh)"
```

## After install (manual steps)
Some items are intentionally not stored in git.

### 1) Create ~/.gitconfig.local (required to commit)

This repo uses useConfigOnly = true, so you must set name/email locally:

```bash
cat > ~/.gitconfig.local <<'EOF'
[user]
  name = Your Name
  email = you@example.com
EOF
```

### 2) Optional local overrides
- `~/.zshrc.local`

- `~/.zprofile.local`

Use these for machine-specific settings and secrets.

## Repository layout

- `Brewfile` — Homebrew Bundle manifest

- `Makefile` — entry points (`make all`, `make brew`, `make link`, etc.)

- `.bin/*.sh` — scripts called by Makefile

- `zsh/`, `git/` — GNU Stow packages (`stow --dotfiles` ...)

## Common commands
```bash
# Install apps from Brewfile
make brew

# Dry-run stow
make dry-run

# Apply dotfiles (default PACKAGES="zsh git")
make link

# Remove symlinks
make unlink

# Check status / hints
make doctor

# Run everything
make all
```

