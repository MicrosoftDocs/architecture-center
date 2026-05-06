---
title: Bulkhead Pattern
description: Learn about the Bulkhead pattern, which isolates elements of an application into pools so that if one fails, the others continue to function.
author: claytonsiemens77
ms.author: pnp
ms.date: 03/19/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Bulkhead pattern

The Bulkhead pattern is a type of application design that's tolerant of failure. In a bulkhead architecture, also known as a *cell-based architecture*, elements of an application are isolated into pools so that if one fails, the other elements continue to function. The Bulkhead pattern is named after the sectioned partitions (bulkheads) of a ship's hull. If the hull of a ship is compromised, only the damaged section fills with water, which prevents the ship from sinking.

## Context and problem

A cloud-based application might include multiple services, and each service has one or more consumers. Excessive load or failure in a service affects all consumers of the service.

Also, a consumer might send requests to multiple services simultaneously and use resources for each request. When the consumer sends a request to a misconfigured or unresponsive service, the resources that the client's request uses might remain unavailable for an extended period. As requests to the service continue, those resources might be exhausted. For example, the client's connection pool might be exhausted. At that point, the consumer's requests to other services are affected. Eventually, the consumer can't send requests to any other services, not only the original unresponsive service.

Resource exhaustion affects services that have multiple consumers. Many requests from one client might exhaust available resources in the service. Resource exhaustion can mean that other consumers can't consume the service, which causes a cascading failure effect.

## Solution

Partition service instances into different groups based on consumer load and availability requirements. This design helps isolate failures. You can sustain service functionality for some consumers, even during a failure.

A consumer can also partition resources to ensure that resources used to call one service don't affect the resources used to call another service. For example, a consumer that calls multiple services might be assigned a connection pool for each service. If a service begins to fail, it only affects the connection pool assigned for that service. The consumer can continue to use other services.

This pattern provides the following benefits:

- Isolates consumers and services from cascading failures. A problem that affects a consumer or service can be isolated within its own bulkhead to prevent the entire solution from failing.

- Preserves some functionality if a service failure occurs. Other services and features of the application continue to work.

- Provides different quality of service levels for consuming applications. You can configure a high-priority consumer pool to use high-priority services.

The following diagram shows bulkheads structured around connection pools that call individual services. If Service A fails or causes a problem, the connection pool is isolated, so only workloads that use the thread pool assigned to Service A are affected. Workloads that use Service B and C aren't affected and can continue working without interruption.

:::image type="complex" source="./_images/bulkhead-connection-pool.png" alt-text="Diagram that shows bulkheads structured around connection pools that call individual services." border="false":::
   Diagram that shows two workloads, Workload 1 and Workload 2, and three services, Service A, Service B, and Service C. Workload 1 uses a connection pool that's assigned to Service A. Workload 2 uses two connection pools. One connection pool is assigned to Service B, and the other is assigned to Service C. The connection pool that Workload 1 uses is isolated. The connection pools that Workload 2 uses can continue to call Service B and Service C.
:::image-end:::

The following diagram shows multiple clients that call a single service. Each client is assigned to a separate service instance. Client 1 makes too many requests and overwhelms its instance. Because each service instance is isolated from the others, the other clients can continue to make calls.

:::image type="complex" source="./_images/bulkhead-single-service.png" alt-text="Diagram that shows multiple clients calling a single service." border="false":::
   Diagram that shows three clients, Client 1, Client 2, and Client 3, and three service instances that each form a part of Service A. Each client connects to its own service instance. The service instances are isolated. If Client 1 overwhelms its instance, Clients 2 and 3 are unaffected.
:::image-end:::

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Define partitions around the business and technical requirements of the application.

- If you use [tactical domain-driven design to design microservices](../microservices/model/tactical-domain-driven-design.md), partition boundaries should align with the bounded contexts.

- When you partition services or consumers into bulkheads, consider the level of isolation offered by the technology and the overhead in terms of cost, performance, and manageability.

- To provide more sophisticated fault handling, consider combining bulkheads with retry, circuit breaker, and throttling patterns.

- When you partition consumers into bulkheads, consider using processes, thread pools, and semaphores. Projects like [resilience4j](https://resilience4j.readme.io/docs/getting-started) and [Polly](https://www.pollydocs.org/) offer a framework for creating consumer bulkheads.

- When you partition services into bulkheads, consider deploying them into separate virtual machines, containers, or processes. Containers offer a good balance of resource isolation with fairly low overhead.

- Services that communicate by using asynchronous messages can be isolated through different sets of queues. Each queue can have a dedicated set of instances that process messages on the queue or a single group of instances that use an algorithm to dequeue and dispatch processing.

- Determine the level of granularity for the bulkheads. For example, if you want to distribute tenants across partitions, you can place each tenant into a separate partition or put several tenants into one partition.

- Monitor each partition's performance and service-level agreement (SLA).

- Use built-in platform controls, such as Azure API Management rate limits, Azure Cosmos DB request unit (RU) isolation, and resource limits in Azure Kubernetes Service (AKS) or Azure Container Apps. Don't re-create these throttling and isolation mechanisms in your application code.

- AI and inference workloads often require strict bulkheads because of deployment-level quotas and concurrency limits, for example, isolating Azure OpenAI deployments per workload or per tenant.

## When to use this pattern

Use this pattern when:

- You want to isolate resources for specific dependencies so that a disruption in one service doesn't affect the entire application.
- You want to isolate critical consumers from standard consumers.
- You need to protect the application from cascading failures.

This pattern might not be suitable when:

- Less efficient use of resources might not be acceptable in the project.
- The added complexity isn't necessary.

## Workload design

Evaluate how to use the Bulkhead pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | The failure isolation strategy introduced through the intentional and complete segmentation between components attempts to contain faults to the bulkhead that experiences the problem, which prevents impact on other bulkheads.<br/><br/> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows)<br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | The segmentation between components helps constrain security incidents to the compromised bulkhead.<br/><br/> - [SE:04 Segmentation](/azure/well-architected/security/segmentation) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | Each bulkhead can be individually scalable to efficiently meet the needs of the task that's encapsulated in the bulkhead.<br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following Kubernetes configuration file creates an isolated container to run a single service, with its own CPU and memory resources and limits.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: drone-management
spec:
  containers:
  - name: drone-management-container
    image: drone-service
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "1"
```

## Next steps

- Use [API Management rate-limit policies](/azure/api-management/api-management-policies#rate-limiting-and-quotas) to control request throughput per client.
- Use [Azure Functions concurrency controls](/azure/azure-functions/functions-concurrency) to limit parallel executions.
- Set [Container Apps resource limits](/azure/container-apps/containers) to control CPU and memory per workload.
- Assign [Azure Cosmos DB RU throughput](/azure/cosmos-db/set-throughput) per container for predictable isolation.

## Related resources

- [Circuit Breaker pattern](./circuit-breaker.md)
- [Retry pattern](./retry.yml)
- [Throttling pattern](./throttling.yml)