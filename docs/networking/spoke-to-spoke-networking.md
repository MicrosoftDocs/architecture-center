The most common networking design patterns in Azure involve creating hub and spoke VNet topologies in one or multiple Azure regions, optionally connected to on-premises networks via Azure ExpressRoute or site-to-site VPN tunnels over the public Internet. Most design guides focus on application traffic from users either in internal, on-premises networks or from the Internet to those VNets (what the industry typically designates as North-South traffic, since this is often represented by vertical lines in network diagrams). This guide will focus on different patterns that are available for East-West traffic, that is, communication flows between workloads deployed in Azure VNets, either in the same or in different regions.

There are many scenarios why spoke-to-spoke traffic is important:

- Different tiers of the same application might be in separate VNets, for example DMZ servers in a DMZ VNet talking to application services in an internal VNet.
- Different applications or microservices might need to talk to each other.
- Databases might have to replicate data across regions to guarantee Business Continuity in the case of a disaster event.
- Users could actually be located inside of Azure VNets, for example if using Azure Virtual Desktop.

Making sure that your network design satisfies requirements for East-West traffic is critical to provide performance, scalability and resiliency to your applications running in Azure.

# Different patterns and topologies for inter-spoke communication

There are two main topologies that can be used in Azure multi-VNet designs: traditional [hub and spoke][hubnspoke], and [Virtual WAN][vwan]. The main difference across both design options is that in Virtual WAN the hub VNet and everything inside is managed by Microsoft, while in a traditional hub and spoke environment the hub VNet is managed by the Azure customer. Both environments are examples of hub and spoke architectures, where the workloads run in spoke VNets.

There are two ways of connecting spoke VNets:

1. Over the hub VNet: each spoke VNet has a peering to the hub VNet. Via routing you can send traffic from the spoke to a virtual network appliance in the hub, which will provide network connectivity to other spoke in the same region and to other regions.
2. Directly to each other: additional VNet peerings or VPN tunnels can be created between the spoke VNets to provide direct connectivity without traversing the hub VNet.

# Direct connectivity between spokes

There are multiple options that can be chosen:

- [VNet Peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview): The advantage of direct VNet peerings over the spokes are a lower cost, since fewer VNet peering hops are required, and better performance, because traffic do not need to traverse any network appliance that introduce additional latency or potential bottlenecks. Other scenarios include cross tenant connectivity. However, customers might have requirements around inspecting traffic between spoke VNets that might demand sending traffic through centralized networking devices in the hub VNet.

- [Virtual Network Manager (AVNM)](https://docs.microsoft.com/en-us/azure/virtual-network-manager/concept-connectivity-configuration#hub-and-spoke-topology): In addition to the advantages VNet peering offers, AVNM extends the VNet peering feature to include a management service which allows to manage virtual network environments and peerings at scale. Peering configurations between spokes VNets, in the same network group, are automatically configured bi-directionally. AVNM brings the ability to statically or dynamically add spoke VNets membership to a specific network group, thus automatically creating the peering connection for any new member. Multiple network groups can be created to isolate clusters of spoke VNets from direct connectivity. Each network group provides same region and multi-region support for spoke to spoke connectivity. One disadvantage is that AVNM does not support cross tenant VNet connectivity.

- VNet-to-VNet VPN Tunnels: VPN services can be configured to directly connect spoke VNets using first party [VPN gateways](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-vnet-vnet-resource-manager-portal?toc=/azure/virtual-network/toc.json) or third party VPN NVAs. The advantage of this option is spoke VNets connectivity cross commercial and sovereign clouds within the same cloud provider or connectivity cross cloud providers. Additionally, in the presence of SDWAN NVAs in each spoke VNet, this can facilitate using third party provider's control plane and feature set to manage virtual network connectivity. Another advantage is to meet compliance requirements for encryption of traffic cross virtual networks in the same Azure datacenter which is not already provided by [MACsec encryption](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-faq#is-vnet-peering-traffic-encrypted).

# Using centralized network appliances

There are multiple options that can be chosen:

- [Virtual Network Manager (AVNM)](https://docs.microsoft.com/en-us/azure/virtual-network-manager/concept-connectivity-configuration#hub-and-spoke-topology): AVNM enhances VNet  management through features to manage virtual network environments and peerings at scale. Peering configurations between hub and spokes VNets are automatically configured bi-directionally for network groups. AVNM brings the ability to statically or dynamically add spoke VNets membership to a specific network group, thus automatically creating the peering connection for any new member. Spoke VNets in network groups have the option to use the [hub VPN or ExpressRoute gateways for connectivity](https://docs.microsoft.com/en-us/azure/virtual-network-manager/concept-connectivity-configuration#use-hub-as-a-gateway). A few disadvantage include that AVNM does not support cross tenant VNet connectivity and does not support using the Azure Firewall or other third party NVAs for spoke to spoke connnectivity.
- Virtual WAN hub router: fully-managed by Microsoft, Virtual WAN contains a network appliance that will attract traffic from the spokes, and route it either to other Azure regions or to connections to onprem via ExpressRoute, Site-to-Site or Point-to-Site VPN tunnels. This hub router scales up and down automatically, so customers only need to consider the [Virtual WAN Limits][vwan_limits].
- Azure Firewall: [Azure Firewall][azfw] is a network appliance managed by Microsoft that not only can forward IP packets, but it can also inspect them and apply traffic segmentation policies that you configure. It autoscales too up to the [Azure Firewall Limits][azfw_limits], and it is available both in Virtual WAN and Hub and Spoke topologies. Note that Azure Firewall only provides out-of-the-box multi-region capabilities when used with Virtual WAN, otherwise you need to implement User Defined Routes to achieve cross-regional spoke-to-spoke communication.
- Network Virtual Appliances: if you prefer to use your own network devices to perform routing and network segmentation, you can certainly deploy Network Virtual Appliances either in a Hub and Spoke or in a Virtual WAN topology, see [Deploy highly available NVAs][nva_ha] and [NVAs in Virtual WAN Hub][vwan_nva]

# Using Azure Firewall in multi-region Hub and Spoke

ToDo! (UDRs in each hub)

# Using dedicated Azure Firewalls for East-West traffic

ToDo! (UDRs for RFC1918 to e/w AzFW1, 0/0 to n/s AzFW2)

[vwan]: /azure/virtual-wan/virtual-wan-about
[vwan_limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#virtual-wan-limits
[vwan_nva]: /azure/virtual-wan/about-nva-hub
[hubnspoke]: ../../reference-architectures/hybrid-networking/hub-spoke.yml
[ars]: /azure/route-server/overview
[avnm]: /azure/virtual-network-manager/overview
[azfw]: /azure/firewall/overview
[azfw_limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits
[nva_ha]: /azure/architecture/reference-architectures/dmz/nva-ha
[vm_flows]: /azure/virtual-network/virtual-machine-network-throughput#flow-limits-and-active-connections-recommendations
