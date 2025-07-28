---
title: Load-balancing options
description: Learn about Azure load-balancing services and considerations to select one for distributing traffic across multiple computing resources.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/10/2025
ms.topic: conceptual
ms.subservice: architecture-guide
---

The term *load balancing* refers to the distribution of processing across multiple computing resources. You load balance to optimize resource usage, maximize throughput, minimize response time, and prevent overloading any single resource. Load balancing can also improve availability by sharing a workload across redundant computing resources.

Azure provides various load-balancing services that you can use to distribute your workloads across multiple computing resources. These services include Azure API Management, Azure Application Gateway, Azure Front Door, Azure Load Balancer, and Azure Traffic Manager.

This article describes considerations to help you determine an appropriate load-balancing solution for your workload's needs.

## Azure load-balancing services

The following main load-balancing services are currently available in Azure:

- [API Management](/azure/api-management/api-management-key-concepts) is a managed service that you can use to publish, secure, transform, maintain, and monitor HTTP(S) APIs. It provides a gateway for your APIs and can be configured to load balance traffic across nodes in a designated load-balanced back-end pool. You can choose from three different load-balancing methods: round-robin, weighted, and priority based.

  > [!IMPORTANT]
  > API Management isn't a traditional, general-purpose load balancer. It's designed specifically for HTTP APIs, and its load balancing capabilities are optional features within its broader API management functionality. API Management is included in this article for completeness because it does provide load balancing capabilities for specific API hosting topologies. However, its primary purpose is API gateway functionality rather than load balancing.

- [Application Gateway](/azure/application-gateway/overview) is a web traffic load load balancer. It provides application delivery controller as a service and provides various Layer 7 load-balancing capabilities and web application firewall functionality. Use Application Gateway to transition traffic from public network space to your web servers hosted in private network space within a region.

- [Azure Front Door](/azure/frontdoor/front-door-overview) is an application delivery network that provides global load balancing and site acceleration for web applications. It provides Layer 7 capabilities for your application such as SSL offload, path-based routing, fast failover, and caching to improve performance and high availability.

- [Load Balancer](/azure/load-balancer/load-balancer-overview) is a high-performance, ultra-low-latency Layer 4 load-balancing service (inbound and outbound) for all UDP and TCP protocols. It's built to handle millions of requests per second while ensuring that your solution is highly available. Load Balancer is zone redundant, which ensures high availability across availability zones. It supports both a regional deployment topology and a [cross-region topology](/azure/load-balancer/cross-region-overview).

- [Traffic Manager](/azure/traffic-manager/traffic-manager-overview) is a DNS-based traffic load balancer that enables you to distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness. Because Traffic Manager is a DNS-based load-balancing service, it load balances only at the domain level. For that reason, it can't fail over as quickly as Azure Front Door, because of common challenges around DNS caching and systems not honoring DNS time-to-live (TTL) values.

> [!NOTE]
> Clustering technology, such as Azure Container Apps or Azure Kubernetes Service, contains load balancing constructs that operate mostly within the scope of their own cluster boundary. These capabilities route traffic to available application instances based on readiness and health probes. This article doesn't cover those load balancing options.

## Service categorizations

Azure load-balancing services can be categorized along two dimensions: global versus regional and HTTP(S) versus non-HTTP(S).

### Global versus regional

- **Global:** These load-balancing services distribute traffic across regional back ends, clouds, or hybrid on-premises services. They provide a single control plane that routes end-user traffic to available back ends globally. These services react to changes in service reliability or performance to maximize availability and performance. You can think of them as systems that load balance between application stamps, endpoints, or scale-units hosted across different regions or geographies.

- **Regional:** These load-balancing services distribute traffic within virtual networks across virtual machines (VMs) or zonal and zone-redundant service endpoints within a region. You can think of them as systems that load balance between VMs, containers, or clusters within a region in a virtual network.

### HTTP(S) versus non-HTTP(S)

- **HTTP(S):** These load-balancing services are [Layer 7](https://www.iso.org/ics/35.100.70/x/) load balancers that accept only HTTP(S) traffic. They're designed for web applications or other HTTP(S) endpoints. Features include Secure Sockets Layer (SSL) offload, web application firewall, path-based load balancing, and session affinity.

- **Non-HTTP(S):** These load-balancing services are either [Layer 4](https://www.iso.org/ics/35.100.40/x/) Transmission Control Protocol (TCP) or User Datagram Protocol (UDP) services, or Domain Name System-based (DNS) load balancing.

The following table summarizes the Azure load-balancing services.

| Service             | Global or regional | Recommended traffic |
| :--- | :--- | :---  |
| API Management      | Regional or global | HTTP(S) APIs only   |
| Application Gateway | Regional           | HTTP(S)             |
| Azure Front Door    | Global             | HTTP(S)             |
| Load Balancer       | Regional or global | Non-HTTP(S)         |
| Traffic Manager     | Global             | Non-HTTP(S)         |

> [!NOTE]
> Traffic Manager and Load Balancer can distribute any traffic type, including HTTP(S). However, these services don't provide Layer 7 capabilities. Unlike Load Balancer, Traffic Manager doesn't handle the traffic directly. Traffic Manager uses DNS to direct clients to the appropriate endpoints.

## Decision tree for load balancing in Azure

Consider the following factors when you select a load balancing solution:

- **Traffic type:** Is it a web HTTP(S) application? Is it public facing or a private application?

- **Global versus regional:** Do you need to load balance VMs or containers within a single virtual network, or load balance scale units/deployments across regions, or both?

- **Availability:** What's the [service-level agreement](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services)?

- **Cost:** For more information, see [Azure pricing](https://azure.microsoft.com/pricing/). In addition to the cost of the service itself, consider the operational cost for managing a solution built on that service.

- **Features and limits:** What capabilities does each service support, and what are the [service limits](/azure/azure-subscription-service-limits) of each service?

The following flow chart helps you choose a load-balancing solution for your application. The flow chart guides you through a set of key decision criteria to reach a recommendation.

> [!TIP]
> You can use Azure Copilot in the Azure portal to help guide you through this decision similar to the flow chart. In Azure Copilot, enter **Help me choose a load balancer.** By answering the questions from Copilot, you can narrow down your load balancing options.

Every application has unique requirements not captured in simple decision trees. Treat this flow chart or Azure Copilot's recommendation as a starting point. Then perform a more detailed evaluation.

:::image type="complex" border="false" source="./images/load-balancing-decision-tree.png" alt-text="Diagram that shows a decision tree for load balancing in Azure." lightbox="./images/load-balancing-decision-tree.png":::
   The image shows a branched flowchart in which each path leads to a load balancing solution. The first path starts at Web application (HTTP/HTTPs), points to Internet facing application via the No arrow, then to Azure Load Balancer via another No arrow. The second path starts at Web application (HTTP/HTTPs), points to Internet facing application via the No arrow, points to Global/deployed in multiple regions via the Yes arrow, and then to Azure Load Balancer via the No arrow. The third path starts at Web application (HTTP/HTTPs), points to Internet facing application via the No arrow, points to Global/deployed in multiple regions via the Yes arrow, then to Traffic Manager + Azure Load Balancer via the Yes arrow. The fourth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Hosting only APIs via the No arrow, to API Management via the Yes arrow. The fifth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Hosting only APIs via the No arrow, to Application Gateway via the No arrow. The sixth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require SSL offload or application-layer processing per request, to Azure Front Door + Application Gateway via the Yes arrow. The seventh path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require SSL offload or application-layer processing per request, to Azure Front Door + API Management via the Only APIs arrow. The eighth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require SSL offload or application-layer processing per request, to Hosting - PaaS, IaaS, AKS via the No arrow, to Azure Front Door via the PaaS arrow. The ninth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require SSL offload or application-layer processing per request, to Hosting - PaaS, IaaS, AKS via the No arrow, to Azure Front Door + Application Gateway ingress controller via the AKS arrow. The tenth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require SSL offload or application-layer processing per request, to Hosting - PaaS, IaaS, AKS via the No arrow, to Azure Front Door + Azure Load Balancer via the IaaS VMs arrow. The eleventh path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require performance acceleration via the No arrow, to Application Gateway via the No arrow. The twelfth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require performance acceleration via the No arrow, to Do you require SSL offload or application-layer processing per request via the Yes arrow, to Azure Front Door + Application Gateway via the Yes arrow. The thirteenth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require performance acceleration via the No arrow, to Do you require SSL offload or application-layer processing per request via the Yes arrow, to Azure Front Door + API Management via the Only APIs arrow. The fourteenth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require performance acceleration via the No arrow, to Application Gateway via the No arrow. The fifteenth path starts at Web application (HTTP/HTTPs), points to Internet facing application via the Yes arrow, to Global/Deployed multiple regions via the Yes arrow, to Do you require performance acceleration via the No arrow, to Application Gateway + API Management via the Only APIs arrow.
:::image-end:::

When your workload includes several services that require load balancing, assess each service individually. An effective setup often uses more than one type of load-balancing solution. You might incorporate these solutions at different places in your workload's architecture, each that serves a unique function or role.

### Definitions

- **Web application (HTTP/HTTPS):** This designation refers to needing the capability to make a routing decision for Layer 7 data such as URL path, support the inspection of the communication payload, such as an HTTP request body, or handle Transport Layer Security (TLS) functionality.

- **Internet facing application:** Applications that are publicly accessible from the internet. As a best practice, application owners apply restrictive access policies or protect the application by setting up offerings like web application firewall and distributed denial-of-service protection.

- **Global or deployed in multiple regions:** If this load balancer should have a single, highly available control plane that routes traffic to public endpoints on your globally distributed application. This configuration can support either active-active or active-passive topologies across regions.

  > [!NOTE]
  > You can use a regional service, such as Application Gateway, to load balance across back ends that span multiple regions and control routing through a single control plane. That architecture is possible by using [cross-region Private Link](/azure/private-link/private-link-faq#can-private-endpoint-connect-to-azure-paas-resources-across-azure-regions-), global virtual network peering, or even public IP addresses of services in other regions.
  >
  > This scenario isn't the primary point of this decision.
  >
  > Using a regional resource as a router for globally distributed back ends introduces a regional single point of failure and incurs extra latency as traffic is forced through one region before going to another and then back again.

- **Platform as a service (PaaS)** provides a managed hosting environment, where you can deploy your application without needing to manage VMs or networking resources. In this case, PaaS refers to services that provide integrated load balancing within a region. For more information, see [Choose a compute service &ndash; Scalability](./compute-decision-tree.yml#scalability).

- **AKS** enables you to deploy and manage containerized applications. AKS provides serverless Kubernetes, an integrated continuous integration and continuous delivery experience, and enterprise-grade security and governance. For more information about AKS architectural resources, see [AKS architecture design](../../reference-architectures/containers/aks-start-here.md).

- **Infrastructure as a service (IaaS)** is a computing option where you provision the VMs that you need, along with associated network and storage components. IaaS applications require internal load balancing within a virtual network by using Load Balancer.

- **Application-layer processing** refers to special routing within a virtual network. Examples include path-based routing across VMs or virtual machine scale sets. For more information, see [Deploy an Application Gateway behind Azure Front Door](/azure/frontdoor/front-door-faq#when-should-i-deploy-an-application-gateway-behind-front-door-).

- **Only APIs** refers to the need to load balance HTTP(S) APIs that aren't web applications. In this case, if your workload already uses API Management for its gateway capabilities, you can consider API Management's optional load balancing feature to direct traffic across API back ends that aren't already load balanced through another mechanism. If your workload isn't using API Management, we don't recommend that you use API Management only for load balancing concerns.

- **Performance acceleration** refers to features that accelerate web access. Performance acceleration can be achieved by using content delivery networks (CDNs) or optimized point of presence ingress for accelerated client onboarding into the destination network. Azure Front Door supports both [CDNs](/azure/frontdoor/front-door-caching?pivots=front-door-standard-premium) and [Anycast traffic acceleration](/azure/frontdoor/front-door-traffic-acceleration?pivots=front-door-standard-premium). You can gain the benefits of both features with or without Application Gateway in the architecture.

### Other considerations

Each load balancing service also has capability support or implementation details that you should consider. Here are some examples that might be relevant for your load-balancing scenario:

- WebSockets support
- Server-sent events support
- HTTP/2 support (both receiving and continuing to back-end nodes)
- Sticky session support
- Back-end node health monitoring mechanism
- Client experience or delay between unhealthy node detection and removal from routing logic.

### Offload capabilities to your load balancer

Some load balancing options in Azure allow you to offload capabilities from the back-end nodes to the load balancer, as some implement the [gateway offloading](../../patterns/gateway-offloading.yml) cloud design pattern. For example, Application Gateway can offload TLS, so your workload's public-facing certificate is managed in one location instead of across back-end nodes. API Management can be configured to offload some basic authorization concerns such as validating claims in JSON web token (JWT) access tokens. Offloading cross-cutting concerns can help reduce the complexity of the logic in your back ends and improve their performance.

## Examples

The following table lists various articles based on the load-balancing services used in the solution.

| Services        | Article | Description |
| :-------------- | :------ | :---------- |
| Load Balancer   | [Load balance VMs across availability zones](/azure/load-balancer/quickstart-load-balancer-standard-public-portal) | Load balance VMs across availability zones to help protect your apps and data from an unlikely failure or loss of an entire datacenter. With zone redundancy, one or more availability zones can fail and the data path survives as long as one zone in the region remains healthy. |
| Traffic Manager | [Multitier web application built for high availability and disaster recovery](../../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml) | Deploy resilient multitier applications built for high availability and disaster recovery. If the primary region becomes unavailable, Traffic Manager fails over to the secondary region. |
| Application Gateway + API Management | [API Management landing zone architecture](../../example-scenario/integration/app-gateway-internal-api-management-function.yml) | Use Application Gateway to offload WAF and TLS. Use API Management to load balance across API back ends. |
| Traffic Manager + Application Gateway | [Multiregion load balancing with Traffic Manager and Application Gateway](../../high-availability/reference-architecture-traffic-manager-application-gateway.yml) | Learn how to serve web workloads and deploy resilient multitier applications in multiple Azure regions to achieve high availability and a robust disaster recovery infrastructure. |

## Next steps

- [Create a public load balancer to load balance VMs](/azure/load-balancer/quickstart-load-balancer-standard-public-portal)
- [Direct web traffic with Application Gateway](/azure/application-gateway/quick-create-portal)
- [Configure Traffic Manager for global DNS-based load balancing](/azure/traffic-manager/quickstart-create-traffic-manager-profile)
- [Configure Azure Front Door for a highly available global web application](/azure/frontdoor/quickstart-create-front-door)
