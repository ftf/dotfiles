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

function mount() {
  if [[ "$OSTYPE" =~ darwin ]]; then
    REALMOUNT=/sbin/mount
  else
    REALMOUNT=/bin/mount
  fi
  if [[ "$#" -eq 0 ]]; then
    $REALMOUNT | column -t
  else
    $REALMOUNT $@
  fi
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
function man() {
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

# webdev stuff, generate a new ca
function generatesslca {
	echo -n "please enter a authority domain for the CA: "
  read CA

  DAYS=3650
  PASSPHRASE=""
  CONFIG_FILE="/tmp/sslconfig.txt"

  cat > $CONFIG_FILE <<-EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = v3_req
x509_extensions = v3_req
distinguished_name = dn

[ dn ]
C = DE
ST = BY
L = Munich
O = IT Crowd
OU = Self Signed for a reason
emailAddress = webmaster@${CA}
CN = ${CA} CA

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = critical, CA:TRUE, pathlen:3
keyUsage = critical, cRLSign, keyCertSign
nsCertType = sslCA, emailCA
EOF

  FILE_NAME="$CA"

  mkdir -p ~/.ssl
  chmod 700 ~/.ssl
  openssl genrsa -aes256 -out ~/.ssl/ca.key.pem 2048
  openssl req -new -x509 -subj "/CN=$CA" -extensions v3_ca -days $DAYS -key ~/.ssl/ca.key.pem -sha256 -out ~/.ssl/ca.pem -config $CONFIG_FILE

  echo "Remove Passphrase? (y/n)"
  read removepass

  if [[ $removepass -eq "y" ]]; then
    openssl rsa -in ~/.ssl/ca.key.pem -out ~/.ssl/ca.key.pem
  fi
  chmod 400 ~/.ssl/ca*

  rm $CONFIG_FILE
  echo
  echo
  echo "$DOMAIN CA is ready for you"
}

# webdev stuff, generate a new ssl crt/key with 3 year validity
function generatesslcert {
  if [[ ! -f ~/.ssl/ca.pem ]]; then
    echo "no CA found, please execute generatesslca first"
    return
  fi
	echo -n "please enter a domain for the certificates: "
  read DOMAIN

  DAYS=1080
  PASSPHRASE=""
  CONFIG_FILE="/tmp/sslconfig.txt"

  cat > $CONFIG_FILE <<-EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = v3_req
x509_extensions = v3_req
distinguished_name = dn

[ dn ]
C = DE
ST = BY
L = Munich
O = IT Crowd
OU = Self Signed for a reason
emailAddress = webmaster@${DOMAIN}
CN = ${DOMAIN%.*}

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = critical, CA:TRUE, pathlen:3
keyUsage = critical, cRLSign, keyCertSign
nsCertType = sslCA, emailCA

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
EOF

  FILE_NAME="$DOMAIN"
  openssl genrsa -out $DOMAIN.key 2048
  openssl req -subj "/CN=$DOMAIN" -extensions v3_req -sha256 -new -key $DOMAIN.key -out $DOMAIN.csr -config $CONFIG_FILE
  openssl x509 -req -extensions v3_req -days 3650 -sha256 -in $DOMAIN.csr -CA ~/.ssl/ca.pem -CAkey ~/.ssl/ca.key.pem -CAcreateserial -out $DOMAIN.crt -extfile $CONFIG_FILE
  rm $DOMAIN.csr
  rm $CONFIG_FILE
  echo
  echo
  echo "$DOMAIN.crt & $DOMAIN.key are ready for you"
}


# Gentoo only functions
if `type emerge >/dev/null 2>&1`; then
  function vmdo() {
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

  function emerge() {
    if [[ `mount | grep '/var/tmp' | grep noexec | wc -l` -eq 1 ]]; then
      print -P \["%F{198}*%f"\] remounting /var/tmp with exec,suid
      mount -o remount,exec,suid /var/tmp
      /usr/bin/emerge $@
      print -P \["%F{198}*%f"\] remounting /var/tmp with noexec,nosuid
      mount -o remount,noexec,nosuid /var/tmp
    else
      /usr/bin/emerge $@
    fi
  }

  function up() {
      if [[ `mount | grep '/var/tmp' | grep noexec | wc -l` -eq 1 ]]; then
        sudo mount -o remount,exec,suid /var/tmp
      fi

      case $@ in
        fixdeps)
          sudo revdep-rebuild -pqi
          ;;
        config)
          sudo dispatch-conf
          ;;
        pretend)
          emerge --verbose --quiet --pretend --update --newuse --with-bdeps=y --deep world
          ;;
        go)
          sudo emerge --quiet --update --newuse --deep --with-bdeps=y --complete-graph=y --keep-going world
          if `type rkhunter >/dev/null`; then
            sudo rkhunter --propupd
          fi
          ;;
        *)
          sudo emerge --verbose --quiet --ask --update --newuse --deep --with-bdeps=y --complete-graph=y --keep-going world
          if `type rkhunter >/dev/null`; then
            sudo rkhunter --propupd
          fi
          ;;
      esac
      if [[ `mount | grep '/var/tmp' | grep exec | wc -l` -eq 1 ]]; then
        sudo mount -o remount,noexec,nosuid /var/tmp
      fi
    }

  function mg() {
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
    if [[ -f /usr/local/etc/php/7.2/conf.d/ext-xdebug.ini ]]; then
      mv /usr/local/etc/php/7.2/conf.d/ext-xdebug.{ini,inix}
    else
      mv /usr/local/etc/php/7.2/conf.d/ext-xdebug.{inix,ini}
    fi
    lunchy restart php72
  }

  function reloaddns() {
    sudo killall -HUP mDNSResponder
    sudo lunchy restart unbound
  }

fi

test $SSH_AUTH_SOCK && ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
