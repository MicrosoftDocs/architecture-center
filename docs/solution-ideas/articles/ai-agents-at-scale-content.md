[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Use this solution to dynamically select relevant agents from a large pool of agents during a conversation. It addresses the main challenges of building a system that can flexibly include agents, explores orchestration strategies, and discusses considerations for scaling to hundreds of agents.

The solution uses Microsoft Foundry, Azure AI Search, Azure OpenAI, and other Azure services to support scalable agent-based interactions.

Use this approach when many agents need to handle open-ended client conversations and you can't predict the conversation domain.

## Architecture

![Architecture diagram for dynamic AI agents at scale](../media/ai-agents-at-scale-architecture.png)
*Download a [Visio file](https://arch-center.azureedge.net/<file-name>.vsdx) of this architecture.*

## Workflow

The following workflow corresponds to the previous diagram:

1. A user submits a query through the client application.

1. The **AI agent service** receives the request and passes it to the **orchestrator**, which delegates to the **agent selector** to identify the most relevant agents to invoke.

1. The **agent selector** queries the **semantic cache** in Azure AI Search. The cache uses vector similarity to compare the query against stored sample utterances and return candidate agents. The agent selector scores and filters those results. If one agent's score exceeds the confidence threshold, the system invokes that agent directly. Otherwise, a large language model (LLM) chooses from the shortlisted candidates.

1. The **agent factory** instantiates the selected agent based on its registered implementation, such as code module, YAML template, or other representation, and returns a ready-to-use agent instance.

1. The selected **agent** processes the request by using **Azure OpenAI** models hosted in **Foundry** or external tools. The response flows back through the orchestration layer to the user.

1. When an agent needs a public endpoint, it calls external APIs or Model Context Protocol (MCP) servers through the NAT gateway.

## Components

- [Foundry](/azure/foundry/what-is-foundry) is an end-to-end platform for building, deploying, and managing AI applications. In this solution, it hosts Azure OpenAI models and provides a unified environment for agent development, model orchestration, and evaluation.

- [Azure AI Search](/azure/search/search-what-is-azure-search) is a cloud search service with built-in AI capabilities for vector search and semantic ranking. In this solution, it acts as the semantic cache that stores sample agent utterances and uses vector similarity to identify candidate agents for user queries.

- [Azure OpenAI](/azure/ai-services/openai/overview) is a managed AI service that provides REST API access to OpenAI language models and embeddings. In this solution, agents use these models to process requests, generate responses, and select appropriate agents from shortlisted candidates.

- [Azure Managed Redis](/azure/redis/overview) is a fully managed, in-memory data store based on Redis Enterprise that enables high-throughput and low-latency data access. In this solution, it stores conversation context and chat history to support multiturn interactions with minimal latency.

- [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview) is an application performance management (APM) service that provides monitoring and diagnostics for cloud applications. In this solution, it collects telemetry from all components via OpenTelemetry. This process enables end-to-end observability of agent interactions, performance metrics, and system health.

- [Azure Monitor](/azure/azure-monitor/overview) is a monitoring solution that collects, analyzes, and responds to telemetry from cloud and on-premises environments. In this solution, it provides dashboards, alerting, and log analytics for tracking system performance and detecting anomalies.

- [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) is a tool for editing and running log queries against data in Azure Monitor Logs. In this solution, it stores execution logs and enables KQL queries to correlate agent behavior and identify conversation-level anomalies.

- [Azure NAT Gateway](/azure/nat-gateway/nat-overview) is a managed Network Address Translation (NAT) service that provides outbound internet connectivity for virtual networks. In this solution, it provides a static outbound IP address for agents that call external APIs or MCP servers that require a public endpoint.

## Scenario details

Use this solution to build and scale multiagent AI systems that can grow to hundreds of agents. The orchestration framework dynamically selects the right agents for each conversation, so you don't need to define workflows in advance. Supporting services add memory, observability, and evaluation across the system.

### Potential use cases

**Virtual smart assistant ecosystems:** These ecosystems evolve rapidly as you add more agents to support users across operations. As you automate more devices and workflows, you need a structured mechanism to build and manage a large network of agents and to keep costs under control.

**Agentic AI ecosystems:** Use this solution for agenetic AI ecosystems that have the following characteristics:

  - **Many collaborating agents:** You expect 10 or more agents to operate in a shared environment. The agents perform diverse functions, often aren't aware of each other, and don't collaborate directly.

  - **Unpredictable agent selection:** You can't determine in advance which agent handles a given request. The system must make the right agents available on demand so that conversations continue without interruption.

  - **Continued growth:** You expect the number of agents to keep increasing, and you need costs to remain predictable as you scale.

### When not to use this solution

Avoid this solution in the following scenarios:

- **Limited number of agents:** The system has fewer than five agents, so the complexity of dynamic orchestration outweighs the benefit.

- **Deterministic orchestration:** The orchestration follows a predefined workflow or handoff process, so you don't need dynamic agent selection.

- **Distinct agent roles:** The agents have clearly distinct roles with no overlap, and the orchestration exposes only specific agents for selection (for example, principal agents that have predefined child or connected agents). In this case, an LLM doesn't need to perform dynamic selection.

### Key challenges

#### Prepare semantic cache data

This solution depends on a well-constructed semantic cache that contains sample agent utterances. Represent each agent's capabilities with diverse sample utterances so that the cache covers the full range of requests that the agent handles. To support reliable agent invocatio, include at least five distinct utterances for every capability. Complete this step before you onboard an agent into the system.

#### Dynamic inclusion of agents

Suppose your organization runs several domain-specific agents and you want to create a unified conversational AI that enables clients to interact with any of them without knowing which agent handles which task. A single conversation might engage multiple agents to address multi-intent requests. For example, the request "Help me book a conference room on the Yosemite floor, and notify parking services that I'll need five spots for a customer meeting on the 26th" engages both the ConferenceBookingAgent and the ParkingServiceAgent. When you have a small number of agents or tools (fewer than 20), a [function calling](/semantic-kernel/concepts/ai-services/chat-completion/function-calling/) pattern handles agent selection well. As the number of agents grows, choosing which agent or function to invoke becomes a major challenge.

### Cost optimization

As the number of agents grows, token consumption becomes a primary cost driver. Sending all agent definitions to an LLM on every request increases token usage linearly with agent count. This architecture addresses that challenge through several mechanisms:

- **Semantic cache narrows candidate agents before LLM invocation.** Azure AI Search performs vector similarity matching against stored utterances and returns only a shortlist of relevant agents. The LLM receives definitions for a small subset of agents rather than the full catalog, which limits per-request token consumption regardless of total agent count.

- **Direct invocation bypasses the orchestrator LLM.** When a single agent exceeds the confidence threshold during semantic cache evaluation, the system invokes that agent directly without an extra LLM call. This path eliminates the token and compute cost of orchestrator reasoning for unambiguous queries.

- **TTL-based conversation memory controls storage costs.** Configurable time-to-live (TTL) values on Azure Managed Redis ensure that stale conversation data expires automatically. Adjust TTL values based on conversation patterns to balance context retention against cache storage costs.

- **Tiered model selection reduces per-call cost.** Use lower-cost models for agent routing and selection decisions. Reserve higher-capability models for complex agent responses where output quality justifies the expense.

- **Telemetry sampling limits observability overhead.** Apply intelligent sampling strategies for OpenTelemetry data to control ingestion and retention costs in Application Insights while preserving diagnostic value for anomaly detection.

### Orchestration patterns

You can orchestrate multiagent conversations in several ways. The main challenge is choosing the orchestration pattern that fits your business needs. You can configure some agents to interact or complete tasks sequentially. You can have other agents take on distinct roles and collaborate concurrently to address client requests. This solution helps you choose orchestration patterns for dynamic environments, where you might not have a precise business context or well-defined agent relationships.

### Evaluating as system evolves

Evaluate agent-based solutions regularly at multiple levels. Assess performance for each individual agent, within the orchestration layer, and across the overall system. At the system or multiagent level, evaluate every new or updated agent for its impact on agent selection, orchestration, and the behavior of other agents. Ongoing evaluation helps you confirm that new agents don't degrade the performance of existing agents. For more information, see [Evaluation framework](#evaluation-framework).

### Agent selection

The agent selector chooses the most appropriate agents for user inquiries from a large pool of candidates. It uses Azure AI Search with vector similarity as a semantic cache to narrow the list of agents, and then it applies an LLM to select from this refined group. This approach ensures context-aware agent selection and produces responses or actions that align with the user's query.

The following diagram illustrates the structure of the agent selector system.

![Agent Selector System Diagram](../media/ai-agents-at-scale-agent-selection.png)

#### Agent selection workflow

User Query → Alias Mapping → Semantic Search (Azure AI Search) → Agent Scoring & Filtering → Orchestrator (Select & Invoke Agent)

1. User submits a query along with registered agent IDs.

1. Query goes through alias mapping to get a normalized query.

1. Normalized query is sent to Azure AI Search (semantic cache) to find top matching agent utterances.

1. Each agent is assigned the highest similarity score based on vector similarity scores of the normalized query with utterances in the semantic cache.

1. Agents with scores above predefined thresholds are shortlisted.

1. Candidate agents are intersected with the user's registered agents.

1. Remove duplicate agents by retaining only the highest similarity score for each agent based on matched utterances.

1. If a single agent remains and its score exceeds the confidence threshold, select that agent. If not, include the SupervisorAgent for further evaluation.

1. Incorporate agents from the previous conversation turn using chat history.

1. Final agent list is sent to the Orchestrator.

1. Orchestrator invokes the single agent directly, or uses an LLM to select if multiple agents are available.

### Multi-agent orchestration

A well-designed orchestration layer is essential for coordinating interactions among multiple AI agents. As both the number of agents and the complexity of user scenarios grow, the orchestration system must enable agents to work together effectively, complete tasks accurately, and preserve conversational context. The choice of orchestration pattern depends on various factors such as the nature of user queries, the degree of agent collaboration required, and the overall system goals.

You can choose from various orchestration patterns to address specific solution needs. For detailed guidance on selecting and implementing these patterns, see [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns).

For scenarios that require a minimal degree of collaboration or conversation between agents, consider using the Agents as Tools pattern. In this approach, a principal agent acts as the main coordinator, invoking other agents as "tools" to fulfill specific tasks. The principal agent interprets user intent and determines which agents to call using the function calling capabilities of large language models.

**Recommended scenarios for the Agents as Tools pattern:**

1. The user's request is straightforward and doesn't require extensive collaboration or reasoning among agents.

1. The solution involves a limited set of agents, usually two or three, to fulfill the task.

1. Each agent operates within a well-defined scope, with responsibilities that don't overlap.

#### Multi-turn scenarios

Multi-turn interactions require the orchestration layer to maintain continuity by providing relevant context from previous requests to the participating agents. The orchestration system should determine when to summarize, prune, or persist the conversation state to optimize performance and relevance.

A basic approach to augment the request with prior context is to store the relevant conversation history in a low-latency cache, such as Azure Managed Redis, indexed by conversation ID along with a configurable time-to-live (TTL) value to control retention. You can adjust the TTL based on business needs, such as using a rolling TTL for ongoing conversations.

For more advanced agent memory strategies, see [Agent Memory](/agent-framework/user-guide/agents/agent-memory).

#### Adaptive orchestration: direct agent invocation vs. orchestrator path

While the orchestration module is central to coordinating agent interactions, some scenarios don't require its involvement. If the agent selection process (using semantic cache and vector similarity) yields a single agent with a confidence score exceeding a defined threshold (such as 85%), the system can invoke that agent directly. This approach eliminates unnecessary orchestration overhead, minimizes additional agent selection steps, and reduces both latency and token consumption associated with additional LLM calls.

Direct invocation is most suitable for unambiguous, single-intent queries where the probability of successful agent resolution is high. For queries exhibiting multi-intent or ambiguity, the orchestrator layer remains essential for advanced agent coordination and reasoning.

This adaptive orchestration strategy balances performance optimization with functional flexibility. It ensures rapid response for straightforward tasks and robust coordination for complex scenarios.

### Agent implementation approaches

When you design a dynamic large-scale multi-agent system, there are different implementation approaches, each offering distinct benefits depending on the scenario.

#### In-code

Agents are defined programmatically in the application code with the help of frameworks like [Microsoft Agent Framework](/agent-framework/overview/agent-framework-overview) and [LangChain](https://www.langchain.com/).

**Advantages:**

- Maximum control over agent logic and behavior.
- Direct integration with existing application infrastructure.
- Efficient runtime performance through direct code execution.
- Rich debugging and testing capabilities.

**Considerations:**

- Requires proficiency in the respective programming language and framework used for agent implementation.
- Updating or onboarding new agents requires code changes and redeployment.
- Higher maintenance overhead as the system scales.

#### Declarative

Declarative agent definitions allow you to declare agent capabilities, prompts, and workflows in configuration files like [YAML](https://yaml.org/). This approach separates agent logic from application code, enabling non-developers to modify agent behavior without code changes.

**Advantages:**

- Easier to introduce new agents into the system without requiring code changes or redeployment.
- Non-technical team members can also contribute to defining agent behavior.
- Faster iteration cycles for agent updates.
- Clear separation of concerns between infrastructure and agent logic.

**Considerations:**

- Agent behavior and capabilities are restricted to what gets defined as part of the YAML schema. Extending functionality beyond these predefined patterns might require significant changes or custom development.
- Validation and testing processes need to be established for YAML changes.

**Selection criteria:**

When selecting an implementation approach, consider the following parameters:

- **Extensibility**: Determine how readily the approach supports adding new agents and capabilities in the system.

- **Maintainability**: Consider the effort required to update, debug, and monitor agents as requirements evolve.

- **Performance requirements**: Consider latency, throughput, and scalability needs based on expected usage patterns.

- **Scalability**: Assess how well the approach supports increasing numbers of agents and higher workloads.

- **Community support**: Assess the availability of documentation, community resources, and official support for the chosen approach.

Additionally, the solution should support multiple implementation approaches simultaneously, allowing you to choose the most appropriate option for each agent based on its specific requirements and constraints.

### Agent Factory

The Factory Design Pattern is a well-established approach for creating objects where the system needs to manage and instantiate a variety of objects dynamically.
When building a scalable multi-agent system, consider adding an Agent Factory to centralize how agents are created and to decouple creation logic from runtime use. Given an agent name, the factory returns a ready-to-use agent instance regardless of its implementation (code, YAML template, etc.). This lets you add new agent types without changing orchestration logic.

#### Key design considerations

- The factory inspects available representations (code module, YAML, other) and instantiates the appropriate implementation.

- Allow configurable priority (for example, prefer YAML template over code) so you can control which implementation is used when multiples exist.

- Include validation, lightweight instantiation checks, and caching to avoid repeated heavy construction.  

The Agent Factory pattern streamlines onboarding, testing, and evolution of an agent catalogue, and preserves modularity and scalability by isolating agent changes from other system components.

### Agent onboarding process

The idea behind this process is to maintain a high-quality, conflict-free multi-agent system where every agent addition, update, or removal is deliberate and validated. Agents are the building blocks of intelligent orchestration, so introducing or modifying one without checks can lead to degraded performance, overlapping responsibilities, or broken user experiences. To prevent this, the lifecycle emphasizes evaluation-driven governance at every stage. The following diagram shows the onboarding process flow.

![AI Agents Onboarding Process](../media/ai-agents-at-scale-onboarding-process.png)

The process starts with onboarding a new agent, which involves verifying the uniqueness of its name, description, and sample utterances. After validation, a temporary semantic cache is created, and the system runs semantic and response evaluations to ensure the new agent doesn't negatively affect existing ones. If results meet benchmarks, the agent is promoted to production, and the golden dataset (the ground truth for evaluations) is updated to reflect the new capabilities. Similarly, when you update an agent, the same validation and regression checks apply to avoid selection drift. Updating the golden dataset is critical for keeping evaluations aligned with real-world usage, while deleting an agent requires careful decommissioning steps to remove dependencies and maintain system integrity. This structured approach ensures scalability without sacrificing accuracy or reliability.

### Evaluation framework

#### Agentic system evaluation framework using Azure AI Foundry

This framework evaluates agentic systems by using Azure AI Foundry. It focuses on the inner mechanics of agent-based systems, such as tool invocation, agent selection, and final responses, using both built-in and custom evaluation metrics. The framework also includes benchmark visualization and detailed analysis through the AI Foundry Evaluation dashboard.

The framework uses the AI Foundry evaluation SDK to simplify experimentation and evaluation. A config-driven approach combined with a pipeline-based architecture provides flexibility to add any module as part of the pipeline. The SDK provides options to use Azure AI Foundry built-in evaluators for standardized scoring and custom evaluator metrics for measuring agent performance. The flow is organized into modular stages (data_loading, data_preprocessing, evaluation, reporting) with swappable datasets, inference models, or evaluators. Inputs and outputs use JSONL/golden dataset formats. Results can be uploaded to blob storage and visualized through the AI Foundry Evaluation dashboard for comparison across runs.

The code for the evaluation framework can be referenced from [Evaluation Framework repo](https://github.com/Azure-Samples/Agentic-Evaluations).

##### Features

- **AI Foundry SDK**: Framework integrated with [Azure AI Evaluation SDK](https://pypi.org/project/azure-ai-evaluation/).

- **Built-in and custom evaluators**: Utilizes both built-in evaluators from AI Foundry ([see full list](/azure/ai-foundry/concepts/evaluation-evaluators/general-purpose-evaluators)) and custom evaluators.

- **Config-driven architecture**: YAML config to customize pipelines, add evaluators, and more.

- **Customizable pipelines**: Beyond evaluations, the framework enables adding your own modules for data preprocessing, model inferencing, and reporting.

##### Evaluation pipeline diagram

![Evaluation Pipeline](../media/ai-agents-at-scale-evalframework-flow.png)

##### Pipeline flow

1. **Load evaluation data from Data store**: Load version controlled golden dataset to be evaluated.

1. **Data Transformation**: Prepare the datasets for agentic system inference

1. **Agent Response**: Get the response from agent for the golden dataset.

1. **Data prep for Evaluation**: combine the dataset with ground truth and prepare for evaluation.

1. **Evaluator (metrics)**: identify the right metrics to be used for the evaluating the agentic system.

1. **Evaluation Results**: Run the evaluations and get the evaluation output (metrics).

1. **Reporting**: Push the evaluation report to AI Foundry and analyze it in the Foundry Dashboard.

##### Experimentation and evaluation of agentic systems

![Experimentation and Evaluation](../media/ai-agents-at-scale-experimentation-evaluation.png)

A step-by-step workflow for evaluating agentic systems and their components:

1. **Agent Development**  
    Developers create or fine-tune new agents, define evaluation metrics, and prepare sample utterances or golden datasets.

1. **Component-Level Evaluation**  
    Evaluate each agent or component individually to ensure its responses meet defined expectations and quality standards.

1. **System-Level Evaluation**  
    After integration, perform system-level evaluations, including semantic cache checks and end-to-end (E2E) assessments, to validate overall system behavior.

1. **Iterative Improvement**                              
    Continuously refine agents and the system, ensuring high performance is maintained and that changes do not negatively impact the overall solution.

This structured approach enables robust validation, benchmarking, and integration of agents, supporting scalable and reliable deployment of agentic systems.

#### Evaluation metrics for agentic selection

| Metric                               | Description                                                      |
|--------------------------------------|------------------------------------------------------------------|
| Agent invoke accuracy, recall        | Evaluates whether the right agent handled the message or task.   |
| Agent selection recall, precision    | Measures if the list of agents suggested by cache matches expected results. |

#### Evaluation of agent response (Foundry)

| Metric                               | Description                                                      |
|--------------------------------------|------------------------------------------------------------------|
| BLEU score      | Evaluates if the response from the agent matches the ground truth.                    |
| Similarity      | Measures how similar the agent response is compared to the ground truth response.     |
| Relevance       | Measures the relevance of the agent response for a query.                             |

For the full list of evaluators, refer to the [Microsoft Foundry Evaluator Reference](/azure/foundry/concepts/built-in-evaluators).

### Observability

When you build AI solutions, especially those powered by **multi-agent architectures**, reliability, maintainability, and performance are essential.
However, as these systems expand in scale and complexity, maintaining visibility into their behavior becomes increasingly difficult.

Unlike traditional applications, agentic systems involve multiple intelligent components that collaborate dynamically: language models, orchestration layers, caching mechanisms, retrieval engines, and external APIs.  
Each component contributes to the outcome, which makes **monitoring, debugging, and optimization** far more intricate.

Observability is the foundation for understanding emergent AI behavior in these systems.

#### Why observability matters in AI systems

Observability provides insight into what your application is doing, not just whether the underlying infrastructure is running. You need to distinguish between **system observability** (infrastructure metrics like CPU, memory, and network) and **application observability** (orchestration logic, agent behavior, prompt flows, and model inference).

In multi-agent environments, application observability answers questions such as:

- Why did one agent take longer to respond than others?  
- What sequence of calls led to a poor or inconsistent result?  
- Which model parameters or prompts were in play during a failure?  

By combining signals from infrastructure, orchestration, and model behavior, observability bridges the gap between **system performance** and **model intelligence**.

#### Observability framework

This observability framework is built on **OpenTelemetry** for instrumentation and **Azure Application Insights** as the telemetry backend.  

- **OpenTelemetry** standardizes how traces, metrics, and logs are captured across agents and services. It ensures interoperability across frameworks and programming languages.  
- **Application Insights** aggregates and visualizes this telemetry, offering dashboards, alerts, and the ability to explore correlations between infrastructure metrics, application traces, and LLM inference data.

For agents built with **Semantic Kernel**, observability is integrated through OpenTelemetry's standardized instrumentation. Semantic Kernel automatically emits traces, logs, and metrics for kernel operations such as function invocations, prompt executions, and plugin calls when you configure OpenTelemetry.

#### The three dimensions of agentic observability

Traditional observability stops at *logs, metrics, and traces*.  
In AI systems, those pillars extend to include **semantic and behavioral observability**, covering how agents reason, collaborate, and evolve during execution.

##### 1. Execution logs

Beyond infrastructure logging, capture **semantic events**: prompts, responses, and intermediate reasoning steps between agents.  
All log data is streamed via **OpenTelemetry exporters** to **Azure Log Analytics**, where you use **KQL** to correlate across agents and identify anomalies at the conversation level.

##### 2. System and model metrics

Metrics provide quantitative signals about both system and model performance.  
Track latency, throughput, and cost, along with **AI-specific metrics** such as token usage and time to first token (TTFT). 

##### 3. Distributed traces with context

Traces connect every service and agent involved in a single conversation.  
By using **trace IDs** and **span IDs**, you can view the full path of an inference request, from the orchestrator to downstream agents, caches, and external calls.

Each trace carries **semantic context**, such as conversation ID and agent name, enabling a unified view of model collaboration.  
This is particularly useful for diagnosing latency spikes, identifying network bottlenecks, or analyzing where agent coordination might fail.

#### Observability data flow for agentic systems

![Observability data flow for agentic systems](../media/ai-agents-at-scale-observability-flow.png)

1. Emit telemetry via OTLP (Instrumentation): Orchestrator, agents, device control, and other services are instrumented using OpenTelemetry SDKs. They emit logs, traces, and metrics via OpenTelemetry Protocol (OTLP).

1. Collect, process & export (Ingestion): Telemetry is sent to the OpenTelemetry Collector, where it flows through receiver, processor, and exporter stages, then is exported to Azure Application Insights.

1. Route to stores (Storage & Query): Application Insights routes data into dedicated stores — Logs to Log Analytics for KQL querying, Traces for distributed tracing via Trace ID and Span ID, and Metrics to the metrics store for system and business monitoring.

1. Visualize & alert (Visualization & Alerting): Dashboards, alerts, and workbooks provide real-time visibility and trigger incident response workflows.

A single trace ID flows through the entire conversation lifecycle, from the initial request to the orchestrator, through agent invocations, function tool calls, and external API services. Each component creates child spans under the parent trace, allowing you to reconstruct the complete execution path and identify where latency or errors occurred across agents and auxiliary services.

#### Observability for LLM and agent systems

For LLM-driven architectures, observability must capture **the cognitive layer**: what the model or agent saw, decided, and produced.

Track not just infrastructure telemetry, but contextual data such as:

- **System prompts**: The instructions that guided behavior.
- **Model parameters**: Temperature, top-p, token limits.
- **User inputs and conversation history**: What context was passed to the model.
- **Outputs**: The actual text, decisions, or structured responses.

Capturing this metadata enables **reproducibility** of inference runs, helping data scientists analyze why an output differed, whether drift occurred, or if bias emerged.

#### Key metrics categories

Track **system performance** metrics (latency, throughput, resource utilization, reliability) and **LLM inference performance** metrics (TTFT, token usage, error rates, content safety triggers). Additionally, monitor **usage and engagement** patterns (active conversations, conversation depth, repeated queries) and **quality and model accuracy** indicators (intent selection accuracy, sentiment trends, instruction adherence, bias and groundedness).

#### Best practices

- **Uniform instrumentation**: Apply OpenTelemetry consistently across all microservices and agents.
- **Correlation IDs**: Include trace and span IDs in every log and metric.
- **Sampling and retention**: Balance data richness with cost efficiency using intelligent sampling.
- **Dashboards and alerts**: Define SLIs/SLOs and automate alerting for anomalies.
- **Secure data handling**: Mask or omit sensitive information from logs and traces.
- **Cross-functional collaboration**: Engineers, data scientists, and product teams should share a unified observability view.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Munish Malhotra](https://www.linkedin.com/in/munish-malhotra) | Senior Software Engineer
- [Brijraj Singh](https://www.linkedin.com/in/brijraajsingh/) | Principal Software Engineering Manager
- [Kshitij Sharma](https://www.linkedin.com/in/ikshitijsharma/) | Senior Software Engineer
- [Vidhya Shankar Venkatesan](https://www.linkedin.com/in/vikesh-singh-baghel-28601322/) | Principal Software Engineer
- [Sushant Bhalla](https://www.linkedin.com/in/sushaanttb/) | Senior Software Engineer
- [Vikesh Bagel](https://www.linkedin.com/in/vikesh-singh-baghel-28601322/) | Principal Data Scientist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Foundry?](/azure/foundry/what-is-foundry)
- [What is Azure AI Search?](/azure/search/search-what-is-azure-search)
- [What is Azure OpenAI?](/azure/ai-services/openai/overview)
- [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns)
- [Microsoft Agent Framework overview](/agent-framework/overview/agent-framework-overview)
- [Foundry evaluation SDK](https://pypi.org/project/azure-ai-evaluation/)
- [Agentic Evaluations framework](https://github.com/Azure-Samples/Agentic-Evaluations)

## Related resources

- [Baseline Foundry chat reference architecture](../../ai-ml/architecture/baseline-microsoft-foundry-chat.yml)
- [Azure OpenAI chat baseline architecture in an Azure landing zone](../../ai-ml/architecture/baseline-microsoft-foundry-landing-zone.yml)
- [AI agent orchestration patterns](../../ai-ml/guide/ai-agent-design-patterns.md)
- [Build a multiple-agent workflow automation solution by using Microsoft Agent Framework](../../ai-ml/idea/multiple-agent-workflow-automation.yml)

