---
title: Azure Service Bus Considerations for Multitenancy
description: Explore Azure Service Bus isolation models, authentication, and features for multitenant architectures. Learn best practices for tenant data separation.
author: PlagueHO
ms.author: dascottr
ms.date: 10/20/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
ai-usage: ai-assisted
---

# Azure Service Bus considerations for multitenancy

Azure Service Bus provides highly reliable and asynchronous cloud messaging between applications and services that aren't necessarily online at the same time. Service Bus is a fully managed enterprise-level message broker that supports both message queues and publish-subscribe topics. This article describes partitioning strategies, isolation models, and Service Bus features for multitenant solutions.

## Partitioning strategies

Service Bus can partition a queue or topic across multiple message brokers and messaging stores. Partitioning increases the potential throughput of a messaging entity and helps the entity remain available when one message store is temporarily unavailable.

Partitioning distributes messages within an entity, but it doesn't provide data or performance isolation between tenants. Tenants that share a partitioned queue or topic still share the entity and namespace resources.

### Understand partitions and fragments

A nonpartitioned queue or topic is handled by one message broker and one messaging store. This configuration can limit the throughput of the entity. Partitioning distributes the entity across multiple brokers and stores.

A partitioned queue or topic consists of multiple internal partitions, sometimes called *fragments*. Each fragment is backed by a separate message store and message broker. Service Bus creates and manages these fragments as part of the messaging entity.

When an application sends a message, Service Bus assigns the message to a fragment by using a partition key or its internal distribution algorithm. When an application receives a message from a queue or topic subscription, Service Bus queries the fragments and returns the first available message. It caches other messages that the fragments return for subsequent receive requests.

Applications don't address or manage individual fragments. Client operations such as receive, complete, defer, dead-letter, and prefetch work the same way for partitioned and nonpartitioned entities. A fragment isn't a tenant isolation boundary or a separately addressable subqueue.

For detailed information about how Service Bus assigns messages to partitions, see [Use of partition keys in partitioned queues and topics](/azure/service-bus-messaging/service-bus-partitioning#use-of-partition-keys).

### Configure partitioning by tier

Partitioning behavior and configuration depend on the Service Bus tier:

- **Basic and Standard:** Set `EnablePartitioning` when you create an entity. Basic supports partitioned queues. Standard supports partitioned queues and topics. A partitioned entity has 16 partitions, and a namespace can contain both partitioned and nonpartitioned entities.
- **Premium:** Enable partitioning when you create the namespace. Use 1 for a nonpartitioned namespace, or 2 or 4 to partition all queues and topics in the namespace. All queues and topics in the namespace are partitioned. For more information, see [Enable partitioning for a Premium namespace](/azure/service-bus-messaging/enable-partitions-premium).

You can't change the partitioning configuration after you create the namespace, queue, or topic. Plan for expected throughput, ordering, and transaction requirements before you create these resources. Basic and Standard namespaces support up to 100 partitioned queues or topics. Premium uses namespace-level partitioning and different entity quotas. For current limits, see [Service Bus quotas](/azure/service-bus-messaging/service-bus-quotas).

If the workload can exceed namespace quotas or capacity, distribute entities across multiple namespaces. For a global workload, deploy namespaces in multiple regions and direct application instances to the appropriate regional namespace.

### Choose whether to use a partition key

If a message doesn't specify a partition key, Service Bus distributes messages across the entity's partitions in round-robin order. If the selected partition is unavailable, Service Bus can route the message to another partition. This behavior improves availability, but it doesn't provide ordering across partitions.

Some Service Bus features require messages to be routed to a specific partition. Service Bus determines the partition key from the following properties, in order:

- **`SessionId`:** Service Bus uses the session ID as the partition key and routes messages in the same session to the same partition. This behavior supports ordered message processing and consistent session state.
- **`PartitionKey`:** For messages that don't use sessions, Service Bus uses this property to route messages that must be stored together, including messages sent in one transaction.
- **`MessageId`:** When duplicate detection is enabled and neither `SessionId` nor `PartitionKey` is set, Service Bus uses the message ID as the partition key so that it can detect duplicate messages.

If you specify both `SessionId` and `PartitionKey`, set them to the same value. Messages sent in one transaction to a partitioned entity must use the same partition key. A transaction for a session-aware partitioned entity can't include messages from different sessions.

A partition key pins a message to a specific partition. If that partition is temporarily unavailable, Service Bus returns an error instead of routing the message to another partition. Don't set `SessionId` or `PartitionKey` unless your workload requires sessions, ordering within a related group of messages, or transactional co-location. When duplicate detection is enabled, Service Bus uses `MessageId` as the partition key automatically if the other key properties aren't set. For more information, see [Partitioned queues and topics](/azure/service-bus-messaging/service-bus-partitioning).

### Partition shared tenant traffic

You can use a tenant identifier as a partition key when you need ordering, sessions, or transactional co-location for that tenant's messages. However, a partition key doesn't create or reserve a dedicated partition for the tenant. Different partition key values can map to the same partition, and a high-volume tenant can create a hot partition that affects other traffic assigned to it.

If you don't need tenant-level ordering or transactional co-location, omit the partition key so that Service Bus can distribute messages for higher availability. To provide tenant data or performance isolation, use separate queues, topics, or namespaces rather than relying on partition keys. For more information, see [Isolation models](#isolation-models).

## Isolation models

After you decide how to partition message traffic, determine the level of tenant isolation to apply. Service Bus supports several isolation models.

The following table summarizes the differences between the main tenancy models for Service Bus.

| Consideration | Dedicated namespace for each tenant | Shared namespace with separate entities for each tenant | Shared namespace and entities |
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

- Deploy a tenant-specific namespace with a pricing tier that's appropriate to that tenant. For example, you can provision [Premium namespaces](/azure/service-bus-messaging/service-bus-premium-messaging) that have a different number of [messaging units (MUs)](/azure/service-bus-messaging/service-bus-premium-messaging#how-many-messaging-units-are-needed).

- Apply networking restrictions based on the tenant's needs. Service Bus namespaces [support a variety of network security approaches](/azure/service-bus-messaging/network-security), including private endpoints, virtual network service endpoints, IP firewall rules, and network security perimeters. Some features require the Premium tier. In a multitenant solution with dedicated namespaces for each tenant, you can configure network restrictions that match each tenant's security requirements.

- Use [tenant-specific encryption keys](#customer-managed-keys).

- For Premium namespaces, configure [Geo-Replication](/azure/service-bus-messaging/service-bus-geo-replication) to replicate the metadata and data of the namespace to another region.

The disadvantage to this isolation model is that as the number of tenants grows within your system over time, the operational complexity of managing your namespaces also increases. If you reach the maximum number of namespaces for each Azure subscription, you could deploy namespaces across different subscriptions. For more information, see [Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp). This approach also increases resource costs because you pay for each namespace that you provision.

### Shared namespace with separate entities for each tenant

You can use one shared namespace for all tenants, or apply the [Sharding pattern](../../../patterns/sharding.md) to distribute tenants across a small number of namespaces. In a sharded model, assign each tenant to a namespace based on criteria such as region, service tier, performance profile, reliability requirements, or compliance requirements. Maintain a mapping from each tenant identifier to the namespace that contains its messaging entities.

Namespace sharding distributes load and helps you stay within namespace quotas without introducing the operational overhead of a dedicated namespace for every tenant. Tenants in each shard still share namespace capacity and namespace-level configuration, so group tenants that have compatible requirements.

You can isolate your tenants on a messaging entity level. For example, each tenant within your system can have one or more dedicated queues that it interacts with. You can authenticate and authorize access to each tenant's messaging entity with a different shared access signature or Microsoft Entra identity.

As the number of tenants grows within your system, the number of queues, topics, or subscriptions also increases to accommodate each tenant. This growth might result in higher operational costs and lower organizational agility.

Because the namespace is shared across all tenants, [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) are more likely with this approach. For example, it's possible that a single tenant's messaging entities could consume a disproportionate amount of the namespace resources and affect all the other tenants. Service Bus namespaces have limits around the MU capacity and the number of concurrent connections to a namespace. Consider whether a single tenant might consume more than their fair share of these resources.

There are also [limits](/azure/service-bus-messaging/service-bus-quotas) on the number of topics and queues that you can provision within a single namespace. However, these limits are higher than the limit of namespaces in a subscription.

### Shared namespace and entities

Use the same namespace and messaging entities for all your tenants to decrease your operational complexity and to lower your resource costs. It can also unlock advanced messaging and [filtering](#topic-filters-and-actions) scenarios.

However, having a single namespace that all your tenants share can also result in the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), which might cause higher latency for some tenants. You also need to make your application code multitenancy-aware. For example, you can pass the tenant context within the message payload or in a user-defined property. This approach enables you to correctly handle messages that are intended for different tenants. Service Bus provides topic filters and actions, which can be used to define which message a specific subscriber should receive. When you use a shared topic or queue, there's no data isolation between tenants, so you need to implement your data isolation requirements within your application logic.

Partitioning can distribute messages across multiple message brokers and stores, but it doesn't isolate tenants that share an entity. Use a partition key derived from the tenant identifier only when you need tenant-level ordering, sessions, or transactional co-location. For more information, see [Partitioning strategies](#partitioning-strategies).

> [!NOTE]
> [Sessions](/azure/service-bus-messaging/message-sessions) are a useful feature to support message ordering requirements. However, they aren't typically used to isolate data between tenants, unless you also have requirements for message ordering within a tenant. For most multitenant solutions, consider using one of the other isolation models described in this article.

## Features of Service Bus that support multitenancy

<a name='azure-active-directory-ad-authentication'></a>

### Microsoft Entra authentication

Service Bus is integrated with Microsoft Entra ID. This integration allows clients to authenticate a managed identity with Microsoft Entra ID to Service Bus resources. Service Bus defines a set of built-in roles that you can grant to your tenants to access Service Bus entities. For example, you can use Microsoft Entra authentication to grant a tenant access to a specific queue or topic that contains their messages. This approach isolates it from the other tenants within your application.

For more information, see [Authenticate a managed identity by using Microsoft Entra ID to access Service Bus resources](/azure/service-bus-messaging/service-bus-managed-service-identity#resource-scope).

### Customer-managed keys

If your tenants need to use their own keys to encrypt and decrypt messages, you can configure customer-managed keys in dedicated Service Bus Premium namespaces. This feature requires that you adopt the [dedicated namespace-per-tenant](#dedicated-namespace-for-each-tenant) isolation model.

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

### Automatic update of MUs

Service Bus Premium namespaces can automatically adjust the number of MUs assigned to a namespace. Enable this feature to allow the namespace to elastically scale based on load. Elastic scaling can be useful in shared namespace multitenant designs to reduce the effects of any [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) without requiring manual intervention. However, it doesn't prevent one tenant from consuming the added capacity, so your application needs to monitor tenant consumption.

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

## Related resources

- [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md)
- [Architecture best practices for Azure Service Bus](/azure/well-architected/service-guides/azure-service-bus)
