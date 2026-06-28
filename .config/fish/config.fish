# -------------------------
# Environment
# -------------------------
set -gx EDITOR nvim
set -gx COLORTERM truecolor
set -gx fish_greeting ""

# Path
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.config/emacs/bin
fish_add_path $HOME/.cargo/bin

# PNPM
set -gx PNPM_HOME $HOME/.local/share/pnpm
fish_add_path $PNPM_HOME

# vi mode
fish_vi_key_bindings

# AUR helper
set -gx aurhelper yay

# SSH agent socket 
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# -------------------------
# Abbreviations (expand in-place, visible in history)
# -------------------------
# Terminal
abbr -a c clear

# Modern file listing with eza
abbr -a l 'eza -lh --icons=auto'
abbr -a ls 'eza -1 --icons=auto'
abbr -a ll 'eza -lha --icons=auto --sort=name --group-directories-first'
abbr -a ld 'eza -lhD --icons=auto'
abbr -a lt 'eza --icons=auto --tree'

# Directory navigation
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .3 'cd ../../..'
abbr -a .4 'cd ../../../..'
abbr -a .5 'cd ../../../../..'

# -------------------------
# Aliases (kept as aliases to override defaults / always apply flags)
# -------------------------
alias mkdir='mkdir -p'
alias grep='grep --color=auto'

# -------------------------
# Shell integrations (guarded against missing binaries)
# -------------------------
# Zoxide (better cd)
command -q zoxide && zoxide init fish --cmd cd | source

# FZF
if command -q fzf
    fzf --fish | source

    # Match zsh fzf-tab muscle memory: open fzf completion on plain TAB,
    # plus Alt+L as an alternate shortcut.
    if functions -q fzf_complete
        bind tab fzf_complete
        bind -M insert tab fzf_complete
        bind alt-l fzf_complete
        bind -M insert alt-l fzf_complete
    end
end

# Atuin
command -q atuin && atuin init fish | source

# Starship prompt
command -q starship && starship init fish | source

# -------------------------
# Keybindings
# -------------------------
# Accept autosuggestion with Alt+l (home row friendly)
bind alt-l forward-char
bind -M insert alt-l forward-char

# -------------------------
# Yazi file manager with directory tracking
# -------------------------
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file=$tmp
    if set cwd (command cat -- $tmp); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- $cwd
    end
    rm -f -- $tmp
end

# pnpm
set -gx PNPM_HOME "/home/cleo/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
