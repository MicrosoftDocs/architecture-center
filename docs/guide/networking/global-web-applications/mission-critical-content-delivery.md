---
title: Mission-Critical Global Content Delivery
description: Learn how to develop highly resilient global HTTP applications when your focus is on content delivery and caching.
author: johndowns
ms.author: pnp
ms.reviewer: dburkhardt
ms.date: 11/25/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: guide
---

# Mission-critical global content delivery

Content delivery networks (CDNs) offer a range of capabilities to optimize performance for users, including global layer 7 load balancing and optimized network routing. Caching is also a common way to reduce load on the backend services and provide further resiliency to a range of issues. CDNs, including Azure Front Door, provide caching at the network edge.

CDNs are an essential component in some solution architectures, so it’s an industry best practice for mission-critical workloads to use multiple CDNs to achieve a higher level of uptime. If one CDN experiences outage or degraded performance, your traffic is automatically diverted to another CDN.

As mentioned in the previous article in this series, Azure Front Door is designed to provide the utmost resiliency and availability not only for our external customers, but also for multiple properties across Microsoft. While Microsoft offers an [industry-leading service level agreement (SLA) for Azure Front Door](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services), if you have a mission-critical application that demands even higher SLA, you will need to rely on multiple CDNs. Consider the implications of this approach. Each CDN provides a separate network path to your application servers, and you need to configure and test each CDN separately.

This article describes an approach for using Azure Front Door with another CDN. This approach is suitable for solutions that rely heavily on caching for delivering static content delivery, media, and high-scale eCommerce applications.

> [!NOTE]
> This use case is part of an overall design strategy that covers an alternate approach when Azure Front Door is unavailable. For information about the context and considerations, see [Mission-critical global web applications](./overview.md).

## Approach

A third-party CDN can be integrated into your Azure solution to provide isolation from Microsoft's infrastructure. This isolation provides a high degree of resiliency from disaster scenarios. If an outage or disaster occurs, traffic is automatically shifted between Azure Front Door and the alternative CDN. You can use Azure Traffic Manager to detect an outage and redirect traffic to the alternative CDN.

> [!NOTE]
> Microsoft offers a CDN interconnect service to route your origin traffic to another CDN with zero data transfer fees. For more information, see [Routing preferences](/azure/virtual-network/ip-services/routing-preference-unmetered).

The following diagram shows how traffic flows between the CDNs:

:::image type="content" source="./media/mission-critical-content-delivery/front-door-alternative-cdn.svg" alt-text="Diagram of Traffic Manager routing between Azure Front Door and another CDN." border="false":::

- **Traffic Manager** uses weighted routing mode, has two [endpoints](/azure/traffic-manager/traffic-manager-endpoint-types), and is configured to [always serve traffic](/azure/traffic-manager/traffic-manager-monitoring#always-serve).

  During normal operations, Traffic Manager sends all requests through Azure Front Door.
  
  If Azure Front Door becomes unavailable, turn off the Azure Front Door endpoint. Traffic Manager then sends all requests through the alternative CDN.

- **Azure Front Door** processes and routes most of your application traffic. Azure Front Door routes traffic to the appropriate origin application server, and it provides the primary path to your application. If Azure Front Door is unavailable, traffic is automatically redirected through the secondary path.

- **An alternative CDN** is configured to send traffic to each origin server.

- **Your origin application servers** need to be ready to accept traffic from both Azure Front Door and another CDN, at any time.

## Considerations

The considerations described in [Mission-critical global web applications](./overview.md) still apply to this use case. Here are some additional points:

#### Choice of CDN

Microsoft offers several CDN products. Our flagship offering is Azure Front Door Standard and Premium, and retirement has been announced for all other CDN products. The other products also share physical infrastructure with Azure Front Door, so we recommend you select a different CDN product for the type of architecture described within this article. Make sure you select an alternative CDN that meets your needs for feature capabilities, uptime, and cost.

You might choose to use more than two CDNs depending on your requirements and risk tolerance.

#### Feature parity

Azure Front Door provides distinct capabilities from many CDNs, and features aren't equivalent between the products. For example, there might be differences in handling of TLS certificates, web application firewall (WAF), and HTTP routing rules.

Carefully consider the features of Azure Front Door that you use, and whether your alternative CDN has equivalent capabilities. For more information, see [Consistency of ingress paths](./overview.md#traffic-routing-consistency).

#### Cache fill

For many situations, an active-passive routing approach makes sense. During normal operations, all traffic routes to Azure Front Door and bypasses the alternative CDN. To achieve this configuration, turn on the Traffic Manager endpoint for Azure Front Door and turn off the endpoint for your alternative CDN.

But if you run multiple CDNs in active-passive mode, the passive one must perform a *cache fill* from your origin when failover occurs.

Test failover between Azure Front Door and your alternative CDN to detect anomalies or performance problems. If your solution is at risk from performance problems during cache fills, consider these approaches to reduce the risk:

- **Scale out or scale up your origins** to handle higher traffic levels, especially during a cache fill.

- **Prefill both CDNs** by serving a percentage of your most popular content through the passive CDN before a failover event occurs. Configure [weighted traffic routing mode](/azure/traffic-manager/traffic-manager-routing-methods#weighted-traffic-routing-method) to send a small portion of traffic to the alternative CDN so that it's ready to serve production traffic at all times.

#### Subdomains

You might combine application-level routing and content delivery. For example, static assets might benefit from caching, while your primary web application might not use caching.

In this scenario, consider putting your content assets on a dedicated subdomain so that you can reconfigure them independently of application server routing.

## Tradeoffs

Using multiple CDNs comes with some tradeoffs. 

- There might be an increase in the overall cost of the solution. When you deploy an architecture that uses multiple CDNs, you're billed for each one. Make sure that you understand how you're charged for each CDN in your solution, and all of the other components you deploy.

- Each additional component you add to your solution increases your management overhead.

- There might be performance problems during failover between Azure Front Door and your alternative CDN.

- By using a DNS traffic manager, you can randomize which CDN is chosen for a request. If you're not careful to implement consistent cache settings across CDNs (for example, [caching in Azure Front Door](/azure/frontdoor/front-door-caching)) you could you risk lower performance and higher costs for origin egress bandwidth.

- A common issue is [cache refilling](#cache-fill) when CDNs are running in an active-passive mode. The CDN configured in passive mode needs to refill its cache from the origin. It can overload origin systems during that process.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Dave Burkhardt](https://www.linkedin.com/in/dave-burkhardt-13b79b3/) | Principal Program Manager, Azure Front Door
- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Akhil Karmalkar](https://www.linkedin.com/in/akhil-karmalkar-8b200546/) | Principal Program Manager, Azure Front Door
- [Priyanka Wilkins](https://www.linkedin.com/in/priyanka-w/) | Principal Content Developer, Azure Patterns & Practices

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [global HTTP ingress](./mission-critical-global-http-ingress.md) scenario to understand whether it applies to your solution.
