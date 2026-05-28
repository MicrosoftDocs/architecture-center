[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Use this solution to dynamically select relevant agents from a large pool of agents during a conversation. This article addresses the main challenges of building a system that can flexibly include agents, explores orchestration strategies, and discusses considerations for scaling to hundreds of agents.

This solution uses Microsoft Foundry, Azure AI Search, Azure OpenAI, and other Azure services to support scalable agent-based interactions.

Use this approach when many agents need to handle open-ended client conversations and you can't predict the conversation domain.

## Architecture

:::image type="complex" border="false" source="../media/ai-agents-at-scale-architecture.svg" alt-text="Architecture diagram for dynamic AI agents at scale." lightbox="../media/ai-agents-at-scale-architecture.svg":::
In step 1, a user connects to application gateways with web application firewall policies in the gateway subnet. The request path continues to a front-end IP address on a load balancer in the private subnet. The diagram includes a cluster subnet that includes an application cluster, a service namespace that contains an AI agent service and multiple agent factory pods, and an operations namespace with other service components. In step 2, the private subnet points to the AI agent service. Below, a private endpoint subnet contains private endpoints for Azure Container Registry, AI Search, Foundry, Azure Managed Redis, Azure Storage, Azure Cosmos DB, and Azure Key Vault. Each of these services connects to corresponding resources: container registries, search services, Azure Managed Redis, Azure Data Lake Storage, Azure Cosmos DB, and key vaults. In step 3, a bidirectional arrow connects an agent factory pod and the AI Search private endpoint. In step 4, an agent factory pod points to the Foundry private endpoint. In step 5, the Foundry private endpoint points to a Foundry section that includes Foundry agents, managed identities, and Azure OpenAI models. The diagram also shows supporting components within the virtual network boundary, including Azure DDoS Protection and private domain name system (DNS), Microsoft Entra ID, Application Insights, and Azure Monitor. At the bottom, a firewall subnet contains Azure Firewall, which connects to external APIs, Model Context Procotol (MCP) servers, and the internet. In step 6, an agent factory pod points to the firewall subnet.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/ai-agents-at-scale-architecture.vsdx) of this architecture.*

## Workflow

The following workflow corresponds to the previous diagram:

1. A user submits a query through the client application.

1. The AI agent service receives the request and passes it to the orchestrator, which delegates to the agent selector to identify the most relevant agents to invoke.

1. The agent selector queries the semantic cache in AI Search. The cache uses vector similarity to compare the query against stored sample utterances and return candidate agents. The agent selector scores and filters those results. If one agent's score exceeds the confidence threshold, the system invokes that agent directly. Otherwise, a large language model (LLM) chooses from the shortlisted candidates.

1. The agent factory instantiates the selected agent based on its registered implementation, such as code module, YAML template, or other representation, and returns a ready-to-use agent instance.

1. The selected agent processes the request by using Azure OpenAI models hosted in Foundry or external tools. The response flows back through the orchestration layer to the user.

1. When an agent needs a public endpoint, it calls external APIs or Model Context Protocol (MCP) servers through the Network Address Translation (NAT) gateway.

## Components

- [Foundry](/azure/foundry/what-is-foundry) is an end-to-end platform that helps you build, deploy, and manage AI applications. In this architecture, it hosts Azure OpenAI models and provides a unified environment for agent development, model orchestration, and evaluation.

- [AI Search](/azure/search/search-what-is-azure-search) is a cloud search service with built-in AI capabilities for vector search and semantic ranking. In this solution, it acts as the semantic cache that stores sample agent utterances and uses vector similarity to identify candidate agents for user queries.

- [Azure OpenAI](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure) is a managed AI service that provides REST API access to OpenAI language models and embeddings. In this solution, agents use these models to process requests, generate responses, and select appropriate agents from shortlisted candidates.

- [Azure Managed Redis](/azure/redis/overview) is a fully managed, in-memory data store based on Redis Enterprise that supports high-throughput and low-latency data access. In this solution, Azure Managed Redis stores conversation context and chat history to support multiturn interactions with minimal latency.

- [Application Insights](/azure/azure-monitor/app/app-insights-overview) is an application performance management (APM) feature that provides monitoring and diagnostics for cloud applications. In this solution, it collects telemetry from all components via OpenTelemetry. This process supports end-to-end observability of agent interactions, performance metrics, and system health.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring solution that collects, analyzes, and responds to telemetry from cloud and on-premises environments. In this solution, it provides dashboards, alerting, and log analytics to track system performance and detect anomalies.

- [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) is a tool for editing and running log queries against data in Azure Monitor Logs. In this solution, it stores execution logs and supports KQL queries to correlate agent behavior and identify conversation-level anomalies.

- [Azure NAT Gateway](/azure/nat-gateway/nat-overview) is a managed NAT service that provides outbound internet connectivity for virtual networks. In this solution, it provides a static outbound IP address for agents that call external APIs or MCP servers that require a public endpoint.

## Scenario details

Use this solution to build and scale multiagent AI systems that can grow to hundreds of agents. The orchestration framework dynamically selects the right agents for each conversation, so you don't need to define workflows in advance. Supporting services add memory, observability, and evaluation across the system.

### Potential use cases

**Virtual smart assistant ecosystems:** These ecosystems evolve rapidly as you add more agents to support users across operations. As you automate more devices and workflows, you need a structured mechanism to build and manage a large network of agents and to control costs.

**Agentic AI ecosystems:** Use this solution for agentic AI ecosystems that have the following characteristics:

  - **Many collaborating agents:** You expect 10 or more agents to operate in a shared environment. The agents perform diverse functions, often aren't aware of each other, and don't collaborate directly.

  - **Unpredictable agent selection:** You can't determine in advance which agent handles a given request. The system must make the right agents available on demand so that conversations continue without interruption.

  - **Continued growth:** You expect the number of agents to keep increasing, and you need costs to remain predictable as you scale.

### When not to use this solution

Avoid this solution in the following scenarios:

- **Limited number of agents:** The system has fewer than five agents, so the complexity of dynamic orchestration outweighs the benefit.

- **Deterministic orchestration:** The orchestration follows a predefined workflow or handoff process, so you don't need dynamic agent selection.

- **Distinct agent roles:** The agents have clearly distinct roles with no overlap, and the orchestration exposes only specific agents for selection, such as principal agents that have predefined child or connected agents. In this case, an LLM doesn't need to perform dynamic selection.

### Key challenges

#### Prepare semantic cache data

This solution depends on a well-constructed semantic cache that contains sample agent utterances. Represent each agent's capabilities by using diverse sample utterances so that the cache covers the full range of requests that the agent handles. To support reliable agent invocation, include at least five distinct utterances for every capability. Complete this step before you onboard an agent into the system.

#### Dynamic inclusion of agents

Suppose your organization runs several domain-specific agents and you want to create a unified conversational AI that enables clients to interact with any of them without knowing which agent handles which task. A single conversation might engage multiple agents to address multiple-intent requests. For example, the request "Help me book a conference room on the Yosemite floor, and notify parking services that I'll need five spots for a customer meeting on the 26th" engages both the `ConferenceBookingAgent` and the `ParkingServiceAgent`. When you have fewer than 20 agents or tools, a [function calling](/semantic-kernel/concepts/ai-services/chat-completion/function-calling/) pattern handles agent selection effectively. As the number of agents grows, choosing which agent or function to invoke becomes a major challenge.

### Cost optimization

As the number of agents grows, token consumption becomes a primary cost driver. Sending all agent definitions to an LLM on every request increases token usage linearly with agent count. This architecture addresses that challenge through several mechanisms:

- **The semantic cache shortlists candidate agents before the system invokes the LLM.** AI Search performs vector similarity matching against stored utterances and returns only a shortlist of relevant agents. The LLM receives definitions for a small subset of agents rather than the full catalog, which limits per-request token consumption regardless of total agent count.

- **Direct invocation bypasses the orchestrator LLM.** When a single agent exceeds the confidence threshold during the semantic cache evaluation, the system invokes that agent directly without an extra LLM call. This path eliminates the token and compute cost of orchestrator reasoning for unambiguous queries.

- **TTL-based conversation memory controls storage costs.** Configurable time-to-live (TTL) values on Azure Managed Redis ensure that stale conversation data expires automatically. Adjust TTL values based on conversation patterns to balance context retention against cache storage costs.

- **Tiered model selection reduces per-call cost.** Use lower-cost models for agent routing and selection decisions. Reserve higher-capability models for complex agent responses where output quality justifies the expense.

- **Telemetry sampling limits observability overhead.** Apply intelligent sampling strategies for OpenTelemetry data to control ingestion and retention costs in Application Insights while preserving diagnostic value for anomaly detection.

### Orchestration patterns

You can orchestrate multiagent conversations in several ways. The main challenge is choosing the orchestration pattern that fits your business needs. You can configure some agents to interact or complete tasks sequentially. You can have other agents take on distinct roles and collaborate concurrently to address client requests. This solution helps you choose orchestration patterns for dynamic environments, where you might not have a precise business context or well-defined agent relationships.

### Evaluation as the system evolves

Evaluate agent-based solutions regularly at multiple levels. Assess performance for each individual agent within the orchestration layer and across the overall system. At the system or multiagent level, evaluate every new or updated agent for its impact on agent selection, orchestration, and the behavior of other agents. Ongoing evaluation helps you confirm that new agents don't degrade the performance of existing agents. For more information, see [Evaluation framework](#foundry-evaluation-framework).

### Agent selection

The agent selector chooses the most appropriate agents for user inquiries from a large pool of candidates. It uses AI Search with vector similarity as a semantic cache to narrow the list of agents, and then it applies an LLM to select from this refined group. This approach ensures context-aware agent selection and produces responses or actions that align with the user's query.

The following diagram illustrates the structure of the agent selector system.

:::image type="complex" border="false" source="../media/ai-agents-at-scale-agent-selection.svg" alt-text="Flow diagram that shows how a system uses a semantic cache to select the most relevant agents for a user query." lightbox="../media/ai-agents-at-scale-agent-selection.svg":::
In step 1, the user submits a query for a specific task and the system considers the user's registered agents. In step 2, the system performs alias mapping to resolve agent references. In step 3, the system generates a normalized query without alias agents. In step 4, AI Search retrieves top embedding matches and the system assigns similarity scores to candidate agents, converts the scores to cosine similarity, and evaluates whether the top score exceeds a confidence threshold to determine whether to keep high-confidence agents or include all agents. In step 5, the system filters results to the top set based on semantic cache thresholds. In step 6, the system intersects the selected agents with the user's available agents. In step 7, the system removes duplicates and assigns each agent a maximum score. In step 8, the system checks whether a single agent remains and whether the score meets a confidence threshold, optionally adding a supervisor agent when conditions are met. In step 9, if multiple agents remain or confidence is low, the system includes other candidate agents and agents from the previous turn. In step 10, the orchestrator receives the final list of agents and either invokes a single agent or uses an LLM to select the best agent when multiple candidates remain.
:::image-end:::

#### Agent selection workflow

The agent selection workflow proceeds through five stages. The user query enters alias mapping, then semantic search in AI Search, then agent scoring and filtering, and finally the orchestrator selects and invokes the agent. The following steps describe each stage in detail:

1. The user submits a query and registered agent IDs.

1. The system applies alias mapping to produce a normalized query.

1. The system sends the normalized query to AI Search (the semantic cache) to find the top matching agent utterances.

1. The system assigns each agent the highest similarity score based on the vector similarity scores between the normalized query and the utterances in the semantic cache.

1. The system shortlists agents that score above predefined thresholds.

1. The system intersects the candidate agents with the user's registered agents.

1. The system removes duplicate agents by retaining only the highest similarity score for each agent based on matched utterances.

1. If a single agent remains and its score exceeds the confidence threshold, the system selects that agent. Otherwise, the system includes the `SupervisorAgent` for further evaluation.

1. The system incorporates agents from the previous conversation turn by using chat history.

1. The system sends the final agent list to the orchestrator.

1. The orchestrator invokes the single agent directly, or it uses an LLM to select an agent if multiple agents are available.

### Multiagent orchestration

A well-designed orchestration layer coordinates interactions among multiple AI agents. As you add more agents and your user scenarios grow more complex, the orchestration system must help agents work together, complete tasks accurately, and preserve conversational context. Choose your orchestration pattern based on the nature of user queries, how much agent collaboration you need, and your overall system goals.

You can choose from various orchestration patterns to address specific solution needs. For more information about how to select and implement these patterns, see [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns).

For scenarios that require minimal collaboration or conversation between agents, consider the Agents as Tools pattern. In this approach, a principal agent acts as the main coordinator and invokes other agents as tools to fulfill specific tasks. The principal agent interprets user intent and uses the function calling capabilities of LLMs to determine which agents to call.

Use the Agents as Tools pattern if:

- The user submits straightforward requests that don't require extensive collaboration or reasoning among agents.

- Two or three agents can complete the task.

- Each agent operates within a well-defined scope and has responsibilities that don't overlap with other agents.

#### Multiturn scenarios

Multiturn interactions require the orchestration layer to maintain continuity by passing relevant context from previous requests to the participating agents. The orchestration system decides when to summarize, prune, or persist the conversation state to optimize performance and relevance.

To augment a request with prior context, store the relevant conversation history in a low-latency cache, such as Azure Managed Redis. Index the entries by conversation ID, and apply a configurable TTL value to control retention. Adjust the TTL based on business needs. For example, use a rolling TTL for ongoing conversations.

#### Adaptive orchestration: Direct agent invocation vs. orchestrator path

The orchestration module coordinates agent interactions, but some scenarios don't need orchestration. If agent selection uses the semantic cache and vector similarity to return a single agent whose confidence score exceeds a defined threshold, such as 85%, the system invokes that agent directly. This approach removes orchestration overhead, skips extra agent selection steps, and reduces the latency and token consumption of extra LLM calls.

Use direct invocation for unambiguous, single-intent queries that have a high probability of successful agent resolution. For multi-intent or ambiguous queries, rely on the orchestrator layer to coordinate agents and reason across them.

This adaptive orchestration strategy balances performance with flexibility. It ensures fast responses for straightforward tasks and full coordination for complex scenarios.

### Agent implementation approaches

When you design a dynamic, large-scale multiagent system, you can choose from different implementation approaches. Each approach offers distinct benefits depending on your scenario.

#### In-code

You define agents programmatically in your application code by using frameworks like [Microsoft Agent Framework](/agent-framework/overview/) and [LangChain](https://www.langchain.com/).

The in-code approach offers the following advantages:

- Provides maximum control over agent logic and behavior
- Integrates directly with your existing application infrastructure
- Delivers efficient runtime performance through direct code execution
- Provides debugging and testing capabilities

Consider the following trade-offs before you choose this approach:

- Requires proficiency in the programming language and framework that you use
- Requires code changes and redeployment when you update or onboard new agents
- Increases maintenance overhead as your system scales

#### Declarative

Use declarative agent definitions to declare agent capabilities, prompts, and workflows in configuration files like [YAML](https://yaml.org/). This approach separates agent logic from application code, so nondevelopers can modify agent behavior without code changes.

The declarative approach offers the following advantages:

- Supports introducing new agents without code changes or redeployment
- Extends agent behavior authoring to nontechnical team members
- Accelerates iteration cycles for agent updates
- Separates infrastructure from agent logic

Consider the following trade-offs before you choose this approach:

- Restricts agent behavior and capabilities to what the YAML schema defines. To extend functionality beyond these patterns, you might need significant changes or custom development.
- Requires you to establish validation and testing processes for YAML changes.

#### Selection criteria

When you select an implementation approach, consider the following parameters:

- **Extensibility:** Determine how readily the approach supports adding new agents and capabilities to the system.

- **Maintainability:** Consider the effort that you need to update, debug, and monitor agents as requirements evolve.

- **Performance requirements:** Consider the latency, throughput, and scalability that your expected usage patterns require.

- **Scalability:** Assess how well the approach handles increasing numbers of agents and higher workloads.

- **Community support:** Assess the documentation, community resources, and official support available for the approach.

The solution should also support multiple implementation approaches simultaneously so that you can choose the most appropriate option for each agent based on its specific requirements and constraints.

### Agent factory

The agent factory design pattern provides a well-established way to create objects when the system manages and instantiates various objects dynamically. When you build a scalable multiagent system, consider adding an agent factory to centralize how the system creates agents and to decouple creation logic from runtime use. Given an agent name, the factory returns a ready-to-use agent instance regardless of its implementation, such as code or a YAML template. Use this approach to add new agent types without changing orchestration logic.

#### Key design considerations

- The factory inspects available representations, such as a code module or YAML, and instantiates the appropriate implementation.

- Make priority configurable (for example, prefer a YAML template over code) to control which implementation the factory uses when multiple representations exist.

- Apply validation, lightweight instantiation checks, and caching to avoid repeated heavy construction.

The agent factory pattern helps you onboard, test, and evolve an agent catalog. It also preserves modularity and scalability because it isolates agent changes from other system components.

### Agent onboarding process

This process helps you maintain a high-quality, conflict-free multiagent system in which you add, update, or remove every agent deliberately and with validation. Agents form the building blocks of intelligent orchestration. Introducing or modifying an agent without checks can degrade performance, create overlapping responsibilities, or break user experiences. To prevent these outcomes, the life cycle applies evaluation-driven governance at every stage. The following diagram shows the onboarding process flow.

:::image type="complex" border="false" source="../media/ai-agents-at-scale-onboarding-process.svg" alt-text="Flow diagram that shows a gated workflow for validating and integrating a semantic cache before production use." lightbox="../media/ai-agents-at-scale-onboarding-process.svg":::
The process begins with prevalidation, which includes checking agent name availability, validating descriptions, and reviewing sample utterances. The workflow then moves to temporary cache creation. The temporary cache is evaluated against an existing golden dataset by using semantic cache evaluation, end-to-end evaluation, and performance analysis benchmarking. The workflow proceeds only when results are approved. The system then performs system integration, which includes updating the production cache, enhancing the golden dataset, and cleaning up intermediate artifacts. After integration, the workflow moves to final validation by using a new golden dataset. The workflow again runs semantic cache evaluation, end-to-end evaluation, and performance benchmarking. It continues only when results meet criteria. The process ends with final steps that include updating the benchmark and merging the pull request to complete the workflow.
:::image-end:::

The life cycle covers three operations:

- **Onboard a new agent.** Verify that the agent has a unique name, description, and sample utterances. After validation, the system creates a temporary semantic cache and runs semantic and response evaluations to confirm that the new agent doesn't degrade existing agents. If results meet the benchmarks, the system promotes the agent to production and updates the golden dataset (the ground truth for evaluations) to reflect the new capabilities.

- **Update an agent.** The same validation and regression checks apply to prevent selection drift. Update the golden dataset to keep evaluations aligned with real-world usage.

- **Delete an agent.** Follow careful decommissioning steps to remove dependencies and maintain system integrity.

This structured approach ensures scalability without sacrificing accuracy or reliability.

### Foundry Evaluation Framework

Use the Foundry Evaluation Framework to evaluate the agentic system. This framework focuses on the inner mechanics of agent-based systems, such as tool invocation, agent selection, and final responses, and applies both built-in and custom evaluation metrics. It also visualizes benchmarks and provides detailed analysis through the Foundry Evaluation dashboard.

The framework uses the Azure AI Evaluation SDK to simplify experimentation and evaluation. A configuration-driven approach combined with a pipeline-based architecture supports adding any module to the pipeline. The SDK supports both Foundry built-in evaluators for standardized scoring and custom evaluator metrics that measure agent performance. The flow organizes work into modular stages (data_loading, data_preprocessing, evaluation, reporting) with swappable datasets, inference models, and evaluators. Inputs and outputs use JSONL or golden dataset formats. You can upload results to blob storage and visualize them in the Foundry evaluation dashboard to compare runs.

To find code for the Foundry Evaluation Framework, see [Evaluation Framework repo](https://github.com/Azure-Samples/Agentic-Evaluations).

#### Features

- **Foundry SDK:** Framework integrated with the [Azure AI Evaluation SDK](https://pypi.org/project/azure-ai-evaluation/).

- **Built-in and custom evaluators:** Uses both [built-in evaluators from Foundry](/azure/foundry/concepts/evaluation-evaluators/general-purpose-evaluators) and custom evaluators.

- **Configuration-driven architecture:** YAML configuration to customize pipelines and add evaluators.

- **Customizable pipelines:** Beyond evaluations, the framework supports adding your own modules for data preprocessing, model inferencing, and reporting.

#### Evaluation pipeline diagram

:::image type="complex" border="false" source="../media/ai-agents-at-scale-evalframework-flow.svg" alt-text="Flow diagram that shows an evaluation pipeline for an agentic system that uses a data catalog tool and multiple evaluators." lightbox="../media/ai-agents-at-scale-evalframework-flow.svg":::
In step 1, the system loads evaluation data from a data catalog tool into an evaluation dataset that contains sample inputs and outputs. In step 2, the dataset provides utterances and inputs to the agentic system. In step 3, the agentic system processes the inputs and produces an agent response that includes predicted output alongside expected or ground truth output. In step 4, the system passes the query, predicted output, and ground truth output to the evaluators. In step 5, the evaluators run by using both custom evaluators from a repository, such as function call, agent planner, multiturn, multi-intent, agent success, and agent selector evaluators, and built-in Foundry evaluators, such as retrieval, relevance, similarity, and content safety evaluators. In step 6, the system aggregates evaluation results into experiment results. In step 7, the results feed into Foundry, where reports and dashboards visualize evaluation metrics.
:::image-end:::

#### Pipeline flow

1. **Evaluation data retrieval:** Load the version-controlled golden dataset to be evaluated.

1. **Data transformation:** Prepare the datasets for agentic system inference.

1. **Agent response:** Get the response from the agent for the golden dataset.

1. **Data prep for evaluation:** Combine the dataset with ground truth and prepare for evaluation.

1. **Evaluator (metrics):** Identify the right metrics to use to evaluate the agentic system.

1. **Evaluation results:** Run the evaluations and get the evaluation output (metrics).

1. **Reporting:** Push the evaluation report to Foundry and analyze it in the Foundry dashboard.

#### Experimentation and evaluation of agentic systems

:::image type="complex" border="false" source="../media/ai-agents-at-scale-experimentation-evaluation.svg" alt-text="Flow diagram that compares component-level evaluation during agent development with end-to-end evaluation during agent onboarding." lightbox="../media/ai-agents-at-scale-experimentation-evaluation.svg":::
On the left, the component-level evaluation section shows a user utterance that flows into either a semantic cache or an individual agent, with an optional payload provided to each. Each component produces a response that's then evaluated independently. On the right, the end-to-end evaluation section shows a user utterance and optional payload that flows into an agentic system composed of multiple agents, which generates a single response that's evaluated as a complete system output.
:::image-end:::

A step-by-step workflow for evaluating agentic systems and their components:

1. **Agent development:** Developers create or fine-tune new agents, define evaluation metrics, and prepare sample utterances or golden datasets.

1. **Component-level evaluation:** Evaluate each agent or component individually to ensure that its responses meet defined expectations and quality standards.

1. **System-level evaluation:** After integration, perform system-level evaluations, including semantic cache checks and end-to-end (E2E) assessments, to validate overall system behavior.

1. **Iterative improvement:** Continuously refine agents and the system to maintain high performance and prevent changes from degrading the overall solution.

This structured approach supports validation, benchmarking, and integration of agents and produces scalable, reliable agentic system deployments.

#### Evaluation metrics for agentic selection

| Metric                               | Description                                                      |
|--------------------------------------|------------------------------------------------------------------|
| Agent invoke accuracy, recall        | Evaluates whether the right agent handled the message or task    |
| Agent selection recall, precision    | Measures if the list of agents suggested by the cache matches expected results |

#### Evaluation of agent response (Foundry)

| Metric                               | Description                                                      |
|--------------------------------------|------------------------------------------------------------------|
| Bilingual Evaluation Understudy (BLEU) score      | Evaluates if the response from the agent matches the ground truth                     |
| Similarity      | Measures how similar the agent response is compared to the ground truth response      |
| Relevance       | Measures the relevance of the agent response for a query                              |

For the full list of evaluators, see [Foundry evaluator reference](/azure/foundry/concepts/built-in-evaluators).

### Observability

When you build AI solutions, especially solutions that use multiagent architectures, you need to maintain reliability, maintainability, and performance. As these systems grow in scale and complexity, maintaining visibility into their behavior becomes increasingly difficult.

Unlike traditional applications, agentic systems combine multiple intelligent components that collaborate dynamically. These components include language models, orchestration layers, caching mechanisms, retrieval engines, and external APIs. Each component contributes to the outcome, which complicates how you monitor, debug, and optimize the system.

Observability gives you the foundation to understand emergent AI behavior in these systems.

#### Why observability matters in AI systems

Observability shows you what your application does, not only whether the underlying infrastructure runs. Distinguish between system observability (infrastructure metrics like CPU, memory, and network) and application observability (orchestration logic, agent behavior, prompt flows, and model inference).

In multiagent environments, application observability helps you:

- Determine why one agent took longer to respond than other agents.
- Identify the sequence of calls that led to a poor or inconsistent result.
- Identify which model parameters or prompts were in play during a failure.

When you combine signals from infrastructure, orchestration, and model behavior, observability bridges the gap between system performance and model intelligence.

#### Observability framework

This observability framework uses OpenTelemetry for instrumentation and Application Insights as the telemetry back end.

- OpenTelemetry standardizes how the system captures traces, metrics, and logs across agents and services. It ensures interoperability across frameworks and programming languages.

- Application Insights aggregates and visualizes this telemetry. You use it to view dashboards, configure alerts, and explore correlations between infrastructure metrics, application traces, and LLM inference data.

If you build agents by using Semantic Kernel, OpenTelemetry standardized instrumentation provides observability. When you set up OpenTelemetry, Semantic Kernel automatically emits traces, logs, and metrics for kernel operations such as function invocations, prompt executions, and plugin calls.

#### The three dimensions of agentic observability

Traditional observability stops at logs, metrics, and traces. In AI systems, those pillars extend to include semantic and behavioral observability, which covers how agents reason, collaborate, and evolve during execution.

- **Execution logs:** Beyond infrastructure logging, capture semantic events, like prompts, responses, and intermediate reasoning steps between agents. OpenTelemetry exporters stream all log data to Log Analytics, where you use KQL to correlate across agents and identify anomalies at the conversation level.

- **System and model metrics:** Metrics provide quantitative signals about both system and model performance. Track latency, throughput, and cost, along with AI-specific metrics such as token usage and time to first token (TTFT).

- **Distributed traces with context:** Traces connect every service and agent involved in a single conversation. Use trace IDs and span IDs to view the full path of an inference request, from the orchestrator to downstream agents, caches, and external calls.

  Each trace carries semantic context, such as conversation ID and agent name, which provides a unified view of model collaboration. Use these traces to diagnose latency spikes, identify network bottlenecks, or analyze where agent coordination fails.

#### Observability data flow for agentic systems

:::image type="complex" border="false" source="../media/ai-agents-at-scale-observability-flow.svg" alt-text="Flow diagram that shows an observability pipeline for microservices by using OpenTelemetry and Azure Monitor." lightbox="../media/ai-agents-at-scale-observability-flow.svg":::
In step 1, instrumented services in the microservices section, including the orchestrator, agents, device control services, other services, and the OpenTelemetry SDK, generate telemetry data and send it to the OpenTelemetry Collector in the Telemetry pipeline. In step 2, the OpenTelemetry Collector receives, processes, and exports the data to Application Insights. In step 3, Application Insights routes the data to logs, traces, and metrics within Azure Monitor, where logs are stored in a Log Analytics workspace for KQL queries, traces capture transaction details such as trace IDs and span IDs, and metrics capture business and system measurements. In step 4, logs, traces, and metrics feed into the visualization and alerts component, which provides dashboards, workbooks, and rule-based alerts to support monitoring and incident response.
:::image-end:::

1. **Emit telemetry via OTLP:** The orchestrator, agents, device control, and other services use OpenTelemetry SDKs for instrumentation. They emit logs, traces, and metrics via OpenTelemetry Protocol (OTLP).

1. **Collect, process, and export:** The OpenTelemetry Collector receives the telemetry, runs it through receiver, processor, and exporter stages, and then exports it to Application Insights.

1. **Route to stores:** Application Insights routes data into dedicated stores. It sends logs to Log Analytics for KQL querying, traces to the trace store for distributed tracing through trace ID and span ID, and metrics to the metrics store for system and business monitoring.

1. **Visualize and alert:** Dashboards, alerts, and workbooks provide real-time visibility and trigger incident response workflows.

A single trace ID flows through the entire conversation life cycle, from the initial request to the orchestrator and through agent invocations, function tool calls, and external API services. Each component creates child spans under the parent trace so that you can reconstruct the complete execution path and identify where latency or errors occur across agents and auxiliary services.

#### Observability for LLM and agent systems

For LLM-driven architectures, observability must capture the cognitive layer, which includes what the model or agent saw, decided, and produced.

Capture infrastructure telemetry and contextual data such as:

- **System prompts:** The instructions that guide behavior

- **Model parameters:** Temperature, top-p, and token limits

- **User inputs and conversation history:** The context that you pass to the model

- **Outputs:** The text, decisions, or structured responses that the model returns

When you capture this metadata, you can reproduce inference runs. Data scientists use these reproductions to analyze why an output differed, whether drift occurred, or whether bias emerged.

#### Key metrics categories

Track the following categories of metrics:

- **System performance:** Latency, throughput, resource utilization, and reliability

- **LLM inference performance:** TTFT, token usage, error rates, and content safety triggers

- **Usage and engagement:** Active conversations, conversation depth, and repeated queries

- **Quality and model accuracy:** Intent selection accuracy, sentiment trends, instruction adherence, bias, and groundedness

#### Best practices

- **Uniform instrumentation:** Apply OpenTelemetry consistently across all microservices and agents.

- **Correlation IDs:** Include trace and span IDs in every log and metric.

- **Sampling and retention:** Use intelligent sampling to balance data richness against cost.

- **Dashboards and alerts:** Define service-level indicators (SLIs) and service-level objectives (SLOs) and automate alerting for anomalies.

- **Secure data handling:** Mask or omit sensitive information in logs and traces.

- **Cross-functional collaboration:** Share a unified observability view across engineers, data scientists, and product teams.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Vikesh Bagel](https://www.linkedin.com/in/vikesh-singh-baghel-28601322/) | Principal Data Scientist
- [Sushant Bhalla](https://www.linkedin.com/in/sushaanttb/) | Senior Software Engineer
- [Munish Malhotra](https://www.linkedin.com/in/munish-malhotra) | Senior Software Engineer
- [Kshitij Sharma](https://www.linkedin.com/in/ikshitijsharma/) | Senior Software Engineer
- [Brijraj Singh](https://www.linkedin.com/in/brijraajsingh/) | Principal Software Engineering Manager
- [Vidhya Shankar Venkatesan](https://www.linkedin.com/in/vidhya-shankar/) | Principal Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Foundry?](/azure/foundry/what-is-foundry)
- [What is AI Search?](/azure/search/search-what-is-azure-search)
- [What is Azure OpenAI?](/azure/ai-services/openai/overview)
- [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns)
- [Agent Framework overview](/agent-framework/overview/)
- [Foundry evaluation SDK](https://pypi.org/project/azure-ai-evaluation/)
- [Agentic Evaluations framework](https://github.com/Azure-Samples/Agentic-Evaluations)

## Related resources

- [Baseline Foundry chat reference architecture](../../ai-ml/architecture/baseline-microsoft-foundry-chat.yml)
- [Azure OpenAI chat baseline architecture in an Azure landing zone](../../ai-ml/architecture/baseline-microsoft-foundry-landing-zone.yml)
- [AI agent orchestration patterns](../../ai-ml/guide/ai-agent-design-patterns.md)
- [Build a multiple-agent workflow automation solution by using Agent Framework](../../ai-ml/idea/multiple-agent-workflow-automation.yml)

