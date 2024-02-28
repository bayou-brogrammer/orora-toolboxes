# shellcheck shell=sh

export XDG_CACHE_HOME=/XDG_DIRS/cache
export XDG_CONFIG_HOME=/XDG_DIRS/config
export XDG_DATA_HOME=/XDG_DIRS/local/share
export XDG_STATE_HOME=/XDG_DIRS/local/state

if [ ! -G /XDG_DIRS ]; then
  echo "Setting permissions for XDG_DIRS..."
  sudo chown -R "$USER":"$USER" /XDG_DIRS/
fi
