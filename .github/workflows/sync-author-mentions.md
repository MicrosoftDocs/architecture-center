---
emoji: "🔀"
name: "Sync author mentions"
description: Combines the mentionable lists from repo memory into the shared allowlist and opens a PR.
private: true

on:
  workflow_dispatch:
  schedule:
    - cron: daily

if: github.repository == 'MicrosoftDocs/architecture-center-pr'

concurrency: sync-author-mentions

permissions:
  contents: read
  copilot-requests: write

model: sonnet
engine:
  id: copilot
  copilot-sdk: true
max-tool-denials: 3
strict: true


tracker-id: sync-author-mentions

network:
  allowed:
    - defaults
    - github

runtimes:
  gh-aw: {}

safe-outputs:
  max-patch-size: 4096
  github-app:
    client-id: ${{ vars.MENTIONS_SYNC_CLIENT_ID }}
    private-key: ${{ secrets.MENTIONS_SYNC_PRIVATE_KEY }}
  mentions: false
  noop:
    report-as-issue: false
  create-pull-request:
    allow-workflows: true # Required because the PR touches files under .github/workflows/ (shared file + lock files).
    title-prefix: "[mentionables] "
    base-branch: main
    draft: true
    max: 1
    preserve-branch-name: true
    recreate-ref: true
    max-patch-files: 40
    protected-files: allowed
    allowed-files:
      - .github/workflows/shared/author-mentions.md
      - .github/workflows/*.lock.yml

steps:
  - name: Rebuild the shared mentionables allowlist from repo memory
    id: sync
    uses: actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3 # v9.0.0
    with:
      script: |
        const { main } = require(require('path').resolve('.github/scripts/mentionables/sync-author-mentions.cjs'));
        await main({ github, context, core });
  - name: Recompile workflows that import the shared list
    if: steps.sync.outputs.changed == 'true'
    env:
      # Required by strict mode for any step that invokes the gh CLI.
      GH_TOKEN: ${{ github.token }}
    run: |
      set -euo pipefail
      { grep -lE '^[[:space:]]*-[[:space:]]+(uses:[[:space:]]+)?shared/author-mentions\.md[[:space:]]*$' .github/workflows/*.md || true; } | while read -r wf; do
        gh aw compile --strict "$(basename "${wf%.md}")"
      done
---

# Sync author mentions

The deterministic steps have refreshed `.github/workflows/shared/author-mentions.md` and recompiled the workflows that import it. Open exactly one pull request containing these changes by calling the `create_pull_request` safe output with the title "Refresh author mentionables list" and branch `automation/sync-author-mentions`. Reuse that branch to update its existing pull request; don't create a new pull request.

Keep the pull request body short and generic (for example, "Routine refresh of the author mentionables allow list from repo memory."). Don't inspect the diff, and don't summarize or list which usernames were added or removed. Don't @-mention anyone. Don't edit any files yourself.
