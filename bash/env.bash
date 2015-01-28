# for gpg curses gui
export GPG_TTY=`tty`
CLICOLOR=1
GREP_COLORS="mt=01;34"

if [[ -a  /usr/local/opt/curl-ca-bundle/share/ca-bundle.crt ]]; then
  export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
fi
