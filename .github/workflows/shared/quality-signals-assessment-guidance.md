# Conditional investigation guidance

All of these methods are available for every finding. Select and combine them according to the actual allegation and evidence. The list isn't exhaustive and you aren't constrained to just these. Performing an open investigation is a valuable use of your time.

## Start with the reader's outcome

- Identify the decision or task affected by the finding. Explain the actual consequence: a blocked next step, a misleading choice, missing context, or unnecessary effort. Don't invent customer feedback, satisfaction scores, or measured benefits.
- Don't optimize for an evaluator's preferred wording or format at the expense of the reader. A flagged condition can exist without warranting a change. Explain why the current presentation serves the reader when recommending no change.
- Prefer a targeted correction that fully addresses the problem. Consider whether it would introduce repetition, new dependencies, unsupported assumptions, or contradictions elsewhere in the article.
- When a recommendation changes an architectural decision, evaluate its trade-offs against the scenario's requirements and the [Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/what-is-well-architected-framework). Consider applicable service guidance rather than assuming one pillar or a newer service outweighs all other concerns.
- Distinguish evidence about the current content from your judgment about a better presentation. Recommend a specific next step and explain the expected reader benefit, including qualifications or trade-offs that must be preserved.

## If the finding concerns a link

- Locate the link in the current article and determine what the reader needs from it: prerequisites, explanation, deployment steps, reference material, or supporting evidence. If the reported link is no longer used, don't investigate an unrelated destination as though the finding still applies.
- Inspect the destination content, not just its response code. A redirect or successful response can lead to an unrelated page. Prefer a verified canonical destination that still satisfies the original purpose; don't replace a useful deep link with a generic landing page merely because it responds.
- Evaluate whether clearer link text or a verified section anchor would help readers find the needed information.
- Avoid unnecessary duplicate links in nearby sections, but don't remove a useful link from an independently readable section solely because it appears elsewhere.
- Don't confuse transient errors, networking restrictions, authentication, rate limits, or server blocks based on IP range, user agent, or request headers with a broken link. Require clear evidence and distinguish tool-access limitations from destination failure.
- Recommend removal only when the link's purpose is no longer needed or the surrounding content can still support the reader's task. If an unavailable resource is essential, explain what information a replacement must provide rather than silently removing the dependency.

## If the finding concerns a product lifecycle, support, or naming claim

- Identify the exact service, feature, version, tier, or deployment model involved.
- Verify the claim with current authoritative lifecycle or product documentation. Distinguish a rename, retirement announcement, end-of-support date, and a specific feature limitation.
- Determine the reference's role. Historical, migration, and compatibility context can be intentional; active greenfield recommendations that depend on unsupported technology need a different response.
- When recommending an alternative, verify that it supports the capability the reader actually needs. Consider compatibility, migration effort, cost, security, reliability, and operational implications where relevant.
- Distinguish a peripheral correction from a change to the solution's central design. For an architecture that depends on unsupported technology, describe the supported redesign or replacement needed.
- A deprecation notice is not a valid workaround.

## If the finding concerns procedures, prerequisites, or missing context

- Establish what the article promises and what its intended reader is expected to know. A solution idea or architecture explanation doesn't need a deployment tutorial.
- Check surrounding content and linked prerequisites before concluding that information is missing. Judge whether the reader can discover what they need before reaching the dependent step.
- For an executable procedure, look for starting conditions that materially affect success: required resources, access, tools, versions, inputs, and relevant constraints. Recommend the missing information without inventing values, privileges, or supported configurations.
- Check whether the reader can understand the operation's purpose and recognize success. Where a task changes or removes resources, consider whether missing consequences, cost implications, or recovery guidance could lead to regret.
- Prefer a focused explanation or a link to maintained service instructions when that meets the need. Keep the article's architectural reasoning. Don't duplicate an entire setup guide or convert a conceptual section into a sequence of unnecessary steps.

## If the finding concerns headings, structure, or extracted passages

- Judge whether a heading helps readers predict the section's purpose and distinguish it from neighboring sections. Preserve necessary product names and scope.
- Check the reported passage both in context and as a plausible standalone section. Keep applicability, prerequisites, units, limits, exceptions, and important warnings close enough to the statement they qualify to avoid a misleading interpretation.
- Choose prose, lists, steps, or tables according to the reader's task.
- For tables, check whether row labels, column headings, units, empty cells, and footnotes support an unambiguous reading.
- For code, establish what the operation does, what inputs are placeholders, and what the result means. Recommend additional context when its absence impedes use.
- Preserve precision when shortening or splitting content.
