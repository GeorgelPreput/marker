import importlib.metadata
import runpy
import sys
import types
import unittest
from pathlib import Path
from unittest.mock import patch


PATCH_FILE = Path(__file__).resolve().parents[1] / "marker_sitecustomize.py"
EXPECTED_MARKER_VERSION = "2.0.0"


class FakeImage:
    def __init__(self, content_type):
        self.content_type = content_type


class FakeShape:
    def __init__(self, content_type):
        self.image = FakeImage(content_type)


def load_patch(installed_version):
    class FakePowerPointProvider:
        def _handle_image(self, shape):
            return f"original:{shape.image.content_type}"

    class FakeLogger:
        def __init__(self):
            self.messages = []

        def warning(self, message):
            self.messages.append(message)

    logger = FakeLogger()
    modules = {
        "marker": types.ModuleType("marker"),
        "marker.logger": types.ModuleType("marker.logger"),
        "marker.providers": types.ModuleType("marker.providers"),
        "marker.providers.powerpoint": types.ModuleType("marker.providers.powerpoint"),
    }
    modules["marker.logger"].get_logger = lambda: logger
    modules["marker.providers.powerpoint"].PowerPointProvider = FakePowerPointProvider

    with patch.object(importlib.metadata, "version", return_value=installed_version):
        with patch.dict(sys.modules, modules):
            runpy.run_path(PATCH_FILE, run_name="marker_sitecustomize_test")

    return FakePowerPointProvider, logger


class MarkerSitecustomizeTest(unittest.TestCase):
    def test_omits_wmf_and_emf_images(self):
        provider_type, logger = load_patch(EXPECTED_MARKER_VERSION)
        provider = provider_type()

        for content_type in ("image/x-wmf", "image/x-emf"):
            with self.subTest(content_type=content_type):
                self.assertEqual(provider._handle_image(FakeShape(content_type)), "")

        self.assertEqual(len(logger.messages), 2)

    def test_delegates_other_images(self):
        provider_type, _ = load_patch(EXPECTED_MARKER_VERSION)
        result = provider_type()._handle_image(FakeShape("image/png"))
        self.assertEqual(result, "original:image/png")

    def test_rejects_a_different_marker_version(self):
        with self.assertRaisesRegex(
            SystemExit, f"expects marker-pdf {EXPECTED_MARKER_VERSION}"
        ):
            load_patch("0.0.0")


if __name__ == "__main__":
    unittest.main()
