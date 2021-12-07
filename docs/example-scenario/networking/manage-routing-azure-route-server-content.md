Network routing is the process of determining the path that traffic takes across networks to reach a destination. Routing tables list network topology information that's useful for determining routing paths.

When your virtual network contains a network virtual appliance (NVA), you need to manually configure and update your routing tables.

This article presents a solution for managing the dynamic routing between NVAs and virtual networks. At the core of the solution is Azure Route Server. This service simplifies the configuration, maintenance, and deployment of NVAs in your virtual network. When you use Route Server, you no longer need to manually update NVA routing tables when your virtual network addresses change.

## Potential use cases

This solution applies to scenarios that:

- Use dual-homed networks. Besides typical hub-and-spoke network topologies, Router Server also supports dual-homed network topologies. This type of configuration peers a spoke virtual network with two or more hub virtual networks. For detailed information, see [About dual-homed network with Azure Route Server][About dual-homed network with Azure Route Server].
- Connect NVAs to ExpressRoute. Some virtual networks contain Azure Route Server, an ExpressRoute gateway, and an NVA. By default, Route Server doesn't propagate the NVA routes to ExpressRoute. Route Server also doesn't propagate ExpressRoute routes to the NVA. But you can get ExpressRoute and the NVA to exchange routes by turning on route exchange functionality in Route Server. For detailed information, see [About Azure Route Server support for ExpressRoute and Azure VPN][About Azure Route Server support for ExpressRoute and Azure VPN].
- Use Azure to connect to the internet from an on-premises system. Organizations that lack good internet access might use this configuration. Systems that have already migrated internet proxies to Azure are other possibilities. Route Server makes this setup possible.

## Architecture

:::image type="content" source="./media/moodle-azure-netapp-files-single-region-architecture.png" alt-text="Architecture diagram showing how students access Moodle. Other components include Azure NetApp Files, Azure Cache for Redis, and Azure Database for MySQL." border="false":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

- This hub-and-spoke architecture has a hub virtual network and one spoke virtual network. The hub virtual network has multiple subnets, each containing virtual machines.

- The address space of each virtual network defines address ranges. For each of those ranges, Azure creates a route with the address prefix of that range. Azure adds those routes to the routing table. Each virtual network has multiple subnets. And each subnet has a network interface card (NIC) that controls connectivity. Azure injects each virtual network's routing table into the subnets' NICs.

  You can't create or remove these default system routes. But you can:

  - Override some system routes with [custom routes][Virtual network traffic routing - Custom routes].
  - Configure Azure to add [optional default routes][Virtual network traffic routing - Optional default routes] to specific subnets.

- Local networks use a VPN gateway and an ExpressRoute gateway to connect to the hub virtual network in a coexisting configuration. When you add the VPN gateway, routes with the gateway as the next route get added to the route tables. When you add ExpressRoute, the route tables are also updated. These routes propagate to all subnets.

- The border gateway protocol (BGP) makes the exchange of IP addresses between on-premises and Azure components possible. This protocol directs packets between autonomous systems. Such systems are small-sized networks or huge pools of routers that a single organization runs.

- A virtual network peering exists between the hub virtual network and the spoke virtual network. When you create the peering, Azure updates the route table. Specifically, Azure adds a route for each address range that's in the hub address space or the spoke address space. These routes propagate to all subnets.

- A subnet in the hub virtual network uses a service endpoint for Azure Storage. Azure adds a public IP address for Storage to that subnet's routing table.

- The hub virtual network contains two NVAs. The NVAs can be Gateways, SD-WANs, or security appliance firewalls. Route Server exchanges the NVA, network application, and gateway routes by:

  - Creating an instance of Azure Virtual Machine Scale Sets. Each VM in the scale set has an IP address. As with gateway IP addresses, Route Server has access to the VM IP addresses.
  - Establishing BGP peers between each NVA and a VM in the scale set.
  - Injecting the VM IP addresses into all routing tables in the virtual network and connected networks.

  There's no need to:

  - Manually add user-defined routes.
  - Manually create routing tables.
  - Link the routing table to the subnet to propagate the routes.
  - Update the routing table when IP addresses change.

### Components

- [Azure Route Server][Azure Route Server] simplifies dynamic routing between NVAs that support BGP and virtual networks. This service eliminates the administrative overhead of maintaining routing tables.

- [Virtual network peering][Virtual network peering] connects two or more Azure virtual networks. Peerings provide low-latency, high-bandwidth connections between resources in different virtual networks. Traffic between VMs in peered virtual networks only uses the Microsoft private network.

- [Azure VPN Gateway][VPN Gateway] is a specific type of virtual network gateway. You can use VPN Gateway to send encrypted traffic:

  - Between an Azure virtual network and an on-premises location over the public internet.
  - Between Azure virtual networks over the Microsoft network.

- [ExpressRoute][What is Azure ExpressRoute?] extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections to cloud components like Azure services and Microsoft 365.

- A [service endpoint][Virtual Network service endpoints] provides secure and direct connectivity to an Azure service from private IP addresses in a virtual network. The service endpoint provides the identity of the virtual network to the Azure service. So the virtual network resources don't need public IP addresses to access the service, and the endpoint protects the service by only allowing traffic from the specified virtual network. The connections use optimized routes over the Azure backbone network.

- An NVA is a virtual appliance that offers networking capabilities. Examples include firewall security, WAN optimization, routing, load balancing, proxy services, and application delivery control functionality.

- Azure Storage is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data.


### Alternatives



## Considerations

- (Maybe move this point to Pricing). Route Server only establishes connections and exchanges routes. It doesn't transfer data packets. As a result, the VMs that it runs in its backend don't require significant CPU power or computational power.

- For this solution to work, create a subnet called `Route Sever Subnet` that uses an IPv4 subnet mask of `/27`. Place Route Server in that subnet.

- Express Route-VPN Gateway coexist configuration are not supported on the basic SKU. For other limitation for such configuration, visit https://docs.microsoft.com/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations

When you implement this solution, also keep in mind the points in the following sections.

### Scalability

This solution scales up or down as needed:


### Availability

For the Azure NetApp Files availability guarantee, see [SLA for Azure NetApp Files][SLA for Azure NetApp Files].

### Security


### Resiliency

## Deploy the solution

## Pricing



## Next steps



## Related resources





[About Azure Route Server support for ExpressRoute and Azure VPN]: https://docs.microsoft.com/en-us/azure/route-server/expressroute-vpn-support
[About dual-homed network with Azure Route Server]: https://docs.microsoft.com/azure/route-server/about-dual-homed-network
[Azure Route Server]: https://azure.microsoft.com/en-us/services/route-server/
[Virtual network peering]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview
[Virtual Network service endpoints]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview
[Virtual network traffic routing - Custom routes]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#custom-routes
[Virtual network traffic routing - Optional default routes]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#optional-default-routes
[VPN Gateway]: https://azure.microsoft.com/en-us/services/vpn-gateway/
[What is Azure ExpressRoute?]: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-introduction