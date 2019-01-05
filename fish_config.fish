set -x -g LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

set -x -g TERM "xterm-256color"

# Coreutils bin and man folders
set -x -g PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
set -x -g MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH

# Findutils bin and man folders
set -x -g PATH /usr/local/opt/findutils/libexec/gnubin $PATH
set -x -g MANPATH /usr/local/opt/findutils/libexec/gnuman $MANPATH

# Fish
set -g fish_user_paths "/usr/local/opt/icu4c/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/icu4c/sbin" $fish_user_paths
set -U fisher_copy true

# Rust
set -x -g PATH $HOME/.cargo/bin $PATH

# Python
status --is-interactive; and source (pyenv init -|psub)

# Ruby
status --is-interactive; and source (rbenv init -|psub)

# Erlang
status --is-interactive; and . "$HOME/kerl/21.2/activate.fish"

# Elixir
status --is-interactive; and source "$HOME/.kiex/scripts/kiex.fish"

# Go
set -x -g PATH $HOME/go/bin $PATH

# GCP
status --is-interactive; and source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
