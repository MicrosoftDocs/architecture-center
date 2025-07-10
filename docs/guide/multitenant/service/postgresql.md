---
title: Guidance for using Azure Database for PostgreSQL in a multitenant solution
description: This article describes the features of Azure Database for PostgreSQL that are useful when working with multitenanted systems, and it provides links to guidance and examples.
author: PlagueHO
ms.author: dascottr
ms.date: 07/11/2025
ms.update-cycle: 180-days
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Guidance for using Azure Database for PostgreSQL in a multitenant solution

Many multitenant solutions on Azure use the open-source relational database management system Azure Database for PostgreSQL. In this article, we review the features of Azure Database for PostgreSQL that are useful when working with multitenant systems. The article also links to guidance and examples for how to use Azure Database for PostgreSQL, in a multitenant solution.

## Deployment modes

There are three deployment modes available for Azure Database for PostgreSQL that are suitable for use with multitenant applications:

- [Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server/) - This is a good choice for most multitenant deployments that don't require the high scalability that's provided by Azure Cosmos DB for PostgreSQL.
- [Azure Database for PostgreSQL - Flexible Server with Elastic Clusters (preview)](/azure/postgresql/flexible-server/concepts-elastic-clusters) - Provides horizontal scaling within a managed service, suitable for multitenant applications that need to be future-proofed to be able to scale from a few tenants to high numbers of tenants. This is in preview, so while it's not recommended for production use yet, you can begin to evaluate it for future implementation.
- [Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/) - An Azure managed database service designed for solutions requiring a high level of scale, which often includes multitenanted applications. This service is part of the Azure Cosmos DB family of products.

> [!NOTE]
> Azure Database for PostgreSQL - Single Server is on the retirement path and is [scheduled for retirement by March 28, 2025](https://azure.microsoft.com/updates/azure-database-for-postgresql-single-server-will-be-retired-migrate-to-flexible-server-by-28-march-2025/). It is not recommended for new multitenant workloads.

## Features of Azure Database for PostgreSQL that support multitenancy

When you're building a multitenant application using Azure Database for PostgreSQL, there are a number of features that you can use to enhance the solution.

> [!NOTE]
> Some features are only available in specific [deployment modes](#deployment-modes). These features are indicated in the guidance below.

### Row-level security

Row-level security is useful for enforcing tenant-level isolation, when you use shared tables. In PostgreSQL, row-level security is implemented by applying *row security policies* to tables to restrict access to rows by tenant.

There maybe a slight performance impact when implementing row-level security on a table. Therefore, additional indexes might need to be created on tables with row-level security enabled to ensure performance is not impacted. It is recommended to use performance testing techniques to validate that your workload meets your baseline performance requirements when row-level security is enabled.

More information:

- [Azure Database for PostgreSQL - Flexible Server row-level security](/azure/postgresql/flexible-server/concepts-security#row--level-security)

### Horizontal scaling with sharding

The [Sharding pattern](/azure/architecture/patterns/sharding) enables you to scale your workload across multiple databases or database servers.

Solutions that need a very high level of scale can use Azure Cosmos DB for PostgreSQL. This deployment mode enables horizontal sharding of tenants across multiple servers (nodes). By using *distributed tables* in multitenant databases, you can ensure all data for a tenant is stored on the same node, which increases query performance.

> [!NOTE]
> From October 2022, Azure Database for PostgreSQL Hyperscale (Citus) has been rebranded as Azure Cosmos DB for PostgreSQL and [moved into the Cosmos DB family of products](/azure/postgresql/hyperscale/moved).

More information:

- [Design a multitenant database using Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/tutorial-design-database-multi-tenant)
- [Distributed tables](/azure/cosmos-db/postgresql/concepts-nodes#type-1-distributed-tables)
- Choosing a [distribution column](/azure/cosmos-db/postgresql/howto-choose-distribution-column) in a distributed table.
- A guide to using [Citus for multitenant applications](https://docs.citusdata.com/en/v10.2/use_cases/multi_tenant.html).

### Elastic clusters (preview)

Elastic clusters is a feature of Azure Database for PostgreSQL Flexible Server, which provide horizontal scaling capabilities within a single managed service. This deployment option uses distributed table functionality for multitenant workloads that require scale-out capabilities.

In multitenant solutions, elastic clusters enable sharding tenant data across multiple nodes. You can distribute tables by tenant ID to ensure tenant data colocation on specific nodes, which can improve query performance for tenant-specific queries.

> [!NOTE]
> Elastic clusters are currently in preview and available only in Azure Database for PostgreSQL - Flexible Server.

More information:

- [Elastic clusters for Azure Database for PostgreSQL Flexible Server](/azure/postgresql/flexible-server/concepts-elastic-clusters)

### Connection pooling

Postgres uses a process-based model for connections. This model makes it inefficient to maintain large numbers of idle connections. Some multitenant architectures require a large number of active connections, which will negatively impact the performance of the Postgres server.

Connection pooling via PgBouncer is installed by default in [Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server).

More information:

- [PgBouncer in Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server/concepts-pgbouncer)
- [Connection pooling in Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/concepts-connection-pool)
- [Steps to install and set up PgBouncer connection pooling proxy with Azure Database for PostgreSQL](https://techcommunity.microsoft.com/t5/azure-database-for-postgresql/steps-to-install-and-setup-pgbouncer-connection-pooling-proxy/ba-p/730555)

### Microsoft Entra authentication

[Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server) supports authenticating connections using Microsoft Entra ID. This feature enables application workloads in a multitenant environment to authenticate to the database by using a tenant-specific service principal or managed identity, which means that the database access can be scoped to an individual tenant. By combining Microsoft Entra ID authentication with tenant specific *row security policies*, you can reduce the risk of an application accessing another tenant's data from within a multitenant database.
More information:

- [Microsoft Entra authentication with Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server/concepts-azure-ad-authentication)
- [Connect with managed identity to Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server/how-to-connect-with-managed-identity)

### Azure Confidential Computing (preview)

Support for Azure Confidential Computing is available in [Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server) through Trusted Execution Environments (TEEs), which provide hardware-based protection for data in use. This feature protects tenant data from unauthorized access by the operating system, hypervisor, or other applications.

For multitenant solutions handling sensitive data, Confidential Computing provides hardware-level data protection during processing. This is applicable when tenants have strict data protection requirements or regulatory compliance needs, or when you need to ensure that tenant data is not accessible to the application provider.

> [!NOTE]
> Confidential Computing is currently in preview and requires specific virtual machine SKUs.

More information:

- [Azure Confidential Computing for Azure Database for PostgreSQL](/azure/postgresql/flexible-server/concepts-confidential-computing)

### Encryption

Data stored in [Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server) is encrypted at rest by default using Microsoft-managed keys, but you can also use customer-managed keys to allow tenants to specify their own encryption keys.

When you use [customer-managed keys (CMK)](/azure/postgresql/flexible-server/concepts-data-encryption), you can provide your own encryption keys stored in [Azure Key Vault](/azure/key-vault/general/overview). In multitenant environments, this enables you to use different encryption keys for different tenants, even when their data is stored in the same database server. This capability also allows tenants to have control over their own encryption keys, and if they need to deactivate their account, deleting the encryption key ensures their data is no longer accessible.

Azure Database for PostgreSQL - Flexible Server supports [automatic key version updates](/azure/postgresql/flexible-server/concepts-data-encryption#cmk-key-version-updates) for customer-managed keys. This feature automatically updates to new key versions after rotation in Azure Key Vault, without requiring manual key version management. In multitenant environments where regulatory compliance requires regular key rotation, this automation reduces manual operational tasks and maintains data protection without service interruption.

More information:

- [Data encryption with customer-managed keys](/azure/postgresql/flexible-server/concepts-data-encryption)
- [Configure data encryption with customer managed key](/azure/postgresql/flexible-server/how-to-data-encryption)
- [Automatic key version updates](/azure/postgresql/flexible-server/concepts-data-encryption#cmk-key-version-updates)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Daniel Scott-Raynsford](https://linkedin.com/in/dscottraynsford) | Partner Solution Architect, Data & AI

Other contributors:

- [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer
- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [Paul Burpo](https://www.linkedin.com/in/paul-burpo/) | Principal Customer Engineer, FastTrack for Azure ISVs
- [Assaf Fraenkel](https://www.linkedin.com/in/assaf-fraenkel/) | Senior Engineer/Data Architect, Azure FastTrack for ISVs and Start-ups

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).
