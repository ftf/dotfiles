#!/bin/zsh
## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## file rename magick
autoload -U zmv
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

export LC_CTYPE=$LANG

#setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS
# treat # as comment, not as a command
setopt INTERACTIVE_COMMENTS

if [[ x$WINDOW != x ]]
then
    SCREEN_NO="%B$WINDOW%b "
else
    SCREEN_NO=""
fi
