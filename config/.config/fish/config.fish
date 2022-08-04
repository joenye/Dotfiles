set fish_greeting

fish_add_path ~/bin
fish_add_path ~/.toolbox/bin
fish_add_path /opt/homebrew/bin

alias vim 'nvim'

if type -q exa
  alias ll 'exa -l -g --icons'
  alias lla 'll -a'
end
