---
title: Architectural approaches for tenant integration and data access
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider for integrations in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 07/11/2022
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

If you work with full data sets, you effectively treat the other system as a [trusted subsystem](TODO), which requires a high level of trust. You also should consider using a *workload identity* instead of a user identity for this integration. A workload identity is a system identity that doesn't correspond to a single user. The workload identity would be granted a high level of permission to the data.

Alternatively, if you work with user-scoped data, then you might need to use an approach like *delegation* to access the correct subset of data from the data set. Then, the destination system effectively gets the same permission that the user has.

For more information on user delegation, see the [Delegated user access](#delegated-user-access) approach below.

### Realtime or batch

- Consider whether you'll be working with realtime data or if it will be batched up.
- Realtime data can be exchanged by using:
  - APIs or webhooks
  - Messaging components designed for loosely coupling systems together, like Azure Service Bus (for queues), or Event Grid or Event Hubs (for eventing).
- Batch data:
  - Is usually managed through a background job.
  - Interactions often involve a staging location such as object storage since batch datasets are usually larger

### Data volume

- Understand the data volume, because this can help you to plan for your overall system capacity.
- This applies to both realtime integrations (where you might measure volume as the number of transactions per unit of time) and to batch integrations (where you might measure volume as the number of records exchanged or in bytes).
- Different tenants might have different volumes of data.

### Data formats

- It's important to be clear on the data formats.
- If the format/schema is within your control, you can simplify things by using the same format for all tenants.
- But if you have different data formats to use when communicating with different tenants, you might need to implement multiple integrations. See [Composable integration components](#composable-integration-components) for an approach that can help.

### Access to tenants' systems

- If you are accessing tenants' data stores, do you have network access? Can you use private link, [agents](../approaches/networking.md#agents), reverse proxies, Azure Relay, etc?
- How will you authenticate? For example:
  - API key: Need to manage credentials securely if you connect to customer-owned resources.
  - Azure AD tokens: You can access a tenant's system by using tokens issued by their Azure AD instance. The token can be issued to your workload (by using a multitenant Azure AD app), or a tenant's user's identity.
- Ensure your tenants follow the principle of least privilege and avoid granting your system unnecessary permissions. For example, if you only need to read data, you shouldn't have write permissions.

### Tenants' access to your systems

- Think carefully before providing tenants with direct access to your Azure resources.
- There are approaches you can use to do it safely though, including:
   - Valet Key pattern with security measures like shared access signatures
   - Using features like a dedicated storage account, or SFTP
- If you do this, it's best to keep integration resources separated from your core system resources. Otherwise, imagine if a tenant accidentally hammers your storage account and it approaches the transaction limit - you want to limit the blast radius to just the integration components, not your whole solution.

### Compliance

- When you start to interact directly with your tenants' data, it's critical that you have a clear understanding of their [governance and compliance requirements](../approaches/governance-compliance.md).

## Approaches and patterns to consider

### Expose APIs

* Use API Management to front any APIs, especially for third parties
* Use subscriptions, rate limiting, auth policies to offload these responsibilities from your backends
* See APIM service-specific guidance (when it's ready)

### Valet Key pattern

* [Valet Key pattern](../../../patterns/valet-key.yml)
* If you need to share direct access to a data store, this is the way to do it.
* Don't use your primary Azure Storage account. Instead, create a dedicated account for this.
* Can be used for batch exports of data - e.g. you build up export data file (which could be quite large), save it to Azure Storage, and generate a time-bound read-only SAS. Provide this to your tenant to download.
* Similarly, can use this for import - generate a SAS that allows writes to a specific blob, let your tenant write data to it, and then Event Grid tells you when it's ready to process.

### Webhooks

* Enables you to send events to tenants at URLs they specify.
* Can use a service like Event Grid, or build your own eventing system. TODO link to section below about Event Grid and EG domains
* Consider using CloudEvents as a standard if you create events. Event Grid works natively with CloudEvents, but you can follow the same standard even if you use other approaches.

### Delegated user access

<!-- Make this section stand alone without the section earlier - might need to repeat a bit of the info above -->
* If you need to access data directly from a tenant's own data stores, consider whether you need to use a user's identity (and associated permissions).
  * Example scenario: You provide and run ML models on your tenants' data. You need to access their data in Synapse, Azure Storage, etc. Each tenant presumably has their own AAD tenant.
* When implementing user-delegated access, it makes it easier if the service supports AAD. Not all services do. [See here for complete list](/azure/active-directory/managed-identities-azure-resources/services-azure-active-directory-support)
* You probably need to store user tokens (and, importantly, refresh tokens) for each user that you need to impersonate.
* If you make outbound connections to your tenants, treat them as external systems and follow good practices around things like retries/circuit breakers, bulkheads, etc. Ensure if they have problems that they don't propagate to your system

### Messaging

* Loosely coupled
* Service Bus/Event Hubs shared access signatures
* Event Grid event domains
* See [messaging approaches](../approaches/messaging.md)
* Consider if you have different SLAs or QoS guarantees/expectations for different tenants, for both import and export. By using the [Priority Queue pattern](../../../patterns/priority-queue.yml), you can create separate queues with different worker instances to prioritize them accordingly.

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
