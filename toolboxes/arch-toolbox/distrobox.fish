alias hx="helix"
alias ls="eza --icons"

set -gx EDITOR nvim
set -gx XDG_CACHE_HOME "$HOME/.cache-distrobox"
set -g fish_greeting

starship init fish | source
