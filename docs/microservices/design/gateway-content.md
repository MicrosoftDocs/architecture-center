In a microservices architecture, a client might interact with more than one front-end service. Given this fact, how does a client know what endpoints to call? What happens when new services are introduced, or existing services are refactored? How do services handle SSL termination, mutual TLS, authentication, and other concerns? An *API gateway* can help to address these challenges.

![Diagram of an API gateway](../images/gateway.png)

*Download a [Visio file](https://arch-center.azureedge.net/gateway.vsdx) of this architecture.*

## What is an API gateway?

An API gateway provides a centralized entry point for managing interactions between clients and application services. It acts as a reverse proxy and routes clients requests to the appropriate services. It can also perform various cross-cutting tasks such as authentication, SSL termination, mutual TLS, and rate limiting.

## Why use an API gateway?

An API gateway simplifies communication, enhances client interactions, and centralizes the management of common service-level responsibilities. It acts as an intermediary, and it prevents direct exposure of application services to clients. Without an API gateway, clients must communicate directly with individual application services, which can introduce the following challenges:

- **Complex client code**: It can result in complex client code. Clients must track multiple endpoints and handle failures resiliently.

- **Tight coupling**: It creates coupling between the client and the backend. Clients need to understand decomposition of individual services, complicating service maintenance and refactoring.

- **Increased latency**: A single operation might require calls to multiple services. The result can be multiple network round trips between the client and the server, adding significant latency.

- **Redundant handling of concerns**: Each public-facing service must handle concerns such as authentication, SSL, and client rate limiting.

- **Protocol limitations**: Services must expose a client-friendly protocol such as HTTP or WebSocket. This exposure limits [communication protocols](./interservice-communication.yml) options.

- **Expanded attack surface**: Public endpoints increase the potential attack surface and require hardening.

## How to use an API gateway

An API gateway can be tailored to your application’s requirements by using specific design patterns. These design patterns address key functionality such as routing, request aggregation, and cross-cutting concerns:

- [Gateway routing](../../patterns/gateway-routing.yml). You can use an API gateway as a reverse proxy to route client requests to different application services. The API gateway uses layer-7 routing and provides a single endpoint for clients to use. Use API gateway routing when you want to decouple clients from application services.

- [Gateway aggregation](../../patterns/gateway-aggregation.yml). You can use the API gateway to aggregate multiple client requests into a single request. Use this pattern when a single operation requires calls to multiple application services. In API aggregation, the client sends one request to the API gateway. Then, the API gateway routes requests to the various services required for the operations. Finally, the API gateway aggregates the results and sends them back to the client. The aggregation helps reduce chattiness between the client and the application services.

- [Gateway offloading](../../patterns/gateway-offloading.yml). You can use an API gateway to provide cross-cutting functionality, so individual services don't have to provide it. It can be useful to consolidate cross-cutting functionality into one place, rather than making every service responsible. Here are examples of functionality that you could offload to an API gateway:

  - SSL termination
  - Mutual TLS
  - Authentication
  - IP allowlist or blocklist
  - Client rate limiting (throttling)
  - Logging and monitoring
  - Response caching
  - Web application firewall
  - GZIP compression
  - Servicing static content

## API gateway options

Here are some options for implementing an API gateway in your application.

- **Reverse proxy server**. Nginx and HAProxy are open-source reverse proxy offerings. They support features such as load balancing, SSL termination, and layer-7 routing. They have free versions and paid editions that provide extra features and support options. These products are mature with rich feature sets, high performance, and extensible.

- **[Service mesh ingress controller](/azure/aks/servicemesh-about/)**. If you use a service mesh, evaluate the ingress controller’s features specific to that service mesh. Check for AKS-supported add-ons like Istio and Open Service Mesh. Look for third-party open-source projects like Linkerd or Consul Connect. For example, the Istio ingress controller supports layer 7 routing, HTTP redirects, retries, and other features.

- **[Azure Application Gateway](/azure/application-gateway/)**. Application Gateway is a managed load balancing service. It provides perform layer-7 routing, SSL termination, and a web application firewall (WAF).

- **[Azure Front Door](/azure/frontdoor/front-door-overview)**. Azure Front Door is a content delivery network (CDN). It uses global and local points of presence (PoPs) to provide fast, reliable, and secure access to your applications' static and dynamic web content globally.

- **[Azure API Management](/azure/api-management/)**. API Management is a managed solution for publishing APIs to external and internal customers. It provides features to manage public-facing APIs, including rate limiting, IP restrictions, and authentication using Microsoft Entra ID or other identity providers. API Management doesn't perform any load balancing, so you should use it with a load balancer, such as Azure Application Gateway, or a reverse proxy. For more information, see [API Management with Azure Application Gateway](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway).

## Choose an API gateway technology

When selecting an API gateway, consider the following factors:

- **Support all requirements.**  Choose an API gateway that supports your required features. All the previous [API gateway options](#api-gateway-options) support layer-7 routing. But their support for other features, such as authentication, rate limiting, and SSL termination, can vary. Assess whether a single gateway meets your needs or if multiple gateways are necessary.

- **Prefer built-in offerings.** Use built-in API gateway and ingress solutions provided by your platform, such as Azure Container Apps and AKS, whenever they meet your security and control requirements. Only use a custom gateway if the built-in options lack necessary flexibility. Custom solutions require a governance model, such as GitOps, to manage its lifecycle effectively.

- **Choose the right deployment model.** Use managed services like Azure Application Gateway and Azure API Management for reduced operational overhead. If you use general-purpose reverse proxies or load balancers, deploy them in a way that aligns with your architecture. You can deploy general-purpose API gateways to dedicated virtual machines or inside an AKS cluster in their Ingress Controller offerings. To isolate the API gateway from the workload, you can deploy them outside the cluster, but this deployment increases the management complexity.

- **Manage changes.** When you update services or add new ones, you might need to update the gateway routing rules.  Implement processes or workflows to manage routing rules when adding or modifying services, SSL certificates, IP allowlists, and security configurations. Use infrastructure-as-code and automation tools to streamline API gateway management.

## Next steps

Previous articles explored the interfaces *between* microservices and between microservices and client applications. These interfaces treat each service as a self-contained, opaque unit. A critical principle of microservices architecture is that services should never expose internal details about how they manage data. This approach has significant implications for maintaining data integrity and consistency, which is the subject of the next article.

> [!div class="nextstepaction"]
> [Data considerations for microservices](./data-considerations.md)

## Related resources

- [Design APIs for microservices](api-design.md)
- [Design a microservices architecture](index.md)
- [Using domain analysis to model microservices](../model/domain-analysis.md)
- [Microservices assessment and readiness](../../guide/technology-choices/microservices-assessment.md)
