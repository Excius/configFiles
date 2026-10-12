# ~/.zshrc — interactive Zsh configuration

# -------------------------
# Shell options
# -------------------------
setopt autocd
setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst
setopt NO_BEEP

# Treat / as a word boundary for word-based editing
WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=""

# -------------------------
# Key bindings
# -------------------------
bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo

# Optional: accept autosuggestions with Right Arrow
# bindkey '^[[C' autosuggest-accept

# -------------------------
# History
# -------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=20000

setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY

# -------------------------
# Locale
# -------------------------
export LANG=en_US.UTF-8

# -------------------------
# Environment variables
# -------------------------
export GOPATH="$HOME/go"
export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"

# Keep PATH and Zsh's path array synchronized and unique.
typeset -U path PATH

# Preserve the existing PATH order after adding preferred user tools.
path=(
    "$BUN_INSTALL/bin"
    "$PNPM_HOME/bin"
    "$HOME/.local/bin"
    $path
    "$GOPATH/bin"
)

# -------------------------
# Completion
# -------------------------
autoload -Uz compinit
compinit

# Optional completion behavior
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# -------------------------
# Colors and aliases
# -------------------------
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -r "$HOME/.dircolors" ]]; then
        eval "$(dircolors -b "$HOME/.dircolors")"
    else
        eval "$(dircolors -b)"
    fi

    export LS_COLORS="${LS_COLORS}:ow=30;44"

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'
    export LESS_TERMCAP_md=$'\E[1;36m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;33m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[1;32m'
    export LESS_TERMCAP_ue=$'\E[0m'

    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias n='nvim'
alias lg='lazygit'

# Git shortcuts
alias gc='git commit -m'
alias gp='git push origin HEAD'
alias gr='git rebase'
alias gpu='git pull origin'
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(red)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff='git diff'
alias gco='git checkout'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Applications
alias zed='WAYLAND_DISPLAY="" zed'
alias y='yazi'
alias bat='batcat'
# if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then
#     tmux new-session -A -s dev
# fi
alias t='tmux new-session -A -s dev'

# -------------------------
# Autosuggestions
# -------------------------
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=magenta'

if [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -r "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# -------------------------
# Bun completions
# -------------------------
if [[ -s "$BUN_INSTALL/_bun" ]]; then
    source "$BUN_INSTALL/_bun"
fi

# -------------------------
# FZF
# -------------------------
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'

if (( $+commands[fzf] )); then
    eval "$(fzf --zsh)"
fi

# -------------------------
# Oh My Posh
# -------------------------
if (( $+commands[oh-my-posh] )); then
    eval "$(oh-my-posh init zsh --config "$HOME/.poshthemes/my_hunk.omp.json")"
fi

# -------------------------
# Syntax highlighting — keep last
# -------------------------
if [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -r "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
