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

TODO figure

It's likely that whichever tenant's request arrived first will take precedence, and the other tenant will experience a noisy neighbor problem. Alternatively, both tenants may find their performance suffers.

Another form of the noisy neighbor problem occurs when the collective resource usage of many tenants results in an peak in overall usage, even if the individual usage for each tenant is fairly low.

TODO figure

This can happen when you have multiple tenants that all have similar usage patterns, or where you haven't provisioned sufficient capacity for the collective load on the system.

## How to fix the problem

From client:

- Migrate to single-tenant instance/stamp
- Handle throttling properly

From service:

- Throttling helps to avoid a single tenant overwhelming the others
- To avoid collective usage issues, monitor overall system usage and ensure you rebalance tenants if needed - look at load patterns

## Considerations

- Tenants likely don't mean to cause issues. It's the service provider's job to ensure that this can't happen - it's not good to blame tenants for using the resources, since they likely are naive to the problem.

## How to detect the problem

- Look for resource usage spikes
- Look at all resources - e.g. CPU, memory, disk IO, database usage, networking metrics, PaaS metrics etc
- Operations for a tenant fail even though the tenant isn't using high numbers of resources
- If possible, track resource consumption by tenant
  - e.g. Cosmos DB RUs on each request, and log by tenant ID

## Example diagnosis

Construct an example with Application Insights and Cosmos DB?

## Related resources

- TODO
