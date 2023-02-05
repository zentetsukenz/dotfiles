set -x -g LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

set -x -g TERM "xterm-256color"

# Explicitly set Homebrew path
set -x -g PATH /opt/homebrew/bin $PATH

# Setting up TTY for GPG
set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Fish
set -U fisher_copy true

# Shell
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US
set -gx LC_TIME en_US.UTF-8

# ncurses
fish_add_path /opt/homebrew/opt/ncurses/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/ncurses/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/ncurses/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/ncurses/lib/pkgconfig"

# PHP Dependencies
fish_add_path /opt/homebrew/opt/bison/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/bison/lib"

fish_add_path /opt/homebrew/opt/libiconv/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/libiconv/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/libiconv/include"

# Fish fzf
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_COMPLETE 1

# asdf
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Rust
set -x -g PATH $HOME/.cargo/bin $PATH

# Erlang
# Always build Erlang documents
set -gx KERL_BUILD_DOCS yes

# Elixir
# Enable iex shell history
set -gx ERL_AFLAGS "-kernel shell_history enabled"

# Python
set -x -g PATH $HOME/.local/bin $PATH
set -x -g PIPENV_VENV_IN_PROJECT 1

# Bob the fish theme
set -g theme_display_k8s_context yes
set -g theme_display_k8s_namespace yes

if [ -f $HOME/.config/fish/config-extension.fish ]; if type source > /dev/null; source $HOME/.config/fish/config-extension.fish; end; end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc' ]; if type source > /dev/null; source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'; else; . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'; end; end
