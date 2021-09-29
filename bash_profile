
export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=vim
export VISUAL=vim
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export GPG_TTY=$(tty)
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/sbin:$PATH
export TZ=America/Denver
PS1="\u:\W$ "

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi

if $(command -v terraform &> /dev/null); then
    complete -C /usr/local/bin/terraform terraform
fi

if [ ! -f ~/.vim/coc-settings.json ]; then
    mkdir -p ~/.vim
    if [ -f ~/.coc-settings.json ]; then
        cp ~/.coc-settings.json ~/.vim/coc-settings.json
    fi
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

# Import my vim snippets if using rc4me (TODO: add rc4me directory compatibility)
if [ ! -f ~/.vim/snips/python.snippets ] && [ -d ~/.rc4me/jeffmm_dotfiles/snips ]; then
    if [ -d ~/.vim/snips ]; then
        cp ~/.rc4me/jeffmm_dotfiles/snips/* ~/.vim/snips
    else
        cp -r ~/.rc4me/jeffmm_dotfiles/snips ~/.vim/snips
    fi
fi
