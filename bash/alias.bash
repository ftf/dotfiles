#!/bin/bash
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias top='top -u -s1 20'
alias l='ls -hasl'
alias ..='cd ..'
alias ...='cd ../..'
#alias port1='sudo port selfupdate && port outdated'
#alias port2='sudo port upgrade outdated && sudo port -f uninstall inactive && sudo port clean --all all'
#alias sgu='sudo gem update'
alias sgu='rvm all do gem update'
alias grep='egrep --ignore-case --color=auto'

# cat with syntax hilightning
if `type pygmentize >/dev/null 2>&1` ; then
    alias c='pygmentize -O style=monokai -f console256 -g'
fi

# OS X only aliases
if [[ "$OSTYPE" =~ darwin ]]; then
  alias bubu='brew update && brew upgrade --all'
  alias cleanservices='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user'
  alias sitm='osascript ~/Library/Scripts/Applications/Safari/Open\ Source\ in\ TextMate.scpt'
fi

