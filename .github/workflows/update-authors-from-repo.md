---
emoji: "🗂️"
name: "Update authors from repo"
description: Scans article author fields and stores the distinct union in repo memory.
private: true

on:
  workflow_dispatch:
  schedule:
    - cron: daily

if: github.repository == 'MicrosoftDocs/architecture-center-pr'

concurrency: update-authors-from-repo

permissions:
  contents: read
  copilot-requests: none

model: sonnet
engine:
  id: copilot
  copilot-sdk: true
max-tool-denials: 3
strict: true

sandbox:
  agent:
    sudo: false

tracker-id: update-authors-from-repo

network:
  allowed:
    - defaults
    - github

# The deterministic step does all the work and emits noop, so the AI engine never runs.
safe-outputs:
  # Nothing should ever be mentioned by this workflow, even if it somehow emits output.
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
      file-glob: ["article-authors.json"]

steps:
  - name: Collect distinct article authors into repo memory
    uses: actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3 # v9.0.0
    with:
      script: |
        const { main } = require(require('path').resolve('.github/scripts/mentionables/collect-authors-from-repo.cjs'));
        await main({ github, context, core });
---

# Update authors from repo

All work is done by the deterministic step above, which scans every `.md` and `.yml` file under `docs/` for `author` fields, writes the distinct union to the `memory/mentionables` branch, and emits `noop`. The AI engine is skipped and this prompt never runs.
