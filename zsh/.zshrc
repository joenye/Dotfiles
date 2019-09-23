export PATH=$HOME/bin:/usr/local/bin:$HOME/.npm-global/bin:/usr/local/go/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$PATH
export ZSH=~/.oh-my-zsh
[[ $TERM == xterm-termite ]] && export TERM=xterm

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

source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
