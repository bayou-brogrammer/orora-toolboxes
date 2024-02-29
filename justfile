set shell := ["bash", "-uc"]

IMAGE_REGISTRY := "ghcr.io/bayou-brogrammer"

[private]
default:
    just --list

# ================================
# Building
# ================================

build TOOLBX="orora-cli":
    just build-docker -t {{ IMAGE_REGISTRY }}/{{ TOOLBX }}:latest -f ./toolboxes/{{ TOOLBX }}/Containerfile

build-orora:
    just build "orora-cli"

build-wolfi:
    just build "wolfi-toolbox"

build-arch:
    just build "arch-toolbox"

[private]
build-docker *FLAGS='':
    docker buildx build . {{ FLAGS }} --progress=plain

[private]
build-docker-no-cache:
    just build --no-cache

# build-dev *FLAGS='':
#   docker buildx build . {{FLAGS}} -t registry.dev.local:5000/{{IMAGE_NAME}}:dev
#   docker push --tls-verify=false registry.dev.local:5000/{{IMAGE_NAME}}:dev
# ================================
# DistroBox
# ================================

create-container TOOLBX:
    distrobox create -i registry.dev.local:5000/{{ IMAGE_REGISTRY }}/{{ TOOLBX }}:dev -n {{ TOOLBX }}

construct TOOLBX:
    just teardown {{ TOOLBX }}
    just create-container {{ TOOLBX }}
    distrobox-enter {{ TOOLBX }}

teardown TOOLBX:
    distrobox-rm -f {{ TOOLBX }}

[private]
setup-registry:
    #!/usr/bin/bash
    grep -Eq "registry.dev.local" /etc/hosts || \
      echo -e "\n# Container registry\n127.0.0.1 registry.dev.local" | sudo tee -a /etc/hosts

    if ! [ -f "/etc/containers/registries.conf.d/ublue-dev.conf" ]; then
      sudo touch "/etc/containers/registries.conf.d/ublue-dev.conf"
      echo -e '\n[[registry]]\nlocation = "registry.dev.local:5000"\ninsecure = true' | sudo tee -a /etc/containers/registries.conf.d/ublue-dev.conf
    fi

    podman container exists registry.dev.local || podman run -d --name registry.dev.local -p 5000:5000 docker.io/library/registry:latest
