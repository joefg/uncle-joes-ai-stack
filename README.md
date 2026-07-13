# Uncle Joe's AI Stack

This is what I use for my AI compute needs.

## Included

* Ollama, for inference;
* Open WebUI, as a ChatGPT-like front-end.

## Prerequisites

This requires docker, docker-compose, and the [nvidia container
toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).
A script to install these on Ubuntu is available in `scripts/install-docker.sh`.

You may also need [Tailscale](https://tailscale.com/download) so you can access
your AI box from anywhere in the world on the same VPN. Follow
those instructions.

## Use

A `runfile` is provided for your convenience.

```
Uncle Joe's AI Stack

help              : Display help text
restore           : Fetch dependencies
build             : Build images
lint              : Lint codebase
dev               : Spawn a development environment
serve             : Spawn prod service
stop              : Halt prod service
console <service> : Open an administration console for a service
```

You will need to configure your environment variables, a
sample is provided. Please change those variables.
