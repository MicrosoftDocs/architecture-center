---
title: Azure Private Link in a Hub-and-Spoke Network
description: Use Azure Private Link to access PaaS services from a hub-and-spoke network. Connect to these services by using a private IP address from your virtual network.
author: ivapplyr
ms.author: ivapplyr
ms.date: 06/24/2025
ms.topic: concept-article
ms.subservice: architecture-guide
categories:
  - networking
  - security
products:
  - azure-expressroute
  - azure-private-link
  - azure-virtual-network
---

# Azure Private Link in a hub-and-spoke network

This article describes how to use Azure Private Link in a hub-and-spoke network topology. The target audience includes network architects and cloud solution architects. This guide outlines how to use Azure private endpoints to privately access platform as a service (PaaS) resources.

This guide doesn't cover virtual network integration, service endpoints, and other solutions for connecting infrastructure as a service (IaaS) components to Azure PaaS resources. For more information about these solutions, see [Integrate Azure services with virtual networks for network isolation][Integrate Azure services with virtual networks for network isolation].

## Azure hub-and-spoke topologies

You can use a hub-and-spoke network topology in Azure to efficiently manage communication services and meet security requirements at scale. For more information, see [Hub-and-spoke network topology][Hub-and-spoke network topology].

A hub-and-spoke architecture provides the following benefits:

- Deploys individual workloads between central IT teams and workload teams
- Saves costs by minimizing redundant resources
- Manages networks efficiently by centralizing services that multiple workloads share
- Overcomes limits associated with a single Azure subscription

The following diagram shows a typical hub-and-spoke topology that you can deploy in Azure.

:::image type="complex" source="./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.svg" alt-text="Architecture diagram that shows a hub virtual network and two spokes. One spoke is an on-premises network. The other is a landing zone virtual network." border="false" lightbox="./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.svg":::
The hub virtual network contains two DNS forwarders. It connects to the on-premises network via a two-sided arrow that represents an ExpressRoute circuit. The on-premises network contains two virtual machines (VMs) and two Domain Name Systems (DNS). The hub virtual network connects to the landing zone virtual network via a two-sided arrow that represents virtual network peering. The landing zone virtual network contains a spoke VM and a private endpoint. The private endpoint connects to storage labeled mystoragewithpl.blob.core.windows.net. The hub virtual network connects to Azure recursive resolvers and private DNS zones via Azure-provided DNS.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/private-link-hub-spoke-network-basic-hub-spoke-diagram.vsdx) of this architecture.*

This architecture is one of two network topology options that Azure supports. This classic reference design uses basic network components like Azure Virtual Network, virtual network peering, and user-defined routes (UDRs). When you use a hub-and-spoke topology, you configure the services, and you must ensure that the network meets security and routing requirements.

[Azure Virtual WAN][What is Virtual WAN?] provides an alternative for deployments at scale. This service uses a simplified network design. Virtual WAN reduces the configuration overhead associated with routing and security.

Private Link supports different options for traditional hub-and-spoke networks and for Virtual WAN networks.

### Private Link

Private Link provides access to services over a private endpoint network interface. A private endpoint uses a private IP address from your virtual network. You can access various services over that private IP address:

- Azure PaaS services
- Customer-owned services that Azure hosts
- Partner services that Azure hosts

Traffic between your virtual network and the service that you access travels across the Azure network backbone. As a result, you no longer access the service over a public endpoint. For more information, see [Private Link][What is Private Link?].

The following diagram shows how on-premises users connect to a virtual network and use Private Link to access PaaS resources.

:::image type="complex" source="./images/private-link-hub-spoke-network-private-link.svg" alt-text="Architecture diagram that shows how Azure Private Link connects a virtual network to PaaS resources." border="false" lightbox="./images/private-link-hub-spoke-network-private-link.svg":::
The diagram has three main sections: a consumer virtual network, a provider virtual network, and a section that includes Azure services. The consumer network connects to on-premises via ExpressRoute private peering. It contains a network security group that denies outbound traffic. It also contains a subnet that includes two private endpoints and computers that point to a private endpoint. The consumer network includes Microsoft Entra tenant A, subscription A, and region A. A dotted arrow that represents Private Link points from the consumer network to the provider network. The provider network contains Private Link and a subnet. Private Link points to a standard load balancer, which distributes traffic to computers in the subnet. The virtual network has a network security group that denies inbound traffic. The provider network includes Microsoft Entra tenant B, subscription B, and region B. A dotted arrow that represents Private Link points from the consumer network to the Azure services. The services in this section include Azure Automation, Azure SQL Database, and many more. Traffic to the provider network and the Azure services is carried over the Microsoft network.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/private-link-hub-spoke-network-private-link.vsdx) of this architecture.*

## Choose the best Private Link deployment configuration

You can deploy private endpoints in either a hub or a spoke. A few factors determine which location works best in each situation. Consider the following factors to determine the best configuration for Azure PaaS services and for customer-owned and partner services that Azure hosts.

#### Determine whether you use Virtual WAN as your network connectivity solution

If you use Virtual WAN, you can only deploy private endpoints on spoke virtual networks that you connect to your virtual hub. You can't deploy resources into your virtual hub or secure hub.

For more information about integrating private endpoints into your network, see the following articles:

- [Use Private Link in Virtual WAN][Use Private Link in Virtual WAN]
- [Configure virtual hub routing][How to configure virtual hub routing]

#### Determine whether you use a network virtual appliance such as Azure Firewall

Traffic to private endpoints uses the Azure network backbone and is encrypted. You might need to log or filter that traffic. You might also want to analyze traffic that flows to private endpoints if you use a firewall in the following areas:

- Across spokes
- Between your hub and spokes
- Between on-premises components and your Azure networks

In this case, deploy private endpoints in your hub in a dedicated subnet. This setup provides the following benefits:

- Simplifies your secure network address translation (SNAT) rule configuration. You can create a single SNAT rule in your network virtual appliance (NVA) for traffic to the dedicated subnet that contains your private endpoints. You can route traffic to other applications without applying SNAT.

- Simplifies your route table configuration. For traffic that flows to private endpoints, you can add a rule to route that traffic through your NVA. You can reuse that rule across all spokes, virtual private network (VPN) gateways, and Azure ExpressRoute gateways.
- Enables you to apply network security group rules for inbound traffic in the subnet that you dedicate to a private endpoint. These rules filter traffic to your resources. They provide a single place to control access to your resources.
- Centralizes management of private endpoints. If you deploy all private endpoints in one place, you can more efficiently manage them in all virtual networks and subscriptions.

Use this configuration when all workloads need access to each PaaS resource that Private Link protects. If your workloads access different PaaS resources, don't deploy private endpoints in a dedicated subnet. Instead, improve security by following the principle of least privilege:

- Place each private endpoint in a separate subnet.
- Only give workloads that use a protected resource access to that resource.

#### Determine whether you use a private endpoint from an on-premises system

If you plan on using private endpoints to access resources from an on-premises system, deploy the endpoints in your hub. This setup provides the following benefits:

- You can use network security groups to control access to your resources.
- You can manage your private endpoints in a centralized location.

If you plan on accessing resources from applications that you deploy in Azure, the following factors apply:

- If only one application needs access to your resources, deploy a private endpoint in that application's spoke.
- If more than one application needs access to your resources, deploy a private endpoint in your hub.

### Flowchart

The following flowchart summarizes options and recommendations. Every customer has a unique environment, so consider your system's requirements when you decide where to place private endpoints.

:::image type="complex" source="./images/private-link-hub-spoke-network-decision-tree.svg" alt-text="Flowchart that guides you through the process of deciding whether to place Private Link on a spoke or in the hub of a hub-and-spoke network." border="false" lightbox="./images/private-link-hub-spoke-network-decision-tree.svg":::
   The top of the flowchart is labeled Start. An arrow points from that box to a box labeled Virtual WAN topology. Two arrows flow out of that box. One labeled yes points to a box labeled spoke. The second arrow is labeled no and points to a box labeled traffic analysis with NVA or Azure Firewall. Two arrows flow out of the traffic analysis box. One labeled yes points to a box labeled hub. The second arrow is labeled No and points to a box labeled private endpoint access from on-premises. Two arrows flow out of the private endpoint box. One labeled yes points to a box labeled hub. The second arrow is labeled no and points to a box labeled single application access. Two arrows flow out of that box. One labeled no points to a box labeled hub. The second arrow is labeled yes and points to a box labeled spoke.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/private-link-hub-spoke-network-decision-tree.vsdx) of this architecture.*

## Considerations

The following factors can affect your private endpoint implementation. They apply to Azure PaaS services and customer-owned and partner services that Azure hosts.

### Networking

When you use private endpoints in a spoke virtual network, the subnet's default route table includes a `/32` route, with a next hop type of `InterfaceEndpoint`.

- If you use a traditional hub-and-spoke topology, you can view this effective route at the network-interface level of your virtual machines (VMs). For more information, see [Diagnose a VM routing problem][Diagnose a virtual machine routing problem - Diagnose by using the Azure portal].

- If you use Virtual WAN, you can view this route in the virtual hub effective routes. For more information, see [View virtual hub effective routes][View virtual hub effective routes].

The `/32` route gets propagated to the following areas:

- Any virtual network peering that you configure
- Any VPN or ExpressRoute connection to an on-premises system

To restrict access from your hub or on-premises system to a private endpoint, use a network security group in the subnet where you deploy the private endpoint. Configure appropriate inbound rules.

### Name resolution

Components in your virtual network associate a private IP address with each private endpoint. Those components can only resolve that private IP address if you use a specific Domain Name System (DNS) setup. If you use a custom DNS solution, use DNS zone groups. Integrate the private endpoint with a centralized Azure private DNS zone, whether you deploy resources in a hub or a spoke. Link the private DNS zone with all virtual networks that need to resolve your private endpoint DNS name.

In this approach, on-premises and Azure DNS clients can resolve the name and access the private IP address. For a reference implementation, see [Private Link and DNS integration at scale][Private Link and DNS integration at scale].

### Costs

- When you use private endpoints across a regional virtual network peering, peering fees don't apply for traffic to and from private endpoints.

- Peering costs apply with other infrastructure resource traffic that flows across a virtual network peering.
- When you deploy private endpoints across different regions, Private Link rates and global peering inbound and outbound rates apply.

For more information, see [Bandwidth pricing][Bandwidth pricing].

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- Jose Angel Fernandez Rodrigues | Senior Specialist GBB

Other contributor:

- [Ivens Applyrs](https://www.linkedin.com/in/ivens-applyrs/) | Product Manager 2

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Private Link availability][Azure Private Link availability]
- [Private endpoints][What is a private endpoint?]
- [Azure Virtual Network][What is Azure Virtual Network?]
- [Azure DNS][What is Azure DNS?]
- [Private Azure DNS zone][What is a private Azure DNS zone]
- [Use Azure Firewall to inspect traffic destined to a private endpoint][Use Azure Firewall to inspect traffic destined to a private endpoint]
- [How network security groups filter network traffic][How network security groups filter network traffic]

## Related resources

- [Baseline highly available zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- [Hub-and-spoke network topology in Azure][Hub-spoke network topology in Azure]

[Azure Private Link availability]: /azure/private-link/availability
[Bandwidth pricing]: https://azure.microsoft.com/pricing/details/bandwidth
[Diagnose a virtual machine routing problem - Diagnose by using the Azure portal]: /azure/virtual-network/diagnose-network-routing-problem#diagnose-using-azure-portal
[How to configure virtual hub routing]: /azure/virtual-wan/how-to-virtual-hub-routing
[How network security groups filter network traffic]: /azure/virtual-network/network-security-group-how-it-works
[Hub-and-spoke network topology]: /azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology
[Hub-spoke network topology in Azure]: ../architecture/hub-spoke.yml
[Integrate Azure services with virtual networks for network isolation]: /azure/virtual-network/vnet-integration-for-azure-services
[Private Link and DNS integration at scale]: /azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale
[SVG version of architecture diagram]: ./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.svg
[SVG version of decision tree]: ./images/private-link-hub-spoke-network-decision-tree.svg
[SVG version of Private Link diagram]: ./images/private-link-hub-spoke-network-private-link.svg
[Use Azure Firewall to inspect traffic destined to a private endpoint]: /azure/private-link/inspect-traffic-with-azure-firewall
[Use Private Link in Virtual WAN]: /azure/virtual-wan/howto-private-link
[View virtual hub effective routes]: /azure/virtual-wan/effective-routes-virtual-hub
[What is Azure DNS?]: /azure/dns/dns-overview
[What is a private endpoint?]: /azure/private-link/private-endpoint-overview
[What is Private Link?]: /azure/private-link/private-link-overview?toc=/azure/virtual-network/toc.json
[What is Azure Virtual Network?]: /azure/virtual-network/virtual-networks-overview
[What is Virtual WAN?]: /azure/virtual-wan/virtual-wan-about
[What is a private Azure DNS zone]: /azure/dns/private-dns-privatednszone
