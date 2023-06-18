
This article describes architectural guide for minimizing private address space consumption when building large networks in Azure. They apply to customers that have run out of private IP addresses to assign to Azure VNets, or expect to face that challenge in the short term if proper address space allocation policies aren't adopted.

## Architecture

The following sections present best practice recommendations and options for customers with huge number of IPv4 address requirements or the ones who are running out of RFC 1918 address space. Each recommendation is collated under the "Best Practices" section.

#### Background
Corporate networks typically use address spaces included in the private IPv4 address ranges defined by RFC 1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16). In on-premises environments, these ranges provide enough IP addresses to meet the requirements of even the largest networks. As a result, many organizations have developed address management practices that prioritize simple routing configurations and agile processes for IP allocation over efficient utilization of the address space. In the cloud, the ease with which large hybrid networks can be built, as well as the emergence of architectural patterns (microservices, container orchestration platforms, VNet injection for PaaS services) that consume many IP addresses, require revisiting those practices. Private IPv4 addresses must be treated as a limited resource.

#### IP address ranges supported by Azure Virtual Networks
Microsoft recommends using the address blocks defined by RFC 1918 in Azure VNets. These blocks have been officially allocated as address space for general-purpose private networks and – as such - declared to be "non routable" on the public internet. However, additional ranges may be used. More specifically:

-	The Shared Address Space for Carrier-Grade NAT defined by RFC 6598 (100.64.0.0/10) is treated as private Address Space in Azure VNets.
-	Azure doesn't prevent using public, internet-routable IP addresses in Azure VNets. When applied to public address ranges not owned by the same organization that owns the VNet, this practice ("address squatting") is discouraged. The obvious side effect is that it prevents resources in the VNet from accessing internet endpoints that may be legitimately exposed over the squatted IP addresses.
-	Azure doesn't prevent using some of the  special-purpose address blocks defined by IANA (192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 233.252.0.0/24, 240.0.0.0/4)

Customers that want to use these address blocks in their VNets should refer to the official IANA documentation to understand the potential implications for their environment.

The following IP address ranges can't be used in Azure VNets:
-	224.0.0.0/4 (Multicast)
-	255.255.255.255/32 (Broadcast)
-	127.0.0.0/8 (Loopback)
-	169.254.0.0/16 (Link-local)
-	168.63.129.16/32 (Internal DNS)

It should be noted that, for organizations that face IPv4 exhaustion issues across the entire RFC 1918 address space, the additional ranges mentioned above aren't likely to provide a long-term solution. Such organizations are encouraged to consider the best practices for minimizing private address space consumption covered in the next sections.

#### ALZ Alignment
The best practices covered in this article target the [Azure Landing Zones (ALZ) reference architecture](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture). As such, the article assumes that the hub and spoke topology is used in each region, and that hub and spoke networks in different regions are connected with each other and to on-premises sites using a proper combination of VNet peering, Expressroute circuits, site-to-site VPNs. The best practices are equally applicable to networks built on top of Virtual WAN, which follow the same topological pattern (hub and spoke networks in each region).

:::image type="content" source="./media/ipv4-exhaustion-hub-spoke.png" alt-text="Regional hub and spoke topology recommended by the ALZ reference architecture." border="false" lightbox="./media/ipv4-exhaustion-hub-spoke.png":::

*Figure 1. Regional hub and spoke topology recommended by the ALZ reference architecture. In multi-region scenarios, a hub and spoke network is created in each region. Application landing zones are typically assigned a single spoke VNet, peered to the regional hub.*

In the ALZ reference architecture, applications are deployed in their own landing zones, each one containing a spoke VNet, peered to a regional hub. Spoke VNets are assumed to be an integral part of the corporate network and are assigned routable (= unique across the entire corporate network) IPv4 addresses. As such, all architectural components that are deployed in Azure VNets (virtual machines, first party or third party network NVAs, VNet-injected PaaS services, etc) consume IPv4 addresses in the corporate network’s address space, even if only a few of them expose endpoints that must be reachable from the entire corporate network.

In the remainder of this article, we'll refer to an application’s components that must be reachable from the entire corporate network (from outside its own landing zone) as "frontend components". Application components that don't expose endpoints in the corporate network and only need to be reachable from within their own landing zone will be referred to as "backend components".

The following sections describe best practices for minimizing private address space consumption when building large networks in Azure. These practices apply to customers that have run out of private IP addresses to assign to Azure VNets, or expect to face that challenge in the short term if proper address space allocation policies aren't adopted.

## Best practice #1: Non-routable LZ spoke VNets
RFC 1918 carves some IP address blocks out of the IPv4 32-bit address space and declares them to be "non routable" in the public internet, so that they can be freely reused within multiple private networks for internal communication. The best practice presented in this section is based on the same principle applied to private address space. One or more address ranges are carved out of the entire private address space used by an organization and declared "non-routable" within that organization’s corporate network, for them to be reused in multiple landing zones. As a result, each landing zone:

- Is assigned a "routable" address space comprised of one or more address ranges centrally managed by the organization and uniquely assigned to a landing zone for communicating with the corporate network. Addresses in the routable space are assigned to frontend components.
- Can freely use the "non-routable" address space, which is the address ranges that the organization has declared to be non-routable in the corporate network. These reserved ranges can be used in all landing zones for internal communication. Addresses in the non-routable space are assigned to backend components.

In an Azure hub and spoke network (irrespective of the implementation: Customer-managed or based on Virtual WAN) it isn't possible for two (or more) spoke VNets to have overlapping IP address spaces. Therefore, non-routable address blocks can't be assigned to an LZ spoke. However, due to the nontransitive nature of VNet peering, an LZ spoke VNet can peer with a "second-level" spoke VNet with a non-routable address space, which suggests the dual-VNet topology for landing zones shown in the following figure:

:::image type="content" source="./media/ipv4-exhaustion-hub-spoke-vnet-peering.png" alt-text="Each application landing zone contains two peered VNets, one with routable IP addresses, which hosts frontend components, and one with non-routable IP addresses, which hosts backend components." border="false" lightbox="./media/ipv4-exhaustion-hub-spoke-vnet-peering.png":::

*Figure 2. Each application landing zone contains two peered VNets, one with routable IP addresses, which hosts frontend components, and one with non-routable IP addresses, which hosts backend components.*

Each landing zone is composed of two peered VNets, referred to as "routable LZ Spoke" and "non-routable LZ Spoke". The routable LZ spoke peers with the regional hub. The non-routable LZ spoke peers the routable LZ spoke. The non-transitive nature of VNet peering prevents non-routable prefixes from becoming visible to the regional hub (and the rest of the corporate network). It should be noted that the address range(s) declared "non-routable" can't be used in any of the routable VNets. Some organizations with fragmented address space already assigned to routable networks may find it challenging to identify reasonably large address blocks that are still unused and declare them "non-routable". Unused addresses not included in the RFC 1918 address space may be considered in this case. Figure 2 provides an example of using CG-NAT addresses (RFC 6598) in non-routable spoke VNets.

### Migration from single-VNet landing zones
VNet peering provides full layer-3 connectivity between two peered VNets. Therefore, application components deployed in traditional ALZ single-VNet landing zones that communicate with each other over IP can be freely moved between routable and non-routable spoke VNets in a landing zone. This section covers two typical migration patterns.

##### Applications exposed via layer-7 application delivery controllers
Applications that are exposed via layer-7 application delivery controllers can be moved to the non-routable spoke. The application delivery controller itself is the only frontend component that must reside in the routable LZ spoke, as shown in the picture below.

:::image type="content" source="./media/ipv4-exhaustion-app-gw-l7.png" alt-text="Migration approach from traditional landing zone for applications exposed via layer-7 application delivery controllers." border="false" lightbox="./media/ipv4-exhaustion-app-gw-l7.png":::

*Figure 3. Migration approach from traditional landing zone for applications exposed via layer-7 application delivery controllers.*

##### Applications exposed via Azure Load Balancer
If an application exposes its endpoints via an Azure Load Balancer, the compute instances that are part of the load balancer’s backend pool must remain in the same VNet (Azure Load Balancers only support backend instances in their own VNet). The resulting migration guidance is shown in the picture below.

:::image type="content" source="./media/ipv4-exhaustion-load-balancer-l4.png" alt-text="Migration approach from traditional landing zone for applications exposed via Azure Load Balancers." border="false" lightbox="./media/ipv4-exhaustion-load-balancer-l4.png":::

*Figure 4. Migration approach from traditional landing zone for applications exposed via Azure Load Balancers.*

### Outbound dependencies
Although an application’s backend components don't need to be reachable (receive inbound connections) from the corporate network, it's common for them to have outbound dependencies: Backend components may need to connect to endpoints outside of their landing zones. Typical examples include DNS resolution, access to application endpoints exposed by other landing zones, access to logging or backup facilities, etc.
Connections initiated by services in non-routable spoke VNets must be Source-NAT’ted behind a routable IP address. This requires deploying a NAT-capable NVA(s) in the routable spoke VNet. Each landing zone must run its own dedicated NAT NVA(s). Two options exist for implementing SNAT in a landing zone: Azure Firewall or third party NVAs. In both cases, all subnets in the non-routable spoke must be associated to a custom route table, to forward traffic to destinations outside of the landing zone to the SNAT device, as shown in the diagram below. Azure NAT Gateway doesn't support SNAT for destination with private IP address space(RFC 1918), hence it can't be used for this purpose.

:::image type="content" source="./media/ipv4-exhaustion-snat-nva.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Source-NAT NVA(s) must be deployed in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to the SNAT NVA(s)." border="false" lightbox="./media/ipv4-exhaustion-snat-nva.png":::

*Figure 5. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Source-NAT NVA(s) must be deployed in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to the SNAT NVA(s).*

##### SNAT Option 1: Azure Firewall
The diagram below shows the typical landing zone layout when using Azure Firewall for Source-NAT in a traditional Hub-Spoke network topology.

:::image type="content" source="./media/ipv4-exhaustion-snat-azfw.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall." border="false" lightbox="./media/ipv4-exhaustion-snat-azfw.png":::

*Figure 6. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke. All subnets in the non-routable spoke must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall.*

The diagram below shows the typical landing zone layout when using Azure Firewall for Source-NAT in a hub and spoke network.

:::image type="content" source="./media/ipv4-exhaustion-snat-azfw-vwan.png" alt-text="To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke (VWAN Connected). All subnets in the non-routable spoke (No Connection with VWAN) must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall." border="false" lightbox="./media/ipv4-exhaustion-snat-azfw-vwan.png":::

*Figure 7. To enable resources in the non-routable spoke to access routable IP addresses outside their landing zone, Azure Firewall must be deployed with ‘Perform Source NAT’ as ‘Always’ in each landing zone’s routable spoke (VWAN Connected). All subnets in the non-routable spoke (No Connection with VWAN) must be associated with a custom route table to send traffic to destinations outside the landing zone to Azure Firewall.*

The following design considerations apply:

-	Azure Firewall provides HA.
-	Azure Firewall provides native scalability. As Source-NAT is a non-resource-intensive task, the Basic SKU should be considered first. For landing zones that require large volumes of outbound traffic from the non-routable address space, the Standard SKU can be used.
-	Azure Firewall Source-NATs traffic behind the private IP addresses of any one of its instances. Each instance can use all the nonprivileged ports.
-	Instructions on how to configure Azure Firewall to Source-NAT all received connections are available in the public documentation.

:::image type="content" source="./media/ipv4-exhaustion-azfw-snat-behavior.png" alt-text="Azure Firewall can be configured to Source-NAT all received connections. This is the required configuration for using Azure Firewall as a NAT device for connections initiated by resources in non-routable spoke VNets." border="false" lightbox="./media/ipv4-exhaustion-azfw-snat-behavior.png":::

*Figure 8. Azure Firewall can be configured to Source-NAT all received connections. This is the required configuration for using Azure Firewall as a NAT device for connections initiated by resources in non-routable spoke VNets.*

##### SNAT Option 2: 3rd Party NVAs (Azure Marketplace)
Typical requirements that are best addressed by using third party NVAs with NAT capabilities include:

- granular control over scale in/scale out
- granular control of the NAT pool
- custom NAT policies, such as the ability to use different NAT addresses depending on the properties of the incoming connection, such as source or destination IP 
 
The following design considerations apply:

-	Clusters with at least two NVAs should be deployed for high availability. An Azure Load Balancer is needed to distribute incoming connections from the non-routable spoke VNet to the NVAs. An "HA Port" load balancing rule is required, as the cluster is expected to Source-NAT all connections leaving the landing zone, irrespective of the destination port. “HA Port" load balancing rules are only supported by Azure Load Balancer Standard.
-	Azure’s network virtualization stack doesn't set any constraints as to how many NICs (one NIC vs. two NICs) the NVAs should use. While this design decision is mainly driven by the specific NVAs being used, single-homed NVAs should be preferred, as they reduce address space consumption in the routable spoke VNets.
The diagram below shows the typical landing zone layout when using third party NVAs in a traditional hub and spoke network topology.

The diagram below shows the typical landing zone layout when using third party NVAs in a VWAN based hub-spoke network topology.

:::image type="content" source="./media/ipv4-exhaustion-nva-snat-flow.png" alt-text="When using third party NVAs, in a VWAN spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure Load Balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required." border="false" lightbox="./media/ipv4-exhaustion-nva-snat-flow.png":::

*Figure 9.  When using third party NVAs, in a VWAN spoke, to provide Source-NAT for non-routable spokes, multiple instances must be deployed behind an Azure Load Balancer in order to guarantee high availability. Azure Load Balancer Standard SKU is required.*

## Best practice #2: Private Link Services
Private Link is an Azure feature that allows a client in a VNet to consume an application deployed in a different, disconnected VNet. In the server-side (application) VNet, a Private Link Service resource is deployed and associated with an application endpoint exposed on the frontend IP address of an Internal Azure Load Balancer (Standard SKU). In the client-side VNet, a Private Endpoint resource is deployed and associated with the Private Link Service. The Private Endpoint exposes the application endpoint in the client’s VNets. Private Link provides, in the physical underlay, the tunneling and NAT-ting logic needed to route traffic between the client- and the server-side. More information about Azure Private Link is available in the public documentation.

Private Link doesn't require any layer-3 connection between client- and server-side VNets. Hence, the two VNets can have overlapping IP address spaces. Private Link allows deploying applications in dedicated, isolated VNets, all of them using the same address space, and exposed as Private Link Services in the corporate network, which uses a routable address space. In the context of the ALZ reference architecture, the resulting landing zone topology is comprised of:

-	An isolated VNet, whose address space can be freely defined by the application team, that hosts the entire application and the Private Link Service(s) associated to the application’s endpoints.
-	A spoke VNet, directly peered with the regional hub, with a routable address space, that hosts the Private Endpoint(s) associated with the Private Link Service(s).
The landing zone topology enabled by Private Link is shown in the diagram below.

:::image type="content" source="./media/ipv4-exhaustion-private-link.png" alt-text="Landing zone topology when Private Link Services are used to expose applications deployed in isolated VNets." border="false" lightbox="./media/ipv4-exhaustion-private-link.png":::

*Figure 10. Landing zone topology when Private Link Services are used to expose applications deployed in isolated VNets.*

### Outbound dependencies
When deploying applications in isolated spoke VNets, Private Link Services (PLS) must be used for outbound dependencies. Private Endpoints must be defined in the isolated spoke VNet and associated with PLS’s in routable VNets. The diagram below shows the conceptual approach.

:::image type="content" source="./media/ipv4-exhaustion-private-link-isolated.png" alt-text="Private Link Services can be used for outbound dependencies for applications deployed in isolated VNets." border="false" lightbox="./media/ipv4-exhaustion-private-link-isolated.png":::

*Figure 11. Private Link Services can be used for outbound dependencies for applications deployed in isolated VNets.*

In real-world, large-scale implementations, the approach shown in Figure 11 may not be applicable:

-	If the applications deployed in the isolated VNet have multiple outbound dependencies, deploying a Private Link Services and a Private Endpoint for each one of them increases complexity and management overhead.
-	Endpoints in the routable network that can't be part of an Azure Load Balancer Backend Pool can't be exposed as Private Link Services.

These two limitations can be overcome by deploying a proxy/NAT solution in the routable Spoke and making it accessible from the isolated VNet using Private Link, as shown in the figure below.

:::image type="content" source="./media/ipv4-exhaustion-private-link-flow.png" alt-text="A single Private Endpoint/Private Link Service can be used to expose a proxy/NAT solution deployed in the routable network. Port- and Address-Translation rules defined on the NVAs allow a single Private Endpoint in the isolated VNet to be used for accessing multiple dependencies in the routable network." border="false" lightbox="./media/ipv4-exhaustion-private-link-flow.png":::

*Figure 12. A single Private Endpoint/Private Link Service can be used to expose a proxy/NAT solution deployed in the routable network. Port- and Address-Translation rules defined on the NVAs allow a single Private Endpoint in the isolated VNet to be used for accessing multiple dependencies in the routable network.*

## Next steps
- [Deploy Azure Firewall in a Virtual Network](/azure/firewall/tutorial-firewall-deploy-portal-policy)
- [Configure SNAT on Azure Firewall](/azure/firewall/snat-private-range)

## Related resources
- [Supported IP addresses in Azure Virtual Networks](/azure/virtual-network/virtual-networks-faq#what-address-ranges-can-i-use-in-my-vnets)
- [Azure Private Link](/azure/private-link/private-link-overview)

