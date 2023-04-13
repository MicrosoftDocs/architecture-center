---
title: Mission-critical global content delivery
titleSuffix: Azure Architecture Center
description: Learn how to develop highly resilient global HTTP applications when your focus is on content delivery and caching.
author: johndowns
ms.author: jodowns
ms.date: 03/10/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
ms.category:
  - fcp
ms.custom:
  - checklist
  - guide
---

# Mission-critical global content delivery

Caching is a common way to reduce load on the backend services and optimize performance for users. Content delivery networks (CDNs), including Azure Front Door, provide caching at the network edge.

Mission-critical workloads often use multiple CDNs to achieve a higher level of uptime. If one CDN experiences outage or degraded performance, your traffic is automatically diverted to another CDN.

If you implement multiple CDNs, consider the implications of this approach. Each CDN provides a separate network path to your application servers, and you need to configure and test each CDN separately.

This article describes an approach for using Azure Front Door with a partner CDN, Verizon. This approach is suitable for solutions that  rely heavily on caching for delivering static content delivery, media, and high-scale eCommerce applications.

> [!NOTE]
>
> This use case is part of an overall design strategy that covers an alternate approach when Azure Front Door is unavailable. For information about the context and considerations, see [Mission-critical global web applications](./overview.md).

## Approach

Verizon's CDN and the CDN platform (Edgio) can be integrated into your Azure solution. You can configure it from the Azure portal and APIs. The platform is isolated from Microsoft's infrastructure.

This isolation provides a high degree of resiliency from disaster scenarios. If an outage or disaster occurs, traffic is automatically shifted between Azure Front Door and Verizon's CDN. You can use Azure Traffic Manager to detect an outage and redirect traffic to the alternative CDN.

:::image type="content" source="./media/mission-critical-content-delivery/front-door-verizon-cdn.png" alt-text="Traffic Manager routing between Azure Front Door and Verizon's CDN." border="false":::


- **Traffic Manager using priority routing mode** has two [endpoints](/azure/traffic-manager/traffic-manager-endpoint-types). By default, Traffic Manager sends requests through Azure Front Door. If Azure Front Door is unavailable, Traffic Manager sends the request through the partner CDN instead.

- **Azure Front Door** processes and routes most of your application traffic. Azure Front Door routes traffic to the appropriate origin application server, and it provides the primary path to your application. If Azure Front Door is unavailable, traffic is automatically redirected through the secondary path.

- **Azure CDN from Verizon** is configured to send traffic to each origin server.

- **Your origin application servers** need to be ready to accept traffic from both Azure Front Door and Azure CDN from Verizon, at any time.

## Considerations

The considerations described in [Mission-critical global web applications](./overview.md) still apply to this use case. Here are some additional points:

#### Choice of CDN

In this example, we suggest using Verizon's CDN. Verizon's CDN is often a good choice because it can be deployed, configured, and billed through Azure, reducing your operational complexity. It runs on separate physical infrastructure to Azure Front Door, which means it's resilient to outages or problems on Microsoft's infrastructure.

You might choose to use a different CDN, or even to use multiple CDNs, depending on your requirements and risk tolerance.

#### Feature parity

Azure Front Door and Verizon's CDN provide distinct capabilities, and features aren't equivalent between the two products. For example, there are differences in handling of TLS certificates, WAF, and HTTP rules.

Carefully consider the features of Azure Front Door that you use, and whether your alternative CDN has equivalent capabilities. For more information, see [Consistency of ingress paths](./overview.md#traffic-routing-consistency).

#### Cache fill

If you're running multiple CDNs in active-passive mode, during a failover, CDN configured in passive mode needs to perform a *cache fill* from your origin during a failover.

Test the failover between Azure Front Door and your alternative CDN to detect anomalies or performance issues. 

If your solution is at risk from performance issues during cache fills, consider these  approaches to reduce the risk:

- **Scale out or scale** up your origins to cope with higher traffic levels, especially during a cache fill.

- **Prefill both CDNs**. You serve a percentage of your most popular content through the passive CDN even before a failover event occurs. For example, you could consider using [weighted traffic routing mode](/azure/traffic-manager/traffic-manager-routing-methods#weighted-traffic-routing-method).


## Tradeoffs

Using multiple CDNs comes with some tradeoffs. 

- **Cost**. There might be an increase in the overall cost of the solution. When you deploy a multi-CDN architecture, you're billed for multiple CDNs. Make sure that you understand how you're charged for each CDN in your solution, and all of the other components you deploy.

- **Performance**. There might be performance issues during failover between Azure Front Door and your alternative CDN.

  A common issue is [cache refilling](#cache-fill) when CDNs are running in an active-passive mode. The CDN configured in passive mode needs refill its cache from the origin. It can overload origin systems during that process.


## Next steps

Review the [global HTTP ingress](./mission-critical-global-http-ingress.md) scenario to understand whether it applies to your solution.
