Decouple backend services from the frontend implementations to tailor experiences for different client interfaces. This pattern is based on [Pattern: Backends For Frontends](https://samnewman.io/patterns/architectural/bff/) described by Sam Newman.

## Context and problem

Consider an application that was initially designed with a desktop web UI and a corresponding backend service. As business requirements changed over time, a mobile inteface was added. Both interfaces interact with the same backend service but the capabilities of a mobile device differ significantly from a desktop browser, in terms of screen size, performance, and display limitations.

![Context-and-problem diagram of the Backends for Frontends pattern](./_images/backend-for-frontend.png)

The backend service often faces competing demands from different frontends, leading to frequent changes and potential bottlenecks in the development process. Conflicting updates and the need to maintain compatibility result in excessive work on a single deployable resource. Having a separate team manage the backend service can create a disconnect between frontend and backend teams, causing delays in gaining consensus and balancing requirements. For example, changes requested by one frontend team must be validated with other frontend teams before integration.


> Note: Many BFFs relied on REST APIs, but GraphQL implementations are a common alternative.

## Solution

Introduce a new layer that handles only the UI-specific requirements. This layer, called the backend-for-frontend (BFF) service, sits between the frontend UI and the backend service. If the application supports multiple interfaces, create a BFF service for each interface. For example, if you have a web interface and a mobile app, you would create separate BFF services for each. 

> This pattern tailors the frontend to a specific interface, without affecting other frontend experiences. It also fine-tunes the performance to best match the needs of the frontend environment. Not only is each BFF service smaller and less complex, but it is also faster than a generic backend.
>
> Frontend teams have autonomy over their own BFF service, allowing flexibility in language selection, release cadence, workload prioritization, and feature integration without relying on a centralized backend development team. 

While many BFFs relied on REST APIs, GraphQL implementations are becoming a common alternative, which removes the need for the BFF layer because the querying mechanism doesn't require a separate endpoint.

![Diagram of the Backends for Frontends pattern](./_images/backend-for-frontend-example.png)

For more information, see [Pattern: Backends For Frontends](https://samnewman.io/patterns/architectural/bff/).

## Issues and considerations


- Consider identifying your organization's approach to determining the optimal number of backends to deliver.
- Evaluate the increased operational overhead (maintain and deploy).
- Consider reviewing your Service Level Objectives (SLOs) to assess the impact of added latency from extra network hops and new service availability.
- If different interfaces (such as mobile clients) make the same requests, consider whether it's necessary to implement a backend for each interface, or if a single backend suffices.
- Code duplication across services is highly likely when implementing this pattern. Calculate the cost of deploying and maintaining additional services.
- Frontend-focused backend services should only contain client-specific logic and behavior. Cross-cutting features should be managed elsewhere in your application (that is, [Gatekeeping](/azure/architecture/patterns/gatekeeper), [Rate Limiting](/azure/architecture/patterns/rate-limiting-pattern), [Routing](/azure/architecture/patterns/gateway-routing), and others).
=======
- Consider what the optimal number of services is for you, as this will have associated costs. Maintaining and deploying more services means increased operational overhead. Each individual service has its own life cycle, maintenance requirements, and security needs.

- 

- If different interfaces (such as mobile clients) will make the same requests, consider whether it is necessary to implement a backend for each interface, or if a single backend will suffice.
- Code duplication across services is highly likely when implementing this pattern.
- Frontend-focused backend services should only contain client-specific logic and behavior. General business logic and other global features should be managed elsewhere in your application.

- Think about how this pattern might be reflected in the responsibilities of a development team.
- Consider how long it takes to implement this pattern. Will the effort of building the new backends incur technical debt, while you continue to support the existing generic backend?
- If your organization uses GraphQL with frontend-specific resolvers, carefully assess whether a BFF adds value to your applications.
- Modern [API Gateway](/azure/architecture/microservices/design/gateway) solutions combined with microservices may be sufficient for some cases where BFFs were previously recommended.

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

This example shows the Backend for Frontends pattern where you have two distinct client applications: a mobile app and a desktop application. Both clients interact with an Azure API Management (data plane gateway), which acts as an abstraction layer, handling common cross-cutting concerns such as:

**Authorization** – Ensuring only verified identities with the proper access tokens can call protected resources using the Azure API Management (APIM) with Microsoft Entra ID.
**Monitoring** – Capturing and sending request and response details for observability purposes to Azure Monitor.
**Request Caching** – Optimizing repeated requests by serving responses from cache using APIM built-in features.
**Routing & Aggregation** – Directing incoming requests to the appropriate Backend for Frontend (BFF) services.

Each client has a dedicated BFF service running as an Azure Function that serve as an intermediary between the gateway and the underlying microservices. These client-specif BFF ensures a tailored experience for pagination among other functionalities. While the mobile is more bandwidth-conscious app and caching improves performance, the desktop aggregates multiple pages in a single request, optimizing for a richer user experience.

![Azure BFF architecture with Azure API Management handling cross-cutting concerns; mobile and desktop fetch data using client-specific BFF Azure Functions](./_images/bff-example.png)

#### Flow A: Mobile Client – First Page Request

1. The mobile client sends a `GET` request for the page `1` including the OAuth 2.0 token in the authorization header.
1. The request reaches the Azure APIM Gateway, which intercepts it and:
   1. Checks authorization status – APIM implements defense in depth, so it checks the validity of the access token.
   1. Stream the request activity as logs to Azure Monitor – Details of the request are recorded for auditing and monitoring.
1. The policies are enforced, then Azure APIM routes the request to the Azure Function Mobile BFF.
1. The Azure Function Mobile BFF then interacts with the necessary microservices to fetch a single page and process the requested data to provide with a lightweight experience.
1. The response is returned to the client.

#### Flow B: Mobile Client – First Page Cached Request
1. The mobile client sends the same `GET` request for the page `1` again including the OAuth 2.0 token in the authorization header.
1. The Azure APIM Gateway recognizes that this request was made before and:
   1. The policies are enforced, and after that it identifies a cached response matching the request parameters.
   1. Returns the cached response immediately, eliminating the need to forward the request to the Azure Function Mobile BFF.

#### Flow C: Desktop Client – First Request
1. The desktop client sends a `GET` request for the first time including the OAuth 2.0 token in the authorization header.
1. The request reaches the Azure APIM Gateway, where similar cross-cutting concerns are handled:
   1. Authorization – token validation is always required.
   1. Stream the request activity – Request details are recorded for observability.
1. Once all policies were enforced, Azure APIM routes the request to the Azure Function Desktop BFF, which is responsible for handling data-heavy application processing. The Desktop BFF aggregates multiple requests using underlying microservices calls before responding to the client with a multiple page response.

### Design

- [Microsoft Entra ID](/entra/fundamentals/whatis) serves as the cloud-based Identity Provider, issuing tailored audience claims for both mobile and desktop clients, which are subsequently leveraged for authorization.
- [Azure API Management](/azure/well-architected/service-guides/api-management/operational-excellence) acts as proxy between the clients and their BBFs adding a perimeter. It is configured with policies to [validate the JSON Web Tokens(JWTs)](/azure/api-management/validate-jwt-policy), rejecting requests that arrive without a token or the claims aren't valid for the targeted BFF. Additionally it streams all the activity logs to Azure Monitor.
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
