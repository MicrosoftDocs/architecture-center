This guide shows you how to transition an IPv4 hub and spoke network topology to IPv6. It uses the [Hub and spoke network topology](/azure/architecture/reference-architectures\hybrid-networking\hub-spoke-content) as the starting point and walks you through the steps required to support IPv6. The hub virtual network acts as a central point of connectivity to spoke virtual networks. The spoke virtual networks connect with the hub and isolate application resources. For more information, see [Transitioning to IPv6](/azure/architecture/networking/guide/ipv6/ipv6-ip-planning).


## Architecture

[ ![Diagram that shows a Hub and Spoke architecture with the necessary components for IPv6 support.](./media/ipv6-hub-spoke.png)](./media/ipv6-hub-spoke.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-network-topology-architecture.vsdx) of this architecture.*

### Worklow

1. On-premises network: VPN connection from on-premises network to connected Azure regions.
1. Dual Stack Hub virtual network: A virtual network spoke for the central hub in the primary region or region A. Dual Stack means the IPv4 and IPv6 Address spaces have been defined correctly. 
1. Azure Firewall: Allowing traffic from the Internet can be filtered and secured using the Azure Firewall rules. 
1. Spoke Virtual Networks: There are 4 spokes that are peered to the Hub Virtual Network. Two Production and Two Non Production spokes. 
1. Virtual Machines: These Virtual Machines are set up with Dual Stack Network Interfaces, meaning there is a IPv4 and IPv6 address on the network interface. 
1. Network Security Groups: The network security groups on the subnets in the spokes can be used to filter out unwanted traffic. 
1. User Defined Routes: These routes will allow our IPv6 traffic to flow according to our expectations
1. Optional Load Balancers: Share the load over multiple machines for higher resiliency. 
1. Azure Bastion: Makes secure virtual machine connectivity possible without using RDP.
1. Azure Monitor: All of the monitoring requirements for resources are handled by Azure Monitor. 
1. Azure Subscription: All of this is hosted in an Azure Subscription. 

### Components

This hub-spoke network configuration with dual stack uses the following architectural elements:

- **Hub virtual network.** Azure Virtual Network is the fundamental building block for private networks in Azure. Virtual Network enables many Azure resources, such as Azure VMs, to securely communicate with each other, cross-premises networks, and the internet.The hub virtual network hosts shared Azure services. Workloads hosted in the spoke virtual networks can use these services. The hub virtual network is the central point of connectivity for cross-premises networks. 

- **Spoke virtual networks.** Spoke virtual networks isolate and manage workloads separately in each spoke. Each workload can include multiple tiers, with multiple subnets connected through Azure load balancers. Spokes can exist in different subscriptions and represent different environments, such as Production and Non-production.

- **Network Interfaces.** Required for Virtual Machine communication. Virtual Machines and other resources can be set up to have multiple network interfaces. This allows for Dual Stack (IPv4 and IPv6) configurations to be created.

- **Public IP Address.** Is used respectively for incoming IPv4 and IPv6 connectivity to Azure resources.

- **Virtual network connectivity.** This architecture connects virtual networks by using [peering connections](/azure/virtual-network/virtual-network-peering-overview) or [connected groups](/azure/virtual-network-manager/concept-connectivity-configuration). Peering connections and connected groups are non-transitive, low-latency connections between virtual networks. Peered or connected virtual networks can exchange traffic over the Azure backbone without needing a router. [Azure Virtual Network Manager](/azure/virtual-network-manager/overview) creates and manages [network groups](/azure/virtual-network-manager/concept-network-groups) and their connections.

- **Azure Bastion host.** Azure Bastion provides secure connectivity from the Azure portal to virtual machines (VMs) by using your browser. An Azure Bastion host deployed inside an Azure virtual network can access VMs in that virtual network or in connected virtual networks.

- **Azure Firewall.** Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. An Azure Firewall managed firewall instance exists in its own subnet.

- **Azure VPN Gateway or Azure ExpressRoute gateway.** A virtual network gateway enables a virtual network to connect to a virtual private network (VPN) device or Azure ExpressRoute circuit. The gateway provides cross-premises network connectivity. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network](/microsoft-365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network?view=o365-worldwide) and [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager). To use IPv6 in Azure route table, you need to create or modify an ExpressRoute circuit and enable IPv6 Private Peering. You can either add IPv6 Private Peering to your existing IPv4 Private Peering configuration by selecting "Both" for Subnets, or only use IPv6 Private Peering by selecting "IPv6". You also need to provide a pair of /126 IPv6 subnets that you own for your primary and secondary links.

- **Load Balancer.** Load Balancers allow you to share traffic between multiple machines that have the same purpose. In this scenario the Load Balancers are used to allow traffic to be distributed between multiple subnets that have been configured in Dual Stack to support IPv6. Optional IPv6 health probe to determine which backend pool instances are health and thus can receive new flows. Optional IPv6 ports can be reused on backend instances using the Floating IP feature of load-balancing rules. Also see, [Deploy an IPv6 dual stack application using Standard Internal Load Balancer in Azure using PowerShell
](/azure/load-balancer/ipv6-dual-stack-standard-internal-load-balancer-powershell)

- **Route Tables.** Azure automatically creates system routes and assigns the routes to each subnet in a virtual network. You can't create system routes, nor can you remove system routes, but you can override some system routes with custom routes. You create custom routes by either creating user-defined routes, or by exchanging border gateway protocol (BGP) routes between your on-premises network gateway and an Azure virtual network gateway. You can create custom, or user-defined(static), routes in Azure to override Azure's default system routes, or to add more routes to a subnet's route table. In Azure, you create a route table, then associate the route table to zero or more virtual network subnets. Each subnet can have zero or one route table associated to it. Azure's original IPv6 connectivity makes it easy to provide dual stack (IPv4/IPv6) Internet connectivity for applications hosted in Azure. It allows for simple deployment of VMs with load balanced IPv6 connectivity for both inbound and outbound initiated connections. This feature is still available and more information is available here. IPv6 for Azure virtual network is much more full featured- enabling full IPv6 solution architectures to be deployed in Azure, see [What is IPv6 for Azure Virtual Network](/azure/virtual-network/ip-services/ipv6-overview)

- **Virtual Machines** Linux and Windows Virtual Machines can all use IPv6 for Azure Virtual Network, see [Add IPv6 configuration to virtual machine](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#add-ipv6-configuration-to-virtual-machine)

- **Azure Subscription.** A logical container for your resources. Each Azure resource is associated with only one subscription. Creating a subscription is the first step in adopting Azure.

- **Azure Bastion.** Azure Bastion is a fully managed Platform-as-a-Service (PaaS) offering provided and maintained by Microsoft. It is designed to provide secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to virtual machines (VMs) without any exposure through public IP addresses.

- **Azure Monitor.** Azure Monitor is a comprehensive monitoring solution for collecting, analyzing, and responding to monitoring data from your cloud and on-premises environments. You can use Azure Monitor to maximize the availability and performance of your applications and services.

## Transition the hub virtual network

To start using IPv6 from the Hub-Spoke deployment model we need to make a few changes to some of our resources:

- Add IPv6 Address Space to the Virtual Network
- If you are using ExpressRoute you need to add IPv6 Private Peering to your ExpressRoute circuit
- Modify any User Defined Routes to allow IPv6 Traffic

## Transition the spoke virtual networks

To start using IPv6 from the spoke Virtual Networks we need to make a few changes to some of our resources:

- Create a dual-stack virtual network with both IPv4 and IPv6 address space
- Create Network interfaces for resources in the spokes like Virtual Machines, Load Balancers and other resources.
- Associate the interfaces to the resources
- Modify any User Defined Routes to allow IPv6 Traffic

## Deploy an Example IPv6 in Azure Virtual Network (VNET)

![Azure Public Test Date](https://azurequickstartsservice.blob.core.windows.net/badges/demos/ipv6-in-vnet/PublicLastTestDate.svg)
![Azure Public Test Result](https://azurequickstartsservice.blob.core.windows.net/badges/demos/ipv6-in-vnet/PublicDeployment.svg)

![Azure US Gov Last Test Date](https://azurequickstartsservice.blob.core.windows.net/badges/demos/ipv6-in-vnet/FairfaxLastTestDate.svg)
![Azure US Gov Last Test Result](https://azurequickstartsservice.blob.core.windows.net/badges/demos/ipv6-in-vnet/FairfaxDeployment.svg)

![Best Practice Check](https://azurequickstartsservice.blob.core.windows.net/badges/demos/ipv6-in-vnet/BestPracticeResult.svg)
![Cred Scan Check](https://azurequickstartsservice.blob.core.windows.net/badges/demos/ipv6-in-vnet/CredScanResult.svg)

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fdemos%2Fipv6-in-vnet%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fdemos%2Fipv6-in-vnet%2Fazuredeploy.json)
[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fdemos%2Fipv6-in-vnet%2Fazuredeploy.json)

**This template demonstrates creation of a dual stack IPv4/IPv6 VNET with 2 dual stack VMs.**

The template creates the following Azure resources:

- a dual stack IP4/IPv6 Virtual Network (VNET) with a dual stack subnet
- a virtual network interface (NIC) for each VM with both IPv4 and IPv6 endpoints
- an Internet-facing Load Balancer with an IPv4 and an IPv6 Public IP addresses
- IPv6  Network Security Group rules (allow HTTP and RDP)
- an IPv6 User-Defined Route to a fictitious Network Virtual Appliance
- an IPv4 Public IP address for each VM to facilitate remote connection to the VM (RDP)
- two virtual machines with both IPv4 and IPv6 endpoints in the VNET/subnet

For a more information about this template, see [What is IPv6 for Azure Virtual Network?](/azure/virtual-network/ipv6-overview/)

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
