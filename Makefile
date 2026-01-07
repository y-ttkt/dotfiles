SHELL := /bin/bash

PACKAGES ?= zsh git

.PHONY: help all brew link dry-run unlink doctor

help:
	@echo "Targets:"
	@echo "  make brew        - Install apps from Brewfile (brew bundle)"
	@echo "  make link        - Apply dotfiles via stow (PACKAGES='$(PACKAGES)')"
	@echo "  make dry-run     - stow dry-run"
	@echo "  make unlink      - Remove stow links"
	@echo "  make doctor      - Check required local files & link status"
	@echo ""
	@echo "Examples:"
	@echo "  make install"
	@echo "  make link PACKAGES='zsh git'"

install: brew link doctor

brew:
	@./.bin/brew.sh

dry-run:
	@./.bin/dry-run.sh $(PACKAGES)

link:
	@./.bin/link.sh $(PACKAGES)

unlink:
	@./.bin/unlink.sh $(PACKAGES)

doctor:
	@./.bin/doctor.sh
