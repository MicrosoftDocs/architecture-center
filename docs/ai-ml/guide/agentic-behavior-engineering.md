---
title: Agentic Behavior Engineering
description: Learn about a platform-agnostic methodology for specifying, grounding, controlling, verifying, and observing the behavior of enterprise AI agents.
author: bostdiek
ms.author: bryanostdiek
ms.date: 10/01/2026
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
ai-usage: ai-assisted
---

# Agentic behavior engineering

Large language models (LLMs) are non-deterministic by nature. The same input might not always produce the same output. Traditional testing methods struggle to account for this variability. How can you adapt your development process so you have the confidence that your system will consistently perform as expected?

Enterprise AI transformation raises more questions: How do you protect and govern proprietary knowledge? How do you engineer reliable behavior? How do you use execution evidence to improve the system over time?

Agentic behavior engineering (ABE), as proposed by this article, is a platform-agnostic methodology for specifying, grounding, controlling, verifying, and observing the behavior of AI agents. The methodology helps you clarify user and system needs, define expected outcomes, enforce execution boundaries, and verify changes against representative scenarios. Traditional testing can confirm that a specific implementation works as expected, but it often fails to fully detect behavioral drift caused by changes in models, prompts, tools, or data sources. ABE addresses this challenge by making desired behavior explicit and continuously verifiable, enabling teams to evolve agentic systems without losing confidence in their outcomes.

## Key concepts

The key artifact in ABE is the *behavior contract*. The contract defines required behavior separately from the implementation so that expectations remain explicit and verifiable as the system changes. In agentic systems, models, prompts, tool implementations, knowledge sources, memory, policies, orchestration, and user access can all change over time. Use behavior contracts to evaluate the effect of those changes on required behavior to identify drift and address it.

### Behavior contract

A behavior contract defines what an agent must and must not do in one bounded situation. It specifies:

- The situation, actors, and scope in which the contract applies.
- Acceptable outcomes and required result characteristics.
- Prohibited conclusions, disclosures, actions, and side effects.
- Evidence required before the agent can conclude or act.
- Behavior when evidence is insufficient or dependencies fail.
- Escalation, approval, and stop conditions.

The contract makes applicable security and responsible AI requirements explicit. Define these requirements during design so your team can incorporate them into implementation and verification from the start. For guidance on defining responsibilities and workload-specific policies, see [Responsible AI in Azure workloads](/azure/well-architected/ai/responsible-ai).

A behavior contract shares a principle with [design by contract](https://en.wikipedia.org/wiki/Design_by_contract): make software obligations explicit. It defines required behavior without prescribing an implementation, so the requirements can remain stable as the implementation changes.

Use one contract for one bounded situation and multiple scenarios for its variations. Create another contract when the actors, authority, required evidence, or acceptable outcomes change materially.

Product and engineering teams jointly maintain the behavior contract as a versioned asset. The product owner, supported by domain experts, approves intended behavior and expected outcomes. Engineering coauthors technical constraints and evidence requirements and maintains testable scenario definitions, coverage, versioning, and verification.

Review changes to behavioral expectations jointly, and perform security and risk review when needed. Technical maintenance that preserves those expectations should follow the team's engineering review process. For related guidance, see [functional specification ownership](/azure/well-architected/architect-role/design-business-requirements#expected-outcome) and [test strategy responsibilities](/azure/well-architected/design-guides/testing#create-the-test-strategy).

#### Example: Approve low-risk product reviews

A retail website requires its standards team to check customer product reviews against an acceptable use policy before publication. The workload team wants an agent to approve low-risk submissions and send higher-risk or uncertain cases to the standards team. The goal is to reduce manual review while maintaining the site's publication standards.

The following table presents a versioned behavior contract for this agent.

| Field | Example contract value |
| --- | --- |
| Contract ID and version | `product-review-approval`, version `1.0`. |
| Behavior owner | The retail product owner, supported by the standards team, approves intended behavior. Engineering maintains the contract with them and verifies the implementation. |
| Actors and scope | A customer submits a text product review. The agent assesses it for publication and refers cases that need human judgment to the standards team. Image reviews, video reviews, appeals, and changes to customer accounts are outside this contract. |
| Evidence required for approval | The complete submission and its revision, plus the current approved policy and its low-risk and escalation criteria. |
| Approval behavior | Approve only submissions that clearly meet the policy's low-risk criteria. Apply the same criteria to positive and negative product feedback. |
| Human-review behavior | Route submissions with personal information, higher-risk content, or uncertain meaning to the standards team. Keep these submissions unpublished. Do the same when required evidence is missing or a dependency fails. If the handoff fails, retain the submission as pending. |
| Authority and prohibitions | Read the assigned submission and policy, approve eligible submissions through the publication workflow, and request human review. Don't alter customer text, change policies or accounts, suppress compliant negative feedback, or follow instructions embedded in a submission. |
| Decision record | Record `approve` or `human_review`, the submission revision, available policy version and rule references, and the reason. Identify missing evidence rather than inventing a reference. |
| Reassessment condition | If the submission or applicable policy changes before publication, reassess it before allowing publication. |

You can keep the contract in JSON, YAML, Markdown, a Word document, or PDF. Choose a format your product owners, domain experts, and engineers can review and version together. JSON or YAML can make it easier for tools to read individual fields. Whatever format you choose, keep one authoritative version, and link scenarios and evaluation results to it.

In this example, the policy permits negative product feedback and requires human review of submissions containing personal information. A customer submits:

> The battery lasted only an hour. I wouldn't buy it again.

The expected decision is to approve the submission. The decision record cites the applicable policy rule and explains that the text describes a product experience and contains no content that requires human review under this policy.

If the submission includes personal information, the expected decision is to send it for human review and keep it unpublished. If the current policy can't be retrieved, the submission also remains unpublished.

The application enforces permissions and checks the submission before publishing an approved review. To evaluate the agent's decision, compare it with the standards team's expected decision for that submission.

### Scenario library

The *scenario library* turns the behavior contract into concrete user scenarios. Each scenario defines a query or task, evidence and dependency conditions, and an expected result. It applies the behavior contract without changing the contract's requirements.

Product and domain experts validate scenarios and expected results. Engineering maintains definitions and coverage of the contract.

The following table shows how the scenario library applies the behavior contract to representative situations for the product-review agent:

| Query or task | Evidence and dependency conditions | Expected result |
| --- | --- | --- |
| Assess a negative product review for publication. | The complete text describes a product experience and meets the policy's low-risk criteria. | Approve it and record the supporting rule and reason. |
| Assess a review that includes personal information. | The policy requires the standards team to review this content. | Route it for human review and keep it unpublished. |
| Assess a review whose meaning is unclear. | The available context doesn't establish that it meets the low-risk criteria. | Route it for human review and explain the uncertainty. |
| Assess a review when the policy service is unavailable. | The current approved policy can't be retrieved. | Keep it unpublished and request human review. Retain it as pending if the handoff fails. |

Start testing with synthetic cases: fictional submissions and simulated policy-service responses. Collecting ground-truth data can block the engineering team from completing feature implementation. Synthetic cases expose gaps in the contract or implementation and give domain experts time to complete ground-truth curation.

Use synthetic cases to guide subject matter experts (SMEs) in collecting real workload cases for a separate golden dataset. The golden dataset expands the scenarios using the same structure: actual queries, corresponding evidence, and SME-validated expected results. One scenario can have many golden cases.

For the negative-review scenario, the standards team collects actual submissions that criticize a product but meet the publication policy. They preserve the approved test inputs and applicable policy version, then establish the expected decision. Synthetic cases guide collection. They aren't promoted into the golden dataset.

Ground truth is a domain-validated expected result or supporting evidence where correctness can be established, not an agent's recorded output. See [Use the right data for evaluation](/azure/well-architected/ai/test#use-the-right-data-for-evaluation).

Use the scenarios during a [proof of concept](/azure/well-architected/architect-role/collaboration#use-a-proof-of-concept-poc) to compare implementations against the same contract and cost and latency limits. In the product-review agent, you'd test approval decisions and handoffs against the standards team's expected outcomes. Record the design and tradeoffs in an [architecture decision record](/azure/well-architected/architect-role/architecture-decision-record), and retain the scenarios for regression testing.

Link each case to its scenario and contract version, and record whether it's synthetic or comes from real workload data. Keep scenarios independent of prompts so required behavior remains testable as the implementation changes.

Add boundary cases and reviewed production failures. If security boundaries are in scope, include prompt injection, misuse, and exfiltration scenarios from AI red teaming and threat modeling.

Keep development, regression, and protected release sets separate. Reserve some test cases for release verification, and don't use them to develop or tune the implementation. Restrict access to these cases and their expected results. If a case guides an implementation change, move it to the regression suite and replace it with another case validated by domain experts.

### Operating envelope

The *operating envelope* covers a subset of the workload's non-functional requirements. It defines resource and execution limits, such as latency, cost, token usage, retries, tool calls, and time spent waiting for approval.

The contract defines correct behavior. The envelope defines the operational limits within which the system must operate. A contract can reference an operating-envelope version when those limits are part of its acceptance criteria. Version the envelope independently so that operational limits can change without redefining behavioral requirements that didn't change. Behavior contracts and operating envelopes don't require a one-to-one relationship.

### Replay

#### Design for replay

Replay, as the name suggests, reruns the inference steps of your system by supplying collected tool and API responses or RAG results. This approach helps you tune your prompt and identify any missing evidence. It avoids repeated calls to live APIs or Model Context Protocol (MCP) tools, which can be costly, rate limited, or return data that changes over time.

Collect replay data in production. Remove or mask sensitive data according to policy before analysis or SME review. Preserve response payloads and their request arguments without changing the case's meaning. If redaction removes required evidence, use an approved fixture and document the limitation.

Have an SME review and curate production-derived data before adding it to the golden dataset or using it to create test doubles. Test doubles can simulate responses, so replay can support new and existing scenarios without requiring production data. See [Mock responses with Dev Proxy](/microsoft-cloud/dev/dev-proxy/how-to/mock-responses) and [Evaluation datasets in Microsoft Foundry](/azure/foundry/observability/how-to/evaluation-datasets).

#### Configure and run replay

Version the replay datasets you use for evaluation and regression testing. To compare an update with the baseline, run both implementations against the same dataset version, using the same cases and evaluator versions. Keep other test conditions consistent except for the change you're testing. When you add or revise cases, create a new dataset version and rerun both implementations.

During development, you can replay a smaller set of cases to check the behavior you're changing. If you don't yet have recorded responses for a new scenario, use simulated responses and label them in the dataset.

Choose the run's purpose:

| Configuration | Purpose |
| --- | --- |
| Development testing | Test new or changed behavior during implementation. |
| Evaluation | Measure behavior across the workload's supported scenarios. |
| Release verification | Check the full required regression suite against release acceptance thresholds and a baseline where applicable. |

The run configuration extends beyond dataset and evaluators. It also includes prompt, model, API/MCP servers, supporting libraries, and more. When running evaluations, you need to have a clear hypothesis and correlated changes to ensure each run only changes a minimal set. This enables you to correctly gauge the impact and avoid running the same update multiple times due to record-keeping shortfalls.

Replay doesn't replace unit or integration tests. Each test checks a different aspect of the software system, and they're equally important. See [Test and evaluate AI workloads](/azure/well-architected/ai/test).

The following diagram shows the shared replay process.

:::image type="complex" source="_images/agentic-behavior-engineering-replay-fanout.png" lightbox="_images/agentic-behavior-engineering-replay-fanout.png" alt-text="Diagram that shows development testing, evaluation, and release verification configurations sharing one replay process." border="false":::
Three boxes across the top, from left to right, show Development test run configuration, Evaluation run configuration, and Release verification configuration. Each includes an implementation version, replay settings, metrics, and evaluators. They select focused scenario cases, a usage-pattern dataset, and a regression dataset, respectively. The release box also includes a baseline and acceptance thresholds. Arrows from all three boxes point down to Shared replay and evaluation, which uses controlled inputs and captured or simulated tool responses. Another arrow leads down from that box to a box labeled Per-case results and execution traces. Its caption reads "Measure behavior by scenario; apply release criteria when qualifying a release."
:::image-end:::

#### Example: Verify a product-review agent change

Suppose release 42 of the product-review agent approves a submission that should have gone to the standards team because it contains personal information. The team prepares the case by using the replay data safeguards and uses a focused development test while revising the implementation for candidate 43.

1. Configure an evaluation run for candidate 43. The evaluation dataset needs to include normal cases as well as compliant negative reviews, uncertain submissions, and dependency failures. Update it with cases that test the feature (personal-information rule). The update creates a new version of the dataset. Run the evaluation and baseline on the new dataset. Replay the full dataset to measure decision accuracy, cost, and latency by scenario.

1. Update the release verification dataset with the new use case and get an updated version. Reference the expanded dataset version and set acceptance thresholds. Replay candidate 43 and baseline 42 against the same expanded suite and recorded evidence.

1. Check existing and new cases against reviewed expectations. Expect `approve` for compliant negative feedback and `human_review` for submissions containing personal information. Confirm that submissions awaiting human review remain unpublished.

1. Save results and per-case traces with their configuration version. Calculate metrics for each scenario. Use evaluation findings to improve the implementation and release verification results to decide whether the candidate can ship. An overall improvement doesn't override a failed mandatory requirement.

## Architecture

To use ABE methodology to design your workload's features, start with problem discovery and capture the expected behavior in a contract. Next, decide whether the workload needs agent-directed execution. Work with the business owner and engineering team to clarify user needs and assumptions. Derive scenarios from the behavior contracts, identify the knowledge and evidence the system needs, and decide which controls the surrounding system must enforce.

The behavior contract and scenario library connect the two-loop system and guide implementation and improvement. The developer inner loop verifies changes before release. The production outer loop collects execution evidence and feedback to identify failures or changed requirements.

:::image type="complex" source="_images/agentic-behavior-engineering-blueprint.png" lightbox="_images/agentic-behavior-engineering-blueprint.png" alt-text="Diagram that summarizes Agentic Behavior Engineering objectives, governed assets, and prerelease and post-release loops." border="false":::
The inner loop is shown at the top of the diagram. Six steps are shown, from left to right: behavior requirements, the scenario library, asset implementation, replay and evaluation, a behavior gate, and release. The center section groups governed assets into behavior specifications, enterprise knowledge, runtime configuration, and engineering infrastructure. A runtime behavior box is on the left, and a behavior scorecard is on the right. At the bottom, an outer loop has five steps: production, feedback and telemetry, behavior analysis, classification, and asset updates. Arrows point from the classification step to new scenarios, knowledge gaps, contract defects, and engineering defects. The asset updates step points to the replay and evaluation step in the inner loop. A dashed arrow labeled scores points from the replay and evaluate step to the scorecard. Another dashed arrow points from the behavior gate step to asset implementation.
:::image-end:::

ABE organizes this work into five engineering responsibilities: *specify*, *ground*, *control*, *verify*, and *observe*. These responsibilities are logical, not five required services or sequential runtime steps. Work on a single feature can span several responsibilities.

Responsible AI and security are cross-cutting concerns across all five system responsibilities. The *specify* responsibility makes responsible AI expectations and security requirements explicit in behavior contracts. The *control* responsibility implements the access rules and execution safeguards that support those requirements.

:::image type="complex" source="_images/agentic-behavior-engineering-reference-architecture.png" lightbox="_images/agentic-behavior-engineering-reference-architecture.png" alt-text="Diagram that shows five responsibilities, the flows that connect them, and a governed change loop." border="false":::
Five numbered boxes show the system responsibilities. A box above them labels security, privacy, and responsible AI as cross-cutting constraints. Number 1, specify, defines behavior contracts and a scenario library. Number 2, ground, governs knowledge, memory, and runtime evidence. Number 3, control, runs within system-enforced boundaries. Number 4, verify, reproduces, measures, and gates behavioral change. Number 5, observe, tracks production health. Solid arrows on the left pass behavior requirements from specify into control, and contracts and scenarios from specify into verify. Arrows pass knowledge, memory, and evidence from ground into control, and captured execution and lineage from control into verify. On the right, behavioral telemetry flows from control into observe, and a dashed governed change loop flows from observe to specify. The footer identifies "replay configurations" as implementation, data, and measures, and "execution traces" as what each execution actually did.
:::image-end:::

*Specify* and *ground* provide early checks on project readiness and feasibility. *Specify* establishes the problem and what success means. *Ground* assesses whether the required information is available and usable under the applicable access requirements. Use these findings to identify gaps before committing to implementation, then validate remaining assumptions in a proof of concept. For more information, see [Align technical strategy with business requirements](/azure/well-architected/architect-role/design-business-requirements).

Use the behavior contract and scenario library to compare feasible designs. A deterministic implementation or a fixed workflow with model-assisted steps might satisfy the requirements. Choose an agentic approach when evaluation demonstrates benefits that justify its additional cost, latency, and operational complexity. For guidance on choosing an execution approach, see [fixed workflows versus agent-directed systems](/azure/databricks/agents/agent-system-design-patterns#levels-of-complexity-from-llms-to-agent-systems).

### Specify

Use design thinking to understand the user's actual need before choosing what and how to automate. Work with users, business owners, and SMEs to agree on acceptable outcomes, constraints, and failure behavior.

Capture these requirements in a versioned behavior contract and derive test scenarios to create the scenario library. Product and engineering teams review changes to expected behavior together. To address responsible AI and security concerns, involve domain experts, risk specialists, and security specialists. Version both the behavior contract and scenario library. Release notes should identify the supported and published contract and scenario library version.

Review requirement changes alongside the product roadmap and recheck the implementation against them. For multi-agent workloads, define an end-to-end contract, and add handoff contracts where responsibilities, evidence requirements, or permissions change.

For the product-review agent, agree with the standards team on which submissions qualify for automatic approval, when human review is required, and how to handle an unavailable policy or review queue.

The following diagram shows how the behavior contract and scenario library guide implementation and verification. Use the scenario library to guide golden dataset curation and define evaluation criteria. Report results by scenario, including the number of cases tested, so an overall score doesn't hide gaps. Reviewed findings from evaluation and production can lead to updates to the scenario library or behavior contract.

:::image type="complex" source="_images/agentic-behavior-engineering-contract-lifecycle.png" lightbox="_images/agentic-behavior-engineering-contract-lifecycle.png" alt-text="Diagram of contract creation, inner-loop verification, optional runtime resolution, and production feedback." border="false":::
At the top, enterprise requirements and knowledge feed a Specify section that contains Create or update, Govern, and Publish contract steps, in that order. Below Specify, a Developer inner loop is on the left. The Publish step leads to Implement or update in that loop. Implement or update leads to Verify for replay and evaluation runs against contract outcomes and regressions. To the right of the inner loop is a Production execution section. The Verify step can return to Implementation or send a qualified release to Execute with controls in the Execution section. An arrow for reviewed contract defects returns from Verify to Create or update. In the Production execution group, Request leads to an optional Resolve step, and then to Execute with controls. A separate path from Request that's labeled No runtime selection bypasses Resolve. Below the Production execution group is a Production outer loop section. The Execute step leads to an Observe step in this loop. Observe captures evidence and user feedback, then cleanses, analyzes, and reviews findings. A dashed arrow labeled Reviewed contract changes returns from Observe to Create or update in the Specify section.
:::image-end:::

For discovery techniques, see [Conduct user research and share the insights](/power-platform/well-architected/experience-optimization/user-centered-design#conduct-user-research-and-share-the-insights).

### Ground

*Ground* governs the knowledge and evidence that you pass to your agent, including retrieved information, tool responses, business rules, and memory. It prepares relevant, authorized information for each task while preserving its source and authority. Provenance, freshness, and sensitivity are some key attributes that need to be properly represented.

To prepare governed information for the agent:

- Select authoritative sources and assign owners to maintain them.
- Identify access requirements and preserve permission and sensitivity metadata for the *control* responsibility.
- Prepare information in a form that the agent can use without losing its business meaning, source, or version.

During design, ensure the sources can supply the evidence that the behavior contract requires. For the product-review agent, link each assessment to the complete submission text, its revision, and the applicable policy version. If required evidence is missing or inaccessible, resolve the data or access issue, narrow the scope, or defer the affected capability.

At runtime, the retrieval layer reports whether a lookup returned data, found no matches, or failed. The application uses that status, together with the evidence metadata, to determine whether to proceed or follow the contract's response for insufficient evidence.

Keep business definitions and rules in workload-owned, versioned assets, independent of prompts and models. Use a data contract or semantic model to define the structure and meaning of information exchanged with other agents and systems.

The following table distinguishes business definitions from evidence for a specific request. An ontology or semantic-model platform can help organize these definitions when agents and systems need shared business concepts and relationships.

| Element | Role | Product-review example |
| --- | --- | --- |
| Ontology | Defines shared business concepts and their relationships. | A submission reviews a product. A moderation decision applies to a submission revision and a policy version. |
| Semantic data model | Maps enterprise data to those business concepts through shared definitions and relationships. | Connects submissions, policy rules, and moderation decisions through their identifiers and version references. |
| Runtime evidence | Supplies the particular records and observations needed for the current task. | The submitted text contains personal information, and the applicable policy requires human review. |

For implementation examples, see [Fabric ontology data binding (preview)](/fabric/iq/ontology/how-to-bind-data) and [Power BI semantic models](/power-bi/connect-data/semantic-models-third-party#relational-databases-vs-semantic-models).

You can establish a rules engine or workflow to apply business rules in deterministic code before passing results to the agent. Test these rules repeatably against domain-reviewed cases to verify that the implementation matches the intended policy and reduce implementation uncertainty.

When assembling context, identify the source and authority of business guidance, current evidence, and memory. Define what the agent can write to memory and how long to retain it. Memory must not override authoritative records and can't be treated the same as prompts or instructions.

The following diagram shows how to prepare and combine knowledge, evidence, and memory for the agent.

:::image type="complex" source="_images/agentic-behavior-engineering-ground-stages.png" lightbox="_images/agentic-behavior-engineering-ground-stages.png" alt-text="Diagram that shows governed knowledge, runtime evidence, and memory passing through semantic interpretation, evidence qualification, and context assembly." border="false":::
The diagram shows three sources that feed three numbered stages. Across the top, three boxes label the sources: governed knowledge frames how to interpret the case, runtime evidence observes the current case, and memory suggests where to look. Their outputs converge into a downward arrow that points to stage one. Stage one, semantic interpretation, maps incoming information to known domain concepts. An ontology can define the concepts, while a semantic model can represent data in their terms. An arrow points from stage one to stage two. Stage two, evidence qualification, checks provenance, freshness, and authority, and classifies runtime observations as positive, negative, or missing. An arrow points from stage two to stage three, context assembly. Stage three preserves each source's identity and authority. This stage points to a box titled governed reasoning context that states that sources remain distinguishable and authority isn't flattened by the context window.
:::image-end:::

### Control

*Control* protects the workload through authentication, authorization, and runtime governance. It establishes who can access the system, what each caller and agent can do, and which actions require approval. Enforce these decisions in the application code and connected services, not in the model.

Follow security best practices and conduct threat modeling to decide which runtime safeguards to implement. A [data flow diagram (DFD)](/azure/well-architected/architect-role/design-diagrams#data-flow-diagram-dfd) shows how information moves between callers, agents, tools, and data stores, including where it crosses trust boundaries. Use that analysis to determine where to enforce access checks, restrict data sharing, and require approvals.

These trust boundaries are part of your defense against attacks. For example, retrieved content or tool responses can contain malicious instructions. Access checks and approval gates must still apply if the model follows those instructions. Follow defense-in-depth and Zero Trust principles. Combine these controls with other [defenses against prompt injection](/security/zero-trust/sfi/defend-indirect-prompt-injection), rather than treating any one safeguard as sufficient.

Authenticate caller and agent identities, and then authorize each data access and tool action for its task and target resource. Apply least privilege and enforce the access requirements identified in the *ground* responsibility. When delegating work, preserve the caller's authorization context and evidence references, and recheck permissions at each handoff. Delegation must not expand authority. If access is denied, follow the defined stop or escalation path instead of bypassing the denial through another tool or agent.

Runtime governance also enforces required approvals, mandatory workflow steps, and operating-envelope limits, such as budgets and rate limits. Retry only operations that are safe to repeat. When a limit is reached, follow the contract's stop or fallback behavior. These controls complement the workload's broader resilience design.

In the product-review agent example, access is limited to the assigned submission, applicable policy, and moderation actions. The publication workflow checks permissions, the submission revision, and the policy version before publishing an approved review. Keep policy changes and customer-account actions outside the agent's permissions.

The following diagram shows how proposed actions are evaluated and recorded.

:::image type="complex" source="_images/agentic-behavior-engineering-authority-boundary.png" lightbox="_images/agentic-behavior-engineering-authority-boundary.png" alt-text="Diagram that shows a proposed action passing through a control point that authorizes it, suspends it for approval, or denies it." border="false":::
On the left, a box labeled model proposes an action. An arrow points to a control point that evaluates the proposal. An arrow flows from the control point and branches into three outcomes: "Authorized" reaches the executor, "needs approval" suspends the run, and "denied" results in no execution. At the bottom of the diagram, a box labeled execution trace states that authorized, denied, and approval-gated actions are recorded, not only executions.
:::image-end:::

For a retrieval example, see [Design a secure multitenant RAG inferencing solution](secure-multitenant-rag.md). For identity and layered protection guidance, see [Identity, access, and least privilege](/security/zero-trust/catalog-ai-defense-capabilities/identity-access-least-privilege) and [Security design principles](/azure/well-architected/security/principles).

For examples of execution controls implemented through workflow orchestration, see [Workflow-oriented multi-agent patterns](/agents/architecture/multi-agent-workflow-oriented).

### Verify

*Verify* combines single-case checks with dataset-level evaluation in the developer inner loop.

#### Check a single case

During implementation, run or replay a test case by using [recorded or simulated responses](#design-for-replay). Inspect the execution trace to compare the evidence, tool calls, control decisions, and outcome with the behavior contract and scenario. Use the findings to debug and refine the implementation.

#### Evaluations

Run evaluations across a versioned dataset to measure behavior across supported scenarios. Define metrics and acceptance thresholds from the behavior contract. The following table describes scenarios and associated measures for the product-review agent.

| Scenario | Measure |
| --- | --- |
| A negative review meets the policy's low-risk criteria. | How often the agent correctly approves it. |
| A submission contains personal information that requires human review. | How often the agent incorrectly approves it, and whether required handoffs complete without publication. |
| The policy service is unavailable. | Whether the submission remains unpublished and reaches human review or stays pending if the handoff fails. |

Compare the candidate and baseline by using the same dataset and evaluator versions. For more information, see [Configure and run replay](#configure-and-run-replay).

Report results by scenario so aggregate scores don't hide regressions. Repeat test cases to check consistency. Define the number of runs and acceptance criteria before evaluation. Record the behavior contract, dataset, evaluator, and threshold versions with the results.

Test long-running cases and failure behavior at operating limits. Define step and tool-call counts, but require an exact path only when the contract specifies one. For multi-agent workloads, test handoffs as well as end-to-end outcomes.

Run these checks alongside unit and integration tests. Block releases that fail required scenario thresholds. For release guidance, see [Adoption path checklist](#adoption-path-checklist).

### Observe

*Observe* analyzes production runs to identify successful behavior, failures, and their causes. The system should collect user feedback to facilitate the analysis. Start the analysis with scenario classification:

1. Classify recorded runs by using the task and execution context. Match each run to the applicable scenario and contract versions. Flag unfamiliar or ambiguous cases for review.

1. Compare the outcome with the scenario's expected behavior and combine that information with user feedback to assess success or failure. Leave cases unassessed when the evidence is insufficient.

1. Investigate failures by using traces and reviewer feedback. Group findings by cause, such as knowledge gaps, implementation or dependency failures, or unclear requirements.

1. Have product owners, domain experts, and engineers review findings and decide what to change. Validate expected outcomes before adding prepared cases to regression coverage. Record the reason for each change and verify it before release.

In the product-review agent example, routing a submission that contains personal information to human review while keeping it unpublished is successful behavior. Approving it is an example of a failure. A request to support image reviews instead identifies a potential scope change.

Capture the task input, tool requests and responses, retrieved content supplied to the model, and output. Preserve source versions, control decisions, and failures. Link user and reviewer feedback to the run and release. Minimize captured data, enforce access and retention limits, and follow the [replay data preparation guidance](#design-for-replay) before analysis or dataset curation.

For an example of connecting production findings to evaluation, see the [agent observability quality loop](/azure/databricks/mlflow3/genai/concepts/core-concepts#how-it-all-fits-together).

## Adoption path checklist

Start with a minimum viable implementation around one consequential behavior in your workload.

The smallest useful ABE implementation isn't a platform. It's one behavior that's explicit, replayable, evaluated, and gated. The first working loop is in *specify* and *verify*. Avoid building a broad platform before the team can use one contract to prevent, detect, or diagnose a real behavioral problem.

1. Select a bounded, consequential situation and identify its product and engineering owners, and involve domain experts.
1. Write one reviewed behavior contract, including evidence and failure states.
1. Define scenarios for normal, boundary, insufficient-evidence, and dependency-failure cases. Generate synthetic cases from these scenarios to start testing.
1. Use the synthetic cases to guide SMEs in collecting and curating actual workload cases for a separate golden dataset.
1. Capture or simulate stable tool and knowledge responses for replay.
1. Add deterministic checks and only the judgment-based evaluators needed by the contract.
1. Run the scenarios in continuous integration and block releases on critical failures.
1. Record enough information from production runs to identify the contract, implementation, evidence path, and outcome.
1. Turn reviewed production findings into regression scenarios.

Changes to prompts, model settings, and application code can change agent behavior. Validate these changes before using them in production. Record the versions you tested, the evaluation setup, and the results. Follow [safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) to introduce changes gradually and plan how to recover if they cause problems. Include configuration changes in the recovery plan.

Build on this first loop as you learn what your workload needs. When agents and systems need shared business definitions and relationships, a [semantic data model](/power-bi/connect-data/semantic-models-third-party#relational-databases-vs-semantic-models) can provide that foundation. When decisions follow explicit business rules, a [rules engine](/azure/logic-apps/rules-engine/rules-engine-overview) can apply those rules outside the model. Keep the access controls and execution evidence your workload requires in place from the start, and then expand monitoring and automation as risks and production findings justify it.

## Implement ABE on Azure

ABE is platform-agnostic. Azure provides services you can use to support its five engineering responsibilities.

The following diagram maps each ABE responsibility to Azure services to consider for your workload.

:::image type="complex" source="_images/agentic-behavior-engineering-azure-services.png" lightbox="_images/agentic-behavior-engineering-azure-services.png" alt-text="Diagram that maps five ABE responsibilities to example Azure services." border="false":::
Five boxes map ABE responsibilities to service options. The specify box lists Azure Repos and Azure App Configuration. The ground box lists Azure AI Search, Microsoft Fabric semantic models and ontology (preview), and Azure Cosmos DB. The control box lists Microsoft Entra ID, API Management, App Service, AKS, Container Apps, Azure AI Content Safety, and Foundry Agent Service. The verify box lists Azure Pipelines, Azure Machine Learning for custom models, Azure Storage, Foundry evaluation, and Foundry datasets. The observe box lists Azure Monitor, Application Insights, and Log Analytics.
:::image-end:::

For each engineering responsibility, combine Azure capabilities with the contracts, controls, and review processes your team maintains.

| Responsibility | Azure capabilities | Your team's work |
| --- | --- | --- |
| Specify | Source control and review workflows. | Creating and maintaining behavior contracts, scenarios, and operating envelopes. |
| Ground | Data access, retrieval, and semantic modeling. | Source ownership, access requirements, and evidence qualification. |
| Control | Hosting, identity, gateways, and control integration points. | Authorization, approval, and execution rules. |
| Verify | Dataset storage, evaluation services, and CI/CD execution. | Replay implementation, expected outcomes, and release criteria. |
| Observe | Telemetry collection, queries, and alerts. | Capture coverage, cleansing, feedback correlation, and analysis. |

Before you choose any Azure service, check that its features, regions, and APIs fit your workload. Prefer generally available (GA) services and application-owned controls for mandatory enforcement and release checks. Some of the features mentioned in the following sections are preview features and might not be suitable for your workload.

### *Specify* on Azure

Keep contracts, scenarios, operating envelopes, and replay configurations in your existing Git repository, for example, Azure Repos or GitHub. Follow the [shared review responsibilities](#behavior-contract) when a change affects expected behavior. Use engineering review for technical maintenance.

### *Ground* on Azure

Connect the agent to the authoritative sources you identified for the *ground* responsibility. For the product-review agent, you start with the website's existing application APIs to retrieve submissions and the currently approved policy.

When you need retrieval across knowledge sources, consider [Azure AI Search agentic retrieval](/azure/search/agentic-retrieval-overview). It can return grounding content with optional source references and an activity log. Measure the cost and latency of the retrieval approach you select.

If your business data is already in Microsoft Fabric, the [Fabric IQ tool](/azure/foundry/agents/how-to/tools/fabric-iq) can connect Microsoft Foundry agents to semantic models and ontology items. The integration and [ontology capability](/fabric/iq/ontology/overview) are in preview. Check how the connection authenticates, which data it can access, and whether data might leave the Azure compliance boundary.

Version semantic definitions separately from the agent implementation and record their versions with the test evidence. [Fabric Git integration](/fabric/cicd/git-integration/intro-to-git-integration) supports ontology items in preview.

### *Control* and run on Azure

You can run prompt agents and custom hosted agents on [Foundry Agent Service](/azure/foundry/agents/overview). For other runtime or deployment requirements, consider AKS, Azure Container Apps, or Azure App Service. See [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md) to compare options. Implement your authorization, approval, and execution rules in the application and connected services.

For Foundry agents, use [Microsoft Entra agent identities](/azure/foundry/agents/concepts/agent-identity) for supported MCP and agent-to-agent connections. When the agent acts for a user, check both the user's authority and the agent's authority. Before release, verify the identity and permissions that the agent will use at runtime.

[Azure API Management](/azure/api-management/mcp-server-overview) can govern shared MCP endpoints through authentication policies, rate limits, and quotas. Use [Agent Framework middleware](/agent-framework/concepts/agents/middleware/) to add application-owned checks for function tools that the framework runs. For tools that run outside that boundary, enforce mandatory authorization and policy at a gateway or downstream service.

When an action needs human confirmation, use [function-tool approval](/agent-framework/agents/tools/tool-approval). If workflow approvals must survive a restart, configure persistent [checkpoint storage](/agent-framework/workflows/checkpoints) and restore the pending approval state before allowing execution. For tools that change state, validate inputs and add idempotency safeguards at the action executor. Version orchestration and control settings with the implementation.

[Prompt Shields](/azure/ai-services/content-safety/concepts/jailbreak-detection) in Azure AI Content Safety can detect prompt-injection attempts in user prompts and grounding documents. Combine these checks with authorization. Define how the workload responds to blocked content in the behavior contract, and test that response.

For the product-review agent, read access is granted to assigned submissions and the current policy. Write access is restricted to the moderation operations that approve a submission or route it for human review. Submission and policy version checks are enforced in the publication workflow.

### *Verify* on Azure

You can store prepared replay cases and test results in Azure Blob Storage. Reference specific dataset versions in your replay configurations, and link production-derived cases to their source executions. Restrict access to protected holdout cases and retained production evidence. Follow the [Blob Storage architecture guidance](/azure/well-architected/service-guides/azure-blob-storage) for identity-based access, data protection, and retention.

By using [Foundry evaluation datasets](/azure/foundry/observability/how-to/evaluation-datasets), you can score completed responses or send inputs to an agent to generate and evaluate new responses. For controlled replay, configure the dependency adapters before invoking the agent. Publish datasets as execution copies of your governed scenario library, and apply the same holdout access restrictions.

Use deterministic checks for criteria with explicit reference values or rules, and use model-based evaluators for judgment-based criteria. Foundry [custom evaluators](/azure/foundry/concepts/evaluation-evaluators/custom-evaluators) support both approaches, as well as external scoring endpoints.

For the product-review agent, a code-based check can compare the structured decision with the standards team's expected decision. A model-based evaluator can assess whether the explanation and cited policy rule support that decision, given the submitted text. [Rubric evaluators](/azure/foundry/concepts/evaluation-evaluators/rubric-evaluators) and custom evaluators are in preview.

Check [evaluator tool compatibility](/azure/foundry/concepts/evaluation-evaluators/agent-evaluators#supported-tools) before using scores in a gate. For conversations containing Azure AI Search or Fabric data agent calls, don't use `tool_call_accuracy`, `tool_input_accuracy`, `tool_output_utilization`, `tool_call_success`, or `groundedness` results. Use deterministic contract assertions or another supported evaluation method.

Save per-case results and traces with the configuration that produced them. Apply release thresholds in the pipeline and block the release if a required scenario fails. Use the same cases and evaluator versions when comparing implementations. If you train custom models in [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning), include their versions in the configuration.

### *Observe* on Azure

[Foundry tracing](/azure/foundry/observability/how-to/trace-agent-setup) uses the Azure Monitor Application Insights resource that's connected to the project. Instrument your application's tool and retrieval code to capture any additional evidence you need.

Decide which content you need to record. [Foundry client-side tracing integration](/azure/foundry/observability/how-to/trace-agent-client-side) includes settings for recording message content. Check that your instrumentation captures the required tool responses and retrieved content alongside operation names and timings. Minimize or redact sensitive payloads before telemetry export, and retain only evidence allowed by your data policy.

Consider using [trace evaluation (preview)](/azure/foundry/observability/how-to/cloud-evaluation-deployed-interactions) to assess retained Application Insights traces that meet the cleansing requirements. It scores existing interactions without rerunning requests, including supported OpenTelemetry traces from agents outside Foundry. Use these scores to investigate production behavior, and then verify any resulting implementation changes through replay and evaluation before release. This feature is in public preview, has no service-level agreement, and isn't recommended for production workloads. Don't rely on it for production monitoring or release decisions.

Use Log Analytics queries and Azure Monitor alerts to investigate behavioral failures and operating-envelope breaches. The [Application Insights Agent details view](/azure/azure-monitor/app/agents-view), currently in preview, can help you investigate individual runs. Feed reviewed findings and prepared cases into the next change-and-replay cycle.

> [!IMPORTANT]
> Your team defines and versions the behavior contract, implements its controls, and sets the criteria for passing the behavior gate. Use release verification results to decide whether the workload is ready to deploy.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Yang Song](https://www.linkedin.com/in/yang-song-4334475/) | Principal Software Engineer

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer
- [Bryan Ostdiek](https://www.linkedin.com/in/bostdiek/) | Principal Data Scientist
- [Peter Parker](https://www.linkedin.com/in/ptparker/) | Principal Solution Engineer, Azure AI Cloud Strategist and Architect
- [Rama Pyarasani](https://www.linkedin.com/in/rama-pyarasani/) | Multidisciplinary Forward Deployed Engineer Manager
- [Ronnie Yates](https://www.linkedin.com/in/ronnieyates/) | General Manager, Forward Deployed Engineering

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Agents in Microsoft Foundry](/azure/foundry/agents/overview)
- [Evaluate your AI agents](/azure/foundry/observability/how-to/evaluate-agent)
- [Agentic retrieval in Azure AI Search](/azure/search/agentic-retrieval-overview)
- [Monitor AI agents with Application Insights](/azure/azure-monitor/app/agents-view)
- [Agent Behavioral Contracts (research paper)](https://arxiv.org/abs/2602.22302)

## Related resources

- [AI agent design patterns](ai-agent-design-patterns.md)
- [Agentic retrieval-augmented generation](rag/rag-agentic.md)
- [Machine learning operations](machine-learning-operations-v2.md)