---
title: Cosmos DB and operational excellence
description: Focuses on the Cosmos DB service used in the Data solution to provide best-practice, configuration recommendations, and design considerations related to Operational Excellence.
author: v-stacywray
ms.date: 11/29/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - cosmos-db
categories:
  - data
  - management-and-governance
---

# Cosmos DB and operational excellence

[Cosmos DB](https://azure.microsoft.com/services/cosmos-db/#overview) is a fully managed NoSQL database for modern app development.

Key features include:

- [Guaranteed speed at any scale](/azure/cosmos-db/introduction#guaranteed-speed-at-any-scale)
- [Simplified application development](/azure/cosmos-db/introduction#simplified-application-development)
- [Mission-critical ready](/azure/cosmos-db/introduction#mission-critical-ready)
- [Fully managed and cost effective](/azure/cosmos-db/introduction#fully-managed-and-cost-effective)

To understand how Cosmos DB promotes operational excellence for your application workload, reference the following articles:

- [Monitor Azure Cosmos DB](/azure/cosmos-db/monitor-cosmos-db)
- [Monitor and debug with insights in Azure Cosmos DB](/azure/cosmos-db/use-metrics)
- [Visualize Azure Cosmos DB data by using the Power BI connector](/azure/cosmos-db/sql/powerbi-visualize)

The following sections include design considerations, a configuration checklist, recommended configuration options, and source artifacts specific to Cosmos DB, and operational excellence.

## Design considerations

Cosmos DB includes the following design considerations:

- SLA for read availability for Database Accounts spanning two or more Azure regions.
- SLAs for throughput, consistency, availability, and latency.
- SLA for both read and write availability with the configuration of multiple Azure regions as writable endpoints.

For more granular information specific to this product, reference [Cosmos DB Service Level Agreements](https://azure.microsoft.com/support/legal/sla/cosmos-db/v1_3/).

## Checklist

**Have you configured Cosmos DB with operational excellence in mind?**

> [!div class="checklist"]
> - Monitor for normal and abnormal activity.
> - If multi-master option is enabled on Cosmos DB, it's important to understand [Conflict Types and Resolution Policies](/azure/cosmos-db/conflict-resolution-policies).
> - Start with, Session, the default consistency level.
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

## Configuration recommendations

Explore the following table of recommendations to optimize operational excellence for your Cosmos DB configuration:

|Recommendation|Description|
|--------------|-----------|
|Monitor for normal and abnormal activity.|The Azure Activity Log is a subscription log that provides insight into subscription-level events that have occurred in Azure. The Activity Log reports control plane events for your subscriptions under the Administrative category. Using the Activity Log, you can determine the *what*, *who*, and *when* for any write operations (`PUT`, `POST`, `DELETE`) taken on the resources in your subscription. You can also understand the status of the operation and other relevant properties. The Activity Log differs from Diagnostic Logs. Activity Logs provide data about the operations on a resource from the outside (the *control plane*). In the Azure Cosmos DB context, some of the control plane operations include create collection, list keys, delete keys, list database, and more. Diagnostic Logs are emitted by a resource and provide information about the operation of that resource (the *data plane*). Some of the data plane diagnostic log examples include delete, insert, ReadFeed operation, and more.|
|Start with, Session, the default consistency level.|It's the recommended consistency level to start with as it receives data later, but in the same order as the writes.|
|*Existing applications*: Find the normalized request unit consumption metric of your database or container.|*Normalized* usage is a measure of how much you're currently using your standard (manual) provisioned throughput.|
|Set provisioned `RU/s` to `T` for all hours in a month.|If you set provisioned `RU/s` to `T` and use the full amount for `66%` of the hours or more, it's estimated you'll save with standard (manual) provisioned `RU/s`. If you set autoscale max `RU/s` to `Tmax` and use the full amount `Tmax` for `66%` of the hours or less, it's estimated you'll save with autoscale.|
|Scale out client applications across multiple servers if client consumes more than `50,000` `RU/s`.|There could be a bottleneck because of the machine capping out on CPU or network usage.|
|Ensure the partition key spreads RU consumption and data storage evenly across all logical partitions.|This spread ensures even RU consumption and storage distribution across your physical partitions.|

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

- [Autoscale FAQ](/azure/cosmos-db/autoscale-faq)
- [Performance Tips for Cosmos DB](/azure/cosmos-db/sql/performance-tips)

## Next step

> [!div class="nextstepaction"]
> [Azure Stack Hub and reliability](../../hybrid/azure-stack-hub/reliability.md)
