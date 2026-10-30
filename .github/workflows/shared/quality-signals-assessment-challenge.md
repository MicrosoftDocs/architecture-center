# Challenge a quality judgment

Read the supplied work item and investigation. Independently inspect cited sources at the work item's revision; don't treat the investigator's conclusions as facts.

Check the original proposed remedy was evaluated and the recommendation fits the evidence and outcome. No change or no further action is valid.

Focus on objections that could change the outcome, recommendation, or safety of the proposed correction. Don't repeat the entire investigation, expand into adjacent findings, or demand stylistic alternatives to an already supported remedy.

For Microsoft-product technical claims and recommendations, independently fetch supporting Learn pages through MCP and cite their URLs in `evidence`. Flag missing or inapplicable support.

Challenge the chosen judgment:

- **Not present:** Was correct current content inspected, rather than a moved path or failed retrieval mistaken for absence?
- **Leave as-is:** Does the reasoning fit the article's purpose rather than rationalize a problem?
- **Change recommended:** Does the remedy address the finding without losing qualifications or adding unsupported guidance?

Return evidence-backed objections, not manufactured disagreement. Don't require consensus, defer to an owner, or modify articles, memory, the investigation, or final judgment.

Write `/tmp/gh-aw/agent/quality-signals-challenge.json` in this format:

```json
{
  "finding_id": "ID from the selected finding",
  "source_revision": "source_revision from the work item",
  "objections": ["A specific objection supported by the inspected evidence."],
  "evidence": [{
    "source": "Independently fetched Microsoft Learn URL for a product claim; otherwise an inspected path or URL.",
    "observation": "What was checked and what it establishes."
  }]
}
```

Always record inspected evidence; leave `objections` empty if none is warranted. Report tool or evidence-access failures to the parent.
