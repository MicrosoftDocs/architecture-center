---
title: Guidance for Using Azure Database for PostgreSQL in a Multitenant Solution
description: Learn about the Azure Database for PostgreSQL features that are useful when you work with multitenant systems. Explore guidance and examples.
author: PlagueHO
ms.author: dascottr
ms.date: 23/01/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Guidance for using Azure Database for PostgreSQL in a multitenant solution

Many multitenant solutions on Azure use the open-source relational database management system Azure Database for PostgreSQL. This article describes the features of Azure Database for PostgreSQL that are useful when you work with multitenant systems. The article also includes links to guidance and examples for how to use Azure Database for PostgreSQL in a multitenant solution.

## Deployment modes

The following deployment modes are available for Azure Database for PostgreSQL and are suitable for use with multitenant applications:

- [Azure Database for PostgreSQL flexible server](/azure/postgresql) is a good choice for most multitenant deployments that don't require the high scalability that Azure Cosmos DB for PostgreSQL provides.

- [Azure Database for PostgreSQL flexible server with elastic clusters (preview)](/azure/postgresql/flexible-server/concepts-elastic-clusters) provides horizontal scaling within a managed service. It's suitable for multitenant applications that need to scale from a few tenants to high numbers of tenants. This feature is in preview and isn't recommended for production use. However, you can begin to evaluate it for future implementation.

- [Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/) is an Azure-managed database service designed for solutions that require a high level of scale, like multitenant applications. This service is part of the Azure Cosmos DB family of products.

## Azure Database for PostgreSQL features that support multitenancy

When you use Azure Database for PostgreSQL to build a multitenant application, the following features can enhance your solution.

> [!NOTE]
> Some features are only available in specific [deployment modes](#deployment-modes). The following guidance describes which features are available.

### Row-level security

Row-level security is useful for enforcing tenant-level isolation when you use shared tables. In PostgreSQL, you implement row-level security by applying *row security policies* to tables to restrict access to rows by tenant.

Implementing row-level security on a table might affect performance. You might need to create other indexes on tables that have row-level security enabled to ensure that performance isn't affected. When you use row-level security, it's important to use performance testing techniques to validate that your workload meets your baseline performance requirements.

For more information about row-level security, see [Access management for Azure Database for PostgreSQL](/azure/postgresql/security/security-access-control#row-level-security).

#### Tenant context for row-level security

Row-level security policies require access to the current tenant identifier. Azure Database for PostgreSQL flexible server provides two extensions that help manage tenant context:

- **session_variable**: Provides session-scoped variables that you can use to store and retrieve the tenant identifier within a session. Use these variables in your row-level security policies.
- **login_hook**: Executes a function at login time. Use this extension to automatically set the tenant context when a connection is established.

For more information, see [Extensions and extension versions for Azure Database for PostgreSQL flexible server](/azure/postgresql/extensions/concepts-extensions-versions).

### Horizontal scaling with sharding

The [Sharding pattern](/azure/architecture/patterns/sharding) enables you to scale your workload across multiple databases or database servers.

Solutions that need a high level of scale can use Azure Cosmos DB for PostgreSQL. This deployment mode enables horizontal sharding of tenants across multiple servers or nodes. Use *distributed tables* in multitenant databases to ensure that all data for a tenant is stored on the same node. This approach improves query performance.

> [!NOTE]
> In October 2022, Azure Database for PostgreSQL Hyperscale (Citus) was rebranded as Azure Cosmos DB for PostgreSQL and [moved into the Azure Cosmos DB family of products](/azure/postgresql/hyperscale/moved).

For more information, see the following articles:

- [Design a multitenant database by using Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/tutorial-design-database-multi-tenant)
- [Distributed tables](/azure/cosmos-db/postgresql/concepts-nodes#type-1-distributed-tables)
- [Choose distribution columns](/azure/cosmos-db/postgresql/howto-choose-distribution-column)
- [Use Citus for multitenant applications](https://docs.citusdata.com/en/v10.2/use_cases/multi_tenant.html)

### Elastic clusters

Elastic clusters are a feature of Azure Database for PostgreSQL flexible server. They provide horizontal scaling capabilities within a single managed service. This deployment option uses distributed table functionality for multitenant workloads that require scale-out capabilities.

In multitenant solutions, elastic clusters enable tenant data sharding across multiple nodes. Elastic clusters support two sharding models:

- **Row-based sharding**: You can distribute tables by tenant ID to ensure that tenant data colocates on specific nodes. This approach can improve query performance for tenant-specific queries but requires that queries include the distribution column.
- **Schema-based sharding**: You can isolate tenants by using a separate schema per tenant. This approach is ideal for ISVs deploying applications that can't undergo query modifications to support row-based sharding. Schema-based sharding is well-suited for workloads that have between 1 and 10,000 tenants.

> [!NOTE]
> Elastic clusters are in preview and available only in Azure Database for PostgreSQL flexible server.

For more information, see the following articles:

- [Elastic clusters in Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/concepts-elastic-clusters)
- [Sharding models for elastic clusters](/azure/postgresql/elastic-clusters/concepts-elastic-clusters-sharding-models)

### Connection pooling

Postgres uses a process-based model for connections. This model makes it inefficient to maintain large numbers of idle connections. Some multitenant architectures require many active connections, which negatively affect the performance of the Postgres server.

Connection pooling via PgBouncer is installed by default in Azure Database for PostgreSQL flexible server.

For more information, see the following articles:

- [PgBouncer in Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/concepts-pgbouncer)
- [Connection pooling in Azure Cosmos DB for PostgreSQL](/azure/cosmos-db/postgresql/concepts-connection-pool)
- [Steps to install and set up PgBouncer connection pooling proxy with Azure Database for PostgreSQL](https://techcommunity.microsoft.com/t5/azure-database-for-postgresql/steps-to-install-and-setup-pgbouncer-connection-pooling-proxy/ba-p/730555)

### Microsoft Entra authentication

Azure Database for PostgreSQL flexible server supports connection authentication by using Microsoft Entra ID. This feature enables application workloads in a multitenant environment to authenticate to the database by using a tenant-specific service principal or managed identity. The database access can be scoped to an individual tenant. By combining Microsoft Entra ID authentication with tenant specific *row security policies*, you can reduce the risk of an application accessing another tenant's data from within a multitenant database.

For more information, see the following articles:

- [Microsoft Entra authentication in Azure Database for PostgreSQL](/azure/postgresql/flexible-server/security-entra-concepts)
- [Connect with managed identity to Azure Database for PostgreSQL flexible server](/azure/postgresql/flexible-server/security-connect-with-managed-identity)

### Azure confidential computing (preview)

Azure Database for PostgreSQL flexible server supports Azure confidential computing through trusted execution environments (TEEs), which provide hardware-based protection for data in use. This feature protects tenant data from unauthorized access by the operating system, hypervisor, or other applications.

For multitenant solutions that handle sensitive data, confidential computing provides hardware-level data protection during processing. Use confidential computing when tenants have strict data protection requirements or regulatory compliance needs or when you need to ensure that the application provider can't access tenant data.

> [!NOTE]
> Confidential computing is currently in preview and requires specific virtual machine SKUs.

For more information, see [Azure confidential computing for Azure Database for PostgreSQL (preview)](/azure/postgresql/flexible-server/concepts-confidential-computing).

### Encryption

Data stored in Azure Database for PostgreSQL flexible server is encrypted at rest by default by using Microsoft-managed keys, but you can also use customer-managed keys (CMKs) to allow tenants to specify their own encryption keys.

When you use [CMKs](/azure/postgresql/flexible-server/security-data-encryption), you can provide your own encryption keys stored in [Azure Key Vault](/azure/key-vault/general/overview). In multitenant environments, this approach enables you to use different encryption keys for different tenants, even when their data is stored in the same database server. This capability also gives tenants control over their own encryption keys. If a tenant chooses to deactivate their account, deleting the associated key ensures that their data is no longer accessible.

Azure Database for PostgreSQL flexible server supports [automatic key version updates](/azure/postgresql/flexible-server/security-data-encryption#cmk-key-version-updates) for CMKs. This feature automatically updates to new key versions after rotation in Key Vault and doesn't require manual key version management. In multitenant environments where regulatory compliance requires regular key rotation, this automation reduces manual operational tasks and maintains data protection without service interruption.

For more information, see the following articles:

- [Data encryption at rest](/azure/postgresql/flexible-server/security-data-encryption)
- [Configure data encryption](/azure/postgresql/flexible-server/security-configure-data-encryption)
- [Automatic key version updates](/azure/postgresql/flexible-server/security-data-encryption#cmk-key-version-updates)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Solution Architect, Data & AI

Other contributors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [Paul Burpo](https://www.linkedin.com/in/paul-burpo/) | Principal Customer Engineer, FastTrack for Azure ISVs
- [Assaf Fraenkel](https://www.linkedin.com/in/assaf-fraenkel/) | Senior Engineer/Data Architect, Azure FastTrack for ISVs and Start-ups

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Architectural approaches for storage and data in multitenant solutions](../approaches/storage-data.md)
