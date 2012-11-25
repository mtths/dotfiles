#!/bin/bash

function link {
    ln -s "`pwd`/$1" ~/
}

function linkbin {
    ln -s "`pwd`/$1" ~/bin
}


#Directories
test -d ~/.config || mkdir ~/.config/
test -d ~/bin || mkdir ~/bin

link '.vim/'

#Files
link '.vimrc'
link '.bashrc'
link '.tmux.conf'

linkbin 'bin/tmx'

echo "==============="
echo "Dotfiles linked"
echo "==============="
