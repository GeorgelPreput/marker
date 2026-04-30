# marker

Unofficial Docker images for [Marker](https://github.com/datalab-to/marker), an open-source document conversion
tool by [Datalab](https://www.datalab.to). Marker converts PDFs, images, and office files (DOCX, PPTX, XLSX, HTML,
EPUB) into Markdown, JSON, or HTML, with accurate handling of tables, equations, forms, code blocks, and more.

Datalab offers a paid, hosted version of Marker with a managed API — see their website for details.
**I am in no way affiliated with Datalab or the Marker project.**

The images package the [`marker-pdf`](https://pypi.org/project/marker-pdf/) PyPI package and expose Marker's
built-in REST API on port `8001`.

#### Licensing

The GPL-3 license of this repository does not reflect the license of Marker itself, but rather only applies to the packaging into Docker images controlled by this repository. Please consult Datalab's license to see in what conditions you can use their product.

#### Notice regarding the GitHub repository

> The [GitHub repository](https://github.com/GeorgelPreput/marker) hosting these files is a mirror of my internal repo I work in. Issues are most welcome, but if you open PR's, expect me to copy your changes into my own development stack and test it. I won't be merging your PRs into this mirror directly.

#### AI notice

Although it started as a fully-human setup, since April 2026 I've been using Claude to help speed things up.

## Available tags

CPU and GPU tags are multi-arch manifests covering `amd64` and `arm64`. Tegra tags have been built on, and target the NVIDIA Jetson Thor. Don't know if they will work on past generations, nor do I have the hardware to try.

| Tag | Description |
|-----|-------------|
| `latest`, `latest-cpu`, `vX.Y.Z-cpu` | CPU-only build |
| `latest-gpu`, `vX.Y.Z-gpu` | GPU-accelerated build (NVIDIA only, CUDA 13.0) |
| `latest-tegra`, `vX.Y.Z-tegra` | NVIDIA Jetson Thor build |

## Building locally

See [docs/building-locally.md](docs/building-locally.md) for the full walkthrough using the `Makefile`.

## Usage

```bash
curl -X POST -F 'file=@/home/user/sample.pdf' http://localhost:8001/marker/upload > ~/sample.json
```
