---
title: Multitenancy and Azure Queue Storage
description: Explore Azure Queue Storage features and isolation models for multitenant solutions, including tenant-scoped access, encryption, and monitoring.
author: PlagueHO
ms.author: dascottr
ms.date: 07/01/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
ai-usage: ai-assisted
---

# Multitenancy and Azure Queue Storage

Azure Queue Storage stores messages for asynchronous processing. This article describes isolation models and Queue Storage features for multitenant solutions. It provides links to guidance that can help you plan how to isolate tenants' messages and manage access, encryption, and usage.

## Isolation models

When you use Queue Storage in a multitenant system, determine the level of isolation to apply. Queue Storage supports shared queues, queues for each tenant, and storage accounts for each tenant. The following table summarizes the differences between the main tenancy isolation models for Queue Storage.

| Consideration | Shared queues | Queues for each tenant | Storage accounts for each tenant |
| --- | --- | --- | --- |
| **Data isolation** | Low. The application enforces isolation. | Low-medium | High |
| **Performance isolation** | Low | Low. Most quotas and limits apply to the entire storage account. | High |
| **Deployment complexity** | Low | Medium | High |
| **Operational complexity** | Low | Medium | High |
| **Example scenario** | A large multitenant solution has a shared application tier. | Tenant-scoped shared access signature (SAS) URLs are issued. | Each tenant has its own deployment stamp. |

> [!NOTE]
> Consider quotas and limits when you select an isolation model. These limits include [Azure service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#storage-limits), [Queue Storage scalability targets](/azure/storage/queues/scalability-targets), and [scalability targets for the Storage resource provider](/azure/storage/common/scalability-targets-resource-provider).

### Shared queues

If you share a queue, consider the quotas and limits that apply. In solutions that have a high request volume, consider whether the [target throughput of 2,000 messages per second for a queue](/azure/storage/queues/scalability-targets), assuming a message size of 1 KiB, works for your scenario.

Queues don't provide partitioning or subqueues, so all tenants' data might become intermingled. Your application must identify the tenant for each message and enforce isolation during processing. Don't grant tenants direct access to a shared queue if they must not access other tenants' messages.

### Queues for each tenant

You can create individual queues for each tenant within a single storage account. There's no limit to the number of queues that you can create within a storage account.

For this scenario, you can use Queue Storage access control, including SAS, to manage access for each tenant's data.

When you dynamically create queues for each tenant, consider how your application tier consumes the messages from each tenant's queue. For advanced scenarios, consider using [Azure Service Bus](service-bus.md), which supports features such as [sessions](/azure/service-bus-messaging/message-sessions), [message autoforwarding](/azure/service-bus-messaging/service-bus-auto-forwarding), and [topics and subscriptions](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions#topics-and-subscriptions).

### Storage accounts for each tenant

The strongest level of isolation uses a dedicated storage account for each tenant. This model ensures full isolation of storage account keys, which you can rotate independently. It also allows you to scale your solution beyond the limits and quotas for each storage account. But you must also consider the maximum number of storage accounts allowed within a single Azure subscription.

## Features of Queue Storage that support multitenancy

The following Queue Storage features can help you implement and operate your chosen isolation model.

### Shared access signatures

When you use Queue Storage from a client application, consider whether to route requests through your application tier or allow clients to connect directly to a queue. Direct client access can reduce the load on your back-end applications and the number of network hops.

A [shared access signature (SAS)](/azure/storage/common/storage-sas-overview) enables you to provide client applications with limited access to a queue. You can restrict the operations that a client can perform and the time period when access is allowed. For example, you can issue a SAS that lets a tenant add messages to its own queue without permitting it to read or delete messages.

Use the [Valet Key pattern](../../../patterns/valet-key.yml) to issue constrained and scoped SAS tokens from your application tier. Authenticate the client by using your application's authentication system, determine which tenant's queue they can access, and issue a token for only the required operations.

[Stored access policies](/rest/api/storageservices/define-stored-access-policy) enable you to define a single policy to use when you issue multiple service SAS tokens. Stored access policies don't apply to user delegation SAS tokens or account SAS tokens.

#### User delegation SAS

A service SAS or account SAS is signed with one of your storage account keys. A [user delegation SAS](/rest/api/storageservices/create-user-delegation-sas) is secured with Microsoft Entra credentials instead. Your application tier requests a user delegation key by using its own managed identity, then signs scoped, time-limited tokens for each tenant. You don't distribute or store account keys. Microsoft recommends using a user delegation SAS instead of an account-key SAS when your design supports it.

Use short token lifetimes and plan how to revoke access if a token is compromised. To correlate your application logs with Queue Storage logs, set a client request ID (`x-ms-client-request-id`) on storage requests and log it alongside the tenant ID.

### Identity-based access control

Queue Storage provides [identity-based access control](/azure/storage/queues/authorize-access-azure-active-directory) through Microsoft Entra ID. Use managed identities and Azure role-based access control to authorize your application to access queues without storing account keys. Scope access to each tenant's queue when tenants require direct access. Queue-level authorization doesn't isolate individual tenants' messages within a shared queue.

### Encryption

Queue Storage [encrypts data at rest](/azure/storage/common/storage-service-encryption) with Microsoft-managed keys by default. To use customer-managed keys, [configure the storage account to use an account-scoped encryption key for queues](/azure/storage/common/account-encryption-key-create) when you create the account. You can't change this encryption key scope after account creation.

If tenants require separate customer-managed keys, use separate storage accounts. Blob Storage encryption scopes and customer-provided keys on individual requests don't apply to Queue Storage. Plan key rotation and revocation alongside your [tenant life cycle](../considerations/tenant-life-cycle.md).

### Monitoring

In a multitenant solution, consider whether you need to [measure the consumption for each tenant](../considerations/measure-consumption.md). Define the specific metrics to track, such as the number of messages or operations for each tenant. You can also use [cost allocation](../approaches/cost-management-allocation.md) to track the cost of each tenant's usage and enable chargeback across multiple subscriptions.

Queue Storage provides [built-in monitoring capabilities](/azure/storage/queues/monitor-queue-storage). When tenants share a queue, include tenant identifiers in your application telemetry so that you can attribute message processing and usage to the correct tenant.

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
- [Multitenancy and Azure Service Bus](service-bus.md)
- [Multitenancy and Azure Blob Storage](blob-storage.md)
- [Multitenancy and Azure Files](files.md)
- [Multitenancy and Azure Table Storage](table-storage.md)
