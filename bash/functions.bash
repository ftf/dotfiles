#!/bin/bash
dl()
{
  for i in $*; do
    echo "Downloading:" $i
    curl -OC -i $i
  done
}

rse()
{
  # We need to wrap each phrase of the command in quotes to preserve arguments that contain whitespace
  # Execute the command, swap STDOUT and STDERR, colour STDOUT, swap back
  ((eval $(for phrase in "$@"; do echo -n "'$phrase' "; done)) 3>&1 1>&2 2>&3 | sed -e "s/^\(.*\)$/$(echo -en \\033)[31;1m\1$(echo -en \\033)[0m/") 3>&1 1>&2 2>&3
}

# Gentoo only functions
if `type emerge >/dev/null 2>&1`; then
  kvmdo() {
    cmd=`echo $@ | cut -d' ' -f2-`
    case $1 in
      all)
        for x in `grep -o  "kvm-.*$" ~/.ssh/config`;   
        do 
            echo $x
            ssh $x $cmd; 
            echo
        done
        ;;
      *)
        targetHost=kvm-$1
        if grep -o $targetHost ~/.ssh/config >/dev/null; then
          ssh kvm-$1 $cmd; 
        else 
          echo Host kvm-$1 not found
        fi
        ;;
    esac
  }

  up() {
    case $@ in
      fixdeps)
        sudo revdep-rebuild -pqi
        ;;
      config)
        sudo dispatch-conf
        ;;
      pretend)
        sudo emerge --verbose --quiet --pretend --update --newuse --deep world
        ;;
      go)
        sudo emerge --quiet --update --newuse --deep --keep-going world
        ;;
      *)
        sudo emerge --verbose --quiet --ask --update --newuse --deep --keep-going world
        ;;
    esac
  }

  mg() {
      grep "$@" /var/log/messages
  }
fi

# OS X only functions
if [[ "$OSTYPE" =~ darwin ]]; then
  manp()
  {
    man -t "${1}" | open -f -a Skim
  }

  sis()
  {
    $* | enscript -p - | open -f -a Skim
  }
fi
