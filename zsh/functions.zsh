#!/bin/zsh

# pretty JSON
function pj() {
  python -mjson.tool
}

# Quick and dirty encryption
function encrypt() {
    openssl des3 -a -in $1 -out $1.des3
}

function decrypt() {
    openssl des3 -d -a -in $1 -out ${1%.des3}
}

function md() {
  mkdir $1
  cd $1
}

function f() {
  find . -name "$1"
}


function lepasta {
  ~/.dotfiles/bin/pastee.py $1 | pbcopy;
  if [[ "$OSTYPE" =~ darwin ]]; then
    /usr/local/bin/growlnotify -n lepasta -t lepasta -m `pbpaste`
  fi
}

# Gentoo only functions
if `type emerge >/dev/null 2>&1`; then
  up() {
    case $@ in
      fixdeps)
        sudo revdep-rebuild -pqi
        ;;
      config)
        sudo dispatch-conf
        ;;
      pretend)
        sudo emerge --verbose --quite --pretend --update --newuse --deep world
        ;;
      go)
        sudo emerge --verbose --quite --update --newuse --deep world
        ;;
      *)
        sudo emerge --verbose --quite --ask --update --newuse --deep world
        ;;
    esac
  }
fi

# OS X only functions
if [[ "$OSTYPE" =~ darwin ]]; then
  function manp() {
    man -t "${1}" | open -f -a Skim
  }

  function sis() {
    $* | enscript -p - | open -f -a Skim
  }

  function growl() { 
    growlnotify -t zsh-reminder -m ${1}
    return 
  }

  function dl() {
    for i in $*; do
      echo "Downloading:" $1
      curl -OC -i $1
    done
  }
fi

test $SSH_AUTH_SOCK && ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
