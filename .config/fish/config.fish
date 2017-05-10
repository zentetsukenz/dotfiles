if not set -q __fish_prefix_coreutils
    set -g __fish_prefix_coreutils (brew --prefix coreutils)
end

if not set -q __fish_prefix_findutils
    set -g __fish_prefix_findutils (brew --prefix findutils)
end

set -x -g LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

set -x -g TERM "xterm-256color"

# Coreutils bin and man folders
set -x -g PATH $__fish_prefix_coreutils/libexec/gnubin $PATH
set -x -g MANPATH $__fish_prefix_coreutils/libexec/gnuman $MANPATH

# Findutils bin and man folders
set -x -g PATH $__fish_prefix_findutils/libexec/gnubin $PATH
set -x -g MANPATH $__fish_prefix_findutils/libexec/gnuman $MANPATH

if test -e ~/.config/fish/config.fish.local
    source ~/.config/fish/config.fish.local
end
