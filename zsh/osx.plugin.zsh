#!/bin/zsh

if [[ "$OSTYPE" =~ darwin ]]; then
  # Generate new xkcd style password an copy it to the clipboarf
  function getpw() {
    if [ -z "$1" ]; then
      LENGTH=4
    else
      LENGTH=$1
    fi
    SEPERATORPOOL=('-' '.' '_' ':')
    SEPERATORSEED=$$$(date +%s)
    SEPERATORRANDOM=$((SEPERATORSEED % ${#SEPERATORPOOL[@]}))
    SEPERATOR=${SEPERATORPOOL[$((SEPERATORRANDOM % ${#SEPERATORPOOL[@]} + 1 ))]}

    curl -s -L "https://xkcd.pw/${LENGTH}" |
      sed -e "s/ /${SEPERATOR}/g" |
      tr -d  '\n' |
      pbcopy
    echo "New ${LENGTH} word xkcd style password copied to your clipboard fine sir"
  }

  function manp() {
    man -t "${1}" | open -f -a Skim
  }

  function sis() {
    cat "$@" | enscript -p - | open -f -a Skim
  }

  function lepasta() {
      ~/.dotfiles/bin/pastee.py $1 | pbcopy;
      /usr/local/bin/terminal-notifier -title lepasta -message `pbpaste`
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

  function trash() {
    local trash_dir="${HOME}/.Trash"
    local temp_ifs=$IFS
    IFS=$'\n'
    for item in "$@"; do
      if [[ -e "$item" ]]; then
        item_name="$(basename $item)"
        if [[ -e "${trash_dir}/${item_name}" ]]; then
          mv -f "$item" "${trash_dir}/${item_name} $(date "+%H-%M-%S")"
        else
          mv -f "$item" "${trash_dir}/"
        fi
      fi
    done
    IFS=$temp_ifs
  }

fi
