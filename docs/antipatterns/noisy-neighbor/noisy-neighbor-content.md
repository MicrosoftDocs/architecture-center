Multitenant systems share resources between two or more tenants. Because tenants use the same shared resources, the activity of one tenant can negatively affect another tenant's use of the system.

## Context and problem

When you build a service that multiple customers or *tenants* share, you can build it to be *multitenanted*. A benefit of multitenant systems is that resources can be pooled and shared among tenants. This resource sharing often results in lower costs and improved efficiency. However, if a single tenant uses a disproportionate amount of the resources available in the system, the overall performance of the system can suffer. The *noisy neighbor* problem occurs when one tenant's performance is degraded because of the activities of another tenant.

Consider an example multitenant system that has two tenants. Tenant A's usage patterns and tenant B's usage patterns coincide. At peak times, tenant A uses all of the system's resources, which means that any requests that tenant B makes fail. In other words, the total resource demand is higher than the capacity of the system:

:::image type="complex" source="_images/noisy-neighbor-single.png" alt-text="Diagram that shows the resource usage of two tenants." lightbox="_images/noisy-neighbor-single.png" border="false":::
   The diagram has two tenants: Tenant A and Tenant B. Two line graphs represent the resource usage of each tenant. Tenant A consumes the complete set of system resources, which results in a system failure for Tenant B.
:::image-end:::

It's likely that the tenant whose request arrives first takes precedence. Then the other tenant might experience a noisy neighbor problem. Alternatively, performance might degrade for both tenants.

The noisy neighbor problem also occurs when each individual tenant consumes only a small portion of the system's capacity. However, the combined resource usage of many tenants can result in a peak in overall usage:

:::image type="complex" source="_images/noisy-neighbor-multiple.png" alt-text="Diagram that shows three tenants, each that use less than max throughput. Together, they fully consume the total system resources." lightbox="_images/noisy-neighbor-multiple.png" border="false":::
   The image shows three line graphs that represent the resource usage for three tenants: Tenant A, Tenant B, and Tenant C. These graphs show the total system capacity over time. Another line graph shows the total system capacity and resource usage of all three tenants.
:::image-end:::

This scenario can occur when you have multiple tenants that all have similar usage patterns or when you haven't provisioned sufficient capacity for the collective load on the system.

## Solution

Sharing a single resource inherently carries the risk of noisy neighbor problems that you can't completely avoid. However, there are some steps that both clients and service providers can take to reduce the likelihood of noisy neighbor problems or to mitigate their effects.

### Actions that clients can take

- **Ensure that your application handles [service throttling](../../patterns/throttling.yml)** to reduce making unnecessary requests to the service. Ensure that your application follows best practices to [retry requests that received a transient failure response](../../patterns/retry.yml).

- **Purchase reserved capacity, if available.** For example, when you use Azure Cosmos DB, purchase [reserved throughput](/azure/cosmos-db/optimize-cost-throughput).

- **Migrate to a service tier that has stronger isolation guarantees, if available.** For example, when you use Azure Service Bus, [migrate to the premium tier](/azure/service-bus-messaging/service-bus-premium-messaging). When you use [Azure Managed Redis](/azure/redis/overview#choosing-the-right-tier) with dedicated infrastructure and private networking you help eliminate noisy neighbor effects.

- **Migrate to a single-tenant instance of the service.** For example, when you use Azure ExpressRoute, [provision separate circuits for environments that are sensitive to performance](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure).

### Actions that service providers can take

- **Monitor the resource usage for your system.** Monitor both the overall resource usage and the resources that each tenant uses. Configure alerts to detect spikes in resource usage. If possible, configure automation to automatically mitigate known problems by [scaling up or out](/azure/well-architected/performance-efficiency/scale-partition).

- **Apply resource governance.** Consider applying policies that prevent a single tenant from overwhelming the system and reducing the capacity available to other tenants. This step might take the form of quota enforcement through the [Throttling pattern](../../patterns/throttling.yml) or the [Rate Limiting pattern](../../patterns/rate-limiting-pattern.yml).

- **Provision more infrastructure.** This process might include scaling up by upgrading some of your solution components. Or it might include scaling out by provisioning extra shards if you follow the [Sharding pattern](../../patterns/sharding.yml), or stamps if you follow the [Deployment Stamps pattern](../../patterns/deployment-stamp.yml).

- **Enable tenants to purchase pre-provisioned or reserved capacity.** This approach gives tenants greater confidence that your solution can reliably handle their workloads.

- **Balance tenant resource usage.** For example, you might try one of the following approaches:

  - If you host multiple instances of your solution, consider rebalancing tenants across the instances or stamps. For example, consider placing tenants with predictable and complementary usage patterns across multiple stamps to flatten the peaks in their usage.
  
  - Consider whether you have background processes or resource-intensive workloads that aren't time-sensitive. Run these workloads asynchronously at off-peak times to preserve your resource capacity for time-sensitive workloads.

- **Check whether your downstream services provide controls to mitigate noisy neighbor problems.** For example, when you use Kubernetes, consider using [pod limits](/azure/aks/developer-best-practices-resource-management). When you use Azure Service Fabric, consider using the [built-in governance capabilities](/azure/service-fabric/service-fabric-resource-governance).

- **Restrict the operations that tenants can perform.** For example, restrict tenants from running resource-intensive database queries by setting a maximum returnable record count or query time limit. Or change these operations to be asynchronous and schedule them to run at off-peak times. This action mitigates the risk of tenants taking actions that might negatively affect other tenants.

- **Provide a quality of service (QoS) system.** When you apply QoS, you prioritize some processes or workloads before other processes or workloads. By factoring QoS into your design and architecture, you can ensure that high-priority operations take precedence when there's pressure on your resources.

## Considerations

In most cases, individual tenants don't intend to cause noisy neighbor problems. Individual tenants might not know that their workloads cause noisy neighbor problems for other tenants. However, some tenants might exploit vulnerabilities in shared components to attack a service, either individually or by performing a distributed denial-of-service attack.

Regardless of the cause, it's important to treat these problems as resource governance problems and to apply usage quotas, throttling, and governance controls to mitigate the problem.

> [!NOTE]
> Be transparent with clients about any throttling mechanisms or usage quotas that you enforce. It's important that they handle failed requests gracefully and aren’t caught off guard by limitations.

## How to detect the problem

From a client's perspective, the noisy neighbor problem typically manifests as failed requests to the service or as requests that take a long time to complete. Specifically, if the same request succeeds at other times and appears to fail randomly, there might be a noisy neighbor problem. Client applications should record telemetry to track the success rate and performance of the requests to services. The applications should also record baseline performance metrics for comparison purposes.

For Azure-based services, review the [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits) to understand limits and quotas that apply to each Azure component in your solution.

From a service's perspective, the noisy neighbor problem might appear in the following ways.

- **Spikes in resource usage:** It's important to clearly understand your normal baseline resource usage and to configure monitoring and alerts to detect spikes. Consider all the resources that might affect your service's performance or availability. These resources include metrics such as server CPU and memory usage, disk input and output, database usage, and network traffic. You should also monitor metrics exposed by managed services, including request volume and synthetic or abstract performance indicators such as Azure Cosmos DB request units.

- **Failures when performing an operation for a tenant:** Look for failures that occur when a tenant isn't consuming a large share of the system's resources. This pattern might indicate that the tenant is experiencing a noisy neighbor problem. Track resource consumption by tenant. For instance, when you use Azure Cosmos DB, log the request units for each request and include the tenant's identifier in the telemetry so that you can aggregate request unit usage for each tenant.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer, Azure Patterns & Practices
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Customer Engineer, FastTrack for Azure
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Partner Technology Strategist
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Architectural considerations for a multitenant solution](../../guide/multitenant/considerations/overview.yml)
- [Transient fault handling best practices](../../best-practices/transient-faults.md)
