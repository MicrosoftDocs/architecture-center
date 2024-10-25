---
title: Azure Cosmos DB considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Cosmos DB that are useful when working with multitenant systems, and links to guidance and examples for how to use Azure Cosmos DB in a multitenant solution.
author: tarabhatiamsft
ms.author: tarabhatia
ms.date: 07/07/2023
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
products:
  - azure
  - azure-cosmos-db
categories:
  - data
ms.custom:
  - guide
  - arb-saas
---

# Multitenancy and Azure Cosmos DB

On this page, we describe some of the features of Azure Cosmos DB that are useful when you're working with multitenant systems. We also link to guidance and examples for how to use Azure Cosmos DB in a multitenant solution.

## Multitenancy requirements

When you plan a multitenant solution, there are two key needs you may need to design for:
- Ensuring strong isolation between tenants, and meeting stringent security requirements for those who need them.
- Maintaining a low cost per tenant. As the provider, you want to ensure that the cost of running the application remains sustainable as it scales.

These two needs can often conflict, requiring tradeoffs and prioritizing one over the other. There are some guidelines you can follow to better understand the trade-offs involved in addressing both of the needs described above. This document helps you navigate these considerations so you can make informed decisions when designing your multitenant solution.

## Isolation models

You need to decide the level of isolation between your tenants. Azure Cosmos DB supports a range of isolation models, but for most solutions we recommend you use one of the following strategies:

- Partition key per tenant, which is often used for fully multitenant solutions like those used in business-to-consumer software as a service (B2C SaaS).
- Database account per tenant, which is often. used in business-to-business (B2B) SaaS.

To select the most appropriate isolation model, consider your business model and the tenants' requirements. For example, strong performance isolation may not be a priority for some B2C models where businesses sell directly to an individual customer using the product or service. However, B2B models may prioritize strong security and performance isolation, and might require tenants to have their own database account provisioned.

You can also combine multiple models together to suit different customer needs. For example, suppose you're building a B2B SaaS solution that you sell to enterprise customers as well as providing a free trial for potential new customers. You might deploy a separate database account for paid enterprise tenants, who need strong security and isolation guarantees, while sharing a database account and using partition keys for isolating trial customers.

## Recommended isolation models

### Partition key per tenant

By isolating our tenants by partition key, throughput will be shared across tenants and grouped them within the same container. 

**Benefits:**
- **Cost efficiency:** All tenants are placed within one container, which is partitioned by tenant ID. Because there is only one billable resource where RU/s are provisioned and shared amongst multiple tenants, this approach is usually more cost-effective and easier to manage than having separate accounts per tenant.
- **Simplified management:** Fewer Azure Cosmos DB accounts to manage.

**Tradeoffs:**
- **Resource contention:** Sharing throughput (RU/s) across tenants in the same container can lead to contention during peak usage, resulting in the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) which can cause performance challenges if your tenants have high or overlapping workloads. This isolation model is appropriate for workloads that do need guaranteed RU/s on a single tenant and can share.
- **Limited isolation:** This approach provides logical isolation, not physical isolation. It might not meet strict isolation requirements, whether from a performance and security perspective.
- **Less Flexibility:** Customizing account-level features like geo-replication, point-in-time restore (PITR), and customer-managed keys (CMK) per tenant are not available if isolating by partition key (or by database/container). 

**Relevant Azure Cosmos DB features:**
- **Control your throughput:** Explore features that can help control the noisy neighbor problem when modeling tenant by partition, such as [throughput reallocation](/azure/cosmos-db/nosql/distribute-throughput-across-partitions), [burst capacity](/azure/cosmos-db/burst-capacity), and [throughput control](/azure/cosmos-db/nosql/throughput-control-spark) in the [Java SDK](/azure/cosmos-db/nosql/sdk-java-v4).
- **Hierarchical partition keys:** Azure Cosmos DB allows each logical partition to grow to up to 20 GB. If you have a single tenant that needs to store more than 20 GB of data, consider spreading the data across multiple logical partitions. For example, instead of having a single partition key of `Contoso`, you might *salt* the partition keys by creating multiple partition keys for a tenant, such as `Contoso1`, `Contoso2`, and so forth.
    
    When you query the data for a tenant, you can use the `WHERE IN` clause to match all of the partition keys. [Hierarchical partition keys](/azure/cosmos-db/hierarchical-partition-keys) can also be used to support large tenants (provided you have high cardinality of tenants), with storage greater than 20 GB, without having to use synthetic partition keys or multiple partition key values per tenant.

    Suppose you have a workload that isolates tenants by partition key. One tenant, Contoso, is much larger and more write-heavy than others, and it's continuing to grow in size. To avoid the risk of not being able to ingest more data for this tenant, you can use hierarchical partition keys. Specify `TenantID` as the first level key, and then add a second level like `UserId`. If you anticipate the `TenantID` and `UserID` combination to produce logical partitions that exceed the 20 GB limit, you can partition further down to another level such as `SessionID`. Queries that specify either `TenantID`, or both `TenantID` and `UserID`, are effectively routed to only the subset of physical partitions that contain the relevant data, which avoids a full fan-out query. If the container had 1,000 physical partitions, but a specific `TenantId` value was only on 5 physical partitions, the query would be routed to the smaller number of relevant physical partitions.
- If your first level does not have high cardinality and you are hitting the 20 GB logical partition limit on your partition key today, we suggest using a synthetic partition key instead of a hierarchical partition key.

### Database account per tenant
By isolating our tenants by database account, each tenant will have its own throughput provisioned at the database level or container level. 

**Benefits:**
- **High isolation:** This approach avoids contention or interference due to dedicated Azure Cosmos DB accounts and containers with provisioned RU/s per unique tenant.
- **Custom SLAs:** Due to each tenant having its own account, you can provide specific tailored resources, customer-facing SLAs, and guarantees because each tenant's database account can be tuned independently for throughput.
- **Enhanced security:** Physical data isolation ensures robust security since customers can enable customer managed keys at an account level per tenant. Each tenant's data is isolated by account, rather than being in the same container.
- **Flexibility:** Tenants can enable account-level features like geo-replication, point-in-time restore (PITR), and customer-managed keys (CMK) as needed.

**Tradeoffs:**
- **Increased management:** This approach brings greater complexity because you manage multiple Azure Cosmos DB accounts.
- **Higher costs:** More accounts mean provisioning throughput (RU/s) on each resource (databases and/or containers) within the account, for each tenant. Every time a resource provisions RU/s, your Azure Cosmos DB costs increase.
- **Query limitations:** Because all tenants are within different accounts, multiple calls within the logic of the application to each tenant are needed when querying for multiple tenants. 

**Relevant Azure Cosmos DB features:**
- **Security features:** This model provides increased data access security isolation by using [Azure RBAC](/azure/cosmos-db/role-based-access-control). In addition, this model provides database encryption security isolation at the tenant level through [customer managed keys](/azure/cosmos-db/how-to-setup-customer-managed-keys). 
- **Custom configuration:** You can configure the location of the database account according to the tenant's requirements. You can also tune the configuration of Azure Cosmos DB features, such as geo-replication and customer-managed encryption keys, to suit each tenant's requirements. 

When using a dedicated Azure Cosmos DB account per tenant, consider the [maximum number of Azure Cosmos DB accounts per Azure subscription](/azure/cosmos-db/concepts-limits#control-plane-operations). 


## Hybrid approach scenario

You can consider a combination of the above approaches to suit different tenants' requirements and [your pricing model](../considerations/pricing-models.md). 

For example, let's say we are a financial application that keeps track of payments from around the world and store the documents with information like TenantId, PayerId, TransactionId, etc. Our business requirements focus on building an experience for two groups of users, each with distinct needs:
1. **Enterprise tenants:** These are our large customers who use our software to monitor their own transactions. They require strong tenant isolation for performance and security reasons, ensuring that financial data is not inadvertently shared across tenants.
1. **Free trial tenants:** These customers are evaluating whether our software meets their workload needs with a subset of data. Since this is a free experience, we aim to keep the cost of running it low for these tenants.

In this scenario, it makes sense to isolate our enterprise tenants by database account to ensure guaranteed performance and security for each tenant, while isolating our free trial tenants by partition key to maintain low costs per tenant.


## Complete list of isolation models
| Workload need | Partition key per tenant (recommended) | Container per tenant (shared throughput) | Container per tenant (dedicated throughput) | Database per tenant | Database account per tenant (recommended) |
|---|:---:|:---:|:---:|:---:|:---:|
| Queries across tenants | Easy (container acts as boundary for   queries) | Hard | Hard | Hard | Hard |
| Tenant density | High (lowest cost per tenant) | Medium | Low | Low | Low |
| Tenant data deletion | Easy| Easy (drop container when tenant leaves) | Easy (drop container when tenant leaves) | Easy (drop database when tenant leaves) | Easy (drop database when tenant leaves) |
| Data access security isolation | Needs to be implemented within the   application | Container RBAC | Container RBAC | Database RBAC | RBAC |
| Geo-replication | Per tenant geo-replication not possible | Group tenants within database accounts   based on requirements | Group tenants within database accounts   based on requirements | Group tenants within database accounts   based on requirements | Group tenants within database accounts   based on requirements |
| Noisy neighbor prevention | None | None | Yes | Yes | Yes |
| New tenant creation latency | Immediate | Fast | Fast | Medium | Slow |
| Data modeling advantages | None | entity colocation | entity colocation | Multiple containers to model tenant   entities | Multiple containers and databases to   model tenants |
| Encryption key | Same for all tenants | Same for all tenants | Same for all tenants | Same for all tenants | Customer managed key per tenant |
| Throughput requirements | >0 RUs per tenant | >100 RUs per tenant | >100 RUs per tenant (with autoscale only, otherwise >400 RUs per tenant) | >400 RUs per tenant | >400 RUs per tenant |
| Example use case(s) | B2C apps | Standard offer for B2B apps | Premium offer for B2B apps | Premium offer for B2B apps | Premium offer for B2B apps |


### Container per tenant

You can provision dedicated containers for each tenant. Dedicated containers work well when the data that you store for your tenant can be combined into a single container. This model provides greater performance isolation than the partition-key-per-tenant model above, and it also provides increased data access security isolation via [Azure RBAC](/azure/cosmos-db/role-based-access-control). 

When using a container for each tenant, you can consider sharing throughput with other tenants by provisioning throughput at the database level. Consider the restrictions and limits around the [minimum number of request units for your database](/azure/cosmos-db/concepts-limits#minimum-throughput-limits) and the [maximum number of containers in the database](/azure/cosmos-db/concepts-limits#provisioned-throughput-1). Also, consider whether your tenants require a guaranteed level of performance, and whether they're susceptible to the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). When you share throughput at the database level, the workload or storage across all the containers should be relatively uniform. Otherwise you might have a noisy neighbor issue, if there are one or more large tenants. If necessary, plan to group these tenants into different databases that are based on workload patterns.

Alternatively, you can provision dedicated throughput for each container. This approach works well for larger tenants and for tenants that are at risk of the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). However, the baseline throughput for each tenant is higher, so consider the minimum requirements and cost implications of this model.

If your tenant data model requires more than one entity, as long as all entities can share the same partition key, they can be colocated in the same container. However, if the tenant data model is more complex, and it requires entities that can't share the same partition key, consider the database-per-tenant or database-account-per-tenant models below. Take a look at our article on [how to model and partition data on Azure Cosmos DB using a real-world example](/azure/cosmos-db/nosql/how-to-model-partition-example) for more guidance.

Lifecycle management is generally simpler when containers are dedicated to tenants. You can [easily move tenants between shared and dedicated throughput models](/azure/cosmos-db/set-throughput#set-throughput-on-a-database-and-a-container), and when deprovisioning a tenant, you can quickly delete the container.

### Database per tenant

You can provision databases for each tenant, in the same database account. Like the container-per-tenant model above, this model provides greater performance isolation than the partition-key-per-tenant model, and it also provides increased data access security isolation via [Azure RBAC](/azure/cosmos-db/role-based-access-control). 

Similar to the account-per-tenant model, this approach gives the highest level of performance isolation, but it provides the lowest tenant density. However, this option is best when each tenant requires a more complicated data model than is feasible in the container-per-tenant model. Or, you should follow this approach when it's a requirement for new tenant creation to be fast and/or free of any overhead to create tenant accounts up-front. It may also be the case, for the specific software development framework being used, that database-per-tenant is the only level of performance isolation that's recognized in that framework. Entity (container) level isolation and entity colocation aren't typically supported natively in such frameworks.


## Features of Azure Cosmos DB that support multitenancy

### Partitioning

By using partitions with your Azure Cosmos DB containers, you can create containers that are shared across multiple tenants. Typically you use the tenant identifier as a partition key, but you might also consider using multiple partition keys for a single tenant. A well-planned partitioning strategy effectively implements the [Sharding pattern](../../../patterns/sharding.yml). With large containers, Azure Cosmos DB spreads your tenants across multiple physical nodes to achieve a high degree of scale.

We recommend that you explore the use of [hierarchical partition keys](/azure/cosmos-db/hierarchical-partition-keys) to improve the performance of your multitenant solution. Hierarchical partition keys enable you to create a partition key that includes multiple values. For example, you might use a hierarchical partition key that includes the tenant identifier, like a high-cardinality GUID, to allow for almost unbounded scale. Or, you can specify a hierarchical partition key that includes a property frequently used in queries. This approach helps you to avoid cross partition queries. By using hierarchical partition keys, you can scale beyond the logical partition limit of 20 GB per partition key value, and you limit expensive fan-out queries.

More information:

- [Partitioning and horizontal scaling in Azure Cosmos DB](/azure/cosmos-db/partitioning-overview)
- [Hierarchical partition keys](/azure/cosmos-db/hierarchical-partition-keys)

### Managing request units

Azure Cosmos DB pricing model is based on the number of *request units* per second that you provision or consume. A request unit is a logical abstraction of the cost of a database operation or query. Typically, you provision a defined number of request units per second for your workload, which is referred to as *throughput*. Azure Cosmos DB provides several options for how you provision throughput. In a multitenant environment, the selection you make affects the performance and price of your Azure Cosmos DB resources. For tenants that require guaranteed performance and security isolation, we recommend isolating tenants by database account. For tenants that do not need guaranteed performance and security isolation, we recommend isolating tenants by partition key to optimize for low cost per tenant. 

One tenancy model for Azure Cosmos DB involves deploying separate containers for each tenant within a shared database. Azure Cosmos DB enables you to provision request units for a database, and all of the containers share the request units. If your tenant workloads don't typically overlap, this approach can help reduce your operational costs. However, this approach is susceptible to the [Noisy Neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) because a single tenant's container might consume a disproportionate amount of the shared provisioned request units. To mitigate this issue, first identify the noisy tenants. Then, you can optionally set provisioned throughput on a specific container. The other containers in the database continue to share their throughput, but the noisy tenant consumes their own dedicated throughput.

Azure Cosmos DB also provides a serverless tier, which is suited for workloads with intermittent or unpredictable traffic. Alternatively, autoscaling enables you to configure policies to specify the scaling of provisioned throughput. Additionally, you can take advantage of Azure Cosmos DB burst capacity, maximizing the utilization of your provisioned throughput capacity, which would have been rate limited otherwise. In a multitenant solution, you might combine all of these approaches to support different types of tenant.

> [!NOTE]
> When planning your Azure Cosmos DB configuration, ensure you consider the [service quotas and limits](/azure/cosmos-db/concepts-limits).

To monitor and manage the costs that are associated with each tenant, every operation using the Azure Cosmos DB API includes the request units consumed. You can use this information to aggregate and compare the actual request units consumed by each tenant, and you can then identify tenants with different performance characteristics.

More information:

- [Provisioned throughput](/azure/cosmos-db/set-throughput)
- [Autoscale](/azure/cosmos-db/provision-throughput-autoscale)
- [Serverless](/azure/cosmos-db/serverless)
- [Measuring the RU charge of a request](/azure/cosmos-db/optimize-cost-reads-writes#measuring-the-ru-charge-of-a-request)
- [Azure Cosmos DB service quotas](/azure/cosmos-db/concepts-limits)
- [Burst capacity](/azure/cosmos-db/burst-capacity)

### Customer-managed keys

Some tenants might require the use of their own encryption keys. Azure Cosmos DB provides a customer-managed key feature. This feature is applied at the level of an Azure Cosmos DB account, so tenants who require their own encryption keys need to be deployed using dedicated Azure Cosmos DB accounts.

More information:

- [Configure customer-managed keys for your Azure Cosmos DB account with Azure Key Vault](/azure/cosmos-db/how-to-setup-cmk)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paul Burpo](https://linkedin.com/in/paul-burpo) | Principal Customer Engineer, FastTrack for Azure
- [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer

Other contributors:

- [Mark Brown](https://www.linkedin.com/in/markjbrown1) | Principal PM Manager, Azure Cosmos DB
- [Tara Bhatia](https://www.linkedin.com/in/tarabhatia01/) | Program Manager, Azure Cosmos DB
- [Deborah Chen](https://www.linkedin.com/in/deborah-chen-62212437) | Principal Program Manager
- [Theo van Kraay](https://www.linkedin.com/in/theo-van-kraay-3388b130) | Senior Program Manager, Azure Cosmos DB
- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- Thomas Weiss | Principal Program Manager
- [Vic Perdana](https://www.linkedin.com/in/vperdana) | Cloud Solution Architect, Azure ISV

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).

Learn more about multitenancy and Azure Cosmos DB:

- [Design and build multi-tenant SaaS apps at scale with Azure Cosmos DB](https://www.youtube.com/watch?v=dd7W_kMh-z4): A session at Build 2024 that walks you through how to design for multi-tenancy on Azure Cosmos DB and learn best practices from a real-world ISV.
- [Azure Cosmos DB and multitenant systems](https://azure.microsoft.com/blog/azure-cosmos-db-and-multi-tenant-systems): A blog post that discusses how to build a multitenant system that uses Azure Cosmos DB.
- [Multitenant applications with Azure Cosmos DB](https://www.youtube.com/watch?v=fOQoQnQqwwU) (video)
- [Building a multitenant SaaS with Azure Cosmos DB and Azure](https://www.youtube.com/watch?v=Tht_RV5QPJ0) (video): A real-world case study of how Whally, a multitenant SaaS startup, built a modern platform from scratch on Azure Cosmos DB and Azure. Whally shows the design and implementation decisions they made that relate to partitioning, data modeling, secure multitenancy, performance, real-time streaming from change feed to SignalR, and more. All these solutions use ASP.NET Core on Azure App Services.

## Related resources

Refer to some of our other Cosmos DB architectural scenarios:

- [Serverless apps using Azure Cosmos DB](/azure/architecture/databases/idea/serverless-apps-using-cosmos-db)
- [Azure Cosmos DB in IoT workloads](/azure/architecture/solution-ideas/articles/iot-using-cosmos-db)
- [Transactional Outbox pattern with Azure Cosmos DB](/azure/architecture/databases/guide/transactional-outbox-cosmos)
- [Visual search in retail with Azure Cosmos DB](/azure/architecture/industries/retail/visual-search-use-case-overview)
- [Gaming using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/gaming-using-cosmos-db)
