---
title: Cosmos DB and reliability
description: Focuses on the Cosmos DB service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Reliability.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - cosmos-db
categories:
  - data
  - management-and-governance
---

# Cosmos DB and reliability

[Cosmos DB](https://azure.microsoft.com/services/cosmos-db/#overview) is a fully managed NoSQL database for modern app development.

Key features include:

- [Guaranteed speed at any scale](/azure/cosmos-db/introduction#guaranteed-speed-at-any-scale)
- [Simplified application development](/azure/cosmos-db/introduction#simplified-application-development)
- [Mission-critical ready](/azure/cosmos-db/introduction#mission-critical-ready)
- [Fully managed and cost effective](/azure/cosmos-db/introduction#fully-managed-and-cost-effective)

To understand how Cosmos DB bolsters resiliency for your application workload, reference the following articles:

- [Distribute your data globally with Azure Cosmos DB](/azure/cosmos-db/distribute-data-globally)
- [How does Azure Cosmos DB provide high availability](/azure/cosmos-db/high-availability)
- [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels)
- [Configure Azure Cosmos DB account with periodic backup](/azure/cosmos-db/configure-periodic-backup-restore)

The following sections include design considerations, a configuration checklist, recommended configuration options, and source artifacts specific to Cosmos DB and reliability.

## Design considerations

Cosmos DB includes the following design considerations:

- SLA for read availability for Database Accounts spanning two or more Azure regions.
- SLAs for throughput, consistency, availability, and latency.
- SLA for both read and write availability with the configuration of multiple Azure regions as writable endpoints.

For more granular information about SLAs specific to this product, reference [Cosmos DB Service Level Agreements](https://azure.microsoft.com/support/legal/sla/cosmos-db/v1_3/).

## Checklist

**Have you configured Cosmos DB with reliability in mind?**

> [!div class="checklist"]
> - Deploy Cosmos DB and the application in the region that corresponds to end users.
> - If multi-master option is enabled on Cosmos DB, it's important to understand [Conflict Types and Resolution Policies](/azure/cosmos-db/conflict-resolution-policies).
> - Start with, Session, the default consistency level.
> - Change the consistency level, depending on the data operation and usage.
> - Evaluate connectivity modes and connection protocols in Cosmos DB.
> - Configure preferred locations.
> - Specify index precisions.
> - Use [Azure Monitor](/azure/cosmos-db/monitor-cosmos-db) to see the provisioned autoscale max `RU/s` (Autoscale Max Throughput) and the `RU/s` the system is currently scaled to (Provisioned Throughput).
> - Understand your traffic pattern to pick the right option for [provisioned throughput types](/azure/cosmos-db/how-to-choose-offer).
> - *New applications*: If you don't know your traffic pattern yet, start at the entry point `RU/s` to avoid over-provisioning in the beginning.
> - *Existing applications*: Use Azure Monitor metrics to determine if your traffic pattern is suitable for autoscale.
> - *Existing applications*: Find the normalized request unit consumption metric of your database or container.
> - *Existing applications*: The closer the number is to `100%`, the more you're fully using your provisioned `RU/s`.
> - Set provisioned `RU/s` to `T` for all hours in a month.
> - Enable [automatic failover](/azure/cosmos-db/high-availability#multi-region-accounts-with-a-single-write-region-write-region-outage) when you configure Cosmos accounts used for production workloads.
> - Implement [retry logic](/azure/architecture/best-practices/retry-service-specific#cosmos-db) in your client.
> - For query-intensive workloads, use Windows `64-bit` instead of Linux or Windows `32-bit` host processing.
> - To reduce latency and CPU jitter, enable accelerated networking on client virtual machines in both Windows and Linux.
> - Increase the number of threads and tasks.
> - To avoid network latency, collocate client in the same region as Cosmos DB.
> - Call [OpenAsync](/dotnet/api/microsoft.azure.documents.client.documentclient.openasync?view=azure-dotnet&preserve-view=true) to avoid startup latency on first request.
> - Scale out client applications across multiple servers if client consumes more than `50,000` `RU/s`.
> - [Select a partition key](/azure/cosmos-db/partitioning-overview#choose-partitionkey).
> - Ensure the partition key is a property that has a value that doesn't change.
> - You can't change a partition key after it's created with the collection.
> - Ensure the partition key has a high cardinality.
> - Ensure the partition key spreads RU consumption and data storage evenly across all logical partitions.
> - Ensure you're running read queries with the partitioned column to reduce RU consumption and latency.
> - Evaluate ways to improve data performance.
> - Configure data replication to ensure Cosmos DB meets the SLAs.

## Configuration recommendations

Explore the following table of recommendations to optimize your Cosmos DB configuration for reliability:

|Recommendation|Description|
|--------------|-----------|
|Deploy Cosmos DB and the application in the region that corresponds to end users.|There are two common scenarios for configuring two or more regions: Delivering low-latency access to data to end users no matter where they're located around the globe. Adding regional resiliency for business continuity and disaster recovery (BCDR). For delivering low-latency to end users, it's recommended to deploy both the application and add Cosmos DB in the regions that correspond to where the application's users are located.|
|Start with, Session, the default consistency level.|It's the recommended consistency level to start with as it receives data later, but in the same order as the writes.|
|Change the consistency level, depending on the data operation and usage.|Depending on the type of data stored, different consistency levels may be changed on a per request basis. For example, if log data is written to Cosmos DB, an **Eventual** consistency may be relevant, but if writing e-commerce transactions, then **Strong** may be more appropriate.|
|Evaluate connectivity modes and connection protocols in Cosmos DB.|Cosmos DB supports two connectivity modes. In *Gateway mode*, requests are always made to the Cosmos DB gateway, which forwards it to the corresponding data partitions. In *Direct connectivity mode*, the client fetches the mapping of tables to partitions, and requests are made directly against data partitions. We recommend Direct, the default mode. Cosmos DB supports two connection protocols: `HTTPS` and `TCP`, which is the default. `TCP` is recommended because it's more lightweight.|
|Configure preferred locations.|Setting preferred locations can improve query performance. To take advantage of global distribution, client applications can specify the ordered preference list of regions to be used to perform document operations, which can be done by setting the connection policy. Based on the Cosmos DB account configuration, current regional availability and the preference list specified, the most optimal endpoint will be chosen by the SQL SDK to perform write and read operations. This preference list is specified when initializing a connection using the SQL SDKs. The SDKs accept an optional parameter, `PreferredLocations`, that is an ordered list of Azure regions. The SDK will automatically send all writes to the current write region. All reads will be sent to the first available region in the `PreferredLocations` list. If the request fails, the client will fail down the list to the next region, and so on. The SDKs will only attempt to read from the regions specified in `PreferredLocations`.|
|Specify index precisions.|Setting these values appropriately can improve query performance and reduce throughput requests. You can use index precision to make trade-offs between index storage overhead and query performance. For numbers, we recommend using the default precision configuration of `-1`(maximum). Because numbers are `8` bytes in JSON, this is equivalent to a configuration of `8` bytes. Choosing a lower value for precision, such as `1` through `7`, means that values within some ranges map to the same index entry. You reduce index storage space, but query execution might have to process more documents. It consumes more throughput in request units. Index precision configuration has more practical application with string ranges. Because strings can be any arbitrary length, the choice of the index precision might affect the performance of string range queries. It also may affect the amount of index storage space that's required. String Range indexes can be configured with `1` through `100` or `-1` (maximum).|
|*Existing applications*: Find the normalized request unit consumption metric of your database or container.|*Normalized* usage is a measure of how much you're currently using your standard (manual) provisioned throughput.|
|Set provisioned `RU/s` to `T` for all hours in a month.|If you set provisioned `RU/s` to `T` and use the full amount for `66%` of the hours or more, it's estimated you'll save with standard (manual) provisioned `RU/s`. If you set autoscale max `RU/s` to `Tmax` and use the full amount `Tmax` for `66%` of the hours or less, it's estimated you'll save with autoscale.|
|Scale out client applications across multiple servers if client consumes more than `50,000` `RU/s`.|There could be a bottleneck because of the machine capping out on CPU or network usage.|
|Ensure the partition key spreads RU consumption and data storage evenly across all logical partitions.|This spread ensures even RU consumption and storage distribution across your physical partitions.|
|Evaluate ways to improve data performance.|Best practices for query performance: <br>- Connection policy: Use direct connection mode. <br>- Connection Policy: Use the `TCP` protocol `Call OpenAsync` to avoid startup latency on first request. <br>- Collocate clients in the same Azure region for performance. <br>- Increase number of threads and tasks. <br>- Install the most recent SDK. <br>- Use a singleton Cosmos DB client for the lifetime of your application. <br>- Increase `System.Net` MaxConnections per host when using Gateway mode. <br>- Tune parallel queries for partitioned collections. <br>- Turn on server-side GC. <br>- Implement backoff at `RetryAfter` intervals. <br>- Scale out your client-workload. <br>- Cache document URIs for lower read latency. <br>- Tune the page size for queries and read feeds for better performance. <br>- Use 64-bit host processing. <br>- Exclude unused paths from indexing for faster writes. <br>- Measure and tune for lower request units and second usage. <br>- Handle rate limiting and request rates that are too large. <br>- Design for smaller documents for higher throughput.|
|Configure data replication to ensure Cosmos DB meets the SLAs|If you've replicated your data in more than one data center, Cosmos DB automatically rolls over your operations should a regional data center go offline. You can create a prioritized list of failover regions using the regions in which your data is replicated. Even within a single data center, Cosmos DB automatically replicates data for high availability giving you the choice of consistency levels.|

## Source artifacts

To check for `cosmosdb` instances where automatic failover isn't enabled, use the following query:

```sql
Resources
|where  type =~ 'Microsoft.DocumentDb/databaseAccounts'
|where properties.enableAutomaticFailover!=True
```

Use the following query to see the list of multiregion writes:

```sql
resources
| where type == "microsoft.documentdb/databaseaccounts"
 and properties.enableMultipleWriteLocations == "true"
```

To view consistency levels for your Cosmos DB accounts, use the following query:

```sql
Resources
| project name, type, location, consistencyLevel = properties.consistencyPolicy.defaultConsistencyLevel 
| where type == "microsoft.documentdb/databaseaccounts" 
| order by name asc
```

To check if multilocation isn't selected, use the following query:

```sql
Resources
|where  type =~ 'Microsoft.DocumentDb/databaseAccounts'
|where array_length( properties.locations) <=1
```

## Learn more

- [High Availability in Cosmos DB](/azure/cosmos-db/high-availability)
- [Autoscale FAQ](/azure/cosmos-db/autoscale-faq)
- [Performance Tips for Cosmos DB](/azure/cosmos-db/sql/performance-tips)

## Next step

> [!div class="nextstepaction"]
> [Cosmos DB and operational excellence](operational-excellence.md)
