---
title: Architectural approaches for tenant integration and data access
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider for integrations in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 07/12/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-api-management
  - azure-logic-apps
categories:
  - integration
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Architectural approaches for tenant integration and data access

It's common for systems to integrate together, even across organizational boundaries. When you build a multitenant solution, you might have requirements to send data back to your tenants' systems, or to receive data from those systems. In this article, we outline the key considerations when you work with integrations for a multitenant solution solution.

> [!NOTE]
> If you provide multiple integration points, it's best to consider each one independently. Often, different integration points have different requirements and are designed differently, even if they're connecting the same systems together in multiple different ways.

## Key considerations and requirements

### Direction of data flow

It's important to clearly understand the direction in which your data flows, because this affects several aspects of your architecture including how you manage identity and your solution's networking topology. There are two common data flows:

- **Export**, which means the data flows from your multitenant system to your individual tenants' systems.
- **Import**, which means data comes from your tenants' systems into your multitenant system.

It's also important to consider the networking data flow, which doesn't necessarily correspond to the logical data flow direction. For example, you might initiate an outbound connection to a tenant so that you can import the data from the tenant's system.

### Full and user-delegated access

In many systems, access to data is restricted to specific users. The data that one user has access to might not be the same as the data that another user has access to. It's important to consider whether you expect to work with complete data sets, or if the data sets you import or export are based on what a specific user has permission to access.

For example, imagine that you're the vendor of a SaaS accounting system. Your tenants are the customers who use your solution, and each tenant has many users. Most of the users who access the system can only work with data that relates to their own business unit. A tenant asks you to export the data from your solution into their own on-premises systems for offline analysis. It's important to decide which approach you follow, such as the following approaches:

- Export all of the data from your system to your tenant's system. If user permissions aren't set up in the destination data store, users might get access to data they shouldn't be allowed to see.
- Export only a subset of the data, depending on the access level of the user who initiated the request. If your tenant expects a complete copy of the data from your system, this approach won't give them what they're looking for.

Both approaches have valid use cases, so it's important to clearly understand your tenants' requirements.

If you work with full data sets, you effectively treat the other system as a *trusted subsystem*. You also should consider using a *workload identity* instead of a user identity for this integration. A workload identity is a system identity that doesn't correspond to a single user. The workload identity would be granted a high level of permission to the data.

Alternatively, if you work with user-scoped data, then you might need to use an approach like *delegation* to access the correct subset of data from the data set. Then, the destination system effectively gets the same permission that the user has.

For more information on user delegation, see the [Delegated user access](#delegated-user-access) approach below.

### Realtime or batch

Consider whether you'll be working with realtime data, or if the data will be sent in batches.

For realtime integrations, these approaches are common:

- Synchronous connections, which are often enabled through APIs or webhooks.
- Asynchronous connections, which are often enabled through messaging components designed for loosely coupling systems together. For example, Azure Service Bus provides message queuing capabilities, and Azure Event Grid and Event Hubs provide eventing capabilities. These components are often used as part of integration architectures.

In contrast, batch integrations are often managed through a background job, which might be triggered at certain times of the day. Commonly, batch integrations take place by reading from or writing to a *staging location*, such as a blob storage container, because the datasets exchanged can be large.

### Data volume

It's important to understand the volume of data that you exchange through an integration, because this information helps you to plan for your overall system capacity. When you plan your system's capacity, remember that different tenants might have different volumes of data to exchange.

For realtime integrations, you might measure volume as the number of transactions over a specified period of time. For batch integrations, you might measure volume either as the number of records exchanged or the amount of data in bytes.

### Data formats

When data is exchanged between two parties, it's important they both have a clear understanding of the format of the data. This includes both the file format, such as JSON or XML, as well as the schema, such as the list of fields that will be included, date formats, and nullability of fields.

When you work with a multitenant system, if possible then it's best to use the same data format for all of your tenants. That way, you avoid having to customize and re-test your integration components for each tenant's requirements.

However, in some situations, you might need to use different data formats for communicating with different tenants, and so you might need to implement multiple integrations. See [Composable integration components](#composable-integration-components) for an approach that can help to simplify this kind of situation.

### Access to tenants' systems

Some integrations involve you making a connection to a tenant's systems or data stores. When you do this, you need to carefully consider how you connect to tenants' systems, both at a networking layer and from an identity perspective.

#### Network access

Consider the network topology for accessing your tenant's system, which might include the following:

- **Connect across the internet.** If you connect across the internet, how will the connection be secured? If your tenants plan to restrict based on your IP addresses, ensure that the Azure services that you use support static IP addresses for outbound connections. Consider using [NAT Gateway](../service/nat-gateway.md) to provide static IP addresses if required.
- **Private endpoints** can be a useful approach to connect to tenants' systems if they're also hosted in Azure.
- **Agents**, which are [deployed into a tenant's enironment](../approaches/networking.md#agents), can provide a flexible approach and avoid the need for your tenants to allow inbound connections.
- **Relays**, such as [Azure Relay](/azure/azure-relay/relay-what-is-it), also provide an approach to avoid inbound connections.

#### Authentication

Consider how you authenticate with each tenant when you initiate a connection. You might consider the following approaches:

- **Keys**, such as API keys, certificates, or other secrets. It's important to plan how you will securely manage your tenants' credentials. Leakage of your tenants' secrets could result in a major security incident, potentially impacting a number of your tenants.
- **Azure Active Directory (Azure AD) tokens**, where you use a token issued by the tenant's own Azure AD instance. The token might be issued to your workload by using a multitenant Azure AD application, or it might be issued to a specific user identity within the tenant's directory.

Whichever approach you select, ensure that your tenants follow the principle of least privilege and avoid granting your system unnecessary permissions. For example, if your system only needs to read data from a tenant's data store, the identity you use to connect shouldn't have write permissions.

### Tenants' access to your systems

If tenants need to connect to your system, consider providing dedicated APIs or other integration points, which you can then model as part of the surface area of your solution.

In some situations, you might decide to provide your tenants with direct access to you Azure resources. Consider the ramifications carefully and ensure you understand how to grant access to tenants in a safe manner. For example, you might use one of the following approaches:

- Use the [Valet Key pattern](#valet-key-pattern), which involves using security measures like shared access signatures to grant restricted access to certain Azure resources.
- Use dedicated resources for integration points, such as a dedicated storage account. It's a good practice to keep integration resources separated from your core system resources. This approach helps you to minimize the *blast radius* of a security incident. It also ensure that, if a tenant accidentally initiates large numbers of connections to the resource and exhausts its capacity, the rest of your system will continue to run.

### Compliance

When you start to interact directly with your tenants' data, or transmit that data, it's critical that you have a clear understanding of your tenants' [governance and compliance requirements](../approaches/governance-compliance.md).

## Approaches and patterns to consider

### Expose APIs

Realtime integrations commonly involve exposing APIs to your tenants or other parties to use. APIs require special considerations, especially when used by external parties. These concerns include the following:

- Who is granted access to the API?
- How will you authenticate the API's users?
- Is there a limit to the number of requests that an API user can make over a period of time?
- How will you provide information about your APIs, and documentation for each API? For example, you might implement a developer portal.

It's a good practice to use an API gateway, such as [Azure API Management](/azure/api-management/api-management-key-concepts), to handle these concerns and many others. By using an API gateway, you have a single place to implement policies that your APIs follow and you simplify the implementation of your backend API systems.

### Valet Key pattern

Occasionally you might need to provide a tenant, or another third party, with direct access to Azure Storage, Azure Cosmos DB, or another supported data source. Consider following the [Valet Key pattern](../../../patterns/valet-key.yml) to securely share data and restrict access to the data store.

For example, you could use this approach when batch exporting a large data file. After you've generated the export file, you can save it to a blob container in Azure Storage, and then generate a time-bound, read-only shared access signature. This signature can be provided to the tenant along with the blob URL. The tenant can then download the file from Azure Storage until the signature's expiry.

Similarly, you can generate a shared access signature with permissions to write to a specific blob. When you provide this to a tenant, they can write their data to the blob. By using Event Grid integration for Azure Storage, your application can then be notified to process and import the data file.

### Webhooks

Webhooks enable you to send events to your tenants at a URL that they provide to you. When you have information to send, you initiate a connection to the tenant's webhook and include your data in the HTTP request payload.

[CloudEvents](https://cloudevents.io/) is a standardized data format for webhooks. If you choose to build your own webhook eventing system, consider following the CloudEvents standard to simplify your tenants' integration requirements. Alternatively, you can use a service like [Azure Event Grid](/azure/event-grid/overview) to provide webhook functionality. Event Grid works natively with CloudEvents, and supports [event domains](/azure/event-grid/event-domains), which are useful for multitenant solutions.

> [!NOTE]
> Whenever you make outbound connections to your tenants' systems, remember that you're connecting to an external system. Follow recommended cloud practices including using [retries](../../../patterns/retry.yml), the [Circuit Breaker pattern](../../../patterns/circuit-breaker.yml), and the [Bulkhead pattern](../../../patterns/bulkhead.yml) to ensure that problems in the tenant's system don't propagate to your system.

### Delegated user access

When you access data from a tenant's data stores, consider whether you need to use a specific user's identity to access the data. When you do, your integration is subject to the same permissions that the user has. This approach is often called [delegated access](#full-and-user-delegated-access).

For example, suppose your multitenant service runs machine learning models over your tenants' data. You need to access each tenant's data store from services like Azure Synapse Analytics, Azure Storage, Azure Cosmos DB, and others. Each tenant has their own Azure AD instance. Your solution can be granted delegated access to the data store so that you can retrieve the data that a specific user can access.

Delegated access is easier if the data store supports Azure AD authentication. [Many Azure services support Azure AD identities.](/azure/active-directory/managed-identities-azure-resources/services-azure-active-directory-support)

After a user establishes the initial connection, your system needs to securely store user tokens and refresh tokens so that you can continue to access the data store.

### Messaging

Messaging allows for asynchronous, loosely coupled communication between systems or components. Messaging is commonly used in integration scenarios to decouple the source and destination systems. For more information on messaging and multitenancy, see [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md).

When you use messaging as part of integrating with your tenants' systems, consider whether you should use [shared access signatures for Azure Service Bus](/azure/service-bus-messaging/service-bus-sas) or [Azure Event Hubs](/azure/event-hubs/authorize-access-shared-access-signature). Shared access signatures enable you to grant limited access to your messaging resources to third parties without enabling them to access the rest of your messaging subsystem.

In some scenarios, you might provide different service level agreements (SLAs) or quality of service (QoS) guarantees to different tenants. For example, a subset of your tenants might expect to have their data export requests processed more quickly than others. By using the [Priority Queue pattern](../../../patterns/priority-queue.yml), you can create separate queues for different levels of priority 
] with different worker instances to prioritize them accordingly.

### Composable integration components

* If you need to integrate with many tenants with different systems/formats, one approach is:
   * Build a set of core integration data sets and code, e.g. using Azure Functions or Azure Data Factory
   * Either:
      * Expose these to your customers, so they can build their own integration components on top of them (e.g. using Logic Apps or Azure Data Factory); or
      * Build Logic Apps or Data Factory pipelines for your customers
   * This might give you the ability to build reusable components, while also meeting different tenants' integration requirements - e.g. different formats or transports.
* Similarly when ingesting data from multiple tenants in different formats or from different transports, it's a good idea to standardise them. Consider using tenant-specific Logic Apps to normalise and ingest data into a standard format/location.
* You might provide more options or flexibility for tenants at a higher pricing tier, while requiring that tenants at a lower tier follow a standard approach.

## Antipatterns to avoid

- **Exposing your primary data stores directly to tenants.** For example, don't provide credentials to your data stores to your customers, and don't replicate from your MySQL main database to customers' read replicas. Create dedicated *integration data stores*, and use the Valet Key pattern to expose the data.
- **Exposing APIs without API Management.**
- **Tight coupling.** Integrations to third parties should be loosely coupled where possible, for security, performance isolation, etc.
- **Custom code for each tenant.** Try to build up standardised approaches for integration and reuse them across tenants. If you have to customise, then keep as much shared logic as possible.

## Next steps

Links to other relevant pages within our section.
