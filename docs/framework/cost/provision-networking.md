---
title: Cost estimates for networking resources
description: See networking cost considerations and examples for traffic routing, load balancing, peering, and hybrid connectivity.
author: PageWriter-MSFT
ms.date: 05/14/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-load-balancer
  - azure-front-door
ms.custom:
  - article
---

# Networking cost estimates

## Traffic routing and load balancing

Most workloads have a load balancing service to route and distribute traffic in a way that a single resource isn't overloaded, and the response time is minimum with maximum throughput.

**Do you need to distribute traffic within a region or across regions?**
***

Azure Front Door and Traffic Manager can distribute traffic to backends, clouds, or hybrid on-premises services that reside in multiple regions. Otherwise, for regional traffic that moves within virtual networks or zonal and zone-redundant service endpoints within a region, choose Application Gateway or Azure Load Balancer.

**What is the type of traffic?** 
***

Load balancers such as Azure Application Gateway and Azure Front Door are designed to route and distribute traffic to web applications or HTTP(S) endpoints. Those services support Layer 7 features such as SSL offload, web application firewall, path-based load balancing, and session affinity. For non-web traffic, choose Traffic Manager or Azure Load Balancer. Traffic Manager uses DNS to route traffic. Load Balancer supports Layer 4 features for all UDP and TCP protocols.

Here's the matrix for choosing load balancers by considering both dimensions.

|Service| Global/regional|Recommended traffic|
|---|---|---|
|[Azure Front Door](/azure/frontdoor/front-door-overview)|Global| HTTP(S)|
|[Traffic Manager](/azure/traffic-manager/traffic-manager-overview) |Global	|non-HTTP(S)|
|[Application Gateway](/azure/application-gateway/overview)|Regional| HTTP(S)|
|[Azure Load Balancer](/azure/load-balancer/load-balancer-overview)|Regional| non-HTTP(S)|

For more information, see [Choose a load balancing service](../../guide/technology-choices/load-balancing-overview.md).

### Example cost analysis

Consider a web application that receives traffic from users across regions over the internet. To minimize the request response time, the load balancer can delegate the responsibility from the web server to a different machine. The application is expected to consume 10 TB of data. Routing rules are required to route incoming requests to various paths. Also, we want to use Web Application Firewall (WAF) to secure the application through policies.

By using the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/), we can estimate the cost for these two services.
> The example is based on the current price and is subject to change. The calculation shown is for information purposes only.

#### Azure Front Door (West US), Zone 1.

![Azure Front Door ](../_images/cost-net-lb.png)

#### Application Gateway (West US)

![Application Gateway (West US)](../_images/cost-net-ag.png)

Consider a similar example where the type of traffic is changed. Instead the application is a UDP streaming service that is deployed across regions and traffic goes over the internet.  We can use a combination of Traffic Manager and Azure Load Balancer. Traffic Manager is a simple routing service that uses DNS to direct clients to specific service. Here are the cost estimates:

#### Azure Traffic Manager

|Item|Example estimate|
|---|---|
|DNS queries|100 million x $0.54/per million = $54.00|
|Basic health checks|20 endpoints x $0.36/month = $7.20|
|Fast interval health checks|10 endpoints x $1.00/month = $10.00|
|External endpoints hosted outside Azure|10 endpoints x $0.54/month = $5.40|
|Real User Measurements|100 million user measurements x $2.00/month = $200.00|
|Traffic view |100 million data points processed x $2.00/month = $200.00|
|**Total**|$486.60|

#### Azure Load Balancer

|Item|Example estimate|
|---|---|
|Rules|First 5 rules: $0.032/rule/hour x 730 = $18.25|
||Additional 5 rules: $0.013/rule/hour x 730 = $36.50|
|Data processed|10 TB x $0.005/GB = 51.20|
|**Total**|$105.95|

## Peering

**Do you need to connect virtual networks?**
***

[Peering technology](/azure/virtual-network/virtual-network-peering-overview) is a service used for Azure virtual networks to connect with other virtual networks in the same or different Azure region. Peering technology is used often in hub and spoke architectures.

An important consideration is the additional costs incurred by peering connections on both egress and ingress traffic traversing the peering connections.
> ![Task](../../_images/i-best-practices.svg) Keeping the top talking services of a workload within the same virtual network, zone and/or region unless otherwise required. Use virtual networks as shared resources for multiple workloads against a single virtual network per workload approach. This approach will localize traffic to a single virtual network and avoid the additional costs on peering charges.

### Example cost analysis

> The example is based on the current price and is subject to change. The calculation shown is for information purposes only.

Peering within the same region is cheaper than peering between regions or Global regions. For instance, you consume 50 TB per month by connecting two VNETs in Central US. Using the current price here is the incurred cost.

|Item|Example estimate|
|---|---|
|Ingress traffic|50 TB x $0.0100/GB = $512.50|
|Egress traffic|50 TB x $0.0100/GB = $512.50|
|**Total**|$1,025.00|

Let's compare that cost for cross-region peering between Central US and East US.

|Item|Example estimate|
|---|---|
|Ingress traffic|50 TB x $0.0350/GB   = $1,792.00|
|Egress traffic|50 TB x $0.0350/GB =   $1,792.00|
|**Total** |$3,584.00|

## Hybrid connectivity

There are two main options for connecting an on-premises datacenter to Azure datacenters:

- [Azure VPN Gateway](/azure/vpn-gateway/) can be used to connect a virtual network to an on-premises network through a VPN appliance or to Azure Stack through a site-to-site VPN tunnel.
- [Azure ExpressRoute](/azure/expressroute/) creates private connections between Azure datacenters and infrastructure that's on premise or in a colocation environment.

**What is the required throughput for cross-premises connectivity?**
***

VPN gateway is recommended for development/test cases or small-scale production workloads where throughput is less than 100 Mbps. Use ExpressRoute for enterprise and mission-critical workloads that access most Azure services. You can choose bandwidth from 50 Mbps to 10 Gbps.

Another consideration is security. Unlike VPN Gateway traffic, ExpressRoute connections don't go over the public internet. VPN Gateway traffic is secured by industry standard IPsec.

For both services, inbound transfers are free and outbound transfers are billed per the billing zone.

For more information, see [Choose a solution for connecting an on-premises network to Azure](../../reference-architectures/hybrid-networking/index.yml).

This [blog post](https://azure.microsoft.com/blog/expressroute-or-virtual-network-vpn-whats-right-for-me/) provides a comparison of the two services.

### Example cost analysis

This example compares the pricing details for VPN Gateway and ExpressRoute.
> The example is based on the current price and is subject to change. The calculation shown is for information purposes only.

#### Azure VPN Gateway

Suppose, you choose the **VpnGw2AZ** tier, which supports availability zones; 1 GB/s bandwidth. The workload needs 15 site-to-site tunnels and 1 TB of outbound transfer. The gateway is provisioned and available for 720 hours.

|Item|Example estimate|
|---|---|
|VPN Hours|720 x $0.564 = $406.08
Site to Site (S2S) Tunnels| The first 10 tunnels are free. For additional tunnels, the cost is 5 tunnels x 720 hours x $0.015 per hour per tunnel = $54.00|
|Outbound transfer| 1024 GB x 0.086 = $88.65|
|Total cost per month| $548.73|

#### ExpressRoute

Let's choose the **Metered Data** plan in billing zone of **Zone 1**.

|Item|Example estimate|
|---|---|
|Circuit bandwidth|1 GB/s speed has a fixed rate of $436.00 for the standard price.|
|Outbound transfer|1 TB x $0.0025 = $25.60|
|Total cost per month|$461.00|

The main cost driver is outbound data transfer. ExpressRoute is more cost-effective than VPN Gateway when consuming large amounts of outbound data. If you consume more than 200 TB per month, consider ExpressRoute with the **Unlimited Data** plan where you're charged a flat rate.

For pricing details, see:

- [Azure VPN Gateway pricing](https://azure.microsoft.com/pricing/details/vpn-gateway/)
- [Azure ExpressRoute pricing](https://azure.microsoft.com/pricing/details/expressroute/)
