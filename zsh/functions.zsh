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

function s() {
    grep -IR "$@" *
}

function md() {
  mkdir "$1"
  cd "$1"
}

function f() {
  find . -name "$1"
}

function dl() {
  for i in $*; do
    echo "Downloading:" $1
    curl -OC -i $1
  done
}

# colored man pages
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

# webdev stuff, generate a new ssl crt/key with 3 year validity
function generatesslcert {
	echo -n "please enter a domain for the certificates: "
  read DOMAIN

  DAYS=1080
  PASSPHRASE=""
  CONFIG_FILE="/tmp/sslconfig.txt"

  cat > $CONFIG_FILE <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
x509_extensions = v3_req
distinguished_name = dn

[dn]
C = DE
ST = BY
L = Munich
O = IT Crowd
OU = Self Signed for a reason
emailAddress = webmaster@$DOMAIN
CN = $DOMAIN

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.$DOMAIN
DNS.2 = $DOMAIN
EOF

  FILE_NAME="$DOMAIN"
  openssl req -new -x509 -newkey rsa:2048 -sha256 -nodes -keyout "$FILE_NAME.key" -days $DAYS -out "$FILE_NAME.crt" -passin pass:$PASSPHRASE -config "$CONFIG_FILE" >/dev/null
  rm $CONFIG_FILE
  echo
  echo
  echo "$DOMAIN.crt & $DOMAIN.key are ready for you"
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
            vmip=`grep $x -A4 ~/.ssh/config | grep -o "[[:digit:]]+.[[:digit:]]+.[[:digit:]]+.[[:digit:]]+"`
            if [ `ping -c1 $vmip | grep "0 received" | wc -l` -eq 1 ]; then
              echo "--> offline";
            else
              ssh $x $cmd;
            fi
            echo
        done
        ;;
      *)
        targetHost=vm-$1
        if grep -o $targetHost ~/.ssh/config >/dev/null; then
          vmip=`grep $targetHost -A4 .ssh/config | grep -o "[[:digit:]]+.[[:digit:]]+.[[:digit:]]+.[[:digit:]]+"`
          if [ `ping -c1 $vmip | grep "0 received" | wc -l` -eq 1 ]; then
            echo "vm-$1 offline";
          else
            ssh kvm-$1 $cmd;
          fi
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
          if [ `type rkhunter >/dev/null 2>&1` ]; then
            rkhunter --propupd
          fi
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

  function lepasta() {
    if [[ "$OSTYPE" =~ darwin ]]; then
      ~/.dotfiles/bin/pastee.py $1 | pbcopy;
      /usr/local/bin/growlnotify -n lepasta -t lepasta -m `pbpaste`
    fi
  }

  function xdebugtoggle() {
    if [[ -f /usr/local/etc/php/7.1/conf.d/ext-xdebug.ini ]]; then
      mv /usr/local/etc/php/7.1/conf.d/ext-xdebug.{ini,inix}
    else
      mv /usr/local/etc/php/7.1/conf.d/ext-xdebug.{inix,ini}
    fi
    lunchy restart php71
  }

  function reloaddns() {
    sudo killall -HUP mDNSResponder
    sudo lunchy restart unbound
  }

fi

test $SSH_AUTH_SOCK && ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
