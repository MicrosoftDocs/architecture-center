---
title: Multitenancy and Azure Event Hubs
titleSuffix: Azure Architecture Center
description: Learn about the Azure Event Hubs features and isolation models that you can use to implement an event-driven architecture for a multitenant system.
author: willvelida
ms.author: willvelida
ms.date: 02/20/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-event-hubs
categories:
 - analytics
---

# Multitenancy and Azure Event Hubs

[Event Hubs](/azure/event-hubs/event-hubs-about) is a big data streaming platform and event ingestion service that can receive and process millions of events per second. You can transform and store event hub data by using real-time analytics providers and batching/storage adapters. For a comparison of Event Hubs and other Azure messaging services, see [Choose between Azure messaging services - Event Grid, Event Hubs, and Service Bus](/azure/event-grid/compare-messaging-services).

This article describes Event Hubs features and isolation models that you can use in multitenant solutions.

## Isolation models

When you use Event Hubs in your multitenant system, you need to decide the level of isolation that you want. Event Hubs supports different models of multitenancy.

- **Trusted multitenancy:** All tenants share an Event Hubs namespace. This choice can be appropriate when all the tenants are in your organization.
- **Hostile multitenancy:** Each tenant has its own namespace that isn't shared. This choice can be appropriate when you want to ensure that your tenants don't have [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) problems.

A system can implement both models: some tenants share namespaces, others have a dedicated one. Also, a tenant can share a namespace with other tenants but have dedicated event hubs.

The following table summarizes the differences between the main tenancy isolation models for Event Hubs. The models are described in more detail in the sections that follow.

| **Consideration** | **Dedicated namespace** |**Shared namespace, dedicated event hubs** | **Shared namespace and event hubs** |
| --- | --- | --- | --- |
| **Data isolation** | High | Medium  | None |
| **Performance isolation** | Highest. Manage performance needs based on each tenant's requirements.  | Medium. Can have noisy neighbor issues. | Low. Can have noisy neighbor issues. |
| **Deployment complexity** | Medium. Be aware of [Event Hubs quotas and limits](/azure/event-hubs/event-hubs-quotas) at the subscription level. | Medium. Separate message entities must be deployed for each tenant. Be aware of [Event Hubs quotas and limits](/azure/event-hubs/event-hubs-quotas). Some cases require multiple namespaces, depending on the number of tenants. | Low |
| **Operational complexity** | High. Need to manage namespaces on a per-tenant basis. | Medium. Some tenants require granular management of message entities. | Low |
| **Example scenario** | Separate application instances per tenant. | Dedicated event hubs for each tenant. | Large multitenant solution with a shared application tier and one or more shared event hubs. |

> [!NOTE]
> Event Hubs for Apache Kafka is a feature that provides a protocol head on top of Event Hubs so that Event Hubs can be used by Apache Kafka applications. The applications stream events into event hubs, which are equivalent to Kafka topics. For more information, see [What is Azure Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-kafka-overview).

### Dedicated namespace

In this model, you provision an [Event Hubs namespace](/azure/event-hubs/event-hubs-features#namespace) for each tenant. This approach provides the maximum level of isolation and the ability to provide acceptable performance for all tenants.

You can use the following techniques to fine-tune eventing capabilities to satisfy tenant requirements:

- Deploy the namespace to a region that's close to the tenant.
- Deploy the namespace with a pricing tier that's appropriate to the tenant. For example, if you use a [premium namespace](/azure/event-hubs/event-hubs-premium-overview) you can choose the number of [processing units](/azure/event-hubs/event-hubs-scalability#processing-units).
- Apply networking restrictions that are based on tenant needs by using [IP firewall rules](/azure/event-hubs/network-security#ip-firewall), [private endpoints](/azure/event-hubs/network-security#private-endpoints), and [virtual network service endpoints](/azure/event-hubs/network-security#network-service-endpoints).
- Use [tenant-specific encryption keys](/azure/event-hubs/configure-customer-managed-key).
- Configure [Event Hubs Geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr) and [availability zones](/azure/event-hubs/event-hubs-geo-dr?tabs=portal#availability-zones) to meet tenant availability requirements.

If you reach the maximum number of Event Hubs namespaces in your Azure subscription, you can deploy namespaces across different subscriptions by using the [Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp).

The disadvantage of this isolation model is that, as the number of tenants grows over time, managing the namespaces gets more complex. Another disadvantage is that the model increases costs, because you pay for each namespace.

### Shared namespace, dedicated event hubs

Even if a namespace is shared by multiple tenants, you can isolate tenants to a dedicated event hub. You can use shared access signatures or Azure Active Directory (Azure AD) identities to control access.

As the number of tenants grows within your system, the number of event hubs also increases to accommodate each tenant. This growth can lead to higher operational costs and lower organizational agility. There's a [limit](/azure/event-hubs/compare-tiers#quotas) on the number of event hubs per namespace. Thus the number of namespaces that your system requires depends on the number of event hubs that your tenants require.

When a namespace is shared, [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) problems are more likely. For example, it's possible that the event entities of a tenant could consume a disproportionate amount of the namespace resources and hinder other tenants. Event hub namespaces have limits on their processing units (premium tier) or capacity units (dedicated tier) and on the number of brokered connections to a namespace. Consider whether a single tenant might consume too many resources.

### Shared namespace and event hubs

You can have a namespace and event entities that are shared by all your tenants. This model decreases operational complexity and lowers resource costs.

However, having a shared namespace can lead to the [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) problem and result in higher latency for some tenants. You also have to implement your applications to serve multiple tenants. Shared event hubs and Kafka topics don't provide data isolation between tenants, so you have to satisfy data isolation requirements in your application logic.

> [!NOTE]
> Don't use [Event Hubs partitions](/azure/event-hubs/event-hubs-features#partitions) to try to isolate your tenants. Partitioning in Event Hubs enables the processing of events and scalability, but it isn't an isolation model. You can send events directly to partitions, but doing so isn't recommended because it downgrades the availability of an event hub to partition level. For more information, see [Availability and consistency in Event Hubs](/azure/event-hubs/event-hubs-availability-and-consistency).

## Features of Event Hubs that support multitenancy

The following features of Event Hubs support multitenancy:

- [Application groups](#application-groups)
- [Azure AD authentication](#azure-ad-authentication)
- [Shared access signature](#shared-access-signature)
- [Customer-managed keys](#customer-managed-keys)
- [Event Hubs Capture](#event-hubs-capture)
- [Geo-disaster recovery](#geo-disaster-recovery)
- [IP firewall rules](#ip-firewall-rules)

These features are discussed in the following sections.

### Application groups

An application group is a collection of one or more client applications that interact with the Event Hubs data plane. You can apply quota and access management policies to all the applications in the group by applying them to the group itself.

Each application group can be scoped to a single Event Hubs namespace or to a single event hub. It should use a uniquely identifying condition identifier of the client applications, such as the security context, which is either a shared access signature (SAS) or an Azure AD application ID.

For more information, see [Resource governance with application groups](/azure/event-hubs/resource-governance-overview).

### Azure AD authentication

Event Hubs is integrated with Azure AD. Clients can authenticate to Event Hubs resources by using a managed identity with Azure AD. Event Hubs defines a set of built-in roles that you can grant to your tenants to access Event Hubs entities. For example, by using Azure AD authentication, you can grant a tenant access to an event hub that has the messages for that tenant. You can use this technique to isolate a tenant from other tenants.

Kafka applications can use [managed identity OAuth](/azure/event-hubs/authenticate-managed-identity#event-hubs-for-kafka) to access Event Hubs resources.


For more information, see the following articles:

- [Authenticate a managed identity with Azure Active Directory to access Event Hubs resources](/azure/event-hubs/authenticate-managed-identity?tabs=latest)
- [Authenticate an application with Azure Active Directory to access Event Hubs resources](/azure/event-hubs/authenticate-application)

### Shared access signature

Shared access signatures (SAS) give you the ability to grant a tenant access to Event Hubs resources with specific rights. If you isolate your tenants at an event entity level, you can grant SAS keys on an event hub or Kafka topic that  applies only to a particular tenant.

For more information, see [Authenticate access to Event Hubs resources using shared access signatures (SAS)](/azure/event-hubs/authenticate-shared-access-signature)

### Customer-managed keys

If your tenants require their own keys to encrypt and decrypt events, you can configure customer-managed keys in some versions of Event Hubs.

This feature requires that you use the [dedicated namespace](#dedicated-namespace) isolation model. Encryption can only be enabled for new or empty namespaces.

For more information, see [Configure customer-managed keys for encrypting Azure Event Hubs data at rest](/azure/event-hubs/configure-customer-managed-key).

### Event Hubs Capture

You can use the Event Hubs Capture feature to automatically capture streaming data from Event Hubs and store it to an Azure Blob Storage or Data Lake Storage account.

This capability is useful for archiving events. For example, if you're required to archive events for a tenant for compliance reasons, you can deploy tenant-specific namespaces and enable Event Hubs Capture to archive events to tenant-specific Azure Storage Accounts. You can also enable Event Hubs Capture on tenant-specific event hubs in a shared namespace.

For more information, see [Capture events through Azure Event Hubs in Azure Blob Storage or Azure Data Lake Storage](/azure/event-hubs/event-hubs-capture-overview)

### Geo-disaster recovery

Geo-disaster recovery continuously replicates the entire configuration of an Event Hubs namespace from a primary namespace to a secondary namespace that's paired with the primary. This feature can help to recover from disasters, such as regional failures.

For example, if you isolate your tenants at the namespace level, you can replicate the configuration of a tenant namespace to a secondary region to provide protection against outages and failure of the primary.

For more information, see [Azure Event Hubs - Geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr).

> [!NOTE]
> To help protect continuity of operations, Geo-disaster recovery replicates the configuration of the primary namespace to the secondary namespace. It doesn't replicate the event data, nor does it replicate any Azure AD RBAC assignments that you use for your primary namespace. For more information, see [Multi-site and multi-region federation](/azure/event-hubs/event-hubs-federation-overview).

### IP firewall rules

You can use IP firewall rules to control access to namespaces. When you isolate tenants at the namespace level, you can configure the namespaces to accept connections only from clients that originate from allowed IP addresses or address ranges.

For more information, see:

- [Network security for Azure Event Hubs](/azure/event-hubs/network-security)
- [Allow access to Azure Event Hubs namespaces from specific IP addresses or ranges](/azure/event-hubs/event-hubs-ip-filtering)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- Will Velida | Customer Engineer 2, FastTrack for Azure

Other contributors:

- John Downs | Principal Customer Engineer, FastTrack for Azure
- Paolo Salvatori | Principal Customer Engineer, FastTrack for Azure
- Arsen Vladimirskiy | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Event Hubs — A big data streaming platform and event ingestion service](/azure/event-hubs/event-hubs-about)
- [What is Azure Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-kafka-overview)
- [Capture events through Azure Event Hubs in Azure Blob Storage or Azure Data Lake Storage](/azure/event-hubs/event-hubs-capture-overview)
- [Overview of Event Hubs Premium](/azure/event-hubs/event-hubs-premium-overview)
- [Overview of Azure Event Hubs Dedicated tier](/azure/event-hubs/event-hubs-dedicated-overview)
- [Event Hubs documentation](/azure/event-hubs)
- [Learn: Enable reliable messaging for Big Data applications using Azure Event Hubs](/training/modules/enable-reliable-messaging-for-big-data-apps-using-event-hubs)

## Related resources

- [Event-driven architecture style](../../../guide/architecture-styles/event-driven.yml)
- [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md)
- [Messaging patterns](../../../patterns/category/messaging.md)
- [Serverless event processing](../../../reference-architectures/serverless/event-processing.yml)
- [Integrate Event Hubs with serverless functions on Azure](../../../serverless/event-hubs-functions/event-hubs-functions.yml)
- [Monitor Azure Functions and Event Hubs](../../../serverless/event-hubs-functions/observability.yml)
- [Performance and scale for Event Hubs and Azure Functions](../../../serverless/event-hubs-functions/performance-scale.yml)
- [Partitioning in Azure Event Hubs and Kafka](../../../reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka.yml)
