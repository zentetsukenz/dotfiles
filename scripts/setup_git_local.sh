#!/usr/bin/env bash
# scripts/setup_git_local.sh
# Sets up machine-local git config (SSH signing key, etc.)
# Called by install.conf.yaml after cp global_gitconfig ~/.gitconfig

set -euo pipefail

GITCONFIG_LOCAL="$HOME/.gitconfig.local"

if [ -f "$GITCONFIG_LOCAL" ]; then
    # Check if it has a signingKey that looks like a legacy key ID
    # (no path separator "/" and no ".pub" extension = old-format bare key ID)
    EXISTING_KEY=$(grep -i 'signingKey' "$GITCONFIG_LOCAL" | awk '{print $NF}' || true)
    if [ -n "$EXISTING_KEY" ] && [[ "$EXISTING_KEY" != */* ]] && [[ "$EXISTING_KEY" != *.pub ]]; then
        echo ""
        echo "⚠️  Detected legacy signing key format in ~/.gitconfig.local"
        echo "   Signing format has changed. Please provide your SSH public key path."
        echo ""
        # Fall through to the prompt below
    else
        echo "✓ ~/.gitconfig.local already configured — skipping signing key setup"
        exit 0
    fi
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       SSH Signing Key Setup (dotfiles install)               ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Git commits are configured to use SSH signing (gpgsign = true)."
echo "The signing key lives in ~/.gitconfig.local (NOT in the repo)."
echo ""
printf "Enter path to your SSH public key for commit signing"
printf " (e.g., ~/.ssh/id_ed25519_sk.pub, leave empty to skip): "
read -r SSH_KEY_PATH

if [ -z "$SSH_KEY_PATH" ]; then
    echo ""
    echo "⚠️  No signing key set."
    echo "   Commits will FAIL signing until you create ~/.gitconfig.local:"
    echo "   echo -e '[user]\n    signingKey = ~/.ssh/id_ed25519_sk.pub' > ~/.gitconfig.local"
    echo ""
else
    printf '[user]\n    signingKey = %s\n' "$SSH_KEY_PATH" > "$GITCONFIG_LOCAL"
    echo ""
    echo "✓ Created ~/.gitconfig.local with signing key: $SSH_KEY_PATH"
    echo ""
fi
