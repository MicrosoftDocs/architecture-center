---
title: AI agent orchestration patterns
description: Learn about fundamental orchestration patterns for AI agent architectures, including concurrent, sequential, group chat, handoff, magnetic, and network patterns.
author: claytonsiemens77
ms.author: pnp
ms.date: 06/26/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
---

# AI agent orchestration patterns

AI agent systems are becoming increasingly sophisticated, moving beyond single-agent, many-tools implementations to multi-agent, few-tools orchestrations that can handle complex, collaborative tasks in a more reliable way. This guide examines fundamental orchestration patterns for multi-agent architectures, helping you choose the right approach for your specific requirements.

## Overview

Using multiple AI agents enables you to decompose complex problems into specialized units of work or knowledge, each handled by dedicated agents with specific capabilities. This approach offers several advantages over monolithic single-agent solutions.

- Specialization: Each agent can focus on a specific domain or capability, reducing code and prompt complexity.
- Scalability: Add or modify agents without redesigning the entire system.
- Maintainability: Each agent has a smaller surface area and tool usage to test and debug.
- Optimization: Each agent can use distinct models, task-solving approaches, knowledge, and tools to accomplish its outcomes.

The patterns described in this guide represent proven approaches to orchestrating multiple agents, each pattern optimized for different types of coordination requirements. These AI agent orchestration patterns complement and extend traditional [cloud design patterns](/azure/architecture/patterns/) by addressing the unique challenges of coordinating intelligent, autonomous components in AI-driven workload capabilities.

## Concurrent orchestration

The concurrent orchestration pattern executes multiple agents simultaneously on the same task, allowing each agent to provide independent analysis or processing from their unique perspective or specialization.

:::image type="complex" source="_images/concurrent-pattern.svg" alt-text="Diagram showing concurrent orchestration where multiple agents process the same input task simultaneously and their results are aggregated." lightbox="_images/concurrent-pattern.svg":::
The diagram shows concurrent orchestration with an input task positioned at the top center. Below the input, three agents are arranged horizontally: Agent A on the left, Agent B in the center, and Agent C on the right. Parallel arrows connect the input task to each agent, indicating simultaneous processing. Each agent produces a specialized output positioned directly below it. At the bottom center, an aggregation component receives arrows from all three agent outputs and produces a final combined result. The visual flow demonstrates how multiple agents work in parallel on the same input, with their diverse outputs converging into a unified result through the aggregation process.
:::image-end:::

This pattern addresses scenarios where you need diverse insights or approaches to the same problem. Instead of sequential processing, all agents work in parallel, reducing overall execution time while providing comprehensive coverage of the problem space. This pattern is similar to the fan-out/fan-in cloud design pattern.

### When to use concurrent orchestration

Consider the concurrent orchestration pattern when you have:

- Tasks that benefit from multiple independent perspectives
- Agents with different specializations that can all contribute to the same problem
- Time-sensitive scenarios where parallel processing reduces latency
- Validation requirements where multiple agents can cross-check results
- Analysis tasks requiring diverse expertise (technical, business, creative, and so on)

### When to avoid concurrent orchestration

Avoid this pattern when:

- Agents need to build upon each other's work or each other's cumulative context sequentially
- The task requires a specific order of operations or deterministic, reproducible results from being run in specific sequence
- Resource constraints, such as model quota, make parallel execution inefficient or impossible
- Agents cannot reliable coordinate changes to shared state as they run simultaneously
- There is no clear conflict resolution strategy to handle conflicting or contradictory results from each agent
- Result aggregation logic would be too complex or would lower the quality of the results

### Concurrent orchestration examples

**Code review validation**: A software development platform uses concurrent agents where security, performance, style, and documentation agents simultaneously analyze the same code submission. Each provides independent assessments that are aggregated into a comprehensive review dashboard, reducing overall processing time while ensuring thorough coverage.

**Investment research analysis**: A financial services firm deploys concurrent agents where fundamental, technical, sentiment, and ESG agents simultaneously analyze the same stock from their specialized perspectives, providing diverse, time-sensitive insights for rapid investment decisions.

### Implement concurrent orchestration

For Semantic Kernel based implementations, see [Concurrent Orchestration in Semantic Kernel](/semantic-kernel/frameworks/agent/agent-orchestration/concurrent).

## Sequential orchestration

The sequential orchestration pattern chains agents together in a predefined order, where each agent processes the output from the previous agent in the sequence, creating a pipeline of specialized transformations.

:::image type="complex" source="_images/sequential-pattern.svg" alt-text="Diagram showing sequential orchestration where agents process tasks in a defined pipeline order with output flowing from one agent to the next." lightbox="_images/sequential-pattern.svg":::
The diagram displays a vertical pipeline with an input document at the top flowing downward through three agents arranged in sequence. Agent A receives the input document and processes it, sending its output via a downward arrow to Agent B positioned below. Agent B receives Agent A's output, processes it further, and sends its result through another downward arrow to Agent C at the bottom. Agent C produces the final output shown below it. Each processing stage is connected by clear directional arrows that demonstrate the linear flow of information from one agent to the next, illustrating how each agent builds upon the work of the previous agent in the chain.
:::image-end:::

This pattern solves problems that require step-by-step processing, where each stage builds upon the previous one. It's ideal for workflows with clear dependencies and where the output quality improves through progressive refinement. This pattern is similar to the [Pipes and Filters](/azure/architecture/patterns/pipes-and-filters) cloud design pattern, but with AI agents rather than custom-coded processing components.

### When to use sequential orchestration

Consider the sequential orchestration pattern when you have:

- Multi-stage processes with clear dependencies and predictable workflow progression
- Data transformation pipelines, where each stage adds specific value that the next stage depends on
- Progressive refinement requirements, like "draft, review, polish" workflows
- Need to add a human-in-the-loop quality gate between steps in a process
- A system where the availability and performance characteristics of every agent in the pipeline is understood. Failures or delays in one agent's processing are tolerable for the pipeline.

### When to avoid sequential orchestration

Avoid this pattern when:

- Stages could be parallelized without impact to quality results
- Early stages might fail or produce low-quality output and there is no reasonable way to prevent future steps from processing against on accumulated errors
- Agents need to collaborate rather than hand off work
- The workflow requires backtracking or iteration
- Dynamic routing based on intermediate results is needed

### Sequential orchestration examples

**Legal contract drafting**: A law firm's document management software uses sequential agents where each stage requires the complete output from the previous stage: template creation, clause customization, regulatory compliance review, risk assessment. Each agent builds upon the work of the previous agent to create a comprehensive contract.

**Personalized curriculum development**: An educational technology company uses sequential agents to build individualized training programs: learning assessment, content mapping, pedagogical sequencing, student task scheduling. Each step depends on the complete output from the previous stage to create an effective learning experience.

### Implement sequential orchestration

For Semantic Kernel based implementations, see [Concurrent Orchestration in Semantic Kernel](/semantic-kernel/frameworks/agent/agent-orchestration/sequential).

## Group chat orchestration

The group chat orchestration enables multiple agents to participate in a shared conversation thread, where agents collaborate through discussion to solve problems, make decisions, or validate work. A chat manager coordinates the flow, determining which agent should respond next and managing different interaction modes from collaborative brainstorming to structured quality gates.

:::image type="complex" source="_images/group-chat-pattern.svg" alt-text="Diagram showing group chat orchestration where multiple agents participate in a managed conversation with a central chat manager coordinating the discussion flow." lightbox="_images/group-chat-pattern.svg":::
The diagram shows group chat orchestration with a shared conversation thread at the top center of the image. Below the conversation thread, a Group Chat Manager is positioned centrally, acting as the coordination hub. Four participants are arranged around the manager in a roughly circular pattern: Agent A positioned to the upper left, Agent B to the upper right, Agent C to the lower left, and a Human Participant to the lower right. Bidirectional arrows connect each participant to the central Group Chat Manager, demonstrating how the manager facilitates communication flow between all participants. The arrangement illustrates how the manager coordinates turn-taking and ensures orderly participation in the shared conversation, enabling collaborative problem-solving through managed group discussion.
:::image-end:::

This pattern addresses scenarios requiring multi-agent discussion to reach decisions, whether through collaborative ideation, structured validation, or quality control processes. It supports various interaction modes from free-flowing brainstorming to formal review workflows with fixed roles and approval gates.

### When to use group chat orchestration

Consider group chat orchestration when you have any of the following scenarios.

#### Collaborative scenarios

- Creative brainstorming sessions where agents build on each other's ideas
- Decision-making processes that benefit from debate and consensus-building
- Complex analysis requiring iterative refinement through discussion
- Multi-disciplinary problems requiring cross-functional dialogue

#### Validation and quality control scenarios

- Quality assurance requirements with structured review processes
- Compliance and regulatory validation requiring multiple expert perspectives
- Financial or high-risk decisions needing approval workflows with clear audit trails
- Content creation requiring editorial review with separation of concerns between creation and validation

#### General discussion scenarios

- Scenarios where human oversight or participation is needed within agent collaboration
- Problems requiring multiple expert perspectives to converge through conversation
- Situations where the decision-making process itself needs to be transparent and auditable

### When to avoid group chat orchestration

Avoid this pattern when:

- Simple task delegation or linear pipeline processing is sufficient
- Single agent processing can adequately handle the requirements
- Real-time processing requirements make discussion overhead unacceptable
- Clear hierarchical decision-making without discussion is more appropriate
- Communication overhead would overwhelm the benefits
- Managing conversation flow and preventing infinite loops would be too complex
- Deterministic workflows are required without any iterative discussion

### Group chat orchestration examples

**Collaborative business strategy planning**: A consulting firm uses group chat orchestration where market research, financial analysis, and competitive intelligence agents collaborate in a shared discussion to develop comprehensive business strategies. The agents build on each other's insights, debate different market approaches, and iteratively refine strategic recommendations through open conversation, with a human strategy director participating to provide industry expertise and guide the collaborative process.

**Financial transaction approval workflow**: An investment bank uses group chat orchestration for high-value transactions where a deal structuring agent presents proposed arrangements, while risk assessment and compliance agents participate in a structured discussion. The chat manager enforces a formal approval workflow where each reviewing agent must explicitly approve or reject with detailed reasoning, ensuring no transaction proceeds without proper validation and creating full audit trails for regulatory compliance.

## Handoff orchestration

The handoff orchestration enables dynamic delegation of tasks between specialized agents, where each agent can assess the task at hand and decide whether to handle it themselves or transfer it to a more appropriate agent based on the context and requirements.

:::image type="complex" source="_images/handoff-pattern.svg" alt-text="Diagram showing handoff orchestration where a triage agent intelligently routes tasks to appropriate specialist agents based on dynamic analysis." lightbox="_images/handoff-pattern.svg":::
The diagram illustrates handoff orchestration with an input task at the top flowing downward into a central Triage Agent positioned in the middle of the diagram. From the Triage Agent, decision pathways branch outward to three specialist agents arranged horizontally below: Specialist Agent A on the left, Specialist Agent B in the center, and Specialist Agent C on the right. Each specialist agent connects downward to its respective output area. The Triage Agent serves as the decision point, evaluating the incoming task and selecting the most appropriate specialist agent based on the task requirements. The routing demonstrates dynamic delegation where only one specialist agent is activated for each specific task, rather than predetermined routing rules.
:::image-end:::

This pattern addresses scenarios where the optimal agent for a task isn't known upfront, or where the task requirements become clear only during processing. It enables intelligent routing and ensures tasks reach the most capable agent.

### When to use handoff orchestration

Consider the agent handoff pattern when you have:

- Agents with specialized knowledge or tools, but the number of agents needing to be involved or order of those agents cannot be pre-determined
- Scenarios where expertise requirements emerge during processing resulting in dynamic task routing based on content analysis
- Multi-domain problems requiring different specialists
- Logical relationships and signals that can be pre-determined to inform when one agent has reached its capability limit

### When to avoid handoff orchestration

Avoid this pattern when:

- The appropriate agents and their order are always known upfront
- Task routing is simple and deterministically rule-based, not based on the dynamic context window or dynamic interpretation
- Decision-making and handoff overhead exceeds the benefits of breaking the task into multiple agents over a single agent with multiple connected knowledge stores and tools
- Suboptimal routing decisions would lead to poor or frustrating user experience
- Avoiding an infinite handoff loop or avoiding excessive bouncing between agents will be challenging

### Agent handoff pattern example

A telecommunications CRM solution uses handoff agents where a general support agent begins helping customers but discovers specialized expertise needs through the conversation. Network issues get handed off to technical infrastructure agents, billing disputes to financial resolution agents, and so on. Further handoffs occur within those agents when the current agent recognizes its own capability limits and is aware of another agent that can support the scenario better. Every agent is capable of completing the conversation if it feels there are no more agents that could further benefit the customer. Likewise, some agents are defined to hand off the user experience to a human support agent in cases that are important to solve, but no AI agents yet have the capabilities to address the problem.

TODO: IMAGE

## Magnetic orchestration

The magnetic orchestration pattern combines the flexibility of autonomous agent collaboration with the structure of a central orchestrator. A lead agent (the "magnetizer") coordinates and directs specialized agents while allowing them to communicate directly with each other when needed, creating a dynamic balance between centralized control and distributed collaboration.

:::image type="complex" source="_images/magnetic-pattern.svg" alt-text="Diagram showing magnetic orchestration where a lead agent coordinates specialized agents while allowing flexible direct communication between specialists." lightbox="_images/magnetic-pattern.svg":::
The diagram displays magnetic orchestration with a Lead Agent positioned at the top center as the primary coordinator. Below the Lead Agent, three specialist agents are arranged horizontally: Agent A on the left, Agent B in the center, and Agent C on the right. Bidirectional coordination arrows connect the Lead Agent to each of the three specialist agents, demonstrating the oversight and coordination relationship. Additionally, direct communication lines connect each specialist agent to the other specialists, forming a mesh of peer-to-peer connections. An input task enters through the Lead Agent, which dynamically coordinates the specialists while allowing them to collaborate directly with each other. Each specialist agent produces its own specialized output, illustrating the hybrid structure that combines centralized coordination with distributed collaboration.
:::image-end:::

This pattern addresses complex scenarios where you need both strategic coordination and tactical flexibility. The lead agent maintains overall direction and can intervene when needed, while specialized agents can collaborate directly for efficiency. This pattern is inspired by Microsoft's MagneticOne framework and balances the benefits of centralized coordination with the agility of peer-to-peer collaboration.

### When to use magnetic orchestration

Consider magnetic orchestration when you have:

- Complex workflows requiring both centralized coordination and flexible agent collaboration
- Need for dynamic task distribution with intelligent agent selection based on task requirements
- Scenarios where specialized agents benefit from direct communication while maintaining overall coordination
- Quality control requirements that benefit from both oversight and peer validation
- Tasks requiring adaptive collaboration patterns that can't be predetermined
- Systems where agent capabilities and availability change dynamically

### When to avoid magnetic orchestration

Avoid this pattern when:

- Simple sequential or concurrent processing is sufficient for your requirements
- Strict hierarchical control is required without any peer-to-peer communication
- The overhead of managing both centralized and distributed coordination exceeds benefits
- Agent interactions are predictable and don't require dynamic collaboration patterns
- Real-time constraints make the coordination overhead unacceptable
- Simple supervisor or handoff patterns adequately address your coordination needs

### Magnetic orchestration examples

**Intelligent customer support platform**: A customer service system uses magnetic orchestration where an orchestrator agent analyzes incoming support requests and dynamically selects appropriate specialist agents. Simple billing questions activate only the billing agent, while complex technical issues might activate network, security, and account management agents together. The specialist agents can collaborate directly when needed (like security consulting with network specialists), while the orchestrator maintains overall case management and ensures resolution quality.

**Research analysis platform**: A scientific research platform uses magnetic orchestration where the orchestrator evaluates research papers and dynamically assembles relevant specialist agents. Statistical analysis papers activate methodology and data validation agents, while experimental biology papers activate domain expertise, ethical review, and replication analysis agents. The specialist agents can collaborate directly on cross-cutting concerns while the orchestrator ensures comprehensive coverage and maintains research quality standards.

## Network orchestration

The network orchestration creates interconnected agents that can communicate directly with multiple other agents, forming a mesh of collaborative relationships without strict hierarchical constraints.

:::image type="complex" source="_images/network-pattern.svg" alt-text="Diagram showing network orchestration where agents form a fully connected mesh allowing any agent to communicate directly with any other agent without central coordination." lightbox="_images/network-pattern.svg":::
The diagram illustrates network orchestration with four agents arranged in a diamond formation: Agent A at the top, Agent B on the right, Agent C at the bottom, and Agent D on the left. Every agent connects to every other agent through bidirectional communication lines, creating a complete mesh topology where each agent has direct connections to all other agents. Multiple input tasks can enter through any of the agents, and output streams emerge from different agents based on their processing. The interconnected structure demonstrates a fully distributed system with no central authority, where all agents have equal capability to initiate communications and coordinate with any other agent. The mesh configuration enables dynamic collaboration patterns and information flow between any combination of agents as needed for the task at hand.
:::image-end:::

This pattern addresses scenarios requiring flexible, peer-to-peer collaboration where agents need to share information, coordinate activities, or collaborate on complex problems without rigid structural constraints. This pattern shares similarities with the [Choreography](/azure/architecture/patterns/choreography) cloud design pattern, where components coordinate workflow among themselves without centralized control.

### When to use network orchestration

Consider network orchestration when you have:

- Collaborative problem-solving requiring peer interaction with maximum flexibility in agent interactions
- Scenarios where any agent might need to communicate with any other with natural collaboration and knowledge sharing
- Dynamic coalition formation for specific tasks that supports emergent behaviors and innovation
- Distributed decision-making requirements across the network
- Complex interdependencies between agent capabilities that are resilient to individual agent failures
- Innovation scenarios requiring creative collaboration

### When to avoid network orchestration

Avoid this pattern when:

- Clear hierarchical structures are more appropriate
- Simple linear or parallel processing suffices
- Communication overhead would overwhelm the benefits or high communication overhead is unacceptable
- Coordination complexity becomes unmanageable or complex coordination and synchronization would be challenging to debug and troubleshoot
- Deterministic workflows are required or behavior is difficult to predict or control
- Potential for communication loops or deadlocks is unacceptable

### Network orchestration examples

**Collaborative research discovery**: A pharmaceutical research consortium uses network agents where a molecular analysis agent discovers compounds and directly shares findings with drug interaction, clinical trial design, and regulatory pathway agents. Each agent freely collaborates with any other relevant agent as discoveries emerge, enabling rapid knowledge transfer and innovative solutions that couldn't be predicted through predetermined workflows.

**Creative content generation**: A multimedia production company uses network agents where concept, visual design, music, and narrative agents dynamically collaborate and share insights based on emerging artistic directions. All agents can form coalitions and adapt to the creative process rather than being forced through rigid structures, fostering innovation through flexible peer-to-peer collaboration.

## Combining orchestration patterns

Applications often require combining multiple orchestration patterns to address complex requirements. Here are common pattern combinations:

### Sequential orchestration with concurrent stages

Implement sequential orchestration where individual stages use concurrent processing. For example, a content creation workflow might have sequential stages (research, writing, review), but each stage could use concurrent agents with different specializations.

**When to use**: Multi-stage processes where individual stages benefit from parallel processing but overall workflow must be sequential.

**Example**: Software development pipeline where the testing stage concurrently runs unit tests, integration tests, and security scans before proceeding to deployment.

### Group chat with validation workflows

Combine group chat orchestration with structured approval workflows where multiple agents participate in discussion but follow formal validation protocols. The chat manager enforces specific roles and approval gates while maintaining the collaborative benefits of group discussion.

**When to use**: Systems requiring both collaborative analysis and mandatory validation, such as financial services or healthcare applications where expertise and compliance must be balanced.

**Example**: Insurance claims processing where multiple specialist agents (medical, legal, financial) discuss complex claims in a group chat format, but the chat manager enforces that each specialist must provide explicit approval with reasoning before final claim resolution.

### Magnetic orchestration coordinating mixed patterns

Use magnetic orchestration to coordinate different pattern types for different workload categories. The lead agent can dynamically select appropriate orchestration approaches - some tasks might follow sequential processing while others use concurrent or network orchestration patterns.

**When to use**: Complex systems handling diverse workload types that require different coordination approaches with intelligent pattern selection.

**Example**: Manufacturing quality control where a magnetic orchestrator coordinates sequential testing for safety-critical components, concurrent analysis for routine inspections, and network collaboration for complex failure investigations, adapting the coordination approach based on the specific quality requirements and available specialist agents.

## Implementation considerations

When implementing any of these agent design patterns, there are key considerations to address. If your agents are defined defined in a no/low-code environment, you might not have control over these behaviors. If your agents are defined in code using SDKs like Semantic Kernel, then you'll have more control. Consider the risk involved with lack of control in these areas in no-code agent solutions.

### Context window

- Terminate and start anew, carry context forward, etc.

### Reliability

- Implement appropriate timeout and retry mechanisms
- Design graceful degradation when one or more agents within a pattern fail
- Consider circuit breaker patterns for agent dependencies

### Security

- Implement authentication and use secure networking between agents
- Consider data privacy implications of agent communications
- Design audit trails for compliance requirements

### Operational excellence

- Instrument agent interactions and handoffs
- Track performance metrics for each agent
- Monitor per agent resource utilization and bottlenecks
- Design testable interfaces for individual agents
- Implement integration tests for multi-agent workflows

### Additional design area considerations

Depending on the level of control you have in your agent implementation, consider these design areas in your architecture.

#### Agent communication

- Synchronous API calls between agents
- Event-driven architectures for loose coupling

#### State management

- Prefer stateless agents for easier scaling and recovery
- Centralized state stores for shared context
- Distributed caching for performance optimization

#### System boundaries

- Define clear interfaces between agents and external systems
- Implement proper abstraction layers for technology independence
- Plan for agent lifecycle management (start, stop, updates, scale)

#### Data flow patterns

- Request-response for synchronous interactions
- Publish-subscribe for event-driven coordination
- Streaming for continuous data processing
- Batch processing for high-volume scenarios

### Common pitfalls and anti-patterns

Avoid these common mistakes when implementing agent orchestration patterns:

#### Over-orchestration

- Creating unnecessary coordination complexity
- Using magnetic orchestration when simple sequential or concurrent orchestration suffices
- Adding agents that don't provide meaningful specialization

#### Communication overhead

- Implementing full network orchestration when simpler coordination works
- Creating chatty interfaces between agents
- Not considering latency impacts of multi-hop communication

#### State synchronization issues

- Sharing mutable state between concurrent agents
- Not handling eventual consistency in distributed scenarios
- Assuming synchronous updates across agent boundaries

#### Orchestration pattern misalignment

- Using deterministic patterns for inherently non-deterministic workflows
- Applying rigid sequential orchestration to collaborative scenarios
- Choosing network orchestration for simple linear processing

#### Scalability blind spots

- Not considering agent granularity for scaling requirements
- Creating bottlenecks in Magnetic or Handoff routing logic
- Ignoring resource constraints when choosing concurrent orchestration

## Relationship to cloud design patterns

AI agent orchestration patterns extend and complement traditional [cloud design patterns](/azure/architecture/patterns/) by addressing the unique challenges of coordinating intelligent, autonomous components. While cloud design patterns focus on structural and behavioral concerns in distributed systems, AI agent orchestration patterns specifically address the coordination of components with reasoning capabilities, learning behaviors, and non-deterministic outputs.

## Implementations in Microsoft Semantic Kernel

The Agent Framework within Semantic Kernel provides support for many of these [Agent Orchestration Patterns](/semantic-kernel/frameworks/agent/agent-orchestration/).

- [Concurrent Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/concurrent)
- [Sequential Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/sequential)
- [Group Chat Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/group-chat)
- [Handoff Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/handoff)
- [Magentic Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/magentic)

Many of these patterns can also be found in [AutoGen](https://microsoft.github.io/autogen/stable/user-guide/core-user-guide/design-patterns/intro.html).

## Next steps

To begin implementing AI agent design patterns:

1. **Assess your requirements** using the orchestration pattern selection guide
2. **Start simple** with proven orchestration patterns before considering custom implementations
3. **Prototype and measure** different orchestration patterns for your specific use case
4. **Implement proper observability** from the beginning
5. **Plan for evolution** as your requirements and understanding mature

For hands-on implementation, explore the [Semantic Kernel multi-agent orchestration samples](https://github.com/microsoft/semantic-kernel/tree/main/python/samples/getting_started_with_agents) that demonstrate these patterns in practice.
