---
title: Agentic Behavior Engineering
description: A platform-agnostic methodology for specifying, grounding, controlling, verifying, and observing the behavior of enterprise AI agents
author: juliays
ms.author: songy
ms.date: 09/07/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Agentic behavior engineering

Agentic Behavior Engineering (ABE) is a platform-agnostic methodology for specifying, grounding, controlling, verifying, and observing the behavior of AI agents.

The basic idea is that required behavior should remain explicit and verifiable even when the implementation changes. Teams change models, prompts, tools, knowledge sources, memory, policies, and orchestration over time. ABE captures the required behavior separately, in a versioned behavior contract that can be tested and used to evaluate the impact of those changes.

ABE isn't a product or an agent framework. It complements application architecture, software testing, security controls, responsible AI practices, and operational monitoring. Use it when an agent must reach conclusions that are supported by evidence, operate within explicit authority, fail predictably, and remain verifiable after deployment.

Enterprise knowledge is the proprietary domain knowledge that differentiates your organization: its business rules, semantics, and operational expertise. Protect that knowledge by keeping it in governed structures that you own and version rather than dissolving it into prompts or model weights. A rule that lives only in a prompt is harder to govern independently, reuse across agents, and trace when it turns out to be wrong.

The blueprint that follows arranges ABE as two loops around a shared set of governed assets. The inner loop verifies behavior before release. The outer loop uses production evidence to detect drift and improve the next release.

:::image type="complex" source="_images/agentic-behavior-engineering-blueprint.png" lightbox="_images/agentic-behavior-engineering-blueprint.png" alt-text="Diagram that summarizes Agentic Behavior Engineering objectives, governed assets, and pre-release and post-release loops." border="false":::
The diagram places three objectives at the top: protect enterprise knowledge, engineer reliable behavior, and learn from production. An inner loop runs left to right from behavior requirements through scenarios, asset implementation, replay and evaluation, a behavior gate, and release.

The center groups governed assets into behavior specifications, enterprise knowledge, runtime configuration, and engineering infrastructure, with runtime behavior on the left and a behavior scorecard on the right. Below, an outer loop connects production, feedback and telemetry, behavior analysis, classification, and asset updates. Classification branches to new scenarios, knowledge gaps, contract defects, and engineering defects. Updated assets return to replay and evaluation. Dashed paths carry scores to the scorecard and feedback to asset implementation.
:::image-end:::

## Why use ABE

Use ABE when the reliability of an agent depends on more than the quality of its final response. An agent's behavior also depends on the evidence that it retrieves, the tools that it selects, the authority under which it acts, the state that it retains, and its response to failures. Testing a model or prompt in isolation doesn't verify this end-to-end behavior. For this reason, the [Azure Well-Architected Framework guidance for testing AI workloads](/azure/well-architected/ai/test) recommends scenario-based testing of the complete agentic flow.

Exact-output assertions alone don't fully describe reliable behavior in agentic systems, which include probabilistic models and changing external dependencies. An answer can be fluent but unsupported, a tool call can succeed but exceed the user's authority, and an aggregate evaluation score can improve while a critical scenario regresses.

Behavior also drifts as the system changes. A model gets upgraded. A knowledge source is updated. A tool starts behaving differently. A new policy takes effect. Any of these can change what the agent does without anyone deciding that it should, so a validation that passed last month doesn't establish that the agent still behaves correctly today.

ABE helps teams:

- Preserve the same acceptance criteria when models, prompts, tools, knowledge sources, or orchestration change.
- Keep proprietary business rules, semantics, and operational expertise in assets the organization owns, so that knowledge stays reviewable and reusable across agents and releases.
- Make release decisions from contract and scenario results instead of relying only on aggregate evaluation scores.
- Identify whether a regression came from evidence, policy, permissions, tools, memory, orchestration, or the model.
- Prevent a model from approving its own high-consequence actions by placing deterministic authorization, policy, approval, and execution controls around it.
- Turn reviewed production findings into regression scenarios that protect later releases.
- Give domain, risk, security, engineering, and operations owners a shared set of artifacts for reviewing requirements, evidence, and release readiness.

## Core engineering artifacts

ABE connects behavioral requirements to implementation, verification, and production through a small set of versioned artifacts. Each one needs an owner who can approve changes to it.

### Behavior contract

A behavior contract defines what an agent must and must not do in one bounded situation. It specifies:

- The situation, actors, and scope in which the contract applies.
- Acceptable outcomes and required result characteristics.
- Prohibited conclusions, disclosures, actions, and side effects.
- Evidence required before the agent can conclude or act.
- Behavior when evidence is insufficient or dependencies fail.
- Escalation, approval, and stop conditions.

A contract defines behavior without prescribing a model, prompt, tool, or orchestration framework, allowing the implementation to change while the requirements remain stable.

The concept borrows from design by contract. Model judgments are probabilistic, but the surrounding system can enforce hard boundaries through deterministic controls. A behavior contract defines which outcomes are acceptable, what evidence they require, and which controls must enforce those boundaries.

Related research applies similar ideas at runtime. [Agent Behavioral Contracts](https://arxiv.org/abs/2602.22302), for example, defines preconditions, invariants, governance policies, and recovery mechanisms that can be checked during agent execution. ABE addresses the broader behavior lifecycle: specifying and governing expected behavior, controlling evidence and authority at runtime, verifying changes before release, and using production findings to improve governed assets and implementation. Formal runtime contracts can enforce parts of an ABE behavior contract within the Control responsibility.

Use one contract for one bounded situation and multiple scenarios for its variations. Create another contract when the actors, authority, required evidence, or acceptable outcomes change materially.

The following example shows one behavior contract for a sign-in diagnosis situation: a user who can't sign in at all.

| Contract element               | Example                                                                                                                                                                                                                                           |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Situation                      | A user reports that they can't sign in at all.                                                                                                                                                                                                    |
| Acceptable outcomes            | An expired credential, a locked account, an unenrolled multifactor authentication (MFA) method, an identity provider outage, or insufficient evidence to determine the cause.                                                                     |
| Prohibited behavior            | Naming a cause that the evidence doesn't support, defaulting to the most common cause when evidence is missing, returning "try resetting your password" as a diagnosis, or treating a tool that didn't respond as evidence that nothing is wrong. |
| Required evidence              | Zero successful sign-in events in the past 24 hours, and a signal that supports the chosen cause, such as a lockout flag, an expiry timestamp in the past, no registered MFA method, or degraded provider health.                                 |
| Insufficient-evidence behavior | Report that the evidence doesn't support a cause instead of naming one.                                                                                                                                                                           |
| Excluded situations            | A user who can sign in but is denied access to one application, and intermittent sign-in failure.                                                                                                                                                 |

### Scenario library

The scenario library is the governed set of examples used to verify a contract. Each scenario supplies concrete inputs, dependency conditions, expected behavioral properties, prohibited outcomes, and any reference evidence. Include normal cases, boundary conditions, insufficient-evidence cases, authorization failures, dependency failures, and cases captured from production incidents. When security boundaries are in scope, also include direct and indirect prompt injection, misuse, and exfiltration attempts. Include findings from AI red teaming alongside threat-model-derived adversarial scenarios, so the library covers both attacks observed in practice and plausible attacks the team needs to anticipate.

Scenarios are more durable than prompts. A prompt is one implementation input, whereas a scenario records the behavior that an implementation must satisfy. Domain owners should review the expected outcomes and evidence because synthetic test data alone can't establish business correctness.

The scenario library is the governed source from which evaluation datasets are derived. Ground truth is the domain-validated reference outcome or evidence for scenarios where a correct answer can be established. Regression cases are scenarios created from reviewed production findings. Governing both through the scenario library means one governed set defines the behavior a release must satisfy.

Partition the scenario library by purpose. Use development scenarios for iteration, regression scenarios for known findings, and a protected holdout set for release decisions. Restrict access to holdout inputs and expected outcomes where feasible. When a holdout scenario drives a change, move it into regression coverage and replace it with another domain-validated case.

### Operating envelope

The operating envelope defines resource and execution limits, such as latency, cost, token usage, retries, tool calls, and time spent waiting for approval. The contract defines what counts as correct behavior, and the envelope defines the resources the system may use to produce it. A contract can reference an operating-envelope version when those limits are part of its acceptance criteria. Version the envelope independently so that operational limits can change without redefining behavioral requirements that haven't changed.

### Release and run manifests

A release manifest records the runtime configuration a team intends to activate and the verification artifacts used to qualify the release. It acts as a bill of materials for an agent release, identifying versions of contracts, scenarios, models, instructions, tools, knowledge sources, policies, orchestration, evaluators, and operating envelopes.

A run manifest records what one execution actually resolved and used. Replay, diagnosis, and audit depend on that record. It links the applicable contract to the agent version, identity, permissions, evidence, tool interactions, policy decisions, fallback states, outcome, and action receipts. Store references, hashes, and redacted values when full content would create a privacy or security risk.

The release manifest describes the declared release configuration and verification context. The run manifest records what actually ran. Reliable replay requires both, because each one alone is incomplete. The release manifest reconstructs the declared environment but not what resolved during a specific run. The run manifest captures what happened but not the declared environment needed to reproduce it.

One release governs many runs, and conditions change underneath it. Any of the following can differ between two runs of the same release:

- A model alias resolves to a newer snapshot.
- A knowledge source is updated after the release ships.
- A feature flag changes.
- A tool fails and a fallback path runs.

Protect manifests as audit records. Store them durably, restrict write and delete permissions, validate their integrity, and retain them long enough to support replay, incident investigation, and audit. Use append-only or immutable storage when policy or regulation requires tamper evidence.

:::image type="complex" source="_images/agentic-behavior-engineering-replay-fanout.png" lightbox="_images/agentic-behavior-engineering-replay-fanout.png" alt-text="Diagram that shows one release fanning out to three runs, and both manifest types feeding replay." border="false":::
The diagram, titled Replay, one release many runs, has two parts. In the upper part, under the heading one release many runs, a box labeled Release 42 and marked declared configuration sits on the left. A connector fans out from it to three stacked boxes on the right that are labeled Run X123, Run X124, and Run X125, captioned resolved executions. In the lower part, under the heading replay needs both, two side-by-side boxes name the release manifest, described as what configuration was declared, and the run manifest, described as what this execution actually used. An arrow points down from each box to a dark box labeled Replay, which states that replay rebuilds the same conditions but not necessarily the same output.
:::image-end:::

## Relationship to Responsible AI

Responsible AI determines which obligations apply to a system. ABE makes the testable and enforceable parts of those obligations explicit and verifiable. Responsible AI practices identify the concerns and affected stakeholders, determine what fairness, transparency, privacy, safety, and accountability require in a specific context, and assign the people accountable for those judgments. The [Well-Architected Framework guidance for responsible AI](/azure/well-architected/ai/responsible-ai) recommends auditability of agent activity, role-based access control, and circuit breaker functionality for agentic systems.

ABE can turn applicable requirements into behavior that teams can test, enforce, and observe in specific situations. For example, contracts can prohibit harmful or unfair outcomes, scenarios can test behavior across affected groups and edge cases, deterministic controls can enforce privacy and security boundaries, and run manifests can provide transparency and accountability for evidence, decisions, and actions. The Well-Architected recommendations for auditability, role-based access control, and circuit breakers map to run manifests, authority boundaries, and explicit stop conditions.

ABE also extends beyond Responsible AI concerns to cover business correctness, evidence sufficiency, authority boundaries, failure handling, latency, and cost. It doesn't replace impact assessment, safety evaluation, security engineering, privacy review, accountable human oversight, or organization-wide agent inventory and lifecycle governance. Use [Cloud Adoption Framework guidance for governing and securing AI agents](/azure/cloud-adoption-framework/ai-agents/governance-security-across-organization) to establish baseline ownership, identity, access, and policy requirements across agents.

## Architecture

An ABE architecture organizes the agentic system around five engineering responsibilities: specify, ground, control, verify, and observe. These responsibilities are logical boundaries. A component can implement more than one responsibility, or several services can collaborate on one responsibility.

Security, privacy, and responsible AI requirements span all five responsibilities. Enforce critical controls outside model instructions so that a model can't reinterpret or bypass them.

:::image type="complex" source="_images/agentic-behavior-engineering-reference-architecture.png" lightbox="_images/agentic-behavior-engineering-reference-architecture.png" alt-text="Diagram that shows the specify, ground, control, verify, and observe bands with the flows that connect them and a governed change loop." border="false":::
The diagram, titled The ABE Reference Architecture, shows five system responsibilities as stacked numbered bands. A top band labels security, privacy, and responsible AI as cross-cutting constraints on every band. Band one, Specify, holds behavior contracts and a scenario library. Band two, Ground, governs knowledge, memory, and runtime evidence. Band three, Control, executes within system-enforced boundaries. Band four, Verify, reproduces, measures, and gates behavioral change. Band five, Observe, tracks production health.

Solid arrows on the left carry behavior requirements from Specify into Control, and contracts and scenarios from Specify into Verify. Vertical arrows pass knowledge, memory, and evidence from Ground into Control, and captured execution and lineage from Control into Verify. On the right, behavioral telemetry flows from Control into Observe, and a dashed governed change loop returns from Observe to Specify. A footer names the release manifest and the run manifest.
:::image-end:::

### Specify

Specify owns the artifacts that define expected behavior: contracts, scenario libraries, operating envelopes, and evaluation criteria. Domain, risk, security, and engineering stakeholders review the artifacts that apply to their concerns. The system resolves the applicable contract as soon as it has enough context to identify the bounded situation, and before consequential conclusions or actions proceed. Later decisions and telemetry then reference the resolved contract version.

Each approved contract version is governed and published, then serves two independent consumers: Control resolves it at runtime, and Verify evaluates behavior against it before a release ships.

Govern behavior contracts like code and serve them like configuration. A contract needs review, version history, and an accountable owner who approves changes. The runtime can load a selected version without redeploying application code.

Publishing an approved version doesn't activate it. Treat activation of a new contract or runtime configuration version as a release, even when application code doesn't change. Identify the configuration selected for activation in that release's manifest. Verify the resulting behavior and pass the behavior gate before activation. Apply [safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) during controlled rollout.

Define contract precedence and a default outcome before runtime. If no contract matches, multiple contracts match without a precedence rule, or the system lacks enough context to select one safely, don't proceed with a consequential conclusion or action. Ask for more information, abstain, or escalate, and record the selection result in the run manifest.

:::image type="complex" source="_images/agentic-behavior-engineering-contract-lifecycle.png" lightbox="_images/agentic-behavior-engineering-contract-lifecycle.png" alt-text="Diagram that shows the behavior contract lifecycle across the specify, control, and verify responsibilities." border="false":::
At the top, a band lists enterprise policies, workflows, business rules, known failures, and subject matter expertise. An arrow leads down into Specify, a dashed region with three stacked stages: Create makes expectations explicit; Govern reviews, approves, versions, and assigns ownership; Publish makes the contract available to runtime and evaluation.

From Publish, arrows branch to two side-by-side dashed regions. On the left, Control contains Resolve, reached by an arrow labeled at runtime. On the right, Verify evaluates behavior against the contract, reached by an arrow labeled before release. A dashed arrow labeled contract defect returns from Verify to Create along the right edge. A bottom banner says to govern behavior contracts like code and serve them like configuration.
:::image-end:::

### Ground

Ground provides the context an agent reasons over. It distinguishes governed enterprise knowledge, current runtime evidence, and conversational or long-term memory. Preserve source, freshness, authority, and access-control metadata instead of combining all context into an unqualified prompt.

An ontology can define the domain concepts, and a semantic model can express enterprise data in those terms. When you govern and version these artifacts independently of the agent implementation, a prompt or model change doesn't take the organization's domain expertise with it.

Treat retrieved content and tool output as untrusted input. Retrieval improves access to relevant evidence, but it doesn't prove that the evidence is current, authorized, complete, or sufficient for a conclusion.

Qualify runtime observations before they support a conclusion. A tool that reports no results and a tool that fails to respond are different findings, and treating them alike is a common source of unsupported conclusions.

| Classification | Condition                                | Evidential value                                                                          |
|----------------|------------------------------------------|-------------------------------------------------------------------------------------------|
| Positive       | The tool returned a signal.              | Can support a conclusion after provenance, freshness, authority, and scope are qualified. |
| Negative       | The tool explicitly returned no results. | A confirmed absence can support a conclusion after the same qualification.                |
| Missing        | The tool didn't answer.                  | Supports nothing. Treat the question as unanswered.                                       |

The following diagram shows how knowledge, evidence, and memory become a governed reasoning context.

:::image type="complex" source="_images/agentic-behavior-engineering-ground-stages.png" lightbox="_images/agentic-behavior-engineering-ground-stages.png" alt-text="Diagram that shows governed knowledge, runtime evidence, and memory passing through semantic interpretation, evidence qualification, and context assembly." border="false":::
The diagram, titled Ground, from enterprise information to reasoning context, shows three sources that feed three numbered stages. Across the top, three boxes label the sources: governed knowledge frames how to interpret the case, runtime evidence observes this case now, and memory suggests where to look. Their outputs converge into a downward arrow. Stage one, semantic interpretation, maps incoming information to known domain concepts, and notes that an ontology can define the concepts while a semantic model can represent data in their terms. Stage two, evidence qualification, checks provenance, freshness, and authority, and classifies runtime observations as positive, negative, or missing. Stage three, context assembly, preserves each source's identity and authority. A dark bar below reads governed reasoning context and states that sources remain distinguishable and authority isn't flattened by the context window. A closing line reads that the model reasons over this context.
:::image-end:::

### Control

Control decides what the agent is allowed to do. Evidence sufficiency and action authority are separate gates. Evidence establishes what the agent can support, and identity, policy, and approval determine what it can do. The model can propose a conclusion or action, but deterministic components validate evidence, authorization, policy, and approval before an executor performs a side effect. Executors should use idempotency controls and return receipts so retries don't duplicate actions.

For a multi-agent system, define an end-to-end contract at the system boundary. Add narrower agent or handoff contracts when responsibility, evidence requirements, or permitted actions change. Preserve the applicable contract, caller context, evidence lineage, and authority through each handoff. Delegation can narrow authority, but it must not expand it.

Represent failure and waiting states explicitly. Examples include retrying within a budget, returning a partial result, abstaining, escalating to a human, waiting for approval, and stopping. Don't let an unconstrained model decide whether a mandatory control applies.

Two boundaries separate where a model can exercise judgment from what the agent can actually do.

The judgment boundary divides the decisions that deterministic software makes from the ones the model makes:

| Software decides                 | Model judges             |
|----------------------------------|--------------------------|
| Policy and rules that can't bend | Ambiguity                |
| Validation                       | Synthesis                |
| Required steps                   | Comparing hypotheses     |
| State transitions                | What to investigate next |

The authority boundary governs what the agent may do once the model proposes an action. Every proposal passes through a control point that resolves the applicable contract, caller identity, policy, agent scope, and approval requirements, and then authorizes, suspends for approval, or denies it.

Treat authorization denial differently from a transient tool failure. Define whether the system stops, escalates, or permits an alternative action. Enforce that decision outside the model, including when the agent proposes the same prohibited action through another tool or delegated agent. Record the denial and subsequent disposition in the run manifest.

:::image type="complex" source="_images/agentic-behavior-engineering-authority-boundary.png" lightbox="_images/agentic-behavior-engineering-authority-boundary.png" alt-text="Diagram that shows a proposed action passing through a control point that authorizes, suspends for approval, or denies it." border="false":::
The diagram, titled Control, the authority boundary, shows how a proposed action is evaluated before it can execute. A band across the top lists what the boundary resolves: the resolved contract, caller identity, policy, agent scope, and approval requirements. Below the band, a box labeled model, which proposes an action, points right to a highlighted control point that evaluates the proposal. The control point branches to three outcomes on the right: authorized, which reaches the executor; needs approval, which suspends the run; and denied, which results in no execution. A dark bar below reads run manifest and states that it records authorized, denied, and approval-gated actions, not only executions. A closing line states that the model can propose what to do while the system decides where model judgment is allowed and what the agent may do.
:::image-end:::

### Verify

Verify answers one question before release: did behavior change in ways the contract permits? It replays scenarios under controlled conditions, evaluates contract requirements, and compares versions. It combines deterministic assertions with model-based or human evaluation where judgment is necessary. Scenario-level results reveal critical regressions that an aggregate score can hide. For multi-agent systems, verify each governed handoff and the end-to-end system outcome.

Verify contract resolution as well as contract satisfaction. An agent that satisfies the wrong contract behaves incorrectly while every downstream measure reports success, so include scenarios for correct matches, no match, ambiguous matches, precedence rules, and insufficient routing context. Confirm that the system selects the contract you expect, and that it declines to proceed when it can't.

Behavior verification adds to your existing tests rather than replacing them. Unit and integration tests check component logic and interactions. Behavior verification adds checks for evidence support and authority across the scenarios you exercise. Run both in the same pipeline, and gate the release on both.

The behavior gate separates measurement from the release decision. Measuring behavior tells you what changed; the gate decides whether that change is acceptable.

For probabilistic requirements, define the number of repeated runs and the acceptable pass distribution or behavioral variance that the gate uses. Otherwise a passing scenario means only that one execution happened to pass.

Include scenarios with execution lengths representative of production. Define how you count steps and tool calls, and compare contract satisfaction across those lengths using repeated runs. Verify the required failure behavior when execution reaches an operating-envelope limit.

To decide whether the measured change is acceptable, the gate asks four narrower questions:

- What behavior changed?
- What should have changed and didn't?
- What changed that shouldn't have?
- What did we break?

Answer these questions from scenario-level results. In the following comparison, one scenario improves, another regresses, and the aggregate still rises.

| Measure                   | Change from the previous release |
|---------------------------|----------------------------------|
| MFA-cause detection       | Improved                         |
| Provider-outage detection | Regressed                        |
| Aggregate score           | Improved                         |

Pair the gate with release controls. Use staged rollout, record the release manifest, and keep a rollback path. Rolling back means restoring the configuration that produced the previous behavior, not only the previous application code.

### Observe

Observe makes deviations detectable and diagnosable. Latency and errors don't tell you what the agent did. Capture which contract applied, what evidence it used and where that evidence came from, what policy and authorization decided, how tools and fallbacks behaved, and what the agent returned or executed. Apply data minimization, redaction, access controls, and retention limits to prompts, retrieved content, tool payloads, and replay data.

Signals become actionable when thresholds make deviation detectable. Define behavioral service-level indicators and objectives, and set error budgets for them. A budget that burns too quickly can trigger investigation, a rollout freeze, tighter controls, or rollback.

Telemetry doesn't surface every problem. An answer can satisfy every threshold and still be wrong in a way only the person reading it notices, so collect user and reviewer feedback as a first-class signal and link each report to the run manifest that produced the response.

Drift can originate in the model, knowledge, user behavior, upstream tools, policy, or the environment. Identify the likely source before the outer loop routes the finding to the artifact or implementation that owns the fix.

Infrastructure telemetry tells you whether the system was healthy, and it covers latency, errors, token usage, tool failures, and resource consumption. Behavioral telemetry tells you what the agent actually did. Collect both, and keep them correlated through the run manifest so a diagnosis can move between them.

### Request and feedback flow

The five responsibilities interact across both runtime execution and the release lifecycle. Before runtime, domain owners define and approve the contracts and scenarios that govern supported situations.

For a runtime request:

1. The system identifies the bounded situation and resolves the applicable contract, caller and agent identities, permissions, policies, tools, and operating envelope.
1. The Ground responsibility retrieves governed knowledge, runtime evidence, and permitted memory with their provenance and freshness metadata.
1. The agent investigates the situation and proposes an outcome or action.
1. Deterministic controls validate required evidence, policy, authorization, and approvals before an executor performs a side effect.
1. The system records states, evidence, decisions, results, and receipts in the run manifest and behavioral telemetry.

Across releases and production feedback:

1. The Verify responsibility replays scenarios, computes scenario-level results and deltas, and applies the behavior gate before staged rollout.
1. Production monitoring and feedback surface behavioral deviations, drift, and new failure modes.
1. Analysis classifies each finding and routes it to the contract, scenario, policy, knowledge source, or implementation that owns the fix.
1. The team replays and verifies the updated behavior before the next release.

## Design principles

These principles guide architectural decisions across the five ABE responsibilities.

### Define behavior before implementation

Start with the situation, acceptable outcomes, prohibited behavior, evidence, and failure states. Select models, tools, prompts, and workflows only after you define the behavior. This order prevents the capabilities of a chosen model or framework from becoming the requirements by default.

### Require evidence for conclusions

The agent can form hypotheses from incomplete evidence, but factual conclusions and consequential actions require sufficient traceable support. Specify what counts as sufficient evidence and permit the agent to abstain when that threshold isn't met. Retrieval relevance alone doesn't establish factual support.

### Use deterministic controls for guarantees

Use probabilistic models for interpretation, synthesis, planning, and other tasks that require judgment. Use deterministic software for guarantees such as schema validation, permission checks, policy rules, approval enforcement, limits, idempotency, and transaction execution. If deterministic code or a workflow can implement the required behavior, prefer it to agent-directed control flow. Use a model where interpretation or judgment is necessary, then return control to deterministic software for required steps and side effects.

### Keep knowledge and memory distinct

Let the model reason over knowledge rather than asking it to remember. Keep systems of record authoritative. Treat memory as contextual state that can be incomplete, stale, or wrong. Record the source and scope of remembered information, restrict what the agent can write, and define expiration and deletion behavior. Memory must not silently override current policy or authoritative data.

### Bound authority

Constrain what each agent can reach: data, tools, operations, write scopes, approval paths, and memory. Apply least privilege to both the caller and the agent. Instructions alone don't enforce a boundary. Identity and policy controls do.

### Design failure behavior

Make failure behavior part of the contract. State when the agent retries, returns a partial result, asks for more information, abstains, escalates, waits for approval, or stops. Include time and cost budgets so an agent can't continue an unproductive loop indefinitely.

### Design for replay

Capture enough context to investigate and re-evaluate a run: inputs, evidence, tool responses, policies, identities, knowledge and memory versions, and implementation versions. Replay reproduces controlled conditions and dependencies, but it doesn't guarantee identical output from a probabilistic model. Run important scenarios repeatedly to measure behavioral variance.

Use recorded tool responses or mocks when replay doesn't need live dependencies. Otherwise, use isolated test resources and identities that can't issue production writes or other consequential production actions. For test isolation guidance, see [Test and evaluate AI workloads](/azure/well-architected/ai/test).

### Make behavior observable

Instrument contract resolution, evidence use, authority decisions, fallback paths, outcomes, and lineage. A request can succeed and still return an unsupported conclusion or perform an unauthorized action.

## Verification lifecycle

ABE uses an inner verification loop for every material change and an outer feedback loop for production learning.

Both loops cut across the ABE responsibilities rather than belonging to any one of them. The inner loop starts with specified behavior and uses replay, evaluation, and the behavior gate to verify a change before release. The outer loop starts with production signals and feedback, routes each finding to the artifact or implementation that owns the fix, and sends the resulting change back through the inner loop.

### Inner loop

The inner loop is **Contract > Scenarios > Replay > Evaluation > Gate**.

1. Select the versioned contract affected by a proposed change.
1. Run the associated scenarios, including cases captured from production.
1. Reproduce the relevant model, tool, evidence, policy, memory, and failure conditions as closely as the test requires.
1. Evaluate required behavior, prohibited behavior, evidence support, action control, and operating limits for each scenario.
1. Block or promote the release according to contract-specific thresholds and critical requirements.

Comparison and verification serve different purposes. Comparison determines which version scores higher on selected measures. Verification determines whether a version satisfies its required behavior. A higher aggregate score must not override a failed mandatory requirement or prohibited outcome.

### Production feedback loop

The outer loop uses reviewed production findings to improve contracts, scenarios, knowledge, controls, or implementation:

1. Detect a behavioral deviation, new situation, weak evidence path, control failure, or operating-envelope breach through telemetry or user and reviewer feedback.
1. Classify the likely source of the finding as contract resolution, the contract itself, scenarios, knowledge, policy, tool, model, instructions, orchestration, or infrastructure.
1. Update the owning artifact or implementation and record the reason for the change.
1. Add or revise scenarios that reproduce the finding.
1. Run the resulting change through the inner loop, then use staged rollout to validate it in production.

Classification decides which asset changes, and the prompt is one candidate among many. Changing the prompt before identifying the cause can mask a defect in the contract, knowledge, or controls.

Don't convert raw production conversations directly into tests. Remove sensitive data, preserve the behavioral conditions that matter, and have domain owners validate the expected behavior before adding the case to the scenario library.

Use production evaluation alongside telemetry and reviewer feedback. Reuse release evaluators when their required inputs are available from production traces, and map the results to the same behavior scorecard dimensions. Keep evaluations that require unavailable reference outcomes or controlled dependency states in the inner loop. Sample deliberately, because evaluating every interaction is expensive and repetitive traffic adds little information. Weight the sample toward the scenario segments the contract cares about, and treat the resulting scores as a production signal rather than a release decision.

## Measure behavior

Correctness alone doesn’t capture how an agent fails. Measure whether the agent answers when it should, abstains when evidence is weak, stays consistent across repeated runs, and remains within its operating envelope. Choose specific measures from the behavior contract and the risk of the situation. ABE doesn't define universal thresholds. Track distributions and scenario segments instead of relying only on averages.

Answer coverage is the proportion of cases in which the agent produces a substantive conclusion instead of abstaining. Selective risk is the error rate among the cases the agent chooses to answer. Scenario coverage measures how much of the governed scenario set a verification run exercises. Evaluate answer coverage and selective risk together against the contract's thresholds.

| Dimension             | Example measures                                                                               |
|-----------------------|------------------------------------------------------------------------------------------------|
| Contract resolution   | Correct-selection rate, no-match handling, ambiguous-match handling, and precedence violations |
| Contract satisfaction | Required-outcome pass rate and prohibited-outcome rate                                         |
| Evidence              | Supported-conclusion rate, unsupported-conclusion rate, and evidence traceability              |
| Insufficient evidence | Correct abstention rate, answer coverage, and selective risk                                   |
| Action control        | Unauthorized action attempts, approval bypasses, duplicate actions, and receipt completeness   |
| Execution path        | Required-step completion, tool-call accuracy, handoff correctness, and delegation violations   |
| Consistency           | Repeated-run agreement and behavioral variance                                                 |
| Operating envelope    | Tail latency, cost, token use, retries, and tool calls                                         |
| Production behavior   | Escalation rate, fallback rate, behavioral drift, and regressions by segment                   |
| Business outcome      | Resolution rate, handoff rate to humans, rework rate, and cycle time for the governed task     |

Evaluate a specific trajectory only when the contract requires that path. When several paths are valid, verify required steps, prohibited transitions, and final behavior instead of enforcing one exact sequence.

Use deterministic evaluators for objective requirements. For criteria that require judgment, use human review or a large language model (LLM) as a judge. Calibrate model-based evaluators against domain-reviewed examples.

The business outcome dimension is the one that justifies the rest. Behavioral measures tell you whether the agent met its contract. Outcome measures tell you whether meeting the contract changed anything for the business. Track both, because an agent can satisfy every contract requirement and still fail to reduce the work it was built to reduce.

A semantic model widens what you can check deterministically. When a contract defines acceptable outcomes as governed domain concepts and the agent returns a canonical identifier or structured outcome, an evaluator can compare the result directly instead of judging whether two phrasings mean the same thing. This reserves model-based evaluation for criteria that genuinely require judgment.

Version the applicable contract, scenario data, rubrics, model-based evaluators, and thresholds so results remain comparable across releases.

## Implement ABE on Azure

ABE doesn't require Azure, but Azure services can implement parts of the architecture. The behavior contracts, contract-selection logic, scenario library, deterministic policy and approval controls, manifests, and release gates remain application-owned responsibilities.

Choose implementation services independently for each responsibility. A workload can combine a managed agent runtime, custom compute, a separate gateway or orchestration layer, and shared observability without changing the ABE boundaries.

If you build on Microsoft Foundry, use [Responsible AI for Microsoft Foundry](/azure/foundry/responsible-use-of-ai-overview) to determine which principles and lifecycle practices apply, and then express the resulting requirements as contracts, scenarios, controls, and manifests.

The following diagram shows example Azure service mappings. These are implementation options, not a required stack.

:::image type="complex" source="_images/agentic-behavior-engineering-azure-services.png" lightbox="_images/agentic-behavior-engineering-azure-services.png" alt-text="Diagram mapping five ABE responsibilities to example Azure services and identifying application-owned responsibilities." border="false":::
Five stacked rows map ABE responsibilities on the left to service options on the right. From top to bottom, Specify lists Azure Repos and Azure App Configuration. Ground lists Azure AI Search, Microsoft Fabric semantic models and ontology (preview), and Azure Cosmos DB.
Control lists Microsoft Entra ID, API Management, AKS, Container Apps, Azure AI Content Safety, and Foundry Agent Service. Verify lists Azure Pipelines, Azure ML for custom models, Azure Storage, Foundry evaluation, and Foundry datasets. Observe lists Azure Monitor, Application Insights, and Log Analytics.

The subtitle says these options aren't a required stack. Below the rows, a note says availability and preview status vary by feature. A footer lists application-owned responsibilities: behavior contracts and scenarios, evidence requirements, judgment boundaries, authority and approval rules, release criteria, and interpretation of behavioral signals.
:::image-end:::

The following mapping separates what the platform supplies from what you own in each of the five responsibilities.

| Responsibility | Platform supplies                                                                                                                   | You own                                                           |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| Specify        | Source control, review workflow, and a runtime-accessible configuration store                                                       | The contracts, the scenario library, and what counts as correct   |
| Ground         | Azure AI Search, Fabric ontology and semantic model, Azure Cosmos DB, and enterprise APIs                                           | Whether knowledge, evidence, and memory stay distinguishable      |
| Control        | Microsoft Entra, Foundry Agent Service, AKS, Container Apps, App Service, gateways, Azure AI Content Safety, and policy enforcement | The judgment boundary, authority rules, and approval policy       |
| Verify         | CI/CD, Foundry evaluation for agents, Azure Machine Learning for custom models, captured state, and deployment records              | Expected behavior, gate criteria, and the release decision        |
| Observe        | Azure Monitor, Application Insights, Log Analytics, and Kusto Query Language (KQL)                                                  | Which behavioral signals to emit, and how findings are classified |

Many of the Azure capabilities in this section are in preview, and this article notes their status where it applies. Preview features carry no service-level agreement and can change before they reach general availability, which makes them a weak foundation for the controls that decide whether a release ships. Build the release-blocking path on generally available capabilities: identity and authorization, deterministic policy and approval checks, source control, deployment pipelines, and telemetry collection. Treat preview capabilities as additional signal until they reach general availability, and record in the release manifest which gate decisions depend on one.

Agents can also run on surfaces outside this mapping, such as Microsoft Copilot Studio. Those agents can participate in Verify and Observe when the surface exposes sufficient evaluation and telemetry signals, but support for OpenTelemetry-aligned telemetry and for deterministic controls varies by surface and feature. Confirm which authority, policy, and approval controls a surface enforces outside the model before you place a consequential action behind it.

### Specify on Azure

Store contracts, scenarios, operating envelopes, evaluator configurations, and release manifests in version control. Use your continuous integration and continuous delivery pipeline to review changes, run replay suites, publish evaluation evidence, and enforce behavior gates. Keep domain approval separate from deployment permission when the risk requires independent review.

### Ground on Azure

[Azure AI Search agentic retrieval](/azure/search/agentic-retrieval-overview) can use a knowledge base to retrieve grounding information across configured knowledge sources. It can return source references and an activity log with the merged grounding content. Answer synthesis, non-minimal retrieval reasoning effort, and multi-turn messages remain in preview. Preserve the source references and relevant retrieval activity in the run manifest when the contract requires traceability.

Availability varies by feature and access path. Some agentic retrieval features are generally available through the `2026-04-01` REST API, while the Azure portal and Microsoft Foundry portal provide preview-only access to agentic retrieval. Preview features come without a service-level agreement and aren't recommended for production workloads. Confirm the availability of the specific features that your contract depends on, and record the API version in the release manifest. Treat an API version upgrade as a behavioral change that requires verification, and apply the same discipline to every service API the agent depends on.

Keep operational records in systems of record such as Azure Cosmos DB and analytical data in Microsoft Fabric authoritative. Label retrieved or tool-supplied data with its source, freshness, and authority before the agent uses it. The application must resolve conflicting sources and decide whether the available evidence satisfies the contract.

The [Fabric IQ](/fabric/iq/overview) workload provides governed business context through ontology and semantic model items. An [ontology](/fabric/iq/ontology/overview) defines a shared domain vocabulary as entity types, properties, and relationships, with rules and constraints that keep them consistent. It binds those concepts to lakehouse tables, eventhouse streams, and Power BI semantic models in OneLake.

Foundry agents can reach these items through the [Fabric IQ tool](/azure/foundry/agents/how-to/tools/fabric-iq). For ontology queries, Fabric IQ resolves natural language against the ontology and applies the permissions and governance policies of the connection identity. Fabric IQ, ontology items, and the Foundry integration are in preview. Connecting to Fabric IQ can also send data outside the Azure compliance boundary, so confirm that the flow meets your residency and compliance requirements before a contract depends on it.

Ontology-bound data isn't automatically current. Updates in the underlying sources become visible in the ontology item only after a refresh, so an ontology can return a confident answer from data that no longer reflects the source. When a contract requires fresh evidence, verify the refresh state rather than assuming the ontology mirrors its sources, and treat the refresh interval as part of evidence qualification.

Expressing contract outcomes as governed ontology concepts widens what you can verify deterministically. Version the ontology definition independently of the agent implementation. [Fabric Git integration](/fabric/cicd/git-integration/intro-to-git-integration) supports ontology items in preview, so source-control the definition there and record the ontology item identifier and commit in the release manifest.

Keep exported definition snapshots for backup and version retention. They don't remove the dependency on the preview ontology runtime.

Agentic retrieval can add latency and cost compared with a single-query pipeline. Include retrieval reasoning effort, source fan-out, token use, and latency in the operating envelope, and include source freshness in evidence qualification. Treat retrieved content as untrusted and test for indirect prompt injection.

### Control and run on Azure

[Foundry Agent Service](/azure/foundry/agents/overview) can run declarative prompt agents or custom hosted agents and can provide models, tools, versioning, and managed endpoints. You can also host custom agent and control components in [Azure Kubernetes Service](/azure/aks/what-is-aks), [Azure Container Apps](/azure/container-apps/overview), or [Azure App Service](/azure/app-service/overview) when you need a different runtime or deployment boundary. To compare these hosting options, see [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md).

Use [Microsoft Entra agent identities](/azure/foundry/agents/concepts/agent-identity) and Azure role-based access control to give agents scoped access to downstream resources. Agent identity authentication currently covers Model Context Protocol and agent-to-agent connections. Other tools might use key-based authentication or OAuth identity passthrough, so confirm what each tool supports before you design its authority boundary. Keep caller authority distinct from agent authority, and apply both when the agent acts for a user. Verify the effective runtime identity and its downstream permissions as part of release readiness.

[Azure API Management](/azure/api-management/mcp-server-overview) can expose and govern MCP servers, validate Microsoft Entra tokens on inbound requests, authenticate outbound calls to backends, and enforce rate limits and quotas that keep tool use inside the operating envelope. Front shared tools with a gateway when multiple agents or teams depend on them.

[Microsoft Agent Framework](/agent-framework/) can provide orchestration for multi-agent systems, including built-in [sequential, concurrent, handoff, group chat, and magentic patterns](/agent-framework/workflows/orchestrations/). Record the orchestration pattern and configuration in the release manifest because changing how agents coordinate can change behavior.

Framework [middleware](/agent-framework/concepts/agents/middleware/) can intercept agent runs, function calls, and model calls. Use function-calling middleware to apply validation and other deterministic controls before a tool executes, and to capture the tool inputs and outputs needed for diagnosis or replay. Agent Framework pairs that middleware with OpenTelemetry instrumentation in the same pipeline, so those execution points can support control and observability.

Agent Framework also implements the suspended-run state that the authority boundary depends on. [Human-in-the-loop workflows](/agent-framework/workflows/human-in-the-loop) pause execution and wait for external input, and an agent can call tools that require human approval before they execute.

For approval waits that must survive a restart, configure persistent [checkpoint storage](/agent-framework/workflows/checkpoints) and restore the saved workflow state. Pending requests are saved with checkpoints and re-emitted on restore; handle those requests through the approval flow before allowing execution to continue.

[Azure AI Content Safety](/azure/ai-services/content-safety/overview) provides content-level controls that run outside the model. [Prompt Shields](/azure/ai-services/content-safety/concepts/jailbreak-detection) analyzes user prompts and grounding documents for direct and indirect prompt injection, which supports the adversarial scenarios in the scenario library. Text and image moderation and protected material detection are also generally available, while groundedness detection is in preview. Treat a block or a modified response as a behavioral outcome. Define the expected behavior in the contract, and record which checks ran and what they returned in the run manifest.

[Task adherence](/azure/ai-services/content-safety/concepts/task-adherence) (preview) flags tool use that conflicts with user intent and provides a signal for control decisions such as blocking a call or requesting human review. Customer data might be routed to and processed in US or EU regions outside your selected region. Confirm that this processing meets your data residency requirements before enabling the feature.

[Groundedness detection](/azure/ai-services/content-safety/concepts/groundedness) checks generated content against supplied source material and can contribute to supported-conclusion measures in the behavior scorecard. Neither check replaces contract assertions or establishes that the underlying evidence is authoritative, fresh, complete, or sufficient under the contract.

Place deterministic authorization, policy, approval, validation, and idempotency controls between an agent's proposal and an action executor. A successful tool call doesn't prove that the action was permitted by the behavior contract. Function-calling middleware, a gateway policy, or a workflow approval step are all reasonable places to enforce these checks. What matters is that the check runs outside the model and that its decision reaches the run manifest.

### Verify on Azure

[Microsoft Foundry agent evaluation](/azure/foundry/observability/how-to/evaluate-agent) provides built-in evaluators for agent behavior, quality, and safety, along with rubric and custom evaluators that you define. Use these evaluators for judgment-based criteria and combine them with deterministic contract assertions in the deployment pipeline.

Rubric and custom evaluators are in preview, as are several individual agent and safety evaluators. Preview evaluators have no service-level agreement, so confirm the status of the ones your gate depends on and don't rest a release decision on a preview evaluator alone.

Publish the scenario subset required for a verification run as a [versioned Foundry dataset](/azure/foundry/observability/how-to/evaluation-datasets). Treat the dataset as an execution copy. The governed scenario library remains the source of truth. Record the scenario library and dataset versions along with the agent, model, evaluator, and rubric versions when you compare releases. When the library partitions a protected holdout set, restrict access to the published dataset accordingly, because an execution copy inherits the exposure risk of the scenarios it carries.

Foundry evaluation can produce aggregate and row-level results. Apply the behavior gate to the row-level results so that it evaluates each scenario. Review regional availability, rate limits, network support, and cost for the evaluators that you select.

To close the outer loop with the same evaluators, use [trace evaluation](/azure/foundry/observability/how-to/cloud-evaluation-deployed-interactions), currently in preview, which scores OpenTelemetry traces that Application Insights already captured without replaying the original requests. It also supports intelligent sampling, which selects a diverse subset of traces instead of scoring every one, and it works for agents built outside Foundry Agent Service as long as they emit spans that follow the generative AI semantic conventions.

If your agent depends on custom models that you train and deploy, register and version those models in [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning), and reference the applicable model version in the release manifest alongside the agent and scenario versions.

### Observe on Azure

Use [Microsoft Foundry observability](/azure/foundry/concepts/observability), Azure Monitor Application Insights, or both to collect and analyze behavioral and operational signals. Both support OpenTelemetry-based instrumentation for traces, metrics, model calls, tool invocations, latency, token use, errors, and other runtime signals. Foundry adds agent-focused monitoring and evaluation experiences over telemetry stored in Application Insights.

When agents run outside Foundry, emit spans that follow the OpenTelemetry generative AI semantic conventions so they can appear in the [Agent details view](/azure/azure-monitor/app/agents-view) alongside Foundry and Copilot Studio sources. The Agent details view is currently in preview.

You can also [register agents that run outside Foundry](/azure/foundry/agents/how-to/register-external-agent), currently in preview, to use the Foundry trace view and evaluation over the same telemetry. Foundry stores only registration metadata and doesn't host, proxy, or invoke the runtime.

ABE defines which behavioral signals matter. Add properties such as the resolved contract version, evidence references, policy decisions, and action receipts. Foundry provides preview support for logging end-user feedback as OpenTelemetry events. Correlate each user and reviewer report with the originating trace and run manifest.

Use Log Analytics queries, Application Insights dashboards, Azure Monitor alerts, or Foundry monitoring experiences to detect contract failures, unsupported conclusions, changes in abstention or escalation rates, and operating-envelope breaches. Restrict access to telemetry and avoid recording sensitive prompt, evidence, memory, or tool content unless the diagnostic value and retention controls justify it.

> [!IMPORTANT]
> Azure services don't create or enforce an ABE behavior contract automatically. Your application and governance process must define the contract, resolve which version applies, implement deterministic controls, and decide whether a release passes its behavior gate.

## Adoption path

Start with a minimum viable implementation around one consequential behavior.

The smallest useful ABE implementation isn't a platform. It's one behavior that's explicit, replayable, evaluated, and gated. The first working loop lives in Specify and Verify. Avoid building a broad platform before the team can use one contract to prevent, detect, or diagnose a real behavioral problem.

1. Select a bounded, consequential situation with a clear domain owner.
1. Write one reviewed behavior contract, including evidence and failure states.
1. Create a small set of domain-validated scenarios that includes normal, boundary, insufficient-evidence, and dependency-failure cases.
1. Capture or simulate stable tool and knowledge responses for replay.
1. Add deterministic checks and only the judgment-based evaluators needed by the contract.
1. Run the scenarios in continuous integration and block releases on critical failures.
1. Record enough information from production runs to identify the contract, implementation, evidence path, and outcome.
1. Turn reviewed production findings into regression scenarios.

Expand by risk and observed need. Ground, Control, and Observe mature as the system scales. Add governed knowledge and memory, finer authority boundaries, durable run states and manifests, repeated-run analysis, behavioral service-level objectives, and automated drift detection as risk increases.

## Limitations and considerations

- ABE can verify only the behavior that teams specify and exercise. Incomplete contracts, scenarios, or evidence requirements can leave important failure modes uncovered.
- ABE improves control and evidence, but it doesn't make model output deterministic or eliminate the need for domain review.
- Replay reproduces captured conditions only to the fidelity of the recorded evidence, tools, policies, configuration, and versions.
- Model-based evaluators are also probabilistic. Calibrate them against domain-reviewed examples, inspect scenario-level explanations, and use deterministic checks for hard requirements.
- More retrieval, replay, evaluation, and telemetry increase latency, storage, and cost. Bound them through the operating envelope.
- Production traces and replay data can contain sensitive information. Apply applicable consent, minimization, redaction, access, residency, and retention requirements throughout their lifecycle.
- Human approval remains necessary when organizational policy, regulation, or the consequence of an action requires accountable human judgment.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Yang Song](https://www.linkedin.com/in/yang-song-4334475/) | Principal Software Engineer

Other contributors:

- [Bryan Osdiek](https://www.linkedin.com/in/bostdiek/) | Principal Data Scientist
- [Rama Pyarasani](https://www.linkedin.com/in/rama-pyarasani/) | Multidisciplinary Forward Deployed Engineer Manager
- [Ronnie Yates](https://www.linkedin.com/in/ronnieyates/) | General Manager, Forward Deployed Engineering GM

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Agents in Microsoft Foundry](/azure/foundry/agents/overview)
- [Evaluate your AI agents](/azure/foundry/observability/how-to/evaluate-agent)
- [Agentic retrieval in Azure AI Search](/azure/search/agentic-retrieval-overview)
- [Monitor AI agents with Application Insights](/azure/azure-monitor/app/agents-view)

## Related resources

- [AI agent design patterns](ai-agent-design-patterns.md)
- [Agentic retrieval-augmented generation](rag/rag-agentic.md)
- [Machine learning operations](machine-learning-operations-v2.md)
