"""Reconcile category TOC links with the managed get-started includes."""

from __future__ import annotations

import argparse
import json
import posixpath
import re
from pathlib import Path, PurePosixPath
from typing import Any
from urllib.parse import urlsplit

from toc_model import CONTENT_TYPES, Category, TocLink, parse_categories

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


def build_context(
    repository_root: Path,
    current_categories: dict[str, Category],
) -> dict[str, Any]:
    """Build complete typed TOC context for every managed category.

    Every run receives the full desired hierarchy so it can reconcile heading
    changes as well as link changes. Added and removed link sets remain in the
    context to make direct link drift explicit.
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
        toc_links = {
            link.target
            for links in current_category.types.values()
            for link in links
        }
        added = sorted(toc_links - existing_links)
        removed = sorted(
            link
            for link in existing_links - toc_links
            if is_architecture_center_link(link)
        )
        sections = [
            build_section(category_name, content_type, current_category.types[content_type])
            for content_type in CONTENT_TYPES
            if current_category.types[content_type]
        ]
        categories.append(
            {
                "category": category_name,
                "getStartedArticle": current_category.article_path,
                "getStartedInclude": include_path,
                "sections": sections,
                "added": added,
                "removed": removed,
            }
        )
    return {"categories": categories}


def build_section(
    category_name: str,
    content_type: str,
    links: list[TocLink],
) -> dict[str, Any]:
    """Serialize one content type while preserving TOC subsection order.

    Links with the same subsection path are grouped together. The workflow uses
    the supplied heading verbatim and turns each subsection path component into
    a progressively deeper Markdown heading.
    """
    groups: list[dict[str, Any]] = []
    groups_by_path: dict[tuple[str, ...], dict[str, Any]] = {}
    for link in links:
        group = groups_by_path.get(link.subsections)
        if group is None:
            group = {
                "subsections": list(link.subsections),
                "links": [],
            }
            groups_by_path[link.subsections] = group
            groups.append(group)
        group["links"].append(
            {
                "name": link.name,
                "href": link.href,
                "target": link.target,
            }
        )
    type_label = content_type.replace("-", " ")
    return {
        "contentType": content_type,
        "heading": f"{category_name} {type_label}",
        "groups": groups,
    }


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
