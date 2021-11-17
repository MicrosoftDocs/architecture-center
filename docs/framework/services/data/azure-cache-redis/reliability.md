---
title: Azure Cache for Redis and reliability
description: Focuses on the Azure Cache for Redis service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Service Reliability.
author: v-stacywray
ms.date: 11/15/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-cache-for-redis
categories:
  - data
  - management-and-governance
---

# Azure Cache for Redis and reliability

[Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) provides an in-memory data store based on the [Redis (Remote Dictionary Server)](https://redis.io/) software. It's a secure data cache and messaging broker that provides high throughput and low-latency access to data for applications.

Key concepts and best practices that support reliability include:

- [High availability](/azure/azure-cache-for-redis/cache-high-availability)
- [Failover and patching](/azure/azure-cache-for-redis/cache-failover)
- [Connection resilience](/azure/azure-cache-for-redis/cache-best-practices-connection)

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
  - Geo-Replication: A secondary cache is in another region and replicates data from the primary for disaster recovery. To failover to the secondary, the caches need to be unlinked manually and then the secondary is available for writes. The application writing to Redis needs to be updated with the secondary's cache connection string.
  - Availability Zones: Deploy the cache and replicas across availability zones.
    > [!NOTE]
    > By default, each deployment will have one replica per shard. Persistence, clustering, and geo-replication are all disabled at this time with deployments that have more than one replica. Your nodes will be distributed evenly across all zones. You should have a replica count `>=` number of zones.
  - Import and export.

Microsoft guarantees at least `99.9%` of the time that customers will have connectivity between the Cache Endpoints and Microsoft's Internet gateway.

## Checklist

**Have you configured Azure Cache for Redis with resiliency in mind?**
***

> [!div class="checklist"]
> - Schedule updates.
> - Monitor the cache and set alerts.
> - Deploy the cache within a VNET.
> - Evaluate a partitioning strategy within Redis cache.
> - Configure **Data Persistence** to save a copy of the cache to Azure Storage or use Geo-Replication, depending on the business requirement.
> - Implement retry policies in the context of your Azure Redis Cache.
> - Use one static or singleton implementation of the connection multiplexer to Redis and follow the [best practices guide](/azure/azure-cache-for-redis/).
> - Review [How to administer Azure Cache for Redis](/azure/azure-cache-for-redis/cache-administration#reboot).

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure Cache for Redis configuration for service reliability:

|Recommendation|Description|
|--------------|-----------|
|Schedule updates.|Schedule the days and times that Redis Server updates will be applied to the cache, which doesn't include Azure updates, or updates to the VM operating system.|
|Monitor the cache and set alerts.|Set alerts for exceptions, high CPU, high memory usage, server load, and evicted keys for insights about when to scale the cache. If the cache needs to be scaled, understanding when to scale is important because it will increase CPU during the scaling event to migrate data.|
|Deploy the cache within a VNET.|Gives the customer more control over the traffic that can connect to the cache. Make sure that the subnet has sufficient address space available to deploy the cache nodes and shards (cluster).|
|Evaluate a partitioning strategy within Redis cache.|Partitioning a Redis data store involves splitting the data across instances of the Redis server. Each instance makes up a single partition. Azure Redis Cache abstracts the Redis services behind a facade and doesn't expose them directly. The simplest way to implement partitioning is to create multiple Azure Redis Cache instances and spread the data across them. You can associate each data item with an identifier (a partition key) that specifies which cache stores the data item. The client application logic can then use this identifier to route requests to the appropriate partition. This scheme is simple, but if the partitioning scheme changes (for example, if extra Azure Redis Cache instances are created), client applications may need to be reconfigured.|
|Configure **Data Persistence** to save a copy of the cache to Azure Storage or use Geo-Replication, depending on the business requirement.|*Data Persistence*: if the master and replica reboot, the data will be loaded automatically from the storage account. *Geo-Replication*: The secondary cache needs to be unlinked from the primary. The secondary will now become the primary and can receive *writes*.|
|Implement retry policies in the context of your Azure Redis Cache.|Most Azure services and client SDKs include a retry mechanism. These mechanisms differ because each service has different characteristics and requirements. Each retry mechanism is tuned to a specific service.|
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
> [Azure Cache for Redis and operational excellence](./operational-excellence.md)
