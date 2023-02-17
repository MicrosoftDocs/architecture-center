---
title: Mission-critical global content delivery
titleSuffix: Azure Architecture Center
description: Learn how to develop highly resilient global HTTP applications when your focus is on content delivery and caching.
author: johndowns
ms.author: jodowns
ms.date: 02/15/2023
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

Microsoft has partnered with Verizon's CDN, and you can integrate Verizon's CDN platform (Edgio) into your Azure-based solution. Although Verizon's CDN is partnered with Azure and can be configured from within the Azure portal and APIs, their CDN platform is isolated from Microsoft’s infrastructure.

This isolation provides a high degree of resiliency from disaster scenarios. In the event of an outage or disaster, traffic can be automatically shifted between Azure Front Door and Verizon's CDN. You can use Azure Traffic Manager to detect an outage and redirect traffic to the alternative CDN.

:::image type="content" source="./media/front-door-verizon-cdn.png" alt-text="Traffic Manager with weighted routing between AFD and Verizon’s CDN." border="false":::

## Considerations

The following sections describe some important considerations for this type of architecture. You should also review [Mission-critical global web applications](./overview.md) for other important considerations about using Azure Front Door in a mission-critical solution.

### Choice of CDN

In this example, we suggest using Verizon's CDN. Verizon's CDN is often a good choice because it can be deployed, configured, and billed through Azure, reducing your operational complexity. It runs on separate physical infrastructure to Azure Front Door, which means it's resilient to outages or problems on Microsoft's infrastructure.

You might choose to use a different CDN, or even to use multiple CDNs, depending on your requirements and risk tolerance.

### Cost

When you deploy a multi-CDN architecture, you're billed for multiple CDNs. Ensure you understand how you'll be billed for each CDN in your solution, and all of the other components you deploy.

### Feature parity

Azure Front Door and Verizon's CDN provide distinct capabilities, and features aren't equivalent between the two products. For example, there are differences between the products' handling of TLS certificates, WAF, and HTTP rules.

Carefully consider the features of Azure Front Door that you use, and whether your alternative CDN has equivalent capabilities. For more information, see [Understand your use of Azure Front Door](./overview.md#understand-your-use-of-azure-front-door).

### Cache fill

It's important to test the failover between Azure Front Door and your alternative CDN. In particular, watch for anomalies or performance issues associated with your applications and infrastructure. A common issue that can arise for customers running multiple CDNs in an active/passive mode is that the CDN configured in passive mode needs to perform a *cache fill* from your origin during a failover. During the cache fill, origin systems could become overloaded.

If performance issues from cache fills are a risk for your solution, consider either of the following approaches:
- Scale out or scale up your origins to cope with additional traffic, especially during a cache fill.
- Pre-fill the passive CDN. Pre-filling means that you serve a percentage of your most popular content through the passive CDN even before a failover event occurs. One approach to consider is Traffic Manager's [weighted traffic routing mode](/azure/traffic-manager/traffic-manager-routing-methods#weighted-traffic-routing-method).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [Dave Burkhardt](https://linkedin.com/in/david-burkhardt-13b79b3) | Principal Product Manager, Azure Networking
 * [John Downs](https://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Harikrishnan M B](https://linkedin.com/in/harikrishnanmb/) | Product Manager 2, Azure Networking

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [global HTTP ingress](./mission-critical-global-http-ingress.md) scenario to understand whether it applies to your solution.
