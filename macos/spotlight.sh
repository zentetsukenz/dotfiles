#!/usr/bin/env bash
# macos/spotlight.sh — Spotlight macOS defaults module.
# Independently runnable: DRY_RUN=1 bash macos/spotlight.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_helpers.sh"

log_info "Applying Spotlight settings..."

# Disable Spotlight indexing for volumes mounted but not yet indexed
set_default_sudo /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# Change indexing order and disable some search results
# (Complex array — use raw defaults write, not set_default helper)
if [[ "${DRY_RUN:-0}" != "1" ]]; then
  defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 1;"name" = "FONTS";}' \
    '{"enabled" = 0;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 0;"name" = "SOURCE";}'
  log_success "Set Spotlight orderedItems"
else
  log_info "[DRY-RUN] Would set Spotlight orderedItems array"
fi

# Enable Spotlight indexing for the main volume
if [[ "${DRY_RUN:-0}" != "1" ]]; then
  sudo mdutil -i on / > /dev/null
  log_success "Enabled Spotlight indexing for /"
else
  log_info "[DRY-RUN] Would run: sudo mdutil -i on /"
fi

# Fresh install only: reload mds and rebuild the Spotlight index from scratch
if [[ "${FRESH_INSTALL:-0}" == "1" ]]; then
  if [[ "${DRY_RUN:-0}" != "1" ]]; then
    killall mds > /dev/null 2>&1 || true
    log_success "Reloaded mds"
    sudo mdutil -E / > /dev/null
    log_success "Rebuilt Spotlight index from scratch"
  else
    log_info "[DRY-RUN] Would run: killall mds && sudo mdutil -E /"
  fi
fi

