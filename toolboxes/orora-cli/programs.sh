#!/bin/bash

set -ouex pipefail

# Rust
if [ ! -d "$HOME/.cargo" ]; then
	curl https://sh.rustup.rs -sSf | sh -s -- -y
fi

# Tmux
# mv /tmux /XDG_DIRS/config/tmux &&
# 	source /etc/profile.d/01-orora-xdg.sh &&
# 	git clone https://github.com/tmux-plugins/tpm /XDG_D4IRS/config/tmux/plugins/tpm &&
# 	/XDG_DIRS/config/tmux/plugins/tpm/bin/install_plugins
