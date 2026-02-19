---
title: Online Transaction Processing (OLTP)
description: Learn about atomicity, consistency, and other features of online transaction processing (OLTP), which manages transactional data while supporting querying.
author: hz4dkr
ms.author: callard
ms.date: 02/06/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-data
---

# Online transaction processing (OLTP)

The management of transactional data by using computer systems is referred to as online transaction processing (OLTP). OLTP systems record business interactions as they occur in the day-to-day operation of the organization, and support querying of this data to make inferences.

## Transactional data

Transactional data is information that tracks the interactions related to an organization's activities. These interactions are typically business transactions, such as payments received from customers, payments made to suppliers, products moving through inventory, orders taken, or services delivered. Transactional events, which represent the transactions themselves, typically contain a time dimension, some numerical values, and references to other data.

Transactions typically need to be *atomic* and *consistent*. Atomicity means that an entire transaction always succeeds or fails as one unit of work, and is never left in a half-completed state. If a transaction can't be completed, the database system must roll back any steps that were already done as part of that transaction. In a traditional relational database management system (RDBMS), this rollback happens automatically when a transaction can't complete. Consistency means that transactions always leave the data in a valid state. These transactions are informal descriptions of atomicity and consistency. There are more formal definitions of these properties, such as [atomic, consistent, isolated, and durable (ACID)](https://en.wikipedia.org/wiki/ACID).

Transactional databases can support strong consistency for transactions by using various locking strategies, such as pessimistic locking. These strategies help ensure that all data remains consistent within the context of the workload, for all users and processes.

The most common deployment architecture that uses transactional data is the data store tier in a three-tier architecture. A three-tier architecture typically consists of a presentation tier, business logic tier, and data store tier. A related deployment architecture is the [N-tier](../../guide/architecture-styles/n-tier.md) architecture, which can have multiple middle-tiers handling business logic.

## Typical traits of transactional data

Transactional data tends to have the following traits.

| Requirement | Description |
| --- | --- |
| Normalization | Highly normalized |
| Schema | Schema on write, enforced |
| Consistency | Strong consistency, ACID guarantees |
| Integrity | High integrity |
| Uses transactions | Yes |
| Locking strategy | Pessimistic or optimistic|
| Updateable | Yes |
| Appendable | Yes |
| Workload | Heavy writes, moderate reads |
| Indexing | Primary and secondary indexes |
| Datum size | Small to medium sized |
| Query flexibility | Highly flexible |
| Scale | Small (MBs) to large (a few TBs) |

## When to use this solution

Choose OLTP when you need to efficiently process and store business transactions and immediately make them available to client applications in a consistent way. Use this architecture when any tangible delay in processing has a negative effect on the day-to-day operations of the business.

OLTP systems are designed to efficiently process and store transactions, and query transactional data. The goal of efficiently processing and storing individual transactions by an OLTP system is partly accomplished through data normalization, which breaks up the data into smaller, less redundant chunks. This step enables the OLTP system to process large numbers of transactions independently. It also avoids extra processes required to maintain data integrity in the presence of redundant data.

## Challenges

An OLTP system can create a few challenges:

- When you run analytics against the data that rely on aggregate calculations over millions of individual transactions, it's very resource-intensive for an OLTP system. They can be slow to run and cause a slow-down by blocking other transactions in the database. As a result, OLTP systems aren't always ideal for handling aggregates over large amounts of distributed data. But there are exceptions, such as a well-planned schema.

- When you conduct analytics and reporting on data that's highly normalized, the queries tend to be complex, because most queries need to denormalize the data by using joins. The increased normalization can make it difficult for business users to query without the help of a database administrator (DBA) or data developer.

- When you store the history of transactions indefinitely or store too much data in any one table, it can lead to slow query performance, depending on the number of transactions that you store. The common solution is to maintain a relevant window of time (such as the current fiscal year) in the OLTP system and offload historical data to other systems, such as a data mart or [data warehouse](./data-warehousing.yml).

## OLTP in Azure

Applications such as websites hosted in [App Service Web Apps](/azure/app-service/overview), REST APIs running in App Service, and mobile or desktop applications typically communicate with the OLTP system by way of a REST API intermediary.

In practice, most workloads aren't entirely OLTP. They often include an analytical component as well and require real-time reporting, such as running reports against the operational system. This workload is referred to as hybrid transactional and analytical processing (HTAP). For more information, see [Online analytical processing (OLAP)](./online-analytical-processing.md).

In Azure, the following data stores meet the core requirements for OLTP and the management of transaction data:

- [Azure SQL Database](/azure/sql-database/)
- [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/)
- [SQL Server on Azure VM](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview)
- [Azure Database for MySQL](/azure/mysql/)
- [Azure Database for PostgreSQL](/azure/postgresql/)
- [Azure Cosmos DB](/azure/cosmos-db/)

## Key selection criteria

To narrow the choices, start by answering the following questions:

- Do you want a managed service rather than managing your own servers?

- Does your solution have specific dependencies for Microsoft SQL Server, MySQL, or PostgreSQL compatibility? Your application might limit the data stores you can choose based on the drivers it supports for communicating with the data store, or the assumptions it makes about which database is used.

- Are your write throughput requirements high? If yes, choose an option that provides in-memory tables or global distribution capabilities like Azure Cosmos DB.

- Is your solution multitenant? If so, consider options that support capacity pools. Multiple database instances draw from an elastic pool of resources, instead of fixed resources per database. Elastic Pools can help you better distribute capacity across all database instances and make your solution more cost effective. Azure Cosmos DB offers multiple isolation models for multitenant scenarios.

- Does your data need to be readable with low latency in multiple regions? If yes, choose an option that supports readable secondary replicas or global distribution.

- Does your database need to be highly available across geo-graphic regions? If yes, choose an option that supports geographic replication. Also consider the options that support automatic failover from the primary replica to a secondary replica.

- Does your workload require guaranteed ACID transactions? If you work with nonrelational data, consider Azure Cosmos DB, which provides ACID guarantees through transactional batch operations within a logical partition.

- Does your database have specific security needs? If yes, examine the options that provide capabilities like row-level security, data masking, and transparent data encryption.

- Does your solution require distributed transactions? If yes, consider elastic transactions within Azure SQL Database and SQL Managed Instance. SQL Managed Instance also supports traditional calls through the Microsoft Distributed Transaction Coordinator (MSDTC).

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Charles Allard](https://www.linkedin.com/in/charles-allard-7004a9/) | Cloud Solutions Architect
- [Amber Sitko](https://www.linkedin.com/in/ambers/) | Cloud Solutions Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Cosmos DB transactional batch operations](/azure/cosmos-db/transactional-batch)
- [Consistency levels in Azure Cosmos DB](/azure/cosmos-db/consistency-levels)
- [Introduction to Memory-Optimized Tables](/sql/relational-databases/in-memory-oltp/introduction-to-memory-optimized-tables)
- [In-Memory OLTP overview and usage scenarios](/sql/relational-databases/in-memory-oltp/overview-and-usage-scenarios)
- [Optimize performance by using in-memory technologies in Azure SQL Database and Azure SQL Managed Instance](/azure/azure-sql/database/in-memory-oltp-overview)
- [Distributed transactions across cloud databases](/azure/azure-sql/database/elastic-transactions-overview)

## Related resources

- [Transactional Outbox pattern with Azure Cosmos DB](../../databases/guide/transactional-outbox-cosmos.yml)
- [Azure Data Architecture Guide](../index.md)
- [Multitenancy and Azure Cosmos DB](../../guide/multitenant/service/cosmos-db.md)
