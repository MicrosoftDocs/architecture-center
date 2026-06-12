---
title: SD-WAN Integration with Azure Hub-and-Spoke Network Topologies
description: Learn how to integrate SD-WAN with Azure hub-and-spoke networks by using Route Server, ExpressRoute, and network virtual appliances (NVAs) for hybrid connectivity.
author: khushal08
ms.author: fguerri
ms.date: 06/12/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# SD-WAN integration with Azure hub-and-spoke network topologies

This article describes how to design software-defined WANs (SD-WANs) that connect on-premises datacenters with each other and with Azure. It presents an architecture that lets Azure customers use their existing investments in the platform by building efficient, global SD-WAN overlays on top of the Microsoft backbone.

## Applicable scenarios

The recommendations in this article are vendor-agnostic and applicable to SD-WAN technologies that meet two basic prerequisites:

- Tunnels that use Transmission Control Protocol (TCP) or User Datagram Protocol (UDP) as the underlying transport, such as tunnel mode IPsec Encapsulating Security Payload (ESP) with network address translation traversal (NAT traversal), implement the SD-WAN overlay.

- Border Gateway Protocol (BGP) v4 exchanges routes between the SD-WAN edge devices and the networks connected to the SD-WAN. No assumptions are made about the routing protocol that the SD-WAN edge devices use to exchange routing information.

You can use SD-WAN products that meet these prerequisites to achieve the following goals:

- Connect Azure hub-and-spoke networks to SD-WANs that span cloud and on-premises facilities, with dynamic route exchange between Azure virtual networks and SD-WAN edge devices.

- Optimize connectivity to Azure and to on-premises datacenters for branches that have local internet breakouts. The [reach](/azure/networking/microsoft-global-network) of the Microsoft backbone, combined with its capacity, resiliency, and *[cold potato](https://en.wikipedia.org/wiki/Hot-potato_and_cold-potato_routing)* routing policy, can make it a high-performance underlay for global SD-WANs.

- Use the Microsoft backbone for all Azure-to-Azure traffic (cross region and cross geography).

- Use existing multiprotocol label switching (MPLS) networks as high-performance underlays.

- Switch from MPLS networks to internet connectivity in a phased approach that minimizes the effect on the business.

The following sections assume that you're familiar with the basics of the [SD-WAN paradigm](https://en.wikipedia.org/wiki/SD-WAN) and the architecture of the [Microsoft backbone](/azure/networking/microsoft-global-network). The Microsoft backbone interconnects Azure regions with each other and with the public internet.

## Architecture

Organizations that have a global presence and a multiregion Azure footprint use multiple connectivity services to build their corporate networks and connect to the Microsoft backbone.

- Dedicated connectivity services, such as MPLS IP virtual private networks (IPVPNs), are typically deployed at the largest sites.

- Azure ExpressRoute circuits connect the Microsoft backbone to datacenter facilities by using the [point-to-point connectivity model](/azure/expressroute/expressroute-connectivity-models) or directly to the MPLS network by using the [any-to-any connectivity model](/azure/expressroute/expressroute-connectivity-models).

- Branch offices that only have internet connectivity might use IPsec VPNs to connect to the closest on-premises datacenter and use that datacenter's ExpressRoute connection to access Azure resources. Or they might use IPsec VPNs to directly connect to Azure hub-and-spoke networks.

SD-WAN projects can differ in the connectivity services that they intend to replace. Some organizations might want to continue to use dedicated links or MPLS for large facilities and deploy SD-WAN only to replace legacy internet-based IPsec VPNs in small sites. Other organizations might want to extend their SD-WAN to MPLS-connected sites and use the existing MPLS network as a high-performance underlay. Some organizations might also retire their MPLS network and build their entire corporate network as a logical overlay on top of public or shared underlays, such as the public internet and the Microsoft backbone.

The architecture supports all the scopes in this article and is based on the following principles:

- SD-WAN devices are deployed as network virtual appliances (NVAs) in each Azure region's hub-and-spoke network and configured as SD-WAN hubs that terminate tunnels from on-premises sites.

- SD-WAN devices in Azure are configured to establish tunnels with each other to create a fully meshed hub-to-hub overlay that efficiently transports traffic among Azure regions. This overlay also relays traffic between geographically distant on-premises sites on top of the Microsoft backbone.

- SD-WAN devices are deployed in all on-premises sites that the SD-WAN solution covers and are configured to establish tunnels to the SD-WAN NVAs in the closest Azure region or regions. Different sites can use different underlay transport services, such as the public internet or ExpressRoute connectivity.

- Traffic from a site routes to the SD-WAN NVAs in the closest Azure region, regardless of whether the destination is in Azure or in another on-premises site. The traffic then traverses the hub-to-hub overlay.

SD-WAN products can use proprietary protocols and features to create direct tunnels between two sites and achieve better performance than relaying traffic through SD-WAN NVAs in Azure.

The following diagram shows the high-level architecture of a global SD-WAN that uses the Microsoft backbone, the public internet, and dedicated ExpressRoute connections as underlays.

:::image type="complex" border="false" source="./images/sd-wan-integration-high-level-architecture.svg" alt-text="Diagram that shows the high level SD-WAN architecture." lightbox="./images/sd-wan-integration-high-level-architecture.svg":::
   The diagram shows three Azure regions at the top, and each region has SD-WAN NVAs and virtual networks. The Microsoft backbone sits under the regions and hosts a high-performance SD-WAN overlay. The public internet sits under the backbone. Dashed lines show how SD-WAN NVAs in nearby Azure regions route traffic between two on-premises sites. Solid lines labeled SD-WAN tunnel over internet link extend from the NVAs to SD-WAN customer premises equipment (CPEs) inside customer facilities. An internet point-of-presence (PoP) symbol sits where these tunnels meet the internet. On the right, a solid line labeled SD-WAN tunnel over dedicated ExpressRoute connection links an NVA to a CPE, with an ExpressRoute PoP symbol under the backbone. A final line labeled internet link connects the internet to the SD-WAN CPE inside the customer facility.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/sd-wan-integration.pptx) of this architecture.*

## Connect Azure hub-and-spoke networks to SD-WANs

This section provides recommendations for deploying SD-WAN edge devices as NVAs in an existing hub-and-spoke Azure network.

### SD-WAN NVAs in the hub virtual network

We recommend the hub-and-spoke topology for building scalable networks in an Azure region by using customer-managed virtual networks. The hub virtual network hosts shared components such as NVAs and native services that provide network functions, like firewalling, load balancing, and connectivity to on-premises sites via site-to-site VPNs or ExpressRoute. The hub virtual network is the logical location for SD-WAN NVAs because it centralizes shared network functions and provides consistent access to remote networks. These NVAs are non-Microsoft gateways that connect the hub to those remote networks.

Deploy SD-WAN NVAs in hub virtual networks in the following ways:

- Use one network interface controller (NIC) for all SD-WAN traffic. You can add other NICs, such as a management NIC, to meet security and compliance requirements or to follow vendor guidelines for Azure deployments.

- Attach the NIC used for SD-WAN traffic to a dedicated subnet. Define the size of the subnet based on the number of SD-WAN NVAs deployed to meet high availability (HA) and scale or throughput requirements. For more information, see [Connect Azure hub-and-spoke networks to SD-WANs](#connect-azure-hub-and-spoke-networks-to-sd-wans) and [Azure Route Server limits and design considerations](#route-server-limits-and-design-considerations).

- Associate network security groups (NSGs) with the SD-WAN traffic NIC, either directly or at the subnet level, to allow connections from remote on-premises sites over the TCP/UDP ports that the SD-WAN solution uses.

- Enable IP forwarding on the NIC used for SD-WAN traffic.

### Route Server in the hub virtual network

Route Server automates route exchange between SD-WAN NVAs and the Azure software-defined networking (SDN) stack. Route Server supports BGP as a dynamic routing protocol. By establishing BGP adjacencies between Route Server and SD-WAN NVAs:

- Route Server injects routes for all on-premises sites connected to the SD-WAN into the virtual network's route tables, and all Azure virtual machines (VMs) learn those routes.

- Route Server propagates routes for all IP prefixes in the address space of virtual networks to all SD-WAN-connected sites.

Configure Route Server with the following requirements:

- [Deploy Route Server in a dedicated subnet in the hub virtual network](/azure/route-server/quickstart-configure-route-server-portal). Set Route Server capacity based on the number of VMs in the hub-and-spoke network.

- To enable dynamic route exchange for all spoke virtual networks, configure virtual network peering to allow the spoke virtual networks to use the hub virtual network's gateway and Route Server. For more information, see the [Route Server FAQ](/azure/route-server/route-server-faq).

- Route Server and the SD-WAN NVAs attach to different subnets, so configure BGP sessions between Route Server and the SD-WAN NVAs to use eBGP multihop support. Any number of hops between two and the maximum supported by the SD-WAN NVA is supported. For more information about how to configure BGP adjacencies for Route Server, see [Create and configure Route Server by using the Azure portal](/azure/route-server/quickstart-configure-route-server-portal).

- Configure two `/32` static routes on the SD-WAN NVA for the BGP endpoints that Route Server exposes. This configuration ensures that the NVA's route table always contains routes for its multihop (not directly connected) BGP peers.

Route Server isn't in the data path. It's a control plane entity that propagates routes between the SD-WAN NVAs and the virtual network SDN stack. The Azure SDN stack handles the actual traffic forwarding between the SD-WAN NVAs and the VMs in the virtual network, as the following figure shows. To achieve this routing behavior, Route Server injects all routes that it learns from the SD-WAN NVAs by setting the next hop to the NVA's address.

Route Server doesn't support IPv6. This architecture is only for IPv4.

:::image type="complex" border="false" source="./images/sd-wan-integration-route-server-architecture.svg" alt-text="Diagram that shows how Route Server works." lightbox="./images/sd-wan-integration-route-server-architecture.svg":::
   The diagram shows Route Server propagation between the SD-WAN customer premises equipment (CPE) and the virtual network SDN stack. It doesn't forward traffic between the SD-WAN CPE and the VMs in the virtual network. Three virtual network route tables are at the top that read next hop to customer facility and include an arrow that points to SD-WAN NVA. Three lines point from these sections and converge at the virtual network. A line points from the first route table to the SdWanNvaSubnet. Two double-sided dotted arrows connect the NVAs in the RouteServerSubnet and the SDwanNvaSubnet. A dotted arrow labeled public IP SD-WAN tunnel endpoint connects the NVA and the customer facility that includes the SD-WAN CPE. A virtual network route table sits below the other three tables. The section that it's part of includes three subnets, a Route Server section that includes instance 0 and instance 1, an SD-WAN NVA, and Azure DNS stack integration. A double-sided arrow connects the first route table in the upper left corner, Azure DNS stack integration, and the lower left route table. The diagram legend is shown at the bottom right corner. A dotted gray arrow shows route propagation, which occurs on the control plane. A solid orange arrow shows the actual traffic path, which occurs on the data plane.
:::image-end:::

### HA for SD-WAN NVAs with Route Server

Route Server has built-in HA. Two compute resources back a single Route Server instance, and Azure deploys these compute resources in different availability zones (in regions with availability zones) or in the same availability set (in regions without availability zones). As a result, a Route Server instance exposes two BGP endpoints, one endpoint for each compute resource. You achieve HA for the SD-WAN NVAs by deploying multiple instances in different availability zones or in the same availability set. Each SD-WAN NVA establishes two BGP sessions, one session for each endpoint that Route Server exposes.

This architecture doesn't rely on Azure load balancers. It has the following characteristics:

- No public load balancers expose SD-WAN tunnel endpoints. Each SD-WAN NVA exposes its own tunnel endpoint. Remote peers establish multiple tunnels, with one tunnel for each SD-WAN NVA in Azure.

- No internal load balancers are required to distribute traffic from Azure VMs across multiple SD-WAN edge devices. Route Server and the Azure SDN stack support equal-cost multi-path (ECMP) routing. If multiple edge devices announce a route for the same destination, Route Server injects multiple routes in the virtual network's route table, with one route for each edge device that announced the destination. Each route has a different next hop that corresponds to the IP address of the edge device that announced it, in the virtual network's route table. The SDN stack then distributes traffic for that destination across all available next hops.

The following figure shows the resulting HA architecture.

:::image type="complex" border="false" source="./images/sd-wan-integration-route-server-high-availability.svg" alt-text="Diagram that shows Route Server HA." lightbox="./images/sd-wan-integration-route-server-high-availability.svg":::
   Diagram that shows the HA architecture for Route Server and SD-WAN NVAs in a hub virtual network. The hub virtual network contains three subnets arranged from left to right: VmSubnet on the left, RouteServerSubnet in the middle, and SdwanNvaSubnet on the right. The VmSubnet contains a virtual network route table that indicates the next hop to the customer facility points to the SD-WAN NVAs. The RouteServerSubnet contains a Route Server instance with two compute resources labeled instance 0 at the top and instance 1 at the bottom. The SdwanNvaSubnet contains two SD-WAN NVAs arranged vertically, with SD-WAN NVA 0 at the top and SD-WAN NVA 1 at the bottom. Lines connect the Route Server instances to both SD-WAN NVAs and represent BGP sessions for route propagation on the control plane. Each SD-WAN NVA establishes two BGP sessions, one with each Route Server instance. A BGP label appears between the RouteServerSubnet and SdwanNvaSubnet. Solid lines extend from each SD-WAN NVA toward two customer facilities shown at the far right and represent redundant traffic paths on the data plane. The upper customer facility contains SD-WAN customer premises equipment (CPE) 0 that connects to SD-WAN NVA 0, while the lower customer facility contains SD-WAN CPE 1 that connects to SD-WAN NVA 1. Public IP addresses (SD-WAN tunnel endpoints) sit between the SD-WAN NVAs and the customer facilities and indicate that each NVA exposes its own public tunnel endpoint. At the bottom left, the Azure SDN stack integration component connects to the virtual network route table. A legend in the lower right shows that gray dotted arrows represent route propagation on the control plane, while solid orange lines represent redundant traffic paths on the data plane.
:::image-end:::

#### N-active versus active-standby HA

When you use multiple SD-WAN NVAs and peer them with Route Server, BGP drives the failover. If an SD-WAN NVA goes offline, it stops advertising routes to Route Server. Route Server then withdraws the routes that it learned from that device from the virtual network's route table. As a result, if an SD-WAN NVA no longer provides connectivity to remote SD-WAN sites because of a fault in the device or in the underlay network, it no longer appears as a possible next hop toward those sites in the virtual network's route table. All the traffic goes to the remaining healthy devices. For more information about route propagation between SD-WAN NVAs and Route Server, see [Routes advertised by a BGP peer to Route Server](#routes-advertised-by-a-bgp-peer-to-route-server).

The following diagram shows this failover behavior.

:::image type="complex" border="false" source="./images/sd-wan-integration-route-server-border-gate-protocol-failover.svg" alt-text="Diagram that shows the Route Server BGP-driven failover." lightbox="./images/sd-wan-integration-route-server-border-gate-protocol-failover.svg":::
   Diagram that shows BGP-driven failover in a Route Server and SD-WAN NVA HA architecture when one device fails. The hub virtual network contains three subnets: VmSubnet, RouteServerSubnet, and SdwanNvaSubnet. At the bottom left, a virtual network route table displays information about the next hop to the customer facilities. In this table, the entry for SD-WAN NVA 0 is crossed out, which indicates that it has failed and is no longer a valid next hop. A label below it indicates that SD-WAN NVA 1 is now the active next hop for traffic. The RouteServerSubnet contains a Route Server instance with two compute resources labeled instance 0 and instance 1. The SdwanNvaSubnet contains two SD-WAN NVAs: SD-WAN NVA 0 and SD-WAN NVA 1. Solid lines that represent BGP sessions connect the Route Server instances to both SD-WAN NVAs on the control plane, but SD-WAN NVA 0 no longer advertises routes because of its failure. A BGP label appears between the RouteServerSubnet and SdwanNvaSubnet. To the right, the diagram shows two customer facilities, each associated with its own SD-WAN CPE. A solid line extends from SD-WAN NVA 1 to the customer facility that it serves, which represents the active redundant traffic path on the data plane. No active traffic path connects from SD-WAN NVA 0 to the customer facility that it serves because that NVA has failed. Public IP tunnel endpoints appear between the NVAs and the customer facilities. At the bottom left, the Azure SDN stack integration component connects to the virtual network route table. A legend in the lower right explains that dotted gray lines represent route propagation on the control plane, while solid orange lines represent redundant traffic paths on the data plane.
:::image-end:::

BGP-driven failover and ECMP routing enable N-active HA architectures with N devices that concurrently process traffic. Active-passive architectures can also be implemented because Route Server honors BGP AS Path attributes. If different SD-WAN edge devices announce routes for the same destinations with different AS Path lengths, the SD-WAN edge device that announces routes with the shortest path becomes the preferred next hop. If that device fails or withdraws some of its routes, Route Server extends routes with longer AS Path values that other devices announce. The only BGP attribute that SD-WAN NVAs can use to express a degree of preference for the routes that they announce to Route Server is AS Path.

We recommend N-active HA architectures because they enable optimal resource utilization without standby SD-WAN NVAs and horizontal scalability. To increase throughput, multiple NVAs can run in parallel, up to the maximum number of [BGP peers](#bgp-peers) that Route Server supports. The N-active HA model requires the SD-WAN NVAs to act as stateless, layer-3 routers. When multiple tunnels to a site exist, the system can route TCP connections asymmetrically. The *original* and *reply* flows of the same TCP connection can be routed through different tunnels and different NVAs. The following figure shows an example of an asymmetrically routed TCP connection. These routing asymmetries are possible for TCP connections initiated on either the virtual network or an on-premises site.

:::image type="complex" border="false" source="./images/sd-wan-integration-asymmetric-routing-with-active-active-high-availability.svg" alt-text="Diagram that shows asymmetric routing in active-active configurations." lightbox="./images/sd-wan-integration-asymmetric-routing-with-active-active-high-availability.svg":::
   Diagram that shows asymmetric routing in active-active HA architectures where the original flow and reply flow of a TCP connection traverse different SD-WAN NVAs. The hub virtual network contains three subnets arranged from left to right: VmSubnet, RouteServerSubnet, and SdwanNvaSubnet. At the bottom left, a virtual network route table displays two possible next hops for destination 192.168.1.0/24: SD-WAN NVA 0 and SD-WAN NVA 1. The RouteServerSubnet in the middle contains a Route Server instance with two compute resources labeled instance 0 and instance 1. The SdwanNvaSubnet at the right contains two SD-WAN NVAs arranged vertically: SD-WAN NVA 0 at the top and SD-WAN NVA 1 at the bottom. Solid lines that represent BGP sessions connect the Route Server instances to both SD-WAN NVAs and show that both NVAs announce the same route for destination 192.168.1.0/24 with the same AS Path length to Route Server. A BGP label appears between the RouteServerSubnet and SdwanNvaSubnet. A red arrow points from SdwanNvaSubnet to VMSubnet. This arrow represents the original traffic flow from the on-premises SD-WAN remote site to Azure. The on-premises SD-WAN customer premises equipment (CPE) selects SD-WAN NVA 1 for this inbound connection, and the tunnel terminates at SD-WAN NVA 1 on the Azure side. A green arrow points from VMSubnet to SD-WAN NVA 0 in the SdwanNva subnet. This arrow represents the reply traffic from Azure to the on-premises SD-WAN site. The Azure SDN stack routes this reply flow to SD-WAN NVA 0 because it's one of the possible next hops for 192.168.1.0/24, according to the virtual network route table with ECMP routing. The customer facility appears at the far right and has the destination address 192.168.1.0/24. At the bottom left, the Azure SDN stack integration component connects to the virtual network route table. A legend in the lower right shows two directional arrows with text labels: a red arrow labeled original direction (on-premises to Azure) and a green arrow labeled reply direction (Azure to on-premises).
:::image-end:::

Consider active-passive HA architectures only when SD-WAN NVAs in Azure perform network functions that require routing symmetry, such as stateful firewall inspection. Avoid this approach because of its scalability implications. Running more network functions on SD-WAN NVAs increases resource consumption. Active-passive HA architectures allow only one NVA to process traffic at any point in time. As a result, the entire SD-WAN layer can only be scaled up to the maximum Azure VM size that it supports, not scaled out. Implement stateful network functions that require routing symmetry on separate NVA clusters that rely on Azure Load Balancer for n-active HA.

## ExpressRoute connectivity considerations

This architecture supports a full SD-WAN approach, so you can build your corporate network as a logical overlay on top of the public internet and the Microsoft backbone. You can also use dedicated ExpressRoute circuits to address specific scenarios that are described in the following sections.

### Scenario #1: ExpressRoute and SD-WAN coexistence

SD-WAN solutions can coexist with ExpressRoute connectivity when SD-WAN devices are deployed only in a subset of sites. For example, some organizations might deploy SD-WAN solutions as a replacement for traditional IPsec VPNs in sites that have internet connectivity only, and use MPLS services and ExpressRoute circuits for large sites and datacenters, as the following figure shows.

:::image type="complex" border="false" source="./images/sd-wan-integration-expressroute-coexistence.svg" alt-text="Diagram that shows SD-WAN and ExpressRoute coexistence." lightbox="./images/sd-wan-integration-expressroute-coexistence.svg":::
   Diagram that shows SD-WAN and ExpressRoute coexistence scenario where SD-WAN devices are deployed in a subset of sites while ExpressRoute circuits serve large sites and datacenters. The diagram displays three Azure regions arranged horizontally at the top, each of which contains a hub virtual network with shared components. Each hub virtual network contains an SD-WAN NVA, Route Server, and an ExpressRoute gateway. The Microsoft backbone sits horizontally below the Azure regions as a horizontal band. A label on the Microsoft backbone layer reads high-performance overlay on top of the Microsoft backbone. Below the Microsoft backbone sits the internet layer as another horizontal band. At the bottom of the diagram, five customer facilities are shown. On the left side of the diagram, three customer facilities each contain an SD-WAN customer premises equipment (CPE) device and all have SD-WAN tunnel over internet link labels. The leftmost customer facility connects through an internet point-of-presence (PoP) to the SD-WAN NVA in the first Azure region. The second customer facility connects through an internet PoP to the SD-WAN NVA in the first Azure region. The third customer facility from the left connects through an internet PoP to the SD-WAN NVA in the second Azure region. On the right side of the diagram, two customer facilities connect via ExpressRoute private peering. These connection lines run through an ExpressRoute PoP to the ExpressRoute gateways across the Azure regions. They demonstrate dedicated connectivity for large sites.
:::image-end:::

This coexistence scenario requires SD-WAN NVAs deployed in Azure to route traffic between sites connected to the SD-WAN and sites connected to ExpressRoute circuits. You can [configure Route Server to propagate routes between ExpressRoute virtual network gateways and SD-WAN NVAs](/azure/route-server/expressroute-vpn-support) in Azure by enabling the `AllowBranchToBranch` feature. Route propagation between the ExpressRoute virtual network gateway and the SD-WAN NVAs occurs over BGP. Route Server establishes BGP sessions with the ExpressRoute virtual network gateway and with the SD-WAN NVAs, and it propagates to each peer the routes that it learns from the other peer. The platform manages the BGP sessions between Route Server and the ExpressRoute virtual network gateway. Users don't need to configure those sessions explicitly. They only need to enable the `AllowBranchToBranch` flag when they deploy Route Server.

:::image type="complex" border="false" source="./images/sd-wan-integration-route-server-allow-branch-to-branch.svg" alt-text="Diagram that shows route propagation when Route Server is configured with AllowBranchToBranch set to true." lightbox="./images/sd-wan-integration-route-server-allow-branch-to-branch.svg":::
   Diagram that shows Route Server configuration for route propagation between ExpressRoute virtual network gateways and SD-WAN NVAs in a hub virtual network. The diagram displays three subnets arranged horizontally: GatewaySubnet at the left, RouteServerSubnet in the center, and SdwanNvaSubnet at the right. An ExpressRoute customer edge device appears next to the GatewaySubnet. A Route Server instance with two compute resources labeled instance 0 at the top and instance 1 at the bottom appears next to the RouteServerSubnet. An SD-WAN NVA device appears next to the SdwanNvaSubnet. Horizontal lines labeled BGP run between the three subnets and represent BGP sessions for route propagation on the control plane. Lines run from the ExpressRoute customer edge device through the Route Server instances, with other BGP lines that run from the Route Server to the SD-WAN NVA. At the bottom left, a box labeled Customer ExpressRoute-connected facility identifies an on-premises site that uses ExpressRoute private peering. At the bottom right, a box labeled Customer SD-WAN facility identifies an on-premises site that uses SD-WAN tunnels. A horizontal annotation box appears below the Route Server subnet and displays the setting AllowBranchToBranch set to TRUE, which indicates that the Route Server configuration flag is active for bidirectional route propagation.
:::image-end:::

This SD-WAN and ExpressRoute coexistence scenario enables migrations from MPLS networks to SD-WAN. It provides a path between legacy MPLS sites and newly migrated SD-WAN sites and eliminates the need to route traffic through on-premises datacenters. Use this pattern during migrations and in scenarios that occur from company mergers and acquisitions to interconnect disparate networks.

### Scenario #2: ExpressRoute as an SD-WAN underlay network

If your on-premises sites have ExpressRoute connectivity, you can configure SD-WAN devices to set up tunnels to the SD-WAN hub NVAs that run in Azure on top of ExpressRoute. You can use both ExpressRoute private peering and Microsoft peering.

#### Private peering

When you use ExpressRoute private peering as the underlay network, all on-premises SD-WAN sites establish tunnels to the SD-WAN hub NVAs in Azure. This scenario doesn't require route propagation between the SD-WAN NVAs and the ExpressRoute virtual network gateway, so you must configure Route Server with the `AllowBranchToBranch` flag set to false.

This approach requires proper BGP configuration on the customer- or provider-side routers that terminate the ExpressRoute connection. Microsoft Enterprise Edge routers (MSEEs) announce all the routes for the virtual networks that are connected to the circuit, either directly or through [virtual network peering](/azure/virtual-network/virtual-network-peering-overview). To forward traffic destined for virtual networks through an SD-WAN tunnel, the on-premises site must learn those routes from the SD-WAN device, not from the ExpressRoute circuit.

As a result, the customer-side or provider-side routers that terminate the ExpressRoute connection must filter out the routes that they receive from Azure. The only routes in the underlay network should allow the on-premises SD-WAN devices to reach the SD-WAN hub NVAs in Azure. Customers who plan to use ExpressRoute private peering as an SD-WAN underlay network should verify that their routing devices support this configuration. This requirement is especially relevant for customers who don't control the edge devices used for ExpressRoute, such as when an MPLS carrier provides the ExpressRoute circuit on top of an IPVPN service.

:::image type="complex" border="false" source="./images/sd-wan-integration-private-peering-underlay.svg" alt-text="Diagram that shows ExpressRoute private peering as an SD-WAN underlay network." lightbox="./images/sd-wan-integration-private-peering-underlay.svg":::
   Diagram that shows ExpressRoute private peering used as an SD-WAN underlay network. On-premises SD-WAN sites establish tunnels to SD-WAN hub NVAs in Azure over ExpressRoute connectivity. The diagram shows a hub virtual network with three subnets arranged horizontally from left to right: GatewaySubnet, RouteServerSubnet, and SdwanNvaSubnet. The GatewaySubnet on the left contains an ExpressRoute customer edge device represented as a gateway icon. The RouteServerSubnet in the center contains a Route Server instance with two compute resources shown as stacked boxes labeled instance 0 at the top and instance 1 at the bottom, which represent built-in redundancy for Route Server. The SdwanNvaSubnet on the right contains an SD-WAN NVA device. Vertical lines connect the subnets and represent network connectivity, with connections from the ExpressRoute customer edge device that pass through the Route Server to the SD-WAN NVA. At the bottom left, a large box labeled Customer ExpressRoute-connected facility indicates an on-premises site with ExpressRoute connectivity and contains an ExpressRoute customer edge device. A connection line extends from the customer facility through an ExpressRoute circuit to connect to the ExpressRoute customer edge device in the GatewaySubnet. A horizontal annotation box below the Route Server shows the setting AllowBranchToBranch set to false. This annotation indicates that the Route Server configuration flag is set to false because this scenario doesn't require route propagation between the SD-WAN NVAs and the ExpressRoute virtual network gateway. At the bottom of the diagram, a legend shows three line types with their meanings: a gray dashed line for Route propagation in Azure and ExpressRoute (BGP), a solid orange line for SD-WAN tunnel, and a black dashed line for SD-WAN route propagation (any routing protocol supported by SD-WAN vendor).
:::image-end:::

#### Microsoft peering

You can also use the ExpressRoute Microsoft peering as an underlay network for SD-WAN tunnels. In this scenario, the SD-WAN hub NVAs in Azure expose only public tunnel endpoints, which SD-WAN customer premises equipment (CPEs) in both internet-connected sites and ExpressRoute-connected sites use. The ExpressRoute Microsoft peering has more complex prerequisites than private peering, but we recommend this option as an underlay network for the following two reasons:

- It doesn't require ExpressRoute virtual network gateways in the hub virtual network. It removes complexity, reduces cost, and lets the SD-WAN solution scale beyond the bandwidth limits of the gateway when you don't use [ExpressRoute FastPath](/azure/expressroute/about-fastpath).

- This approach provides a clear separation between overlay and underlay routes. MSEEs announce only the Microsoft network's public prefixes to the customer or provider edge. You can place those routes in a separate virtual routing and forwarding (VRF) instance and propagate them only to a perimeter network segment of the site's LAN. SD-WAN devices propagate the routes for the customer's corporate network in the overlay, including routes for virtual networks. Customers who consider this approach should verify that they can configure their routing devices accordingly or request the appropriate service from their MPLS carrier.

## MPLS considerations

Migration from traditional MPLS corporate networks to more modern network architectures based on the SD-WAN paradigm requires significant effort and time. Use this architecture to implement phased migrations from MPLS to SD-WAN. The following sections describe two typical migration scenarios.

### Phased MPLS decommissioning

Customers who want to build an SD-WAN on top of the public internet and the Microsoft backbone and completely decommission MPLS IPVPNs or other dedicated connectivity services can use the [ExpressRoute and SD-WAN coexistence scenario](#scenario-1-expressroute-and-sd-wan-coexistence) during migration. In this scenario, SD-WAN-connected sites can reach sites connected to the legacy MPLS. After you migrate a site to the SD-WAN and deploy CPE devices, you can decommission its MPLS link. The site can access the entire corporate network through its SD-WAN tunnels to the closest Azure regions.

:::image type="complex" border="false" source="./images/sd-wan-integration-multiprotocol-label-switching-decommissioning.svg" alt-text="Diagram that shows the MPLS decommission architecture." lightbox="./images/sd-wan-integration-multiprotocol-label-switching-decommissioning.svg":::
   Diagram that shows the phased MPLS decommission architecture during migration from traditional MPLS corporate networks to SD-WAN. Three sections labeled Azure region appear horizontally across the top of the diagram from left to right. Each Azure region contains a dashed-border box that represents a hub virtual network. Each hub virtual network contains an SD-WAN NVA, a Route Server, and an ExpressRoute gateway. A wide horizontal band labeled Microsoft backbone sits below the three Azure regions and represents the high-performance Microsoft global network infrastructure that interconnects the Azure regions. Another horizontal band labeled internet sits below the Microsoft backbone and represents the public internet underlay that SD-WAN tunnels traverse. A third band labeled MPLS backbone appears to the right, parallel to the internet band, and represents the private MPLS network infrastructure. Five customer facilities appear at the bottom of the diagram. From left to right: three SD-WAN customer facilities that each contain an SD-WAN CPE device, with connection lines labeled SD-WAN tunnel over internet link extending upward through the internet layer to connect to SD-WAN NVAs in different Azure regions via internet points of presence (PoPs). The fourth facility is labeled customer facility migrated to SD-WAN and also contains an SD-WAN CPE device with a tunnel over internet link. The fifth facility on the far right is labeled MPLS customer facility and connects to the third Azure region through an ExpressRoute private peering connection that passes through an ExpressRoute PoP and connects to the ExpressRoute gateway. A label at the center reads phased MPLS decommissioning.
:::image-end:::

When all sites are migrated, you can decommission the MPLS IPVPN along with the ExpressRoute circuits that connect it to the Microsoft backbone. You no longer need ExpressRoute virtual network gateways and can deprovision them. The SD-WAN hub NVAs in each region become the only entry point into that region's hub-and-spoke network.

### MPLS integration

Organizations that don't trust public and shared networks to provide the desired performance and reliability might decide to use an existing MPLS network as an enterprise-class underlay for specific sites or applications.

The [ExpressRoute as an SD-WAN underlay](#scenario-2-expressroute-as-an-sd-wan-underlay-network) scenario supports SD-WAN and MPLS integration. Prefer ExpressRoute Microsoft peering over private peering. When you use Microsoft peering, the MPLS network and the public internet become functionally equivalent underlays. They provide access to all of the SD-WAN tunnel endpoints that the SD-WAN hub NVAs in Azure expose. An SD-WAN CPE deployed in a site that has both internet and MPLS connectivity can establish multiple tunnels to the SD-WAN hubs in Azure on both underlays. The CPE can then route different connections through different tunnels based on application-level policies that the SD-WAN control plane manages.

:::image type="complex" border="false" source="./images/sd-wan-integration-multiprotocol-label-switching-integration.svg" alt-text="Diagram that shows the MPLS integration architecture." lightbox="./images/sd-wan-integration-multiprotocol-label-switching-integration.svg":::
   Diagram that shows the MPLS integration architecture, where organizations use an existing MPLS network as an enterprise-class underlay for SD-WAN tunnels alongside public internet connectivity. Three Azure regions appear horizontally across the top of the diagram. Each Azure region contains a hub virtual network with an SD-WAN NVA device. A wide horizontal band labeled Microsoft backbone sits below the Azure regions. Below the Microsoft backbone, two parallel underlay networks appear as horizontal bands: on the left side, a band labeled internet represents the public internet underlay, and on the right side, a band labeled MPLS backbone represents the private MPLS network underlay. Five customer facilities appear at the bottom of the diagram. On the left side, in the internet underlay area, three facilities appear from left to right. The first facility is labeled customer facility SD-WAN with internet underlay and contains an SD-WAN CPE device. A connection line labeled SD-WAN tunnel over internet link extends upward from this facility, passes through the internet layer, and connects to an SD-WAN NVA in the first Azure region. The second facility is labeled customer facility SD-WAN with MPLS and internet underlays and contains an SD-WAN CPE device. Connection lines extend upward from this facility through both the internet and MPLS layers. The third facility in this group is labeled customer facility SD-WAN with internet and MPLS underlays and contains an SD-WAN CPE device. Connection lines extend from this facility through both underlay layers and connect to SD-WAN NVAs in Azure, which demonstrates how sites with both connectivity types establish multiple tunnels on different underlays. On the right side, in the MPLS backbone area, two facilities appear. The first facility is labeled customer facility SD-WAN with MPLS and internet underlays and contains an SD-WAN CPE device. Connection lines extend upward from this facility through both the MPLS backbone layer and the internet layer. The second facility on the far right is labeled customer facility SD-WAN with MPLS underlay and contains an SD-WAN CPE device. A connection line labeled SD-WAN tunnel over MPLS extends upward from this facility, passes through the MPLS backbone layer, and connects to an SD-WAN NVA in the third Azure region. The MPLS network and the public internet function as equivalent underlays when ExpressRoute Microsoft peering is used. SD-WAN CPEs establish multiple tunnels to SD-WAN hubs in Azure on both underlays and route different connections through different tunnels based on application-level policies that the SD-WAN control plane manages.
:::image-end:::

### Route Server routing preference

In both MPLS scenarios in the previous two sections, some branch sites can be connected to both the MPLS IPVPN and the SD-WAN. As a result, the Route Server instances deployed in the hub virtual networks can learn the same routes from ExpressRoute gateways and SD-WAN NVAs.

Use Route Server routing preference to control which path to prefer and extend in the virtual networks' route tables.

Routing preference is useful when you can't use AS Path prepending. An example is MPLS IPVPN services that don't support custom BGP configurations. Depending on how the MPLS network aggregates routes, the level of control you have over the attributes of your MPLS routes, and your preference between SD-WAN and MPLS during the migration, you might need to force Route Server to prefer MPLS routes over SD-WAN routes or SD-WAN routes over MPLS routes.

## Route Server limits and design considerations

Route Server is central to this architecture. It propagates routes between SD-WAN NVAs deployed in virtual networks and the underlying Azure SDN stack. It provides a BGP-based approach for running multiple SD-WAN NVAs for HA and horizontal scalability. When you design large SD-WANs based on this architecture, account for the [scalability limits of Route Server](/azure/route-server/route-server-faq).

The following sections provide guidance about scalability maximums and how to handle each limit.

### Routes advertised by a BGP peer to Route Server

Route Server doesn't define an explicit limit for the number of routes that can be advertised to ExpressRoute virtual network gateways when the `AllowBranchToBranch` flag is set. However, ExpressRoute gateways further propagate the routes that they learn from Route Server to the ExpressRoute circuits that they connect to.

Azure [limits the number of routes that ExpressRoute gateways can advertise to ExpressRoute circuits over private peering](/azure/azure-resource-manager/management/azure-subscription-service-limits). When you design SD-WAN solutions based on the guidance in this article, ensure that SD-WAN routes don't reach this limit. If you reach the limit, the BGP sessions between ExpressRoute gateways and ExpressRoute circuits are dropped, and connectivity between virtual networks and remote networks connected via ExpressRoute is lost.

The total number of routes that ExpressRoute gateways advertise to circuits is the sum of the routes that they learn from Route Server and the prefixes that comprise the Azure hub-and-spoke network's address space. To avoid outages from dropped BGP sessions, we recommend the following mitigations:

- Use native SD-WAN device features (route summarization and filtering) to limit the number of routes announced to Route Server, if available.

- Use [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview) to proactively detect spikes in the number of routes that ExpressRoute gateways announce. Monitor the metric [count of routes advertised to peer](/azure/expressroute/monitor-expressroute-reference).

### BGP peers

Route Server can establish BGP sessions with up to a [maximum number of BGP peers](/azure/route-server/route-server-faq#what-are-azure-route-server-limits). This limit determines how many SD-WAN NVAs can establish BGP adjacencies with Route Server. It also defines the maximum aggregate throughput that can be supported across all SD-WAN tunnels. Only large SD-WANs are expected to reach this limit. No workaround exists beyond creating multiple hub-and-spoke networks that each has its own gateways and route servers.

### Participating VMs

ExpressRoute virtual network gateways and Route Server configure the routes that they learn from their remote peers for all VMs in their own virtual network and in directly peered virtual networks. To protect Route Server from excessive resource consumption from routing updates to VMs, Azure defines a [limit on the number of VMs in a single hub-and-spoke network](/azure/route-server/route-server-capacity). Adjust Route Server capacity based on the expected number of VMs in the hub virtual network that contains the Route Server and in all directly peered spoke virtual networks.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Federico Guerrini](https://www.linkedin.com/in/federico-guerrini-phd-8185954) | Senior Cloud Solution Architect
- [Khush Kaviraj](https://www.linkedin.com/in/khushalkaviraj) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Microsoft Well-Architected Framework](/azure/well-architected/)

## Related resources

- [Connect an on-premises network to Azure by using ExpressRoute](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml)
- [Deploy highly available NVAs](network-virtual-appliance-high-availability.md)
