#!/usr/bin/env bash

set -euo pipefail

# Constants (mirrored from setup_ssh_agent.sh for isolation)
SSH_AGENT_BIN="/opt/homebrew/bin/ssh-agent"
AGENT_LABEL="dev.dotfiles.ssh-agent"
PLIST_PATH="$HOME/Library/LaunchAgents/${AGENT_LABEL}.plist"
SOCKET_PATH="$HOME/.ssh/agent.sock"

# Colors for readability
MARK_OK="✓"
MARK_FAIL="✗"
MARK_WARN="⚠"

# --- Binary Check ---
if [ ! -f "$SSH_AGENT_BIN" ]; then
  echo "$MARK_FAIL Homebrew ssh-agent not installed at $SSH_AGENT_BIN"
  exit 2
fi

# --- Plist Check ---
if [ ! -f "$PLIST_PATH" ]; then
  echo "$MARK_FAIL LaunchAgent plist not installed — run scripts/setup_ssh_agent.sh"
  echo ""
  echo "Recovery:"
  echo "  bash scripts/setup_ssh_agent.sh"
  exit 1
fi

# --- LaunchAgent State Check ---
launchctl_output=$(launchctl print "gui/$(id -u)/${AGENT_LABEL}" 2>/dev/null || echo "")
if ! echo "$launchctl_output" | grep -q "state = running"; then
  echo "$MARK_FAIL SSH agent LaunchAgent not running"
  echo ""
  echo "Recovery:"
  echo "  rm -f ~/.ssh/agent.sock"
  echo "  launchctl kickstart -k gui/\$(id -u)/dev.dotfiles.ssh-agent"
  echo "  bash scripts/setup_ssh_agent.sh   # if kickstart insufficient"
  exit 1
fi

# --- Socket Check ---
if [ ! -S "$SOCKET_PATH" ]; then
  echo "$MARK_FAIL Socket missing or not a socket file at $SOCKET_PATH"
  echo ""
  echo "Recovery:"
  echo "  rm -f ~/.ssh/agent.sock"
  echo "  launchctl kickstart -k gui/\$(id -u)/dev.dotfiles.ssh-agent"
  echo "  bash scripts/setup_ssh_agent.sh   # if kickstart insufficient"
  exit 1
fi

# --- Agent Response Check ---
_rc=0
SSH_AUTH_SOCK="$SOCKET_PATH" ssh-add -l >/dev/null 2>&1 || _rc=$?
if [ "$_rc" -eq 2 ]; then
  echo "$MARK_FAIL Agent socket present but not listening (Connection refused)"
  echo ""
  echo "Recovery:"
  echo "  rm -f ~/.ssh/agent.sock"
  echo "  launchctl kickstart -k gui/\$(id -u)/dev.dotfiles.ssh-agent"
  echo "  bash scripts/setup_ssh_agent.sh   # if kickstart insufficient"
  exit 1
fi

# --- PID Sanity Check (Warning, not failure) ---
_pid=$(echo "$launchctl_output" | awk '/pid =/ {print $3}')
if [ -n "$_pid" ]; then
  _process=$(ps -p "$_pid" -o comm= 2>/dev/null || echo "")
  if [ -n "$_process" ] && ! echo "$_process" | grep -q "ssh-agent"; then
    echo "$MARK_WARN LaunchAgent PID $_pid is running $_process instead of ssh-agent — exec may not have worked"
  fi
fi

# --- Success ---
echo "$MARK_OK SSH agent healthy"
exit 0
