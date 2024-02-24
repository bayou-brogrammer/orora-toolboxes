# Orora Toolboxes

<div align="center" width="50%">
  <img width="75%" alt="orora" src="assets/thumbnail.webp">
</div>

Centralized repository of my personal containers designed for Toolbox/Distrobox with batteries included. These toolboxes strive for:

- Instant launch
- Include quadlets and systemd service units for management
- Intended to be used as general purpose toolboxes for "daily driver" usage
- Can be used with [boxkit](https://github.com/ublue-os/boxkit) as base images to manage your own custom setup

## Images

- `wolfi-toolbox` - a WolfiOS base image
- `orora-cli` - an Alpine Edge based image with Homebrew and a strongly opinionated default experience

It is strongly recommended that the [Prompt terminal](https://gitlab.gnome.org/chergert/prompt) be used with these toolboxes.

## Automatic Toolbox Startup

### Quadlets

Podman supports starting containers via a systemd generator. Quadlets replaced the `podman generate systemd` command and provide a method to create a systemd service for managing your container. The generated unit file can automatically start your container on login, automatically check for updates from the registry, and automatically clean-up the container and any transient volumes when the container stops. This provides an ideal way to have a clean slate on each login.

Inside the quadlets directory are example quadlets each of the toolboxes listed above. Distrobox and Toolbox provide a convenient way to integrate the containers into your host. `wolfi-toolbox` and `orora-cli` are currently only compatible with distrobox. 

The quadlets mimic the create and enter commands to setup the container. You can use these by copying them to `~/.config/containers/systemd`. When using the Prompt terminal, they will appear in the menu as available containers. The `Exec=` line of the distrobox quadlets can be modified to include additional packages.

To get automatic updates you will need to enable `podman-auto-update.timer` which by default will auto-update at midnight. Quadlets support creating volumes using a `.volume` unit. These volumes can be accessed by other containers by prepending the name of `.volume` with `systemd`.

### Systemd one-shots

An alternative method for having automatic toolbox startup is to leverage systemd one-shot services and distrobox assemble commands.

Distrobox assemble enables the user to declare a setup without going through the process of creating a customized image. Instead, an ini style file can be used with `distrobox-assemble` and `distrobox-enter` to setup and enter a modified container. Example assemble files are available here and on the universal-blue discourse.

To utilize these, place the user service file in `~/.config/systemd/user` and make sure the assemble file is in place. The ones inside the repo are set to replace the existing container of the same to behave similar to the quadlet. Again you can access `.volume` by using the name of the volume unit prepended with `systemd`.

### Orora-CLI

`orora-cli` is built from `alpine:edge`. It contains [Homebrew](https://brew.sh/) configured out of the box. The brew state is bind mounted to a directory from your `$HOME`. Unlike the other toolboxes, `orora-cli` is intended for CLI applications _only_. 

It's primary purpose is to be **the** command line companion to Flathub-enabled systems by providing access to one of the largest command line repositories in the world via homebrew. Developer dependencies should be managed seperately via [devcontainers](https://github.com/devcontainers).  

The default configuration destroys and updates this container daily so that the toolbox is built from scratch.

Updates to brew itself happen automatically when the container rebuilds. Brew will automatically upgrade packages as you use it. Brew's state is also volume mounted to a file in your home directory so your container is fresh but your packages remain untouched. At this time it is **strongly recommended** to maintain a backup of your brew package list via the [brew bundle](https://docs.brew.sh/Manpage#bundle-subcommand) subcommand.  

The [WolfiOS](https://edu.chainguard.dev/open-source/wolfi/overview/) apk package manager is preferred for fully declarative setups with [boxkit](https://github.com/ublue-os/boxkit). You can file package requests on the [WolfiOS repository](https://github.com/wolfi-dev/) for packages that you may need. We are working on a way to do this locally as well. 

The intended endstate of `orora-cli` is a fully automated declarative config managed via git using Wolfi packages for clean rebuilds daily. `brew` is used to fill out the "long tail" of existing software.

`wolfi-toolbox` have Wolfi developer variants built from the Wolfi SDK image, intended for Wolfi package and image development. They include utilities such as melange, wolfictl, and apko. These images are labelled `wolfi-dx-toolbox`.