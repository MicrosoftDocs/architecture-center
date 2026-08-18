---
name: microsoft-learn-grounding
description: 'How to use the Microsoft Learn MCP server to ground answers, recommendations, or content edits. USE when the data on a Learn page will inform something you are about to claim, recommend, write, or edit. DO NOT USE for tactical work where guidance is not the point.'
compatibility: 'Requires an internet connection to the Microsoft Learn API.'
disable-model-invocation: false
license: MIT
user-invocable: false
metadata:
  author: 'Microsoft Patterns & Practices'
---

# Microsoft Learn grounding via MCP

This skill is guidance on how to use the Microsoft Learn MCP server effectively while you do your work. It is not a black-box "grounding service" that you hand a query to and get a sanitized answer from. These are the practices to follow whenever Microsoft Learn data is going to inform something you're about to claim, recommend, write, or edit.

Your training data is stale. Microsoft Learn is the source of truth. However, even Microsoft Learn has stale data, and this skill will help you navigate that.

## The MCP server is the only approved channel

When you consult Microsoft Learn for grounding, use the Microsoft Learn MCP server at `https://learn.microsoft.com/api/mcp`. Do not substitute browser automation, `curl` or `wget` against `learn.microsoft.com`, ad-hoc web search, the Bing or Google index, cached snippets, or any other channel. If the MCP server can't answer the question, surface that to the user rather than working around it.

The two tools you'll use:

- `microsoft_docs_search`: keyword/semantic search; returns ranked Learn URLs with short excerpt chunks. Use it to find the right page. The excerpts are a routing signal, not grounding.
- `microsoft_docs_fetch`: retrieves the full page content for a URL. This is what you actually ground on.

## When you don't need this skill

This skill is about pulling guidance data out of Learn. It is not for tactical operations against Learn URLs where the guidance content is not the point. Skip it when you're:

- Checking whether a link works: redirect tests or broken-link checks.

- Resolving the canonical form of a URL, normalizing trailing slashes, or testing locale segments before linking.

- Verifying that an anchor exists on a Learn page you're already linking to (`#some-section`).

- Fetching a Learn page for a non-grounding reason.

  For example, comparing the scope of an article you're editing against the published version, checking which topics a related page covers so you don't duplicate them, or pulling a page to explore its structure. The exclusion list in this skill applies to grounding data retrieval; you can still fetch excluded pages (or the article's own published version) when the page itself, not the guidance in it, is what you need.

For any of those, use whatever direct tool or self-guided process fits. The `microsoft_docs_fetch` tool is still the right way to retrieve the page content.

## You decide what the data means

Neither the MCP server nor this skill tells you how to decide:

- Whether any Learn content is applicable to the task you're working on.
- What you should claim, recommend, or write based on it.
- Tone, framing, structure, or wording.
- Whether a deprecation or caveat the data surfaces actually matters in your scenario.

## How to use the MCP server effectively

Apply these practices every time you're grounding on Learn. This isn't a rigid pipeline; it's the flow that keeps you from grounding on the wrong data.

### 1. Search when you don't already have a URL

Call `microsoft_docs_search` with the topic. If you already have a specific Learn URL in hand: one the invoker provided, one cited in the article you're editing, or a known canonical page, you can skip the search and go straight to fetching.

Don't skip the search just because you "remember" a URL from training data. If you didn't get the URL this turn, search for it.

### 2. Normalize and filter before you trust a URL

Whether the URL came from search or you brought it in yourself, rewrite the locale segment to `en-us` (form: `https://learn.microsoft.com/en-us/<path>`) before you act on it. Auto-translated locale pages can lose technical precision and sometimes lag the English source.

Then check the URL against [excluded-sources.md](./references/excluded-sources.md) and drop it if it matches, even if it's the top-ranked result. If nothing survives, re-search with terms that bias toward non-stale data.

Also discard self-referential results per [self-reference-rule.md](./references/self-reference-rule.md). Grounding an article's .md on its published version doesn't make a claim more true. This applies to the article you're editing right now, not to the whole `/azure/architecture/` URL space; sibling articles in this repo are fine to ground on.

### 3. Fetch the full page; never ground on excerpts

Call `microsoft_docs_fetch` on every URL you intend to cite, quote, paraphrase, or draw a recommendation from. The search excerpt is too short, contains no metadata, and is too narrow to ground on; assume it will omit the very caveat, prerequisite, or retirement notice that would change your recommendation.

### 4. Fan out when there might be more to the story

A fetched page might just be a starting point, not the whole picture. If the page you have feels like an overview or summary of your topic, consider fanning out. You might want to explore a few of linked pages you believe will directly improve your grounding data and fetch them too.

### 5. Watch for deprecation signals on the pages you fetched

While you're reading the fetched pages for your topic, also scan them for signs the feature is being retired or superseded. See [detect-deprecations.md](./references/detect-deprecations.md) for the signals and what to do about them. Grounding on a page about a retiring feature and recommending that feature anyway is not appropriate.

### 6. Treat the page itself as the grounding, not your summary of it

When you go to write or recommend, ground on what the fetched page actually says, not your memory of it from earlier in the turn. If the raw, non-compacted fetch result is still in your context, reuse it. If only your summary remains, fetch again.

## When the MCP server can't help

- If the MCP server is not configured in your environment, tell the user and stop. Do not fall back to training data or open web searches and present it as if it were grounded.
- If a search fails, comes back empty, or comes back with irrelevant findings, retry a few times and work for a better outcome. If it keeps failing, say so. Do not silently fall back to training data.
- If a direct fetch fails, retry a few times. If it keeps failing, say so. Do not silently fall back to the search snippet or to training data.
