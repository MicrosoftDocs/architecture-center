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

- If you provide multiple integration points, it's best to consider each one independently. Often, different integration points have different requirements and are designed differently, even if they're connecting the same systems together in multiple different ways.

## Key considerations and requirements

### Direction of access

- Do you need to export (send data from your system to your tenants' systems), or import (take data from your tenants' systems and ingest it into yours)?
- The direction of access affects a number of concerns including identity and your networking topology.

### Full and user-delegated access

- Consider the scope of the data you'll be working with. Will you need to export/import complete data sets or will it be scoped to what an individual user has access to?
- For example, suppose you're the vendor of a SaaS accounting system, and each tenant might have many users. When you export the data you store on behalf of the tenant, do you provide the full data set, or do you provide a subset depending on the access level of the user who initiated the request? Both are valid and have different use cases.
- If you work with a full data set:
  - This uses a workload identity, rather than a user identity.
  - You treat the source/destination as a trusted subsystem - i.e. they have full access to everything in the data set, so there's a high level of trust involved.
- If you use user-delegated permissions:
  - Uses a user's permissions from the native data set. So, the destination essentially get the same permission that the user gets in the native dataset.
- See user-delegated section in approaches below TODO

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

* https://docs.microsoft.com/azure/architecture/patterns/valet-key
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
* Consider if you have different SLAs or QoS guarantees/expectations for different tenants, for both import and export. By using the [Priority Queue pattern](https://docs.microsoft.com/azure/architecture/patterns/priority-queue), you can create separate queues with different worker instances to prioritize them accordingly.

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
