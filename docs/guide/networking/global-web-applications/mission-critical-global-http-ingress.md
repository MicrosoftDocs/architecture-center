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

TODO

## Approach

This DNS-based load balancing solution uses Azure Traffic Manager to monitor Azure Front Door. In the very unlikely event of an availability issue, Traffic Manager redirects traffic through Azure Application Gateway.

:::image type="content" source="./media/mission-critical-global-http-ingress/front-door-application-gateway.png" alt-text="Azure Traffic Manager with priority routing to Azure Front Door, and a nested Traffic Manager profile using performance routing to send to Application Gateway instances in two regions." border="false":::

## Considerations

The following sections describe some important considerations for this type of architecture. You should also review [Mission-critical global web applications](./overview.md) for other important considerations about using Azure Front Door in a mission-critical solution.

### Traffic Manager configuration

- Nested ATM structure (a second ATM between the first ATM and the Application Gateways) for finer control over the routing logic

### Azure Front Door and Application Gateway features

- This combination is useful if you want to keep using features like rules engine, WAF, TLS offload in the event of a failover. 
- Need to configure them in both places.

- While there are similarities between the features that AFD and AppGW offer, not all features have parity (e.g., rules engine, WAF etc.). Similarly, AFD has additional capabilities that may not be offered with AppGW (e.g., caching). Be mindful of these differences as they could affect how the application delivery behavior after failover. 

### Regional distribution

- Unlike AFD which is a global service, AppGW is a regional service, which means you would need to spin up an AppGW instance in each Azure region you have an origin. This can become very costly if you have origins across multiple regions.

### Scaling
- It is recommended that your AppGW is also appropriately scaled to serve traffic incase of a failover or has autoscaling enabled.

### Caching

- If you have enabled caching with AFD, after failover to AppGW, your content will no longer be served from AFD’s 185+ global edge PoPs. So, depending on the size of your content library if you, you could potentially overload your origin when a failover occurs – meaning, performance of your internet application/services will load slowly, but your traffic will not be offline if AFD is down. 

- If you depend on caching, see the CDN scenario
- If cost is a factor, consider the CDN scenario because it's consumption-based pricing
- If you use caching but it's not a critical part of your solution, consider whether you can scale out/up your origins to cope with the increased load caused by a higher number of cache misses

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [Dave Burkhardt](https://linkedin.com/in/david-burkhardt-13b79b3) | Principal Product Manager, Azure Networking
 * [John Downs](https://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Harikrishnan M B](https://linkedin.com/in/harikrishnanmb/) | Product Manager 2, Azure Networking

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [global content delivery](./mission-critical-content-delivery.md) scenario to understand whether it applies to your solution.
