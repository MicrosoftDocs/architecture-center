---
emoji: "🔗"
name: "GitHub sample collector"
description: Gathers every GitHub link in the docs and enriches each repository with health data, persisting the catalog to repo memory.
private: true

on:
  workflow_dispatch:
  schedule:
    - cron: daily

if: github.repository == 'MicrosoftDocs/architecture-center-pr'

permissions:
  contents: read
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

tracker-id: github-sample-collector

network:
  allowed:
    - defaults
    - github

safe-outputs:
  noop:
    report-as-issue: false

tools:
  bash: true
  repo-memory:
    - id: github-samples
      branch-name: memory/github-samples
      description: "GitHub sample link catalog with repository health"
      allowed-extensions: [".json", ".csv"]
      file-glob: ["data/*.json", "data/*.csv"]
      format-json: true
      max-file-size: 2097152 # 2 MB
      max-patch-size: 1048576 # 1 MB

timeout-minutes: 20

steps:
  - name: Extract GitHub links from docs
    run: |
      mkdir -p /tmp/gh-aw/agent
      # file:line:url for every GitHub-family link in the docs data.
      grep -rnoE 'https?://(www\.)?(raw\.githubusercontent\.com|docs\.github\.com|github\.com|gist\.github\.com|[a-z0-9-]+\.github\.io)\b([/?#][A-Za-z0-9._/~%#?&=+@!,;:-]*)?' docs \
        --include='*.md' --include='*.yml' \
        > /tmp/gh-aw/agent/raw-links.txt || status=$?
      status=${status:-0}
      # grep: 0 = matches, 1 = no matches (fine), >1 = real error (e.g. unreadable docs tree)
      if [ "$status" -gt 1 ]; then
        echo "::error::grep failed with exit $status while scanning docs; aborting so the catalog isn't overwritten with empty data." >&2
        exit "$status"
      fi
      echo "Total GitHub links found: $(wc -l < /tmp/gh-aw/agent/raw-links.txt)"
      jq -R -s 'split("\n") | map(select(length>0)) | map(capture("^(?<file>[^:]+):(?<line>[0-9]+):(?<url>.*)$"))' \
        /tmp/gh-aw/agent/raw-links.txt > /tmp/gh-aw/agent/links.json
      echo "Structured link records: $(jq length /tmp/gh-aw/agent/links.json)"
  - name: Classify links and enrich repositories with health data
    uses: actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3 # v9.0.0
    with:
      script: |
        const fs = require('fs');
        const links = JSON.parse(fs.readFileSync('/tmp/gh-aw/agent/links.json', 'utf8'));

        // Microsoft-controlled organizations (lowercase for case-insensitive match)
        const MS_ORGS = new Set([
          'azure', 'azure-samples', 'microsoft', 'microsoftdocs', 'mspnp', 'dotnet',
          'microsoftgraph', 'azuread', 'microsoftlearning', 'officedev', 'powershell',
          'microsoft-foundry',
        ]);
        // github.com paths that are pages, not repositories
        const NON_REPO_PATHS = new Set([
          'features', 'marketplace', 'pricing', 'sponsors', 'about', 'orgs', 'apps',
          'settings', 'topics', 'collections', 'customer-stories', 'readme', 'site',
          'security', 'enterprise', 'team', 'contact', 'login', 'join', 'notifications',
        ]);

        function classify(rawUrl) {
          let u;
          try { u = new URL(rawUrl); } catch { return { cls: 'website', ownerRepo: null }; }
          const host = u.hostname.toLowerCase();
          const parts = u.pathname.split('/').filter(Boolean);
          if (host === 'gist.github.com') return { cls: 'gist', ownerRepo: null };
          if (host.endsWith('.github.io')) return { cls: 'website', ownerRepo: null };
          if (host === 'raw.githubusercontent.com') {
            return parts.length >= 2
              ? { cls: 'raw', ownerRepo: `${parts[0]}/${parts[1]}` }
              : { cls: 'website', ownerRepo: null };
          }
          if (host === 'github.com' || host === 'www.github.com') {
            if (parts.length < 2 || NON_REPO_PATHS.has(parts[0].toLowerCase())) {
              return { cls: 'website', ownerRepo: null };
            }
            const owner = parts[0];
            const repo = parts[1].replace(/\.git$/, '');
            const seg = parts[2];
            // seg undefined = repo root; tree/blob/raw = file/dir views; anything else
            // (releases, issues, pulls, wiki, actions, ...) is a deep repository page.
            const cls = seg === undefined ? 'repo-root'
              : seg === 'tree' ? 'tree'
              : seg === 'blob' ? 'blob'
              : seg === 'raw' ? 'raw'
              : 'repo-page';
            return { cls, ownerRepo: `${owner}/${repo}` };
          }
          return { cls: 'website', ownerRepo: null };
        }

        const tierOf = (ownerRepo) =>
          !ownerRepo ? null : (MS_ORGS.has(ownerRepo.split('/')[0].toLowerCase()) ? 'Microsoft' : 'third-party');

        for (const link of links) {
          link.url = link.url.replace(/[.,;:)\]}'"]+$/, ''); // strip trailing sentence punctuation
          const { cls, ownerRepo } = classify(link.url);
          // GitHub owner/repo is case-insensitive; normalize so casing variants dedupe to one record.
          const normalized = ownerRepo ? ownerRepo.toLowerCase() : null;
          link.class = cls;
          link.owner_repo = normalized;
          link.owner_tier = tierOf(normalized);
        }

        const uniqueRepos = [...new Set(links.map(l => l.owner_repo).filter(Boolean))];
        core.info(`Unique repositories to enrich: ${uniqueRepos.length}`);

        const TWELVE_MONTHS_MS = 365 * 24 * 60 * 60 * 1000;
        function healthOf(rec) {
          if (rec.status !== 'ok') return 'dead';
          if (rec.archived || rec.disabled) return 'archived';
          if (!rec.pushed_at) return 'stale';
          return (Date.now() - new Date(rec.pushed_at).getTime()) > TWELVE_MONTHS_MS ? 'stale' : 'healthy';
        }

        const repos = [];
        const healthByRepo = {};
        for (const slug of uniqueRepos) {
          const [owner, repo] = slug.split('/');
          let rec;
          try {
            const { data } = await github.rest.repos.get({ owner, repo });
            rec = {
              repo: slug, status: 'ok',
              archived: data.archived, disabled: data.disabled, is_fork: data.fork,
              pushed_at: data.pushed_at, updated_at: data.updated_at,
              stars: data.stargazers_count, open_issues: data.open_issues_count, forks: data.forks_count,
              license: data.license ? data.license.spdx_id : null,
              default_branch: data.default_branch, description: data.description, homepage: data.homepage,
            };
          } catch (error) {
            // Only a confirmed 404 means the repo is deleted or private. Any other status
            // (rate limit, auth, transient 5xx) must fail the run rather than publish false deaths.
            if (error.status === 404) {
              rec = { repo: slug, status: 'not_found_or_private', http_status: 404 };
            } else {
              core.setFailed(`Failed to fetch ${slug}: HTTP ${error.status || 'unknown'} — ${error.message}. Failing the run to avoid marking healthy repositories dead.`);
              throw error;
            }
          }
          rec.health = healthOf(rec);
          healthByRepo[slug] = rec.health;
          repos.push(rec);
        }

        for (const link of links) {
          link.health = link.owner_repo ? (healthByRepo[link.owner_repo] || 'dead') : 'n/a';
        }

        fs.writeFileSync('/tmp/gh-aw/agent/links-enriched.json', JSON.stringify(links, null, 2));
        fs.writeFileSync('/tmp/gh-aw/agent/repos.json', JSON.stringify(repos, null, 2));
        core.info(`Classified ${links.length} links across ${repos.length} repositories`);
  - name: Assemble catalog into repo memory
    run: |
      mkdir -p /tmp/gh-aw/repo-memory/github-samples/data
      jq -n --arg ts "$(date -u +%FT%TZ)" \
        --slurpfile links /tmp/gh-aw/agent/links-enriched.json \
        --slurpfile repos /tmp/gh-aw/agent/repos.json \
        '{generated_at: $ts, links: $links[0], repos: $repos[0]}' \
        > /tmp/gh-aw/repo-memory/github-samples/data/catalog.json
      # Human-readable full catalog for browsing and linking from the report issue
      jq -r '
        (.repos | map({(.repo): .pushed_at}) | add // {}) as $pushed
        | (["article","line","url","owner_repo","class","owner_tier","health","last_push"] | @csv),
          (.links[] | [.file, .line, .url, (.owner_repo // ""), .class, (.owner_tier // ""), .health, ($pushed[(.owner_repo // "")] // "")] | @csv)
      ' /tmp/gh-aw/repo-memory/github-samples/data/catalog.json \
        > /tmp/gh-aw/repo-memory/github-samples/data/catalog.csv
      echo "Catalog written: $(jq '{links: (.links|length), repos: (.repos|length)}' /tmp/gh-aw/repo-memory/github-samples/data/catalog.json)"
      echo "CSV rows: $(($(wc -l < /tmp/gh-aw/repo-memory/github-samples/data/catalog.csv) - 1))"
---

# GitHub sample collector

Deterministic steps have already run before you. They gathered every GitHub link in `docs/`, enriched each unique repository with health data from the GitHub API, and wrote the result to `/tmp/gh-aw/repo-memory/github-samples/data/catalog.json`.

You're only a validator. You don't gather data, edit articles, or create issues.

Your task:

1. Confirm `/tmp/gh-aw/repo-memory/github-samples/data/catalog.json` exists and parses as JSON with a `links` array and a `repos` array. Use `jq` from `bash`.
2. Report the link count and repository count in your run summary.
3. If the file is missing or invalid, state that clearly in your run summary so the failure is visible.

The catalog automatically persists to the `memory/github-samples` branch when the run completes. Don't edit any file under the `docs/` folder.
