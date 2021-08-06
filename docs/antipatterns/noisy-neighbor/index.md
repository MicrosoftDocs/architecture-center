---
title: Noisy Neighbor antipattern
titleSuffix: Performance antipatterns for cloud apps
description: Learn how the activity of one tenant can impact the performance of other tenants in a multitenant system.
author: johndowns
ms.date: 07/29/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: anti-pattern
products:
 - azure
categories:
 - management-and-governance
 - security
ms.custom:
  - article
---

# Noisy Neighbor antipattern

Multitenant systems share resources between tenants. This means that the activity of one tenant can have a negative impact on another tenant's use of the system.

## Problem description

A benefit of multitenant systems is that resources can be pooled and shared among tenants. This often results in lower costs and improved efficiency. However, if a single tenant uses a disproportionate amount of the resources available in the system, the overall performance of the system can suffer. The _noisy neighbor_ problem occurs when one tenant's performance is degraded because of the activities of another tenant.

Consider an example multitenant system with two tenants. Tenant A's usage patterns and tenant B's usage patterns coincide, which means that at peak times, the total resource usage is higher than the capacity of the system:

![Diagram showing two tenants. Tenant A ](_images/noisy-neighbor-single.png)

It's likely that whichever tenant's request arrived first will take precedence, and the other tenant will experience a noisy neighbor problem. Alternatively, both tenants may find their performance suffers.

The noisy neighbor problem also occurs even when each individual tenant is consuming relatively small amounts of the system's capacity, but the collective resource usage of many tenants results in a peak in overall usage:

![Figure with 3 tenants, each consuming less the maximum throughput of the solution. In total, the three tenants consume the complete system resources.](_images/noisy-neighbor-multiple.png)

This can happen when you have multiple tenants that all have similar usage patterns, or where you haven't provisioned sufficient capacity for the collective load on the system.

## How to fix the problem

Noisy neighbor problems are an inherent risk in multitenant systems, and it's not possible to completely eliminate the possibility of being impacted by a noisy neighbor. However, there are some steps that both clients and service providers can take to reduce the likelihood of noisy neighbor problems, or to mitigate their effects when they are observed.

### Actions that clients can take

- Purchase reserved capacity if available. For example, when using Cosmos DB, purchase [reserved throughput](/azure/cosmos-db/optimize-cost-throughput), and when using ExpressRoute, [provision separate circuits for environments that are sensitive to performance](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure)
- Migrate to single-tenant instance/stamp or to service tiers with higher isolation guarantees. For example, when using Service Bus, [migrate to the premium tier](/azure/service-bus-messaging/service-bus-premium-messaging), and when using Azure Cache for Redis, [provision a standard or premium tier cache](/azure/azure-cache-for-redis/cache-best-practices#configuration-and-concepts)    .
- Handle throttling properly    

### Actions that service providers can take

- Monitor overall and per-tenant resource usage. Configure alerts and automation to handle issues.
- Apply resource governance to avoid a single tenant overwhelming the others. This might take the form of quota enforcement through throttling, and rate limiting.
- Consider restricting the operations that tenants can perform, to avoid tenants taking actions that might negatively impact other tenants.
- Consider provisioning more infrastructure, such as by upgrading your components, or by provisioning an additional deployment stamp if you follow that pattern.
- Consider allowing tenants to purchase pre-provisioned/reserved capacity.
- If you host multiple instances of your solution, consider re-balancing tenants across instances/stamps. For example, consider placing tenants with predictable usage patterns across multiple stamps to flatten the peaks in usage.
- Consider whether you have background processes, or resource-intensive workloads that aren't time-sensitive. Run these asynchronously at off-peak times to preserve your peak resource capacity for time-sensitive workloads.
- Consider whether your services provide controls to mitigate noisy neighbor problems. For example, when using Kubernetes [consider using pod limits](/azure/aks/developer-best-practices-resource-management), and when using Service Fabric, [consider using the built-in governance capabilities](/azure/service-fabric/service-fabric-resource-governance).

## Considerations

- Tenants likely don't mean to cause issues.
- However, sometimes there could be bad actors that DDOS a multitenant system if it does not have usage governance, quota enforcement, and throttling.
- It's the service provider's job to ensure that this can't happen - it's not good to blame tenants for using the resources, since they likely are naive to the problem.

## How to detect the problem

From client side, might see same operation taking different amounts of time or failing intermittently

- Look for resource usage spikes. Set up alerts, and make sure you have a clear understanding of your normal baseline resource usage.
- Look at all resources - e.g. CPU, memory, disk IO, database usage, networking metrics, PaaS metrics etc
- Operations for a tenant fail even though the tenant isn't using high numbers of resources
- Track resource consumption by tenant
  - e.g. Cosmos DB RUs on each request, and log by tenant ID

## Example diagnosis

Construct an example with Application Insights and Cosmos DB?

## Related resources

 * [Transient fault handling best practices](../../best-practices/transient-faults.md)
