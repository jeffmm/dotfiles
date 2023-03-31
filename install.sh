#!/bin/bash

cp zshrc ~/.zshrc
cp bash_profile ~/.bash_profile
cp bash_aliases ~/.bash_aliases
cp gitconfig ~/.gitconfig
cp vimrc ~/.vimrc
shell=$(basename $SHELL)
if [[ $shell == "bash" ]]; then
    source ~/.bash_profile
    source ~/.bash_aliases
elif [[ $shell == "zsh" ]]; then
    source ~/.zshrc
    source ~/.bash_aliases
else
    source ~/.bash_aliases
fi
