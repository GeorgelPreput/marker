# marker

Unofficial Docker images for [Marker](https://github.com/datalab-to/marker), an open-source document conversion
tool by [Datalab](https://www.datalab.to). Marker converts PDFs, images, and office files (DOCX, PPTX, XLSX, HTML,
EPUB) into Markdown, JSON, or HTML, with accurate handling of tables, equations, forms, code blocks, and more.

Datalab offers a paid, hosted version of Marker with a managed API — see their website for details.
**We are in no way affiliated with Datalab or the Marker project.**

The images package the [`marker-pdf`](https://pypi.org/project/marker-pdf/) PyPI package and expose Marker's
built-in REST API on port `8001`.

## Available tags

All tags are multi-arch manifests covering `amd64` and `arm64`.

| Tag | Description |
|-----|-------------|
| `latest`, `latest-cpu`, `vX.Y.Z-cpu` | CPU-only build |
| `latest-gpu`, `vX.Y.Z-gpu` | GPU-accelerated build (NVIDIA only, CUDA 13.0) |

## Building locally

#### Before You Start

Due to DNS issues in configuration, it has been necessary to use the host network. If that's not the case anymore,
please ignore the CLI call below, as well as any `--builder hostnet-builder` parameters in `docker buildx build`

```bash
docker buildx create --use --name hostnet-builder --driver-opt network=host
```

### CPU-only image

- build via:

    ```bash
    docker buildx build --builder hostnet-builder --no-cache --provenance=false -f ./Dockerfile.cpu --load .
    ```

- run via:

    ```bash
    docker run -it -d -p 8001:8001 --name marker marker:latest-cpu
    ```

### GPU-enabled image

Requires an NVIDIA GPU with the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html) installed on the host. Built against CUDA 13.0.

- build via:

    ```bash
    docker buildx build --builder hostnet-builder --no-cache --provenance=false -f ./Dockerfile.gpu --load .
    ```

- run via:

    ```bash
    docker run --runtime=nvidia --gpus=all -it -d -p 8001:8001 --name marker marker:latest-gpu
    ```

## Usage

```bash
curl -X POST -F 'file=@/home/user/sample.pdf' http://localhost:8001/marker/upload > ~/sample.json
```
