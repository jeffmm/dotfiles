# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme setting - Powerlevel10k is highly customizable and works well with dev workflows
ZSH_THEME="powerlevel10k/powerlevel10k"

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Vim mode configuration
bindkey -v  # Enable vim mode
export KEYTIMEOUT=1  # Reduce mode switch delay

# Keep some emacs bindings in vim mode for convenience
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Plugins
plugins=(
    git
    docker
    docker-compose
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    python
    pip
    virtualenv
    brew
)

source $ZSH/oh-my-zsh.sh

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always {}'"

# Load global aliases
[[ ! -f ~/.bash_aliases ]] || source ~/.bash_aliases

# Load local/private definitions
[[ ! -f ~/.bash_local ]] || source ~/.bash_local

# Custom key bindings for fzf integration
bindkey '^f' fzf-file-widget
bindkey '^r' fzf-history-widget

# Directory navigation
setopt AUTO_PUSHD           # Push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT        # Do not print the directory stack after pushd or popd

# Completion configuration
zstyle ':completion:*' menu select  # Enable menu-style completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case-insensitive completion


# Load Powerlevel10k config if it exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
