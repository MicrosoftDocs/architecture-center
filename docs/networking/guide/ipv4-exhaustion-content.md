This article describes two methods to minimize IPv4 address space consumption when you build large networks in Azure. The proposed methods rely on network topologies that allow re-using the same IPv4 address blocks in multiple Virtual Networks or landing zones.

## Scenario details

Corporate networks typically use address spaces included in the private IPv4 address ranges defined by [RFC 1918](https://datatracker.ietf.org/doc/html/rfc1918): 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16. In on-premises environments, these ranges provide enough IP addresses to meet the requirements of even the largest networks. As a result, many organizations developed address management practices that prioritize simple routing configurations and agile processes for IP allocation. Efficient use of the IPv4 address space often isn't a priority. 
In the cloud, large networks are easy to build, and some common architectural patterns, like microservices or containerization, might lead to increased IPv4 address consumption. Therefore, it’s important to adopt more conservative address management practices and treat IPv4 addresses as a limited resource.

### Azure Virtual Network IP address ranges

We recommend that you use the address blocks defined by RFC 1918 in your Azure virtual networks. These address blocks are for general purposes private networks and are non-routable on the public internet.
In Azure Virtual Networks, you can use other ranges. Please refer to [the official documentation](/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-virtual-networks) for more details.

### Azure landing zone alignment

The recommendations in this article apply to network topologies based on the [Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture). In these types of network topologies:
- Each region where Azure resources are deployed has a hub and spoke network.
- Hub and spoke networks in different regions are connected to each other via global virtual network peering.
- Hub and spoke networks are connected to on-premises sites via a combination of ExpressRoute circuits and site-to-site VPNs.

In the Azure landing zone architecture, applications are deployed to their own spoke virtual network. Each spoke virtual network has an IPv4 address space that is unique across the corporate network. All resources deployed in a landing zone can (i) use their IP address to initiate connections to any other resources in the corporate network and (ii) be directly reached from the entire corporate network through their IP address. However, reachability from the entire corporate network is not always needed. For example, in a landing zone that contains a three-layer web application (HTTP front-end, business logic, data layer), only the HTTP front-end must be reachable from outside the landing zone. The other layers must be able to connect with each other and with the front-end, but do not need to be reachable by clients. This example suggests that IPv4 address consumption can be minimized by assigning to each landing zone:
-	An address space that is unique across the entire corporate network, only used for resources that must be reachable from outside their landing zone. In this article, this address space is referred to as the landing zone’s routable address space. 
-	An internal address space for resources that need to communicate only with other resources inside their own landing zone. This address space does not need to be directly reachable from the corporate network. In this article, this address space is referred to as the landing zone’s non-routable address space.

This article covers two methods for building Azure landing zones with routable and non-routable address spaces. 
- Method 1: Use [IPv4 subnet peering](/azure/virtual-network/how-to-configure-subnet-peering) to exclude one or more subnets from the peering between the landing zone’s spoke virtual network and the hub virtual network. Subnets excluded from the peering relationship can be assigned the same non-routable IP address ranges in all landing zones. These IP address ranges cannot overlap with any other routable IP address ranges.
- Method 2: Deploy applications in isolated virtual networks not connected to the landing zones' virtual networks, and associate their endpoints with Private Link services. In the landing zones' spoke virtual networks, create Private Endpoints associated with Private Link Services. The isolated virtual networks can get any IPv4 address space, even if it overlaps with the corporate network’s routable address space.

In the following sections, front-end component refers to an application component that must be reachable from the entire corporate network. Back-end component refers to an application component that doesn't expose endpoints in the corporate network and only needs to be reachable from within its own landing zone. 

## Method 1: Non-routable subnets in landing zone spoke virtual networks

[IPv4 subnet peering](/azure/virtual-network/how-to-configure-subnet-peering) allows restricting a peering relationship between two virtual networks to select subnets. Only subnets that are included in the peering configuration can route traffic to each other. Subnets that are excluded from the peering configuration are not visible and not reachable from the peer virtual network. If, in a hub and spoke topology, one or more subnets in each spoke are excluded from the peering configuration, those subnets are not visible to/reachable from the hub or any other remote network connected to the hub over other peerings, ExpressRoute or VPN connections. Therefore, all subnets excluded from the peering configuration can be assigned the same address range in all spoke virtual networks. That range must be defined as “non-routable” and cannot be used anywhere else in the corporate network.

The following diagram provides an example where the range 10.57.0.0/16 has been chosen as the non-routable address space:
- The hub virtual network and each landing zone spoke virtual network are assigned routable (unique) IP address ranges (10.0.0.0/24, 10.1.0.0/24, 10.2.0.0/24). 
- Each landing zone spoke virtual network also contains one or more non-routable subnets with address space included in the non-routable range 10.57.0.0/16 (the address space of an Azure Virtual Network can include multiple IP address ranges). 
- These subnets are excluded from the peering relationship with the hub. Therefore, non-routable subnets in different landing zone spokes can have the same, or overlapping, address ranges included in 10.57.0.0/16.

:::image type="content" source="./images/ipv4-exhaustion-hub-spoke-subnet-peering.svg" alt-text="Diagram that shows how to use subnet peering for landing zones with routable and non-routable address spaces." border="false" lightbox="./images/ipv4-exhaustion-hub-spoke-subnet-peering.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-hub-spoke-subnet-peering.pptx) of this architecture.*

This approach does not introduce any connectivity constraints within a landing zone’s spoke virtual network. All resources deployed in the same spoke virtual network can connect with each other, irrespective of which subnet (routable or non-routable) they are in. However, only resources deployed in routable subnets can connect to resources outside of their own landing zone.

### Deploying applications to landing zones

When using subnet peering to build landing zones with non-routable subnets, different patterns exist for spreading an application’s front-end and back-end components across routable and non-routable subnets. The considerations that follow apply both to newly built applications and to applications migrated from traditional landing zones with a single, entirely routable address space. 

Applications that are exposed via layer-7 application delivery controllers (Azure Application Gateway or 3rd party NVAs). For these applications, the only endpoints that must be reachable from clients outside of their own landing zone are exposed by the application delivery controller itself. Therefore, the application delivery controller is the only front-end component that must reside in a routable subnet.

Applications are exposed via an Azure load balancer. If an application exposes its endpoints via an internal Azure load balancer, the virtual machines that are part of the load balancer’s back-end pool must reside in a routable subnet. All the other components can be deployed to non-routable subnets.
The following diagram shows the two patterns. Landing zone “A” hosts a three-layer web application exposed through an application deliver controller, which is the only component deployed in a routable subnet. Landing zone “B” hosts a three-layer application exposed through an Internal Azure Load Balancer.

:::image type="content" source="./images/ipv4-exhaustion-deploying-apps.svg" alt-text="Diagram that shows how to deploy applications in landing zones with routable and non-routable address spaces." border="false" lightbox="./images/ipv4-exhaustion-deploying-apps.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-deploying-apps.pptx) of this architecture.*

### Outbound dependencies

An application’s back-end components don't need to be reachable, or receive inbound connections, from the corporate network. But they might need to initiate connections to endpoints that are outside their landing zone. Typical examples include DNS resolution, interaction with Active Directory Domain Services Domain Controllers, accessing applications in other landing zones or shared services (such as log management or backup systems).
When resources deployed in non-routable subnets need to initiate connections to endpoints outside of their landing zone, those connections must be Source-NATted behind a routable IP address. Therefore, a NAT-capable NVA must be deployed in each landing zone, in a routable subnet, as shown in the following diagram.

:::image type="content" source="./images/ipv4-exhaustion-snat-nva.svg" alt-text="Diagram that shows how the custom route table forwards traffic to the SNAT device." border="false" lightbox="./images/ipv4-exhaustion-snat-nva.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-nva.pptx) of this architecture.*

**Non-routable subnets** must be associated with a custom route table that forwards all traffic destined outside of the landing zone to the NAT-capable NVA. In the previous diagram, the range 10.57.0.0/16 is non-routable, while any other ranges included in 10.0.0.0/8 are routable. The custom route table associated with each non-routable subnet must contain this UDR:

| Destination | Next Hop Type           | Next Hop Ip Address                  |
| ----------- | ----------------------- | ------------------------------------ |
| 10.0.0.0/8  | VirtualNetworkAppliance | \<Spoke NAT-capable NVA IP address\> |

A system route for destinations included in the non-routable range 10.57.0.0/16 is already present in the virtual network’s route table. No UDRs are needed for traffic destined to the non-routable subnets.

**Routable subnets**, including the subnet hosting the NAT-capable NVA, must be associated with a custom route table that forwards traffic outside of the landing zone (typically to routing/firewalling NVA in the hub virtual network). In the previous diagram, the custom route table associated with each routable subnet must contain these UDRs:

| Destination  | Next Hop Type           | Next Hop Ip Address                |
| ------------ | ----------------------- | ---------------------------------- |
| 10.0.0.0/8   | VirtualNetworkAppliance | \<Hub router/firewall IP address\> |
| 10.0.0.0/24  | VirtualNetworkAppliance | \<Hub router/firewall IP address\> |

The second UDR with destination 10.0.0.0/24 is needed to make sure that connections to resources deployed in the hub virtual network are routed via the hub firewall. Specific applications may require more UDRs. Also, a default route (0.0.0.0/0) is needed if virtual machines in the landing zone are meant to access the internet via NVAs (typically hosted in the hub virtual network).

> [!NOTE]
> Client to Active Directory Domain Services (ADDS) Domain Controllers (DCs) communication over NAT is supported. DC to DC communication over NAT has not been tested and is not supported as detailed in [Description of support boundaries for Active Directory over NAT](/troubleshoot/windows-server/active-directory/support-for-active-directory-over-nat). Microsoft recommends that you deploy Active Directory DCs to routable subnets.

Both Azure Firewall and third-party NVAs can be used as NAT-capable devices. The following sections cover both options. It should be noted that Azure NAT Gateway cannot be used, because it provides SNAT only for internet-bound traffic. 

#### Implement SNAT via Azure Firewall

When low complexity and low management effort must be prioritized, Azure Firewall is the preferred option to implement SNAT for connections originating from non-routable subnets. Azure Firewall provides:
- Fully managed lifecycle.
- Built-in High Availability.
- Auto-scaling based on traffic volume.

When using Azure Firewall, the following considerations apply.
- Azure Firewall must be deployed into its own reserved subnet (named AzureFirewallSubnet), which must have a routable address space. 
- Some Azure Firewall SKUs and/or configurations may require a second reserved subnet, for firewall management purposes. The management subnet does not require a routable address range.
- Azure Firewall is available in three different SKUs. SNAT is not a resource-intensive task, so consider the basic SKU first. For landing zones that generate large volumes of outbound traffic from the non-routable subnets, consider the standard SKU.
- Azure Firewall must be configured with the Perform SNAT option set to Always. Each instance uses all its non-privileged ports for SNAT. You can find instructions about how to configure Azure Firewall to implement SNAT on all received connections in the [public documentation](/azure/firewall/snat-private-range#configure-snat-private-ip-address-ranges---azure-portal). 
- All non-routable subnets must be associated with a custom route table to forward to the firewall’s private IP all traffic to destinations outside of the landing zone.
The following diagram shows a hub and spoke network with Azure Firewall deployed in each spoke to provide SNAT for connections originating from non-routable subnets.

:::image type="content" source="./images/ipv4-exhaustion-snat-azure-firewall.svg" alt-text="Diagram that shows the SNAT implementation by using Azure Firewall." border="false" lightbox="./images/ipv4-exhaustion-snat-azure-firewall.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-azure-firewall.pptx) of this architecture.*

#### Implement SNAT via third-party NVAs

Third-party NVAs with NAT capabilities are available in Azure Marketplace. Consider using a third-party NVA if you have advanced requirements that cannot be met by using Azure Firewall, such as:
- Granular control over the NAT pool.
- Custom NAT policies. For example, you may need to use different NAT addresses for different connections.
- Granular control over scale-in and scale-out.
When using third-party NVAs, the following considerations apply.
- Deploy clusters with at least two NVAs, for high availability. 
- Use a Standard SKU Azure load balancer to distribute connections from the non-routable spoke virtual network to the NVAs. As all connections must be source-NATted, irrespective of the destination port, use [high-availability/anyport load-balancing rules](/azure/load-balancer/manage-rules-how-to#high-availability-ports). 
- NAT-capable NVAs can be single-armed or dual-armed. Single-arm configurations are simpler and therefore recommended.

The following diagram shows the landing zone layout to implement SNAT in a hub-and-spoke network topology by using third-party NVAs.

:::image type="content" source="./images/ipv4-exhaustion-snat-3rd-party-nva.svg" alt-text="Diagram that shows the SNAT implementation by using Azure Firewall." border="false" lightbox="./images/ipv4-exhaustion-snat-3rd-party-nva.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-snat-3rd-party-nva.pptx) of this architecture.*

### Hub and spoke networks based on Azure Virtual WAN
Subnet peering is currently not available for Virtual WAN. In hub and spoke networks based on Virtual WAN, it is currently not possible to have landing zone virtual networks with non- routable subnets. However, the fundamental principle of method 1 covered in this section can still be applied to Virtual WAN scenarios, by using two peered virtual networks for each landing zone. The first virtual network gets a routable address space and is connected to the Virtual WAN hub. The second virtual network gets a non-routable address space and is peered with the routable virtual network. The resulting topology is shown in the following diagram.

:::image type="content" source="./images/ipv4-exhaustion-vwan.svg" alt-text="Diagram that shows the SNAT implementation by using Azure Firewall." border="false" lightbox="./images/ipv4-exhaustion-vwan.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-vwan.pptx) of this architecture.*

This approach does not introduce any connectivity constraints within a landing zone. As the two virtual networks in the landing zone are directly peered, all resources can connect with each other, irrespective of which virtual network (routable or non-routable) they are in. However, only resources deployed in the routable virtual network can connect to resources outside of their own landing zone.

Routing-wise, having routable and non-routable subnets in the same virtual network (described in the previous section for traditional hub and spoke networks) or in directly peered virtual networks (described in this section for hub and spoke networks based on Azure Virtual WAN) makes no difference. As a result, in networks based on Virtual WAN: 
- all the considerations in the previous sections about spreading application components across routable and non-routable subnets are applicable. 
- Outbound dependencies can be managed with with NAT-capable NVAs in routable subnets.

## Method 2: Azure Private Link services

[Azure Private Link](/azure/private-link/private-link-overview) is an Azure platform feature that allows clients in a virtual network to consume applications deployed in a different virtual network, without configuring layer-3 connectivity between the two virtual networks (VNet peering, VNet-to-VNet VPN, …). The two virtual networks can use overlapping IP address ranges. The platform transparently provides the required NAT logic. This method applies to both traditional hub and spoke networks and networks based on Azure Virtual WAN. 

In order for an application to be consumed via Private Link, the application’s endpoints must be added to the back-end pool of an internal Azure Load Balancer (Standard SKU). The Load Balancer’s front-end IP is then associated with a [Private Link Service resource](/azure/private-link/private-link-service-overview). On the client side, a [Private Endpoint resource](/azure/private-link/private-endpoint-overview) is created and associated with the server-side Private Link Service. To consume the application, clients connect to the Private Endpoint. The platform transparently routes the connection to Load Balancer front-end IP associated with the corresponding Private Link Service.

Private Link can help mitigate IPv4 exhaustion issues by assigning  two virtual networks to each landing zone: 
- A virtual network with a routable address space, connected to the corporate network.
- An isolated virtual network, with an arbitrarily chosen address space, which may even overlap with the corporate network’s. 

Applications, along with the Private Link Services that expose their endpoints, are deployed to the isolated virtual networks. Private Endpoints associated with the Private Link Services are deployed into routable virtual networks.

The following diagram shows two landing zones with a large address space (10.0.0.0/16, which overlaps with the corporate network’s), assigned to isolated virtual networks. The applications are deployed into the isolated spoke virtual networks and associated with Private Link Services. 

:::image type="content" source="./images/ipv4-exhaustion-private-link.svg" alt-text="Diagram that shows the landing zone topology when Private Link services expose applications deployed in isolated virtual networks." border="false" lightbox="./images/ipv4-exhaustion-private-link.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-private-link.pptx) of this architecture.*

Clients in the corporate network consume the applications via Private Endpoints associated with Private Link Services, including across landing zones, as shown in the following diagram.

:::image type="content" source="./images/ipv4-exhaustion-private-link-conns.svg" alt-text="Diagram that shows the landing zone topology when Private Link services expose applications deployed in isolated virtual networks and how connections are established" border="false" lightbox="./images/ipv4-exhaustion-private-link-conns.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-private-link-conns.pptx) of this architecture.*

### Use a Private Link service for outbound dependencies

Applications deployed to isolated virtual networks cannot initiate connections to endpoints in the corporate network. As such, the method covered in this section is recommended for scenarios where applications in different landing zones are independent of each other and have no dependencies on systems in the corporate network. However, it is still applicable when applications deployed in isolated virtual networks need to access select endpoints outside their landing zone. The following diagram shows how Private Link Services can be used to allow the application deployed in the isolated virtual network in Landing Zone "A" to consume a shared service in the hub virtual network and an application endpoint in a different landing zone "B".

:::image type="content" source="./images/ipv4-exhaustion-private-link-outbound.svg" alt-text="Diagram that shows the architecture that uses a Private Link service for outbound dependencies." border="false" lightbox="./images/ipv4-exhaustion-private-link-outbound.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/ipv4-exhaustion-private-link-outbound.pptx) of this architecture.*

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Federico Guerrini](https://www.linkedin.com/in/federico-guerrini-phd-8185954) | Senior Cloud Solution Architect, EMEA Technical Lead Azure Networking
- [Khush Kaviraj](https://www.linkedin.com/in/khushalkaviraj) | Cloud Solution Architect
- [Jack Tracey](https://www.linkedin.com/in/jacktracey93) | Senior Cloud Solution Architect
  
Other contributors:

- [Jodi Martis](https://www.linkedin.com/in/jodimartis) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps
- [Configure Subnet Peering](/azure/virtual-network/how-to-configure-subnet-peering)
- [Deploy Azure Firewall in a virtual network](/azure/firewall/tutorial-firewall-deploy-portal-policy)
- [Configure SNAT in Azure Firewall](/azure/firewall/snat-private-range)
- [Supported IP addresses in Azure Virtual Network](/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-vnets)
- [Azure Private Link](/azure/private-link/private-link-overview)
- [Azure Load Balancer](/azure/load-balancer/load-balancer-overview)
- [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview)

## Related resources

- [Networking architecture design](../../networking/index.md)
- [Architectural approaches for networking in multitenant solutions](../../guide/multitenant/approaches/networking.md)
- [Hub-and-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology)
