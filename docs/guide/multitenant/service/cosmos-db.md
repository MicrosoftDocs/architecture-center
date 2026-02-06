---
title: Multitenancy and Azure Cosmos DB
description: Learn about features of Azure Cosmos DB that you can use with multitenant systems. Find other resources about how to use Azure Cosmos DB in a multitenant solution.
author: deborahc
ms.author: dech
ms.date: 11/16/2024
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy and Azure Cosmos DB

This article describes features of Azure Cosmos DB that you can use for multitenant systems. It provides guidance and examples about how to use Azure Cosmos DB in a multitenant solution.

## Multitenancy requirements

When you plan a multitenant solution, you have two key requirements:
- Help ensure strong isolation between tenants, and meet stringent security requirements for those who need them.
- Maintain a low cost per tenant. As the provider, ensure that the cost to run the application remains sustainable as it scales.

These two needs can often conflict and introduce a trade-off where you must prioritize one over the other. The guidance in this article can help you better understand the trade-offs that you must make to address these needs. This article helps you navigate these considerations so you can make informed decisions when you design your multitenant solution.

## Isolation models

Determine the level of isolation that you need between your tenants. Azure Cosmos DB supports a range of isolation models, but for most solutions we recommend that you use one of the following strategies:

- A partition key per tenant is often used for fully multitenant solutions, like business-to-consumer software as a service (B2C SaaS) solutions.
- A database account per tenant is often used for business-to-business (B2B) SaaS solutions.

To choose the most appropriate isolation model, consider your business model and the tenants' requirements. For example, strong performance isolation might not be a priority for some B2C models where a business sells a product or service directly to an individual customer. However, B2B models might prioritize strong security and performance isolation and might require that tenants have their own provisioned database account.

You can also combine multiple models to suit different customer needs. For example, suppose you build a B2B SaaS solution that you sell to enterprise customers, and you provide a free trial for potential new customers. You might deploy a separate database account for paid enterprise tenants that need strong security and isolation guarantees. And you might share a database account and use partition keys to isolate trial customers.

## Recommended isolation models

The partition-key-per-tenant model and the database-account-per-tenant model are the most common isolation models for multitenant solutions. These models provide the best balance between tenant isolation and cost efficiency.

### Partition-key-per-tenant model

If you isolate your tenants by partition key, throughput is shared across tenants and managed within the same container.

> [!NOTE]
> A *request unit* (RU) is a logical abstraction of the cost of a database operation or query. Typically, you provision a defined number of request units per second (RU/s) for your workload, which is referred to as *throughput*. 

#### Benefits

- **Cost efficiency:** You place all tenants in one container, which is partitioned by the tenant ID. This approach has only one billable resource that provisions and shares RUs among multiple tenants. This model is usually more cost effective and easier to manage than having separate accounts for each tenant.

- **Simplified management:** You have fewer Azure Cosmos DB accounts to manage.

#### Trade-offs

- **Resource contention:** Shared throughput (RU/s) across tenants that are in the same container can lead to contention during peak usage. This contention can create [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) and performance challenges if your tenants have high or overlapping workloads. Use this isolation model for workloads that need guaranteed RUs on a single tenant and can share throughput.

- **Limited isolation:** This approach provides logical isolation, not physical isolation. It might not meet strict isolation requirements from a performance or security perspective.
- **Less flexibility:** You can't customize account-level features, like geo-replication, point-in-time restore, and customer-managed keys, for each tenant if you isolate by partition key or by database or container. 

#### Azure Cosmos DB features for multitenancy

- **Control your throughput:** Explore features that can help control the noisy neighbor problem when you use a partition key to isolate tenants. Use features such as [throughput reallocation](/azure/cosmos-db/nosql/distribute-throughput-across-partitions), [burst capacity](/azure/cosmos-db/burst-capacity), and [throughput control](/azure/cosmos-db/nosql/throughput-control-spark) in the [Java SDK](/azure/cosmos-db/nosql/sdk-java-v4).

- **Hierarchical partition keys:** Use Azure Cosmos DB so that each logical partition can increase in size up to 20 GB. If you have a single tenant that needs to store more than 20 GB of data, consider spreading the data across multiple logical partitions. For example, instead of having a single partition key of `Contoso`, you might distribute the partition keys by creating multiple partition keys for a tenant, such as `Contoso1` and `Contoso2`.
    
    When you query data for a tenant, you can use the `WHERE IN` clause to match all partition keys. You can also use [hierarchical partition keys](/azure/cosmos-db/hierarchical-partition-keys) to provide large tenants with storage greater than 20 GB if you have a high cardinality of tenants. You don't have to use synthetic partition keys or multiple partition key values per tenant for this method.

    Suppose you have a workload that isolates tenants by partition key. One tenant, Contoso, is larger and more write-heavy than others, and it continues to grow in size. To avoid the risk of not being able to ingest more data for this tenant, you can use hierarchical partition keys. Specify `TenantID` as the first level key, and then add a second level like `UserId`. If you anticipate the `TenantID` and `UserID` combination to produce logical partitions that exceed the 20-GB limit, you can partition further down to another level, such as `SessionID`. Queries that specify either `TenantID` or both `TenantID` and `UserID` are effectively routed to only the subset of physical partitions that contain the relevant data, which avoids a full fan-out query. If the container has 1,000 physical partitions but a specific `TenantId` value is only on five physical partitions, the query is routed to the smaller number of relevant physical partitions.

    If your first level doesn't have sufficiently high cardinality, and you reach the 20-GB logical partition limit on your partition key, consider using a synthetic partition key instead of a hierarchical partition key.

### Database-account-per-tenant model

If you isolate your tenants by database account, each tenant has its own throughput provisioned at the database level or container level. 

#### Benefits

- **High isolation:** This approach avoids contention or interference because of dedicated Azure Cosmos DB accounts and containers that have provisioned RUs per unique tenant.

- **Custom service-level agreements (SLAs):** Each tenant has its own account, so you can provide specific tailored resources, customer-facing SLAs, and guarantees because you can tune each tenant's database account independently for throughput.
- **Enhanced security:** Physical data isolation helps ensure robust security because customers can enable customer-managed keys at an account level per tenant. Each tenant's data is isolated by account, rather than being in the same container.
- **Flexibility:** Tenants can enable account-level features like geo-replication, point-in-time restore, and customer-managed keys as needed.

#### Trade-offs

- **Increased management:** This approach is more complex because you manage multiple Azure Cosmos DB accounts.

- **Higher costs:** More accounts mean that you must provision throughput on each resource, such as databases or containers, within the account for each tenant. Every time a resource provisions RUs, your Azure Cosmos DB costs increase.
- **Query limitations:** All tenants are in different accounts, so applications that query multiple tenants require multiple calls within the application's logic.

#### Azure Cosmos DB features for multitenancy

- **Security features:** This model provides increased data access security isolation via [Azure role-based access control (RBAC)](/azure/cosmos-db/role-based-access-control). This model also provides database encryption security isolation at the tenant level through [customer-managed keys](/azure/cosmos-db/how-to-setup-customer-managed-keys).
 
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
- [Transactional Outbox pattern with Azure Cosmos DB](../../../databases/guide/transactional-outbox-cosmos.yml)
