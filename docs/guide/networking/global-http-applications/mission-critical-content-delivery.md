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

## Azure Front Door + Verizon’s CDN for Disaster Recovery Failover

It is a common industry practice for customers who need to implement Disaster Recovery (DR) solutions pertaining to their web applications to utilize multiple CDNs. As we mentioned earlier, AFD already provides customers with a 99.99% SLA, but leveraging more than one CDN can significantly increase the uptime with your web applications in the event a CDN has disaster, outage and/or performance degradation. There are numerous tools customers can utilize to monitor availability/performance, and these solutions will then automatically shift traffic over to another preconfigured CDN if a less than ideal threshold is identified. One of the key technologies to enable multi-CDN availability are DNS based load balancing solutions (e.g., Azure Traffic Manager). Moreover, since DNS is a key element with serving web application traffic, it is also an industry best practice to utilize multiple DNS resolvers to ensure the utmost availability.

Microsoft has partnered with Verizon’s CDN offering, and customers can easily integrate this additional CDN platform from within the Azure portal. While Verizon’s CDN can be configured from the Azure portal, their CDN platform is isolated from Microsoft’s infrastructure.  This isolation will allow for an excellent failover option during various disaster scenarios. In the event of an outage/disaster, traffic can be automatically shifted between AFD and Verizon’s CDN by placing Azure’s Traffic Manager (ATM) in front of both CDNs – or alternatively, customers can utilize third party load balancing solutions that are isolated from Microsoft or Verizon. 

Points for consideration:
- Whether customers utilize Verizon’s CDN or another CDN with their multi-CDN strategy, customers would need to verify feature parity and then configure any features/capabilities they utilize with AFD (e.g., certificates, HTTP rules, WAF, etc.) on the failover CDN.
- We recommend customers test the failover between CDNs, and then observe for anomalies or performance characteristics associated with their applications/infrastructures. One common issue that can arise for customers running multiple CDNs in an active/passive mode is the CDN configured in passive mode will need to perform a cache fill from your origin storage systems during a failover. During these scenarios of a cache fill, origin storage systems could become overloaded. As such, increasing the performance criteria for these storage systems and/or pre-filling the passive CDN with a percentage of your most popular content can mitigate against origin storage performance impacts.

:::image type="content" source="./media/front-door-verizon-cdn.png" alt-text="Traffic Manager with weighted routing between AFD and Verizon’s CDN." border="false":::

## Implementation overview

The following steps provide a high-level overview how AFD customers can utilize Azure Traffic Manager to failover to Verizon’s CDN:

1. Access your domain provider’s administrative portal and create two DNS CNAME entries (please see here for examples: Fail over across multiple endpoints with Traffic Manager - Azure Content Delivery Network | Microsoft Learn).
1. Configure a Verizon CDN profile, and then link it to your endpoints.
1. Configure ATM with the required routing logic to load balance between Front Door and Verizon’s CDN.

   [Routing Methods](/azure/traffic-manager/traffic-manager-routing-methods) to Consider:
   - Priority: Create Primary/Fallback endpoints. If primary becomes unhealthy all traffic will failover to fallback endpoint
   - Weight: Distribute traffic (equally/unevenly) among endpoints by setting weight
   - Performance: Route traffic to least latent endpoints (please see [Real User Measurements in Azure Traffic Manager](/traffic-manager/traffic-manager-rum-overview))
   - Geo: Based on client geography, route to an endpoint in same geo
   - Subnet: Custom route specific client IP ranges to specific endpoint IP ranges
1. Point your custom domain to the Traffic Manager domain to initiate traffic flow to AFD and Verizon’s CDN.
1. ATM’s built-in endpoint health monitoring will now auto fail-over to in the rare event an outage with AFD is detected. Please see: [Azure Traffic Manager endpoint monitoring](../traffic-manager/traffic-manager-monitoring.md) for details.

## Next steps

There are other industry solutions to achieve high availability with CDNs services, but we wanted to start by advising the most expedient and less complex solutions that are within Azure’s ecosystem. Nonetheless, please leverage your Microsoft Cloud Solutions Architects or Fast Track engineers to help you determine which solution is best for your organization.
