#!/bin/bash 

wd=${PWD##*/}
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
COLORRESET="\033[0m"
SPACER="   "

function install() { 
  backupall=false
  deleteall=false
  skipall=false
  backupdir=${PWD}/backup

  for file in *.symlink; do
    target="$HOME/.${file%.*}" 
    
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
           echo -e "$SPACER$YELLOW-$COLORRESET moving $target to .dotfiles/backup/.$file"
           mv $target $backupdir/
           echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
           ln -s ${PWD}/$file $target
           ;;
         B)
           echo backup all
           backupall=true
           echo -e "$SPACER$YELLOW-$COLORRESET moving $target to .dotfiles/backup/.$file"
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
           echo wrong input, skipping
           continue
           ;;
       esac
      fi
      
    else 
      echo -e "$SPACER$GREEN+$COLORRESET linking $file to $target"
    fi
  done
}

function uninstall() {

  for sym in *.symlink; do
    target="$HOME/.${sym%.*}" 
    if [ "`readlink $target`" ==  "${PWD}/$sym" ]; then
      echo -e "$RED-$COLORRESET Deleting $target"
      rm $target
      if [ -e "backup/.${sym%.*}" ]; then
        echo -e "$SPACER$GREEN+$COLORRESET restoring original file"
        mv backup/.${sym%.*} $HOME/
      fi
    fi
  done
}

function update() {
  git pull
  install
}

function usage() {
  cat << EOF
How to use this:

./install.sh install 
  Symlink the dotfiles to the home directory

./install.sh uninstall
  Remove all symlinks to this directory and restore from backup if possible

./install.sh update
  Fetch updates from the repository and update symlinks if needed
EOF
}

case $@ in
  install)
    install
    ;;
  uninstall)
    uninstall
    ;;
  update)
    update
    ;;
  *)
    usage 
    ;;
esac
