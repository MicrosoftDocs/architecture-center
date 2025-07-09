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

The group chat orchestration enables multiple agents to to solve problems, make decisions, or validate work through participating in a shared conversation thread, where agents collaborate through discussion. A chat manager coordinates the flow, determining which agents can respond next and managing different interaction modes from collaborative brainstorming to structured quality gates.

:::image type="complex" source="_images/group-chat-pattern.svg" alt-text="Diagram showing group chat orchestration where multiple agents participate in a managed conversation with a central chat manager coordinating the discussion flow." lightbox="_images/group-chat-pattern.svg":::
TODO
:::image-end:::

This pattern addresses scenarios that are best accomplished through group discussion to reach decisions, whether through collaborative ideation, structured validation, or quality control processes. The pattern supports various interaction modes from free-flowing brainstorming to formal review workflows with fixed roles and approval gates.

This pattern works particularly well with human-in-the-loop scenarios where humans can optionally assume dynamic chat manager responsibilities and guide conversations toward productive outcomes.

### When to use group chat orchestration

Consider group chat orchestration when your situation might be able to be solved through spontaneous or guided collaboration or iterative maker-checker loops. And all of these can support real-time human oversight or participation. Because all of the agents are emitting output into a single accumulating thread, the pattern provides a good means for transparency and auditability.

#### Collaborative scenarios

- Creative brainstorming sessions where agents with different forced perspectives and knowledge sources build on each other's contributions to the chat
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
- Real-time processing requirements make discussion overhead unacceptable and overwhelm the benefits
- Clear hierarchical decision-making or deterministic workflows without discussion is more appropriate

Managing conversation flow and preventing infinite loops requires careful attention as control becomes harder to maintain with more agents. Consider limiting group chat orchestration to three or fewer agents to maintain effective control.

### Group chat orchestration example

A city parks and recreation department uses software that includes group chat orchestration for evaluating new park development proposals. The software reads the draft proposal and multiple specialist agents debate different community impact perspectives and work toward consensus on the proposal. This process is done before the proposal is opened for community review to help anticipate the feedback the proposal will face.

:::image type="complex" source="_images/group-chat-pattern-example.svg" alt-text="Diagram showing group chat orchestration for municipal park planning with specialist city planning agents." lightbox="_images/group-chat-pattern-example.svg":::
TODO
:::image-end:::

The system processes park development proposals by initiating a group consultation with specialized municipal agents who engage in the task from multiple civic perspectives.

- The *community engagement agent* evaluates accessibility requirements, anticipated resident feedback, and usage patterns to ensure equitable community access.
- The *environmental planning agent* assesses ecological impact, sustainability measures, native vegetation displacement, and environmental regulations compliance.
- The *budget and operations agent* analyzes construction costs, ongoing maintenance expenses, staffing requirements, and long-term operational sustainability.

The chat manager facilitates a structured debate where agents challenge each other's recommendations and defend their reasoning. The parks department employee participates in the chat thread to add insight and respond to knowledge requests made by the agents in real time. This process enables the employee to update the original proposal to address identified concerns and prepare for community feedback.

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

- [Sequential Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/sequential)
- [Concurrent Orchestration](/semantic-kernel/frameworks/agent/agent-orchestration/concurrent)
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
