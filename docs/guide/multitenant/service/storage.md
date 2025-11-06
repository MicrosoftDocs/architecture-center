---
title: Multitenancy and Azure Storage
description: This article describes the features of Azure Storage that benefit multitenant systems. It includes links to guidance and examples.
author: PlagueHO
ms.author: dascottr
ms.date: 06/15/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Multitenancy and Azure Storage

Azure Storage is a foundational service that nearly every solution uses. Multitenant solutions often use Storage for blob, file, queue, and table storage. This article describes features of Storage for multitenant solutions. It provides links to guidance that can help you plan how to use Storage.

## Features of Storage that support multitenancy

Azure Storage includes many features that support multitenancy.

### Shared access signatures

When you use Storage from a client application, consider whether to route client requests through another component that you control, like a content delivery network or API. Or you can allow clients to connect directly to your storage account. Sending requests through another component can provide benefits like caching data at the edge of your network.

Direct client access to Storage to download or upload data can improve performance, especially for large blobs or many files. It also reduces the load on your back-end applications and servers and reduces the number of network hops.

A [shared access signature (SAS)](/azure/storage/common/storage-sas-overview) enables you to securely provide your client applications with access to objects in Storage.

You can use a SAS to restrict the scope of operations that a client can perform and the objects that they can perform operations against. For example, if you have a shared storage account for all your tenants and store tenant A's data in a blob container named `tenanta`, you can create a SAS that permits only tenant A's users to access that container. For more information about approaches that isolate your tenants' data in a storage account, see [Isolation models](#isolation-models).

Use the [Valet Key pattern](../../../patterns/valet-key.yml) to issue constrained and scoped SAS tokens from your application tier. For example, if your multitenant application allows users to upload videos, your API or application tier can authenticate the client by using your application's authentication system. You can then provide a SAS that allows the client to upload a video file to a specific blob path within a designated container. The client then uploads the file directly to the storage account, which reduces bandwidth and load on your API. If the client tries to read data from the blob container or write data to another container in the storage account, Storage blocks the request. The SAS expires after a configurable time period.

[Stored access policies](/rest/api/storageservices/define-stored-access-policy) extend the SAS functionality, which enables you to define a single policy to use when you issue multiple signatures.

### Identity-based access control

Azure Storage also provides [identity-based access control](/azure/storage/blobs/authorize-access-azure-active-directory) through Microsoft Entra ID. This capability enables [attribute-based access control](/azure/role-based-access-control/conditions-overview), which provides fine-grained access to blob paths or to blobs tagged with a specific tenant ID.

### Lifecycle management

When you use blob storage in a multitenant solution, your tenants might require different policies for data retention. When you store large volumes of data, you might also want to automatically move tenant-specific data to the [cool or archive storage tiers](/azure/storage/blobs/storage-blob-storage-tiers) to optimize costs.

Use [lifecycle management policies](/azure/storage/blobs/lifecycle-management-overview) to set the blob lifecycle for all tenants or for a subset of tenants. You can apply a lifecycle management policy to blob containers or a subset of blobs within a container. But lifecycle management policies have limits on the number of rules that you can specify. Plan and test your configuration carefully in a multitenant environment. Consider deploying multiple storage accounts if your rule count exceeds the limits.

### Immutable storage

When you configure [immutable blob storage](/azure/storage/blobs/immutable-storage-overview) on storage containers by using [time-based retention policies](/azure/storage/blobs/immutable-time-based-retention-policy-overview), Storage prevents deletion or modification of the data before a specified time. This enforcement occurs at the storage account layer and applies to all users, including your organization's administrators.

Use immutable storage if tenants must maintain data or records because of legal or compliance requirements. Evaluate how this feature fits your [tenant life cycle](../considerations/tenant-life-cycle.md). For example, if a tenant is offboarded and requests data deletion, you might not be able to fulfill their request. If you use immutable storage for tenant data, consider how to address this problem in your terms of service.

### Server-side copy

In a multitenant system, you might need to move data from one storage account to another. For example, if you move a tenant between deployment stamps or rebalance a [sharded](../../../patterns/sharding.yml) set of storage accounts, you need to copy or move a specific tenant's data. When you have large volumes of data, use [server-side copy APIs](https://azure.microsoft.com/updates/new-copy-apis-for-efficient-data-copy) to decrease migration time.

The [AzCopy tool](/azure/storage/common/storage-use-azcopy-v10) is an application that you can run from your computer or a virtual machine to manage the copy process. AzCopy is compatible with the server-side copy feature, and it provides a scriptable command-line interface that you can run from your solutions. You can also use AzCopy to upload and download large volumes of data.

If you need to use the server-side copy APIs directly from your code, consider using the following options:

- [Put Block From URL API](/rest/api/storageservices/put-block-from-url)
- [Put Page From URL API](/rest/api/storageservices/put-page-from-url)
- [Append Block From URL API](/rest/api/storageservices/append-block-from-url)
- [Copy Blob From URL API](/rest/api/storageservices/copy-blob-from-url) for smaller blobs

### Object replication

[Object replication](/azure/storage/blobs/object-replication-overview) is a feature that automatically and asynchronously replicates data between a source and destination storage account. In a multitenant solution, use this feature to continuously replicate data between deployment stamps or when you implement the [Geode pattern](../../../patterns/geodes.yml).

### Encryption

Azure Storage enables you to [provide encryption keys](/azure/storage/blobs/encryption-customer-provided-keys) for your data. In a multitenant solution, consider combining this capability with [encryption scopes](/azure/storage/blobs/encryption-scope-overview). You can assign different encryption keys to different tenants, even when their data resides in the same storage account. These features together enable tenants to control their own data. If they deactivate their account, deleting the encryption key ensures that no one can access their data.

### Monitoring

In a multitenant solution, consider whether you need to [measure the consumption for each tenant](../considerations/measure-consumption.md). Define the specific metrics to track, such as the storage capacity that each tenant uses or the number of operations performed for each tenant's data. You can also use [cost allocation](../approaches/cost-management-allocation.md) to track the cost of each tenant's usage and enable chargeback across multiple subscriptions.

Azure Storage provides [built-in monitoring capabilities](/azure/storage/blobs/monitor-blob-storage). Consider the services that you plan to use within the Storage account. For example, when you use [blobs](/azure/storage/blobs/monitor-blob-storage-reference), you can view the total capacity of a storage account but not a single container. When you use file shares, you can view the capacity for each share but not each folder.

You can also [log all requests to Storage](/azure/storage/blobs/monitor-blob-storage#analyzing-logs), then aggregate and analyze those logs. This approach provides flexibility when you aggregate and group data for each tenant. But in solutions that create high volumes of requests to Storage, consider whether the benefit that you gain from this approach justifies the cost to capture and process those logs.

[Azure Storage inventory](/azure/storage/blobs/calculate-blob-count-size) provides another approach to measure the total size of a blob container.

## Isolation models

When you use Storage in a multitenant system, determine the level of isolation to apply. Azure Storage supports several isolation models.

### Storage accounts for each tenant

The strongest level of isolation uses a dedicated storage account for each tenant. This model ensures full isolation of storage keys, which you can rotate independently. It also allows you to scale your solution beyond the limits and quotas for each storage account. But you must also consider the maximum number of storage accounts allowed within a single Azure subscription.

> [!NOTE]
> Consider Storage quotas and limits when you select an isolation model. These limits include [Azure service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#storage-limits), [general scalability targets](/azure/storage/blobs/scalability-targets), and [scalability targets for the Storage resource provider](/azure/storage/common/scalability-targets-resource-provider).

Each component of Storage provides further options for tenant isolation.

### Blob storage isolation models

The following table summarizes the differences between the main tenancy isolation models for Storage blobs.

| Consideration | Shared blob containers | Blob containers for each tenant | Storage accounts for each tenant |
|---|---|---|---|
| **Data isolation** | Low-medium. Use paths to identify each tenant's data or hierarchical namespaces. | Medium. Use container-scoped SAS URLs to support security isolation. | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to the entire storage account. | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | Each tenant has only a few blobs. | Tenant-scoped SAS URLs are issued. | Each tenant has its own deployment stamp. |

#### Shared blob containers

When you work with blob storage, you might use a shared blob container that includes blob paths to separate data for each tenant.

| Tenant ID | Example blob path |
|-|-|
| `tenant-a` | `https://contoso.blob.core.windows.net/sharedcontainer/tenant-a/blob1.mp4` |
| `tenant-b` | `https://contoso.blob.core.windows.net/sharedcontainer/tenant-b/blob2.mp4` |

This approach is simple to implement, but in many scenarios, blob paths don't provide sufficient isolation across tenants. Blob storage doesn't support a true directory or folder structure, so you can't assign access to all blobs within a specified path. But Storage provides a capability to [list, or enumerate, blobs that begin with a specified prefix](/rest/api/storageservices/enumerating-blob-resources). This feature supports scenarios that use shared blob containers and don't require directory-level access control.

The [hierarchical namespace](/azure/storage/blobs/data-lake-storage-namespace#deciding-whether-to-enable-a-hierarchical-namespace) feature in Storage provides a stronger directory or folder structure, including directory-specific access control. This feature supports multitenant scenarios where you have shared blob containers but want to grant access to a single tenant's data.

In some multitenant solutions, you might only need to store a single blob or set of blobs for each tenant, such as tenant icons for customizing a user interface. A single shared blob container might work for these scenarios. You can use the tenant identifier as the blob name, and read the specific blob instead of enumerating a blob path.

When you use shared containers, consider whether you need to track the data and Storage usage for each tenant. For more information, see [Monitoring](#monitoring).

#### Blob containers for each tenant

You can create individual blob containers for each tenant within a single storage account. There's no limit to the number of blob containers that you can create within a storage account.

When you create a container for each tenant, you can use Storage access control, including SAS, to manage access for each tenant's data. You can also easily monitor the capacity that each container uses.

### File storage isolation models

The following table summarizes the differences between the main tenancy isolation models for Storage files.

| Consideration | Shared file shares | File shares for each tenant | Storage accounts for each tenant |
|---|---|---|---|
| **Data isolation** | Medium-high. Apply authorization rules for tenant-specific files and directories. | Medium-high | High |
| **Performance isolation** | Low | Low-medium. Most quotas and limits apply to the entire storage account, but you should set size quotas for each file share. | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | An application controls all access to files. | Tenants access their own files. | Each tenant has its own deployment stamp. |

#### Shared file shares

When you work with file shares, you might use a shared file share that includes file paths to separate the data for each tenant.

| Tenant ID | Example file path |
|-|-|
| `tenant-a` | `https://contoso.file.core.windows.net/share/tenant-a/blob1.mp4` |
| `tenant-b` | `https://contoso.file.core.windows.net/share/tenant-b/blob2.mp4` |

When your application communicates via the Server Message Block (SMB) protocol and you use Active Directory Domain Services either on-premises or in Azure, file shares [support authorization](/azure/storage/files/storage-files-active-directory-overview) at both the share level and the directory or file level.

In other scenarios, consider using SAS to grant access to specific file shares or files. SAS doesn't support granting access to directories.

When you use shared file shares, consider whether you need to track the data and Storage usage for each tenant. For more information, see [Monitoring](#monitoring).

#### File shares for each tenant

You can create individual file shares for each tenant within a single storage account. There's no limit to the number of file shares that you can create within a storage account.

For this scenario, you can use Storage access control, including SAS, to manage access for each tenant's data. You can also easily monitor the capacity that each file share uses.

### Table storage isolation models

The following table summarizes the differences between the main tenancy isolation models for Storage tables.

| Consideration | Shared tables with partition keys for each tenant | Tables for each tenant | Storage accounts for each tenant |
|---|---|---|---|
| **Data isolation** | Low. The application enforces isolation. | Low-medium | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to the entire storage account. | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | A large multitenant solution has a shared application tier. | Tenant-scoped SAS URLs are issued. | Each tenant has its own deployment stamp. |

#### Shared tables with partition keys for each tenant

When you use table storage that includes a single shared table, consider using the [built-in support for partitioning](/rest/api/storageservices/understanding-the-table-service-data-model#partitionkey-property). Each entity must include a partition key, such as a tenant identifier.

SAS tokens and policies enable you to specify a partition key range. Azure Storage ensures that requests that contain the signature can only access the specified partition key ranges. You can implement the [Valet Key pattern](../../../patterns/valet-key.yml), which allows untrusted clients to access a single tenant's partition without affecting other tenants.

For high-scale applications, consider the maximum throughput of each table partition and the storage account.

#### Tables for each tenant

You can create individual tables for each tenant within a single storage account. There's no limit to the number of tables that you can create within a storage account.

For this scenario, you can use Storage access control, including SAS, to manage access for each tenant's data.

### Queue storage isolation models

The following table summarizes the differences between the main tenancy isolation models for Storage queues.

| Consideration | Shared queues | Queues for each tenant | Storage accounts for each tenant |
|---|---|---|---|
| **Data isolation** | Low | Low-medium | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to the entire storage account. | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | A large multitenant solution has a shared application tier. | Tenant-scoped SAS URLs are issued. | Each tenant has its own deployment stamp. |

#### Shared queues

If you share a queue, consider the quotas and limits that apply. In solutions that have a high request volume, consider whether the target throughput of 2,000 messages per second works for your scenario.

Queues don't provide partitioning or subqueues, so all tenants' data might become intermingled.

#### Queues for each tenant

You can create individual queues for each tenant within a single storage account. There's no limit to the number of queues that you can create within a storage account.

For this scenario, you can use Storage access control, including SAS, to manage access for each tenant's data.

When you dynamically create queues for each tenant, consider how your application tier consumes the messages from each tenant's queue. For advanced scenarios, consider using [Azure Service Bus](https://azure.microsoft.com/services/service-bus), which supports features such as [sessions](/azure/service-bus-messaging/message-sessions), [message autoforwarding](/azure/service-bus-messaging/service-bus-auto-forwarding), [topics, and subscriptions](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions#topics-and-subscriptions). These capabilities can enhance multitenant solutions.

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

## Related resource

- [Storage and data approaches for multitenancy](../approaches/storage-data.md)
