# === Homebrew ===
set -x -g PATH /opt/homebrew/bin $PATH

# === Shell ===
set -g fish_greeting ""  # Disable default greeting (starship handles prompt)

# Cleanup stale universal vars from old theme/FZF (run once on fresh config load)
set -l _old_theme_ctx (string join '' theme_display_ k8s_context)
if set -q $_old_theme_ctx; set -e $_old_theme_ctx; end
set -l _old_theme_ns (string join '' theme_display_ k8s_namespace)
if set -q $_old_theme_ns; set -e $_old_theme_ns; end

# === GPG/SSH ===
set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# === Locale/Editor ===
set -gx LANG en_US.UTF-8
set -gx EDITOR nvim
set -gx LANGUAGE en_US
set -gx LC_TIME en_US.UTF-8

# === Podman ===
set -gx CONTAINERS_MACHINE_PROVIDER "libkrun"

# === FZF ===
set -gx FZF_LEGACY_KEYBINDINGS 0
set -gx FZF_COMPLETE 1

# === Rust ===
set -x -g PATH $HOME/.cargo/bin $PATH

# === Erlang ===
# Always build Erlang documents
set -gx KERL_BUILD_DOCS yes
set -gx KERL_CONFIGURE_OPTIONS "--disable-jit"

# === Elixir ===
# Enable iex shell history
set -gx ERL_AFLAGS "-kernel shell_history enabled"

# === Python ===
set -x -g PATH $HOME/.local/bin $PATH
set -x -g PIPENV_VENV_IN_PROJECT 1

# === VS Code ===
string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)

# === Runtime Manager ===
if command -q mise; mise activate fish | source; end

# === Prompt ===
if command -q starship; starship init fish | source; end

# === Navigation ===
if command -q zoxide; zoxide init fish | source; end

# === Modern CLI Aliases ===
if command -q eza
    alias ls "eza --icons --group-directories-first"
    alias tree "eza --tree --icons"
end
if command -q bat
    alias cat "bat --paging=never"
end
if command -q btop; alias top "btop"; end
if command -q lazygit; alias lg "lazygit"; end

# === Google Cloud SDK ===
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc' ]; if type source > /dev/null; source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'; else; . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'; end; end

# === pnpm ===
set -gx PNPM_HOME "$HOME/.pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# === Extensions ===
if [ -f $HOME/.config/fish/config-extension.fish ]; if type source > /dev/null; source $HOME/.config/fish/config-extension.fish; end; end

# === PATH: OpenCode ===
fish_add_path $HOME/.opencode/bin

# === PATH: Antigravity ===
fish_add_path $HOME/.antigravity/antigravity/bin
