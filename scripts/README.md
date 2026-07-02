# Scripts

PowerShell tooling for maintaining Azure Architecture Center. This is not article content for Microsoft Learn.

## Article metadata as CSV

Walks the article files under `docs/`, reads each article's metadata, computes an expiry month from `ms.date` plus the effective `ms.update-cycle`, and writes a CSV. Columns: `ms_author`, `title`, `live_url`, `ms_date`, `ms_update_cycle`, `expiry_month_year`.

Prerequisites:

- PowerShell 7 or later.
- The `powershell-yaml` module: `Install-Module -Name powershell-yaml`.
- Run from the repository root.

```powershell
# Write article-metadata.csv in the current directory
./scripts/export-article-metadata.ps1
```

## Build expiring article email

Produces an email-ready HTML report of articles that have expired or will expire during the target month (always two months from today), plus CC and BCC lists of the article owners. It runs `export-article-metadata.ps1` internally, so you don't need to generate the CSV first. This script never sends email; it builds content for a manual mail merge.

The email body lives in `templates/expiry-email.html`.

Prerequisites:

- PowerShell 7 or later.
- The `powershell-yaml` module: `Install-Module -Name powershell-yaml`.
- Run from the repository root.

```powershell
# Write expiring-articles-<yyyy-MM>.html in the current directory
./scripts/build-expiring-article-email.ps1
```

Open the resulting HTML file in a browser. It contains the subject, the email body, and the CC and BCC lists.

## Sync AAC group membership

Reconciles an Entra group's membership against the current set of article authors (`ms.author`). It adds authors who aren't members and removes members who are no longer authors. It only manages membership - it never changes group ownership, and group owners are always protected from removal. The script prints the planned changes and requires explicit approval before applying them.

Prerequisites:

- PowerShell 7 or later.
- Azure CLI (`az`) with an authenticated session that can manage the group.
- Run from the repository root.

```powershell
# Preview the plan without making changes
./scripts/sync-aac-group-membership.ps1 -WhatIf

# Run interactively (prompts for approval before applying)
./scripts/sync-aac-group-membership.ps1
```
