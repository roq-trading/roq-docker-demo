# roq-docker-demo

Demonstrates how to install several Roq services into container image and how to manage these using Supervisor.

![Design](/static/images/docker.png)


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


## License

The project is released under the terms of the MIT license.
