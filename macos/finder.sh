#!/usr/bin/env bash
# macos/finder.sh — Finder domain settings.
# Independently runnable: DRY_RUN=1 bash macos/finder.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/_helpers.sh"

log_info "Applying Finder settings..."

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
set_default com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
set_default com.apple.finder DisableAllAnimations -bool true

# Set ~/workspace as the default location for new Finder windows
# BUG FIX: original used PfDe (Desktop); PfLo = custom path
set_default com.apple.finder NewWindowTarget -string "PfLo"
set_default com.apple.finder NewWindowTargetPath -string "file://${HOME}/workspace/"

# Show icons for hard drives, servers, and removable media on the desktop
set_default com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
set_default com.apple.finder ShowHardDrivesOnDesktop -bool true
set_default com.apple.finder ShowMountedServersOnDesktop -bool true
set_default com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
set_default com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
set_default NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
set_default com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
set_default com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
set_default com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
set_default com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
set_default com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
set_default com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
set_default NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
set_default NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
set_default com.apple.desktopservices DSDontWriteNetworkStores -bool true
set_default com.apple.desktopservices DSDontWriteUSBStores -bool true

# Automatically open a new Finder window when a volume is mounted
set_default com.apple.frameworks.diskimages auto-open-ro-root -bool true
set_default com.apple.frameworks.diskimages auto-open-rw-root -bool true
set_default com.apple.finder OpenWindowForNewRemovableDisk -bool true

# PlistBuddy icon view settings — must kill Finder first to avoid cache issues
if [[ "${DRY_RUN:-0}" != "1" ]]; then
  killall Finder 2>/dev/null || true
  sleep 1
fi

FINDER_PLIST="${HOME}/Library/Preferences/com.apple.finder.plist"

# Show item info near icons on the desktop and in other icon views
set_plistbuddy "$FINDER_PLIST" ":DesktopViewSettings:IconViewSettings:showItemInfo" bool true
set_plistbuddy "$FINDER_PLIST" ":FK_StandardViewSettings:IconViewSettings:showItemInfo" bool true
set_plistbuddy "$FINDER_PLIST" ":StandardViewSettings:IconViewSettings:showItemInfo" bool true

# Show item info to the right of the icons on the desktop
set_plistbuddy "$FINDER_PLIST" "DesktopViewSettings:IconViewSettings:labelOnBottom" bool false

# Enable snap-to-grid for icons on the desktop and in other icon views
set_plistbuddy "$FINDER_PLIST" ":DesktopViewSettings:IconViewSettings:arrangeBy" string grid
set_plistbuddy "$FINDER_PLIST" ":FK_StandardViewSettings:IconViewSettings:arrangeBy" string grid
set_plistbuddy "$FINDER_PLIST" ":StandardViewSettings:IconViewSettings:arrangeBy" string grid

# Increase grid spacing for icons on the desktop and in other icon views
set_plistbuddy "$FINDER_PLIST" ":DesktopViewSettings:IconViewSettings:gridSpacing" real 100
set_plistbuddy "$FINDER_PLIST" ":FK_StandardViewSettings:IconViewSettings:gridSpacing" real 100
set_plistbuddy "$FINDER_PLIST" ":StandardViewSettings:IconViewSettings:gridSpacing" real 100

# Increase the size of icons on the desktop and in other icon views
set_plistbuddy "$FINDER_PLIST" ":DesktopViewSettings:IconViewSettings:iconSize" real 80
set_plistbuddy "$FINDER_PLIST" ":FK_StandardViewSettings:IconViewSettings:iconSize" real 80
set_plistbuddy "$FINDER_PLIST" ":StandardViewSettings:IconViewSettings:iconSize" real 80

# Use list view in all Finder windows by default
set_default com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Enable the warning before emptying the Trash
set_default com.apple.finder WarnOnEmptyTrash -bool true

# Enable AirDrop over Ethernet and on unsupported Macs
set_default com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
if [[ "${DRY_RUN:-0}" != "1" ]]; then
  sudo chflags nohidden ~/Library
  log_success "Unhidden ~/Library"
else
  log_info "[DRY-RUN] Would run: sudo chflags nohidden ~/Library"
fi

# Show the /Volumes folder
if [[ "${DRY_RUN:-0}" != "1" ]]; then
  sudo chflags nohidden /Volumes
  log_success "Unhidden /Volumes"
else
  log_info "[DRY-RUN] Would run: sudo chflags nohidden /Volumes"
fi

# Expand the following File Info panes: General, Open with, and Sharing & Permissions
if [[ "${DRY_RUN:-0}" != "1" ]]; then
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true
  log_success "Set FXInfoPanesExpanded"
else
  log_info "[DRY-RUN] Would set FXInfoPanesExpanded -dict General/OpenWith/Privileges"
fi

