#!/usr/bin/env bash
# scripts/setup_git_local.sh
# Sets up machine-local git config (GPG signing key, etc.)
# Called by install.conf.yaml after cp global_gitconfig ~/.gitconfig

set -euo pipefail

GITCONFIG_LOCAL="$HOME/.gitconfig.local"

if [ -f "$GITCONFIG_LOCAL" ]; then
    echo "✓ ~/.gitconfig.local already exists — skipping GPG signing key setup"
    exit 0
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          GPG Signing Key Setup (dotfiles install)            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Git commits are configured to use GPG signing (gpgsign = true)."
echo "The signing key lives in ~/.gitconfig.local (NOT in the repo)."
echo ""
printf "Enter your GPG Key ID for commit signing (leave empty to skip): "
read -r GPG_KEY_ID

if [ -z "$GPG_KEY_ID" ]; then
    echo ""
    echo "⚠️  No signing key set."
    echo "   Commits will FAIL GPG signing until you create ~/.gitconfig.local:"
    echo "   echo -e '[user]\n    signingkey = YOUR_GPG_KEY_ID' > ~/.gitconfig.local"
    echo ""
else
    printf '[user]\n    signingkey = %s\n' "$GPG_KEY_ID" > "$GITCONFIG_LOCAL"
    echo ""
    echo "✓ Created ~/.gitconfig.local with signing key: $GPG_KEY_ID"
    echo ""
fi
