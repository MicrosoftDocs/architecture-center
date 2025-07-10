The term *load balancing* refers to the distribution of processing across multiple computing resources. You load balance to optimize resource use, maximize throughput, minimize response time, and avoid overloading any single resource. Load balancing can also improve availability by sharing a workload across redundant computing resources.

Azure provides various load-balancing services that you can use to distribute your workloads across multiple computing resources. These services include Azure API Management, Azure Application Gateway, Azure Front Door, Azure Load Balancer, and Azure Traffic Manager.

This article describes considerations to help you determine an appropriate load-balancing solution for your workload's needs.

## Service categorizations

Azure load-balancing services can be categorized along two dimensions: global versus regional and HTTP(S) versus non-HTTP(S).

### Global vs. regional

- **Global:** These load-balancing services distribute traffic across regional back ends, clouds, or hybrid on-premises services. These services provide a single control plane that routes end-user traffic to available back ends globally. They react to changes in service reliability or performance to maximize availability and performance. You can think of them as systems that load balance between application stamps, endpoints, or scale-units hosted across different regions or geographies.
- **Regional:** These load-balancing services distribute traffic within virtual networks across virtual machines (VMs) or zonal and zone-redundant service endpoints within a region. You can think of them as systems that load balance between VMs, containers, or clusters within a region in a virtual network.

### HTTP(S) vs. non-HTTP(S)

- **HTTP(S):** These load-balancing services are [Layer 7](https://www.iso.org/ics/35.100.70/x/) load balancers that only accept HTTP(S) traffic. They're designed for web applications or other HTTP(S) endpoints. They include features such as SSL offload, web application firewall, path-based load balancing, and session affinity.
- **Non-HTTP(S):** These load-balancing services are either [Layer 4](https://www.iso.org/ics/35.100.40/x/) TCP or UDP services, or DNS-based load balancing.

The following table summarizes the Azure load-balancing services.

| Service                   | Global/Regional    | Recommended traffic |
| :------------------------ | :----------------- | :------------------ |
| Azure API Management      | Regional or Global | HTTP(S) APIs        |
| Azure Application Gateway | Regional           | HTTP(S)             |
| Azure Front Door          | Global             | HTTP(S)             |
| Azure Load Balancer       | Regional or Global | Non-HTTP(S)         |
| Azure Traffic Manager     | Global             | Non-HTTP(S)         |

> [!NOTE]
> Azure Traffic Manager and Azure Load Balancer can distribute any traffic type, including HTTP(S). However, these services don't provide Layer 7 capabilities. Unlike Azure Load Balancer, Azure Traffic Manager doesn't handle the traffic directly. Traffic Manager uses DNS to direct clients to the appropriate endpoints.

## Azure load-balancing services

Here are the main load-balancing services currently available in Azure:

- [Azure API Management](/azure/api-management/api-management-overview) is a managed service that enables you to publish, secure, transform, maintain, and monitor HTTP(S) APIs. It provides a gateway for your APIs and can load balance traffic across nodes in a designated load-balanced back-end pool. You can choose from three different load-balancing methods: round-robin, weighted, and priority based.

- [Application Gateway](/azure/application-gateway/overview) provides application delivery controller as a service, offering various Layer 7 load-balancing capabilities and web application firewall functionality. Use Application Gateway to transition traffic from public network space to your web servers hosted in private network space within a region.

- [Azure Front Door](/azure/frontdoor/front-door-overview) is an application delivery network that provides global load balancing and site acceleration for web applications. It offers Layer 7 capabilities for your application such as SSL offload, path-based routing, fast failover, and caching to improve performance and high availability.

- [Load Balancer](/azure/load-balancer/load-balancer-overview) is a high-performance, ultra-low-latency Layer 4 load-balancing service (inbound and outbound) for all UDP and TCP protocols. It's built to handle millions of requests per second while ensuring your solution is highly available. Load Balancer is zone redundant, ensuring high availability across availability zones. It supports both a regional deployment topology and a [cross-region topology](/azure/load-balancer/cross-region-overview).

- [Traffic Manager](/azure/traffic-manager/traffic-manager-overview) is a DNS-based traffic load balancer that enables you to distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness. Because Traffic Manager is a DNS-based load-balancing service, it load balances only at the domain level. For that reason, it can't fail over as quickly as Azure Front Door, because of common challenges around DNS caching and systems not honoring DNS time-to-live (TTL) values.

> [!NOTE]
> Clustering technology, such as Azure Container Apps or Azure Kubernetes Service, contains load balancing constructs that operate mostly within the scope of their own cluster boundary. These capabilities route traffic to available application instances based on readiness and health probes. This article doesn't cover those load balancing options.

## Decision tree for load balancing in Azure

Consider factors such as these when you select a load balancing solution:

- **Traffic type:** Is it a web HTTP(S) application? Is it public facing or a private application?
- **Global vs. regional:** Do you need to load balance VMs or containers within a single virtual network, or load balance scale units/deployments across regions, or both?
- **Availability:** What's the [service-level agreement](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services)?
- **Cost:** For more information, see [Azure pricing](https://azure.microsoft.com/pricing/). In addition to the cost of the service itself, consider the operational cost for managing a solution built on that service.
- **Features and limits:** What capabilities does each service support, and what are the [service limits](/azure/azure-subscription-service-limits) of each service?

The following flowchart helps you choose a load-balancing solution for your application. The flowchart guides you through a set of key decision criteria to reach a recommendation.

> [!TIP]
> You can use Azure Copilot in the Azure portal to help guide you through this decision similar to the flowchart. In Azure Copilot, enter **Help me choose a load balancer.** By answering the questions from Copilot, you can narrow down your load balancing options.

Treat this flowchart or Azure Copilot's recommendation as a starting point. Every application has unique requirements, so use the recommendation as a starting point. Then perform a more detailed evaluation.

![Diagram that shows a decision tree for load balancing in Azure.](./images/load-balancing-decision-tree.png)

When your workload involves several services that require load balancing, assess each service individually. An effective setup often uses more than one type of load-balancing solution. You might incorporate these solutions at different places in your workload's architecture, each serving a unique function or role.

### Definitions

- **Web application (HTTP/HTTPS):** This refers to needing the capability to make a routing decision for Layer 7 data such as URL path, support the inspection of the communication payload (such as an HTTP request body), or handle TLS functionality.

- **Internet facing application:** Applications that are publicly accessible from the internet. As a best practice, application owners apply restrictive access policies or protect the application by setting up offerings like web application firewall and DDoS protection.

- **Global or deployed in multiple regions:** If this load balancer should have a single, highly available control plane that routes traffic to public endpoints on your globally distributed application. This can support either active-active or active-passive topologies across regions.

  > [!NOTE]
  > You can use a regional service, such as Application Gateway or API Management, to load balance across back ends spanning multiple regions and control routing through a single control plane. That architecture is possible by using [cross-region Private Link](/azure/private-link/private-link-faq#can-private-endpoint-connect-to-azure-paas-resources-across-azure-regions-), global virtual network peering, or even public IPs of services in other regions.
  >
  > This scenario isn't the primary point of this decision.
  >
  > Using a regional resource as a router for globally distributed back ends introduces a regional single point of failure and incurs additional latency as traffic is forced through one region before going to another and then back again.

- **Platform as a service (PaaS)** provides a managed hosting environment, where you can deploy your application without needing to manage VMs or networking resources. In this case, PaaS refers to services that provide integrated load balancing within a region. For more information, see [Choose a compute service &ndash; Scalability](./compute-decision-tree.yml#scalability).

- **Azure Kubernetes Service (AKS)** enables you to deploy and manage containerized applications. AKS provides serverless Kubernetes, an integrated continuous integration and continuous delivery experience, and enterprise-grade security and governance. For more information about AKS architectural resources, see [Azure Kubernetes Service architecture design](../../reference-architectures/containers/aks-start-here.md).

- **Infrastructure as a service (IaaS)** is a computing option where you provision the virtual machines that you need, along with associated network and storage components. IaaS applications require internal load balancing within a virtual network by using Load Balancer.

- **Application-layer processing** refers to special routing within a virtual network. Examples include path-based routing across VMs or virtual machine scale sets. For more information, see [When should I deploy an Application Gateway behind Azure Front Door?](/azure/frontdoor/front-door-faq#when-should-i-deploy-an-application-gateway-behind-front-door-)

- **Only APIs** refers to the need to load balance HTTP(S) APIs that aren't web applications. In this case, you should consider Azure API Management to load balance traffic across API back ends that aren't already load balanced through another mechanism.

- **Performance acceleration** refers to features that accelerate web access. Performance acceleration can be achieved by using content delivery networks (CDNs) or optimized point of presence ingress for accelerated client onboarding into the destination network. Azure Front Door supports both [CDNs](/azure/frontdoor/front-door-caching?pivots=front-door-standard-premium) and [Anycast traffic acceleration](/azure/frontdoor/front-door-traffic-acceleration?pivots=front-door-standard-premium). You can gain the benefits of both features with or without Application Gateway in the architecture.

### Additional considerations

Each load balancing service also has capability support or implementation details that you should consider. Here are some examples that might be relevant for your load-balancing scenario:

- WebSockets support
- Server-sent events support
- HTTP/2 support (both receiving and continuing to back-end nodes)
- Sticky session support
- Back-end node health monitoring mechanism
- Client experience or delay between unhealthy node detection and removal from routing logic.

### Offload capabilities to your load balancer

Some load balancing options in Azure allow you to offload capabilities from the back-end nodes to the load balancer, as some implement the [gateway offloading](../../patterns/gateway-offloading.yml) cloud design pattern. For example, Application Gateway can offload TLS, so your workload's public-facing certificate is managed in one location instead of across back-end nodes. API Management can be configured to offload some basic authorization concerns such as validating claims in JWT access tokens. Offloading cross-cutting concerns can help reduce the complexity of the logic in your back ends and improve their performance.

## Examples

The following table lists various articles based on the load-balancing services used in the solution.

| Services        | Article | Description |
| :-------------- | :------ | :---------- |
| Load Balancer   | [Load balance virtual machines (VMs) across availability zones](/azure/load-balancer/quickstart-load-balancer-standard-public-portal) | Load balance VMs across availability zones to help protect your apps and data from an unlikely failure or loss of an entire datacenter. With zone redundancy, one or more availability zones can fail and the data path survives as long as one zone in the region remains healthy. |
| Traffic Manager | [Multitier web application built for high availability and disaster recovery](../../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml) | Deploy resilient multitier applications built for high availability and disaster recovery. If the primary region becomes unavailable, Traffic Manager fails over to the secondary region. |
| Application Gateway + API Management   | [Azure API Management landing zone architecture](../../example-scenario/integration/app-gateway-internal-api-management-function.yml) | Use Application Gateway to offload WAF and TLS. Use API Management to load balance across API back ends. |
| Azure Front Door + Application Gateway | [Multitenant SaaS on Azure](../../example-scenario/multi-saas/multitenant-saas.yml) | Use a multitenant solution that includes a combination of Azure Front Door and Application Gateway. Azure Front Door helps load balance traffic across regions. Application Gateway routes and load-balances traffic internally in the application to the various services that satisfy client business needs. |
| Traffic Manager + Application Gateway  | [Multiregion load balancing with Traffic Manager and Application Gateway](../../high-availability/reference-architecture-traffic-manager-application-gateway.yml) | Learn how to serve web workloads and deploy resilient multitier applications in multiple Azure regions to achieve high availability and a robust disaster recovery infrastructure. |

## Next steps

- [Create a public load balancer to load balance VMs](/azure/load-balancer/quickstart-load-balancer-standard-public-portal)
- [Direct web traffic with Application Gateway](/azure/application-gateway/quick-create-portal)
- [Configure Traffic Manager for global DNS-based load balancing](/azure/traffic-manager/quickstart-create-traffic-manager-profile)
- [Configure Azure Front Door for a highly available global web application](/azure/frontdoor/quickstart-create-front-door)
