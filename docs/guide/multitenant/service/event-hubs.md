---
title: Multitenancy and Azure Event Hubs
description: Learn about Azure Event Hubs features and isolation models that you can use to implement an event-driven architecture for a multitenant system.
author: PlagueHO
ms.author: dascottr
ms.date: 06/15/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-saas
---

# Multitenancy and Azure Event Hubs

[Azure Event Hubs](/azure/event-hubs/event-hubs-about) is a big data streaming platform and event ingestion service that can receive and process millions of events per second. You can use Event Hubs to transform and store event hub data by using real-time analytics providers and batching or storage adapters. For a comparison of Event Hubs and other Azure messaging services, see [Choose between Azure messaging services](/azure/event-grid/compare-messaging-services).

This article describes Event Hubs features and isolation models to use in multitenant solutions.

## Isolation models

Determine the level of isolation that you want when you use Event Hubs in your multitenant system. Event Hubs supports different models of multitenancy.

- **Trusted multitenancy:** All tenants share an Event Hubs namespace. Use this option if all tenants reside in your organization.

- **Hostile multitenancy:** Each tenant has its own namespace that isn't shared. Use this option to prevent [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) for your tenants.

A system can implement both models. Some tenants can share namespaces, while other tenants have a dedicated namespace. A tenant can also share a namespace with other tenants but have dedicated event hubs.

The following table summarizes the differences between the main tenancy isolation models for Event Hubs.

| Consideration | Dedicated namespace | Shared namespace and dedicated event hubs | Shared namespace and shared event hubs |
| --- | --- | --- | --- |
| **Data isolation** | High | Medium  | None |
| **Performance isolation** | Highest. Manage performance needs based on each tenant's requirements. | Medium. Can have noisy neighbor problems. | Low. Can have noisy neighbor problems. |
| **Deployment complexity** | Medium. Understand [Event Hubs quotas and limits](/azure/event-hubs/event-hubs-quotas) at the subscription level. | Medium. Deploy separate message entities for each tenant. Understand [Event Hubs quotas and limits](/azure/event-hubs/event-hubs-quotas). Some cases require multiple namespaces, depending on the number of tenants. | Low |
| **Operational complexity** | High. Manage namespaces separately for each tenant. | Medium. Some tenants require granular management of message entities. | Low |
| **Example scenario** | Separate application instances for each tenant. | Dedicated event hubs for each tenant. | Large multitenant solution that has a shared application tier and one or more shared event hubs. |

The following sections describe the models in more detail.

> [!NOTE]
> Event Hubs for Apache Kafka is a feature that adds a Kafka-compatible protocol layer to Event Hubs so that Apache Kafka applications can use Event Hubs. The applications stream events into event hubs, which function like Kafka topics. For more information, see [Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-kafka-overview).

### Dedicated namespace

This model provisions an [Event Hubs namespace](/azure/event-hubs/event-hubs-features#namespace) for each tenant. This approach provides the maximum level of isolation and the ability to provide acceptable performance for all tenants.

Use the following techniques to fine-tune eventing capabilities to satisfy tenant requirements:

- Deploy the namespace to a region that's close to the tenant.

- Deploy the namespace with a pricing tier that's appropriate for the tenant's requirements. For example, a [premium namespace](/azure/event-hubs/event-hubs-premium-overview) allows you to choose the number of [processing units](/azure/event-hubs/event-hubs-scalability#processing-units).

- Apply networking restrictions based on tenant needs by using [IP firewall rules](/azure/event-hubs/network-security#ip-firewall), [private endpoints](/azure/event-hubs/network-security#private-endpoints), and [virtual network service endpoints](/azure/event-hubs/network-security#network-service-endpoints).

- Use [tenant-specific encryption keys](/azure/event-hubs/configure-customer-managed-key).

- Configure [Event Hubs geo-replication](/azure/event-hubs/geo-replication) and [Event Hubs geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr) to meet tenant availability requirements.

If you reach the maximum number of Event Hubs namespaces in your Azure subscription, deploy namespaces across different subscriptions by using the [Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp).

This isolation model becomes more complex to manage as the number of tenants increases. It also increases costs because you pay for each namespace.

### Shared namespace and dedicated event hubs

If multiple tenants share a namespace, you can still isolate tenants to a dedicated event hub. To control access, use a Microsoft Entra identity or a shared access signature (SAS).

As your system adds more tenants, the number of event hubs increases to accommodate each tenant. This growth can lead to higher operational costs and lower organizational agility. Each namespace has a [limit](/azure/event-hubs/compare-tiers#quotas) on the number of event hubs. So the number of namespaces that your system requires depends on the number of event hubs that your tenants require.

Shared namespaces increase the risk of [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). For example, a tenant's event entities might consume a disproportionate amount of namespace resources and hinder other tenants. Event hub namespaces have limits on processing units in the premium tier, capacity units in the dedicated tier, and the number of brokered connections to a namespace. Consider whether a single tenant might consume too many resources.

### Shared namespace and shared event hubs

All your tenants can share a namespace and event entities. This model decreases operational complexity and resource costs.

But a shared namespace can lead to [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) and higher latency for some tenants. You also have to set up your applications to serve multiple tenants. Shared event hubs and Kafka topics don't provide data isolation between tenants, so you have to satisfy data isolation requirements in your application logic.

> [!NOTE]
> Don't use [Event Hubs partitions](/azure/event-hubs/event-hubs-features#partitions) to isolate your tenants. Partitioning in Event Hubs supports processing events and scalability, but it isn't an isolation model. You can send events directly to partitions, but it downgrades the availability of an event hub to the partition level. For more information, see [Availability and consistency in Event Hubs](/azure/event-hubs/event-hubs-availability-and-consistency).

## Features of Event Hubs that support multitenancy

The following features of Event Hubs support multitenancy:

- [Application groups](#application-groups)
- [Microsoft Entra authentication](#azure-ad-authentication)
- [SAS](#sas)
- [Customer-managed keys](#customer-managed-keys)
- [Event Hubs capture](#event-hubs-capture)
- [Geo-replication and geo-disaster recovery](#geo-replication-and-geo-disaster-recovery)
- [IP firewall rules](#ip-firewall-rules)

The following sections describe these features.

### Application groups

An application group consists of one or more client applications that interact with the Event Hubs data plane. You can apply quota and access management policies to the group, which applies them to all applications in the group.

You can scope each application group to a single Event Hubs namespace or a single event hub. The application group should use a unique identifying condition for the client applications, such as a security context like a Microsoft Entra application ID or a SAS.

For more information, see [Resource governance with application groups](/azure/event-hubs/resource-governance-overview).

### Event Hubs Premium namespaces

Event Hubs Premium namespaces provide reserved processing units that aren't shared with other namespaces. They ensure predictable latency and throughput for each namespace and prevent noisy neighbor problems. Premium namespaces provide the highest level of performance isolation without requiring a dedicated cluster.

Premium namespaces suit hostile multitenancy scenarios, where tenants operate independently and might have unpredictable workloads. Each tenant can use the full capacity of their Premium namespace without affecting other tenants. This tier costs more than the Standard tier.

Premium features include reserved processing units, customer-managed keys, virtual network integration, and enhanced message retention.

For more information, see [Overview of Event Hubs Premium](/azure/event-hubs/event-hubs-premium-overview).

<a name='azure-ad-authentication'></a>
### Microsoft Entra authentication

Event Hubs integrates with Microsoft Entra ID. To authenticate to Event Hubs resources, clients can use a managed identity with Microsoft Entra ID. Event Hubs defines a set of built-in roles that you can grant to your tenants to access Event Hubs entities. For example, you can use Microsoft Entra authentication to grant a tenant access to an event hub that contains messages for that tenant. This technique isolates one tenant from another.

Kafka applications can use [managed identity OAuth](/azure/event-hubs/authenticate-managed-identity#event-hubs-for-kafka) to access Event Hubs resources.

For more information, see the following articles:

- [Authenticate a managed identity by using Microsoft Entra ID to access Event Hubs resources](/azure/event-hubs/authenticate-managed-identity)
- [Authenticate an application by using Microsoft Entra ID to access Event Hubs resources](/azure/event-hubs/authenticate-application)

### SAS

Use a SAS to grant a tenant access to Event Hubs resources while granting specific rights. If you isolate your tenants at an entity level, you can grant SAS keys on an event hub or Kafka topic that applies only to a particular tenant.

For more information, see [Authenticate access to Event Hubs resources by using a SAS](/azure/event-hubs/authenticate-shared-access-signature).

### Customer-managed keys

If your tenants require their own keys to encrypt and decrypt events, you can configure customer-managed keys in some versions of Event Hubs.

This feature requires that you use either an [Event Hubs Premium tier namespace](/azure/event-hubs/event-hubs-premium-overview) or [Event Hubs Dedicated tier namespace](/azure/event-hubs/event-hubs-dedicated-overview). You can enable encryption only for new or empty namespaces.

For more information, see [Configure customer-managed keys to encrypt Event Hubs data at rest](/azure/event-hubs/configure-customer-managed-key).

### Event Hubs capture

You can use the Event Hubs capture feature to automatically capture streaming data from Event Hubs and store it to an Azure Blob Storage or Azure Data Lake Storage account.

You can use this capability to archive events. For example, if you need to archive events for a tenant because of compliance reasons, you can deploy tenant-specific namespaces and enable Event Hubs capture to archive events in tenant-specific Azure Storage accounts. You can also enable Event Hubs capture on tenant-specific event hubs in a shared namespace.

For more information, see [Capture events through Event Hubs in Blob Storage or Data Lake Storage](/azure/event-hubs/event-hubs-capture-overview).

### Geo-replication and geo-disaster recovery

[Event Hubs Geo-replication](/azure/event-hubs/geo-replication) continuously replicates the configuration and data of an Event Hubs namespace from a primary namespace to a paired secondary namespace. This feature improves recovery capabilities from disasters, such as regional failures. For example, if you isolate your tenants at the namespace level, you can replicate the configuration of a tenant namespace to a secondary region. This setup provides protection against outages and failures in the primary region. However, it requires that your namespaces use specific tiers.

Event Hubs also has a separate feature called [Geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr), which replicates just the configuration of a namespace. This capability helps to maintain operational continuity. It doesn't replicate the event data or any Microsoft Entra role-based access control assignments that you use for your primary namespace. If you need to, you can configure your own replication by using [Multisite and multiregion federation](/azure/event-hubs/event-hubs-federation-overview).

### IP firewall rules

You can use IP firewall rules to control access to namespaces. When you isolate tenants at the namespace level, you can configure the namespaces to accept connections only from clients that originate from allowed IP addresses or address ranges.

For more information, see the following articles:

- [Network security for Event Hubs](/azure/event-hubs/network-security)
- [Allow access to Event Hubs namespaces from specific IP addresses or ranges](/azure/event-hubs/event-hubs-ip-filtering)

### Auto-inflate for elastic scaling

Standard Event Hubs namespaces support the auto-inflate feature, which automatically increases the number of throughput units during periods of high demand.

When you enable auto-inflate on shared namespaces, the platform can temporarily scale capacity up to a defined maximum when one or more tenants experience traffic spikes. This elasticity helps prevent throttling and service errors during sudden load surges, which maintains stability for all tenants.

Auto-inflate is especially useful in multitenant environments because it absorbs noisy neighbor bursts. It allocates extra resources instead of suppressing traffic. But this increase in capacity can also increase costs during the spike. For best results, combine auto-inflate with throttling policies to ensure that no single tenant can consume unbounded resources.

For more information, see [Auto-inflate Event Hubs throughput units](/azure/event-hubs/event-hubs-auto-inflate).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Will Velida](https://www.linkedin.com/in/willvelida/) | Customer Engineer 2, FastTrack for Azure

Other contributors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Customer Engineer, FastTrack for Azure
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Solution Architect, Data & AI
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Event Hubs: A big data streaming platform and event ingestion service](/azure/event-hubs/event-hubs-about)
- [Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-kafka-overview)
- [Capture events through Event Hubs in Blob Storage or Data Lake Storage](/azure/event-hubs/event-hubs-capture-overview)
- [Overview of the Event Hubs Premium tier](/azure/event-hubs/event-hubs-premium-overview)
- [Overview of the Event Hubs Dedicated tier](/azure/event-hubs/event-hubs-dedicated-overview)
- [Event Hubs documentation](/azure/event-hubs)
- [Training: Enable reliable messaging for big data applications by using Event Hubs](/training/modules/enable-reliable-messaging-for-big-data-apps-using-event-hubs)

## Related resources

- [Event-driven architecture style](../../../guide/architecture-styles/event-driven.md)
- [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md)
- [Integrate Event Hubs with serverless functions on Azure](../../../serverless/event-hubs-functions/event-hubs-functions.yml)
- [Monitor Azure Functions and Event Hubs](../../../serverless/event-hubs-functions/observability.yml)
- [Performance and scale for Event Hubs and Azure Functions](../../../serverless/event-hubs-functions/performance-scale.yml)
