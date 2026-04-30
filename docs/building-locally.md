# Building locally

The repository ships a `Makefile` that mirrors the CI pipeline. Each Dockerfile gets its own build target, and
separate push and manifest targets let you publish individual arch images or combined multi-arch manifest lists.

## Build a single image

Pick the target that matches the variant and architecture you want to build:

| Target | Dockerfile | Platform |
|--------|-----------|----------|
| `make build-cpu-amd64` | `Dockerfile.cpu-amd64` | `linux/amd64` |
| `make build-cpu-arm64` | `Dockerfile.cpu-arm64` | `linux/arm64` |
| `make build-gpu-amd64` | `Dockerfile.gpu-amd64` | `linux/amd64` |
| `make build-gpu-arm64` | `Dockerfile.gpu-arm64` | `linux/arm64` |
| `make build-tegra-arm64` | `Dockerfile.tegra-arm64` | `linux/arm64` |

The version tag is read automatically from the matching pyproject file — `pyproject-cpu.toml` for CPU images and
`pyproject-gpu.toml` for GPU and tegra images — so the resulting image is tagged
`georgelpreput/marker:vX.Y.Z-<variant>-<arch>` (e.g. `georgelpreput/marker:v1.8.0-cpu-amd64`).

## Push an arch-tagged image

After building, push the arch-specific image to Docker Hub with the matching push target:

```bash
make build-cpu-amd64
make push-cpu-amd64
```

The full set of push targets is `push-cpu-amd64`, `push-cpu-arm64`, `push-gpu-amd64`, `push-gpu-arm64`,
`push-tegra-arm64`.

## Publish multi-arch manifest lists

Once both arch images for a variant are pushed, create and push the combined multi-arch manifest lists:

```bash
# CPU: creates vX.Y.Z-cpu, latest-cpu, and latest
make manifest-cpu

# GPU: creates vX.Y.Z-gpu and latest-gpu
make manifest-gpu

# Tegra: creates vX.Y.Z-tegra and latest-tegra (arm64 only, no multi-arch)
make manifest-tegra
```

These are the same final tags served to `docker pull` users.

## Full release workflow example

```bash
# 1. Build all images (CPU/GPU can be cross-built; tegra must run on or target arm64)
make build-gpu-amd64
make build-cpu-amd64
make build-gpu-arm64
make build-cpu-arm64
make build-tegra-arm64

# 2. Push the arch-tagged images
make push-gpu-amd64
make push-cpu-amd64
make push-gpu-arm64
make push-cpu-arm64
make push-tegra-arm64

# 3. Combine into multi-arch manifests
make manifest-cpu
make manifest-gpu
make manifest-tegra
```

## Running the built image

CPU-only:

```bash
docker run -it -d -p 8001:8001 --name marker georgelpreput/marker:latest-cpu
```

GPU-accelerated (requires an NVIDIA GPU and the
[NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html),
built against CUDA 13.0):

```bash
docker run --runtime=nvidia --gpus=all -it -d -p 8001:8001 --name marker georgelpreput/marker:latest-gpu
```

Tegra / Jetson (requires the NVIDIA Container Toolkit configured for Jetson, tested on Jetson Thor with
JetPack r36.4.0):

```bash
docker run --runtime=nvidia --gpus=all -it -d -p 8001:8001 --name marker georgelpreput/marker:latest-tegra
```
