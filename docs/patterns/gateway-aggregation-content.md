Use a gateway to aggregate multiple individual requests into a single request. This pattern is useful when a client must make multiple calls to different backend systems to perform an operation.

## Context and problem

To perform a single task, a client might have to make multiple calls to various backend services. An application that relies on many services to perform a task must expend resources on each request. When any new feature or service is added to the application, additional requests are needed, further increasing resource requirements and network calls. This chattiness between a client and a backend can adversely affect the performance and scale of the application. Microservice architectures have made this problem more common, as applications built around many smaller services naturally have a higher amount of cross-service calls.

In the following diagram, the client sends requests to each service (1,2,3). Each service processes the request and sends the response back to the application (4,5,6). Over a cellular network with typically high latency, using individual requests in this manner is inefficient and could result in broken connectivity or incomplete requests. While each request might be done in parallel, the application must send, wait, and process data for each request, all on separate connections, increasing the chance of failure.

:::image type="complex" source="./_images/gateway-aggregation-problem.png" alt-text="Problem diagram for the Gateway Aggregation pattern." border="false":::
   Diagram that shows a client making separate calls to multiple backend services and receiving individual responses.
:::image-end:::

## Solution

Use a gateway to reduce chattiness between the client and the services. The gateway receives client requests, dispatches requests to the various backend systems, and then aggregates the results and sends them back to the requesting client.

This pattern can reduce the number of requests that the application makes to backend services, and improve application performance over high-latency networks.

In the following diagram, the application sends a request to the gateway (1). The request contains a package of additional requests. The gateway decomposes these and processes each request by sending it to the relevant service (2). Each service returns a response to the gateway (3). The gateway combines the responses from each service and sends the response to the application (4). The application makes a single request and receives only a single response from the gateway.

:::image type="complex" source="./_images/gateway-aggregation.png" alt-text="Solution diagram for the Gateway Aggregation pattern." border="false":::
   Diagram that shows a client sending one request to a gateway, which calls multiple backend services and returns an aggregated response.
:::image-end:::

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- The gateway should not introduce service coupling across the backend services.
- The gateway should be located near the backend services to reduce latency as much as possible.
- The gateway service might introduce a single point of failure. Ensure the gateway is properly designed to meet your application's availability requirements.
- The gateway might introduce a bottleneck. Ensure the gateway has adequate performance to handle load and can be scaled to meet your anticipated growth.
- Perform load testing against the gateway to ensure you don't introduce cascading failures for services.
- Implement a resilient design, using techniques such as [bulkheads](./bulkhead.md), [circuit breaking](./circuit-breaker.md), [retry](./retry.yml), and timeouts.
- If one or more service calls takes too long, it might be acceptable to time out and return a partial set of data. Consider how your application will handle this scenario.
- Use asynchronous I/O to ensure that a delay at the backend doesn't cause performance issues in the application.
- Implement distributed tracing using correlation IDs to track each individual call.
- Monitor request metrics and response sizes.
- Consider returning cached data as a failover strategy to handle failures.
- Instead of building aggregation into the gateway, consider placing an aggregation service behind the gateway. Request aggregation will likely have different resource requirements than other services in the gateway and might affect the gateway's routing and offloading functionality.

## When to use this pattern

Use this pattern when:

- A client needs to communicate with multiple backend services to perform an operation.
- The client might use networks with significant latency, such as cellular networks.

This pattern might not be suitable when:

- You want to reduce the number of calls between a client and a single service across multiple operations. In that scenario, it might be better to add a batch operation to the service.
- The client or application is located near the backend services and latency isn't a significant factor.

## Workload design

An architect should evaluate how the Gateway Aggregation pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | This topology enables you to, among other things, shift transient fault handling from a distributed implementation across clients to a centralized implementation.<br/><br/> - [RE:07 Transient faults](/azure/well-architected/reliability/handle-transient-faults) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | This topology often reduces the number of touch points a client has with a system, which reduces the public surface area and authentication points. The aggregated backends can stay fully network-isolated from clients.<br/><br/> - [SE:04 Segmentation](/azure/well-architected/security/segmentation)<br/> - [SE:08 Hardening](/azure/well-architected/security/harden-resources) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This pattern enables backend logic to evolve independently from clients, allowing you to change the chained service implementations, or even data sources, without needing to change client touchpoints.<br/><br/> - [OE:04 Tools and processes](/azure/well-architected/operational-excellence/tools-processes) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This design can incur less latency than a design in which the client establishes multiple connections. Caching in aggregation implementations minimizes calls to backend systems.<br/><br/> - [PE:03 Selecting services](/azure/well-architected/performance-efficiency/select-services)<br/> - [PE:08 Data performance](/azure/well-architected/performance-efficiency/optimize-data-performance) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

Consider a microservices-based application that provides an order summary experience for a customer. When a user opens an order page, the application must retrieve data from multiple backend services, such as an order service, a shipment service, and a customer profile service.  
In a microservices architecture, these services are implemented and deployed independently. Without aggregation, the client must call each service directly, which increases latency and complexity.  
To address this problem, the application uses [Azure API Management](/azure/api-management/api-management-key-concepts) as the gateway aggregation layer. The client sends a single request to an API Management operation that acts as a collector for order information. API Management then calls the supporting backend APIs and returns a unified response to the client.  
You can implement this lightweight composition by using the API Management [`send-request` policy](/azure/api-management/send-request-policy) to retrieve data from multiple services and construct a combined response, as shown in [Using external services from the Azure API Management service](/azure/api-management/api-management-sample-send-request). In this example, the backend services run in an [Azure Container Apps environment](/azure/container-apps/environment), and each backend service is deployed as a container app that remains hidden from direct client access.  

:::image type="complex" source="./_images/gateway-aggregation-example.png" alt-text="Diagram showing a client request flowing through API Management to order, shipment, and customer profile services in an app environment." border="false":::
   Diagram that shows a client request flowing through API Management to order, shipment, and customer profile services that run in an app environment.
:::image-end:::

The request flow is as follows:

1. The client sends a request to an order summary endpoint exposed through API Management.
1. API Management applies a policy that collects the order, shipment, and customer profile data from the backend services.
1. API Management composes the backend responses into a single order summary payload.
1. API Management returns the aggregated response to the client.

By introducing this aggregation layer, the solution reduces client-to-service round trips and simplifies client interactions. This layer is now responsible for handling unresponsive backend services gracefully and preventing failures from cascading across the aggregated response. Harden your API Management policies with per-request timeouts, conditional error handling, and [circuit breakers](/azure/api-management/backends?tabs=bicep#circuit-breaker).

If one of the backend calls times out or returns an error, API Management can apply the behavior that best fits the operation. For example, it might return a partial response when missing data is acceptable, or it might fail the entire request when complete and consistent order data is required. This decision should be explicit in the policy design so that clients receive predictable behavior.

This approach works well when the gateway performs lightweight composition, shaping, and response assembly. If the aggregation requires custom domain logic, complex transformations, or longer-running orchestration, place that functionality in a dedicated custom service behind the gateway.

For monitoring, collect telemetry across the full request path so you can correlate API Management behavior with backend latency. This visibility is important in a gateway aggregation pattern because a single client operation depends on multiple backend calls, and failures or slow responses in any one dependency can affect the final aggregated result. Use [Azure Monitor](/azure/azure-monitor/overview) as the central observability platform, collect API Management logs and metrics for the gateway and policy execution path, and enable [monitoring for Azure Container Apps](/azure/container-apps/log-monitoring) to capture application logs and metrics from the backend container apps. Route API Management and backend telemetry to a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-overview) for unified querying, alerting, and troubleshooting. With this telemetry, you can detect timeout patterns, identify which backend dependency caused a partial or failed response, and create alerts for elevated latency or error rates.

## Next steps

- [Using external services from the Azure API Management service](/azure/api-management/api-management-sample-send-request)
- [Send-request policy](/azure/api-management/send-request-policy)
- [Azure Container Apps documentation](/azure/container-apps/)

## Related resources

- [Backends for Frontends pattern](./backends-for-frontends.md)
- [Gateway Offloading pattern](./gateway-offloading.yml)
- [Gateway Routing pattern](./gateway-routing.yml)