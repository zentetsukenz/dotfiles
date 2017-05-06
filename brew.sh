#!/usr/bin/env bash

# sudo is needed to install cask
sudo -v

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen

# Install shell
brew install fish

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install dns2tcp
brew install foremost
brew install nmap
brew install sqlmap
brew cask install xquartz
brew install xpdf
brew install xz

# Install other useful binaries.
brew install ack
brew install dark-mode
brew install git
brew install git-lfs
brew install imagemagick --with-webp
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install speedtest_cli
brew install testssl
brew install tree
brew install vbindiff
brew install webkit2png
brew install zopfli
brew install ctags
brew install reattach-to-user-namespace

# Remove outdated versions from the cellar.
brew cleanup
