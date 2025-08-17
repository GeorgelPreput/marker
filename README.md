# docker-image-marker

Docker image for Marker document conversion service

## CPU-only image

- build via:

    ```bash
    docker build --build-arg BASE_IMAGE=python:3.13-slim-bookworm --build-arg BUILD_TYPE=cpu -t marker:cpu .
    ```

- run via:

    ```bash
    docker run -p 8001:8001 marker:cpu
    ```

## GPU-enabled image

- build via:

    ```bash
    docker build --build-arg BASE_IMAGE=nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04 --build-arg BUILD_TYPE=gpu -t marker:gpu .
    ```

- run via:

    ```bash
    docker run --runtime=nvidia --gpus=all -it -d -p 8001:8001 marker:gpu
    ```

## Usage

```bash
curl -X POST -F 'file=@/home/user/sample.pdf' http://localhost:8001/marker/upload > ~/sample.json
```