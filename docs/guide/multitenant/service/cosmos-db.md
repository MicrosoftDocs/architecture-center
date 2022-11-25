---
title: Azure Cosmos DB considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Cosmos DB that are useful when working with multitenanted systems, and links to guidance and examples for how to use Azure Cosmos DB in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 11/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-cosmos-db
categories:
  - data
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Cosmos DB

On this page, we describe some of the features of Azure Cosmos DB that are useful when working with multitenanted systems, and we link to guidance and examples for how to use Azure Cosmos DB in a multitenant solution.

## Features of Azure Cosmos DB that support multitenancy

### Partitioning

By using partitions with your Azure Cosmos DB containers, you can create containers that are shared across multiple tenants. Typically you use the tenant identifier as a partition key, but you might also consider using multiple partition keys for a single tenant. A well-planned partitioning strategy effectively implements the [Sharding pattern](../../../patterns/sharding.yml). With large containers, Azure Cosmos DB spreads your tenants across multiple physical nodes to achieve a high degree of scale.

More information:

- [Partitioning and horizontal scaling in Azure Cosmos DB](/azure/cosmos-db/partitioning-overview)
- [Hierarchical partition keys](https://devblogs.microsoft.com/cosmosdb/hierarchical-partition-keys-private-preview/)

### Managing request units

Azure Cosmos DB pricing model is based on the number of *request units* per second that you provision or consume. A request unit is a logical abstraction of the cost of a database operation or query. Typically, you provision a defined number of request units per second for your workload, which is referred to as *throughput*. Azure Cosmos DB provides several options for how you provision throughput. In a multitenant environment, the selection you make affects the performance and price of your Azure Cosmos DB resources.

One tenancy model for Azure Cosmos DB involves deploying separate containers for each tenant within a shared database. Azure Cosmos DB enables you to provision request units for a database, and all of the containers share the request units. If your tenant workloads don't typically overlap, this can provide a useful approach to reduce your operational costs. However, note that this approach is susceptible to the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) because a single tenant's container might consume a disproportionate amount of the shared provisioned request units. To mitigate this after you've identified noisy tenants, you can optionally set provisioned throughput on a specific container. The other containers in the database continue to share their throughput, but the noisy tenant consumes their own dedicated throughput.

Azure Cosmos DB also provides a serverless tier, which is suited for workloads with intermittent or unpredictable traffic. Alternatively, autoscaling enables you to configure policies to specify the scaling of provisioned throughput. In a multitenant solution, you might combine all of these approaches to support different types of tenant.

> [!NOTE]
> When planning your Azure Cosmos DB configuration, ensure you consider the [service quotas and limits](/azure/cosmos-db/concepts-limits).

To monitor and manage the costs that are associated with each tenant, every operation using the Azure Cosmos DB API includes the request units consumed. You can use this information to aggregate and compare the actual request units consumed by each tenant, and you can then identify tenants with different performance characteristics.

More information:

- [Provisioned throughput](/azure/cosmos-db/set-throughput)
- [Autoscale](/azure/cosmos-db/provision-throughput-autoscale)
- [Serverless](/azure/cosmos-db/serverless)
- [Measuring the RU charge of a request](/azure/cosmos-db/optimize-cost-reads-writes#measuring-the-ru-charge-of-a-request)
- [Azure Cosmos DB service quotas](/azure/cosmos-db/concepts-limits)

### Customer-managed keys

Some tenants might require the use of their own encryption keys. Azure Cosmos DB provides a customer-managed key feature. This feature is applied at the level of an Azure Cosmos DB account, so tenants who require their own encryption keys need to be deployed using dedicated Azure Cosmos DB accounts.

More information:

- [Configure customer-managed keys for your Azure Cosmos DB account with Azure Key Vault](/azure/cosmos-db/how-to-setup-cmk)

## Isolation models

When working with a multitenant system that uses Azure Cosmos DB, you need to make a decision about the level of isolation you want to use. Azure Cosmos DB supports several isolation models:


|                         | Partition key per tenant                                                                                                                                                                                                      | Container per tenant (shared throughput)                                                                                                                                                                        | Container per tenant (dedicated throughput)                                                                                                           | Database per tenant                                                                                           | Database account per tenant |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-----------------------------|
| Isolation options       | <ul><li>Share throughput across tenants grouped by container to mitigate noisy neighbor blast radius.</li> <li>Enables easy queries across tenants (containers act as boundary for queries).</li> <li>Provides highest tenant density (lowest cost per tenant).</li></ul>| <ul><li>Share throughput across tenants that are grouped by database to  mitigate noisy neighbor blast radius.</li> <li>Easy management of tenants (drop the container when the tenant leaves).</li><li>Data access security isolation via RBAC.</il></ul> | <ul><li>Independent throughput options (dedicated throughput eliminates noisy neighbors).</li> <li>Group tenants within database account(s), based on geo-replication requirements.</li><li>Data access security isolation via RBAC.</il></ul> |<ul><li>Faster creation of tenant than with tenant-per-account.</il><li>Data modeling advantages over container-per-tenant (use multiple containers to model tenent entities).</il><li>Application framework advantages - some database frameworks only support isolation at the database logical level natively.</il><li>Group tenants within database account(s), based on geo-replication requirements.</li><li>Data access security isolation via RBAC.</il></ul>  | <ul><li>Independent geo-replication knobs.</il><li>Data modeling advantages for complex tenants over container-per-tenant or database-per-tenant (use multiple containers and databases to model tenant).</il><li>Data access security isolation via RBAC.</il><li>Database encryption security isolation via customer managed key.</il><li>Multiple throughput options (dedicated throughput eliminates noisy neighbors).</il></ul>                        |
| Throughput requirements | >0 RUs per tenant                                                                                                                                                                                                                                     | >100 RUs per tenant                                                                                                                                                                                                                                            | >400 RUs per tenant                                                                                                                                      | >400 RUs per tenant                                                                                                   | >400 RUs per tenant                        |
| Example use case        | B2C apps                                                                                                                                                                                                                                              | Standard offer for B2B apps                                                                                                                                                                                                                                    | Premium offer for B2B apps                                                                                                                               | Premium offer for B2B apps                                                                                            | Premium offer for B2B apps                        |


### Partition key per tenant

When you use a single container for multiple tenants, you can make use of Azure Cosmos DB partitioning support. By using separate partition keys for each tenant, you can easily query the data for a single tenant. You can also query across multiple tenants, even if they are in separate partitions. However, [cross-partition queries](/azure/cosmos-db/sql/how-to-query-container#cross-partition-query) have a higher request unit (RU) cost than single-partition queries.

This approach tends to work well when the amount of data stored for each tenant is small. It can be a good choice for building a [pricing model](../considerations/pricing-models.md) that includes a free tier, and for business-to-consumer (B2C) solutions. In general, by using shared containers, you achieve the highest density of tenants and therefore the lowest price per tenant.

It's important to consider the throughput of your container. All of the tenants will share the container's throughput, so the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) can cause performance challenges if your tenants have high or overlapping workloads. This problem can sometimes be mitigated by grouping subsets of tenants into different containers, and by ensuring that each tenant group has compatible usage patterns. Alternatively, you can consider a hybrid multi- and single-tenant model, where smaller tenants are grouped into shared partitioned containers, and large customers have dedicated containers. Additionally, there are features that can help control the noisy neighbour problem when modeling tenant by partition, such as [throughput reallocation](/azure/cosmos-db/nosql/distribute-throughput-across-partitions), [burst capacity](/azure/cosmos-db/burst-capacity), and [throughput control](/azure/cosmos-db/nosql/throughput-control-spark) in the [Java SDK](/azure/cosmos-db/nosql/sdk-java-v4).

It's also important to consider the amount of data you store in each logical partition. Azure Cosmos DB allows each logical partition to grow to up to 20 GB. If you have a single tenant that needs to store more than 20 GB of data, consider spreading the data across multiple logical partitions. For example, instead of having a single partition key of `Contoso`, you might *salt* the partition keys by creating multiple partition keys for a tenant, such as `Contoso1`, `Contoso2`, and so forth. When you query the data for a tenant, you can use the `WHERE IN` clause to match all of the partition keys. [Hierarchical partition keys](https://devblogs.microsoft.com/cosmosdb/hierarchical-partition-keys-private-preview) can also be used to support large tenants.

Consider the operational aspects of your solution, and the different phases of the [tenant lifecycle](../considerations/tenant-lifecycle.md). For example, when a tenant moves to a dedicated pricing tier, you will likely need to move the data to a different container. When a tenant is deprovisioned, you need to run a delete query on the container to remove the data, and for large tenants, this query might consume a significant amount of throughput while it executes.

### Container per tenant

You can provision dedicated containers for each tenant. This can work well when the data you store for your tenant can be combined into a single container. This model provides greater performance isolation than the container-per-partition key model above, and also provides additional data access security isolation via [Azure RBAC](/azure/cosmos-db/role-based-access-control). 

When using a container for each tenant, you can consider sharing throughput with other tenants by provisioning throughput at the database level. Consider the restrictions and limits around the [minimum number of request units for your database](/azure/cosmos-db/concepts-limits#minimum-throughput-limits) and the [maximum number of containers in the database](/azure/cosmos-db/concepts-limits#provisioned-throughput-1). Also, consider whether your tenants require a guaranteed level of performance, and whether they're susceptible to the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). If necessary, plan to group tenants into different databases that are based on workload patterns.

Alternatively, you can provision dedicated throughput for each container. This works well for larger tenants, and for tenants that are at risk of the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). However, the baseline throughput for each tenant is higher, so consider the minimum requirements and cost implications of this model.

Lifecycle management is generally simpler when containers are dedicated to tenants. You can [easily move tenants between shared and dedicated throughput models](/azure/cosmos-db/set-throughput#set-throughput-on-a-database-and-a-container), and when deprovisioning a tenant, you can quickly delete the container.

### Database per tenant

You can provision databases for each tenant, in the same database account. Like the container-per-tenant model above, this model provides greater performance isolation than the container-per-partition key model, and also provides additional data access security isolation via [Azure RBAC](/azure/cosmos-db/role-based-access-control). 

Like the account-per-tenant model below, this approach gives the highest level of performance isolation, but the lowest tenant density. However, this is the best option when each tenant requires a more complicated data model than is feasible in the container-per-tenant model, and when it is a requirement for new tenant creation to be fast and/or free of any overhead to create tenant accounts up-front. It may also be tha case that for the specific software development framework being used, database-per-tenant is the only level of performance isolation recognised in that framework - entity (container) level isolation is not typically supported natively in such frameworks.

### Database account per tenant

Azure Cosmos DB enables you to provision separate database accounts for each tenant, which provides the highest level of isolation, but the lowest density. Like the container-per-tenant and database-per-tenant models above, this model provides greater performance isolation than the container-per-partition key model, and also provides additional data access security isolation via [Azure RBAC](/azure/cosmos-db/role-based-access-control). In addition, this model also provides database encyrption security isolation at the tenant level via [customer managed keys](/azure/cosmos-db/how-to-setup-customer-managed-keys). 

A single database account is dedicated to a tenant, which means they are not subject to the noisy neighbor problem. You can also configure the location of the database account according to the tenant's requirements, and you can tune the configuration of Azure Cosmos DB features, such as geo-replication and customer-managed encryption keys, to suit each tenant's requirements. When using a dedicated Azure Cosmos DB account per tenant, consider the [maximum number of Azure Cosmos DB accounts per Azure subscription](/azure/cosmos-db/concepts-limits#control-plane-operations). 

If using this model, you should consider how fast your application needs to be able to generate new tenants - account creation in Azure Cosmos DB can take up to 15 minutes, so it may be required to create accounts up-front. If this is not feasible, consider the database per tenant model.

If you allow tenants to migrate from a shared account to a dedicated Azure Cosmos DB account, consider the migration approach you'll use to move a tenant's data between the old and new accounts.

### Hybrid approaches

You can consider a combination of the above approaches to suit different tenants' requirements and [your pricing model](../considerations/pricing-models.md). For example:

- Provision all free trial customers within a shared container, and use the tenant ID or a [synthetic key partition key](/azure/cosmos-db/sql/synthetic-partition-keys).
- Offer a paid *Bronze* tier that deploys a dedicated container per tenant, but with [shared throughput on a database](/azure/cosmos-db/set-throughput#set-throughput-on-a-database).
- Offer a higher *Silver* tier that provisions dedicated throughput for the tenant's container.
- Offer the highest *Gold* tier, and provide a dedicated database account for the tenant, which also allows tenants to select the geography for their deployment.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paul Burpo](http://linkedin.com/in/paul-burpo) | Principal Customer Engineer, FastTrack for Azure
- [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

- [Mark Brown](https://www.linkedin.com/in/markjbrown1) | Principal PM Manager, Azure Cosmos DB
- [Theo van Kraay](https://www.linkedin.com/in/theo-van-kraay-3388b130/) | Senior Program Manager, Azure Cosmos DB
- [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- Thomas Weiss | Principal Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).

## Related resources

- [Azure Cosmos DB and multitenant systems](https://azure.microsoft.com/blog/azure-cosmos-db-and-multi-tenant-systems): A blog post that discusses how to build a multitenant system that uses Azure Cosmos DB.
- [Multitenant applications with Azure Cosmos DB](https://www.youtube.com/watch?v=fOQoQnQqwwU) (video)
- [Building a multitenant SaaS with Azure Cosmos DB and Azure](https://www.youtube.com/watch?v=Tht_RV5QPJ0) (video): A real-world case study of how Whally, a multitenant SaaS startup, built a modern platform from scratch on Azure Cosmos DB and Azure. Whally shows the design and implementation decisions they made that relate to partitioning, data modeling, secure multitenancy, performance, real-time streaming from change feed to SignalR, and more, all using ASP.NET Core on Azure App Services.
