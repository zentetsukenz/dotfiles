#!/usr/bin/env bash
# scripts/setup_ssh_agent.sh
# Sets up Homebrew SSH agent as a LaunchAgent for FIDO2 support
# Called by install.conf.yaml after brew bundle

set -euo pipefail

SSH_AGENT_BIN="/opt/homebrew/bin/ssh-agent"
AGENT_LABEL="dev.dotfiles.ssh-agent"
PLIST_PATH="$HOME/Library/LaunchAgents/${AGENT_LABEL}.plist"
SOCKET_PATH="$HOME/.ssh/agent.sock"

# === Guard: Homebrew ssh-agent not available ===
if [ ! -f "$SSH_AGENT_BIN" ]; then
    echo "✓ Homebrew SSH agent not found at $SSH_AGENT_BIN — skipping setup"
    exit 0
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       Homebrew SSH Agent Setup (dotfiles install)            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# === Disable macOS built-in SSH agent ===
echo "Disabling macOS built-in SSH agent..."
launchctl disable "user/$(id -u)/com.openssh.ssh-agent"
launchctl bootout "user/$(id -u)/com.openssh.ssh-agent" 2>/dev/null || true
echo "✓ macOS built-in SSH agent disabled"
echo ""

# === Create ~/.ssh directory ===
echo "Ensuring ~/.ssh directory exists..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
echo "✓ ~/.ssh directory ready"
echo ""

# === Write LaunchAgent plist ===
echo "Writing LaunchAgent plist to $PLIST_PATH..."
mkdir -p "$(dirname "$PLIST_PATH")"

cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>$AGENT_LABEL</string>
	<key>ProgramArguments</key>
	<array>
		<string>$SSH_AGENT_BIN</string>
		<string>-D</string>
		<string>-a</string>
		<string>$SOCKET_PATH</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
</dict>
</plist>
EOF

echo "✓ LaunchAgent plist written"
echo ""

# === Load the agent ===
echo "Loading SSH agent into launchd..."
launchctl bootout "gui/$(id -u)/${AGENT_LABEL}" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"
echo "✓ SSH agent loaded"
echo ""

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                      Setup Complete                          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  • Add keys to the agent: ssh-add ~/.ssh/id_ed25519"
echo "  • Cache key for 24 hours: ssh-add -t 86400 ~/.ssh/id_ed25519"
echo "  • Verify agent: echo \$SSH_AUTH_SOCK"
echo ""
