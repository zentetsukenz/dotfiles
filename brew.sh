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
brew cask install iterm2
brew install neovim/neovim/neovim
brew install grep
brew install openssh
brew install tmux
brew install gpg

# Install shell
brew install fish
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
if ! grep -Fxq "/usr/local/bin/fish" /etc/shells ; then
  echo /usr/local/bin/fish | sudo tee -a /etc/shells
  chsh -s /usr/local/bin/fish
fi

# Install other useful binaries.
brew install ag
brew install git
brew install git-lfs
brew install imagemagick --with-webp
brew install lua
brew install p7zip
brew install pigz
brew install rename
brew install speedtest_cli
brew install testssl
brew install tree
brew install ctags
brew install reattach-to-user-namespace
brew install cmake

# Remove outdated versions from the cellar.
brew cleanup
