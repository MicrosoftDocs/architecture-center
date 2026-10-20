---
title: Multitenancy and Azure Table Storage
description: Explore Azure Table Storage features and isolation models for multitenant solutions, including tenant partition keys, access control, encryption, and monitoring.
author: PlagueHO
ms.author: dascottr
ms.date: 10/20/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
ai-usage: ai-assisted
---

# Multitenancy and Azure Table Storage

Azure Table Storage stores structured, nonrelational data. This article describes partitioning strategies, isolation models, and Table Storage features for multitenant solutions. It provides guidance that can help you distribute entity data and request load, isolate tenants' entities, and manage access, encryption, and usage.

## Partitioning strategies

Table Storage automatically partitions entities based on the value of the `PartitionKey` property. Every entity must include a `PartitionKey` and a `RowKey`. Together, these properties uniquely identify the entity. Each property can contain a string of up to 1,024 characters.

All entities that have the same `PartitionKey` value belong to the same partition. When the application writes the first entity with a new `PartitionKey` value, Table Storage creates the corresponding logical partition and manages its physical placement. Table Storage distributes partitions across storage nodes and can rebalance them as request patterns change. This automatic partition management enables the service to scale out as you add partition key values.

### Design keys for access patterns

Choose `PartitionKey` and `RowKey` values based on how your application queries and modifies data. A point query that specifies both values is the most efficient query. Queries that specify a `PartitionKey` and a range of `RowKey` values scan only one partition. Queries that don't specify a `PartitionKey` must scan multiple partitions or the entire table. Choose a `RowKey` that supports the sort order and range queries that your workload uses most frequently.

A natural key is a candidate for `PartitionKey` only when it aligns with the workload's query, distribution, and transaction requirements. If a logical partition contains exactly one entity, you can use the natural key as the `PartitionKey` and an empty string as the `RowKey`. If an entity has multiple stable key properties, choose the value or values for `PartitionKey` that distribute request load, support dominant queries, and group entities that require atomic transactions. Use `RowKey` to uniquely identify and order entities within that partition. If no single property meets these requirements, construct a synthetic key by concatenating stable property values.

Table Storage automatically indexes only `PartitionKey` and `RowKey`. If you regularly query by other properties, consider implementing the [Index Table pattern](../../../patterns/index-table.md), duplicating entities to support another access pattern, or using a data store that supports secondary indexes. For more information about query design, see [Design for querying](/azure/storage/tables/table-storage-design-for-query).

### Partition entity properties vertically

For logical entities that contain many properties, use server-side projection to retrieve only the properties that each query requires. If groups of properties have substantially different access or update patterns, or if a logical entity approaches Table Storage entity limits, consider splitting it across multiple entities or tables. Keep related entities in the same table with the same `PartitionKey` when you need to update them in an entity group transaction. For more information, see [Table design patterns](/azure/storage/tables/table-storage-design-patterns).

### Choose partition key granularity

The granularity of `PartitionKey` values affects scalability, query efficiency, and transaction boundaries:

- **One partition for many entities:** Using the same `PartitionKey` value for many entities keeps related data together. Queries can retrieve the group from one partition, and entity group transactions can update the entities atomically. However, all requests for those entities share the partition's throughput target. Using one `PartitionKey` value for an entire table can create a hot partition and is suitable only for small workloads.
- **One partition for each entity:** Using a unique `PartitionKey` value for every entity distributes request load across many partitions. Point queries remain efficient, but queries that retrieve multiple entities might need to access many partitions. Multiple entities can't participate in the same entity group transaction because they don't share a `PartitionKey`.
- **One partition for each related group:** Sharing a `PartitionKey` value among entities that the application commonly queries or updates together balances query locality, transaction support, and scalability. For a multitenant workload, the related group might be a tenant or a bucket of entities within a large tenant.

Avoid monotonically increasing or decreasing `PartitionKey` values in write-heavy workloads, such as `0001`, `0002`, and `0003`. These values can concentrate writes in a narrow key range and create a hot partition. Use stable hashing or bucketing when you need to distribute writes, and test the partitioning strategy under expected peak load. For current limits and design guidance, see [Table Storage scalability targets](/azure/storage/tables/scalability-targets) and [Design a scalable partitioning strategy for Table Storage](/rest/api/storageservices/designing-a-scalable-partitioning-strategy-for-azure-table-storage).

### Partition by tenant

In a shared table, you can use the tenant identifier as the `PartitionKey` when most operations are scoped to one tenant and each tenant's peak workload fits within the scalability target for a single partition. For entities that are 1 KiB, a partition has a target throughput of up to 2,000 entities per second, and a storage account has a maximum request rate of 20,000 transactions per second. A disproportionately active tenant can create a hot partition and experience throttling even when other partitions have unused capacity.

Creating more tables within the same storage account doesn't increase the account-level request target. If one partition approaches its target, refine the `PartitionKey` strategy to distribute its request load. If the aggregate workload approaches the storage account target, distribute the workload across multiple storage accounts.

For large or active tenants, construct multiple tenant-aware `PartitionKey` values by combining the tenant identifier with a stable bucket or domain-specific value. This approach distributes a tenant's entities and request load across partitions, but it introduces tradeoffs:

- Tenant-wide queries might need to query multiple partitions.
- Entity group transactions can't span the tenant's partitions.
- The application must route operations to the correct partition.
- Key-range-scoped shared access signatures (SAS) become more complex to design and issue.

### Plan transaction boundaries

Table Storage supports entity group transactions for entities in the same table that have the same `PartitionKey` value. A transaction can include at most 100 entities, and its payload must be smaller than 4 MiB. All operations in the transaction succeed or fail atomically.

Operations that span partitions aren't transactional. If a business operation must update entities atomically, store those entities in the same partition. Otherwise, design the application to handle partial failures and use an appropriate consistency strategy. For more information, see [Perform entity group transactions](/rest/api/storageservices/performing-entity-group-transactions).

## Isolation models

After you design your tenant-aware partition keys, determine the level of tenant isolation to apply. Table Storage supports shared tables, tables for each tenant, and storage accounts for each tenant. The following table summarizes the differences between the main tenancy isolation models for Table Storage.

| Consideration | Shared tables with tenant-aware partition keys | Tables for each tenant | Storage accounts for each tenant |
| --- | --- | --- | --- |
| **Data isolation** | Low. The application or a key-range-scoped shared access signature (SAS) enforces isolation. | Low-medium | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to the entire storage account. | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | A large multitenant solution has a shared application tier. | Tenant-scoped SAS URLs are issued. | Each tenant has its own deployment stamp. |

> [!NOTE]
> Consider quotas and limits when you select an isolation model. These limits include [Azure service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#storage-limits), [Table Storage scalability targets](/azure/storage/tables/scalability-targets), and [scalability targets for the Storage resource provider](/azure/storage/common/scalability-targets-resource-provider).

### Shared tables with tenant-aware partition keys

When you use a single shared table, use the tenant identifier as the complete `PartitionKey` for tenants whose data and request load fit within one partition, such as smaller tenants, or as one component of a synthetic `PartitionKey` for larger tenants. For key design and scalability considerations, see [Partitioning strategies](#partitioning-strategies).

SAS tokens enable you to specify a partition key range. Table Storage ensures that requests that contain the signature can only access entities within the specified partition and row key ranges. If a tenant's data spans multiple `PartitionKey` values, design the values and SAS ranges so that the token can't grant access to another tenant's entities. You can implement the [Valet Key pattern](../../../patterns/valet-key.yml) to allow untrusted clients to access a tenant's entities without granting access to other tenants.

If your application accesses a shared table on behalf of tenants, enforce the tenant's key range on every operation. A partition key naming convention doesn't provide access isolation by itself.

### Tables for each tenant

You can create individual tables for each tenant within a single storage account. There's no limit to the number of tables that you can create within a storage account.

Separate tables provide a routing and access-control boundary, but they don't provide performance isolation. All tables in the account share the storage account's capacity and performance targets.

For this scenario, you can use Table Storage access control, including SAS, to manage access for each tenant's data.

### Storage accounts for each tenant

The strongest level of isolation uses a dedicated storage account for each tenant. This model ensures full isolation of storage account keys, which you can rotate independently. It also allows you to scale your solution beyond the limits and quotas for each storage account. Consider this model for tenants that have sustained high transaction volumes or require independent regional configuration, encryption keys, or performance targets. You must also consider the maximum number of storage accounts allowed within a single Azure subscription.

## Features of Table Storage that support multitenancy

The following Table Storage features can help you implement and operate your chosen isolation model.

### Shared access signatures

When you use Table Storage from a client application, consider whether to route requests through your application tier or allow clients to connect directly to a table. Direct client access can reduce the load on your back-end applications and the number of network hops.

A [shared access signature (SAS)](/azure/storage/common/storage-sas-overview) enables you to provide client applications with limited access to a table. You can restrict the operations that a client can perform, the partition and row key ranges that it can access, and the time period when access is allowed. For example, you can issue a SAS that permits a tenant to read only the entities within its own partition key range.

Use the [Valet Key pattern](../../../patterns/valet-key.yml) to issue constrained and scoped SAS tokens from your application tier. Authenticate the client by using your application's authentication system, determine which tenant's entities they can access, and issue a token for only the required key ranges and operations.

[Stored access policies](/rest/api/storageservices/define-stored-access-policy) enable you to define a single policy to use when you issue multiple service SAS tokens. Stored access policies don't apply to user delegation SAS tokens or account SAS tokens.

#### User delegation SAS

A service SAS or account SAS is signed with one of your storage account keys. A [user delegation SAS](/rest/api/storageservices/create-user-delegation-sas) is secured with Microsoft Entra credentials instead. Your application tier requests a user delegation key by using its own managed identity, then signs scoped, time-limited tokens for each tenant. You don't distribute or store account keys. Microsoft recommends using a user delegation SAS instead of an account-key SAS when your design supports it.

Use short token lifetimes and plan how to revoke access if a token is compromised. To correlate your application logs with Table Storage logs, set a client request ID (`x-ms-client-request-id`) on storage requests and log it alongside the tenant ID.

### Identity-based access control

Table Storage provides [identity-based access control](/azure/storage/tables/authorize-access-azure-active-directory) through Microsoft Entra ID. Use managed identities and Azure role-based access control to authorize your application to access tables without storing account keys. Scope access to each tenant's table when tenants require direct access. Table-level role assignments don't restrict access to a tenant's partition within a shared table.

### Encryption

Table Storage [encrypts data at rest](/azure/storage/common/storage-service-encryption) with Microsoft-managed keys by default. To use customer-managed keys, [configure the storage account to use an account-scoped encryption key for tables](/azure/storage/common/account-encryption-key-create) when you create the account. You can't change this encryption key scope after account creation. Table Storage capacity and transactions are billed at [different rates](/azure/storage/common/account-encryption-key-create#pricing-and-billing) when the account is created to use an account-scoped encryption key for tables, even if Microsoft manages the key.

If tenants require separate customer-managed keys, use separate storage accounts. Blob Storage encryption scopes and customer-provided keys on individual requests don't apply to Table Storage. Plan key rotation and revocation alongside your [tenant life cycle](../considerations/tenant-life-cycle.md).

### Monitoring

In a multitenant solution, consider whether you need to [measure the consumption for each tenant](../considerations/measure-consumption.md). Define the specific metrics to track, such as the number of entities or operations for each tenant's data. You can also use [cost allocation](../approaches/cost-management-allocation.md) to track the cost of each tenant's usage and enable chargeback across multiple subscriptions.

Table Storage provides [built-in monitoring capabilities](/azure/storage/tables/monitor-table-storage). When tenants share a table, include tenant identifiers in your application telemetry so that you can attribute operations and usage to the correct tenant.

Monitor request rates and HTTP 500 and 503 responses to detect partitions or accounts that approach scalability targets. Correlate this telemetry with tenant identifiers so that you can identify tenants whose usage affects shared capacity.

You can collect request logs, then aggregate and analyze them alongside your application telemetry. In solutions that create high volumes of requests, consider whether the benefit justifies the cost to capture and process those logs.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Dr. Christian Geuer-Pollmann](https://www.linkedin.com/in/chgeuer) | Principal Customer Engineer, FastTrack for Azure
- Patrick Horn | Senior Customer Engineering Manager, FastTrack for Azure
- [Ben Hummerstone](https://www.linkedin.com/in/bhummerstone) | Principal Customer Engineer, FastTrack for Azure
- [Vic Perdana](https://www.linkedin.com/in/vperdana) | Cloud Solution Architect, Azure ISV
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Solution Architect, Data & AI
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Storage and data approaches for multitenancy](../approaches/storage-data.md)
- [Multitenancy and Azure Blob Storage](blob-storage.md)
- [Multitenancy and Azure Files](files.md)
- [Multitenancy and Azure Queue Storage](queue-storage.md)
- [Reliability in Azure Table Storage](/azure/reliability/reliability-storage-table)
