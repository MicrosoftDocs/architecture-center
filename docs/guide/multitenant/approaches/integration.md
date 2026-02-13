---
title: Architectural Approaches for Tenant Integration and Data Access
description: Learn about integration approaches for multitenant solutions, including APIs, webhooks, messaging, and data access patterns for tenant systems.
author: johndowns
ms.author: pnp
ms.date: 06/30/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural approaches for tenant integration and data access

It's typical for systems to integrate together, even across organizational boundaries. When you build a multitenant solution, you might have requirements to send data back to your tenants' systems or receive data from those systems. This article outlines key considerations and approaches for architecting and developing integrations for a multitenant solution.

> [!NOTE]
> If you provide multiple integration points, consider each point independently. Different integration points often have different requirements and are designed differently, even if they connect the same systems in various ways.

## Key considerations and requirements

### Direction of data flow

It's important to understand the direction of your data flows. The data flow direction affects several aspects of your architecture, such as how you manage identity and your solution's networking topology. There are two common data flows:

- **Export**, which means that data flows from your multitenant system to your individual tenants' systems

- **Import**, which means that data comes from your tenants' systems into your multitenant system

It's also important to consider the networking data flow direction, which doesn't necessarily correspond to the logical data flow direction. For example, you might initiate an outbound connection to a tenant so that you can import the data from the tenant's system.

### Full access or user-delegated access

In many systems, access to specific data is restricted to individual users. The data that one user accesses might differ from what another user accesses. It's important to consider whether you work with complete data sets or if the data that you import or export depends on each user's access permissions.

For example, Power BI is a multitenant service that provides reporting and business intelligence on top of customer-owned data stores. When you configure Power BI, you configure *data sources* to pull data from databases, APIs, and other data stores. You can configure data stores in two different ways:

- **Import all the data from the underlying data store.** This approach requires that Power BI receives credentials for an identity that has permissions to the full data store. After importing the data, Power BI administrators configure permissions independently. Power BI enforces those permissions.

- **Import a subset of data from the underlying data store, based on a user's permissions.** When a user creates a data source, they use their credentials and associated permissions. The exact subset of data that Power BI imports depends on the access level of the user who creates the data source.

Both approaches have valid use cases, so it's important to clearly understand your tenants' requirements.

If you work with full data sets, the source system effectively treats the destination system as a *trusted subsystem*. For this type of integration, you should also consider using a *workload identity* instead of a user identity. A workload identity is a system identity that doesn't correspond to a single user. The workload identity is granted a high level of permission to the data in the source system.

Alternatively, if you work with user-scoped data, then you might need to use an approach like *delegation* to access the correct subset of data from the data set. Then the destination system effectively gets the same permission as a specific user. For more information, see [Delegated user access](#delegated-user-access). If you use delegation, consider how to handle scenarios where a user is deprovisioned or their permissions change.

### Real-time integrations or batch integrations

Consider whether you plan to use real-time data or send the data in batches.

For real-time integrations, the following approaches are common:

- **Request-response** is where a client initiates a request to a server and receives a response. Typically, request-response integrations are implemented by using APIs or webhooks. Requests might be *synchronous*, where they wait for acknowledgment and a response. Alternatively, requests can be *asynchronous* and use something like the [Asynchronous Request-Reply pattern](../../../patterns/async-request-reply.yml) to wait for a response.

- **Loosely coupled communication** is often enabled through messaging components that are designed for loosely coupling systems together. For example, Azure Service Bus provides message queuing capabilities, and Azure Event Grid and Azure Event Hubs provide eventing capabilities. These components are often used as part of integration architectures.

In contrast, batch integrations are often managed through a background job, which might be triggered at specific times of the day. Batch integrations often occur through a *staging location* such as a blob storage container because the data sets exchanged can be large.

### Data volume

It's important to understand the volume of data that you exchange through an integration because this information helps you plan for your overall system capacity. When you plan your system's capacity, remember that different tenants might have different volumes of data to exchange.

For real-time integrations, you might measure volume as the number of transactions over a specified period of time. For batch integrations, you might measure volume either as the number of records exchanged or the amount of data in bytes.

### Data formats

When data is exchanged between two parties, it's important that they both clearly understand the data's format and structure. Consider the following parts of the data format:

- The file format, such as JSON, Parquet, CSV, or XML

- The schema, such as the list of fields included, date formats, and nullability of fields

When you work with a multitenant system, if possible, standardize and use the same data format for all of your tenants. This approach helps you avoid having to customize and retest your integration components for each tenant's requirements. However, some scenarios require different data formats to communicate with different tenants, so you might need to implement multiple integrations. For an approach that can help simplify this type of scenario, see [Composable integration components](#composable-integration-components).

### Access to tenants' systems

Some integrations require you to make a connection to your tenant's systems or data stores. When you connect to your tenant's systems, you need to carefully consider both the networking and identity components of the connection.

#### Network access

Consider the network topology for accessing your tenant's system, which might include the following options:

- **Internet connections** can raise concerns about securing the connection and encrypting the data. Determine how to secure the connection and encrypt the data when you connect across the internet. If your tenants plan to restrict access based on your IP addresses, ensure that the Azure services that your solution uses can support static IP addresses for outbound connections. For example, consider using [Azure NAT Gateway](../service/nat-gateway.md) to provide static IP addresses, if necessary. If you require a VPN, consider how to exchange keys securely with your tenants.

- **[Agents](../approaches/networking.md#agents)**, which are deployed into a tenant's environment, can provide a flexible approach. Agents can also help you avoid the need for your tenants to allow inbound connections.

- **Relays**, such as [Azure Relay](/azure/azure-relay/relay-what-is-it), also provide an approach to avoid inbound connections.

For more information, see [Networking approaches for multitenancy](networking.md#public-or-private-access).

#### Authentication

Consider how you authenticate with each tenant when you initiate a connection. Consider the following approaches:

- **Secrets**, such as API keys or certificates. It's important to plan how to securely manage your tenants' credentials. Leakage of your tenants' secrets could result in a major security incident, which can potentially affect many tenants.

- **Microsoft Entra tokens**, where you use a token that the tenant's Microsoft Entra directory issues. The token might be issued directly to your workload by using a multitenant Microsoft Entra application registration or a specific service principal. Alternatively, your workload can request delegated permission to access resources on behalf of a specific user within the tenant's directory.

Whichever approach you select, ensure that your tenants follow the principle of least privilege and don't grant your system unnecessary permissions. For example, if your system only needs to read data from a tenant's data store, the identity that your system uses shouldn't have write permissions.

### Tenants' access to your systems

If tenants need to connect to your system, consider providing dedicated APIs or other integration points. You can then model these integration points as part of the surface area of your solution.

In some scenarios, you might decide to provide your tenants with direct access to your Azure resources. Consider the ramifications carefully and ensure that you understand how to grant access to tenants in a safe manner. For example, you might use one of the following approaches:

- Use the [Valet Key pattern](#valet-key-pattern), which uses security measures like shared access signatures (SAS) tokens to grant restricted access to specific Azure resources.

- Use dedicated resources for integration points, such as a dedicated storage account. It's good practice to keep integration resources separated from your core system resources. This approach helps you minimize the *blast radius* of a security incident. It also ensures that if a tenant accidentally initiates large numbers of connections to the resource and exhausts its capacity, the rest of your system continues to run.

### Compliance

When you interact with or transmit your tenants' data directly, it's crucial that you have a clear understanding of your tenants' [governance and compliance requirements](../approaches/governance-compliance.md).

## Approaches and patterns

### Expose APIs

Real-time integrations often involve exposing APIs for your tenants or other parties to use. APIs require special considerations, especially when external parties use them. Consider the following factors:

- Define who can access the API.

- Authenticate users of the API by using a secure and reliable method.

- Set a limit on the number of requests that each API user can make over a specific time period.

- Provide clear information and documentation for each API. If appropriate, implement a developer portal to support discovery and onboarding.

A good practice is to use an API gateway, such as [Azure API Management](/azure/api-management/api-management-key-concepts), to handle these concerns and many others. API gateways give you a single place to implement policies that your APIs follow. They also simplify the implementation of your back-end API systems. For more information, see [Use API Management in a multitenant solution](../service/api-management.md).

### Valet Key pattern

Occasionally, a tenant might need direct access to a data source, such as Azure Storage. Consider following the [Valet Key pattern](../../../patterns/valet-key.yml) to share data securely and to restrict access to the data store.

For example, you can use this approach to batch export a large data file. After you generate the export file, you can save it to a blob container in Azure Storage and then generate a time-bound, read-only SAS. This signature can be provided to the tenant, along with the blob URL. The tenant can then download the file from Azure Storage until the signature's expiration date.

Similarly, you can generate an SAS with permissions to write to a specific blob. When you provide an SAS to a tenant, they can write their data to the blob. By using Event Grid integration for Azure Storage, your application can then be notified to process and import the data file.

### Webhooks

Webhooks enable you to send events to your tenants at a URL that they provide to you. When you have information to send, you initiate a connection to the tenant's webhook and include your data in the HTTP request payload.

If you choose to build your own webhook eventing system, consider following the [CloudEvents](https://cloudevents.io/) standard to simplify your tenants' integration requirements.

Alternatively, you can use a service like [Event Grid](/azure/event-grid/overview) to provide webhook functionality. Event Grid works natively with CloudEvents and supports [event domains](/azure/event-grid/event-domains), which are useful for multitenant solutions.

> [!NOTE]
> When you make outbound connections to your tenants' systems, you connect to an external system. Follow recommended cloud practices, including using the [Retry pattern](../../../patterns/retry.yml), the [Circuit Breaker pattern](../../../patterns/circuit-breaker.md), and the [Bulkhead pattern](../../../patterns/bulkhead.yml) to ensure that problems in the tenant's system don't propagate to your system.

### Delegated user access

When you access data from a tenant's data stores, consider whether you need to use a specific user's identity to access the data. When you do, your integration is subject to the same permissions that the user has. This approach is often called [delegated access](#full-access-or-user-delegated-access).

For example, suppose that your multitenant service runs machine learning models over your tenants' data. You need to access each tenant's instances of services, such as [Microsoft Fabric workspaces](/fabric/fundamentals/microsoft-fabric-overview) for analytics, Azure Storage, and Azure Cosmos DB. Each tenant has their own Microsoft Entra directory. Your solution can be granted delegated access to the data store so that you can retrieve the data that a specific user can access.

Delegated access is easier if the data store supports Microsoft Entra authentication. Many Azure services support [Microsoft Entra identities](/entra/identity/managed-identities-azure-resources/managed-identities-status).

For example, suppose that your multitenant web application and background processes need to access Azure Storage by using your tenants' user identities from Microsoft Entra ID. You might do the following steps:

1. [Create a multitenant Microsoft Entra application registration](/entra/identity-platform/scenario-web-app-sign-user-app-registration) that represents your solution.

1. Grant the application [delegated permission to access Azure Storage as the signed-in user](/azure/storage/common/storage-auth-aad-app#grant-your-registered-app-permissions-to-azure-storage).

1. Configure your application to authenticate users by using Microsoft Entra ID.

After a user signs in, Microsoft Entra ID issues your application a short-lived access token that can be used to access Azure Storage on behalf of the user, and it issues a longer-lived refresh token. Your system needs to store the refresh token securely so that your background processes can obtain new access tokens and can continue to access Azure Storage on behalf of the user.

### Messaging

Messaging allows for asynchronous, loosely coupled communication between systems or components. Messaging is often used in integration scenarios to decouple the source and destination systems. For more information about messaging and multitenancy, see [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md).

When you use messaging as part of an integration with your tenants' systems, consider whether you should use [SAS tokens for Service Bus](/azure/service-bus-messaging/service-bus-sas) or [Event Hubs](/azure/event-hubs/authorize-access-shared-access-signature). SAS tokens grant limited access to your messaging resources to external users or systems without enabling them to access the rest of your messaging subsystem.

In some scenarios, you might provide different service-level agreements or quality of service guarantees to different tenants. For example, a subset of your tenants might expect to have their data export requests processed more quickly than others. By using the [Priority Queue pattern](../../../patterns/priority-queue.yml), you can create separate queues for different levels of priority. Then, you can use different worker instances to prioritize them accordingly.

### Composable integration components

Sometimes you might need to integrate with many different tenants, each of which uses different data formats or different types of network connectivity.

A common approach in integration is to build and test individual steps that perform the following types of actions:

- Retrieve data from a data store.
- Transform data to a specific format or schema.
- Transmit data by using a specific network transport or to a known destination type.

Typically, you build these individual elements by using services like Azure Functions and Azure Logic Apps. You then define the overall integration process by using a tool like Logic Apps or Azure Data Factory, which invokes each predefined step.

When you work with complex multitenant integration scenarios, it's helpful to define a library of reusable integration steps. You can build workflows for each tenant by composing the applicable pieces based on that tenant's requirements. Alternatively, you might expose some of the data sets or integration components directly to your tenants so that they can build their own integration workflows.

Similarly, you might need to import data from tenants who use a different data format or different transport than others. A good approach for this scenario is to build tenant-specific *connectors*. Connectors are workflows that normalize and import the data into a standardized format and location. They then trigger your main shared import process.

If you need to build tenant-specific logic or code, consider following the [Anti-Corruption Layer pattern](../../../patterns/anti-corruption-layer.yml). This pattern helps you encapsulate tenant-specific components and keeps the rest of your solution unaware of the added complexity.

If you use a [tiered pricing model](../considerations/pricing-models.md#feature--and-service-level-based-pricing), you might require that tenants at low pricing tiers follow a standard approach with a limited set of data formats and transports. Tenants at higher pricing tiers might have access to more customization or flexibility in the integration components that you provide.

## Antipatterns to avoid

- **Exposing your primary data stores directly to tenants.** When tenants access your primary data stores, it can become harder to secure those stores. They might also accidentally cause performance problems that affect your solution. Avoid providing credentials to your data stores to customers. Don't directly replicate raw data from your primary database to customers' read replicas of the same database system. Instead, create dedicated *integration data stores*. Use the [Valet Key pattern](#valet-key-pattern) to expose the data.

- **Exposing APIs without an API gateway.** APIs have specific concerns for access control, billing, and metering. Even if you don't plan to use API policies initially, it's a good idea to include an API gateway early. That way, if you need to customize your API policies later, you don't have to make breaking changes to the URLs that an external client depends on.

- **Unnecessary tight coupling.** Loose coupling, such as by using [messaging](#messaging) approaches, can provide a range of benefits for security, performance isolation, and resiliency. When possible, you should loosely couple your integrations with external systems. If you need to tightly couple to an external system, ensure that you follow good practices like the [Retry pattern](../../../patterns/retry.yml), the [Circuit Breaker pattern](../../../patterns/circuit-breaker.md), and the [Bulkhead pattern](../../../patterns/bulkhead.yml).

- **Custom integrations for specific tenants.** Tenant-specific features or code can make your solution harder to test. It also makes it harder to modify your solution in the future because you have to understand more code paths. Instead, try to build [composable components](#composable-integration-components) that abstract the requirements for any specific tenant and reuse them across multiple tenants that have similar requirements.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

- [Will Velida](https://www.linkedin.com/in/willvelida/) | Customer Engineer 2, FastTrack for Azure
- [Filipe Moreira](https://www.linkedin.com/in/filipefumaux/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Architectural approaches for messaging in multitenant solutions](../approaches/messaging.md)
