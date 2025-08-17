# For a CPU-only build, use the following build command:
#   docker build --build-arg BASE_IMAGE=python:3.13-slim-bookworm --build-arg BUILD_TYPE=cpu -t marker:cpu .

# For a CUDA-enabled build, use the following build command:
#   docker build --build-arg BASE_IMAGE=nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04 --build-arg BUILD_TYPE=gpu -t marker:gpu .

ARG BASE_IMAGE=python:3.13-slim-bookworm
ARG BUILD_TYPE=cpu
FROM ${BASE_IMAGE} AS builder

ARG BUILD_TYPE
LABEL build_type=${BUILD_TYPE}

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential curl wget python3 python-is-python3 software-properties-common && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# CUDA Keyring for Ubuntu doesn't get accepted, but the Debian 12 one is. Go figure.
RUN if [ "$BUILD_TYPE" = "gpu" ]; then \
    wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm cuda-keyring_1.1-1_all.deb && \
    apt-get update && \
    apt-get -y install libcusparselt0 libcusparselt-dev cuda-toolkit-12-6; \
    else \
    echo "Skipping cuSPARSELt and CUPTI installation for non-GPU build"; \
    fi

RUN useradd --create-home --shell /bin/bash app
ENV HOME=/home/app

USER app
WORKDIR /home/app

ADD --chown=app:app https://astral.sh/uv/install.sh install.sh
RUN chmod -R 755 install.sh && ./install.sh && rm install.sh

ENV PATH="/home/app/.local/bin:${PATH}"

COPY pyproject-${BUILD_TYPE}.toml pyproject.toml
RUN uv sync

ENV PATH="/home/app/.venv/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda-12.6/lib64:${LD_LIBRARY_PATH}"
ENV CUDA_HOME="/usr/local/cuda-12.6"

EXPOSE 8001

CMD ["marker_server", "--host", "0.0.0.0", "--port", "8001"]