import tomllib
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROJECT_FILES = ("pyproject-cpu.toml", "pyproject-gpu.toml")


class ProjectVersionTest(unittest.TestCase):
    def test_projects_pin_marker_2_and_matching_surya(self):
        for filename in PROJECT_FILES:
            with self.subTest(filename=filename):
                with (ROOT / filename).open("rb") as project_file:
                    project = tomllib.load(project_file)["project"]

                self.assertEqual(project["version"], "2.0.0")
                self.assertIn("marker-pdf[full]==2.0.0", project["dependencies"])
                self.assertIn("surya-ocr==0.22.1", project["dependencies"])


if __name__ == "__main__":
    unittest.main()
