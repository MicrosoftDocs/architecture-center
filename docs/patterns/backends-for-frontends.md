---
title: Backends for Frontends Pattern
description: Explore the Backends for Frontends pattern, which creates separate backend services for consumption by specific frontend applications or interfaces.
ms.author: csiemens
author: claytonsiemens77
ms.date: 03/19/2025
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Backends for Frontends pattern

This pattern describes how to decouple backend services from frontend implementations to tailor experiences for different client interfaces. This pattern is useful when you want to avoid customizing a backend that serves multiple interfaces. This pattern is based on the [Backends for Frontends pattern by Sam Newman](https://samnewman.io/patterns/architectural/bff/).

## Context and problem

Consider an application that's initially designed with a desktop web UI and a corresponding backend service. As business requirements change over time, a mobile interface is added. Both interfaces interact with the same backend service. But the capabilities of a mobile device differ significantly from a desktop browser in terms of screen size, performance, and display limitations.

:::image type="complex" border="false" source="./_images/backend-for-frontend-problem.svg" alt-text="Architectural diagram that shows the context and problem of the Backends for Frontends pattern." lightbox="./_images/backend-for-frontend-problem.svg":::
   The diagram has two sections: the backend service and the desktop client and mobile client. Two double-sided arrows point from the backend service to both the desktop client and the mobile client.
:::image-end:::

A backend service frequently encounters competing demands from multiple frontend systems. These demands result in frequent updates and potential development bottlenecks. Conflicting updates and the need to maintain compatibility result in excessive demand on a single deployable resource.

Having a separate team manage the backend service can create a disconnect between frontend and backend teams. This disconnect can cause delays in gaining consensus and balancing requirements. For example, changes requested by one frontend team must be validated with other frontend teams before integration.

## Solution

Introduce a new layer that handles only the requirements that are specific to the interface. This layer, known as the backend-for-frontend (BFF) service, sits between the frontend client and the backend service. If the application supports multiple interfaces, such as a web interface and a mobile app, create a BFF service for each interface.

This pattern customizes the client experience for a specific interface without affecting other interfaces. It also optimizes performance to meet the needs of the frontend environment. Because each BFF service is smaller and less complex than a shared backend service, it can make the application easier to manage.

Frontend teams independently manage their own BFF service, which gives them control over language selection, release cadence, workload prioritization, and feature integration. This autonomy enables them to operate efficiently without depending on a centralized backend development team.

Many BFF services traditionally relied on REST APIs, but GraphQL implementations are emerging as an alternative. With GraphQL, the querying mechanism eliminates the need for a separate BFF layer because it allows clients to request the data that they need without relying on predefined endpoints.

:::image type="complex" border="false" source="_images/backend-for-frontend-solution.svg" alt-text="Architectural diagram that shows the Backends for Frontends pattern." lightbox="_images/backend-for-frontend-solution.svg":::
   The diagram shows three sections. The first section consists of the desktop client and mobile client. The second section consists of the desktop client BFF service and the mobile client BFF service. The desktop client has a solid arrow that points to the desktop client BFF service. The mobile client has a solid arrow that points to the mobile client BFF service. Each BFF service has a dotted arrow that points to the backend service section.
:::image-end:::

For more information, see [Backends for Frontends pattern by Sam Newman](https://samnewman.io/patterns/architectural/bff/).

## Problems and considerations

- Evaluate your optimal number of services depending on the associated costs. Maintaining and deploying more services means increased operational overhead. Each individual service has its own life cycle, deployment and maintenance requirements, and security needs.

- Review the service-level objectives when you add a new service. Increased latency might occur because clients aren't contacting your services directly, and the new service introduces an extra network hop.

- When different interfaces make the same requests, evaluate whether the requests can be consolidated into a single BFF service. Sharing a single BFF service between multiple interfaces can result in different requirements for each client, which can complicate the BFF service's growth and support.

  Code duplication is a probable outcome of this pattern. Evaluate the trade-off between code duplication and a better-tailored experience for each client.

- The BFF service should only handle client-specific logic related to a specific user experience. Cross-cutting features, such as monitoring and authorization, should be abstracted to maintain efficiency. Typical features that might surface in the BFF service are handled separately with the [Gatekeeping](/azure/architecture/patterns/gatekeeper), [Rate Limiting](/azure/architecture/patterns/rate-limiting-pattern), and [Routing](/azure/architecture/patterns/gateway-routing) patterns.

- Consider how learning and implementing this pattern affects the development team. Developing new backend systems requires time and effort, which can result in technical debt. Maintaining the existing backend service adds to this challenge.

- Evaluate whether you need this pattern. For example, if your organization uses GraphQL with frontend specific resolvers, BFF services might not add value to your applications.

  Another scenario is an application that combines an [API gateway](/azure/architecture/microservices/design/gateway) with microservices. This approach might be sufficient for some scenarios where BFF services are typically recommended.

## When to use this pattern

Use this pattern when:

- A shared or general-purpose backend service requires substantial development overhead to maintain.

- You want to optimize the backend for the requirements of specific client interfaces.

- You make customizations to a general-purpose backend to accommodate multiple interfaces.

- A programming language is better suited for the backend of a specific user interface, but not all user interfaces.

This pattern might not be suitable when:

- Interfaces make the same or similar requests to the backend.

- Only one interface interacts with the backend.

## Workload design

Evaluate how to use the Backends for Frontends pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | When you isolate services to a specific frontend interface, you contain malfunctions. The availability of one client doesn't affect the availability of another client's access. When you treat various clients differently, you can prioritize reliability efforts based on expected client access patterns. <br><br> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows) <br> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | The service separation introduced in this pattern allows security and authorization in the service layer to be customized for each client's specific needs. This approach can reduce the API's surface area and limit lateral movement between backends that might expose different capabilities. <br><br> - [SE:04 Segmentation](/azure/well-architected/security/segmentation) <br> - [SE:08 Hardening resources](/azure/well-architected/security/harden-resources) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | The backend separation enables you to optimize in ways that might not be possible with a shared service layer. When you handle individual clients differently, you can optimize performance for a specific client's constraints and functionality. <br><br> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning) <br> - [PE:09 Critical flows](/azure/well-architected/performance-efficiency/prioritize-critical-flows) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

This example demonstrates a use case for the pattern in which two distinct client applications, a mobile app and a desktop application, interact with Azure API Management (data plane gateway). This gateway serves as an abstraction layer and manages common cross-cutting concerns such as:

- **Authorization.** Ensures that only verified identities with the proper access tokens can call protected resources by using API Management with Microsoft Entra ID.

- **Monitoring.** Captures and sends request and response details to Azure Monitor for observability purposes.

- **Request caching.** Optimizes repeated requests by serving responses from cache by built-in features of API Management.

- **Routing and aggregation.** Directs incoming requests to the appropriate BFF services.

Each client has a dedicated BFF service running as an Azure function that serves as an intermediary between the gateway and the underlying microservices. These client-specific BFF services ensure a tailored experience for pagination and other functionalities. The mobile app prioritizes bandwidth efficiency and takes advantage of caching to enhance performance. In contrast, the desktop application retrieves multiple pages in a single request, which creates a more immersive user experience.

:::image type="complex" border="false" source="./_images/backend-for-frontend-example.svg" alt-text="Diagram that shows the Azure BFF service architecture with API Management handling cross-cutting concerns. Mobile and desktop platforms retrieve data through client-specific Azure Functions in the BFF service." lightbox="./_images/backend-for-frontend-example.svg":::
   The diagram is structured into four sections that illustrate the flow of requests, authentication, monitoring, and client-specific processing. Two client devices initiate requests: a mobile application optimized for a bandwidth-efficient user experience and a web browser that provides a fully functional interface. Arrows extend from both devices toward the central entry point, which is the API Management gateway, to indicate that all requests must pass through this layer. In the second section, enclosed in a dashed-line rectangle, the architecture is divided into two horizontal groups. The left group represents the API Management that handles incoming requests and determines how to process them. Two arrows extend outward from this data plane gateway. One arrow points upward to Microsoft Entra ID, which manages the authorization. Another arrow points downward to Azure Monitor, which is responsible for logging and observability. An arrow loops back from the gateway to the mobile client, which represents a cached response when an identical request is repeated, which reduces unnecessary processing. The right group within the dashed rectangle focuses on tailoring backend responses based on the type of client that makes the request. It features two separate backend-for-frontend clients, both hosted by using Azure Functions for serverless computing. One is dedicated to the mobile client and the other to the desktop client. Two arrows extend from the gateway to these backend-for-frontend clients, which illustrates that each incoming request is forwarded to the appropriate service, depending on the client type. Beyond this layer, dashed arrows extend and connect the backend-for-frontend clients to various microservices, which handle the actual business logic. The image shows a left-to-right flow where client requests move from mobile and web clients to the gateway. This gateway processes each request while delegating authentication upward to the identity provider and logging downward to the monitoring service. From there, it routes requests to the appropriate backend-for-frontend client based on whether the request originates from a mobile or desktop client. Finally, each backend-for-frontend client forwards the request to specialized microservices, which perform the required business logic and return the necessary response. If a cached response is available, the gateway intercepts the request and sends the stored response directly to the mobile client, which prevents redundant processing.
:::image-end:::

### Flow A for the first page request from the mobile client

1. The mobile client sends a `GET` request for page `1`, including the OAuth 2.0 token in the authorization header.

1. The request reaches the API Management gateway, which intercepts it and:

   1. **Checks the authorization status.** API Management implements defense in depth, so it checks the validity of the access token.

   1. **Streams the request activity as logs to Azure Monitor.** Details of the request are recorded for auditing and monitoring.

1. The policies are enforced, then API Management routes the request to the Azure function mobile BFF service.

1. The Azure function mobile BFF service then interacts with the necessary microservices to fetch a single page and process the requested data to provide a lightweight experience.

1. The response is returned to the client.

### Flow B for the first page cached request from the mobile client

1. The mobile client sends the same `GET` request for page `1` again, including the OAuth 2.0 token in the authorization header.

1. The API Management gateway recognizes that this request was made before and:

   1. **The policies are enforced.** Then the gateway identifies a cached response that matches the request parameters.

   1. **Returns the cached response immediately.** This quick response eliminates the need to forward the request to the Azure function mobile BFF service.

### Flow C for the first request from the desktop client

1. The desktop client sends a `GET` request for the first time, including the OAuth 2.0 token in the authorization header.

1. The request reaches the API Management gateway, where cross-cutting concerns are handled.

   1. **Authorization:** Token validation is always required.

   1. **Stream the request activity:** Request details are recorded for observability.

1. After all policies are enforced, API Management routes the request to the Azure function desktop BFF service, which handles the data-heavy application processing. The desktop BFF service aggregates multiple requests by using underlying microservices calls before responding to the client with a multiple page response.

### Design

- [Microsoft Entra ID](/entra/fundamentals/whatis) serves as the cloud-based identity provider. It provides tailored audience claims for both mobile and desktop clients. These claims are then used for authorization.

- [API Management](/azure/well-architected/service-guides/api-management/operational-excellence) serves as a proxy between the clients and their BFF services, which establishes a perimeter. API Management is configured with policies to [validate the JSON Web Tokens](/azure/api-management/validate-jwt-policy) and rejects requests that lack a token or contain invalid claims for the targeted BFF service. It also streams all the activity logs to Azure Monitor.

- [Azure Monitor](/azure/well-architected/service-guides/azure-log-analytics) functions as the centralized monitoring solution. It aggregates all activity logs to ensure comprehensive, end-to-end observability.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless solution that efficiently exposes BFF service logic across multiple endpoints, which simplifies development. Azure Functions also minimizes infrastructure overhead and helps lower operational costs.

## Next steps

- [Backends for Frontends pattern by Sam Newman](https://samnewman.io/patterns/architectural/bff/)
- [Authentication and authorization to APIs in API Management](/azure/api-management/authentication-authorization-overview)
- [How to integrate API Management with Application Insights](/azure/api-management/api-management-howto-app-insights)

## Related resources

- [Gateway Aggregation pattern](./gateway-aggregation.yml)
- [Gateway Offloading pattern](./gateway-offloading.yml)
- [Gateway Routing pattern](./gateway-routing.yml)
