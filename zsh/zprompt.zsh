#!/bin/zsh

# -----------------------------------------------------
# Warning: escape the fcking colors!
# -----------------------------------------------------

# thanks to:
# https://github.com/nicknisi/dotfiles/blob/master/zsh/prompt.zsh
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

setopt prompt_subst

function battery_charge {
  echo `~/.dotfiles/bin/battery.py 2>/dev/null`
}

#RPROMPT=$(battery_charge)
function git_status {
  git branch >/dev/null 2>/dev/null && echo "🗄  " && return
  return
}

function git_current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " on %{$fg_bold[blue]%}${ref#refs/heads/}%{$reset_color%}%{$reset_color%} "
}


function git_uncommited {
  git rev-parse --git-dir >/dev/null 2>/dev/null && if [[ `git ls-files -m | wc -l | awk '{ print $1; }'` -gt 0 ]]; then
    commit_status="%{$fg_bold[red]%}✘%{$reset_color%}"
  else
    commit_status="%{$fg_bold[green]%}✓%{$reset_color%}"
  fi
  echo "$commit_status "
}

function git_pushstate {
  arrow_status="$(command git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null)"

  # do nothing if the command failed
  (( !$? )) || return

  # split on tabs
  arrow_status=(${(ps:\t:)arrow_status})
  local left=${arrow_status[1]} right=${arrow_status[2]}
  (( ${right:-0} > 0 )) && arrows+="%{$fg_bold[blue]%}⇣%{$reset_color%}"
  (( ${left:-0} > 0 )) && arrows+="%{$fg_bold[green]%}⇡%{$reset_color%}"
  echo "$arrows "
}

function hg_prompt_info {
  hg root >/dev/null 2>/dev/null || return
  echo " %{$fg_bold[blue]%}`hg branch`%{$reset_color%} %{$fg[green]%}|%{$reset_color%}"
}

function suspended_jobs() {
  if [[ `jobs | wc -l` -ne "" ]]; then
    echo "⏱%  "
  fi
}

if [ "$USER" = 'root' ] ; then
  base_prompt="%{$fg_bold[red]%}%m%k%{$reset_color%} "
else
  base_prompt="%{$fg[blue]%}%n%{$fg_bold[green]%}@%m%k%{$reset_color%} "
fi
post_prompt="%b%f%k"

setopt extended_glob

preexec () {
  if [[ "$TERM" == "screen" ]]; then
    local CMD=${1[(wr)^(*=*|sudo|-*)]}
    echo -ne "\ek$CMD\e\\"
  fi
}

setopt noxtrace localoptions

PS1='$base_prompt%{$fg_bold[blue]%}${PWD/#$HOME/~}%{$reset_color%}$(git_current_branch)
$(git_status)$(git_pushstate)$(git_uncommited)$(suspended_jobs) '

#RPROMPT='$(battery_charge)'
