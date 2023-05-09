This example workload shows an Azure Virtual WAN deployment with multiple hubs per region. To improve availability and scalability, each hub peers to geographically dispersed, redundant Azure ExpressRoute circuits. This architecture is for exceptionally large and critical workloads. It supports business units and applications that reside on spoke virtual networks. The spoke virtual networks often have security requirements for internet-to-spoke or spoke-to-spoke connectivity.

## Architecture

:::image type="content" source="./media/massive-scale-architecture.png" alt-text="Diagram that shows a massive-scale Azure Virtual WAN deployment." lightbox="./media/massive-scale-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/massive-scale-architecture.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Traffic from the spoke virtual networks to the internet routes through the network virtual appliance (NVA) firewalls in the security virtual networks that are attached to the same hub as the spoke.

1. The NVAs that are connected to the same hub as the spoke source or destination inspect all traffic between the spoke virtual networks and on-premises. This routing optimizes performance and retains secure traffic between on-premises and Azure.

1. Traffic between spokes that reside on different hubs follow the path *spoke* > *hub* > *hub* > *spoke*. If spoke owners want more inspection, they must implement it within their spokes. This traffic doesn't traverse ExpressRoute connections, and security virtual network NVAs don't inspect it.

1. Spoke-to-spoke traffic on the same hub follows the path *spoke* > *hub* > *spoke*. Security virtual network NVAs don't inspect this traffic.

### Components

- [ExpressRoute](https://azure.microsoft.com/products/expressroute) is a service that provides a private connection between your on-premises environment and Azure resources.
- [Virtual WAN](https://azure.microsoft.com/products/virtual-wan) is a networking service that provides optimized and automated branch to branch connectivity through Azure. It provides transit for networking and routing via ExpressRoute between your on-premises resources and your Azure resources.
  - Custom route tables optimize routing in the solution, so network-to-network traffic can bypass the firewalls. Traffic between networks and on-premises environments remains inspected.
  - Labels simplify the routing by eliminating the need to extensively propagate the routes of individual networks to all route tables.
- [NVAs](https://azure.microsoft.com/solutions/network-appliances) are virtual machines that control routing to manage the flow of network traffic. This architecture uses NVAs. Large organizations with established investment in firewall technology and management often require NVAs.

### Alternatives

An alternative is a hub-and-spoke virtual network model with Azure route servers. You can have better performance than the 50-Gbps limit per hub. This alternative has better performance limits but more complexity. For more information, see [Hub-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke).

As another alternative, ExpressRoute Direct splits off ExpressRoute circuits into local and standard circuits. This service can optimize cost if the necessary bandwidth is sufficient to justify using ExpressRoute Direct.

## Scenario details

This deployment maximizes the scalability of Virtual WAN by using multiple Virtual WAN hubs per region. To find the number of virtual network connections that each hub can support, you subtract the total number of Virtual WAN hubs in your solution from 500. In this solution with four hubs, each hub can support 496 virtual network connections. Performance scales linearly with the number of hubs, so this solution provides exceptional performance and virtual network scaling.

This solution uses an open bow-tie design for ExpressRoute connectivity to the Virtual WAN hub. Each hub has two geographically dispersed ExpressRoute circuits. This design solves many problems and enables the use of NVAs.

ExpressRoute is a preferred path for Virtual WAN because traffic can travel between two spokes that are attached to different hubs, for instance between Spoke VNet1 and Spoke VNet5. If the design is a complete bow tie with a single ExpressRoute circuit that connects to Region1 VWAN Hub1 and Region2 VWAN Hub1, traffic between the spokes starts at Spoke VNet1 and then goes to Region1 VWAN Hub1. It goes down the ExpressRoute circuit and then back up the ExpressRoute path to Region2 VWAN Hub1 and then to Spoke VNet5. The open bow-tie design eliminates that path and enables the spoke-to-hub-to-hub-to-spoke path.

This solution uses different ExpressRoute circuits, so you can use the local ExpressRoute SKU for all their standard operating traffic. The disaster recovery path is rarely used and is a standard circuit SKU, which optimizes the bandwidth cost in the solution.

Traffic can use the NVA in the security virtual network that's attached to the same hub as the virtual network where the source of the traffic resides. During an ExpressRoute failure, the backup path continues to use the local NVA. The backup path simplifies routing, optimizes performance by avoiding inspection in multiple regions, and minimizes the risk of asymmetric routes by limiting complexity.

Custom NVA design allows routing flexibility by using customer-defined route tables in Virtual WAN.

This deployment provides highly redundant ExpressRoute connectivity for each hub. Highly redundant NVAs are attached to each hub.

### Region1 Hub1 route tables

The following tables show the defined routing options for Region1 Hub1.

#### Default (Hub1)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
| 10.0.0.0/16 | SecurityVNet1Connection/NVA internal IP address | Branches | Branches | default, Hub1Default |

#### Spokes (Hub1)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
| 172.16.0.0/16 | SecurityVNet1Connection/NVA internal IP address | Spoke VNet1, Spoke VNet2 |-| AllWorkloadSpokes |
| 0.0.0.0/0 | SecurityVNet1Connection/NVA internal IP address | Spoke VNet1, Spoke VNet2 |-| AllWorkloadSpokes |

#### Security (Hub1)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
|-|-| Security VNet1 |-| Hub1SecuritySpokes, AllSecuritySpokes |

### Region1 Hub2 route tables

The following tables show the defined routing options for Region1 Hub2.

#### Default route table (Hub2)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
| 10.1.0.0/16 | SecurityVNet2Connection/NVA internal IP address | Branches | Branches | default, Hub2Default |

#### Spokes (Hub2)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
| 172.16.0.0/16 | SecurityVNet2Connection/NVA internal IP address | Spoke VNet3, Spoke VNet4 |-| AllWorkloadSpokes |
| 0.0.0.0/0 | SecurityVNet2Connection/NVA internal IP address | Spoke VNet3, Spoke VNet4 |-| AllWorkloadSpokes |

#### Security (Hub2)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
|-|-| Security VNet2 |-| Hub2SecuritySpokes, AllSecuritySpokes |

### Region2 Hub1 route tables

The following tables show the defined routing options for Region2 Hub1.

#### Default (Hub3)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
| 10.2.0.0/16 | SecurityVNet3Connection/NVA internal IP address | Branches | Branches | default, Hub3Default |

#### Spokes (Hub3)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
| 172.16.0.0/16 | SecurityVNet3Connection/NVA internal IP address | Spoke VNet5, Spoke VNet6 |-| AllWorkloadSpokes |
| 0.0.0.0/0 | SecurityVNet3Connection/NVA internal IP address | Spoke VNet5, Spoke VNet6 |-| AllWorkloadSpokes |

#### Security (Hub3)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
|-|-| Security VNet3 |-| Hub3SecuritySpokes, AllSecuritySpokes |

### Region2 Hub2 route tables

The following tables show the defined routing options for Region2 Hub2.

#### Default (Hub4)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
| 10.3.0.0/16 | SecurityVNet4Connection/NVA internal IP address | Branches | Branches | default, Hub4Default |

#### Spokes (Hub4)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
| 172.16.0.0/16 | SecurityVNet4Connection/NVA internal IP address | Spoke VNet7, Spoke VNet8 |-| AllWorkloadSpokes |
| 0.0.0.0/0 | SecurityVNet3Connection/NVA internal IP address | Spoke VNet7, Spoke VNet8 |-| AllWorkloadSpokes |

#### Security (Hub4)

| Destination | Next hop | Associated | Propagated | Labels |
|-------------|----------|------------|------------|--------|
|-|-| Security VNet4 |-| Hub4SecuritySpokes, AllSecuritySpokes |

### Labels

| **Label** | **Propagated virtual network connections** |
| ---------- | ------------------------------- |
| AllWorkloadSpokes | SpokeVNet1Connection, SpokeVNet2Connection, SpokeVNet3Connection, SpokeVNet4Connection, SpokeVNet5Connection, SpokeVNet6Connection, SpokeVNet7Connection, SpokeVNet8Connection, SecurityVNet1Connection, SecurityVNet2Connection, SecurityVNet3Connection, SecurityVNet4Connection |
| AllSecuritySpokes | SpokeVNet1Connection, SpokeVNet2Connection, SpokeVNet3Connection, SpokeVNet4Connection, SpokeVNet5Connection, SpokeVNet6Connection, SpokeVNet7Connection, SpokeVNet8Connection |
| Hub1Default | SecurityVNet1Connection |
| Hub2Default | SecurityVNet2Connection |
| Hub3Default | SecurityVNet3Connection |
| Hub4Default | SecurityVNet4Connection |
| Hub1SecuritySpokes | SpokeVNet1Connection, SpokeVNet2Connection, SecurityVNet1Connection |
| Hub2SecuritySpokes | SpokeVNet3Connection, SpokeVNet4Connection, SecurityVNet2Connection |
| Hub3SecuritySpokes | SpokeVNet5Connection, SpokeVNet6Connection, SecurityVNet3Connection |
| Hub4SecuritySpokes | SpokeVNet7Connection, SpokeVNet8Connection, SecurityVNet4Connection |

This network architecture integrates seamlessly with the Cloud Adoption Framework for Virtual WAN. The Virtual WAN service, ExpressRoute connections, firewalls, and, in this case, security virtual networks  are in the connectivity subscription. The workloads, network security groups, and spoke virtual networks are in the workload or application owner’s separate landing zone subscriptions.

For more information, see [Virtual WAN network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology).

### Potential use cases

This design is applicable to any business of sufficient size and footprint in Azure. The business might use this design to:

- Replace existing multiprotocol label switching (MPLS) or Virtual WAN third-party deployments.
- Connect massive-scale cloud environments to on-premises environments.
- Support various business units and applications with disparate requirements and ownership within one tenant.

## Recommendations

### ExpressRoute

- Customers with massive-scale networks often have previously established connectivity points and require high bandwidth for their circuits. If you migrate from a large-scale MPLS, such as NetBond, and require over 40-Gbps circuit connectivity, you can take advantage of your network infrastructure and establish ExpressRoute Direct. ExpressRoute Direct supports MACsec encryption for high-security workloads.
- For cost optimization, use local ExpressRoute connections to peer the primary ExpressRoute circuit to the regional hub of choice. The backup ExpressRoute circuit should use standard ExpressRoute connections.

### Spoke

- **Internet egress**: Egress internet traffic should route through the local NVA firewall that's connected to the same hub as the source virtual network for that traffic.
- **Internet ingress inspection**: Customers can inspect ingress internet connectivity for the spoke workloads. They can use Azure Application Gateway or Azure Front Door for WAF inspection of traffic into the spokes. Source network address translation (SNAT) is required to avoid routing conflicts with the 0.0.0.0/0 route that's advertised by the Virtual WAN hub.
- **Network security groups**: Use network security groups to customize the security of the application that resides in your spoke virtual network.

### NVA

- **Redundancy**: Follow a best practice architecture for NVA deployment redundancy. Use multiple virtual machines or scale sets and load balancers to provide front end and back end support.

### Virtual WAN hub routing

- Spoke virtual network connections should only propagate to route table labels and not to specific route tables. This practice simplifies approaches that use infrastructure as code.
- Each hub should have its own default hub label to allow and limit propagation of the security virtual network routes to only that hub's default route table. If you use the built-in default label, it propagates across all hubs.
- Each hub should have a route table label for that hub's security virtual network. This practice streamlines infrastructure as code because virtual network connections propagate to the label instead of a specific route table.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This workload optimizes high availability with Virtual WAN, redundant ExpressRoute circuits, and scale sets for NVAs. This combination results in the redundancy that's necessary for highly critical workloads.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This workload provides firewall inspection between Azure and on-premises systems and inspection for outgoing internet traffic from Azure. For inbound internet traffic, consider Azure Front Door or Application Gateway. Use SNAT to avoid routing conflicts.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

For costs of Azure components, see the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Pricing for this solution is based on factors such as:

- The Azure services that are used.
- The ExpressRoute sizing.
- The Virtual WAN sizing and data traffic quantities that each hub processes.
- The NVA pricing.

This workload prioritizes performance and availability over low cost. But using ExpressRoute Local for primary connections optimizes cost because it limits bandwidth expenses. If you want to compromise performance and reliability to optimize cost, you can reduce the number of ExpressRoute circuits and firewalls. When you reduce these resources, it reduces cost but traverses the Virtual WAN hubs with less efficiency when you connect to on-premises or cloud destinations.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

This design is compatible with Terraform and infrastructure as code. It requires the Terraform Azure API provider for deployment because of Virtual WAN lag in feature availability.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This network is highly performant. Even if a connection fails, performance and routing use the best available path.

## Deploy this scenario

The following steps establish the Virtual WAN service, hubs, spoke virtual networks, and ExpressRoute connections. For a tutorial, see [Create an ExpressRoute association to Azure Virtual WAN](/azure/virtual-wan/virtual-wan-expressroute-portal).

1. Create a Virtual WAN service.
1. Deploy multiple hubs and an ExpressRoute gateway in each hub.
1. Deploy the required number of workload spoke virtual networks to support your workload and connect them to the desired hubs.
1. Establish connections between your ExpressRoute circuits and your hubs.
1. Deploy one security virtual network for each hub.
1. Deploy the NVA of your choosing and configure the firewall. Use NVA-specific documentation for this step. To establish the route tables and labels, use the example in [How to configure virtual hub routing: Azure portal - Azure Virtual WAN](/azure/virtual-wan/how-to-virtual-hub-routing).
1. Verify the routing.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ethan Haslett](https://www.linkedin.com/in/ethan-haslett-1502841) | Sr Cloud Solution Architect
- [John Poetzinger](https://www.linkedin.com/in/john-poetzinger-467b9922) | Sr Cloud Solution Architect

Other contributors:

- [Jimmy Avila](https://www.linkedin.com/in/jimmyavila) | Sr Cloud Solution Architect
- [Andrew Delosky](https://www.linkedin.com/in/andrewdelosky) | Principal Cloud Solution Architect
- [Robert Lightner](https://www.linkedin.com/in/robert-lightner) | Sr Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [About virtual hub routing](/azure/virtual-wan/about-virtual-hub-routing)
- [Route traffic through NVAs by using custom settings](/azure/virtual-wan/scenario-route-through-nvas-custom)
- [About ExpressRoute connections in Azure Virtual WAN](/azure/virtual-wan/virtual-wan-expressroute-about)
- [What is Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about)

## Related resources

- [Hub-spoke network topology with Azure Virtual WAN](/azure/architecture/networking/hub-spoke-vwan-architecture)
- [Migrate to Azure Virtual WAN](/azure/virtual-wan/migrate-from-hub-spoke-topology)
- [Virtual WAN architecture optimized for department-specific requirements](/azure/architecture/example-scenario/infrastructure/performance-security-optimized-vwan)
- [Virtual WAN network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology?toc=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
