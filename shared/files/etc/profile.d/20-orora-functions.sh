# shellcheck shell=sh

# Virtualenv auto activation and deactivation
cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]]; then
    ## If env folder is found then activate the vitualenv
    if [[ -d ./.env ]]; then
      source ./.env/bin/activate
    fi
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]]; then
      deactivate
    fi
  fi
}
