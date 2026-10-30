# Conditional investigation guidance

Choose checks from the allegation and evidence, not just its source category. These methods aren't exhaustive.

## Start with the reader's outcome

- Identify the affected task and actual reader consequence. Don't invent feedback, metrics, or measured benefits, or optimize for evaluator preferences over reader needs.
- A flagged condition needn't warrant a change. Explain why leaving it serves the reader, or recommend a targeted correction without repetition, new dependencies, unsupported assumptions, or contradictions.
- Separate observed facts from judgment; explain the preferred next step, expected benefit, and qualifications to preserve.
- For architectural changes, evaluate scenario trade-offs against the [Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/what-is-well-architected-framework) and service guidance; don't presume one pillar or a newer service dominates.
- Don't allow a recommendation to deviate from the content type's template.

## Keep checks proportional

Seek enough evidence for the selected decision, not an exhaustive audit.

- For an editorial or structural finding, check meaning, context, qualifications, and reader benefit.
- Fetch Learn evidence when a Microsoft-product technical claim is necessary to the judgment or proposed correction.
- Inspect an image only if its content could materially change the selected judgment.
- Stop investigating alternative rewrites once evidence supports a specific, bounded recommendation.

## If the finding concerns a link

- Locate the current link and its purpose; don't investigate unrelated destinations.
- Inspect destination content, not just status codes or redirects. Verify a canonical replacement preserves the purpose and useful deep link; consider clearer text or a verified anchor.
- Remove unnecessary nearby duplication, but retain useful links in independently readable sections.
- Distinguish destination failure from transient errors, network/authentication restrictions, rate limits, or server blocks based on IP, user agent, or headers.
- Remove a link only if its purpose is unnecessary or the reader's task remains supported. For essential unavailable resources, specify the information a replacement must supply.

## If the finding concerns a product lifecycle, support, or naming claim

- Identify the exact service, feature, version, tier, or deployment model. Verify authoritative current documentation, distinguishing rename, retirement announcement, end of support, and feature limitations.
- Include only modern approaches in the solution. Avoid involving legacy, classic, deprecated options/choices.
- Distinguish intentional historical/migration/compatibility context from active greenfield recommendations.
- Verify alternatives meet required capabilities; consider compatibility, migration, cost, security, reliability, and operations.
- Distinguish peripheral corrections from central redesigns. Describe the supported replacement for architectures dependent on unsupported technology; a deprecation notice isn't a workaround.

## If the finding concerns procedures, prerequisites, or missing context

- Match the article's promise and expected reader knowledge; conceptual guidance isn't a deployment tutorial.
- Check surrounding content and linked prerequisites for information discoverable before the dependent step.
- For executable procedures, check resources, access, tools, versions, inputs, and constraints without inventing values, privileges, or supported configurations.
- Check purpose, recognizable success, and consequences, costs, or recovery for resource changes/removal.
- Prefer focused explanations or maintained service instructions; preserve architectural reasoning without duplicating setup guides or adding unnecessary procedures.

## If the finding concerns headings, structure, or extracted passages

- Check headings predict and distinguish section purpose while preserving product names and scope.
- Read passages in context and standalone. Keep applicability, prerequisites, units, limits, exceptions, and warnings beside the claims they qualify.
- Choose prose, lists, steps, or tables aligned to help the reader with their task. Check table labels, headings, units, empty cells, and footnotes for ambiguity.
- For code, check purpose, placeholder inputs, and result meaning. Add missing context needed for use. Preserve precision when shortening or splitting.
