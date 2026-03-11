#!/usr/bin/env bash
# macos/locale.sh — Language & Region domain module.
# Independently runnable: DRY_RUN=1 bash macos/locale.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_helpers.sh"

log_info "Applying Language & Region settings..."

# Set language and text formats
set_default NSGlobalDomain AppleLanguages -array "en" "th"
set_default NSGlobalDomain AppleLocale -string "en_US@currency=USD"
set_default NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
set_default NSGlobalDomain AppleMetricUnits -bool true

# Show language menu in the top right corner of the boot screen
set_default_sudo /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Set the timezone
# NOTE: systemsetup is a raw command — wrap in dry-run check
if [[ "${DRY_RUN:-0}" != "1" ]]; then
  sudo systemsetup -settimezone "Asia/Bangkok" > /dev/null
  log_success "Set timezone: Asia/Bangkok"
else
  log_info "[DRY-RUN] Would run: sudo systemsetup -settimezone Asia/Bangkok"
fi
