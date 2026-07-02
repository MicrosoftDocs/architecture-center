---
title: Gateway Aggregation Pattern
description: Learn about the Gateway Aggregation pattern, which uses a gateway to aggregate many individual requests into a single request.
ms.author: pnp
author: claytonsiemens77
ms.date: 06/02/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Gateway Aggregation pattern

Use a gateway to aggregate multiple individual requests into a single request. This pattern is useful when a client must make multiple calls to different back-end systems to perform an operation.

## Context and problem

To perform a single task, a client might have to make multiple calls to various back-end services. An application that relies on many services to perform a task must expend resources on each request. When new features or services are added to the application, extra requests are needed, which further increases resource requirements and network calls. This chattiness between a client and a back end can adversely affect the performance and scale of the application. Microservices architectures have made this problem more common because applications built around many smaller services have a higher number of cross-service calls.

In the following diagram, the client sends requests to each service (numbered 1, 2, and 3). Each service processes the request and returns a response to the application (numbered 4, 5, and 6). Sending individual requests in this way over a cellular network that has high latency is inefficient and can cause connectivity loss or incomplete responses. Each request might run in parallel. However, the application still must send, wait for, and process data for each request on separate connections, which increases the chance of failure.

:::image type="complex" border="false" source="./_images/gateway-aggregation-problem.png" alt-text="A problem diagram for the Gateway Aggregation pattern." lightbox="./_images/gateway-aggregation-problem.png":::
   Diagram that shows a client making separate calls to multiple back-end services and receiving individual responses. Arrows connect the application to services 1, 2, and 3 in both directions.
:::image-end:::

## Solution

Use a gateway to reduce chattiness between the client and the services. The gateway receives client requests, dispatches requests to the various back-end systems, and aggregates the results before it sends them back to the client.

This pattern can reduce the number of requests that the application makes to back-end services and improve application performance over high-latency networks.

In the following diagram, the application sends a request to the gateway (1). The request contains a package of extra requests. The gateway decomposes these requests and processes each request by sending it to the relevant service (2). Each service returns a response to the gateway (3). The gateway combines the responses from each service and sends the response to the application (4). The application makes a single request and receives only a single response from the gateway.

:::image type="complex" border="false" source="./_images/gateway-aggregation.png" alt-text="A solution diagram for the Gateway Aggregation pattern." lightbox="./_images/gateway-aggregation.png":::
   The diagram shows an application sending one request to a gateway, which calls multiple back‑end services and returns an aggregated response. Three arrows point from the gateway to services 1, 2, and 3. Three arrows point from the services back to the gateway. One arrow points from the application to the gateway, and another arrow points from the gateway to the application.
:::image-end:::

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- The gateway shouldn't introduce service coupling across the back-end services.

- The gateway should be located near the back-end services to reduce latency as much as possible.

- The gateway service might introduce a single point of failure (SPoF). Ensure that the gateway is properly designed to meet your application's availability requirements.

- The gateway might introduce a bottleneck. Ensure that the gateway has adequate performance to handle the current load and can be scaled to meet your anticipated growth.

- Perform load testing against the gateway to ensure that you don't introduce cascading failures for services.

- Implement a resilient design by using techniques such as [bulkheads](./bulkhead.md), [circuit breaking](./circuit-breaker.md), [retry](./retry.yml), and timeouts.

- If one or more service calls take too long, it might be acceptable to time out and return a partial set of data. Consider how your application will handle this scenario.

- Use asynchronous input and output (I/O) to ensure that a delay at the back end doesn't cause performance problems in the application.

- Implement distributed tracing by using correlation IDs to track each individual call.

- Monitor request metrics and response sizes.

- Consider returning cached data as a failover strategy to handle failures.

- Rather than build aggregation into the gateway, consider placing an aggregation service behind the gateway. Request aggregation is likely to have different resource requirements than other services in the gateway and might affect the gateway's routing and offloading functionality.

## When to use this pattern

Use this pattern when:

- A client needs to communicate with multiple back-end services to perform an operation.

- The client might use networks that have significant latency, such as cellular networks.

This pattern might not be suitable when:

- You want to reduce the number of calls between a client and a single service across multiple operations. In that scenario, adding a batch operation to the service might be more suitable.

- The client or application is located near the back-end services and latency isn't a significant factor.

## Workload design

Evaluate how to use the Gateway Aggregation pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | With this topology, you can shift transient fault handling from a distributed implementation across clients to a centralized implementation.<br><br> - [Recommendations for handling transient faults](/azure/well-architected/design-guides/handle-transient-faults)|
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | This topology often reduces the number of touchpoints that a client has with a system, which reduces the public surface area and authentication points. The aggregated back ends can remain fully network-isolated from clients.<br><br> - [SE:04 Segmentation](/azure/well-architected/security/segmentation)<br> - [SE:08 Harden resources](/azure/well-architected/security/harden-resources) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This pattern enables back-end logic to evolve independently from clients. This decoupling gives you the flexibility to change the chained service implementations, or even data sources, without needing to change client touchpoints.<br><br> - [OE:04 Tools and processes](/azure/well-architected/operational-excellence/tools-processes) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This design can incur less latency than a design in which the client establishes multiple connections. Caching in aggregation implementations minimizes calls to back-end systems.<br><br> - [PE:03 Select services](/azure/well-architected/performance-efficiency/select-services)<br> - [PE:08 Data performance](/azure/well-architected/performance-efficiency/optimize-data-performance) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

Consider a microservices-based application that provides an order summary experience for a customer. When a user opens an order page, the application must retrieve data from multiple back-end services, such as an order service, a shipment service, and a customer profile service.

In a microservices architecture, these services are implemented and deployed independently. Without aggregation, the client must call each service directly, which increases latency and complexity.

To address this problem, the application uses [Azure API Management](/azure/api-management/api-management-key-concepts) as the gateway aggregation layer. The client sends a single request to an API Management operation that acts as a collector for order information. API Management then calls the supporting back-end APIs and returns a unified response to the client.

You can implement this lightweight composition by using the API Management [send-request policy](/azure/api-management/send-request-policy) to [retrieve data from multiple services and construct a combined response](/azure/api-management/api-management-sample-send-request). In this example, the back-end services run in an [Azure Container Apps environment](/azure/container-apps/environment), and you deploy each back-end service as a container app that remains hidden from direct client access.  

:::image type="complex" border="false" source="./_images/gateway-aggregation-example.svg" alt-text="Diagram that shows a client request flowing through API Management to the order, shipment, and customer profile services in an app environment." lightbox="./_images/gateway-aggregation-example.svg":::
   In the diagram, an arrow points from the customer to API Management. Another arrow points from API Management and splits into three arrows that point to order, shipment, and customer profile. An app environment is shown below and to the right of the customer profile. An arrow points from the payload summary to API Management.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/gateway-aggregation-example.vsdx) of this architecture.*

The request flow follows these steps:

1. The client sends a request to an order summary endpoint exposed through API Management.

1. API Management applies a policy that collects the order, shipment, and customer profile data from the back-end services.

1. API Management composes the back-end responses into a single order summary payload.

1. API Management returns the aggregated response to the client.

By introducing this aggregation layer, the solution reduces client-to-service round trips and simplifies client interactions. This layer becomes responsible for handling unresponsive back-end services gracefully and preventing failures from cascading across the aggregated response. Harden your API Management policies by using per-request timeouts, conditional error handling, and [circuit breakers](/azure/api-management/backends?tabs=bicep#circuit-breaker).

If one of the back-end calls times out or returns an error, API Management can apply the behavior that best fits the operation. For example, it might return a partial response when missing data is acceptable, or it might fail the entire request when complete and consistent order data is required. Make this decision explicit in the policy design so that clients experience predictable behavior.

This approach works well when the gateway performs lightweight composition, shaping, and response assembly. If the aggregation requires custom domain logic, complex transformations, or longer-running orchestration, place that functionality in a dedicated custom service behind the gateway.

For monitoring, collect telemetry across the full request path so that you can correlate API Management behavior with back-end latency. This visibility is important in a gateway aggregation pattern because a single client operation depends on multiple back-end calls, and failures or slow responses in any one dependency can affect the final aggregated result. Use [Azure Monitor](/azure/azure-monitor/fundamentals/overview) as the central observability platform. Collect API Management logs and metrics for the gateway and policy execution path, and enable [monitoring for Container Apps](/azure/container-apps/log-monitoring) to capture application logs and metrics from the back-end container apps. Route API Management and back-end telemetry to a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-overview) for unified querying, alerting, and troubleshooting. With this telemetry, you can detect timeout patterns, identify which back-end dependency caused a partial or failed response, and create alerts for elevated latency or error rates.

## Next steps

- [Use external services from the API Management service](/azure/api-management/api-management-sample-send-request)
- [Send-request policy](/azure/api-management/send-request-policy)
- [Container Apps documentation](/azure/container-apps/)

## Related resources

- [Backends for Frontends pattern](./backends-for-frontends.md)
- [Gateway Offloading pattern](./gateway-offloading.yml)
- [Gateway Routing pattern](./gateway-routing.yml)
