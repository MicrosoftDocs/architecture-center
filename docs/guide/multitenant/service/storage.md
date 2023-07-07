---
title: Azure Storage considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Storage that are useful when working with multitenanted systems. It provides links to guidance and examples for how to use Azure Storage in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 07/07/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-storage
categories:
  - storage
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Storage

Azure Storage is a foundational service used in almost every solution. Multitenant solutions often use Azure Storage for blob, file, queue, and table storage. On this page, we describe some of the features of Azure Storage that are useful for multitenant solutions, and then we provide links to the guidance that can help you, when you're planning how you're going to use Azure Storage.

## Features of Azure Storage that support multitenancy

Azure Storage includes many features that support multitenancy.

### Shared access signatures

When you work with Azure Storage from a client application, it's important to consider whether client requests should be sent through another component that you control, like a content delivery network or API, or if the client should connect directly to your storage account. There might be good reasons to send requests through another component, including caching data at the edge of your network. However, in some situations, it's advantageous for client endpoints to connect directly to Azure Storage to download or upload data. This connection helps you improve the performance of your solution, especially when you work with large blobs or large numbers of files. It also reduces the load on your backend applications and servers, and it reduces the number of network hops. A [shared access signature](/azure/storage/common/storage-sas-overview) (SAS) enables you to securely provide your client applications with access to objects in Azure Storage.

Shared access signatures can be used to restrict the scope of operations that a client can perform, and the objects that they can perform operations against. For example, if you have a shared storage account for all of your tenants, and you store all of tenant A's data in a blob container named `tenanta`, you can create an SAS that only permits tenant A's users to access that container. For more information, see [Isolation models](#isolation-models) to explore the approaches you can use to isolate your tenants' data in a storage account.

The [Valet Key pattern](../../../patterns/valet-key.yml) is useful as a way to issue constrained and scoped shared access signatures from your application tier. For example, suppose you have a multitenant application that allows users to upload videos. Your API or application tier can authenticate the client using your own authentication system. You can then provide a SAS to the client that allows them to upload a video file to a specified blob, into a container and blob path that you specify. The client then uploads the file directly to the storage account, avoiding the extra bandwidth and load on your API. If they try to read data from the blob container, or if they try to write data to a different part of the container to another container in the storage account, Azure Storage blocks the request. The signature expires after a configurable time period.

[Stored access policies](/rest/api/storageservices/define-stored-access-policy) extend the SAS functionality, which enables you to define a single policy that can be used when issuing multiple shared access signatures.

### Identity-based access control

Azure Storage also provides [identity-based access control](/azure/storage/blobs/authorize-access-azure-active-directory) by using Azure Active Directory (Azure AD). This capability also enables you to use [attribute-based access control](/azure/role-based-access-control/conditions-overview), which gives you finer-grained access to blob paths, or to blobs that have been tagged with a specific tenant ID.

### Lifecycle management

When you use blob storage in a multitenant solution, your tenants might require different policies for data retention. When you store large volumes of data, you might also want to configure the data for a specific tenant to automatically be moved to the [cool or archive storage tiers](/azure/storage/blobs/storage-blob-storage-tiers), for cost-optimization purposes.

Consider using [lifecycle management policies](/azure/storage/blobs/lifecycle-management-overview) to set the blob lifecycle for all tenants, or for a subset of tenants. A lifecycle management policy can be applied to blob containers, or to a subset of blobs within a container. However, there are limits on the number of rules you can specify in a lifecycle management policy. Make sure you plan and test your use of this feature in a multitenant environment, and consider deploying multiple storage accounts, if you will exceed the limits.

### Immutable storage

When you configure [immutable blob storage](/azure/storage/blobs/immutable-storage-overview) on storage containers with [time-based retention policies](/azure/storage/blobs/immutable-time-based-retention-policy-overview), Azure Storage prevents deletion or modification of the data before a specified time. The prevention is enforced at the storage account layer and applies to all users. Even your organization's administrators can't delete immutable data.

Immutable storage can be useful when you work with tenants that have legal or compliance requirements to maintain data or records. However, you should consider how this feature is used within the context of your [tenant lifecycle](../considerations/tenant-lifecycle.md). For example, if tenants are offboarded and request the deletion of their data, you might not be able to fulfill their requests. If you use immutable storage for your tenants' data, consider how you address this issue in your terms of service.

### Server-side copy

In a multitenant system, there is sometimes a need to move data from one storage account to another. For example, if you move a tenant between deployment stamps or rebalance a [sharded](../../../patterns/sharding.yml) set of storage accounts, you need to copy or move a specific tenant's data. When working with large volumes of data, it's advisable to use [server-side copy APIs](https://azure.microsoft.com/updates/new-copy-apis-for-efficient-data-copy) to decrease the time it takes to migrate the data.

The [AzCopy tool](/azure/storage/common/storage-use-azcopy-v10) is an application that you can run from your own computer, or from a virtual machine, to manage the copy process. AzCopy is compatible with the server-side copy feature, and it provides a scriptable command-line interface that you can run from your own solutions. AzCopy is also helpful for uploading and downloading large volumes of data.

If you need to use the server-side copy APIs directly from your code, consider using the [Put Block From URL](/rest/api/storageservices/put-block-from-url) API, [Put Page From URL](/rest/api/storageservices/put-page-from-url) API, [Append Block From URL](/rest/api/storageservices/append-block-from-url) API, and the [Copy Blob From URL](/rest/api/storageservices/copy-blob-from-url) API when working with smaller blobs.

### Object replication

The [Object replication](/azure/storage/blobs/object-replication-overview) feature automatically replicates data between a source and destination storage account. Object replication is asynchronous. In a multitenant solution, this feature can be useful when you need to continuously replicate data between deployment stamps, or in an implementation of the [Geode pattern](../../../patterns/geodes.yml).

### Encryption

Azure Storage enables you to [provide encryption keys](/azure/storage/blobs/encryption-customer-provided-keys) for your data. In a multitenant solution, consider combining this capability with [encryption scopes](/azure/storage/blobs/encryption-scope-overview), which enable you to define different encryption keys for different tenants, even if their data is stored in the same storage account. By using these features together, you can also provide tenants with control over their own data. If they need to deactivate their account, they can delete the encryption key and their data is no longer accessible.

### Monitoring

When working with a multitenant solution, consider whether you need to [measure the consumption for each tenant](../considerations/measure-consumption.md), and define the specific metrics you need to track, such as the amount of storage used for each tenant (the capacity), or the number of operations performed for each tenant's data. You can also use [cost allocation](/azure/cost-management-billing/costs/allocate-costs) to track the cost of each tenant's usage and enable chargeback.  This can be useful if you have multiple subscriptions e.g., have a shared service in a different subscription than the tenant's subscription and need to manage and show cost accountability from all associated resources in multiple subscriptions.

Azure Storage provides [built-in monitoring capabilities](/azure/storage/blobs/monitor-blob-storage). It's important to consider the services you'll use within the Azure Storage account. For example, when you work with [blobs](/azure/storage/blobs/monitor-blob-storage-reference), it's possible to view the total capacity of a storage account, but not a single container. In contrast, when you work with file shares, it's possible to see the capacity for each share, but not for each folder.

You can also [log all of the requests made to Azure Storage](/azure/storage/blobs/monitor-blob-storage?tabs=azure-portal#analyzing-logs), and then you can aggregate and analyze those logs. This provides more flexibility in how you aggregate and group data for each tenant. However, in solutions that create high volumes of requests to Azure Storage, it's important to consider whether the benefit you gain from this approach justifies the cost involved in capturing and processing those logs.

[Azure Storage inventory](/azure/storage/blobs/calculate-blob-count-size) provides another approach to measure the total size of a blob container.

## Isolation models

When working with a multitenant system using Azure Storage, you need to make a decision about the level of isolation you want to use. Azure Storage supports several isolation models.

### Storage accounts per tenant

The strongest level of isolation is to deploy a dedicated storage account for a tenant. This ensures that all storage keys are isolated and can be rotated independently. This approach enables you to scale your solution to avoid limits and quotas that are applicable to each storage account, but you also need to consider the maximum number of storage accounts that can be deployed into a single Azure subscription.

> [!NOTE]
> Azure Storage has many quotas and limits that you should consider when you select an isolation model. These include [Azure service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#storage-limits), [scalability targets](/azure/storage/blobs/scalability-targets), and [scalability targets for the Azure Storage resource provider](/azure/storage/common/scalability-targets-resource-provider).

Additionally, each component of Azure Storage provides further options for tenant isolation.

### Blob storage isolation models

The following table summarizes the differences between the main tenancy isolation models for Azure Storage blobs:

| Consideration | Shared blob containers | Blob containers per tenant | Storage accounts per tenant |
|---|---|---|---|
| **Data isolation** | Low-medium. Use paths to identify each tenant's data, or hierarchical namespaces | Medium. Use container-scoped SAS URLs to support security isolation | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to entire storage account | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | Storing a small number of blobs per tenant | Issue tenant-scoped SAS URLs | Separate deployment stamps for each tenant |

#### Shared blob containers

When working with blob storage, you might choose to use a shared blob container, and you might then use blob paths to separate data for each tenant:

| Tenant ID | Example blob path |
|-|-|
| `tenant-a` | `https://contoso.blob.core.windows.net/sharedcontainer/tenant-a/blob1.mp4` |
| `tenant-b` | `https://contoso.blob.core.windows.net/sharedcontainer/tenant-b/blob2.mp4` |

While this approach is simple to implement, in many scenarios, blob paths don't provide sufficient isolation across tenants. This is because blob storage doesn't typically provide a concept of directories or folders. This means you can't assign access to all blobs within a specified path. However, Azure Storage provides a capability to [list (enumerate) blobs that begin with a specified prefix](/rest/api/storageservices/enumerating-blob-resources), which can be helpful when you work with shared blob containers and don't require directory-level access control.

Azure Storage's [hierarchical namespace](/azure/storage/blobs/data-lake-storage-namespace#deciding-whether-to-enable-a-hierarchical-namespace) feature provides the ability to have a stronger concept of a directory or folder, including directory-specific access control. This can be useful in some multitenant scenarios where you have shared blob containers, but you want to grant access to a single tenant's data.

In some multitenant solutions, you might only need to store a single blob or set of blobs for each tenant, such as tenant icons for customizing a user interface. In these scenarios, a single shared blob container might be sufficient. You could use the tenant identifier as the blob name, and then read a specific blob instead of enumerating a blob path.

When you work with shared containers, consider whether you need to track the data and Azure Storage service usage for each tenant, and plan an approach to do so. See [Monitoring](#monitoring) for further information.

#### Blob containers per tenant

You can create individual blob containers for each tenant within a single storage account. There is no limit to the number of blob containers that you can create, within a storage account.

By creating containers for each tenant, you can use Azure Storage access control, including SAS, to manage access for each tenant's data. You can also easily monitor the capacity that each container uses.

### File storage isolation models

The following table summarizes the differences between the main tenancy isolation models for Azure Storage files:

| Consideration | Shared file shares | File shares per tenant | Storage accounts per tenant |
|---|---|---|---|
| **Data isolation** | Medium-high. Apply authorization rules for tenant-specific files and directories | Medium-high | High |
| **Performance isolation** | Low | Low-medium. Most quotas and limits apply to the entire storage account, but set size quotas on a per-share level | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | Application controls all access to files | Tenants access their own files | Separate deployment stamps for each tenant |

#### Shared file shares

When working with file shares, you might choose to use a shared file share, and then you might use file paths to separate data for each tenant:

| Tenant ID | Example file path |
|-|-|
| `tenant-a` | `https://contoso.file.core.windows.net/share/tenant-a/blob1.mp4` |
| `tenant-b` | `https://contoso.file.core.windows.net/share/tenant-b/blob2.mp4` |

When you use an application that can communicate using the Server Message Block (SMB) protocol, and when you use Active Directory Domain Services either on-premises or in Azure, file shares [support authorization](/azure/storage/files/storage-files-active-directory-overview) at both the share and the directory/file levels.

In other scenarios, consider using SAS to grant access to specific file shares or files. When you use SAS, you can't grant access to directories.

When you work with shared file shares, consider whether you need to track the data and Azure Storage service usage for each tenant, and then plan an approach to do so (as necessary). See [Monitoring](#monitoring) for further information.

#### File shares per tenant

You can create individual file shares for each tenant, within a single storage account. There is no limit to the number of file shares that you can create within a storage account.

By creating file shares for each tenant, you can use Azure Storage access control, including SAS, to manage access for each tenant's data. You can also easily monitor the capacity each file share uses.

### Table storage isolation models

The following table summarizes the differences between the main tenancy isolation models for Azure Storage tables:

| Consideration | Shared tables with partition keys per tenant | Tables per tenant | Storage accounts per tenant |
|---|---|---|---|
| **Data isolation** | Low. Application enforces isolation | Low-medium | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to entire storage account | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | Large multitenant solution with shared application tier | Issue tenant-scoped SAS URLs | Separate deployment stamps for each tenant |

#### Shared tables with partition keys per tenant

When using table storage with a single shared table, you can consider using the [built-in support for partitioning](/rest/api/storageservices/understanding-the-table-service-data-model#partitionkey-property). Each entity must include a partition key. A tenant identifier is often a good choice for a partition key.

Shared access signatures and policies enable you to specify a partition key range, and Azure Storage ensures that requests containing the signature can only access the specified partition key ranges. This enables you to implement the [Valet Key pattern](../../../patterns/valet-key.yml), which allows untrusted clients to access a single tenant's partition, without affecting other tenants.

For high-scale applications, consider the maximum throughput of each table partition and the storage account.

#### Tables per tenant

You can create individual tables for each tenant within a single storage account. There is no limit to the number of tables that you can create within a storage account.

By creating tables for each tenant, you can use Azure Storage access control, including SAS, to manage access for each tenant's data.

### Queue storage isolation models

The following table summarizes the differences between the main tenancy isolation models for Azure Storage queues:

| Consideration | Shared queues | Queues per tenant | Storage accounts per tenant |
|---|---|---|---|
| **Data isolation** | Low | Low-medium | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to entire storage account | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | Large multitenant solution with shared application tier | Issue tenant-scoped SAS URLs | Separate deployment stamps for each tenant |

#### Shared queues

If you choose to share a queue, consider the quotas and limits that apply. In solutions with a high request volume, consider whether the target throughput of 2,000 messages per second is sufficient.

Queues don't provide partitioning or subqueues, so data for all tenants could be intermingled.

#### Queues per tenant

You can create individual queues for each tenant within a single storage account. There is no limit to the number of queues that you can create within a storage account.

By creating queues for each tenant, you can use Azure Storage access control, including SAS, to manage access for each tenant's data.

When you dynamically create queues for each tenant, consider how your application tier will consume the messages from each tenant's queue. For more advanced scenarios, consider using [Azure Service Bus](https://azure.microsoft.com/services/service-bus), which supports features such as [topics and subscriptions](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions#topics-and-subscriptions), [sessions](/azure/service-bus-messaging/message-sessions), and [message auto-forwarding](/azure/service-bus-messaging/service-bus-auto-forwarding), which can be useful in a multitenant solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

 * [Dr. Christian Geuer-Pollmann](https://www.linkedin.com/in/chgeuer) | Principal Customer Engineer, FastTrack for Azure
 * [Patrick Horn](https://www.linkedin.com/in/patrick-horn-4383531) | Senior Customer Engineering Manager, FastTrack for Azure
 * [Ben Hummerstone](https://www.linkedin.com/in/bhummerstone) | Principal Customer Engineer, FastTrack for Azure
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
 * [Vic Perdana](https://www.linkedin.com/in/vperdana) | Cloud Solution Architect, Azure ISV

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [storage and data approaches for multitenancy](../approaches/storage-data.yml).
