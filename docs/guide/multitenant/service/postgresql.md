---
title: Azure Database for PostgreSQL considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Database for PostgreSQL that are useful when working with multitenanted systems, and it provides links to guidance and examples.
author: PlagueHO
ms.author: dascottr
ms.date: 02/04/2022
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

There are three deployment modes available for Azure Database for PostgreSQL that are suitable for use with multitenant applications:

- [Single Server](/azure/postgresql/single-server) - The basic PostgreSQL service that has a broad set of supported features and [service limits](/azure/postgresql/concepts-limits).
- [Flexible Server](/azure/postgresql/flexible-server/) - Supports higher [service limits](/azure/postgresql/flexible-server/concepts-limits) and larger SKUs than single server. This is a good choice for most multitenant deployments that don't require the high scalability that's provided by Hyperscale (Citus).
- [Hyperscale (Citus)](/azure/postgresql/hyperscale/) - Azure managed database service designed for solutions requiring a high level of scale, which often includes multitenanted applications.

## Features of Azure Database for PostgreSQL that support multitenancy

When you're building a multitenant application using Azure Database for PostgreSQL, there are a number of features that you can use to enhance the solution.

> [!NOTE]
> Some features are only available in specific [deployment modes](#deployment-modes). These features are indicated in the guidance below.

### Row-level security

Row-level security is useful for enforcing tenant-level isolation, when you use shared tables. In PostgreSQL, row-level security is implemented by applying _row security policies_ to tables to restrict access to rows by tenant.

More information:

- [Row security policies in PostgreSQL](https://www.postgresql.org/docs/14/ddl-rowsecurity.html)

### Horizontal scaling with sharding

The [Sharding pattern](/azure/architecture/patterns/sharding) enables you to scale your workload across multiple databases or database servers.

Solutions that need a very high level of scale can use Azure Database for PostgreSQL Hyperscale (Citus). This deployment mode enables horizontal sharding of tenants across multiple servers (nodes). By using _distributed tables_ in multitenant databases, you can ensure all data for a tenant is stored on the same node, which increases query performance.

More information:

- [Designing a multitenant database in Hyperscale (Citus)](/azure/postgresql/tutorial-design-database-hyperscale-multi-tenant)
- [Distributed tables](/azure/postgresql/hyperscale/concepts-nodes#type-1-distributed-tables)
- Choosing a [distribution column](/azure/postgresql/hyperscale/concepts-choose-distribution-column) in a distributed table.
- A guide to using [Citus for multitenant applications](https://docs.citusdata.com/en/v10.2/use_cases/multi_tenant.html).

### Connection pooling

Postgres uses a process-based model for connections. This model makes it inefficient to maintain large numbers of idle connections. Some multitenant architectures require a large number of active connections, which will negatively impact the performance of the Postgres server.

Connection pooling via PgBouncer is installed by default in Azure Database for PostgreSQL [Flexible Server](/azure/postgresql/flexible-server) and [Hyperscale (Citus)](/azure/postgresql/hyperscale). Connection pooling via PgBouncer is not built-in to [Single Server](/azure/postgresql/single-server), but it can be installed on a separate server.

More information:

- [PgBouncer in Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/hyperscale/concepts-connection-pool)
- [Azure Database for PostgreSQL – Hyperscale (Citus) connection pooling](/azure/postgresql/flexible-server/concepts-pgbouncer)
- [Steps to install and set up PgBouncer connection pooling proxy with Azure Database for PostgreSQL](https://techcommunity.microsoft.com/t5/azure-database-for-postgresql/steps-to-install-and-setup-pgbouncer-connection-pooling-proxy/ba-p/730555)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:
 * [Daniel Scott-Raynsford](http://linkedin.com/in/dscottraynsford) | Partner Technology Strategist

Other contributors:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).
