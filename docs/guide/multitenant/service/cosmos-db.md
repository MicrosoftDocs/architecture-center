---
title: Multitenancy and Azure Cosmos DB
description: Learn about features of Azure Cosmos DB that you can use with multitenant systems. Find other resources about how to use Azure Cosmos DB in a multitenant solution.
author: deborahc
ms.author: dech
ms.date: 03/12/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy and Azure Cosmos DB

This article describes features of Azure Cosmos DB that you can use for multitenant systems. It provides guidance and examples about how to use Azure Cosmos DB in a multitenant solution.

## Multitenancy requirements

When you plan a multitenant solution, you have two key requirements:
- Ensure security and performance isolation between tenants. As the provider, meet security requirements and ensure good performance per tenant.
- Maintain a low cost per tenant. As the provider, ensure that the cost to run the application remains sustainable as it scales.

These two needs can often conflict and introduce a trade-off where you must prioritize one over the other. The guidance in this article can help you better understand the trade-offs that you must make to address these needs. This article helps you navigate these considerations so you can make informed decisions when you design your multitenant solution.

## Isolation models

Determine the level of isolation that you need between your tenants. For most solutions, we recommend that you use one of the following strategies, depending on your workload:

- A partition key per tenant is often used for business-to-consumer software as a service (B2C SaaS) solutions. For example, a conversational chatbot application that stores user chat history in Azure Cosmos DB.
- A database account per tenant is often used for business-to-business (B2B) SaaS solutions. For example, a Content Management System (CMS) sold to enterprises to publish digital content.

To choose the most appropriate isolation model, consider your business model and the tenants' requirements. For example, in B2C models, where a business sells a product or service directly to an individual customer, strong security and performance isolation for each individual customer is often not required. For these applications, for highest cost efficiency, the data for all tenants can be stored in the same container, with partition key providing logical isolation. However, in a B2B models, providers often sell different SKUs corresponding to different performance levels or SLA guarantees. In addition, providers often want to offer their customers the option to manage their own encryption keys, known as cross-tenant or hosted on behalf of customer managed keys. For these applications, using a separate database account per tenant ensures the ability to tune and guarantee performance per customer, as well as provide customer managed keys, a feature only available at the Azure Cosmos DB database account level.

## Partition-key-per-tenant model (recommended)

In a partition key per tenant model, all the data for your tenants is stored in the same Azure Cosmos DB container, often using a partition key like /TenantId. All the throughput (RU/s) of the container is shared by the tenants.

> [!NOTE]
> A *request unit* (RU) is a logical abstraction of the cost of a database operation or query. Typically, you provision a defined number of request units per second (RU/s) for your workload, which is referred to as *throughput*. 

### Benefits

- **Simplified management:** You place all tenants in one container, which is partitioned by the tenant ID. This approach has only one billable resource that provisions and shares RU/s among multiple tenants. This model is usually easier to manage, as there is only one RU/s setting that affects cost for the entire multi-tenant workload.

### Trade-offs / considerations

- **Resource contention:** Shared throughput (RU/s) across tenants that are in the same container can lead to contention during peak usage. This contention can create [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) and performance challenges if your tenants have high or overlapping workloads. Use this isolation model for workloads that don't need guaranteed RU/s on a single tenant and can share throughput.

- **Limited isolation:** This approach provides logical isolation, not physical isolation. Use this isolation model for workloads that don't need guaranteed performance per tenant or customer managed keys per tenant.
- 
- **Less flexibility:** You can't customize account-level features, like geo-replication, point-in-time restore, and customer-managed keys, for each tenant if you isolate by partition key.

### Azure Cosmos DB features for multitenancy

- **Control your throughput:** Explore features that can help control the noisy neighbor problem when you use a partition key to isolate tenants. Use features such as [throughput reallocation](/azure/cosmos-db/nosql/distribute-throughput-across-partitions) to give more RU/s to hot partitions, [burst capacity](/azure/cosmos-db/burst-capacity), and [throughput control](/azure/cosmos-db/nosql/throughput-control-spark) in the [Java SDK](/azure/cosmos-db/nosql/sdk-java-v4).

- **Partition keys:** For read-heavy workloads where your most common queries are by tenant, it is recommended to use [hierachical partition keys](/azure/cosmos-db/hierarchical-partition-keys). By setting /TenantId as your first level key and a high cardinality field, such as /id as your second level key, you can guarantee that you can have unlimited storage per tenant. If you have an additional hierarchy in your workload, such as storing data per users in each tenant, you can set /TenantId as your first level, /UserId as your second level, and a last level of /id to guarantee unlimited storage for each user in a tenant. In addition, queries that specify either /TenantId or both /TenantId and /UserId and will be efficiently routed only to the subset of physical partitions that contains the relevant data, which avoids a full fanout query. If the container has 1,000 physical partitions but a specific `TenantId` value is only on five physical partitions, the query is routed to the smaller number of relevant physical partitions.

Note that features in Azure Cosmos DB like stored procedures and atomic batch transactions are only available at the full logical partition key level. This means if you partition by /id as your last level key using hierarchical partition keys, you will not be able to run stored procedures or do an atomic batch transaction at partial levels. For example, if you partition by /TenantId, UserId, /id, you will not be able to run a stored procedure or do an atomic batch transaction by specifying only the TenantId or only the TenantId and UserId. If you need to use such features, do not set /id as your last level key.

Hierarchical partition keys work best when you have high cardinality of values and uniform distribution of request volumes for your first level keys. In a multi-tenant setting, this means that you should have a high number of tenants (ideally in the order of hundreds to thousands of tenants or higher) and your tenants should roughly have a similar usage pattern. If you have small number of tenants, for example, 10 tenants, or a skewed workload where a single tenant consistently consumes 10x the RU/s as your other tenants, even with hierarchical partition keys, you may have a hot partition and possible degraded performance.

For these workloads where you do not have high cardinality per tenant or need to optimize for write performance, it is recommended to use synthetic partition keys or partition just by /id. Both these approaches will allow you to spread writes evenly across all physical partitions. The main advantage of a synthetic key over id is if you're able to construct the key in a way that still allows you to optimize for some queries - for example, a synthetic key of TenantId_UserId will have a slight trade-off in perfectly even distribution of data across all partitions, but will allow you to do efficient queries if you specify both the TenantId_UserId. However, if your workload needs to optimize for write throughput, running queries may not be relevant, and you can partition by just /id to simplify your workload.

Finally, if you find you have a small number of tenants that are much larger and have consistently higher request volumes than others, you may consider isolating that tenant into its own database account, while keeping the remaining tenants in a shared container. 

## Database-account-per-tenant model (recommended)

In the database account per tenant model, each of your tenants' data is stored in their own Azure Cosmos DB database account. Within each account, you can have multiple containers for different workloads or microservices that access data for a tenant, each with dedicated throughput (RU/s). You can also use [Azure Cosmos DB fleets](/azure/cosmos-db/fleet) to optimize your cost by [sharing throughput (RU/s) across different database accounts](/azure/cosmos-db/fleet-pools), as well as [monitor your fleet of database accounts](/azure/cosmos-db/how-to-enable-fleet-analytics) at scale.

### Benefits

- **High isolation:** This approach avoids contention or noisy neighbor because each tenant's data is in their own dedicated Azure Cosmos DB account, with dedicated RU/s on each container within the account.
- **Custom service-level agreements (SLAs):** Each tenant has its own account, so you can provide specific tailored resources, customer-facing SLAs, and guarantees because you can tune the resources in each tenant's database account independently to meet their performance needs.
- **Enhanced security:** This approach allows the provider to offer customer managed keys per tenant by enabling it at the database account level. If customer managed keys are a requirement, use database account per tenant isolation.
- **Flexibility:** You can enable account-level features like geo-replication, point-in-time restore, and customer-managed keys at a per-tenant (database account) level as needed.

### Trade-offs / considerations

- **More accounts to manage:** This approach can be more complex because you have multiple Azure Cosmos DB accounts, each representing a tenant or customer.  However, with Azure Cosmos DB fleets, you can simplify your management by sharing throughput (RU/s) across multiple database accounts and use fleet analytics to monitor your usage at scale.
- **Cross-tenant query limitations:** All tenants are in different accounts, so applications that query multiple tenants require multiple calls within the application's logic. Typically, these cross tenant queries are not part of the core transactional workload that provides the service to each tenant; rather they may be part of an analytical workload to help the provider understand broader trends and usage across different tenants or customers. For these use cases, consider using [Fabric mirror](fabric/mirroring/azure-cosmos-db).

### Azure Cosmos DB features for multitenancy

- **Azure Cosmos DB fleet pools:** Azure Cosmos DB fleets are designed to help customers building multi-tenant applications manage, monitor, and optimize their fleet of database accounts. Within a fleet, you can organize your tenants (database accounts) into logical groupings called a fleetspace. At the fleetspace level, you can configure an optional [pool of throughput (RU/s)](/azure/cosmos-db/fleet-pools) that can be shared across all database accounts in the fleetspace, which helps optimize your cost.

Many providers create a fleet for each region they operate in and further separate the tenants into fleetspaces based on tenant performance requirements, or "class of tenant." For example, for their East US 2 fleet, a provider might create one fleetspace for accounts belonging to tenants using a free trial (less pool RU/s required) and another fleetspace for accounts belonging to tenants who have signed an enterprise agreement (more RU/s required). 

These pools let you share RU/s across multiple accounts, even if they span different subscriptions and resource groups within a fleet. While the resources in each account retain its own dedicated RU/s, pools allow accounts to automatically use extra RU/s when needed from the shared pool. This helps avoid overprovisioning. Rather than provisioning every tenant's containers for peak RU/s, which can be expensive, you can set a typical RU/s per container and use the pool's shared capacity to handle any spikes. To protect against noisy neighbor, by design, any throughput provisioned on a container is dedicated and guaranteed to always be available to that container, while the shared pool RU/s can be used by any container that needs more throughput. This enables you to suport database account per tenant isolation while remaining cost effective.
- **Azure Cosmos DB fleet analytics:** 
You can enable fleet analytics for your fleet to monitor usage and track historical trends across tenants at scale. Fleet analytics streams usage and cost data for every database account, database, and container within the fleet to either Microsoft Fabric or an Azure Storage account, enabling long-term analysis of accounts within your fleet. You can track trends like which accounts are most active, how resources scale over time, and when access keys were last rotated. The raw telemetry data is also available to allow you to write custom queries or build PowerBI dashboards to analyze your fleet.
- **Security features:** This model provides increased data access security isolation via [Azure role-based access control (RBAC)](/azure/cosmos-db/role-based-access-control). This is also the only model that provides tenant level security isolation through [customer-managed keys](/azure/cosmos-db/how-to-setup-customer-managed-keys).
 
- **Custom configuration:** You can configure the location of the database account according to the tenant's requirements. You can also tune the configuration of Azure Cosmos DB features, such as geo-replication and customer-managed encryption keys, to suit each tenant's requirements. 

When you use a dedicated Azure Cosmos DB account per tenant, consider the [maximum number of Azure Cosmos DB accounts per Azure subscription](/azure/cosmos-db/concepts-limits#resource-limits). 

## Complete list of isolation models

| Workload need | Partition key per tenant (recommended) | Container per tenant (shared throughput) | Container per tenant (dedicated throughput) | Database per tenant | Database account per tenant (recommended) |
|---|:---:|:---:|:---:|:---:|:---:|
| Queries across tenants | Easy (container acts as boundary for   queries) | Hard | Hard | Hard | Hard |
| Tenant density | High (lowest cost per tenant) | Medium | Low | Low | Low |
| Tenant data deletion | Easy| Easy (drop container when tenant leaves) | Easy (drop container when tenant leaves) | Easy (drop database when tenant leaves) | Easy (drop database when tenant leaves) |
| Data access security isolation | Need to implement within the   application | Container RBAC | Container RBAC | Database RBAC | RBAC |
| Geo-replication | Per tenant geo-replication not possible | Group tenants within database accounts   based on requirements | Group tenants within database accounts   based on requirements | Group tenants within database accounts   based on requirements | Group tenants within database accounts   based on requirements |
| Noisy neighbor prevention | No | No | Yes | Yes | Yes |
| New tenant creation latency | Immediate | Fast | Fast | Medium | Slow |
| Data modeling advantages | None | Entity colocation | Entity colocation | Multiple containers to model tenant   entities | Multiple containers and databases to   model tenants |
| Encryption key | Same for all tenants | Same for all tenants | Same for all tenants | Same for all tenants | Customer-managed key per tenant |
| Throughput requirements | >0 RUs per tenant | >100 RUs per tenant | >100 RUs per tenant (with autoscale only, otherwise >400 RUs per tenant) | >400 RUs per tenant | >400 RUs per tenant |
| Example use case | B2C apps | Standard offer for B2B apps | Premium offer for B2B apps | Premium offer for B2B apps | Premium offer for B2B apps |


### Container-per-tenant model

You can provision dedicated containers for each tenant. Dedicated containers work well when you can combine the data that you store for your tenant into a single container. This model provides greater performance isolation than the partition-key-per-tenant model. It also provides increased data access security isolation via [Azure RBAC](/azure/cosmos-db/role-based-access-control). 

When you use a container for each tenant, consider sharing throughput with other tenants by provisioning throughput at the database level. Consider the restrictions and limits for the [minimum number of RUs for your database](/azure/cosmos-db/concepts-limits#minimum-throughput-limits) and the [maximum number of containers in the database](/azure/cosmos-db/concepts-limits#provisioned-throughput-1). Also consider whether your tenants require a guaranteed level of performance and whether they're susceptible to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). When you share throughput at the database level, the workload or storage across all the containers should be relatively uniform. Otherwise you might have a noisy neighbor problem if you have one or more large tenants. If necessary, plan to group these tenants into different databases that are based on workload patterns.

Alternatively, you can provision dedicated throughput for each container. This approach works well for larger tenants and for tenants that are at risk of the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). But the baseline throughput for each tenant is higher, so consider the minimum requirements and cost implications of this model.

If your tenant data model requires more than one entity, and if all entities can share the same partition key, you can colocate them in the same container. But if the tenant data model is more complex, and it requires entities that can't share the same partition key, consider the database-per-tenant or database-account-per-tenant models. For more information, see [Model and partition data on Azure Cosmos DB](/azure/cosmos-db/nosql/how-to-model-partition-example).

Lifecycle management is generally simpler when you dedicate containers to tenants. You can [easily move tenants between shared and dedicated throughput models](/azure/cosmos-db/set-throughput#set-throughput-on-a-database-and-a-container). And when you deprovision a tenant, you can quickly delete the container.

### Database-per-tenant model

You can provision databases for each tenant in the same database account. Like the container-per-tenant model, this model provides greater performance isolation than the partition-key-per-tenant model. It also provides increased data access security isolation via [Azure RBAC](/azure/cosmos-db/role-based-access-control). 

Similar to the account-per-tenant model, this approach provides the highest level of performance isolation, but it provides the lowest tenant density. Use this option if each tenant requires a more complicated data model than is feasible in the container-per-tenant model. Or follow this approach if new tenant creation must be fast or free of any overhead up front. For some software development frameworks, the database-per-tenant model might be the only level of performance isolation that the framework supports. Such frameworks don't typically support entity (container) level isolation and entity colocation.

## Features of Azure Cosmos DB that support multitenancy

### Partitioning

Use partitions with your Azure Cosmos DB containers to create containers that multiple tenants share. Typically you use the tenant identifier as a partition key, but you might also consider using multiple partition keys for a single tenant. A well-planned partitioning strategy effectively implements the [Sharding pattern](../../../patterns/sharding.yml). When you have large containers, Azure Cosmos DB spreads your tenants across multiple physical nodes to achieve a high degree of scale.

Consider [hierarchical partition keys](/azure/cosmos-db/hierarchical-partition-keys) to help improve the performance of your multitenant solution. Use hierarchical partition keys to create a partition key that includes multiple values. For example, you might use a hierarchical partition key that includes the tenant identifier, like a high-cardinality GUID, to allow for almost unbounded scale. Or you can specify a hierarchical partition key that includes a property that queries frequently use. This approach helps you avoid cross-partition queries. Use hierarchical partition keys to scale beyond the logical partition limit of 20 GB per partition key value and limit expensive fan-out queries.

For more information, see the following resources:

- [Partitioning and horizontal scaling in Azure Cosmos DB](/azure/cosmos-db/partitioning-overview)
- [Hierarchical partition keys](/azure/cosmos-db/hierarchical-partition-keys)

### Manage RUs

The Azure Cosmos DB pricing model is based on the number of RU/s that you provision or consume. Azure Cosmos DB provides several options to provision throughput. In a multitenant environment, your selection affects the performance and price of your Azure Cosmos DB resources.

For tenants that require guaranteed performance and security isolation, we recommend that you isolate tenants by database account and allocate RUs to the tenant. For tenants that have less-stringent requirements, we recommend that you isolate tenants by partition key. Use this model to share RUs among your tenants and optimize the cost per tenant.

An alternative tenancy model for Azure Cosmos DB involves deploying separate containers for each tenant within a shared database. Use Azure Cosmos DB to provision RUs for a database so that all the containers share the RUs. If your tenant workloads don't typically overlap, this approach can help reduce your operational costs. But this approach is susceptible to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) because a single tenant's container might consume a disproportionate amount of the shared provisioned RUs. To mitigate this problem, first identify the noisy tenants. Then, you can optionally set provisioned throughput on a specific container. The other containers in the database continue to share their throughput, but the noisy tenant consumes their own dedicated throughput.

Azure Cosmos DB also provides a serverless tier, which suits workloads that have intermittent or unpredictable traffic. Alternatively, you can use autoscaling to configure policies that specify the scaling of provisioned throughput. You can also take advantage of Azure Cosmos DB burst capacity to maximize the usage of your provisioned throughput capacity, which is otherwise restricted by rate limits. In a multitenant solution, you might combine all these approaches to support different types of tenants.

> [!NOTE]
> When you plan your Azure Cosmos DB configuration, consider the [service quotas and limits](/azure/cosmos-db/concepts-limits).

To monitor and manage the costs that are associated with each tenant, remember that every operation that uses the Azure Cosmos DB API includes the RUs consumed. You can use this information to aggregate and compare the actual RUs that each tenant consumes. You can then identify tenants that have different performance characteristics.

For more information, see the following resources:

- [Provisioned throughput](/azure/cosmos-db/set-throughput)
- [Autoscale](/azure/cosmos-db/provision-throughput-autoscale)
- [Serverless](/azure/cosmos-db/serverless)
- [Measure the RU charge of a request](/azure/cosmos-db/optimize-cost-reads-writes#measuring-the-ru-charge-of-a-request)
- [Azure Cosmos DB service quotas](/azure/cosmos-db/concepts-limits)
- [Burst capacity](/azure/cosmos-db/burst-capacity)

### Customer-managed keys

Some tenants might require the use of their own encryption keys. Azure Cosmos DB provides a customer-managed key feature. You apply this feature at the level of an Azure Cosmos DB account. So if tenants require their own encryption keys, you must use dedicated Azure Cosmos DB accounts to deploy the tenants.

For more information, see [Configure customer-managed keys for your Azure Cosmos DB account with Azure Key Vault](/azure/cosmos-db/how-to-setup-cmk).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Tara Bhatia](https://www.linkedin.com/in/tarabhatia01/) | Program Manager, Azure Cosmos DB
- [Paul Burpo](https://www.linkedin.com/in/paul-burpo) | Principal Customer Engineer, FastTrack for Azure
- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Mark Brown](https://www.linkedin.com/in/markjbrown1) | Principal PM Manager, Azure Cosmos DB
- [Deborah Chen](https://www.linkedin.com/in/deborah-chen-62212437) | Principal Program Manager
- [Theo van Kraay](https://www.linkedin.com/in/theo-van-kraay-3388b130) | Senior Program Manager, Azure Cosmos DB
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- Thomas Weiss | Principal Program Manager
- [Vic Perdana](https://www.linkedin.com/in/vperdana) | Cloud Solution Architect, Azure ISV

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn more about multitenancy and Azure Cosmos DB:

- [Design and build multitenant SaaS apps at scale with Azure Cosmos DB](https://www.youtube.com/watch?v=dd7W_kMh-z4): A session at Build 2024 that walks you through how to design for multitenancy on Azure Cosmos DB and learn best practices from a real-world independent software vendor.
- [Azure Cosmos DB and multitenant systems](https://azure.microsoft.com/blog/azure-cosmos-db-and-multi-tenant-systems): A blog post that discusses how to build a multitenant system that uses Azure Cosmos DB.
- [Video: Multitenant applications with Azure Cosmos DB](https://www.youtube.com/watch?v=fOQoQnQqwwU)
- [Video: Build a multitenant SaaS with Azure Cosmos DB and Azure](https://www.youtube.com/watch?v=Tht_RV5QPJ0): A real-world case study about how Whally, a multitenant SaaS startup, builds a modern platform from scratch on Azure Cosmos DB and Azure. Whally shows the design and implementation decisions they make that relate to partitioning, data modeling, secure multitenancy, performance, and real-time streaming from change feed to SignalR. All these solutions use ASP.NET Core on Azure App Service.

## Related resources

Refer to some of our other Azure Cosmos DB architectural scenarios:

- [Storage and data approaches for multitenancy](../approaches/storage-data.md)
- [Transactional Outbox pattern with Azure Cosmos DB](../../../databases/guide/transactional-out-box-cosmos.md)
