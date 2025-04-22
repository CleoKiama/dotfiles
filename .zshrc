# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# -------------------------
# Zinit plugin manager setup
# -------------------------
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
#source/load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# ZSH Vi Mode plugin
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Load completions
autoload -Uz compinit && compinit

# Add in snippets from Oh My Zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# -------------------------
# Terminal settings
# -------------------------
alias grep='grep --color=auto'
export COLORTERM=truecolor

# -------------------------
# Node Version Manager
# -------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# -------------------------
# Package manager configuration
# -------------------------
# Define AUR helper for package management aliases
export aurhelper="yay"  # Change to your preferred AUR helper (yay, paru, etc.)

# -------------------------
# Aliases
# -------------------------
# Terminal operations
alias c='clear' # clear terminal

# Modern file listing with eza
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree

# Package management
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list available package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -

# Applications
alias vc='code' # gui code editor

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# -------------------------
# Keybindings
# -------------------------
# bindkey -e  #emacs keybinds
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# -------------------------
# History configuration
# -------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# -------------------------
# Completion styling
# -------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' #auto complete lowercase
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# -------------------------
# Path and environment settings
# -------------------------
# Editor configuration
export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"

# Bun JavaScript runtime
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# PNPM package manager
export PNPM_HOME="/home/cleo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Rust environment
. "$HOME/.cargo/env"

# -------------------------
# File manager integration
# -------------------------
# Yazi file manager with directory tracking
function yazi_cd() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
alias y="yazi_cd"  # Keep the short alias but use descriptive function name

# -------------------------
# Completions
# -------------------------
# Bun completions
[ -s "/home/cleo/.bun/_bun" ] && source "/home/cleo/.bun/_bun"

# -------------------------
# ZSH Vi Mode Configuration
# -------------------------
# Setting 'jj' as the escape key sequence in insert mode
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

# -------------------------
# Shell integrations and tools
# -------------------------
eval "$(fzf --zsh)"
eval "$(zoxide init zsh --cmd cd)" #better cd
eval "$(starship init zsh)" #starship

# -------------------------
# Powerlevel10k theme configuration
# -------------------------
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

