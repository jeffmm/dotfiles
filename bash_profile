
export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=vim
export VISUAL=vim
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export GPG_TTY=$(tty)
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/sbin:$PATH
export PATH=/opt/homebrew/bin:$HOME/.local/bin:$PATH
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

if [ ! -f ~/.config/nvim/init.vim ]; then
    mkdir -p ~/.config/nvim
    if [ -f ~/.nvim_init ]; then
        ln -s ~/.nvim_init ~/.config/nvim/init.vim
    fi
fi

if [ ! -f ~/.config/nvim/coc-settings.json ]; then
    if [ -f ~/.coc-settings.json ]; then
        ln -s ~/.coc-settings.json ~/.config/nvim/coc-settings.json
    fi
fi

if [ ! -f ~/.vim/coc-settings.json ]; then
    mkdir -p ~/.vim
    if [ -f ~/.coc-settings.json ]; then
        ln -s ~/.coc-settings.json ~/.vim/coc-settings.json
    fi
fi

# Timezones
export TZ=America/Denver
if [ ! -f ~/.timezone ]; then
    # Check if we need sudo (not on a docker container)
    if $(command -v sudo &> /dev/null); then
        sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
        if [ ! "$(uname)" = "Darwin" ]; then
            sudo sh -c "echo $TZ > /etc/timezone"
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
if [ ! -d ~/.vim/snips ] && [ -d ~/.rc4me/jeffmm_dotfiles/snips ]; then
    ln -s ~/.rc4me/jeffmm_dotfiles/snips ~/.vim/snips
fi

if [ ! -d ~/.config/nvim/snips ] && [ -d ~/.rc4me/jeffmm_dotfiles/snips ]; then
    ln -s ~/.rc4me/jeffmm_dotfiles/snips ~/.config/nvim/snips
fi
