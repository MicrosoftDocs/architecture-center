
Prompt 1 – Identify files under a toc node: Copy the toc.yml excerpt for node {NODE_NAME} below. List each leaf article (href) with inferred type (pattern, best-practice, guide, reference) and a one-line inferred purpose. Return a table. Toc excerpt: ```yaml <Paste the node snippet from toc.yml>


## 2. Summarize Each Article
Prompt 2 – Batch summarization:
You will receive N articles from the {NODE_NAME} set. For each, return: 
- file
- doc_type (infer)
- primary objective (<=12 words)
- key takeaways (3–5 bullets)
- prerequisites (if any)
- related patterns/links (only if explicitly present)
Respond in a markdown table. Articles: 
BEGIN FILE: {path1}
<content>
END FILE
... (repeat)

## 3. Thematic Clustering
Prompt 3 – Theme clustering and learning path:
Using prior summaries (don’t re-summarize raw text), cluster the articles into 3–7 thematic groups. For each group give: name, rationale, member files (ordered for learning path), dependency notes, and whether an overview subsection is warranted. Conclude with a recommended overall sequence across groups.

## 4. Gap & Overlap Analysis
Prompt 4 – Gap / overlap:
Based on clusters, identify:
- Overlaps (pairs or triads) and suggested consolidation
- Missing prerequisite concepts
- Missing advanced/deep-dive topics
- Redundant terminology inconsistencies
Provide actionable recommendations (imperative verbs).

## 5. Overview Article Outline
Prompt 5 – Outline generation:
Draft a proposed outline for a new overview article introducing {NODE_NAME}. Must include: Purpose, Audience, When to use this set, Concept map (describe), Thematic sections (one paragraph preview each), How to navigate (decision table or flow), Related Azure services, Next steps (ordered links), Further reading. Keep outline bullets concise. Assume audience: {GOAL_AUDIENCE}. Tone: {TONE}. Primary outcome: {PRIMARY_OUTCOME}.

## 6. Draft the Overview Article
Prompt 6 – Full draft:
Using the approved outline (paste below), write the full overview article (≈ {OVERVIEW_LENGTH} words). Include:
- YAML front matter (title, description ≤155 chars, ms.topic:introduction, keywords array)
- Intro paragraph (problem space + value)
- Concept map description (no image, text only)
- Each thematic section (≤150 words) with 1–3 inline links to member articles
- Decision aid (table) guiding which article to read first for common scenarios (columns: Scenario | Start With | Why)
- Calls to action (bullet list)
- Consistent terminology, no marketing fluff
Outline:
<paste outline>
If data gaps exist, insert TODO: <description>.

## 7. Metadata & SEO Refinement
Prompt 7 – Metadata optimization:
Given the draft (paste), propose:
1. 3 alternative SEO-friendly titles (≤60 chars)
2. Meta description variants (≤155 chars)
3. 8–12 keyword phrases (no duplicates, intent-balanced)
4. Slug suggestion (kebab-case)
Justify any keyword additions (short note).

## 8. Link & Navigation Map
Prompt 8 – Link map:
Produce a map: For each existing article file, list: Inbound relevance angle (why overview should link to it), Suggested anchor text variants (2–3), and Priority (High/Med/Low). Then list gaps where an anchor text is needed but no article exists yet.

## 9. Consistency & Style QA
Prompt 9 – Style check:
Review the draft overview for: passive voice >10%, sentence length outliers, unexplained acronyms, inconsistent capitalization of Azure service names, and list overuse. Provide a findings table and revised snippets only where changes are needed. Don’t rewrite the whole article.

## 10. Compression / TL;DR
Prompt 10 – Executive summary:
Create a TL;DR (≤120 words) and a bullet “elevator pitch” (≤5 bullets, each ≤12 words) for internal reviewers.

## 11. Version Diff Refinement (Optional)
Prompt 11 – Delta improvement:
Here is V1 and a reviewer’s comments. Produce V2 with tracked change commentary (inline [COMMENT: …]) only where modified. Maintain original section numbering. 
V1:
<paste>
Reviewer notes:
<paste>

## 12. Reusable Prompt Wrapper (All-in-One When Small Set)
Prompt 12 – Compact end-to-end (use only for ≤6 short files):
You are generating an overview introduction for the {NODE_NAME} article set. Goals: {PRIMARY_OUTCOME}. Audience: {GOAL_AUDIENCE}. Tone: {TONE}. Files and contents follow. Steps you must perform sequentially in one response: (1) per-file summary; (2) thematic clustering; (3) gap/overlap list; (4) outline; (5) full draft (≤ {OVERVIEW_LENGTH} words); (6) metadata (title options, description, keywords). If info missing, insert TODO. Keep response structured with clear headings. Files: (paste BEGIN/END blocks).

## 13. Focused Refinement (Length / Clarity / Depth)
Prompt 13A – Shorten:
Reduce overview length by 15% without losing unique concepts. Provide a diff-like list of removed/condensed segments.
Prompt 13B – Clarify:
Identify sentences with >28 words or ≥2 subordinate clauses. Rewrite them more simply.
Prompt 13C – Depth boost:
Enhance only the “Concept map” section with one concise domain example; keep total word count growth ≤60.

## 14. Accessibility & Inclusive Language Check
Prompt 14 – Accessibility:
Scan the draft for: idioms, potentially exclusionary phrases, non-descriptive link text (“click here”), missing alt guidance (if images referenced). Return a fixes table (Issue | Location | Recommended fix).

## 15. Final Publication Readiness Gate
Prompt 15 – Publication gate:
Evaluate the draft across: Structure completeness (Y/N), Redundancy, Reading level (approx grade), Terminology consistency, Link density appropriateness, Metadata quality. For any “No” or risk, provide a remediation step. Conclude with PASS or BLOCK and rationale.

---

## Example (Filling Variables Quickly)
If working on “Best practices for cloud applications”:
- {NODE_NAME}: Best practices for cloud applications
- {GOAL_AUDIENCE}: Solution architects & senior backend engineers
- {PRIMARY_OUTCOME}: Quickly locate the specific best practice they need
- {OVERVIEW_LENGTH}: 700
- {TONE}: Authoritative, concise
Use Prompt 1 with that node’s toc snippet, then proceed.

---

## Minimal Starter (If You Need Just Two Prompts)
Starter Summarize:
Summarize these related articles (list paths) into a comparison table (file | purpose | 3 takeaways | when to read first) and propose 4–6 section headings for an overview article that would introduce them.

Starter Draft:
Using the headings you proposed, draft an overview intro (≤600 words) that orients a new architect, includes a decision table (Scenario | Start With | Reason), and ends with next-step links. Provide front matter.

---

Let me know if you want these wrapped into a single markdown reference file or tailored to a specific toc node.