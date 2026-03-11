#!/usr/bin/env bash
# macos/_helpers.sh — Shared helper library for macOS defaults modules.
# Source this file at the top of each domain module.
#
# NSGlobalDomain Ownership Map (which module owns which key):
# keyboard.sh: ApplePressAndHoldEnabled, KeyRepeat, InitialKeyRepeat, AppleKeyboardUIMode,
#              NSAutomaticCapitalizationEnabled, NSAutomaticDashSubstitutionEnabled,
#              NSAutomaticPeriodSubstitutionEnabled, NSAutomaticQuoteSubstitutionEnabled,
#              NSAutomaticSpellingCorrectionEnabled,
#              com.apple.mouse.tapBehavior, com.apple.swipescrolldirection
# general_ux.sh: NSTableViewDefaultSizeMode, NSUseAnimatedFocusRing, NSScrollAnimationEnabled,
#                NSWindowResizeTime, NSNavPanelExpandedStateForSaveMode, NSNavPanelExpandedStateForSaveMode2,
#                PMPrintingExpandedStateForPrint, PMPrintingExpandedStateForPrint2,
#                NSDocumentSaveNewDocumentsToCloud, NSTextShowsControlCharacters, AppleShowScrollBars,
#                NSQuitAlwaysKeepsWindows (com.apple.systempreferences), NSDisableAutomaticTermination
# locale.sh: AppleLanguages, AppleLocale, AppleMeasurementUnits, AppleMetricUnits
# finder.sh: AppleShowAllExtensions, com.apple.springing.enabled, com.apple.springing.delay
# keyboard.sh (-currentHost): com.apple.mouse.tapBehavior, com.apple.trackpad.*

# Global state
DRY_RUN="${DRY_RUN:-0}"
FRESH_INSTALL="${FRESH_INSTALL:-0}"
_APPLY_COUNT=0
_SKIP_COUNT=0
_FAIL_COUNT=0

# Color codes
_GREEN='\033[0;32m'
_YELLOW='\033[0;33m'
_RED='\033[0;31m'
_BLUE='\033[0;34m'
_RESET='\033[0m'

# ---------------------------------------------------------------------------
# Logging helpers (output to stderr)
# ---------------------------------------------------------------------------

log_info()    { printf "${_BLUE}[INFO]${_RESET} %s\n"    "$*" >&2; }
log_warn()    { printf "${_YELLOW}[WARN]${_RESET} %s\n"  "$*" >&2; }
log_error()   { printf "${_RED}[ERROR]${_RESET} %s\n"    "$*" >&2; }
log_success() { printf "${_GREEN}[OK]${_RESET} %s\n"     "$*" >&2; }

# ---------------------------------------------------------------------------
# set_default domain key type value... [# description]
#
# Wraps `defaults write`. Supports all type flags: -bool, -int, -float,
# -string, -array, -dict-add, etc.
#
# Usage:
#   set_default com.apple.dock tilesize -int 36 "Dock tile size"
#   set_default NSGlobalDomain AppleLanguages -array "en" "th" "Languages"
# ---------------------------------------------------------------------------
set_default() {
  local domain="$1" key="$2" type="$3"
  shift 3
  # Last arg may be a description (we strip it only for display; all remaining
  # args are passed as the value to defaults write).
  # Simple heuristic: if called with a trailing description it is the caller's
  # responsibility to structure the call correctly. We pass "$@" as the value.
  local desc="$domain › $key"

  if [[ "$DRY_RUN" == "1" ]]; then
    printf "${_YELLOW}[DRY-RUN]${_RESET} Would set: %s %s %s %s\n" \
      "$domain" "$key" "$type" "$*" >&2
    _SKIP_COUNT=$(( _SKIP_COUNT + 1 ))
    return 0
  fi

  if defaults write "$domain" "$key" "$type" "$@"; then
    log_success "Set $desc"
    _APPLY_COUNT=$(( _APPLY_COUNT + 1 ))
  else
    log_error "Failed to set $desc"
    _FAIL_COUNT=$(( _FAIL_COUNT + 1 ))
  fi
}

# ---------------------------------------------------------------------------
# set_default_currenthost domain key type value...
# ---------------------------------------------------------------------------
set_default_currenthost() {
  local domain="$1" key="$2" type="$3"
  shift 3
  local desc="-currentHost $domain › $key"

  if [[ "$DRY_RUN" == "1" ]]; then
    printf "${_YELLOW}[DRY-RUN]${_RESET} Would set (currentHost): %s %s %s %s\n" \
      "$domain" "$key" "$type" "$*" >&2
    _SKIP_COUNT=$(( _SKIP_COUNT + 1 ))
    return 0
  fi

  if defaults -currentHost write "$domain" "$key" "$type" "$@"; then
    log_success "Set $desc"
    _APPLY_COUNT=$(( _APPLY_COUNT + 1 ))
  else
    log_error "Failed to set $desc"
    _FAIL_COUNT=$(( _FAIL_COUNT + 1 ))
  fi
}

# ---------------------------------------------------------------------------
# set_default_sudo path key type value...
#
# For system-level plist paths (e.g. /Library/Preferences/...).
# Requires an active sudo session (managed by apply.sh).
# ---------------------------------------------------------------------------
set_default_sudo() {
  local path="$1" key="$2" type="$3"
  shift 3
  local desc="sudo $path › $key"

  if [[ "$DRY_RUN" == "1" ]]; then
    printf "${_YELLOW}[DRY-RUN]${_RESET} Would set (sudo): %s %s %s %s\n" \
      "$path" "$key" "$type" "$*" >&2
    _SKIP_COUNT=$(( _SKIP_COUNT + 1 ))
    return 0
  fi

  if sudo defaults write "$path" "$key" "$type" "$@"; then
    log_success "Set $desc"
    _APPLY_COUNT=$(( _APPLY_COUNT + 1 ))
  else
    log_error "Failed to set $desc"
    _FAIL_COUNT=$(( _FAIL_COUNT + 1 ))
  fi
}

# ---------------------------------------------------------------------------
# set_plistbuddy plist_path keypath type value [description]
#
# Wraps PlistBuddy with a Set→Add fallback for fresh Macs.
# ---------------------------------------------------------------------------
set_plistbuddy() {
  local plist="$1" keypath="$2" type="$3" value="$4"
  local desc="${5:-$plist › $keypath}"

  if [[ "$DRY_RUN" == "1" ]]; then
    printf "${_YELLOW}[DRY-RUN]${_RESET} Would set PlistBuddy: %s %s = %s\n" \
      "$plist" "$keypath" "$value" >&2
    _SKIP_COUNT=$(( _SKIP_COUNT + 1 ))
    return 0
  fi

  # Attempt Set first (key already exists)
  if /usr/libexec/PlistBuddy -c "Set $keypath $value" "$plist" 2>/dev/null; then
    log_success "PlistBuddy Set $desc"
    _APPLY_COUNT=$(( _APPLY_COUNT + 1 ))
    return 0
  fi

  # Fallback: Add (key path does not exist yet — fresh Mac)
  if /usr/libexec/PlistBuddy -c "Add $keypath $type $value" "$plist" 2>/dev/null; then
    log_success "PlistBuddy Add $desc"
    _APPLY_COUNT=$(( _APPLY_COUNT + 1 ))
    return 0
  fi

  # Both failed
  log_warn "PlistBuddy could not Set or Add: $desc"
  _FAIL_COUNT=$(( _FAIL_COUNT + 1 ))
}

# ---------------------------------------------------------------------------
# os_version_at_least <major>
#
# Returns 0 (true) if the current macOS major version >= the given version.
# Example: os_version_at_least 14 && echo "Sonoma or later"
# ---------------------------------------------------------------------------
os_version_at_least() {
  local required="$1"
  local current
  current="$(sw_vers -productVersion | cut -d. -f1)"
  [[ "$current" -ge "$required" ]]
}

# ---------------------------------------------------------------------------
# require_sudo
#
# Verifies that an active sudo session exists (non-interactively).
# Returns 1 if no sudo session is active.
# ---------------------------------------------------------------------------
require_sudo() {
  if ! sudo -n true 2>/dev/null; then
    log_error "No active sudo session. Run apply.sh to manage sudo elevation."
    return 1
  fi
}

# ---------------------------------------------------------------------------
# print_summary
#
# Prints a summary of applied/skipped/failed settings.
# ---------------------------------------------------------------------------
print_summary() {
  printf "\n%s\n" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  printf "  Applied:  %s\n" "$_APPLY_COUNT"
  printf "  Skipped (dry-run): %s\n" "$_SKIP_COUNT"
  printf "  Failed:   %s\n" "$_FAIL_COUNT"
  printf "%s\n\n" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}
