A global manufacturing company provided the architecture that this article describes. The company's operational technology and information technology departments are highly integrated, demanding a single internal network. But the environments have drastically different security and performance requirements. Because of the sensitive nature of the company's operations, all traffic needs to be firewall protected by a network virtual appliance (NVA) the customer hosts on their own virtual machines and an Intrusion Detection and Protection System (IDPS) solution needs to be in place. The information technology department has less demanding security requirements for the network, but that department wants to optimize for performance, so users have low-latency access to IT applications.

Decision makers at the company turned to Azure Virtual WAN to meet global needs for a single network with varying security and performance requirements. They also got a solution that's easy to manage, deploy, and scale. As they add regions, they can continue to grow seamlessly with a network that's highly optimized for their needs.

## Potential use cases

Typical use cases for this architecture include:

- A global organization that requires a centralized file solution for business-critical work.
- High-performing file workloads that require localized cached files.
- A flexible remote workforce for users both in and out of the office.
- A requirement to use self-hosted NVAs.

## Architecture

:::image type="content" source="./_images/performance-security-optimized-vwan-architecture-azure-main.png" alt-text="Diagram that shows an architecture optimized for either security or performance, depending on the department." lightbox="./_images/performance-security-optimized-vwan-architecture-azure-main.png":::

Download a [Visio file](https://arch-center.azureedge.net/Performance-security-optimized-VWAN-architecture-azure.vsdx) of this architecture.

Here's a summary of the architecture:

- Users access virtual networks from a branch.
- Azure ExpressRoute extends the on-premises networks into the Microsoft cloud over a private connection, with the help of a connectivity provider.
- A Virtual WAN hub routes traffic appropriately for security or performance. The hub contains various service endpoints to enable connectivity.
- User-defined routes force traffic to the NVAs when necessary.
- Each NVA inspects traffic that's flowing into a virtual network.
- Virtual network peering provides VNet-to-VNet inspection in the performance-optimized environment.

The company has multiple regions and continues to deploy regions to the model. The company deploys a security-optimized or performance-optimized environment only when needed. The environments route the following traffic through the network virtual appliance (NVA):

### Traffic pathways

| |  |   |         |        | Destinations|      |        |
|--|--|--|--|--|--|--|--|
| ||**VNet1**        |**VNet2**   |**VNet3**   |**VNet4**   |**Branch**   |**Internet**   |
|**Security-optimized source**|**VNet1**|Intra VNet|NVA1-VNet2 |NVA1-hub-VNet3|NVA1-hub-VNet4|NVA1-hub-branch|NVA1-internet|
|**Performance-optimized source**| **VNet3**| hub-NVA1-VNet1 |hub-NVA1-VNet2|Intra VNet| NVA2-VNet4 |hub-branch| NVA2-internet|
|**Branch source**|**Branch**| hub-NVA1-VNet1| hub-NVA1-VNet2| hub-VNet3 |hub-VNet4| Not applicable |Not applicable|

![Diagram that shows traffic pathways for the architecture.](./_images/performance-security-optimized-vwan-azure.png)

As the preceding diagram shows, an NVA and routing architecture force all traffic pathways in the security-optimized environment to use the NVA between the virtual networks and the hub in a common layered architecture.

The performance-optimized environment has a more customized routing schema. This schema provides a firewall and traffic inspection where they're needed. It doesn't provide a firewall where it's not needed. VNet-to-VNet traffic in the performance-optimized space is forced through NVA2, but branch-to-VNet traffic can go directly across the hub. Likewise, anything headed to the secure environment doesn't need to go to NVA VNet2 because it's inspected at the edge of the secure environment by the NVA in NVA VNet1. The result is high-speed access to the branch. The architecture still provides VNet-to-VNet inspection in the performance-optimized environment. This isn't necessary for all customers but can be accomplished through the peerings that you can see in the architecture.

### Associations and propagations of the Virtual WAN hub

Configure routes for the Virtual WAN hub as follows:

|Name| Associated to |Propagating to|
|--|-|-|
|NVA VNet1 |defaultRouteTable| defaultRouteTable|
|NVA VNet2 |PerfOptimizedRouteTable| defaultRouteTable|
|VNet3 |PerfOptimizedRouteTable |defaultRouteTable|
|VNet4 |PerfOptimizedRouteTable |defaultRouteTable|

### Routing requirements

- A custom route on the default route table in the Virtual WAN hub to route all traffic for VNet1 and VNet2 to secOptConnection.

   |  Route name |Destination type| Destination prefix |Next hop| Next hop IP|
   |-|-|-|-|-|
   |Security optimized route| CIDR| 10.1.0.0/16 |secOptConnection| \<IP address of NVA1>|

- A static route on the secOptConnection forwarding the traffic for VNet1 and VNet2 to the IP address of NVA1.

   |Name| Address prefix| Next hop type| Next hop IP address|
   |-|-|-|-|
   |rt-to-secOptimized |10.1.0.0/16 |Virtual appliance| \<IP address of NVA1>|

- A custom route table on the Virtual WAN hub that's named perfOptimizedRouteTable. This table is used to ensure the performance-optimized virtual networks can't communicate with each other over the hub and must use the peering to NVA VNet2.
- A UDR associated with all subnets in VNet1 and VNet2 to route all traffic back to NVA1.

   |Name| Address prefix| Next hop type| Next hop IP address|
   |-|-|-|-|
   |rt-all |0.0.0.0/0| Virtual appliance| \<IP address of NVA1>|

- A UDR associated with all subnets in VNet3 and VNet4 to route VNet-to-VNet traffic and internet traffic to NVA2.

   |Name |Address prefix| Next hop type| Next hop IP address|
   |-|-|-|-|
   |rt-to-internet |0.0.0.0/0 |Virtual appliance |\<IP of address NVA2>|
   |vnet-to-vnet |10.2.0.0/16 |Virtual appliance |\<IP address of NVA2>|

 > [!NOTE]
 > You can replace NVA IP addresses with load balancer IP addresses in the routing if you're deploying a high-availability architecture with multiple NVAs behind the load balancer.

### Components

- [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about). Virtual WAN is a networking service that brings many networking, security, and routing functionalities together to provide a single operational interface. In this case, it simplifies and scales routing to the attached virtual networks and branches.
- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute). ExpressRoute extends on-premises networks into the Microsoft cloud over a private connection.
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network). Virtual Network is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources, like Azure virtual machines (VMs), to communicate with improved security with each other, the internet, and on-premises networks.
- [Virtual WAN hub](/azure/virtual-wan/about-virtual-hub-routing). A virtual hub is a virtual network that Microsoft manages. The hub contains various service endpoints to enable connectivity.
- [Hub virtual network connections](/rest/api/virtualwan/hub-virtual-network-connections/create-or-update#hubvirtualnetworkconnection). The hub virtual network connection resource connects the hub seamlessly to your virtual networks.
- [Static routes](/azure/virtual-wan/about-virtual-hub-routing#static). Static routes provide a mechanism for steering traffic through a next hop IP.
- [Hub route tables](/azure/virtual-wan/about-virtual-hub-routing#hub-route). You can create a virtual hub route and apply the route to the virtual hub route table.
- [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview). By using virtual network peering, you can seamlessly connect two or more [virtual networks](/azure/well-architected/service-guides/virtual-network) in Azure.
- [User-defined routes](/azure/virtual-network/virtual-networks-udr-overview#user-defined). User-defined routes are static routes that override the default Azure system routes or add more routes to a subnet's route table. They're used here to force traffic to the NVAs when necessary.
- Network virtual appliances. Network virtual appliances are marketplace-offered network appliances. In this case, the company deployed Palo Alto's NVA, but any NVA firewall would work here.

### Alternatives

If self-hosting NVAs isn't a requirement, a simpler solution exists where the NVA is hosted in an Azure VWAN secured hub and internal traffic inspection is modified for each virtual network connection. However, this solution doesn't allow you to discriminate between vnet-to-vnet and [vnet-to-cross-premises traffic](/azure/virtual-wan/how-to-routing-policies).

To deploy only a high-security NVA environment, you can follow this model: [Route traffic through an NVA](/azure/virtual-wan/scenario-route-through-nva).

To deploy a custom NVA model that supports both routing traffic to a dedicated firewall for the internet and routing branch traffic over an NVA, see [Route traffic through NVAs by using custom settings](/azure/virtual-wan/scenario-route-through-nvas-custom).

 The previous alternative deploys a high-security environment behind an NVA and offers some capability to deploy a custom environment. But it differs from the use case described in this article in two ways. First, it shows the two models in isolation instead of in combination. Second, it doesn't support VNet-to-VNet traffic in the custom environment (what we call the *Performance-optimized environment* here).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Virtual WAN is a highly available networking service. You can set up more connectivity or paths from the branch to get multiple pathways to the Virtual WAN service. But you don't need anything additional within the VWAN service.

You should set up NVAs in a highly available architecture similar to the one described here: [Deploy highly available NVAs](../guide/nva-ha.yml).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

With NVAs, you can use features like IDPS with Virtual WAN.

In this deployment, routes that cross the Virtual WAN hub to a performance-optimized environment don't pass through the NVA in that environment. This presents a potential problem with cross-regional traffic that's illustrated here:

![Diagram that shows a potential problem with cross-regional traffic.](./_images/performance-security-optimized-vwan-architecture-regions.png)

Traffic across regions between performance-optimized environments doesn't cross the NVA. This is a limitation of directly routing hub traffic to the virtual networks.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Pricing for this architecture depends heavily on the NVAs that you deploy. For a 2-Gbps ER connection and a Virtual WAN hub that processes 10 TB per month, see this [pricing estimate](https://azure.com/e/0bf78de2bf3b45aa961e0dc2f57eb2fe).

You should set up NVAs in a highly available architecture similar to the one described here: [Deploy highly available NVAs](../guide/network-virtual-appliance-high-availability.md).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This solution optimizes performance of the network where necessary. You can modify the routing according to your own requirements, enabling the traffic to the branch to cross the NVA and the traffic between virtual networks to flow freely or to use a single firewall for internet egress.

This architecture is scalable across regions. Consider your requirements when you set up routing labels for grouping routes and branch traffic forwarding between the virtual hubs.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [John Poetzinger](https://www.linkedin.com/in/john-poetzinger-467b9922) | Senior Cloud Solution Architect

## Next steps

- [What is Azure Virtual WAN?](/azure/virtual-wan/virtual-wan-about)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [How to configure virtual hub routing - Azure Virtual WAN](/azure/virtual-wan/how-to-virtual-hub-routing)
- [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway)
- [Azure Virtual WAN and supporting remote work](/azure/virtual-wan/work-remotely-support)

## Related resources

- [Hub-spoke network topology with Azure Virtual WAN](/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture)
- [Choose between virtual network peering and VPN gateways](/azure/architecture/reference-architectures/hybrid-networking/vnet-peering)
