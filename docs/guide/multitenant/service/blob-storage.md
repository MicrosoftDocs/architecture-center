---
title: Multitenancy and Azure Blob Storage
description: Explore Azure Blob Storage features and isolation models for multitenant solutions, including tenant-scoped access, encryption, and monitoring.
author: PlagueHO
ms.author: dascottr
ms.date: 10/20/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
ai-usage: ai-assisted
---

# Multitenancy and Azure Blob Storage

Azure Blob Storage stores unstructured data, such as documents, images, and videos. This article describes partitioning strategies, isolation models, and Blob Storage features for multitenant solutions. It provides guidance that can help you distribute request load, isolate tenants' data, and manage access, retention, encryption, and usage.

## Partitioning strategies

Blob Storage automatically partitions data by using a partition key that consists of the storage account name, container name, and blob name. Azure load-balances ranges of partition keys across the service. You don't control the physical partition for a blob. Placing each tenant in a separate container or blob-name prefix doesn't provide dedicated throughput or performance isolation.

In a shared storage account, a workload that concentrates requests on a narrow range of blob names can create a hot partition, even when the account has unused capacity. Hot partitions can increase latency and cause HTTP 500 (Operation Timeout) or HTTP 503 (Server Busy) responses.

For clients that upload blocks smaller than 256 KiB, blob naming can affect upload performance. For example, an application that writes all of a day's data to a blob named using the pattern `yyyy-mm-dd` directs every write for that day to the same partition key, which can create a hot partition. For high-request-rate workloads, split the data across multiple blobs and add a short hash prefix, or a seconds or minutes value, near the beginning of each blob name. Avoid sequential or append-only naming patterns. Uploads that use larger blocks aren't affected by partition naming. For more information, see [Optimize blob partitions](/azure/storage/blobs/storage-performance-blob-partitions) and [Scalability and performance targets for Blob Storage](/azure/storage/blobs/scalability-targets).

A high-volume tenant can create a hot partition or consume a disproportionate share of a storage account's capacity. Monitor throttling and tenant request patterns, use exponential-backoff retries, and consider a dedicated storage account for tenants that need independent scale or stronger performance isolation. Partitioning and tenant isolation are separate concerns. For isolation options, see [Isolation models](#isolation-models).

## Isolation models

Partitioning controls how Blob Storage distributes request load, but it doesn't establish a tenant isolation boundary. When you use Blob Storage in a multitenant system, determine the level of isolation to apply. Blob Storage supports shared containers, containers for each tenant, and storage accounts for each tenant. The following table summarizes the differences between the main tenancy isolation models for Blob Storage.

| Consideration | Shared blob containers | Blob containers for each tenant | Storage accounts for each tenant |
|---|---|---|---|
| **Data isolation** | Low-medium. Use paths to identify each tenant's data or hierarchical namespaces. | Medium. Use container-scoped shared access signature (SAS) URLs to support security isolation. | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to the entire storage account. | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | Each tenant has only a few blobs. | Tenant-scoped SAS URLs are issued. | Each tenant has its own deployment stamp. |

> [!NOTE]
> Consider Storage quotas and limits when you select an isolation model. These limits include [Azure service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#storage-limits), [general scalability targets](/azure/storage/blobs/scalability-targets), and [scalability targets for the Storage resource provider](/azure/storage/common/scalability-targets-resource-provider).

### Shared blob containers

When you work with blob storage, you might use a shared blob container that includes blob paths to separate data for each tenant.

| Tenant ID | Example blob path |
|-|-|
| `tenant-a` | `https://contoso.blob.core.windows.net/sharedcontainer/tenant-a/blob1.mp4` |
| `tenant-b` | `https://contoso.blob.core.windows.net/sharedcontainer/tenant-b/blob2.mp4` |

Blob name prefixes identify each tenant's data, but naming alone doesn't enforce access isolation. Blob Storage provides a capability to [list, or enumerate, blobs that begin with a specified prefix](/rest/api/storageservices/enumerating-blob-resources). Ensure that your application and authorization configuration prevent tenants from accessing other tenants' blobs. Design the blob names within each tenant prefix to avoid concentrating high request volumes on a narrow range of partition keys. For more information, see [Partitioning strategies](#partitioning-strategies).

The [hierarchical namespace](/azure/storage/blobs/data-lake-storage-namespace#deciding-whether-to-enable-a-hierarchical-namespace) feature in Storage provides a stronger directory or folder structure, including directory-specific access control. This feature supports multitenant scenarios where you have shared blob containers but want to grant access to a single tenant's data.

In some multitenant solutions, you might only need to store a single blob or set of blobs for each tenant, such as tenant icons for customizing a user interface. A single shared blob container might work for these scenarios. You can use the tenant identifier as the blob name, and read the specific blob instead of enumerating a blob path.

When you use shared containers, consider whether you need to track the data and Storage usage for each tenant. For more information, see [Monitoring](#monitoring).

### Blob containers for each tenant

You can create individual blob containers for each tenant within a single storage account. There's no limit to the number of blob containers that you can create within a storage account.

Separate containers provide an access-control and management boundary, but they don't provide performance isolation. All containers in the account share the storage account's capacity and performance targets.

When you create a container for each tenant, you can use Blob Storage access control, including SAS, to manage access for each tenant's data. Use [blob inventory](/azure/storage/blobs/calculate-blob-count-size) to measure the capacity that each container uses.

### Storage accounts for each tenant

The strongest level of isolation uses a dedicated storage account for each tenant. This model ensures full isolation of storage keys, which you can rotate independently. It also allows you to scale your solution beyond the limits and quotas for each storage account. Consider this model for tenants that have sustained high request volumes or require independent performance targets. But you must also consider the maximum number of storage accounts allowed within a single Azure subscription.

## Features of Blob Storage that support multitenancy

The following Blob Storage features can help you implement and operate your chosen isolation model.

### Shared access signatures

When you use Blob Storage from a client application, consider whether to route client requests through another component that you control, like a content delivery network or API. Or you can allow clients to connect directly to your storage account. Sending requests through another component can provide benefits like caching data at the edge of your network.

Direct client access to Blob Storage to download or upload data can improve performance, especially for large blobs. It also reduces the load on your back-end applications and servers and reduces the number of network hops.

A [shared access signature (SAS)](/azure/storage/common/storage-sas-overview) enables you to provide your client applications with limited access to blobs.

You can use a SAS to restrict the scope of operations that a client can perform and the objects that they can perform operations against. For example, if you have a shared storage account for all your tenants and store tenant A's data in a blob container named `tenanta`, you can create a SAS that permits only tenant A's users to access that container. For more information about approaches that isolate your tenants' data in a storage account, see [Isolation models](#isolation-models).

Use the [Valet Key pattern](../../../patterns/valet-key.yml) to issue constrained and scoped SAS tokens from your application tier. For example, if your multitenant application allows users to upload videos, your API or application tier can authenticate the client by using your application's authentication system. You can then provide a SAS that allows the client to upload a video file to a specific blob path within a designated container. The client then uploads the file directly to the storage account, which reduces bandwidth and load on your API. If the client tries to read data from the blob container or write data to another container in the storage account, Storage blocks the request. The SAS expires after a configurable time period.

[Stored access policies](/rest/api/storageservices/define-stored-access-policy) enable you to define a single policy to use when you issue multiple service SAS tokens. Stored access policies don't apply to user delegation SAS tokens or account SAS tokens.

#### User delegation SAS

A service SAS or account SAS is signed with one of your storage account keys, so any component that creates one needs access to those keys. A [user delegation SAS](/rest/api/storageservices/create-user-delegation-sas) is secured with Microsoft Entra credentials instead. Your application tier requests a user delegation key by using its own managed identity, then signs scoped, time-limited tokens for each tenant. You don't distribute or store account keys. Microsoft recommends using a user delegation SAS instead of an account-key SAS when your design supports it. Use short token lifetimes and plan how to revoke access if a token is compromised.

In a multitenant solution, combine a user delegation SAS with the [Valet Key pattern](../../../patterns/valet-key.yml) to issue tenant-scoped tokens that your identity provider backs. You can bind each token to a specific delegated user. To correlate your application logs with Storage logs, set a client request ID (`x-ms-client-request-id`) on Storage requests and log it alongside the tenant ID. For more information, see [Grant limited access to Azure Storage resources by using shared access signatures](/azure/storage/common/storage-sas-overview).

### Identity-based access control

Blob Storage also provides [identity-based access control](/azure/storage/blobs/authorize-access-azure-active-directory) through Microsoft Entra ID. This capability enables [attribute-based access control](/azure/role-based-access-control/conditions-overview), which provides fine-grained access to blob paths or to blobs tagged with a specific tenant ID.

### Concurrency control

Blob Storage doesn't provide transactions across multiple blobs. If multiple application instances can update the same blob, implement a concurrency-control strategy. Use ETags and conditional requests for optimistic concurrency, or acquire a blob lease for pessimistic concurrency.

An active lease enforces exclusive write access to the leased blob for the lease holder. It doesn't prevent uncoordinated reads or make operations across multiple blobs atomic. In a multitenant solution, consider concurrency control when multiple workers can process or update the same tenant's blob. For more information, see [Manage concurrency in Blob Storage](/azure/storage/blobs/concurrency-manage).

### Lifecycle management

When you use blob storage in a multitenant solution, your tenants might require different policies for data retention. When you store large volumes of data, you might also want to automatically move tenant-specific data to the [cool or archive storage tiers](/azure/storage/blobs/access-tiers-overview) to optimize costs.

Use [lifecycle management policies](/azure/storage/blobs/lifecycle-management-overview) to set the blob lifecycle for all tenants or for a subset of tenants. You can apply a lifecycle management policy to blob containers or a subset of blobs within a container. But lifecycle management policies have limits on the number of rules that you can specify. Plan and test your configuration carefully in a multitenant environment. Consider deploying multiple storage accounts if your rule count exceeds the limits.

### Immutable storage

When you configure [immutable blob storage](/azure/storage/blobs/immutable-storage-overview) on storage containers by using [time-based retention policies](/azure/storage/blobs/immutable-storage-overview#time-based-retention-policies), Storage prevents deletion or modification of the data before a specified time. This enforcement occurs at the storage account layer and applies to all users, including your organization's administrators.

Use immutable storage if tenants must maintain data or records because of legal or compliance requirements. Evaluate how this feature fits your [tenant life cycle](../considerations/tenant-life-cycle.md). For example, if a tenant is offboarded and requests data deletion, you might not be able to fulfill their request. If you use immutable storage for tenant data, consider how to address this problem in your terms of service.

### Server-side copy

In a multitenant system, you might need to move data from one storage account to another. For example, if you move a tenant between deployment stamps or rebalance a [sharded](../../../patterns/sharding.md) set of storage accounts, you need to copy or move a specific tenant's data. When you have large volumes of data, use [server-side copy APIs](https://azure.microsoft.com/updates/new-copy-apis-for-efficient-data-copy) to decrease migration time.

The [AzCopy tool](/azure/storage/common/storage-use-azcopy-v10) is an application that you can run from your computer or a virtual machine to manage the copy process. AzCopy is compatible with the server-side copy feature, and it provides a scriptable command-line interface that you can run from your solutions. You can also use AzCopy to upload and download large volumes of data.

If you need to use the server-side copy APIs directly from your code, consider using the following options:

- [Put Block From URL API](/rest/api/storageservices/put-block-from-url)
- [Put Page From URL API](/rest/api/storageservices/put-page-from-url)
- [Append Block From URL API](/rest/api/storageservices/append-block-from-url)
- [Copy Blob From URL API](/rest/api/storageservices/copy-blob-from-url) for smaller blobs

### Object replication

[Object replication](/azure/storage/blobs/object-replication-overview) automatically and asynchronously replicates block blobs between a source and destination storage account. Object replication doesn't support accounts with hierarchical namespace enabled or source blobs encrypted with customer-provided keys. Destination containers reject writes while replication rules are active, so object replication alone doesn't provide active-active writes.
 
In a multitenant solution, you can use this feature when active-passive replication is sufficient. Example scenarios might be to distribute copies of tenant data between deployment stamps, or to distribute read-only assets when implementing the [Geode pattern](../../../patterns/geodes.yml).

### Encryption

Blob Storage [encrypts data at rest](/azure/storage/common/storage-service-encryption). In a multitenant solution, consider using [encryption scopes](/azure/storage/blobs/encryption-scope-overview) with customer-managed keys. You can assign different encryption keys to different tenants, even when their data resides in the same storage account. Alternatively, you can [provide an encryption key on individual Blob Storage requests](/azure/storage/blobs/encryption-customer-provided-keys). These are separate key-management options. Plan key rotation and revocation alongside your [tenant life cycle](../considerations/tenant-life-cycle.md).

### Monitoring

In a multitenant solution, consider whether you need to [measure the consumption for each tenant](../considerations/measure-consumption.md). Define the specific metrics to track, such as the storage capacity that each tenant uses or the number of operations performed for each tenant's data. You can also use [cost allocation](../approaches/cost-management-allocation.md) to track the cost of each tenant's usage and enable chargeback across multiple subscriptions.

Blob Storage provides [built-in monitoring capabilities](/azure/storage/blobs/monitor-blob-storage). Built-in [capacity metrics](/azure/storage/blobs/monitor-blob-storage-reference) report usage for the storage account, not for individual containers. Plan how to measure usage for each tenant when tenants share an account.

Monitor request latency and HTTP 500 and 503 responses to detect possible hot partitions or workloads that approach scalability targets. Correlate this telemetry with tenant identifiers so that you can identify tenants whose access patterns affect shared capacity.

You can also [log all requests to Storage](/azure/storage/blobs/monitor-blob-storage#analyzing-logs), then aggregate and analyze those logs. This approach provides flexibility when you aggregate and group data for each tenant. But in solutions that create high volumes of requests to Storage, consider whether the benefit that you gain from this approach justifies the cost to capture and process those logs.

[Azure Storage inventory](/azure/storage/blobs/calculate-blob-count-size) provides another approach to measure the total size of a blob container.

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
- [Architecture best practices for Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage)
- [Multitenancy and Azure Files](files.md)
- [Multitenancy and Azure Queue Storage](queue-storage.md)
- [Multitenancy and Azure Table Storage](table-storage.md)
- [Reliability in Azure Blob Storage](/azure/reliability/reliability-storage-blob)
