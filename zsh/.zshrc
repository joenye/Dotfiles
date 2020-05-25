export PATH=$HOME/bin:/usr/local/bin:$HOME/.npm-global/bin:/usr/local/go/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.local/bin:/snap/bin:$PATH
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

# Amazon aliases
alias tail-apihandler-logs='sls logs -f workflowLoopRunner --stage joenye -t'
alias tail-wf-logs='sls logs -f workflowLoopRunner --stage joenye -t'

source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/ANT.AMAZON.COM/joenye/.nvm/versions/node/v10.16.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/ANT.AMAZON.COM/joenye/.nvm/versions/node/v10.16.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/ANT.AMAZON.COM/joenye/.nvm/versions/node/v10.16.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /home/ANT.AMAZON.COM/joenye/.nvm/versions/node/v10.16.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/ANT.AMAZON.COM/joenye/.nvm/versions/node/v10.16.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /home/ANT.AMAZON.COM/joenye/.nvm/versions/node/v10.16.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
