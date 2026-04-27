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

See [docs/building-locally.md](docs/building-locally.md) for the full walkthrough using the `Makefile`.

## Usage

```bash
curl -X POST -F 'file=@/home/user/sample.pdf' http://localhost:8001/marker/upload > ~/sample.json
```
