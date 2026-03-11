#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_helpers.sh"

log_info "Applying Keyboard & Input settings..."

# Trackpad: enable tap to click for this user and for the login screen
set_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
set_default_currenthost NSGlobalDomain com.apple.mouse.tapBehavior -int 1
set_default NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
set_default com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
set_default com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
set_default_currenthost NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
set_default_currenthost NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Enable natural (Lion-style) scrolling
# NOTE: value true = ENABLED (comment in original .macos was wrong: said "Disable")
set_default NSGlobalDomain com.apple.swipescrolldirection -bool true

# Enable full keyboard access for all controls (e.g. Tab in modal dialogs)
set_default NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with Ctrl (^) modifier key to zoom
set_default com.apple.universalaccess closeViewScrollWheelToggle -bool true
set_default com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Follow the keyboard focus while zoomed in
set_default com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Disable press-and-hold for keys in favor of key repeat
set_default NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
set_default NSGlobalDomain KeyRepeat -int 1
set_default NSGlobalDomain InitialKeyRepeat -int 10

# Disable automatic capitalization (annoying when typing code)
set_default NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes (annoying when typing code)
set_default NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution (annoying when typing code)
set_default NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes (annoying when typing code)
set_default NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
set_default NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
