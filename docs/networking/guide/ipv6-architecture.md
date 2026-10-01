---
title: IPv6 Hub-Spoke Network Topology
description: Learn how to transition a hub-and-spoke network topology in Azure so it supports IPv6, which creates a dual-stack network.
author: WernerRall147
ms.author: weral
ms.date: 09/18/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# IPv6 hub-and-spoke network topology

This article describes how to transition an IPv4 hub-spoke network topology to IPv6. It presents the [hub-and-spoke network topology](../architecture/hub-spoke.yml) as a starting point and describes the steps you can take to implement IPv6 support.

In a hub-and-spoke network, the hub virtual network is a central point of connectivity for the spoke virtual networks. The spoke virtual networks connect to the hub and can provide isolation for application resources. For more information, see [Transitioning to IPv6](./ipv6-ip-planning.md).

## Architecture

:::image type="complex" source="./images/ipv6-hub-spoke.svg" lightbox="./images/ipv6-hub-spoke.svg" alt-text="Diagram that shows a hub-and-spoke architecture with the necessary components for IPv6 support." border="false":::
   An Azure Virtual Network Manager box is at the center. On the left, a Public internet box contains Browser and Internet. Below it, Cross-premises network contains two virtual machines, VPN Gateway, and ExpressRoute circuits. Dotted arrows connect both boxes to the central Dual Stack Hub virtual network. From top to bottom, the hub contains Azure Bastion with a network security group, an IPv4 Azure Firewall, NAT Gateway beside VPN Gateway, an IPv6 NVA pool with a network security group and internal load balancer, and ExpressRoute. IPv6 UDRs appear beside the NVA and ExpressRoute paths. Azure Monitor to the right receives diagnostics. Four spokes sit to the right of and below the hub: two Production Dual Stack and two Non-Production Dual Stack. Each spoke contains an internal load balancer above three resource subnets. Each subnet contains a network security group, virtual machine, and IPv6 UDR. Dashed IPv4 Inspection Path and IPv6 Inspection Path lines connect the spokes to the hub.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/ipv6-hub-spoke-network-topology.vsdx) of this architecture.*

### Workflow

1. **Public internet and cross-premises network:** Users or services can access Azure resources via the public internet. The cross-premises network includes on-premises virtual machines that connect securely to the Azure network. IPv4 traffic uses either a VPN gateway or Azure ExpressRoute. IPv6 traffic uses ExpressRoute IPv6 private peering. Azure VPN Gateway can carry IPv6 traffic in other configurations, but not when it coexists with an IPv6-enabled ExpressRoute gateway, as it does here.

1. **Azure Virtual Network Manager:** This management layer centrally groups and configures the virtual networks in the topology. It deploys connectivity, security admin, and routing configurations across network groups.

1. **Hub virtual network:** The hub is the central point of the network topology. The network configuration supports both IPv4 and IPv6 (dual stack), except for the components noted in [IPv6 support limitations](#ipv6-support-limitations).

    - Azure Bastion provides Remote Desktop Protocol / Secure Shell (RDP/SSH) connectivity from the Azure portal to the virtual machines directly over Transport Layer Security (TLS).
    - Azure Firewall inspects and filters IPv4 traffic between the hub and the public internet. [Dual-stack IPv6 support is in preview](/azure/firewall/deploy-dual-stack-firewall) and covers only network rules and DNS proxy, so this architecture keeps the firewall subnet IPv4-only and routes IPv6 inspection to the NVA pool.
    - A pool of IPv6-capable network virtual appliances (NVAs) runs in its own hub subnet behind an internal load balancer. The pool inspects and filters IPv6 traffic between the spokes, the public internet, and the cross-premises network. It provides the IPv6 equivalent of the inspection path that Azure Firewall provides for IPv4. Deploy at least two instances so that the loss of one instance doesn't sever IPv6 connectivity.
    - ExpressRoute connects the cross-premises network to the hub and carries both IPv4 and IPv6 traffic.
    - VPN Gateway also connects the cross-premises network to the hub and can serve as an IPv4 failover path for ExpressRoute private peering. Coexistence alone doesn't produce failover. Configure your on-premises network to prefer the routes that it learns through ExpressRoute, such as by setting a higher BGP local preference. Because VPN Gateway coexists with an IPv6-enabled ExpressRoute gateway in this hub, it carries only IPv4 traffic.
    - The services in the hub virtual network send logs and metrics (diagnostics) to Azure Monitor for monitoring.

1. **Spoke virtual networks:** Four spokes connect to the hub. Each spoke is a dual-stack network, supporting both IPv4 and IPv6.

    - IPv6 user-defined routes (UDRs) define custom routes for IPv6 traffic from the spoke.
    - The spoke virtual networks are connected via [peering connections](/azure/virtual-network/virtual-network-peering-overview) or [connected groups](/azure/virtual-network-manager/concept-connectivity-configuration). Peering connections and connected groups are nontransitive, low-latency connections between virtual networks. Peered or connected virtual networks can exchange traffic over the Azure backbone.
    - All outbound IPv4 traffic from the spoke virtual networks flows through the hub. A default IPv4 route in each spoke subnet's route table sends that traffic to Azure Firewall. A separate default IPv6 route sends outbound IPv6 traffic to the IPv6 NVA pool, because this architecture keeps Azure Firewall IPv4-only.
    - Within each spoke, there are three subnets designated as resource subnets, each hosting a virtual machine.
    - Each virtual machine connects to an internal load balancer configured to support IPv4 and IPv6 address ranges. The load balancer distributes incoming network traffic across the virtual machines.

### Components

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the foundational networking layer in Azure that enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, it forms the hub-and-spoke topology, which supports dual-stack (IPv4 and IPv6) configurations for centralized and isolated connectivity.
- A [virtual network interface](/azure/virtual-network/virtual-network-network-interface) is a logical interface that connects Azure resources to a virtual network. In this architecture, it enables virtual machines to communicate over both IPv4 and IPv6. A single interface becomes dual-stack when you add an IPv6 IP configuration alongside its existing IPv4 configuration.
- [A public IP address](/azure/virtual-network/ip-services/public-ip-addresses) provides inbound connectivity to Azure resources over the internet. In this architecture, it supports both IPv4 and IPv6 access to services hosted in the virtual network.
- [Virtual Network Manager](/azure/virtual-network-manager/overview) is a centralized management service for organizing and configuring virtual networks and their connectivity. In this architecture, it manages [network groups](/azure/virtual-network-manager/concept-network-groups) and connections across the hub and the spoke networks.
- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a network security service that protects Azure resources by inspecting and filtering traffic. In this architecture, it enforces IPv4 traffic control between the hub and the public internet. An Azure Firewall managed firewall instance resides in its own subnet, which this architecture keeps IPv4-only because dual-stack IPv6 support is in preview and excludes application rules, DNAT, threat intelligence, IDPS, Explicit Proxy, and IP Groups.
- A [network virtual appliance (NVA)](network-virtual-appliance-high-availability.md) is a virtual machine that runs a networking function, such as a firewall or a router. In this architecture, a pool of IPv6-capable NVAs in the hub inspects and filters IPv6 traffic. An internal load balancer fronts the pool so that no single appliance becomes a single point of failure for IPv6 connectivity.
- [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) and [ExpressRoute](/azure/expressroute/expressroute-introduction) are services that provide secure cross-premises connectivity between Azure and on-premises networks. They can create virtual network gateways that connect Azure virtual networks to virtual private network (VPN) devices or ExpressRoute circuits, which enables encrypted or private communication. In this architecture, ExpressRoute carries cross-premises IPv6 traffic through IPv6 private peering, and VPN Gateway carries IPv4 traffic only because the two gateways coexist.
- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a layer-4 load balancing service that distributes incoming network traffic across multiple back-end resources to ensure high availability and scalability. In this architecture, an internal load balancer in each spoke balances IPv6 traffic across the virtual machines in that spoke, and an internal load balancer in the hub fronts the IPv6 NVA pool.
- [Azure NAT Gateway](/azure/nat-gateway/nat-overview) provides outbound-only internet connectivity for a subnet. In this architecture, a StandardV2 NAT gateway attached to the NVA subnet gives the IPv6 NVA pool an explicit egress path, because the internal load balancer that fronts the pool doesn't provide outbound connectivity.
- A [route table](/azure/virtual-network/manage-route-table) is a set of UDRs that provide custom control over how traffic flows within and between Azure virtual networks. In this architecture, UDRs direct IPv6 traffic across hub-and-spoke subnets to enforce traffic flow and security policies.
- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) solution that provides flexible, scalable compute resources. In this architecture, virtual machines are deployed in spoke subnets configured by using dual-stack network interfaces, which enable support for both IPv4 and IPv6 workloads.
- [Azure Bastion](/azure/bastion/bastion-overview) is a managed platform as a service (PaaS) that provides secure RDP and SSH access to virtual machines without exposing them to the public internet. In this architecture, it runs in the hub and enables TLS-secured remote access to the virtual machines in the peered spoke virtual networks.
- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is an observability platform that collects, analyzes, and acts on telemetry data from Azure and hybrid environments. In this architecture, it gathers diagnostics and metrics from hub services to support performance monitoring and operational visibility.

## IPv6 support limitations

Several services that commonly appear in a hub-spoke topology don't carry IPv6 traffic, or carry it only under specific conditions. Account for these constraints before you plan your address space and routing.

| Service | IPv6 behavior | Design implication |
| --- | --- | --- |
| Azure Firewall | [Dual-stack IPv6 support is in preview](/azure/firewall/deploy-dual-stack-firewall) and covers network rules and DNS proxy only. Application rules, DNAT, threat intelligence, IDPS, Explicit Proxy, and IP Groups don't support IPv6. You can't revert a dual-stack firewall to IPv4-only. | Keep the firewall subnet IPv4-only when your inspection path needs application rules or IDPS. Inspect and filter IPv6 egress with an IPv6-capable NVA, and use network security groups for IPv6 filtering. |
| VPN Gateway | Supports [IPv6 inner traffic in dual-stack deployments](/azure/vpn-gateway/ipv6-configuration) on VpnGw1AZ through VpnGw5AZ. Site-to-site IPv6 requires IKEv2. Point-to-site supports IKEv2 and OpenVPN. When VPN Gateway coexists with an IPv6-enabled ExpressRoute gateway, the VPN gateway carries only IPv4 traffic. | For this coexistence architecture, use ExpressRoute IPv6 private peering for cross-premises IPv6 connectivity. |
| Azure Virtual WAN | Supports IPv4 traffic only. ExpressRoute IPv6 isn't supported with Virtual WAN. | Use a self-managed hub-and-spoke topology for IPv6 workloads. |
| Azure Route Server | Supports IPv4 traffic only. | Define static IPv6 routes with UDRs instead. UDRs apply only to the subnets that you associate them with. They aren't advertised to peers or to on-premises networks. |
| Azure Bastion | [Dual-stack support is in preview](/azure/bastion/configuration-settings#ipv6-dual-stack-support-preview). IPv6 applies only between the user and Bastion. Bastion-to-virtual-machine connections use IPv4. You must enable dual stack when you create the Bastion host because you can't convert an existing IPv4-only host. | Keep IPv4 connectivity between Bastion and target virtual machines. Redeploy Bastion if your existing host is IPv4-only. |
| Azure Load Balancer | In a dual-stack configuration, health probes don't work for IPv6 unless a network security group is active on the back-end subnet. | Apply a network security group to every subnet that holds a dual-stack back-end pool, including the NVA subnet. |
| Virtual machines and scale sets | IPv6-only isn't supported. Every network interface needs at least one IPv4 configuration. | Plan a dual-stack design rather than an IPv6-only design. |
| Network security groups | ICMPv6 rules aren't supported, and a single rule can't combine IPv4 and IPv6 prefixes. | Create separate IPv4 and IPv6 rules. |

For the full list, see [IPv6 for Azure Virtual Network limitations](/azure/virtual-network/ip-services/ipv6-overview#limitations) and [ExpressRoute IPv6 limitations](/azure/expressroute/expressroute-howto-add-ipv6#limitations).

An internal load balancer distributes inbound traffic only and provides no outbound connectivity. Subnets in virtual networks that you create with a current API version  are private by default, so they have no [default outbound access](/azure/virtual-network/ip-services/default-outbound-access). Every subnet that sends IPv6 traffic to the internet needs an explicit egress method, including the NVA subnet. This architecture attaches a [StandardV2 NAT gateway](/azure/nat-gateway/nat-sku) to the NVA subnet, which is the only NAT gateway SKU that supports IPv6.

Don't combine a StandardV2 NAT gateway with [Azure Load Balancer outbound rules](/azure/load-balancer/outbound-rules) on the same subnet. The NAT gateway disrupts IPv6 outbound connections that use those rules. A StandardV2 NAT gateway also provides NAT64 translation so that IPv6 workloads can reach IPv4-only destinations, but name-based access to those destinations requires a third-party DNS64 solution to synthesize AAAA records.

## Transition a hub virtual network to IPv6

To transition a hub virtual network to support IPv6, you must update the network infrastructure to accommodate IPv6 address ranges, so the central, controlling part of the network can handle IPv6 traffic. This approach ensures that the central hub can efficiently route and manage traffic among various network segments (spokes) by using IPv6. To implement IPv6 in the hub virtual network, follow these steps:

### Add IPv6 address space to the hub virtual network and the hub subnets

You need to add IPv6 address ranges to the hub virtual network first and then to its subnets. Use the /56 address block for the virtual network and the /64 address block for each subnet. The following table shows an example setup.

| Hub virtual network address range | Hub subnet address range |
| --- | --- |
| Hub virtual network: `2001:db8:1234:0000::/56` | Azure Bastion subnet: `2001:db8:1234:0000::/64`<br>Gateway subnet (ExpressRoute): `2001:db8:1234:0003::/64`<br>NVA subnet: `2001:db8:1234:0004::/64` |

Don't add IPv6 address space to the Azure Firewall subnet. This architecture keeps Azure Firewall IPv4-only because its dual-stack support is in preview and doesn't cover application rules or IDPS. The VPN gateway coexists with the IPv6-enabled ExpressRoute gateway, so it carries only IPv4 traffic. Don't route IPv6 through it even if its subnet is dual-stack.

The Azure Bastion subnet needs IPv6 address space only if you run a dual-stack Bastion host. You can't convert an existing IPv4-only host, so redeploy Bastion with dual stack enabled before you rely on that range.

The IPv6 addresses in the table are examples. Replace `2001:db8:1234::` with your organization's IPv6 address block. Carefully plan and document your IPv6 address allocations to avoid overlaps and ensure efficient use of the address space. To add the IPv6 address space to the hub virtual network, see [Add IPv6 to a virtual network](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#add-ipv6-to-virtual-network), which provides instructions for using the Azure portal, PowerShell, and the Azure CLI.

### Deploy the IPv6 NVA pool for high availability

The IPv6 NVA carries every inspected IPv6 flow in this architecture, so a single appliance becomes a single point of failure for IPv6 internet and cross-premises connectivity. Deploy a pool of appliances instead of one virtual machine.

- Deploy at least two NVA instances, and spread them across availability zones in regions that support zones.
- Front the pool with an internal Standard load balancer that has a dual-stack front-end configuration. Configure a [high availability ports rule](/azure/load-balancer/load-balancer-ha-ports-overview) by setting the protocol to **All** and the port to **0** so that the load balancer forwards all protocol flows on all ports to the instances, including ICMP. ICMP matters for IPv6 because Neighbor Discovery and Path MTU Discovery depend on ICMPv6. For more information, see [Create a dual-stack internal load balancer](/azure/load-balancer/ipv6-dual-stack-standard-internal-load-balancer-powershell).
- Point every IPv6 UDR at the load balancer's IPv6 front-end address rather than at an individual appliance. The examples in this article use `2001:db8:1234:0004::4` in the NVA subnet as that front-end address.
- Apply a network security group to the NVA subnet. In a dual-stack configuration, load balancer health probes don't work for IPv6 unless a network security group is active, so the load balancer can't detect an unhealthy appliance.
- Attach a StandardV2 NAT gateway to the NVA subnet. The internal load balancer provides no outbound connectivity, so the appliances need an explicit egress method to reach the internet.
- Confirm that your NVA vendor validates and supports the design. Follow the vendor's guidance on active/active versus active/standby topology and whether the appliance needs Source Network Address Translation (SNAT) to keep traffic symmetric.

For the available design patterns, their convergence times, and their traffic symmetry tradeoffs, see [Deploy highly available NVAs](network-virtual-appliance-high-availability.md).

### Configure UDRs for each hub subnet

UDRs are routes that you manually set up to override the Azure default system routes. In Azure, UDRs are essential for controlling the flow of network traffic in a virtual network. You can use UDRs to direct traffic from one subnet to specific appliances, gateways, or targets within Azure or to on-premises networks. When you add IPv6 support to the hub virtual network, you need to:

- *Add IPv6 routes*. Existing IPv4 routes don't apply to IPv6 traffic, because each route has a single destination address prefix. Create separate routes that specify the IPv6 destination prefixes and the next hops that they require.
- *Associate the route table with subnets*. After you define the routes, associate the route table with the relevant subnets within the virtual network. This association determines which subnets use the routes that you defined.

You define routes for destination prefixes, not for individual resources. You associate a route table with a subnet, and every resource in that subnet follows the routes in that table. For more information, see [User-defined route overview](/azure/virtual-network/virtual-networks-udr-overview).

In the example architecture, the hub virtual network has IPv6 routes for the gateway subnet and the NVA subnet. The Azure Firewall subnet has no IPv6 routes because it's IPv4-only, and the Azure Bastion subnet has no route table because Azure Bastion doesn't support UDRs on `AzureBastionSubnet`. The next hop address `2001:db8:1234:0004::4` is the IPv6 front-end address of the internal load balancer that fronts the NVA pool, not the address of an individual appliance. The following table shows example IPv6 UDRs.

| Hub subnet | Description | IPv6 address range | Route name | Destination | Next hop type | Next hop address |
| --- | --- | --- | --- | --- | --- | --- |
| Gateway (ExpressRoute) | Send on-premises traffic that's bound for spoke 1 to the NVA pool for inspection | `2001:db8:1234:0003::/64` | Spoke 1 inspection route | `2001:db8:1234:0100::/56` | Virtual appliance | `2001:db8:1234:0004::4` |
| NVA | Send inspected traffic to the internet | `2001:db8:1234:0004::/64` | Internet route | `::/0` | Internet | Not applicable |

Repeat the inspection route for each spoke prefix that you want the NVA pool to inspect. Don't disable BGP route propagation on the GatewaySubnet, because the gateway won't function. Keep propagation enabled on the NVA and spoke subnets so BGP-learned on-premises IPv6 prefixes remain available for inspected traffic.

Don't create routes that use the `Virtual network gateway` next hop type. Azure supports that next hop type only when the virtual network's gateway is a VPN gateway. When a VPN gateway and an ExpressRoute gateway are deployed in the same virtual network, Azure treats the ExpressRoute gateway as the virtual network's gateway, so that next hop type doesn't apply in this architecture.

When you set up your UDRs, you must align them with your organizational network policies and the architecture of your Azure deployment.

### Modify the ExpressRoute circuit (if applicable)

To enable IPv6 on the ExpressRoute circuit, you need to:

- *Enable IPv6 private peering*. Enable IPv6 private peering for the ExpressRoute circuit. This configuration enables IPv6 traffic between your on-premises network and the hub virtual network.
- *Allocate IPv6 address space*. Provide a pair of /126 IPv6 subnets that you own for the primary and secondary ExpressRoute links.
- *Verify route propagation*. The gateway learns on-premises IPv6 prefixes through BGP regardless of any route table setting. Route propagation controls whether Azure injects those learned prefixes into a subnet's route table, so keep it enabled on the NVA subnet and on the spoke subnets that need cross-premises connectivity.

These configurations extend IPv6 connectivity to your Azure services via an ExpressRoute circuit, so you can route dual-stack capabilities simultaneously. To modify ExpressRoute, see [Add IPv6 support for private peering](/azure/expressroute/expressroute-howto-add-ipv6), which provides instructions for using the Azure portal, PowerShell, and the Azure CLI.

Add IPv6 address space to the virtual network and the gateway subnet before you create the ExpressRoute virtual network gateway. IPv6 private peering supports newly created ExpressRoute virtual network gateways of any SKU that use a Standard, static public IP address. Existing gateways support IPv6 only if they're zone-redundant. IPv6 private peering isn't supported with Virtual WAN, and a dual-stack gateway can't connect to a circuit that has only IPv4 enabled on private peering. You must also configure IPv6 on your on-premises customer premises equipment.

## Transition spoke virtual networks to IPv6

Spoke virtual networks are connected to the central hub. When you enable IPv6 on the spoke virtual networks, each spoke network can communicate via IPv6 protocol, and the network gains a more consistent IPv6 design across the topology. To enable IPv6 on the spoke virtual networks, follow these steps:

### Add IPv6 address space to the spoke virtual networks and spoke subnets

As with the hub virtual network, you must add IPv6 address ranges to every spoke virtual network, and then to their subnets. Use the /56 address block for the virtual networks and the /64 address block for the subnets. The following table provides an example of IPv6 address ranges for spoke virtual networks and their subnets.

| Spoke virtual network address range | Spoke subnet address range |
| ----------------------------- | --------------------- |
| Spoke virtual network 1: `2001:db8:1234:0100::/56` | Subnet 1: `2001:db8:1234:0100::/64`<br>Subnet 2: `2001:db8:1234:0101::/64`<br>Subnet 3: `2001:db8:1234:0102::/64` |
| Spoke virtual network 2: `2001:db8:1234:0200::/56` | Subnet 1: `2001:db8:1234:0200::/64`<br>Subnet 2: `2001:db8:1234:0201::/64`<br>Subnet 3: `2001:db8:1234:0202::/64` |
| Spoke virtual network 3: `2001:db8:1234:0300::/56` | Subnet 1: `2001:db8:1234:0300::/64`<br>Subnet 2: `2001:db8:1234:0301::/64`<br>Subnet 3: `2001:db8:1234:0302::/64` |
| Spoke virtual network 4: `2001:db8:1234:0400::/56` | Subnet 1: `2001:db8:1234:0400::/64`<br>Subnet 2: `2001:db8:1234:0401::/64`<br>Subnet 3: `2001:db8:1234:0402::/64` |

For your setup, adjust the IPv6 addresses according to your organization's allocation and needs.

### Modify spoke virtual network resources

Each spoke virtual network contains multiple virtual machines and an internal load balancer. The internal load balancer enables you to route IPv4 and IPv6 traffic to the virtual machines. You must modify the virtual machines and internal load balancers so that they support IPv6.

For each virtual machine, add an IPv6 IP configuration to the network interface that the virtual machine already has. Don't create a separate IPv6 interface. The interface keeps its IPv4 configuration and becomes dual-stack, which every network interface requires because Azure doesn't support IPv6-only interfaces. For more information, see [Add IPv6 configuration to a virtual machine](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#add-ipv6-configuration-to-virtual-machine).

If there isn't an internal load balancer in each spoke virtual network, create a dual-stack internal load balancer. For more information, see [Create a dual-stack internal load balancer](/azure/load-balancer/ipv6-dual-stack-standard-internal-load-balancer-powershell). If there's an internal load balancer, you can use [PowerShell](/azure/load-balancer/ipv6-add-to-existing-vnet-powershell) or the [Azure CLI](/azure/load-balancer/ipv6-add-to-existing-vnet-cli) to add IPv6 support.

### Configure UDRs for each spoke subnet

To configure UDRs, use the same configuration for spoke virtual networks as for hub virtual networks. When you add IPv6 support to a spoke virtual network, you need to:

- *Add IPv6 routes*. Existing IPv4 routes don't apply to IPv6 traffic, because each route has a single destination address prefix. Create separate routes that specify the IPv6 destination prefixes and the next hops that they require.
- *Associate the route table with subnets*. After you define the routes, associate the route table with the relevant subnets within the virtual network. This association determines which subnets use the routes that you defined.

The following table shows example IPv6 UDRs for each subnet in a spoke virtual network. Internet-bound IPv6 traffic goes to the IPv6 NVA pool in the hub rather than to Azure Firewall, which this architecture keeps IPv4-only. As in the hub, the next hop address is the load balancer's IPv6 front-end address, not the address of an individual appliance.

| Spoke subnet | Description | IPv6 address range | Route name | Destination | Next hop type | Next hop address |
| --- | --- | --- | --- | --- | --- | --- |
| Subnet 1 | Send internet-bound traffic to the NVA pool | `2001:db8:1234:0100::/64` | Internet route | `::/0` | Virtual appliance | `2001:db8:1234:0004::4` |
| Subnet 2 | Send internet-bound traffic to the NVA pool | `2001:db8:1234:0101::/64` | Internet route | `::/0` | Virtual appliance | `2001:db8:1234:0004::4` |
| Subnet 2 | Send on-premises traffic to the NVA pool for inspection | `2001:db8:1234:0101::/64` | On-premises route | `2001:db8:5678::/56` | Virtual appliance | `2001:db8:1234:0004::4` |
| Subnet 3 | Send internet-bound traffic to the NVA pool | `2001:db8:1234:0102::/64` | Internet route | `::/0` | Virtual appliance | `2001:db8:1234:0004::4` |

Spokes learn on-premises IPv6 prefixes from the ExpressRoute gateway through BGP when you enable **Use the remote virtual network's gateway or Route Server** on the peering. Add an on-premises UDR only when you want to override those learned routes, such as when you send the traffic to the NVA for inspection. As in the hub, don't use the `Virtual network gateway` next hop type to reach on-premises networks over ExpressRoute.

For your setup, you must align the UDRs with your organizational network policies and the architecture of your Azure deployment.

## Contributors

*Microsoft maintains this article. The following contributors originally wrote the article.*

Principal author:

- [Werner Rall](https://www.linkedin.com/in/werner-rall) | Senior Cloud Solutions Architect

Other contributors:

- [Sherri Babylon](https://www.linkedin.com/in/sbabylon) | Senior Technical Program Manager
- [Dawn Bedard](https://www.linkedin.com/in/dawnbedard) | Principal Technical Program Manager
- [Brandon Stephenson](https://www.linkedin.com/in/brandon-stephenson-3340219b) | Senior Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Create a virtual machine with an IPv6 dual-stack network](/azure/virtual-network/ip-services/create-vm-dual-stack-ipv6-portal)
- [Manage IP address ranges](/azure/virtual-network/manage-virtual-network#add-or-remove-an-address-range)
- [Cloud Adoption Framework: Plan for IP addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing#ipv6-considerations)
- [IPv6 for Azure Virtual Network](/azure/virtual-network/ip-services/ipv6-overview)
- [Add IPv6 support for ExpressRoute private peering](/azure/expressroute/expressroute-howto-add-ipv6)
- [Azure DNS reverse DNS overview](/azure/dns/dns-reverse-dns-overview)
- [Azure NAT Gateway SKUs](/azure/nat-gateway/nat-sku)

## Related resources

- [Transition to IPv6](ipv6-ip-planning.md)
- [Virtual network connectivity options and spoke-to-spoke communication](../../reference-architectures/hybrid-networking/virtual-network-peering.yml)
- [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.md)
- [Deploy AD DS in an Azure virtual network](../../example-scenario/identity/adds-extend-domain.yml)
