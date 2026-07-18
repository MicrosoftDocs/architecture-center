---
name: pnp-engineering-review
description: 'How to run a engineering review of an Azure Architecture Center article. USE when an "engineering review" is requested of an article, or when asked to review, evaluate, assess, or check the completeness/quality of an article. GitHub Copilot should use this as part of its agentic PR review process for pull requests that appear to be freshness passes. DO NOT USE for ai assisted authoring, for pure link checking alone, or for drafting new content from scratch.'
compatibility: 'Depends on the microsoft-learn-grounding skill, a web search tool, and the link-checker agent. Requires an internet connection.'
disable-model-invocation: false
license: MIT
user-invocable: true
metadata:
  author: 'Azure Patterns & Practices'
---

# Engineering review

This skill is a repeatable process for running an engineering review of an Azure Architecture Center article against a fixed set of quality criteria defined by the Azure Patterns & Practices engineering team. It produces feedback that the author should consider.

The review is read-only. You evaluate and report. You don't edit the article unless the invoker explicitly asks you to fix a specific finding.

## Scope: the whole article

Review the article as it stands today in your workspace. Read the full content body and the paired `.yml` metadata, if one exists, before you evaluate anything.

Align your review to the article's content type. It changes how hard you press on some topics. A solution idea isn't expected to cover every Well-Architected pillar; a reference architecture is.

The target reader is a professional cloud architect or software engineer designing a real workload for Azure, usually greenfield. Judge guidance from that seat: "If I had to advise this customer today, is this what I'd say?"

## Workflow

1. **Build the todo list first.** Enumerate the review steps (below, plus any the invoker adds) as tracked tasks. For interactive use, wait for the invoker to confirm the list before starting; during agentic PR review, proceed through the list automatically. Insert or drop steps when the invoker asks.
2. **Work one todo item at a time.** Mark it in-progress, gather evidence, then report a verdict before moving on. Don't batch.
3. **Report per todo item:** a clear **PASS / FAIL** (or PASS-with-findings), then findings tagged by severity: Critical (wrong or broken), High (missing core guidance, undisclosed shortcoming), Medium (redirects, stale-but-working), Low (nice-to-have). Link findings to specific lines.
4. **Close with a summary** across all steps.

## The steps

These are the todo items for the list. The user can take them in any order, but unless otherwise instructed, expect to operate on them sequentially as listed here.

### 1. Factually correct (grounded in Microsoft Learn)

Extract the article's load-bearing, falsifiable claims such as service names, limits, SLAs, feature behaviors, numeric thresholds, "you can / you can't" statements. Ground each one on Microsoft Learn by **following the `microsoft-learn-grounding` skill**. Report claims that are wrong, stale, or newly incomplete. Cite your source.

### 2. Matches the title, opening description, and metadata description

Break the title, H1, and descriptions (metadata and opening section) into their promises. Confirm the body delivers on each. Watch for scope drift: content that wanders off-title, or a title that promises more than the body covers. You can propose a more scoped title to match the body and/or call out what the body is missing or too broadly addressing.

### 3. No deprecated technology or operational processes

If the article recommends, showcases, or depends on anything that's deprecated, the design causes regret. Per policy, the data in this article must not showcase deprecated technology or solution approaches, and a deprecation notice is never a valid workaround. Treat a violation as a high-severity finding no matter how strong the surrounding guidance is.

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

Only applies when the article has a **Components** section (the list of Azure services and other building blocks the architecture uses). If there's no such section, skip this step. When there is, check four things:

- **No key component is missing.** The list doesn't have to be exhaustive, but every major building block the architecture depends on should appear. Cross-check the list against the diagram, the data flow, and the body. A service the design clearly leans on but never lists is a gap.
- **No listed component is absent from the architecture.** Question or flag anything in the list that the architecture doesn't actually appear to use. "Services you could also consider" don't belong in a list of what this architecture is built from.
- **Each entry states its specific role in *this* architecture.** Every item must say what direct responsibility or capability it provides in this particular design, not just a generic product description lifted from the service's overview. Flag entries that only describe the product in general instead of its job here in this scenario.
- Each item in the components list must contain a link to the product's WAF service guide. If the Well-Architected Framework doesn't have a service guide for the product, then the component must link to its Microsoft Learn product documentation. If it is a non-Microsoft product that doesn't have Microsoft Learn documentation, it must link the official third-party documentation for that component.

### 7. Alternatives are captured, consolidated, and justified

Sound, common alternatives to the design belong in a dedicated **Alternatives** section, not scattered through the article. Alternatives are usually component-level swaps but can also be a different process or approach. The goal is to capture the *most likely* alternatives for this scenario, not to list all alternatives.

Check for:

- **Scattered alternatives.** If the article raises alternatives inline across multiple sections, recommend consolidating them into a single Alternatives section, and note where they currently appear.
 - **Missing likely alternatives.** Research what the industry commonly uses for this scenario. When there's clear evidence that a mainstream alternative is widely used for this scenario and the article doesn't mention it, name it and cite your source.
- **Weak or unjustified entries.** If a listed alternative isn't meaningfully different, isn't realistic for this scenario, or gives no reason you'd ever choose it, suggest removing it or adding the tradeoff that justifies keeping it.

Every alternative that stays should say *when* a reader would pick it over the primary choice.

### 8. Well-Architected pillar content is filed under the right pillar

Only applies when the article organizes content by Well-Architected Framework pillar section. If the article doesn't have a pillar section, skip this step.

For each pillar subsection, confirm the recommendations under it actually belong to that pillar. You're looking for misfiled content such as a *Reliability* item that's actually a cost tradeoff. Flag anything that belongs under a different pillar. When an item genuinely spans pillars, it should sit under its primary concern and can reference the others rather than being duplicated.

Ground against the WAF pillar definitions on Microsoft Learn per the `microsoft-learn-grounding` skill. Report each misfiled item with the pillar it's under now and the pillar it belongs under and the Learn source for that reason.

### 9. Cost Optimization section links a pricing estimate

Only applies when the article has a Cost Optimization section. The section must include a link to a saved Azure Pricing Calculator estimate for this architecture, not the generic calculator URL. Confirm that the link targets a shared estimate, but don't evaluate whether the estimate's calculations are accurate or current.

### 10. Article and reference implementation align

This step applies only when the article includes a link to a deployable repo. If there's no such link, skip this step. When there is a link, fetch the linked implementation (for example, the GitHub repo it points to) and do a light comparison against what the article says. You're confirming the article and the code tell the same story, not auditing or running the code.

Look for divergences that would matter to a reader who deploys the code expecting what the article describes:

- **Components or resources** the article describes that the implementation doesn't deploy, or resources the code deploys that the article never mentions.
- **Topology, SKUs or tiers, region or zone counts, or key settings** that differ between the article and the code.
- **Instructions or prerequisites** in the article that no longer match the repo (renamed scripts, moved paths, changed parameters).

Call out significant differences and why they matter to the article. Ignore trivial or cosmetic drift.

### 11. Aligns with industry perspective

Compare the article's positions and terminology against how the broader industry describes the same system. Use your **web search tool** to consult reputable non-Microsoft sources: vendor technical reports and reference architectures, integrator and practitioner guides, and cloud-agnostic references. When the topic has a clear equivalent on another hyperscaler, check the other hyperscalers' documentation too (for example, AWS or Google Cloud documentation for the same workload or pattern). A competitor's treatment of the same problem is a legitimate industry-perspective signal, even though you'll ground the Azure specifics on Microsoft Learn.

Report scope divergence in both directions:

- **The article covers something others don't.** Novel or opinionated positions can be a strength, but flag them so the author can confirm the claim is intentional and defensible rather than an outlier or scope creep.
- **Others cover something the article doesn't.** A topic, constraint, or design consideration that the industry treats as important but the article omits is a gap candidate. The author decides whether it belongs in scope.

Sourcing rules: prefer first-party vendor and reputable practitioner sources, and attribute them. Watch for terminology misalignment such as cases where the article uses a product or domain term differently than the industry does.

### 12. URLs avoid redirects and dead-ends

Collect every link in the article and pair it with the context where it's used. Resolve site-relative and repo-relative links to their published absolute URLs for validation while retaining the original link and source context, then run the `link-checker` agent over that list.

Your job is to interpret the agent's table, not to re-verify it. Report real redirects, silent aliases, irrelevant content, and dead-ends with the lines where they appear. Watch for known false positives: the agent probes with a plain `curl` and no browser identity, so some hosts return blocking codes even though the page is fine in a browser. When the agent flags one of those as an error, label it a probable false positive for a human to confirm rather than reporting it as a dead-end.

## What you won't be checking for

- Grammar and spelling
- Metadata correctness (for example, `ms.date`, `author`, `ms.author`, `ms.topic`, `ai-usage`)