# Virtualenv auto activation and deactivation
function cd() {
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

# Remap vagrant command to use podman
vagrant() {
	podman run -it --rm \
		-e LIBVIRT_DEFAULT_URI \
		-v /var/run/libvirt/:/var/run/libvirt/ \
		-v ~/.vagrant.d:/.vagrant.d \
		-v $(realpath "${PWD}"):${PWD} \
		-w "${PWD}" \
		--network host \
		--entrypoint /bin/bash \
		--security-opt label=disable \
		docker.io/vagrantlibvirt/vagrant-libvirt:latest \
		vagrant $@
}
