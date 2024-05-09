The Azure OpenAI Service exposes HTTP APIs that allow your applications to perform embeddings or completions using OpenAI's large language models (LLMs). Intelligent applications call these HTTP APIs either directly from clients or orchestrators. Examples of clients include chat UI code and custom data processing pipelines, while examples of orchestrators include LangChain, Semantic Kernel, and Azure Machine Learning prompt flow. When your workload involves connecting to one or more Azure OpenAI instances, you'll need to decide whether these consumers connect directly or through a reverse proxy API gateway.

Use this guide to learn about the key challenges across the five pillars of the [Azure Well-Architected Framework](/azure/well-architected/) that you'll encounter if your workload design includes direct access from your consumers to the Azure OpenAI data plane APIs. You'll then learn how introducing a gateway in your architecture can address these direct access challenges, while introducing new challenges you need to further address. This article doesn't cover how the gateway is implemented, rather it covers the architectural pattern.

Because a gateway can be used to solve specific scenarios, not all of which are present in every workload, be sure to see [Specific scenario guidance](#next-step) that looks at that specific use case of a gateway in more depth.

## Key challenges

Without an API gateway or the ability to add logic into the Azure OpenAI HTTP APIs, the responsibility for API client logic, including retry mechanisms or circuit breaking, falls on the client. This can be challenging in scenarios where you are not in direct control of the client code or the code is restricted to specific SDK usage. Multiple clients or multiple Azure OpenAI instances and deployments present further challenges, such as coordination of safe deployments and observability.

Here are some examples of specific key architectural challenges you face if your architecture only supports direct access to Azure OpenAI from consumers. The challenges are organized using the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars).

### Reliability challenges

The reliability of the workload depends on several factors, including its capacity for self-preservation and self-recovery, often implemented through replication and failover mechanisms. Without a gateway, all reliability concerns must be addressed exclusively in client logic and Azure OpenAI service features. When there isn't enough reliability control available in either of those two surfaces, workload reliability is compromised.

- **Redundancy:** Failing over between multiple Azure OpenAI instances based on service availability is a client responsibility that you need to control through configuration and custom logic.

- **Scale out to handle spikes:** Failing over to Azure OpenAI instances with capacity when throttled is another client responsibility that you need to control through configuration and custom logic. Updating multiple client configurations for new Azure OpenAI instances carries greater risk and has timeliness concerns. The same is true for updating client code to implement changes in logic, such as directing low priority requests to a queue during high demand periods.

- **Load balancing/throttling:** The Azure OpenAI APIs throttles requests by returning a 429 response code to requests that exceed the Token-Per-Minute (TPM) or Requests-Per Minute (RPM) in the consumption billing model or requests that exceed the provisioned throughput units (PTU) capacity for the pre-provisioned billing model. Handling appropriate back-off and retry logic is left exclusively to client implementations.

### Security challenges

Security controls must protect workload confidentiality, integrity, and availability. Without a gateway, all security concerns must be addressed exclusively in client logic and Azure OpenAI service features. Workload requirements might demand more than what's available for client segmentation, client control, or service security features for direct communication.

- **Identity management - authentication scope:** The data plane APIs exposed by Azure OpenAI can be secured in one of two ways, API key or Azure role-based access control (RBAC). No matter which approach is used, authentication happens at the Azure OpenAI instance level, not the individual deployment level. This introduces complexity for providing least privileged access and identity segmentation for specific deployment models.

- **Identity management - identity providers:** For clients that cannot use identities found in the Microsoft Entra tenant backing the Azure OpenAI instance, clients are left sharing a single full-access API key. API keys have security usefulness limitations and are problematic when multiple clients are involved due to all clients sharing the same identity.

- **Network security:** Depending on client location relative to your Azure OpenAI instances, public internet access to LLM models might be necessary.

- **Data sovereignty:** Data sovereignty in the context of Azure OpenAI refers to the legal and regulatory requirements related to the storage and processing of data within the geographic boundaries of a specific country or region. Your workload needs to ensure regional affinity for clients to comply with data residency and sovereignty laws. This involves multiple Azure OpenAI deployments.

### Cost optimization challenges

Workloads benefit from ensuring architectures minimize waste and maximize utility. Strong cost modeling and monitoring are an important requirement of any workload. Without a gateway, utilization of PTU or per-client cost tracking can be authoritatively achieved exclusively from aggregating Azure OpenAI instance usage telemetry.

- **Cost tracking:** Being able to provide a financial perspective on Azure OpenAI usage is limited to data aggregated from Azure OpenAI instance usage telemetry. When required to do chargeback or showback, you need to be able to attribute that usage telemetry with various clients across different departments or even customers for multitenant scenarios.

- **Provisioned throughput utilization:** Your workload wants to avoid waste by fully utilizing the provisioned throughput you paid for. This means that clients must be trusted and coordinated to use PTU-based model deployments before spilling over into any consumption-based model deployments.

### Operational excellence challenges

Without a gateway, observability, change control, and development processes are limited to what is provided with direct client to server communication provides.

- **Quota control:** Clients receive 429s directly from Azure OpenAI when the HTTP APIs are throttled. Workload operators are responsible to make sure enough quota is available for legitimate usage while also ensuring that misbehaving clients do not consume in excess. When your workload consists of multiple model deployments, understanding where quota is being used, where quota is available, can be a challenge to visualize.

- **Monitoring and observability:** Azure OpenAI services default metrics are available via Azure Monitor however there's latency with the availability of the data and doesn't provide real-time monitoring.

- **Safe deployment practices:** Your LLMOps process will require coordination between clients and the models deployed in Azure OpenAI. For advanced deployment approaches, such as blue/green or canary, that logic will need to be handled client side.

### Performance efficiency challenges

Without a gateway, your workload puts responsibility on clients to be both individually well-behaved and behave fairly with other clients against limited capacity.

- **Performance optimization - priority traffic:** Prioritizing client requests so that high priority clients have preferential access over low priority clients would require extensive, and likely untenable, client-to-client coordination. Some workloads would benefit from having low priority requests queued to run when model utilization is low.

- **Performance optimization - client compliance:** In order to share capacity, clients need to be well-behaved, such as ensuring `max_tokens` and `best_of` are set to approved values. Without a gateway, you'll need to trust clients to act in the best interest of preserving capacity of your Azure OpenAI instance.

- **Minimize latency:** While network latency is usually a small component of the overall prompt and completion request flow, ensuring clients are routed to a network endpoint and model close to them could be a benefit. Without a gateway, clients would need to self-select which of your model deployments endpoint to use and what credentials are necessary for that specific Azure OpenAI data plane API.

## Solution

:::image type="complex" source="_images/azure-openai-gateway-conceptual-architecture.svg" lightbox="_images/azure-openai-gateway-conceptual-architecture.svg" alt-text="Diagram that shows a conceptual architecture of injecting a gateway between an intelligent application and Azure OpenAI.":::
    The diagram shows an intelligent application icon with an arrow pointing into a dashed line box labeled gateway. The arrow goes through a line that is labeled 'Federated Authentication,' pointing to a 'rate limiter' icon. The 'rate limiter' has an arrow that points to a 'router' icon. The 'router' has four arrows pointing to different icons. The first arrow points to a 'load balancer,' which points to 'OpenAI deployment' or 'LLM' icons in two regions and on-premises. The second arrow points to a 'monitoring' icon that later points to a 'cost' and a 'usage' icon. The third arrow points to a 'compute' icon. The fourth points to a 'message queue' icon, which then points to the 'Load balancer.'
:::image-end:::
*Figure 1: Conceptual architecture of accessing Azure OpenAI through a gateway*

To address the many of the challenges listed in the [Key challenges](#key-challenges) section, you can inject a reverse proxy gateway to decouple the intelligent application from the Azure OpenAI service. This [gateway offloading](../../patterns/gateway-offloading.yml) allows you to shift responsibility, complexity, and observability away from clients and gives you an opportunity to augment the Azure OpenAI service by providing other capabilities not otherwise built-in. Some examples are:

- Implementing [federated authentication](../../patterns/federated-identity.yml)
- Controlling pressure on models through [rate limiting](../../patterns/rate-limiting-pattern.yml)
- Cross-cutting and cross-model monitoring
- Ability to introduce [gateway aggregation](../../patterns/gateway-aggregation.yml) and advanced [routing](../../patterns/gateway-routing.yml) to multiple services such as routing low priority messages to a queue for [queue-based load leveling](../../patterns/queue-based-load-leveling.yml) or to compute to perform tasks.
- Load balancing that uses [health endpoint monitoring](../../patterns/health-endpoint-monitoring.yml) to route only to health endpoints by [circuit breaking](../../patterns/circuit-breaker.yml) on unavailable or overloaded model deployments.

Some specific scenarios have additional guidance available that directly addresses an API gateway and Azure OpenAI instances. Those scenarios are listed in the [Next step](#next-step) section.

## Considerations

When you introduce a new component into your architecture, you need to evaluate the newly introduced tradeoffs. When you inject an API gateway between your clients and the Azure OpenAI data plane to address any of [key challenges](#key-challenges), you introduce new considerations to your architecture. Carefully evaluate whether the workload impact across these architectural considerations justifies the added value or utility of the gateway.

### Reliability

When considering how an API gateway benefits your architecture, use the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist) to evaluate your design. You need to address reliability considerations such as:

- The gateway solution can introduce a single point of failure. This failure could have its origin in service availability of the gateway platform, interruptions due to code or configuration deployments, or even misconfiguration of critical API endpoints in your gateway. Ensure you design your implementation to meet your workload's availability requirements. Consider resiliency and fault tolerance capabilities in the implementation by including the gateway in the [failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis) of the workload.
- Your solution might require global routing capabilities if your architecture requires Azure OpenAI instances in multiple regions. This can further complicate the topology through management of additional fully qualified domain names (FQDNs), TLS certificates, and additional global routing components.

> [!IMPORTANT]
> Don't implement a gateway if doing so would jeopardize your workload's ability to hit agreed upon service-level objectives.

### Security

When considering how an API gateway benefits your architecture, use the [Design review checklist for Security](/azure/well-architected/security/checklist) to evaluate your design. You need to address security considerations such as:

- The surface area of the workload is increased with the addition of the gateway. That surface area brings extra identity and access management (IAM) considerations of the Azure resources, increased hardening efforts, and more.
- The gateway can act as a network boundary transition between client network space and private Azure OpenAI network space. While this might allow a previously Internet-facing Azure OpenAI endpoint to now be private through private link, point of entry is instead shifted to the gateway, which needs protection itself.
- A gateway is in a unique position to see raw request data and formulated responses from the LLM, which could include confidential data from either source. Data compliance and regulatory scope is now extended to this additional component.
- A gateway can extend the scope of client authorization and authentication beyond Microsoft Entra ID and API key authentication, potentially across multiple identity providers (IdP).
- In multi-region implementations, you must factor in data sovereignty in your implementation. Ensure your gateway compute and routing logic adheres to sovereignty requirements placed on your workload.

> [!IMPORTANT]
> Don't implement a gateway if doing so would leave your workload unable to protect the confidentiality, integrity, or availability of the itself or its users' data.

### Cost Optimization

When considering how an API gateway benefits your architecture, use the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist) to evaluate your design.

Any API gateway that is implemented has runtime costs that need to be budgeted and accounted for. Those costs usually increase with features to address the reliability, security, and performance of the gateway itself along with operational costs introduced with added APIOps management. These added costs need be measured against the new value delivered from the system with the gateway. Ideally you want to reach a point where the new capabilities introduced through using a gateway greatly outweigh the cost of implementing and maintaining the gateway. Depending on your workload's relationship to its users, you might be able to charge back usage.

### Operational Excellence

When considering how an API gateway benefits your architecture, use the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist) to evaluate your design. You need to address operational excellence considerations such as:

- The gateway itself needs to be monitored by your workload's monitoring solution and potentially by clients. This means that gateway compute and operations need to be included in the workload's [health modeling](/azure/well-architected/cross-cutting-guides/health-modeling).
- Your safe deployment practices now need to address the deployment of the API gateway infrastructure and the code or configuration of the gateway routing. Your infrastructure automation and Infrastructure as Code (IaC) solution needs to consider how to treat your gateway as a long-lived resource in the workload.
- You need to build or extend your APIOps approach to cover the APIs exposed in the gateway.

### Performance Efficiency

When considering how an API gateway benefits your architecture, use the [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) to evaluate your design. You need to address performance efficiency considerations such as:

- The gateway service can introduce a throughput bottleneck. Ensure the gateway has adequate performance to handle full concurrent load and can easily scale in line with your growth expectations. Ensure elasticity in the solution to ensure the gateway can reduce supply (scale down) when demand is low, such as typical with business day usage.
- The gateway service does have processing to perform per request, and will introduce added latency per API invocation. You should optimize your routing logic to keep requests performing well.
- In most cases, the gateway should be geographically near both the users and the Azure OpenAI instances to reduce latency. While network latency is usually a small percentage of time in overall API calls to LLMs, it might be a competitive factor for your workload.
- Evaluate the impact of the gateway on Azure OpenAI features such as streaming responses or instance pinning for stateful interactions such as the Assistant API.

> [!IMPORTANT]
> Don't implement a gateway if doing make achieving negotiated performance targets impossible or too compromising on other tradeoffs.

## Implementation options

Azure doesn't offer a turn-key solution designed specifically to proxy Azure OpenAI's HTTP API or other custom large language model inferencing APIs. But there are still several options for your workload team to implement such a gateway in Azure.

### Use Azure API Management

[Azure API Management](/azure/api-management/api-management-key-concepts) is platform-managed service specifically designed to offload cross-cutting concerns for HTTP-based APIs. It's configuration driven and supports customization through its inbound and outbound request processing policy system. It supports highly available, zone-redundant, and even multi-region replicas through a single control plane.

Most of the gateway routing and request handling logic must be implemented in the policy system of API Management. You'll combine [built-in policies](/azure/api-management/api-management-policies) and custom policies. Some example custom policies can be found on this community GitHub repository, [Azure OpenAI API Management policies](https://github.com/CrewAakash/aoai-apim-policies).

Use the [Well-Architected Framework service guide for API Management](/azure/well-architected/service-guides/api-management/reliability) when designing a solution involving Azure API Management.

Using Azure API Management for your gateway implementation is generally the preferred approach to building and operating an Azure OpenAI gateway. This is based on the service being a platform as a service (PaaS) offering with rich built-in capabilities, high availability, and networking options. It also robust APIOps approaches to managing your completion APIs.

### Use custom code

The custom code approach requires a software development team to create a custom coded solution and deploy that solution to an application platform of their choosing on Azure. Building a self-managed solution to handle the gateway logic can be a good fit for workload teams proficient at managing network and routing code.

The workload can usually use compute they're familiar with. For example, hosting the gateway code on Azure App Service, Azure Container Apps, or Azure Kubernetes Service.

Custom code deployments can also be fronted with API Management, where API Management is used exclusively for its core HTTP API gateway capabilities between your clients and your custom code. This way your custom code focuses exclusively on interfacing with your Azure OpenAI HTTP APIs based on the necessary business logic.

The use of third-party gateway technology, a product or service that isn't natively provided by Azure, also can be considered as part of this approach.

## Example architecture

:::image type="complex" source="_images/azure-openai-gateway-example-architecture.svg" lightbox="_images/azure-openai-gateway-example-architecture.svg" alt-text="Diagram that shows an example architecture of injecting a gateway between an intelligent application and Azure OpenAI.":::
    The diagram shows an intelligent application icon with an arrow pointing to two Azure API Management icons, one of which is gateway only. The icons have arrows pointing to two Azure OpenAI icons in one region and one in another. One of the Azure API Management icons has an arrow pointed to Azure Event Hubs with the arrow labeled 'batch request.' The same icon has an arrow pointing to an Azure Function with the arrow labeled 'Compute service.' The Azure function has an arrow pointed to API Management with a label 'Replay batched request' and an arrow pointing to Azure Event Hubs labeled 'Batched request.' At the bottom of the diagram are a Microsoft Entra ID icon, an Azure Traffic Manager icon, Application Insights and an Azure Monitor icon.
:::image-end:::
*Figure 2: Example architecture of accessing Azure OpenAI through an Azure API Management-based gateway*

## Next step

Learn about a specific scenario where deploying a gateway between an intelligent application and Azure OpenAI deployments is used to address workload requirements:

| Scenario | Description |
| :------- | :---------- |
| [Load balancing or failover between multiple backend instances](./azure-openai-gateway-multi-backend.yml) | Route requests across multiple Azure OpenAI deployments using an API gateway. |
