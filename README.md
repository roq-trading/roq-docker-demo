# roq-docker-demo

Demonstrates how to install and use Roq services from inside a container.


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

> You should update the Deribit login and secret in the `config/` directory before starting the container.

The following command will

* Launch Supervisor to manage the Roq services
* Start Roq's Deribit gateway
* Start Roq's FIX-Bridge
* Enable Supervisor's web interface on port 9001 (for monitoring logs and managing services)
* Make Roq's FIX-Bridge available on port 1234
* Share the `config/` directory (with your specific credentials) into the container
* Share the `data/` directory into the container (certain data must be persisted, e.g. user id's)

```bash
docker run -it \
    --publish 9001:9001 \
    --publish 1234:1234 \
    --volume ./config:/config:ro \
    --volume ./data:/data \
    test:1
```


## License

The project is released under the terms of the MIT license.
