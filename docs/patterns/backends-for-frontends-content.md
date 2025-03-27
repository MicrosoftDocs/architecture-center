Decouple backend services from the frontend implementations to tailor experiences for different client interfaces. This pattern is useful when you want to avoid customizing a backend that serves multiple interfaces. This pattern is based on [Pattern: Backends For Frontends](https://samnewman.io/patterns/architectural/bff/) described by Sam Newman.

## Context and problem

Consider an application that was initially designed with a desktop web UI and a corresponding backend service. As business requirements changed over time, a mobile interface was added. Both interfaces interact with the same backend service but the capabilities of a mobile device differ significantly from a desktop browser, in terms of screen size, performance, and display limitations.

![Architectural diagram showing the context and problem of the Backends for Frontends pattern.](./_images/backend-for-frontend-problem.png)

The backend service often faces competing demands from different frontends, leading to frequent changes and potential bottlenecks in the development process. Conflicting updates and the need to maintain compatibility result in excessive work on a single deployable resource.

Having a separate team manage the backend service can create a disconnect between frontend and backend teams, causing delays in gaining consensus and balancing requirements. For example, changes requested by one frontend team must be validated with other frontend teams before integration.

## Solution

Introduce a new layer that handles only the interface-specific requirements. This layer called the backend-for-frontend (BFF) service, sits between the frontend client and the backend service. If the application supports multiple interfaces, create a BFF service for each interface. For example, if you have a web interface and a mobile app, you would create separate BFF services for each.

> This pattern tailors client experience for a specific interface, without affecting other interfaces. It also fine-tunes the performance to best match the needs of the frontend environment. Because each BFF service smaller and less complex, the application might experience optimization benefits to a certain degree.
>
> Frontend teams have autonomy over their own BFF service, allowing flexibility in language selection, release cadence, workload prioritization, and feature integration without relying on a centralized backend development team.

While many BFFs relied on REST APIs, GraphQL implementations are becoming an alternative, which removes the need for the BFF layer because the querying mechanism doesn't require a separate endpoint.

![Architectural diagram showing the backends for frontends pattern.](./_images/backend-for-frontend-solution.png)

For more information, see [Pattern: Backends For Frontends](https://samnewman.io/patterns/architectural/bff/).

## Issues and considerations


- Evaluate what the optimal number of services is for you, as this will have associated costs. Maintaining and deploying more services means increased operational overhead. Each individual service has its own life cycle, deployment and maintenance requirements, and security needs.

- Review the Service Level Objectives (SLOs) when adding a new service. Increased latency may occur because clients aren't contacting your services directly, and the new service introduces an extra network hop.

- When different interfaces make the same requests, evaluate whether the requests can be consolidated into a single BFF service. Sharing a single BFF service between multiple interfaces can lead to different requirements for each client, which can complicate the BFF service's growth and support.

    Code duplication is a probable outcome of this pattern. Evaluate the tradeoff between code duplication and a better-tailored experience for each client.

- The BFF service should only handle client-specific logic related to a specific user experience. Cross-cutting features, such as monitoring and authorization, should be abstracted to keep BFF service light. Typical features that might surface in the BFF service are handled separately with [Gatekeeping](/azure/architecture/patterns/gatekeeper), [Rate Limiting](/azure/architecture/patterns/rate-limiting-pattern), [Routing](/azure/architecture/patterns/gateway-routing), and others.

- Consider the impact on the development team when learning and implementing this pattern. Building new backends requires time and effort, potentially incurring technical debt while maintaining the existing backend service.

- Evaluate if you need this pattern at all. For example if your organization uses GraphQL with frontend-specific resolvers, BFF might not add value to your applications.

    Another example is application that combines [API Gateway](/azure/architecture/microservices/design/gateway) with microservices. This approach may be sufficient for some cases where BFFs were previously recommended.

## When to use this pattern

Use this pattern when:

- A shared or general purpose backend service must be maintained with significant development overhead.

- You want to optimize the backend for the requirements of specific client interfaces.

- Customizations are made to a general-purpose backend to accommodate multiple interfaces.

- A programming language is better suited for the backend of a specific user interface, but not all user interfaces.

This pattern may not be suitable:

- When interfaces make the same or similar requests to the backend.

- When only one interface is used to interact with the backend.

## Workload design

An architect should evaluate how the Backends for Frontends pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | Having separate services that are exclusive to a specific frontend interface contains malfunctions so the availability of one client might not affect the availability of another client's access. Also, when you treat various clients differently, you can prioritize reliability efforts based on expected client access patterns.<br/><br/> - [RE:02 Critical flows](/azure/well-architected/reliability/identify-flows)<br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | Because of service separation introduced in this pattern, the security and authorization in the service layer that supports one client can be tailored to the functionality required by that client, potentially reducing the surface area of an API and lateral movement among different backends that might expose different capabilities.<br/><br/> - [SE:04 Segmentation](/azure/well-architected/security/segmentation)<br/> - [SE:08 Hardening resources](/azure/well-architected/security/harden-resources) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | The backend separation enables you to optimize in ways that might not be possible with a shared service layer. When you handle individual clients differently, you can optimize performance for a specific client's constraints and functionality.<br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:09 Critical flows](/azure/well-architected/performance-efficiency/prioritize-critical-flows) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

This example shows a use case for the pattern where you have two distinct client applications: a mobile app and a desktop application. Both clients interact with an Azure API Management (data plane gateway), which acts as an abstraction layer, handling common cross-cutting concerns such as:

- **Authorization** – Ensuring only verified identities with the proper access tokens can call protected resources using the Azure API Management (APIM) with Microsoft Entra ID.

- **Monitoring** – Capturing and sending request and response details for observability purposes to Azure Monitor.

- **Request Caching** – Optimizing repeated requests by serving responses from cache using APIM built-in features.

- **Routing & Aggregation** – Directing incoming requests to the appropriate Backend for Frontend (BFF) services.

Each client has a dedicated BFF service running as an Azure Function that serve as an intermediary between the gateway and the underlying microservices. These client-specific BFF ensures a tailored experience for pagination among other functionalities. While the mobile is more bandwidth-conscious app and caching improves performance, the desktop aggregates multiple pages in a single request, optimizing for a richer user experience.

:::image type="complex" source="./_images/backend-for-frontend-example.png" alt-text="Diagram that shows Azure BFF architecture with Azure API Management handling cross-cutting concerns; mobile and desktop fetch data using client-specific BFF Azure Functions.":::
   The diagram is structured into four distinct sections, illustrating the flow of requests, authentication, monitoring, and client-specific processing. On the far left, two client devices initiate requests: a mobile application optimized for a bandwidth-efficient user experience and a web browser offering a fully functional interface. Arrows extend from both devices toward the central entry point, which is the Azure API Management gateway, indicating that all requests must pass through this layer. Within the second section, enclosed in a dashed-line rectangle, the architecture is divided into two horizontal groups. The left group represents the Azure API Management, responsible for handling incoming requests and determining how they should be processed. Two arrows extend outward from this data plane gateway: one pointing upward to Microsoft Entra ID, which manages the authorization, and another pointing downward to Azure Monitor, which is responsible for logging and observability. Additionally, an arrow loops back from the gateway to the mobile client, representing a cached response when an identical request is repeated, reducing unnecessary processing. The right group within the dashed rectangle focuses on tailoring backend responses based on the type of client making the request. It features two separate backend-for-frontend clients, both hosted using Azure Functions for serverless computing—one dedicated to the mobile client and the other to the desktop client. Two arrows extend from the gateway to these backend-for-frontend clients, illustrating that each incoming request is forwarded to the appropriate service depending on the client type. Beyond this layer, dashed arrows extend further to the right, connecting the backend-for-frontend clients to various microservices, which handle the actual business logic. To visualize this diagram, imagine a left-to-right flow where client requests move from mobile and web clients to the gateway. This gateway processes each request while delegating authentication upward to the identity provider and logging downward to the monitoring service. From there, it routes requests to the appropriate backend-for-frontend client based on whether the request originates from a mobile or desktop client. Finally, each backend-for-frontend client forwards the request to specialized microservices, which execute the required business logic and return the necessary response. If a cached response is available, the gateway intercepts the request and sends the stored response directly to the mobile client, preventing redundant processing.
:::image-end:::

#### Flow A: Mobile client – first page request

1. The mobile client sends a `GET` request for the page `1` including the OAuth 2.0 token in the authorization header.
1. The request reaches the Azure APIM Gateway, which intercepts it and:
   1. Checks authorization status – APIM implements defense in depth, so it checks the validity of the access token.
   1. Stream the request activity as logs to Azure Monitor – Details of the request are recorded for auditing and monitoring.
1. The policies are enforced, then Azure APIM routes the request to the Azure Function Mobile BFF.
1. The Azure Function Mobile BFF then interacts with the necessary microservices to fetch a single page and process the requested data to provide with a lightweight experience.
1. The response is returned to the client.

#### Flow B: Mobile client – first page cached request
1. The mobile client sends the same `GET` request for the page `1` again including the OAuth 2.0 token in the authorization header.
1. The Azure APIM Gateway recognizes that this request was made before and:
   1. The policies are enforced, and after that it identifies a cached response matching the request parameters.
   1. Returns the cached response immediately, eliminating the need to forward the request to the Azure Function Mobile BFF.

#### Flow C: Desktop client – first request
1. The desktop client sends a `GET` request for the first time including the OAuth 2.0 token in the authorization header.
1. The request reaches the Azure APIM Gateway, where similar cross-cutting concerns are handled:
   1. Authorization – token validation is always required.
   1. Stream the request activity – Request details are recorded for observability.
1. Once all policies were enforced, Azure APIM routes the request to the Azure Function Desktop BFF, which is responsible for handling data-heavy application processing. The Desktop BFF aggregates multiple requests using underlying microservices calls before responding to the client with a multiple page response.

### Design

- [Microsoft Entra ID](/entra/fundamentals/whatis) serves as the cloud-based Identity Provider, issuing tailored audience claims for both mobile and desktop clients, which are subsequently leveraged for authorization.

- [Azure API Management](/azure/well-architected/service-guides/api-management/operational-excellence) acts as proxy between the clients and their BBFs adding a perimeter. It's configured with policies to [validate the JSON Web Tokens (JWTs)](/azure/api-management/validate-jwt-policy), rejecting requests that arrive without a token or the claims aren't valid for the targeted BFF. Additionally it streams all the activity logs to Azure Monitor.

- [Azure Monitor](/azure/well-architected/service-guides/azure-log-analytics) functions as the centralized monitoring solution, aggregating all activity logs to ensure comprehensive, end-to-end observability.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless solution that seamlessly exposes BFF logic across multiple endpoints, enabling streamlined development, reducing infrastructure overhead, and lowering operational costs.

## Next steps

- [Pattern: Backends For Frontends](https://samnewman.io/patterns/architectural/bff/)

## Related resources

- [Gateway Aggregation pattern](./gateway-aggregation.yml)
- [Gateway Offloading pattern](./gateway-offloading.yml)
- [Gateway Routing pattern](./gateway-routing.yml)
- [Authentication and authorization to APIs in Azure API Management](/azure/api-management/authentication-authorization-overview)
- [How to integrate Azure API Management with Azure Application Insights](/azure/api-management/api-management-howto-app-insights)
- [Serverless web application reference architecture](/azure/architecture/web-apps/serverless/architectures/web-app)
