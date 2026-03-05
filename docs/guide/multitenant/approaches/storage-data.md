---
title: Architectural Approaches for Storage and Data in Multitenant Solutions
description: Learn about approaches, including common patterns and antipatterns, to support multitenancy for the storage and data components of your solution.
author: johndowns
ms.author: pnp
ms.date: 07/17/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
   - arb-saas
---

# Architectural approaches for storage and data in multitenant solutions

Data is often considered the most valuable part of a solution because it represents your and your customers' valuable business information. It's important to carefully manage your data. When you plan storage or data components for a multitenant system, you need to decide on an approach to sharing or isolating your tenants' data.

This article provides guidance about the key considerations and requirements for solution architects when they decide on an approach to store data in a multitenant system. This article also describes some common patterns for applying multitenancy to storage and data services and some antipatterns to avoid. It also provides targeted guidance for some specific scenarios.

## Key considerations and requirements

It's important to consider the approaches that you use for storage and data services from several perspectives, including the pillars of the [Azure Well-Architected Framework](/azure/architecture/framework).

### Scale

When you work with services that store your data, you should consider the number of tenants that you have and the volume of data that you store. If you have few tenants, such as five or fewer, and you store small amounts of data for each tenant, then you probably don't need to plan a highly scalable data storage approach or build a fully automated approach to manage your data resources. 

But, as you grow, you increasingly benefit from having a clear strategy to scale your data and storage resources and automate their management. When you have 50 tenants or more, or if you plan to reach that level of scale, then it's especially important to design your data and storage approach with scale as a key consideration.

Consider the extent to which you plan to scale, and clearly plan your data storage architectural approach to meet that level of scale.

### Performance predictability

Multitenant data and storage services are susceptible to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). It's important to consider whether your tenants might affect each other's performance. For example, consider whether your tenants have overlapping peaks in their usage patterns over time. Also consider whether all of your customers use your solution at the same time each day and whether requests are distributed evenly. Those factors affect the level of isolation that you need to design for, the amount of resources that you need to provision, and the degree to which tenants can share resources.

It's important to consider [Azure resource and request quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits) as part of this decision. For example, suppose that you deploy a single storage account to contain all of your tenants' data. If you exceed a specific number of storage operations per second, Azure Storage rejects your application's requests, which affects all of your tenants. This behavior is called *throttling*. It's important that you monitor for throttled requests.

### Data isolation

When you design a solution that contains multitenant data services, there are different options and levels of data isolation that have their own benefits and trade-offs. Consider the following examples:

- When you use Azure Cosmos DB, you can deploy separate containers for each tenant, and you can share databases and accounts between multiple tenants. Alternatively, you might consider deploying different databases or even accounts for each tenant, depending on the level of isolation that you require.

- When you use Storage for blob data, you can deploy separate blob containers for each tenant, or you can deploy separate storage accounts.

- When you use Azure SQL, you can use separate tables in shared databases, or you can deploy separate databases or servers for each tenant.

- In all Azure services, you can consider deploying resources within a single shared Azure subscription, or you can use multiple Azure subscriptions or even one subscription for each tenant.

There's no single solution that works for every scenario. The option that you choose depends on several factors and your tenants' requirements. For example, if you design a business-to-consumer (B2C) solution, it might be reasonable to have a single data store for all of your data. However, if your tenants need to meet specific compliance or regulatory standards, you might need to apply a higher level of isolation. 

Similarly, you might have commercial requirements to physically isolate your customers' data, or you might need to enforce isolation to avoid the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). If any of the following conditions apply, you might need to isolate tenants from others or group them with tenants that have similar policies:

- Tenants need to use their own encryption keys
- Tenants have individual backup and restore policies
- Tenants need to have their data stored in different geographical locations

### Complexity of implementation

It's important to consider the complexity of your implementation. It's a good practice to keep your architecture as simple as possible, while still meeting your requirements. Avoid committing to an architecture that might become increasingly complex as you scale or an architecture that you don't have the resources or expertise to develop and maintain.

Similarly, if your solution doesn't need to scale to a large number of tenants or if you aren't concerned about performance or data isolation, then it's better to keep your solution simple and avoid adding unnecessary complexity.

A particular concern for multitenant data solutions is the level of customization that you support. For example, you might allow a tenant to extend your data model or apply custom data rules. Ensure that you design for this requirement up front. Avoid forking or providing customized infrastructure for individual tenants. Customized infrastructure inhibits your ability to scale, to test your solution, and to deploy updates. Instead, consider using [feature flags](/devops/operate/progressive-experimentation-feature-flags) and other forms of tenant configuration.

### Complexity of management and operations

Consider how you plan to operate your solution and how your multitenancy approach affects your operations and processes.

- **Management:** Consider management operations, such as regular maintenance activities. If you use multiple servers, file stores, or databases, plan how to initiate and monitor the maintenance operations for each tenant's resources.

- **Monitoring and metering:** If you monitor or meter your tenants, consider how your solution reports metrics and whether it can easily link metrics to the tenant that triggered the request.

- **Reporting:** Consider whether you need to report on aggregated data from across multiple isolated tenants. As your solution scales, it becomes cumbersome to run queries on each database individually and aggregate the results. A different approach is to have each tenant's applications publish data to a centralized data warehouse.

- **Schema updates:** If you use a database that enforces a schema, plan how to deploy schema updates across your estate. Consider how your application knows which schema version to use for a specific tenant's database queries.

- **Requirements:** Consider your tenants' high availability requirements, such as uptime service-level agreements (SLAs), and disaster recovery requirements, such as recovery time objectives (RTOs) and recovery point objectives (RPOs). If tenants have different expectations, verify that you can meet each tenant's requirements.

- **Migration:** Consider whether you want to enable tenants to move to a different type of service, a different deployment, or another region. If you plan to offer this capability, build processes and tools to ensure that it's a repeatable and safe process.

### Cost

Generally, the higher the density of tenants to your deployment infrastructure, the lower the cost to provision that infrastructure. However, shared infrastructure increases the likelihood of problems like the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), so consider the trade-offs carefully.

## Approaches and patterns to consider

Several design patterns from the Azure Architecture Center are relevant to multitenant storage and data services. You might choose to follow one pattern consistently. Or you can consider mixing and matching patterns. For example, you might use a multitenant database for most of your tenants but deploy single-tenant stamps for tenants who pay more or who have unusual requirements.

### Deployment Stamps pattern

For more information about how to use the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) to support a multitenant solution, see [Overview](overview.md#deployment-stamps-pattern).

> [!TIP]
> In multitenant solutions, it's a good practice to create deployment stamps. This recommendation applies even when you use a multitenant database or sharded databases within a stamp. By modeling your solution as a stamp, you can easily redeploy it as new business opportunities arise.

### Shared multitenant databases and file stores

You might consider deploying a shared multitenant database, storage account, or file share and sharing it across all of your tenants.

:::image type="complex" border="false" source="media/storage-data/shared-database.png" alt-text="Diagram that shows a single shared multitenant database for all tenants' data." lightbox="media/storage-data/shared-database.png":::
   The diagram consists of three blue boxes and one gray box. The first blue box is labeled Tenant A. The second blue box is labeled Tenant B. The third blue box is labeled Tenant C. Arrows point from the blue boxes to the gray box, labeled Shared resources. The shared resources box contains an icon that represents a web server and an icon that represents tenants A, B, and C.
:::image-end:::

This approach provides the highest density of tenants to infrastructure, so it tends to come at the lowest financial cost of any approach. It also often reduces the management overhead because there's a single database or resource to manage, back up, and secure.

However, when you work with shared infrastructure, consider the following drawbacks:

- **Scale limits:** When you rely on a single resource, consider the supported scale and limits of that resource. For example, if your architecture relies on a single shared database, the maximum size of a database or file store, or the maximum throughput limits, eventually become a hard blocker. Carefully consider the maximum scale that you need to achieve and compare it to your current and future limits before you select this pattern.

- **Noisy neighbors:** The [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) might become a factor, especially if you have tenants that are busy or generate higher workloads than others. Consider applying the [Throttling pattern](../../../patterns/throttling.yml) or the [Rate Limiting pattern](../../../patterns/rate-limiting-pattern.yml) to mitigate these effects.

- **Measure tenants' consumption:** Consider whether you need to [measure the consumption](../considerations/measure-consumption.md) of each tenant. Some data services, such as Azure Cosmos DB, provide reporting on resource usage for each transaction. You can track this information and aggregate it to measure the consumption for each tenant. Other services don't provide the same level of detail. For example, when you use Azure Files with premium file shares, you can access metrics for file capacity for each file share dimension. The standard tier provides the metrics only at the storage account level.

- **Tenant requirements:** Tenants might have different requirements for security, backup, availability, or storage location. If these requirements don't match your single resource's configuration, you might not be able to accommodate them.

- **Schema customization:** When you work with a relational database or another scenario where the schema of the data is important, then tenant-level schema customization is difficult.

### Sharding pattern

The [Sharding pattern](../../../patterns/sharding.yml) involves deploying multiple separate databases, called *shards*, that each contains one or more tenants' data. Unlike deployment stamps, shards don't imply that the entire infrastructure is duplicated. You might shard databases without also duplicating or sharding other infrastructure in your solution.

:::image type="complex" border="false" source="media/storage-data/sharding.png" alt-text="Diagram that shows a sharded database. One database contains the data for tenants A and B, and the other database contains the data for tenant C." lightbox="media/storage-data/sharding.png":::
   The diagram consists of three blue boxes and one gray box. The first blue box is labeled Tenant A. The second blue box is labeled Tenant B. The third blue box is labeled Tenant C. Arrows point from the blue tenant boxes to a gray box. The gray box contains a smaller box that's labeled Web server (Shared). The gray box also contains three icons for shards. One icon is labeled Shard map. The second icon is labeled Shard 1, and the third icon is labeled Shard 2. Tenants A and B share shard 1, and tenant C uses shard 2.
:::image-end:::

Sharding is closely related to *partitioning*, and the terms are often used interchangeably. Consider the [Horizontal, vertical, and functional data partitioning guidance](../../../best-practices/data-partitioning.yml).

The Sharding pattern can scale to large numbers of tenants. Depending on your workload, you might also be able to achieve a high density of tenants to shards, which can lower costs. You can use the Sharding pattern to address [Azure subscription and service quotas, limits, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

Some data stores, such as Azure Cosmos DB, provide native support for sharding or partitioning. When you work with other solutions, such as Azure SQL, it can be more complex to build a sharding infrastructure and to route requests to the correct shard for a given tenant.

Sharding also makes it difficult to support tenant-level configuration differences and to enable customers to provide their own encryption keys.

### Multitenant app with dedicated databases for each tenant

Another common approach is to deploy a single multitenant application that has dedicated databases for each tenant.

:::image type="complex" border="false" source="media/storage-data/dedicated-databases.png" alt-text="Diagram that shows different databases for each tenant." lightbox="media/storage-data/dedicated-databases.png":::
   The diagram consists of three blue boxes and one gray box. The first blue box is labeled Tenant A. The second blue box is labeled Tenant B. The third blue box is labeled Tenant C. Arrows point from the blue boxes to the gray box. The gray box contains a smaller box that's labeled Web server (Shared). It also contains three icons, labeled Tenant A, Tenant B, and Tenant C.
:::image-end:::

In this model, each tenant's data is isolated from the others' data, and you might be able to support some degree of customization for each tenant.

The cost for this approach can be higher than shared hosting models because you provision dedicated data resources for each tenant. However, Azure provides several options that you can consider to share the cost of hosting individual data resources across multiple tenants. For example, when you work with Azure SQL Database, you can consider [elastic pools](/azure/azure-sql/database/elastic-pool-overview). For Azure Cosmos DB, you can [provision throughput for a database](/azure/cosmos-db/set-throughput#set-throughput-on-a-database), and the throughput is shared between the containers in that database. However, this approach isn't appropriate when you need guaranteed performance for each container.

In this approach, because only the data components are deployed individually for each tenant, you likely can achieve high density for the other components in your solution and reduce the cost of those components.

> [!NOTE]
> It's important to use automated deployment approaches when you provision databases for each tenant. Otherwise, the complexity of manually deploying and managing the databases becomes overwhelming.

### Geode pattern

The [Geode pattern](../../../patterns/geodes.yml) is designed specifically for geographically distributed solutions, including multitenant solutions. It supports high load and high levels of resiliency. If you implement the Geode pattern, your data tier must be able to replicate the data across geographic regions, and it should support multiple-geography writes.

:::image type="complex" border="false" source="media/storage-data/geodes.png" alt-text="Diagram that shows the Geode pattern, with databases deployed across multiple regions that synchronize together." lightbox="media/storage-data/geodes.png":::
   The diagram consists of three blue boxes and four gray boxes. The first blue box is labeled Tenant A. The second blue box is labeled Tenant B. The third blue box is labeled Tenant C. Arrows point from the blue boxes to a gray box labeled Global Load Balancer. The arrow from tenant A continues through the global load balancer to a gray box labeled Region 1. It contains a web server and a database. The arrow from tenant B continues through the global load balancer to a gray box labeled Region 2. It contains a web server and a database. The arrow from tenant C continues through the global load balancer to a gray box labeled Region 3. It contains a web server and a database. Double-sided arrows point from database to database in each of the region boxes.
:::image-end:::

Azure Cosmos DB provides [multiple-region writes](/azure/cosmos-db/nosql/how-to-multi-master) to support this pattern, and Azure Managed Instance for Apache Cassandra supports [multiple-region clusters](/azure/managed-instance-apache-cassandra/create-multi-region-cluster). Other data services usually can't support this pattern without significant customization.

## Antipatterns to avoid

When you create multitenant data services, it's important to avoid situations that inhibit your ability to scale.

For relational databases, these antipatterns include:

- **Table-based isolation.** When you work within a single database, avoid creating individual tables for each tenant. A single database can't support large numbers of tenants when you use this approach, and it becomes increasingly difficult to query, manage, and update data. Instead, consider using a single set of multitenant tables with a tenant identifier column. Alternatively, you can use a [recommended pattern](#approaches-and-patterns-to-consider) to deploy separate databases for each tenant.

- **Column-level tenant customization.** Avoid schema updates that only apply to a single tenant. For example, suppose that you have a single multitenant database. Avoid adding a new column to meet a specific tenant's requirements. It might be acceptable for a few customizations, but this method rapidly becomes unmanageable when you have many customizations to consider. Instead, consider revising your data model to track custom data for each tenant in a dedicated table.

- **Manual schema changes.** Avoid updating your database schema manually, even if you only have a single shared database. It's easy to lose track of the updates that you apply, and if you need to scale out to more databases, it's challenging to identify the correct schema to apply. Instead, build tooling or an automated pipeline to deploy your schema changes, and use it consistently. Track the schema version that you use for each tenant in a dedicated database or lookup table.

- **Version dependencies.** Avoid having your application take a dependency on a single version of your database schema. As you scale, you might need to apply schema updates at different times for different tenants. Instead, ensure that your application version is backwards-compatible with at least one previous schema version, and sequence destructive schema changes across multiple versions to support rollbacks.

## Databases

There are some features that can be useful for multitenancy. However, these features aren't available in all database services. Consider whether you need the following features when you decide on the service to use for your scenario:

- **Row-level security** can provide security isolation for specific tenants' data in a shared multitenant database. This feature is available in some databases, like SQL Database and Azure Database for PostgreSQL flexible server.

    When you use row-level security, you need to ensure that the user's identity and tenant identity are propagated through the application and into the data store with each query. This approach can be complex to design, implement, test, and maintain. Many multitenant solutions don't use row-level security because of those complexities.

- **Tenant-level encryption** might be required to support tenants that provide their own encryption keys for their data. This feature is available in SQL Server and Azure SQL as part of [Always Encrypted](/sql/relational-databases/security/encryption/always-encrypted-database-engine). Azure Cosmos DB provides [customer-managed keys at the account level](/azure/cosmos-db/how-to-setup-customer-managed-keys) and also [supports Always Encrypted](/azure/cosmos-db/how-to-always-encrypted).

- **Resource pooling** enables you to share resources and their costs between multiple databases or containers. This feature is available in SQL Database [elastic pools](/azure/azure-sql/database/elastic-pool-overview), in [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview), and in Azure Cosmos DB [database throughput](/azure/cosmos-db/set-throughput#set-throughput-on-a-database).

- **Sharding and partitioning** has stronger native support in some services than in others. This feature is available in Azure Cosmos DB by using its [logical and physical partitioning](/azure/cosmos-db/partitioning-overview). Although SQL Database doesn't natively support sharding, it provides [sharding tools](/azure/azure-sql/database/elastic-scale-introduction) to support this type of architecture.

Additionally, when you maintain a fleet of relational databases or other schema-based databases, consider where the schema upgrade process should be triggered. In a small estate of databases, you might consider using a deployment pipeline to deploy schema changes. As the number of databases increases, it might be better for your application tier to detect the schema version for a specific database and to initiate the upgrade process.

## File and blob storage

Consider the approach that you use to isolate data within a storage account. For example, you might deploy separate storage accounts for each tenant, or you might share storage accounts and deploy individual containers. Alternatively, you might create shared blob containers, and then you can use the blob path to separate data for each tenant. Consider [Azure subscription limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits), and carefully plan your growth to ensure that your Azure resources scale to support your future needs.

If you use shared containers, plan your authentication and authorization strategy carefully to ensure that tenants can't access each other's data. Consider the [Valet Key pattern](../../../patterns/valet-key.yml) when you provide clients with access to Storage resources.

## Cost allocation

Consider how you [measure consumption and allocate costs to tenants](../considerations/measure-consumption.md) for the use of shared data services. Whenever possible, aim to use built-in metrics instead of calculating your own. However, with shared infrastructure, it becomes hard to split telemetry for individual tenants, and you might need to consider application-level custom metering.

In general, cloud-native services, like Azure Cosmos DB and Azure Blob Storage, provide more granular metrics to track and model the usage for a specific tenant. For example, Azure Cosmos DB provides the consumed throughput for every request and response.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Paul Burpo](https://www.linkedin.com/in/paul-burpo) | Principal Customer Engineer, FastTrack for Azure
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Technology Strategist
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

For more information about multitenancy and specific Azure services, see the following resources:

- [Multitenancy and Storage](../service/storage.md)
- [Multitenancy and SQL Database](../service/sql-database.md)
- [Multitenancy and Azure Cosmos DB](../service/cosmos-db.md)
- [Multitenancy and Azure Database for PostgreSQL](../service/postgresql.md)
