This article provides guidelines for using Azure Private Link in a hub-and-spoke network topology. The target audience includes network architects and cloud solution architects. Specifically, this guide discusses how to use Azure Private Endpoint to privately access platform as a service (PaaS) resources.

This guide doesn't cover virtual network integration, service endpoints, and other solutions for connecting infrastructure as a service (IaaS) components to Azure PaaS resources. For more information on these solutions, see [Integrate Azure services with virtual networks for network isolation][Integrate Azure services with virtual networks for network isolation].

## Overview

The following sections provide general information on Private Link and its environment.

### Azure hub-and-spoke topologies

Hub and spoke is a network topology that you can use in Azure. This topology works well for efficiently managing communication services and meeting security requirements at scale. For more information about hub-and-spoke networking models, see [Hub-and-spoke network topology][Hub-and-spoke network topology].

By using a hub-and-spoke architecture, you can take advantage of these benefits:

- Deploying individual workloads between central IT teams and workload teams
- Saving costs by minimizing redundant resources
- Managing networks efficiently by centralizing services that multiple workloads share
- Overcoming limits associated with single Azure subscriptions

This diagram shows a typical hub-and-spoke topology that you can deploy in Azure:

:::image type="complex" source="./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.png" alt-text="Architecture diagram showing a hub virtual network and two spokes. One spoke is an on-premises network. The other is a landing zone virtual network." border="false":::
   On the left, the diagram contains a dotted box labeled On-premises network. It contains icons for virtual machines and domain name servers. A bi-directional arrow connects that box to a dotted box on the right labeled Hub virtual network. An icon above that arrow is labeled Azure ExpressRoute. The hub box contains icons for D N S forwarders. Arrows point away from the hub box toward icons for private D N S zones. A bi-directional arrow connects the hub box to a box below it labeled Landing zone virtual network. To the right of the arrow, an icon is labeled Virtual network peering. The landing zone box contains icons for a virtual machine and a private endpoint. An arrow points from the private endpoint to a storage icon that's outside the landing zone box.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/private-link-hub-spoke-diagrams.pptx) of this architecture.*

This architecture is one of two options for network topology that Azure supports. This classic reference design uses basic network components like Azure Virtual Network, virtual network peering, and user-defined routes (UDRs). When you use hub and spoke, you're responsible for configuring the services. You also need to ensure that the network meets security and routing requirements.

[Azure Virtual WAN][What is Azure Virtual WAN?] provides an alternative for deployments at scale. This service uses a simplified network design. Virtual WAN also reduces the configuration overhead associated with routing and security.

Private Link supports different options for traditional hub-and-spoke networks and for Virtual WAN networks.

### Private Link

Private Link provides access to services over the Private Endpoint network interface. Private Endpoint uses a private IP address from your virtual network. You can access various services over that private IP address:

- Azure PaaS services
- Customer-owned services that Azure hosts
- Partner services that Azure hosts

Traffic between your virtual network and the service that you're accessing travels across the Azure network backbone. As a result, you no longer access the service over a public endpoint. For more information, see [What is Azure Private Link?][What is Azure Private Link?].

The following diagram shows how on-premises users connect to a virtual network and use Private Link to access PaaS resources:

:::image type="complex" source="./images/private-link-hub-spoke-network-private-link.png" alt-text="Architecture diagram showing how Azure Private Link connects a virtual network to PaaS resources." border="false":::
   The diagram contains a dotted box on the left labeled Consumer network. An icon sits on its border and is labeled Azure ExpressRoute. Outside the box on the left are icons for on-premises users and a private peering. Inside the box is a smaller dotted box labeled Subnet that contains icons for computers and private endpoints. The smaller box's border contains an icon for a network security group. Two dotted arrows flow out of the inner box. They also pass through the outer box's border. One points to a dotted box on the right that's filled with icons for Azure services. The other arrow points to a dotted box on the right labeled Provider network. The provider network box contains a smaller dotted box and an icon for Azure Private Link. The smaller dotted box contains icons for computers. Its border contains two icons: one for a load balancer and one for a network security group.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/private-link-hub-spoke-diagrams.pptx) of this architecture.*

## Decision tree for Private Link deployment

You can deploy private endpoints in either a hub or a spoke. A few factors determine which location works best in each situation. The factors are relevant for Azure PaaS services and for customer-owned and partner services that Azure hosts.

### Questions to consider

Use the following questions to determine the best configuration for your environment:

#### Is Virtual WAN your network connectivity solution?

If you use Virtual WAN, you can only deploy private endpoints on spoke virtual networks that you connect to your virtual hub. You can't deploy resources into your virtual hub or secure hub.

For more information on integrating Private Endpoint into your network, see these articles:

- [Use Private Link in Virtual WAN][Use Private Link in Virtual WAN]
- [How to configure virtual hub routing][How to configure virtual hub routing]

#### Do you use a network virtual appliance (NVA) such as Azure Firewall?

Traffic to Private Endpoint uses the Azure network backbone and is encrypted. You might need to log or filter that traffic. You might also want to use a firewall to analyze traffic flowing to Private Endpoint if you use a firewall in any of these areas:

- Across spokes
- Between your hub and spokes
- Between on-premises components and your Azure networks

In this case, deploy private endpoints in your hub in a dedicated subnet. This arrangement:

- Simplifies your secure network address translation (SNAT) rule configuration. You can create a single SNAT rule in your NVA for traffic to the dedicated subnet that contains your private endpoints. You can route traffic to other applications without applying SNAT.
- Simplifies your route table configuration. For traffic that's flowing to private endpoints, you can add a rule to route that traffic through your NVA. You can reuse that rule across all your spokes, virtual private network (VPN) gateways, and Azure ExpressRoute gateways.
- Makes it possible to apply network security group rules for inbound traffic in the subnet that you dedicate to Private Endpoint. These rules filter traffic to your resources. They provide a single place for controlling access to your resources.
- Centralizes management of private endpoints. If you deploy all private endpoints in one place, you can more efficiently manage them in all your virtual networks and subscriptions.

When all your workloads need access to each PaaS resource that you're protecting with Private Link, this configuration is appropriate. But if your workloads access different PaaS resources, don't deploy private endpoints in a dedicated subnet. Instead, improve security by following the principle of least privilege:

- Place each private endpoint in a separate subnet.
- Only give workloads that use a protected resource access to that resource.

#### Do you use Private Endpoint from an on-premises system?

If you plan on using private endpoints to access resources from an on-premises system, deploy the endpoints in your hub. With this arrangement, you can take advantage of some of the benefits that the previous section describes:

- Using network security groups to control access to your resources
- Managing your private endpoints in a centralized location

If you're planning on accessing resources from applications that you've deployed in Azure, the situation's different:

- If only one application needs access to your resources, deploy Private Endpoint in that application's spoke.
- If more than one application needs access to your resources, deploy Private Endpoint in your hub.

### Flowchart

The following flowchart summarizes the various options and recommendations. Since every customer has a unique environment, consider your system's requirements when deciding where to place private endpoints.

:::image type="complex" source="./images/private-link-hub-spoke-network-decision-tree.png" alt-text="Flowchart that guides users through the process of deciding whether to place Azure Private Link on a spoke or in the hub of a hub-and-spoke network." border="false":::
   At the top of the flowchart is a green box labeled Start. An arrow points from that box to a blue box labeled Azure Virtual W A N topology. Two arrows flow out of that box. One labeled Yes points to an orange box labeled Spoke. The second arrow is labeled No. It points to a blue box labeled Traffic analysis with N V A or Azure Firewall. Two arrows also flow out of the traffic analysis box. One labeled Yes points to an orange box labeled Hub. The second arrow is labeled No. It points to a blue box labeled Private Endpoint access from on-premises. Two arrows flow out of the Private Endpoint box. One labeled Yes points to the orange box labeled Hub. The second arrow is labeled No. It points to a blue box labeled Single application access. Two arrows flow out of that box. One labeled No points to the orange box labeled Hub. The second arrow is labeled Yes. It points to the orange box labeled Spoke.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/private-link-hub-spoke-diagrams.pptx) of this architecture.*

## Considerations

A few factors can affect your Private Endpoint implementation. They apply to Azure PaaS services and customer-owned and partner services that Azure hosts. Consider these points when you deploy Private Endpoint:

### Networking

When you use Private Endpoint in a spoke virtual network, the subnet's default route table includes a `/32` route with a next hop type of `InterfaceEndpoint`.

- If you use a traditional hub-and-spoke topology:

  - You can see this effective route at the network-interface level of your virtual machines.
  - For more information, see [Diagnose a virtual machine routing problem][Diagnose a virtual machine routing problem - Diagnose using Azure portal].

- If you use Virtual WAN:

  - You can see this route in the virtual hub effective routes.
  - For more information, see [View virtual hub effective routes][View virtual hub effective routes].

The `/32` route gets propagated to these areas:

- Any virtual network peering that you've configured
- Any VPN or ExpressRoute connection to an on-premises system

To restrict access from your hub or on-premises system to Private Endpoint, use a network security group in the subnet where you've deployed Private Endpoint. Configure appropriate inbound rules.

### Name resolution

Components in your virtual network associate a private IP address with each private endpoint. Those components can only resolve that private IP address if you use a specific Domain Name System (DNS) setup. If you use a custom DNS solution, it's best to use DNS zone groups. Integrate Private Endpoint with a centralized Azure private DNS zone. It doesn't matter whether you've deployed resources in a hub or a spoke. Link the private DNS zone with all virtual networks that need to resolve your Private Endpoint DNS name.

With this approach, on-premises and Azure DNS clients can resolve the name and access the private IP address. For a reference implementation, see [Private Link and DNS integration at scale][Private Link and DNS integration at scale].

### Costs

- When you use Private Endpoint across a regional virtual network peering, you're not charged peering fees for traffic to and from Private Endpoint.
- Peering costs still apply with other infrastructure resource traffic that flows across a virtual network peering.
- If you deploy private endpoints across different regions, Private Link rates and global peering inbound and outbound rates apply.

For more information, see [Bandwidth pricing][Bandwidth pricing].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - Jose Angel Fernandez Rodrigues | Senior Specialist GBB

Other contributor:

 - [Ivens Applyrs](https://www.linkedin.com/in/ivens-applyrs/) | Product Manager 2
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Hub-spoke network topology in Azure][Hub-spoke network topology in Azure]
- [Azure Private Link availability][Azure Private Link availability]
- [What is Azure Private Endpoint?][What is Azure Private Endpoint?]
- [What is Azure Virtual Network?][What is Azure Virtual Network?]
- [What is Azure DNS?][What is Azure DNS?]
- [What is a private Azure DNS zone?][What is a private Azure DNS zone]
- [Use Azure Firewall to inspect traffic destined to a private endpoint][Use Azure Firewall to inspect traffic destined to a private endpoint]
- [How network security groups filter network traffic][How network security groups filter network traffic]

## Related resources

- [Serverless event stream processing in a VNet with private endpoints][Serverless event stream processing in a VNet with private endpoints]
- [Secure your Microsoft Teams channel bot and web app behind a firewall][Securing your Microsoft Teams channel bot and web app behind a firewall]
- [Web app private connectivity to Azure SQL database][Web app private connectivity to Azure SQL database]
- [Multi-region web app with private connectivity to database][Multi-region web app with private connectivity to database]

[Azure Private Link availability]: /azure/private-link/availability
[Bandwidth pricing]: https://azure.microsoft.com/pricing/details/bandwidth
[Diagnose a virtual machine routing problem - Diagnose using Azure portal]: /azure/virtual-network/diagnose-network-routing-problem#diagnose-using-azure-portal
[How to configure virtual hub routing]: /azure/virtual-wan/how-to-virtual-hub-routing
[How network security groups filter network traffic]: /azure/virtual-network/network-security-group-how-it-works
[Hub-and-spoke network topology]: /azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology
[Hub-spoke network topology in Azure]: ../../reference-architectures/hybrid-networking/hub-spoke.yml
[Integrate Azure services with virtual networks for network isolation]: /azure/virtual-network/vnet-integration-for-azure-services
[Multi-region web app with private connectivity to database]: ../../example-scenario/sql-failover/app-service-private-sql-multi-region.yml
[Private Link and DNS integration at scale]: /azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale
[Securing your Microsoft Teams channel bot and web app behind a firewall]: ../../example-scenario/teams/securing-bot-teams-channel.yml
[Serverless event stream processing in a VNet with private endpoints]: ../../solution-ideas/articles/serverless-event-processing-private-link.yml
[SVG version of architecture diagram]: ./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.svg
[SVG version of decision tree]: ./images/private-link-hub-spoke-network-decision-tree.svg
[SVG version of Private Link diagram]: ./images/private-link-hub-spoke-network-private-link.svg
[Use Azure Firewall to inspect traffic destined to a private endpoint]: /azure/private-link/inspect-traffic-with-azure-firewall
[Use Private Link in Virtual WAN]: /azure/virtual-wan/howto-private-link
[View virtual hub effective routes]: /azure/virtual-wan/effective-routes-virtual-hub
[Web app private connectivity to Azure SQL database]: ../../example-scenario/private-web-app/private-web-app.yml
[What is Azure DNS?]: /azure/dns/dns-overview
[What is Azure Private Endpoint?]: /azure/private-link/private-endpoint-overview
[What is Azure Private Link?]: /azure/private-link/private-link-overview?toc=/azure/virtual-network/toc.json
[What is Azure Virtual Network?]: /azure/virtual-network/virtual-networks-overview
[What is Azure Virtual WAN?]: /azure/virtual-wan/virtual-wan-about
[What is a private Azure DNS zone]: /azure/dns/private-dns-privatednszone
