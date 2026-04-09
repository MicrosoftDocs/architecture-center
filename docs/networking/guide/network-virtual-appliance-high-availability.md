---
title: Deploy Highly Available NVAs
description: Learn how to deploy network virtual appliances in high availability architectures for ingress and egress traffic in Azure.
author: erjosito
ms.author: jomore
ms.date: 03/25/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Deploy highly available NVAs

This article describes common ways to deploy a set of network virtual appliances (NVAs) for high availability in Azure. An NVA typically controls the flow of traffic between network segments that have different security levels. For example, you might use an NVA between a perimeter network virtual network and the public internet, or to connect external locations to Azure via a VPN or software-defined WAN (SD-WAN) appliances.

This article assumes that you have a basic understanding of Azure networking, [Azure load balancers](/azure/load-balancer/load-balancer-overview), [virtual network traffic routing](/azure/virtual-network/virtual-networks-udr-overview), and user-defined routes (UDRs).

Many design patterns use NVAs to inspect traffic between different security zones. These patterns might use NVAs to:

- Inspect egress traffic from virtual machines to the internet and prevent data exfiltration.

- Inspect ingress traffic from the internet to virtual machines and prevent attacks.

- Filter traffic between virtual machines in Azure to prevent lateral moves of compromised systems.

- Filter traffic between on-premises systems and Azure virtual machines, especially if they belong to different security levels. For example, Azure hosts the perimeter network, while the on-premises environment hosts the internal applications.

- Terminate VPN or SD-WAN tunnels from external locations, such as on-premises networks or other public clouds.

You can add the following NVAs to an Azure design by using the patterns in this article:

- Network firewalls
- Layer-4 reverse proxies
- Internet Protocol Security (IPsec) VPN endpoints
- SD-WAN appliances
- Web-based reverse proxies that have web application firewall (WAF) functionality
- Internet proxies to restrict which internet pages can be accessed from Azure
- Layer-7 load balancers

Azure-native NVAs, such as [Azure Firewall](/azure/firewall/overview) and [Azure Application Gateway][appgw], use the designs explained later in this article. You should understand these options from a design perspective and for network troubleshooting purposes.

NVAs often require high availability because they control the communication between network segments. If NVAs become unavailable, network traffic can't flow and applications stop working. Scheduled and unscheduled outages occasionally shut down NVA instances, similar to other virtual machines in Azure or in other clouds. The NVA instances might shut down even if you configure them with Azure Premium SSDs, which provide a single-instance service-level agreement in Azure. Highly available applications require at least two NVAs to help ensure connectivity.

When you choose the best option to deploy an NVA into an Azure virtual network, the most important aspect is whether the NVA vendor evaluates and validates the design. The vendor must also provide the required NVA configuration to integrate the NVA into Azure. If the NVA vendor provides multiple supported design options, consider the following factors:

- **Convergence time:** The time that it takes each design to reroute traffic away from a failed NVA instance

- **Topology support:** The NVA configurations that each design option supports, such as active/active, active/standby, or scale-out NVA clusters that have an extra unit for redundancy

- **Traffic symmetry:** Whether a particular design forces the NVA to perform Source Network Address Translation (SNAT) on the packets to avoid asymmetric routing, or if the design enforces traffic symmetry by other means

>[!NOTE]
> This article focuses on [hub-and-spoke designs](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology). It doesn't cover [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about) because it has more prescriptive guidelines for NVA deployment, depending on whether a Virtual WAN hub supports a specific NVA. For more information, see [NVAs in a Virtual WAN hub](/azure/virtual-wan/about-nva-hub).

The following sections describe common architectures that you can use to integrate NVAs into a hub-and-spoke network.

## High availability architectures overview

| Solution | Benefits | Considerations |
| --- | --- | --- |
| [Load Balancer](#load-balancer) | This solution supports active/active and active/standby configurations, and scale-out NVAs with good convergence time. | The NVA needs to provide a port for the health probes, especially for active/standby deployments. For stateful appliances, such as firewalls that require traffic symmetry, flows to and from the internet require SNAT. |
| [Azure Route Server](#route-server) | The NVA must support Border Gateway Protocol (BGP). This solution supports active/active, active/standby, and scale-out NVAs. | Traffic symmetry requires SNAT in this solution. |
| [Gateway Load Balancer](#gateway-load-balancer) | Traffic symmetry is guaranteed without SNAT. NVAs can be shared across tenants. This solution has a good convergence time and supports active/active, active/standby, and scale-out NVAs. | This solution supports flows to and from the internet and doesn't support East-West flows. |
| [Dynamic public IP address and UDRs](#dynamic-public-ip-address-and-udr-management) | The NVA doesn't require special features. This solution guarantees symmetric traffic. | This solution is only for active/passive designs. It has a high convergence time of one to two minutes. |

## Common high availability patterns

The following recommendations and considerations apply to all designs:

- Deploy the NVA instances across multiple availability zones if available in your Azure region. Multiple availability zones increase the resiliency of your NVA and protect your network against failures of a single zone.

- For egress traffic to the public internet, consider using an Azure NAT gateway with availability zone support for best resiliency and scalability. For more information, see [Reliability in Azure NAT Gateway][natgw_reliability].

- For more outbound traffic approaches, see [Use SNAT for outbound connections][outbound].

## Load Balancer

The Load Balancer design pattern uses two Azure load balancers to expose a cluster of NVAs to the rest of the network. The approach suits both stateful and stateless NVAs.

- An internal load balancer redirects internal traffic from Azure and on-premises to the NVAs. This internal load balancer is configured with [high availability ports rules][alb_haports] so that every Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) port is redirected to the NVA instances.

- A public load balancer exposes the NVAs to the internet. High availability ports are for inbound traffic, so each TCP and UDP port needs to be opened in a dedicated load-balancing rule.

The following diagram shows the sequence of hops that packets take from the internet to an application server in a spoke virtual network. These packets traverse a firewall NVA to control traffic to and from the public internet, also called *North-South traffic*.

:::image type="complex" source="./images/network-virtual-appliance-high-availability-load-balancer-internet-inbound.svg" lightbox="./images/network-virtual-appliance-high-availability-load-balancer-internet-inbound.svg" alt-text="Diagram that shows inbound internet traffic with Load Balancer integration." border="false":::
Diagram that shows a hub and two spokes. The hub contains a gateway subnet and an NVA subnet. The gateway subnet contains a VPN or Azure ExpressRoute gateway. The NVA subnet contains an internal load balancer and NVAs. Spoke1 contains an app server in the 10.1.1.0/24 address space. Spoke2 contains an app server in the 10.1.2.0/24 address space. Inbound traffic flows from the public internet to the NVAs through the public load balancer. The NVAs need to perform SNAT before they send the traffic to the app server to guarantee traffic symmetry. The translated traffic then flows to the app server in Spoke2. Return traffic flows from this app server directly to the corresponding NVA instance because of SNAT, which forwards it to the public internet.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/network-virtual-appliance-high-availability-load-balancer-internet-inbound.vsdx) of this architecture.*

This design requires SNAT because traffic in each direction would otherwise pass through a different load balancer. The internal and public Azure load balancers can't guarantee traffic symmetry, so the NVA instances must perform SNAT to attract return traffic. Most stateful NVAs, such as firewalls, require traffic symmetry.

The following diagram shows a slightly different pattern for outbound traffic.

:::image type="complex" source="./images/network-virtual-appliance-high-availability-load-balancer-internet-outbound.svg" lightbox="./images/network-virtual-appliance-high-availability-load-balancer-internet-outbound.svg" alt-text="Diagram that shows outbound internet traffic with Load Balancer integration." border="false":::
  Diagram that shows a hub and two spokes. The hub contains a gateway subnet and an NVA subnet. The gateway subnet contains a VPN or Azure ExpressRoute gateway. The NVA subnet contains an internal load balancer and NVAs. There's a NAT gateway between the NVA subnet and the internet. Each spoke contains an app server. Spoke2 contains a spoke route table for IP address ranges 0.0.0.0/0 to 10.0.0.36, with gateway propagation turned off. Outbound traffic flows from the Spoke2 app server to the NVA through the internal load balancer because of the UDR for 0.0.0.0/0. The NVA sends it to the public internet through the NAT gateway. Return traffic comes back through the NAT gateway, then to the NVA, and finally to the Spoke2 app server.
:::image-end:::

To send traffic from spokes to the public internet through the NVAs, this design uses a UDR for `0.0.0.0/0` applied to the application server's subnet in the spoke virtual network. The next hop is the internal load balancer's IP address. The load balancer forwards the traffic to one of the NVA instances, which sends it to the public internet via the NAT gateway. The NAT gateway ensures that return traffic is forwarded to the same NVA instance, which delivers it to the first app server.

The following diagram shows how to use the same load balancer design to inspect traffic between Azure and on-premises networks, or *East-West traffic*, which involves only an internal load balancer. You can also use this method to send traffic between spokes through the NVAs.

:::image type="complex" source="./images/load-balancer-on-premises.svg" lightbox="./images/load-balancer-on-premises.svg" alt-text="Diagram that shows on-premises traffic with Load Balancer integration." border="false":::
  Diagram that shows a hub and two spokes. The hub contains a gateway subnet and NVA subnet. The gateway subnet contains a VPN or ExpressRoute gateway. The NVA subnet contains an internal load balancer and NVAs. Each spoke contains an app server. Spoke2 contains a spoke route table for IP address ranges 0.0.0.0/0 to 10.0.0.36, with gateway propagation turned off. Inbound traffic flows from on-premises to the NVAs through the VPN or ExpressRoute gateway and then the internal load balancer. This traffic then flows to the app server in Spoke2. Return traffic flows from this app server to the NVAs through the internal load balancer. This traffic then flows to on-premises through the VPN or ExpressRoute gateway.
:::image-end:::

In the previous diagrams, Spoke1 doesn't know about Spoke2's range. Therefore, the `0.0.0.0/0` UDR sends traffic that's intended for Spoke2 to the NVA's internal load balancer.

For traffic between on-premises networks and Azure or between Azure virtual machines, traffic symmetry is guaranteed in single network interface card (NIC) NVAs by the internal load balancer. When both directions of a traffic flow traverse the same load balancer, the load balancer selects the same NVA instance for both directions. If a dual-NIC NVA design has an internal load balancer for each direction of communication, SNAT is required to ensure traffic symmetry. The previous North-South diagram provides an example of this design.

In this design, dual-NIC NVAs must determine where to send replies to the load balancer's health checks. Load Balancer always uses the same IP address as the source for the health checks, which is `168.63.129.16`. The NVA must send these health check responses back through the same interface on which they're received. This process typically requires multiple routing tables in an OS because destination-based routing sends the replies through the same NIC.

The load balancer has a good convergence time in individual NVA outages. You can send [health probes](/azure/load-balancer/load-balancer-custom-probe-overview) every five seconds, and it takes three failed probes to declare a back-end instance out of service. It usually takes 10 to 15 seconds for the load balancer to converge traffic to a different NVA instance.

This setup supports both active/active and active/standby configurations. For active/standby configurations, the NVA instances need to provide either a TCP or UDP port or an HTTP endpoint that responds only to the load balancer health probes for the instance currently in the active role.

### Layer-7 load balancers

A specific design for security appliances replaces the Azure public load balancer with a Layer-7 load balancer such as Application Gateway, which can also be thought of as an NVA.

In this scenario, the NVAs only require an internal load balancer for traffic from the workload systems. Dual-NIC devices sometimes use this approach to avoid routing problems with the load balancer's health checks. This design supports only the Layer-7 protocols that the Layer-7 load balancer supports, which are typically HTTP and HTTPS.

The NVA typically handles inbound traffic for protocols that the Layer-7 load balancer doesn't support. The NVA might also handle egress traffic. For more information, see [Azure Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway).

## Route Server

[Route Server](/azure/route-server/overview) is a service that connects NVAs to Azure software-defined networking via BGP. NVAs learn which IP address prefixes exist in Azure virtual networks. They can also inject routes in the effective route tables of virtual machines in Azure. 

:::image type="complex" source="./images/route-server-internet.svg" lightbox="./images/route-server-internet.svg" alt-text="Diagram that shows internet traffic with Route Server integration." border="false":::
  Diagram that shows a hub and two spokes. The hub contains a gateway subnet, NVA subnet, and Route Server subnet. The gateway subnet contains a VPN or ExpressRoute gateway. The NVA subnet contains two NVAs. The Route Server subnet contains Route Server. Each spoke contains an app server. Spoke2 contains spoke effective routes from IP address ranges 0.0.0.0/0 to 10.0.0.37 and 0.0.0.0/0 to 10.0.0.38. Inbound traffic flows from the public internet to NVA1 through the public load balancer. This traffic then flows to the app server in Spoke2. Return traffic flows from this app server to NVA1 and then to the public internet. BGP adjacency connects NVA1, NVA2, and Route Server. NVA2 and Route Server are connected via an external BGP (eBGP).
:::image-end:::

In the previous diagram, each NVA instance connects to Route Server via BGP. This design doesn't require a route table in the spoke subnets because Route Server configures the spoke workloads with the routes advertised by the NVAs. If two or more routes are programmed in the Azure virtual machines, they use equal-cost multipath routing to choose one of the NVA instances for every traffic flow. Therefore, you must include SNAT in this design if you require traffic symmetry.

This insertion method supports both active/active and active/standby configurations. In an active/active configuration, all NVAs advertise the same routes to Route Server. In an active/standby configuration, one NVA advertises routes with a shorter Autonomous System (AS) path than the other. Route Server supports a maximum of eight BGP adjacencies, so if you use a scale-out cluster of active NVAs, this design supports a maximum of eight NVA instances.

This setup has a fast convergence time. The keepalive and holdtime timers of the BGP adjacency influence the convergence time. Route Server has default keepalive timers set to 60 seconds and holdtime timers set to 180 seconds. But the NVAs can negotiate lower timers during the BGP adjacency establishment. You can cause BGP instability if you set these timers too low.

This design suits NVAs that need to interact with Azure routing. Examples include SD-WAN or IPsec NVAs, which typically have good BGP support. These NVAs need to learn the prefixes configured in Azure virtual networks or advertise certain routes over ExpressRoute private peerings. These types of appliances are usually stateless, so traffic symmetry isn't a problem and SNAT isn't required.

## Gateway Load Balancer

[Gateway Load Balancer](/azure/load-balancer/gateway-overview) can insert NVAs in the data path without the need to route traffic by using UDRs. For virtual machines that expose their workloads via a load balancer or via a public IP address, you can redirect inbound and outbound traffic transparently to a cluster of NVAs located in a different virtual network. The following diagram shows the path that packets follow for inbound traffic from the public internet if the workloads expose the application via a load balancer.

:::image type="complex" source="./images/gateway-load-balancer-internet.svg" lightbox="./images/gateway-load-balancer-internet.svg" alt-text="Diagram that shows internet traffic with Gateway Load Balancer integration." border="false":::
  Diagram that shows an NVA virtual network and an app virtual network. The NVA virtual network contains Gateway Load Balancer and NVAs. The app virtual network contains a web server. The user flow goes from the internet to the web server via a public standard load balancer. Gateway Load Balancer directs the flow from the public standard load balancer to Gateway Load Balancer and then to the NVAs. This flow reverses direction and goes from the NVAs to Gateway Load Balancer and then to the public standard load balancer.
:::image-end:::

This NVA injection method:

- Eliminates the need for SNAT to guarantee traffic symmetry.
- Enables the same NVAs to inspect traffic to and from multiple virtual networks, which supports multitenancy from the NVA perspective.
- Removes the requirement for virtual network peering between the NVA virtual network and the workload virtual networks, which simplifies configuration.
- Removes the need for UDRs in the workload virtual network, which also simplifies configuration.

You can use service injection via Gateway Load Balancer for inbound traffic to an Azure public load balancer, its return traffic, and outbound traffic from Azure. East-West traffic between Azure virtual machines can't use Gateway Load Balancer for NVA injection.

In the NVA cluster, load balancer health check probes detect failures in individual NVA instances, which provides a quick convergence time of 10 to 15 seconds.

## Dynamic public IP address and UDR management

The goal of this design is to have a setup that functions without NVA redundancy and can be modified if the NVA experiences downtime. The following diagram shows how an Azure public IP address associates with an active NVA (NVA1 in the following diagram). The UDRs in the spokes use the active NVA's IP address, `10.0.0.37`, as the next hop.

:::image type="complex" source="./images/private-ip-internet.svg" lightbox="./images/private-ip-internet.svg" alt-text="Diagram that shows internet traffic with dynamic public IP address and UDR management." border="false":::
  Diagram that shows a hub and two spokes. The hub contains a gateway subnet and NVA subnet. The gateway subnet contains a VPN or ExpressRoute gateway. The NVA subnet contains two NVAs. NVA1 is labeled as active and NVA2 is labeled as standby. Each spoke contains an app server. Spoke2 contains a spoke route table for IP address ranges 0.0.0.0/0 to 10.0.0.37, gateway propagation turned off. Inbound traffic flows from the internet to NVA1 through a public IP address. This traffic then flows to Spoke2. Return traffic flows from Spoke2 to NVA1 and then to the internet.
:::image-end:::

If the active NVA becomes unavailable, the standby NVA calls the Azure API to remap the public IP address and the spoke UDRs to itself, or to also take over the private IP address. These API calls can take several minutes to be effective, so this design provides the longest convergence time among the options described in this article. Additionally, split brain scenarios might be possible if the connectivity between both appliances fails and both appliances think that the other instance is down.

This design supports only active/standby configurations, which can lead to scalability problems. If you need to increase the bandwidth that your NVAs support, scale up both instances.

This design doesn't require SNAT to guarantee traffic symmetry because only one NVA is active at any given time.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Keith Mayer](https://www.linkedin.com/in/keithm/) | Principal Cloud Solution Architect
- [Jose Moreno](https://www.linkedin.com/in/erjosito/) | Solutions Engineer
 
*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Hub-spoke network topology in Azure](../architecture/hub-spoke.yml)

## Related resource

- [Implement a secure hybrid network by using Azure Firewall](../../reference-architectures/dmz/secure-vnet-dmz.yml)

<!-- links -->

[appgw]: /azure/application-gateway/overview
[alb_haports]: /azure/load-balancer/load-balancer-ha-ports-overview
[natgw_reliability]: /azure/reliability/reliability-nat-gateway
[outbound]: /azure/load-balancer/load-balancer-outbound-connections