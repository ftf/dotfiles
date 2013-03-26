#!/bin/zsh

# -----------------------------------------------------
# Warning: escape the fcking colors!
# -----------------------------------------------------



#autoload -U promptinit
#promptinit
#prompt gentoo
setopt prompt_subst

function battery_charge {
    echo `~/.dotfiles/bin/battery.py 2>/dev/null`
}

#RPROMPT=$(battery_charge)
function vcs_status {
    git branch >/dev/null 2>/dev/null && echo "%{$fg_bold[blue]%}git%{$reset_color%} %{$fg[green]%}|%{$reset_color%}" && return
    hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[blue]%}hg%{$reset_color%} %{$fg[green]%}|%{$reset_color%}"   && return
    return
}

function git_current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " %{$fg_bold[blue]%}${ref#refs/heads/}%{$reset_color%} %{$fg[green]%}|%{$reset_color%}"
}

function git_uncommited {
  git rev-parse --git-dir >/dev/null 2>/dev/null && if [[ `git ls-files -m | wc -l | awk '{ print $1; }'` -gt 0 ]]; then 
    echo "%{$fg_bold[red]%}▼%{$reset_color%} "
  else 
    echo "%{$fg_bold[green]%}▷%{$reset_color%} " 
  fi
}

function hg_prompt_info {
  hg root >/dev/null 2>/dev/null || return
  echo " %{$fg_bold[blue]%}`hg branch`%{$reset_color%} %{$fg[green]%}|%{$reset_color%}"
}

if [ "$USER" = 'root' ] ; then
  base_prompt="%{$fg_bold[red]%}%m%k%{$reset_color%} "
else
  base_prompt="%{$fg_bold[green]%}%n@%m%k%{$reset_color%} "
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

path_prompt=%1~
PS1='$(git_uncommited)$base_prompt%{$fg_bold[cyan]%}$path_prompt%{$reset_color%} ' # $post_prompt'   #%{$fg_bold[red]%}$(commit_status)%{$reset_color%}$(hg_prompt_info)$(git_current_branch) %{$fg_bold[cyan]%}$%{$reset_color%} $post_prompt'
PS2='$base_prompt%{$fg_bold[cyan]%}$path_prompt%{$reset_color%}%{$fg_bold[blue]%}$(vcs_status) %_> $post_prompt'
PS3='$base_prompt%{$fg_bold[cyan]%}$path_prompt%{$reset_color%}%{$fg[blue]%}$(vcs_status) ?# $post_prompt'
if [ -e "$HOME/.rvm/bin/rvm-prompt" ]; then
  RPROMPT='$(vcs_status)$(hg_prompt_info)$(git_current_branch) %{$fg_bold[blue]%}$(~/.rvm/bin/rvm-prompt)%{$reset_color%}'
elif which rbenv > /dev/null; then
  RPROMPT='$(vcs_status)$(hg_prompt_info)$(git_current_branch) %{$fg_bold[blue]%}$(rbenv version-name)%{$reset_color%}'
else
  RPROMPT='$(vcs_status)$(hg_prompt_info)$(git_current_branch)'
fi
