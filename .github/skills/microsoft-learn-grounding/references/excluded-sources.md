# Excluded Microsoft Learn sources

Do not cite, fetch for guidance, or paraphrase from these, even when search returns them as top hits.

Some exclusions have a deterministic substitute (a known sibling URL you can rewrite to). Others have no substitute and force you to discard the result and re-search.

## Excluded Microsoft Learn URLs

- Per-service Azure security baselines

  URL pattern: `learn.microsoft.com/<locale>/security/benchmark/azure/baselines/<service>-security-baseline`

  Why: Every published baseline carries a Microsoft warning that the content *"may contain outdated guidance."* The risk of citing stale security guidance outweighs the value.

  Substitute: None, re-search

- Microsoft Cloud Security Baseline (MCSB) v1.0 deep links

  URL pattern: `learn.microsoft.com/<locale>/security/benchmark/azure/mcsb-*` URL without the `-v2-` segment.

  Why: These URLs point to the deprecated v1 version of the Microsoft Cloud Security Benchmark.

  Substitute: Rewrite the `mcsb-` segment to `mcsb-v2-` and fetch that URL. If the v2 equivalent does not exist, re-search.

- Anything on the `azure.cn` domain

  URL pattern: `azure.cn/*`

  Why: a lagging, partial mirror of Learn, designed to be specific to Azure China Operated by 21Vianet. Never link to it or use it as a source.

  Substitute: None, re-search.

- Non `en-us` locale pages

  URL pattern: `learn.microsoft.com/<locale other than en-us>/*`

  Why: Auto-translated pages can lose technical precision and sometimes lag the English source.

  Substitute: Rewrite the `<locale>` segment to `en-us` and fetch that URL.

- Previous-version archive pages

  URL pattern: `learn.microsoft.com/<locale>/previous-versions/*`

  Why: These pages document superseded versions of products, SDKs, APIs, or architectural opinions and are kept online for historical reference only.

  Substitute: None, re-search for the current data on the topic.

- AI Playbook

  URL pattern: `learn.microsoft.com/<locale>/ai/playbook/*`

  Why: The AI Playbook is hosted on the `learn.microsoft.com` domain but is not part of the governed Microsoft Learn content set. It does not carry editorial or freshness guarantees.

  Substitute: None, re-search.

## Non-authoritative sources

Microsoft Tech Community posts, Azure team blogs, MVP articles, and third-party guidance are never authoritative grounding. They can inform reasoning; they cannot back a claim. Reference them only when Learn does not cover the topic, and attribute them clearly.

## When search returns an excluded URL

If `microsoft_docs_search` returns an excluded URL as the top hit, apply that entry's Substitute rule.
