#!/usr/bin/env bash
# macos/software_update.sh — Software Update domain defaults.
# Run standalone: DRY_RUN=1 bash macos/software_update.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_helpers.sh"

log_info "Applying Software Update settings..."

# Enable the automatic update check
set_default com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
set_default com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Install System data files & security updates
set_default com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
set_default com.apple.commerce AutoUpdate -bool true
