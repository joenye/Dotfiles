export PATH=$HOME/bin:/usr/local/bin:/home/joenye/.npm-global/bin:/home/joenye/platform-tools:/usr/local/go/bin:/usr/local/cuda-9.0/bin:/home/joenye/.nvm/versions/node/v9.4.0/bin:$PATH
export NODE_PATH=/home/joenye/.npm-global/lib/node_modules
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
# gpg-connect-agent updatestartuptty /bye > /dev/null; pkill curses
export ZSH=/usr/share/oh-my-zsh

ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"

plugins=(git)

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
alias weather='wego'
alias open='nautilus . &'
alias reboot='reboot'
alias shutdown='shutdown now'
alias suspend='systemctl suspend'

source $ZSH/oh-my-zsh.sh
source /usr/share/nvm/init-nvm.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
