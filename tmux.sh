#!/usr/bin/env bash

# Pull TMUX plugin manager repository
if ! [ -e ~/.tmux/plugins/tpm ]
then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
