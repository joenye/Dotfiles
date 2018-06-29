**Stow**

Change directory to dotfiles and install using `GNU Stow`:

- `stow x` will sym link the files in the x/ directory to the correct place in $HOME.
- Use install.sh to stow all.

**A few installation notes**

Vim Plug

1. https://github.com/junegunn/vim-plug

FZF

1. `git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf`
2. Run `~/.fzf/install`

Oh My Zsh

1. sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ZSH Syntax Highlighting

1. `cd ~/.oh-my-zsh/custom/plugins`
2. `git clone git://github.com/zsh-users/zsh-syntax-highlighting.git`

Ag

1. Install https://github.com/ggreer/the_silver_searcher
