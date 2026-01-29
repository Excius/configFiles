
# ~/.zshrc for interactive shells

# -------------------------
# Shell options (interactive)
# -------------------------
setopt autocd
setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst
setopt NO_BEEP

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

# Optional: accept autosuggestion with Right-Arrow
# Uncomment if you want Right-Arrow to accept suggestions (may conflict with other completion)
# bindkey '^[[C' autosuggest-accept

# -------------------------
# Minimal completion setup
# -------------------------
autoload -Uz compinit
compinit -C

# -------------------------
# History settings (improved for autosuggestions)
# -------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000

# Make history immediately available to other shells and autosuggestions
setopt INC_APPEND_HISTORY    # append commands to the history file immediately
setopt SHARE_HISTORY         # share history across all sessions
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

alias history="history 0"

# -------------------------
# Prompt configuration
# -------------------------
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

configure_prompt() {
    prompt_symbol=㉿
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

if [ "$color_prompt" = yes ]; then
    VIRTUAL_ENV_DISABLE_PROMPT=1
    configure_prompt
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

precmd() {
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# -------------------------
# ls, less, grep coloring and handy aliases
# -------------------------
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:"

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

# -------------------------
# Autosuggestions & syntax highlighting (order matters!)
# -------------------------
# Set strategy and style BEFORE sourcing the plugin.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=magenta'

# Source autosuggestions first
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Source syntax highlighting last
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f "${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# -------------------------
# Oh-My-Posh prompt
# -------------------------
eval "$(oh-my-posh init zsh --config ~/.poshthemes/my_hunk.omp.json)"

# -------------------------
# FZF defaults
# -------------------------
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'

# -------------------------
# PATH additions
# -------------------------
export PATH="$PATH:/opt/nvim-linux-x86_64/bin" # nvim path
export PATH=/usr/local/node/bin:$PATH # node path
export PATH=$PATH:/usr/local/go/bin # go path
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# -------------------------
# Misc
# -------------------------
# Command-not-found helper
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# Inline autosuggestions only (this is a fallback path check)
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # already sourced above, but keep for compatibility
    :
fi

