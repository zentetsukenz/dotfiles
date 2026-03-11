#!/usr/bin/env bash
# macos/screen.sh — Screen & Screensaver defaults module.
# Sourced by apply.sh or run standalone: DRY_RUN=1 bash macos/screen.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_helpers.sh"

log_info "Applying Screen & Screensaver settings..."

# Require password immediately after sleep or screen saver begins
set_default com.apple.screensaver askForPassword -int 1
set_default com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the Desktop
set_default com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
set_default com.apple.screencapture type -string "png"

# Disable shadow in screenshots
set_default com.apple.screencapture disable-shadow -bool true

# Enable HiDPI display modes (requires restart)
set_default_sudo /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
