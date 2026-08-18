# Uncle Joe's AI Stack

This is what I use for my AI compute needs.

## Included

* Ollama, for inference;
* Open WebUI, as a ChatGPT-like front-end;
* Hermes, an agent.

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

## Configuration

### Network access

> TL;DR Use a reverse proxy if you can't wall off the server behind
> a NAT or a DMZ and access through Tailscale. Otherwise, localhost
> only.

By default, all services are bound to `127.0.0.1`, which means they
are only accessible to `localhost`. For server use, you have two options:

1. Reverse proxy. This takes requests from an open port and forwards them to
a service running on localhost only. Here's a basic
[Caddy](https://caddyserver.com/docs) setup.

```Caddyfile
://api.yourdomain.com {
    # Automatic HTTPS is handled automatically by Caddy
    
    # Require Bearer token for all endpoints
    @auth {
        header Authorization "Bearer YOUR_SECRET_API_KEY"
    }

    # Forward authorized traffic to Ollama
    reverse_proxy @auth http://localhost:11434 {
        # Optional: increase timeout for long text generation
        transport http {
            read_timeout 300s
        }
    }

    # Reject unauthorized requests
    handle {
        respond "Unauthorized - Invalid API Key" 401
    }
}
```

This uses a Bearer token, which your harness or model of your choice
can configure.

2. You can expose services to `0.0.0.0`, meaning "all network devices".
**This is profoundly unwise on almost all services**. If you can hide the
device behind a NAT or a DMZ (and access it entirely though a VPN such as
Tailscale) this is OK, but **never, ever expose things to 0.0.0.0 on
a production server**.

3. You can (and should!) use Tailscale, but you may run into issues if you
use Tailscale's SSH. It offers an authentication layer where you can log in
with GitHub, but I find that most SSH utilities fall when doing so because
Tailscale's SSH is an unofficial extension.

### ollama

You may need to use `./run console ollama` to get a shell in the ollama
container and `ollama pull` your models. Open WebUI can also do this
in settings.

The url of the API available inside the Docker network is going to be
`http://ollama:11434/v1`, which doesn't require auth. This is inside
the network. If you want to expose it to the wider network see above.
