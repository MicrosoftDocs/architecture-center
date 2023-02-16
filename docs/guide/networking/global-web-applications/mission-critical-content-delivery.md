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

Some applications heavily depend on caching for performance acceleration as well as to improve the resiliency of their application servers. Content delivery networks (CDNs), including Azure Front Door, provide caching at the network edge.

It's common for mission-critical solutions to use multiple CDNs when serving their traffic. Azure Front Door provides a high uptime SLA, but by using multiple CDNs, you can achieve an even higher level of uptime. In the event that one CDN has a disaster, outage, or performance issue, your traffic can fail over to another CDN.

However, when you implement multiple CDNs, you need to carefully consider the full implications. Each CDN provides a separate network path to your application servers, and needs to be configured and tested separately.

In this article, we describe an approach for using Azure Front Door with a partner CDN, Verizon.

## Approach

Microsoft has partnered with Verizon's CDN, and you can integrate Verizon's CDN platform (Edgio) into your Azure-based solution. Although Verizon's CDN is partnered with Azure and can be configured from within the Azure portal and APIs, their CDN platform is isolated from Microsoft’s infrastructure.

This isolation provides a high degree of resiliency from disaster scenarios. In the event of an outage or disaster, traffic can be automatically shifted between Azure Front Door and Verizon's CDN. You can use Azure Traffic Manager to detect an outage and redirect traffic to the alternative CDN.

:::image type="content" source="./media/front-door-verizon-cdn.png" alt-text="Traffic Manager with weighted routing between AFD and Verizon’s CDN." border="false":::

<!-- TODO here down -->

## Configuration

The following steps provide a high-level overview how you can configure this multi-CDN approach:

1. Access your domain provider's administrative portal. Create two DNS CNAME entries (please see here for examples: Fail over across multiple endpoints with Traffic Manager - Azure Content Delivery Network | Microsoft Learn).
1. Configure a Verizon CDN profile, and then link it to your endpoints.
1. Configure Azure Traffic Manager with the required routing logic to load balance between Front Door and Verizon’s CDN.

   [Routing Methods](/azure/traffic-manager/traffic-manager-routing-methods) to Consider:
   - Priority: Create Primary/Fallback endpoints. If primary becomes unhealthy all traffic will failover to fallback endpoint
   - Weight: Distribute traffic (equally/unevenly) among endpoints by setting weight
   - Performance: Route traffic to least latent endpoints (please see [Real User Measurements in Azure Traffic Manager](/traffic-manager/traffic-manager-rum-overview))
   - Geo: Based on client geography, route to an endpoint in same geo
   - Subnet: Custom route specific client IP ranges to specific endpoint IP ranges
1. Point your custom domain to the Traffic Manager domain to initiate traffic flow to AFD and Verizon’s CDN.
1. ATM’s built-in endpoint health monitoring will now auto fail-over to in the rare event an outage with AFD is detected. Please see: [Azure Traffic Manager endpoint monitoring](/traffic-manager/traffic-manager-monitoring) for details.

## Considerations

### Cost

- Paying for multiple CDNs. This might or might not be a problem. Look into the CDNs you're using and how their billing works

### Monitoring health and triggering failover

There are numerous tools customers can utilize to monitor availability/performance, and these solutions will then automatically shift traffic over to another preconfigured CDN if a less than ideal threshold is identified. One of the key technologies to enable multi-CDN availability are DNS based load balancing solutions (e.g., Azure Traffic Manager).

 alternatively, customers can utilize third party load balancing solutions that are isolated from Microsoft or Verizon. 

### Feature parity

- Whether customers utilize Verizon’s CDN or another CDN with their multi-CDN strategy, customers would need to verify feature parity and then configure any features/capabilities they utilize with AFD (e.g., certificates, HTTP rules, WAF, etc.) on the failover CDN.

### Cache fill

- We recommend customers test the failover between CDNs, and then observe for anomalies or performance characteristics associated with their applications/infrastructures. One common issue that can arise for customers running multiple CDNs in an active/passive mode is the CDN configured in passive mode will need to perform a cache fill from your origin storage systems during a failover. During these scenarios of a cache fill, origin storage systems could become overloaded. As such, increasing the performance criteria for these storage systems and/or pre-filling the passive CDN with a percentage of your most popular content can mitigate against origin storage performance impacts.

### Choice of CDN

- Verizon is a good choice because it can be controlled and billed through Azure while running on separate infrastructure
- You can use another CDN if you prefer too, or even several CDNs

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [Dave Burkhardt](https://linkedin.com/in/david-burkhardt-13b79b3) | Principal Product Manager, Azure Networking
 * [John Downs](https://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Harikrishnan M B](https://linkedin.com/in/harikrishnanmb/) | Product Manager 2, Azure Networking

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

There are other industry solutions to achieve high availability with CDNs services, but we wanted to start by advising the most expedient and less complex solutions that are within Azure’s ecosystem. Nonetheless, please leverage your Microsoft Cloud Solutions Architects or Fast Track engineers to help you determine which solution is best for your organization.
