---
title: Load Balancing Options
description: Learn about Azure load balancing services and considerations to select one for distributing traffic across multiple computing resources.
author: claytonsiemens77
ms.author: pnp
ms.date: 11/12/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Load balancing options

The term *load balancing* refers to the distribution of processing across multiple computing resources. You load balance to optimize resource usage, maximize throughput, minimize response time, and avoid overloading any single resource. Load balancing can also improve availability by sharing a workload across redundant computing resources.

Azure provides various load balancing services that you can use to distribute your workloads across multiple computing resources. These services include Azure API Management, Azure Application Gateway, Azure Front Door, Azure Load Balancer, and Azure Traffic Manager.

This article describes considerations to help you determine an appropriate load balancing solution for your workload's needs.

## Azure load balancing services

The following main load balancing services and service with load balancing capabilities are available in Azure:

- [API Management](/azure/api-management/api-management-key-concepts) is a managed service that you can use to publish, secure, transform, maintain, and monitor HTTP(S) APIs. It provides a gateway for your APIs and can be configured to load balance traffic across nodes in a designated load balanced back-end pool. You can choose from three different load balancing methods: round-robin, weighted, and priority-based.

  > [!IMPORTANT]
  > API Management isn't a traditional, general-purpose load balancer. It's designed specifically for HTTP APIs, and its load balancing capabilities are optional within its broader API management functionality. API Management is included in this article for completeness because it provides load balancing capabilities for specific API hosting topologies. However, its primary purpose is API gateway functionality rather than load balancing.

- [Application Gateway](/azure/application-gateway/overview) is a proxy load balancer. It provides application delivery controller functionality as a managed service. It offers various Layer-7 load balancing, routing, TLS offloading and web application firewall functionalities. As a terminating load balancer, it also offers [Layer-4 load balancing](/azure/application-gateway/tcp-tls-proxy-overview) for TCP and TLS protocols. Use Application Gateway to transition traffic from public network space to your web servers hosted in private network space within a region.

- [Application Gateway for Containers](/azure/application-gateway/for-containers/overview) is an application layer (layer 7) load balancing and dynamic traffic management product for workloads running in a Kubernetes cluster.

- [Azure Front Door](/azure/frontdoor/front-door-overview) is an application delivery network that provides global load balancing and site acceleration for web applications. It provides Layer-7 capabilities for your application such as Secure Sockets Layer (SSL) offload, path-based routing, fast failover, and caching to improve performance and high availability.

- [Load Balancer](/azure/load-balancer/load-balancer-overview) is a Layer-4 service that handles inbound and outbound traffic across all User Datagram Protocol (UDP) and Transmission Control Protocol (TCP) protocols. It's designed for high performance and ultra-low latency. It's built to handle millions of requests per second while ensuring that your solution is highly available. Load Balancer is zone redundant, which ensures high availability across availability zones. It supports both a regional deployment topology and a [cross-region topology](/azure/load-balancer/cross-region-overview).

- [Traffic Manager](/azure/traffic-manager/traffic-manager-overview) is a Domain Name System (DNS)-based traffic load balancer that enables you to distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness. Because Traffic Manager is a DNS-based load balancing service, it load balances only at the domain level. For that reason, it can't fail over as quickly as Azure Front Door. DNS caching and systems that ignore DNS time-to-live (TTL) values often cause this delay.

> [!NOTE]
> Clustering technologies, such as Azure Container Apps or Azure Kubernetes Service (AKS), contain load balancing constructs. These constructs operate mostly within the scope of their own cluster boundary. They route traffic to available application instances based on readiness and health probes. This article doesn't cover all of these load balancing options.

## Service categorizations

Azure load balancing services can be categorized along two dimensions: global versus regional and HTTP(S) versus non-HTTP(S).

### Global versus regional

- **Global:** These load balancing services distribute traffic across regional back ends, clouds, or hybrid on-premises services. They provide a single control plane that routes user traffic to available back ends globally. These services react to changes in service reliability or performance to maximize availability and performance. You can think of them as systems that load balance between application stamps, endpoints, or scale units hosted across different regions or geographies.

- **Regional:** These load balancing services distribute traffic within virtual networks across virtual machines (VMs) or zonal and zone-redundant service endpoints within a region. You can think of them as systems that load balance between VMs, containers, or clusters within a region in a virtual network.

### HTTP(S) versus non-HTTP(S)

- **HTTP(S):** These load balancing services are [Layer-7](https://www.iso.org/ics/35.100.70/x/) load balancers that accept only HTTP(S) traffic. They're designed for web applications or other HTTP(S) endpoints. Features include SSL offload, web application firewall, path-based load balancing, and session affinity.

- **Non-HTTP(S):** These load balancing services include [Layer-4](https://www.iso.org/ics/35.100.40/x/) TCP and UDP services, or DNS-based load balancing services.

The following table summarizes the Azure load balancing services.

| Service             | Global or regional | Recommended traffic |
| :--- | :--- | :---  |
| API Management      | Regional or global | HTTP(S) APIs only   |
| Application Gateway | Regional           | HTTP(S), TCP, & TLS |
| Application Gateway for Containers | Regional           | HTTP(S) |
| Azure Front Door    | Global             | HTTP(S)             |
| Load Balancer       | Regional or global | Non-HTTP(S)         |
| Traffic Manager     | Global             | Non-HTTP(S)         |

> [!NOTE]
> Traffic Manager and Load Balancer can distribute any traffic type, including HTTP(S). However, these services don't provide Layer-7 capabilities. Unlike Load Balancer, Traffic Manager doesn't handle the traffic directly. Traffic Manager uses DNS to direct clients to the appropriate endpoints.

## Choose a load balancing solution for your scenario

Consider the following factors when you select a load balancing solution:

- **Traffic type:** Determine whether it's a web HTTP(S) application and whether it is public facing or a private application.

- **Global versus regional:** Clarify whether you need to load balance VMs or containers within a single virtual network, load balance scale units or deployments across regions, or both.

- **Availability:** Review the [service-level agreement (SLA)](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

- **Cost:** Account for the cost of the service itself, as well as the operational cost of managing a solution built on that service. For more information, see [Azure pricing](https://azure.microsoft.com/pricing/).

- **Features and limits:** Identify the capabilities supported by each service and the applicable [service limits](/azure/azure-subscription-service-limits).

The following flow chart helps you choose a load balancing solution for your application. The flow chart guides you through a set of key decision criteria to reach a recommendation.

> [!TIP]
> You can use Azure Copilot to help guide you through this decision, similar to the flow chart described here. For more information, see [Work with Azure Load Balancer using Microsoft Azure Copilot](/azure/copilot/work-load-balancer).

Every application has unique requirements not captured in simple decision trees. Treat this flow chart or Copilot recommendation as a starting point. Then perform a more detailed evaluation.

:::image type="complex" border="false" source="./images/load-balancing-decision-tree.png" alt-text="Diagram that shows a decision tree for load balancing in Azure." lightbox="./images/load-balancing-decision-tree-large.png":::
   The image shows a branched flowchart where each path leads to a load balancing or application delivery solution. Path one starts at Web application (HTTP/HTTPS), goes to Internet-facing application via the No arrow, then to Load Balancer. Path two starts at Web application (HTTP/HTTPS), goes to Internet-facing application via the Yes arrow, then to Global/deployed in multiple regions via the No arrow, and ends at Application Gateway. Path three starts at Web application (HTTP/HTTPS), goes to Internet-facing application via Yes, then to Global/deployed in multiple regions via Yes, then to Do you require performance acceleration via Yes, and ends at Azure Front Door. Path four starts at Web application (HTTP/HTTPS), goes to Internet-facing application via Yes, then to Global/deployed in multiple regions via Yes, then to Do you require performance acceleration via No, then to Do you require SSL offload or application-layer processing per request via Yes, and ends at Azure Front Door and Application Gateway. Path five starts at Web application (HTTP/HTTPS), goes to Internet-facing application via Yes, then to Global/deployed in multiple regions via Yes, then to Do you require performance acceleration via No, then to Do you require SSL offload or application-layer processing per request via Yes, and ends at Azure Front Door and API Management for API-only hosting. Path six starts at Web application (HTTP/HTTPS), goes to Internet-facing application via Yes, then to Global/deployed in multiple regions via Yes, then to Do you require performance acceleration via No, then to Do you require SSL offload or application-layer processing per request via No, then to Hosting type, and ends at Azure Front Door for PaaS, Azure Front Door and Load Balancer for IaaS VMs, or Azure Front Door and Application Gateway ingress controller for AKS. Each path concludes with one or more Azure services—Load Balancer, Application Gateway, Azure Front Door, or API Management—selected based on application scope, global reach, performance needs, SSL requirements, and hosting environment.
:::image-end:::

When your workload includes several services that require load balancing, assess each service individually. An effective setup often uses more than one type of load balancing solution. You might incorporate these solutions at different places in your workload's architecture to serve unique functions or roles.

### Definitions

- **Web application (HTTP/HTTPS)** refers to an application that requires at least one of the following capabilities:
  - Makes a routing decision for Layer-7 data, such as a URL path
  - Supports the inspection of the communication payload, such as an HTTP request body
  - Handles Transport Layer Security (TLS) functionality

- **Non-HTTP(S) application** refers to an application that needs Layer 4 (TCP or UDP protocols) or Transport Layer Security (TLS protocol) support. Both Azure Load Balancer and Azure Application Gateway provide capabilities to handle such traffic. However, their features and behaviors differ, as described in this [comparison article](/azure/application-gateway/tcp-tls-proxy-overview#comparing-azure-load-balancer-with-azure-application-gateway).

- **Internet-facing application** refers to an application that's publicly accessible from the internet. As a best practice, application owners apply restrictive access policies or protect the application by setting up offerings like web application firewall and distributed denial-of-service protection.

- **Global or deployed in multiple regions** means that the load balancer should have a single, highly available control plane that routes traffic to public endpoints on your globally distributed application. This configuration can support either active-active or active-passive topologies across regions.

  > [!NOTE]
  > You can use a regional service, such as Application Gateway, to load balance across back ends that span multiple regions and control routing through a single control plane. It works by using a [cross-region private link](/azure/private-link/private-link-faq#can-private-endpoint-connect-to-azure-paas-resources-across-azure-regions-), global virtual network peering, or even public IP addresses of services in other regions.
  >
  > This scenario isn't the primary point of this decision.
  >
  > Using a regional resource as a router for globally distributed back ends introduces a regional single point of failure. It also incurs extra latency because traffic is forced through one region before going to another and then back again.

- **Platform as a service (PaaS)** provides a managed hosting environment where you can deploy your application without needing to manage VMs or networking resources. In this case, PaaS refers to services that provide integrated load balancing within a region. For more information, see [Choose a compute service for scalability](./compute-decision-tree.md#scalability).

- **AKS** enables you to deploy and manage containerized applications. AKS provides serverless Kubernetes, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance. These AKS workloads are referred to as AKS backends. For more information, see [AKS architecture design](../../reference-architectures/containers/aks-start-here.md).

- **Infrastructure as a service (IaaS)** is a computing option where you provision the VMs that you need, along with associated network and storage components. IaaS applications require internal load balancing within a virtual network by using Load Balancer.

- **Application-layer processing** refers to special routing within a virtual network. Examples include path-based routing across VMs or virtual machine scale sets. For more information, see [Deploy an Application Gateway behind Azure Front Door](/azure/frontdoor/front-door-faq#when-should-i-deploy-an-application-gateway-behind-front-door-).

- **Only APIs** refers to the need to load balance HTTP(S) APIs that aren't web applications. In this case, if your workload already uses API Management for its gateway capabilities, you can consider its optional load balancing feature to direct traffic across API back ends that aren't already load balanced through another mechanism. If your workload doesn't use API Management, don't use it solely for load balancing.

- **Content delivery network (CDN)** refers to a feature that accelerates webpage loading times through its geographically distributed network of servers. CDN enables performance acceleration or optimized point-of-presence ingress for accelerated client onboarding into the destination network. Azure Front Door supports both [content delivery networks](/azure/frontdoor/front-door-caching) and [Anycast traffic acceleration](/azure/frontdoor/front-door-traffic-acceleration). You can gain the benefits of both features with or without Application Gateway in the architecture.

- **Passthrough load balancer** is a load balancer where a client directly establishes a connection with a backend server that is selected by the load balancer's distribution algorithm.

- **Terminating load balancer** is where a client establishes a connection with the load balancer (proxy) and a separate connection is initiated from load balancer to the backend server.

### Other considerations

Each load balancing service also has capability support or implementation details that you should consider. Here are some examples that might be relevant for your load balancing scenario:

- WebSockets support
- Server-sent events support
- HTTP/2 support (both receiving and continuing to back-end nodes)
- Sticky session support
- Back-end node health monitoring mechanism
- Client experience or delay between unhealthy node detection and removal from routing logic

### Offload capabilities to your load balancer

Some load balancing options in Azure allow you to offload capabilities from the back-end nodes to the load balancer. These options implement the [Gateway Offloading](../../patterns/gateway-offloading.yml) cloud design pattern. For example, Application Gateway can offload TLS, so your workload's public-facing certificate is managed in one location instead of across back-end nodes. API Management can be configured to offload some basic authorization concerns such as validating claims in JSON Web Token (JWT) access tokens. Offloading cross-cutting concerns can help reduce the complexity of the logic in your back ends and improve their performance.

## Examples

The following table lists various articles based on the load balancing services used in the solution.

| Services        | Article | Description |
| :-------------- | :------ | :---------- |
| Load Balancer   | [Load balance VMs across availability zones](/azure/load-balancer/quickstart-load-balancer-standard-public-portal) | Load balance VMs across availability zones to help protect your apps and data from an unlikely failure or loss of an entire datacenter. With zone redundancy, one or more availability zones can fail and the data path survives as long as one zone in the region remains healthy. |
| Traffic Manager | [Multitier web application built for high availability and disaster recovery](../../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml) | Deploy resilient multitier applications built for high availability and disaster recovery. If the primary region becomes unavailable, Traffic Manager fails over to the secondary region. |
| Application Gateway and API Management | [API Management landing zone architecture](../../example-scenario/integration/app-gateway-internal-api-management-function.yml) | Use Application Gateway to offload web application firewall and TLS. Use API Management to load balance across API back ends. |
| Traffic Manager and Application Gateway | [Multiregion load balancing with Traffic Manager and Application Gateway](../../high-availability/reference-architecture-traffic-manager-application-gateway.yml) | Learn how to serve web workloads and deploy resilient multitier applications in multiple Azure regions to achieve high availability and a robust disaster recovery infrastructure. |

## Next steps

- [Create a public load balancer to load balance VMs](/azure/load-balancer/quickstart-load-balancer-standard-public-portal)
- [Direct web traffic with Application Gateway](/azure/application-gateway/quick-create-portal)
- [Configure Traffic Manager for global DNS-based load balancing](/azure/traffic-manager/quickstart-create-traffic-manager-profile)
- [Configure Azure Front Door for a highly available global web application](/azure/frontdoor/quickstart-create-front-door)
