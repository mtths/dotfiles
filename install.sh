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
link '.perltidyrc'

linkbin 'bin/tmx'
linkbin 'bin/pc'

echo "==============="
echo "Dotfiles linked"
echo "==============="
