---
title: Azure Service Bus considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Service Bus that are useful when you use it in multitenanted systems. It provides links to guidance for how to use Azure Service Bus in a multitenant solution.
author: willvelida
ms.author: willvelida
ms.date: 02/15/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-service-bus
categories:
 - integration
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Service Bus

Azure Service Bus provides highly reliable and asynchronous cloud messaging between applications and services that aren't necessarily online at the same time. Service Bus is a fully managed enterprise-level message broker with support for both message queues and publish-subscribe topics. In this article, we describe some of the features of Service Bus that are useful for multitenant solutions. We then provide links to the guidance that can help you when you're planning how you're going to use Service Bus.

## Isolation models

When working with a multitenant system that uses Service Bus, you need to make a decision about the level of isolation that you want to adopt. Service Bus supports several isolation models.

The following table summarizes the differences between the main tenancy models for Service Bus:

| **Consideration** | **Namespace per tenant** | **Shared namespace, separate topics or queues per tenant** | **Shared namespace, topics or queues between tenants** |
| --- | --- | --- | --- |
| **Data isolation** | High | Medium  | None |
| **Performance isolation** | Highest. Manage performance needs based on each tenant's requirements | Medium. Potentially subject to noisy neighbor issues | Low. Potentially subject to noisy neighbor issues |
| **Deployment complexity** | Medium. Be aware of [Azure Service Bus quotas and limits](/azure/service-bus-messaging/service-bus-quotas) at the subscription level | Medium. Message entities must be deployed on a per-tenant basis. Be aware of [Azure Service Bus quotas and limits](/azure/service-bus-messaging/service-bus-quotas) at the namespace level | Low |
| **Operational complexity** | High. Need to manage namespaces on a per-tenant basis | Medium. Granular management of message entities might be required depending on tenant  | Low |
| **Example scenario** | Individual application instances per tenant | Dedicated queues for each tenant | Large multitenant solution with a shared application tier and one or more shared queues and topics |

### Dedicated namespace per tenant

Within your solution, you can use a specific Service Bus namespace for each tenant. This deployment approach provides your solution with the maximum level of isolation, with the ability to provide consistent performance per tenant.

You can also fine-tune messaging capabilities for each tenant based on their needs, such as by using the following approaches:

- Deploy the namespace to a region that's close to the tenant.
- Deploy a tenant-specific namespace with a pricing tier that's appropriate to that tenant. For example, you can provision [premium namespaces](/azure/service-bus-messaging/service-bus-premium-messaging) with a different number of [messaging units](/azure/service-bus-messaging/service-bus-premium-messaging#how-many-messaging-units-are-needed).
- Apply networking restrictions based on the tenant's needs.
- Use [tenant-specific encryption keys](#customer-managed-keys).

The disadvantage to this isolation model is that, as the number of tenants grows within your system over time, the operational complexity of managing your namespaces also increases. If you reach the maximum number of namespaces per Azure subscription, you could deploy namespaces across different subscriptions (see [deployment stamp pattern](/azure/architecture/patterns/deployment-stamp)). This approach also increases resource costs, since you pay for each namespace you provision.

### Separate topics and queues in a shared namespace

You can isolate your tenants on a messaging entity level. For example, each tenant within your system can have a dedicated one or more queues that it listens to. You can authenticate and authorize access to each tenant's messaging entity with a different shared access signature or Azure Active Directory (Azure AD) identity.

As the number of tenants grows within your system, the number of queues, topics, or subscriptions also increases to accommodate each tenant. This growth might lead to higher operational costs and lower organizational agility.

Because the namespace is shared across all tenants, [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) problems are more likely with this approach. For example, it's possible that a single tenant's messaging entities could consume a disproportionate amount of the namespace resources and impact all the other tenants. Service Bus namespaces have limits around the messaging unit capacity and the number of concurrent connections to a namespace. Consider whether a single tenant might consume more than their fair share of these resources.

There are also [limits](/azure/service-bus-messaging/service-bus-quotas) on how many topics and queues you can provision within a single namespace, although these limits are higher than the limit of namespaces in a subscription.

### Shared topics or queues

Use the same namespace and messaging entities for all your tenants to decrease your operational complexity and to lower your resource costs. It can also unlock advanced messaging and [filtering](#topic-filters-and-actions) scenarios.

However, having a single namespace that all your tenants share can also lead to the [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) problem, which might cause higher latency for some tenants. You'll also need to make your application code multitenancy-aware. For example, you can pass the tenant context within the message payload or in a user-defined property. This approach enables you to correctly handle messages that are intended for different tenants. Service Bus provides topic filters and actions, which can be used to define which message a particular subscriber should receive. When using a shared topic or queue, there's no data isolation between tenants, so you'll need to implement your data isolation requirements within your application logic.

> [!NOTE]
> [Sessions](/azure/service-bus-messaging/message-sessions) are a useful feature to support message ordering requirements. However, they aren't typically used for isolating data between tenants, unless you also have requirements for message ordering within a tenant. For most multitenant solutions, you should consider using one of the other isolation models described in this article.

## Features of Azure Service Bus that support multitenancy

### Azure Active Directory (AD) authentication

Service Bus is integrated with Azure AD, which allows clients to authenticate a managed identity with Azure AD to Service Bus resources. Service Bus defines a set of built-in roles that you can grant to your tenants to access Service Bus entities. For example, with Azure AD authentication, you can grant a tenant access to a specific queue or topic that contains their messages, which isolates it from the other tenants within your application.

See [Authenticate a managed identity with Azure Active Directory to access Azure Service Bus resources](/azure/service-bus-messaging/service-bus-managed-service-identity#resource-scope).

### Customer-managed keys

If your tenants need to use their own keys to encrypt and decrypt messages, you can configure customer-managed keys in Service Bus premium namespaces. This feature requires that you adopt the [dedicated namespace-per-tenant](#dedicated-namespace-per-tenant) isolation model.

See [Configure customer-managed keys for encrypting Azure Service Bus data at rest](/azure/service-bus-messaging/configure-customer-managed-key).

### Shared access signatures

Shared access signatures (SAS) give you the ability to grant a tenant access to Service Bus resources with specific rights. If you choose to isolate your tenants at a messaging entity level, you can grant SAS keys on a queue or topic that only apply to a particular tenant.

For more information, see the following articles:

- [Shared Access Signature in Azure Service Bus](/azure/service-bus-messaging/service-bus-authentication-and-authorization#shared-access-signature)
- [Service Bus access control with Shared Access Signatures](/azure/service-bus-messaging/service-bus-sas)

### Topic filters and actions

If you're using Service Bus topics within your namespace, you can use topic filters and actions to allow your subscribers to define which messages they want to receive from a topic. Each rule has a filter condition that selects the desired message, along with an action that will annotate the message. For example, if your topic subscriptions are split on a per-tenant basis, you can use filters to receive messages from a topic that are only intended for that tenant.

See [Topic filters and actions](/azure/service-bus-messaging/topic-filters).

### Suspend and reactivate messaging entities

You can temporarily suspend message entities. Suspension puts the messaging entity into a disabled state, and all messages are maintained in storage. The ability to deactivate messaging entities is useful when handling your [tenant lifecycle](../considerations/tenant-lifecycle.md). For example, if a tenant unsubscribes from your product, you could disable the queues that are specific to that particular tenant.

See [Suspend and reactivate messaging entities (disable)](/azure/service-bus-messaging/entity-suspend).

### Partitioning

Partitions can be used to improve the throughput of your messaging entities by distributing the messages across multiple message brokers and message stores.

You can assign a partition to a specific tenant by setting the message's partition key to that tenant's identifier. This approach ensures that Service Bus assigns the message to that tenant's partition. However, Service Bus has limits on the number of partitions that you can support on a single entity. For shared entities, you should consider using partition keys that are derived from the tenant ID. For example, you could use a hashing algorithm that converts tenant IDs to a fixed number of partition keys.

Partitioning is available when you deploy namespaces with specific SKUs. For more information, see [Service Bus Premium and Standard messaging tiers](/azure/service-bus-messaging/service-bus-premium-messaging).

See [Partitioned queues and topics](/azure/service-bus-messaging/service-bus-partitioning).

> [!NOTE]
> Partitioning is available at entity creation for all queues and topics in Basic or Standard SKUs. It isn't available for the Premium messaging SKU anymore, but any previously existing partitioned entities from when they were supported in Premium namespaces will continue to work as expected.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Will Velida](http://linkedin.com/in/willvelida) | Customer Engineer 2, FastTrack for Azure

Other contributors:

* [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
* [Daniel Larsen](https://www.linkedin.com/in/daniellarsennz) | Principal Customer Engineer, FastTrack for Azure
* [Paolo Salvatori](http://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
* [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [architectural approaches for messaging in multitenant solutions](../approaches/messaging.md)
