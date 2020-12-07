export GOPATH=$HOME/go
export PATH=$HOME/bin:/usr/local/bin:$HOME/.npm-global/bin:/usr/local/go/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.local/bin:/snap/bin:$GOPATH/bin:$PATH
export ZSH=~/.oh-my-zsh
[[ $TERM == xterm-termite ]] && export TERM=xterm

# https://www.reddit.com/r/i3wm/comments/6in8m1/did_you_know_xdg_current_desktop/
# https://github.com/emersion/xdg-desktop-portal-wlr
XDG_CURRENT_DESKTOP=sway
XDG_SESSION_TYPE=wayland
MOZ_ENABLE_WAYLAND=1

# GOPROXY=chalupa-dns-sinkhole.corp.amazon.com
ZSH_THEME='robbyrussell'
COMPLETION_WAITING_DOTS='true'

plugins=(git docker docker-compose zsh-nvm aws zsh-syntax-highlighting z pyenv)

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  export GIT_EDITOR='nvim'
fi

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

alias vim='nvim'
alias python='python3'
alias pip='pip3'
# alias ctags="`brew --prefix`/bin/ctags"

# Amazon aliases
alias tail-apihandler-logs='sls logs -f workflowLoopRunner --stage joenye -t'
alias tail-wf-logs='sls logs -f workflowLoopRunner --stage joenye -t'

source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/usr/local/share/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib64/x86_64-linux-gnu/:$LD_LIBRARY_PATH

# Alacritty
fpath+=${ZDOTDIR:-~}/.zsh_functions
