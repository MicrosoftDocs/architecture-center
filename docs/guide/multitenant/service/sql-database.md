---
title: Azure SQL Database considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure SQL Database that are useful when working with multitenanted systems, and links to guidance and examples for how to use Azure SQL in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 10/08/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
  - security
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure SQL Database

Multitenant solutions on Azure commonly use Azure SQL Database. On this page, we describe some of the features of Azure SQL Database that are useful when working with multitenanted systems, and we link to guidance and examples for how to use Azure SQL in a multitenant solution.

## Guidance

The Azure SQL Database team has published extensive guidance on implementing multitenant architectures with Azure SQL Database. See [Multi-tenant SaaS patterns with Azure SQL Database](/azure/azure-sql/database/saas-tenancy-app-design-patterns). Also, consider the guidance for [partitioning Azure SQL databases](../../../best-practices/data-partitioning-strategies.md#partitioning-azure-sql-database).

## Features of Azure SQL Database that support multitenancy

Azure SQL Database includes a number of features that support multitenancy.

### Elastic pools

Elastic pools enable you to share compute resources between a number of databases on the same server. By using elastic pools, you can achieve performance elasticity for each database, while also achieving cost efficiency by sharing your provisioned resources across databases. Elastic pools provide built-in protections against the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/index.md).

More information:

* [SQL Database elastic pools](/azure/azure-sql/database/elastic-pool-overview)
* [Resource management in dense elastic pools](/azure/azure-sql/database/elastic-pool-resource-management)
* [Disaster recovery strategies for applications using SQL Database elastic pools](/azure/azure-sql/database/disaster-recovery-strategies-for-applications-with-elastic-pool)

### Elastic database tools

The [Sharding pattern](../../../patterns/sharding.md) enables you to scale your workload across multiple databases. Azure SQL Database provides tools to support sharding. These tools include the management of *shard maps* (a database that tracks the tenants assigned to each shard), as well as initiating and tracking queries and management operations on multiple shards by using *elastic jobs*.

More information:

* [Multi-tenant applications with elastic database tools and row-level security](/azure/azure-sql/database/saas-tenancy-elastic-tools-multi-tenant-row-level-security)
* [Scaling out with Azure SQL Database](/azure/azure-sql/database/elastic-scale-introduction)
* [Elastic database jobs](/azure/azure-sql/database/job-automation-overview)
* The [Elastic Jobs tutorial](/azure/azure-sql/database/elastic-jobs-overview) describes the process of creating, configuring, and managing elastic jobs.

### Row-level security

Row-level security is useful for enforcing tenant-level isolation, when you use shared tables.

More information:

* [Video overview](https://azure.microsoft.com/resources/videos/row-level-security-in-azure-sql-database)
* [Documentation](/sql/relational-databases/security/row-level-security)
* [Multi-tenant applications with elastic database tools and row-level security](/azure/azure-sql/database/saas-tenancy-elastic-tools-multi-tenant-row-level-security)

### Key management

The Always Encrypted feature provides the end-to-end encryption of your databases. If your tenants require they supply their own encryption keys, consider deploying separate databases for each tenant and consider enabling the Always Encrypted feature.

More information:

* [Always Encrypted](/sql/relational-databases/security/encryption/always-encrypted-database-engine)

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.md).

## Related resources

* [Data partitioning strategies for Azure SQL Database](../../../best-practices/data-partitioning-strategies.md#partitioning-azure-sql-database)
* **Case study:** [Running 1M databases on Azure SQL for a large SaaS provider: Microsoft Dynamics 365 and Power Platform](https://devblogs.microsoft.com/azure-sql/running-1m-databases-on-azure-sql-for-a-large-saas-provider-microsoft-dynamics-365-and-power-platform/)
* **Sample:** The [Wingtip Tickets SaaS application](/azure/azure-sql/database/saas-tenancy-welcome-wingtip-tickets-app) provides three multi-tenant examples of the the same app; each explores a different database tenancy pattern on Azure SQL Database. The first uses a standalone application, per tenant with its own database. The second uses a multi-tenant app with a database, per tenant. The third sample uses a multi-tenant app with sharded multi-tenant databases.
* **Video:** [Multitenant design patterns for SaaS applications on Azure SQL Database](https://www.youtube.com/watch?v=jjNmcKBVjrc)
