"""Tests for TOC-to-include outline mirroring."""

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
                "name": "Containers",
                "items": [
                    {"name": "Get started", "href": "containers/get-started.md"},
                    {
                        "name": "Select a service",
                        "items": [
                            {"name": "Container host options", "href": "guide/choose.md"}
                        ],
                    },
                    {
                        "name": "Guides",
                        "items": [
                            {
                                "name": "Networking",
                                "items": [
                                    {"name": "Current guide", "href": "guide/current.md"}
                                ],
                            }
                        ],
                    },
                    {
                        "name": "Kubernetes-based hosting",
                        "items": [
                            {
                                "name": "Get started",
                                "href": "reference-architectures/aks-start-here.md",
                            },
                            {
                                "name": "Architectures",
                                "items": [
                                    {"name": "AKS baseline", "href": "reference-architectures/baseline.yml"}
                                ],
                            },
                        ],
                    },
                ],
            }
        ],
    }
]


def _find(nodes, name):
    """Return the first node with the given name in an outline list."""
    return next(node for node in nodes if node["name"] == name)


class OutlineTests(unittest.TestCase):
    """Verify the deterministic outline supplied to the workflow."""

    def test_strips_site_navigation_query(self) -> None:
        """Ignore site navigation query parameters when comparing local links."""
        target = published_link(
            "/azure/aks/monitor-aks?toc=/azure/architecture/toc.json"
        )

        self.assertEqual(target, "/azure/aks/monitor-aks")

    def test_mirrors_toc_order_and_nesting(self) -> None:
        """Reproduce every top-level node in TOC order, minus Get started."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            context = build_context(Path(temporary_directory), categories)

        category = context["categories"][0]
        self.assertEqual(category["category"], "Containers")
        self.assertEqual(
            category["getStartedArticle"], "docs/containers/get-started.md"
        )
        self.assertEqual(
            [node["name"] for node in category["outline"]],
            ["Select a service", "Guides", "Kubernetes-based hosting"],
        )

    def test_heading_levels_start_at_three(self) -> None:
        """Top-level sections are H3 and nested sections deepen by one."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            context = build_context(Path(temporary_directory), categories)

        outline = context["categories"][0]["outline"]
        guides = _find(outline, "Guides")
        self.assertEqual(guides["kind"], "section")
        self.assertEqual(guides["headingLevel"], 3)
        networking = _find(guides["children"], "Networking")
        self.assertEqual(networking["headingLevel"], 4)
        current = _find(networking["children"], "Current guide")
        self.assertEqual(current["kind"], "link")
        self.assertEqual(
            current["target"], "/azure/architecture/guide/current"
        )

    def test_direct_links_precede_subsections(self) -> None:
        """A section renders its direct links before its subsections."""
        toc = [
            {
                "name": "Azure categories",
                "items": [
                    {
                        "name": "Internet of Things",
                        "items": [
                            {"name": "Get started", "href": "iot/get-started.md"},
                            {
                                "name": "Guides",
                                "items": [
                                    {
                                        "name": "OPC UA reference solution",
                                        "items": [
                                            {"name": "Overview", "href": "guide/opc.md"}
                                        ],
                                    },
                                    {"name": "Scale IoT solutions", "href": "guide/scale.md"},
                                ],
                            }
                        ],
                    }
                ],
            }
        ]
        categories = parse_categories(json.dumps(toc))
        with tempfile.TemporaryDirectory() as temporary_directory:
            context = build_context(Path(temporary_directory), categories)

        guides = context["categories"][0]["outline"][0]
        self.assertEqual(
            [(child["name"], child["kind"]) for child in guides["children"]],
            [("Scale IoT solutions", "link"), ("OPC UA reference solution", "section")],
        )

    def test_excludes_only_own_get_started(self) -> None:
        """Exclude the category Get started but keep nested Get started nodes."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            context = build_context(Path(temporary_directory), categories)

        outline = context["categories"][0]["outline"]
        self.assertNotIn("Get started", [node["name"] for node in outline])
        hosting = _find(outline, "Kubernetes-based hosting")
        nested = _find(hosting["children"], "Get started")
        self.assertEqual(nested["kind"], "link")
        self.assertEqual(
            nested["target"],
            "/azure/architecture/reference-architectures/aks-start-here",
        )

    def test_removes_aac_links_absent_from_toc(self) -> None:
        """Flag Architecture Center include links that left the TOC."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            include_path = (
                repository_root / "docs/includes/containers-get-started-include.md"
            )
            include_path.parent.mkdir(parents=True)
            include_path.write_text(
                "- [Current guide](../guide/current.md)\n"
                "- [Retired guide](../guide/retired.md)\n",
                encoding="utf-8",
            )

            context = build_context(repository_root, categories)

        category = context["categories"][0]
        self.assertEqual(
            category["removed"], ["/azure/architecture/guide/retired"]
        )

    def test_preserves_external_links_missing_from_toc(self) -> None:
        """Never remove product-documentation or full external URLs."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            include_path = (
                repository_root / "docs/includes/containers-get-started-include.md"
            )
            include_path.parent.mkdir(parents=True)
            include_path.write_text(
                "- [Current guide](../guide/current.md)\n"
                "- [Product documentation](/azure/aks/intro.md)\n"
                "- [External site](https://example.com/resource)\n",
                encoding="utf-8",
            )

            context = build_context(repository_root, categories)

        category = context["categories"][0]
        self.assertEqual(category["removed"], [])

    def test_reports_added_toc_links(self) -> None:
        """Flag TOC links missing from the include as additions."""
        categories = parse_categories(json.dumps(TOC))
        with tempfile.TemporaryDirectory() as temporary_directory:
            context = build_context(Path(temporary_directory), categories)

        added = context["categories"][0]["added"]
        self.assertIn("/azure/architecture/guide/choose", added)
        self.assertIn("/azure/architecture/reference-architectures/baseline", added)

    def test_caps_heading_depth_beyond_h6(self) -> None:
        """Render sections nested past H6 as bold labels (null level)."""
        toc = [
            {
                "name": "Azure categories",
                "items": [
                    {
                        "name": "Compute",
                        "items": [
                            {"name": "Get started", "href": "compute/get-started.md"},
                            {
                                "name": "L3",
                                "items": [
                                    {
                                        "name": "L4",
                                        "items": [
                                            {
                                                "name": "L5",
                                                "items": [
                                                    {
                                                        "name": "L6",
                                                        "items": [
                                                            {
                                                                "name": "L7",
                                                                "items": [
                                                                    {
                                                                        "name": "Deep link",
                                                                        "href": "guide/deep.md",
                                                                    }
                                                                ],
                                                            }
                                                        ],
                                                    }
                                                ],
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

        node = context["categories"][0]["outline"][0]
        for expected_level in (3, 4, 5, 6):
            self.assertEqual(node["headingLevel"], expected_level)
            node = node["children"][0]
        self.assertEqual(node["name"], "L7")
        self.assertIsNone(node["headingLevel"])


if __name__ == "__main__":
    unittest.main()