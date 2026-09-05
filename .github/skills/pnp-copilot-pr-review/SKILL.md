---
name: pnp-copilot-pr-review
description: 'How GitHub Copilot runs its automated pull request review of an Azure Architecture Center article. USE only as part of GitHub Copilot''s agentic PR review process. DO NOT USE for human-requested interactive reviews (use pnp-engineering-review instead)'
compatibility: 'Depends on the microsoft-learn-grounding skill. Requires an internet connection.'
disable-model-invocation: false
license: MIT
user-invocable: true
metadata:
  author: 'Azure Patterns & Practices'
---

# GitHub Copilot pull request review

This skill folds a fixed set of Azure Patterns & Practices engineering quality criteria into GitHub Copilot's standard pull request review of an Azure Architecture Center article. It's mostly additive: run it alongside your normal PR review behavior and add the checks below. Where a directive here conflicts with a default review behavior, this skill takes precedence for these articles. It produces feedback that the author should consider.

Deliver findings as review comments, and use GitHub's **suggestion** feature to propose concrete edits inline wherever a finding maps to a specific line or lines the author can apply with one click.

## Editorial-only pull requests

Before you apply the whole-article scope or any technical checks, inspect the pull request title and body to determine whether the author is performing an editorial pass.

Switch to **editorial-only review mode** when either of these explicit signals appears, case-insensitively:

- The title identifies the change as a **PnP edit** or **P&P edit**, including variants such as "PnP edits."
- The body identifies the change as a **copy edit**, **copyedit**, **editorial pass**, **P4 edit**, or **post-publish edit**.

Phrases such as "Edit article," a link to an earlier content pull request, or an editorial work-item link can support the classification, but none is sufficient by itself. Don't infer editorial-only intent from changed-file types or size of the diff. Non-editorial PRs get the full review. If the signals conflict or the intent is unclear, use the full review.

In editorial-only review mode, this section takes precedence over the normal Copilot review behavior and every section below:

- Review only the lines changed in this pull request. Don't evaluate the whole article.
- Limit comments to serious copyediting concerns that the PR author (a professional copyeditor) should address in this pull request.
- Flag wording that accidentally changes or obscures the apparent meaning of the source text. Frame the comment as preserving meaning, not as a technical or architectural correction.
- Don't comment on factual or technical correctness, deprecations, architectural choices, missing guidance, component selection, alternatives, Well-Architected alignment, cost estimates, or reference implementations. Skip checks 1 through 10 in the following sections.
- Don't ask the copy editor to expand the scope of the pull request.
- Prefer an inline suggestion when you can provide the exact replacement. Don't manufacture a comment when the changed text has no actionable copyediting issue.

## Scope: the whole article

Evaluate the article as it stands in this pull request, not just the changed lines. Read the full content body and the paired `.yml` metadata, if one exists, before you comment on anything.

Align your review to the article's content type. It changes how hard you press on some topics. A solution idea isn't expected to cover every Well-Architected pillar; a reference architecture is.

The target reader is a professional cloud architect or software engineer designing a real workload for Azure, usually greenfield. Judge guidance from that seat: "If I had to advise this customer today, is this what I'd say?"

## How to review

Before you start, determine whether this is your first pass on this pull request or a repeat run, and calibrate per "First pass vs. repeat runs" below. Then work through the in-scope checks.

## First pass vs. repeat runs

This skill runs on every push to the pull request branch, so check which pass you're on before you comment:

- **First pass** — no earlier Copilot review exists on this pull request. Do the full review: read the whole article for context and apply every check below.
- **Repeat run** — you already reviewed an earlier commit on this pull request. Back off. Focus only on what changed since your last review and how those changes ripple through the rest of the article. Don't re-review untouched sections, and don't repeat findings you already raised, including ones the author resolved or replied to.

On repeat runs, raise the bar for what earns a comment:

- Comment on high-severity problems the change introduces or exposes: factual errors, deprecated technology, or guidance that's now wrong or self-contradictory.
- Let medium- and low-severity items go unless the change itself created them. Stylistic and nice-to-have nits don't justify another round-trip with the author.
- Don't manufacture findings to justify the run. A run that adds no new comments is a fine outcome, not a failure.

## The checks

Apply the checks in the order listed. Each check is independent, so skip any check that doesn't apply to this article. The individual checks note when they're out of scope.

### 1. Factually correct (grounded in Microsoft Learn)

Extract the article's load-bearing, falsifiable claims such as service names, limits, SLAs, feature behaviors, numeric thresholds, and "you can / you can't" statements. Ground each claim on Microsoft Learn by **following the `microsoft-learn-grounding` skill**. Report claims that are wrong, stale, or newly incomplete. Cite your source.

### 2. Matches the title, opening description, and metadata description

Break the title, H1, and descriptions (metadata and opening section) into their promises. Confirm the body delivers on each. Watch for scope drift: content that wanders off-title, or a title that promises more than the body covers. You can propose a more scoped title to match the body and/or call out what the body is missing or too broadly addressing.

### 3. No deprecated technology or operational processes

If the article recommends, showcases, or depends on anything that's deprecated, the design causes regret. The data in this article must not showcase deprecated technology or solution approaches, and a deprecation notice is never a valid workaround. Treat a violation as a high-severity finding no matter how strong the surrounding guidance is.

Flag any of the following items:

- **Deprecated, retired, or superseded technology.** A service, SKU, API version, tool, or feature that Microsoft announced for retirement, replaced with a successor, or no longer recommends.
- **Deprecated operational processes.** A configuration, deployment, or management procedure that is no longer the supported or recommended mechanism when a documented replacement exists.
- **Retirement paths.** Something still supported today but carrying a published end-of-life or migration deadline the reader should know about.

Cite the retirement or replacement notice, and name the current successor the article author should instead pivot the architecture to use.

### 4. Great, opinionated guidance

Judge whether the article leads the architect to a durable, low-regret design. Check alignment with the Well-Architected Framework and Cloud Adoption Framework. Look specifically for:

- **Undisclosed shortcomings.** Manual steps presented as if automatic, constraints not stated, lock-in from a recommended option. Flag them even when every individual sentence is technically true.
- **Internal contradictions.**
- **Missing core guidance.** What would the architect reading this expect to find that isn't here?
- **Non-"regular-way" approaches.** An unusual or niche path chosen where a mainstream, supported approach exists.
- **Weasel words and marketing speak.** Language that doesn't help an architect understand or justify a decision to their product owner or team, such as vague and unquantified claims. Push for the underlying fact, metric, or limit instead, so the reader can weigh it against their own constraints.

Ground every "current best practice" claim you make on Microsoft Learn and cite your source.

### 5. Images and text tell the same story

For each image in the article, compare what the image depicts against what the article says. They should describe the same design. Look for:

- Components or services in the diagram that the text never mentions, and text that describes important elements absent from the diagram.
- Numbered or lettered callouts that don't match between the figure and the step list, or that are out of order.
- Contradicting details such as different tier names, replication directions, zone or region counts, or connection topology between the picture and the words.

Report any place where a reader following the text would picture something different from the diagram.

Also evaluate **arrow clarity** in architecture diagrams. Arrows carry meaning, so they must be used consistently: either every arrow shows data-flow direction (rare) or, more usefully, every arrow shows a client-server interaction (who calls whom). Pick one convention and hold to it across the diagram. Flag double-headed arrows as they're almost always wrong, because a component is rarely both the client and the server of the same connection. The reader should be able to tell from the arrows what calls what, so they can reason about dependencies and network line-of-sight requirements. Describe on the diagram where the direction is ambiguous, inconsistent, or implies a relationship that doesn't exist.

### 6. Components section is complete, accurate, and purposeful

Only applies when the article has a **Components** section (the list of Azure services and other building blocks the architecture uses). If there's no such section, skip this check. When there is, check four things:

- **No key component is missing.** The list doesn't have to be exhaustive, but every major building block the architecture depends on should appear. Cross-check the list against the diagram, the data flow, and the body. A service the design clearly leans on but never lists is a gap.
- **No listed component is absent from the architecture.** Question or flag anything in the list that the architecture doesn't actually appear to use. "Services you could also consider" don't belong in a list of what this architecture is built from.
- **Each entry states its specific role in *this* architecture.** Every item must say what direct responsibility or capability it provides in this particular design, not just a generic product description lifted from the service's overview. Flag entries that only describe the product in general instead of its job here in this scenario.
- Each item in the components list must contain a link to the product's WAF service guide. If the Well-Architected Framework doesn't have a service guide for the product, then the component must link to its Microsoft Learn product documentation. If it is a non-Microsoft product that doesn't have Microsoft Learn documentation, it must link the official third-party documentation for that component.

### 7. Alternatives are captured, consolidated, and justified

Sound, common alternatives to the design belong in a dedicated **Alternatives** section, not scattered through the article. Alternatives are usually component-level swaps but can also be a different process or approach. The goal is to capture the *most likely* alternatives for this scenario, not to list all alternatives.

Check for:

- **Scattered alternatives.** If the article raises alternatives inline across multiple sections, recommend consolidating them into a single Alternatives section, and note where they currently appear.
- **Weak or unjustified entries.** If a listed alternative isn't meaningfully different, isn't realistic for this scenario, or gives no reason you'd ever choose it, suggest removing it or adding the tradeoff that justifies keeping it.

Every alternative that stays should say *when* a reader would pick it over the primary choice.

### 8. Well-Architected pillar content is filed under the right pillar

Only applies when the article organizes content by Well-Architected Framework pillar section. If the article doesn't have a pillar section, skip this check.

For each pillar subsection, confirm the recommendations under it actually belong to that pillar. You're looking for misfiled content such as a *Reliability* item that's actually a cost tradeoff. Flag anything that belongs under a different pillar. When an item genuinely spans pillars, it should sit under its primary concern and can reference the others rather than being duplicated.

Ground against the WAF pillar definitions on Microsoft Learn per the `microsoft-learn-grounding` skill. Report each misfiled item with the pillar it's under now and the pillar it belongs under and the Learn source for that reason.

### 9. Cost Optimization section links a pricing estimate

Only applies when the article has a Cost Optimization section. The section must include a link to a saved Azure Pricing Calculator estimate for this architecture, not the generic calculator URL. Confirm that the link targets a shared estimate, but don't evaluate whether the estimate's calculations are accurate or current.

### 10. Article and reference implementation align

This check applies only when the article includes a link to a deployable repo. If there's no such link, skip this check. When there is a link, fetch the linked implementation (for example, the GitHub repo it points to) and do a light comparison against what the article says. You're confirming the article and the code tell the same story, not auditing or running the code.

Look for divergences that would matter to a reader who deploys the code expecting what the article describes:

- **Components or resources** the article describes that the implementation doesn't deploy, or resources the code deploys that the article never mentions.
- **Topology, SKUs or tiers, region or zone counts, or key settings** that differ between the article and the code.
- **Instructions or prerequisites** in the article that no longer match the repo (renamed scripts, moved paths, changed parameters).

Call out significant differences and why they matter to the article. Ignore trivial or cosmetic drift.
