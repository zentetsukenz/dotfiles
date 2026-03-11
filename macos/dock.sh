#!/usr/bin/env bash
# macos/dock.sh — Dock & Hot Corners domain module.
# Part of the macos-defaults-rework project.
#
# Usage:
#   bash macos/dock.sh                   # Apply all settings
#   DRY_RUN=1 bash macos/dock.sh         # Preview without applying
#   FRESH_INSTALL=1 bash macos/dock.sh   # Include destructive ops (persistent-apps wipe, Launchpad reset)

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_helpers.sh"

log_info "Applying Dock & Hot Corners settings..."

# Enable highlight hover effect for the grid view of a stack (Dock)
set_default com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 36 pixels
set_default com.apple.dock tilesize -int 36

# Change minimize/maximize window effect to scale (faster than genie)
set_default com.apple.dock mineffect -string "scale"

# Minimize windows into their application's icon
set_default com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
set_default com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
set_default com.apple.dock show-process-indicators -bool true

# Show only open applications in the Dock
set_default com.apple.dock static-only -bool true

# Don't animate opening applications from the Dock
set_default com.apple.dock launchanim -bool false

# Speed up Mission Control animations
set_default com.apple.dock expose-animation-duration -float 0.1

# Don't automatically rearrange Spaces based on most recent use
set_default com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
set_default com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
set_default com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
set_default com.apple.dock autohide -bool true

# Destructive ops — only on fresh install
if [[ "${FRESH_INSTALL:-0}" == "1" ]]; then
  # Wipe all (default) app icons from the Dock
  if [[ "${DRY_RUN:-0}" != "1" ]]; then
    defaults write com.apple.dock persistent-apps -array
    log_success "Wiped Dock persistent apps"
  else
    log_info "[DRY-RUN] Would wipe Dock persistent apps"
  fi

  # Reset Launchpad, but keep the desktop wallpaper intact
  if [[ "${DRY_RUN:-0}" != "1" ]]; then
    find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete
    log_success "Reset Launchpad database"
  else
    log_info "[DRY-RUN] Would reset Launchpad database"
  fi
fi

# Hot corners
# Possible values:
#  0: no-op   2: Mission Control  3: App windows  4: Desktop
#  5: Start screen saver  6: Disable screen saver  10: Put display to sleep
# 11: Launchpad  12: Notification Center  13: Lock Screen
# Top left screen corner → Lock Screen (requires password immediately)
set_default com.apple.dock wvous-tl-corner -int 13
set_default com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → no-op
set_default com.apple.dock wvous-tr-corner -int 0
set_default com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → no-op
set_default com.apple.dock wvous-bl-corner -int 0
set_default com.apple.dock wvous-bl-modifier -int 0
