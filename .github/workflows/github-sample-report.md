---
emoji: "🔗"
name: "GitHub sample report"
description: Reads the repo-memory catalog of GitHub links and files a weekly issue summarizing repository health and changes.
private: true

on:
  workflow_dispatch:
  schedule:
    - cron: weekly on monday

if: github.repository == 'MicrosoftDocs/architecture-center-pr'

permissions:
  contents: read
  issues: read
  copilot-requests: write

model: sonnet
engine:
  id: copilot
  copilot-sdk: true
max-tool-denials: 3
strict: true

sandbox:
  agent:
    sudo: false

tracker-id: github-sample-report

network:
  allowed:
    - defaults
    - github

safe-outputs:
  allowed-domains:
    - github.com
    - "*.github.com"
    - raw.githubusercontent.com
    - gist.github.com
    - "*.github.io"
    - learn.microsoft.com
    - "*.microsoft.com"
    - aka.ms
  mentions: false
  create-issue:
    title-prefix: "[github-sample-catalog] "
    deduplicate-by-title: true
    expires: 14d
    max: 6
  noop:
    report-as-issue: false

tools:
  bash: true
  cache-memory:
    retention-days: 90
    allowed-extensions: [".json"]
  repo-memory:
    - id: github-samples
      branch-name: memory/github-samples
      description: "GitHub sample link catalog with repository health"
      allowed-extensions: [".json", ".csv"]
      file-glob: ["data/*.json", "data/*.csv"]
      max-file-size: 2097152 # 2 MB, mirror the collector so validating the cloned catalog doesn't fail
      max-patch-size: 1048576 # 1 MB

timeout-minutes: 20
---

# GitHub sample report

You turn the durable GitHub sample catalog into one weekly issue. You don't gather data or call the GitHub API. You don't edit any article. You read, interpret, and report.

## Inputs

- `/tmp/gh-aw/repo-memory/github-samples/data/catalog.json` — the current catalog written by the `github-sample-collector` workflow. It contains `generated_at`, a `links` array of `{ file, line, url, class, owner_repo, owner_tier, health }`, and a `repos` array of health records with `repo`, `status`, `health`, `archived`, `disabled`, `is_fork`, `pushed_at`, `updated_at`, `stars`, `open_issues`, `forks`, `license`, `default_branch`, `description`, and `homepage`. All classification and health fields are already computed; read them, don't recompute them.
- `/tmp/gh-aw/cache-memory/previous-catalog.json` — the catalog you saw on the previous run, if it exists. Use it to detect what changed since last week.

If the current catalog is missing or empty, the collector didn't produce a catalog yet. Don't file a noise issue about internal plumbing. Call `noop` with a short message explaining that the catalog isn't available, then stop.

## Fields in the catalog

The collector already computed the per-link and per-repository fields deterministically. Do not recompute them; read and report them.

Each link carries:

- `class` — `repo-root`, `repo-page`, `tree`, `blob`, `raw`, `gist`, or `website`. `repo-root` is a bare `owner/repo`; `repo-page` is a deep repository page such as `releases`, `issues`, `pulls`, or `wiki`; `tree`, `blob`, and `raw` point at directories or files. A `website` link (a `*.github.io` Pages site or a non-repository `github.com` page) has no repository, so its health is `n/a`.
- `owner_repo` — the `owner/repo` for repository links, or `null` for `gist` and `website` links.
- `owner_tier` — `Microsoft` or `third-party` for repository links, or `null` for `gist` and `website` links, which have no owner. Treat `null` as its own "no owner" group so every link is represented.
- `health` — one of `healthy`, `stale`, `archived`, `dead`, or `n/a`, joined from the repository record.

Each repository record carries the same `health`, plus `pushed_at`, `stars`, `license`, and the other biographical fields. Health means:

- `healthy` — reachable, not archived, pushed within the last 12 months.
- `stale` — reachable, not archived, no push in more than 12 months.
- `archived` — archived or disabled.
- `dead` — deleted, private, or otherwise unreachable.

## Detect changes

Compare the current catalog with `/tmp/gh-aw/cache-memory/previous-catalog.json` to separate **new** problems from **ongoing** ones. A problem is new when a repository moved to `stale`, `archived`, or `dead` since last week, or when a new link to an already-unhealthy repository appeared.

## Weekly report issue

Call `create_issue` once for the weekly report. This is the single summary issue for the run; the escalation section below may add more issues. Title: `Weekly report — YYYY-MM-DD` (use the `generated_at` date from the catalog). Use sentence-case headings and `<details>` blocks for long tables:

- **Summary**: total links, unique repositories, and counts by health status, with the delta versus last week when available.
- **New this week**: repositories that became stale, archived, or dead since last week, each with the affected article paths and line numbers. If none, say so.
- **Ongoing problems**: unhealthy repositories seen before, sorted by health status. For each repository, list the affected article paths and line numbers so a maintainer can act without opening the full catalog.
- **Rollups**: counts by ownership tier and by link class. Include a `null`/"no owner" bucket in the ownership rollup for `gist` and `website` links so the tier counts sum to the total link count. Call out the `website` count separately, since those are documentation or product pages rather than sample repositories. Note how many links are deep `blob` or `tree` links, which rot when a repository is restructured.
- **Full catalog**: don't inline the full list; it's too large for an issue body. Link to the complete, browsable catalog at `https://github.com/MicrosoftDocs/architecture-center-pr/blob/memory/github-samples/data/catalog.csv`, which the collector regenerates every run.

Follow the repository writing style: sentence case, no weasel words, complete sentences, and Oxford commas.

## Escalate dead and archived repositories

For each repository with health status `dead` or `archived`, call `create_issue` once with:

- Title: `Unhealthy GitHub sample: <owner/repo>`. Keep this title stable so `deduplicate-by-title` keeps a single open issue per repository, and so a still-unhealthy repository is re-raised on the next run after its issue expires.
- Body: the `owner/repo`, whether it's `dead` (deleted, private, or otherwise unreachable) or `archived` (frozen and no longer maintained), every affected article path and line number, the original URL, and a recommended action — replace or remove the link, and consider a freshness pass on the affected articles.

Create at most five escalation issues per run. If more than five repositories are dead or archived, list the remainder in the weekly report and note that the count exceeded the escalation limit. Don't escalate `stale` repositories here; they belong in the weekly report.

## Persist your snapshot

Copy the current catalog to `/tmp/gh-aw/cache-memory/previous-catalog.json` so the next run can compute deltas. Don't modify the repo-memory catalog; the collector owns it.

## Completion rule

Every run must end with at least one safe-output call, or the run fails the safe-output compliance check. Before finishing, confirm you called at least one of:

- `create_issue` — the normal path: one weekly report issue, plus one escalation issue per dead or archived repository.
- `noop` — the fallback, when the catalog is missing or empty (see Inputs). Include a brief reason.

Do not edit any file under `docs/`.
