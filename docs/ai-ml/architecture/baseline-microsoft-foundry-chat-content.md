Enterprise chat applications let employees interact with AI agents through natural language conversations. These applications use language models, like OpenAI GPT models, and open-source development kits, like the Microsoft Foundry SDKs or the Microsoft Agent Framework. These chat applications typically consist of the following components:

- A chat user interface (UI) that's integrated into a larger enterprise application. It provides users with a conversational experience alongside other business functions.

- Data repositories that contain domain-specific information that's pertinent to user queries.

- Language models that reason over the domain-specific data to produce relevant responses.

- A persisted orchestration definition or long-lived agent that oversees the interactions between data sources, language models, and the user.

This article provides a baseline architecture to help you build and deploy enterprise chat applications by using [Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) and [Azure OpenAI](/azure/ai-services/openai/concepts/models). This architecture uses a single, prompt-based agent persisted in Foundry Agent Service. The agent receives user messages and then queries data stores to retrieve grounding information for the language model.

The chat UI follows the [baseline Azure App Service web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) guidance about how to deploy a secure, zone-redundant, and highly available web application on App Service. In that architecture, App Service communicates with the Azure platform as a service (PaaS) solution through virtual network integration over private endpoints. In the chat UI architecture, App Service communicates with the agent over a private endpoint. This architecture blocks public access to the Foundry portal and agents.

> [!IMPORTANT]
> This article doesn't describe the components or architecture decisions from the [baseline App Service web application architecture](../../web-apps/app-service/architectures/baseline-zone-redundant.yml). For guidance about how to host the web application that contains your chat UI, see that article.

This architecture uses the [Foundry Agent Service standard agent setup](/azure/ai-services/agents/concepts/standard-agent-setup) to provide enterprise-grade security, compliance, and control. In this configuration, you bring your own network for network isolation and your own Azure resources to store chat and agent state. All communication between application components and Azure services occurs over private endpoints. This approach ensures that data traffic remains within your workload's virtual network. Outbound traffic from the agents strictly routes through Azure Firewall, which enforces egress rules.

> [!TIP]
> :::image type="icon" source="../../_images/github.svg"::: The [Foundry Agent Service reference implementation](https://github.com/Azure-Samples/microsoft-foundry-baseline) showcases a baseline end-to-end chat implementation on Azure. It serves as a foundation to develop custom solutions as you move toward production.

## Architecture

:::image type="complex" source="_images/baseline-microsoft-foundry.svg" border="false" lightbox="_images/baseline-microsoft-foundry.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture that uses Foundry.":::
   The diagram presents a detailed Azure architecture for deploying an AI solution. On the left, a user connects through Azure Application Gateway with a web application firewall, which is part of a virtual network. This gateway is linked to private DNS zones and protected by Azure DDoS Protection. Under the gateway, private endpoints connect to services like App Service, Azure Key Vault, and Azure Storage, which are used for client app deployment. App Service is managed with identity and spans three zones. Application Insights and Azure Monitor provide monitoring, and Microsoft Entra ID handles authentication. To the right, the virtual network contains several subnets: App Service integration, private endpoint, Foundry integration, Azure AI agent integration, Azure Bastion, jump box, build agents, and Azure Firewall. Each subnet hosts specific endpoints or services, like storage, Foundry, Azure AI Search, Azure Cosmos DB, and knowledge store, all connected via private endpoints. Outbound traffic from the network passes through Azure Firewall to reach internet sources. To the far right, a separate box represents Foundry, which includes an account and a project. Managed identities connect Foundry Agent Service to the Foundry project, which in turn accesses an Azure OpenAI model. The diagram uses numbered green circles to indicate the logical flow. It shows how user requests traverse the network, interact with various endpoints, and ultimately connect to Foundry and storage services, with dependencies clearly grouped and labeled.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-microsoft-foundry.vsdx) of this architecture.*

### Workflow

1. An application user interacts with a chat UI. The requests route through Azure Application Gateway. Azure Web Application Firewall inspects these requests before it forwards them to the back-end App Service instance.

1. When the web application receives a user query or instruction, it invokes the purpose-built agent. The web application communicates with the agent endpoints via the [Foundry C# SDK](/azure/ai-foundry/how-to/develop/sdk-overview?view=foundry&preserve-view=true&pivots=programming-language-csharp). The web application calls the agent over a private endpoint and authenticates to Foundry by using its managed identity.

1. The agent processes the user's request based on the instructions in its system prompt. To fulfill the user's intent, the agent has a configured language model, connected tools, and connected knowledge stores.

1. The agent connects to the knowledge store (Azure AI Search) in the private network via a private endpoint.

1. Requests to most external knowledge stores or tools, like Wikipedia, traverse Azure Firewall for inspection and egress policy enforcement.

1. The agent connects to its configured language model and passes relevant context.

1. Before the agent returns the response to the UI, it persists the request, the generated response, and a list of consulted knowledge stores into a dedicated *memory* database. This database maintains the complete conversation history, which supports context-aware interactions and lets users resume conversations with the agent without losing prior context.

   The Foundry APIs support the development of user experiences that manage multiple concurrent, context-isolated conversations.

### Components

This architecture builds on the [basic Foundry chat reference architecture](./basic-microsoft-foundry-chat.yml#components). This architecture introduces more Azure services to address enterprise requirements for reliability, security, and operational control. Each of the following components plays a specific role in a production enterprise chat solution:

- [Foundry Agent Service](/azure/ai-services/agents/overview) is a cloud-native runtime environment that lets intelligent agents operate securely and autonomously. In this architecture, Foundry Agent Service provides a managed runtime for a prompt-based agent and integrates with Azure services. It hosts and manages agents that do the following tasks:

  - Process user requests
  - Orchestrate calls to tools and other agents
  - Enforce content safety
  - Integrate with enterprise identity, networking, and observability

  The [standard agent setup](/azure/ai-services/agents/concepts/standard-agent-setup) ensures network isolation and provides control over data storage. You supply dedicated Azure resources for agent state, chat history, and file storage, but Foundry Agent Service manages them exclusively. Other application components in the workload shouldn't use these required resources.

  - [Azure Cosmos DB for NoSQL](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, document database service. In this architecture, it hosts the workload's memory database, called `enterprise_memory`, within your subscription. This database stores the agent's operational state, including chat conversations and agent definitions. This design ensures that chat history and agent configuration are isolated, auditable, and managed according to data governance requirements. Foundry Agent Service manages the database, its collections, and its data.

  - [Azure Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud storage service for unstructured data. In this architecture, it provides dedicated storage for files uploaded during chat sessions. Hosting this account in your subscription provides granular access control, auditing capabilities, and compliance with data residency or retention policies. Foundry Agent Service manages the containers and data life cycle within those containers.

  - [AI Search](/azure/search/search-what-is-azure-search) is a managed search solution that provides search capabilities. In this architecture, it stores a searchable, chunked index of uploaded files from conversations with the agent. AI Search also stores chunked, static files that you add as knowledge sources during agent creation. These files remain available across all agent invocations. Foundry Agent Service manages the index, schema, and data, and uses its own chunking strategy and query logic.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic load balancer and application delivery controller. In this architecture, it acts as a secure, scalable entry point for all HTTP and HTTPS traffic to the chat UI. It also provides Transport Layer Security (TLS) termination and path-based routing. Application Gateway distributes requests across availability zones, which supports high availability and performance for the web application tier. Its back end is the App Service instance that hosts the application code.

  - [Azure Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) is a cloud-native service that protects web applications from common web exploits. In this architecture, it integrates with Application Gateway to protect the chat UI from common web vulnerabilities and attacks. It inspects and filters HTTP requests, which provides a security layer for public-facing applications.

  - [Azure Key Vault](/azure/key-vault/general/overview) is a cloud service for securely storing and accessing secrets, keys, and certificates. In this architecture, it securely stores and manages the TLS certificates that Application Gateway requires. Centralized certificate management in Key Vault supports automated rotation, auditing, and compliance with organizational security standards. This architecture doesn't require stored keys or other secrets.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for private networks in Azure. In this architecture, it provides network isolation for all components to help you meet security and compliance requirements. When you place resources in a private virtual network, you control east-west and north-south traffic, enforce segmentation, keep traffic private, and provide inspection of ingress and egress flows.

- [Azure Private Link](/azure/private-link/private-link-overview) is a networking service that provides private connectivity from a virtual network to Azure PaaS services. In this architecture, it connects all PaaS services, like Azure Cosmos DB, Storage, AI Search, and Foundry Agent Service, to the virtual network via private endpoints. Private Link helps you ensure that all data traffic remains on the Azure backbone, which eliminates exposure to the public internet and reduces the attack surface.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a managed, cloud-based network security service. In this architecture, it inspects and controls all outbound (egress) traffic from the virtual network. It also enforces fully qualified domain name (FQDN)-based rules, which ensures that only approved destinations are reachable. This configuration helps prevent data exfiltration and meet requirements for network security.

- [Azure DNS](/azure/dns/dns-overview) is a hosting service for DNS domains that provides name resolution. In this architecture, it provides private DNS zones linked to the virtual network. It handles name resolution for private endpoints, which ensures that all service-to-service communication uses private IP addresses and remains within the network boundary.

- [Azure Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud storage service for unstructured and structured data. In this architecture, it supports secure, automated deployment workflows and separates application artifacts from compute resources. It hosts the web application code as a ZIP file for deployment to App Service.

### Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and trade-offs.

#### Chat orchestration

**Current approach:** This architecture uses [Foundry Agent Service](/azure/ai-services/agents/overview) to orchestrate prompt-based agent execution flows, including fetching grounding data from knowledge stores, invoking AI models, and enforcing consistent response behavior based on the agent's system-level instructions and conversational history. Foundry Agent Service provides codeless, nondeterministic orchestration for conversational AI workloads. It manages chat requests, conversation state, tool invocation, content safety, and integration with identity, networking, and observability. The service supports persistence of conversational context and agent state through a predefined data model deployed into a database within your subscription.

**Alternative approach:** You can host agents and implement custom execution logic by using frameworks like the [Agent Framework](/agent-framework/overview/agent-framework-overview), [Semantic Kernel](/semantic-kernel/overview/), [LangChain](/azure/ai-foundry/how-to/develop/langchain), or custom code that adheres to the Foundry protocol. In this alternative, Foundry Agent Service continues to manage conversation orchestration and state, while your agent code augments or extends the execution behavior within those protocol boundaries. Use hosted agents to deploy and run containerized, deterministic, code-driven agent execution on Foundry Agent Service. The platform manages infrastructure and core orchestration capabilities.

Consider hosted agents instead of prompt-based agents when your workload requires one or more of the following capabilities:

- Use of models not [supported by Foundry Agent Service](/azure/ai-foundry/agents/concepts/model-region-support), or integration with tools not exposed by the service

- Fine-grained, deterministic control over the agent execution path, including explicit orchestration patterns, external systems or tools invocations, prompt engineering, connection with multiple agents, or human-in-the-loop intervention

- Reuse of existing codebases or libraries that handle complex business processes

- Agent code auditing, inspection, or certification for security, compliance, or regulatory purposes

- Advanced client request routing for experimentation

- Safe deployment practices beyond the standard hosted agents life cycle

- Fine-tuned agent runtime configuration, including CPU and memory allocation or autoscaling settings

- Extended memory stored in a separate database alongside the native Foundry Agent Service conversation state

Self-hosted orchestration increases operational complexity and requires you to manage compute, scaling, and security.

#### Application tier components

**Current approach:** The chat UI front-end website is hosted on the Web Apps feature of App Service, which provides a managed, scalable platform for web applications. Web Apps integrates natively with Azure networking and security features.

**Alternative approach:** You can use other Azure-managed compute platforms, like Azure Container Apps or Azure Kubernetes Service (AKS), to host the application tier.

Consider this alternative if your workload meets any of the following conditions:

- Another compute platform better supports certain use cases, and colocating services on that platform can improve cost efficiency and simplify operations

- Your application requires more sophisticated scaling, orchestration, or custom networking

App Service remains the preferred option for its simplicity in hosting web applications and their APIs.

#### Grounding data (knowledge) store

**Current approach:** This architecture uses AI Search as the primary data store for grounding knowledge. It uses AI Search vector search and semantic ranking capabilities.

**Alternative approach:** You might use other data platforms for grounding knowledge, like Azure Cosmos DB, Azure SQL Database, or other online transaction processing (OLTP) data stores. Your data platform depends on your existing data estate, data freshness requirements, and query requirements.

Consider this alternative if your workload meets any of the following conditions:

- You already manage your grounding knowledge in an existing transactional or operational database

- You require multi-model or SDK support not available in AI Search

- You need to integrate with specialized data sources or legacy systems

Vector search is common for retrieval-augmented generation but not always required. For more information, see [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search). Before you choose a data store, evaluate the data access patterns, latency, and scalability needs of your workload.

#### Predefined agent or dynamically created agent

**Current approach:** The reference implementation uses a statically defined agent that's deployed as a microservice within Foundry. The agent's logic and data sources are configured at deployment and remain unchanged until the next application release. This approach works well when agent behavior and data sources are stable and controlled through DevOps processes.

**Alternative approach:** You can dynamically create or modify agents at runtime by using the Foundry SDKs. This approach lets the application instantiate agents on demand, adjust system prompts, or reconfigure connections based on user context or business logic.

Consider dynamic agents if your workload requires the following capabilities:

- Personalized agent behavior or data sources for each user or session

- Frequent or programmatic changes to agent configuration

- Ephemeral, context-specific agent support for advanced user experiences

Dynamic agent management increases flexibility but also introduces the burden of life cycle management. Ensure that you have appropriate controls for agent creation, modification, and cleanup.

Choose the agent approach that aligns with your workload's user experience requirements.

#### Single-agent or multiagent orchestration

**Current approach:** This reference architecture uses a single agent that has access to all necessary knowledge sources and tools to handle most user interactions effectively.

**Alternative approach:** You can orchestrate multiple specialized agents, where each agent focuses on specific domains, uses different models, or accesses distinct knowledge stores and tools.

Consider a multiagent approach when your workload exhibits the following characteristics:

- Requests span multiple expertise areas, like financial analysis, legal review, and technical implementation. Specialized agents provide deeper, more accurate responses within their respective domains.

- Information requires different permission levels. A human resources (HR) agent might access employee data, while a customer service agent accesses only product information. Multiagent architectures support granular security boundaries at the agent level.

- Different query interactions benefit from different models. A lightweight model handles simple questions, while a more powerful model processes complex reasoning tasks. This approach optimizes both cost and latency.

- The chat experience serves as a front end to business processes that involve sequential or parallel steps that require different specialists.

Multiagent approaches introduce coordination complexity and increased latency because of communication between agents. Use a single agent when your use case is well-defined, doesn't require strict access isolation, and can be handled effectively by one model with a reasonable set of tools.

For more information about how to implement multiple coordinated agents, see [AI agent orchestration patterns](../guide/ai-agent-design-patterns.md). This article covers sequential, concurrent, group chat, handoff, and magentic orchestration approaches. You can implement some patterns within Foundry Agent Service. Other patterns require self-hosted orchestration by using an SDK like Agent Framework.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

Apply this architecture and the [AI workloads on Azure design guidance](/azure/well-architected/ai/get-started) during the design phase of your workload.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The baseline App Service web application architecture focuses on zonal redundancy for key regional services. Availability zones are physically separate locations within a region that provide redundancy when you deploy two or more instances across them. If one zone experiences downtime, other zones in the region might remain unaffected. The architecture also distributes instances and configurations of Azure services across availability zones. For more information, see [Baseline highly available zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml).

This section addresses reliability for components not covered in the App Service baseline architecture, specifically Foundry and AI Search.

#### Zone redundancy in your orchestration layer

Enterprise deployments usually require zonal redundancy to minimize the risk of service disruption from zone-level failures. In Azure, zonal redundancy means that you use resources that support [availability zones](/azure/reliability/availability-zones-overview) and deploy at least three instances, or activate platform-level redundancy where direct instance control is unavailable.

In this architecture, Foundry hosts the Foundry Agent Service capability. The agent's reliability depends on the availability of the Foundry Agent Service dependencies, which are Azure Cosmos DB, Storage, and AI Search. Foundry Agent Service manages the data within these services, but you configure their reliability in your subscription.

To achieve zonal redundancy for the orchestration layer, follow these recommendations:

- Turn on [zone redundancy in your Azure Cosmos DB for NoSQL](/azure/reliability/reliability-cosmos-db-nosql#availability-zone-support) account. This configuration ensures synchronous data replication across multiple zones, which reduces the risk of data loss or downtime from a single-zone failure.

  Also consider [global distribution](/azure/cosmos-db/distribute-data-globally) to mitigate regional outages within Azure Cosmos DB.

- Use [zone-redundant storage (ZRS)](/azure/storage/common/storage-redundancy-zrs#zone-redundant-storage) for your Storage account. For higher resilience, use [geo-zone-redundant storage (GZRS)](/azure/storage/common/storage-redundancy-zrs#geo-zone-redundant-storage), which combines zonal and regional redundancy.

- [Configure your AI Search instance](/azure/search/search-reliability#availability-zone-support) with at least three replicas. This configuration ensures that the service distributes replicas across unique zones in your region.

If your agent integrates with other workload-specific dependencies, like custom tool connections or external knowledge stores, ensure that those dependencies meet your availability and redundancy requirements. Any single-zone or nonredundant dependency can undermine the overall reliability of the orchestration layer.

The Foundry portal, its data plane APIs, and the Foundry Agent Service capability don't provide direct controls for zone redundancy.

#### Reliability in Foundry model hosting

Foundry provides models as a service (MaaS) hosting with several deployment options. These options primarily support quota and throughput management, rather than traditional high availability within a region. Standard model deployments operate in a single region and don't support availability zones. To achieve multi-datacenter availability, you must use either a global or data zone model deployment.

For enterprise chat scenarios, deploy both a [data zone provisioned](/azure/ai-foundry/foundry-models/concepts/deployment-types#data-zone-provisioned) and [data zone standard](/azure/ai-foundry/foundry-models/concepts/deployment-types#data-zone-standard) model. Configure [spillover](/azure/ai-services/openai/how-to/spillover-traffic-management) to handle excess traffic or failures. If your workload doesn't require low latency or strict geographic data residency and processing, use global deployments for maximum resilience.

Foundry doesn't support advanced load balancing or failover mechanisms, like round-robin routing or [circuit breaking](/azure/api-management/backends#circuit-breaker), for model deployments. If you require granular redundancy and failover control within a region, host your model access logic outside the managed service. For example, you can build a custom gateway by using Azure API Management. This approach lets you implement custom routing, health checks, and failover strategies. But it also increases operational complexity and shifts responsibility for the reliability of that component to your team.

You can also expose gateway-fronted models as custom API-based tools or knowledge stores for your agent. For more information, see [Use a gateway in front of multiple Azure OpenAI deployments or instances](../guide/azure-openai-gateway-multi-backend.yml).

#### Reliability in AI Search for enterprise knowledge

Deploy AI Search by using the Standard pricing tier or higher in a [region that supports availability zones](/azure/search/search-reliability#prerequisites). Configure at least three replicas to ensure that the service distributes instances across separate availability zones. This configuration provides resilience to zone-level failures and supports high availability for search operations.

To determine the optimal number of replicas and partitions for your workload, use the following methods:

- [Monitor AI Search](/azure/search/monitor-azure-cognitive-search) by using built-in metrics and logs. Track query latency, throttling, and resource usage.

- Use monitoring metrics and logs and performance analysis to determine the appropriate number of replicas. This approach helps you avoid throttling from high query volume, insufficient partitions, or index limitations.

- Ensure indexing reliability by avoiding disruptions from periodic indexing or indexing errors. Consider indexing into an offline index and swapping from your live index to your rebuilt index after you validate data integrity.

#### Reliability in Azure Firewall

Azure Firewall is a critical egress control point in this architecture but represents a single point of failure for all outbound traffic. To mitigate this risk, deploy Azure Firewall [across all availability zones](/azure/firewall/basic-features#built-in-high-availability) in your region. This configuration helps maintain outbound connectivity if a zone becomes unavailable.

If your workload requires a high volume of concurrent outbound connections, configure Azure Firewall with multiple public IP addresses. This approach distributes Source Network Address Translation (SNAT) connections across [multiple IP address prefixes](/azure/virtual-network/ip-services/public-ip-address-prefix), which reduces the risk of SNAT port exhaustion. [SNAT exhaustion](/azure/firewall/firewall-best-practices#recommendations) can cause intermittent or total loss of outbound connectivity for agents and other workload components, which can result in feature downtime or degraded performance.

Monitor [SNAT port usage and firewall health](/azure/firewall/monitor-firewall#analyze-monitoring-data). If you observe connection failures or throughput problems, review firewall metrics and logs to identify and address SNAT exhaustion or other bottlenecks.

#### Isolate Foundry Agent Service dependencies from similar workload components

To maximize reliability and minimize the blast radius of failures, strictly isolate the Foundry Agent Service dependencies from other workload components that use the same Azure services. Specifically, don't share AI Search, Azure Cosmos DB, or Storage resources between the agent service and other application components. Instead, deploy dedicated instances for the agent service's required dependencies.

This separation provides two key benefits:

- It contains failures or performance degradation to a single workload segment, which prevents cascading effects across unrelated application features.

- It lets you apply targeted operational processes, like backup, restore, and failover. These processes are tuned to the specific availability and recovery requirements of the workload flow that uses those resources.

For example, if your chat UI application needs to store transactional state in Azure Cosmos DB, set up a separate Azure Cosmos DB account and database for that purpose, rather than reusing the account or database that Foundry Agent Service manages. Even if cost or operational simplicity motivates resource sharing, the risk of a reliability event affecting unrelated workload features outweighs the potential savings in most enterprise scenarios.

> [!IMPORTANT]
> If you colocate workload-specific data with the agent's dependencies for cost or operational reasons, never interact directly with the system-managed data, like collections, containers, or indexes, that Foundry Agent Service creates. These internal implementation details are undocumented and subject to change without notice. Direct access can break the agent service or result in data loss. Always use the Foundry Agent Service data plane APIs for data manipulation, like fulfilling right to be forgotten (RTBF) requests. Treat the underlying data as off limits and monitor only.

#### Multiregion design

This architecture uses availability zones for high availability within a single Azure region. It's not a multiregion solution. It lacks the following critical elements required for regional resiliency and disaster recovery (DR):

- Global ingress and traffic routing
- DNS management for failover
- Data replication or isolation strategies across regions
- An active-active, active-passive, or active-cold designation
- Regional failover and failback processes to meet recovery time objectives (RTOs) and recovery point objectives (RPOs)
- Consideration of region availability for developer experiences, including the Foundry portal and data plane APIs

If your workload requires business continuity if a regional outage occurs, you must design and implement extra components and operational processes beyond this architecture. Specifically, you need to address load balancing and failover at each architectural layer, including the following areas:

- Grounding data (knowledge stores)
- Model hosting and inference endpoints
- The orchestration or agent layer
- User-facing UI traffic and DNS entry points

You must also ensure that observability, monitoring, and content safety controls remain operational and consistent across regions.

This baseline architecture lacks multiregion capabilities, so regional outages are likely to result in loss of service within your workload.

#### Disaster recovery

Chat architectures contain stateful components, so you must plan for DR. These workloads typically require a memory store for active or paused chat sessions. They also require storage for supplemental data, like documents or images, added to chat conversations. The agent orchestration layer might also maintain state that's specific to conversation flows. In this architecture, Foundry Agent Service uses Azure Cosmos DB, Storage, and AI Search to persist operational and transactional state. The life cycle and coupling of this state across components determines your DR strategy and recovery operations.

For Foundry Agent Service, ensure that you can recover all dependencies to a consistent point in time. This approach helps maintain transactional integrity across the three external dependencies.

The following recommendations summarize guidance from the [Foundry Agent Service disaster recovery](/azure/ai-foundry/how-to/agent-service-disaster-recovery) guide:

- **Azure Cosmos DB:** Turn on [continuous backup](/azure/cosmos-db/online-backup-and-restore) for the `enterprise_memory` database. This setup provides point-in-time restore (PITR) with a seven-day RPO, which includes agent definitions and chat conversations. Test your restore process regularly to confirm that it meets your RTO and that the restored data remains available to the agent service. Always restore to the same account and database.

- **AI Search:** AI Search lacks built-in restore capabilities and doesn't support direct index manipulation. If data loss or corruption occurs, you must contact Microsoft support for assistance with index restoration. This limitation can significantly affect your RTO. If your chat UI doesn't support file uploads and you don't have agents that use static files as knowledge, you might not need a DR plan for AI Search.

  Maintain a separate, regularly updated source of truth for your enterprise grounding knowledge. This practice ensures that you can rebuild indexes when necessary.

- **Storage:** If you have a geo-redundant storage account, use [customer-managed failover](/azure/storage/common/storage-disaster-recovery-guidance#customer-managed-unplanned-failover) for blob containers that Foundry Agent Service uses. This setup lets you initiate failover during a regional outage. If you use only ZRS, contact Microsoft support to restore data. This process might extend your RTO. As with AI Search, if your chat UI doesn't support file uploads and you don't have agents that use static files as knowledge, you might not need a DR plan for blob containers.

- **Transactional consistency:** If the state store in your workload references Azure AI agent identifiers, like conversation IDs or agent IDs, coordinate recovery across all relevant data stores. Restoring only a subset of dependencies can result in orphaned or inconsistent data. Design your DR processes to maintain referential integrity between your workload and the agent service's state.

- **Agent definitions and configuration:** Define agents *as code*. Store agent definitions, connections, system prompts, and parameters in source control. This practice lets you redeploy agents from a known good configuration if you lose the orchestration layer. Avoid making untracked changes to agent configuration through the Foundry portal or data plane APIs. This approach ensures that your deployed agents remain reproducible.

- **Foundry projects:** Use a user-assigned managed identity for a project's identity. If the project is accidentally deleted, a user-assigned managed identity lets you reuse your existing role assignments when you re-create the project and its capability host. This approach reduces the coordination required with project dependencies during recovery.

As an added preventative measure for the Foundry Agent Service dependencies, add a *delete* resource lock to each service. This practice helps protect against catastrophic loss of state in AI Search, Azure Cosmos DB, and Storage.

Before you move to production, build a recovery runbook that addresses failures in both application-owned state and agent-owned state.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture extends the security foundation established in the [basic Foundry chat reference architecture](./basic-microsoft-foundry-chat.yml). It adds a network security perimeter alongside the identity perimeter from the basic architecture. From a network perspective, Application Gateway is the only internet-exposed resource. It makes the chat UI application available to users. From an identity perspective, the chat UI should authenticate and authorize requests. Use managed identities when possible to authenticate applications to Azure services.

#### Identity and access management

This architecture primarily uses system-assigned managed identities for service-to-service authentication. You might also use user-assigned managed identities. In either case, apply the following principles:

- Isolate identities by resource and function. Create distinct managed identities for the following components:

  - The Foundry account
  - Each Foundry project
  - The web application
  - Any custom orchestrator or integration code

- Assign an identity to an Azure resource only if that resource must authenticate as a client to another Azure service.

- Use fit-for-purpose identity types. Where possible, use [workload identities](/entra/workload-id/workload-identities-overview) for applications and automation, and use [agent identities](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/announcing-microsoft-entra-agent-id-secure-and-manage-your-ai-agents/3827392) for AI agents.

##### Connections

Connections define how a Foundry account or an individual project authenticates to and uses an [external dependency](/azure/ai-foundry/how-to/connections-add?#connection-types). Create connections at the project level when possible. Remove unused connections. Prefer Microsoft Entra ID-based authentication for all connections.

If a connection doesn't support Microsoft Entra ID, you must supply a secret, like an API key. Store these secrets in a dedicated, self-hosted Azure key vault. Configure an [Azure Key Vault connection](/azure/ai-foundry/how-to/set-up-key-vault-connection) for the Foundry account so the service can read and write the secrets that it manages.

Use this key vault only for Foundry. Don't share it with other workload components. All non–Microsoft Entra ID connections across all projects in the account store their secrets in this vault. Other workload components don't need access to these secrets to consume Foundry capabilities. Don't grant read or write permissions on this vault to other components unless you have a clear operational requirement or accept the trade-off.

This architecture includes two API-key-based connections: Application Insights for Foundry metrics and Grounding with Bing Search.

If you use customer-managed keys for encryption, you can host both the customer-managed keys and the connection secrets in the same dedicated vault, if your security governance policies allow colocation of encryption keys and secrets.

##### Foundry portal employee access

When you onboard employees to Foundry projects, assign the minimum permissions required for their role. Use Microsoft Entra ID groups and Azure role-based access control (Azure RBAC) to enforce separation of duties. For example, distinguish agent developers from data scientists who handle fine-tuning tasks. But understand the limitations and risks.

The Foundry portal runs many actions by using the service's identity rather than the employee's identity. As a result, employees that have limited Azure RBAC roles might have visibility into sensitive data, like chat conversations, agent definitions, and configuration. This Foundry portal design can inadvertently bypass your desired access constraints and expose more information than intended.

To mitigate the risk of unauthorized access, restrict portal usage in production environments to employees that have a clear operational need. For most employees, revoke or block access to the Foundry portal in production. Instead, use automated deployment pipelines and infrastructure as code (IaC) to manage agent and project configuration.

Treat creating new projects in a Foundry account as a privileged action. Projects created through the portal don't automatically inherit your established network security controls, like private endpoints or network security groups (NSGs). New agents in those projects bypass your intended security perimeter. Enforce project creation exclusively through your controlled, auditable IaC processes.

##### Foundry project role assignments and connections

To use Foundry Agent Service in Standard mode, the project must have administrative permissions on the Foundry Agent Service dependencies. Specifically, the project's managed identity must have elevated role assignments on the Storage account, AI Search, and the Azure Cosmos DB account. These permissions provide nearly full access to these resources, including the ability to read, write, modify, or delete data. To uphold least privilege access, isolate your workload resources from the Foundry Agent Service dependencies.

All agents within a single Foundry project share the same managed identity. If your workload uses multiple agents that require access to different sets of resources, the principle of least privilege requires you to create a separate Foundry project for each distinct agent access pattern. This separation lets you assign only the minimum required permissions to each project's managed identity, which reduces the risk of excessive or unintended access.

When you establish [connections](/azure/ai-foundry/how-to/connections-add) to external resources from within Foundry, use Microsoft Entra ID-based authentication if available. This approach eliminates the need to maintain preshared secrets. Scope each connection so that only the owning project can use it. If multiple projects require access to the same resource, create a separate connection in each project rather than sharing a single connection across projects. This practice enforces strict access boundaries and prevents future projects from inheriting access that they don't require.

Avoid creating connections at the Foundry account level because account-level connections apply to all current and future projects in the account. They can inadvertently grant broad access to resources, violate least privilege principles, and increase the risk of unauthorized data exposure. Create project-level connections only.

#### Networking

In addition to identity-based access, this architecture requires network confidentiality.

The network design includes the following safeguards:

- A single, secure entry point for all chat UI traffic, which minimizes the attack surface

- Filtered ingress and egress network traffic by using a combination of NSGs, a web application firewall, user-defined routes (UDRs), and Azure Firewall rules

- End-to-end encryption of data in transit by using TLS

- Network privacy by using Private Link for all Azure PaaS service connections

- Logical segmentation and isolation of network resources, with dedicated subnets for each major component grouping to support granular security policies

##### Network flows

:::image type="complex" source="_images/baseline-microsoft-foundry-network-flow.svg" border="false" lightbox="_images/baseline-microsoft-foundry-network-flow.svg" alt-text="Diagram that shows two networking flows from the baseline App Service web application architecture and the Foundry Agent Service networking flow.":::
  The diagram resembles the baseline end-to-end chat architecture. It includes the Azure OpenAI architecture and three numbered network flows. The inbound flow and the flow from App Service to Azure PaaS services are copied from the baseline App Service web architecture. The Foundry Agent Service flow shows an arrow from the Foundry private endpoint in the private virtual network that points to Foundry Agent Service. The second numbered arrow in the Foundry Agent Service flow shows calls from the Azure AI agent virtual interface in the private network flowing through private endpoints. The third numbered arrow shows an arrow from the virtual interface to an Azure Firewall box, which indicates that all calls to the internet flow through that firewall.
:::image-end:::

The [baseline App Service web application architecture](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) outlines the inbound flow from the user to the chat UI and the flow from App Service to [Azure PaaS services](../../web-apps/app-service/architectures/baseline-zone-redundant.yml#outbound-flow). This section focuses on agent interactions.

When the chat UI communicates with the agent deployed in Foundry, the following network flows occur:

1. The App Service-hosted chat UI initiates HTTPS requests through a private endpoint to the Foundry data plane API endpoint.

1. When the agent accesses Azure PaaS services, like service dependencies, custom knowledge stores, or custom tools, it sends HTTPS requests from the delegated subnet to the private endpoints of those services.

1. When the agent accesses resources outside the virtual network, including internet-based APIs or external services, it's forced to route those HTTPS requests from the delegated subnet through Azure Firewall.

Private endpoints serve as a critical security control in this architecture by supplementing identity-based security. Because this architecture uses private endpoints and UDRs in your virtual network, it doesn't support the [network security perimeter](/azure/ai-foundry/how-to/add-foundry-to-network-security-perimeter) capability of Foundry projects.

##### Ingress to Foundry

This architecture blocks public access to the Foundry data plane by allowing traffic only through a [private link for Foundry](/azure/ai-foundry/how-to/configure-private-link). You can access much of the Foundry portal through the [portal website](https://ai.azure.com), but all project-level functionality requires network access. The portal relies on your Foundry account's data plane APIs, which are reachable only through private endpoints. As a result, developers and data scientists must access the portal through a jump box, a peered virtual network, an Azure ExpressRoute connection, or a site-to-site VPN connection.

All programmatic interactions with the agent data plane must also use these private endpoints. Examples include calls from the web application or from external orchestration code that invokes model inferencing. Private endpoints are defined at the account level, not the project level, so all projects within the account share the same endpoints and network exposure. You can't segment network access at the project level.

To support this configuration, set up DNS for the following Foundry FQDN API endpoints:

- `privatelink.services.ai.azure.com`
- `privatelink.openai.azure.com`
- `privatelink.cognitiveservices.azure.com`

The following diagram shows how an AI developer connects through Azure Bastion to a virtual machine (VM) jump box. From that jump box, the author can access the project in the Foundry portal through a private endpoint in the same network.

:::image type="complex" source="_images/baseline-microsoft-foundry-portal-access.svg" border="false" lightbox="_images/baseline-microsoft-foundry-portal-access.svg" alt-text="A diagram that shows how a user connects to a jump box VM through Azure Bastion.":::
  An arrow points from an agent author, to Azure Bastion, to the jump box, to a Foundry (portal) private endpoint, and then to the Foundry project that contains Foundry Agent Service. From the Foundry project, an arrow points to a virtual interface in the Azure AI agent integration subnet. A final arrow points from the virtual interface to the three Foundry Agent Service dependency's private endpoints. Those dependencies are AI Search, Azure Cosmos DB, and Storage.
:::image-end:::

##### Control traffic from the Foundry agent subnet

This architecture routes all outbound (egress) network traffic from the Foundry Agent Service capability through a delegated subnet within your virtual network. This subnet serves as the sole egress point for both the agent's required three service dependencies and any external knowledge sources or tool connections that the agent uses. This design helps reduce data exfiltration attempts from within the orchestration logic.

By forcing this egress path, you gain full control over outbound traffic. You can apply granular NSG rules, custom routing, and DNS control to all agent traffic that leaves the service.

The agent service uses the virtual network's DNS configuration to resolve private endpoint records and required external FQDNs. This setup ensures that the agent's requests generate DNS logs, which support auditing and troubleshooting.

The NSG attached to the agent egress subnet blocks all inbound traffic because no legitimate ingress should occur. Outbound NSG rules allow access only to private endpoint subnets within the virtual network and to Transmission Control Protocol (TCP) port 443 for internet-bound traffic. The NSG denies all other traffic.

To further restrict internet traffic, this architecture applies a UDR to the subnet, which directs all HTTPS traffic through Azure Firewall. The firewall controls which FQDNs the agent can reach through HTTPS connections. For example, if the agent only needs to access `https://example.org/api`, configure Azure Firewall to allow traffic to `api.example.org` on port 443 from this subnet and ensure that the NSG allows that traffic.

> [!NOTE]
> Not all knowledge tools connected to your agents egress through this subnet. For example, [Grounding with Bing](/azure/ai-services/agents/how-to/tools/bing-grounding) calls `api.bing.microsoft.com`, which you might expect to route through Azure Firewall by allowing port 443 from this subnet. But the agent service invokes this tool through an internal mechanism that bypasses the egress subnet entirely. Test all built-in knowledge and tool connections for your workload to verify whether they align with your network egress control policies.

##### Virtual network segmentation and security

This architecture segments the virtual network by assigning each major component group to its own subnet. Each subnet has a dedicated NSG that limits the inbound and outbound traffic to only what the component requires.

The following table summarizes the NSG and firewall configuration for each subnet.

| Usage or subnet name | Inbound traffic (NSG) | Outbound traffic (NSG) | UDR to firewall | Firewall egress rules |
| :--- | :--- | :--- | :---: | :--- |
| Private endpoints <br> `snet-privateEndpoints` | Virtual network | No traffic allowed | Yes | No traffic allowed |
| Application Gateway <br> `snet-appGateway` | Chat UI user source IP addresses, like the public internet, and required sources for the service | Private endpoint subnet and required items for the service | No | - |
| App Service <br> `snet-appServicePlan` | No traffic allowed | Private endpoints and Azure Monitor | Yes | To Azure Monitor |
| Foundry Agent Service <br> `snet-agentsEgress` | No traffic allowed | Private endpoints and the internet | Yes | Only public FQDNs that you allow your agents to use |
| Jump box VMs <br> `snet-jumpBoxes` | Azure Bastion subnet | Private endpoints and the internet | Yes | As needed by the VM |
| Build agents <br> `snet-buildAgents` | Azure Bastion subnet | Private endpoints and the internet | Yes | As needed by the VM |
| Azure Bastion <br> `AzureBastionSubnet` | See [NSG access and Azure Bastion](/azure/bastion/bastion-nsg) | See [NSG access and Azure Bastion](/azure/bastion/bastion-nsg) | No | - |
| Azure Firewall <br> `AzureFirewallSubnet` <br> `AzureFirewallManagementSubnet` | No NSG | No NSG | No | - |

This design explicitly denies all other traffic, either through NSG rules or by default in Azure Firewall.

When you implement network segmentation and security in this architecture, follow these recommendations:

- Deploy an [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) plan on the Application Gateway public IP address to mitigate volumetric attacks.

- Attach an [NSG](/azure/virtual-network/network-security-groups-overview) to every subnet that supports it. Apply the strictest rules possible without disrupting required functionality.

- Apply [forced tunneling](/azure/firewall/forced-tunneling) to all supported subnets so that your egress firewall can inspect all outbound traffic. Use forced tunneling even on subnets where you don't expect egress. This method adds a defense-in-depth measure that protects against intentional or accidental misuse of the subnet.

#### Governance through policy

To align with your workload's security baseline, use Azure Policy and network policies to ensure that all workload resources meet your requirements. Platform automation through policy reduces the risk of security configuration drift and helps reduce manual validation activities.

Consider implementing the following types of security policies to strengthen your architecture:

- Turn off key-based or other local authentication methods in services like Foundry and Key Vault.

- Require explicit configuration of network access rules, private endpoints, and NSGs.

- Require encryption, like customer-managed keys.

- Restrict resource creation, like limiting regions or resource types.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This [Azure pricing estimate](https://azure.com/e/9ed058e3b57b4386b7ac1bd3f782a344) includes only the components in this architecture, so customize it to match your usage. The most expensive components in the scenario are Azure Cosmos DB, AI Search, and DDoS Protection. Other notable costs include the chat UI compute and Application Gateway. Optimize those resources to reduce costs.

#### Foundry Agent Service

When you use the standard deployment, you must set up and manage the service's dependencies in your own Azure subscription.

The following recommendations explain how to optimize costs for these required services:

- Foundry Agent Service manages the request unit (RU) allocation on Azure Cosmos DB. To reduce long-term costs, purchase reserved capacity for Azure Cosmos DB. Align reservations with your expected usage duration and volume. Reserved capacity requires upfront commitment and lacks flexibility if your workload's usage patterns change significantly.

- If your chat scenario doesn't require file uploads, exclude this feature in your application. In that case, apply the following configuration changes:

  - Use a locally redundant storage (LRS) tier for the Storage account.

  - Configure AI Search with a single replica instead of the recommended three replicas.

- Regularly delete unused agents and their associated conversations by using the SDK or REST APIs. Stale agents and conversations continue to consume storage and can increase costs across Azure Cosmos DB, Storage, and AI Search.

- Turn off features on dependent resources that your workload doesn't require, like the following features:

  - The semantic ranker in AI Search

  - The gateway and multiregion write capabilities in Azure Cosmos DB

- To avoid cross-region bandwidth charges, deploy Azure Cosmos DB, Storage, and AI Search in the same Azure region as Foundry Agent Service.

- Avoid colocating workload-specific data in the same Azure Cosmos DB or AI Search resources that Foundry Agent Service uses. In some cases, you can share these resources to reduce unused capacity in RUs or search units, which reduces cost. Only consider resource sharing after a thorough risk assessment for reliability, security, and performance trade-offs.

#### Agent knowledge and tools

Foundry Agent Service runs agent logic in a nondeterministic manner. It might invoke connected knowledge stores, tools, or other agents for each request, even if that resource isn't relevant to the user query. This behavior can result in unnecessary calls to external APIs or data sources, increase costs for each transaction, and introduce unpredictable usage patterns that complicate budget forecasting.

To control costs and maintain predictable behavior, apply the following strategies:

- Connect only the knowledge stores, tools, or agents that most agent invocations are likely to use. Avoid connecting resources that are rarely needed or that incur high costs for each call unless they're essential.

- Design and refine the system prompt to instruct the agent to minimize unnecessary or redundant external calls. The system prompt should guide the agent to use only the most relevant connections for each request.

- Use Foundry metrics and logs to monitor which external APIs, knowledge stores, or tools the agent accesses, how frequently it accesses them, and the associated costs. Regularly review this data to identify unexpected usage patterns or cost spikes, and adjust your system prompt as needed.

- Be aware that nondeterministic invocation can make cost forecasting difficult, especially when you integrate with usage-based APIs. If you require predictable costs, consider self-hosting the orchestrator by using deterministic code.

#### Azure OpenAI models

Model deployments in Foundry use the MaaS approach. Costs depend primarily on usage or pre-provisioned allocation.

To control consumption model costs in this architecture, use a combination of the following approaches:

- **Control clients.** Client requests drive most costs in a consumption model, so you must control agent behavior.

  To reduce unnecessary usage, take the following actions:

  - Approve all model consumers. Don't expose models in a way that allows unrestricted access.

  - Enforce token-limiting constraints like `max_tokens` and `max_completions` through agent logic. This control is only available in self-hosted orchestration. Foundry Agent Service doesn't support this functionality.

  - Optimize prompt input and response length. Longer prompts consume more tokens, which increases cost. Prompts that lack sufficient context reduce model effectiveness. Create concise prompts that provide enough context to allow the model to generate a useful response. Ensure that you optimize the limit of the response length.

    This level of control is only available in self-hosted orchestration. Foundry Agent Service doesn't provide enough configuration to support this functionality.

- **Choose the right model for the agent.** Select the least expensive model that meets your agent's requirements. Avoid using higher cost models unless they're essential. For example, the reference implementation uses GPT-4o instead of a more expensive model and achieves sufficient results.

- **Monitor and manage usage.** Use [Microsoft Cost Management](/azure/ai-services/openai/how-to/manage-costs) and model-usage metrics to track token usage, set budgets, and create alerts for anomalies. Regularly review usage patterns and adjust quotas or client access as needed. For more information, see [Plan and manage costs for Foundry](/azure/ai-foundry/how-to/costs-plan-manage).

- **Use the right deployment type.** Use pay-as-you-go pricing for unpredictable workloads, and switch to provisioned throughput when usage is stable and predictable. Combine both options when you establish a reliable baseline.

- **Restrict playground usage.** To prevent unplanned production costs, restrict the use of the Foundry playground to preproduction environments only.

- **Plan fine-tuning and image generation carefully.** These features have different billing models. They're billed per hour or per batch. Schedule usage to align with billing intervals and avoid waste.

#### Network security resources

This architecture requires Azure Firewall as an egress control point. To optimize costs, use the Basic tier of Azure Firewall unless the rest of your workload components require advanced features. Higher tiers add cost, so only use them if you need their capabilities.

If your organization uses an Azure landing zone, consider using shared firewall and distributed denial-of-service (DDoS) resources to defer or reduce costs. Workloads that have similar security and performance requirements can benefit from shared resources. Ensure that shared resources don't introduce security or operational risks. For an example that uses shared resources, see the [landing zone version of this architecture](./baseline-microsoft-foundry-landing-zone.yml).

#### Microsoft Defender for Cloud

Use the following Cloud Workload Protection plans to cover the related resources in this architecture.

| Plan | Benefit |
| :--- | :------ |
| Microsoft Defender for Servers | Detects vulnerabilities and monitors file integrity to help prevent highly privileged jump boxes and build agents from becoming threat vectors. |
| Microsoft Defender for App Service | Monitors logs, host machines, and management interfaces for your chat UI components. |
|Microsoft Defender for Azure Cosmos DB | Monitors database interactions for signs of potential misuse or unauthorized access to chat data and agent definitions. |
| Microsoft Defender for AI services | Alerts on jailbreaking attempts or data leakage based on agent requests and responses. If your organization uses Microsoft Purview, this plan also provides integration with [Microsoft Purview Data Security Posture Management for AI (DSPM for AI)](/azure/defender-for-cloud/ai-onboarding#enable-data-security-for-azure-ai-with-microsoft-purview). |

If your organization uses a security information and event management (SIEM) solution or Microsoft Purview, ensure that any customer data replicated to those data stores, like prompts and responses, resides in a region that meets your workload's data sovereignty requirements.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The following operational excellence guidance doesn't include the front-end application elements, which remain the same as the [baseline highly available zone-redundant web application architecture](../../web-apps/app-service/architectures/baseline-zone-redundant.yml#deployment-flow).

When you plan your experimentation, testing, and production environments, establish distinct and isolated Foundry resources, including dependencies.

#### Agent compute

Microsoft manages the serverless compute platform for Foundry Agent Service REST APIs and the orchestration implementation logic. A [self-hosted orchestration](#alternatives) provides more control over runtime characteristics and capacity, but you must directly manage the day-2 operations for that platform. Evaluate the constraints and responsibilities of your approach to understand which day-2 operations support your orchestration layer.

In both approaches, you must manage state storage, like chat history and agent configuration for durability, backup, and recovery.

#### Monitoring

Similar to the basic architecture, this architecture sends diagnostics data from all services to your workload's Log Analytics workspace. The configuration captures all available log categories for each service, except App Service. In production, you might not need every log category. For example, the chat UI application on App Service might only require `AppServiceHTTPLogs`, `AppServiceConsoleLogs`, `AppServiceAppLogs`, `AppServicePlatformLogs`, and `AppServiceAuthenticationLogs`. Tune log streams to match your operational needs.

Evaluate custom alerts, like custom alerts in the Azure Monitor baseline alerts, for the resources in this architecture. Consider the following alerts:

- [AI Search alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/Search/searchServices/)
- [AI services alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/CognitiveServices/accounts/)
- [Web Apps alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/Web/serverFarms/)

Monitor the usage of tokens against your model deployments. In this architecture, Foundry tracks [token usage](/azure/ai-foundry/how-to/monitor-quality-safety) through its integration with Application Insights.

Your jump boxes and build agent VMs reside in a highly privileged location, which provides those VMs direct network access to the data plane of all components in your architecture. Ensure that those VMs emit enough logs to understand when they're used, who uses them, and what actions they perform.

#### Agent versioning and life cycle

Treat each agent as an independently deployable unit within your chat workload, unless you specifically design your application to dynamically create and delete agents at runtime. These agents have life cycle management requirements similar to other microservices in your workload.

To prevent service disruptions, ensure safe and controlled agent deployment by implementing the following approaches:

- **Define agents as code.** Always store agent definitions, connections, system prompts, and configuration parameters in source control. This practice ensures traceability and reproducibility. Avoid untracked changes through the Foundry portal.

- **Automate agent deployment.** Use your workload's continuous integration and continuous deployment (CI/CD) pipelines. Use the Foundry SDKs to build, test, and deploy agent changes from your network-connected build agents.

  Prefer agent pipelines that you can deploy independently for small, incremental changes. But make sure that the pipelines provide enough flexibility to deploy them alongside your application code when you require coordinated updates. To support this method, loosely couple your chat UI code and your chat agents so that changes to one component don't require simultaneous changes to the other.

- **Test before production.** Validate agent behavior, prompts, and connections in preproduction environments. Use a combination of automated and manual tests to catch regressions, security problems, and unintended changes in agent behavior.

  Agents defined in Foundry Agent Service behave nondeterministically, so you must determine how to measure and maintain your desired quality level. Create and run a test suite that checks for ideal responses to realistic user questions and scenarios.

- **Version and track agents.** Assign clear version identifiers to each agent. Maintain records of which agent versions are active, along with their dependencies like models, data sources, and tools. Deploy new agent versions alongside existing ones to support progressive rollout, rollback, and controlled migration of users or sessions. [Foundry supports multiple published agent versions](/azure/ai-foundry/agents/how-to/publish-agent#update-a-published-agent-application) to help manage rollouts.

- **Publish and share agents.** After you author and validate agents in production Foundry instances, publish them to expose a dedicated endpoint that has its own identity and governance controls. Publishing creates a managed [Azure agent application resource](/azure/ai-foundry/agents/how-to/publish-agent) that lets external clients access the agent without granting access to the production Foundry project itself.

  Before you publish, any user that has the Azure AI User RBAC role on the Foundry project can interact with all contained agents, and conversation context and state is shared across users. After you publish, an application deployment is created. It runs a specific agent version and enforces user-level data isolation by scoping interactions and associated data to the calling identity. You can start, stop, and update the deployment to reference a new agent version. The application endpoint remains stable across version updates, which avoids downstream client configuration changes.

- **Plan for failback.** Foundry doesn't provide built-in support for blue-green or canary deployments of agents. If you require these deployment patterns, implement a routing layer, like an API gateway or custom router, in front of the agent API. This routing layer lets you shift traffic incrementally between agent versions, monitor the effect, and perform a full switchover when ready.

- **Coordinate agent removal.** When you remove agents, coordinate the process with your application's state management and user experience requirements. Handle active chat sessions appropriately. Depending on your workload's functional requirements, you can migrate sessions, pin users to the old agent version, or require users to start new sessions.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This section addresses performance efficiency for AI Search, model deployments, and Foundry.

#### Performance efficiency in AI Search

In Foundry Agent Service, you don't control the specific queries sent to your indexes because agents are codeless. To optimize performance, focus on what you can control in the index. Observe how your agent typically queries the index, and apply guidance to [analyze and optimize performance in AI Search](/azure/search/search-performance-analysis).

If index server-tuning alone doesn't resolve all bottlenecks, consider the following options:

- Replace the direct connection to AI Search with a connection to an API that you own. This API can implement code optimized for your agent's retrieval patterns.

- Redesign the orchestration layer to use the [self-hosted alternative](#chat-orchestration) so that you can define and optimize queries in your own orchestrator code.

#### Performance efficiency in model deployments

- Determine whether your application needs [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) or can use the shared (consumption) model. Provisioned throughput provides reserved capacity and predictable latency, which supports production workloads that have strict service-level objectives (SLOs). The consumption model provides best-effort service and might suffer from noisy neighbor effects.

- Monitor [provision-managed usage](/azure/ai-services/openai/how-to/monitoring) to avoid overprovisioning or underprovisioning.

- Choose a conversational model that meets your inference latency requirements.

- Deploy models in the same data region as your agents to minimize network latency.

#### Azure AI agent performance

Azure AI agents run on a serverless compute back end that doesn't support custom performance tuning. But you can improve performance through agent design:

- Minimize the number of knowledge stores and tools connected to your chat agent. Each extra connection potentially increases the total runtime for an agent call because the agent might invoke all configured resources for each request.

- Use Azure Monitor and Application Insights to track agent invocation times, tool and knowledge store latencies, and error rates. Regularly review these metrics to identify slow knowledge or tool connections.

- Design system prompts that guide the agent to use connections efficiently. For example, instruct the agent to query external knowledge stores only when needed, or to avoid redundant tool invocations.

- Monitor for service limits or quotas that might affect performance during peak usage. Watch for throttling indicators like HTTP 429 or 503 responses, even though serverless compute scales automatically.

## Deploy this scenario

To deploy and run this reference implementation, follow the deployment guide in the [Foundry Agent Service chat baseline reference implementation](https://github.com/Azure-Samples/microsoft-foundry-baseline).

The chat UI application in this reference implementation is basic and demonstrates how to communicate with agent endpoints. For examples of more advanced chat UI experiences, see the [Foundry agent web app repository](https://github.com/microsoft-foundry/foundry-agent-webapp).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Rob Bagby](https://www.linkedin.com/in/robbagby/) | Principal Content Developer - Azure Patterns & Practices
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices

Other contributors:

- [Raouf Aliouat](https://www.linkedin.com/in/raouf-aliouat/) | Senior Software Engineer
- [Freddy Ayala](https://www.linkedin.com/in/freddyayala/) | Cloud Solution Architect
- [Prabal Deb](https://www.linkedin.com/in/prabaldeb/) | Principal Software Engineer
- [Ritesh Modi](https://www.linkedin.com/in/ritesh-modi/) | Principal Software Engineer
- [Ryan Pfalz](https://www.linkedin.com/in/ryanpfalz/) | Senior Technical Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Baseline Foundry chat architecture in an Azure landing zone](./baseline-microsoft-foundry-landing-zone.yml)

## Related resources

- [AI workloads on Azure](/azure/well-architected/ai/get-started)
- [Azure OpenAI models](/azure/ai-services/openai/concepts/models)
- [Content filtering](/azure/ai-services/openai/concepts/content-filter)
- [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns)
