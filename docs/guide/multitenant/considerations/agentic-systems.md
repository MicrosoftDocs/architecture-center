---
title: Considerations for Multitenant Agentic Systems
description: Review considerations for multitenant agentic systems, including tenant isolation, identity management, tool-calling governance, and state isolation.
author: johndowns
ms.author: pnp
ms.date: 09/25/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Considerations for multitenant agentic systems

Agents are AI-powered applications that use a language model to reason about a user's goal, take actions on the user's behalf by calling tools, access and store state, and adapt their behavior based on the results. In a multitenant environment, agents require careful consideration. If you're not careful, they might use tools outside of the tenant's boundary and access data in ways that inadvertently leak tenant-specific data.

This article outlines some of the key areas to consider when designing a multitenant agentic system, especially with respect to tenant isolation. It's not a design guide, but instead provides considerations and safeguards to review during the design process and before a multitenant agentic system is finished and released.

## What are agents?

An *agent* is an application that runs an iterative reasoning-and-action loop. The user provides a *goal*, which the agent then attempts to achieve through a combination of techniques:

- **AI model-based reasoning.** Interprets the user's goals and statements, decides on the next actions, and plans how to achieve the overall goal.
- **Tool-calling.** Retrieves information from systems like databases, invokes actions in other systems, and generates content or responses.
- **Observing outputs.** Interprets the outputs from tools and reasoning steps, compares them with the goal, and plans next steps.
- **Repeating until an end condition is met.** Typical end conditions include:
    - When the agent is satisfied that its goal is met.
    - When the agent requires more input from the user to continue.
    - When the application reaches a predefined limit for conversation turns, token usage, elapsed time, or another resource.

### Multitenancy and agents

When you design agents in a multitenant solution, be aware of places where the agent might work with tenant-specific data or otherwise require an active tenant context. If you're not careful, tenant data and usage might leak or overlap. The following diagram illustrates several places where the risk of tenant data leakage is especially high:

:::image type="complex" source="./media/agentic-systems/tenant-context-loss-risks.svg" alt-text="Diagram of five tenant-context loss risks across a multitenant agent's identity and agent loop, tool calls, handoffs, and data retrieval." lightbox="./media/agentic-systems/tenant-context-loss-risks.svg" border="false":::
    The diagram flows from left to right, beginning with a tenant user who sends a request and tenant context to a box labeled multitenant agent. In the agent box, risk 1 is the agent identity, which has no implicit tenant context. Risk 2 is the agent loop, which includes reasoning, tool selection and calling, handoff decisions, and user interaction and confirmation. Three paths leave the agent. The top tool-call path carries tenant context to Azure API Management, a gatekeeper that verifies tenant context is passed, and then to an MCP server or shared tool. Risk 3 is the tenant-context transfer. The middle path carries tenant context in a handoff to a specialized agent that can be single-tenant or multitenant. Risk 4 is this transfer. The bottom path reads or writes tenant data in a tenant-specific or shared data store or knowledge base. Risk 5 is on the data retrieval boundary.
:::image-end:::

1. **Agent identity:** A multitenant agent's identity typically has permissions to work across multiple tenants, but doesn't inherently understand tenant context. Enforce boundaries in deterministic code, not the identity.

1. **Model behavior and decisions:** Model behavior is inherently unpredictable, and you can't rely on the model to propagate tenant or user context even if the model appears to behave correctly in tests. As with other security-critical operations, set and propagate the tenant ID only in deterministic code.

1. **Tool-calling:** When the agent passes tenant context to tools, a tool gateway (in this case, Azure API Management) acts as gatekeeper and can be configured to ensure that the context is passed to each tool in tamper-resistant tokens.

1. **Subagent invocation and agent handoff:** If your agent invokes or hands off to another agent, use deterministic logic to pass tenant and user context between the agents, and validate every transition from single-tenant to multitenant or vice versa.

1. **Data stores:** Verify that every data store enforces tenant isolation before the agent reads or writes data or knowledge.

The rest of this article describes these risks and mitigations in more detail.

### Agent platforms

Because agents are applications, you can build them completely yourself and host them as regular applications. This approach provides flexibility but requires that you take responsibility for a range of concerns, many of which aren't specific to your application logic.

Agents tend to have similar responsibilities and requirements, so it's common to use an *agent framework* or an *agent platform*. Agent frameworks and platforms handle some of the responsibilities, leaving you to focus on the business problem that your agent is intended to address.

Agent frameworks are SDKs that create agent applications. The framework provides some predefined behavior.

Hosted platforms, like [Foundry Agent Service](/azure/foundry/agents/overview), help to accelerate the delivery of your agents, minimize the amount of boilerplate logic you need to write, and reduce your responsibilities for data storage and management. However, you need to verify that the platform gives you the level of control you need. Many off-the-shelf agentic platforms aren't built with multitenancy in mind. You need to evaluate them to understand whether you can meet your requirements, including satisfying any regulatory or compliance requirements.

## Agent deployment approaches

There are two broad deployment approaches for agents in a multitenant solution:

- **Multitenant agents.** A multitenant agent is deployed as a single application, with a single endpoint, that users from multiple tenants interact with.

    A multitenant agent must be tenant-aware. If you configure appropriate guardrails, it can work with data and tools for a single tenant. Enforce guardrails deterministically at key boundaries, including handoffs between agents and when invoking tools.

    Multitenant agents tend to be relatively simple to deploy, but they're harder to implement because of the level of tenant isolation required. Depending on the agent platform you use, you might or might not have control over isolation for certain aspects, like tool calling and state.

- **Single-tenant agents.** A single-tenant agent is specialized for an individual tenant. It might be given broad access to that specific tenant's data or tools. It can be straightforward to configure tenant guardrails in a single-tenant agent because you can embed them into the agent's configuration rather than building conditional logic.

    However, single-tenant agents introduce operational complexity at scale. You must define, deploy, version, and manage a separate agent instance for each tenant. If you use hosted agent platforms, you need a strategy for how to create, update, and maintain tenant-specific deployments efficiently.

In a multitenant solution, it's common to use both multitenant and single-tenant agents. For example, a multitenant agent might answer questions about tenant data stored in your system, while single-tenant agents integrate with each tenant's backend systems.

## Tenant-specific configuration

Multitenant solutions often allow tenants to customize agent behavior to meet their business, compliance, and operational requirements. Treat tenant-specific configuration as tenant-scoped data. Apply the same isolation, authorization, and lifecycle management controls that you use for other tenant data.

The following list provides common examples of places where tenant-specific configuration is used. Consider whether tenants might have different requirements for each of these items:

- Enabled tools and integrations, including external APIs, Model Context Protocol (MCP) servers, and Agent2Agent (A2A) endpoints
- Model selection or model parameters
- Knowledge sources and retrieval settings
- Memory retention policies
- Approval workflows for sensitive actions
- Enabled experimental features

Validate this configuration before exposing tools or agents, and don't allow the model to select or modify configuration, endpoints, credentials, or tenant context.

Avoid allowing one tenant's configuration choices to affect another tenant's experience. For example, ensure that feature flags, tool permissions, and retrieval settings are evaluated within the context of the current tenant.

When configuration influences data access, authorization decisions, or tool execution, enforce the configuration through deterministic controls rather than relying on prompts or agent instructions.

## Identity

Agents can function autonomously or semi-autonomously on behalf of users. Consider the identity they use to access data and systems, including credentials and authorization. The two common approaches are agent identities and delegated access.

- **Agent identity:** The agent has its own independent identity, which you grant permissions to data or systems separately from any user identity.

    Where possible, use identity models specifically designed for agents. Prefer managed or federated identities instead of long-lived credentials. Reducing credential management requirements can improve security and increase operational simplicity.

    When you use an agent identity with a multitenant agent, design the entire request flow to isolate tenants. An agent identity establishes who the agent is and which resources it can access, but it doesn't determine which tenant's data the agent is authorized to access. Propagate and enforce tenant context throughout the request flow by using deterministic code rather than relying on the identity itself.
    
    Prefer designs that reduce the scope of permissions granted to any single agent identity. Smaller permission boundaries can help limit the impact of authorization defects or configuration errors.
    
    > [!CAUTION]
    > An agent identity might have permissions across multiple tenants or tenant resources so that it can do its work. It's your responsibility to ensure that those permissions don't allow tenant boundaries to be crossed.

    In Azure, consider using [Microsoft Entra agent identities](/entra/agent-id/agent-identities) to authenticate an agent.

- **Delegation:** The agent uses a delegated access token to call downstream APIs or other systems on behalf of the user. The agent can access data and systems that the user has access to.

    The OAuth on-behalf-of (OBO) flow is one example of a *delegated* authorization model. In other delegation models, the user might be able to limit the agent to a subset of the user's permissions or data.

    This type of identity helps to enforce tenant and user access controls. It can simplify authorization because the user's tenant context and permissions are available to downstream systems. However, multitenant isolation should still be enforced through explicit authorization and tenant-aware resource access controls.

    In Azure, consider using [Microsoft Entra agent identities with the OBO OAuth flow](/entra/agent-id/agent-on-behalf-of-oauth-flow) for delegated authorization.

> [!IMPORTANT]
> Apply the principle of least privilege regardless of the identity model you choose. Grant agents only the permissions required to perform their task, and prefer delegated authorization models when access should be constrained by a user's permissions.

### Choosing an identity model

Agentic systems often involve multiple identities within a single request flow:

- **User identity.** The user who initiated the request.
- **Delegated identity.** The permissions granted on behalf of the user, such as through OAuth delegation or OBO flows.
- **Agent identity.** The workload identity used by the agent itself.

These identities can coexist within the same workflow and serve different purposes.

Select the identity model based on who is ultimately authorized to perform the action.

| Scenario | Recommended authorization model |
|-|-|
| Accessing user-scoped tenant data | Delegated authorization (for example, OBO) |
| Performing actions that require the user's permissions | Delegated authorization |
| Asynchronous or background processing that retains user authorization | Delegated authorization when the flow and resource support it |
| Background or scheduled processing authorized by the application | Agent identity |
| Infrastructure operations | Agent identity |
| Mixed workflows | Combination of delegated and agent identities |

The agent identity and delegation approaches can be used together in different parts of a solution. For example, an agent might access tenant documents by using the user's identity but use its own identity to store workflow state or emit telemetry.

You should enforce authorization decisions by using explicit tenant context rather than assuming the tenant based on the identity type being used. For user-authorized access to tenant data, prefer delegated authorization models such as OAuth delegation or OBO flows rather than granting broad access to the agent's own identity.

### Identity isolation strategy

After selecting an authorization model, choose an identity architecture that aligns with your isolation and operational requirements. Different multitenant architectures use different identity isolation models. Some systems use a shared multitenant agent identity and rely on authorization and resource partitioning. Others use tenant-scoped identities or dedicated deployments to improve isolation. These approaches can improve isolation but often introduce additional operational complexity.

Consider the following isolation strategies:

| Identity architecture | Characteristics | Benefits | Tradeoffs |
|-|-|-|-|
| Shared multitenant agent identity | Single identity serves multiple tenants | Simpler operations and lower management overhead | Strong authorization and tenant isolation controls are required |
| Tenant-scoped agent identities | Separate identity per tenant | Reduces blast radius of authorization or configuration failures | Higher operational complexity because there are more identities to maintain |
| Dedicated tenant deployments | Agent and resources deployed separately per tenant | Strong isolation and compliance support | Higher deployment and operational costs |
| Delegated authorization (for example, OBO) | Agent acts by using user-authorized permissions | Aligns access with user permissions and tenant context | Not suitable for background or autonomous operations that run outside of a user context |
| Hybrid approach | Combines delegated and agent identities | Flexibility across different workloads | Increased design complexity |

No single identity architecture is appropriate for all multitenant agentic systems. As isolation requirements increase, many solutions move from shared multitenant identities toward tenant-scoped identities or dedicated deployments. These approaches can reduce the impact of authorization defects or configuration errors, but they generally increase operational complexity.

### Permission management

Multitenant agentic systems can create a complex permission matrix, especially if you deploy multiple agents or use a set of tenant-specific agent identities. Each agent might need access to different tools and resources, and those permissions must be granted separately for each tenant.

To manage this complexity, follow these guidelines:

> [!div class="checklist"]
> - **Consider the operational cost of tenant-specific deployments.** If you deploy an agent instance for each tenant, you also deploy a set of credentials or identities per tenant. Factor this operational overhead into your deployment strategy.
>
> - **Centralize permission management.** Use a tool gateway or identity provider to define and enforce permissions in one place, rather than scattering permissions across multiple resources and systems.
>
> - **Audit and validate permissions regularly.** As the number of agents and tenants grow, it's easy for permissions to become out of sync or overly broad. Implement regular reviews to detect and remediate permission drift.

## Prompt injection and input validation

Agents often use user-provided input to select tools, retrieve information, and execute actions. In a multitenant solution, malicious or accidental prompts might attempt to access data belonging to another tenant. Similarly, any content that's sent to a model as context can potentially contain attempts to cross tenant boundaries, including results from tool calling, memory, and documents used as grounding sources.

Treat prompts as untrusted input. Validate all requests that influence data access, retrieval, tool invocation, or action execution before performing the operation. Use [Prompt Shields in Content Safety](/azure/ai-services/content-safety/concepts/jailbreak-detection), and also design your overall architecture to ensure agents can't access systems or data that they don't need.

> [!IMPORTANT] 
> Don't rely on prompts, system instructions, or model behavior to enforce tenant isolation. They aren't security boundaries. Instead, enforce tenant boundaries through tenant-scoped identities, deterministic authorization policies, resource partitioning, and tool-level access controls.

## Tool calling

*Tools* are typically APIs, command-line applications, or other structured interfaces that provide access to another system's data or functionality. Many tools are implemented to be deterministic, and you can test them in isolation from the agents that use them. You might also use them in other applications besides agents.

In a multitenant environment, you might have one or both of the following types of tools:

- **Tenant-specific tools:** Some tools are specific to a single tenant or a subset of tenants. For example, a multitenant financial processing system might use a tenant-specific tool to generate and send invoices on behalf of that tenant. It's important that tool availability is scoped to the current tenant context. An agent should only be able to discover and invoke tools that are authorized for the current tenant.

- **Shared tools:** Other tools are shared among tenants but require valid tenant context throughout the request flow. For example, a document search tool might search a shared knowledge base but filter by tenant.

    Your agent needs to ensure that the appropriate tenant context is provided. Tenant context should be derived from trusted application state or security tokens rather than from model-generated content. You might derive context via tokens, which can contain tenant identification claims. Or you might have some other way to inject a tenant identifier through the tool-calling processes. Verify that these processes are secure and tamper-resistant. For example, passing a tenant ID through a query string is a security risk if your agent relies on client-side application logic to invoke tools.

### Tool discovery

*Tool discovery* is the process by which your application tells the agent which tools it can invoke. Tool discovery introduces multitenancy considerations because the set of available tools becomes tenant-specific data. Similar considerations apply to dynamic agent discovery, which should also be governed by tenant-aware authorization controls.

A tenant should only be able to discover tools that are available to that tenant. Even if invocation is blocked later, exposing tool metadata can reveal information about other tenants, services, or business processes.

[MCP servers](/azure/foundry/agents/how-to/tools/model-context-protocol) are one way to expose tools and external data sources to agents. If tenants provide MCP server connections, treat those connections, their authentication configuration, and the tools that they advertise as tenant-scoped configuration. Allow only approved MCP servers and tools for the current tenant.

Treat tool descriptions, annotations, and results from remote MCP servers as untrusted input. Tool metadata supplied by external systems becomes part of the model's context and can influence model behavior. Validate and govern tool metadata in the same way as any other model input.

### Tool gateways

Consider using a *tool gateway*, like Azure API Management, as a centralized abstraction layer in front of a suite of tools. Tool gateways can act as [gatekeepers](../../../patterns/gatekeeper.md), enforcing governance and compliance, and verifying that tenant context is being passed to each tool that requires it. They can also enforce access policies and provide rate limiting functionality that's helpful for high-scale agentic applications.

Consider using a centralized tool gateway to:

- Restrict which tools are discoverable for each tenant, and enable or disable MCP server connections for each tenant.
- Enforce authorization before tool invocation.
- Validate tool metadata before it's exposed to the model.
- Audit tool discovery and usage activity.

### Client-side and server-side tool calling

When an agent calls a tool, the execution model affects your ability to enforce tenant context. In client-side tool calling, your code is responsible for executing the tool and can inject tenant context deterministically before each call. For server-side tools, verify that the platform or agent application can propagate trusted tenant context and tenant-scoped credentials or configuration to every invocation. If it can't, use dedicated containers or separate tool configurations for each tenant. Regardless of which execution model you use, ensure that your tools and agent design together enforce tenant boundaries. The specific mechanisms depend on your agent framework or platform.

Evaluate authorization decisions each time a tool is invoked. Don't infer the authorization from earlier steps in the workflow.

> [!CAUTION]
> Never rely on the model to propagate a tenant or user context, or assume that the model will do so. Model behavior is inherently unpredictable, even with clear prompts. Deterministic code should handle tenant context management. Avoid any situations where the tenant ID can be set or changed by the model.

### Accessing shared resources

If you deploy tenant-specific agents, you might still need those agents to access shared resources like a shared database or knowledge base through tools. In this scenario, you have several options to choose from, based on your compliance requirements and operational model:

- **Single agent identity with tenant-aware tools.** Grant the shared agent identity access to the shared resource and rely on your tools and deterministic code to filter data appropriately for the tenant. This approach simplifies permissions but requires careful implementation to prevent cross-tenant data leakage.

- **Tenant-specific agent identities with partition-based access.** If your shared resource supports partition-based access control (for example, row-level security in a database), grant each tenant's agent identity access only to its partition. This approach provides strong isolation but might require credential management at scale.

- **Delegated authorization.** Use delegated user permissions when accessing shared resources on behalf of a user. This approach can reduce the need for broad permissions on the agent identity and align access control with the user's existing permissions.

### Security and governance

For high-risk actions, consider introducing approval workflows before tool execution. Examples include financial transactions, administrative operations, customer record modifications, or actions that affect external systems. Human approval workflows can help reduce the impact of prompt injection attacks, authorization mistakes, and unintended model behavior. Approvals don't replace deterministic tenant authorization checks. Both checks should be performed.

## State, memory, and persistence

Agents work with multiple types of *state*. Each of these types of state needs to be isolated between tenants:

| Type of data | Examples | Reason for tenant isolation |
|-|-|-|
| Conversation records | Session metadata, transcripts of conversations between the user and the agent, files the user uploaded, and details of the agent's activities during the conversation, including tool calling, reasoning, and handoff notes. | Might inadvertently store tenant-specific data. The questions that tenants ask, or requests that they make, can refer to proprietary data. |
| Memory | User profile facts, conversation summaries, learned procedures, and other knowledge retained across conversations. | By its nature, memory stores user-specific facts that shouldn't be shared with other users or tenants, like questions about a tenant's customers or financial data.<br /><br />Avoid *memory bleed*, where memory is shared across tenants because of poor isolation. Verify whether memory is scoped to a user, conversation, tenant, or agent instance, and ensure the scope aligns with your isolation requirements. |
| Generated artifacts | Documents or other items generated by the agent, either as the final result of the conversation or as intermediate results during the conversation. | Artifacts that the agent generates probably contain proprietary information that could be subject to data management policies. In addition to keeping tenant data separated, the agent might need to apply data sensitivity labels based on the tenant's rules. When an agent ingests sensitive documents, all downstream artifacts and handoffs should inherit the highest sensitivity classification from the source documents. |

Evaluate each data store used by the agent, and verify that it meets your tenant isolation requirements. If you use a hosted service, it might abstract the details of how some of its data is stored. Verify that the service provides the region placement, logical partitioning, export, retention, and deletion controls that the tenant requires. If it doesn't, select another service or place the tenant in a regional or tenant-dedicated deployment that can enforce the requirements.

Where possible, store references to tenant data rather than duplicating tenant data within agent memory or conversation state.

For broader guidance about isolating and managing tenant data throughout its lifecycle, see [Architectural approaches for storage and data in multitenant solutions](../approaches/storage-data.md#complexity-of-management-and-operations).

## Subagent invocation and agent handoff

It's common to build a suite of specialized agents, each with a specific role or focus. For example, one agent might have access to specialized knowledge or data that helps it answer questions about a topic, while another agent can be optimized for taking actions.

To achieve a user's goal, an agent might invoke a *subagent* or *hand off* work to another agent:

- When an agent invokes a subagent, the invoking agent delegates a task but retains responsibility for the conversation and overall workflow.
- In a handoff, responsibility for the next part of the interaction moves to the target agent.

Both patterns create boundaries where you must preserve and validate tenant context. Some agents might be single-tenant and others might be multitenant.

### Agent discovery

If agents are discovered dynamically, ensure that discovery is mediated by deterministic authorization logic rather than model reasoning. A tenant should only be able to discover agents that are installed, licensed, or explicitly available for that tenant.

Implement discovery through a trusted registry, catalog, or orchestration layer that evaluates tenant context and authorization before returning available agents. Treat agent metadata as tenant-scoped information. Even if invocation is blocked, exposing unauthorized agent metadata can reveal information about services, capabilities, or business processes.

### Agent2Agent

The Agent2Agent (A2A) protocol provides a standardized way for agents to communicate. You can use A2A when invoking a subagent or implementing other agent-to-agent collaboration patterns, but the protocol doesn't determine whether the interaction is an invocation or a handoff.

Consider whether you should treat A2A endpoints, authentication settings, and agent metadata as tenant-scoped data. Before each A2A invocation, verify that the current tenant is authorized to discover and invoke the target agent. Choose shared or individual authentication based on whether the operation requires the user's identity and permissions, and re-establish tenant and user context through deterministic logic.

> [!NOTE]
> The A2A protocol includes an optional `tenant` field. This field is used for routing and isn't a secure way to pass tenant context between agents.

### Tenant context and permissions

Treat every agent invocation and handoff as a trust boundary. Use deterministic logic to propagate and re-establish tenant and user context from trusted application state rather than model-generated content, conversation history, or previous prompts. If a flow transitions between single-tenant and multitenant agents, validate each transition and revalidate authorization.

Users or tenants might grant different permissions to different agents. Each agent should validate that it has the permissions required to perform its task and shouldn't assume that permissions granted to a previous agent remain valid.

Long-running or asynchronous agent tasks create trust boundaries after the initial invocation. Verify that all agents and their tasks associate their work with the tenant context.

## Resource management

Agents can use a lot of resources. In particular, the types of reasoning-focused model interactions that agents use can consume large numbers of tokens. Some models and model platforms limit the number of tokens that a single application can use during a defined time period. If you use Foundry Agent Service, review its [limits, quotas, and regional support](/azure/foundry/agents/concepts/limits-quotas-regions) when you plan capacity.

Because agents can consume large numbers of tokens, they can encounter [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), where one tenant's activities affect another tenant's ability to use the system. If a small number of tenants use up your model's token allowance, other tenants can't use your agent.

To manage your agent's resources effectively, follow these guidelines:

> [!div class="checklist"]
> - **Monitor token usage by tenant.** Most models include token usage on each response. Store that information and aggregate it so you can detect whether specific tenants or users are using much higher numbers of tokens than you expect.
> 
> - **Monitor other resource dimensions.** Track tool invocation frequency, memory storage size, agent execution duration, and background task volume in addition to token consumption. These resources can also contribute to noisy neighbor problems.
> 
> - **Apply governance and cost management.** Implement quota management mechanisms described in the [Noisy Neighbor antipattern](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), such as tenant-scoped or user-scoped rate limits, or behavioral nudges like giving users an alert when their usage is unusually high.
> 
> - **Deploy dedicated capacity.** If you have high-use tenants, consider whether you can partition them to use their own dedicated capacity, and reflect that in your [pricing model](./pricing-models.md).

## Observability and auditing

Agentic systems can make many decisions and invoke multiple tools during a single interaction. In a multitenant environment, maintain audit records for:

- Each major operation performed, including the user identity, tenant identifier, and agent identity that performed it.
- Tool invocations.
- Subagent invocation and agent handoff operations.
- Data retrieval actions.

If you use Microsoft Foundry, see [Trace agents](/azure/foundry/observability/how-to/trace-agent-setup) for guidance on collecting and reviewing trace data.

> [!CAUTION]
> Traces and audit records can contain sensitive data, including prompts and tool inputs and outputs. Ensure that they're isolated between tenants and that tenant administrators can access only their own operational data.

## Testing and validating tenant isolation

Agentic systems introduce probabilistic behavior because model outputs aren't deterministic. A successful test doesn't prove that tenant isolation controls are correct.

Focus testing on deterministic boundaries rather than model behavior. Consider validating the following scenarios:

- Verify that an identity issued for one tenant can't access resources belonging to another tenant, even if a different tenant identifier is supplied.
- Test every subagent invocation and agent handoff path, and verify that tenant context is re-established explicitly at each transition.
- Attempt direct cross-tenant data access below the agent layer and verify that tenant partitioning controls prevent access.
- Run automated adversarial and fuzz testing suites repeatedly as part of deployment pipelines.

Tenant isolation shouldn't depend on model behavior. Isolation should continue to work even when the model produces unexpected outputs. However, you should also execute adversarial prompts that attempt to access another tenant's data and verify that requests are rejected by authorization, API, or data-layer controls.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Daphne Choong](https://www.linkedin.com/in/daphnecys) | Senior Partner Solution Architect, Enterprise Partner Solutions
- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Senior Partner Solution Architect, Enterprise Partner Solutions

Other contributors:

- [Mamoru Kuroda](https://www.linkedin.com/in/mamoru-kuroda-2278a6157/) | Partner Solution Architect, Enterprise Partner Solutions
- [Kodai Sakabe](https://www.linkedin.com/in/koudaiii/) | Partner Solution Architect, Enterprise Partner Solutions

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Design a secure multitenant RAG inferencing solution](/azure/architecture/ai-ml/guide/secure-multitenant-rag)
- [Architectural approaches for AI and machine learning in multitenant solutions](../approaches/ai-machine-learning.md)
- [Multitenancy and Azure OpenAI](../service/openai.md)
- [Use Azure API Management in a multitenant solution](../service/api-management.md)
