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
      *)
        sudo emerge -avq --update --newuse --deep world
        ;;
    esac
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

