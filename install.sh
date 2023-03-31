cp zshrc ~/.zshrc
cp bash_profile ~/.bash_profile
cp bash_aliases ~/.bash_aliases
cp gitconfig ~/.gitconfig
cp vimrc ~/.vimrc
shell=basename $SHELL
if [ $shell = "bash" ]; then
    source ~/.bash_profile
elif [ $shell = "zsh" ]; then
    source ~/.zshrc
else
    source ~/.bash_aliases
fi
