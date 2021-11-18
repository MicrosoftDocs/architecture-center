---
title: Azure Cache for Redis and operational excellence
description: Focuses on the Azure Cache for Redis service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Operational Excellence.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-cache-for-redis
categories:
  - data
  - management-and-governance
---

# Azure Cache for Redis and operational excellence

[Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) provides an in-memory data store based on the [Redis (Remote Dictionary Server)](https://redis.io/) software. It's a secure data cache and messaging broker that provides high throughput and low-latency access to data for applications.

Best practices that support operational excellence include:

- [Server load management](/azure/azure-cache-for-redis/cache-best-practices-server-load)
- [Memory management](/azure/azure-cache-for-redis/cache-best-practices-memory-management)
- [Performance testing](/azure/azure-cache-for-redis/cache-best-practices-performance)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure Cache for Redis.

## Design considerations

The [Azure Cache for Redis Service Level Agreements (SLA)](https://azure.microsoft.com/support/legal/sla/cache/v1_0/) covers only Standard and Premium tier caches. Basic tier isn't covered.

Redis is an in-memory cache for key value pairs and has High Availability (HA), by default, except for Basic tier. There are three tiers for Azure Cache for Redis:

- *Basic*: *Not recommended for production workloads*. Basic tier is ideal for:
  - Single node
  - Multiple sizes
  - Development
  - Test
  - Non-critical workloads

- *Standard*: A replicated cache in a two-node primary and secondary configuration managed by Microsoft, with a high availability SLA.
- *Premium*: Includes all standard-tier features and includes the following other features:
  - Faster hardware and performance compared to Basic or Standard tier.
  - Larger cache size, up to `120GB`.
  - [Data persistence](https://redis.io/topics/persistence), which includes Redis Database File (RDB) and Append Only File (AOF).
  - VNET support.
  - [Clustering](/azure/azure-cache-for-redis/cache-how-to-premium-clustering)
  - Geo-Replication: A secondary cache is in another region and replicates data from the primary for disaster recovery. To failover to the secondary, the caches need to be unlinked manually and then the secondary is available for writes. The application writing to Redis will need to be updated with the secondary's cache connection string.
  - Availability Zones: Deploy the cache and replicas across availability zones.
    > [!NOTE]
    > By default, each deployment will have one replica per shard. Persistence, clustering, and geo-replication are all disabled at this time with deployments that have more than one replica. Your nodes will be distributed evenly across all zones. You should have a replica count `>=` number of zones.
  - Import and export.

Microsoft guarantees at least `99.9%` of the time that customers will have connectivity between the Cache Endpoints and Microsoft's Internet gateway.

## Checklist

**Have you configured Azure Cache for Redis with operational excellence in mind?**
***

> [!div class="checklist"]
> - Schedule updates.
> - Monitor the cache and set alerts.
> - Deploy the cache within a VNET.
> - Use the correct caching type (local, in role, managed, redis) within your solution.
> - Configure **Data Persistence** to save a copy of the cache to Azure Storage or use Geo-Replication, depending on the business requirement.
> - Use one static or singleton implementation of the connection multiplexer to Redis and follow the [best practices guide](/azure/azure-cache-for-redis/).
> - Review [How to administer Azure Cache for Redis](/azure/azure-cache-for-redis/cache-administration#reboot).

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure Cache for Redis configuration for operational excellence:

|Recommendation|Description|
|--------------|-----------|
|Schedule updates.|Schedule the days and times that Redis Server updates will be applied to the cache, which doesn't include Azure updates, or updates to the VM operating system.|
|Monitor the cache and set alerts.|Set alerts for exceptions, high CPU, high memory usage, server load, and evicted keys for insights about when to scale the cache. If the cache needs to be scaled, understanding when to scale is important because it will increase CPU during the scaling event to migrate data.|
|Deploy the cache within a VNET.|Gives the customer more control over the traffic that can connect to the cache. Make sure that the subnet has sufficient address space available to deploy the cache nodes and shards (cluster).|
|Use the correct caching type (local, in role, managed, redis) within your solution.|Distributed applications typically implement either or both of the following strategies when caching data: <br>- Using a private cache, where data is held locally on the machine that's running an instance of an application or service. <br>- Using a shared cache, serving as a common source that can be accessed by multiple processes and machines. <br>In both cases, caching can be performed client-side and server-side. Client-side caching is done by the process that provides the user interface for a system, such as a web browser or desktop application. Server-side caching is done by the process that provides the business services that are running remotely.|
|Configure **Data Persistence** to save a copy of the cache to Azure Storage or use Geo-Replication, depending on the business requirement.|*Data Persistence*: If the master and replica reboot, the data will be loaded automatically from the storage account. *Geo-Replication*: The secondary cache needs to be unlinked from the primary. The secondary will now become the primary and can receive *writes*.|
|Review [How to administer Azure Cache for Redis](/azure/azure-cache-for-redis/cache-administration#reboot).|Understand how data loss can occur with cache reboots and how to test the application for resiliency.|

## Source artifacts

To identify Redis instances that aren't on the Premium tier, use the following query:

```sql
Resources 
| where type == 'microsoft.cache/redis'
| where properties.sku.name != 'Premium'
```

## Next step

> [!div class="nextstepaction"]
> [Azure Databricks and security](../azure-databricks/security.md)
