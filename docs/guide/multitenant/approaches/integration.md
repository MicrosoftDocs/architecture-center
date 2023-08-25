---
title: Architectural approaches for tenant integration and data access
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider for integrations in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 05/08/2023
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

It's common for systems to integrate together, even across organizational boundaries. When you build a multitenant solution, you might have requirements to send data back to your tenants' systems, or to receive data from those systems. In this article, we outline the key considerations and approaches for architecting and developing integrations for a multitenant solution.

> [!NOTE]
> If you provide multiple integration points, it's best to consider each one independently. Often, different integration points have different requirements and are designed differently, even if they're connecting the same systems together in multiple different ways.

## Key considerations and requirements

### Direction of data flow

It's important to understand the direction in which your data flows. The data flow direction affects several aspects of your architecture, such as how you manage identity and your solution's networking topology. There are two common data flows:

- **Export**, which means the data flows from your multitenant system to your individual tenants' systems.
- **Import**, which means data comes from your tenants' systems into your multitenant system.

It's also important to consider the networking data flow direction, which doesn't necessarily correspond to the logical data flow direction. For example, you might initiate an outbound connection to a tenant so that you can import the data from the tenant's system.

### Full or user-delegated access

In many systems, access to certain data is restricted to specific users. The data that one user can access might not be the same as the data that another user can access. It's important to consider whether you expect to work with complete data sets, or if the data sets you import or export are based on what a specific user has permission to access.

For example, consider Microsoft Power BI, which is a multitenant service that provides reporting and business intelligence on top of customer-owned data stores. When you configure Power BI, you configure *data sources* to pull data from databases, APIs, and other data stores. You can configure data stores in two different ways:

- **Import all the data from the underlying data store**. This approach requires that Power BI is provided with credentials for an identity that can access the complete data store. Then, Power BI administrators can separately configure permissions to the imported data after it's imported into Power BI. Power BI enforces the permissions.
- **Import a subset of data from the underlying data store, based on a user's permissions.** When a user creates the data source, they use their credentials and the associated permissions. The exact subset of data that Power BI imports depends on the access level of the user who created the data source.

Both approaches have valid use cases, so it's important to clearly understand your tenants' requirements.

If you work with full data sets, the source system effectively treats the destination system as a *trusted subsystem*. For this type of integration, you should also consider using a *workload identity* instead of a user identity. A workload identity is a system identity that doesn't correspond to a single user. The workload identity is granted a high level of permission to the data in the source system.

Alternatively, if you work with user-scoped data, then you might need to use an approach like *delegation* to access the correct subset of data from the data set. Then, the destination system effectively gets the same permission as a specific user. For more information on user delegation, see the [Delegated user access](#delegated-user-access) approach below. If you use delegation, consider how you'll handle scenarios where a user is deprovisioned or their permissions change.

### Real-time or batch

Consider whether you'll be working with real-time data, or if the data will be sent in batches.

For real-time integrations, these approaches are common:

- **Request/response** is where a client initiates a request to a server and receives a response. Typically, request/response integrations are implemented by using APIs or webhooks. Requests might be *synchronous*, where they wait for acknowledgment and a response. Alternatively, requests can be *asynchronous*, using something like the [Asynchronous request-reply pattern](../../../patterns/async-request-reply.yml) to wait for a response.
- **Loosely coupled communication** is often enabled through messaging components that are designed for loosely coupling systems together. For example, Azure Service Bus provides message queuing capabilities, and Azure Event Grid and Event Hubs provide eventing capabilities. These components are often used as part of integration architectures.

In contrast, batch integrations are often managed through a background job, which might be triggered at certain times of the day. Commonly, batch integrations take place through a *staging location*, such as a blob storage container, because the data sets exchanged can be large.

### Data volume

It's important to understand the volume of data that you exchange through an integration, because this information helps you to plan for your overall system capacity. When you plan your system's capacity, remember that different tenants might have different volumes of data to exchange.

For real-time integrations, you might measure volume as the number of transactions over a specified period of time. For batch integrations, you might measure volume either as the number of records exchanged or the amount of data in bytes.

### Data formats

When data is exchanged between two parties, it's important they both have a clear understanding of how the data will be formatted and structured. Consider the following parts of the data format:

- The file format, such as JSON, Parquet, CSV, or XML.
- The schema, such as the list of fields that will be included, date formats, and nullability of fields.

When you work with a multitenant system, if possible, it's best to standardize and use the same data format for all of your tenants. That way, you avoid having to customize and retest your integration components for each tenant's requirements. However, in some situations, you might need to use different data formats for communicating with different tenants, and so you might need to implement multiple integrations. See the section, [Composable integration components](#composable-integration-components), for an approach that can help to simplify this kind of situation.

### Access to tenants' systems

Some integrations require you to make a connection to your tenant's systems or data stores. When you connect to your tenant's systems, you need to carefully consider both the networking and identity components of the connection.

#### Network access

Consider the network topology for accessing your tenant's system, which might include the following options:

- **Connect across the internet.** If you connect across the internet, how will the connection be secured, and how will the data be encrypted? If your tenants plan to restrict based on your IP addresses, ensure that the Azure services that your solution uses can support static IP addresses for outbound connections. For example, consider using [NAT Gateway](../service/nat-gateway.md) to provide static IP addresses, if necessary.
- [**Agents**](../approaches/networking.md#agents), which are deployed into a tenant's environment, can provide a flexible approach and can help you avoid the need for your tenants to allow inbound connections.
- **Relays**, such as [Azure Relay](/azure/azure-relay/relay-what-is-it), also provide an approach to avoid inbound connections.

For more information, see the guidance on [networking approaches for multitenancy](networking.md#public-or-private-access).

#### Authentication

Consider how you authenticate with each tenant when you initiate a connection. Consider the following approaches:

- **Secrets**, such as API keys or certificates. It's important to plan how you'll securely manage your tenants' credentials. Leakage of your tenants' secrets could result in a major security incident, potentially impacting many tenants.
- **Azure Active Directory (Azure AD) tokens**, where you use a token issued by the tenant's own Azure AD instance. The token might be issued directly to your workload by using a multitenant Azure AD application registration or a specific service principal. Alternatively, your workload can request delegated permission to access resources on behalf of a specific user within the tenant's directory.

Whichever approach you select, ensure that your tenants follow the principle of least privilege and avoid granting your system unnecessary permissions. For example, if your system only needs to read data from a tenant's data store, then the identity that your system uses shouldn't have write permissions.

### Tenants' access to your systems

If tenants need to connect to your system, consider providing dedicated APIs or other integration points, which you can then model as part of the surface area of your solution.

In some situations, you might decide to provide your tenants with direct access to your Azure resources. Consider the ramifications carefully and ensure you understand how to grant access to tenants in a safe manner. For example, you might use one of the following approaches:

- Use the [Valet Key pattern](#valet-key-pattern), which involves using security measures like shared access signatures to grant restricted access to certain Azure resources.
- Use dedicated resources for integration points, such as a dedicated storage account. It's a good practice to keep integration resources separated from your core system resources. This approach helps you to minimize the *blast radius* of a security incident. It also ensures that, if a tenant accidentally initiates large numbers of connections to the resource and exhausts its capacity, then the rest of your system continues to run.

### Compliance

When you start to interact directly with your tenants' data, or transmit that data, it's critical that you have a clear understanding of your tenants' [governance and compliance requirements](../approaches/governance-compliance.md).

## Approaches and patterns to consider

### Expose APIs

Real-time integrations commonly involve exposing APIs to your tenants or other parties to use. APIs require special considerations, especially when used by external parties. Consider the following questions:

- Who is granted access to the API?
- How will you authenticate the API's users?
- Is there a limit to the number of requests that an API user can make over a period of time?
- How will you provide information about your APIs and documentation for each API? For example, do you need to implement a developer portal?

A good practice is to use an API gateway, such as [Azure API Management](/azure/api-management/api-management-key-concepts), to handle these concerns and many others. API gateways give you a single place to implement policies that your APIs follow, and they simplify the implementation of your backend API systems.

### Valet Key pattern

Occasionally, a tenant might need direct access to a data source, such as Azure Storage. Consider following the [Valet Key pattern](../../../patterns/valet-key.yml) to share data securely and to restrict access to the data store.

For example, you could use this approach when batch exporting a large data file. After you've generated the export file, you can save it to a blob container in Azure Storage, and then generate a time-bound, read-only shared access signature. This signature can be provided to the tenant, along with the blob URL. The tenant can then download the file from Azure Storage until the signature's expiry.

Similarly, you can generate a shared access signature with permissions to write to a specific blob. When you provide a shared access signature to a tenant, they can write their data to the blob. By using Event Grid integration for Azure Storage, your application can then be notified to process and import the data file.

### Webhooks

Webhooks enable you to send events to your tenants at a URL that they provide to you. When you have information to send, you initiate a connection to the tenant's webhook and include your data in the HTTP request payload.

If you choose to build your own webhook eventing system, consider following the [CloudEvents](https://cloudevents.io/) standard to simplify your tenants' integration requirements.

Alternatively, you can use a service like [Azure Event Grid](/azure/event-grid/overview) to provide webhook functionality. Event Grid works natively with CloudEvents, and supports [event domains](/azure/event-grid/event-domains), which are useful for multitenant solutions.

> [!NOTE]
> Whenever you make outbound connections to your tenants' systems, remember that you're connecting to an external system. Follow recommended cloud practices, including using the [Retry pattern](../../../patterns/retry.yml), the [Circuit Breaker pattern](../../../patterns/circuit-breaker.yml), and the [Bulkhead pattern](../../../patterns/bulkhead.yml) to ensure that problems in the tenant's system don't propagate to your system.

### Delegated user access

When you access data from a tenant's data stores, consider whether you need to use a specific user's identity to access the data. When you do, your integration is subject to the same permissions that the user has. This approach is often called [delegated access](#full-or-user-delegated-access).

For example, suppose your multitenant service runs machine learning models over your tenants' data. You need to access each tenant's instances of services, like Azure Synapse Analytics, Azure Storage, Azure Cosmos DB, and others. Each tenant has their own Azure AD instance. Your solution can be granted delegated access to the data store, so that you can retrieve the data that a specific user can access.

Delegated access is easier if the data store supports Azure AD authentication. [Many Azure services support Azure AD identities](/azure/active-directory/managed-identities-azure-resources/services-azure-active-directory-support).

For example, suppose that your multitenant web application and background processes need to access Azure Storage by using your tenants' user identities from Azure AD. You might do the following steps:

1. [Create a multitenant Azure AD application registration](/azure/active-directory/develop/scenario-web-app-sign-user-overview) that represents your solution.
1. Grant the application [delegated permission to access Azure Storage as the signed-in user](/azure/storage/common/storage-auth-aad-app#grant-your-registered-app-permissions-to-azure-storage).
1. Configure your application to authenticate users by using Azure AD.

After a user signs in, Azure AD issues your application a short-lived access token that can be used to access Azure Storage on behalf of the user, and it issues a longer-lived refresh token. Your system needs to store the refresh token securely, so that your background processes can obtain new access tokens and can continue to access Azure Storage on behalf of the user.

### Messaging

Messaging allows for asynchronous, loosely coupled communication between systems or components. Messaging is commonly used in integration scenarios to decouple the source and destination systems. For more information on messaging and multitenancy, see [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md).

When you use messaging as part of an integration with your tenants' systems, consider whether you should use [shared access signatures for Azure Service Bus](/azure/service-bus-messaging/service-bus-sas) or [Azure Event Hubs](/azure/event-hubs/authorize-access-shared-access-signature). Shared access signatures enable you to grant limited access to your messaging resources to third parties, without enabling them to access the rest of your messaging subsystem.

In some scenarios, you might provide different service-level agreements (SLAs) or quality of service (QoS) guarantees to different tenants. For example, a subset of your tenants might expect to have their data export requests processed more quickly than others. By using the [Priority Queue pattern](../../../patterns/priority-queue.yml), you can create separate queues for different levels of priority, with different worker instances to prioritize them accordingly.

### Composable integration components

Sometimes you might need to integrate with many different tenants, each of which uses different data formats or different types of network connectivity.

A common approach in integration is to build and test individual steps that perform the following types of actions:

- Retrieve data from a data store.
- Transform data to a specific format or schema.
- Transmit the data by using a particular network transport or to a known destination type.

Typically, you build these individual elements by using services like Azure Functions and Azure Logic Apps. You then define the overall integration process by using a tool like Logic Apps or Azure Data Factory, and it invokes each of the predefined steps.

When you work with complex multitenant integration scenarios, it can be helpful to define a library of reusable integration steps. Then, you can build workflows for each tenant to compose the applicable pieces together, based on that tenant's requirements. Alternatively, you might be able to expose some of the data sets or integration components directly to your tenants, so that they can build their own integration workflows from them.

Similarly, you might need to import data from tenants who use a different data format or different transport to others. A good approach for this scenario is to build tenant-specific *connectors*. Connectors are workflows that normalize and import the data into a standardized format and location, and then they trigger your main shared import process.

If you need to build tenant-specific logic or code, consider following the [Anti-corruption Layer pattern](../../../patterns/anti-corruption-layer.yml). The pattern helps you to encapsulate tenant-specific components, while keeping the rest of your solution unaware of the added complexity.

If you use a [tiered pricing model](../considerations/pricing-models.md#feature--and-service-level-based-pricing), you might choose to require that tenants at a low pricing tier follow a standard approach with a limited set of data formats and transports. Higher pricing tiers might enable more customization or flexibility in the integration components that you offer.

## Antipatterns to avoid

- **Exposing your primary data stores directly to tenants.** For example, avoid providing credentials to your data stores to your customers, and don't directly replicate data from your primary database to customers' read replicas of the same database system. Instead, create dedicated *integration data stores*, and use the [Valet Key pattern](#valet-key-pattern) to expose the data.
- **Exposing APIs without an API gateway.** APIs have specific concerns for access control, billing, and metering. Even if you don't plan to use API policies initially, it's a good idea to include an API gateway early. That way, if you need to customize your API policies in the future, you don't need to make breaking changes to the URLs that a third party depends on.
- **Unnecessary tight coupling.** Loose coupling, such as by using [messaging](#messaging) approaches, can provide a range of benefits for security, performance isolation, and resiliency. When possible, it's a good idea to loosely couple your integrations with third parties. If you do need to tightly couple to a third party, ensure that you follow good practices like the [Retry pattern](../../../patterns/retry.yml), the [Circuit Breaker pattern](../../../patterns/circuit-breaker.yml), and the [Bulkhead pattern](../../../patterns/bulkhead.yml).
- **Custom integrations for specific tenants.** Tenant-specific features or code can make your solution harder to test. It also makes it harder to modify your solution in the future, because you have to understand more code paths. Instead, try to build [composable components](#composable-integration-components) that abstract the requirements for any specific tenant, and reuse them across multiple tenants with similar requirements.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
 
Other contributor:

 * [Will Velida](http://linkedin.com/in/willvelida) | Customer Engineer 2, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md).
