---
title: Multitenancy and Azure SQL Database
description: This article describes partitioning and tenancy strategies and Azure SQL Database features for multitenant solutions.
author: johndowns
ms.author: pnp
ms.date: 10/23/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
ai-usage: ai-assisted
---

# Multitenancy and Azure SQL Database

Multitenant solutions on Azure commonly use Azure SQL Database. This article describes partitioning and tenancy strategies and SQL Database features for multitenant solutions.

Read this article together with [Architectural approaches for storage and data in multitenant solutions](../approaches/storage-data.md), which describes general considerations and approaches that apply across data services.

## Partitioning and tenancy strategies

Choose the tenancy model that meets the workload's scale, isolation, recovery, customization, and cost requirements. Prefer the simplest model that meets those requirements. Sharding adds application and operational complexity, so don't introduce it only to work around limits that a larger service tier can satisfy.

To compare the architectural tradeoffs of common Azure SQL Database tenancy models, see [How to choose the appropriate tenancy model](/azure/azure-sql/database/saas-tenancy-app-design-patterns#b-how-to-choose-the-appropriate-tenancy-model).

### Decide whether to use one or multiple databases

A single SQL database has finite storage capacity. Its throughput and concurrency are constrained by the service tier, compute configuration, connection limits, and workload characteristics. Estimate the aggregate and per-tenant requirements for storage, throughput, concurrency, latency, isolation, recovery, and regional configuration before you choose one shared database, a database for each tenant, or a sharded topology.

The database boundary also determines the granularity of backup, restore, geo-replication, and failover operations. For more information, see [Architecture best practices for Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database#reliability).

A shared multitenant database can provide high tenant density and low per-tenant cost, but multiple databases might be appropriate before a single database reaches its technical limits if tenants require stronger isolation or independent configuration and lifecycle operations.

You can combine tenancy models. For example, you can place most tenants in shared databases and give high-demand or regulated tenants dedicated databases. Use a tenant catalog to route each tenant to the appropriate database.

Evaluate the [Hyperscale service tier](/azure/azure-sql/database/service-tier-hyperscale) when database size, backup and restore duration, read scale-out, or rapid compute scaling drive the design. Hyperscale supports automatically growing storage of up to 128 TB for a database and up to 100 TB for a Hyperscale elastic pool. If an existing architecture uses sharding only to work around database storage limits, consider consolidating the shards into a Hyperscale database. Validate write throughput, cost, recovery objectives, isolation, and operational requirements before consolidating.

### Shared multitenant database

In a shared database, store a tenant identifier in every table that contains tenant-owned data. Propagate authenticated user and tenant identity into the database for every request. Establish and validate this context whenever you reuse a pooled connection instead of relying on context from a previous request. Use [row-level security](#row-level-security) as a database-enforced safeguard against cross-tenant data access.

All tenants share the database's compute, storage, backup, restore, and regional configuration. This model is susceptible to the [Noisy Neighbor antipattern](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), in which one tenant's workload affects other tenants. Restoring or moving one tenant requires application-controlled data extraction and validation. Use this model when tenant density and cost efficiency are more important than tenant-specific configuration or strong performance isolation.

### Database per tenant

Use a separate database for each tenant when tenants require stronger data and performance isolation, independent backup and restore, schema customization, regional placement, or clearer cost attribution. The application must maintain a reliable mapping from each tenant identifier to its database and route connections accordingly.

Place databases with compatible performance and recovery requirements in [elastic pools](#elastic-pools) to share provisioned compute. Use [Hyperscale](#hyperscale) or Hyperscale elastic pools when individual tenant databases require Hyperscale storage, backup, restore, or read-scale capabilities.

### Sharded multitenant databases

Use sharded multitenant databases when distributing tenants across multiple shared databases better meets the workload's scale, recovery, tenant-density, or cost requirements than a single shared database or a database-per-tenant topology. A shard is an Azure SQL database that stores one or more tenants. Use a stable shard key, such as a tenant identifier, so that the application can determine which database stores a tenant's data.

Treat each tenant's dataset as a placement unit. Keep all data for a tenant in one shard when possible so that tenant-scoped queries and transactions remain within one database. Maintain a mapping from each tenant identifier to the database that contains its data.

A tenant-to-database mapping is often called a *shard map*. A shard map is a catalog that maps each shard key, or a range of keys, to the database that stores the associated data. Implement the shard map as durable application metadata that meets the workload's availability and consistency requirements. Application instances can cache shard-map entries to reduce routing latency, but they must refresh or invalidate cached entries when mappings change.

Make the authoritative shard map highly available and update it atomically with tenant-migration operations. The application must also own connection routing, shard provisioning, tenant movement, rebalancing, and failure handling. Plan how the application handles stale mappings during cutover and rollback. For general design guidance, see the [Sharding pattern](../../../patterns/sharding.md).

### Plan cross-database operations

Design each database as an independent transaction and integrity boundary:

- **Preserve data locality and integrity:** Keep data that the application joins or updates transactionally in the same database. Don't create referential integrity, trigger, or stored procedure dependencies across databases. For business operations that span databases, use eventual consistency or another application-level coordination pattern.
- **Manage schemas consistently:** Use the same tables, columns, indexes, views, and stored procedures in each shard so that the application can use the same data-access logic after it routes a request to any shard. Automate schema deployments across the database fleet and track the schema version of each database. If you intentionally support schema variation, make the application and deployment process version-aware.
- **Manage reference data deliberately:** Replicate static or slow-changing reference data when doing so avoids synchronous cross-database operations. Define how the application propagates updates and handles stale copies.
- **Balance and place shards:** Balance shards by data volume and request load, not only by tenant count. Plan an automated and recoverable process to move tenants between shards. Place databases according to tenant latency, residency, and disaster-recovery requirements.

Use [Elastic jobs](#elastic-jobs) for scheduled schema changes, maintenance, telemetry collection, and other operations across database groups. For reporting and analytics across tenant databases, use a centralized analytical store, such as Microsoft Fabric through [mirroring for Azure SQL Database](/fabric/mirroring/azure-sql-database), or an extract, transform, and load (ETL) pipeline such as [Azure Data Factory](/azure/data-factory/). If an application requires synchronous fan-out queries, build a query and aggregation layer that defines timeout, retry, partial-failure, and result-merging behavior.

## Features of SQL Database that support multitenancy

SQL Database includes many features that support multitenancy.

### Elastic pools

Elastic pools share a configured set of compute resources among multiple databases on the same logical server. Pools can reduce costs when tenant databases have low average utilization and infrequent, nonoverlapping usage peaks. Databases with persistent medium-to-high utilization might be better suited to dedicated compute. You can set minimum and maximum resource limits for individual pooled databases to constrain their resource consumption, but all databases still share the pool's total capacity. Monitor both aggregate pool utilization and individual database utilization.

For more information, see the following resources:

- [SQL Database elastic pools](/azure/azure-sql/database/elastic-pool-overview)
- [Resource management in dense elastic pools](/azure/azure-sql/database/elastic-pool-resource-management)
- [Disaster recovery (DR) strategies for applications that use SQL Database elastic pools](/azure/azure-sql/database/disaster-recovery-strategies-for-applications-with-elastic-pool)

### Hyperscale

Azure SQL Database Hyperscale separates compute from storage so that you can scale them independently. Use Hyperscale when a shared multitenant database or an individual tenant database requires higher storage limits, rapid backup and restore, or read scale-out.

For more information, see the following resources:

- [Hyperscale service tier](/azure/azure-sql/database/service-tier-hyperscale)
- [Hyperscale elastic pools overview](/azure/azure-sql/database/hyperscale-elastic-pool-overview)
- [Work with Hyperscale elastic pools by using command-line tools](/azure/azure-sql/database/hyperscale-elastic-pool-command-line)

### Elastic jobs

Use Elastic jobs to run scheduled Transact-SQL (T-SQL) scripts and maintenance tasks against one or many databases. Target groups can include individual databases, logical servers, elastic pools, and databases across subscriptions. Common multitenant uses include deploying schema changes, managing credentials, collecting telemetry, and running batch data-processing tasks across a database fleet.

Elastic jobs don't provide a synchronous application query layer. If an application request must query multiple databases and immediately aggregate the results, implement that behavior in an application or analytical layer.

For more information, see [Elastic jobs in Azure SQL Database](/azure/azure-sql/database/elastic-jobs-overview).

### Row-level security

[Row-level security](/sql/relational-databases/security/row-level-security) helps enforce tenant-level isolation in shared tables. For more information, see [Row-level security implementation on Azure SQL](https://www.youtube.com/watch?v=QQobIo-gfmk).

### Key management

Azure SQL Database uses transparent data encryption (TDE) to encrypt data at rest. If tenants must supply their own encryption keys, use separate databases and configure [customer-managed TDE keys at the database level](/azure/azure-sql/database/transparent-data-encryption-byok-database-level-overview). Use [Always Encrypted](/sql/relational-databases/security/encryption/always-encrypted-database-engine) when the database engine and its operators must not have access to plaintext values in specific sensitive columns. Verify application and query compatibility because Always Encrypted restricts some operations on encrypted columns.

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

## Next steps

- [Run one million databases on Azure SQL for a large SaaS provider: Dynamics 365 and Microsoft Power Platform](https://devblogs.microsoft.com/azure-sql/running-1m-databases-on-azure-sql-for-a-large-saas-provider-microsoft-dynamics-365-and-power-platform/)
- [Design patterns for SaaS applications on SQL Database](https://www.youtube.com/watch?v=jjNmcKBVjrc)
- [Architecture best practices for SQL Database](/azure/well-architected/service-guides/azure-sql-database)

## Related resources

- [Architectural approaches for storage and data in multitenant solutions](../approaches/storage-data.md)
