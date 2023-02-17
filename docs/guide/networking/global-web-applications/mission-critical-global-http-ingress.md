---
title: Mission-critical global HTTP ingress
titleSuffix: Azure Architecture Center
description: Learn how to develop highly resilient global HTTP applications when your focus is on HTTP ingress.
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

# Mission-critical global HTTP ingress

Mission-critical dynamic applications and APIs need to maintain a high level of uptime, even when network components are unavailable or degraded. If your solution uses Azure Front Door for web traffic ingress, routing, and security, and you need to maintain a mission-critical status, then you might need to consider an architecture that combines multiple Azure services together to achieve your requirements.

This article describes an approach to support global HTTP traffic ingress though Azure Front Door and Azure Application Gateway.

> [!NOTE]
> This article should be read in conjunction with [Mission-critical global web applications](./overview.md), which provides important context and overall considerations that apply.

## Requirements

This approach might suit your needs if the following statements apply to your solution:

- Azure Front Door provides global traffic routing. This might mean that you have multiple instances of your application in separate Azure regions, or that you serve all global users from a single region.
- You need to use a web application firewall (WAF) to protect your application, regardless of the path your traffic follows to reach your origin servers.
- Caching at the network edge is not a critical part of your application delivery. If caching is important, see [Mission-critical global content delivery](./mission-critical-content-delivery.md) for an alternative approach.

## Approach

This DNS-based load balancing solution uses multiple Azure Traffic Manager profiles to monitor Azure Front Door. In the very unlikely event of an availability issue, Traffic Manager redirects traffic through Application Gateway.

:::image type="content" source="./media/mission-critical-global-http-ingress/front-door-application-gateway.png" alt-text="Azure Traffic Manager with priority routing to Azure Front Door, and a nested Traffic Manager profile using performance routing to send to Application Gateway instances in two regions." border="false":::

The solution includes the following components:

- **Traffic Manager using priority routing mode** sends traffic to Azure Front Door by default. If Azure Front Door is unavailable, it uses a second Traffic Manager profile to determine where to direct the request.

- **Azure Front Door** processes and routes most of your application traffic. Azure Front Door provides the primary path to your application. If Azure Front Door is unavailable, traffic is automatically redirected through the secondary path.

- **Traffic Manager using performance routing mode** sends traffic to the Application Gateway instance with the best performance from the client's location.

- **Application Gateway** is deployed into each region, and sends traffic to the origin servers within that region.

- **Your origin application servers** need to be ready to accept traffic from both Azure Front Door and Azure Application Gateway.

## Considerations

The following sections describe some important considerations for this type of architecture. You should also review [Mission-critical global web applications](./overview.md) for other important considerations about using Azure Front Door in a mission-critical solution.

### Traffic Manager configuration

This approach uses [nested Traffic Manager profiles](/azure/traffic-manager/traffic-manager-nested-profiles) to achieve both priority-based and performance-based routing together for your application's alternative traffic path. In a simple scenario with an origin in a single region, you might only need a single Traffic Manager profile configured to use priority-based routing.

### Azure Front Door and Application Gateway features

This type of architecture is most useful if you want your alternative traffic path to use features like request processing rules, a WAF, and TLS offload. Both Azure Front Door and  Application Gateway provide similar capabilities.

However, it's important to consider the following:

- When you use any of these features, you need to configure them on both Azure Front Door and Application Gateway. For example, if you make a configuration change to your Azure Front Door WAF, you need to apply the same configuration change to your Application Gateway WAF too.
- While there are similarities between the features that Azure Front Door and Application Gateway offer, many features don't have exact parity. Be mindful of these differences, because they could affect how the application is delivered based on the traffic path it follows.
- Application Gateway doesn't provide caching. For more information about this difference, see [Caching](#caching).

Furthermore, it's important to remember that Azure Front Door and Application Gateway are distinct products and have different use cases. In particular, [Application Gateway is a regional service](#regional-distribution), while Azure Front Door has points of presence globally. The two products behave differently. Ensure you understand the details of each product and how you use them.

### Regional distribution

- Unlike AFD which is a global service, AppGW is a regional service, which means you would need to spin up an AppGW instance in each Azure region you have an origin. This can become very costly if you have origins across multiple regions.

### Scaling

- It is recommended that your AppGW is also appropriately scaled to serve traffic incase of a failover or has autoscaling enabled.

### Caching

- If you have enabled caching with AFD, after failover to AppGW, your content will no longer be served from AFD’s 185+ global edge PoPs. So, depending on the size of your content library if you, you could potentially overload your origin when a failover occurs – meaning, performance of your internet application/services will load slowly, but your traffic will not be offline if AFD is down. 

- If you depend on caching, see the CDN scenario
- If cost is a factor, consider the CDN scenario because it's consumption-based pricing
- If you use caching but it's not a critical part of your solution, consider whether you can scale out/up your origins to cope with the increased load caused by a higher number of cache misses

### Access origins through a private IP address

- AFD - Private Link
- AppGW - private endpoint in your VNet configured as the backend in AppGW

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [Dave Burkhardt](https://linkedin.com/in/david-burkhardt-13b79b3) | Principal Product Manager, Azure Networking
 * [John Downs](https://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Harikrishnan M B](https://linkedin.com/in/harikrishnanmb/) | Product Manager 2, Azure Networking

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [global content delivery](./mission-critical-content-delivery.md) scenario to understand whether it applies to your solution.
