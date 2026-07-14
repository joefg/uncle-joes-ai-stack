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

### ollama

You may need to use `./run console ollama` to get a shell in the ollama
container and `ollama pull` your models.

The url of the API available inside the Docker network is going to be
`http://ollama:11434/v1`, which doesn't require auth. This is inside
the network. To use it outside of the docker network you would need
to expose ollama to the network through `0.0.0.0`, and change
the API location in your apps to `http://<your-hostname>:11434/v1`.

This is fine on a local network if you're just keeping it inside Tailscale.

It is **profoundly unwise** to expose it through `0.0.0.0` (all network
interfaces) to the outside world. If you want an exposed instance, you should
put it behind a reverse proxy. You can do so with
[Caddy](https://caddyserver.com/docs/). A `Caddyfile` for this would look like:

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
