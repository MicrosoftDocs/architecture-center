Enterprise chat applications can empower employees through conversational interactions with AI agents. This capability is increasingly powerful thanks to ongoing advancements in language models, such as OpenAI's GPT models and orchestration SDKs like Semantic Kernel. These chat applications typically consist of the following components:

- A chat user interface (UI) that's integrated into a larger enterprise application. It provides users with a conversational experience alongside other business functions.

- Data repositories that contain domain-specific information that's pertinent to user queries.

- Language models that reason over the domain-specific data to produce relevant responses.

- An orchestrator or agent that oversees the interactions between data sources, language models, and the end user.

This article provides a baseline architecture to help you build and deploy enterprise chat applications by using [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) and [Azure OpenAI language models](/azure/ai-services/openai/concepts/models). This architecture uses a single agent hosted in Azure AI Foundry Agent Service. The agent receives user messages and queries data stores to retrieve grounding information for the language model.

The chat UI follows the [baseline Azure App service web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) guidance about how to deploy a secure, zone-redundant, and highly available web application on App Service. In that architecture, App Service communicates to the Azure platform as a service (PaaS) solution through virtual network integration over private endpoints. In the chat UI architecture, App Service communicates with the agent over a private endpoint. Public access to Azure AI Foundry portal and agents are disabled.

> [!IMPORTANT]
> This article doesn't describe components or architecture decisions from the [baseline App Service web application architecture](../../web-apps/app-service/architectures/baseline-zone-redundant.yml). Read that article for architectural guidance about how to host the web application that contains your chat UI.

This architecture uses the [Foundry Agent Service standard agent setup](/azure/ai-services/agents/concepts/standard-agent-setup) to enable enterprise-grade security, compliance, and control. In this configuration, you bring your own network for network isolation and your own Azure resources to store chat and agent state. All communication between application components and Azure services occurs over private endpoints, which ensures that data traffic remains within your workload's virtual network. Outbound traffic from the agents strictly routes through Azure Firewall, where egress rules are enforced.

> [!TIP]
> :::image type="icon" source="../../_images/github.svg"::: The [Foundry Agent Service reference implementation](https://github.com/Azure-Samples/openai-end-to-end-baseline) showcases a baseline end-to-end chat implementation on Azure. It serves as a foundation to develop custom solutions as you move toward production.

## Architecture

:::image type="complex" source="_images/ai-foundry-end-to-end-baseline-deployment.svg" border="false" lightbox="_images/ai-foundry-end-to-end-baseline-deployment.svg" alt-text="Diagram that shows a baseline end-to-end chat architecture that uses Azure AI Foundry.":::
    The diagram presents a detailed Azure architecture for deploying an AI solution. On the left, a user connects through an Application Gateway with a web application firewall, which is part of a virtual network. This gateway is linked to private DNS zones and protected by DDoS Protection. Below the gateway, private endpoints connect to services such as App Service, Key Vault, and Storage, which are used for client app deployment. The App Service is managed with identity and spans three zones. Monitoring is provided by Application Insights and Azure Monitor, and authentication is handled by Microsoft Entra ID.
    Moving right, the virtual network contains several subnets: App Service integration, private endpoint, Azure AI Foundry integration, Azure AI Agent integration, Bastion, Jump box, Build agents, and Azure firewall. Each subnet hosts specific endpoints or services, such as storage, AI Foundry, AI Search, CosmosDB, and knowledge store, all connected via private endpoints. Outbound traffic from the network passes through the Azure Firewall to reach internet sources.
    To the far right, a separate box represents Azure AI Foundry, which includes an account and a project. Managed identities are used to connect the Foundry Agent Service to the Azure AI Foundry project, which in turn accesses an Azure OpenAI Model. The diagram uses numbered green circles to indicate the logical flow, showing how user requests traverse the network, interact with various endpoints, and ultimately connect to AI services and storage, with dependencies clearly grouped and labeled.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/openai-end-to-end.vsdx) of this architecture.*

### Workflow

1. An application user interacts with a chat interface. The requests are routed through Azure Application Gateway. Azure Web Application Firewall inspects these requests before it forwards them to the back-end App Service.

1. When the web application receives a user query or instruction, it invokes the purpose-built agent. The web application communicates with the agent via with the Azure AI Agent SDK. The web application calls the agent over a private endpoint and authenticates to Azure AI Foundry by using its managed identity.

1. The agent processes the user's request based on the instructions in its system prompt. To fulfill the user's intent, the agent uses a configured language model and connected tools and knowledge stores.

1. The agent connects to the knowledge store (Azure AI Search) in the private network via a private endpoint.

1. Requests to external knowledge stores or tools, such as Wikipedia or Bing, traverse Azure Firewall for inspection and egress policy enforcement.

1. The agent connects to its configured language model and passes relevant context.

1. Before the agent returns the response to the UI, it persists the request, the generated response, and a list of consulted knowledge stores into a dedicated *memory* database. This database maintains the complete conversation history, which enables context-aware interactions and allows users to resume conversations with the agent without losing prior context.

   The Azure AI Foundry APIs support the development of user experiences that manage multiple concurrent, context-isolated conversations.

### Components

This architecture builds on the [basic Azure OpenAI end-to-end chat architecture](./basic-openai-e2e-chat.yml#components). It introduces more Azure services to address enterprise requirements for reliability, security, and operational control. Each of the following components play a specific role in a production enterprise chat solution:

- [Foundry Agent Service](/azure/ai-services/agents/overview) provides the orchestration layer for chat interactions. It hosts and manages agents that process user requests, coordinate calls to tools and other agents, enforce content safety, and integrate with enterprise identity, networking, and observability.

  The [standard agent setup](/azure/ai-services/agents/concepts/standard-agent-setup) ensures network isolation and provides control over data storage. You supply dedicated Azure resources for agent state, chat history, and file storage, which Foundry Agent Service uses exclusively. Other application components in the workload shouldn't use these required resources.

  - [Azure Cosmos DB for NoSQL](/azure/well-architected/service-guides/cosmos-db) hosts this workload's memory database, called `enterprise_memory`, within your subscription. This database stores the agent's operational state, including chat threads and agent definitions. This design ensures that chat history and agent configuration are isolated, auditable, and managed according to data governance requirements. Foundry Agent Service manages the database, its collections, and its data.

  - A dedicated [Azure Storage](/azure/well-architected/service-guides/azure-blob-storage) account stores files uploaded during chat sessions. Hosting this account in your subscription provides granular access control, auditing capabilities, and compliance with data residency or retention policies. Foundry Agent Service manages the containers and data life cycle within those containers.

  - A dedicated [AI Search](/azure/search/search-what-is-azure-search) instance stores a searchable, chunked index of uploaded files from conversations with the agent. It also stores static files that are added as knowledge sources when the agent is created. Foundry Agent Service manages the index, schema, and data, and uses its own chunking strategy and query logic.

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) serves as the secure, scalable entry point for all HTTP or HTTPS traffic to the chat UI. It provides Transport Layer Security (TLS) termination and path-based routing. It also distributes requests across availability zones, which supports high availability and performance for the web application tier. Its back end is the App Service that hosts the application code.

  [Azure Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) integrates with Application Gateway to protect the chat UI from common web vulnerabilities and attacks. It inspects and filters HTTP requests, which provides a security layer for public-facing applications.

  [Azure Key Vault](/azure/key-vault/general/overview) securely stores and manages the TLS certificates that Application Gateway requires. Centralized certificate management in Key Vault supports automated rotation, auditing, and compliance with organizational security standards. This architecture doesn't require stored keys or other secrets.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) provides network isolation for all components. When you place resources in a private virtual network, you control east-west and north-south traffic, enforce segmentation, keep traffic private, and enable inspection of ingress and egress flows. This setup helps you meet security and compliance requirements.

- [Azure Private Link](/azure/private-link/private-link-overview) connects all PaaS services, such as Azure Cosmos DB, Storage, AI Search, and Foundry Agent Service, to the virtual network via private endpoints. This approach ensures that all data traffic remains on the Azure backbone, which eliminates exposure to the public internet and reduces the attack surface.

- [Azure Firewall](/azure/firewall/) inspects and controls all outbound (egress) traffic from the virtual network. It enforces fully qualified domain name (FQDN)-based rules, which ensures that only approved destinations are reachable. This configuration helps prevent data exfiltration and meet requirements for network security.

- [Azure DNS](/azure/dns/dns-overview) provides private Domain Name System (DNS) zones linked to the virtual network. This feature enables name resolution for private endpoints, which ensures that all service-to-service communication uses private IP addresses and remains within the network boundary.

- [Storage](/azure/well-architected/service-guides/azure-blob-storage) hosts the web application code as a ZIP file for deployment to App Service. This method supports secure, automated deployment workflows and separates application artifacts from compute resources.

### Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and trade-offs.

#### Chat orchestration

**Current approach:** This architecture uses [Foundry Agent Service](/azure/ai-services/agents/overview) to orchestrate chat flows, including fetching grounding data from knowledge stores and invoking Azure OpenAI models. Foundry Agent Service provides codeless, nondeterministic orchestration. It handles chat requests, thread management, tool invocation, content safety, and integration with identity, networking, and observability. It provides a native memory database solution.

**Alternative approach:** You can self-host the orchestration layer by using frameworks such as [Semantic Kernel](/semantic-kernel/overview/) or [LangChain](/azure/ai-foundry/how-to/develop/langchain). Use these frameworks to implement deterministic, code-driven chat flows and custom orchestration logic.

Consider alternatives if your workload requires the following capabilities:

- Fine-grained, deterministic control over the orchestration sequence, tool invocation, or prompt engineering

- Integration with custom business logic or external systems that Foundry Agent Service doesn't natively support
- Advanced client request routing for experimentation or safe deployment practices
- A custom memory database solution that differs from the native Foundry Agent Service solution

Self-hosted orchestration increases operational complexity and requires you to manage compute, scaling, and security.

#### Application tier components

**Current approach:** The chat UI front-end website is hosted on the Web Apps feature of App Service, which provides a managed, scalable platform for web applications. It integrates natively with Azure networking and security features.

**Alternative approach:** You can use other Azure-managed compute platforms, such as Azure Container Apps or Azure Kubernetes Service (AKS), to host the application tier.

Consider alternatives if your workload requires the following capabilities:

- Another compute platform better supports certain use cases, and colocating services on that platform can improve cost efficiency and simplify operations

- Your application requires more sophisticated scaling, orchestration, or custom networking

App Service remains the preferred option for its simplicity in hosting web applications and their APIs.

#### Grounding data (knowledge) store

**Current approach:** This architecture uses AI Search as the primary data store for grounding knowledge. It uses AI Search vector search and semantic ranking capabilities.

**Alternative approach:** You might use other data platforms for grounding knowledge, such as Azure Cosmos DB, Azure SQL Database, or other online transaction processing (OLTP) data stores. Your data platform depends on your existing data estate, data freshness requirements, and query requirements.

Consider alternatives if your workload requires the following capabilities:

- You already manage your grounding knowledge in an existing transactional or operational database

- You require multi-model or SDK support not available in AI Search
- You need to integrate with specialized data sources or legacy systems

Vector search is common for retrieval-augmented generation, but not always required. For more information, see [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search). Before you choose a data store, evaluate the data access patterns, latency, and scalability needs of your workload.

#### Predefined agent or dynamically created agent

**Current approach:** The reference implementation uses a statically defined agent that's deployed as a microservice within Azure AI Foundry. The agent's logic and data sources are configured at deployment and remain unchanged until the next application release. This approach works well when agent behavior and data sources are stable and controlled through DevOps processes.

**Alternative approach:** You can dynamically create or modify agents at runtime by using the Azure AI Agent SDK. This approach allows the application to instantiate agents on demand, adjust system prompts, or reconfigure connections based on user context or business logic.

Consider dynamic agents if your workload requires the following capabilities:

- Personalized agent behavior or data sources for each user or session

- Frequent or programmatic changes to agent configuration
- Ephemeral, context-specific agent support for advanced user experiences

Dynamic agent management increases flexibility but also introduces the burden of life cycle management. Ensure that you have appropriate controls for agent creation, modification, and cleanup.

Choose the agent approach that aligns with your workload's user experience requirements.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

Apply this architecture and the [AI workloads on Azure design guidance](/azure/well-architected/ai/get-started) during the design phase of your workload.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The baseline App Service web application architecture focuses on zonal redundancy for key regional services. Availability zones are physically separate locations within a region that provide redundancy when you deploy two or more instances across them. If one zone experiences downtime, others in the region might remain unaffected. The architecture also distributes instances and configurations of Azure services across availability zones. For more information, see [Baseline highly available zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml).

This section addresses reliability for componenets not covered in the App Service baseline architecture, specifically Azure AI Foundry and AI Search.

#### Zone redundancy in your orchestration layer

Enterprise deployments usually require zonal redundancy to minimize the risk of service disruption from zone-level failures. In Azure, zonal redundancy means using resources that support [availability zones](/azure/reliability/availability-zones-overview) and deploying at least three instances, or enabling platform-level redundancy where direct instance control is unavailable.

In this architecture, Azure AI Foundry hosts the AI Agent capability. The agent's reliability depends on the availability of its dependencies: Azure Cosmos DB, Storage, and AI Search. Foundry Agent Service manages the data within these services, but you configure their reliability in your subscription.

To achieve zonal redundancy for the orchestration layer, follow these recommendations:

- Enable [zone redundancy in your Azure Cosmos DB for NoSQL](/azure/reliability/reliability-cosmos-db-nosql#availability-zone-support) account. This configuration ensures synchronous data replication across multiple zones, which reduces the risk of data loss or downtime from a single-zone failure.

  Also consider [global distribution](/azure/cosmos-db/distribute-data-globally) to mitigate regional outages within Azure Cosmos DB.

- Use [zone-redundant storage (ZRS)](/azure/storage/common/storage-redundancy-zrs) for your Storage account. For higher resilience, use [geo-zone-redundant storage (GZRS)](/azure/storage/common/storage-redundancy-zrs), which combines zonal and regional redundancy.

- Configure your [AI Search](/azure/search/search-reliability#availability-zone-support) instance with at least three replicas. This configuration ensures that the service distributes replicas across unique zones in your region.

If your agent integrates with other workload-specific dependencies, such as custom tool connections or external knowledge stores, ensure that those dependencies meet your availability and redundancy requirements. Any single-zone or non-redundant dependency can undermine the overall reliability of the orchestration layer.

The AI Foundry portal, its data plane APIs, and the AI Agent capability don't provide direct controls for zone redundancy.

#### Reliability in Azure AI Foundry model hosting

Azure AI Foundry offers models as a service (MaaS) hosting with several deployment options. These options primarily support quota and throughput management, rather than traditional high availability within a region. Standard model deployments operate in a single region and don't support availability zones. To achieve multi-datacenter availability, you must use either a global or a data zone model deployment.

For enterprise chat scenarios, deploy both a [data zone provisioned](/azure/ai-foundry/model-inference/concepts/deployment-types#data-zone-provisioned) and [data zone standard](/azure/ai-foundry/model-inference/concepts/deployment-types#data-zone-standard) model. Configure [spillover](/azure/ai-services/openai/how-to/spillover-traffic-management) to handle excess traffic or failures. If your workload doesn't require low latency or strict geographic data residency and processing, use global deployments for maximum resilience.

Azure AI Foundry doesn't support advanced load balancing or failover mechanisms, such as round-robin routing or [circuit breaking](/azure/api-management/backends#circuit-breaker), for model deployments. If you require granular redundancy and failover control within a region, host your model access logic outside of the managed service. For example, you can use a build custom gateway by using Azure API Management. This approach allows you to implement custom routing, health checks, and failover strategies. But it also increases operational complexity and shifts responsibility for reliability of that component to your team.

You can also expose gateway-fronted models as custom API-based tools or knowledge stores for your agent. For more information, see [Use a gateway in front of multiple Azure OpenAI deployments or instances](../guide/azure-openai-gateway-multi-backend.yml).

#### Reliability in AI Search for enterprise knowledge

Deploy AI Search by using the Standard pricing tier or higher in a [region that supports availability zones](/azure/search/search-reliability#prerequisites). Configure at least three replicas to ensure that the service distributes instances across separate availability zones. This configuration provides resilience to zone-level failures and supports high availability for search operations.

To determine the optimal number of replicas and partitions for your workload, use the following methods:

- [Monitor AI Search](/azure/search/monitor-azure-cognitive-search) by using built-in metrics and logs. Track query latency, throttling, and resource usage.

- Use monitoring metrics and logs and performance analysis to determine the appropriate number of replicas. This approach helps you avoid throttling from high query volume, insufficient partitions, or index limitations.

- Ensure indexing reliability by avoiding disruptions from periodic indexing or indexing errors. Consider indexing into an offline index and swapping from your live index to your rebuilt index after you validate data integrity.

#### Reliability in Azure Firewall

Azure Firewall is a critical egress control point in this architecture but represents a single point of failure for all outbound traffic. To mitigate this risk, deploy Azure Firewall [across all availability zones](/azure/firewall/basic-features#built-in-high-availability) in your region. This configuration helps maintain outbound connectivity if a zone becomes unavailable.

If your workload requires a high volume of concurrent outbound connections, configure Azure Firewall with multiple public IP addresses. This approach distributes Source Network Address Translation (SNAT) connections across [multiple address prefixes](/azure/virtual-network/ip-services/public-ip-address-prefix), which reduces the risk of SNAT port exhaustion. [SNAT exhaustion](/azure/firewall/firewall-best-practices#recommendations) can cause intermittent or total loss of outbound connectivity for agents and other workload components, which can result in feature downtime or degraded performance.

Monitor [SNAT port usage and firewall health](/azure/firewall/monitor-firewall#analyze-monitoring-data). If you observe connection failures or throughput problems, review firewall metrics and logs to identify and address SNAT exhaustion or other bottlenecks.

#### Bulkhead Foundry Agent Service dependencies from similar workload components

To maximize reliability and minimize the blast radius of failures, strictly isolate the Foundry Agent Service dependencies from other workload components that use the same Azure services. Specifically, don't share AI Search, Azure Cosmos DB, or Storage resources between the agent service and other application components. Instead, provision dedicated instances for the agent service's required dependencies.

This separation provides two key benefits:

- It contains failures or performance degradation to a single workload segment, which prevents cascading impacts across unrelated application features.

- It enables you to apply targeted operational processes, such as backup, restore, and failover that are tuned to the specific availability and recovery requirements of the workload flow that uses those resources.

For example, if your chat UI application needs to store transactional state in Azure Cosmos DB, provision a separate Azure Cosmos DB account and database for that purpose, rather than reusing the account or database that Foundry Agent Service manages. Even if cost or operational simplicity motivates resource sharing, the risk of a reliability event affecting unrelated workload features outweighs the potential savings in most enterprise scenarios.

> [!IMPORTANT]
> If you colocate workload-specific data with the agent's dependencies for cost or operational reasons, never interact directly with the system-managed data, such as collections, containers, or indexes, that Foundry Agent Service creates. These internal implementation details are undocumented and subject to change without notice. Direct access can break the agent service or result in data loss. Always use the Foundry Agent Service data plane APIs for data manipulation, and treat the underlying data as opaque and monitor-only.

#### Multiple-region design

This architecture uses availability zones for high availability within a single Azure region. It's not a multi-region solution. It lacks the following critical elements required for regional resiliency and disaster recovery (DR):

- Global ingress and traffic routing
- DNS management for failover
- Data replication or isolation strategies across regions
- An active-active, active-passive, or active-cold designation
- Regional failover and failback processes to meet recovery time objectives (RTOs) and recovery point objectives (RPOs)
- Consideration of region availability for developer experiences, including Azure AI Foundry portal and data plane APIs

If your workload requires business continuity if a regional outage occurs, you must design and implement extra components and operational processes beyond this architecture. Specifically, you need to address load balancing and failover at each architectural layer, including the following areas:

- Grounding data (knowledge stores)
- Model hosting and inference endpoints
- Orchestration or agent layer
- User-facing UI traffic and DNS entry points

You must also ensure that observability, monitoring, and content safety controls remain operational and consistent across regions.

This baseline architecture lacks multi-region capabilities, so regional outages are likely to result in loss of service within your workload.

#### Disaster recovery

Chat architectures contain stateful components, so DR planning is essential. These workloads typically require a memory store for active or paused chat sessions. They also require storage for supplemental data, such as documents or images, added to chat threads. The agent orchestration layer might also maintain state that's specific to conversation flows. In this architecture, Foundry Agent Service uses Azure Cosmos DB, Storage, and AI Search to persist operational and transactional state. The life cycle and coupling of this state across components determines your DR strategy and recovery operations.

For Foundry Agent Service, ensure that you can recover all dependencies to a consistent point in time. This approach helps maintain transactional integrity across the three external dependencies.

The following recommendations address DR for each service:

- **Azure Cosmos DB:** Enable [continuous backup](/azure/cosmos-db/online-backup-and-restore) for the `enterprise_memory` database. This setup provides point-in-time restore (PITR) with a seven-day RPO, which indludes agent definitions and chat threads. Test your restore process regularly to confirm that it meets your RTO and that the restored data remains available to the agent service. Always restore to the same account and database.

- **AI Search:** AI Search lacks built-in restore capabilities and doesn't support direct index manipulation. If data loss or corruption occurs, you must contact Microsoft support for assistance with index restoration. This limitation can significantly affect your RTO. If your chat UI doesn't support file uploads and you haven't created agents that use static files as knowledge, you might not need a DR plan for AI Search.

  Maintain a separate, regularly updated source of truth for your knowledge base. This practice ensures that you can rebuild indexes when necessary.

  When you use AI Search to support enterprise grounding knowledge, always maintain a separate, regularly updated source of truth for your knowledge base to enable index reconstruction if needed.

- **Storage:** If you have a geo-redundant storage account, use [customer-managed failover](/azure/storage/common/storage-disaster-recovery-guidance#customer-managed-unplanned-failover) for blob containers that Foundry Agent Service uses. This setup allows you to initiate failover during a regional outage. If you use only zone-redundant storage, contact Microsoft support to restore data. This process might extend your RTO. As with AI Search, if your chat UI doesn't support file uploads and you haven't created agents that use static files as knowledge, blob containers might not require DR planning.

- **Transactional consistency:** If your workload's state store references Azure AI Agent identifiers, such as thread IDs or agent IDs, coordinate recovery across all relevant data stores. Restoring only a subset of dependencies can result in orphaned or inconsistent data. Design your DR processes to maintain referential integrity between your workload and the agent service's state.

- **Agent definitions and configuration:** Define agents *as code*. Store agent definitions, connections, system prompts, and parameters in source control. This practice enables you to redeploy agents from a known good configuration if you lose the orchestration layer. Avoid making untracked changes to agent configuration through the AI Foundry portal or data plane APIs. This approach ensures that your deployed agents remain reproducible.

Before you move to production, build a recovery runbook that addresses failures in both application-owned state and agent-owned state.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture extends the security foundation established in the [basic OpenAI end-to-end chat reference architecture](./basic-openai-e2e-chat.yml). The primary difference is the addition of a network security perimeter alongside the identity perimeter from the basic architecture. From a network perspective, Application Gateway is the only internet-exposed resource. It makes the chat UI application available to users. From an identity perspective, the chat UI should authenticate and authorize requests. Use managed identities when possible to authenticate applications to Azure services.

This section describes networking and security considerations for key rotation and Azure OpenAI model fine-tuning.

#### Identity and access management

This architecture primarily uses system-assigned managed identities for service-to-service authentication. You might also use user-assigned managed identities. In either case, apply the following principles:

- Isolate identities by resource and function. Provision distinct managed identities for the following components:

  - The Azure AI Foundry account
  - Each Azure AI Foundry project
  - The web application
  - Any custom orchestrator or integration code

- Assign an identity to an Azure resource only if that resource must authenticate as a client to another Azure service.

- Use fit-for-purpose identity types. Where possible, use [workload identities](/entra/workload-id/workload-identities-overview) for applications and automation, and use [agent identities](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/announcing-microsoft-entra-agent-id-secure-and-manage-your-ai-agents/3827392) for AI agents.

##### Azure AI Foundry portal employee access

When you onboard employees to Azure AI Foundry projects, assign the minimum permissions required for their role. Use Microsoft Entra ID groups and role-based access control (RBAC) to enforce separation of duties. For example, distinguish agent developers from data scientists who handle fine-tuning tasks. However, be aware of the following limitations and risks.

Azure AI Foundry portal runs many actions by using the service's identity rather than the employee's identity. As a result, employees that have limited RBAC roles might have visibility into sensitive data, such as chat threads, agent definitions, and configuration. This AI Foundry portal design can inadvertently bypass your desired access constraints and expose more information than intended.

To mitigate the risk of undesired access, restrict portal usage in production environments to employees that have a clear operational need. For most employees, disable or block access to the Azure AI Foundry portal in production. Instead, use automated deployment pipelines and infrastructure as code (IaC) to manage agent and project configuration.

Creating new projects in an Azure AI Foundry account grants high-level privileges. Projects created through the portal don't automatically inherit your established network security controls, such as private endpoints or network security groups (NSGs). And new agents in those projects bypass your intended security perimeter. Enforce project creation exclusively through your controlled, auditable IaC processes.

##### Azure AI Foundry project role assignments and connections

To use Foundry Agent Service in Standard mode, the project must have administrative permissions on the Foundry Agent Service dependencies. Specifically, the project's managed identity must have elevated role assignments on the Storage account, AI Search, and the Azure Cosmos DB account. These permissions provide nearly full access to these resources, including the ability to read, write, modify, or delete data. To uphold least privilege access, isolate your workload resources from the Foundry Agent Service dependencies.

All agents within a single AI Foundry project share the same managed identity. If your workload uses multiple agents that require access to different sets of resources, the principle of least privilege requires you to create a separate Azure AI Foundry project for each distinct agent access pattern. This separation allows you to assign only the minimum required permissions to each project's managed identity, which reduces the risk of excessive or unintended access.

When you establish [connections](/azure/ai-foundry/how-to/connections-add) to external resources from within Azure AI Foundry, use Microsoft Entra ID-based authentication if available. This approach avoids maintaining preshared secrets. Always scope each connection so that it's usable only by the project that owns it. If multiple projects require access to the same resource, create a separate connection in each project, rather than sharing a single connection across projects. This practice enforces strict access boundaries and prevents future projects from inheriting access they don't require.

Connections created at the Azure AI Foundry account level are shared across all projects in the account, both current and future. This can inadvertently grant broad access to resources beyond what is intended, undermining least privilege and increasing the risk of unauthorized data exposure. Prefer project-level connections only.

#### Networking

In addition to identity-based access, network confidentiality is a foundational requirement for this architecture. The network design enforces:

- A single, secure entry point for all chat UI traffic, minimizing the attack surface.
- Filtered ingress and egress network traffic, using a combination of NSGs, Web Application Firewall (WAF), user-defined routes (UDRs), and Azure Firewall rules.
- End-to-end encryption of data in transit using TLS.
- Network privacy by using Private Link for all Azure PaaS service connections.
- Logical segmentation and isolation of network resources, with dedicated subnets for each major component grouping, to support granular security policies.

##### Network flows

:::image type="complex" source="_images/ai-foundry-end-to-end-chat-network-flow.svg" border="false" lightbox="_images/ai-foundry-end-to-end-chat-network-flow.svg" alt-text="Diagram that shows a numbered flow in a baseline end-to-end chat architecture that uses OpenAI.":::
    The diagram resembles the baseline end-to-end chat architecture. It includes the Azure OpenAI architecture and three numbered network flows. The inbound flow and the flow from App Service to Azure PaaS services are copied from the baseline App Service web architecture. The Foundry Agent Service flow shows an arrow from the Azure AI Foundry private endpoint in the private virtual network that points to Foundry Agent Service. The second numbered arrow in the Foundry Agent Service flow shows calls from the Azure AI Agent virtual interface in the private network flowing through private endpoints. The third numbered arrow shows an arrow from the virtual interface to an Azure Firewall box indicating that all calls to the internet flow through that firewall.
:::image-end:::

The inbound flow from the user to the chat UI and the flow from App Service to [Azure PaaS services](../../web-apps/app-service/architectures/baseline-zone-redundant.yml#app-service-to-azure-paas-services-flow), are detailed in the [baseline App Service web application architecture](../../web-apps/app-service/architectures/baseline-zone-redundant.yml). This section focuses on the Azure AI Agent interactions. When the chat UI communicates with the agent deployed in Azure AI Foundry, the following network flows occur:

1. The App Service-hosted chat UI initiates an HTTPS request that is routed through a private endpoint to the Azure AI Foundry data plane API endpoint.
1. When the agent accesses Azure PaaS services (such as service dependencies, custom knowledge stores, or custom tools), HTTPS requests are routed from the delegated subnet to the private endpoints of those services.
1. When the agent accesses resources outside the virtual network (including internet-based APIs or external services), HTTPS requests are routed from the delegated subnet through Azure Firewall.

Private endpoints are a critical security control in this architecture, supplementing identity-based security.

##### Ingress to Azure AI Foundry

In this architecture, public access to the Azure AI Foundry data plane is disabled by using [private link for Azure AI Foundry](/azure/ai-foundry/how-to/configure-private-link). Although much of the AI Foundry portal is accessible at <https://ai.azure.com>, all project-level functionality in the portal is unavailable unless the employee is connected from within the network. The portal relies on your AI Foundry account's data plane APIs, which are only reachable via private endpoints. As a result, developers and data scientists must access the portal through a jump box, a peered virtual network, or a site-to-site VPN/ExpressRoute connection.

Similarly, all programmatic interactions with the agent data plane, such as from the web application or when invoking model inferencing from external orchestration code, must use these private endpoints. Private endpoints are defined at the account level, not the project level. Therefore, all projects within the account are accessible from the same set of endpoints. Network segmentation at the project level isn't possible, and all projects share the same network exposure.

You must configure DNS for the following three Azure AI Foundry FQDN API endpoints:

- `privatelink.services.ai.azure.com`
- `privatelink.openai.azure.com`
- `privatelink.cognitiveservices.azure.com`

:::image type="complex" source="_images/ai-foundry-end-to-end-chat-portal-access.svg" border="false" lightbox="_images/ai-foundry-end-to-end-chat-portal-access.svg" alt-text="Diagram that shows a user connecting to a Machine Learning workspace through a jump box to author a flow OpenAI.":::
    The diagram shows a user connecting to a jump box virtual machine through Azure Bastion. An arrow points from the jump box to an Azure AI Foundry (portal) private endpoint. Another arrow points from the private endpoint to the Azure AI Foundry project that contains Foundry Agent Service. From the Azure AI Foundry project, an arrow points to a virtual interface in the private virtual network. A final arrow points from the virtual interface to the Foundry Agent Service dependencies private endpoints. Those dependencies are AI Search, Azure Cosmos DB
four arrows point to four private endpoints that connect to Container Registry, Storage, Azure OpenAI, and AI Search.
:::image-end:::

The diagram illustrates how an AI developer connects through Azure Bastion to a virtual machine (VM) jump box. From that jump box, the author can access the project in the AI Foundry portal through a private endpoint in the same network.

##### Control traffic from Azure AI Foundry agent subnet

This architecture enforces that all outbound (egress) network traffic from the Azure AI Foundry agent capability is routed through a delegated subnet within your virtual network. This subnet acts as the sole egress point for both the agent's required three service dependencies and any external knowledge or tool connections the agent is configured to use. The goal with this design is to reduce data exfiltration attempts from within the orchestration logic.

By forcing egress to happen this way, you can apply granular NSG rules, custom routing, and DNS control to all agent traffic leaving the service.

The agent service uses the virtual network's DNS configuration to resolve private endpoint records and any required external FQDNs. As such, the agent's requests can be integrated with DNS logging for audit and troubleshooting purposes.

The NSG attached to the agent egress subnet blocks all inbound traffic, as no legitimate ingress should occur. Outbound NSG rules are configured to allow only access to private endpoints subnet within the virtual network and port 443 TCP traffic to the internet. All other traffic is denied.

To further restrict the internet traffic, a UDR is applied to this subnet to force all HTTPS requests leaving the virtual network through Azure Firewall. The firewall enforces which fully qualified domain names (FQDN) the agents are allowed to access. For example, if your agent only needs to access the [Grounding with Bing](/azure/ai-services/agents/how-to/tools/bing-grounding) public APIs, you'd configure the Azure Firewall to allow only `api.bing.microsoft.com` on port 443 from this subnet. All other outbound destinations are denied.

##### Virtual network segmentation and security

This architecture implements network segmentation by assigning each major component group to its own subnet within the virtual network. Each subnet has a dedicated NSG that limits the inbound and outbound traffic to only what's required for its function in this workload. The table below summarizes the NSG and firewall configuration for each subnet:

| Usage / subnet name                   | Inbound traffic (NSG)  | Outbound traffic (NSG)         | UDR to firewall | Firewall egress rules |
| :------------------------------------ | :--------------------- | :----------------------------- | :-------------: | :-------------------- |
| Private endpoints<br>`snet-privateEndpoints` | Virtual network | No traffic allowed             | Yes             | No traffic allowed    |
| Application Gateway<br>`snet-appGateway`     | Chat UI user source IP addresses, such as the public internet, and required sources for the service | Private endpoint subnet and required items for the service | No | - |
| App Service<br>`snet-appServicePlan`  | No traffic allowed     | Private endpoints and Azure Monitor | Yes        | To Azure Monitor      |
| Azure AI Agent<br>`snet-agentsEgress` | No traffic allowed     | Private endpoints and internet | Yes             | Only those public FQDNs you allow your agents to use |
| Jump box VMs<br>`snet-jumpBoxes`      | Azure Bastion subnet   | Private endpoints and internet | Yes             | As needed by VM       |
| Build agents<br>`snet-buildAgents`    | Azure Bastion subnet   | Private endpoints and internet | Yes             | As needed by VM       |
| Azure Bastion<br>`AzureBastionSubnet` | See [NSG access and Azure Bastion](/azure/bastion/bastion-nsg). | See [NSG access and Azure Bastion](/azure/bastion/bastion-nsg). | No | - |
| Azure Firewall<br>`AzureFirewallSubnet`<br>`AzureFirewallManagementSubnet` | No NSG | No NSG    | No              | -                     |

All other traffic is explicitly denied, either through explicit NSG rules or by default in Azure Firewall.

When implementing network segmentation and security in this architecture, follow these recommendations:

- Deploy a [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) plan on the Application Gateway public IP to mitigate volumetric attacks.

- Attach an [NSG](/azure/virtual-network/network-security-groups-overview) to every subnet that allows NSGs. Use the strictest rules that don't block required functionality.

- Apply [forced tunneling](/azure/firewall/forced-tunneling) to all supported subnets, ensuring that all your egress firewall inspects all outbound traffic. Forced tunneling should be used even on subnets where you don't expect egress, as a defense-in-depth measure to protect against intentional or unintentional misuse of the subnet.

#### Governance through policy

To help ensure alignment with your workload's security baseline, use Azure Policy and network policies to enforce that all workload resources meet your requirements. Platform automation through policy reduces the risk of security configuration drift and helps reduce manual validation activities. Consider the following recommended types security policies this architecture can benefit from.

- Disable key-based or other local authentication methods in services like Azure AI services and Key Vault.
- Require explicit configuration of network access rules, private endpoints, and NSGs.
- Require encryption, such as the use of customer-managed keys.
- Enforce controls on resource creation, such as limiting which regions or resource types can be used.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To see a pricing example for this architecture, use this prebuilt [Azure pricing calculator](https://azure.com/e/9ed058e3b57b4386b7ac1bd3f782a344) estimate. You need to customize the example to match your usage because this example only includes the components that this architecture uses. The most expensive components in the scenario are Azure Cosmos DB, AI Search, and Azure DDoS Protection. Other notable costs include the chat UI compute and Application Gateway. Optimize those resources to reduce costs.

#### Foundry Agent Service

When using the standard deployment, you're responsible for provisioning and managing the service's dependencies in your own Azure subscription. The following recommendations clarify how to optimize costs for these required services.

- Foundry Agent Service manages the request units (RUs) allocation on Azure Cosmos DB. The most effective way to reduce long-term costs is to purchase reserved capacity for Azure Cosmos DB, aligning reservations with your expected usage duration and volume. However, reserved capacity requires upfront commitment and might not be flexible if your workload's usage patterns change significantly.

- If your chat scenario doesn't require file uploads, don't code this feature in your application. When file uploads aren't needed:

  - Use a locally redundant storage (LRS) tier for the Storage account.
  - Configure AI Search with a single replica instead of the recommended three.
  
- Regularly delete unused agents and their associated threads using the SDK or REST APIs. Stale agents and threads continue to consume storage and can increase costs across Azure Cosmos DB, Storage, and AI Search.

- Disable features on dependent resources that aren't required for your workload. For example:

  - Semantic ranker in AI Search
  - Gateway and multi-master writing features in Azure Cosmos DB

- Deploy all three dependencies (Azure Cosmos DB, Storage, AI Search) in the same Azure region as Foundry Agent Service. This avoids cross-region bandwidth charges.

- Avoid colocating workload-specific data in the same Azure Cosmos DB or AI Search resources used by Foundry Agent Service. However, in some cases, sharing these resources to avoid unused capacity in request units (RUs) or search units can be a strategic cost optimization. Only consider resource sharing after a thorough risk assessment for reliability, security, and performance tradeoffs.

#### Agent knowledge and tools

Foundry Agent Service executes agent logic in a nondeterministic manner, meaning it may invoke any connected knowledge store, tool, or other agent for each request, regardless of whether that resource is ultimately relevant to the specific user query. This can result in unnecessary calls to external APIs or data sources, increasing per-transaction costs and potentially introducing unpredictable usage patterns leading to budget forecasting challenges.

To control costs and maintain predictable behavior:

- Only connect knowledge stores, tools, or agents that you expect to be used with most agent invocations. Avoid connecting resources that are rarely needed or that incur high per-call costs unless essential.

- Carefully design and refine your agent's system prompt to try to instruct it to minimize unnecessary or redundant external calls. The system prompt should guide the agent to use only the most relevant connections for each request.

- Use Azure AI Foundry telemetry to monitor which external APIs, knowledge stores, or tools are being accessed, how often, and at what cost. Regularly review this telemetry to identify unexpected usage patterns or cost spikes, and adjust your agent prompt as needed.

- Be aware that nondeterministic invocation can make it difficult to forecast costs, especially when integrating with metered APIs. If cost predictability is a requirement, you might consider self-hosting your orchestrator using code that can be more deterministic.

#### Azure OpenAI models

Model deployments in Azure AI Foundry use the models-as-a-service (MaaS) approach, with costs driven primarily by usage or pre-provisioned allocation. Controlling demand is the primary way to control consumption model costs in this architecture. Use a combination of approaches.

- **Control clients.** Client requests are the primary source of cost in a consumption model, so controlling agent behavior is crucial. All model consumers should:

  - Be approved. Avoid exposing the models in a way that supports free-for-all access.

  - Be self controlled. Require agents to use the token-limiting constraints that API calls provide, such as max_tokens and max_completions. This is only possible in self-hosted orchestration approaches. Foundry Agent Service doesn't provide this limiting functionality.

  - Optimize prompt input and response length. Longer prompts consume more tokens, which increases cost. Prompts that lack sufficient context don't help the models produce good results. Create concise prompts that provide enough context to allow the model to generate a useful response. Ensure that you optimize the limit of the response length.

    This is only possible in self-hosted orchestration approaches. Foundry Agent Service doesn't provide enough configuration to control this.

- **Choose the right model for the agent.** Select the least expensive model that meets your agent's requirements. Avoid overprovisioning with higher-cost models unless necessary. For example, the reference implementation uses GPT-4o instead of a more expensive model and achieves sufficient results.

- **Monitor and manage usage.** Use [Azure cost management](/azure/ai-services/openai/how-to/manage-costs) and model telemetry to track token usage, set budgets, and create alerts for anomalies. Regularly review usage patterns and adjust quotas or client access as needed. See, [Plan and manage costs for Azure AI Foundry](/azure/ai-foundry/how-to/costs-plan-manage).

- **Use the right deployment type.** Use pay-as-you-go for unpredictable workloads, and switch to provisioned throughput when usage is stable and predictable. Combine both when you have a baseline established.

- **Restrict playground usage.** Restrict use of the Azure AI Foundry playground to preproduction environments to prevent unplanned production costs.

- **Fine-tuning and image generation.** Be aware that fine-tuning and image generation are billed differently (per hour or per batch). Plan usage to maximize value within billing intervals.

#### Network security resources

Azure Firewall is a required egress control point in this architecture. To optimize costs, use the Basic tier of Azure Firewall unless the rest of your workload components requires advanced features. Higher tiers add cost and are only justified if you need their capabilities.

If your organization uses Azure landing zones, consider using shared firewall and DDoS resources to defer or reduce costs. Shared resources can be effective for workloads with similar security and performance requirements, but ensure that sharing doesn't introduce security or operational risks. See what shared resources are used when this [Azure AI Foundry chat baseline is deployed in an Azure landing zone](./azure-openai-baseline-landing-zone.yml).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

This operational excellence guidance doesn't include the front-end application elements, which are unchanged from the [baseline highly available zone-redundant web application architecture](../../web-apps/app-service/architectures/baseline-zone-redundant.yml#deployment-flow).

#### Agent compute

Microsoft fully manages the serverless compute platform for Azure AI Agent REST APIs and the orchestration execution logic. If you self-host orchestration, as mentioned in the [alternatives](#alternatives), you gain more control over runtime characteristics and capacity however you'll be directly responsible for all day-2 operations relevant for that platform. You need to evaluate the constraints and responsibilities inherit in your selected approach to understand what day-2 operations need to be designed to support your orchestration layer.

In both approaches, state storage, such as chat history and agent configuration must be managed for durability, backup, and recovery.

#### Monitoring

Like in the basic architecture, diagnostics are configured for all services, sinking those streams to your workload's Log Analytics workspace. All services except App Service are configured to capture all logs. In production, all logs are likely excessive. For example, the chat UI application might only require `AppServiceHTTPLogs`, `AppServiceConsoleLogs`, `AppServiceAppLogs`, `AppServicePlatformLogs`, and `AppServiceAuthenticationLogs`. Tune log streams to your operational needs.

Evaluate building custom alerts, such as those found in the Azure Monitor baseline alerts, for the resources in this architecture. For example:

- [AI Search alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/Search/searchServices/)
- [Azure AI Services alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/CognitiveServices/accounts/)
- [Web Apps alerts](https://azure.github.io/azure-monitor-baseline-alerts/services/Web/serverFarms/)

Be sure to monitor the usage of tokens against your model deployments. In this architecture, Azure AI Foundry tracks [token usage](/azure/ai-foundry/how-to/monitor-quality-safety) through its integration with Application Insights.

Your jump boxes and build agent VMs are placed in a highly privileged location which gives those virtual machines, by design, network line of sight to the data plane of all components in your architecture. Ensure those VMs emit enough logs to understand when they're being used, by whom, and what actions they're performing.

#### Agent versioning and life cycle

Treat each agent as an independently deployable unit within your chat workload, unless your application is specifically designed to dynamically create and delete agents at runtime. These agents have life cycle management requirements similar to other microservices in your workload. Ensuring safe and controlled deployment of agents is critical to prevent service disruptions.

- **Define agents as code.** Always store agent definitions, connections, system prompts, and configuration parameters in source control. This practice ensures traceability and reproducibility. Avoid untracked changes made through the Azure AI Foundry portal.

- **Automate agent deployment.** Use your workload's CI/CD pipelines and use the AI Agent SDK to build, test, and deploy agent changes from your network-connected build agents.

  Aim for agent pipelines that can be deployed independently for small, incremental changes, but are also flexible enough to be deployed together with your application code when coordinated updates are required. To support this, loosely couple your chat UI code and your chat agents, so that changes to one don't require simultaneous changes to the other.

- **Test before production.** Validate agent behavior, prompts, and connections in preproduction environments. Use a combination of automated and manual tests to catch regressions, security issues, and unintended changes in agent behavior.

  Because agents defined in Foundry Agent Service are nondeterministic, you must determine how to measure and maintain your desired quality level. This involves creating and executing a suite of tests that check for ideal responses to realistic user questions and scenarios.

- **Version and track agents.** Assign clear version identifiers to each agent. Maintain records of which agent versions are active, along with their dependencies such as models, data sources, and tools. Prefer deploying new agent versions side-by-side with existing ones to enable progressive rollout, rollback, and controlled migration of users or sessions.

- **Plan for failback.** Azure AI Foundry doesn't provide built-in support for blue-green or canary deployments of agents. If you require these deployment patterns, implement a routing layer (such as an API gateway or custom router) in front of the agent API. This allows you to incrementally shift traffic between agent versions, monitor the impact, and perform a full cutover when ready.

- **Coordinate agent removal.** When removing agents, coordinate the process with your application's state management and user experience requirements. Ensure that active chat sessions are handled appropriately. This might involve migrating sessions, pinning users to the old agent version, or requiring users to start new sessions, depending on your workload's functional requirements.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This section addresses performance efficiency for AI Search, Azure AI Foundry, and model deployments.

#### Performance Efficiency in AI Search

When using Foundry Agent Service, you don't control the specific queries sent to your indexes because agents are codeless. To optimize performance, focus on what you can control with the index by observing how your agent typically queries the index. Follow the guidance to [analyze and optimize performance in AI Search](/azure/search/search-performance-analysis).

If you encounter bottlenecks that can't be resolved through index server tuning alone, consider these options:

- Replace the direct connection to AI Search with a connection to an API that you own. This API can implement code optimized for your agent's retrieval patterns.
- Redesign the orchestration layer to use the [self-hosted alternative](#chat-orchestration), allowing you to define and optimize queries in your own orchestrator code.

#### Performance Efficiency in model deployments

- Decide if your application needs [provisioned throughput](/azure/ai-services/openai/concepts/provisioned-throughput) or can use the shared (consumption) model. Provisioned throughput provides reserved capacity and predictable latency, which is important for production workloads with strict SLOs. The consumption model is best-effort and might be affected by noisy neighbor effects.

- Monitor [provision-managed utilization](/azure/ai-services/openai/how-to/monitoring) to ensure you're not over or under-provisioned.

- Choose a conversational model that meets your inference latency requirements.

- Deploy models in the same data region as your agents to minimize network latency.

#### Azure AI Agent performance

Azure AI Agents run on a serverless compute backend that doesn't support custom performance tuning. However, you can still improve performance through agent design:

- Minimize the number of knowledge stores and tools connected to your chat agent. Each additional connection potentially increases the total execution time for an agent call, as the agent may invoke all configured resources per request.

- Use Azure Monitor and Application Insights to track agent invocation times, tool/knowledge store latencies, and error rates. Regularly review this telemetry to identify slow knowledge or tool connections.

- Design system prompts to guide the agent to use connections efficiently. For example, instruct the agent to query external knowledge stores only when needed, or to avoid redundant tool invocations.

- Although serverless compute scales automatically, be aware of service limits or quotas that could affect peak load scenarios. Monitor for throttling (HTTP 429/503 responses).

## Deploy this scenario

To deploy and run this reference implementation, follow the deployment guide in the [Foundry Agent Service chat baseline reference implementation](https://github.com/Azure-Samples/openai-end-to-end-baseline/).

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

[Azure AI Foundry chat baseline in an Azure landing zone](./azure-openai-baseline-landing-zone.yml)

## Related resources

- A Well-Architected Framework perspective on [AI workloads on Azure](/azure/well-architected/ai/get-started)
- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service)
- [Azure OpenAI language models](/azure/ai-services/openai/concepts/models)
- [Content filtering](/azure/ai-services/openai/concepts/content-filter)