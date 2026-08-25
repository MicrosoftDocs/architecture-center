"""Simple tests for current TOC-to-include reconciliation."""

from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT_DIRECTORY = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SCRIPT_DIRECTORY))

from prepare_context import build_context  # noqa: E402
from toc_model import parse_categories  # noqa: E402

TOC = [
    {
        "name": "Azure categories",
        "items": [
            {
                "name": "Analytics",
                "items": [
                    {"name": "Get started", "href": "analytics/analytics-get-started.md"},
                    {
                        "name": "Guides",
                        "items": [
                            {"name": "Current guide", "href": "guide/current.md"}
                        ],
                    },
                ],
            }
        ],
    }
]


class ReconcileTests(unittest.TestCase):
    """Verify the two direct link-set differences used by the workflow."""

    def test_reports_link_missing_from_include(self) -> None:
        """Report a current TOC link as added when the include is empty."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            context = build_context(Path(temporary_directory), categories)

        change = context["categories"][0]["changes"][0]
        self.assertEqual(change["added"], ["/azure/architecture/guide/current"])
        self.assertEqual(change["removed"], [])

    def test_reports_link_missing_from_toc(self) -> None:
        """Report an include link as removed when it isn't in the current TOC."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            include_path = repository_root / "docs/includes/analytics-get-started-include.md"
            include_path.parent.mkdir(parents=True)
            include_path.write_text(
                "- [Current guide](../guide/current.md)\n"
                "- [Old guide](../guide/old.md)\n",
                encoding="utf-8",
            )

            context = build_context(repository_root, categories)

        change = context["categories"][0]["changes"][0]
        self.assertEqual(change["added"], [])
        self.assertEqual(change["removed"], ["/azure/architecture/guide/old"])


if __name__ == "__main__":
    unittest.main()