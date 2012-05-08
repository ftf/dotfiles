#!/usr/bin/env  bash 

# The MIT License (MIT)
# Copyright (c) 2012 Fabian Franke http://fabianfranke.de

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
COLORRESET="\033[0m"
SPACER="   "
packfilename='privdots'

function install() {
  backupall=false
  deleteall=false
  skipall=false
  backupdir=${PWD}/backup

  if [ ! -z $1 ]; then
    prefix=$1
  fi
  
  if ls $prefix*.symlink >/dev/null 2>&1; then
    echo -e "$GREEN-$COLORRESET found some .symlink files, starting symlinking"
  else
    echo -e "$RED-$COLORRESET found no .symlink files, nothing to do"
    exit
  fi

  for file in $prefix*.symlink; do

    target="$HOME/.`basename ${file%.*}`"
    purefilename=`basename ${file%.*}`

    if [ $file == "" ]; then
      echo empty file!
    fi
    
    if [ "`readlink $target`" ==  "${PWD}/$file" ]; then
      continue
    fi

    if [ -e "$target" ]; then
      if $backupall ; then
        echo -e "$SPACER$YELLOW-$COLORRESET moving $target to backup"
        mv $target $backupdir/
        echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
        ln -s ${PWD}/$file $target
      elif $deleteall ; then
        echo -e "$SPACER$RED-$COLORRESET deleting existing $target"
        rm -r $target
        echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
        ln -s ${PWD}/$file $target
      elif $skipall ; then
        echo -e "$SPACER$YELLOW-$COLORRESET skipping ${file%.*}"
      else
        echo "$target exists. What to do? (b)ackup, (d)elete, (s)kip. Or for this and further existing files (B)ackup, (S)kip, (D)elete"
        read filedecision
        case $filedecision in
         b)
           echo -e "$SPACER$YELLOW-$COLORRESET moving $target to .dotfiles/backup/.$purefilename"
           mv $target $backupdir/
           echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
           ln -s ${PWD}/$file $target
           ;;
         B)
           echo backup all
           backupall=true
           echo -e "$SPACER$YELLOW-$COLORRESET moving $target to .dotfiles/backup/.$purefilename"
           mv $target $backupdir/
           echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
           ln -s ${PWD}/$file $target
           ;;
         d)
           echo -e "$SPACER$RED-$COLORRESET deleting $target"
           rm -r $target
           echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
           ln -s ${PWD}/$file $target
           ;;
         D)
           echo deleting all
           deleteall=true
           echo -e "$SPACER$RED-$COLORRESET deleting $target"
           rm -r $target
           echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
           ln -s ${PWD}/$file $target
           ;;
         s)
           echo -e "$SPACER$YELLOW-$COLORRESET skipping ${file%.*}"
           continue
           ;;
         S)
           echo skipping all
           skipall=true
           echo -e "$SPACER$YELLOW-$COLORRESET skipping ${file%.*}"
           continue
           ;;
         *)
           echo -e "$RED-$COLORRESET wrong input, skipping"
           continue
           ;;
       esac
      fi
      
    else 
      echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
      ln -s ${PWD}/$file $target
    fi
  done
}

function uninstall() {

  if [ ! -z $1 ]; then
    prefix=$1
  fi

  for sym in $prefix*.symlink; do
    purefilename=`basename ${sym%.*}`
    target="$HOME/.$purefilename" 
    if [ "`readlink $target`" ==  "${PWD}/$sym" ]; then
      echo -e "$RED-$COLORRESET Deleting $target"
      rm $target
      if [ -e "backup/.$purefilename" ]; then
        echo -e "$SPACER$GREEN+$COLORRESET restoring original file"
        mv backup/.$purefilename $HOME/
      fi
    fi
  done
}

function update() {
  echo -e "$GREEN-$COLORRESET Fetching updates from github"
  git pull >/dev/null
  link
}

function link() {
  echo -e "$GREEN-$COLORRESET Trying to link new files"
  install
}

function installprivatedots() {
  echo -e "$GREEN-$COLORRESET Decrypting, unpacking and linking your private dotfiles"
  if [ -e "$packfilename.des3" ]; then
    openssl des3 -a -d -in $packfilename.des3 -out $packfilename.tbz2 && tar xfj $packfilename.tbz2 && rm $packfilename.tbz2 $packfilename.des3
  else 
    echo -e "$RED-$COLORRESET ERROR: Cannot find transport container."
    echo -e "$SPACER$RED-$COLORRESET It should be named $packfilename.des3"
  fi
  install "privatedots/"
}

function linkprivatedots() {
  echo -e "$GREEN-$COLORRESET Updating links from your private dotfiles"
  install "privatedots/"
}

function packprivatedots() {
  echo -e "$GREEN-$COLORRESET compressing and encrypting private dotfiles"
  echo -e "$SPACER$YELLOW-$COLORRESET prompting for a password in a little while"
  tar -jcf $packfilename.tbz2 privatedots && openssl des3 -a -in $packfilename.tbz2 -out $packfilename.des3 && rm $packfilename.tbz2
  echo
  if [ -e "$packfilename.des3" ]; then
    echo -e "$GREEN-$COLORRESET your private dotfiles are ready at $PWD/$packfilename.des3"
    echo -e "$SPACER Transfer them over to your other installations and run ./installer.sh installprivatedots"
  else
    echo -e "$RED-$COLORRESET something went terribly wrong"
  fi
}

function delprivatedots() {
  echo -e "$SPACER$RED-$COLORRESET unlinking and deleting your private dotfiles from this box"
  echo -e "$SPACER  CTRL+C to abort now"

  echo -en "$RED"
  for i in {1..5}; do
    echo -n .
    sleep 1
  done
  echo -e "$COLORRESET"

  uninstall "privatedots/"
  echo "rm privatedots/*"
}

function vimupdate() {
  if `type git >/dev/null 2>&1`; then
    if [ `git submodule | wc -l | awk '{ print $1; }'` -eq 0 ]; then
      git submodule init
    fi

    git submodule update
    cd vim.symlink && git checkout master && git pull origin master && rake
    cd ..
  else
    echo -e "$RED-$COLORRESET you need git installed to use this function"
  fi
}

function usage() {
  cat << EOF
How to use this:

./install.sh install
  Symlink dotfiles to the home directory

./install.sh uninstall
  Remove all dotfile symlinks from home directory and restore from backup if possible

./install.sh update
  Fetch updates from the repository and update symlinks if needed

./install.sh link
  Update symlinks if needed

./install.sh privatedots install
  Decrypt and unpack your private dotfiles and install them at this computer

./install.sh privatedots link
  Link newly added private dotfiles to your home directory

./install.sh privatedots pack
  Encrypt and pack your private dotfiles to transfer them to another box

./install.sh privatedots delete
  Delete your private dotfiles from this computer

./install.sh vimupdate
Initialize or update the janus vim distribution  (also update or install 
new vim plugins inside .janus.symlink)

EOF
}

case $1 in
  install)
    install
    ;;
  uninstall)
    uninstall
    ;;
  link)
    link
    ;;
  update)
    update
    ;;
  privatedots)
    case $2 in
      pack)
        packprivatedots
        ;;
      install)
        installprivatedots
        ;;
      link)
        linkprivatedots
        ;;
      delete)
        deleteprivatedots
        ;;
      *)
        usage
        ;;
    esac
    ;;
  vimupdate)
    vimupdate
    ;;
  *)
    usage
    ;;
esac
