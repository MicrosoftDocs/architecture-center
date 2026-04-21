Protect applications and services by using a dedicated host instance to broker requests between clients and the application or service. The broker validates and sanitizes the requests, and can provide an additional layer of security and limit the system's attack surface.

## Context and problem

Cloud services expose endpoints that allow client applications to call their APIs. The code used to implement the APIs triggers or performs several tasks, including but not limited to authentication, authorization, parameter validation, and some or all request processing. The API code is likely to access storage and other services on behalf of the client.

If a malicious user compromises the system and gains access to the application's hosting environment, its security mechanisms and access to data and other services are exposed. As a result, the malicious user can gain unrestricted access to credentials, storage keys, sensitive information, and other services.

## Solution

One solution to this problem is to decouple the code that implements public endpoints from the code that processes requests and accesses storage. You can achieve this by using a façade tier that interacts with clients and then hands off approved requests&mdash;through an internal endpoint, queue, or broker&mdash;to the workload components that handle the business operation. The figure provides a high-level overview of this pattern.

![High-level overview of this pattern](./_images/gatekeeper-diagram.png)

The gatekeeper pattern can be used to protect storage, or it can be used as a more comprehensive façade to protect all of the functions of the application. The important factors are:

- **Controlled validation**. The gatekeeper validates all requests, and rejects requests that don't meet validation requirements.
- **Limited risk and exposure**. The gatekeeper doesn't have access to the credentials or keys used by the trusted host to access storage and services. If the gatekeeper is compromised, the attacker doesn't get access to these credentials or keys.
- **Appropriate security**. The gatekeeper runs in a limited privilege mode, while the rest of the application runs in the full trust mode required to access storage and services. If the gatekeeper is compromised, it can't directly access the application services or data.

This pattern acts like a firewall in a typical network topography. It allows the gatekeeper to examine requests and make a decision about whether to pass the request on to the trusted host that performs the required tasks. This decision typically requires the gatekeeper to validate and sanitize the request content before passing it on to the trusted host.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Ensure that the trusted hosts expose only internal or protected endpoints, used only by the gatekeeper. The trusted hosts shouldn't expose any external endpoints or interfaces.
- The gatekeeper must run in a limited-privilege mode. In practice, host the gatekeeper and trusted backend on separate compute boundaries, and keep backend endpoints private.
- The gatekeeper shouldn't perform any processing related to the application or services or access any data. Its function is purely to validate and sanitize requests. The trusted hosts might need to perform additional request validation, but the gatekeeper should perform the core validation.
- Use a secure communication channel (HTTPS, SSL, or TLS) between the gatekeeper and the trusted hosts or tasks where possible. However, some hosting environments don't support HTTPS on internal endpoints.
- Adding the extra layer to implement the gatekeeper pattern will likely affect performance due to the additional processing and network communication required.
- The gatekeeper instance could be a single point of failure. To minimize the impact of a failure, consider deploying redundant instances and using an autoscaling mechanism to ensure capacity to maintain availability.

## When to use this pattern

Use this pattern when:

- You handle sensitive information.
- You expose services that require strong protection from malicious traffic.
- You perform mission-critical operations that can't tolerate direct exposure of backend services.
- You need request validation and sanitization to be separated from core business processing.

This pattern might not be suitable when:

- You can satisfy security and validation requirements through built-in platform controls on the backend service without adding a dedicated gatekeeper tier.
- Added network hops and validation latency would violate strict end-to-end latency requirements.

## Workload design

An architect should evaluate how the Gatekeeper pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Security](/azure/well-architected/security/checklist) design decisions help ensure the **confidentiality**, **integrity**, and **availability** of your workload's data and systems. | Adding a gateway into the request flow enables you to centralize security functionality like web application firewalls, DDoS protection, bot detection, request manipulation, authentication initiation, and authorization checks.<br/><br/> - [SE:06 Network controls](/azure/well-architected/security/networking)<br/> - [SE:10 Monitoring and threat detection](/azure/well-architected/security/monitor-threats) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This pattern is how you can implement throttling at a gateway level rather than implementing rate checks at the node level. Coordinating rate state among all nodes isn't inherently performant.<br/><br/> - [PE:03 Selecting services](/azure/well-architected/performance-efficiency/select-services) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

The gatekeeper pattern is often implemented as a layered request path where each layer has a specific responsibility and limited trust scope:

```text
Client
       ↓
Application Gateway (WAF)
       ↓
API Management (APIM)
       ↓
Backend services (private)
```

In this design, [Azure Application Gateway with Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) is the outer gatekeeper. It inspects internet-facing traffic and applies security controls before traffic reaches the API tier. [Azure API Management](/azure/api-management/api-management-key-concepts) is the inner gatekeeper. It applies API-specific controls and forwards only approved traffic to private backends.

For example, WAF can detect and block SQL injection and cross-site scripting patterns, enforce protocol and request-size rules, and apply bot and IP-based filtering before requests reach APIM or private backends.

When APIM is used in the inner layer, it applies policies to inbound requests and outbound responses in the gateway pipeline. See [Policies in Azure API Management](/azure/api-management/api-management-howto-policies) for the inbound/backend/outbound model, and [API Management policy reference](/azure/api-management/api-management-policies) for policy options such as JWT validation, rate limiting, header transformation, and response shaping.

Use [managed identities for Azure resources](/entra/identity/managed-identities-azure-resources/overview) consistently for service-to-service authentication in this path. For example, APIM can use the [Authenticate with managed identity policy](/azure/api-management/authentication-managed-identity-policy) to get Microsoft Entra tokens for backend calls without storing secrets.

The backend remains private. For example, the backend can be an [Azure App Service](/azure/app-service/overview) app that uses a [private endpoint](/azure/app-service/overview-private-endpoint), so the app can be accessed privately.

For containerized workloads, an alternative can replace the APIM plus App Service inner path with ingress-based compute:

- [Azure Kubernetes Service (AKS)](/azure/aks/concepts-network-ingress#compare-ingress-options), where you have more control over ingress controller choice, Kubernetes policies, network topology, and cluster operations.
- [Azure Container Apps](/azure/container-apps/overview), a serverless managed container platform with [ingress capabilities](/azure/container-apps/ingress-overview) and reduced infrastructure management.

In these alternatives, ingress can route by host or path, terminate TLS, and expose internal-only services. Specific capabilities such as request limits and allow or deny rules depend on the selected ingress implementation. In all cases, keep the gatekeeper boundaries: apply validation and policy enforcement at ingress, and keep backend services reachable only through that gatekeeper path.

Each layer in this path emits logs and metrics that you should centralize. WAF diagnostic logs record matched and blocked rules per request. APIM emits gateway logs that capture request duration, response codes, and policy outcomes. Backend services emit application-level telemetry. Collect all of this in [Azure Monitor](/azure/azure-monitor/overview) and route it to a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-overview) for unified querying. Use [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) to surface security recommendations across the gatekeeper components, and configure alerts on anomalous WAF block rates or APIM error spikes to detect threats before they reach private backends.

## Next steps

The following guidance might be relevant when implementing this pattern:

- [What is Azure Web Application Firewall on Azure Application Gateway?](/azure/web-application-firewall/ag/ag-overview)
- [Policies in Azure API Management](/azure/api-management/api-management-howto-policies)
- [Use private endpoints for Azure App Service apps](/azure/app-service/overview-private-endpoint)

## Related resources

The following cloud design patterns are often used together with the Gatekeeper pattern:

- [Gateway Routing pattern](./gateway-routing.yml)
- [Gateway Offloading pattern](./gateway-offloading.yml)
- [Federated Identity pattern](./federated-identity.yml)
- [Valet Key pattern](./valet-key.yml)
