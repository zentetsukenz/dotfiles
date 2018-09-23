set -x -g LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

set -x -g TERM "xterm-256color"

# Coreutils bin and man folders
set -x -g PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
set -x -g MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH

# Findutils bin and man folders
set -x -g PATH /usr/local/opt/findutils/libexec/gnubin $PATH
set -x -g MANPATH /usr/local/opt/findutils/libexec/gnuman $MANPATH

status --is-interactive; and source (pyenv init -|psub)

if test -e ~/.config/fish/config.fish.local
    source ~/.config/fish/config.fish.local
end

status --is-interactive; and source (rbenv init -|psub)
status --is-interactive; and source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
