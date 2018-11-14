export PATH=$HOME/bin:/usr/local/bin:/home/joenye/.npm-global/bin:/home/joenye/platform-tools:/usr/local/go/bin:/usr/local/cuda-9.0/bin:/home/joenye/.nvm/versions/node/v9.4.0/bin:$PATH
export NODE_PATH=/home/joenye/.npm-global/lib/node_modules
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
plugins=(git history-substring-search)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  export GIT_EDITOR='nvim'
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Termite
if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

# Force nvim when typing 'vim' (type 'vi' to use vim)
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi
alias weather='wego'
alias open='nautilus . &'
alias reboot='sudo systemctl reboot'
alias shutdown='sudo systemctl poweroff'
alias suspend='sudo systemctl suspend'

# SSH / GPG over Yubikey
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
gpg-connect-agent updatestartuptty /bye > /dev/null; pkill curses

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
