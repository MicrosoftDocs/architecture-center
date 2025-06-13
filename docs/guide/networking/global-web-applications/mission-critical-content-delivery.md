---
title: Mission-critical global content delivery
description: Learn how to develop highly resilient global HTTP applications when your focus is on content delivery and caching.
author: johndowns
ms.author: pnp
ms.reviewer: dburkhardt
ms.date: 02/21/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: guide
---

# Mission-critical global content delivery

Content delivery networks (CDNs) offer a range of capabilities to optimize performance for users, including global layer 7 load balancing and optimized network routing. Caching is also a common way to reduce load on the backend services and provider further resiliency to a range of issues. CDNs, including Azure Front Door, provide caching at the network edge.

CDNs are an essential component in some solution architectures, so it’s an industry best practice for mission-critical workloads to use multiple CDNs to achieve a higher level of uptime. If one CDN experiences outage or degraded performance, your traffic is automatically diverted to another CDN.

Microsoft offers an [industry-leading service level agreement (SLA) for Azure Front Door](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services). Even if another provider offers a 100% uptime SLA, it's important to note that that isn't a guarantee of zero downtime, and that SLAs typically provide for service credits in the event of an outage. For this reason, even Microsoft's competitors recommend using multiple CDNs for mission-critical workloads, and many companies who manage their own CDN also utilize other CDNs too.

If you implement multiple CDNs, consider the implications of this approach. Each CDN provides a separate network path to your application servers, and you need to configure and test each CDN separately.

This article describes an approach for using Azure Front Door with another CDN. This approach is suitable for solutions that rely heavily on caching for delivering static content delivery, media, and high-scale eCommerce applications.

> [!NOTE]
> This use case is part of an overall design strategy that covers an alternate approach when Azure Front Door is unavailable. For information about the context and considerations, see [Mission-critical global web applications](./overview.md).

## Approach

A third-party CDN can be integrated into your Azure solution to provide isolation from Microsoft's infrastructure. This isolation provides a high degree of resiliency from disaster scenarios. If an outage or disaster occurs, traffic is automatically shifted between Azure Front Door and the alternative CDN. You can use Azure Traffic Manager to detect an outage and redirect traffic to the alternative CDN.

> [!NOTE]
> Microsoft offers a CDN interconnect service to route your origin traffic to another CDN with zero data transfer fees. For more details, see [Routing preferences](/azure/virtual-network/ip-services/routing-preference-unmetered).

The following diagram shows how traffic flows between the CDNs:

:::image type="content" source="./media/mission-critical-content-delivery/front-door-alternative-cdn.png" alt-text="Diagram of Traffic Manager routing between Azure Front Door and another CDN." border="false":::

- **Traffic Manager using priority routing mode** has two [endpoints](/azure/traffic-manager/traffic-manager-endpoint-types). By default, Traffic Manager sends requests through Azure Front Door. If Azure Front Door is unavailable, Traffic Manager sends the request through the alternative CDN instead.

- **Azure Front Door** processes and routes most of your application traffic. Azure Front Door routes traffic to the appropriate origin application server, and it provides the primary path to your application. If Azure Front Door is unavailable, traffic is automatically redirected through the secondary path.

- **An alternative CDN** is configured to send traffic to each origin server.

- **Your origin application servers** need to be ready to accept traffic from both Azure Front Door and another CDN, at any time.

## Considerations

The considerations described in [Mission-critical global web applications](./overview.md) still apply to this use case. Here are some additional points:

#### Choice of CDN

Microsoft offers several CDN products. Our flagship CDN offering is Azure Front Door Standard and Premium, and retirement has been announced for all other CDN products. The other CDN products also share physical infrastructure with Azure Front Door, so we recommend you select a different CDN product for the type of architecture described within this article. Make sure you select an alternative CDN that meets your needs for feature capabilities, uptime, and cost.

You might choose to use more than two CDNs depending on your requirements and risk tolerance.

#### Feature parity

Azure Front Door provides distinct capabilities from many CDNs, and features aren't equivalent between the CDN products. For example, there might be differences in handling of TLS certificates, web application firewall (WAF), and HTTP routing rules.

Carefully consider the features of Azure Front Door that you use, and whether your alternative CDN has equivalent capabilities. For more information, see [Consistency of ingress paths](./overview.md#traffic-routing-consistency).

#### Cache fill

If you're running multiple CDNs in active-passive mode, during a failover, CDN configured in passive mode needs to perform a *cache fill* from your origin during a failover.

Test the failover between Azure Front Door and your alternative CDN to detect anomalies or performance issues. 

If your solution is at risk from performance issues during cache fills, consider these  approaches to reduce the risk:

- **Scale out or scale** up your origins to cope with higher traffic levels, especially during a cache fill.

- **Prefill both CDNs**. You serve a percentage of your most popular content through the passive CDN even before a failover event occurs. For example, you could consider using [weighted traffic routing mode](/azure/traffic-manager/traffic-manager-routing-methods#weighted-traffic-routing-method).

## Tradeoffs

Using multiple CDNs comes with some tradeoffs. 

- There might be an increase in the overall cost of the solution. When you deploy a multi-CDN architecture, you're billed for multiple CDNs. Make sure that you understand how you're charged for each CDN in your solution, and all of the other components you deploy.

- Each additional component you add to your solution increases your management overhead.

- There might be performance issues during failover between Azure Front Door and your alternative CDN.

- By using a DNS traffic manager, you can randomize which CDN is chosen for a request. If you're not careful to implement consistent cache settings across CDNs (for example, [caching in Azure Front Door](/azure/frontdoor/front-door-caching)) you could you risk lower performance and higher costs for origin egress bandwidth.

- A common issue is [cache refilling](#cache-fill) when CDNs are running in an active-passive mode. The CDN configured in passive mode needs refill its cache from the origin. It can overload origin systems during that process.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Dave Burkhardt](https://linkedin.com/in/dave-burkhardt-13b79b3/) | Principal Program Manager, Azure Front Door
- [John Downs](https://linkedin.com/in/john-downs/) | Principal Software Engineer
- [Priyanka Wilkins](https://linkedin.com/in/priyanka-w/) | Principal Content Developer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [global HTTP ingress](./mission-critical-global-http-ingress.md) scenario to understand whether it applies to your solution.
