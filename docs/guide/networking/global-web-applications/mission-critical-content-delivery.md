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

Some applications heavily depend on caching for performance acceleration and to improve the resiliency of their application servers. Content delivery networks (CDNs), including Azure Front Door, provide caching at the network edge.

It's common for mission-critical solutions to use multiple CDNs when serving their traffic. Azure Front Door provides a high uptime SLA, but by using multiple CDNs, you can achieve an even higher level of uptime. If one CDN has a disaster, outage, or performance issue, your traffic is automatically diverted to another CDN.

However, when you implement multiple CDNs, you need to carefully consider the full implications. Each CDN provides a separate network path to your application servers, and you need to configure and test each CDN separately.

This article describes an approach for using Azure Front Door with a partner CDN, Verizon.

> [!NOTE]
> This article should be read in conjunction with [Mission-critical global web applications](./overview.md), which provides important context and overall considerations that apply.

## Requirements

This approach might suit your needs if you rely heavily on caching to deliver your content. Example scenarios where caching is important include static content delivery, media, and high-scale eCommerce applications.

## Approach

Microsoft has partnered with Verizon's CDN, and you can integrate Verizon's CDN platform (Edgio) into your Azure-based solution. Verizon's CDN is a Microsoft Azure partner, and you can configure it from within the Azure portal and APIs. However, their CDN platform is isolated from Microsoft's infrastructure.

This isolation provides a high degree of resiliency from disaster scenarios. If an outage or disaster occurs, traffic is automatically shifted between Azure Front Door and Verizon's CDN. You can use Azure Traffic Manager to detect an outage and redirect traffic to the alternative CDN.

:::image type="content" source="./media/mission-critical-content-delivery/front-door-verizon-cdn.png" alt-text="Traffic Manager routing between Azure Front Door and Verizon's CDN." border="false":::

The solution includes the following components:

- **Traffic Manager using priority routing mode** has two [endpoints](/azure/traffic-manager/traffic-manager-endpoint-types). By default, Traffic Manager sends requests through Azure Front Door. If Azure Front Door is unavailable, Traffic Manager sends the request through the partner CDN instead.

- **Azure Front Door** processes and routes most of your application traffic. Azure Front Door routes traffic to the appropriate origin application server, and it provides the primary path to your application. If Azure Front Door is unavailable, traffic is automatically redirected through the secondary path.

- **Azure CDN from Verizon** is configured to send traffic to each origin server.

- **Your origin application servers** need to be ready to accept traffic from both Azure Front Door and Azure CDN from Verizon, at any time.

## Considerations and tradeoffs

The following sections describe some important considerations for this type of architecture. You should also review [Mission-critical global web applications](./overview.md) for other important considerations and tradeoffs when you use Azure Front Door in a mission-critical solution.

### Choice of CDN

In this example, we suggest using Verizon's CDN. Verizon's CDN is often a good choice because it can be deployed, configured, and billed through Azure, reducing your operational complexity. It runs on separate physical infrastructure to Azure Front Door, which means it's resilient to outages or problems on Microsoft's infrastructure.

You might choose to use a different CDN, or even to use multiple CDNs, depending on your requirements and risk tolerance.

### Cost

When you deploy a multi-CDN architecture, you're billed for multiple CDNs. Ensure you understand how you're charged for each CDN in your solution, and all of the other components you deploy.

### Feature parity

Azure Front Door and Verizon's CDN provide distinct capabilities, and features aren't equivalent between the two products. For example, there are differences between the products' handling of TLS certificates, WAF, and HTTP rules.

Carefully consider the features of Azure Front Door that you use, and whether your alternative CDN has equivalent capabilities. For more information, see [Consistency of ingress paths](./overview.md#consistency-of-ingress-paths).

### Cache fill

It's important to test the failover between Azure Front Door and your alternative CDN. In particular, watch for anomalies or performance issues associated with your applications and infrastructure. A common issue that can arise for customers running multiple CDNs in an active/passive mode is that the CDN configured in passive mode needs to perform a *cache fill* from your origin during a failover. During the cache fill, origin systems could become overloaded.

If your solution is at risk from performance issues during cache fills, consider either of the following approaches to reduce the risk:

- Scale out or scale up your origins to cope with higher traffic levels, especially during a cache fill.
- Pre-fill both CDNs. Pre-filling means that you serve a percentage of your most popular content through the passive CDN even before a failover event occurs. For example, you could consider using [weighted traffic routing mode](/azure/traffic-manager/traffic-manager-routing-methods#weighted-traffic-routing-method).


## Next steps

Review the [global HTTP ingress](./mission-critical-global-http-ingress.md) scenario to understand whether it applies to your solution.
