#!/bin/zsh
setopt correct_all

alias man='nocorrect man'
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mysql='nocorrect mysql'
alias mkdir='nocorrect mkdir'

# quote pasted URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
