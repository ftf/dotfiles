Just a bunch of .dotfiles
=========================

install.sh
----------

Inspired by [holmans dotfiles](https://github.com/holman/dotfiles)
Rakefile.
Since some moron systems don't ship with ruby I wanted to use a 
pure shell script based installation. Luckily we can install ruby later with
the help of [rvm](http://rvm.io).

### install.sh options

```
How to use this:

./install.sh install 
  Symlink dotfiles to the home directory

./install.sh uninstall
  Remove all dotfile symlinks from home directory and restore from backup if possible
  
./install.sh update
  Fetch updates from the repository and update symlinks if needed

./install.sh link
  Update symlinks if needed

./install.sh privatedots install
  Decrypt and unpack your private dotfiles and install them at this computer

./install.sh privatedots link
  Link newly added private dotfiles to your home directory

./install.sh privatedots pack
  Encrypt and pack your private dotfiles to transfer them to another box

./install.sh privatedots delete
  Delete your private dotfiles from this computer

./install.sh vimupdate
  Initialize or update the janus vim distribution (also update or
  install new vim plugins inside .janus.symlink)
```

Installation: 
-------------
- Open a fresh shell/Terminal session
- git clone git://github.com/ftf/dotfiles .dotfiles
- or if the system has no git installed, grab the zip file 
- -> wget https://github.com/ftf/dotfiles/zipball/master && unzip master -d .dotfiles && rm master
- cd .dotfiles 
- ./install.sh install

Post installation
-----------------
- to use the janus vim distribution run: ```./install.sh vimupdate```
- get the [lolcat](https://github.com/busyloop/lolcat) gem for color awesomeness

Will the script kill my current configuration files?
---------------------------------------------
If you want, yes.

Or you can skip to the next file without replacing it or you can choose
to move your file to ```.dotfiles/backup```.

Custom ZSH files
----------------
Store them at ```.dotfiles/privatedots/zsh/``` as ```somefile.zsh```. 
Git will ignore them, so you won't share any sensitive information if 
you fork this repo.

Custom BASH files
-----------------
As above, store them at ```.dotfiles/privatedots/bash``` as
```somefile.bash```

Custom .dotfiles
----------------
Just put them in ```.dotfiles``` and name them ```something.symlink``` 
to get them linked to your home directory, to do this run  
```./install.sh link```.

Example: ```~/.dotfiles/.someth.ing.symlink``` will be linked to ```~/.someth.ing```

How to link newly added .dotfiles?
-------------------------------
Just run ```./install.sh link``` 

Private Dotfiles 
---------------- 

### What to do with the dotfiles that should not end up on GitHub?

Put them in .dotfiles/privatedots. When they should be linked to your
home directory add as before ```.symlink``` to the filename.

To link newly added private dotfiles use ```./install.sh
privatedots link```

The ```privatedots``` directory will be compressed with tar/bzip2 and
afterwards encrypted with openssl/des.

### Transfer private dotfiles between machines
- Run ```./install.sh privatedots pack``` and enter a password when
  prompted
- Copy the privdots.des3 file to anothers box ```.dotfile``` directory by 
  ftp/sftp/scp/rsync whatever
- At the other machine run ```./install.sh privatedots install```

### I don't want my private dotfiles on a machine anymore
Just run ```./install.sh privatedots delete``` and they are gone

### Why private dotfiles after all, should I not share all my dotfiles?
While this thought should be appreciated, you probably don't want to
share your ftp or irssi passwords with everyone out there.

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
- [Vim plugin: vim-markdown-preview](https://github.com/rasky/vim-markdown-preview)

Add VIM plugins
---------------
In your .dotfiles directory execute:

```
git submodule add -f https://github..... janus.symlink/pluginname
```

and then run ```./install.sh vimupdate```
