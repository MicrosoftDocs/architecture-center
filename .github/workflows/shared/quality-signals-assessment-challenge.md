# Challenge a quality judgment

First read `/tmp/gh-aw/repo-memory/quality-signals/guide.md` to understand the selected record's documented shape and meaning. Then read the supplied work item and initial investigation. Inspect the cited sources independently rather than treating the investigator's conclusions as facts. Use the same source revision as the work item. Don't change records or the guide; the parent investigator owns persistence.

Check that the investigator considered any original proposed remedy rather than merely accepting it, and that the written recommendation is supported by the evidence and consistent with the outcome. A recommendation to leave content unchanged or take no further action is valid; don't demand a change just to produce a solution.

The review should challenge each possible judgment:

- **Finding not present:** Was the correct current content inspected, or was a moved path or failed retrieval mistaken for absence?
- **Present; leave as-is:** Does the reasoning fit the article's purpose, or does it rationalize an actual problem?
- **Present; change recommended:** Does the preferred change address the finding without losing qualifications or introducing unsupported guidance?

Return specific objections and supporting evidence. Don't manufacture disagreement, require consensus, defer to an owner, or modify the investigator's judgment.

Write `/tmp/gh-aw/agent/quality-signals-challenge.json` in this format:

```json
{
  "finding_id": "ID from the selected finding",
  "source_revision": "source_revision from the work item",
  "objections": ["A specific objection supported by the inspected evidence."],
  "evidence": [
    {
      "source": "An independently inspected path or URL.",
      "observation": "What was checked and what it establishes."
    }
  ]
}
```

Use an empty objection list if none is warranted, but always record the inspected evidence. Return actual tool or evidence-access failures to the parent rather than pretending the challenge completed.
