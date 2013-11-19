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

export PATH=/usr/local/sbin:/usr/local/bin:~/.dotfiles/bin:$PATH
#export PYTHONPATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7
export PYTHONPATH=~/.python/PYTHONPATH #/usr/local/lib/python3.3/site-packages:/usr/local/lib/python2.7/site-packages:/System/Library/Frameworks/Python.framework/Versions/Current
export PYTHONSTARTUP=~/.pythonrc

# for gpg curses gui
export GPG_TTY=`tty`

# osx only vars
if [[ "$OSTYPE" =~ darwin ]]; then
    # set default virsh connect uri for tesserakt
    export VIRSH_DEFAULT_CONNECT_URI='qemu+ssh://tesserakt/system?socket=/var/run/libvirt/libvirt-sock'
    if [[ -a  /usr/local/opt/curl-ca-bundle/share/ca-bundle.crt ]]; then
      export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
    fi
fi
