---
title: Architectural approaches for compute in multitenant solutions
titleSuffix: Azure Architecture Center
description: This article describes approaches to support multitenancy for the compute components of your solution.
author: DixitArora-MSFT
ms.author: dixitaro
ms.date: 03/24/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-app-service
 - azure-functions
 - azure-kubernetes-service
categories:
 - compute
 - web
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Architectural approaches for compute in multitenant solutions

Most cloud-based solutions are composed of compute resources of some kind, such as web and application tiers, batch processors, scheduled jobs, and even specialized resources like GPUs and high-performance compute (HPC). Multitenant solutions often benefit from shared compute resources, because a higher density of tenants to infrastructure reduces the operational cost and management. You should consider the isolation requirements and the implications of shared infrastructure.

This article provides guidance about the considerations and requirements that are essential for solution architects to consider when planning a multitenant compute tier. This includes some common patterns for applying multitenancy to compute services, along with some antipatterns to avoid.

## Key considerations and requirements

Multitenancy, and the isolation model you select, impacts the scaling, performance, state management, and security of your compute resources. In this section, we review some of the key decisions you must make when you plan a multitenant compute solution.

### Scale

Systems need to perform adequately under changing demand. As the number of tenants and the amount of traffic increase, you might need to increase the capacity of your resources, to keep up with the growing number of tenants and to maintain an acceptable performance rate. Similarly, when the number of active users or the amount of traffic decrease, you should automatically reduce the compute capacity to reduce costs, but you should reduce the capacity with minimal impact to users.

If you deploy dedicated resources for each tenant, you have the flexibility to scale each tenant's resources independently. In a solution where compute resources are shared between multiple tenants, if you scale those resources, then all of those tenants can make use of the new scale. However, they also will all suffer when the scale is insufficient to handle their overall load. For more information, see the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml).

When you build cloud solutions, you can choose whether to [scale horizontally or vertically](/azure/architecture/framework/scalability/design-scale). In a multitenant solution with a growing number of tenants, scaling horizontally typically provides you with greater flexibility and a higher overall scale ceiling.

Performance problems often remain undetected until an application is under load. You can use a fully managed service, such as [Azure Load Testing](/azure/load-testing/overview-what-is-azure-load-testing), to learn how your application behaves under stress.

#### Scale triggers

Whichever approach you use to scale, you typically need to plan the triggers that cause your components to scale. When you have shared components, consider the workload patterns of every tenant who uses the resources, in order to ensure your provisioned capacity can meet the total required capacity, and to minimize the chance of a tenant experiencing the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). You might also be able to plan your scaling capacity by considering the number of tenants. For example, if you measure the resources that you use to service 100 tenants, then as you onboard more tenants, you can plan to scale such that your resources double for every additional 100 tenants.

### State

Compute resources can be _stateless_, or they can be _stateful_. Stateless components don't maintain any data between requests. From a scalability perspective, stateless components are often easy to scale out because you can quickly add new workers, instances, or nodes, and they can immediately start to process requests. If your architecture allows for it, you can also repurpose instances that are assigned to one tenant and allocate them to another tenant.

Stateful resources can be further subdivided, based on the type of state they maintain. _Persistent state_ is data that needs to be permanently stored. In cloud solutions, you should avoid storing a persistent state in your compute tier. Instead, use storage services like databases or storage accounts. _Transient state_ is data that is stored temporarily, and it includes read-only in-memory caches, and the storage of temporary files on local disks.

Transient state is often useful to improve the performance of your application tier, by reducing the number of requests to backend storage services. For example, when you use an in-memory cache, you might be able to serve read requests, without connecting to a database, and without performing an intensive query that you recently performed when you served another request.

In latency-sensitive applications, the cost of cache hydration can become significant. A multitenant solution can exacerbate this issue, if each tenant requires different data to be cached. To mitigate this issue, some solutions use _session affinity_ to ensure that all requests for a specific user or tenant are processed by the same compute worker node. Although session affinity can improve the ability of the application tier to use its cache effectively, it also makes it harder to scale and to balance the traffic load across workers. This tradeoff needs to be carefully considered. For many applications, session affinity is not required.

It's also possible to store data in external caches, such as Azure Cache for Redis. External caches are optimized for low-latency data retrieval, while keeping the state isolated from the compute resources, so they can be scaled and managed separately. In many solutions, external caches enable you to improve application performance, while you keep the compute tier stateless.

> [!IMPORTANT]
> Avoid leaking data between tenants, whenever you use in-memory caches or other components that maintain state. For example, consider prepending a tenant identifier to all cache keys, to ensure that data is separated for each tenant.

### Isolation

When you design a multitenant compute tier, you often have many options to consider for the level of isolation between tenants, including deploying [shared compute resources](#compute-resource-consolidation-pattern), to be used by all tenants, [dedicated compute resources](#dedicated-compute-resources-per-tenant) for each tenant, or [something in between these extremes](#semi-isolated-compute-resources). Each option comes with tradeoffs. To help you decide which option suits your solution best, consider your requirements for isolation.

You might be concerned with the logical isolation of tenants, and how to separate the management responsibilities or policies that are applied to each tenant. Alternatively, you might need to deploy distinct resource configurations for specific tenants, such as deploying a specific virtual machine SKU to suit a tenant's workload.

Whichever isolation model you select, ensure you verify your tenant data remains appropriately isolated even when components are unavailable or malfunctioning. Consider using [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) as part of your regular automated testing process to deliberately introduce faults that simulate real-world outages and verify that your solution doesn't leak data between tenants and is functioning properly even under pressure.

## Approaches and patterns to consider

### Autoscale

Azure compute services provide different capabilities to scale your workloads. [Many compute services support autoscaling](../../../best-practices/auto-scaling.md), which requires you to consider when you should scale, and your minimum and maximum levels of scale. The specific options available for scaling depend on the compute services you use. See the following example services:

- **Azure App Service**: [Specify autoscale rules](/azure/app-service/manage-scale-up) that scale your infrastructure, based on your requirements.
- **Azure Functions**: Select from [multiple scale options](/azure/azure-functions/functions-scale#scale), including an event-driven scaling model that automatically scales, based on the work that your functions perform.
- **Azure Container Apps**: Use [event-driven autoscaling](/azure/container-apps/overview) to scale your application, based on the work it performs and on its current load.
- **Azure Kubernetes Service (AKS)**: To keep up with your application's demands, you might need to [adjust the number of nodes that run your workloads](/azure/aks/cluster-autoscaler). Additionally, to rapidly scale application workloads in an AKS cluster, you can use [virtual nodes](/azure/aks/virtual-nodes).
- **Virtual machines:** A virtual machine scale set can [automatically increase or decrease the number of VM instances](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview) that run your application.

### Deployment Stamps pattern

For more information about how the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) can be used to support a multitenant solution, see [Overview](overview.yml#deployment-stamps-pattern).

### Compute Resource Consolidation pattern

The [Compute Resource Consolidation pattern](../../../patterns/compute-resource-consolidation.yml) helps you achieve a higher density of tenants to compute infrastructure, by sharing the underlying compute resources. By sharing compute resources, you are often able to reduce the direct cost of those resources. Additionally, your management costs are often lower because there are fewer components to manage.

However, compute resource consolidation increases the likelihood of the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Any tenant's workload might consume a disproportionate amount of the compute capacity that's available. You can often mitigate this risk by ensuring you scale your solution appropriately, and by applying controls like quotas and API limits, to avoid tenants that consume more than their fair share of the capacity.

This pattern is achieved in different ways, depending on the compute service you use. See the following example services:

- **Azure App Service and Azure Functions**: Deploy shared App Service plans, which represent the hosting server infrastructure.
- **Azure Container Apps**: Deploy shared [environments](/azure/container-apps/environment).
- **Azure Kubernetes Service (AKS)**: Deploy shared pods, with a multitenancy-aware application.
- **Virtual machines**: Deploy a single set of virtual machines for all tenants to use.

### Dedicated compute resources per tenant

You can also deploy dedicated compute resources for every tenant. Dedicated resources mitigate the risk of the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), by ensuring that the compute resources for every tenant are isolated from the others. It also enables you to deploy a distinct configuration for each tenant's resources, based on their requirements. However, dedicated resources typically come with a higher cost, because you have a lower density of tenants to resources.

Depending on the Azure compute services you use, you need to deploy different dedicated resources, as follows:

- **Azure App Service and Azure Functions**: Deploy separate App Service plans for each tenant.
- **Azure Container Apps**: Deploy separate environments for each tenant.
- **Azure Kubernetes Service (AKS)**: Deploy dedicated clusters for each tenant.
- **Virtual machines**: Deploy dedicated virtual machines for each tenant.

### Semi-isolated compute resources

Semi-isolated approaches require you to deploy aspects of the solution in an isolated configuration, while you share the other components.

When you work with App Service and Azure Functions, you can deploy distinct applications for each tenant, and you can host the applications on shared App Service plans. This approach reduces the cost of your compute tier, because App Service plans represent the unit of billing. It also enables you to apply distinct configuration and policies to each application. However, this approach introduces the risk of the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml).

Azure Container Apps enables you to deploy multiple applications to a shared environment, and then to use Dapr and other tools to configure each application separately.

Azure Kubernetes Service (AKS), and Kubernetes more broadly, provide a variety of options for multitenancy, including the following:

 - Tenant-specific namespaces, for logical isolation of tenant-specific resources, which are deployed to shared clusters and node pools.
 - Tenant-specific nodes or node pools on a shared cluster.
 - Tenant-specific pods that might use the same node pool.

AKS also enables you to apply pod-level governance to mitigate the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). For more information, see [Best practices for application developers to manage resources in Azure Kubernetes Service (AKS)](/azure/aks/developer-best-practices-resource-management).

It's also important to be aware of shared components in a Kubernetes cluster, and how these components might be affected by multitenancy. For example, the Kubernetes API server is a shared service that is used throughout the entire cluster. Even if you provide tenant-specific node pools to isolate the tenants' application workloads, the API server might experience contention from a large number of requests across the tenants.

## Antipatterns to avoid

### Noisy Neighbor antipattern

Whenever you deploy components that are shared between tenants, the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) is a potential risk. Ensure you include resource governance and monitoring to mitigate the risk of a tenant's compute workload being affected by the activity of other tenants.

### Cross-tenant data leakage

Compute tiers can be subject to cross-tenant data leakage, if they are not properly handled. This isn't generally something you need to consider when you're using a multitenant service on Azure, because Microsoft provides protections at the platform layer. However, when you develop your own multitenant application, consider whether any shared resources (such as local disk caches, RAM, and external caches) might contain data that another tenant can inadvertently view or modify.

### Busy Front End antipattern

To avoid the [Busy Front End antipattern](../../../antipatterns/busy-front-end/index.md), avoid your front end tier doing a lot of the work that could be handled by other components or tiers of your architecture. This antipattern is particularly important when you create shared front-ends for a multitenant solution, because a busy front end will degrade the experience for all tenants.

Instead, consider using asynchronous processing by making use of queues or other messaging services. This approach also enables you to apply _quality of service_ (QoS) controls for different tenants, based on their requirements. For example, all tenants might share a common front end tier, but tenants who [pay for a higher service level](../considerations/pricing-models.md) might have a higher set of dedicated resources to process the work from their queue messages.

### Inelastic or insufficient scaling

Multitenant solutions are often subject to bursty scale patterns. Shared components are particularly susceptible to this issue, because the scope for burst is higher, and the impact is greater when you have more tenants with distinct usage patterns.

Ensure you make good use of the elasticity and scale of the cloud. Consider whether you should use [horizontal or vertical scaling](/azure/architecture/framework/scalability/design-scale), and use autoscaling to automatically handle spikes in load. Test your solution to understand how it behaves under different levels of load. Ensure you include the load volumes that are expected in production, and your expected growth. You can use a fully managed service, such as [Azure Load Testing](/azure/load-testing/overview-what-is-azure-load-testing), to learn how your application behaves under stress.

### No Caching antipattern

The [No Caching antipattern](../../../antipatterns/no-caching/index.md) is when the performance of your solution suffers because the application tier repeatedly requests or recomputes information that could be reused across requests. If you have data that can be shared, either among tenants or among users within a single tenant, it's likely worth caching it to reduce the load on your backend/database tier.

### Unnecessary statefulness

The corollary to the No Caching antipattern is that you also should avoid storing unnecessary state in your compute tier. Be explicit about where you maintain state and why. Stateful front-end or application tiers can reduce your ability to scale. Stateful compute tiers typically also require session affinity, which can reduce your ability to effectively load balance traffic, across workers or nodes.

Consider the tradeoffs for each piece of state you maintain in your compute tier, and whether it impacts your ability to scale or to grow as your tenants' workload patterns change. You can also store state in an external cache, such as Azure Cache for Redis.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * Dixit Arora | Senior Customer Engineer, FastTrack for Azure
 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 
Other contributors:

 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

## Next steps

Review service-specific guidance for your compute services:

- [Azure App Service and Azure Functions considerations for multitenancy](../service/app-service.yml)
- [Considerations for using Container Apps in a multitenant solution](../service/container-apps.md)
- [Azure Kubernetes Service (AKS) considerations for multitenancy](../service/aks.yml)
