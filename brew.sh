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
brew install neovim
brew install ripgrep
brew install openssh
brew install tmux
brew install gpg
brew install fzf

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
curl https://sh.rustup.rs -sSf | sh

# Install other useful binaries.
brew install git
brew install git-lfs
brew install tree
brew install reattach-to-user-namespace
brew install cmake

# Install kubectl krew plugin
begin
  set -x; set temp_dir (mktemp -d); cd "$temp_dir" &&
  set OS (uname | tr '[:upper:]' '[:lower:]') &&
  set ARCH (uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/') &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  set KREWNAME krew-$OS"_"$ARCH &&
  ./$KREWNAME install krew &&
  set -e KREWNAME; set -e temp_dir
end

# Remove outdated versions from the cellar.
brew cleanup
