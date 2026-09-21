"""Map managed get-started categories to the files the workflow reconciles.
"""

from __future__ import annotations

import argparse
import json
import posixpath
import re
from pathlib import Path, PurePosixPath
from typing import Any

from toc_model import parse_categories

INCLUDE_PATTERN = re.compile(r"\[!INCLUDE\s*\[[^\]]*\]\(([^)]+)\)\]", re.IGNORECASE)


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
    categories: dict[str, str],
) -> dict[str, str]:
    """Return categories whose parent article renders the managed include.

    The TOC contains categories that intentionally retain ordinary get-started
    pages. Resolving DocFX include directives from each parent article prevents
    this automation from claiming categories that have no managed include.
    """
    managed: dict[str, str] = {}
    for category_name, article_path in categories.items():
        article = PurePosixPath(article_path)
        repository_path = repository_root.joinpath(*article.parts)
        if not repository_path.is_file():
            continue
        article_text = repository_path.read_text(encoding="utf-8")
        expected_include = include_path_for(article_path)
        for include_target in INCLUDE_PATTERN.findall(article_text):
            normalized_target = include_target.strip().replace("\\", "/")
            resolved_path = posixpath.normpath(
                posixpath.join(article.parent.as_posix(), normalized_target)
            )
            if resolved_path == expected_include:
                managed[category_name] = article_path
                break
    return managed


def build_mapping(managed: dict[str, str]) -> dict[str, Any]:
    """Build the category-to-file mapping the workflow reconciles.

    Each entry pairs a category with the include to edit and the parent article
    that hosts it. The category name locates the subtree in docs/toc.yml.
    """
    return {
        "categories": [
            {
                "category": category_name,
                "getStartedArticle": article_path,
                "getStartedInclude": include_path_for(article_path),
            }
            for category_name, article_path in managed.items()
        ]
    }


def parse_arguments() -> argparse.Namespace:
    """Parse workflow and local invocation arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--toc", type=Path, default=Path("docs/toc.yml"))
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args()


def main() -> None:
    """Write the managed category-to-file mapping as JSON."""
    arguments = parse_arguments()
    repository_root = arguments.root.resolve()
    toc_path = arguments.toc
    if not toc_path.is_absolute():
        toc_path = repository_root / toc_path
    managed = managed_categories(
        repository_root,
        parse_categories(toc_path.read_text(encoding="utf-8")),
    )
    mapping = build_mapping(managed)
    output_text = json.dumps(mapping, indent=2) + "\n"
    arguments.output.parent.mkdir(parents=True, exist_ok=True)
    arguments.output.write_text(output_text, encoding="utf-8", newline="")
    print(output_text, end="")


if __name__ == "__main__":
    main()
