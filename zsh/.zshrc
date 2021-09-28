# -----------------------------------------------------------------------------
# Exports
# -----------------------------------------------------------------------------

GOPATH=$HOME/go
PYTHONPATH=~/.local/lib/python3.8
PATH=$HOME/bin:/usr/local/bin:$HOME/.npm-global/bin:/usr/local/go/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$HOME/.local/bin:/snap/bin:$GOPATH/bin:$HOME/Projects/ee-productivity-scripts:$PATH

# https://www.reddit.com/r/i3wm/comments/6in8m1/did_you_know_xdg_current_desktop/
# https://github.com/emersion/xdg-desktop-portal-wlr
XDG_CURRENT_DESKTOP=sway
XDG_SESSION_TYPE=wayland
MOZ_ENABLE_WAYLAND=1
MOZ_DBUS_REMOTE=1
GDK_BACKEND=wayland

# GOPROXY=chalupa-dns-sinkhole.corp.amazon.com
ZSH_THEME='robbyrussell'
COMPLETION_WAITING_DOTS='true'

PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
PKG_CONFIG_PATH=/usr/local/share/pkgconfig:$PKG_CONFIG_PATH
LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=/usr/local/lib64/:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=/usr/local/lib64/x86_64-linux-gnu/:$LD_LIBRARY_PATH

# Lazy load zsh-nvm plugin
# NVM_LAZY_LOAD=true

NVM_LAZY_LOAD_EXTRA_COMMANDS=('nvim')
plugins=(git docker docker-compose zsh-nvm fzf aws zsh-syntax-highlighting z pyenv)


# Use vim on SSH, else nvim
if [[ -n $SSH_CONNECTION ]]; then
  EDITOR='vim'
  GIT_EDITOR='vim'
  VISUAL='vim'
else
  EDITOR='nvim'
  GIT_EDITOR='nvim'
  VISUAL='nvim'
fi

# -----------------------------------------------------------------------------
# Sourcing
# -----------------------------------------------------------------------------

source ~/.oh-my-zsh/oh-my-zsh.sh

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

alias vim='nvim'
alias python='python3'
alias pip='pip3'

alias tail-apihandler-logs='sls logs -f workflowLoopRunner --stage joenye -t'
alias tail-wf-logs='sls logs -f workflowLoopRunner --stage joenye -t'

alias reboot='shutdown -r now'
alias shutdown='shutdown now'

alias 'sudo-vim'='f() { sudo -E nvim $1 };f'

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

# https://github.com/ohmyzsh/ohmyzsh/issues/8751#issuecomment-616009741
_systemctl_unit_state() {
  typeset -gA _sys_unit_state
  _sys_unit_state=( $(__systemctl list-unit-files "$PREFIX*" | awk '{print $1, $2}') ) }

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

zmodload zsh/datetime

prompt_preexec() {
  prompt_prexec_realtime=${EPOCHREALTIME}
}

prompt_precmd() {
  if (( prompt_prexec_realtime )); then
    local -rF elapsed_realtime=$(( EPOCHREALTIME - prompt_prexec_realtime ))
    local -rF s=$(( elapsed_realtime%60 ))
    local -ri elapsed_s=${elapsed_realtime}
    local -ri m=$(( (elapsed_s/60)%60 ))
    local -ri h=$(( elapsed_s/3600 ))
    if (( h > 0 )); then
      printf -v prompt_elapsed_time '%ih%im' ${h} ${m}
    elif (( m > 0 )); then
      printf -v prompt_elapsed_time '%im%is' ${m} ${s}
    elif (( s >= 10 )); then
      printf -v prompt_elapsed_time '%.2fs' ${s} # 12.34s
    elif (( s >= 1 )); then
      printf -v prompt_elapsed_time '%.3fs' ${s} # 1.234s
    else
      printf -v prompt_elapsed_time '%ims' $(( s*1000 ))
    fi
    unset prompt_prexec_realtime
  else
    # Clear previous result when hitting ENTER with no command to execute
    unset prompt_elapsed_time
  fi
}

setopt nopromptbang prompt{cr,percent,sp,subst}

autoload -Uz add-zsh-hook
add-zsh-hook preexec prompt_preexec
add-zsh-hook precmd prompt_precmd

RPS1='%F{cyan}${prompt_elapsed_time}%F{none}'
