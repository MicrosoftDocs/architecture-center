---
title: Architectural Approaches for Compute in Multitenant Solutions
description: Learn about approaches to support multitenancy for compute components, including scaling strategies, isolation models, and cost-efficient shared resources.
author: DixitArora-MSFT
ms.author: dixitaro
ms.date: 05/02/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural approaches for compute in multitenant solutions

Most cloud-based solutions are composed of compute resources. These resources can include web and application tiers, batch processors, scheduled jobs, or specialized resources like GPUs and high-performance compute. Multitenant solutions often benefit from shared compute resources because a higher density of tenants for each infrastructure lowers operational costs and simplifies management. You should consider the isolation requirements and the implications of shared infrastructure.

This article provides guidance about crucial considerations and requirements for solution architects to consider when they plan a multitenant compute tier. This guidance includes common patterns for applying multitenancy to compute services and antipatterns to avoid.

## Key considerations and requirements

Both multitenancy and the isolation model that you choose affect the scaling, performance, state management, and security of your compute resources. The following sections review key decisions that you must make when you plan a multitenant compute solution.

### Scale

Systems must perform adequately as demand changes. As the number of tenants and traffic increase, you might need to scale your resources to match the growing demand and maintain acceptable performance. Similarly, when the number of active users or the amount of traffic decreases, you should automatically reduce compute capacity to lower costs. However, you should minimize any disruption for users when you adjust capacity.

If you deploy dedicated resources for each tenant, you have the flexibility to scale each tenant's resources independently. In a solution where compute resources are shared among multiple tenants, scaling those resources allows all tenants to benefit from the increased capacity. However, all tenants suffer when the scale is insufficient to handle their overall load. For more information, see [Noisy Neighbor antipattern](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml).

When you build cloud solutions, you can choose whether to [scale horizontally or vertically](/azure/well-architected/performance-efficiency/scale-partition). In a multitenant solution that has a growing number of tenants, scaling horizontally often provides greater flexibility and a higher overall scale ceiling.

Performance problems often remain undetected until an application is under load. You can use a fully managed service, such as [Azure Load Testing](/azure/load-testing/overview-what-is-azure-load-testing), to learn how your application operates under stress.

#### Scale triggers

Regardless of the approach that you use to scale, you typically need to plan the triggers that cause your components to scale. When you have shared components, consider each tenant's workload patterns to ensure that your provisioned capacity meets the total required demand. This approach helps prevent resource contention and reduces the likelihood of tenants experiencing the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). You might also be able to plan your scaling capacity by considering the number of tenants. For example, if you measure the resources that you use to service 100 tenants, then as you onboard more tenants, you can plan to scale so that your resources double for every extra 100 tenants.

### State

Compute resources can be *stateless*, or they can be *stateful*. Stateless components don't maintain any data between requests. From a scalability perspective, stateless components are often easy to scale out because you can quickly add new workers, instances, or nodes. Stateless components can also immediately start to process requests. If your architecture supports instance repurposing, you can also reassign instances from one tenant to another tenant.

Stateful resources can be further subdivided based on the type of state that they maintain. *Persistent state* is data that needs to be stored permanently. In cloud solutions, avoid storing a persistent state in your compute tier. Instead, use storage services like databases or storage accounts. *Transient state* is data that's stored temporarily. It includes read-only in-memory caches and the storage of temporary files on local disks.

Transient state is often useful to improve the performance of your application tier by reducing the number of requests to back-end storage services. For example, when you use an in-memory cache, you might be able to serve read requests without connecting to a database and without performing an intensive query that you recently performed when you served another request.

In latency-sensitive applications, the cost of cache hydration can become significant. A multitenant solution can worsen this problem if each tenant requires different data to be cached. To mitigate this problem, some solutions apply *session affinity*. This approach ensures that the same compute worker node processes all requests for a specific user or tenant. Session affinity can improve the ability of the application tier to use its cache effectively. However, session affinity also complicates scaling and traffic load balancing across workers. Consider this trade-off carefully. For many applications, session affinity isn't required.

It's also possible to store data in external caches, such as Azure Managed Redis. External caches are optimized for low-latency data retrieval, while isolating the state from the compute resources so that they can be scaled and managed separately. In many solutions, external caches enable you to improve application performance, while you keep the compute tier stateless.

> [!IMPORTANT]
> Avoid leaking data between tenants when you use in-memory caches or other components that maintain state. For example, consider prepending a tenant identifier to all cache keys to ensure that data is separated for each tenant.

### Isolation

When you design a multitenant compute tier, you have several options for tenant isolation. You can deploy [shared compute resources](#compute-resource-consolidation-pattern) for all tenants, [dedicated compute resources](#dedicated-compute-resources-for-each-tenant) for individual tenants, or a [semi-isolated approach](#semi-isolated-compute-resources) that falls between these extremes. Each option has trade-offs. To help you decide which option best suits your solution, consider your requirements for isolation.

You might be concerned with the logical isolation of tenants and how to separate the management responsibilities or policies that are applied to each tenant. Alternatively, you might need to deploy distinct resource configurations for specific tenants, such as deploying a specific virtual machine (VM) SKU to suit a tenant's workload.

Depending on the isolation model that you choose, ensure that tenant data remains properly isolated, even if component failures or outages occur. Consider using [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) in your regular automated testing process to introduce faults that simulate real-world outages. This testing helps verify that your solution maintains proper tenant isolation and continues to function under pressure.

## Approaches and patterns to consider

### Autoscale

Azure compute services provide various capabilities that scale workloads. [Many compute services support autoscaling](../../../best-practices/auto-scaling.md), which requires you to determine when to scale and to set minimum and maximum scale levels. The specific scaling options depend on the compute services that you use. See the following example services or components:

- **Azure App Service:** [Specify autoscale rules](/azure/app-service/manage-scale-up) that scale your infrastructure based on your requirements.

- **Azure Functions:** Choose from [multiple scale options](/azure/azure-functions/functions-scale#scale), including an event-driven scaling model that automatically scales based on the work that your functions perform.

- **Azure Container Apps:** Use [event-driven autoscaling](/azure/container-apps/overview) to scale your application based on the work that it performs and on its current load.

- **Azure Kubernetes Service (AKS):** To keep up with the demands of your application, you might need to [adjust the number of nodes that run your workloads](/azure/aks/cluster-autoscaler). To rapidly scale application workloads in an AKS cluster, you can use [virtual nodes](/azure/aks/virtual-nodes).

- **VMs:** A virtual machine scale set can [automatically increase or decrease the number of VM instances](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview) that run your application.

### Deployment Stamps pattern

For more information about how you can use the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) to support a multitenant solution, see [Architectural approaches for a multitenant solution](overview.md#deployment-stamps-pattern).

### Compute Resource Consolidation pattern

The [Compute Resource Consolidation pattern](../../../patterns/compute-resource-consolidation.yml) helps you achieve a higher density of tenants to compute infrastructure by sharing the underlying compute resources. By sharing compute resources, you can reduce the direct cost of those resources. Also, your management costs are often lower because there are fewer components to manage.

However, compute resource consolidation increases the likelihood of the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Any tenant's workload might consume a disproportionate amount of the compute capacity that's available. You can often mitigate this risk by ensuring that you scale your solution appropriately and by applying controls like quotas and API limits to avoid tenants that consume more than their fair share of the capacity.

This pattern is achieved in different ways, depending on the compute service that you use. See the following example services or components:

- **App Service and Azure Functions:** Deploy shared App Service plans, which represent the hosting server infrastructure.

- **Container Apps:** Deploy [shared environments](/azure/container-apps/environment).

- **AKS:** Deploy shared pods with a multitenancy-aware application.

- **VMs:** Deploy a single set of VMs for all tenants to use.

### Dedicated compute resources for each tenant

You can also deploy dedicated compute resources for each tenant. Dedicated resources mitigate the risk of the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) by ensuring that the compute resources for each tenant are isolated from the others. It also enables you to deploy a distinct configuration for each tenant's resources based on their requirements. However, dedicated resources typically incur a higher cost because you have a lower density of tenants to resources.

Depending on the Azure compute services that you use, you might need to deploy different dedicated resources:

- **App Service and Azure Functions:** Deploy separate App Service plans for each tenant.

- **Container Apps:** Deploy separate environments for each tenant.
- **AKS:** Deploy dedicated clusters for each tenant.
- **VMs:** Deploy dedicated VMs for each tenant.

Physical host‑level isolation can also be provided by running tenant VMs on [Azure dedicated hosts](/azure/virtual-machines/dedicated-hosts), which reserve an entire physical server for a single customer. However, this approach is typically more expensive than using shared hosts.

### Semi-isolated compute resources

Semi-isolated approaches require you to deploy aspects of the solution in an isolated configuration while you share the other components.

When you use App Service and Azure Functions, you can deploy distinct applications for each tenant and host the applications on shared App Service plans. This approach reduces the cost of your compute tier because App Service plans represent the unit of billing. It also enables you to apply distinct configuration and policies to each application. However, this approach introduces the risk of the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml).

You can use Container Apps to deploy multiple applications to a shared environment and then use Dapr and other tools to configure each application separately.

AKS, and Kubernetes more broadly, provide various options for multitenancy:

- Tenant-specific namespaces that can provide logical isolation of tenant-specific resources, which are deployed to shared clusters and node pools

- Tenant-specific nodes or node pools on a shared cluster

- Tenant-specific pods that might use the same node pool

You can also use AKS to apply pod-level governance to mitigate the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). For more information, see [Best practices for application developers to manage resources in AKS](/azure/aks/developer-best-practices-resource-management).

It's also important to be aware of shared components in a Kubernetes cluster, and how multitenancy might affect these components. For example, the Kubernetes API server is a shared service that's used throughout the entire cluster. Even if you provide tenant-specific node pools to isolate the tenants' application workloads, the API server might experience contention from a large number of requests across the tenants.

## Antipatterns to avoid

Avoid the following antipatterns.

### Noisy Neighbor antipattern

When you deploy components that tenants share, the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) is a potential risk. Ensure that you include resource governance and monitoring to mitigate the risk of other tenants' activity affecting a tenant's compute workload.

### Cross-tenant data leakage

Compute tiers can be subject to cross-tenant data leakage if they aren't properly handled. This risk isn't usually something that you need to consider when you use a multitenant service on Azure because Microsoft provides protections at the platform layer. However, when you develop your own multitenant application, consider whether any shared resources, such as local disk caches, RAM, and external caches, might contain data that another tenant can accidentally view or modify.

### Busy Front End antipattern

To avoid the [Busy Front End antipattern](../../../antipatterns/busy-front-end/index.md), make sure that your front-end tier doesn't do most of the work that other components or tiers of your architecture can handle. This antipattern is especially important when you create shared front ends for a multitenant solution because a busy front end degrades the experience for all tenants.

Instead, consider using asynchronous processing by using queues or other messaging services. This approach also enables you to apply *quality of service (QOS)* controls for different tenants based on their requirements. For example, all tenants might share a common front-end tier, but tenants who [pay for a higher service level](../considerations/pricing-models.md) might have a higher set of dedicated resources to process the work from their queue messages.

### Inelastic or insufficient scaling

Multitenant solutions are often subject to bursty scale patterns. Shared components are especially vulnerable to this problem because the scope for burst is higher, and the effect is greater when you have more tenants that have distinct usage patterns.

Ensure that you take advantage of the elasticity and scale of the cloud. Consider whether you should use [horizontal or vertical scaling](/azure/well-architected/performance-efficiency/scale-partition), and use autoscaling to automatically handle spikes in load. Test your solution to understand how it operates under different levels of load. Ensure that you include the load volumes that are expected in production and your expected growth. You can use a fully managed service, such as [Load Testing](/azure/load-testing/overview-what-is-azure-load-testing), to learn how your application operates under stress.

### No Caching antipattern

The [No Caching antipattern](../../../antipatterns/no-caching/index.md) is when the performance of your solution suffers because the application tier repeatedly requests or recomputes information that can be reused across requests. If you have data that can be shared, either among tenants or among users within a single tenant, it's likely worth caching it to reduce the load on your back-end or database tier.

### Unnecessary statefulness

The implication of the No Caching antipattern is that you also should avoid storing unnecessary state in your compute tier. Be explicit about where you maintain state and why. Stateful front-end or application tiers can reduce your ability to scale. Stateful compute tiers typically also require session affinity, which can reduce your ability to effectively load balance traffic across workers or nodes.

Consider the trade-offs for each piece of state that you maintain in your compute tier, and whether it affects your ability to scale or grow as your tenants' workload patterns change. You can also store state in an external cache, such as Azure Managed Redis.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- Dixit Arora | Senior Customer Engineer, FastTrack for Azure
- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

Review service-specific guidance for your compute services:

- [App Service and Azure Functions considerations for multitenancy](../service/app-service.md)
- [Considerations for using Container Apps in a multitenant solution](../service/container-apps.md)
- [AKS considerations for multitenancy](../service/aks.md)
