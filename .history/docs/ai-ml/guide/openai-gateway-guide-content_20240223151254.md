The Azure OpenAI service is a powerful cloud-based platform that allows your applications to take advantage of OpenAI's powerful large language models (LLMs). While these LLMs enable you to build intelligent applications, building and deploying well-architected AI applications isn't a simple task. The design choices in your architecture should align with the principles outlined in the five [Well Architected Framework (WAF) pillars](/azure/well-architected/).

This guide helps you understand some of the key challenges across the five pillars that you encounter if your architecture includes direct access from your consumers to the OpenAI service. The guide then teaches you how introducing a gateway in your architecture can address these direct access challenges, while introducing new challenges you need to further address.

## How to use this guide

This guide includes N articles: this introduction article and X articles that are deep dives into specific scenarios that a gateway addresses. This introduction article discusses the architectural challenges of direct access, the gateway solution, and the architectural considerations of using a gateway at a high-level. This article doesn't cover how the gateway is implemented, rather it covers the architectural pattern. The subsequent articles outline specific scenarios, such as scalability or cost management, propose an architecture and discuss how that architecture addresses the scenario.

## Key challenges

In this section, you learn about the key architectural challenges you face if your architecture includes direct access to Azure OpenAI from consumers. The challenges are organized by the WAF pillars.

### Reliability

- **Redundancy** - Deploy instances of OpenAI across regions and fail over when an instance becomes unhealthy.
- **Scale out to handle spikes** - Ensure you're able to increase capacity to handle unexpected loads on the system.
- **Load Balancing/Throttling** - The Azure OpenAI service throttles your requests by returning a 429 response code to requests that exceed the Token-Per-Minute (TPM) or Requests-Per Minute (RPM) in the pay-as-you-go model or requests that exceed the provisioned throughput units (PTU) capacity for the provisioned throughput model.

### Security

- **Identity management** - Implement a centralized identity model for all language model usage, including non-Azure OpenAI models with different identity management solutions.Support alternative identity providers other than the Azure OpenAI default authentication.
- **Network Security** - Ensure network traffic is not exposed to the public internet when not necessary.
- **Data Security** - Ensure overseeing access to the application and data is securely transfered with tools to cover common security challenges and tactics/techniques in the MITRE framework that threat actors use to leverage their exploits. 
- **Data sovereignty** - Data sovereignty in the context of Azure OpenAI refers to the legal and regulatory requirements related to the storage and processing of data within the geographic boundaries of a specific country or region. Ensure regional affinity for consumers to comply with data residency and sovereignty laws.


### Cost Optimization

- **Cost tracking** -Track your OpenAI usage costs across your different departments, customers, or applications?
- **Provisioned throughput utilization** - Ensure you're fully utilizing the provisioned throughput you paid for and orchestrate utilization in the manner consume.

### Operational Excellence

- **Quota control** - Centralized control over the usage of LLM models.
- **Monitoring and Observability** - Azure OpenAI services default metrics is available via Azure Monitor however there is latency with the availability of the data and does not provide real-time monitoring. Monitor usage in real-time. This information can be useful to understand when a subsequent call likely results in being throttled.
- **Hybrid integration** - Ensure efficient and secure access with other hybrid services. 

### Performance Efficiency

- **Performance optimization** - How can you queue and batch low priority requests to run when model utilization is low. Ensure parameters such as max_tokens and best_of are set to approved values. Ensure critical workloads have prioritized access to Azure OpenAI deployed models. 
- **Minimize latency** - Route requests to the closest model. Deploy OpenAI instances in multiple regions to reduce latency.

## Solution

:::image type="complex" source="_images/openai-gateway-conceptual-architecture.svg" lightbox="_images/openai-gateway-conceptual-architecture.svg" alt-text="Diagram that shows a conceptual architecture of injecting a gateway between an intelligent application and Azure OpenAI.":::
    The diagram shows an intelligent application icon with an arrow pointing into a dashed line box labeled gateway. The arrow goes through a line that is labeled 'Federated Authentication', pointing to a 'rate limiter' icon. The 'rate limiter' has an arrow that points to a 'router' icon. The 'router' has four arrows pointing to different icons. The first arrow points to a 'load balancer', which points to 'OpenAI deployment' or 'LLM' icons in two regions and on-premises. The second arrow points to a 'monitoring' icon that later points to a 'cost' and a 'usage' icon. The third arrow points to a 'compute' icon. The fourth points to a 'message queue' icon, which then points to the 'Load balancer'.
:::image-end:::
*Figure 1: Conceptual architecture of accessing Azure OpenAI through a gateway*

To address the key challenges listed in the [key challenges section](#key-challenges), you can inject a gateway to decouple the intelligent application from the Azure OpenAI service and other LLMs. The gateway gives you the ability to augment the OpenAI service by providing services such as the following:

- [Federated authentication](/azure/architecture/patterns/federated-identity)
- [Rate limiting](/azure/architecture/patterns/rate-limiting-pattern)
- Cross-cutting monitoring
- [Gateway offloading](/azure/architecture/patterns/gateway-offloading) by offloading shared services to the gateway
- [Gateway aggregation](/azure/architecture/patterns/gateway-aggregation) by [Routing](/azure/architecture/patterns/gateway-routing) to multiple services such as routing low priority messages to a queue for [queue-based load leveling](/azure/architecture/patterns/queue-based-load-leveling) or to compute to perform tasks.
- Load balancing that uses [health endpoint monitoring](/azure/architecture/patterns/health-endpoint-monitoring) to route only to health endpoints.

## Considerations

When you introduce a gateway into your architecture to address the considerations outlined in the [key challenges](#key-challenges) section, the gateway itself introduces new considerations to your architecture.

### Reliability

- The gateway service can introduce a single point of failure. Ensure you design it to meet your availability requirements. Consider resiliency and fault tolerance capabilities in the implementation.
- The gateway service might require global routing capabilities if your architecture requires OpenAI instances in multiple regions.
- The gateway service should implement health probes to provide failover capabilities for OpenAI instances that aren't responding.

### Security

- Network Isolation with Private network access
- **Data Security** - Ensure overseeing access to the application and data is securely transfered with tools to cover common security challenges and tactics/techniques in the MITRE framework that threat actors use to leverage their exploits. 
- **Multitenancy** - 
- **Federated identity** - Support alternate identity providers other than the Azure OpenAI default authentication.
- **Data sovereignty** -Ensure that hybrid system also adheres to multi-region availability requirements to support affinity.

### Cost Optimization

Higher cost and resource consumption - The gateway service adds to the cost of the architecture. When calculating the cost, take into account redundancy and multi-region capabilities required for the gateway.

### Operational Excellence

- The gateway allows routing request based on there priority which requires monitoring the PTU utilization. Monitoring can be done in a couple of ways. Consider one method comes with a delay where the other approach is near real-time.
- Adding a gateway service to your architecture adds complexity to the architecture. The gateway service deployment should be included in your Infrastructure as Code (IaC) strategy. The gateway should be included in your monitoring strategy.


### Performance Efficiency

- The gateway service can introduce a bottleneck. Ensure the gateway has adequate performance to handle load and can easily scale in line with your growth expectations.
- The gateway service can introduce latency. The gateway should be located near the backend services to reduce latency as much as possible. Consider the cost, in terms of added latency, of services implemented at the gateway and ensure the benefit outweighs the added latency.

## When/when not to introduce a gateway

You're not required to use a gateway if you want to implement services such as rate limiting or routing. That logic could be implemented in the intelligent application. Consider implementing a gateway for the following reasons:

- You don't have control over the client (intelligent application)
- You have many clients and don't want to duplicate logic
- You want the client to be thin and focused on the business problem

## Example architecture

:::image type="complex" source="_images/openai-gateway-example-architecture.svg" lightbox="_images/openai-gateway-example-architecture.svg" alt-text="Diagram that shows an example architecture of injecting a gateway between an intelligent application and Azure OpenAI.":::
    The diagram shows an intelligent application icon with an arrow pointing to two Azure API Management (APIM) icons, one of which is gateway only. The APIM icons have arrows pointing to two Azure OpenAI icons in one region and one in another. One of the APIM icons has an arrow pointed to Azure Event Hubs with the arrow labeled 'batch request'. The same APIM icon has an arrow pointing to an Azure Function with the arrow labeled 'Compute service'. The Azure function has an arrow pointed to APIM with a label 'Replay batched request' and an arrow pointing to Azure Event Hubs labeled 'Batched request'. At the bottom of the diagram are an Microsoft Entra ID icon, an Azure Traffic Manager icon, Application Insights and an Azure Monitor icon.
:::image-end:::
*Figure 2: Example architecture of accessing Azure OpenAI through a gateway*

## List of scenarios

The following table lists specific scenarios that injecting a gateway between an intelligent application and Azure OpenAI deployments can address:

| Scenario | Description |
| --- | --- |
| **Custom Authentication** | Provide authentication to generative AI services through an API gateway |
