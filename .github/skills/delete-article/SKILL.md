---
name: delete-article
description: 'How to delete an Azure Architecture Center article from this repository so no reader hits a 404 and no dangling reference is left behind. USE when asked to delete, remove, retire, or take down an article. DO NOT USE for moving or renaming an article that keeps its content, for removing a single section within an article, or for deprecating technology inside an article.'
compatibility: "Operates on files in this repository. Requires an internet connection."
disable-model-invocation: false
license: MIT
user-invocable: true
metadata:
  author: 'Azure Patterns & Practices'
---

# Delete an article

This skill is the repeatable process for deleting an article from the Azure Architecture Center. Deleting the article files alone is never enough. A published article has a URL that readers, search engines, and other articles point to. If you remove the files without cleaning up the surrounding references, readers get 404s, the table of contents breaks, and orphaned links stay behind.

You execute the deletion directly. The one thing you must get from the human is the **redirect target**, because a deleted URL must send its traffic somewhere sensible and only the human knows the intended replacement.

## Before you touch anything: get the redirect target

Every deleted article needs a redirect. Do not proceed without a destination URL. The target is usually a site-relative path such as `/azure/architecture/...`, but it can be an absolute URL.

If you were provided a redirect target, use it. If you weren't, offer your caller a choice:

- They give you the destination URL, or
- You search for the best destination on their behalf.

If they want you to search, find the destination that best helps the architect accomplish the job the deleted article was helping them do. The replacement doesn't have to live in the Azure Architecture Center. It can be anywhere on Microsoft Learn (a Well-Architected Framework page, a Cloud Adoption Framework page, a service guide, a product doc, or another AAC article). Use the `microsoft-learn-grounding` skill and its Microsoft Learn MCP tools to search Learn, read candidate pages, and confirm the destination genuinely covers the reader's need rather than just matching keywords. Propose your best-fit target to your invoker and have them confirm before you continue.

Whichever path you take, confirm the final target actually makes sense as a landing spot for someone who wanted the deleted article, and that it resolves. The human owns the final decision.

## Step 1: Identify the article and its file pattern

Articles use one of three file patterns. Determine which one applies before deleting, because it changes what you remove.

- **Pattern 1 — YAML + Markdown pair:** `article-name.yml` (metadata, published URL) plus `article-name-content.md` (body, pulled in via `[!INCLUDE[]]`). Delete **both**.
- **Pattern 2 — Pure Markdown:** `article-name.md` with frontmatter. Delete the one file.
- **Pattern 3 — Pure YAML:** `article-name.yml`. Delete the one file.

The file that maps to the published URL is the `.yml` (Pattern 1 and 3) or the `.md` (Pattern 2). That path is what you use as the redirect `source_path`. The `-content.md` include file has no URL of its own.

## Step 2: Add the redirect entry

Add an entry to the `redirections` array in `.openpublishing.redirection.json` at the repository root:

```json
{
  "source_path": "docs/<path>/<article-name>.yml",
  "redirect_url": "<target the human gave you>",
  "redirect_document_id": false
}
```

- `source_path` is relative to the repository root (starts with `docs/`) and points to the URL-bearing file from Step 1.
- `redirect_document_id` is **`false`** for a deletion, because the redirect target is a different article, not the same content at a new location. (Only set it `true` when content moved or was renamed and still exists at the new URL — that's not a delete.)
- Add one redirect per URL-bearing file. The `-content.md` include doesn't get its own redirect.

## Step 3: Remove the article files and article-only assets

Delete the article files you identified in Step 1. Then clean up assets that belong to the article:

- **Diagram and image files** in the article's local image folder (`_images/`, `images/`, or `media/` next to the article). Images usually belong to one article, but sharing is possible, so check before you delete. For each image file, run a repository-wide search for the file name across `docs/` to find every reference. Delete the image only when the deleted article is the sole referrer. If any other article or file still references it, leave the image in place and note in your summary which files keep it alive.
- **The browse thumbnail** referenced by the `thumbnailUrl` field in the YAML (Pattern 1), located in `docs/browse/thumbs/`. Apply the same check: search for the thumbnail file name and delete it only if nothing else references it.

## Step 4: Remove the article from the table of contents

Remove any entry in `docs/toc.yml` whose `href` points to the deleted article (paths there are relative to `docs/`). Remove the whole node, including its `name`. If removing it leaves an empty parent group with no remaining children, remove that empty parent too.

## Step 5: Handle the main landing page

Check whether the deleted article is featured on the main Azure Architecture Center landing page, `docs/index.yml` (articles there are referenced with `url:` entries). If it isn't, skip this step.

If it is, don't just delete the entry and leave a gap. The landing page is curated to stay populated with high-value content, so recommend a replacement AAC article to take the slot. Choose one that:

- Lives in the Azure Architecture Center (a `/azure/architecture/...` article), not elsewhere on Microsoft Learn. This page features AAC content.
- Carries comparable importance to what you're removing (a reference or baseline architecture, a widely used guide or decision tree), so the page keeps its quality bar.
- Fits the section of the landing page the deleted article sat in, so the surrounding grouping still makes sense.
- Isn't already featured elsewhere on the page, to avoid duplication.

Propose your recommended replacement to the human with a one-line reason and let them confirm or substitute before you edit `docs/index.yml`. This replacement is a separate decision from the redirect target in Step 1 and the two don't have to match.

## Step 6: Find and fix inbound links

Search the whole `docs/` tree for links that point to the deleted article and repoint them at the redirect target. Look for:

- Relative Markdown links to the deleted file (for example `../guide/foo.md` or `foo-content.md`).
- Absolute links to the published URL (`/azure/architecture/...` and the full `https://learn.microsoft.com/azure/architecture/...` form).
- References to the deleted article's images or thumbnail from other files.

Update each inbound link so it lands on the redirect target rather than the now-deleted page. If a link's surrounding sentence no longer makes sense pointing at the new target, fix the sentence, not just the URL. Report any inbound reference you could not cleanly repoint so the human can decide.

**Exception — get-started pages.** The per-category "get started" hub pages (for example `docs/databases/database-get-started.md`, files named `*-get-started.md`) are curated lists of links. When one of these pages links to the deleted article, remove the link entry entirely instead of repointing it to the redirect target. Don't add the redirect target in its place: if the target is another AAC article it's most likely already listed on the relevant get-started page, and if the target is elsewhere on Microsoft Learn it doesn't belong on an AAC get-started hub. Remove the whole list item or entry, and if that leaves an empty heading or grouping, tidy it up.

## Step 7: Verify

Before you finish, confirm:

1. The article's URL-bearing file is gone and, for Pattern 1, the `-content.md` include is also gone.
2. Article-only images and the browse thumbnail are gone; shared assets are untouched.
3. A redirect entry exists with `redirect_document_id: false` and a valid target.
4. No `href` in `docs/toc.yml` points to the deleted article, and no empty parent group remains.
5. If the article was featured in `docs/index.yml`, you removed its `url:` entry and added a confirmed AAC replacement so the page stays populated.
6. A repository-wide search for the old file name and old URL returns no remaining references (other than the redirect entry itself).

Summarize what you deleted, the redirect you added, the TOC change, the landing-page replacement (if any), and every inbound link you repointed.
