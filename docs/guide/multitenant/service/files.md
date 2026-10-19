---
title: Multitenancy and Azure Files
description: Explore Azure Files features and isolation models for multitenant solutions, including tenant-specific file shares, access control, encryption, and monitoring.
author: PlagueHO
ms.author: dascottr
ms.date: 07/01/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
ai-usage: ai-assisted
---

# Multitenancy and Azure Files

Azure Files provides managed file shares that multitenant solutions can use to store tenant data. This article describes isolation models and Azure Files features for multitenant solutions. It provides links to guidance that can help you plan how to isolate tenants' files and manage access, encryption, and usage.

## Isolation models

When you use Azure Files in a multitenant system, determine the level of isolation to apply. You can share file shares, create file shares for each tenant within a storage account, or use dedicated resources for each tenant. Choose access controls and isolation models that match the protocol and resource provider that you use. The following table summarizes the differences between the main tenancy isolation models for file shares within storage accounts. For an alternative that doesn't require storage accounts, see [File shares as standalone resources](#file-shares-as-standalone-resources).

| Consideration | Shared file shares | File shares for each tenant | Storage accounts for each tenant |
| --- | --- | --- | --- |
| **Data isolation** | Medium-high. Apply authorization rules for tenant-specific files and directories. | Medium-high | High |
| **Performance isolation** | Low | Low-medium. Most quotas and limits apply to the entire storage account. Set size quotas for each file share, or use [provisioned v2 SSD shares](/azure/storage/files/understanding-billing#provisioned-v2-model) to provision IOPS and throughput for each share. | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | An application controls all access to files. | Tenants access their own files. | Each tenant has its own deployment stamp. |

> [!NOTE]
> Consider quotas and limits when you select an isolation model. These limits include [Azure service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#storage-limits), [Azure Files scalability targets](/azure/storage/files/storage-files-scale-targets), and [scalability targets for the Storage resource provider](/azure/storage/common/scalability-targets-resource-provider).

### Shared file shares

When you work with file shares, you might use a shared file share that includes file paths to separate the data for each tenant.

| Tenant ID | Example file path |
| --- | --- |
| `tenant-a` | `https://contoso.file.core.windows.net/share/tenant-a/file1.mp4` |
| `tenant-b` | `https://contoso.file.core.windows.net/share/tenant-b/file2.mp4` |

File paths identify each tenant's data but don't enforce isolation by themselves. Consider isolation approaches based on the way your applications access data in the share:

- For Server Message Block (SMB) access, apply share-level authorization and directory or file permissions to restrict each tenant's access.
- For FileREST access, issue shared access signature (SAS) tokens scoped to the appropriate resources or enforce isolation in your application.
- For [NFS access](/azure/storage/files/files-nfs-protocol#authentication-and-network-access), don't rely on tenant directories or separate shares within one storage account to isolate mutually untrusted, tenant-controlled clients. NFS uses network-level access controls instead of user-based authentication. Classic shares share account-level network rules. Route access through a trusted application tier, or use separate storage accounts or standalone shares with tenant-specific network restrictions.

When you use shared file shares, consider whether you need to track the data and usage for each tenant. For more information, see [Monitoring](#monitoring).

### File shares for each tenant

You can create individual file shares for each tenant within a single storage account. For this scenario, use Azure Files access control to manage access for each tenant's data. Choose identity-based authorization for SMB or scoped access for FileREST. You can also monitor the capacity that each file share uses.

For SSD file shares, the [provisioned v2 model](/azure/storage/files/understanding-billing#provisioned-v2-model) lets you provision storage, IOPS, and throughput independently for each share. This capability improves performance isolation between tenants because one tenant's activity doesn't consume the throughput that you provision for another tenant's share. It also supports per-tenant cost tracking because Azure Files bills each share for its provisioned capacity.

### Storage accounts for each tenant

A dedicated storage account for each tenant isolates storage account keys, which you can rotate independently. It also allows you to scale your solution beyond the limits and quotas for each storage account. But you must also consider the maximum number of storage accounts allowed within a single Azure subscription.

### File shares as standalone resources

You can create a file share as a standalone, top-level Azure resource by using the [`Microsoft.FileShares` resource provider](/azure/storage/files/create-file-share), which deploys a share without a storage account. Each share has its own performance, redundancy, networking, and billing settings, so you can isolate tenants without managing shared storage account limits. Consider the [number of file shares that you can deploy for each subscription in each region](/azure/storage/files/storage-files-scale-targets#file-share-scale-targets-microsoftfileshares) when you evaluate this model.

This resource provider currently only supports NFS 4.1 SSD shares that use the [provisioned v2 billing model](/azure/storage/files/understanding-billing#provisioned-v2-model), and it doesn't support the SMB protocol. If your tenants need SMB access, the [identity-based authorization options](#identity-based-access-control) described later in this article, or HDD storage, use file shares within a storage account instead. For the full list of differences, see [Comparison of the Microsoft.Storage and Microsoft.FileShares providers](/azure/storage/files/storage-files-planning#comparing-resource-providers-microsoftstorage-versus-microsoftfileshares).

## Features of Azure Files that support multitenancy

The following Azure Files features can help you implement and operate your chosen isolation model.

### Shared access signatures

When you access Azure Files through the FileREST API, consider whether to route client requests through your application tier or allow clients to connect directly to a file share. Direct client access can reduce the load on your back-end applications and the number of network hops.

A [shared access signature (SAS)](/azure/storage/common/storage-sas-overview) enables you to provide client applications with limited access to file shares or individual files. You can restrict the operations that a client can perform and the time period when access is allowed. SAS authorization applies to FileREST requests, not to SMB or NFS access.

Use the [Valet Key pattern](../../../patterns/valet-key.yml) to issue constrained and scoped SAS tokens from your application tier. Authenticate the client by using your application's authentication system, determine which tenant's files they can access, and issue a token for only the required resources and operations.

[Stored access policies](/rest/api/storageservices/define-stored-access-policy) enable you to define a single policy to use when you issue multiple service SAS tokens. Stored access policies don't apply to user delegation SAS tokens or account SAS tokens.

#### User delegation SAS

A service SAS or account SAS is signed with one of your storage account keys. A [user delegation SAS](/rest/api/storageservices/create-user-delegation-sas) is secured with Microsoft Entra credentials instead. Your application tier requests a user delegation key by using its own managed identity, then signs scoped, time-limited tokens for each tenant. You don't distribute or store account keys. Microsoft recommends using a user delegation SAS instead of an account-key SAS when your design supports it.

Use short token lifetimes and plan how to revoke access if a token is compromised. To correlate your application logs with Azure Files logs, set a client request ID (`x-ms-client-request-id`) on FileREST requests and log it alongside the tenant ID.

### Identity-based access control

When your application communicates through the SMB protocol, Azure Files [supports identity-based authorization](/azure/storage/files/storage-files-active-directory-overview) at both the share level and the directory or file level. You can use on-premises Active Directory Domain Services, Microsoft Entra Domain Services, or [Microsoft Entra Kerberos for hybrid and cloud-only identities](/azure/storage/files/storage-files-identity-auth-hybrid-identities-enable). By using Microsoft Entra Kerberos, cloud-only identities can access a share without a domain controller, which removes the on-premises dependency when you authorize each tenant's users.

Applications and virtual machines can also use [managed identities to access SMB shares](/azure/storage/files/files-managed-identities) without storage account keys. Each storage account supports only one identity source, so if your tenants require different identity sources, isolate those tenants in separate storage accounts.

### Encryption

Azure Files [encrypts data at rest](/azure/storage/common/storage-service-encryption) with Microsoft-managed keys by default. For file shares within a storage account, you can use [customer-managed keys](/azure/storage/files/storage-files-planning#encryption-at-rest). If each tenant requires a separate encryption key, use separate storage accounts because the key applies at the account level.

File shares created through the `Microsoft.FileShares` resource provider use Microsoft-managed keys and don't support customer-managed keys. Consider these differences when you select an isolation model and plan your [tenant life cycle](../considerations/tenant-life-cycle.md).

### Monitoring

In a multitenant solution, consider whether you need to [measure the consumption for each tenant](../considerations/measure-consumption.md). Define the specific metrics to track, such as the storage capacity that each tenant uses or the number of operations performed for each tenant's files. You can also use [cost allocation](../approaches/cost-management-allocation.md) to track the cost of each tenant's usage and enable chargeback across multiple subscriptions.

Azure Files provides [built-in monitoring capabilities](/azure/storage/files/storage-files-monitoring). You can view the capacity for each share but not each folder. If tenants share a file share, plan how to measure usage for each tenant.

You can collect request logs, then aggregate and analyze them for each tenant. Verify which operations your protocol and resource provider log. In solutions that create high volumes of requests, consider whether the benefit justifies the cost to capture and process those logs.

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
- [Architecture best practices for Azure Files](/azure/well-architected/service-guides/azure-files)
- [Multitenancy and Azure Blob Storage](blob-storage.md)
- [Multitenancy and Azure Queue Storage](queue-storage.md)
- [Multitenancy and Azure Table Storage](table-storage.md)
