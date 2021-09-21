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
brew install autoconf

# Install fishshell
brew install fish
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
if ! grep -Fxq "/usr/local/bin/fish" /etc/shells ; then
  echo /usr/local/bin/fish | sudo tee -a /etc/shells
  chsh -s /usr/local/bin/fish
fi

# Install other useful binaries.
brew install git
brew install git-lfs
brew install tree
brew install reattach-to-user-namespace
brew install cmake
brew install bison
brew install re2c
brew install libgd
brew install libiconv
brew install oniguruma
brew install libzip

# Language specific
brew install asdf
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin-add php https://github.com/asdf-community/asdf-php.git
asdf plugin-add nodejs
asdf plugin-add python
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Remove outdated versions from the cellar.
brew cleanup
