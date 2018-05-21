#!/bin/bash
dl()
{
  for i in $*; do
    echo "Downloading:" $i
    curl -OC -i $i
  done
}

#colored man pages
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
  }

# webdev stuff, generate a new ssl crt/key with 1 year validity
function generatesslcert {
  echo -n "please enter a basename for the certificates: "
  read certname
  openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -keyout $certname.key -out $certname.crt
  echo
  echo
  echo "$certname.crt & $certname.key are ready for you"
}
rse()
{
  # We need to wrap each phrase of the command in quotes to preserve arguments that contain whitespace
  # Execute the command, swap STDOUT and STDERR, colour STDOUT, swap back
  ((eval $(for phrase in "$@"; do echo -n "'$phrase' "; done)) 3>&1 1>&2 2>&3 | sed -e "s/^\(.*\)$/$(echo -en \\033)[31;1m\1$(echo -en \\033)[0m/") 3>&1 1>&2 2>&3
}

# Gentoo only functions
if `type emerge >/dev/null 2>&1`; then
  vmdo() {
    cmd=`echo $@ | cut -d' ' -f2-`
    case $1 in
      all)
        for x in `grep -o  "kvm-.*$" ~/.ssh/config`;
        do
            echo $x
            ssh $x "$cmd";
            echo
        done
        ;;
      *)
        targetHost=vm-$1
        if grep -o $targetHost ~/.ssh/config >/dev/null; then
          ssh vm-$1 "$cmd";
        else
          echo Host vm-$1 not found
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
