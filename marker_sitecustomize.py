"""Omit PPTX pictures that Pillow cannot rasterize on Linux."""

from importlib.metadata import version


EXPECTED_MARKER_VERSION = "2.0.0"
UNSUPPORTED_IMAGE_TYPES = {"image/x-wmf", "image/x-emf"}


def _apply():
    installed_version = version("marker-pdf")
    if installed_version != EXPECTED_MARKER_VERSION:
        raise SystemExit(
            f"WMF/EMF patch expects marker-pdf {EXPECTED_MARKER_VERSION}, "
            f"but {installed_version} is installed"
        )

    from marker.logger import get_logger
    from marker.providers.powerpoint import PowerPointProvider

    logger = get_logger()
    original_handle_image = PowerPointProvider._handle_image

    def handle_image(self, shape):
        content_type = shape.image.content_type
        if content_type in UNSUPPORTED_IMAGE_TYPES:
            logger.warning(f"Skipping unsupported PowerPoint image: {content_type}")
            return ""
        return original_handle_image(self, shape)

    PowerPointProvider._handle_image = handle_image


_apply()
