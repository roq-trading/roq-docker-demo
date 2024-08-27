Docker demo

podman pull docker.io/condaforge/miniforge3:latest

podman build --no-cache --tag test:1 .

podman run -it -p9001:9001 -v .:/etc/roq:ro test:1
