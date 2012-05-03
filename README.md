Just a bunch of .dotfiles
=========================

install.sh
----------

Inspired by [holmans dotfiles](https://github.com/holman/dotfiles)
Rakefile.
Since some moron systems don't ship with ruby I wanted to use a 
pure shell based installation. Luckily we can install ruby later with
the help of [rvm](http://rvm.io).

### install.sh options
```
./install.sh install 
  Symlink dotfiles to the home directory

./install.sh uninstall
  Remove all dotfile symlinks from home directory and restore from backup if possible

./install.sh update
  Fetch updates from the repository and update symlinks if needed
```

Installation: 
-------------
- Open a fresh shell session
- git clone git://github.com/ftf/dotfiles .dotfiles
- or if the system has no git installed, grab the zip file 
- -> wget https://github.com/ftf/dotfiles/zipball/master && unzip master -d .dotfiles && rm master
- cd .dotfiles 
- ./install.sh 

Custom ZSH files
----------------
Store them at .dotfiles/zsh/ as somefile.my.zsh. Git will ignore them, so
you won't share any sensitive information if you fork this repo.

Custom BASH files
-----------------
As above, store them at .dotfiles/bash as somefile.my.bash

Post installation
-----------------
- git submodule init && git submodule update
- cd .vim && rake -> finishes janus/vim installation
- get the [lolcat](https://github.com/busyloop/lolcat) gem for color awesomeness

Will the script kill my current config files?
---------------------------------------------
If you want, yes.

Or you can skip to the next file without replacing it, or you can choose
to move your file to .dotfiles/backup.

Submodules
----------
- [Janus Vim Distribution](https://github.com/carlhuda/janus/)
- [Vim colorscheme: Busybee](https://github.com/vim-scripts/BusyBee)
- [Vim colorscheme: corn](https://github.com/vim-scripts/corn)
- [Vim colorscheme: kellys](https://github.com/vim-scripts/kellys)
- [Vim plugin: LaTeX-Box](https://github.com/vim-scripts/LaTeX-Box)
- [Vim plugin: vim-haml](https://github.com/tpope/vim-haml)
- [Vim plugin: vim-ruby](https://github.com/vim-ruby/vim-ruby)
- [Vim plugin: vim-smartinput](https://github.com/kana/vim-smartinput)
