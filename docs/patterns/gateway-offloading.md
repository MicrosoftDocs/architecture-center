---
title: Gateway Offloading Pattern
description: Centralize shared capabilities, such as TLS termination and authentication, in a gateway to simplify backend services.
author: claytonsiemens77 
ms.author: pnp
ms.date: 09/23/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Gateway Offloading pattern

Offload shared or specialized service functionality to a gateway proxy. This approach simplifies application development by centralizing cross-cutting concerns, such as client-facing TLS certificate termination, in the gateway instead of duplicating them across services.

When multiple services share responsibilities such as authentication, monitoring, or protocol translation, consolidating those concerns into a single gateway reduces per-service configuration overhead and deployment risk.

## Context and problem

Some features are commonly used across multiple services, and these features require configuration, management, and maintenance. A shared or specialized service that you distribute with every application deployment adds administrative overhead and increases the likelihood of deployment error. You must deploy any updates to a shared feature across all services that share that feature.

Security issues such as token validation, encryption, and TLS certificate management can require team members to have highly specialized skills. For example, without a gateway, you might need to configure and deploy a client-facing certificate on every application instance. You must track its expiration and update, test, and verify it across those instances.

Other common services such as authentication, authorization, logging, monitoring, or [throttling](./throttling.md) can be difficult to implement and manage across a large number of deployments. Consolidating this type of functionality reduces overhead and the chance of errors.

## Solution

Offload some capabilities into a gateway. The gateway then handles cross-cutting concerns such as client-facing certificate management, authentication, TLS termination, monitoring, protocol translation, and throttling on behalf of backend services.

The following diagram shows a gateway that terminates inbound TLS connections and applies shared capabilities. The gateway validates the backend certificate and re-encrypts traffic over a separate TLS connection to the backend service.

:::image type="complex" source="./_images/gateway-offload-tls.svg" alt-text="Diagram of a client connecting to a gateway over TLS." border="false" lightbox="./_images/gateway-offload-tls.svg":::
    The diagram shows a left-to-right TLS flow. A client on the left sends a TLS connection to a gateway proxy in the center. In the gateway box, four actions are listed: terminate client TLS, apply shared capabilities, validate the backend certificate, and re-encrypt traffic to the backend. Three arrows start from the gateway and connect to backend service 1 at the upper right, backend service 2 at the middle right, and backend service 3 at the lower right. Each backend is labeled HTTPS, and the gateway-to-backend path is labeled as a new TLS connection.
:::image-end:::

Benefits of this pattern include:

- Simplify the development of services by centralizing shared configuration, such as authentication, throttling, and request logging, instead of implementing it in each backend service. Centralization improves consistency and makes service upgrades more straightforward.

- Allow dedicated teams to implement features that require specialized expertise, such as security. Your core team can then focus on application functionality, leaving these specialized but cross-cutting concerns to the relevant experts.

- Provide some consistency for request and response logging and monitoring. Even if a service isn't correctly instrumented, the gateway can provide a baseline level of monitoring and logging.

- Centralize carbon-aware traffic management. A gateway can adjust caching, rate limiting, and logging behaviors based on real-time carbon intensity signals. Azure API Management provides these capabilities in limited preview, in select regions and classic tiers (Developer, Basic, Standard, and Premium). For availability and configuration details, see [Environmentally sustainable APIs in Azure API Management](/azure/api-management/sustainability).

## Problems and considerations

Consider the following points when you decide how to implement this pattern:

- **High availability and resilience.** Ensure the gateway is highly available and resilient to failure. Avoid single points of failure by running multiple instances of your gateway. Because the gateway terminates client connections and can buffer request bodies, consider how in-flight requests are handled during instance failures. Use connection draining or graceful shutdown mechanisms so that removing or restarting a gateway instance doesn't drop active sessions.

- **Capacity and scaling.** Ensure the gateway is designed for the capacity and scaling requirements of your application and endpoints. Make sure the gateway doesn't become a bottleneck for the application and is sufficiently scalable. The gateway must be provisioned to handle peak traffic bursts, not just average load. Under-provisioning the gateway to reduce cost directly degrades performance for every service behind it.

- **Offloading scope.** Offload features shared by multiple services or routes when centralizing them reduces duplicated implementation and management.

- **Business logic separation.** Never offload business logic to the gateway.

- **Transaction tracking.** If you need to track transactions, consider generating correlation IDs for logging purposes.

- **Latency overhead.** The gateway adds a network hop to every request. Each offloaded function that the gateway performs, such as TLS termination, authentication, or request inspection, adds processing time to the request path. Gateway connection pooling and keep-alive connections to backend services can partially offset the latency cost by reusing connections rather than establishing new ones for each request. Evaluate whether the combined latency of the gateway hop and the offloaded functions is acceptable for the workload's performance targets.

- **Operational complexity.** A centralized gateway consolidates management but also concentrates operational responsibility. You must manage the gateway configuration, certificate lifecycle, policy updates, and version upgrades as a shared concern. Ensure the team responsible for the gateway has the capacity and tooling to manage it at the scale of all services that depend on it.

- **Security implications.** The gateway is a high-value target because it centralizes cross-cutting security functions such as authentication, TLS termination, and request inspection. A compromise of the gateway can expose all downstream services. Harden the gateway, restrict its management surface, and monitor it for anomalous behavior independently from the backend services it protects.

- **Gateway bypass prevention.** Configure backend services to accept requests only through the intended gateway path. Otherwise, clients can connect directly to a backend and bypass authentication, throttling, request inspection, and logging at the gateway.

- **Identity propagation.** Define whether each backend authorizes the original caller, the gateway's workload identity, or both. Preserve caller tokens or trusted claims only when the backend requires delegated user context. Always authenticate the gateway to the backend separately. Don't treat unverified forwarded headers as proof of identity.

- **TLS maintenance.** If the gateway terminates TLS, reestablish TLS to the backend. Don't forward traffic over unencrypted HTTP. Treat all networks as untrusted. This topology still requires a process to issue, rotate, and revoke backend certificates.

- **Forwarded headers and client context.** When the gateway terminates client connections and establishes new connections to backend services, information such as the client IP address, original protocol, and host name is lost unless the gateway explicitly forwards it. For mitigation strategies, see [Preserve the original HTTP host name between a reverse proxy and its back-end web application](/azure/architecture/best-practices/host-name-preservation).

## When to use this pattern

Use this pattern when:

- An application deployment has a shared concern such as TLS certificates or encryption.
- A feature common across application deployments might have different resource requirements, such as memory resources, storage capacity, or network connections.
- You want to move the responsibility for issues such as network security, throttling, or other network boundary concerns to a more specialized team.

This pattern might not be suitable when:

- The gateway must contain service-specific logic or routing rules that tightly couple backend service changes to gateway configuration changes. Coupling the gateway tier with internal services means that backend updates can force gateway redeployment, reducing deployment independence.
- The offloaded concern is lightweight and the workload is latency-sensitive. The additional network hop through the gateway might not be justified when the overhead outweighs the benefit of centralization.
- Centralizing concerns into a shared gateway creates a change-management bottleneck. If the gateway team's release cycle is slower than the service teams', offloading can delay updates to certificates, authentication policies, or network rules.

## Workload design

An architect should evaluate how the Gateway Offloading pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | Offloading this responsibility to a gateway reduces the complexity of application code on backend nodes. In some cases, offloading completely replaces functionality with a reliable platform-provided feature.<br/><br/> - [RE:01 Simplicity and efficiency](/azure/well-architected/reliability/simplify) |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | Adding a gateway into the request flow enables you to centralize controls such as web application firewalls and client TLS policies. Any offloaded functionality that's platform-provided already offers enhanced security.<br/><br/> - [SE:06 Network controls](/azure/well-architected/security/networking)<br/> - [SE:08 Hardening resources](/azure/well-architected/security/harden-resources) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) focuses on **sustaining and improving** your workload's **return on investment**. | This pattern enables you to redirect costs from resources that would be spent per-node into the gateway implementation. Costs in the centralized processing model are frequently lower than those of the distributed model.<br/><br/> - [CO:14 Consolidation](/azure/well-architected/cost-optimization/consolidation) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | In this pattern, the configuration and upkeep of the offloaded functionality are associated with a single point instead of requiring management from multiple nodes. This centralization standardizes how cross-cutting concerns are applied, making routine and ad-hoc operational changes consistent and predictable.<br/><br/> - [OE:02 Standardize operations](/azure/well-architected/operational-excellence/formalize-operations-tasks) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | Adding an offloading gateway to the request process enables you to use less resources per node because functionality is centralized at the gateway. You can optimize the implementation of the offloaded functionality independently of the application code. Offloaded platform-provided functionality is already likely to be highly performant.<br/><br/> - [PE:03 Selecting services](/azure/well-architected/performance-efficiency/select-services) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

Azure Application Gateway WAF_v2 can implement this pattern for a regional web application. The gateway terminates client TLS connections, applies WAF and routing policies, and establishes new TLS connections to the backend services. This design keeps shared request-processing concerns out of the backend application code.

### Application Gateway with TLS offloading

The following diagram shows how Application Gateway terminates inbound TLS connections, inspects and filters the traffic, and re-encrypts it before forwarding it to a backend pool over TLS.

:::image type="complex" source="./_images/gateway-offload-application-gateway.svg" alt-text="Diagram that shows Application Gateway terminating inbound TLS from clients, applying WAF and routing rules, and re-encrypting traffic over TLS to a backend pool." border="false" lightbox="./_images/gateway-offload-application-gateway.svg":::
    The diagram shows a left-to-right flow. A client on the left sends an HTTPS request over a TLS-encrypted connection to an Application Gateway WAF_v2 box in the center. In the Application Gateway box, the following items are listed: an HTTPS listener on port 443, a TLS certificate, a WAF policy, and a routing rule. These items are followed by backend HTTP settings that use HTTPS on port 443 and validate certificate trust and hostname. Three arrows connect from the gateway over re-encrypted TLS and connect to backend server 1 at the upper right, backend server 2 at the middle right, and backend server 3 at the lower right. The three HTTPS servers form the backend pool.
:::image-end:::

This architecture uses the following Application Gateway components to offload shared capabilities and re-encrypt backend traffic:

- **HTTPS listener.** An HTTPS listener on port 443 accepts inbound TLS connections from clients.
- **TLS certificate.** A PFX certificate, sourced from [Azure Key Vault](/azure/application-gateway/key-vault-certs), is attached to the HTTPS listener. Application Gateway decrypts inbound traffic to inspect and route it, then re-encrypts it to the backend pool. Backend servers still need certificates for the re-encrypted connections, but in many cases platform-managed certificates can be used.
- **Backend pool.** A backend pool defines the set of HTTPS servers that receive the re-encrypted traffic. Backend targets can be virtual machines, Azure Virtual Machine Scale Sets, IP addresses, or Azure App Service instances. Restrict backend access so that clients can't bypass Application Gateway and its WAF policy by connecting directly.
- **Backend HTTP settings.** Set the backend protocol to HTTPS and the port to the backend's TLS port, such as 443. Configure certificate trust and a hostname that matches the backend certificate. For a private certificate authority, configure the trusted root certificate. For details, see [End-to-end TLS with the v2 SKU](/azure/application-gateway/ssl-overview#end-to-end-tls-with-the-v2-sku).
- **Routing rule.** A request routing rule associates the listener with the backend pool and backend HTTP settings. Path-based rules can route different URL paths to different backend pools.
- **WAF policy.** The policy defines the managed and custom rules used to inspect requests, including any Geomatch rules.

Because Application Gateway decrypts the traffic, it can inspect request content for intelligent routing, rewrite HTTP headers and URLs, and apply WAF rules. It then re-encrypts the traffic before forwarding requests to the backend.

For configuration guidance, see [End-to-end TLS encryption with Application Gateway](/azure/application-gateway/ssl-overview#end-to-end-tls-encryption).

## Supporting technologies

The following Azure services can help you implement this pattern:

- Use [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) for regional web traffic.

- Use [Azure Application Gateway for Containers](/azure/application-gateway/for-containers/overview) for Kubernetes-native ingress to AKS workloads.

- Use [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) for global or multiregion web traffic.

- Use [Azure API Management](/azure/well-architected/service-guides/azure-api-management) for API-specific concerns like authentication, throttling, transformation, and monitoring.

## Next steps

- [Load balancing options](../guide/technology-choices/load-balancing-overview.md)
- [Use API gateways in microservices](../microservices/design/gateway.yml)

## Related resources

- [Backends for Frontends pattern](./backends-for-frontends.md)
- [Gateway Aggregation pattern](./gateway-aggregation.md)
- [Gateway Routing pattern](./gateway-routing.yml)
- [Throttling pattern](./throttling.md)
- [Protect APIs by using Application Gateway and API Management](/azure/architecture/web-apps/api-management/architectures/protect-apis)
