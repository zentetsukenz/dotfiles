#!/usr/bin/env bash
# macos/apply.sh — Orchestrator for macOS system defaults
#
# Sources _helpers.sh and all 8 domain modules sequentially.
# Manages sudo elevation and performs the final process kill sweep.
#
# Usage: bash macos/apply.sh [--dry-run] [--fresh-install] [--help]

set -euo pipefail

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------

show_usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Apply macOS system defaults across all domains.

OPTIONS:
  --dry-run        Print what would be changed without applying any settings.
                   No sudo required. Safe to run on any machine.
  --fresh-install  Apply destructive/reset operations (Dock wipe, Launchpad
                   reset, Spotlight reindex). Only needed on a new machine.
  --help, -h       Show this help message and exit.

NOTES:
  - Requires Full Disk Access granted to your terminal in System Settings.
  - Some changes require a logout or restart to take effect.
  - Modules run sequentially: general_ux → dock → finder → keyboard →
    screen → spotlight → locale → software_update.

EXAMPLES:
  # Preview all changes without applying:
  bash macos/apply.sh --dry-run

  # Full apply on a new machine:
  bash macos/apply.sh --fresh-install

  # Standard apply (incremental update):
  bash macos/apply.sh
EOF
}

# ---------------------------------------------------------------------------
# Flag parsing
# ---------------------------------------------------------------------------

DRY_RUN=0
FRESH_INSTALL=0

for arg in "$@"; do
  case "$arg" in
    --dry-run)       DRY_RUN=1 ;;
    --fresh-install) FRESH_INSTALL=1 ;;
    --help|-h)       show_usage; exit 0 ;;
    *) echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done

export DRY_RUN FRESH_INSTALL

# ---------------------------------------------------------------------------
# Path resolution
# ---------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR

# ---------------------------------------------------------------------------
# Bootstrap helpers
# ---------------------------------------------------------------------------

. "$SCRIPT_DIR/_helpers.sh"

# ---------------------------------------------------------------------------
# Pre-flight: close System Settings
# ---------------------------------------------------------------------------

# Close any open System Settings panes to prevent them from overriding
# settings we are about to change.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# ---------------------------------------------------------------------------
# Sudo management (skip in dry-run — no writes needed)
# ---------------------------------------------------------------------------

if [[ "$DRY_RUN" != "1" ]]; then
  # Ask for the administrator password upfront.
  sudo -v

  # Keep sudo alive in background until apply.sh finishes.
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT
fi

# ---------------------------------------------------------------------------
# Load domain modules (sequential — order matters)
# ---------------------------------------------------------------------------

. "$SCRIPT_DIR/general_ux.sh"
. "$SCRIPT_DIR/dock.sh"
. "$SCRIPT_DIR/finder.sh"
. "$SCRIPT_DIR/keyboard.sh"
. "$SCRIPT_DIR/screen.sh"
. "$SCRIPT_DIR/spotlight.sh"
. "$SCRIPT_DIR/locale.sh"
. "$SCRIPT_DIR/software_update.sh"

# ---------------------------------------------------------------------------
# Final kill sweep — restart affected system processes
# ---------------------------------------------------------------------------

if [[ "$DRY_RUN" != "1" ]]; then
  for app in "Dock" "Finder" "SystemUIServer" "cfprefsd"; do
    killall "$app" 2>/dev/null || true
  done
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

print_summary

echo "Done. Some changes require logout/restart to take effect."
