#!/bin/zsh

export DISPLAY=:0.0
export LANG="de_DE.UTF-8"

#for the output without escape sequences
export LESS="-erX"  

export EDITOR=vim

if [ -x /usr/libexec/path_helper ]; then
   PATH=""
   eval `/usr/libexec/path_helper -s`
fi

export PATH=/usr/local/sbin:/usr/local/bin:~/.dotfiles/bin:$PATH
#export PYTHONPATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7
export PYTHONPATH=/System/Library/Frameworks/Python.framework/Versions/Current
export PYTHONSTARTUP=~/.pythonrc
