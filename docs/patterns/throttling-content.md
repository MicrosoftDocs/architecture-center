Control the consumption of resources used by an instance of an application, an individual tenant, or an entire service. This can allow the system to continue to function and meet service-level objectives (SLOs), even when an increase in demand places an extreme load on resources.

## Context and problem

The load on a cloud application typically varies over time based on the number of active users or the types of activities they're performing. For example, more users are likely to be active during business hours, or the system might be required to perform computationally expensive analytics at the end of each month. There might also be sudden and unanticipated bursts in activity. If the processing requirements of the system exceed the capacity of the resources that are available, it'll experience poor performance and can even fail. If the system has to meet an agreed level of service, such failure could be unacceptable.

There are many strategies available for handling varying load in the cloud, depending on the business goals for the application. One strategy is to use [autoscaling](../best-practices/auto-scaling.md) to match the provisioned resources to the user needs at any given time. This has the potential to consistently meet user demand, while optimizing running costs. However, while autoscaling can trigger the provisioning of more resources, this provisioning isn't immediate. If demand grows quickly, there can be a window of time where there's a resource deficit.

## Solution

An alternative strategy to autoscaling is to allow applications to use resources only up to a limit, and then throttle them when this limit is reached. The system should monitor how it's using resources so that, when usage exceeds the threshold, it can throttle requests from one or more users. This enables the system to continue functioning and meet any service-level objectives (SLOs) that are in place.

Throttling is a control loop, not a single admission decision. The system needs low-latency signals at three layers: infrastructure utilization, application state, and per-principal counters. It continuously measures saturation, enforces limits at well-defined boundaries, and adapts those limits as traffic patterns change. Overload is a normal operating mode that a mature system detects and recovers from. Throttling provides [self-preservation](/azure/well-architected/reliability/self-preservation) capabilities in your workload.

The system could implement several throttling strategies, including:

- Rejecting requests from an individual user who's already accessed system APIs more than n times per second over a given period of time. This requires the system to attribute each request to a principal and meter resource use against that principal. For multitenant workloads, see [Measure the consumption of each tenant](../guide/multitenant/considerations/measure-consumption.md).

- Disabling or degrading the functionality of selected nonessential services so that essential services can run unimpeded with sufficient resources. This approach trades response completeness for availability. For example, if the application is streaming video output, it could switch to a lower resolution.

- Using load leveling to smooth the volume of activity (this approach is covered in more detail by the [Queue-based Load Leveling pattern](./queue-based-load-leveling.yml)). In a multitenant environment, this approach will reduce the performance for every tenant. If the system must support a mix of tenants with different SLAs, the work for high-value tenants might be performed immediately. Requests for other tenants can be held back, and handled when the backlog has eased. The [Priority Queue pattern](./priority-queue.yml) could be used to help implement this approach, as could exposing different endpoints for the different service levels/priorities.

- Deferring operations being performed on behalf of lower priority applications or tenants. These operations can be suspended or limited, with an exception generated to inform the tenant that the system is busy and that the operation should be retried later.

- You should be careful when integrating with some external services that might become unavailable or return errors. Reduce the number of concurrent requests being processed so that the logs do not unnecessarily fill up with errors. You also avoid the costs that are associated with needlessly retrying the processing of requests that would fail because of that external service. Then, when requests are processed successfully, go back to regular unthrottled request processing. One library that implements this functionality is [NServiceBus](https://docs.particular.net/nservicebus/recoverability/#automatic-rate-limiting).

The figure shows an area graph for resource use (a combination of memory, CPU, bandwidth, and other factors) against time for applications that are making use of three features. A feature is an area of functionality, such as a component that performs a specific set of tasks, a piece of code that performs a complex calculation, or an element that provides a service such as an in-memory cache. These features are labeled A, B, and C.

![Figure 1 - Graph showing resource use against time for applications running on behalf of three users.](./_images/throttling-resource-utilization.png)

> The area immediately below the line for a feature indicates the resources that are used by applications when they invoke this feature. For example, the area below the line for Feature A shows the resources used by applications that are making use of Feature A, and the area between the lines for Feature A and Feature B indicates the resources used by applications invoking Feature B. Aggregating the areas for each feature shows the total resource use of the system.

The previous figure shows the effects of deferring operations. Just before time T1, the total resources allocated to all applications that use these features reach a threshold. That threshold represents the limit of resource use. At this point, the applications are in danger of exhausting the resources available. In this system, Feature B is less critical than Feature A or Feature C, so it's temporarily disabled and the resources that it was using are released. Between times T1 and T2, the applications using Feature A and Feature C continue running as normal. Eventually, the resource use of these two features diminishes to the point when, at time T2, there is sufficient capacity to enable Feature B again.

The autoscaling and throttling approaches can also be combined to help keep the applications responsive and within SLAs. If the demand is expected to remain high, throttling provides a temporary solution while the system scales out. At this point, the full functionality of the system can be restored.

The next figure shows an area graph of the overall resource use by all applications running in a system against time, and illustrates how throttling can be combined with autoscaling.

![Figure 2 - Graph showing the effects of combining throttling with autoscaling](./_images/throttling-autoscaling.png)

At time T1, the threshold specifying the soft limit of resource use is reached. At this point, the system can start to scale out. However, if the new resources don't become available quickly enough, then the existing resources might be exhausted and the system could fail. To prevent this from occurring, the system is temporarily throttled, as described earlier. When autoscaling has completed and the extra resources are available, throttling can be relaxed.

> [!TIP]
> Edge controls such as [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) and web application firewall (WAF) rate-limit rules sit above this pattern. They drop volumetric or abusive traffic at the network boundary before requests reach your application. The Throttling pattern meters *legitimate* traffic against application-defined limits, and doesn't replace those edge controls. Use both layers together, DDoS protection won't stop a user from running a runaway job, and application throttling isn't designed to absorb a volumetric attack.

## Issues and considerations

You should consider the following points when deciding how to implement this pattern:

- Throttling an application, and the strategy to use, is an architectural decision that affects the entire design of a system. Throttling should be considered early in the application design process because it isn't easy to add once a system has been implemented.

- Align your throttling limits with the component that saturates first.

  Request rate is the most familiar dimension to limit, but the real bottleneck is often concurrent in-flight requests, queue depth, CPU or memory utilization, or a downstream dependency's own limitations. A requests-per-second limit doesn't protect a system whose bottleneck is concurrency at a fan-out point.

  Identify the saturation point at each boundary where you enforce throttling; for example, the gateway, the service, a partition, or a specific downstream dependency. Then set the limit on that dimension. For concurrency-bounded protection at fan-out points, see the [Bulkhead pattern](./bulkhead.md), which complements throttling.

- Pick a limiting algorithm intentionally. Match the algorithm to the tolerance of the component you're protecting.

  | Algorithm | Behavior and best fit |
  | :-------- | :-------------------- |
  | Token bucket | Allows bursts up to a configured size while enforcing a steady refill rate. Fits gateways that need to absorb short spikes. |
  | Leaky bucket | Emits at a constant rate. Fits backends that need a steady ingress rate. |
  | Fixed window | Simple to implement, but allows back-to-back bursts at window boundaries. |
  | Sliding window | Smooths the window-boundary problem of fixed windows at the cost of more state. |

- Decide who feels the limit. Throttling at a coarse boundary, like a regional gateway, can affect many unrelated users when only a few are causing the load.

- Decide where the counter lives when the throttle spans multiple nodes. Local counters are fast but under count when the same caller hits multiple replicas. A centralized counter, stored in a shared dependency like Redis, sees all requests but adds latency to every decision. You can approximate a global rate by dividing the limit among replicas with periodic reconciliation.

- Throttling must be performed quickly. The system must be capable of detecting an increase in activity and react accordingly. The system must also be able to revert to its original state quickly after the load has eased. This requires that the appropriate performance data is continually captured and monitored.

- Shed load proactively, not at the edge of collapse. A throttle that only rejects after a component is fully saturated lets latency spike before callers see any back-pressure.

  As utilization approaches the hard limit, start rejecting a growing fraction of requests; this gives callers earlier signals to back off and avoids the latency collapse that abrupt limits often trigger. Use p99 latency against your SLO as the primary trigger; average utilization can look healthy while p99 has already breached.

  Where you can distinguish request value, shed lower value or more retryable work first; see the [Priority Queue pattern](./priority-queue.yml).

- If a service needs to deny a user request temporarily, it should return a specific error code like 429 ("Too Many Requests") and 503 ("Service Unavailable") so the client application can understand that the reason for the refusal to serve a request is due to throttling.

  - HTTP 429 indicates the calling application sent too many requests in a time window and exceeded a predetermined limit.
  - HTTP 503 indicates the service isn't ready to handle the request. The common cause is that the service is experiencing more temporary load spikes than expected.

  The client application can wait for a period before retrying the request. A `Retry-After` HTTP header should be included, to support the client in choosing the retry strategy.

  Beyond `Retry-After`, return enough context for the caller to retry deliberately rather than blindly. For example include the limit that was exceeded, be clear about the affected scope, or suggest a rate that would succeed. Opaque rejections don't help callers adapt.

- Propagate important overload signals from your dependencies; don't absorb them. A service that throttles its callers should also respect the throttling responses it receives from its own downstream dependencies. If your service masks a downstream's 429 or 503 response by retrying silently or by translating it into an opaque 500, callers can't slow down appropriately, retries amplify, and the overload cascades back through the system. This is the failure mode described by the [Retry Storm antipattern](../antipatterns/retry-storm/index.md). Surface back-pressure to upstream callers so the entire call chain can shed load together.

- Make rejection cheaper than the work it prevents. If refusing a request involves heavy authentication, deep parsing, or complex policy evaluation, a flood of rejected requests can still saturate the system. Reject as early in the request pipeline as you can, and load test the rejection path itself.

- Throttling can't always buy enough time for autoscale. If demand grows faster than new capacity comes online, even a throttled system can fail. Where this is unacceptable, keep larger capacity reserves and configure more aggressive autoscaling.

- Don't substitute caching for throttling. A cache lowers average load on the origin but doesn't bound peak load. Cache misses pass through to the origin, and a popular key expiring under heavy traffic can cause many callers to race to refill it. Use caching to reduce normal pressure and throttling to bound the worst case; see the [Cache-Aside pattern](./cache-aside.yml).

- Normalize resource costs for different operations as they generally don't carry equal execution costs. For example, throttling limits might be lower for read operations and higher for write operations. Not considering the cost of an operation can result in exhausted capacity and exposing a potential attack vector.

- Dynamic configuration change of throttling behavior at runtime is desirable. If a system faces an abnormal load that the applied configuration cannot handle, throttling limits might need to increase or decrease to stabilize the system and keep up with the current traffic. Expensive, risky, and slow deployments are not desirable at this point. Using the [External Configuration Store pattern](./external-configuration-store.md) throttling configuration is externalized and can be changed and applied without deployments.

- Consider adaptive limits as an alternative to static ones. Some throttling SDKs react to latency or queue depth signals so the limit tracks actual component conditions. Always pair an adaptive limiter with a hard ceiling.

- Revisit your limits as the workload evolves. Even adaptive limits can't see all drift; SLO changes, changed dependency capacity, or shifts in per-operation cost. Schedule periodic operator review against those inputs.

## When to use this pattern

Use this pattern:

- To ensure that a system continues to meet service-level objectives (SLOs).

- To prevent a single tenant from monopolizing the resources provided by an application.

- To handle bursts in activity.

- To help cost-optimize a system by limiting the maximum resource levels needed to keep it functioning.

- To reduce low value compute processing during periods of high carbon intensity in the energy grid.

## Workload design

An architect should evaluate how the Throttling pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | You design the limits to help prevent resource exhaustion that might lead to malfunctions. You can also use this pattern as a control mechanism in a graceful degradation plan.<br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | You can design the limits to help prevent resource exhaustion that could result from automated abuse of the system.<br/><br/> - [SE:06 Network controls](/azure/well-architected/security/networking)<br/> - [SE:08 Hardening resources](/azure/well-architected/security/harden-resources) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) is focused on **sustaining and improving** your workload's **return on investment**. | The enforced limits can inform cost modeling and can even be directly tied to the business model of your application. They also put clear upper bounds on utilization, which can be factored into resource sizing.<br/><br/> - [CO:02 Cost model](/azure/well-architected/cost-optimization/cost-model)<br/> - [CO:12 Scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | When the system is under high demand, this pattern helps mitigate congestion that can lead to performance bottlenecks. You can also use it to proactively avoid noisy neighbor scenarios.<br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

The final figure illustrates how throttling can be implemented in a multitenant system. Users from each of the tenant organizations access a cloud-hosted application where they fill out and submit surveys. The application contains instrumentation that monitors the rate at which these users are submitting requests to the application.

In order to prevent the users from one tenant affecting the responsiveness and availability of the application for all other users, a limit is applied to the number of requests per second the users from any one tenant can submit. The application blocks requests that exceed this limit.

![Figure 3 - Implementing throttling in a multitenant application](./_images/throttling-multi-tenant.png)

## Next steps

The following guidance might also be relevant when implementing this pattern:

- [Architecture strategies for designing a monitoring system](/azure/well-architected/operational-excellence/observability). Throttling depends on continuous, low-latency signals about resource use and saturation. This guidance describes how to design the instrumentation, collection, and alerting that your throttling control loop relies on.
- [Measure the consumption of each tenant](../guide/multitenant/considerations/measure-consumption.md). Per-tenant throttling requires attributing each request to a principal and metering its resource use. This guidance covers the per-tenant signals and approaches you need before you can enforce per-tenant limits.
- [Autoscaling in Azure](../best-practices/auto-scaling.md). Throttling can be used as an interim measure while a system autoscales, or to remove the need for a system to autoscale. Contains information on autoscaling strategies.

## Related resources

The following patterns might also be relevant when implementing this pattern:

- [Queue-based Load Leveling pattern](./queue-based-load-leveling.yml). Queue-based load leveling is a commonly used mechanism for implementing throttling. A queue can act as a buffer that helps to even out the rate at which requests sent by an application are delivered to a service.
- [Priority Queue pattern](./priority-queue.yml). A system can use priority queuing as part of its throttling strategy to maintain performance for critical or higher value applications, while reducing the performance of less important applications.
- [External Configuration Store pattern](./external-configuration-store.md). Centralizing and externalizing the throttling policies provides the capability to change the configuration at runtime without the need for a redeployment. Services can subscribe to configuration changes, which applies the new configuration immediately, to stabilize a system.
