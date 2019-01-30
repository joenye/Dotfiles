export PATH=$HOME/bin:/usr/local/bin:/home/joenye/.npm-global/bin:/home/joenye/platform-tools:/usr/local/go/bin:/usr/local/cuda-9.0/bin:/home/joenye/.yarn/bin:$PATH
export NODE_PATH=/home/joenye/.npm-global/lib/node_modules
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye > /dev/null
export SSH_AUTH_SOCK='/run/user/$UID/gnupg/S.gpg-agent.ssh'
export HISTFILE=/home/joenye/_Dotfiles/zsh_history/.zsh_history
export ZSH=/usr/share/oh-my-zsh

export TERM="xterm-256color"

# https://wiki.archlinux.org/index.php/Python/Virtual_environment#virtualenv
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper_lazy.sh

ZSH_THEME='robbyrussell'
COMPLETION_WAITING_DOTS='true'

plugins=(git docker docker-compose)

if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  export GIT_EDITOR='nvim'
fi

# Force nvim when typing 'vim' (type 'vi' to use vim)
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi
alias reboot='reboot'
alias shutdown='shutdown now'
alias suspend='systemctl suspend'

source $ZSH/oh-my-zsh.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/bin/aws_zsh_completer.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
