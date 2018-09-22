#!/usr/bin/env bash

#
# Powerline fonts installation functions
#

function is_powerline_fonts_exist() {
  if ls ~/Library/Fonts/*Powerline.ttf 1> /dev/null 2>&1; then
    return 0;
  else
    return 1;
  fi
}

if ! is_powerline_fonts_exist; then
    rm -rf fonts
    git clone https://github.com/powerline/fonts.git
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
else
    echo "Powerline fonts already exist";
    exit 0;
fi
