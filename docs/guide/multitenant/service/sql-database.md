---
title: Multitenancy and Azure SQL Database
description: This article outlines Azure SQL Database features for designing a multitenant system. It provides guidance and examples for using Azure SQL in a multitenant solution.
author: johndowns
ms.author: pnp
ms.date: 03/18/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy and Azure SQL Database

Multitenant solutions on Azure commonly use Azure SQL Database. This article outlines key SQL Database features that support multitenant system design. It also provides guidance and examples for how to implement Azure SQL in a multitenant solution.

## Guidance

The SQL Database team publishes extensive guidance for how to implement multitenant architectures by using SQL Database. For more information, see [Multitenant software as a service (SaaS) database tenancy patterns](/azure/azure-sql/database/saas-tenancy-app-design-patterns) and [Partition SQL Database](../../../best-practices/data-partitioning-strategies.yml#partitioning-azure-sql-database).

## Features of SQL Database that support multitenancy

SQL Database includes many features that support multitenancy.

### Elastic pools

Elastic pools enable you to share compute resources between multiple databases on the same server. By using elastic pools, you can achieve performance elasticity for each database. You can also maximize cost efficiency by sharing provisioned resources across multiple databases. Elastic pools provide built-in protections against the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml).

For more information, see the following resources:

- [SQL Database elastic pools](/azure/azure-sql/database/elastic-pool-overview)
- [Resource management in dense elastic pools](/azure/azure-sql/database/elastic-pool-resource-management)
- [Disaster recovery strategies for applications that use SQL Database elastic pools](/azure/azure-sql/database/disaster-recovery-strategies-for-applications-with-elastic-pool)

### Elastic database tools

You can use the [Sharding pattern](../../../patterns/sharding.yml) to scale your workload across multiple databases. SQL Database provides tools to support sharding. These tools include the management of *shard maps*, which serve as databases that track the tenants assigned to each shard. These tools also include the capability to initiate and track queries and management operations on multiple shards by using *elastic jobs*.

For more information, see:

- [Multitenant applications with elastic database tools and row-level security](/azure/azure-sql/database/saas-tenancy-elastic-tools-multi-tenant-row-level-security)
- [Scale out by using SQL Database](/azure/azure-sql/database/elastic-scale-introduction)
- [Elastic jobs](/azure/azure-sql/database/job-automation-overview)
- [Create, configure, and manage elastic jobs](/azure/azure-sql/database/elastic-jobs-overview)

### Row-level security

[Row-level security](/sql/relational-databases/security/row-level-security) helps enforce tenant-level isolation in shared tables.

For more information, see the following resources:

- [Row-level security implementation on Azure SQL](https://www.youtube.com/watch?v=QQobIo-gfmk)
- [Multitenant applications with elastic database tools and row-level security](/azure/azure-sql/database/saas-tenancy-elastic-tools-multi-tenant-row-level-security)

### Key management

The Always Encrypted feature provides end-to-end encryption for your databases. If your tenants must supply their own encryption keys, consider deploying separate databases for each tenant and enabling the [Always Encrypted](/sql/relational-databases/security/encryption/always-encrypted-database-engine) feature.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paul Burpo](https://www.linkedin.com/in/paul-burpo) | Principal Customer Engineer, FastTrack for Azure
- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Silvano Coriani](https://www.linkedin.com/in/scoriani) | Principal Program Manager, Azure SQL
- [Dimitri Furman](https://www.linkedin.com/in/dimitri-furman-200a555) | Principal Program Manager, Azure SQL
- [Sanjay Mishra](https://www.linkedin.com/in/sanjaymishra0) | Principal Group Program Manager, Azure SQL
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- **Case study:** [Run one million databases on Azure SQL for a large SaaS provider: Dynamics 365 and Microsoft Power Platform](https://devblogs.microsoft.com/azure-sql/running-1m-databases-on-azure-sql-for-a-large-saas-provider-microsoft-dynamics-365-and-power-platform/)
- **Sample:** The [Wingtip Tickets SaaS application](/azure/azure-sql/database/saas-tenancy-welcome-wingtip-tickets-app) provides three multitenant examples of the same app. Each example explores a different database tenancy pattern on SQL Database. The first example uses a standalone application, where each tenant has its own database. The second example features a multitenant app, with each tenant having a separate database. The third example includes a multitenant app that has sharded multitenant databases.
- **Video:** [Design patterns for SaaS applications on SQL Database](https://www.youtube.com/watch?v=jjNmcKBVjrc)

## Related resources

- [Architectural approaches for storage and data in multitenant solutions](../approaches/storage-data.md).
- [Data partitioning strategies for SQL Database](../../../best-practices/data-partitioning-strategies.yml#partitioning-azure-sql-database)
