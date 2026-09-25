---
title: Index Table Pattern
description: Find out how to use the Index Table pattern to improve query performance by creating indexes over data store fields that queries frequently reference.
author: anaharris-ms
ms.author: pnp
ms.date: 06/09/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Index Table pattern

Create and maintain separate lookup tables for data that applications frequently use in queries when a data store doesn't provide suitable secondary indexes. This approach improves read performance by avoiding full data scans when queries don't use the primary key or partition key.

## Context and problem

Many data stores organize the data for a collection of entities by using the primary key. An application can use this key to locate and retrieve data. The following figure shows an example of a data store holding customer information organized by the primary key, Customer ID.

:::image type="complex" source="./_images/index-table-figure-1.png" alt-text="Diagram that shows a customer data table organized by the primary key, Customer ID. The Customer Data column contains customer last names and towns." border="false":::
   The image shows a two-column table of customer records. The first column, Primary Key (Customer ID), contains Customer IDs 1 through 9 followed by an ellipsis, ID 1000, and another ellipsis. The second column, Customer Data, contains customer data consisting of a last name and town followed by an ellipsis. Visible examples include ID 1, which maps to the last name Smith and the town Redmond, and ID 2, which maps to the last name Jones and the town Seattle. Another row shows Smith in Chicago, and another shows Smith in Redmond. Yet another row shows Jones in Chicago.
:::image-end:::

Although the primary key is valuable for queries that fetch data based on the value of this key, an application that needs to retrieve data based on some other field can't use the primary key for that query. In the customers example, an application can't use the Customer ID primary key to retrieve customers if it queries data solely by referencing the value of some other attribute, such as the town in which the customer is located. To perform a query that references only the town, the application might have to fetch and examine every customer record, which can be a slow process.

Many relational database management systems support secondary indexes. A secondary index is a separate data structure that's organized by one or more non-primary (secondary) key fields. A secondary index indicates where the data for each indexed value is stored. The items in a secondary index are typically sorted by the value of the secondary keys to enable fast lookup of data. The database management system usually maintains these indexes automatically.

Relational databases allow multiple secondary indexes to support various query patterns. For example, in a Customers table in a relational database where the Customer ID is the primary key, it's beneficial to add a secondary index over the Town field if the application frequently looks up customers by the town where they reside.

Although secondary indexes are common in relational systems, not all data stores provide an equivalent feature. Some data stores lack secondary indexes, while others provide indexes that don't satisfy a workload's query, partitioning, or performance requirements. In these cases, applications must choose between full scans and manual index management.

## Solution

Create an index table that organizes the data by a specified key. The following section describes three common strategies for structuring an index table. The two subsequent sections describe uses for index tables in specific scenarios.

### Standard structuring strategies

The following strategies are commonly used to structure an index table. Choose a strategy based on the number of secondary indexes that your scenario requires and the nature of the queries that your application performs.

#### Complete denormalization

Complete denormalization duplicates the data in each index table but organizes it by keys other than the primary key. The following figure shows index tables that organize the same customer information by Town and LastName.

:::image type="complex" source="./_images/index-table-figure-2.png" alt-text="Diagram of index tables that duplicate customer data and organize it by Town and LastName keys." lightbox="./_images/index-table-figure-2.png" border="false":::
   The diagram shows two index tables side by side. The table on the left is organized by a Town secondary key, and the table on the right is organized by a LastName secondary key. Each table has a Customer Data column. Every row in that column duplicates a complete customer record consisting of the customer ID, last name, town, and other data represented by an ellipsis. The same customers appear in both tables, but the row order differs because each table is sorted by its own secondary key.
:::image-end:::

This strategy works well for read-heavy workloads in which data changes infrequently. As the update rate increases, maintaining every copy adds processing overhead (see [Consistency complexity](#problems-and-considerations)). For high-volume datasets, storing the copies can also require significant space.

#### Normalized index

A normalized index table organizes data by keys other than the primary key. The normalized index table references the original data by using the primary key rather than duplicating that data, as shown in the following figure. The original data is called a fact table.

> [!TIP]
> Here, *fact table* means the authoritative source table referenced by an index. It doesn't imply a [dimensional data model](/fabric/data-warehouse/dimensional-modeling-fact-tables).

:::image type="complex" source="./_images/index-table-figure-3.png" alt-text="Diagram of normalized index tables that reference a fact table by primary key instead of duplicating data." lightbox="./_images/index-table-figure-3.png" border="false":::
   The diagram contains a fact table in the center and two index tables, one on each side. The fact table organizes customer data by the primary key, Customer ID. Its Customer Data column contains customer last names, towns, and an ellipsis that represents other data. The index table on the left is organized by the Town secondary key, and the index table on the right is organized by the LastName secondary key. The Customer Reference column in each index table contains customer IDs but no customer data. Arrows connect each customer reference in the index tables to the corresponding Customer ID row in the fact table. Multiple entries for the same town or last name can point to different customer rows.
:::image-end:::

This technique saves space and reduces the overhead of maintaining duplicate data. The disadvantage is that an application has to perform two lookup operations to find data by using a secondary key. The application has to find the primary key for the data in the index table and then use the primary key to look up the data in the fact table.

#### Partial denormalization

Partial denormalization creates index tables that duplicate frequently retrieved fields and are organized by keys other than the primary key. The fact table is referenced to access less frequently accessed fields. The following figure shows how commonly accessed data is duplicated in each index table.

:::image type="complex" source="./_images/index-table-figure-4.png" alt-text="Diagram of partially normalized index tables that duplicate frequently accessed fields and reference a fact table for remaining data." lightbox="./_images/index-table-figure-4.png" border="false":::
   The diagram contains a fact table in the center and two index tables, one on each side. The fact table organizes customer data by the primary key, Customer ID, with last names, towns, and an ellipsis that represents other data in the Customer Data column. The left index table uses Town as the secondary key, with customer ID and last name in each Customer Reference row. The right index table uses LastName as the secondary key, with customer ID and town in each Customer Reference row. Arrows extend from rows in both index tables toward the center, connecting each index entry to the fact table row with the corresponding Customer ID. Crossing arrows show that entries grouped by town or last name can reference customer rows at different positions in the fact table.
:::image-end:::

This strategy balances the first two approaches. You can quickly retrieve data for common queries by using a single lookup, while the space and maintenance overhead isn't as significant as duplicating the entire dataset.

### Composite keys

Some applications frequently query data by specifying a combination of values, for example, "Find all customers that live in Redmond and that have a last name of Smith." In this situation, create index keys from multiple attributes, such as the Town and LastName attributes in this case.

Use an encoding that preserves component boundaries so that different value combinations can't produce the same key. If queries depend on key order, also ensure that the encoding preserves the required sort order under the data store's key collation rules.

The following figure shows an index table based on composite keys. The keys are sorted by Town and then by LastName for records that have the same value for Town.

:::image type="complex" source="./_images/index-table-figure-5.png" alt-text="Diagram of an index table and a fact table. The index table is organized by composite keys formed by concatenating the Town and LastName attributes." border="false":::
   The diagram contains an index table on the left and a fact table on the right. The fact table organizes customer data by the primary key, Customer ID. Each Customer Data row contains a customer last name, town, and an ellipsis indicating other data. The index table is organized by a composite key that combines Town and LastName. Its second column, Customer Reference (ID) and commonly queried data, contains a customer ID and an ellipsis. Arrows extend from index table rows to the fact table, with each arrow pointing to the Customer ID row referenced by that index entry. The crossing arrows illustrate that entries ordered by the composite key can reference customer rows at different positions in the fact table.
:::image-end:::

### Index tables over sharded data

Index tables can speed up query operations over sharded data. They're especially useful when the shard key is hashed. The following figure shows an example where the shard key is a hash of the Customer ID. The index table organizes entries by non-hashed values, Town and LastName, and stores the corresponding hashed shard key with each entry.

This arrangement supports range and ordered lookups on the non-hashed values while providing the routing information needed to retrieve each record from the correct shard. For example, a query such as "Find all customers that live in Redmond" can locate the matching items in a contiguous block in the index table. The application then follows the references to the customer data by using the shard keys stored in the index table.

:::image type="complex" source="./_images/index-table-figure-6.png" alt-text="Diagram of sharded data tables and an index table that provides quick lookup for sharded data by mapping non-hashed values to hashed shard keys." lightbox="./_images/index-table-figure-6.png" border="false":::
   The diagram contains an index table on the left and sharded customer data on the right. The sharded data shows three shards, each containing rows organized by a shard key derived from a hash of the Customer ID. Each Customer Data row in the sharded data contains a customer ID, last name, town, and an ellipsis indicating other data. The index table uses a composite key combining Town and LastName, with a Shard Key column containing the corresponding hashed shard key. Arrows extend from index entries on the left to the appropriate shard on the right, indicating which shard contains the referenced customer data. The arrows cross where index entries reference shards at different vertical positions.
:::image-end:::

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Maintenance overhead.** Maintaining secondary indexes can add significant overhead. Analyze and understand the queries that your application uses. Create index tables only when you're likely to use them regularly. Don't create speculative index tables to support queries that an application doesn't perform or performs only occasionally. As the number of query patterns grows, the number of index tables grows, and each one adds operational surface area to monitor, maintain, and debug. Weigh the query benefit of each index table against the operational cost of maintaining another derived data structure. Periodically review existing index tables to identify and remove any that are no longer being queried.

- **Storage and throughput cost.** Duplicating data in an index table increases storage costs in proportion to the number of index tables and the size of copied fields. Maintaining multiple copies of data also adds effort. Every write to an index table consumes throughput capacity, such as transactions against the storage account's limits in Azure Table Storage or request units in Azure Cosmos DB. The cost extends beyond storage to write-side throughput.

- **Double lookup penalty.** Implementing an index table as a normalized structure that references the original data requires an application to perform two lookup operations to find data. The first operation searches the index table to retrieve the primary key, and the second uses the primary key to fetch the data.

- **Consistency complexity.** If a system incorporates a number of index tables over large datasets, maintaining consistency between index tables and the original data can be difficult. If the source data and index entries can't be updated in the same transaction, design the application around an eventual consistency model. Capture each source change durably before acknowledging the write. For example, consume a database change feed, use the [Transactional Outbox pattern](../databases/guide/transactional-out-box-cosmos.md) to write an outbox record in the same transaction as the source change, or enqueue a command before changing the source data. In the command-based approach, use a worker to process the command and update the source data and its indexes. Don't update the source data and then independently publish an index-update message, because a failure between those operations can leave the index stale.

  Design the asynchronous consumer to be [idempotent](./idempotent-consumer.md), because message delivery and retries can cause the same update to run more than once. Updates for the same source record can also arrive out of order. Include a source version or sequence number in each index update, and apply an update only if it's newer than the version in the index. For deletes, retain a versioned tombstone or an equivalent high-water mark so that a delayed older update can't re-create the deleted index entry. During the interval between the source-data write and the asynchronous index update, queries against the index table can return stale references to records that have been updated or deleted in the source data, and they can omit recently added records.

- **Partitioning index tables.** Index tables might themselves be partitioned or sharded, which adds complexity to query routing and requires the partitioning strategy to align with the query patterns the index is designed to serve.

## When to use this pattern

Use this pattern when an application frequently needs to retrieve data by using a key other than the primary (or shard) key, and the data store doesn't natively support secondary indexes or its native indexes don't satisfy the workload's query, partitioning, or performance requirements.

This pattern might not be suitable when:

- **Data is volatile.** The data changes so frequently that the write rate exceeds the rate at which index tables can be asynchronously refreshed. The staleness window grows until the index is permanently out of date, making it ineffective and making the storage and throughput overhead of maintaining the index table greater than any query savings.

- **You have non-discriminating keys.** A field selected as the secondary key for an index table is nondiscriminating and can have only a small set of values (for example, a Boolean field that records whether an item is active). The index table incurs full storage and throughput cost but provides minimal query selectivity.

- **Data values have a skewed distribution.** The balance of the data values for a field selected as the secondary key for an index table is highly skewed. For example, if 90 percent of the records contain the same value in a field, then creating and maintaining an index table to look up data based on this field might create more overhead than sequentially scanning the data. However, if queries frequently target values that lie in the remaining 10 percent, this index can still be useful.

## Workload design

An architect should evaluate how to use the Index Table pattern in their workload design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) helps your workload meet its **resiliency and recovery targets** by building redundancy and preserving functionality during failures. | Asynchronous index maintenance can prevent temporary index-update failures from blocking source-data writes. Idempotent processing, dead-letter handling, monitoring, and reconciliation help restore index consistency after failures.<br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation)<br/> - [RE:10 Monitoring](/azure/well-architected/reliability/monitoring) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | Index tables help enable fast lookups on non-primary key fields without requiring full data scans. For sharded data stores, index tables can organize entries by non-hashed values to support range and ordering queries that the shard key alone can't serve efficiently.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition)<br/> - [PE:08 Data performance](/azure/well-architected/performance-efficiency/optimize-data-performance) |

As with any design decision, if this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

Consider an application that stores information about movies. Assume the catalog is large and read-heavy, each movie has one primary genre, actor queries are frequent, cast data changes infrequently, and brief index lag is acceptable. Table Storage stores each entity as a structured set of named properties. Every entity includes a `PartitionKey`, a `RowKey`, and a timestamp, and entities in the same table can have different sets of properties.

Table Storage uses a composite primary key that consists of `PartitionKey` and `RowKey`. The `PartitionKey` value determines the partition in which an entity is stored. Within a partition, the `RowKey` value uniquely identifies an entity. Table Storage is optimized for queries that specify both keys or fetch a contiguous range of row key values within one partition.

> [!TIP]
> Table Storage supports transactional updates for entities in the same table and partition through [entity group transactions](/rest/api/storageservices/performing-entity-group-transactions). A transaction can't span a fact table and a separate index table. To update a fact entity and index entities atomically, store them in the same table with the same `PartitionKey`. Entity group transactions are limited to 100 entities per batch with a maximum payload of 4 MiB.

For this example, create an Azure table with partitions for each genre by using an encoded genre identifier as the partition key and a stable, unique movie identifier as the row key. Store the genre and movie names as properties. The following figure uses readable names in place of identifiers to make the example easier to follow.

:::image type="complex" source="./_images/index-table-figure-7.png" alt-text="Diagram of movie data in Azure table partitions. Readable genre and movie names represent encoded genre partition keys and unique movie row keys." lightbox="./_images/index-table-figure-7.png" border="false":::
   The diagram shows three vertically stacked shards of an Azure table that stores movie data. From top to bottom, the shards contain Action, Comedy, and Drama movies. Within each shard, all rows have the same genre. The Partition Key column contains the genre, and the Row Key column contains readable movie names, such as Action Movie 1, Comedy Movie 1, and Drama Movie 1. The Movie Data column contains starring actors, a director, a release date, and an ellipsis indicating additional data. A brace along the right side spans all three tables and labels the tables as shards.
:::image-end:::

This approach is less effective if the application also needs to query movies by starring actor. In that case, create a separate Azure table that acts as an index table. Use an encoded, stable actor identifier as the partition key and the movie identifier as the row key. Store actor and movie names as properties. The following figure uses readable names in place of identifiers. If a movie stars more than one actor, the same movie occurs in multiple partitions.

The following figure shows the actor index table.

:::image type="complex" source="./_images/index-table-figure-8.png" alt-text="Diagram of actor partitions acting as index tables that duplicate movie data, use actors as partition keys, and use movies as row keys." lightbox="./_images/index-table-figure-8.png" border="false":::
   The diagram contains two tables: an Index Table (Actor partitions) on the left and Genre partitions on the right. The index table shows four actor partitions, with additional partitions indicated by an ellipsis. Each partition uses actor names as Partition Keys and movie names as Row Keys. The Movie Data column in each partition contains starring actors and genres. The Genre partitions table contains three shards for Action, Comedy, and Drama. Each uses genre as the Partition Key and movie name as the Row Key. The Movie Data column in each partition includes actors, director, release date, and an ellipsis. Arrows extend from individual index entries on the left to the corresponding movie rows in the genre partitions on the right. A note explains that the genre and movie name can be combined to locate complete movie details in the genre partitions.
:::image-end:::

### Design walkthrough

The movie table uses genre as its partition key, which means queries that filter by genre execute efficiently as partition scans over contiguous row key ranges. However, Table Storage supports only a single clustered index on `PartitionKey` and `RowKey`. It has no secondary indexes. A query such as "find all movies starring a specific actor" requires a full table scan across every genre partition, which is expensive at scale.

The actor index table addresses this limitation by reversing the access pattern. Each actor identifier becomes a partition key and each movie identifier becomes a row key, so actor-based queries resolve as efficient partition lookups. Because each partition holds only one actor's movies, the query returns a contiguous range of entities without scanning unrelated data.

Because movie and actor entries use separate tables and partition keys, these entries can't share an entity group transaction. Maintain the actor index through a durable asynchronous change-capture mechanism, and design the application to tolerate brief query staleness.

The index table applies partial denormalization: each entry duplicates commonly accessed fields (such as the names of other actors) so the most frequent queries can be answered from the index table alone with a single lookup. For less frequently accessed fields, the entry includes the genre partition key from the original movie table, enabling a targeted point query to the genre partition for the full record. This design balances query speed against storage cost and maintenance overhead.

## Next steps

- [Table Storage query design guidance](/azure/storage/tables/table-storage-design-for-query) describes secondary-index patterns that use `PartitionKey` and `RowKey`, including approaches for storing index entries in the same partition or in separate partitions.

- [Data partitioning strategies](../best-practices/data-partitioning-strategies.yml) explains how to select partition and row keys based on query patterns, data distribution, transaction requirements, and scalability goals.

- [Architecture strategies for optimizing data performance](/azure/well-architected/performance-efficiency/optimize-data-performance) provides guidance for evaluating query patterns, indexes, partitions, and monitoring requirements.

- [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels) describes the consistency models that are relevant when you maintain index tables in Azure Cosmos DB.

## Related resources

The following patterns might also be relevant when you implement this pattern:

- [Sharding pattern](./sharding.md). The Index Table pattern is frequently used in conjunction with data partitioned by using shards. The Sharding pattern describes how to divide a data store into a set of shards.

- [Materialized View pattern](./materialized-view.md). Instead of indexing data to support queries that summarize data, it can be more appropriate to create a materialized view of the data. This pattern describes how to generate prepopulated views over data to support efficient summary queries.

- [Transactional Outbox pattern](../databases/guide/transactional-out-box-cosmos.md). Use the Transactional Outbox pattern to help publish changes for asynchronous index maintenance reliably when source data and index entries can't be updated in one transaction.
