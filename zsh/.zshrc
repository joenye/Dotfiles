export PATH=$HOME/bin:/usr/local/bin:/home/joenye/.npm-global/bin:/home/joenye/platform-tools:/usr/local/go/bin:/usr/local/cuda-9.0/bin:/home/joenye/.nvm/versions/node/v9.4.0/bin:$PATH:$(ruby -e 'print Gem.user_dir')/bin 
export NODE_PATH=/home/joenye/.npm-global/lib/node_modules
export ZSH=/home/joenye/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
export DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
bindkey -M viins 'jj' vi-cmd-mode
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
plugins=(git history-substring-search zsh-syntax-highlighting npm)


# Docker compose autocompletion
autoload -Uz compinit && compinit -i
fpath=(~/.zsh/completion $fpath)
dco(){
   if [[ $1 = "up" ]]; then
        # if it's a docker-compose 'up' command, auto add docker-compose 'down' variant
        docker-compose ${@:1} && echo "--restarting--" && dco ${@:1}
   else
        docker-compose ${@:1}
   fi
}

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  export GIT_EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias python3="/usr/bin/python3.7"
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.7
source /usr/bin/virtualenvwrapper.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Termite
if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

# Tmuxp completion
autoload bashcompinit
bashcompinit
eval "$(_TMUXP_COMPLETE=source tmuxp)"

[ -f ~/.key-bindings.zsh ] && source ~/.key-bindings.zsh

# Do not be disturbed by ctrl-s or ctrl-q.
stty -ixon

# Force nvim when typing 'vim' (type 'vi' to use vim)
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

# Wego
alias weather='wego'

# SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
gpg-connect-agent updatestartuptty /bye > /dev/null; pkill curses

# Alaister's lengendary scripts
listify () {
    cat $1 | cut -d ',' -f 1  | awk '{print "\""$1"\","}' | tr '\n' ' ' | awk '{print "["$0"]"}'
}
