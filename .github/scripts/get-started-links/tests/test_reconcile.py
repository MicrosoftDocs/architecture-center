"""Tests for full TOC-to-include reconciliation."""

from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT_DIRECTORY = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SCRIPT_DIRECTORY))

from prepare_context import build_context  # noqa: E402
from toc_model import parse_categories, published_link  # noqa: E402

TOC = [
    {
        "name": "Azure categories",
        "items": [
            {
                "name": "Web applications",
                "items": [
                    {"name": "Get started", "href": "web-apps/web-apps-get-started.md"},
                    {
                        "name": "Select a service",
                        "items": [
                            {"name": "Choose hosting", "href": "guide/hosting.md"}
                        ],
                    },
                    {
                        "name": "Guides",
                        "items": [
                            {
                                "name": "Networking",
                                "items": [
                                    {
                                        "name": "Current guide",
                                        "href": "guide/current.md",
                                    }
                                ],
                            }
                        ],
                    },
                    {
                        "name": "Architectures",
                        "items": [
                            {
                                "name": "Hosting WordPress on Azure",
                                "items": [
                                    {
                                        "name": "WordPress overview",
                                        "href": "guide/wordpress.yml",
                                    }
                                ],
                            }
                        ],
                    },
                    {
                        "name": "Solution ideas",
                        "items": [
                            {"name": "SharePoint farm", "href": "ideas/sharepoint.yml"}
                        ],
                    },
                ],
            }
        ],
    }
]


class ReconcileTests(unittest.TestCase):
    """Verify the complete three-type structure supplied to the workflow."""

    def test_strips_site_navigation_query(self) -> None:
        """Ignore site navigation query parameters when comparing local links."""
        target = published_link(
            "/azure/aks/monitor-aks?toc=/azure/architecture/toc.json"
        )

        self.assertEqual(target, "/azure/aks/monitor-aks")

    def test_preserves_types_and_subsections(self) -> None:
        """Preserve recursive TOC subsections beneath exactly three types."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            context = build_context(Path(temporary_directory), categories)

        category = context["categories"][0]
        self.assertEqual(category["category"], "Web applications")
        self.assertEqual(
            [section["heading"] for section in category["sections"]],
            [
                "Web applications guides",
                "Web applications architectures",
                "Web applications solution ideas",
            ],
        )
        guide_group = category["sections"][0]["groups"][0]
        self.assertEqual(guide_group["subsections"], ["Networking"])
        architecture_group = category["sections"][1]["groups"][0]
        self.assertEqual(
            architecture_group["subsections"], ["Hosting WordPress on Azure"]
        )
        added = category["added"]
        self.assertNotIn("/azure/architecture/guide/hosting", added)
        self.assertIn("/azure/architecture/guide/wordpress", added)

    def test_preserves_wrapper_above_type(self) -> None:
        """Preserve a wrapper that contains a recognized content type.

        Some categories group their three content types beneath a named topic,
        such as SAP or Kubernetes-based hosting. The wrapper still identifies
        the subsection that must appear beneath the category-qualified H3.
        """
        toc = [
            {
                "name": "Azure categories",
                "items": [
                    {
                        "name": "Compute",
                        "items": [
                            {"name": "Get started", "href": "compute/get-started.md"},
                            {
                                "name": "SAP",
                                "items": [
                                    {
                                        "name": "Architectures",
                                        "items": [
                                            {
                                                "name": "SAP architecture",
                                                "href": "architectures/sap.yml",
                                            }
                                        ],
                                    }
                                ],
                            },
                        ],
                    }
                ],
            }
        ]
        categories = parse_categories(json.dumps(toc))
        with tempfile.TemporaryDirectory() as temporary_directory:
            context = build_context(Path(temporary_directory), categories)

        architecture_section = context["categories"][0]["sections"][0]
        architecture_group = architecture_section["groups"][0]
        self.assertEqual(architecture_group["subsections"], ["SAP"])

    def test_removes_links_outside_three_types(self) -> None:
        """Remove an include link that exists only outside the three TOC types."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            include_path = repository_root / "docs/includes/web-apps-get-started-include.md"
            include_path.parent.mkdir(parents=True)
            include_path.write_text(
                "- [Current guide](../guide/current.md)\n"
                "- [Choose hosting](../guide/hosting.md)\n",
                encoding="utf-8",
            )

            context = build_context(repository_root, categories)

        category = context["categories"][0]
        self.assertEqual(
            category["removed"], ["/azure/architecture/guide/hosting"]
        )

    def test_preserves_external_links_missing_from_toc(self) -> None:
        """Don't remove product-documentation or full external URLs.

        The TOC controls Architecture Center links. External links can provide
        useful supporting resources in an include even when the TOC doesn't
        contain them, so reconciliation must leave those links untouched.
        """
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            include_path = repository_root / "docs/includes/web-apps-get-started-include.md"
            include_path.parent.mkdir(parents=True)
            include_path.write_text(
                "- [Current guide](../guide/current.md)\n"
                "- [Old AAC guide](../guide/old.md)\n"
                "- [Product documentation](/azure/app-service/overview.md)\n"
                "- [External site](https://example.com/resource)\n",
                encoding="utf-8",
            )

            context = build_context(repository_root, categories)

        category = context["categories"][0]
        self.assertEqual(category["removed"], ["/azure/architecture/guide/old"])


if __name__ == "__main__":
    unittest.main()