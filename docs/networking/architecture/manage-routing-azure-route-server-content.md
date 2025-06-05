This article presents a solution for managing the dynamic routing between NVAs and virtual networks. At the core of the solution is Azure Route Server. This service simplifies the configuration, maintenance, and deployment of NVAs in your virtual network. When you use Route Server, you no longer need to manually update NVA route tables when your virtual network addresses change.

## Architecture

:::image type="content" source="./_images/manage-routing-azure-route-server-architecture.png" alt-text="Architecture diagram that shows how data flows between local networks, a hub virtual network, a spoke virtual network, and various gateways." border="false" lightbox="./_images/manage-routing-azure-route-server-architecture.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Workflow

- This hub-and-spoke architecture has a hub virtual network and one spoke virtual network. The hub virtual network has multiple subnets, each containing virtual machines (VMs).

- The address space of each virtual network defines address ranges. For each of those ranges, Azure creates a route with the address prefix of that range. Azure adds those routes to route tables. Each virtual network has multiple subnets, and each subnet has a network interface card (NIC) that controls connectivity. Azure injects each virtual network's route table into the subnets' NICs.

  You can't create or remove these default system routes. But you can:

  - Override some system routes with [custom routes][Virtual network traffic routing - Custom routes].
  - Configure Azure to add [optional default routes][Virtual network traffic routing - Optional default routes] to specific subnets.

- Local networks use Azure VPN Gateway and an ExpressRoute gateway to connect to the hub virtual network in a coexisting configuration. When you add the VPN gateway, routes with the gateway as the next route get added to the route tables. When you add ExpressRoute, the route tables are also updated. These routes propagate to all subnets.

- The border gateway protocol (BGP) makes the exchange of IP addresses between on-premises and Azure components possible. This protocol directs packets between autonomous systems. Such systems are small networks or huge pools of routers that a single organization runs.

- A virtual network peering exists between the hub virtual network and the spoke virtual network. When you create the peering, Azure updates the route table. Specifically, Azure adds a route for each address range that's in the hub address space or the spoke address space. These routes propagate to all subnets.

- A subnet in the hub virtual network uses a service endpoint for Azure Storage. Azure adds a public IP address for Storage to that subnet's route table.

- The hub virtual network contains two NVAs. The NVAs might be gateways, software-defined wide-area networks (SD-WANs), or security appliance firewalls. Route Server exchanges the NVA, network application, and gateway routes by:

  - Creating an instance of Azure Virtual Machine Scale Sets. Each VM in the scale set has an IP address. As with gateway IP addresses, Route Server has access to the VM IP addresses.
  - Establishing BGP peers between each NVA and a VM in the scale set.
  - Injecting the VM IP addresses into all route tables in the virtual network and connected networks.

  There's no need to:

  - Manually add user-defined routes.
  - Manually create route tables.
  - Link route tables to the subnet to propagate the routes.
  - Update route tables when IP addresses change.

### Components

- [Route Server][Azure Route Server] simplifies dynamic routing between NVAs that support BGP and virtual networks. This service eliminates the administrative overhead of maintaining route tables.

- [Virtual Network][Virtual Network] is the fundamental building block for private networks in Azure. Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks through Virtual Network.

- [Virtual network peering][Virtual network peering] connects two or more Azure virtual networks. Peerings provide low-latency, high-bandwidth connections between resources in different virtual networks. Traffic between VMs in peered virtual networks uses only the Microsoft private network.

- [VPN Gateway][VPN Gateway] is a specific type of virtual network gateway. You can use VPN Gateway to send encrypted traffic:

  - Between an Azure virtual network and an on-premises location over the public internet.
  - Between Azure virtual networks over the Azure backbone network.

- [ExpressRoute][What is Azure ExpressRoute?] extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections to cloud components like Azure services and Microsoft 365.

- A [service endpoint][Virtual Network service endpoints] provides secure and direct connectivity to an Azure service from private IP addresses in a virtual network. The service endpoint provides the identity of the virtual network to the Azure service. So the virtual network resources don't need public IP addresses to access the service, and the endpoint protects the service by allowing only traffic from the specified virtual network. The connections use optimized routes over the Azure backbone network.

- An NVA is a virtual appliance that offers networking capabilities such as firewall security and load balancing.

- [Azure Storage][Introduction to the core Azure Storage services] is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data.

### Alternatives

- In this solution, you don't have to connect the service endpoint to Storage. You can use other Azure services instead. For a list of services that you can secure with service endpoints, see [Virtual Network service endpoints][Virtual Network service endpoints].

- Instead of using Route Server, you can add user-defined routes to each subnet's route table. For more information about user-defined routes, see [User-defined in Virtual network traffic routing][Virtual network traffic routing - User-defined].

## Scenario details

Network routing is the process of determining the path that traffic takes across networks to reach a destination. Route tables list network topology information that's useful for determining routing paths.

When your virtual network contains a network virtual appliance (NVA), you need to manually configure and update your route tables.

This article presents a solution for managing the dynamic routing between NVAs and virtual networks. At the core of the solution is Azure Route Server. This service simplifies the configuration, maintenance, and deployment of NVAs in your virtual network. When you use Route Server, you no longer need to manually update NVA route tables when your virtual network addresses change.

### Potential use cases

This solution applies to scenarios that:

- Use dual-homed networks. Besides typical hub-and-spoke network topologies, Router Server also supports dual-homed network topologies. This type of configuration peers a spoke virtual network with two or more hub virtual networks. For detailed information, see [About dual-homed network with Azure Route Server][About dual-homed network with Azure Route Server].
- Connect NVAs to Azure ExpressRoute. Some virtual networks contain Route Server, an ExpressRoute gateway, and an NVA. By default, Route Server doesn't propagate the NVA routes to ExpressRoute. Route Server also doesn't propagate ExpressRoute routes to the NVA. You can get ExpressRoute and the NVA to exchange routes by turning on route exchange functionality in Route Server. For detailed information, see [About Azure Route Server support for ExpressRoute and Azure VPN][About Azure Route Server support for ExpressRoute and Azure VPN].
- Use Azure to connect to the internet from an on-premises system. Organizations that lack good internet access might use this configuration. Systems that have already migrated internet proxies to Azure are other possibilities. Route Server makes this setup possible.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

Consider these points when implementing this solution:

- Route Server establishes connections and exchanges routes. It doesn't transfer data packets. As a result, the VMs that Route Server runs in its back end don't require significant CPU power or computational power.

- When you deploy Route Server, create a subnet called `RouteServerSubnet` that uses an IPv4 subnet mask of `/26`. Place Route Server in that subnet.

- In Azure gateways, the Basic pricing tier doesn't support coexisting ExpressRoute and VPN Gateway connections. For other limitations with coexisting configurations, see [Limits and limitations][Configure ExpressRoute and Site-to-Site coexisting connections using PowerShell - Limits and limitations].

- There's no limit on the number of service endpoints that you can use in a virtual network. But some Azure services, such as Storage, enforce limits on the number of subnets that you can use to secure the resource. For more information, see [Next steps in Virtual Network service endpoints][Next steps in Virtual Network service endpoints].

When considering this solution, also keep in mind the points in the following sections.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This solution uses only managed components. At a regional level, all these components are automatically resilient. Route Server offers high availability. When you deploy Route Server in an Azure region that supports availability zones, your implementation has zone-level redundancy. For more information about availability zones, see [Regions and availability zones][Regions and availability zones].

Route Server is a fully managed service that offers high availability. For this service's availability guarantee, see [SLA for Azure Route Server][SLA for Azure Route Server].

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- For guidance on improving the security of your applications and data on Azure, see [Overview of the Azure Security Benchmark (v1)][Overview of the Azure Security Benchmark (v1)].
- For guidance from Azure Security Benchmark version 1.0 that's specific to Virtual Network, see [Azure security baseline for Virtual Network][Azure security baseline for Virtual Network].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To estimate the cost of implementing this solution, see the [Azure pricing calculator][Pricing calculator].

The following sections discuss pricing information for the solution's components.

#### Route Server

Currently, there's no upfront cost or termination fee for Route Server. For pricing information, see [Azure Route Server pricing][Azure Route Server pricing].

#### Virtual Network

You can use Virtual Network free of charge. With an Azure subscription, you can create up to 50 virtual networks across all regions. Traffic that's within a virtual network's boundaries is free. As a result, there's no charge for communication between two VMs in the same virtual network.

#### VPN Gateway

When you use VPN Gateway, all inbound traffic is free. You're charged only for outbound traffic. Internet bandwidth costs apply with VPN outbound traffic. For more information, see [VPN Gateway pricing][VPN Gateway pricing].

#### ExpressRoute

ExpressRoute data transfers that are inbound are free of charge. For outbound data transfer, you're charged a predetermined rate. A fixed monthly port fee also applies. For more information, see [Azure ExpressRoute pricing][Azure ExpressRoute pricing].

#### Service endpoints

There's no charge for using service endpoints.

#### NVAs

NVAs are charged based on the appliance that you use. You're also charged for the Azure VMs that you deploy and the underlying infrastructure resources that you consume, such as storage and networking. For more information, see [Linux Virtual Machines Pricing][Linux Virtual Machines Pricing].

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Most components in this solution are managed services that automatically scale. But there are some exceptions. For example, Route Server can support at most 4,000 VMs per virtual network, including peered virtual networks.

## Next steps

- [Quickstart: Create and configure Route Server using the Azure portal][Quickstart: Create and configure Route Server using the Azure portal]
- [About Azure Route Server support for ExpressRoute and Azure VPN][About Azure Route Server support for ExpressRoute and Azure VPN]
- [Azure Route Server FAQ][Azure Route Server FAQ]
- [Azure road map][Azure road map]
- [Networking blog][Networking blog]
- [SLA for Azure Route Server][SLA for Azure Route Server]
- [What is Azure Route Server?][What is Azure Route Server?]

## Related resources

- [Choose between virtual network peering and VPN gateways][Choose between virtual network peering and VPN gateways]
- [Recommendations for using availability zones and regions][Recommendations for using availability zones and regions]
- [Deploy highly available NVAs][Deploy highly available NVAs]
- [Zero-trust network for web applications with Azure Firewall and Application Gateway][Zero-trust network for web applications with Azure Firewall and Application Gateway]

[About Azure Route Server support for ExpressRoute and Azure VPN]: /azure/route-server/expressroute-vpn-support
[About dual-homed network with Azure Route Server]: /azure/route-server/about-dual-homed-network
[Azure ExpressRoute pricing]: https://azure.microsoft.com/pricing/details/expressroute
[Azure road map]: https://azure.microsoft.com/updates/?category=networking
[Azure Route Server]: /azure/route-server/overview
[Azure Route Server FAQ]: /azure/route-server/route-server-faq
[Azure Route Server pricing]: https://azure.microsoft.com/pricing/details/route-server
[Azure security baseline for Virtual Network]: /security/benchmark/azure/baselines/virtual-network-security-baseline
[Recommendations for using availability zones and regions]: /azure/well-architected/reliability/regions-availability-zones
[Choose between virtual network peering and VPN gateways]: ../../reference-architectures/hybrid-networking/vnet-peering.yml
[Configure ExpressRoute and Site-to-Site coexisting connections using PowerShell - Limits and limitations]: /azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations
[Deploy highly available NVAs]: ../guide/network-virtual-appliance-high-availability.md
[Introduction to the core Azure Storage services]: /azure/storage/common/storage-introduction?toc=/azure/storage/blobs/toc.json
[Linux Virtual Machines Pricing]: https://azure.microsoft.com/pricing/details/virtual-machines/linux
[Networking blog]: https://azure.microsoft.com/blog/topics/networking
[Next steps in Virtual Network service endpoints]: /azure/virtual-network/virtual-network-service-endpoints-overview#next-steps
[Overview of the Azure Security Benchmark (v1)]: /security/benchmark/azure/overview-v1
[Pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Quickstart: Create and configure Route Server using the Azure portal]: /azure/route-server/quickstart-configure-route-server-portal
[Regions and availability zones]: /azure/reliability/availability-zones-overview
[SLA for Azure Route Server]: https://azure.microsoft.com/support/legal/sla/route-server/v1_0
[Virtual Network]: /azure/well-architected/service-guides/virtual-network
[Virtual network peering]: /azure/virtual-network/virtual-network-peering-overview
[Virtual Network service endpoints]: /azure/virtual-network/virtual-network-service-endpoints-overview
[Virtual network traffic routing - Custom routes]: /azure/virtual-network/virtual-networks-udr-overview#custom-routes
[Virtual network traffic routing - Optional default routes]: /azure/virtual-network/virtual-networks-udr-overview#optional-default-routes
[Virtual network traffic routing - User-defined]: /azure/virtual-network/virtual-networks-udr-overview#user-defined
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1886347-manage-routing-azure-route-server-architecture.vsdx
[VPN Gateway]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[VPN Gateway pricing]: https://azure.microsoft.com/pricing/details/vpn-gateway
[What is Azure ExpressRoute?]: /azure/well-architected/service-guides/azure-expressroute
[What is Azure Route Server?]: /azure/route-server/overview
[Zero-trust network for web applications with Azure Firewall and Application Gateway]: ../../example-scenario/gateway/application-gateway-before-azure-firewall.yml
