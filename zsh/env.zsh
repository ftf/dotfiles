#!/bin/zsh

export DISPLAY=:0.0
export LANG="en_US.UTF-8"
#export LC_ALL="en_US.UTF-8"

#for the output without escape sequences
export LESS="-erX"

export EDITOR=vim

if [ -x /usr/libexec/path_helper ]; then
   PATH=""
   eval `/usr/libexec/path_helper -s`
fi

export PATH=~/.dotfiles/bin:/usr/local/sbin:/usr/local/bin:$PATH

[ -d ~/.composer/vendor/bin ] && export PATH=~/.composer/vendor/bin:$PATH
[ -d ~/.node/bin ] && export PATH=~/.node/bin:$PATH
[ -d ~/.cargo/bin ] && export PATH=~/.cargo/bin:$PATH
[ -d /usr/local/opt/ruby/bin ] && export PATH=/usr/local/opt/ruby/bin:$PATH

if `type gem >/dev/null 2>&1`; then
  RUBYBINPATH=`gem env | grep "EXECUTABLE DIRECTORY" | awk  '{ print $4 }'`
  export PATH=$RUBYBINPATH:$PATH
fi

#export PYTHONPATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7
#export PYTHONPATH=~/.python/PYTHONPATH #/usr/local/lib/python3.3/site-packages:/usr/local/lib/python2.7/site-packages:/System/Library/Frameworks/Python.framework/Versions/Current
export PYTHONSTARTUP=~/.pythonrc

# for gpg curses gui
export GPG_TTY=`tty`
