# just for local development

set shell := ["bash", "-uc"]

IMAGE_REGISTRY := "ghcr.io/bayou-brogrammer"

default:
  just --list

setup-registry:
  #!/usr/bin/bash
  grep -Eq "registry.dev.local" /etc/hosts || \
    echo -e "\n# Container registry\n127.0.0.1 registry.dev.local" | sudo tee -a /etc/hosts

  if ! [ -f "/etc/containers/registries.conf.d/ublue-dev.conf" ]; then
    sudo touch "/etc/containers/registries.conf.d/ublue-dev.conf"
    echo '\n[[registry]]\nlocation = "registry.dev.local:5000"\ninsecure = true' | sudo tee -a /etc/containers/registries.conf.d/ublue-dev.conf
  fi

  podman container exists registry.dev.local || podman run -d --name registry.dev.local -p 5000:5000 docker.io/library/registry:latest

# ================================
# Building
# ================================

build-docker *FLAGS='':
  docker buildx build . {{FLAGS}} --progress=plain
build-docker-no-cache:
  just build --no-cache
# build-dev *FLAGS='':
#   docker buildx build . {{FLAGS}} -t registry.dev.local:5000/{{IMAGE_NAME}}:dev
#   docker push --tls-verify=false registry.dev.local:5000/{{IMAGE_NAME}}:dev

build NAME:
  just build-docker -t {{IMAGE_REGISTRY}}/{{NAME}}:latest -f ./toolboxes/{{NAME}}/Containerfile
build-arch:
  just build "arch-toolbox"
build-orora:
  just build "orora-toolbox"
build-wolfi:
  just build "wolfi-toolbox"

# ================================
# DistroBox
# ================================

# create-container:
#   distrobox create -i registry.dev.local:5000/{{IMAGE_NAME}}:dev -n {{IMAGE_NAME}}
# construct:
#   just teardown
#   just create-container
#   distrobox-enter {{IMAGE_NAME}}
# teardown :
#   distrobox-rm -f {{IMAGE_NAME}}
