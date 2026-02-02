This article describes the key challenges across the five pillars of the [Azure Well-Architected Framework](/azure/well-architected/) that you encounter if your workload design includes direct access from your consumers to the Azure OpenAI in Foundry Models data plane APIs. Learn how introducing a gateway into your architecture can help resolve these direct access challenges, while introducing new challenges. This article describes the architectural pattern but not how to implement the gateway.

[Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service) exposes HTTP APIs that let your applications perform embeddings or completions by using OpenAI's language models. Intelligent applications call these HTTP APIs directly from clients or orchestrators. Examples of clients include chat UI code and custom data processing pipelines. Examples of orchestrators include Microsoft Agent Framework, Semantic Kernel, LangChain, and Foundry Agent Service. When your workload connects to one or more Azure OpenAI instances, you must decide whether these consumers connect directly or through a reverse proxy API gateway.

Because a gateway can be used to solve specific scenarios that might not be present in every workload, see be sure to see [Specific scenario guidance](#next-steps), which looks at that specific use case of a gateway in more depth.

## Key challenges

Without an API gateway or the ability to add logic into the Azure OpenAI HTTP APIs, the client has to handle the API client logic, which includes retry mechanisms or circuit breakers. This situation can be challenging in scenarios in which you don't directly control the client code, or when the code is restricted to specific SDK usage. Multiple clients or multiple Azure OpenAI instances and deployments present further challenges, such as coordination of safe deployments and observability.

This section provides examples of specific key architectural challenges that you might face if your architecture only supports direct access to Azure OpenAI from consumers. The challenges are organized by using the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars).

### Reliability challenges

The reliability of the workload depends on several factors, including its capacity for self-preservation and self-recovery, which are often implemented through replication and failover mechanisms. Without a gateway, all reliability concerns must be addressed exclusively by using client logic and Azure OpenAI features. Workload reliability is compromised when there isn't enough reliability control available in either of those two surfaces.

- **Load balancing or Redundancy:** Failing over between multiple Azure OpenAI instances based on service availability is a client responsibility that you need to control through configuration and custom logic.

  Whether you use [Global](/azure/ai-foundry/foundry-models/concepts/deployment-types#global-standard), standard or provisioned, or [data zone](/azure/ai-foundry/foundry-models/concepts/deployment-types#data-zone-standard), standard or provisioned, it doesn't affect the Azure OpenAI availability from a regional endpoint availability perspective. You still have a responsibility to implement failover logic yourself.

- **Scale out to handle spikes:** Failing over to Azure OpenAI instances with capacity when throttled is another client responsibility that you need to control through configuration and custom logic. Updating multiple client configurations for new Azure OpenAI instances presents greater risk and has timeliness concerns. The same is true for updating client code to implement changes in logic, such as directing low priority requests to a queue during high demand periods.

- **Throttling:** Azure OpenAI APIs throttle requests by returning an HTTP 429 error response code to requests that exceed the Token-Per-Minute (TPM) or Requests-Per-Minute (RPM) in the standard model. Azure OpenAI APIs also throttle requests that exceed provisioned capacity for the pre-provisioned billing model. Handling appropriate back-off and retry logic is left exclusively to client implementations.

  Most workloads should solve this specific issue by using [global](/azure/ai-foundry/foundry-models/concepts/deployment-types#global-standard) and [data zone](/azure/ai-foundry/foundry-models/concepts/deployment-types#data-zone-standard) deployments of Azure OpenAI. Those deployments to use model capacity from data centers with the enough capacity for each request. Using global and data zone deployments will significantly decrease service throttling without added complexity of custom gateways. The global and data zone deployments are themselves a gateway implementation.

### Security challenges

Security controls must help protect workload confidentiality, integrity, and availability. Without a gateway, all security concerns must be addressed exclusively in client logic and Azure OpenAI features. Workload requirements might demand more than what's available for client segmentation, client control, or service security features for direct communication.

- **Identity management - authentication scope:** The data plane APIs exposed by Azure OpenAI can be secured in one of two ways: API key or Azure role-based access control (RBAC). In both cases, authentication happens at the Azure OpenAI instance level, not the individual deployment level, which introduces complexity for providing least privileged access and identity segmentation for specific deployment models.

- **Identity management - identity providers:** Clients that can't use identities located in the Microsoft Entra tenant that's backing the Azure OpenAI instance must share a single full-access API key. API keys have security usefulness limitations and are problematic when multiple clients are involved and all share the same identity.

- **Network security:** Depending on client location relative to your Azure OpenAI instances, public internet access to language models might be necessary.

- **Data sovereignty:** Data sovereignty in the context of Azure OpenAI refers to the legal and regulatory requirements related to the storage and processing of data within the geographic boundaries of a specific country or region. Your workload needs to ensure regional affinity so that clients can comply with data residency and sovereignty laws. This process involves multiple Azure OpenAI deployments.

  You should be aware that when you are using [global](/azure/ai-foundry/foundry-models/concepts/deployment-types#global-standard) or [data zone](/azure/ai-foundry/foundry-models/concepts/deployment-types#data-zone-standard) deployments of Azure OpenAI, data at rest remains in the designated Azure geography, but data may be transmitted and processed for inferencing in any Azure OpenAI location.

### Cost optimization challenges

Workloads benefit when architectures minimize waste and maximize utility. Strong cost modeling and monitoring are an important requirement for any workload. Without a gateway, utilization of provisioned or per-client cost tracking can be authoritatively achieved exclusively from aggregating Azure OpenAI instance usage telemetry.

- **Cost tracking:** Being able to provide a financial perspective on Azure OpenAI usage is limited to data aggregated from Azure OpenAI instance usage telemetry. When required to do chargeback or showback, you need to attribute that usage telemetry with various clients across different departments or even customers for multitenant scenarios.

- **Provisioned throughput utilization:** Your workload wants to avoid waste by fully utilizing the provisioned throughput that you paid for. This means that clients must be trusted and coordinated to use provisioned model deployments before spilling over into any standard model deployments.

### Operational excellence challenges

Without a gateway, observability, change control, and development processes are limited to what is provided by direct client-to-server communication.

- **Quota control:** Clients receive 429 response codes directly from Azure OpenAI when the HTTP APIs are throttled. Workload operators are responsible for ensuring that enough quota is available for legitimate usage and that misbehaving clients don't consume in excess. When your workload consists of multiple model deployments or multiple data zones, understanding quota usage and quota availability can be difficult to visualize.

- **Monitoring and observability:** Azure OpenAI default metrics are available through Azure Monitor. However, there's latency with the availability of the data and it doesn't provide real-time monitoring.

- **Safe deployment practices:** Your GenAIOps process requires coordination between clients and the models that are deployed in Azure OpenAI. For advanced deployment approaches, such as blue-green or canary, logic needs to be handled on the client side.

### Performance efficiency challenges

Without a gateway, your workload puts responsibility on clients to be individually well-behaved and to behave fairly with other clients against limited capacity.

- **Performance optimization - priority traffic:** Prioritizing client requests so that high priority clients have preferential access over low priority clients would require extensive, and likely unreasonable, client-to-client coordination. Some workloads might benefit from having low priority requests queued to run when model utilization is low.

- **Performance optimization - client compliance:** To share capacity, clients need to be well-behaved. An example of this is when clients ensure that `max_tokens` and `best_of` are set to approved values. Without a gateway, you must trust clients to act in the best interest of preserving capacity of your Azure OpenAI instance.

- **Minimize latency:** While network latency is usually a small component of the overall prompt and completion request flow, ensuring that clients are routed to a network endpoint and model close to them might be beneficial. Without a gateway, clients would need to self-select which model deployment endpoints to use and what credentials are necessary for that specific Azure OpenAI data plane API.

## Solution

:::image type="complex" source="_images/azure-openai-gateway-conceptual-architecture.svg" lightbox="_images/azure-openai-gateway-conceptual-architecture.svg" alt-text="Diagram that shows a conceptual architecture that injects a gateway between an intelligent application and Azure OpenAI.":::
    The diagram shows an intelligent application icon with an arrow pointing into a dashed line box labeled gateway. The arrow goes through a line that is labeled 'Federated Authentication,' pointing to a 'rate limiter' icon. The 'rate limiter' has an arrow that points to a 'router' icon. The 'router' has four arrows pointing to different icons. The first arrow points to a 'load balancer,' which points to 'OpenAI deployment' or 'LLM' icons in two regions and on-premises. The second arrow points to a 'monitoring' icon that later points to a 'cost' and a 'usage' icon. The third arrow points to a 'compute' icon. The fourth points to a 'message queue' icon, which then points to the 'Load balancer.'
:::image-end:::
*Figure 1: Conceptual architecture of accessing Azure OpenAI through a gateway*

To address the many challenges listed in [Key challenges](#key-challenges), you can inject a reverse proxy gateway to decouple the intelligent application from Azure OpenAI. This [gateway offloading](../../patterns/gateway-offloading.yml) lets you shift responsibility, complexity, and observability away from clients and gives you an opportunity to augment Azure OpenAI by providing other capabilities that aren't built in. Some examples are:

- Potential to implement [federated authentication](../../patterns/federated-identity.yml).

- Ability to control pressure on models through [rate limiting](../../patterns/rate-limiting-pattern.yml).

- Cross-cutting and cross-model monitoring.

- Ability to introduce [gateway aggregation](../../patterns/gateway-aggregation.yml) and advanced [routing](../../patterns/gateway-routing.yml) to multiple services, like routing low priority messages to a queue for [queue-based load leveling](../../patterns/queue-based-load-leveling.yml) or to compute resources to handle tasks.

- Load balancing that uses [health endpoint monitoring](../../patterns/health-endpoint-monitoring.yml) to route only to healthy endpoints by [circuit breaking](../../patterns/circuit-breaker.md) on unavailable or overloaded model deployments.

Some specific scenarios have more guidance available that directly addresses an API gateway and Azure OpenAI instances. Those scenarios are listed in the [Next steps](#next-steps) section.

## Considerations

The decision to add a gateway and what technology to use is made as part of the [Application design](/azure/well-architected/ai/application-design#evaluate-the-use-of-api-gateways) described in the Azure Well-Architected Framework's [AI workloads on Azure](/azure/well-architected/ai/get-started) guidance. As an architect, you'll need to make the decision to include or exclude this component.

When you introduce a new component into your architecture, you need to evaluate the newly introduced tradeoffs. When you inject an API gateway between your clients and the Azure OpenAI data plane to address any of [key challenges](#key-challenges), you introduce new considerations into your architecture. Carefully evaluate whether the workload impact across these architectural considerations justifies the added value or utility of the gateway.

### Reliability

Reliability ensures that your application meets the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- The gateway solution can introduce a single point of failure. This failure could have its origin in service availability of the gateway platform, interruptions due to code or configuration deployments, or even misconfigured critical API endpoints in your gateway. Ensure that you design your implementation to meet your workload's availability requirements. Consider resiliency and fault tolerance capabilities in the implementation by including the gateway in the [failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis) of the workload.

- Your solution might require global routing capabilities if your architecture requires Azure OpenAI instances in multiple regions to increase the availability of your Azure OpenAI endpoints, such as the ability to continue to serve requests in the event of a regional outage. This situation can further complicate the topology through management of extra fully qualified domain names, TLS certificates, and more global routing components.

> [!IMPORTANT]
> Don't implement a gateway if doing so would jeopardize your workload's ability to meet agreed upon service-level objectives (SLOs).

### Security

When considering how an API gateway benefits your architecture, use the [Design review checklist for Security](/azure/well-architected/security/checklist) to evaluate your design. You need to address the following security considerations:

- The surface area of the workload is increased with the addition of the gateway. That surface area brings extra identity and access management (IAM) considerations of the Azure resources, increased hardening efforts, and more.

- The gateway can act as a network boundary transition between client network space and private Azure OpenAI network space. Even though the gateway makes a previously internet-facing Azure OpenAI endpoint private through the use of Azure Private Link, it now becomes the new point of entry and must be adequately secured.

- A gateway is in a unique position to see raw request data and formulated responses from the language model, which could include confidential data from either source. Data compliance and regulatory scope is now extended to this other component.

- A gateway can extend the scope of client authorization and authentication beyond Microsoft Entra ID and API key authentication, and potentially across multiple identity providers (IdP).

- Data sovereignty must be factored in your implementation in multi-region implementations. Ensure that your gateway compute and routing logic adheres to sovereignty requirements placed on your workload.

> [!IMPORTANT]
> Don't implement a gateway if doing so would leave your workload unable to protect the confidentiality, integrity, or availability of itself or its users' data.

### Cost Optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

All implemented API gateways have runtime costs that need to be budgeted and accounted for. Those costs usually increase with added features to address the reliability, security, and performance of the gateway itself along with operational costs introduced with added APIOps management. These added costs need be measured against the new value delivered from the system with the gateway. You want to reach a point where the new capabilities introduced by using a gateway outweigh the cost to implement and maintain the gateway. Depending on your workload's relationship to its users, you might be able to chargeback usage.

To help manage costs when developing and testing a gateway, consider using a simulated endpoint for Azure OpenAI. For example, use the solution in the [Azure OpenAI API simulator](https://github.com/microsoft/aoai-api-simulator/) GitHub repository.

### Operational Excellence

When considering how an API gateway benefits your architecture, use the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist) to evaluate your design. You need to address the following operational excellence considerations:

- The gateway itself needs to be monitored by your workload's monitoring solution and potentially by clients. This means that gateway compute and operations need to be included in the workload's [health modeling](/azure/well-architected/cross-cutting-guides/health-modeling).

- Your safe deployment practices now need to address the deployment of the API gateway infrastructure and the code or configuration of the gateway routing. Your infrastructure automation and infrastructure as code (IaC) solution needs to consider how to treat your gateway as a long-lived resource in the workload.

- You need to build or extend your APIOps approach to cover the APIs exposed in the gateway.

- You duplicate capabilities that are available through solutions such as the Azure AI Service resource or Azure OpenAI data zone load distribution functionality.

### Performance Efficiency

When considering how an API gateway benefits your architecture, use the [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) to evaluate your design. You need to address the following performance efficiency considerations:

- The gateway service can introduce a throughput bottleneck. Ensure the gateway has adequate performance to handle full concurrent load and can easily scale in line with your growth expectations. Ensure elasticity in the solution so that the gateway can reduce supply, or scale down, when demand is low, such as with business day usage.

- The gateway service has processing that it must run for each request and introduces added latency for each API invocation. Optimize your routing logic to keep requests fast and reliable.

- In most cases, the gateway should be geographically near both the users and the Azure OpenAI instances to reduce latency. While network latency is usually a small percentage of time in overall API calls to language models, it might be a competitive factor for your workload.

- Evaluate the impact of the gateway on Azure OpenAI features, such as streaming responses or instance pinning for stateful interactions, such as the Assistants API.

> [!IMPORTANT]
> Don't implement a gateway if doing so makes achieving negotiated performance targets impossible or too compromising on other tradeoffs.

## Implementation options

Azure doesn't offer a turn-key solution designed specifically to proxy Azure OpenAI's HTTP API or other custom language model inferencing APIs to cover all of these scenarios. But there are still several options for your workload team to implement, such as a gateway in Azure.

### Use Azure API Management

[Azure API Management](/azure/api-management/api-management-key-concepts) is a platform-managed service designed to offload cross-cutting concerns for HTTP-based APIs. It's configuration driven and supports customization through its inbound and outbound request processing policy system. It supports highly available, zone-redundant, and even multi-region replicas by using a single control plane.

Most of the gateway routing and request handling logic must be implemented in the policy system of API Management. You can combine [built-in policies](/azure/api-management/api-management-policies) specific to Azure OpenAI, such as [Limit Azure OpenAI API token usage](/azure/api-management/azure-openai-token-limit-policy) or [Emit metrics for consumption of Azure OpenAI tokens](/azure/api-management/azure-openai-emit-token-metric-policy), and your own custom policies. The [GenAI gateway toolkit](https://github.com/Azure-Samples/apim-genai-gateway-toolkit) GitHub repository contains multiple custom API Management policies, along with a load-testing setup for testing the behavior of the policies.

Use the [Well-Architected Framework service guide for API Management](/azure/well-architected/service-guides/api-management/reliability) when designing a solution that involves Azure API Management. If your workload exists as part of an application landing zone, review the guidance available in the Cloud Adoption Framework for Azure on implementing an [Azure API Management landing zone](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator).

Using Azure API Management for your gateway implementation is generally the preferred approach to building and operating an Azure OpenAI gateway. It's preferred because the service is a platform as a service (PaaS) offering with rich built-in capabilities, high availability, and networking options. It also has robust APIOps approaches to managing your completion APIs.

### Use custom code

The custom code approach requires a software development team to create a custom coded solution and to deploy that solution to an Azure application platform of their choice. Building a self-managed solution to handle the gateway logic can be a good fit for workload teams proficient at managing network and routing code.

The workload can usually use compute that they're familiar with, such as hosting the gateway code on Azure App Service, Azure Container Apps, or Azure Kubernetes Service.

Custom code deployments can also be fronted with API Management when API Management is used exclusively for its core HTTP API gateway capabilities between your clients and your custom code. This way your custom code interfaces exclusively with your Azure OpenAI HTTP APIs based on the necessary business logic.

The use of non-Microsoft gateway technology, which is a product or service that isn't natively provided by Azure, can be considered as part of this approach.

## Example architecture

:::image type="complex" source="_images/azure-openai-gateway-example-architecture.svg" lightbox="_images/azure-openai-gateway-example-architecture.svg" alt-text="Diagram that shows an example architecture that injects a gateway between an intelligent application and Azure OpenAI.":::
    The diagram shows an intelligent application icon with an arrow that points to two Azure API Management icons, one of which is gateway only. The icons have arrows that point to two Azure OpenAI icons in one region and one in another. One of the Azure API Management icons has an arrow labeled Batch request that points to Azure Event Hubs. The same icon has an arrow that points to an Azure Function with the arrow labeled Compute service. The Azure function has an arrow that points to API Management with a label Replay batched request and an arrow that points to Azure Event Hubs labeled Batched request. A Microsoft Entra ID icon, an Azure Traffic Manager icon, and an Application Insights and Azure Monitor icon are at the bottom of the diagram.
:::image-end:::
*Figure 2: Example architecture of accessing Azure OpenAI through an Azure API Management-based gateway*

## Next steps

Learn about a specific scenario where deploying a gateway between an intelligent application and Azure OpenAI deployments is used to address workload requirements:

- [Load balancing or failover between multiple backend instances](./azure-openai-gateway-multi-backend.yml)
- [Custom authentication and authorization for client applications](./azure-openai-gateway-custom-authentication.yml)
- [Implement logging and monitoring for Azure OpenAI models](./azure-openai-gateway-monitoring.yml)

## Related resources

- [API gateway in Azure API Management](/azure/api-management/api-management-gateways-overview)
- [API Management landing zone](https://github.com/Azure/apim-landing-zone-accelerator/blob/main/scenarios/workload-genai/README.md) GitHub repository covering generative AI scenarios
- [API Management gateway toolkit](https://github.com/Azure-Samples/apim-genai-gateway-toolkit)
- [OpenAI API Simulator](https://github.com/microsoft/aoai-api-simulator/)
