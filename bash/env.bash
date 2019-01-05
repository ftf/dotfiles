# for gpg curses gui
export GPG_TTY=`tty`
export CLICOLOR=1
export GREP_COLORS="mt=01;34"
export EDITOR=vim

if [[ -a  /usr/local/opt/curl-ca-bundle/share/ca-bundle.crt ]]; then
  export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
fi

export PATH=~/.dotfiles/bin:/usr/local/sbin:/usr/local/bin:$PATH
export PATH=~/.dotfiles/bin:/usr/local/sbin:/usr/local/bin:$PATH

[ -d /usr/local/opt/ruby/bin ] && export PATH=/usr/local/opt/ruby/bin:$PATH
if `type gem >/dev/null 2>&1`; then
  RUBYBINPATH=`gem env | grep "EXECUTABLE DIRECTORY" | awk  '{ print $4 }'`
  export PATH=$RUBYBINPATH:$PATH
fi

[ -d ~/.composer/vendor/bin ] && export PATH=~/.composer/vendor/bin:$PATH
[ -d ~/.node/bin ] && export PATH=~/.node/bin:$PATH
[ -d ~/.cargo/bin ] && export PATH=~/.cargo/bin:$PATH
