source ~/.antigen.zsh

antigen bundle brew
antigen bundle common-aliases
antigen bundle docker
antigen bundle git
antigen bundle pip

antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# User configuration

# Enable colors and change prompt:

export EDITOR=vim
export VISUAL=vim
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export GPG_TTY=$(tty)
export GOPATH=$HOME/go
export PATH=$HOME/.local/bin:$GOPATH/bin:/usr/local/sbin:$PATH

autoload -U colors && colors
PS1="%B%{$fg[black]%}<%B%{$fg[red]%}${HOSTNAME:-$(hostname -f)}%B%{$fg[black]%}>%{$fg[magenta]%}[%{$fg[blue]%}%~%{$fg[magenta]%}]%{$reset_color%}$%b "
# History in cache directory:
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE=~/.cache/zsh/history
if [ ! -d ~/.cache/zsh ]; then
		mkdir -p ~/.cache/zsh
fi

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey "^R" history-incremental-search-backward

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

autoload -U +X bashcompinit && bashcompinit
#
# Load zsh-syntax-highlighting; should be last.
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi

complete -o nospace -C /usr/local/bin/terraform terraform
if $(command -v terraform &> /dev/null); then
    complete -C /usr/local/bin/terraform terraform
fi

# Timezones
export TZ=America/Denver
if [ ! -f ~/.timezone ]; then
    # Check if we need sudo (not on a docker container)
    if $(command -v sudo &> /dev/null); then
        sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
        if [ ! "$(uname)" = "Darwin" ]; then
            sudo echo $TZ > /etc/timezone
        fi
    else
        ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
        if [ ! "$(uname)" = "Darwin" ]; then
            echo $TZ > /etc/timezone
        fi
    fi
    echo $TZ > ~/.timezone
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
