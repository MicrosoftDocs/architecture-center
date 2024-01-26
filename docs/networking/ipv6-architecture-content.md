This guide shows you how to transition an IPv4 hub and spoke network topology to IPv6. It uses the [Hub and spoke network topology](/azure/architecture/reference-architectures\hybrid-networking\hub-spoke-content) as the starting point and walks you through the steps required to support IPv6. The hub virtual network acts as a central point of connectivity to spoke virtual networks. The spoke virtual networks connect with the hub and isolate application resources. For more information, see [Transitioning to IPv6](/azure/architecture/networking/guide/ipv6/ipv6-ip-planning).

## Architecture

[![Diagram that shows a Hub and Spoke architecture with the necessary components for IPv6 support.](./media/ipv6-hub-spoke.png)](./media/ipv6-hub-spoke.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-network-topology-architecture.vsdx) of this architecture.*

### Workflow

1. **Public internet and cross-premises network:**
    - Users or services begin by accessing the system via the public internet, connecting to Azure resources.
    - Cross-premises network has on-premises virtual machines that connect to the Azure network through a VPN Gateway, creating a secure connection from on-premises to Azure.

1. **Azure Virtual Network Manager:**
    - It's the management layer that oversees the entire network infrastructure within Azure. It handles the routing, policies, and overall health of the virtual network.

1. **Hub virtual network:**
    - The hub is the central point of the network topology and is configured to support both IPv4 and IPv6 (hence "Dual Stack").
    - Azure Bastion provides secure and seamless RDP/SSH connectivity to your virtual machines directly in the Azure portal over TLS.
    - Azure Firewall serves as a barrier between the hub and the public internet, filtering traffic and providing protection.
    - Express Route connects the cross-premises network to the hub.
    - VPN Gateway also connects the cross-premises network to the hub and is used for redundancy.
    - The services in the hub virtual network send logs and metrics (diagnostics) to Azure Monitor for monitoring.

1. **Spoke virtual networks:**
    - There are four spokes  connected to the hub. Each spoke is a dual stack network, supporting both IPv4 and IPv6.
    - The networks are connected using [peering connections](/azure/virtual-network/virtual-network-peering-overview) or [connected groups](/azure/virtual-network-manager/concept-connectivity-configuration). Peering connections and connected groups are nontransitive, low-latency connections between virtual networks. Peered or connected virtual networks can exchange traffic over the Azure backbone without needing a router.
    - In the production virtual networks, consider implementing user-defined routes (UDRs) to direct traffic from the spokes through Azure Firewall or an alternative Network Virtual Appliance (NVA) functioning as a router in the hub. This adjustment facilitates inter-spoke connectivity. To enable this setup, Azure Firewall must be configured with forced tunneling. Further details are available in the Azure Firewall forced tunneling documentation see [forced tunneling](/azure/firewall/forced-tunneling).
    - All outbound traffic from the spoke virtual networks flows through the hub, using a configuration in Azure Firewall called forced tunneling.
    - Within each spoke, there are three subnets indicated as resource subnets, each hosting a virtual machine.
    - Each virtual machine is connected to an Internal Load Balancer, which distributes incoming network traffic across the virtual machines to ensure that no single VM becomes a point of congestion.
    - IPv6 user defined routes (UDR) define custom routes for IPv6 traffic from the spoke.

### Components

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for private networks in Azure. Virtual Network enables many Azure resources, such as Azure VMs, to securely communicate with each other, cross-premises networks, and the internet.

- [Virtual network interface](/azure/virtual-network/virtual-network-network-interface) are required for virtual machine communication. Virtual machines and other resources can be set up to have multiple network interfaces. Multiple network interfaces is what allows you to create dual stack (IPv4 and IPv6) configurations.

- [Public IP Address](/azure/virtual-network/ip-services/public-ip-addresses) is used for inbound IPv4 and IPv6 connectivity to Azure resources.

- [Azure Virtual Network Manager](/azure/virtual-network-manager/overview) creates and manages [network groups](/azure/virtual-network-manager/concept-network-groups) and their connections.

- [Azure Firewall](/azure/firewall/overview) is a managed, cloud-based network security service that protects your Azure Virtual Network resources. An Azure Firewall managed firewall instance exists in its own subnet.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) or [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute/). A virtual network gateway enables a virtual network to connect to a virtual private network (VPN) device or Azure ExpressRoute circuit. The gateway provides cross-premises network connectivity.

- [Azure Load Balancer](/products/load-balancer/) allows you to share traffic between multiple machines that have the same purpose. In this scenario, the load balancers distribute traffic between multiple subnets that support IPv6.

- [Route Table](/azure/virtual-network/manage-route-table) in Azure is a set of user-defined routes that allow for custom path definitions for network traffic.

- [Azure Virtual Machines](/products/virtual-machines/) is an infrastructure-as-a-service computing solution that supports IPv6.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed Platform-as-a-Service (PaaS) offering provided and maintained by Microsoft. It's designed to provide secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to virtual machines (VMs) without any exposure through public IP addresses.

- [Azure Monitor](/azure/azure-monitor/overview) is a comprehensive monitoring solution for collecting, analyzing, and responding to monitoring data from your cloud and on-premises environments. You can use Azure Monitor to maximize the availability and performance of your applications and services.

## Transition the hub virtual network to IPv6

To start using IPv6 in the hub virtual network, you need added IPv6 address space:

**Add IPv6 Address Space to the virtual network.** You need to add additional IPv6 address ranges to the hub virtual network first and then its subnets. You can use the [Azure portal](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#add-ipv6-to-virtual-network), [Powershell](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-powershell#add-ipv6-to-virtual-network), [Azure CLI](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-cli#add-ipv6-to-virtual-network) to add the IPv6 address space.

**Modify User Defined Routes (UDRs).** UDRs are the routes that you manually set up to override Azure's default system routes. They direct traffic from one subnet to a specific virtual appliance, gateway, or other target within Azure or on-premises. When you're adding IPv6 support to the hub virtual network, you need to make the following configurations:

- *Add IPv6 routes*: If the route table is already in place, you add new routes that specify the IPv6 address prefixes to the table.
- *Modify existing routes*: If the routes already exist for IPv4, you might need to modify them to ensure that they also apply to IPv6 traffic or create separate IPv6-specific routes.
- *Associate route table with subnets*: After defining your routes, you associate the route table with the relevant subnets within your virtual network. This association determines which subnets will use the routes you have defined.

Remember that you don’t necessarily need to add a route for every single resource, but rather for each subnet. Each subnet can have multiple resources, and they all follow the rules defined in the route table associated with their subnet. 

**Modify ExpressRoute circuit (if applicable).** To have Azure ExpressRoute support IPv6, you need to:

- *Enable IPv6 private peering*: Enable IPv6 private peering on your ExpressRoute circuit to allow the routing of IPv6 traffic between your on-premises network and the hub virtual network.
- *Allocate IPv6 address space*: Provide IPv6 subnets for your primary and secondary ExpressRoute links.
- *Update route tables*: Ensure IPv6 traffic is directed appropriately through the ExpressRoute circuit.

These changes will extend IPv6 connectivity to your Azure services through the ExpressRoute circuit. It enables dual-stack capabilities where both IPv4 and IPv6 traffic can be routed simultaneously if configured. You can use the [Azure portal](/azure/expressroute/expressroute-howto-add-ipv6-portal), [Powershell](/azure/expressroute/expressroute-howto-add-ipv6-powershell), [Azure CLI](/azure/expressroute/expressroute-howto-add-ipv6-cli) to modify ExpressRoute.


## Transition the spoke virtual networks to IPv6

To start using IPv6 in the spoke virtual networks, we need to make a few changes to some of our resources:

**Create a dual-stack virtual network with both IPv4 and IPv6 address space.** To add an IPv6 address range to your Virtual Network in Azure, start by signing in to the Azure portal. Once logged in, use the search box at the top of the portal to search for "Virtual network." From the search results, select the required Virtual Network. In the Virtual Network's settings, click on "Address space." Here, you can add an additional address range by selecting "Add additional address range." For example, you might enter something like "2404:f800:8000:122::/63." After entering the new address range, make sure to save your changes. Next, go to "Subnets" in the settings. In the Subnets section, select your desired subnet name from the list. Within the subnet configuration, check the option to "Add IPv6 address space." Here, enter the specific IPv6 address space you require, such as "2404:f800:8000:122::/64." Remember to save your configuration to apply these changes.
For an example to set this up with a Virtual Machine see [Add Dual Stack IPv6 for VM in Portal](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal).

**Modify spoke resources**: The spoke virtual networks contain virtual machines and an internal load balancer. The internal load balancer allows you to route IPv4 and IPv6 traffic to your virtual machines. Here's how to modify each resource in the spoke subnets:

- *Virtual machines:* To add IPv6 support to virtual machines, you need create and associate an IPv6 network interface to each virtual machine. For more information, see [Add IPv6 configuration to virtual machine](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#add-ipv6-configuration-to-virtual-machine).
- *Internal load balancer:* If you don't have an internal load balancer in your spoke virtual networks, you should create a dual-stack internal load balancer. For more information, see, [Create dual-stack internal load balancer](/azure/load-balancer/ipv6-dual-stack-standard-internal-load-balancer-powershell). If you already have an internal load balancer, you can use [Powershell](/azure/load-balancer/ipv6-add-to-existing-vnet-powershell or [Azure CLI](/azure/load-balancer/ipv6-add-to-existing-vnet-cli) to add IPv6 support to an internal load balancer.



- [Add IPv6 configuration to virtual machine](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#add-ipv6-configuration-to-virtual-machine)
- Load balancers: Optional IPv6 health probe to determine which backend pool instances are health and thus can receive new flows. Optional IPv6 ports can be reused on backend instances using the Floating IP feature of load-balancing rules. Also see, [Deploy an IPv6 dual stack application using Standard Internal Load Balancer in Azure using PowerShell
](/azure/load-balancer/ipv6-dual-stack-standard-internal-load-balancer-powershell)

**Modify any User Defined Routes to allow IPv6 Traffic.** Customize the routing of IPv6 traffic in your virtual network with User-Defined Routes especially when using Network Virtual Appliances to augment your application. To modify user-defined routes (UDRs) in Azure, you need to go to the route table that contains the routes you want to change, and click on “Edit routes”. Then you can remove, add, or edit the routes as needed, and save the changes. You can also use PowerShell or Azure CLI commands to modify UDRs. For example, to remove a route using PowerShell, you can use the ```Remove-AzRouteConfig``` cmdlet. To add a route using Azure CLI, you can use the ```az network route-table route create``` command.

## Contributors

*Microsoft maintains this article. The following contributors wrote it.*

Principal author:

- [Werner Rall](https://www.linkedin.com/in/werner-rall/) | Senior Cloud Solutions Architect Engineer

Other contributors:

- [Brandon Stephenson](https://www.linkedin.com/in/brandon-stephenson-3340219b/) | Senior Customer Engineer
- [Sherri Babylon](https://www.linkedin.com/in/sbabylon/) | Senior Technical Program Manager
- [Dawn Bedard](https://www.linkedin.com/in/dawnbedard/) | Principal Technical Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Learn more about [Create a VM with IPv6 Dual Stack](/azure/virtual-network/ip-services/create-vm-dual-stack-ipv6-portal)
- Learn more about [managing IP Address ranges](/azure/virtual-network/manage-virtual-network#add-or-remove-an-address-range) on Virtual Networks.

## Related resources

Read more about IPv6:

- [Cloud Adoption Framework plan for ip addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing#ipv6-considerations)
- [Azure Public IPv6 offerings are free](/azure-public-ipv6-offerings-are-free-as-of-july-31)
- [Azure Virtual Networking IPv6](/azure/virtual-network/ip-services/ipv6-overview)
- [ExpressRoute Support for IPv6](/azure/expressroute/expressroute-howto-add-ipv6-portal)
- [Azure DNS IPv6 support](/azure/dns/dns-reverse-dns-overview)
- [Azure Load Balancer IPv6 Support](/azure/load-balancer/load-balancer-ipv6-overview)
- [Add IPv6 support for private peering using the Azure portal](/azure/expressroute/expressroute-howto-add-ipv6-portal)

Read more about virtual network architecture:

- [Choose between virtual network peering and VPN gateways](/azure/architecture/reference-architectures/hybrid-networking/vnet-peering)
- [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway)
- [Virtual network integrated serverless microservices](/azure/architecture/example-scenario/integrated-multiservices/virtual-network-integration)
- [Deploy AD DS in an Azure virtual network](/azure/architecture/reference-architectures/identity/adds-extend-domain)
