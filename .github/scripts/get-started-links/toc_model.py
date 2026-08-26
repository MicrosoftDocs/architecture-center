"""Read the Azure categories TOC subtree as a faithful, ordered tree.

The reader is deliberately convention-free. It doesn't classify nodes by name
or recognize special content types. It reproduces the category subtree exactly
as the TOC declares it, preserving order and nesting, so the include can mirror
the TOC outline instead of a hardcoded subset of it.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import PurePosixPath
from typing import Any
from urllib.parse import urlsplit

import yaml

GET_STARTED_NAME = "Get started"


@dataclass
class TocNode:
    """One node of a category subtree, preserving TOC order and nesting.

    A node can be a heading (it has children), a link (it has an href and no
    children), or both (an href and children). Keeping the raw shape lets the
    downstream stage render structure deterministically and reserve editorial
    judgment for text.
    """

    name: str
    href: str | None
    target: str | None
    children: list["TocNode"] = field(default_factory=list)


@dataclass
class Category:
    """One category and its ordered subtree, minus its own Get started node.

    Only the category's own Get started entry is excluded, because that entry
    names the parent article that hosts the managed include. Every other node,
    including Get started entries nested deeper in the subtree, is preserved.
    """

    name: str
    article_path: str
    nodes: list[TocNode] = field(default_factory=list)


def published_link(href: str | None) -> str | None:
    """Return the published target represented by one TOC href.

    Local article paths are converted to Architecture Center URLs. Absolute
    product-documentation and external targets are preserved because TOC
    membership, not hosting location, determines eligibility.
    """
    if not href or href.startswith("#"):
        return None
    parsed = urlsplit(href)
    if parsed.scheme or parsed.netloc:
        return href
    if href.startswith("/"):
        return parsed.path.rstrip("/")
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


def _build_node(raw_item: dict[str, Any]) -> TocNode | None:
    """Build one node and its subtree from a raw TOC dictionary."""
    name = raw_item.get("name")
    if not isinstance(name, str):
        return None
    href = raw_item.get("href")
    href = href if isinstance(href, str) else None
    children = _build_nodes(raw_item.get("items"))
    return TocNode(
        name=name,
        href=href,
        target=published_link(href),
        children=children,
    )


def _build_nodes(items: Any) -> list[TocNode]:
    """Build an ordered node list from a raw TOC items array."""
    if not isinstance(items, list):
        return []
    nodes: list[TocNode] = []
    for raw_item in items:
        if not isinstance(raw_item, dict):
            continue
        node = _build_node(raw_item)
        if node is not None:
            nodes.append(node)
    return nodes


def parse_categories(toc_text: str) -> dict[str, Category]:
    """Parse the Azure categories subtree into faithful ordered trees."""
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
                if isinstance(item, dict)
                and item.get("name") == GET_STARTED_NAME
                and isinstance(item.get("href"), str)
                and published_link(item.get("href"))
            ),
            None,
        )
        if get_started is None:
            continue
        article_path = (PurePosixPath("docs") / get_started["href"]).as_posix()
        nodes = [
            node
            for raw_item in category_items
            if isinstance(raw_item, dict) and raw_item is not get_started
            for node in [_build_node(raw_item)]
            if node is not None
        ]
        categories[category_name] = Category(
            name=category_name,
            article_path=article_path,
            nodes=nodes,
        )
    return categories
