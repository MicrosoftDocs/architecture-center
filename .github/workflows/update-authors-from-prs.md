---
emoji: "🗂️"
name: "Update authors from PRs"
description: Collects mentionable logins from recent pull requests and stores them in repo memory.
private: true

on:
  workflow_dispatch:
  schedule:
    - cron: every 6h

if: github.repository == 'MicrosoftDocs/architecture-center-pr'

concurrency: update-authors-from-prs

permissions:
  contents: read
  pull-requests: read
  copilot-requests: write

model: sonnet
engine:
  id: copilot
  copilot-sdk: true
max-tool-denials: 3
strict: true


tracker-id: update-authors-from-prs

network:
  allowed:
    - defaults
    - github

safe-outputs:
  mentions: false
  noop:
    report-as-issue: false

tools:
  repo-memory:
    - id: mentionables
      branch-name: memory/mentionables
      description: "Author/mentionable lists (one JSON file per source)"
      allowed-extensions: [".json"]
      max-file-size: 262144
      max-patch-size: 262144
      file-glob: ["prs/pr-knowns.json", "prs/pr-scan-state.json"]

steps:
  - name: Collect mentionable logins from recent PRs into repo memory
    uses: actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3 # v9.0.0
    with:
      script: |
        const { main } = require(require('path').resolve('.github/scripts/mentionables/collect-authors-from-prs.cjs'));
        await main({ github, context, core });
---

# Update authors from PRs

All work is done by the deterministic step above, which scans all open PRs plus closed PRs updated in the last 30 days, collects opener/assignee/requested-reviewer/@mention logins, writes the union to `prs/pr-knowns.json` on the `memory/mentionables` branch (with a `prs/pr-scan-state.json` watermark so unchanged PRs are skipped next time), and emits `noop`. The AI engine is skipped and this prompt never runs.
