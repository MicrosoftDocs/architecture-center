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

## Azure Traffic Manager + Azure Front Door + Azure Application Gateway

This DNS based load balancing solution utilizes Azure Traffic Manager (ATM) to monitor AFD, in the very unlikely event of an availability issue, and then will fail-over the traffic to Application Gateway (AppGW). 

Points for consideration:
- This combination is useful if you want to keep using features like rules engine, WAF, TLS offload in the event of a failover. 
- Unlike AFD which is a global service, AppGW is a regional service, which means you would need to spin up an AppGW instance in each Azure region you have an origin. This can become very costly if you have origins across multiple regions.
- If you have enabled caching with AFD, after failover to AppGW, your content will no longer be served from AFD’s 185+ global edge PoPs. So, depending on the size of your content library if you, you could potentially overload your origin when a failover occurs – meaning, performance of your internet application/services will load slowly, but your traffic will not be offline if AFD is down. 
- It is recommended that your AppGW is also appropriately scaled to serve traffic incase of a failover or has autoscaling enabled.
- While there are similarities between the features that AFD and AppGW offer, not all features have parity (e.g., rules engine, WAF etc.). Similarly, AFD has additional capabilities that may not be offered with AppGW (e.g., caching). Be mindful of these differences as they could affect how the application delivery behavior after failover. 
- You can consider using a nested ATM structure (a second ATM between the first ATM and the Application Gateways) for finer control over the routing logic

:::image type="content" source="./media/front-door-application-gateway.png" alt-text="Traffic Manager with priority routing (AFD on higher priority) and AFD on least latency routing." border="false":::

## Next steps

There are other industry solutions to achieve high availability with CDNs services, but we wanted to start by advising the most expedient and less complex solutions that are within Azure’s ecosystem. Nonetheless, please leverage your Microsoft Cloud Solutions Architects or Fast Track engineers to help you determine which solution is best for your organization.