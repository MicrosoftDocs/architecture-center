---
title: Gatekeeper Pattern
description: Learn how to use the Gatekeeper pattern to protect applications and services by using a dedicated host instance as a broker to validate requests and data.
author: claytonsiemens77
ms.author: pnp
ms.date: 06/01/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Gatekeeper pattern

Protect applications and services by using a dedicated component to broker requests between clients and the application or service. The broker validates and sanitizes the requests, and can provide an extra layer of security and limit the system's attack surface.

## Context and problem

Many cloud services expose endpoints that allow client applications to call their APIs across the internet or another untrusted network. The code that implements the APIs triggers or performs several tasks, including but not limited to authentication, authorization, parameter validation, and some or all request processing. The API code is likely to access storage and other services on the client's behalf.

If a malicious user compromises the system and gains access to the application's hosting environment, its security mechanisms and access to data and other services are exposed. As a result, the malicious user can gain unrestricted access to credentials, storage keys, sensitive information, and other services.

## Solution

One solution to this problem is to decouple the code that implements public endpoints from the code that processes requests and accesses storage. Decouple the code by using a façade tier that interacts with clients and routes approved requests through an internal endpoint, queue, or broker to the workload components that handle the business operation. The diagram provides a high-level overview of this pattern.

:::image type="complex" border="false" source="./_images/gatekeeper-diagram.png" alt-text="Diagram that shows a high-level overview of the Gatekeeper pattern." lightbox="./_images/gatekeeper-diagram.png":::
   The diagram shows client, gatekeeper, trusted host or key master, services, and data sections. The gatekeeper exposes endpoints to clients, then validates and sanitizes requests. The gatekeeper might then be decoupled from the trusted host or hosts. The trusted host accesses service and storage.
:::image-end:::

You can use the Gatekeeper pattern to protect storage, or you can use it as a more comprehensive façade to protect all of the functions of the application. Important factors include:

- **Controlled validation:** The gatekeeper validates all requests, and rejects requests that don't meet validation requirements.

- **Limited risk and exposure:** Risks and exposure are reduced because the gatekeeper doesn't access the credentials or keys that the trusted host uses to access storage and services. If the gatekeeper becomes compromised, attackers can't access these credentials or keys.

- **Appropriate security:** The gatekeeper runs in a limited privilege mode, while the rest of the application runs in the full trust mode required to access storage and services. If the gatekeeper is compromised, it can't directly access the application services or data.

This pattern acts like a firewall in a typical network topography. Unlike a traditional firewall, it allows the gatekeeper to examine requests in detail and make an application-driven decision about whether to pass the request to the trusted host that performs the required tasks. This decision typically requires the gatekeeper to validate and sanitize the request content before it passes it to the trusted host. Gatekeepers might authorize the request, look for unexpected or invalid payload content, perform rate limiting, and perform various other checks.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Ensure that the trusted hosts expose only internal or protected endpoints that only the gatekeeper uses. The trusted hosts shouldn't expose any external endpoints or interfaces.

- The gatekeeper must run in a limited-privilege mode. In practice, host the gatekeeper and trusted back end on separate compute boundaries, and keep back-end endpoints private.

- The gatekeeper shouldn't perform processing related to the application or services or access data. Its function is solely to validate and sanitize requests. The trusted hosts might need to perform extra request validation, but the gatekeeper should perform the core validation.

- Use a secure communication channel like HTTPS, Secure Sockets Layer (SSL), or Transport Layer Security (TLS) between the gatekeeper and the trusted hosts or tasks where possible. However, some hosting environments don't support HTTPS on internal endpoints.

- Adding the extra layer to implement the Gatekeeper pattern is likely to affect performance because of the extra processing and network communication required.

- The gatekeeper can be a single point of failure (SPoF). To minimize the impact of a failure, consider deploying redundant instances and using an autoscaling mechanism to ensure capacity and maintain availability.

## When to use this pattern

Use this pattern when:

- You handle sensitive information.

- You expose services that require strong protection from malicious traffic.

- You perform mission-critical operations that can't tolerate direct exposure of back-end services.

- You need request validation and sanitization to be separated from core business processing.

This pattern might not be suitable when:

- You can satisfy security and validation requirements through built-in platform controls on the back-end service without adding a dedicated gatekeeper tier.

- Added network hops and validation latency violate strict end-to-end latency requirements.

## Workload design

Evaluate how to use the Gatekeeper pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | A gatekeeper in the request flow helps you centralize security functionality like web application firewalls, DDoS protection, bot detection, request manipulation, authentication initiation, and authorization checks.<br/><br/> - [SE:06 Network controls](/azure/well-architected/security/networking)<br/> - [SE:10 Monitoring and threat detection](/azure/well-architected/security/monitor-threats) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | You can use this pattern to implement throttling at a gatekeeper level rather than implement rate checks at the node level. Rate state coordination among all nodes isn't inherently performant.<br/><br/> - [PE:03 Select services](/azure/well-architected/performance-efficiency/select-services) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The Gatekeeper pattern typically implements a layered request path, where each layer has a specific responsibility and a limited trust scope.

:::image type="complex" border="false" source="./_images/gatekeeper-example.svg" alt-text="Diagram that shows the layered Gatekeeper pattern." lightbox="./_images/gatekeeper-example.svg":::
   Users connect to Azure Application Gateway, which is in a virtual network, via a public IP. The virtual network includes Application Gateway, Azure API Management, a private endpoint, and three subnets. An arrow points from Application Gateway to API Management, from API Management to the private endpoint, and from the private endpoint to Azure App Service. Azure Monitor is below App Service.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/gatekeeper.vsdx) of this architecture.*

In this design, [Azure Application Gateway with Azure Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) is the outer gatekeeper. It inspects internet-facing traffic and applies security controls before traffic reaches the API tier. [Azure API Management](/azure/api-management/api-management-key-concepts) is the inner gatekeeper. It applies API-specific controls and forwards only approved traffic to private back ends.

For example, Azure Web Application Firewall can detect and block SQL injection and cross-site scripting patterns, enforce protocol and request-size rules, and apply bot and IP-based filtering before requests reach API Management or private back ends.

When you use API Management in the inner layer, it applies policies to inbound requests and outbound responses in the gateway pipeline. For more information about how API Management processes requests and responses, see [Policies in API Management](/azure/api-management/api-management-howto-policies). For policy options such as JSON Web Token (JWT) validation, rate limiting, header transformation, and response shaping, see [API Management policy reference](/azure/api-management/api-management-policies).

Use [managed identities for Azure resources](/entra/identity/managed-identities-azure-resources/overview) consistently for service-to-service authentication in this path. For example, API Management can use the [authenticate with managed identity policy](/azure/api-management/authentication-managed-identity-policy) to get Microsoft Entra tokens for back-end calls without storing secrets.

The back end remains private. For example, the back end can be an [Azure App Service](/azure/app-service/overview) app that uses a [private endpoint](/azure/app-service/overview-private-endpoint), so the app can be accessed privately.

For containerized workloads, an alternative can replace the API Management plus App Service inner path with ingress-based compute:

- [Azure Kubernetes Service (AKS)](/azure/aks/concepts-network-ingress#compare-ingress-options), which gives you more control over ingress controller choice, Kubernetes policies, network topology, and cluster operations.

- [Azure Container Apps](/azure/container-apps/overview), which is a serverless managed container platform that provides [ingress capabilities](/azure/container-apps/ingress-overview) and reduces infrastructure management.

In these alternatives, ingress can route by host or path, terminate TLS, and expose internal-only services. Specific capabilities such as request limits and allow or deny rules depend on the selected ingress implementation. In all cases, keep the gatekeeper boundaries: apply validation and policy enforcement at ingress, and keep back-end services reachable only through that gatekeeper path.

Each layer in this path emits logs and metrics that you should centralize. Azure Web Application Firewall diagnostic logs record matched and blocked rules per request. API Management emits gateway logs that capture request duration, response codes, and policy outcomes. Back-end services emit application-level telemetry. Collect these logs and metrics in [Azure Monitor](/azure/azure-monitor/fundamentals/overview) and route them to a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-overview) for unified querying. Standardize end-to-end request correlation by generating or forwarding a correlation ID at the edge and propagating it through API Management and back-end services (for example, through request headers and distributed trace context) so that a single transaction remains traceable across all layers. Use [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) to surface security recommendations across the gatekeeper components. Configure alerts on anomalous Azure Web Application Firewall block rates or API Management error spikes to detect threats before they reach private back ends.

## Next steps

The following guidance might be relevant when you implement this pattern:

- [Azure Web Application Firewall on Application Gateway](/azure/web-application-firewall/ag/ag-overview)
- [Policies in API Management](/azure/api-management/api-management-howto-policies)
- [Use private endpoints for App Service apps](/azure/app-service/overview-private-endpoint)

## Related resources

The following cloud design patterns are often used together with the Gatekeeper pattern:

- [Gateway Routing pattern](./gateway-routing.yml)
- [Gateway Offloading pattern](./gateway-offloading.yml)
- [Federated Identity pattern](./federated-identity.md)
- [Valet Key pattern](./valet-key.yml)
