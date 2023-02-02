---
title: Azure Event Hubs considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Event Hubs that are useful when you use it in multitenanted systems, and it provides links to guidance for how to use Azure Event Hubs in a multitenant solution.
author: willvelida
ms.author: willvelida
ms.date: 12/4/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-event-hubs
categories:
 - analytics
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Event Hubs

[Azure Event Hubs](/azure/event-hubs/event-hubs-about) is a big data streaming platform and event ingestion service that can receive and process millions of events per second. Data sent to an event hub can be transformed and stored by using real-time analytics providers and batching/storage adapters. For a comparison between Azure Event Hubs and the other messaging in the Azure platform, see [Choose between Azure messaging services - Event Grid, Event Hubs, and Service Bus](/azure/event-grid/compare-messaging-services). 

In this article, we describe some of the features that are useful for multitenant solutions, and the isolation models you can adopt when implementing Event Hubs in multitenant solutions. 

## Isolation models

When working with a multitenant system that uses Event Hubs, you need to make a decision about the level of isolation that you want to adopt. Event Hubs supports different models of multitenancy:

- You can implement *trusted multitenancy* by using a shared namespace. For example, this model might be appropriate when all your tenants are within your organization.
- You can implement *hostile multitenancy* by deploying separate namespaces for each tenant. For example, this model might be appropriate when you want to ensure that your tenants don't suffer from [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) problems.

The following table summarizes the differences between the main tenancy isolation models for Event Hubs. The models are described later in this article.

| **Consideration** | **Namespace per tenant** | **Shared namespace, separate event hubs per tenant** | **Shared namespace, event hubs between tenants** |
| --- | --- | --- | --- |
| **Data isolation** | High | Medium  | None |
| **Performance isolation** | Highest. Manage performance needs based on each tenant's requirements  | Medium. Potentially subject to noisy neighbor issues | Low. Potentially subject to noisy neighbor issues |
| **Deployment complexity** | Medium. [Be aware of Azure Event Hubs quotas and limits](/azure/event-hubs/event-hubs-quotas) at the subscription level | Medium. Message entities must be deployment on a per-tenant basis. Be aware for [Azure Event Hubs quotas and limits](/azure/event-hubs/event-hubs-quotas). You may still need multiple namespaces, depending on the number of tenants. | Low |
| **Operational complexity** | High. Need to manage namespaces on a per-tenant basis | Medium. Granular management of message entities may be required depending on tenant | Low |
| **Example scenario** | Individual application instances per tenant | Dedicated event hubs for each tenant | Large multitenant solution with a shared application tier and one or more shared event hubs. |

> [!NOTE]
> Event Hubs for Apache Kafka is a feature that provides a protocol head on top of Event Hubs.  It enables Azure Event Hubs to be compatible with Apache Kafka clients. These are equivalent to Apache Kafka *topics*, which are not to be confused with topics in Azure Service Bus. Read [Kafka and Event Hubs conceptual mapping](/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview) for more information.

### Dedicated namespace per tenant

Within your solution, you can provision a specific [Event Hubs namespace](/azure/event-hubs/event-hubs-features#namespace) for each tenant. This deployment approach provides your solution with the maximum level of isolation, with the ability to provide consistent performance per tenant.

You can also fine-tune eventing capabilities for each tenant based on their needs, by using the following approaches:

- Deploy the namespace to a region that's close to the tenant.
- Deploy a tenant-specific namespace with a pricing tier that's appropriate to that tenant. For example, you can provision [premium namespaces](/azure/event-hubs/event-hubs-premium-overview) with a different number of [processing units](/azure/event-hubs/event-hubs-scalability#processing-units).
- Apply networking restrictions based on the tenant's needs using [IP firewall rules](/azure/event-hubs/network-security#ip-firewall), [Private Endpoints](/azure/event-hubs/network-security#private-endpoints), and [Virtual Network Service Endpoints](/azure/event-hubs/network-security#network-service-endpoints).
- Use [tenant-specific encryption keys](/azure/event-hubs/configure-customer-managed-key).
- Configure [Event Hubs Geo-disaster](/azure/event-hubs/event-hubs-geo-dr) and [Availability Zones](/azure/event-hubs/event-hubs-geo-dr?tabs=portal#availability-zones) support based on tenant's needs.

The disadvantage to this isolation model is that, as the number of tenants grows within your system over time, the operational complexity of managing your namespaces increases. If you reach the maximum number of Event Hubs namespaces within your Azure subscription, you could deploy namespaces across different subscriptions using the [Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp). This approach also increases resource costs, since you pay for each namespace that you provision.


### Shared namespace, separate event hubs per tenant

You can isolate your tenants to a specific event hub that they'll listen to. You can authenticate and authorize access to each tenant's event entity with different shared access signatures, or Azure Active Directory (Azure AD) identity.

As the number of tenants grow within your system, the number of event hubs also increase to accommodate each tenant. This growth might lead to higher operational costs and lower organizational agility.

Because the namespace is shared across all your tenants, [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) problems are more likely with this approach. For example, it's possible that a single tenant's event entities could consume a disproportionate amount of the namespace resources and impact all the other tenants. Event Hub namespaces have limits around processing units (capacity units for Dedicated tier) and the number of brokered connections to a namespace. Consider whether a single tenant might consume more than their fair share of these resources.

There are also [limits](/azure/event-hubs/compare-tiers#quotas) on how many event hubs you can provision within a single namespace. Due to these limits, you may be required to provision multiple namespaces as the number of your tenants grow beyond the number of event hubs you can provision to a single namespace.

### Shared namespace, event hubs between tenants

Use the same namespace and event entities for all your tenants to decrease operational complexity and lower your resource costs.

However, having a single namespace that all your tenants share can also lead to the [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) problem, which might cause higher latency for some tenants. You'll also need to make your application code multitenancy-aware. When using a shared event hub or Kafka topic, there's no data isolation between tenants, so you'll need to implement data isolation requirements within your application logic.

> [!NOTE]
> Avoid isolating your tenants by [partitions](/azure/event-hubs/event-hubs-features#partitions). Partitioning in Event Hubs enables the processing of events and scalability, it is not an isolation model. You can send events directly to partitions, but it's not recommended since this approach downgrades the availability of an event hub to partition-level. For more information, see [Availability and consistency in Event Hubs](/azure/event-hubs/event-hubs-availability-and-consistency).

## Features of Azure Event Hubs that support multitenancy

### Application groups

An application group is a collection of one or more client applications that interact with the Event Hubs data plane. Application groups can be scoped to a single Event Hubs namespace or event hub, and use a unique identifier, such as the application ID of the client application.

If you have tenants that have multiple applications associated with them, you can use a unique identifier to authorize those applications to interact with a specific event hub within a namespace.

See [Resource governance with application groups](/azure/event-hubs/resource-governance-overview).

### Azure Active Directory authentication

Event Hubs is integrated with Azure Active Directory (Azure AD), which allows clients to authenticate a managed identity with Azure AD to Event Hub resources. Event Hubs defines a set of built-in roles that you can grant to your tenants to access Event Hub entities. For example, by using Azure AD authentication, you can grant tenant access to a specific event hub that contains their messages, which isolate it from other tenants within your application.

For Kafka applications, you can use [managed identity OAuth](/azure/event-hubs/authenticate-managed-identity#event-hubs-for-kafka) to authenticate clients to Event Hub resources.

For more information, see the following articles:

- [Authenticate a managed identity with Azure Active Directory to access Event Hubs Resources](/azure/event-hubs/authenticate-managed-identity?tabs=latest)
- [Authenticate an application with Azure Active Directory to access Event Hubs resources](/azure/event-hubs/authenticate-application)

### Shared access signature

Shared access signatures (SAS) give you the ability to grant a tenant access to Event Hubs resources with specific rights. If you chose to isolate your tenants at an event entity level, you can grant SAS keys on an event hub or Kafka topic that only applies to a particular tenant.

See [Authenticate access to Event Hubs resources using shared access signatures (SAS)](/azure/event-hubs/authenticate-shared-access-signature)

### Customer-managed keys

If your tenants need to use their own keys to encrypt and decrypt events, you can configure customer-managed keys in Event Hubs premium and dedicated namespaces. 

This feature requires that you adopt the [dedicated namespace-per-tenant](#dedicated-namespace-per-tenant) isolation model. Bear in mind that encryption can only be enabled for new or empty namespaces.

See [Configure customer-managed keys for encrypting Azure Event Hubs data at rest](/azure/event-hubs/configure-customer-managed-key).

### Event Hubs Capture

Event Hubs enables you to automatically capture the streaming data in Event Hubs in an Azure Blob Storage or Data Lake Storage Gen 1 or Gen 2 account.

If you're required to archive events for a specific tenant for compliance reasons, you can deploy tenant-specific namespaces and enable Event Hubs Capture to archive events to tenant-specific Azure Storage Accounts. You can also enable Event Hubs Capture on tenant specific event hubs within a shared namespace.

See [Capture events through Azure Event Hubs in Azure Blob Storage or Azure Data Lake Storage](/azure/event-hubs/event-hubs-capture-overview)

### Geo-disaster recovery

Geo-disaster recovery ensures that the entire configuration of an Event Hubs namespace is continuously replicated from a primary namespace to a secondary namespace when paired. This feature is designed to make it easier to recover from disasters, such as regional failures.

For example, if you're isolating your tenants at the namespace level, you can replicate the configuration of your tenant's namespaces to a secondary region in the event of a disaster.


See [Azure Event Hubs - Geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr)

> [!NOTE]
> Geo-disaster enables continuity of operations by replicating the same configuration of the primary namespace to the seconday namespace. **Geo-disaster does not replicate the event data**. If you're using Azure AD RBAC assignments for your primary namespace, these will also not be replicated to the secondary namespace. Please review [Multi-site and multi-region federation](/azure/event-hubs/event-hubs-federation-overview) for more information.

### IP firewall rules

You can restrict access to your tenant's Event Hub namespaces to only a set of IPv4 addresses or ranges using IP firewall rules.

When isolating tenants at the namespace level, you can configure those namespaces to only accept connections from clients originating from allowed IP addresses or ranges.

More information:
- [Network security for Azure Event Hubs](/azure/event-hubs/network-security)
- [Allow access to Azure Event Hubs namespaces from specific IP addresses or ranges](/azure/event-hubs/event-hubs-ip-filtering)

## Next steps

Review [architectural approaches for messaging in multitenant solutions](../approaches/messaging.md)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

* [Will Velida](http://linkedin.com/in/willvelida) | Customer Engineer 2, FastTrack for Azure

Other contributors:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
  * [Paolo Salvatori](http://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

