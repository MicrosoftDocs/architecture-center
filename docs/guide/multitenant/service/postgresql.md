---
title: Azure Database for PostgreSQL considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Database for PostgreSQL that are useful when working with multitenanted systems, and it provides links to guidance and examples.
author: PlagueHO
ms.author: dascottr
ms.date: 07/07/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-resource-manager
categories:
 - data
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Database for PostgreSQL

Many multitenant solutions on Azure use the open-source relational database management system Azure Database for PostgreSQL. In this article, we review the features of Azure Database for PostgreSQL that are useful when working with multitenant systems. The article also links to guidance and examples for how to use Azure Database for PostgreSQL, in a multitenant solution.

## Deployment modes

There are two deployment modes available for Azure Database for PostgreSQL that are suitable for use with multitenant applications:

- [Flexible Server](/azure/postgresql/flexible-server/) - This is a good choice for most multitenant deployments that don't require the high scalability that's provided by Azure Cosmos DB for PostgreSQL.
- [Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/) - An Azure managed database service designed for solutions requiring a high level of scale, which often includes multitenanted applications. This service is part of the Azure Cosmos DB family of products.

> [!NOTE]
> Azure Database for PostgreSQL - Single Server is on the retirement path and is [scheduled for retirement by March 28, 2025](https://azure.microsoft.com/updates/azure-database-for-postgresql-single-server-will-be-retired-migrate-to-flexible-server-by-28-march-2025/). It is not recommended for new multitenant workloads.

## Features of Azure Database for PostgreSQL that support multitenancy

When you're building a multitenant application using Azure Database for PostgreSQL, there are a number of features that you can use to enhance the solution.

> [!NOTE]
> Some features are only available in specific [deployment modes](#deployment-modes). These features are indicated in the guidance below.

### Row-level security

Row-level security is useful for enforcing tenant-level isolation, when you use shared tables. In PostgreSQL, row-level security is implemented by applying _row security policies_ to tables to restrict access to rows by tenant.

There maybe a slight performance impact when implementing row-level security on a table. Therefore, additional indexes might need to be created on tables with row-level security enabled to ensure performance is not impacted. It is recommended to use performance testing techniques to validate that your workload meets your baseline performance requirements when row-level security is enabled.

More information:

- [Azure Database for PostgreSQL Flexible Server row-level security](/azure/postgresql/flexible-server/concepts-security#row--level-security)

### Horizontal scaling with sharding

The [Sharding pattern](/azure/architecture/patterns/sharding) enables you to scale your workload across multiple databases or database servers.

Solutions that need a very high level of scale can use Azure Cosmos DB for PostgreSQL. This deployment mode enables horizontal sharding of tenants across multiple servers (nodes). By using _distributed tables_ in multitenant databases, you can ensure all data for a tenant is stored on the same node, which increases query performance.

> [!NOTE]
> From October 2022, Azure Database for PostgreSQL Hyperscale (Citus) has been rebranded as Azure Cosmos DB for PostgreSQL and [moved into the Cosmos DB family of products](/azure/postgresql/hyperscale/moved).

More information:

- [Design a multi-tenant database using Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/tutorial-design-database-multi-tenant)
- [Distributed tables](/azure/cosmos-db/postgresql/concepts-nodes#type-1-distributed-tables)
- Choosing a [distribution column](/azure/cosmos-db/postgresql/howto-choose-distribution-column) in a distributed table.
- A guide to using [Citus for multitenant applications](https://docs.citusdata.com/en/v10.2/use_cases/multi_tenant.html).

### Connection pooling

Postgres uses a process-based model for connections. This model makes it inefficient to maintain large numbers of idle connections. Some multitenant architectures require a large number of active connections, which will negatively impact the performance of the Postgres server.

Connection pooling via PgBouncer is installed by default in Azure Database for PostgreSQL [Flexible Server](/azure/postgresql/flexible-server).

More information:

- [PgBouncer in Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/hyperscale/concepts-connection-pool)
- [Connection pooling in Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/concepts-connection-pool)
- [Steps to install and set up PgBouncer connection pooling proxy with Azure Database for PostgreSQL](https://techcommunity.microsoft.com/t5/azure-database-for-postgresql/steps-to-install-and-setup-pgbouncer-connection-pooling-proxy/ba-p/730555)

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal author:

- [Daniel Scott-Raynsford](http://linkedin.com/in/dscottraynsford) | Partner Technology Strategist

Other contributors:

- [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [Paul Burpo](https://www.linkedin.com/in/paul-burpo/) | Principal Customer Engineer, FastTrack for Azure ISVs
- [Assaf Fraenkel](https://www.linkedin.com/in/assaf-fraenkel/) | Senior Engineer/Data Architect, Azure FastTrack for ISVs and Start-ups

_To see non-public LinkedIn profiles, sign in to LinkedIn._

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).
