Just a bunch of .dotfiles
=========================

dotey - a little dotfiles helper
----------

Inspired by [holmans dotfiles](https://github.com/holman/dotfiles)
Rakefile.
Since some moron systems don't ship with ruby I wanted to use a
pure shell script based installation. Luckily we can install ruby later with
the help of [rvm](http://rvm.io).

### dotey options

```
How to use this:

./dotey install
  Symlink dotfiles to the home directory

./dotey uninstall
  Remove all dotfile symlinks from home directory and restore from backup if possible

./dotey update
  Fetch updates from the repository and update symlinks if needed

./dotey link
  Update symlinks if needed

./dotey privatedots install
  Decrypt and unpack your private dotfiles and install them at this computer

./dotey privatedots link
  Link newly added private dotfiles to your home directory

./dotey privatedots pack
  Encrypt and pack your private dotfiles to transfer them to another box

./dotey privatedots delete
  Delete your private dotfiles from this computer
```

Installation:
-------------
- Open a fresh shell/Terminal session
- git clone git://github.com/ftf/dotfiles .dotfiles
- or if the system has no git installed, grab the zip file
- -> wget https://github.com/ftf/dotfiles/zipball/master && unzip master -d .dotfiles && rm master
- cd .dotfiles
- ./dotey install
- dotey should work with different pathnames too, but I wouldn't count on it

Post installation
-----------------
- to use a couple of neat vim bundles run: ```./dotey vimupdate```
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
As above, store them at ```.dotfiles/privatedots/bash``` as ```somefile.bash```

Custom .dotfiles
----------------
Just put them in ```.dotfiles``` and name them ```something.symlink```
to get them linked to your home directory, to do this run
```./dotey link```.

Example: ```~/.dotfiles/.someth.ing.symlink``` will be linked to ```~/.someth.ing```

How to link newly added .dotfiles?
-------------------------------
Just run ```./dotey link```

Private Dotfiles
----------------

### What to do with the dotfiles that should not end up on GitHub?

Put them in .dotfiles/privatedots. When they should be linked to your
home directory add as before ```.symlink``` to the filename.

To link newly added private dotfiles use ```./dotey
privatedots link```

The ```privatedots``` directory will be compressed with tar/bzip2 and
afterwards encrypted with openssl/des.

### Transfer private dotfiles between machines
- Run ```./dotey privatedots pack``` and enter a password when
  prompted
- Copy the privdots.des3 file to anothers box ```.dotfile``` directory by
  ftp/sftp/scp/rsync whatever
- At the other machine run ```./dotey privatedots install```

### I don't want my private dotfiles on a machine anymore
Just run ```./dotey privatedots delete``` and they are gone

### Why private dotfiles after all, should I not share all my dotfiles?
While this thought should be appreciated, you probably don't want to
share your ftp or irssi passwords with everyone out there.

Add VIM plugins
---------------
Launch vim and run :PlugInstall thanks to the awesome [vim-plug]:(https://github.com/junegunn/vim-plug)

Some VIM tips
-------------
- The Leader key is mapped to the space bar. (thx [sheerun](http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/))
- Switch a buffer with CtrlP ```Space + b```
- Open a new file with CtrlP ```Space + o```
- Un-/Comment a line: ```gcc```
- Un-/Comment a visual block: ```gc```
- Fast window navigation with: ```,k ``` ``` ,j ``` ``` ,h ``` ``` ,l```
- View hidden characters: ```Space + h```
- Disable highlighted search result: ```Space + q```
- Enable//Disable line numbers: ```Space + l```
- View syntastic errors: ```Space + e```
- Use ```tab``` to jump through results in the youcompleteme omnibox,
- use ```ctrl+j``` to expand a snippet
- On a Mac, open the file in chrome: ```Space + cr```
- On a Mac, open the file in safari: ```Space + sf```
- Toggle line wrapping with ```Space + w```
- Toggle paste mode with ```Space + p```
- Toggle vim hardmode with ```Space + k```
  (Disables all for cursor keys and ```h,j,k,l```)

Vim Plugins
----------
All vim plugins that are pulled in right now:
- [You complete me](https://github.com/Valloric/YouCompleteMe)
- [GitGutter](https://github.com/airblade/vim-gitgutter)
- [Airline](https://github.com/bling/vim-airline.git)
- [bufferline](https://github.com/bling/vim-bufferline.git )
- [colorschemes](https://github.com/flazz/vim-colorschemes)
- [fugitive](https://github.com/tpope/vim-fugitive)
- [syntastic](https://github.com/scrooloose/syntastic)
- [trailing whitespace](https://github.com/bronson/vim-trailing-whitespace)
- [matchit](https://github.com/tmhedberg/matchit)
- [emmet](https://github.com/mattn/emmet-vim)
- [nerdtree](https://github.com/scrooloose/nerdtree)
- [vim-indent](https://github.com/michaeljsmith/vim-indent-object)
- [Vim plugin: vim-smartinput](https://github.com/kana/vim-smartinput)
- [multiple coursors](https://github.com/terryma/vim-multiple-cursors)
- [ctrlp](https://github.com/kien/ctrlp.vim.git)
- [ultisnips](https://github.com/SirVer/ultisnips)
- [snippets](https://github.com/honza/vim-snippets)
- [vim commentary](https://github.com/tpope/vim-commentary)
- [Javascript Syntax](https://github.com/jelera/vim-javascript-syntax)
- [Javascript Indent](https://github.com/vim-scripts/JavaScript-Indent)


dotey is a stupid name
----------------------
Go fork the repo and come up with something better.

The same applies if you don't like my config files ;)


<a href="http://flattr.com/thing/671197/ftf-on-GitHub" target="_blank">
<img src="http://api.flattr.com/button/flattr-badge-large.png"
alt="Flattr this" title="Flattr this" border="0" /></a>
