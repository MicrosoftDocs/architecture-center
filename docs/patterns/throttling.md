---
title: Throttling Pattern
description: Control the resources that an application instance, tenant, or service consumes so that the system continues to meet service-level objectives (SLOs) under load.
ms.author: pnp
author: claytonsiemens77
ms.date: 05/29/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Throttling pattern

Limit the resources that an application instance, an individual tenant, or an entire service can consume. This lets the system function and meets its service-level objectives (SLOs) under sudden or sustained load.

## Context and problem

The load on a cloud application varies over time based on active users and their activity. More users sign in during business hours, and the system runs computationally expensive analytics at the end of each month. Sudden bursts also occur. If processing demand exceeds available capacity, the system slows or fails. When the system has an agreed service level, that failure violates the SLO.

Several strategies handle varying load, depending on the application's business goals. One strategy is [autoscaling](../best-practices/auto-scaling.md), which matches provisioned resources to current demand and controls cost. But provisioning new resources takes time and adds cost. Demand that exceeds capacity growth or budget creates a resource deficit.

## Solution

An alternative to autoscaling is to cap resource use and throttle requests when usage exceeds that cap. The workload monitors its own resource use and throttles requests from one or more users when usage exceeds the threshold. The system continues to function and meet its SLOs.

Throttling is a control loop, not a single admission decision. The system needs low-latency signals at three layers: infrastructure utilization, application state, and per-principal counters. It continuously measures saturation, enforces limits at well-defined boundaries, and adapts those limits as traffic patterns change. Overload is a normal operating mode that a mature system detects and recovers from. Throttling provides [self-preservation](/azure/well-architected/reliability/self-preservation) capabilities in your workload.

The system can implement several throttling or related strategies:

- **Per-principal rate limits:** Reject requests from a user who already exceeded the configured rate over a defined window. This strategy requires the system to attribute each request to a principal and meter resource use against that principal. For multitenant workloads, see [Measure the consumption of each tenant](../guide/multitenant/considerations/measure-consumption.md).

- **Graceful feature degradation:** Turn off or degrade nonessential features so that essential features have enough resources. This strategy trades response completeness for availability. For example, a video-streaming application can drop to a lower resolution.

- **Load leveling:** Smooth activity volume by [using a queue](./queue-based-load-leveling.md). In a multitenant environment, leveling reduces performance for every tenant. When tenants have different service-level agreements (SLAs), process work for high-value tenants immediately and hold lower-priority work until the backlog eases. Implement this approach by using the [Priority Queue pattern](./priority-queue.yml) or by exposing separate endpoints for each priority tier.

- **Priority-based deferral:** Defer operations on behalf of lower-priority applications or tenants. Suspend or limit operations, and return an exception that tells the tenant to retry later.

- **Outbound rate limits:** Limit your own outbound calls when an external dependency fails or returns errors. Lower the in-flight request count to stop flooding logs and to avoid retry costs against an unhealthy dependency. Restore normal request flow after the dependency recovers. For example, [NServiceBus](https://docs.particular.net/nservicebus/recoverability/#automatic-rate-limiting) implements this functionality.

The following chart shows resource use (a combination of memory, CPU, bandwidth, and other factors) over time for an application that uses three features, labeled A, B, and C. A feature is a specific area of functionality, such as a component that performs a specific set of tasks, a piece of code that performs a complex calculation, or an element that provides a service such as an in-memory cache.

:::image type="complex" border="false" source="./_images/throttling-resource-utilization.png" alt-text="Graph that shows resource use against time for applications that run on behalf of three users.":::
A line graph plots resource utilization on the y-axis against time on the x-axis. Three colored lines represent Feature A, Feature B, and Feature C, with Feature A's line lowest, Feature B's line in the middle, and Feature C's line highest. A solid horizontal line near the top of the chart marks maximum capacity, and a dashed horizontal line below it marks the soft limit of resource utilization. Two vertical dashed lines mark times T1 and T2. Before T1, all three feature lines fluctuate, and Feature C's line rises and crosses the soft limit. At T1, Feature B's line drops to zero and stays at zero until T2 because Feature B is suspended to free resources for Feature A and Feature C. Feature C's line falls back below the soft limit between T1 and T2 while Feature A continues normally. At T2, Feature B resumes and all three lines continue to fluctuate below the soft limit.
:::image-end:::

The chart is a stacked area chart. The area below Feature A's line shows the resources that Feature A consumes, the area between Feature A's and Feature B's lines shows the resources that Feature B consumes, and the area between Feature B's and Feature C's lines shows the resources that Feature C consumes. Feature C's line sits at the top of the stack, so it also shows total system resource use over time.

The chart shows graceful feature degradation. Just before time T1, total resource use approaches the threshold and risks exhausting available capacity. Feature B is less critical than Feature A or Feature C, so the system turns off Feature B and releases its resources. Between times T1 and T2, Feature A and Feature C continue normally. By time T2, total resource use drops enough to turn Feature B back on.

You can combine autoscaling, graceful degradation, and throttling to keep applications responsive and within SLAs. When you expect demand to stay high, throttling maintains stability while the system scales out. After scaling completes, the system restores full functionality.

The next chart shows total resource use over time and how throttling combines with autoscaling and other compensating controls.

:::image type="complex" border="false" source="./_images/throttling-autoscaling.png" alt-text="Graph that shows the effects of combining throttling with autoscaling.":::
A line graph plots resource utilization for all applications on the y-axis against time on the x-axis. Two horizontal reference lines mark the soft limit of resource utilization and the maximum capacity before autoscaling. A higher horizontal line, which begins at time T2, marks the maximum capacity after autoscaling. The utilization line rises and fluctuates over time. It crosses the soft limit at time T1, which is the point where autoscaling commences. Between T1 and T2, the system is throttled while autoscaling occurs, and utilization stays below the preautoscaling maximum capacity. At time T2, autoscaling completes, throttling is relaxed, and the utilization line jumps up and continues to fluctuate below the new, higher maximum capacity.
:::image-end:::

At time T1, the system reaches the soft limit and starts to scale out. If new resources don't arrive in time, demand can exhaust the existing resources, and the system can fail. Throttling rejects excess requests during scale-out to keep resource use below the hard limit, then lifts those restrictions after new capacity comes online.

> [!TIP]
> Edge controls and the Throttling pattern address different problems. Edge controls, such as [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) and web application firewall (WAF) rate-limit rules, run at the network boundary and drop volumetric or malicious traffic before it reaches your application. The Throttling pattern runs inside your application and meters *legitimate* traffic against application-defined limits. Use both layers together. DDoS protection doesn't stop a legitimate user from overloading your service, and application throttling doesn't absorb a volumetric attack.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Make throttling decisions early. Throttling is an architectural decision that affects the whole system. Retrofitting it later is expensive.

- Align throttling limits with the component that saturates first.

  Request rate is the most familiar dimension to limit, but the real bottleneck is often concurrent in-flight requests, queue depth, CPU or memory utilization, or a downstream dependency's own limits. A requests-per-second limit doesn't protect a system whose bottleneck is concurrency at a fan-out point.

  At each throttling enforcement boundary, such as the gateway, the service, a partition, or a downstream dependency, identify what saturates first and set the limit on that dimension. For concurrency-bounded protection at fan-out points, see the [Bulkhead pattern](./bulkhead.md), which complements throttling.

- Pick a limiting algorithm intentionally. Match it to the tolerance of the component that you're protecting.

  | Algorithm | Behavior and best fit |
  | :-------- | :-------------------- |
  | Token bucket | Supports bursts up to a configured size and enforces a steady refill rate. Use for gateways that need to absorb short spikes. |
  | Leaky bucket | Emits at a constant rate. Use for back ends that need a steady ingress rate. |
  | Fixed window | Simple to implement, but admits back-to-back bursts at window boundaries. |
  | Sliding window | Smooths the window-boundary problem of fixed windows at the cost of more state. |

- Decide who the limit affects. Throttling at a coarse boundary, such as a regional gateway, can affect many unrelated users when only a few of them drive the load.

- Decide where the counter resides when one limit spans multiple nodes. Local counters are fast but undercount when the same caller reaches multiple replicas. A centralized counter in a shared store like Redis sees every request but adds latency to each decision. To approximate a global rate, divide the limit across replicas and reconcile periodically.

- Make throttling decisions quickly. The system must detect rising load, react, and return to normal after load eases. This process requires continuous performance instrumentation.

- Shed load proactively, not at the edge of collapse. A throttle that only rejects after a component saturates causes latency to spike before callers see any back-pressure.

  As utilization approaches the hard limit, start rejecting a growing fraction of requests. Early rejection signals callers to back off and prevents the latency collapse that abrupt limits often trigger. Use p99 latency against your SLO as the primary trigger. Average utilization can look healthy while p99 has already breached.

  Where you can distinguish request value, shed lower-value or more retryable work first. For more information, see the [Priority Queue pattern](./priority-queue.yml).

- Return a status code that tells the client when a temporary rejection is the result of throttling:

  - **HTTP 429 (Too Many Requests):** The caller exceeds a configured request rate over a defined window.
  - **HTTP 503 (Service Unavailable):** The service can't handle the request right now, often because of an unexpected load spike.

  Include a `Retry-After` HTTP header so that the client can pick a retry strategy. Return enough context for the caller to retry deliberately instead of guessing. For example, name the limit that the caller exceeds, clarify the affected scope, or suggest a rate that would succeed. Unexplained rejections don't help callers adapt.

- Propagate overload signals from your dependencies instead of absorbing them. A service that throttles its callers must also honor the throttling responses that it receives from its own downstream dependencies. If your service hides a downstream 429 or 503 response by retrying silently or by returning a generic HTTP 500 (Internal Server Error) response, callers can't slow down, retries amplify, and the overload cascades back upstream. The [Retry Storm antipattern](../antipatterns/retry-storm/index.md) describes this failure mode. Surface back-pressure to upstream callers so that the entire call chain sheds load together.

- Make rejection cheaper than the work that it prevents. If refusing a request requires heavy authentication, deep parsing, or complex policy evaluation, a flood of rejected requests can still saturate the system. Reject as early in the request pipeline as possible, and load test the rejection path itself.

- Plan for cases where throttling can't buy enough time for autoscale. If demand grows faster than new capacity comes online, even a throttled system can fail. When that outcome is unacceptable, keep larger capacity reserves and configure more aggressive autoscaling.

- Don't use caching as a substitute for throttling. A cache lowers average load on the origin but doesn't bound peak load. Every cache miss passes through to the origin, and when a popular key expires under heavy traffic, many callers can race to refill it. Use caching to reduce normal pressure and throttling to bound the worst case. For more information, see the [Cache-Aside pattern](./cache-aside.yml).

- Normalize resource costs for different operations because they generally don't carry equal execution costs. For example, throttling limits might be higher for read operations and lower for write operations. Ignoring per-operation cost can exhaust capacity and create an attack vector.

- Make throttling configuration changeable at runtime. When abnormal load arrives, you need to adjust limits without a deployment. Deployments are slow and risky during an incident. The [External Configuration Store pattern](./external-configuration-store.md) externalizes the configuration so that you can change it at runtime.

- Consider adaptive limits instead of static limits. Some throttling SDKs react to latency or queue-depth signals so that the limit tracks actual component conditions. Always pair an adaptive limiter with a set maximum.

- Revisit your limits as the workload evolves. Adaptive limiters can't track every kind of drift, such as SLO changes, changes in dependency capacity, or shifts in per-operation cost. Schedule periodic operator review against those inputs.

## When to use this pattern

Use this pattern:

- To keep a system within its SLOs.

- To prevent a single tenant from monopolizing application resources.

- To handle bursts in activity.

- To limit the maximum resource level that a system needs.

- To reduce low-value compute during periods of high grid carbon intensity.

## Workload design

Evaluate how to use the Throttling pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | You design the limits to help prevent resource exhaustion that might lead to malfunctions. You can also use this pattern as a control mechanism in a graceful degradation plan.<br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | You can design the limits to help prevent resource exhaustion that could result from automated abuse of the system.<br/><br/> - [SE:06 Network controls](/azure/well-architected/security/networking)<br/> - [SE:08 Hardening resources](/azure/well-architected/security/harden-resources) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) focuses on **sustaining and improving** your workload's **return on investment**. | The enforced limits can inform cost modeling and can be directly tied to the business model of your application. They also put clear upper bounds on utilization, which can be factored into resource sizing.<br/><br/> - [CO:02 Cost model](/azure/well-architected/cost-optimization/cost-model)<br/> - [CO:12 Scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | When the system is under high demand, this pattern helps mitigate congestion that can lead to performance bottlenecks. You can also use it to proactively avoid noisy neighbor scenarios.<br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following diagram shows throttling in a multitenant system.

:::image type="complex" border="false" source="./_images/throttling-multi-tenant.png" alt-text="Diagram that shows throttling in a multitenant application.":::
Three labeled users on the left represent tenants of a multitenant Surveys application: Adatum, Fabrikam, and Contoso. Each user sends requests through a tenant-specific custom domain, which the application uses to identify the tenant. Adatum sends 5 requests per second through surveys.adatum.com, Fabrikam sends 10 requests per second through surveys.fabrikam.com, and Contoso sends 150 requests per second through surveys.contoso.com. On the right, the surveys application web role meters the per-second request rate for each tenant. The Adatum and Fabrikam request flows pass through to the application. The Contoso request flow is blocked by an Error: Throttled response because the rate exceeds the per-tenant limit.
:::image-end:::

Users from several tenant organizations access a cloud-hosted application to fill out and submit surveys. The application contains instrumentation that monitors the rate at which each tenant's users submit requests.

To prevent users from one tenant degrading responsiveness and availability for users in other tenants, the application limits the requests-per-second rate that any single tenant can submit. The application blocks requests that exceed this limit.

## Next step

- [Architecture strategies for designing a monitoring system](/azure/well-architected/operational-excellence/observability)

## Related resources

- [Measure the consumption of each tenant](../guide/multitenant/considerations/measure-consumption.md)
- [Autoscaling in Azure](../best-practices/auto-scaling.md)
- [Queue-Based Load Leveling pattern](./queue-based-load-leveling.md)
- [Priority Queue pattern](./priority-queue.yml)
- [External Configuration Store pattern](./external-configuration-store.md)
