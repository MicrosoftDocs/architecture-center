---
title: Networking resources provisioning
description: Describes cost strategies for networking design choices
author: PageWriter-MSFT
ms.date: 05/14/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-application-gateway
  - azure-load-balancer
ms.custom:
  - article
---

# Networking resources provisioning

For design considerations, see [Networking resource choices](provision-networking.md).

## Azure Front Door
Azure Front Door billing is affected by outbound data transfers, inbound data transfers, and routing rules.  The pricing chart doesn't include the cost of accessing data from the backend services and transferring to Front Door. Those costs are billed based on data transfer charges, described in [Bandwidth Pricing Details](https://azure.microsoft.com/pricing/details/bandwidth/).

Another consideration is Web Application Firewall (WAF) settings. Adding policies will drive up the cost.

For more information, see [Azure Front Door Pricing](https://azure.microsoft.com/pricing/details/frontdoor/).

### Reference architecture
[Highly available multi-region web application](../../reference-architectures/app-service-web-app/multi-region.yml) uses Front Door to route incoming requests to the primary region. If the application running that region becomes unavailable, Front Door fails over to the secondary region.

## Azure Application Gateway

There are two main pricing models:

- Fixed price

  You're charged for the time that the gateway is provisioned and available and the amount of data processed by the gateway. For more information, see Application Gateway pricing.

- Consumption price

    This model applies to v2 SKUs that offer additional features such as autoscaling, Azure Kubernetes Service Ingress Controller, zone redundancy, and others. You're charged based on the consumed capacity units. The capacity units measure the compute resources, persistent connections, and throughput.  Consumption price is charged in addition to the fixed price.

For more information, see:
-  [Application Gateway v2 pricing](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#pricing)
-  [Application Gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/)

### Reference architecture
- [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml) uses Application Gateway as the ingress controller.

- [Securely managed web applications](../../example-scenario/apps/fully-managed-secure-apps.yml) uses Application Gateway as a web traffic load balancer operating at Layer 7 that manages traffic to the web application. Web Application Firewall (WAF) is enabled to  enhance security.

## Azure ExpressRoute
There are two main pricing models:

- **Metered Data plan**

    There are two pricing tiers: **Standard** and **Premium**, which is priced higher. The tier pricing is based on the circuit bandwidth.

    If you don't need to access the services globally, choose **Standard**. With this tier, you can connect to regions within the same zone at no additional cost. Outbound cross-zonal traffic incurs more cost.

- **Unlimited Data plan**

    All inbound and outbound data transfer is included in the flat rate. There are two pricing tiers: **Standard** and **Premium**, which is priced higher.

Calculate your utilization and choose a billing plan. The **Unlimited Data plan** is recommended if you exceed about 68% of utilization.

For more information, see [Azure ExpressRoute pricing](https://azure.microsoft.com/pricing/details/expressroute).

### Reference architecture
[Connect an on-premises network to Azure using ExpressRoute](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml) connects an Azure virtual network and an on-premises network connected using with VPN gateway failover.

## Azure Firewall

 Azure Firewall usage can be charged at a fixed rate per deployment hour. There's additional cost for the amount of data transferred.

There aren't additional cost for a firewall deployed in an availability zone. There are additional costs for inbound and outbound data transfers associated with availability zones.

When compared to network virtual appliances (NVAs), with Azure Firewall you can save up to 30-50%. For more information see [Azure Firewall vs NVA](https://azure.microsoft.com/blog/azure-firewall-and-network-virtual-appliances).

### Reference architecture
- [Hub-spoke network topology in Azure](../../reference-architectures/hybrid-networking/hub-spoke.yml)
- [Deploy highly available NVAs](../../reference-architectures/dmz/nva-ha.yml)

## Azure Load Balancer
The service distributes inbound traffic according to the configured rules.

There are two tiers: **Basic** and **Standard**.

The **Basic** tier is free.

For the **Standard** tier, you are charged only for the number of configured load-balancing and outbound rules. Inbound NAT rules are free. There's no hourly charge for the load balancer when no rules are configured.

See [Azure Load Balancer Pricing](https://azure.microsoft.com/pricing/details/load-balancer/) for more information.

### Reference architecture
- [Connect an on-premises network to Azure using ExpressRoute](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml): Multiple subnets are connected through Azure load balancers.

- [SAP S/4HANA in Linux on Azure](../../reference-architectures/sap/sap-s4hana.yml): Distribute traffic to virtual machines in the application-tier subnet.

- [Extend an on-premises network using VPN](../../reference-architectures/hybrid-networking/vpn.yml) Internal load balancer. Network traffic from the VPN gateway is routed to the cloud application through an internal load balancer. The load balancer is located in the front-end subnet of the application.

## Azure VPN Gateway

When provisioning a VPN Gateway resource, choose between two gateway types:
- VPN gateway to send encrypted traffic across the public internet. Site-to-Site, Point-to-Site, and VNet-to-VNet connections all use a VPN gateway.
- ExpressRoute gateway - To send network traffic on a private connection. This is used when configuring Azure ExpressRoute.

For VPN gateway, select **Route-based** or **Policy-based** based on your VPN device and the kind of VPN connection you want to create. Route-based gateway allows point-to-site, inter-virtual network, or multiple site-to-site connections. Policy based only allows one site-to-site tunnel. Point-to-site isn't supported. So, route-based VPN is more expensive.

Next, you need to choose the SKU for **Route-based** VPN. For developer/test workloads, use **Basic**. For production workloads, an appropriate **Generation1** or **Generation2** SKU. Each SKU has a range and pricing depends on the type of VPN gateway because each type offers different levels of bandwidth, site-to-site, and point-to-site tunnel options. Some of those types also offer availability zones, which are more expensive. If you need higher bandwidth, consider Azure ExpressRoute.

VPN gateway can be the cost driver in a workload because charges are based on the amount of time that the gateway is provisioned and available.

All inbound traffic is free, all outbound traffic is charged as per the bandwidth of the VPN type. Bandwidth also varies depending on the billing zone.

For more information, see
- [Hybrid connectivity](./provision-networking.md#hybrid-connectivity)
- [VPN Gateway Pricing](https://azure.microsoft.com/pricing/details/vpn-gateway/).
- [Traffic across zones](./design-regions.md#traffic-across-billing-zones-and-regions)
- [Bandwidth Pricing Details](https://azure.microsoft.com/pricing/details/bandwidth/).

### Reference architecture
- [Extend an on-premises network using VPN](../../reference-architectures/hybrid-networking/vpn.yml) connects the virtual network to the on-premises network through a VPN device.

## Traffic Manager
Traffic manager uses DNS to route and load balance traffic to service endpoints in different Azure regions. So, an important use case is disaster recovery. In a workload, you can use Traffic Manager to route incoming requests to the primary region. If that region becomes unavailable, Traffic Manager fails over to the secondary region. There are other features that can make the application highly responsive and available. Those features cost money.
- Determine the best web app to handle request based on geographic location.
- Configure caching to reduce the response time.

Traffic Manager isn't charged for bandwidth consumption. Billing is based on the number of DNS queries received, with a discount for services receiving more than 1 billion monthly queries. You're also charged for each monitored endpoint.

### Reference architecture

[Multi-region N-tier application](../../reference-architectures/n-tier/multi-region-sql-server.yml) uses Traffic Manager to route incoming requests to the primary region. If that region becomes unavailable, Traffic Manager fails over to the secondary region. For more information, see the section [Traffic Manager configuration](../../reference-architectures/n-tier/multi-region-sql-server.yml#traffic-manager-configuration).

### DNS query charges
Traffic Manager uses DNS to direct clients to specific service.

Only DNS queries that reach Traffic Manager are charged in million query units. For 100 million DNS queries month, the charges will be $54.00 a month based on the current Traffic Manager pricing.

Not all DNS queries reach Traffic Manager. Recursive DNS servers run by enterprises and ISPs first attempt to resolve the query by using cached DNS responses. Those servers query Traffic Manager at a regular interval to get updated DNS entries. That interval value or TTL is configurable in seconds. TTL can impact cost. Longer TTL increases the amount of caching and reduces DNS query charges. Conversely, shorter TTL results in more queries.

However, there is a tradeoff. Increased caching also impacts how often the endpoint status is refreshed.  For example, the user failover times, for an endpoint failure, will become longer.

### Health monitoring charges
When Traffic Manager receives a DNS request, it chooses an available endpoint based on configured state and health of the endpoint. To do this, Traffic Manager continually monitors the health of each service endpoint.

The number of monitored endpoints are charged. You can add endpoints for services hosted in Azure and then add on endpoints for services hosted on-premises or with a different hosting provider. The external endpoints are more expensive, but health checks can provide high-availability applications that are resilient to endpoint failure, including Azure region failures.

### Real User Measurement charges
Real User Measurements evaluates network latency from the client applications to Azure regions. That influences Traffic Manager to select the best Azure region in which the application is hosted. The number of measurements sent to Traffic Manager is billed.

### Traffic view charges
By using Traffic View, you can get insight into the traffic patterns where you have endpoints. The charges are based on the number of data points used to create the insights presented.

## Virtual Network
Azure Virtual Network is free. You can create up to 50 virtual networks across all regions within a subscription. Here are a few considerations:

- Inbound and outbound data transfers are charged per the billing zone. Traffic that moves across regions and billing zones are more expensive. For more information, see:
    - [Traffic across zones](./design-regions.md#traffic-across-billing-zones-and-regions)
    - [Bandwidth Pricing Details](https://azure.microsoft.com/pricing/details/bandwidth/).

- VNET Peering has additional cost. Peering within the same region is cheaper than peering between regions or Global regions. Inbound and outbound traffic is charged at both ends of the peered networks. For more information, see [Peering](./provision-networking.md#peering)

- Managed services (PaaS) don't always need a virtual network. The cost of networking is included in the service cost.
