export PATH=$HOME/bin:/usr/local/bin:$HOME/.npm-global/bin:/usr/local/go/bin:$HOME/.yarn/bin:$PATH
export ZSH=~/.oh-my-zsh
[[ $TERM == xterm-termite ]] && export TERM=xterm

ZSH_THEME='robbyrussell'
COMPLETION_WAITING_DOTS='true'

plugins=(git docker docker-compose zsh-nvm aws zsh-syntax-highlighting z)

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

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/joenye/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/joenye/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/joenye/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/joenye/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/joenye/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/joenye/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
