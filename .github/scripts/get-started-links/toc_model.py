"""Map Azure category names to their get-started parent articles.
"""

from __future__ import annotations

from pathlib import PurePosixPath

import yaml

GET_STARTED_NAME = "Get started"


def parse_categories(toc_text: str) -> dict[str, str]:
    """Map each Azure category name to its Get started article path.

    A category qualifies when it has a top-level Get started node whose href
    points to a Markdown or YAML article. That article hosts the managed
    include.
    """
    document = yaml.safe_load(toc_text)
    root_items = document if isinstance(document, list) else document.get("items", [])
    if not isinstance(root_items, list):
        raise ValueError("docs/toc.yml must contain a root item array.")
    categories_root = next(
        (
            item
            for item in root_items
            if isinstance(item, dict) and item.get("name") == "Azure categories"
        ),
        None,
    )
    if not isinstance(categories_root, dict) or not isinstance(
        categories_root.get("items"), list
    ):
        raise ValueError("docs/toc.yml does not contain the Azure categories subtree.")
    categories: dict[str, str] = {}
    for category_node in categories_root["items"]:
        if not isinstance(category_node, dict):
            continue
        category_name = category_node.get("name")
        category_items = category_node.get("items")
        if not isinstance(category_name, str) or not isinstance(category_items, list):
            continue
        get_started = next(
            (
                item
                for item in category_items
                if isinstance(item, dict)
                and item.get("name") == GET_STARTED_NAME
                and isinstance(item.get("href"), str)
                and item["href"].rsplit(".", 1)[-1].lower() in {"md", "yml"}
            ),
            None,
        )
        if get_started is None:
            continue
        categories[category_name] = (
            PurePosixPath("docs") / get_started["href"]
        ).as_posix()
    return categories
