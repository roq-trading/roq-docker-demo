# roq-docker-demo

Demonstrates how to install several Roq services into container image and how to manage these services using Supervisor.

> This is **NOT** a low-latency configuration.
> You should install on physical and use the core-pinning features, if that is your concern.


## Design

![Design](/static/images/docker-demo.png)


## Prerequisites

Pull the base image

```bash
docker pull docker.io/condaforge/miniforge3:latest
```


## Building

Build this image

```bash
docker build --no-cache --tag test:1 .
```


## Using

> You should update the Deribit login and secret in the relevant files of the `config` directory before starting the container.

The following command will

* Assume that a ClickHouse database listens to port `8123` on `localhost`
* Mount the `config` directory (with your specific credentials) into the container
* Mount the `data` directory into the container
* Expose Supervisor's web interface on port `9001`
* Expose Roq's FIX-Bridge on port `1234`
* Start Supervisor
* Start Roq's Journal
* Start Roq's Deribit gateway
* Start Roq's FIX-Bridge

```bash
docker run -it \
    --env ROQ_DATABASE_URI=http://localhost:8123 \
    --env ROQ_DATABASE_NAME=roq \
    --volume ./config:/config:ro \
    --volume ./data:/data \
    --publish 9001:9001 \
    --publish 1234:1234 \
    test:1
```


## FAQ

### Can I deploy the services using different container images?

Yes.
You should expose the relevant port(s) if the services communicate using tcp or udp.
You should mount the '/run/roq' directory and share it between containers if the services communicate
using unix sockets and shared memory.

### How do I generate Roq's authentication keys?

Follow the instructions from [here](https://roq-trading.com/docs/reference/gateways/flags/#authentication).

> Please note that you will have to contact Roq to register your key.

### Can I use this without a valid license key?

Yes.
The gateway will function for a short period before it automatically shuts down.

### How can I collect events?

Add the gateway `--event_log_dir` flag.


## License

The project is released under the terms of the MIT license.
