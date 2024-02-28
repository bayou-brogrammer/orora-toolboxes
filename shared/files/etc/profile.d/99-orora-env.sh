# shellcheck shell=bash

export EDITOR=nvim
export DELTA_PAGER="less -R"

eval "$(zoxide init bash)"

STARSHIP_CONFIG=/etc/starship.toml
export STARSHIP_CONFIG
eval "$(starship init bash)"

# Enable fzf keybindings
[ -r /run/host/usr/share/fzf/shell/key-bindings.bash ] &&
  . /run/host/usr/share/fzf/shell/key-bindings.bash

# Enable atuin and bash-prexec
source /usr/share/bash-prexec

# Atuin
bind -x '"\C-p": __atuin_history --shell-up-key-binding'
eval "$(atuin init bash)"

# Enable zoxide
eval "$(zoxide init bash --cmd cd)"
