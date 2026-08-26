"""Reconcile category TOC links with the managed get-started includes."""

from __future__ import annotations

import argparse
import json
import posixpath
import re
from pathlib import Path, PurePosixPath
from typing import Any
from urllib.parse import urlsplit

from toc_model import Category, TocNode, parse_categories

INCLUDE_PATTERN = re.compile(r"\[!INCLUDE\s*\[[^\]]*\]\(([^)]+)\)\]", re.IGNORECASE)
LINK_PATTERN = re.compile(r"(?<!!)\[[^\]]+\]\(\s*([^\s)]+)")


def normalize_link(target: str, include_path: str | None = None) -> str:
    """Normalize a Markdown target to the route format used by the TOC."""
    parsed_target = urlsplit(target)
    if parsed_target.scheme or parsed_target.netloc:
        return target
    link = target.split("#", 1)[0].split("?", 1)[0].rstrip("/")
    if include_path and link and not link.startswith("/"):
        include_directory = PurePosixPath(include_path).parent.as_posix()
        source_path = posixpath.normpath(posixpath.join(include_directory, link))
        if source_path.startswith("docs/"):
            route = source_path.removeprefix("docs/")
            route = re.sub(r"\.(?:md|yml)$", "", route)
            route = route.removesuffix("-content")
            route = route.removesuffix("/index")
            link = f"/azure/architecture/{route}"
    return link


def include_links(text: str, include_path: str) -> set[str]:
    """Collect normalized inline Markdown links from one managed include."""
    return {
        normalize_link(target, include_path)
        for target in LINK_PATTERN.findall(text)
        if normalize_link(target, include_path)
    }


def is_architecture_center_link(target: str) -> bool:
    """Return whether a normalized target is controlled by this TOC.

    The Architecture Center TOC owns routes beneath `/azure/architecture/`.
    Product-documentation routes and full external URLs can be curated directly
    in an include, so their absence from the TOC must never mark them for
    removal. External links that do appear in the TOC remain eligible for
    addition because this check applies only to the removal calculation.
    """
    return target.startswith("/azure/architecture/")


def include_path_for(article_path: str) -> str:
    """Derive the centralized managed include path from a get-started article."""
    article = PurePosixPath(article_path)
    if article.name == "get-started.md":
        category_name = article.parent.name
    elif article.stem.endswith("-get-started"):
        category_name = article.stem.removesuffix("-get-started")
    else:
        category_name = article.parent.name
    include_name = f"{category_name}-get-started-include.md"
    return (PurePosixPath("docs/includes") / include_name).as_posix()


def managed_categories(
    repository_root: Path,
    categories: dict[str, Category],
) -> dict[str, Category]:
    """Return categories whose parent article renders the managed include.

    The TOC contains categories that intentionally retain ordinary get-started
    pages. Resolving DocFX include directives from each parent article prevents
    this automation from creating orphan includes for those categories.
    """
    managed: dict[str, Category] = {}
    for category_name, category in categories.items():
        article_path = PurePosixPath(category.article_path)
        repository_path = repository_root.joinpath(*article_path.parts)
        if not repository_path.is_file():
            continue
        article_text = repository_path.read_text(encoding="utf-8")
        expected_include = include_path_for(category.article_path)
        for include_target in INCLUDE_PATTERN.findall(article_text):
            normalized_target = include_target.strip().replace("\\", "/")
            resolved_path = posixpath.normpath(
                posixpath.join(article_path.parent.as_posix(), normalized_target)
            )
            if resolved_path == expected_include:
                managed[category_name] = category
                break
    return managed


def collect_targets(nodes: list[TocNode]) -> set[str]:
    """Collect every published target in a category subtree."""
    targets: set[str] = set()
    for node in nodes:
        if node.target:
            targets.add(node.target)
        targets |= collect_targets(node.children)
    return targets


def serialize_outline(nodes: list[TocNode], level: int = 3) -> list[dict[str, Any]]:
    """Serialize a category subtree into the deterministic include outline.

    The outline fixes order, nesting, and heading depth so the workflow only
    editorializes text. A node with children is a section rendered at its
    heading level, capped at H6; deeper sections carry a null level so the
    workflow renders them as bold labels. A childless node with a target is a
    link. A childless node without a target is a bare label.

    Within each parent, direct links are emitted before subsections. In flat
    Markdown a subsection heading captures every bullet that follows it, so a
    parent-level link placed after a subsection would appear nested inside it.
    Ordering leaves before groups keeps each link under its own section.
    """
    leaves = [node for node in nodes if not node.children]
    sections = [node for node in nodes if node.children]
    entries: list[dict[str, Any]] = []
    for node in leaves + sections:
        entry: dict[str, Any] = {"name": node.name}
        if node.href is not None:
            entry["href"] = node.href
        if node.target is not None:
            entry["target"] = node.target
        if node.children:
            entry["kind"] = "section"
            entry["headingLevel"] = level if level <= 6 else None
            entry["children"] = serialize_outline(node.children, level + 1)
        elif node.target is not None:
            entry["kind"] = "link"
        else:
            entry["kind"] = "label"
        entries.append(entry)
    return entries


def build_context(
    repository_root: Path,
    current_categories: dict[str, Category],
) -> dict[str, Any]:
    """Build the full TOC outline and current link drift for every category.

    Every run receives the complete desired outline so it can reconcile
    structure and text together. Added and removed target sets make link drift
    explicit. Removal is limited to Architecture Center targets so curated
    product-documentation and external links are preserved in place.
    """
    categories: list[dict[str, Any]] = []
    for category_name, current_category in current_categories.items():
        include_path = include_path_for(current_category.article_path)
        include_file = repository_root.joinpath(*PurePosixPath(include_path).parts)
        existing_links: set[str] = set()
        if include_file.is_file():
            existing_links = include_links(
                include_file.read_text(encoding="utf-8"),
                include_path,
            )
        toc_targets = collect_targets(current_category.nodes)
        added = sorted(toc_targets - existing_links)
        removed = sorted(
            link
            for link in existing_links - toc_targets
            if is_architecture_center_link(link)
        )
        categories.append(
            {
                "category": category_name,
                "getStartedArticle": current_category.article_path,
                "getStartedInclude": include_path,
                "outline": serialize_outline(current_category.nodes),
                "added": added,
                "removed": removed,
            }
        )
    return {"categories": categories}


def parse_arguments() -> argparse.Namespace:
    """Parse workflow and local invocation arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--toc", type=Path, default=Path("docs/toc.yml"))
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args()


def main() -> None:
    """Write the complete managed TOC structure and current link drift as JSON."""
    arguments = parse_arguments()
    repository_root = arguments.root.resolve()
    toc_path = arguments.toc
    if not toc_path.is_absolute():
        toc_path = repository_root / toc_path
    current_categories = managed_categories(
        repository_root,
        parse_categories(toc_path.read_text(encoding="utf-8")),
    )
    context = build_context(repository_root, current_categories)
    output_text = json.dumps(context, indent=2) + "\n"
    arguments.output.parent.mkdir(parents=True, exist_ok=True)
    arguments.output.write_text(output_text, encoding="utf-8", newline="")
    print(output_text, end="")


if __name__ == "__main__":
    main()
