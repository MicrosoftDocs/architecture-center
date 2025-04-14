---
title: Azure SQL Database considerations for multitenancy
description: This article describes the features of Azure SQL Database that are useful when you design a multitenant system, and links to guidance and examples for how to use Azure SQL in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 03/18/2025
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
products:
  - azure
  - azure-sql-database
categories:
  - data
ms.custom:
  - guide
  - arb-saas
---

# Multitenancy and Azure SQL Database

Multitenant solutions on Azure commonly use Azure SQL Database. On this page, we describe some of the features of Azure SQL Database that are useful when you design a multitenant system. We also link to guidance and examples for how to use Azure SQL in a multitenant solution.

## Guidance

The Azure SQL Database team publishes extensive guidance on implementing multitenant architectures with Azure SQL Database. See [Multitenant SaaS patterns with Azure SQL Database](/azure/azure-sql/database/saas-tenancy-app-design-patterns). Also, consider the guidance for [partitioning Azure SQL databases](../../../best-practices/data-partitioning-strategies.yml#partitioning-azure-sql-database).

## Features of Azure SQL Database that support multitenancy

Azure SQL Database includes many features that support multitenancy.

### Elastic pools

Elastic pools enable you to share compute resources between many databases on the same server. By using elastic pools, you can achieve performance elasticity for each database, while also achieving cost efficiency by sharing your provisioned resources across databases. Elastic pools provide built-in protections against the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml).

More information:

* [SQL Database elastic pools](/azure/azure-sql/database/elastic-pool-overview)
* [Resource management in dense elastic pools](/azure/azure-sql/database/elastic-pool-resource-management)
* [Disaster recovery strategies for applications using SQL Database elastic pools](/azure/azure-sql/database/disaster-recovery-strategies-for-applications-with-elastic-pool)

### Elastic database tools

The [Sharding pattern](../../../patterns/sharding.yml) enables you to scale your workload across multiple databases. Azure SQL Database provides tools to support sharding. These tools include the management of *shard maps* (a database that tracks the tenants assigned to each shard). They also include initiating and tracking queries and management operations on multiple shards by using *elastic jobs*.

More information:

* [Multitenant applications with elastic database tools and row-level security](/azure/azure-sql/database/saas-tenancy-elastic-tools-multi-tenant-row-level-security)
* [Scaling out with Azure SQL Database](/azure/azure-sql/database/elastic-scale-introduction)
* [Elastic database jobs](/azure/azure-sql/database/job-automation-overview)
* The [Elastic Jobs tutorial](/azure/azure-sql/database/elastic-jobs-overview) describes the process of creating, configuring, and managing elastic jobs.

### Row-level security

Row-level security is useful for enforcing tenant-level isolation, when you use shared tables.

More information:

* [Video overview](https://azure.microsoft.com/resources/videos/row-level-security-in-azure-sql-database)
* [Documentation](/sql/relational-databases/security/row-level-security)
* [Multitenant applications with elastic database tools and row-level security](/azure/azure-sql/database/saas-tenancy-elastic-tools-multi-tenant-row-level-security)

### Key management

The Always Encrypted feature provides the end-to-end encryption of your databases. If your tenants require they supply their own encryption keys, consider deploying separate databases for each tenant and consider enabling the Always Encrypted feature.

More information:

* [Always Encrypted](/sql/relational-databases/security/encryption/always-encrypted-database-engine)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Paul Burpo](https://linkedin.com/in/paul-burpo) | Principal Customer Engineer, FastTrack for Azure
 * [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer

Other contributors:

 * [Silvano Coriani](https://www.linkedin.com/in/scoriani) | Principal Program Manager, Azure SQL
 * [Dimitri Furman](https://www.linkedin.com/in/dimitri-furman-200a555) | Principal Program Manager, Azure SQL
 * [Sanjay Mishra](https://www.linkedin.com/in/sanjaymishra0) | Principal Group Program Manager, Azure SQL
 * [Arsen Vladimirskiy](https://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).

## Related resources

* [Data partitioning strategies for Azure SQL Database](../../../best-practices/data-partitioning-strategies.yml#partitioning-azure-sql-database)
* **Case study:** [Running 1M databases on Azure SQL for a large SaaS provider: Microsoft Dynamics 365 and Power Platform](https://devblogs.microsoft.com/azure-sql/running-1m-databases-on-azure-sql-for-a-large-saas-provider-microsoft-dynamics-365-and-power-platform/)
* **Sample:** The [Wingtip Tickets SaaS application](/azure/azure-sql/database/saas-tenancy-welcome-wingtip-tickets-app) provides three multitenant examples of the same app; each explores a different database tenancy pattern on Azure SQL Database. The first uses a standalone application, per tenant with its own database. The second uses a multitenant app with a database, per tenant. The third sample uses a multitenant app with sharded multitenant databases.
* **Video:** [Multitenant design patterns for SaaS applications on Azure SQL Database](https://www.youtube.com/watch?v=jjNmcKBVjrc)
