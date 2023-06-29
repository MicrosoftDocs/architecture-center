
This article describes how to minimize private address space consumption when you build large networks in Azure. For example, these recommendations are useful if you run out of private IP addresses to assign to Azure Virtual Network because proper address space allocation policies aren't adopted.

## Architecture

The following sections present best practice recommendations for scenarios that have a huge number of IPv4 address requirements and for scenarios that have limited RFC 1918 address space. Each recommendation is collated under the "Best Practices" section.

### Background

Corporate networks typically use address spaces that are included in the private IPv4 address ranges defined by RFC 1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16). In on-premises environments, these ranges provide enough IP addresses to meet the requirements of even the largest networks. As a result, many organizations develop address-management practices that prioritize simple routing configurations and agile processes for IP allocation over efficient utilization of the address space.

In the cloud, large hybrid networks are easy to build, and architectural patterns (microservices, container orchestration platforms, virtual network injection for platform-as-a-service (PaaS) services) consume many IP addresses, so it’s important to revisit those address-management  practices. Treat private IPv4 addresses as a limited resource.

### IP address ranges that Azure Virtual Network supports

In Azure Virtual Network, we recommend that you use the address blocks that are defined by RFC 1918. These address blocks are for general-purpose private networks and are "non-routable" on the public internet.

But you can also use the following ranges. Before you use these ranges in your virtual network, read the IANA documentation to understand the potential implications to your environment:

- The shared address space for Carrier Grade NAT (CGN) that's defined by RFC 6598 (100.64.0.0/10) is treated as private address space in Azure Virtual Network.
- You can use public, internet-routable IP addresses in Azure Virtual Network. You can use public address ranges that aren’t owned by your organization, but this practice is discouraged. When you use public address ranges, resources in the virtual network can’t access internet endpoints that are exposed over the public IP addresses.
- You can use some of the special-purpose address blocks that are defined by IANA, like 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 233.252.0.0/24, 240.0.0.0/4.

You can't use the following IP address ranges in Azure Virtual Network:

- 224.0.0.0/4 (Multicast)
- 255.255.255.255/32 (Broadcast)
- 127.0.0.0/8 (Loopback)
- 169.254.0.0/16 (Link-local)
- 168.63.129.16/32 (Internal DNS)

> [!NOTE]
> The additional ranges mentioned previously aren't likely to provide a long-term solution for organizations that have IPv4 exhaustion issues across the entire RFC 1918 address space. Those organizations should minimize private address space consumption.

### Azure landing zone alignment

The best practices in this article are for scenarios based on the [Azure landing zones reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture). The guidance assumes that:

- A hub-and-spoke topology is used in each region.
- Hub-and-spoke networks that are in different regions are connected.
- Hub-and-spoke networks are connected to on-premises sites via a combination of virtual network peering, ExpressRoute circuits, and site-to-site VPNs.

The best practices are equally applicable to networks that are built on top of Azure Virtual WAN, which follows the same topological pattern that has hub-and-spoke networks in each region.

:::image type="content" source="./media/ipv4-exhaustion-hub-spoke.png" alt-text="Regional hub-and-spoke topology recommended by the Azure landing zone reference architecture." border="false" lightbox="./media/ipv4-exhaustion-hub-spoke.png":::

*Figure 1. Regional hub-and-spoke topology recommended by the Azure landing zone reference architecture. In multi-region scenarios, a hub-and-spoke network is created in each region. Application landing zones are typically assigned a single spoke virtual network, peered to the regional hub that's deployed into the platform landing zone.*

In a scenario that's based on the Azure landing zone reference architecture, applications are deployed in their own landing zones. Each landing zone contains a spoke virtual network that's peered to a regional hub. Spoke virtual networks are an integral part of the corporate network and are assigned routable IPv4 addresses. These addresses are unique across the entire corporate network. So, all architectural components that are deployed in Azure Virtual Network consume IPv4 addresses in the corporate network’s address space even if only a few of them expose endpoints that must be reachable from the entire corporate network. These architectural components can be virtual machines, first-party or third-party network NVAs, or virtual network-injected PaaS services.

In the remainder of this article, an application’s components that must be reachable from the entire corporate network (from outside its own landing zone) are referred to as "front-end components". Application components that don't expose endpoints in the corporate network and only need to be reachable from within their own landing zone are referred to as "back-end components". For example, a web application that exposes an endpoint and a database that doesn't expose any endpoint have one front-end component and one back-end component.

The following sections describe best practices to minimize private address space consumption when you build large networks in Azure. For example, these recommendations are useful if you run out of private IP addresses to assign to Azure Virtual Network because proper address space allocation policies aren't adopted.

## Best practice #1: Non-routable landing zone spoke virtual networks

RFC 1918 carves some IP address blocks out of the IPv4 32-bit address space and declares them to be "non-routable" in the public internet, so that they can be freely reused within multiple private networks for internal communication. This best practice is based on the same principle that applies to private address space. One or more address ranges are carved out of the entire private address space that's used by an organization and declared "non-routable" within that organization’s corporate network, for them to be reused in multiple landing zones. As a result, each landing zone:

- Is assigned a "routable" address space made of one or more address ranges that are centrally managed by the organization and uniquely assigned to a landing zone for communicating with the corporate network. Addresses in the routable space are assigned to front-end components.
- Can freely use the "non-routable" address space, which is the address ranges that the organization has declared to be non-routable in the corporate network. You can use these reserved ranges for internal communication in all landing zones. Addresses in the non-routable space are assigned to back-end components.

In an Azure hub-and-spoke network (customer-managed or based on Virtual WAN), two or more spoke virtual networks can't have overlapping IP address spaces. So non-routable address blocks can't be assigned to a landing zone spoke. But due to the nontransitive nature of virtual network peering, a landing zone spoke virtual network can peer with a "second-level" spoke virtual network with a non-routable address space. The following diagram shows the dual virtual network topology for landing zones:

:::image type="content" source="./media/ipv4-exhaustion-hub-spoke-vnet-peering.png" alt-text="Each application landing zone contains two peered virtual networks, one with routable IP addresses, which hosts front-end components, and one with non-routable IP addresses, which hosts back-end components." border="false" lightbox="./media/ipv4-exhaustion-hub-spoke-vnet-peering.png":::

*Figure 2. Each application landing zone contains two peered virtual networks, one with routable IP addresses, which hosts front-end components, and one with non-routable IP addresses, which hosts back-end components.*

Each application landing zone is composed of two peered virtual networks, referred to as "routable landing zone spoke" and "non-routable landing zone spoke". The routable landing zone spoke peers with the regional hub. The non-routable landing zone spoke peers the routable landing zone spoke. The non-transitive nature of virtual network peering prevents non-routable prefixes from becoming visible to the regional hub and the rest of the corporate network. The "non-routable" address range(s) can't be used in any of the routable virtual networks. Some organizations with fragmented address space that’s already assigned to routable networks find it challenging to identify unused large address blocks and declare them "non-routable". In that case, consider unused addresses that aren’t included in the RFC 1918 address space. The previous diagram provides an example of CGN addresses (RFC 6598) in non-routable spoke virtual networks.

### Migration from single virtual network landing zones

Virtual network peering provides full layer-3 connectivity between two peered virtual networks. Traditional single virtual network landing zones communicate with each other over IP. If application components are deployed in single virtual network landing zones, you can move the components between routable and non-routable spoke virtual networks. The following sections describe two typical migration patterns.

#### Applications that are exposed via layer-7 application delivery controllers

Applications that are exposed via layer-7 application delivery controllers can be moved to the non-routable spoke. The application delivery controller is the only front-end component that must reside in the routable landing zone spoke, as shown in the following diagram.

:::image type="content" source="./media/ipv4-exhaustion-app-gw-l7.png" alt-text="Migration approach from traditional landing zone for applications exposed via layer-7 application delivery controllers." border="false" lightbox="./media/ipv4-exhaustion-app-gw-l7.png":::

*Figure 3. Migration approach from traditional landing zone for applications exposed via layer-7 application delivery controllers.*

##### Applications that are exposed via Azure Load Balancer

If an application exposes its endpoints via an Azure load balancer, the compute instances that are part of the load balancer’s back-end pool must remain in the same virtual network (Azure load balancers only support back-end instances in their own virtual network). The resulting migration guidance is shown in the following diagram.

:::image type="content" source="./media/ipv4-exhaustion-load-balancer-l4.png" alt-text="Migration approach from traditional landing zone for applications exposed via Azure Load Balancer." border="false" lightbox="./media/ipv4-exhaustion-load-balancer-l4.png":::

*Figure 4. Migration approach from traditional landing zone for applications exposed via Azure Load Balancer.*

### Outbound dependencies
Although an application’s back-end components don't need to be reachable (receive inbound connections) from the corporate network, it's common for them to have outbound dependencies: back-end components may need to connect to endpoints outside of their landing zones. Typical examples include DNS resolution, access to application endpoints exposed by other landing zones, access to logging or backup facilities, etc.

Connections initiated by services in non-routable spoke virtual networks must be Source-NAT’ted behind a routable IP address. This requires deploying a NAT-capable NVA(s) in the routable spoke virtual network. Each landing zone must run its own dedicated NAT NVA(s). Two options exist for implementing SNAT in a landing zone: Azure Firewall or third-party NVAs. In both cases, all subnets in the non-routable spoke must be associated to a custom route table, to forward traffic to destinations outside of the landing zone to the SNAT device, as shown in the following diagram. Azure NAT Gateway doesn't support SNAT for destination with private IP address space(RFC 1918), hence it can't be used for this purpose.

:::image type="content" source="./media/ipv4-exhaustion-snat-nva.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Source-NAT NVA(s) must be deployed in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to the SNAT NVA(s)." border="false" lightbox="./media/ipv4-exhaustion-snat-nva.png":::

*Figure 5. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Source-NAT NVA(s) must be deployed in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to the SNAT NVA(s).*

##### SNAT Option 1: Azure Firewall
The following diagram shows the typical landing zone layout when using Azure Firewall for Source-NAT in a traditional Hub-Spoke network topology.

:::image type="content" source="./media/ipv4-exhaustion-snat-azfw.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall." border="false" lightbox="./media/ipv4-exhaustion-snat-azfw.png":::

*Figure 6. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall.*

The following diagram shows the typical landing zone layout when using Azure Firewall for Source-NAT in a Virtual WAN based hub-and-spoke network.

:::image type="content" source="./media/ipv4-exhaustion-snat-azfw-vwan.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke (VWAN Connected). All subnets in the non-routable spoke (No Connection with VWAN) must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall." border="false" lightbox="./media/ipv4-exhaustion-snat-azfw-vwan.png":::

*Figure 7. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke (VWAN Connected). All subnets in the non-routable spoke (No Connection with VWAN) must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall.*

The following design considerations apply:

- Azure Firewall provides High Availability.
- Azure Firewall provides native scalability and 3 different SKUs. As Source-NAT is a non-resource-intensive task, the Basic SKU should be considered first. For landing zones that require large volumes of outbound traffic from the non-routable address space, the Standard SKU can be used.
- Azure Firewall Source-NATs traffic behind the private IP addresses of any one of its instances. Each instance can use all the nonprivileged ports.
- Instructions on how to configure Azure Firewall to Source-NAT all received connections are available in the public documentation.

:::image type="content" source="./media/ipv4-exhaustion-azfw-snat-behavior.png" alt-text="Azure Firewall can be configured to Source-NAT all received connections. This is the required configuration for using Azure Firewall as a NAT device for connections initiated by resources in non-routable spoke virtual networks." border="false" lightbox="./media/ipv4-exhaustion-azfw-snat-behavior.png":::

*Figure 8. Azure Firewall can be configured to Source-NAT all received connections. This is the required configuration for using Azure Firewall as a NAT device for connections initiated by resources in non-routable spoke virtual networks.*

##### SNAT Option 2: Third-party NVAs (Azure Marketplace)
Typical requirements that are best addressed by using third-party NVAs with NAT capabilities include:

- granular control over scale in/scale out
- granular control of the NAT pool
- custom NAT policies, such as the ability to use different NAT addresses depending on the properties of the incoming connection, such as source or destination IP

The following design considerations apply:

- Clusters with at least two NVAs should be deployed for high availability. An Azure load balancer is needed to distribute incoming connections from the non-routable spoke virtual network to the NVAs. An "HA Port" load balancing rule is required, as the cluster is expected to Source-NAT all connections leaving the landing zone, irrespective of the destination port. "HA Port" load balancing rules are only supported by Azure Load Balancer Standard.
- Azure’s network virtualization stack doesn't set any constraints as to how many NICs (one NIC vs. two NICs) the NVAs should use. While this design decision is mainly driven by the specific NVAs being used, single-homed NVAs should be preferred, as they reduce address space consumption in the routable spoke virtual networks.

The following diagram shows the typical landing zone layout when using third-party NVAs in a traditional hub-and-spoke network topology.
:::image type="content" source="./media/ipv4-exhaustion-nva-snat-flow.png" alt-text="When using third-party NVAs, in a traditional hub-spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure load balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required." border="false" lightbox="./media/ipv4-exhaustion-nva-snat-flow.png":::

*Figure 9.  When using third-party NVAs, in a traditional hub-spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure load balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required.*

The following diagram shows the typical landing zone layout when using third-party NVAs in a VWAN based hub-spoke network topology.

:::image type="content" source="./media/ipv4-exhaustion-vwan-nva-snat-flow.png" alt-text="When using third-party NVAs, in a VWAN spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure load balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required." border="false" lightbox="./media/ipv4-exhaustion-vwan-nva-snat-flow.png":::

*Figure 10.  When using third-party NVAs, in a VWAN spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure Load Balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required.*

## Best practice #2: Private Link Services
Private Link is an Azure feature that allows a client in a virtual network to access an application deployed in a different, disconnected virtual network. In the server-side (application) virtual network, a Private Link Service resource is deployed and associated with an application endpoint exposed on the front-end IP address of an internal Azure load balancer (Standard SKU). In the client-side virtual network, a Private Endpoint resource is deployed and associated with the Private Link Service. The Private Endpoint exposes the application endpoint in the client’s virtual networks. Private Link provides, in the physical underlay, the tunneling and NAT-ting logic needed to route traffic between the client- and the server-side. For more information see [What is Azure Private Link?](/azure/private-link/private-link-overview).

Private Link doesn't require a layer-3 connection between client-side and server-side virtual networks. Hence, the two virtual networks can have overlapping IP address spaces. Private Link allows deployment of applications in dedicated, isolated virtual networks, all of which the same address space. The applications are exposed as Private Link Services in the corporate network, which uses a routable address space. In the context of the Azure landing zone reference architecture, the resulting landing zone topology is comprised of:

- An isolated virtual network, whose address space can be freely defined by the application team, that hosts the entire application and the Private Link Service(s) associated to the application’s endpoints.
- A spoke virtual network, directly peered with the regional hub, with a routable address space, that hosts the Private Endpoint(s) associated with the Private Link Service(s).

The landing zone topology enabled by Private Link is shown in the following diagram.

:::image type="content" source="./media/ipv4-exhaustion-private-link.png" alt-text="Landing zone topology when Private Link Services are used to expose applications deployed in isolated virtual networks." border="false" lightbox="./media/ipv4-exhaustion-private-link.png":::

*Figure 11. Landing zone topology using Private Link Services to expose applications deployed in isolated virtual networks.*

### Outbound dependencies

When deploying applications in isolated spoke virtual networks, Private Link Services (PLS) must be used for outbound dependencies. Private Endpoints must be defined in the isolated spoke virtual network and associated with PLS’s in routable virtual networks. The following diagram shows the conceptual approach.

:::image type="content" source="./media/ipv4-exhaustion-private-link-isolated.png" alt-text="Private Link Services can be used for outbound dependencies for applications deployed in isolated virtual networks." border="false" lightbox="./media/ipv4-exhaustion-private-link-isolated.png":::

*Figure 12. Private Link Services can be used for outbound dependencies for applications deployed in isolated virtual networks.*

In real-world, large-scale implementations, the approach shown in Figure 11 may not be applicable:

- If the applications deployed in the isolated virtual network have multiple outbound dependencies, deploying a Private Link Services and a Private Endpoint for each one of them increases complexity and management overhead.
- Endpoints in the routable network that can't be part of an Azure load balancer back-end pool can't be exposed as Private Link Services.

These two limitations can be overcome by deploying a proxy/NAT solution in the routable Spoke and making it accessible from the isolated virtual network using Private Link, as shown in the following diagram.

:::image type="content" source="./media/ipv4-exhaustion-private-link-flow.png" alt-text="A single Private Endpoint/Private Link Service can be used to expose a proxy/NAT solution deployed in the routable network. Port- and Address-Translation rules defined on the NVAs allow a single Private Endpoint in the isolated virtual network to be used for accessing multiple dependencies in the routable network." border="false" lightbox="./media/ipv4-exhaustion-private-link-flow.png":::

*Figure 13. A single Private Endpoint/Private Link Service can be used to expose a proxy/NAT solution deployed in the routable network. Port-Translation and Address-Translation rules defined on the NVAs allow a single Private Endpoint in the isolated virtual network to be used for accessing multiple dependencies in the routable network.*

**Principal authors:**

- [Federico Guerrini](https://www.linkedin.com/in/federico-guerrini-phd-8185954) | EMEA Technical Lead
- [Khush Kaviraj](https://www.linkedin.com/in/khushalkaviraj) | Cloud Solution Architect
- [Jack Tracey](https://www.linkedin.com/in/jacktracey93) | Senior Cloud Solution Architect
  
 *To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Deploy Azure Firewall in a virtual network](/azure/firewall/tutorial-firewall-deploy-portal-policy)
- [Configure SNAT on Azure Firewall](/azure/firewall/snat-private-range)

## Related resources

- [Supported IP addresses in Azure Virtual Network](/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-vnets)
- [Azure Private Link](/azure/private-link/private-link-overview)
