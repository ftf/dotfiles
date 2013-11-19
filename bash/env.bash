# for gpg curses gui
export GPG_TTY=`tty`
GREP_COLOR="1;31"
GREP_OPTIONS="-i --color=auto"
CLICOLOR=1
if [[ -a  /usr/local/opt/curl-ca-bundle/share/ca-bundle.crt ]]; then
  export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
fi
