set -x -g LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

set -x -g TERM "xterm-256color"

# Coreutils bin and man folders
set -x -g PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
set -x -g MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH

# Findutils bin and man folders
set -x -g PATH /usr/local/opt/findutils/libexec/gnubin $PATH
set -x -g MANPATH /usr/local/opt/findutils/libexec/gnuman $MANPATH

# Setting up TTY for GPG
set -x -g GPG_TTY (tty)
set -x -g SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye

# Fish
set -g fish_user_paths "/usr/local/opt/icu4c/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/icu4c/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -U fisher_copy true

# ncurses
set -g fish_user_paths "/usr/local/opt/ncurses/bin" $fish_user_paths
set -gx LDFLAGS "-L/usr/local/opt/ncurses/lib"
set -gx CPPFLAGS "-I/usr/local/opt/ncurses/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/ncurses/lib/pkgconfig"

# PHP Dependencies
fish_add_path /usr/local/opt/bison/bin
fish_add_path /usr/local/opt/libiconv/bin

# Fish fzf
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_COMPLETE 1

# asdf
source /usr/local/opt/asdf/libexec/asdf.fish

# Rust
set -x -g PATH $HOME/.cargo/bin $PATH

# Erlang
# Always build Erlang documents
set -gx KERL_BUILD_DOCS yes

# Elixir
# Enable iex shell history
set -gx ERL_AFLAGS "-kernel shell_history enabled"

# Bob the fish theme
set -g theme_display_k8s_context yes
set -g theme_display_k8s_namespace yes

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc' ]; if type source > /dev/null; source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'; else; . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'; end; end
