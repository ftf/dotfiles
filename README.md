Just a bunch of .dotfiles
=========================

install.sh
----------

Inspired by [holmans dotfiles](https://github.com/holman/dotfiles)
Rakefile.
Since some moron systems don't ship with ruby I wanted to use a 
pure shell based installation. After the .dotfile installation we 
can install ruby via [rvm](http://rvm.io).

### install.sh options
./install.sh install 
  Symlink the dotfiles to the home directory

./install.sh uninstall
  Remove all symlinks to this directory and restore from backup if possible

./install.sh update
  Fetch updates from the repository and update symlinks if needed


Installation: 
-------------
- Open a fresh shell session
- git clone git://github.com/ftf/dotfiles .dotfiles
- or if the system has no git installed, grab the zip file 
- > wget -r https://github.com/ftf/dotfiles/zipball/master && unzip master -d .dotfiles
- cd .dotfiles 
- ./install.sh 

Custom ZSH files
----------------
Store them at .dotfiles/zsh/ as somefile.my.zsh

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

