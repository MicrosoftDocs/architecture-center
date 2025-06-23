---
title: AI agent design patterns
description: Learn about six fundamental design patterns for AI agent architectures, including concurrent, sequential, handoff, supervisor, network, and maker-checker patterns.
author: claytonsiemens77
ms.author: pnp
ms.date: 06/23/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
---

# AI agent design patterns

AI agent systems are becoming increasingly sophisticated, moving beyond single-agent implementations to multi-agent orchestrations that can handle complex, collaborative tasks. This guide examines six fundamental design patterns for multi-agent architectures, helping you choose the right approach for your specific requirements.

## Overview

Using multiple AI agents enables you to break down complex problems into specialized components, each handled by dedicated agents with specific capabilities. This approach offers several advantages over monolithic single-agent solutions:

- **Specialization**: Each agent can focus on a specific domain or capability
- **Scalability**: Add or modify agents without redesigning the entire system
- **Resilience**: Failure in one agent doesn't necessarily break the entire workflow, unless you've deemed it critical
- **Maintainability**: Smaller surface area to test and debug

The patterns described in this guide represent proven approaches to orchestrating multiple agents, each optimized for different types of coordination requirements. These AI agent patterns complement and extend traditional [cloud design patterns](/azure/architecture/patterns/) by addressing the unique challenges of coordinating intelligent, autonomous components in AI-driven workload capabilities.

## Concurrent agents pattern

The concurrent agents pattern executes multiple agents simultaneously on the same task, allowing each agent to provide independent analysis or processing from their unique perspective or specialization.

:::image type="complex" source="_images/concurrent-pattern.svg" alt-text="Diagram showing the concurrent agents pattern where multiple agents process the same task simultaneously." lightbox="_images/concurrent-pattern.svg":::
The diagram illustrates the concurrent agents pattern with an input task box at the top center, followed by three parallel agent boxes labeled Agent A, Agent B, and Agent C positioned horizontally below the input. Each agent connects directly to the input task via arrows, indicating simultaneous processing. Below the agents, three output boxes show the results from each agent (Output A, Output B, Output C), connected by arrows from their respective agents. All three outputs then converge with arrows pointing to a final aggregated result box at the bottom center, demonstrating how multiple agents process the same task concurrently and their results are combined into a unified output.
:::image-end:::

This pattern addresses scenarios where you need diverse insights or approaches to the same problem. Instead of sequential processing, all agents work in parallel, reducing overall execution time while providing comprehensive coverage of the problem space. This pattern is similar to the fan-out/fan-in cloud design pattern.

### When to use the concurrent agents pattern

Consider the concurrent agents pattern when you have:

- Tasks that benefit from multiple independent perspectives
- Agents with different specializations that can all contribute to the same problem
- Time-sensitive scenarios where parallel processing reduces latency
- Validation requirements where multiple agents can cross-check results
- Analysis tasks requiring diverse expertise (technical, business, creative, and so on)

### When to avoid the concurrent agents pattern

Avoid this pattern when:

- Agents need to build upon each other's work or each other's cumulative context sequentially
- The task requires a specific order of operations or deterministic, reproducible results from being run in specific sequence
- Resource constraints, such as model quota, make parallel execution inefficient or impossible
- Agents cannot reliable coordinate changes to shared state as they run simultaneously
- There is no clear conflict resolution strategy to handle conflicting or contradictory results from each agent
- Result aggregation logic would be too complex or would lower the quality of the results

### Concurrent agents pattern examples

**Code review validation**: A software development platform uses concurrent agents where security, performance, style, and documentation agents simultaneously analyze the same code submission. Each provides independent assessments that are aggregated into a comprehensive review dashboard, reducing overall processing time while ensuring thorough coverage.

**Investment research analysis**: A financial services firm deploys concurrent agents where fundamental, technical, sentiment, and ESG agents simultaneously analyze the same stock from their specialized perspectives, providing diverse, time-sensitive insights for rapid investment decisions.

## Sequential agents pattern

The sequential agents pattern chains agents together in a predefined order, where each agent processes the output from the previous agent in the sequence, creating a pipeline of specialized transformations.

:::image type="complex" source="_images/sequential-pattern.svg" alt-text="Diagram showing the sequential agents pattern where agents process tasks in a predefined order." lightbox="_images/sequential-pattern.svg":::
The diagram shows a vertical flow representing the sequential agents pattern. Starting from the top, an input task box connects via an arrow to Agent A below it. Agent A then connects to Agent B through a downward arrow, and Agent B connects to Agent C in the same manner. Finally, Agent C connects via an arrow to the output box at the bottom. This linear arrangement demonstrates how the task flows through each agent in a predetermined sequence, with each agent processing the output from the previous agent before passing it to the next one.
:::image-end:::

This pattern solves problems that require step-by-step processing, where each stage builds upon the previous one. It's ideal for workflows with clear dependencies and where the output quality improves through progressive refinement. This pattern is similar to the [Pipes and Filters](/azure/architecture/patterns/pipes-and-filters) cloud design pattern, but with AI agents rather than custom-coded processing components.

### When to use the sequential agents pattern

Consider the sequential agents pattern when you have:

- Multi-stage processes with clear dependencies and predictable workflow progression
- Data transformation pipelines, where each stage adds specific value that the next stage depends on
- Progressive refinement requirements, like "draft, review, polish" workflows
- Need to add a human-in-the-loop quality gate between steps in a process
- A system where the availability and performance characteristics of every agent in the pipeline is understood. Failures or delays in one agent's processing are tolerable for the pipeline.

### When to avoid the sequential agents pattern

Avoid this pattern when:

- Stages could be parallelized without impact to quality results
- Early stages might fail or produce low-quality output and there is no reasonable way to prevent future steps from processing against on accumulated errors
- Agents need to collaborate rather than hand off work
- The workflow requires backtracking or iteration
- Dynamic routing based on intermediate results is needed

### Sequential agents pattern examples

**Legal contract drafting**: A law firm's document management software uses sequential agents where each stage requires the complete output from the previous stage: template creation, clause customization, regulatory compliance review, risk assessment. Each agent builds upon the work of the previous agent to create a comprehensive contract.

**Personalized curriculum development**: An educational technology company uses sequential agents to build individualized training programs: learning assessment, content mapping, pedagogical sequencing, student task scheduling. Each step depends on the complete output from the previous stage to create an effective learning experience.

## Agent handoff pattern

The agent handoff pattern enables dynamic delegation of tasks between agents, where each agent can assess the task at hand and decide whether to handle it themselves or transfer it to a more appropriate agent based on the context and requirements.

:::image type="complex" source="_images/handoff-pattern.svg" alt-text="Diagram showing the agent handoff pattern where a triage agent routes tasks to appropriate specialists." lightbox="_images/handoff-pattern.svg":::
The diagram depicts a agent handoff pattern with an input task at the top connecting to a triage agent below it. The triage agent sits at the center and has three arrows extending from it to three specialist agents positioned horizontally: Specialist Agent A on the left, Specialist Agent B in the center, and Specialist Agent C on the right. Each specialist agent connects downward to its respective output box (Output A, Output B, Output C). This arrangement shows how the triage agent analyzes the incoming task and routes it to the most appropriate specialist agent based on the task requirements, with only one specialist handling each specific task.
:::image-end:::

This pattern addresses scenarios where the optimal agent for a task isn't known upfront, or where the task requirements become clear only during processing. It enables intelligent routing and ensures tasks reach the most capable agent.

### When to use the agent handoff pattern

Consider the agent handoff pattern when you have:

- Agents with specialized knowledge or tools, but the number of or order of those agents cannot be pre-determined
- Scenarios where expertise requirements emerge during processing resulting in dynamic task routing based on content analysis
- Multi-domain problems requiring different specialists

### When to avoid the agent handoff pattern

Avoid this pattern when:

- The appropriate agent is always known upfront
- Task routing is simple and rule-based
- Decision-making and handoff overhead exceeds the benefits of specialization
- Suboptimal routing decisions would lead to poor user experience
- The problem could result in infinite handoff loops

### Agent handoff pattern examples

**Scientific research analysis**: A research institution uses handoff agents where an initial data processing agent analyzes experimental results but discovers specialized interpretation needs that only emerge during analysis. Statistical anomalies get handed off to methodology validation specialists, unexpected correlations to theoretical modeling agents, demonstrating how the initial agent cannot predetermine which specialist is needed.

**Dynamic customer service escalation**: A telecommunications CRM solution uses handoff agents where a general support agent begins helping customers but discovers specialized expertise needs through conversation. Network issues get handed off to technical infrastructure agents, billing disputes to financial resolution agents, with handoffs occurring when the current agent recognizes capability limits.

## Agent supervisor pattern

The agent supervisor pattern employs a central coordinating agent that manages and directs multiple worker agents, making high-level decisions about task distribution, progress monitoring, and result integration.

:::image type="complex" source="_images/supervisor-pattern.svg" alt-text="Diagram showing the agent supervisor pattern where a central agent coordinates multiple worker agents." lightbox="_images/supervisor-pattern.svg":::
The diagram illustrates the agent supervisor pattern with an input task at the top connecting to a supervisor agent positioned at the center. From the supervisor agent, bidirectional arrows extend to three worker agents arranged horizontally below: Worker Agent A on the left, Worker Agent B in the center, and Worker Agent C on the right. Each worker agent connects downward to its corresponding output (Output A, Output B, Output C). The bidirectional arrows between the supervisor and workers indicate ongoing coordination and communication, demonstrating how the supervisor manages task distribution, monitors progress, and coordinates the work of multiple agents.
:::image-end:::

This pattern solves coordination challenges in complex multi-agent systems by providing centralized decision-making and oversight. It enables sophisticated orchestration while maintaining clear responsibility boundaries. This pattern draws inspiration from the [Scheduler Agent Supervisor](/azure/architecture/patterns/scheduler-agent-supervisor) cloud design pattern, extending it with AI capabilities for intelligent coordination and decision-making.

### When to use the agent supervisor pattern

Consider the agent supervisor pattern when you have:

- Complex workflows requiring centralized coordination and decision-making
- Need for dynamic task distribution based on agent availability with strategic oversight of overall progress
- Quality control and oversight requirements with validation capabilities
- Resource management and load balancing needs
- Scenarios requiring strategic planning and tactical execution
- Integration of results from multiple specialized agents with clear hierarchical structure and responsibilities

### When to avoid the agent supervisor pattern

Avoid this pattern when:

- Simple peer-to-peer collaboration is sufficient
- Centralized control creates bottlenecks or the supervisor agent becomes a single point of failure
- Overhead of coordination exceeds benefits or added complexity in supervisor logic is unacceptable
- Agent autonomy is more important than coordination
- Risk of over-centralization reducing agent autonomy or potential bottleneck for all communications would impact performance

### Agent supervisor pattern examples

**Customer data integration platform**: A retail company's CRM system uses a supervisor agent that coordinates data processing across customer touchpoints by distributing validation and enrichment tasks to specialized workers based on priorities and capacity. The supervisor monitors processing queues, reallocates resources during volume spikes, and integrates insights to maintain comprehensive customer views.

**Enterprise security operations center**: A cybersecurity firm uses a supervisor agent that orchestrates threat response by coordinating specialized security agents based on evolving landscapes and resource availability. The supervisor dynamically adjusts priorities based on threat severity, balances workloads, and maintains comprehensive visibility requiring strategic coordination.

## Network-of-agents pattern

The network-of-agents pattern creates interconnected agents that can communicate directly with multiple other agents, forming a mesh of collaborative relationships without strict hierarchical constraints.

:::image type="complex" source="_images/network-pattern.svg" alt-text="Diagram showing the network-of-agents pattern where agents communicate directly with each other in a mesh topology." lightbox="_images/network-pattern.svg":::
The diagram shows a network-of-agents pattern with three agents arranged in a triangular formation. Agent A is positioned at the top, with Agent B at the bottom left and Agent C at the bottom right. Bidirectional arrows connect all three agents to each other, forming a mesh topology where Agent A connects to both Agent B and Agent C, and Agent B also connects directly to Agent C. An input task box at the top connects to Agent A, and output boxes are positioned below each agent (Output A, Output B, Output C). This interconnected structure demonstrates how agents can communicate and collaborate directly with each other without requiring central coordination.
:::image-end:::

This pattern addresses scenarios requiring flexible, peer-to-peer collaboration where agents need to share information, coordinate activities, or collaborate on complex problems without rigid structural constraints. This pattern shares similarities with the [Choreography](/azure/architecture/patterns/choreography) cloud design pattern, where components coordinate workflow among themselves without centralized control.

### When to use the network-of-agents pattern

Consider the network-of-agents pattern when you have:

- Collaborative problem-solving requiring peer interaction with maximum flexibility in agent interactions
- Scenarios where any agent might need to communicate with any other with natural collaboration and knowledge sharing
- Dynamic coalition formation for specific tasks that supports emergent behaviors and innovation
- Distributed decision-making requirements across the network
- Complex interdependencies between agent capabilities that are resilient to individual agent failures
- Innovation scenarios requiring creative collaboration

### When to avoid the network-of-agents pattern

Avoid this pattern when:

- Clear hierarchical structures are more appropriate
- Simple linear or parallel processing suffices
- Communication overhead would overwhelm the benefits or high communication overhead is unacceptable
- Coordination complexity becomes unmanageable or complex coordination and synchronization would be challenging to debug and troubleshoot
- Deterministic workflows are required or behavior is difficult to predict or control
- Potential for communication loops or deadlocks is unacceptable

### Network-of-agents pattern examples

**Collaborative research discovery**: A pharmaceutical research consortium uses network agents where a molecular analysis agent discovers compounds and directly shares findings with drug interaction, clinical trial design, and regulatory pathway agents. Each agent freely collaborates with any other relevant agent as discoveries emerge, enabling rapid knowledge transfer and innovative solutions that couldn't be predicted through predetermined workflows.

**Creative content generation**: A multimedia production company uses network agents where concept, visual design, music, and narrative agents dynamically collaborate and share insights based on emerging artistic directions. All agents can form coalitions and adapt to the creative process rather than being forced through rigid structures, fostering innovation through flexible peer-to-peer collaboration.

## Maker-checker pattern

The maker-checker pattern implements a two-stage workflow where one agent (maker) creates or executes work, and another agent (checker) reviews, validates, or approves the output before final completion.

:::image type="complex" source="_images/maker-checker-pattern.svg" alt-text="Diagram showing the maker-checker pattern where one agent creates work and another reviews it." lightbox="_images/maker-checker-pattern.svg":::
The diagram illustrates the maker-checker pattern with an input task at the top connecting to a maker agent positioned on the left side. The maker agent produces output that flows to a checker agent positioned on the right side. The checker agent has two possible outputs: an approved result that flows downward to a final output box, and a feedback loop that connects back to the maker agent, indicated by an arrow labeled "Feedback for revision." This arrangement demonstrates the iterative process where the maker creates work, the checker reviews it, and either approves the work or provides feedback for revision until the work meets quality standards.
:::image-end:::

This pattern addresses quality assurance, compliance, and risk management requirements by ensuring that no single agent has complete control over critical processes. It provides built-in validation and error detection.

### When to use the maker-checker pattern

Consider the maker-checker pattern when you have:

- Quality assurance requirements with built-in error detection
- Compliance and regulatory constraints requiring risk reduction through dual control
- Financial or high-risk transactions needing clear accountability and audit trails
- Content creation requiring editorial review with separation of concerns between creation and validation
- Code development with mandatory peer review
- Critical decisions requiring validation

### When to avoid the maker-checker pattern

Avoid this pattern when:

- Speed is more important than accuracy
- Single agent review is sufficient or overhead of dual processing isn't justified
- Checker agent lacks domain expertise to effectively validate
- Real-time processing requirements preclude review delays or doubled processing time and resources are unacceptable
- Potential bottlenecks in the review stage would impact performance
- Risk of checker agent becoming rubber stamp or coordination overhead between maker and checker is excessive
- Possible conflicts requiring resolution mechanisms would be too complex

### Maker-checker pattern examples

**High-value financial transactions**: An investment bank uses maker-checker agents for merger and acquisition transactions where a deal structuring agent (maker) creates complex financial arrangements while an independent validation agent (checker) reviews every aspect against compliance frameworks and risk policies before approval, ensuring no single agent can authorize transactions worth hundreds of millions of dollars.

**Pharmaceutical regulatory submissions**: A biotech company uses maker-checker agents where a clinical data analysis agent (maker) compiles drug approval packages while a regulatory compliance agent (checker) independently validates every component against FDA guidelines and safety requirements, providing mandatory dual control for submissions that determine whether medications reach patients.

## Custom pattern

The custom pattern represents tailored agent architectures designed for specific use cases that don't fit neatly into standard patterns. These implementations combine elements from multiple patterns or introduce novel interaction models.

:::image type="complex" source="_images/custom-pattern.svg" alt-text="Diagram showing the custom pattern with domain-specific agent arrangements and interactions." lightbox="_images/custom-pattern.svg":::
The diagram represents a custom pattern with a complex arrangement of interconnected agents. At the top, an input task connects to Agent A, which has bidirectional connections to both Agent B positioned to its right and Agent D positioned below it. Agent B connects unidirectionally to Agent C on its right. Agent D has a bidirectional connection to Agent E, which is positioned to its right. Agent C connects downward to a final output box at the bottom right. This intricate network of connections demonstrates how custom patterns can combine elements from multiple standard patterns, creating specialized workflows tailored to specific domain requirements and business logic.
:::image-end:::

This pattern addresses unique requirements that standard patterns can't accommodate effectively, enabling optimization for specific domains, constraints, or innovative approaches that haven't been standardized yet.

### When to use the custom pattern

Consider the custom pattern when you have:

- Unique requirements not addressed by standard patterns with perfect fit for specific requirements
- Domain-specific constraints requiring specialized approaches for optimal performance in targeted scenarios
- Performance requirements demanding custom optimization
- Innovative use cases requiring novel interaction models with innovation opportunities and competitive advantage
- Legacy system integration requiring adapted patterns with complete control over agent interactions
- Regulatory or security requirements necessitating custom controls with ability to incorporate domain-specific optimizations

### When to avoid the custom pattern

Avoid this pattern when:

- Standard patterns adequately address your needs
- Development and maintenance costs outweigh benefits or high development and maintenance overhead is unacceptable
- Team lacks expertise to design and maintain custom orchestration or increased complexity and debugging difficulty would be problematic
- Simplicity and maintainability are priorities
- Future scalability requires standard pattern compatibility or limited reusability across different scenarios is a concern
- Documentation and knowledge transfer challenges or risk of over-engineering simple problems

### Custom pattern examples

**Autonomous drone swarm coordination**: An aerospace company creates custom agents for search and rescue operations where drone agents must simultaneously coordinate flight paths, share environmental data, form dynamic sub-swarms, and maintain communication relays. The custom pattern combines network communication, supervisor behavior, and handoff capabilities to address unique constraints of autonomous flight operations that no standard pattern can accommodate.

**Real-time language translation platform**: A global communications company implements custom agents for multilingual video conferences where translation, cultural context, audio synchronization, and quality assurance agents work together. The custom pattern requires specialized protocols for handling overlapping speech, cultural sensitivity validation, temporal synchronization, and graceful degradation due to complex linguistic, cultural, and technical constraints.

## Combining patterns

Applications often require combining multiple patterns to address complex requirements. Here are common pattern combinations:

### Sequential agents with concurrent stages

Implement a Sequential pipeline where individual stages use Concurrent processing. For example, a content creation workflow might have sequential stages (research, writing, review), but each stage could use concurrent agents with different specializations.

**When to use**: Multi-stage processes where individual stages benefit from parallel processing but overall workflow must be sequential.

**Example**: Software development pipeline where the testing stage concurrently runs unit tests, integration tests, and security scans before proceeding to deployment.

### Handoff with maker-checker validation

Combine Handoff routing with maker-checker validation at specialist endpoints. Tasks are routed to appropriate specialists who then follow maker-checker protocols for quality assurance.

**When to use**: Systems requiring both intelligent routing and mandatory validation, such as financial services or healthcare applications.

**Example**: Insurance claims processing where a triage agent routes claims to appropriate specialists (auto, home, health), and each specialist follows maker-checker validation before final approval.

### Supervisor coordinating mixed patterns

Use a Supervisor to orchestrate different pattern types for different workload categories. Some tasks might follow Sequential processing while others use Concurrent or Network-of-agents patterns.

**When to use**: Complex systems handling diverse workload types that require different coordination approaches.

**Example**: Manufacturing quality control where a supervisor coordinates sequential testing for safety-critical components, concurrent analysis for routine inspections, and network collaboration for complex failure investigations.

## Implementation considerations

When implementing any of these agent design patterns, there are key considerations to address. If your agents are defined defined in a no/low-code environment, you might not have control over these behaviors. If your agents are defined in code using SDKs like Semantic Kernel, then you'll have more control. Consider the risk involved with lack of control in these areas in no-code agent solutions.

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

Avoid these common mistakes when implementing agent patterns:

#### Over-orchestration

- Creating unnecessary coordination complexity
- Using agent supervisor patterns when simple sequential or concurrent agents patterns suffice
- Adding agents that don't provide meaningful specialization

#### Communication overhead

- Implementing full Network-of-agents patterns when simpler coordination works
- Creating chatty interfaces between agents
- Not considering latency impacts of multi-hop communication

#### State synchronization issues

- Sharing mutable state between concurrent agents
- Not handling eventual consistency in distributed scenarios
- Assuming synchronous updates across agent boundaries

#### Pattern misalignment

- Using deterministic patterns for inherently non-deterministic workflows
- Applying rigid sequential agents patterns to collaborative scenarios
- Choosing Network-of-agents patterns for simple linear processing

#### Scalability blind spots

- Not considering agent granularity for scaling requirements
- Creating bottlenecks in Supervisor or Handoff routing logic
- Ignoring resource constraints when choosing Concurrent agents patterns

## Relationship to cloud design patterns

AI agent design patterns extend and complement traditional [cloud design patterns](/azure/architecture/patterns/) by addressing the unique challenges of coordinating intelligent, autonomous components. While cloud design patterns focus on structural and behavioral concerns in distributed systems, AI agent patterns specifically address the orchestration of components with reasoning capabilities, learning behaviors, and non-deterministic outputs.

## Next steps

To begin implementing AI agent design patterns:

1. **Assess your requirements** using the pattern selection guide
2. **Start simple** with proven patterns before considering custom implementations
3. **Prototype and measure** different patterns for your specific use case
4. **Implement proper observability** from the beginning
5. **Plan for evolution** as your requirements and understanding mature

For hands-on implementation, explore the [Semantic Kernel multi-agent orchestration samples](https://github.com/microsoft/semantic-kernel/tree/main/python/samples/getting_started_with_agents) that demonstrate these patterns in practice.
