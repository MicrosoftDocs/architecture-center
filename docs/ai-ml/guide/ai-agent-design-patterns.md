---
title: AI Agent Orchestration Patterns
description: Learn about fundamental orchestration patterns for AI agent architectures, including sequential, concurrent, group chat, handoff, and magentic patterns.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/12/2026
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
---

# AI agent orchestration patterns

As architects and developers design their workload to take full advantage of language model capabilities, AI agent systems become increasingly complex. These systems often exceed the abilities of a single agent that has access to many tools and knowledge sources. Instead, these systems use multiagent orchestrations to handle complex, collaborative tasks reliably. This guide covers fundamental orchestration patterns for multiagent architectures and helps you choose the approach that fits your specific requirements.

## Start with the right level of complexity

Before you adopt a multiagent orchestration pattern, evaluate whether your scenario requires one. Agent architectures exist on a spectrum of complexity, and each level introduces coordination overhead, latency, and cost. Use the lowest level of complexity that reliably meets your requirements.

| Level | Description | When to use | Considerations |
| :---- | :---------- | :---------- | :------------- |
| **Direct model call** | A single language model call with a well-crafted prompt. No agent logic, no tool access. | The model can complete classification, summarization, translation, and other single-step tasks in one pass. | The least complex option. If prompt engineering can solve the problem, you don't need an agent. |
| **Single agent with tools** | One agent that reasons and chooses from available tools, knowledge sources, and APIs. The agent can loop through multiple model calls and tool invocations to refine results. | The agent can handle varied queries within a single domain, in which some requests require dynamic tool use, such as order status lookup or database queries. | Often the right default for enterprise use cases. Simpler to debug and test than multiagent setups, but still supports dynamic logic. To guard against infinite tool-call loops, set iteration limits. |
| **Multiagent orchestration** | Multiple specialized agents that coordinate to solve problems. An orchestrator or peer-based protocol manages work distribution, context sharing, and result aggregation. | The agents can handle cross-functional or cross-domain problems, scenarios that require distinct security boundaries for each agent, and tasks that benefit from parallel specialization. | Adds coordination overhead, latency, and failure modes. You can justify the added complexity because a single agent can't reliably handle certain tasks due to prompt complexity, tool overload, or security requirements. |

This guide focuses on orchestration patterns at the multiagent level, where coordination challenges are most significant.

## Overview

When you use multiple AI agents, you can break down complex problems into specialized units of work or knowledge. You assign each task to dedicated AI agents that have specific capabilities. These approaches mirror strategies found in human teamwork. Using multiple agents provides several advantages compared to monolithic single-agent solutions.

- **Specialization:** Individual agents can focus on a specific domain or capability, which reduces code and prompt complexity.

- **Scalability:** Agents can be added or modified without redesigning the entire system.

- **Maintainability:** Testing and debugging can be focused on individual agents, which reduces the complexity of these tasks.

- **Optimization:** Each agent can use distinct models, task-solving approaches, knowledge, tools, and compute to achieve its outcomes.

The patterns in this guide show proven approaches for orchestrating multiple agents to work together and accomplish an outcome. Each pattern is optimized for different types of coordination requirements. These AI agent orchestration patterns complement and extend traditional [cloud design patterns](/azure/architecture/patterns/) by addressing the unique challenges of coordinating autonomous components in AI-driven workload capabilities.

## Sequential orchestration

The sequential orchestration pattern chains AI agents in a predefined, linear order. Each agent processes the output from the previous agent in the sequence, which creates a pipeline of specialized transformations.

The sequential orchestration pattern is also known as a *pipeline*, *prompt chaining*, or *linear delegation*.

:::image type="complex" border="false" source="_images/sequential-pattern.svg" alt-text="Diagram that shows sequential orchestration where agents process tasks in a defined pipeline order. Output flows from one agent to the next." lightbox="_images/sequential-pattern.svg":::
   The image shows several sections that have arrows and connecting lines. An arrow points from Input to Agent 1. A line connects Agent 1 to a section that reads Model, knowledge, and tools. An arrow points from Agent 1 to Agent 2. A line connects Agent 2 to a section that reads Model, knowledge, and tools. An arrow points from Agent 2 to a box that has ellipses. An arrow points from this box to Agent n. A line connects Agent n to a section that reads Model, knowledge, and tools. An arrow points from Agent n to Result. A section that reads Common state spans the Agent 1 section through the Agent n section.
:::image-end:::

The sequential orchestration pattern solves problems that require step-by-step processing, where each stage builds on the previous stage. It suits workflows that have clear dependencies and improve output quality through progressive refinement. This pattern resembles the [Pipes and Filters](/azure/architecture/patterns/pipes-and-filters) cloud design pattern, but it uses AI agents instead of custom-coded processing components. The choice of which agent gets invoked next is deterministically defined as part of the workflow and isn't a choice given to agents in the process.

### When to use sequential orchestration

Consider the sequential orchestration pattern in the following scenarios:

- Multistage processes that have clear linear dependencies and predictable workflow progression

- Data transformation pipelines, where each stage adds specific value that the next stage depends on

- Workflow stages that can't be parallelized

- Progressive refinement requirements, such as *draft, review, polish* workflows

- Systems where you understand the availability and performance characteristics of every AI agent in the pipeline, and where failures or delays in one AI agent's processing are tolerable for the overall task to be accomplished

### When to avoid sequential orchestration

Avoid this pattern in the following scenarios:

- Stages are [embarrassingly parallel](https://wikipedia.org/wiki/Embarrassingly_parallel). You can parallelize them without compromising quality or creating shared state contention.

- Processes that include only a few stages that a single AI agent can accomplish effectively.

- Early stages might fail or produce low-quality output, and there's no reasonable way to prevent later steps from processing by using accumulated error output.

- AI agents need to collaborate rather than hand off work.

- The workflow requires backtracking or iteration.

- You need dynamic routing based on intermediate results.

### Sequential orchestration example

A law firm's document management software uses sequential agents for contract generation. The intelligent application processes requests through a pipeline of four specialized agents. The sequential and predefined pipeline steps ensure that each agent works with the complete output from the previous stage.

:::image type="complex" border="false" source="_images/sequential-pattern-example.svg" alt-text="Diagram that shows sequential orchestration where a document creation pipeline is implemented with agents." lightbox="_images/sequential-pattern-example.svg":::
   The image shows several sections that have arrows and connecting lines. An arrow points from Document creation requirements to Template selection agent. A line connects the Template section agent to a section that reads Model, template library, and research tools. An arrow points from the Template selection agent to the Clause customization agent. A line connects the Clause customization agent to a section that reads Fine-tuned model. An arrow points from the Clause customization agent to the Regulatory compliance agent. A line connects the Regulatory compliance agent to a section that reads Model, regulatory knowledge. An arrow points from the Regulatory compliance agent to the Risk assessment agent. A line connects the Risk assessment agent to a section that reads Model, liability knowledge, and persistence tools. An arrow points from the Risk assessment agent to a section that reads Proposed document. A section that reads Document state spans the Clause customization agent to the Proposed document section.
:::image-end:::

1. The *template selection agent* receives client specifications, like contract type, jurisdiction, and parties involved, and selects the appropriate base template from the firm's library.

1. The *clause customization agent* takes the selected template and modifies standard clauses based on negotiated business terms, including payment schedules and liability limitations.

1. The *regulatory compliance agent* reviews the customized contract against applicable laws and industry-specific regulations.

1. The *risk assessment agent* performs comprehensive analysis of the complete contract. It evaluates liability exposure and dispute resolution mechanisms while providing risk ratings and protective language recommendations.

## Concurrent orchestration

The concurrent orchestration pattern runs multiple AI agents simultaneously on the same task. This approach enables each agent to provide independent analysis or processing from its unique perspective or specialization.

The concurrent orchestration is also known as *parallel*, *fan-out/fan-in*, *scatter-gather*, or *map-reduce*.

:::image type="complex" border="false" source="_images/concurrent-pattern.svg" alt-text="Diagram that shows concurrent orchestration where multiple agents process the same input task simultaneously and their results are aggregated." lightbox="_images/concurrent-pattern.svg":::
   The image contains three key sections. In the top section, an arrow points from Input to the Initiator and collector agent. An arrow points from the Initiator and collector agent to a section that reads Aggregated results based on combined, compared, and selected results. A line connects the Initiator and collector agent to a line that connects to four sections via arrows. These sections are Agent 1, Agent 2, an unlabeled section that has ellipses, and Agent n. An arrow points from Agent 1 to Intermediate result. A line points from Agent 1 and splits into two flows. The first flow shows a Sub agent 1.1 section and a section that reads Model, knowledge, and tools. The second flow shows a Sub agent 1.2 and a section that reads Model, knowledge and tools. An arrow points from Agent 2 to Intermediate result. A line connects Agent 2 to a section that reads Model, knowledge, and tools. An arrow points from the unlabeled section that has ellipses to Intermediate results. An arrow points from Agent n to Intermediate result. A line connects Agent n to a section that reads Model, knowledge, and tools.
:::image-end:::

This pattern addresses scenarios in which you need diverse insights or approaches to the same problem. Instead of sequential processing, all agents work in parallel, which reduces overall run time and provides comprehensive coverage of the problem space. This orchestration pattern resembles the Fan-out/Fan-in cloud design pattern. The results from each agent are often aggregated to return a final result, but that's not required. Each agent can independently produce its own results within the workload, such as invoking tools to accomplish tasks or updating different data stores in parallel. When aggregation is needed, choose a strategy that fits the task. For example, vote or use majority-rule for classification, apply weighted merging for scored recommendations, or use a language-model-synthesized summary to reconcile results into a coherent narrative.

Agents operate independently and don't hand off results to each other. An agent might invoke extra AI agents by using its own orchestration approach as part of its independent processing. The orchestrator must know which agents are registered and available. This pattern supports both deterministic calls to all registered agents and dynamic selection of which agents to invoke based on the task requirements.

### When to use concurrent orchestration

Consider the concurrent orchestration pattern in the following scenarios:

- Tasks that you can run in parallel, either by using a fixed set of agents or by dynamically choosing AI agents based on specific task requirements.

- Tasks that benefit from multiple independent perspectives or different specializations, such as technical, business, and creative approaches, that can all contribute to the same problem. This collaboration typically occurs in scenarios that feature the following multiagent decision-making techniques:

  - Brainstorming

  - Ensemble reasoning

  - Quorum and voting-based decisions

- Time-sensitive scenarios where parallel processing reduces latency.

### When to avoid concurrent orchestration

Avoid this orchestration pattern in the following scenarios:

- Agents need to build on each other's work or require cumulative context in a specific sequence.

- The task requires a specific order of operations or deterministic, reproducible results from running in a defined sequence.

- Resource constraints, such as model quota, make parallel processing inefficient or impossible.

- Agents can't reliably coordinate changes to shared state or external systems while running simultaneously.

- There's no clear conflict resolution strategy to handle contradictory or conflicting results from each agent.

- Result aggregation logic is too complex or lowers the quality of the results.

### Concurrent orchestration example

A financial services firm built an intelligent application that uses concurrent agents that specialize in different types of analysis to evaluate the same stock simultaneously. Each agent contributes insights from its specialized perspective, which provides diverse, time-sensitive input for rapid investment decisions.

:::image type="complex" border="false" source="_images/concurrent-pattern-example.svg" alt-text="Diagram that shows concurrent orchestration to evaluate a stock." lightbox="_images/concurrent-pattern-example.svg":::
   The image contains three key sections. In the top section, an arrow points from Ticker symbol to the Stock analysis agent. A line connects Model, exchange symbol mapping knowledge to the Stock analysis agent. An arrow points from the Stock analysis agent to a section that reads Decision with supporting evidence based on combined intermediate results. A line connects Stock analysis agent to a line that points to four separate sections. These sections are four separate flows: Fundamental analysis agent, Technical analysis agent, Sentiment analysis agent, and ESG agent. A line connects Model to the Fundamental analysis agent flow. An arrow points from Fundamental analysis agent flow to Intermediate result. A line points from the Fundamental analysis agent flow and splits into two flows: Financials and revenue analysis agent and Competitive analysis agent. A line connects Financials and revenue analysis agent to a section that reads Model, reported financials knowledge. A line connects Competitive analysis agent to a section that reads Model, competitive knowledge. An arrow points from Technical analysis agent to Intermediate result. A line connects Technical analysis agent to a section that reads Fine-tuned model, market APIs. An arrow points from Sentiment analysis agent to Intermediate result. A line connects Sentiment analysis agent to a section that reads Model, social APIs, news APIs. An arrow points from the ESG agent to Intermediate result. A line connects the ESG agent to a section that reads Model, ESG knowledge.
:::image-end:::

The system processes stock analysis requests by dispatching the same ticker symbol to four specialized agents that run in parallel.

- The *fundamental analysis agent* evaluates financial statements, revenue trends, and competitive positioning to assess intrinsic value.

- The *technical analysis agent* examines price patterns, volume indicators, and momentum signals to identify trading opportunities.

- The *sentiment analysis agent* processes news articles, social media mentions, and analyst reports to gauge market sentiment and investor confidence.

- The *environmental, social, and governance (ESG) agent* reviews environmental impact, social responsibility, and governance practice reports to evaluate sustainability risks and opportunities.

These independent results are then combined into a comprehensive investment recommendation, which enables portfolio managers to make informed decisions quickly.

## Group chat orchestration

The group chat orchestration pattern enables multiple agents to solve problems, make decisions, or validate work by participating in a shared conversation thread where they collaborate through discussion. A chat manager coordinates the flow by determining which agents can respond next and by managing different interaction modes, from collaborative brainstorming to structured quality gates.

The group chat orchestration is also known as *roundtable*, *collaborative*, *multiagent debate*, or *council*.

:::image type="complex" border="false" source="_images/group-chat-pattern.svg" alt-text="Diagram that shows group chat orchestration where multiple agents participate in a managed conversation. A central chat manager coordinates the discussion flow." lightbox="_images/group-chat-pattern.svg":::
   The image shows several sections that have arrows and connecting lines. An arrow points from Input to Group chat manager. An arrow starts at Model, goes through Group chat manager, and points to Accumulating chat thread. A section below this line reads New group instructions based on accumulated context. A line connects to a section that reads Human chat participant or observer. An arrow points from Group chat manager to Agent 2. A double-sided arrow connects Agent 1, an unlabeled box that has ellipses, and Agent n. A line connects Agent 1, Agent 2, the unlabeled box, and Agent n. A line connects Agent 1 to Model and knowledge. A line connects Agent 2 to Model and knowledge. A line connects Agent n to Model and knowledge. An arrow points from a section that reads Chat output from agents to Accumulating chat thread. A line connects Accumulating chat thread to Result.
:::image-end:::

This pattern addresses scenarios that are best accomplished through group discussion to reach decisions. These scenarios might include collaborative ideation, structured validation, or quality control processes. The pattern supports various interaction modes, from free-flowing brainstorming to formal review workflows that use fixed roles and approval gates.

This pattern works well for human-in-the-loop (HITL) scenarios where humans can optionally take on dynamic chat manager responsibilities and guide conversations toward productive outcomes. In this orchestration pattern, agents are typically in a *read-only* mode. They don't use tools to make changes in running systems.

### When to use group chat orchestration

Consider group chat orchestration when your scenario can be solved through spontaneous or guided collaboration or iterative maker-checker loops. All of these approaches support real-time human oversight or participation. Because all agents and humans in the loop emit output into a single accumulating thread, this pattern provides transparency and auditability.

#### Collaborative scenarios

- Creative brainstorming sessions where agents that have different perspectives and knowledge sources build on each other's contributions to the chat

- Decision-making processes that benefit from debate and consensus-building

- Decision-making scenarios that require iterative refinement through discussion

- Multidisciplinary problems that require cross-functional dialogue

#### Validation and quality control scenarios

- Quality assurance requirements that involve structured review processes and iteration

- Compliance and regulatory validation that requires multiple expert perspectives

- Content creation workflows that require editorial review with a clear separation of concerns between creation and validation

### When to avoid group chat orchestration

Avoid this pattern in the following scenarios:

- Basic task delegation or linear pipeline processing is sufficient.

- Real-time processing requirements make discussion overhead unacceptable.

- Clear hierarchical decision-making or deterministic workflows without discussion are more appropriate.

- The chat manager has no objective way to determine whether the task is complete.

Managing conversation flow and preventing infinite loops require careful attention, especially as more agents make control more difficult to maintain. To maintain effective control, consider limiting group chat orchestration to three or fewer agents.

### Maker-checker loops

The maker-checker loop is a specific type of group chat orchestration in which one agent, the *maker*, creates or proposes something, and another agent, the *checker*, evaluates the result against defined criteria. If the checker identifies gaps or quality problems, it pushes the conversation back to the maker with specific feedback. The maker revises its output and resubmits the result. This cycle repeats until the checker approves the result or the orchestration reaches a maximum iteration limit. Although the group chat pattern doesn't require agents to *take turns* chatting, the maker-checker loop requires a formal turn-based sequence that the chat manager drives.

Maker-checker loops are also known as *evaluator-optimizer*, *generator-verifier*, *critic loops*, or *reflection loops*.

This pattern requires clear acceptance criteria for the checker agent so that it can make consistent pass or fail decisions. Set an iteration cap to prevent infinite refinement loops, and define fallback behavior for when the cap is reached. The failover behavior might include escalation to a human reviewer or a quality warning alongside the best possible result.

### Group chat orchestration example

A city parks and recreation department uses software that includes group chat orchestration to evaluate new park development proposals. The software reads the draft proposal, and multiple specialist agents debate different community impact perspectives and work toward consensus on the proposal. This process occurs before the proposal opens for community review to help anticipate the feedback that it might receive.

:::image type="complex" border="false" source="_images/group-chat-pattern-example.svg" alt-text="Diagram that shows group chat orchestration for municipal park planning with specialist city planning agents." lightbox="_images/group-chat-pattern-example.svg":::
   The image shows several sections that have arrows and connecting lines. An arrow points from Park development proposal to Group chat manager. A line starts at Model, goes through Group chat manager, and points to Accumulating conversation. A line connects Parks department employee to this line. A section that reads Instructions based on accumulated context and fresh insight is beneath this section. An arrow points from Group chat manager to the Environmental planning agent. A double-sided arrow connects the Community engagement agent and the Parks budget and operations agent. A line connects the Community engagement agent to the Environmental planning agent and the Parks budget and operations agent. A line connects the Community engagement agent to a section that reads Model and civic knowledge. A line connects the Environmental planning agent to a section that reads Model and local environmental knowledge. An arrow connects a section that reads Chat output from civic agents to Accumulating conversation. A line connects Accumulating conversation to Park proposal consensus. A line connects the Parks budget and operations agent to a section that reads Model and city knowledge.
:::image-end:::

The system processes park development proposals by initiating a group consultation with specialized municipal agents that engage in the task from multiple civic perspectives.

- The *community engagement agent* evaluates accessibility requirements, anticipated resident feedback, and usage patterns to ensure equitable community access.

- The *environmental planning agent* assesses ecological impact, sustainability measures, native vegetation displacement, and compliance with environmental regulations.

- The *budget and operations agent* analyzes construction costs, ongoing maintenance expenses, staffing requirements, and long-term operational sustainability.

The chat manager facilitates structured debate where agents challenge each other's recommendations and defend their reasoning. A parks department employee participates in the chat thread to add insight and respond to agents' knowledge requests in real time. This process enables the employee to update the original proposal to address identified concerns and better prepare for community feedback.

## Handoff orchestration

The handoff orchestration pattern enables dynamic delegation of tasks between specialized agents. Each agent can assess the task at hand and decide whether to handle it directly or transfer it to a more appropriate agent based on the context and requirements.

The handoff orchestration is also known as *routing*, *triage*, *transfer*, *dispatch*, or *delegation*.

:::image type="complex" border="false" source="_images/handoff-pattern.svg" alt-text="Diagram that shows handoff orchestration where an agent intelligently routes tasks to appropriate specialist agents based on dynamic analysis." lightbox="_images/handoff-pattern.svg":::
   The image shows five key sections. The Agent 1 section includes input, a model and general knowledge section, and a result. The Agent 2 section includes a result and model and knowledge section. The Agent 3 section includes the model, knowledge, and tools section, a result, and an unlabeled section that connects to a result. The Agent n section includes a model and knowledge section and a result. The Customer support employee section includes a result. Curved arrows flow from agent to agent and to the customer support employee.
:::image-end:::

This pattern addresses scenarios in which the optimal agent for a task isn't known upfront or the task requirements become clear only during processing. It enables intelligent delegation and ensures that tasks reach the most capable agent. Agents in this pattern don't typically work in parallel. Full control transfers from one agent to another agent.

### When to use handoff orchestration

Consider the agent handoff pattern in the following scenarios:

- Tasks that require specialized knowledge or tools, but where the number of agents needed or their order can't be predetermined

- Scenarios where expertise requirements emerge during processing, resulting in dynamic task routing based on content analysis

- Multiple-domain problems that require different specialists who operate one at a time

- Logical relationships and signals that you can predetermine to indicate when one agent reaches its capability limit and which agent should handle the task next

### When to avoid handoff orchestration

Avoid this pattern in the following scenarios:

- The appropriate agent, or sequence of agents, is identifiable from the initial input. In that case, use deterministic routing or a simpler dispatcher that doesn't take an active role in processing. This dispatcher first classifies the input and then sends it to the appropriate agent.

- Task routing is deterministic and rule-based. It isn't based on dynamic context windows or dynamic interpretation.

- Suboptimal routing decisions might lead to a poor or frustrating user experience.

- Multiple operations should run concurrently to address the task.

- Avoiding an infinite handoff loop or avoiding excessive bouncing between agents is challenging.

### Agent handoff pattern example

A telecommunications customer relationship management (CRM) solution uses handoff agents in its customer support web portal. An initial agent begins helping customers but discovers that it needs specialized expertise during the conversation. The initial agent passes the task to the most appropriate agent to address the customer's concern. Only one agent at a time operates on the original input, and the handoff chain results in a single result.

:::image type="complex" border="false" source="_images/handoff-pattern-example.svg" alt-text="Diagram that shows handoff orchestration where a triage agent intelligently routes questions to appropriate specialist agents based on dynamic analysis." lightbox="_images/handoff-pattern-example.svg":::
   The image includes five key sections. The Triage support agent section includes a model and general knowledge section, input, and a result. The Technical infrastructure agent section includes a result and a model, infrastructure knowledge, and tools section. The Financial resolution agent section includes a model, billing account knowledge, and billing API access section, and a result. The Account access agent section includes a result and a model and customer knowledge section. The Customer support employee section includes a result. Curved arrows flow from agent to agent and to the Customer support employee.
:::image-end:::

In this system, the *triage support agent* interprets the request and tries to handle common problems directly. When it reaches its limits, it hands off problems to other agents. For example, it hands off network problems to a *technical infrastructure agent* and hands off billing disputes to a *financial resolution agent*. Further handoffs occur within those agents when the current agent recognizes its own capability limits and knows another agent can better support the scenario.

Each agent is capable of completing the conversation if it determines that customer success is achieved or that no other agent can further benefit the customer. Some agents are also designed to hand off the user experience to a human support agent when the problem is important to solve but no AI agent currently has the capabilities to address it.

One example of a handoff instance is highlighted in the diagram. It begins with the triage agent that hands off the task to the technical infrastructure agent. The technical infrastructure agent then decides to hand off the task to the financial resolution agent, which ultimately redirects the task to customer support.

## Magentic orchestration

The magentic orchestration pattern is designed for open-ended and complex problems that don't have a predetermined plan of approach. Agents in this pattern typically have tools that help them make direct changes in external systems. The focus is as much on building and documenting the approach to solve the problem as it is on implementing that approach. The task list is dynamically built and refined as part of the workflow through collaboration between specialized agents and a magentic manager agent. As the context evolves, the magentic manager agent builds a task ledger to develop the approach plan with goals and subgoals, which is eventually finalized, followed, and tracked to complete the desired outcome.

The magentic orchestration is also known as *dynamic orchestration*, *task-ledger-based orchestration*, or *adaptive planning*.

:::image type="complex" border="false" source="_images/magentic-pattern.svg" alt-text="Diagram that shows magentic orchestration." lightbox="_images/magentic-pattern.svg":::
   The image shows a Manager agent section. It includes the input and a model. An arrow labeled Invoke agents points from the Manager agent to Agent 2. An arrow labeled Evaluate goal loop points to the Task complete section. An arrow labeled Yes points to the Results section, and an arrow labeled No points back to the Manager agent. An arrow points from the Manager agent to the Task and progress ledger section. A line connects the Task and progress ledger section to the Human participant section. A line that has three arrows points to Agent 1, Agent 2, an unlabeled section, and Agent n. A line connects Agent 1 to a section that reads Model and knowledge. A line connects Agent 2 to a section that reads Model, knowledge, and tools. A line connects Agent n to Model and tools. An arrow points from the section that reads Model, knowledge, and tools to External systems and from the Model and tools section to External systems.
:::image-end:::

The manager agent communicates directly with specialized agents to gather information as it builds and refines the task ledger. It iterates, backtracks, and delegates as many times as needed to build a complete plan that it can successfully carry out. The manager agent regularly checks whether the original request is satisfied or stalled and updates the ledger to adjust the plan.

In some ways, this orchestration pattern is an extension of the [group chat](#group-chat-orchestration) pattern. The magentic orchestration pattern focuses on an agent that builds a plan of approach, while other agents use tools to make changes in external systems instead of only using their knowledge stores to reach an outcome.

### When to use magentic orchestration

Consider the magentic pattern in the following scenarios:

- A complex or open-ended use case that has no predetermined solution path.  

- A requirement to consider input and feedback from multiple specialized agents to develop a valid solution path.

- A requirement for the AI system to generate a fully developed plan of approach that a human can review before or after implementation.

- Agents equipped with tools that interact with external systems, consume external resources, or can induce changes in running systems. A documented plan that shows how those agents are sequenced can be presented to a user before allowing the agents to follow the tasks.

### When to avoid magentic orchestration

Avoid this pattern in the following scenarios:

- The solution path is developed or should be approached in a deterministic way.

- There's no requirement to produce a ledger.

- The task has low complexity and a simpler pattern can solve it.

- The work is time-sensitive. The pattern focuses on building and debating viable plans, not optimizing for speed.

- You anticipate frequent stalls or infinite loops that don't have a clear path to resolution.

### Magentic orchestration example

A site reliability engineering (SRE) team built automation that uses magentic orchestration to handle low-risk incident response scenarios. When a service outage occurs within the scope of the automation, the system must dynamically create and implement a remediation plan. It does this without knowing the specific steps needed upfront.

:::image type="complex" border="false" source="_images/magentic-pattern-example.svg" alt-text="Diagram that shows magentic orchestration for SRE automation." lightbox="_images/magentic-pattern-example.svg":::
   The image shows the SRE automation manager agent section that includes input and a model. An arrow points from the SRE automation manager agent to the Task and progress ledger section. An arrow labeled Invoke knowledge and action agents points to a line that points to the Infrastructure, Diagnostics, Rollback, and Communication agents. An arrow labeled Evaluate goal loop points from the SRE automation manager agent to the Live-site issue resolved section. An arrow labeled Yes points from Live-site issue resolved to Result. The Task and progress ledger section includes a Resolution approach plan, Resolution task statuses, and the Live-site issue resolved section. An arrow labeled No points from the Live-site issue to the SRE automation manager agent. A line starts at the Diagnostic agent, goes through the Model and log and metrics knowledge section, and points to Workload systems. A line starts at the Infrastructure agent, goes through the model, graph knowledge, and CLI tools section, and joins the line that points to Workload systems. A line starts at the Rollback agent, goes through the model, Git access, CLI tools section, and points to Workload systems. A line starts at the Communication agent, goes through the Model and communication API access section, and points to the Human participant section.
:::image-end:::

When the automation detects a qualifying incident, the *magentic manager agent* begins by creating an initial task ledger with high-level goals such as restoring service availability and identifying the root cause. The manager agent then consults with specialized agents to gather information and refine the remediation plan.

1. The *diagnostics agent* analyzes system logs, performance metrics, and error patterns to identify potential causes. It reports findings back to the manager agent.

1. Based on diagnostic results, the manager agent updates the task ledger with specific investigation steps and consults the *infrastructure agent* to understand current system state and available recovery options.

1. The *communication agent* provides stakeholder notification capabilities, and the manager agent incorporates communication checkpoints and approval gates into the evolving plan according to the SRE team's escalation procedures.

1. As the scenario becomes clearer, the manager agent might add the *rollback agent* to the plan if deployment reversion is needed, or escalate to human SRE engineers if the incident exceeds the automation's scope.

Throughout this process, the manager agent continuously refines the task ledger based on new information. It adds, removes, or reorders tasks as the incident evolves. For example, if the diagnostics agent discovers a database connection problem, the manager agent might switch the entire plan from a deployment rollback strategy to a plan that focuses on restoring database connectivity.

The manager agent watches for excessive stalls in restoring service and guards against infinite remediation loops. It maintains a complete audit trail of the evolving plan and the implementation steps, which provides transparency for post-incident review. This transparency ensures that the SRE team can improve both the workload and the automation based on lessons learned.

## Choose a pattern

The following table compares the orchestration patterns to help you identify the approach that fits your coordination requirements.

| Pattern | Coordination | Routing | Best for | Watch out for |
| :------ | :----------- | :------ | :------- | :------------ |
| [Sequential](#sequential-orchestration) | Linear pipeline. Each agent processes the previous agent's output. | Deterministic, predefined order. | Step-by-step refinement with clear stage dependencies. | Failures in early stages propagate. No parallelism. |
| [Concurrent](#concurrent-orchestration) | Parallel pipeline. Agents work independently on the same input. | Deterministic or dynamic agent selection. | Independent analysis from multiple perspectives. Latency-sensitive scenarios. | Requires conflict resolution when results contradict. Resource-intensive. |
| [Group chat](#group-chat-orchestration) | Conversational pipeline. Agents contribute to a shared thread. | Chat manager controls turn order. | Consensus-building, brainstorming, and iterative maker-checker validation. | Conversation loops. Difficult to control with multiple agents. |
| [Handoff](#handoff-orchestration) | Dynamic delegation model. One active agent at a time. | Agents decide when to transfer control. | Tasks in which the right specialist emerges during processing. | Infinite handoff loops. Unpredictable routing paths. |
| [Magentic](#magentic-orchestration) | Plan-build-execute model. Manager agent builds and adapts a task ledger. | Manager agent assigns and reorders tasks dynamically. | Open-ended problems that don't have a predetermined solution path. | Slow to converge. Stalls on ambiguous goals. |

## Implementation considerations

To avoid common pitfalls and to ensure that your agent orchestration is robust, secure, and maintainable, review the following considerations when you implement any of these agent design patterns.

### Single agent, multitool

You can address some problems with a single agent if you give it sufficient access to tools and knowledge sources. For more information, see [Start with the right level of complexity](#start-with-the-right-level-of-complexity). Protocols like [Model Context Protocol](/azure/developer/ai/intro-agents-mcp) standardize how agents discover and invoke tools. As the number of knowledge sources and tools increases, it becomes difficult to provide a predictable agent experience. If a single agent can reliably solve your scenario, consider adopting that approach. Decision-making and flow-control overhead often exceed the benefits of breaking the task into multiple agents. However, security boundaries, network line of sight, and other factors can still render a single-agent approach infeasible.

### Deterministic routing

Some patterns require you to route flow between agents deterministically. Others rely on agents to choose their own routes. If your agents are defined in a no-code or low-code environment, you might not control those behaviors. If you define your agents in code by using SDKs like [Microsoft Agent Framework](/agent-framework/overview/agent-framework-overview) or Semantic Kernel, you have more control.

### Context and state management

AI agents often have limited context windows. This constraint can affect their ability to process complex tasks, especially as context grows with each agent transition. When you implement these patterns, decide what context the next agent requires to be effective. In some scenarios, you need the full, raw context gathered so far. In other scenarios, a compacted version, such as a summary of prior agent outputs, is more appropriate. If your agent can work without accumulated context and only requires a new instruction set, take that approach instead of providing context that doesn't help accomplish the agent's task.

In multiagent orchestrations, context windows can grow rapidly because each agent adds its own reasoning, tool results, and intermediate outputs. Monitor accumulated context size and use compaction techniques, such as summarization or selective pruning, between agents. These techniques can help you stay within model limits and avoid response quality degradation.

For orchestrations that span multiple user interactions or long-running tasks, persist shared state externally rather than relying only on in-memory context. To enable agents to resume work after interruptions, store task progress, intermediate results, and conversation history in a durable store. To reduce token overhead and privacy risks, scope persisted state to the minimum necessary information.

### Reliability

These patterns require properly functioning agents and reliable transitions between them. They often result in classical distributed systems problems such as node failures, network partitions, message loss, and cascading errors. Mitigation strategies should be in place to address these challenges. Agents and their orchestrators should do the following steps.

- Implement timeout and retry mechanisms.

- Include a graceful degradation implementation to handle one or more agents within a pattern faulting.

- Surface errors instead of hiding them, so downstream agents and orchestrator logic can respond appropriately.

- Validate agent output before you pass it to the next agent. Low-confidence, malformed, or off-topic responses can cascade through a pipeline. The orchestrator or the receiving agent should check output quality and either retry, request clarification, or halt the workflow to avoid bad input propagation.

- Consider circuit breaker patterns for agent dependencies.

- Design agents to be as isolated as is practical from each other, with single points of failure not shared between agents. For example:

  - Ensure compute isolation between agents.

  - Evaluate how a single model as a service (MaaS) endpoint or a shared knowledge store can introduce rate limiting when agents run in parallel.

- Use checkpoint features available in your SDK to help recover from an interrupted orchestration, such as from a fault or a new code deployment.

### Security

Implementing proper security mechanisms in these design patterns minimizes the risk of exposing your AI system to attacks or data leakage. Securing communication between agents and limiting each agent's access to sensitive data are key security design strategies. Consider the following security measures:

- Implement authentication and use secure networking between agents.

- Consider data privacy implications of agent communications.

- Design audit trails to meet compliance requirements.

- Design agents and their orchestrators to follow the principle of least privilege.

- Consider how to handle the user's identity across agents. Agents must have broad access to knowledge stores to handle requests from all users, but they must not return data that's inaccessible to the user. Security trimming must be implemented in every agent in the pattern.

- Apply content safety [guardrails](/azure/ai-foundry/guardrails/guardrails-overview) at multiple points in the orchestration, including user input, tool calls, tool responses, and final output. Intermediate agents might introduce or propagate harmful content.

### Cost optimization

Multiagent orchestrations multiply model invocations, and each agent consumes tokens for its instructions, context, reasoning, and tool interactions. The pattern that you choose directly affects cost. Sequential and handoff patterns invoke agents individually, which limits concurrent resource usage but accumulates cost across each step. Concurrent patterns increase throughput but they might spike resource consumption when multiple agents invoke models simultaneously. Magentic orchestrations are the most variable because the manager agent continues to iterate until it builds a viable plan, which makes it hard to predict the total cost.

To manage cost in multiagent orchestrations:

- Assign each agent a model that matches the complexity of its task. Not every agent requires the most capable model. Agents that perform classification, extraction, or formatting can often use smaller, less expensive models without a reduction in overall quality.

- To identify which agents or patterns are the most expensive, monitor token consumption per agent and per orchestration run. Use this data to target optimization efforts.

- To reduce the token volume passed through the orchestration, apply context compaction between agents. For more information, see [Context and state management](#context-and-state-management).

### Observability and testing

Distributing your AI system across multiple agents requires monitoring and testing each agent individually, and the system as a whole, to ensure proper functionality. When you design your observability and testing strategies, consider the following recommendations:

- Instrument all agent operations and handoffs. Troubleshooting distributed systems is a computer science challenge, and orchestrated AI agents are no exception.

- Track performance and resource usage metrics for each agent so that you can establish a baseline, find bottlenecks, and optimize.

- Design testable interfaces for individual agents.

- Implement integration tests for multiagent workflows. Agent outputs are nondeterministic, so use scoring rubrics or language-model-as-judge evaluations rather than exact-match assertions.

### Human participation

Several orchestration patterns support [HITL](/agent-framework/workflows/human-in-the-loop) involvement. Forms of HITL include observers in group chat, reviewers in maker-checker loops, and escalation targets in handoff and magentic orchestrations. Identify which points require human input, decide if that input is optional or mandatory, and determine whether the human response is an approval that advances the workflow or feedback that loops back to the agent for refinement. Mandatory gates make the orchestration synchronous at that step, so persist state at these checkpoints to resume operation without a replay of prior agent work. You can also scope HITL gates to specific tool invocations rather than full agent outputs so that the orchestration can proceed autonomously for low-risk actions. In this state, approval is required only for sensitive operations.

### Common pitfalls and antipatterns

Avoid these common mistakes when you implement agent orchestration patterns:

- Creating unnecessary coordination complexity by using a complex pattern when basic sequential or concurrent orchestration would suffice.

- Adding agents that don't provide meaningful specialization.

- Overlooking latency impacts of multiple-hop communication.

- Sharing mutable state between concurrent agents, which can result in transactionally inconsistent data because of assuming synchronous updates across agent boundaries.

- Using deterministic patterns for workflows that are inherently nondeterministic.

- Using nondeterministic patterns for workflows that are inherently deterministic.

- Ignoring resource constraints when you choose concurrent orchestration.

- Consuming excessive model resources because context windows grow as agents accumulate more information and consult their model to make progress on their task.

### Combining orchestration patterns

Applications sometimes require you to combine multiple orchestration patterns to address their requirements. For example, you might use sequential orchestration for the initial data processing stages and then switch to concurrent orchestration for parallelizable analysis tasks. Don't try to make one workflow fit into a single pattern when different stages of your workload have different characteristics and can benefit from each stage using a different pattern.

## Relationship to cloud design patterns

AI agent orchestration patterns extend and complement traditional [cloud design patterns](/azure/architecture/patterns/) by addressing the unique challenges of coordinating intelligent, autonomous components. Cloud design patterns focus on structural and behavioral concerns in distributed systems, but AI agent orchestration patterns specifically address the coordination of components with reasoning capabilities, learning behaviors, and nondeterministic outputs.

## Implementations

These orchestration patterns are technology-agnostic. You can implement them by using various SDKs and platforms, depending on your language, infrastructure, and integration requirements.

### Agent Framework

[Agent Framework](/agent-framework/overview) is an open-source SDK that can help you build multiagent orchestrations on the Microsoft platform. Agent Framework provides built-in support for the following [workflow orchestrations](/agent-framework/workflows/orchestrations):

- [Sequential orchestration](/agent-framework/workflows/orchestrations/sequential)
- [Concurrent orchestration](/agent-framework/workflows/orchestrations/concurrent)
- [Group chat orchestration](/agent-framework/workflows/orchestrations/group-chat)
- [Handoff orchestration](/agent-framework/workflows/orchestrations/handoff)
- [Magentic orchestration](/agent-framework/workflows/orchestrations/magentic)

> [!TIP]
> These orchestrations support HITL capabilities for workflow execution approvals and feedback.

For hands-on implementation, explore the Agent Framework [Declarative Workflows](https://github.com/microsoft/agent-framework/tree/main/declarative-agents/workflow-samples) on GitHub.

[Semantic Kernel](/semantic-kernel/frameworks/agent/agent-orchestration/) continues to provide agent orchestration support. If you already have Semantic Kernel workloads, follow the [migration guide](/agent-framework/migration-guide/from-semantic-kernel/) to transition to Agent Framework.

### Foundry Agent Service

[Foundry Agent Service](/azure/foundry/agents/overview) provides a managed, no-code approach to agent chains by using its [connected agents](/azure/foundry-classic/agents/how-to/connected-agents) functionality. The workflows in this service are primarily nondeterministic, which limits the range of patterns that you can fully implement. Use Agent Service when you need a managed environment and your orchestration requirements are straightforward.

### Other frameworks

The orchestration patterns described in this article aren't specific to Microsoft SDKs. Other frameworks that support multiagent orchestration include [LangChain](https://docs.langchain.com/oss/python/langchain/multi-agent#patterns), [CrewAI](https://docs.crewai.com/concepts/processes), and the [OpenAI Agents SDK](https://openai.github.io/openai-agents-python/multi_agent/). Each framework has its own approach to pattern implementation, and you can apply the architectural guidance in this article regardless of the SDK you choose.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Clayton Siemens](https://www.linkedin.com/in/clayton-siemens-3514896/) | Principal Content Developer - Azure Patterns & Practices

Other contributors:

- [Hemavathy Alaganandam](https://www.linkedin.com/in/hemaalaganandam/) | Principal Software Engineer
- [James Lee](https://www.linkedin.com/in/jameslee-7/) | Data Scientist 2
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Software Engineer
- [Mahdi Setayesh](https://www.linkedin.com/in/mahdi-setayesh-a03aa644/) | Principal Software Engineer
- [Mark Taylor](https://www.linkedin.com/in/mark-taylor-5043351/) | Principal Software Engineer
- [Yaniv Vaknin](https://www.linkedin.com/in/yaniv-vaknin-7a8324178/) | Senior Technical Specialist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

> [!div class="nextstepaction"]
> [Implement agent orchestration with Agent Framework](/agent-framework/workflows/orchestrations)
