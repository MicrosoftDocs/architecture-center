---
title: Partitioning data for performance optimization
description: Partitioning considerations for performance optimization
author: v-aangie
ms.date: 01/11/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Partitioning data for performance optimization

Data partitioning can optimize performance, improve scalability, and reduce contention by lowering the taxation of database operations. It can also provide a mechanism for dividing data by usage pattern. For example, you can archive older data in cheaper data storage. Data partitioning involves conversations and planning between developers and database administrators.

For more reasons why you may want to partition, see [Why partition data?](/azure/architecture/best-practices/data-partitioning#why-partition-data)

## Determine acceptable performance optimization

There is almost no limit to how much an application can be performance tuned. How do you know when you have tuned an application enough? To find your limit, use the 80/20 rule. Generally, 80% of the application can be optimized by focusing on just 20%. After optimizing 20%, a company typically sees a diminishing return on further optimization. The question you should answer is how much of the remaining 80% of the application is worth optimizing for the business. For example, how much will optimizing the remaining 80% help the business reach its goals of customer acquisition, retention, sales, etc.? The business must determine its own realistic definition of "acceptable."

## Types of partitioning

You can partition to hold a specific subset of the data (e.g., all the orders for a set of customers), hold a subset of field which are divided according to their pattern of use (e.g., frequently accessed fields versus less frequently accessed fields), or aggregate data according to how it is used by each bounded context in the system (e.g., an e-commerce system might store invoice data in one partition and product inventory data in another).

To learn more about the main types of partitioning, see [Horizontal, vertical, and functional data partitioning](/azure/architecture/best-practices/data-partitioning).

## Strategies for data partitioning

Partitioning adds complexity to the design and development of your system. Consider partitioning as a fundamental part of system design even if the system initially contains only a single partition. If you address partitioning as an afterthought, it will be more challenging because you already have a live system to maintain:

- Data access logic will need to be modified.
- Large quantities of existing data may need to be migrated, to distribute it across partitions.
- Users expect to be able to continue using the system during the migration.

Different strategies are used to partition data in various Azure data stores to help improve performance. Click the data storage links below for details.

- [Partitioning Azure SQL Databases](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-sql-database)
- [Partitioning Azure table storage](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-table-storage)
- [Partitioning Azure blob storage](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-blob-storage) 
- [Partitioning Azure storage queues](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-storage-queues)
- [Partitioning Azure Service Bus](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-service-bus)
- [Partitioning Cosmos DB](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-cosmos-db)
- [Partitioning Azure Search](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-search)
- [Partitioning Azure Cache for Redis](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-cache-for-redis)
- [Partitioning Azure Service Fabric](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-service-fabric)
- [Partitioning Azure Event Hubs](/azure/architecture/best-practices/data-partitioning-strategies#partitioning-azure-event-hubs)

To learn about these strategies, see [Application design considerations](/azure/architecture/best-practices/data-partitioning#application-design-considerations).

## Next steps
> [!div class="nextstepaction"]
> [Sustain](/azure/architecture/framework/scalability/optimize-sustain)
