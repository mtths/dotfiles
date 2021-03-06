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

cd ~/dotfiles

link '.vim/'

#Files
link '.vimrc'
link '.bashrc'
link '.tmux.conf'
link '.perltidyrc'
link '.LESS_TERMCAP'

linkbin 'bin/tmx'
linkbin 'bin/pc'

cd -

echo "==============="
echo "Dotfiles linked"
echo "==============="
