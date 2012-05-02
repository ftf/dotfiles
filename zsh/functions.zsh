#!/bin/zsh

function manp() {
  man -t "${1}" | open -f -a Skim
}

# pretty JSON
function pj() {
  python -mjson.tool
}

function sis() {
  $* | enscript -p - | open -f -a Skim
}

function dl() {
  for i in $*; do
    echo "Downloading:" $1
    curl -OC -i $1
  done
}

# Quick and dirty encryption
function encrypt() {
    openssl des3 -a -in $1 -out $1.des3
}

function decrypt() {
    openssl des3 -d -a -in $1 -out ${1%.des3}
}

function mkcd() {
  mkdir $1
  cd $1
}

function growl() { 
  growlnotify -t zsh-reminder -m ${1}
  return 
}

function lepasta {
  ~/.dotfiles/bin/pastee.py $1 | pbcopy;
  /usr/local/bin/growlnotify -n lepasta -t lepasta -m `pbpaste`
}

test $SSH_AUTH_SOCK && ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
