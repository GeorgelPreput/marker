import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DOCKERFILES = (
    "Dockerfile.cpu-amd64",
    "Dockerfile.cpu-arm64",
    "Dockerfile.gpu-amd64",
    "Dockerfile.gpu-arm64",
    "Dockerfile.tegra-arm64",
)
COPY_PATCH = (
    "COPY --chown=app:app marker_sitecustomize.py "
    "/home/app/marker-patch/sitecustomize.py"
)
SET_PYTHONPATH = 'ENV PYTHONPATH="/home/app/marker-patch"'
SMOKE_TEST = (
    "RUN python -c \"from marker.providers.powerpoint import PowerPointProvider; "
    "assert PowerPointProvider._handle_image.__module__ == 'sitecustomize'\""
)


class DockerfileTest(unittest.TestCase):
    def test_all_images_load_the_patch_from_the_virtual_environment(self):
        for filename in DOCKERFILES:
            with self.subTest(filename=filename):
                text = (ROOT / filename).read_text()
                sync_position = text.index("RUN uv sync")
                path_position = text.index('ENV PATH="/home/app/.venv/bin:${PATH}"')
                copy_position = text.index(COPY_PATCH)
                pythonpath_position = text.index(SET_PYTHONPATH)
                smoke_position = text.index(SMOKE_TEST)

                self.assertLess(sync_position, path_position)
                self.assertLess(path_position, copy_position)
                self.assertLess(copy_position, pythonpath_position)
                self.assertLess(pythonpath_position, smoke_position)


if __name__ == "__main__":
    unittest.main()
