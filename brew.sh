#!/usr/bin/env bash

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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
brew cask install alacritty
brew cask install google-cloud-sdk
brew install kubernetes-helm
brew install neovim/neovim/neovim
brew install ripgrep
brew install openssh
brew install tmux
brew install gpg

# Install spacemacs
brew tap d12frosted/emacs-plus
brew install emacs-plus
ln -s /usr/local/Cellar/emacs-plus/26.1/Emacs.app/ /Applications/
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# Install fishshell
brew install fish
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
if ! grep -Fxq "/usr/local/bin/fish" /etc/shells ; then
  echo /usr/local/bin/fish | sudo tee -a /etc/shells
  chsh -s /usr/local/bin/fish
fi

# Language specific
brew install pyenv
brew install rbenv
brew install kerl
if ! [ -e ~/.kiex ] ; then
  curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s
fi

# Install other useful binaries.
brew install git
brew install git-lfs
brew install tree
brew install reattach-to-user-namespace
brew install cmake

# Remove outdated versions from the cellar.
brew cleanup
