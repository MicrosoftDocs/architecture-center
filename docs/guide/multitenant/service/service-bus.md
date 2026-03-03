---
title: Azure Service Bus Considerations for Multitenancy
description: Explore Azure Service Bus isolation models, authentication, and features for multitenant architectures. Learn best practices for tenant data separation.
author: PlagueHO
ms.author: dascottr
ms.date: 05/02/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Azure Service Bus considerations for multitenancy

Azure Service Bus provides highly reliable and asynchronous cloud messaging between applications and services that aren't necessarily online at the same time. Service Bus is a fully managed enterprise-level message broker that supports both message queues and publish-subscribe topics. This article describes features of Service Bus that are useful for multitenant solutions. It also provides resources that can help you plan how to use Service Bus.

## Isolation models

When you work with a multitenant system that uses Service Bus, you need to make a decision about the level of isolation that you want to adopt. Service Bus supports several isolation models.

The following table summarizes the differences between the main tenancy models for Service Bus.

| Consideration | Namespace for each tenant | Shared namespace or separate topics or queues for each tenant | Shared namespace, topics, or queues between tenants |
| :--- | :--- | :--- | :--- |
| Data isolation | High | Medium | None |
| Performance isolation | Highest. Manage performance needs based on each tenant's requirements. | Medium. Potentially subject to noisy neighbor problems. | Low. Potentially subject to noisy neighbor problems. |
| Deployment complexity | Medium. Be aware of [Service Bus quotas and limits](/azure/service-bus-messaging/service-bus-quotas) at the subscription level. | Medium. Message entities must be deployed separately for each tenant. Be aware of [Service Bus quotas and limits](/azure/service-bus-messaging/service-bus-quotas) at the namespace level. | Low |
| Operational complexity | High. Manage namespaces separately for each tenant. | Medium. Granular management of message entities might be required depending on tenant. | Low |
| Example scenario | Individual application instances for each tenant | Dedicated queues for each tenant | Large multitenant solution with a shared application tier and one or more shared queues and topics |

### Dedicated namespace for each tenant

Within your solution, you can use a specific Service Bus namespace for each tenant. This deployment approach provides your solution with the maximum level of isolation and the ability to provide consistent performance for each tenant.

You can also fine-tune messaging capabilities for each tenant based on their needs by using the following approaches:

- Deploy the namespace to a region that's close to the tenant.

- Deploy a tenant-specific namespace with a pricing tier that's appropriate to that tenant. For example, you can provision [premium namespaces](/azure/service-bus-messaging/service-bus-premium-messaging) that have a different number of [messaging units (MUs)](/azure/service-bus-messaging/service-bus-premium-messaging#how-many-messaging-units-are-needed).

- Apply networking restrictions based on the tenant's needs.

- Use [tenant-specific encryption keys](#customer-managed-keys).

- Configure [geo-replication](/azure/service-bus-messaging/service-bus-geo-replication) or [geo‑disaster recovery](/azure/service-bus-messaging/service-bus-geo-dr) to replicate the metadata and data of the namespace to another region.

The disadvantage to this isolation model is that as the number of tenants grows within your system over time, the operational complexity of managing your namespaces also increases. If you reach the maximum number of namespaces for each Azure subscription, you could deploy namespaces across different subscriptions. For more information, see [Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp). This approach also increases resource costs because you pay for each namespace that you provision.

### Separate topics and queues in a shared namespace

You can isolate your tenants on a messaging entity level. For example, each tenant within your system can have one or more dedicated queues that it interacts with. You can authenticate and authorize access to each tenant's messaging entity with a different shared access signature or Microsoft Entra identity.

As the number of tenants grows within your system, the number of queues, topics, or subscriptions also increases to accommodate each tenant. This growth might result in higher operational costs and lower organizational agility.

Because the namespace is shared across all tenants, [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) are more likely with this approach. For example, it's possible that a single tenant's messaging entities could consume a disproportionate amount of the namespace resources and affect all the other tenants. Service Bus namespaces have limits around the MU capacity and the number of concurrent connections to a namespace. Consider whether a single tenant might consume more than their fair share of these resources.

There are also [limits](/azure/service-bus-messaging/service-bus-quotas) on the number of topics and queues that you can provision within a single namespace. However, these limits are higher than the limit of namespaces in a subscription.

### Shared topics or queues

Use the same namespace and messaging entities for all your tenants to decrease your operational complexity and to lower your resource costs. It can also unlock advanced messaging and [filtering](#topic-filters-and-actions) scenarios.

However, having a single namespace that all your tenants share can also result in the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), which might cause higher latency for some tenants. You also need to make your application code multitenancy-aware. For example, you can pass the tenant context within the message payload or in a user-defined property. This approach enables you to correctly handle messages that are intended for different tenants. Service Bus provides topic filters and actions, which can be used to define which message a specific subscriber should receive. When you use a shared topic or queue, there's no data isolation between tenants, so you need to implement your data isolation requirements within your application logic.

> [!NOTE]
> [Sessions](/azure/service-bus-messaging/message-sessions) are a useful feature to support message ordering requirements. However, they aren't typically used to isolate data between tenants, unless you also have requirements for message ordering within a tenant. For most multitenant solutions, consider using one of the other isolation models described in this article.

## Features of Service Bus that support multitenancy

<a name='azure-active-directory-ad-authentication'></a>

### Microsoft Entra authentication

Service Bus is integrated with Microsoft Entra ID. This integration allows clients to authenticate a managed identity with Microsoft Entra ID to Service Bus resources. Service Bus defines a set of built-in roles that you can grant to your tenants to access Service Bus entities. For example, you can use Microsoft Entra authentication to grant a tenant access to a specific queue or topic that contains their messages. This approach isolates it from the other tenants within your application.

For more information, see [Authenticate a managed identity by using Microsoft Entra ID to access Service Bus resources](/azure/service-bus-messaging/service-bus-managed-service-identity#resource-scope).

### Customer-managed keys

If your tenants need to use their own keys to encrypt and decrypt messages, you can configure customer-managed keys in Service Bus premium namespaces. This feature requires that you adopt the [dedicated namespace-per-tenant](#dedicated-namespace-for-each-tenant) isolation model.

For more information, see [Configure customer-managed keys for encrypting Service Bus data at rest](/azure/service-bus-messaging/configure-customer-managed-key).

### Shared access signatures

Shared access signatures give you the ability to grant a tenant access to Service Bus resources with specific rights. If you choose to isolate your tenants at a messaging entity level, you can grant shared access signature keys on a queue or topic that only apply to a specific tenant.

For more information, see the following articles:

- [Shared access signatures in Service Bus](/azure/service-bus-messaging/service-bus-authentication-and-authorization#shared-access-signature)
- [Service Bus access control with shared access signatures](/azure/service-bus-messaging/service-bus-sas)

### Topic filters and actions

If you use Service Bus topics within your namespace, you can use topic filters and actions to allow your subscribers to define which messages they want to receive from a topic. Each rule has a filter condition that selects the desired message, along with an action that annotates the message. For example, if your topic subscriptions are divided by tenant, you can use filters to receive messages from a topic that are only intended for that tenant.

For more information, see [Topic filters and actions](/azure/service-bus-messaging/topic-filters).

### Suspend and reactivate messaging entities

You can temporarily suspend message entities. Suspension puts the messaging entity into a disabled state, and all messages are maintained in storage. The ability to deactivate messaging entities is useful when handling your [tenant life cycle](../considerations/tenant-life-cycle.md). For example, if a tenant unsubscribes from your product, you could disable the queues that are specific to that specific tenant.

For more information, see [Suspend and reactivate messaging entities (disable)](/azure/service-bus-messaging/entity-suspend).

### Partitioning

You can use partitions to improve the throughput of your messaging entities by distributing the messages across multiple message brokers and message stores.

You can assign a partition to a specific tenant by setting the message's partition key to that tenant's identifier. This approach ensures that Service Bus assigns the message to that tenant's partition. However, Service Bus has limits on the number of partitions that you can support on a single entity. For shared entities, consider using partition keys that are derived from the tenant ID. For example, you could use a hashing algorithm that converts tenant IDs to a fixed number of partition keys.

Partitioning is available when you deploy namespaces with specific SKUs. For more information, see [Service Bus Premium messaging tiers](/azure/service-bus-messaging/service-bus-premium-messaging) and [Partitioned queues and topics](/azure/service-bus-messaging/service-bus-partitioning).

### Automatic update of MUs

Service Bus premium namespaces can automatically adjust the number of MUs assigned to a namespace. Enable this feature to allow the namespace to elastically scale based on load. Elastic scaling can be useful in shared namespace multitenant designs to reduce the risk of [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) without requiring manual intervention.

For more information, see [Automatically update MUs of a Service Bus namespace](/azure/service-bus-messaging/automate-update-messaging-units).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Will Velida](https://www.linkedin.com/in/willvelida) | Customer Engineer 2, FastTrack for Azure

Other contributors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Daniel Larsen](https://www.linkedin.com/in/daniellarsennz) | Principal Customer Engineer, FastTrack for Azure
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Solution Architect, Data & AI
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md)
