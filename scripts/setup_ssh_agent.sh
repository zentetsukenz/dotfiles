#!/usr/bin/env bash
# scripts/setup_ssh_agent.sh
# Sets up Homebrew SSH agent as a LaunchAgent for FIDO2 support
# Called by install.conf.yaml after brew bundle

set -euo pipefail

SSH_AGENT_BIN="/opt/homebrew/bin/ssh-agent"
AGENT_LABEL="dev.dotfiles.ssh-agent"
PLIST_PATH="$HOME/Library/LaunchAgents/${AGENT_LABEL}.plist"
SOCKET_PATH="$HOME/.ssh/agent.sock"
SSH_ADD_BIN="/opt/homebrew/bin/ssh-add"
ASKPASS="$(cd "$(dirname "$0")" && pwd)/ssh_askpass_keychain.sh"
KEYS='"$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519_sk"'

# The agent's launchd job. Each start publishes the socket to GUI apps (launchctl setenv), then
# reloads the keys from the login Keychain through ssh_askpass_keychain.sh, so a restart, a kill or a
# reboot never leaves an empty agent. Store a key's passphrase once:
#   security add-generic-password -U -a "$USER" -s "ssh:id_ed25519" -T /usr/bin/security -w
write_plist() {
    cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>$AGENT_LABEL</string>
	<key>ProgramArguments</key>
	<array>
		<string>/bin/bash</string>
		<string>-c</string>
		<string>launchctl setenv SSH_AUTH_SOCK "$SOCKET_PATH"; rm -f "$SOCKET_PATH"; (until [ -S "$SOCKET_PATH" ]; do sleep 0.2; done; SSH_AUTH_SOCK="$SOCKET_PATH" SSH_ASKPASS="$ASKPASS" SSH_ASKPASS_REQUIRE=force "$SSH_ADD_BIN" $KEYS) &amp; exec "$SSH_AGENT_BIN" -D -a "$SOCKET_PATH"</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
	<key>ThrottleInterval</key>
	<integer>10</integer>
</dict>
</plist>
EOF
}

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

write_plist > "$PLIST_PATH"

echo "✓ LaunchAgent plist written"
echo ""

# === Early-exit-if-healthy ===
if [ -S "$SOCKET_PATH" ]; then
    _ssh_rc=0
    SSH_AUTH_SOCK="$SOCKET_PATH" ssh-add -l >/dev/null 2>&1 || _ssh_rc=$?
    if [ "$_ssh_rc" -eq 0 ] || [ "$_ssh_rc" -eq 1 ]; then
        # Write expected plist to tempfile
        _tmpfile=$(mktemp)
        write_plist > "$_tmpfile"
        if diff -q "$PLIST_PATH" "$_tmpfile" >/dev/null 2>&1; then
            rm -f "$_tmpfile"
            echo "✓ SSH agent already healthy — skipping setup"
            exit 0
        fi
        rm -f "$_tmpfile"
    fi
fi
echo ""
# === Guard: socket path is not a directory ===
if [ -d "$SOCKET_PATH" ]; then
    echo "✗ $SOCKET_PATH is a directory — cannot safely remove. Aborting." >&2
    exit 1
fi
rm -f "$SOCKET_PATH"
echo ""
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
