#!/usr/bin/env bash
# macos/general_ux.sh — General UI/UX macOS defaults
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_helpers.sh"

log_info "Applying General UI/UX settings..."

# Disable transparency in the menu bar
set_default com.apple.universalaccess reduceTransparency -bool true

# Set sidebar icon size to medium
set_default NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Automatically show scrollbars
set_default NSGlobalDomain AppleShowScrollBars -string "Automatic"

# Disable the over-the-top focus ring animation
set_default NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Disable smooth scrolling (makes UI feel snappier)
set_default NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
set_default NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
set_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
set_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
set_default NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
set_default NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
set_default NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
set_default com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Display ASCII control characters using caret notation
set_default NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
set_default com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
set_default NSGlobalDomain NSDisableAutomaticTermination -bool true

# Set Help Viewer windows to non-floating mode
set_default com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version when clicking clock in login window
set_default_sudo /Library/Preferences/com.apple.loginwindow AdminHostInfo -string HostName

# Disable tiling window margins (prefer edge-to-edge tiling)
set_default com.apple.WindowManager EnableTiledWindowMargins -bool false
