"""Parse Azure category TOC entries and calculate category-level changes."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import PurePosixPath
from typing import Any
from urllib.parse import urlsplit

import yaml

GROUP_TYPES: dict[str, str] = {
    "Architectures": "architectures",
    "Solution ideas": "solution-ideas",
    "Guides": "guides",
    "Select a service": "guides",
}
CONTENT_TYPES: tuple[str, ...] = (
    "architectures",
    "solution-ideas",
    "guides",
)


@dataclass
class Category:
    """Represent one category, its get-started article, and mapped TOC links."""

    article_path: str
    types: dict[str, set[str]] = field(
        default_factory=lambda: {content_type: set() for content_type in CONTENT_TYPES}
    )


def published_link(href: str | None) -> str | None:
    """Return the published target represented by one TOC href.

    Local article paths are converted to Architecture Center URLs. Absolute
    product-documentation and external targets are preserved because TOC
    membership, not hosting location, determines eligibility.
    """
    if not href or href.startswith("#"):
        return None
    parsed = urlsplit(href)
    if parsed.scheme or parsed.netloc or href.startswith("/"):
        return href
    relative_path = PurePosixPath(parsed.path.replace("\\", "/"))
    if relative_path.suffix.lower() not in {".md", ".yml"}:
        return None
    article_path = relative_path.with_suffix("").as_posix()
    while article_path.startswith("./"):
        article_path = article_path[2:]
    if article_path.endswith("-content"):
        article_path = article_path.removesuffix("-content")
    normalized_parts: list[str] = []
    for part in PurePosixPath(article_path).parts:
        if part == "..":
            if normalized_parts:
                normalized_parts.pop()
        elif part not in {"", "."}:
            normalized_parts.append(part)
    if not normalized_parts:
        return None
    if normalized_parts[-1] == "index":
        normalized_parts.pop()
    if not normalized_parts:
        return None
    return "/azure/architecture/" + "/".join(normalized_parts)


def collect_links(
    items: Any,
    links_by_type: dict[str, set[str]],
    inherited_type: str | None = None,
) -> None:
    """Collect published links under recognized nested content groups.

    Wrapper nodes such as SAP and Kubernetes-based hosting can contain the
    recognized Architectures, Solution ideas, or Guides groups. Carry the
    current content type through unrecognized wrappers and replace it when a
    nested recognized group starts.
    """
    if not isinstance(items, list):
        return
    for raw_item in items:
        if not isinstance(raw_item, dict):
            continue
        name = raw_item.get("name")
        content_type = GROUP_TYPES.get(name, inherited_type)
        href = raw_item.get("href")
        link = published_link(href if isinstance(href, str) else None)
        if link and isinstance(name, str) and content_type:
            links_by_type[content_type].add(link)
        collect_links(raw_item.get("items"), links_by_type, content_type)


def parse_categories(toc_text: str) -> dict[str, Category]:
    """Parse the Azure categories subtree without inferring from directories."""
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
    categories: dict[str, Category] = {}
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
                if isinstance(item, dict) and item.get("name") == "Get started"
            ),
            None,
        )
        if not isinstance(get_started, dict):
            continue
        get_started_href = get_started.get("href")
        if not isinstance(get_started_href, str) or not published_link(get_started_href):
            continue
        article_path = (PurePosixPath("docs") / get_started_href).as_posix()
        category = Category(article_path=article_path)
        collect_links(category_items, category.types)
        categories[category_name] = category
    return categories
