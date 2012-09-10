#!/bin/zsh

# Set up aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias j=jobs
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias h=history
alias grep=egrep
alias ll='ls -l'
alias la='ls -a'

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'

# List only directories and symbolic
# links that point to directories
alias lsd='ls -ld *(-/DN)'

# List only file beginning with "."
alias lsa='ls -ld .*'

# custom aliases
alias _='sudo'
alias getmtu='ping -D -g 1400 -G 1500 -h1 heise.de'

#alias start_tomcat='$CATALINA_HOME/bin/startup.sh'
#alias stop_tomcat='$CATALINA_HOME/bin/shutdown.sh'
alias top='top -u -s1 20'

## Start a local SMTP server and dump emails sent to it to the console
alias smtpconsole='python -m smtpd -n -c DebuggingServer localhost:1025'

## Serve the current folder on port 80
alias serve_this='python -m SimpleHTTPServer'

## Highlight-aware less command
alias hl='less -R'

## Show history
alias history='fc -l 1'

# OS X only aliases
if [[ "$OSTYPE" =~ darwin ]]; then
  ## Quick-look a file (^C to close)
  alias ql='qlmanage -p 2>/dev/null'
  
  ## Open current directory
  alias oo='open .'

  alias bubu='brew update && brew upgrade'
  #alias cleanservices='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user'

  alias tc='/Applications/TrueCrypt.app/Contents/MacOS/TrueCrypt'

  alias nginx-up='sudo /usr/local/sbin/nginx -g "daemon on;"'
  alias nginx-down='sudo nginx -s stop'

  alias redis-up='/usr/local/bin/redis-server /usr/local/etc/redis.conf'
  alias redis-down='killall redis-server'

  alias mysql-up='/usr/local/bin/mysql.server start'
  alias mysql-down='/usr/local/bin/mysql.server stop'

  alias psgrs-up='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
  alias psgrs-down='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

  alias proxy-on='networksetup -setwebproxystate Wi-Fi on'
  alias proxy-off='networksetup -setwebproxystate Wi-Fi off'
  alias proxy-status='networksetup -getwebproxy Wi-Fi'
fi

# cat with syntax hilightning
if `type pygmentize >/dev/null 2>&1` ; then
  alias c='pygmentize -O style=monokai -f console256 -g'
fi

alias l='ls -hasl'
alias ..='cd ..'
alias ...='cd ../..'

