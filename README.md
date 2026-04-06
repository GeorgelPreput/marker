# docker-image-marker

Docker image for Marker document conversion service

#### Before You Start

Due to DNS issues in configuration, it has been necessary to use the host network. If that's not the case anymore,
please ignore the CLI call below, as well as any `--builder hostnet-builder` parameters in `docker buildx build`

```bash
docker buildx create --use --name hostnet-builder --driver-opt network=host
```

## CPU-only image

- build via:

    ```bash
    docker buildx build --builder hostnet-builder --no-cache -f ./Dockerfile.cpu --load .
    ```

- run via:

    ```bash
    docker run -it -d -p 8001:8001 --name marker marker:latest-gpu
    ```

## GPU-enabled image

- build via:

    ```bash
    docker buildx build --builder hostnet-builder --no-cache -f ./Dockerfile.gpu --load .
    ```

- run via:

    ```bash
    docker run --runtime=nvidia --gpus=all -it -d -p 8001:8001 --name marker marker:latest-gpu
    ```

## Usage

```bash
curl -X POST -F 'file=@/home/user/sample.pdf' http://localhost:8001/marker/upload > ~/sample.json
```
