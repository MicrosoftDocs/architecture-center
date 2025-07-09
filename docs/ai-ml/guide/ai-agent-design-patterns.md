---
title: AI agent orchestration patterns
description: Learn about fundamental orchestration patterns for AI agent architectures, including sequential, concurrent, group chat, handoff, and magentic patterns.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/08/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
---

# AI agent orchestration patterns

AI agent systems are sophisticated and are often pushing the limits of what single-agent with access to many tools can provide. These systems instead use multi-agent orchestrations that can handle complex, collaborative tasks in a reliable way. This guide examines a few fundamental orchestration patterns for multi-agent architectures, so you can choose the correct approach for your specific requirements.

## Overview

Using multiple AI agents enables you to decompose complex problems into specialized units of work or knowledge, each handled by dedicated agents with specific capabilities. This approach offers several advantages over monolithic single-agent solutions.

- Specialization: Each agent can focus on a specific domain or capability, reducing code and prompt complexity.
- Scalability: Add or modify agents without redesigning the entire system.
- Maintainability: Each agent has a smaller surface area and tool usage to test and debug.
- Optimization: Each agent can use distinct models, task-solving approaches, knowledge, tools, and even compute to accomplish its outcomes.

The patterns described in this guide represent proven approaches to orchestrating multiple agents, each pattern optimized for different types of coordination requirements. These AI agent orchestration patterns complement and extend traditional [cloud design patterns](/azure/architecture/patterns/) by addressing the unique challenges of coordinating autonomous components in AI-driven workload capabilities.

## Sequential orchestration

The sequential orchestration pattern chains agents together in a predefined, linear order, where each agent processes the output from the previous agent in the sequence, creating a pipeline of specialized transformations.

:::image type="complex" source="_images/sequential-pattern.svg" alt-text="Diagram showing sequential orchestration where agents process tasks in a defined pipeline order with output flowing from one agent to the next." lightbox="_images/sequential-pattern.svg":::
TODO
:::image-end:::

This pattern solves problems that require step-by-step processing, where each stage builds upon the previous one. It's ideal for workflows with clear dependencies and where the output quality improves through progressive refinement. This pattern is similar to the [Pipes and Filters](/azure/architecture/patterns/pipes-and-filters) cloud design pattern, but with AI agents rather than custom-coded processing components. The choice of which agent invoked next deterministically defined as part of the workflow and is not a choice given to agents in the process.

### When to use sequential orchestration

Consider the sequential orchestration pattern when you have:

- Multi-stage processes with clear linear dependencies and predictable workflow progression
- Data transformation pipelines, where each stage adds specific value that the next stage depends on
- Stages that cannot be parallelized
- Progressive refinement requirements, like "draft, review, polish" workflows
- A system where the availability and performance characteristics of every agent in the pipeline is understood. Failures or delays in one agent's processing are tolerable for the overall task to be accomplished.

### When to avoid sequential orchestration

Avoid this pattern when:

- Stages could be parallelized without impact to quality results or shared state contention
- Process that involves a only a few stages
- Early stages might fail or produce low-quality output and there is no reasonable way to prevent future steps from processing against accumulated errors
- Agents need to collaborate rather than hand off work
- The workflow requires backtracking or iteration
- Dynamic routing based on intermediate results is needed

### Sequential orchestration example

A law firm's document management software uses sequential agents for contract generation. The intelligent application processes requests through a pipeline of four specialized agents. The sequential and pre-defined pipeline steps ensures that each agent works with the complete output from the previous stage.

:::image type="complex" source="_images/sequential-pattern-example.svg" alt-text="Diagram showing sequential orchestration where a document creation pipeline is implemented with agents." lightbox="_images/sequential-pattern-example.svg":::
TODO
:::image-end:::

1. First, the *template selection agent* receives client specifications (contract type, jurisdiction, parties involved) and selects the appropriate base template from the firm's library.
1. Then, the *clause customization agent* takes the selected template and modifies standard clauses based on negotiated business terms, including payment schedules and liability limitations.
1. Next, the *regulatory compliance agent* then reviews the customized contract against applicable laws and industry-specific regulations.
1. Finally, the *risk assessment agent* performs comprehensive analysis of the complete contract, evaluating liability exposure and dispute resolution mechanisms while providing risk ratings and protective language recommendations.

## Concurrent orchestration

The concurrent orchestration pattern executes multiple agents simultaneously on the same task, allowing each agent to provide independent analysis or processing from their unique perspective or specialization.

:::image type="complex" source="_images/concurrent-pattern.svg" alt-text="Diagram showing concurrent orchestration where multiple agents process the same input task simultaneously and their results are aggregated." lightbox="_images/concurrent-pattern.svg":::
TODO
:::image-end:::

This pattern addresses scenarios where you need diverse insights or approaches to the same problem. Instead of sequential processing, all agents work in parallel, reducing overall execution time while providing comprehensive coverage of the problem space. This pattern is similar to the fan-out/fan-in cloud design pattern. Often the results of each agent are aggregated to return a final result, but this is not required. Each agent can independently produce its own results within the workload, such as invoking tools to accomplish tasks or update different data stores in parallel.

Agents operate independently, and do not hand off results to each other. Agents might invoke additional agents, using their own orchestration approach, as part of their own independent processing. The available agents for processing must be made known to the initiator agent. This pattern supports both deterministically calling all registered agents or allows the initiator agent to dynamically choose among the available agents which ones to invoke.

### When to use concurrent orchestration

Consider the concurrent orchestration pattern when you have:

- Tasks that can be done in parallel, either as a fixed set of agents or dynamically chosen based on the given task requirements
- Tasks that benefit from multiple independent perspectives or different specializations (technical, business, creative, and so on) that can all contribute to the same problem. This is typically found in scenarios that feature:

  - Brainstorming
  - Ensemble reasoning
  - Quorum and voting based decisions

- Time-sensitive scenarios where parallel processing reduces latency

### When to avoid concurrent orchestration

Avoid this pattern when:

- Agents need to build upon each other's work or the cumulative context sequentially
- The task requires a specific order of operations or deterministic, reproducible results from being run in specific sequence
- Resource constraints, such as model quota, make parallel execution inefficient or impossible
- Agents cannot reliably coordinate changes to shared state or external systems as they run simultaneously
- There is no clear conflict resolution strategy to handle conflicting or contradictory results from each agent
- Result aggregation logic would be too complex or would lower the quality of the results

### Concurrent orchestration example

A financial services firm has an intelligent application that uses concurrent agents that specialize in different analyses to simultaneously evaluate the same stock from their specialized perspectives, providing diverse, time-sensitive insights for rapid investment decisions.

:::image type="complex" source="_images/concurrent-pattern-example.svg" alt-text="Diagram showing concurrent orchestration to evaluate a stock." lightbox="_images/concurrent-pattern-example.svg":::
TODO
:::image-end:::

The system processes stock analysis requests by dispatching the same ticker symbol to four specialized agents running in parallel.

- The *fundamental analysis agent* evaluates financial statements, revenue trends, and competitive positioning to assess intrinsic value.
- The *technical analysis agent* examines price patterns, volume indicators, and momentum signals to identify trading opportunities.
- The *sentiment analysis agent* processes news articles, social media mentions, and analyst reports to gauge market sentiment and investor confidence.
- The *ESG (environmental, social, and governance) agent* reviews environmental impact, social responsibility, and governance practice reports to evaluate sustainability risks and opportunities.

These independent results are then combined into a comprehensive investment recommendation which enables portfolio managers to make informed decisions quickly.

## Group chat orchestration

The group chat orchestration pattern enables multiple agents to solve problems, make decisions, or validate work by participating in a shared conversation thread where agents collaborate through discussion. A chat manager coordinates the flow, determining which agents can respond next and managing different interaction modes from collaborative brainstorming to structured quality gates.

:::image type="complex" source="_images/group-chat-pattern.svg" alt-text="Diagram showing group chat orchestration where multiple agents participate in a managed conversation with a central chat manager coordinating the discussion flow." lightbox="_images/group-chat-pattern.svg":::
TODO
:::image-end:::

This pattern addresses scenarios that are best accomplished through group discussion to reach decisions, whether through collaborative ideation, structured validation, or quality control processes. The pattern supports various interaction modes from free-flowing brainstorming to formal review workflows with fixed roles and approval gates.

This pattern works particularly well with human-in-the-loop scenarios where humans can optionally assume dynamic chat manager responsibilities and guide conversations toward productive outcomes.

### When to use group chat orchestration

Consider group chat orchestration when your situation can be solved through spontaneous or guided collaboration or iterative maker-checker loops. All of these approaches support real-time human oversight or participation. Because all agents and humans in the loop emit output into a single accumulating thread, the pattern provides transparency and auditability.

#### Collaborative scenarios

- Creative brainstorming sessions where agents with different perspectives and knowledge sources build on each other's contributions to the chat
- Decision-making processes that benefit from debate and consensus-building
- Decision making requiring iterative refinement through discussion
- Multi-disciplinary problems requiring cross-functional dialogue

#### Validation and quality control scenarios

- Quality assurance requirements with structured review processes and iteration
- Compliance and regulatory validation requiring multiple expert perspectives
- Content creation requiring editorial review with separation of concerns between creation and validation

### When to avoid group chat orchestration

Avoid this pattern when:

- Simple task delegation or linear pipeline processing is sufficient
- Real-time processing requirements make discussion overhead unacceptable
- Clear hierarchical decision-making or deterministic workflows without discussion are more appropriate
- The chat manager has no objective way to determine if the task is complete

Managing conversation flow and preventing infinite loops requires careful attention as control becomes harder to maintain with more agents. Consider limiting group chat orchestration to three or fewer agents to maintain effective control.

### Maker-checker loops

The maker-checker loop is a specific type of group chat orchestration where one agent (the "maker") creates or proposes something, and another agent (the "checker") provides critical feedback. This pattern is iterative with the checker agent pushing the conversation back to the maker agent to make updates and go through the process again. While the group chat pattern doesn't require agents to *take turns* chatting, the maker-checker loop does require a formal turn-based sequence driven by the chat manager.

### Group chat orchestration example

A city parks and recreation department uses software that includes group chat orchestration for evaluating new park development proposals. The software reads the draft proposal, and multiple specialist agents debate different community impact perspectives and work toward consensus on the proposal. This process occurs before the proposal is opened for community review to help anticipate the feedback the proposal will receive.

:::image type="complex" source="_images/group-chat-pattern-example.svg" alt-text="Diagram showing group chat orchestration for municipal park planning with specialist city planning agents." lightbox="_images/group-chat-pattern-example.svg":::
TODO
:::image-end:::

The system processes park development proposals by initiating a group consultation with specialized municipal agents who engage in the task from multiple civic perspectives.

- The *community engagement agent* evaluates accessibility requirements, anticipated resident feedback, and usage patterns to ensure equitable community access.
- The *environmental planning agent* assesses ecological impact, sustainability measures, native vegetation displacement, and environmental regulations compliance.
- The *budget and operations agent* analyzes construction costs, ongoing maintenance expenses, staffing requirements, and long-term operational sustainability.

The chat manager facilitates structured debate where agents challenge each other's recommendations and defend their reasoning. The parks department employee participates in the chat thread to add insight and respond to knowledge requests made by the agents in real time. This process enables the employee to update the original proposal to address identified concerns and better prepare for community feedback.

## Handoff orchestration

The handoff orchestration enables dynamic delegation of tasks between specialized agents, where each agent can assess the task at hand and decide whether to handle it themselves or transfer it to a more appropriate agent based on the context and requirements.

:::image type="complex" source="_images/handoff-pattern.svg" alt-text="Diagram showing handoff orchestration where an agent intelligently routes tasks to appropriate specialist agents based on dynamic analysis." lightbox="_images/handoff-pattern.svg":::
TODO
:::image-end:::

This pattern addresses scenarios where the optimal agent for a task isn't known upfront, or where the task requirements become clear only during processing. It enables intelligent routing and ensures tasks reach the most capable agent. Agents in this pattern do not typically work in parallel, full control is transfered from agent to agent.

### When to use handoff orchestration

Consider the agent handoff pattern when you have:

- Tasks that require specialized knowledge or tools, but the number of tasks needing to be involved or order of those tasks cannot be pre-determined.
- Scenarios where expertise requirements emerge during processing resulting in dynamic task routing based on content analysis
- Multi-domain problems requiring different specialists that can operate one at a time
- Logical relationships and signals that can be pre-determined to inform when one agent has reached its capability limit and which agent should next handle the task

### When to avoid handoff orchestration

Avoid this pattern when:

- The appropriate agents and their order are always known upfront
- Task routing is simple and deterministically rule-based, not based on the dynamic context window or dynamic interpretation
- Suboptimal routing decisions would lead to poor or frustrating user experience
- Multiple operations should be running concurrently to address the task
- Avoiding an infinite handoff loop or avoiding excessive bouncing between agents will be challenging

### Agent handoff pattern example

A telecommunications CRM solution uses handoff agents in their customer support web portal. A initial agent begins helping customers but discovers specialized expertise needs through the conversation, and hands the conversation to the most likely agent to address the customer concern. Only one agent at a time is operating on the original input.

:::image type="complex" source="_images/handoff-pattern-example.svg" alt-text="Diagram showing handoff orchestration where a triage agent intelligently routes questions to appropriate specialist agents based on dynamic analysis." lightbox="_images/group-chat-pattern-example.svg":::
TODO
:::image-end:::

In this system, the *triage support agent* interprets the request and tries to handle common problems itself. When it's reached its limits, the agent hands network issues to a *technical infrastructure agent*, billing disputes to a *financial resolution agent*, and so on. Further handoffs occur within those agents when the current agent recognizes its own capability limits and is aware of another agent that can support the scenario better. Every agent is capable of completing the conversation if it feels it reached customer success or if it feels there are no more agents that could further benefit the customer. Likewise, some agents are defined to hand off the user experience to a human support agent in cases that are important to solve but no AI agents yet have the capabilities to address the problem.

## Magentic orchestration

TODO

:::image type="complex" source="_images/magentic-pattern.svg" alt-text="Diagram showing magentic orchestration where TODO." lightbox="_images/magentic-pattern.svg":::
TODO
:::image-end:::

TODO

### When to use magentic orchestration

TODO

### When to avoid magentic orchestration

TODO

### Magentic orchestration examples

TODO

## Combining orchestration patterns

Applications sometimes require combining multiple orchestration patterns to address complex requirements.

TODO

:::image type="complex" source="_images/magentic-pattern-example.svg" alt-text="Diagram showing magentic orchestration where TODO." lightbox="_images/magentic-pattern.svg":::
TODO
:::image-end:::

## Implementation considerations

When implementing any of these agent design patterns, there are many considerations to address. Reviewing these considerations can help you avoid common pitfalls and ensure your agent orchestration is robust, secure, and maintainable.

### Single agent, multi-tool

Some problems can be addressed without the use of a orchestration of agents if one agent can be given enough access to tools and knowledge sources. As the number of knowledge sources and tools increasing, providing a predictable experience with the agent can be hard to achieve. If you situation can be reliably solved with a single agent, consider approaching your solution from that perspective. Decision-making and flow control overhead can often exceed the benefits of breaking the task into multiple agents. However, security boundaries, network line of sight, and other considerations might make a single agent approach still ultimately infeasible

### Deterministic routing

Some of these patterns require routing the flow between agents in a deterministic way while others depend on the agents to make their own routing choices. If your agents are defined defined in a no/low-code environment, you might not have control over these behaviors. If your agents are defined in code using SDKs like Semantic Kernel, then you'll have more control.

### Context window

AI agents often have limited context windows, which can impact their ability to process complex tasks. When you implement these patterns decide what context is required for the next agent in the orchestration to be effective. In some scenarios, you might need the full, raw context gathered up to this point. In some scenarios, a summarized or truncated version of the context is more appropriate. If your agent can work off of no accumulated context, just a new instruction set prefer that approach instead of providing context that will not be helpful to accomplishing the agent's task.

### Reliability

These patterns all require properly operating agents and reliable transitions between the agents. These patterns often result in classical distributed systems problems: node failures, network partitions, message loss, cascading errors. It's important to have mitigation strategies in place. Agents and their orchestrators should:

- Implement timeout and retry mechanisms.
- Have a graceful degradation implementation to handle one or more agents within a pattern faulting.
- Never hide errors, but instead surface them so downstream agents and orchestrator logic can respond appropriately.
- Consider circuit breaker patterns for agent dependencies.
- Be designed so agents are as isolated as practicable from each other, with single points of failure not shared between agents. For example consider:
  - Compute isolation between agents
  - How usage of a single models-as-a-service (MaaS) model or a single knowledge store could result in rate limiting when agents are concurrently running.
- Use checkpoint features available in your SDK to help recover from an interrupted orchestration, such as from a fault or from a new code deployment.

### Security

TODO, intro

- Implement authentication and use secure networking between agents.
- Consider data privacy implications of agent communications.
- Design audit trails for compliance requirements.
- Design agents and their orchestrators to follow the principle of least privilege.
- Consider how the end user's identity should be handled across agents. Agents must themselves have broad access to knowledge stores to handle the requests from all users but agents should not return data that should be inaccessible to the user. Security trimming must be implemented in every agent in the pattern.

### Observability and testing

TODO, intro

- Instrument all agent operations and handoffs. Troubleshooting distributed systems is a computer science challenge, and orchestrated AI agents are no exception.
- Track performance and resource utilization metrics for each agent so you can baseline, find bottlenecks, and optimize.
- Design testable interfaces for individual agents.
- Implement integration tests for multi-agent workflows.

### Common pitfalls and anti-patterns

Avoid these common mistakes when implementing agent orchestration patterns:

- Creating unnecessary coordination complexity by using a complex pattern when a simple sequential or concurrent orchestration suffices.
- Adding agents that don't provide meaningful specialization.
- Not considering latency impacts of multi-hop communication.
- Sharing mutable state between concurrent agents that can result in transactionally inconsistent data due to assuming synchronous updates across agent boundaries.
- Using deterministic patterns for inherently non-deterministic workflows.
- Using non-deterministic patterns for inherently deterministic workflows.
- Ignoring resource constraints when choosing concurrent orchestration.
- Excessive model consumption due to growing context windows as agents accumulate more information and consult their model to make progress on their task.

## Relationship to cloud design patterns

AI agent orchestration patterns extend and complement traditional [cloud design patterns](/azure/architecture/patterns/) by addressing the unique challenges of coordinating intelligent, autonomous components. While cloud design patterns focus on structural and behavioral concerns in distributed systems, AI agent orchestration patterns specifically address the coordination of components with reasoning capabilities, learning behaviors, and non-deterministic outputs.

## Implementations in Microsoft Semantic Kernel

The Agent Framework within Semantic Kernel provides support for many of these [Agent Orchestration Patterns](/semantic-kernel/frameworks/agent/agent-orchestration/).

- [Sequential Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/sequential)
- [Concurrent Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/concurrent)
- [Group Chat Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/group-chat)
- [Handoff Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/handoff)
- [Magentic Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/magentic)

Many of these patterns can also be found in [AutoGen](https://microsoft.github.io/autogen/stable/user-guide/core-user-guide/design-patterns/intro.html).

## Next steps

To begin implementing AI agent design patterns:

1. Assess your requirements using this orchestration pattern selection guide.
1. Start simple with proven orchestration patterns before considering custom implementations.
1. Prototype and measure different orchestration patterns for your specific use case.
1. Implement proper observability from the beginning.
1. Plan for evolution as your requirements and understanding mature.

For hands-on implementation, explore some [Semantic Kernel multi-agent orchestration samples](https://github.com/microsoft/semantic-kernel/tree/main/python/samples/getting_started_with_agents) on GitHub that demonstrate these patterns in practice.
