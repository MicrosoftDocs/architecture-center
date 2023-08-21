[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article is a discussion on multiple options available to establish network connectivity with Azure VMware Solution private cloud.  Network connectivity can be established from multiple sources such as on-premises data center, head offices, remote branch locations, external users, and many more.

## Architecture

The following high-level architecture diagram covers key networking scenarios.

[![Diagram showing the Azure VMware Solution network architecture.](../media/azure-vmware-solution-networking.svg)](../media/azure-vmware-solution-networking.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/azure-vmware-solution-networking.vsdx) of this architecture.*

This architecture showcases a key network design that enables the following scenarios:

- Connectivity between on-premises and Azure VMware Solution private cloud
- Connectivity between public internet and Azure VMware Solution private cloud
- Connectivity between branch/VPN sites and Azure VMware Solution private cloud
- Connectivity between Azure and Azure VMware Solution private cloud

Each route design is denoted by a number (1, 2, 3, and so on) and is discussed in detail below. Route numbers do not represent any priority.

### Workflow

#### Azure ExpressRoute Global Reach (route 1)

Route 1 depicts the on-premises site connectivity with the Azure VMware Solution private cloud. This connectivity is established using [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach). This connectivity consists of a pair of routers. The first router is referred to as the Microsoft Enterprise Edge (MSEE) router. This router establishes connectivity between an on-premises site and Azure. The second router is referred as the Dedicated Microsoft Enterprise Edge (D-MSEE) router. The second router establishes connectivity between Azure and the Azure VMware Solution private cloud. D-MSEE router pricing is included in the Azure VMware Solution pricing. Network throughput for ExpressRoute Global Reach is capped at the smallest throughout between two circuits.

#### Azure VPN Gateway (route 2)

Route 2 depicts connectivity using site-to-site (S2S) VPN connectivity for *migration* purpose. This connectivity establishes network connectivity between on-premises VMware site and Azure VMware Solution private cloud.

Azure VPN gateways are available either in a hub Azure Virtual Network (VNet) or in Azure Virtual WAN (vWAN).

In Azure vWAN, VPN gateways have a transit connectivity with ExpressRoute gateways enabled by default. Azure VMware Solution private cloud's D-MSEE can be terminated on ExpressRoute gateway - which has a networking path to a VPN site connected to VPN gateway.

In hub Azure Virtual Network, there is no transit connectivity between VPN and ExpressRoute gateway enabled by default. To achieve such transit connectivity either [Azure Route Server](https://learn.microsoft.com/azure/route-server/expressroute-vpn-support) or a third party Network Virtual Appliance (NVA) can be used. Once such transit connectivity is available, Azure VMware Solution private cloud's D-MSEE can be terminated on ExpressRoute gateway and then transited over to VPN site over VPN gateway.  

Existing Workloads running on on-premises location can be migrated using VPN connection by using this topology. Azure vWAN VPN gateways are built for higher scalability and throughput, compared to VPN gateways in hub Azure Virtual Networks.

#### Public IP address on NSX-T Edge node in the Azure VMware private cloud (route 3)

Route 3 shows an option for performing HCX migration by using a public IP address on an NSX-T Edge node in the Azure VMware Solution private cloud. You might consider using this option if ExpressRoute or VPN connectivity is impossible or time-consuming. For the best migration experience, it is recommended to use ExpressRoute connectivity.

#### Remote VPN site (route 4)

Route 4 depicts connectivity using site-to-site (S2S) VPN connectivity for *accessing* purpose. Unlike in [Azure VPN Gateway (route 2)](#azure-vpn-gateway-route-2), site connected to Azure does not need to have any VMware environment. Purpose of this topology is to allow connectivity from remote VPN sites to Azure VMware Solution private cloud workloads.

VPN connectivity with remote sites can be established from Azure either by using VPN gateway in hub virtual network or in Azure vWAN.

VPN gateway in hub virtual network will need Azure Route Server or a third party NVA to enable transit connectivity with ExpressRoute gateway which is used to terminate D-MSEE ExpressRoute circuit of Azure VMware Solution private cloud.

VPN gateway in Azure vWAN has transit connectivity enabled with ExpressRoute gateway in Azure vWAN out of the box. Azure vWAN's ExpressRoute gateway is used for termination of D-MSEE ExpressRoute circuit of Azure VMware Solution private cloud.  

#### Azure Application Gateway (route 5)

Route 5 shows how Azure services can be integrated with Azure VMware Solution private cloud. In this route, external user requests arrive at [Azure Application Gateway](/azure/application-gateway/overview), which is commonly referred to as App Gateway. App Gateway is a layer 7 load balancer. It exposes a public IP address that can be associated with a DNS entry. App Gateway can use Azure VMware Solution private cloud guest VMs as its backend. The combination of App Gateway as a frontend and Azure VMware Solution VMs as a backend ensures that no public IP is exposed from the Azure VMware Solution environment. App Gateway provides services such as Web Application Firewall (WAF), which ensures that common security vulnerabilities (such as SQL injection, CSRF, XSS, and so on) are mitigated even before a request can reach the Azure VMware Solution environment. App Gateway is one of the ideal solutions for any web-facing workload that's running in an Azure VMware Solution environment.

#### Network Virtual Appliance (NVA) from Azure Marketplace (route 6)

Route 6 depicts the use of [Azure Marketplace](https://azuremarketplace.microsoft.com) solutions. Azure Marketplace provides a large collection of partner solutions across multiple IT solution categories, such as firewalls, Network Virtual Appliances (NVAs), load balancers, and so on. In this flow, customers can choose from their favorite vendor's solution for accepting external user requests. Depending on the configured routes and the security check, as evaluated by the vendor solution, the request can then be forwarded to Azure VMware Solution private cloud guest VMs.  Customers can take advantage of the license mobility that's offered by a partner from an on-premises environment, and they can use it in Azure VMware Solution private cloud.

#### Azure Virtual WAN (route 7)

Route 7 shows the use of a public IP address that's associated with [Secure Azure Virtual WAN](/azure/firewall-manager/secure-hybrid-network) (vWAN). In this route, Azure vWAN is configured with a public IP address that's associated with its firewall. A firewall rule is then configured with a D-NAT rule. The rule will route requests that arrive at the public IP address, to the private IP that's associated with the Azure VMware Solution VM. Additional firewall rules can also be configured using Azure Firewall Manager. Azure vWAN provides transitive connectivity for any-to-any network connectivity. This capability enables access to Azure VMware Solution (AVS) private cloud guest VMs using Azure vWAN.

#### Azure VNet peering (route 8)

Route 8 shows connectivity with an Azure VMware Solution private cloud from Azure Virtual Networks (VNets) using [Azure Virtual Network peering](/azure/virtual-network/virtual-network-peering-overview). An Azure VMware Solution private cloud can be connected a VNet at the time of provisioning. This VNet can be peered with other VNets that run workloads inside of them. Any Azure VMware Solution private cloud guest VM can then connect with other workloads and exchange data in both directions. VNet peering provides low-latency, high-throughput connectivity over a Microsoft backbone network, which enables seamless connectivity between Azure VMware Solution private cloud and other workloads that run in Azure.

#### Azure vWAN VNet connection (route 9)

Route 9 depicts connection between Azure Virtual Networks (VNets) and Azure VMware Solution private cloud guest VMs. Unlike in [Azure Virtual WAN (route 7)](#azure-virtual-wan-route-7), which represents connectivity between Azure VMware Solution private cloud and outside world, route 9 depicts connectivity between Azure VNets connected to Azure vWAN and Azure VMware Solution private cloud guest VMs. Azure vWAN offers transit connectivity between sites connected to it's various gateways (VPN, ER or VNet). This feature is utilized by this route.

#### Azure private endpoint (route 10)

Route 10 represents connectivity between Azure services and Azure VMware Solution private cloud guest VMs over a [Private Endpoint](/azure/private-link/private-endpoint-overview). An Azure service, such as Azure SQL DB or Azure Cosmos DB, can create a private endpoint into an Azure Virtual Network (VNet). This private endpoint gets a private IP address assigned from the VNet's IP address space. An Azure VMware Solution private cloud is connected to that VNet using one of the two ways below.

1. Azure VMware Solution private cloud terminates it's D-MSEE ExpressRoute circuit on an ExpressRoute Gateway in the same VNet.
1. VNet used to terminate Azure VMware Solution private cloud's D-MSEE ExpressRoute circuit is peered with VNet hosting the private endpoint.

This scenario represents initial steps towards the gradual modernization of VMs in Azure VMware Solution private cloud. As an example, this connectivity will enable a Web Server VM in Azure VMware Solution to connect with Azure SQL DB, which is a managed SQL database service.

#### Azure PaaS endpoint (route 11)

Route 11 depicts connectivity from Azure VMware Solution private cloud guest VMs to Azure PaaS services using a public endpoint. This connectivity is similar to route 10. However, the difference between the two routes lies in the Azure PaaS service endpoint. Route 11 uses a public endpoint, whereas route 10 uses a private endpoint. With more and more Azure services offering connectivity over a private endpoint, it is recommended to use private endpoint. For those services that do not offer a private endpoint yet, Azure VMware SOlution guest VMs can use their public endpoints for consuming them.

#### Public IP address on an NSX-T Edge node in the Azure VMware Solution cloud (route 12)

Route 12 enables inbound and outbound internet connectivity to VMs that are running in the Azure VMware Solution private cloud. This connectivity uses a public IP address that's deployed on an NSX-T Edge node. This route provides SNAT and DNAT capabilities. Although this route simplifies inbound and outbound internet connectivity, it is recommended that you evaluate this configuration by taking into account [Internet connectivity design considerations](/azure/azure-vmware/concepts-design-public-internet-access).

### Components

- [Azure VMware Solution](https://azure.microsoft.com/services/azure-vmware)
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute)
- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager)
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway)
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network)
- [Azure Virtual WAN](https://azure.microsoft.com/services/virtual-wan)
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway)
- [Azure Route Server](https://azure.microsoft.com/products/route-server)

## Scenario details

This article discusses how to use Azure native services (such as Azure ExpressRoute, Azure Traffic Manager, and Azure Application Gateway), as some key services that assist in connecting Azure VMware Solution workloads to an on-premises environment, as well as with external users.

> [!NOTE]
> See [Enterprise-scale for Microsoft Azure VMware Solution](/azure/cloud-adoption-framework/scenarios/azure-vmware/enterprise-scale-landing-zone) for the latest landing zone guidance.

### Potential use cases

Providing network connectivity can enable the following key use cases:

- Extend an on-premises VMware environment to Azure.
- Migrate VMware workloads from on-premises to Azure.
- Enable secure connectivity from the public internet to Azure VMware Solution workloads.
- Set up disaster recovery (DR) processes between an on-premises environment and an Azure VMware Solution environment, or between two Azure VMware Solution environments.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Mahesh Kshirsagar](https://www.linkedin.com/in/mahesh-kshirsagar-msft) | Cloud Solution Architect

## Next steps

See the following guidance about additional AVS architectural options:

* [Azure VMware Solution Foundation - Landing Zone](/azure/architecture/solution-ideas/articles/azure-vmware-solution-foundation-landing-zone)
* [Azure VMware Solution Foundation - Capacity Planning](/azure/architecture/solution-ideas/articles/azure-vmware-solution-foundation-capacity)

## Related resources

Refer to the following related resources:

* [Enterprise-scale for Microsoft Azure VMware Solution](/azure/cloud-adoption-framework/scenarios/azure-vmware/enterprise-scale-landing-zone)
* [Azure VMware Solution](/azure/azure-vmware/)
* [Networking planning checklist](/azure/azure-vmware/tutorial-network-checklist)
