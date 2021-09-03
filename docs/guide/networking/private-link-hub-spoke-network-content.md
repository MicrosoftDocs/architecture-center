This article provides guidelines for using Azure Private Link in a hub-and-spoke network topology. The target audience includes network architects and cloud solution architects. Specifically, this guide discusses how to use Azure Private Endpoint to privately access platform as a service (PaaS) resources.

This guide doesn't cover virtual network integration, service endpoints, and other solutions for connecting infrastructure as a service (IaaS) components to Azure PaaS resources. For more information on these solutions, see [Integrate Azure services with virtual networks for network isolation][Integrate Azure services with virtual networks for network isolation].

## Overview

The following sections provide general information on Private Link and its environment.

### Azure hub-and-spoke topologies

Hub and spoke is a network topology that you can use on Azure. It works well for efficiently managing communication services and meeting security requirements at scale. See [Hub-and-spoke network topology][Hub-and-spoke network topology] for more information on hub-and-spoke networking models.

By using a hub-and-spoke architecture, you can take advantage of these benefits:

- Deploying individual workloads between central IT teams and workload teams
- Saving costs by minimizing redundant resources
- Managing networks efficiently by centralizing services that multiple workloads share
- Overcoming limits associated with single Azure subscriptions

This diagram shows a typical hub-and-spoke topology that you can deploy in Azure:

:::image type="complex" source="./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.png" alt-text="Architecture diagram showing how Azure Databricks works with data storage services to refine and analyze data and make it available for other services." border="false":::
   The diagram contains three gray rectangles: one labeled Process, one labeled Serve, and one labeled Store. The Process and Serve rectangles are next to each other in the upper part of the diagram. The Serve rectangle contains a white box with icons for Machine Learning and Azure Kubernetes Service. Another white box straddles the Process and Serve rectangles. It contains icons for Azure Databricks and MLflow. An arrow points from that box to the white box in the Serve rectangle. Below the Process rectangle is the Store rectangle. It contains a white box with icons for Data Lake Storage, Delta Lake, and three database tables labeled Bronze, Silver, and Gold. Three lines connect the Process and Store rectangles, with arrows at each end of each line.
:::image-end:::

*Download an [SVG][SVG version of architecture diagram] of this architecture.*

This architecture is one of two options for network topology that Azure supports. This classic reference design uses basic network components like Azure Virtual Network, virtual network peering, and user-defined routes (UDRs). When you use hub and spoke, you're responsible for configuring the services. You also need to ensure that the network meets security and routing requirements.

[Azure Virtual WAN][What is Azure Virtual WAN?] provides an alternative for deployments at scale. This service uses a simplified network design. Virtual WAN also reduces the configuration overhead associated with routing and security.

Private Link supports different options for traditional hub-and-spoke networks and for Virtual WAN networks.

### Private Link

Private Link provides access to services over the Private Endpoint network interface. Private Endpoint uses a private IP address from your virtual network. You can access various services over that private IP address:

- Azure PaaS services
- Customer-owned services that Azure hosts
- Partner services that Azure hosts

Traffic between your virtual network and the service that you're accessing travels across the Azure network backbone. As a result, you no longer access the service over a public endpoint. For more information, see [What is Azure Private Link?][What is Azure Private Link?].

:::image type="complex" source="./images/private-link-hub-spoke-network-private-link.png" alt-text="Architecture diagram showing how Azure Databricks works with data storage services to refine and analyze data and make it available for other services." border="false":::
   The diagram contains three gray rectangles: one labeled Process, one labeled Serve, and one labeled Store. The Process and Serve rectangles are next to each other in the upper part of the diagram. The Serve rectangle contains a white box with icons for Machine Learning and Azure Kubernetes Service. Another white box straddles the Process and Serve rectangles. It contains icons for Azure Databricks and MLflow. An arrow points from that box to the white box in the Serve rectangle. Below the Process rectangle is the Store rectangle. It contains a white box with icons for Data Lake Storage, Delta Lake, and three database tables labeled Bronze, Silver, and Gold. Three lines connect the Process and Store rectangles, with arrows at each end of each line.
:::image-end:::

*Download an [SVG][SVG version of Private Link diagram] of this architecture.*

## Decision tree for Private Link deployment

You can deploy private endpoints in either a hub or a spoke. A few factors determine which location works best in each situation. The factors are relevant for Azure PaaS services and also for customer-owned and partner services that Azure hosts.

The following questions and flowchart present those factors in decision-tree format. Use these questions to determine the best configuration for your environment:

1. Is Virtual WAN your network connectivity solution?

   If you use Virtual WAN, you can only provision private endpoints on spoke virtual networks that you connect to your virtual hub. You can't deploy resources into your virtual hub or secure hub.

   For more information on integrating Private Endpoint into your network, see these articles:

   - [Use Private Link in Virtual WAN][Use Private Link in Virtual WAN]
   - [How to configure virtual hub routing][How to configure virtual hub routing]

1. Do you use a network virtual appliance (NVA) such as Azure Firewall?

   Traffic to Private Endpoint uses the Azure network backbone and is encrypted. However, you might need to log or filter that traffic.

   In certain cases, you might want to use a firewall to analyze traffic flowing to Private Endpoint. Specifically, you might use a firewall if you use one for traffic in any of these areas:

   - Across spokes
   - Between your hub and spokes
   - Between on-premises components and and your Azure networks

   In this case, deploy private endpoints in your hub in a dedicated subnet. This arrangement helps you to:

   - Simplify your secure network address translation (SNAT) rule configuration. You can create a single SNAT rule in your NVA for traffic to the dedicated subnet that contains your private endpoints. You can route traffic to other applications without applying SNAT.
   - Simplify your route table configuration. For traffic that's flowing to private endpoints, you can add a rule to route that traffic through your NVA. You can reuse that rule across all your spokes, virtual private network (VPN) gateways, and Azure ExpressRoute gateways.  
   - Apply network security group rules for inbound traffic in the subnet that you dedicate to Private Endpoint. These rules work on top of your firewall by filtering traffic to your resources. They provide a single place for controlling access to resources.
   - Centralize management of private endpoints. If you deploy all private endpoints in one place, you can more efficiently manage them in all your virtual networks and subscriptions.

   Deploying private endpoints in a dedicated subnet is appropriate when all workloads need access to each PaaS resource that you're protecting with Private Link. But if your workloads access different PaaS resources, don't use this configuration. Instead, improve security by following the principle of least privilege (PoLP):

   - Place each private link in a separate subnet.
   - Only give workloads that use a protected resource access to that resource.

1. Do you use Private Endpoint from an on-premises system?

   If you plan on using private endpoints to access resources from an on-premises system, deploy the endpoints in your hub. With this arrangement, you can take advantage of some of the benefits that the previous section describes:

   - Using network security groups to control access to your resources
   - Managing your private endpoints in a centralized location

   If you're planning on accessing resources from applications that you've deployed in Azure, the situation's different:

   - If only one application needs access to your resources, deploy Private Endpoint in that application's spoke.
   - If more than one application needs access to your resources, deploy Private Endpoint in your hub.

The following flowchart summarizes the various options and recommendations. Since every customer has a unique environment, consider your system's requirements when deciding where to place private endpoints.

:::image type="complex" source="./images/private-link-hub-spoke-network-decision-tree.png" alt-text="Architecture diagram showing how Azure Databricks works with data storage services to refine and analyze data and make it available for other services." border="false":::
   The diagram contains three gray rectangles: one labeled Process, one labeled Serve, and one labeled Store. The Process and Serve rectangles are next to each other in the upper part of the diagram. The Serve rectangle contains a white box with icons for Machine Learning and Azure Kubernetes Service. Another white box straddles the Process and Serve rectangles. It contains icons for Azure Databricks and MLflow. An arrow points from that box to the white box in the Serve rectangle. Below the Process rectangle is the Store rectangle. It contains a white box with icons for Data Lake Storage, Delta Lake, and three database tables labeled Bronze, Silver, and Gold. Three lines connect the Process and Store rectangles, with arrows at each end of each line.
:::image-end:::

*Download an [SVG][SVG version of decision tree] of this architecture.*

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

- When you use Private Endpoint across a regional virtual network peering, you don't incur peering charges for traffic to and from Private Endpoint.
- Peering costs still apply with other infrastructure resource traffic that flows across a virtual network peering.
- If you deploy private endpoints across different regions, Private Link rates and global peering inbound and outbound rates apply.

For more information, see [Bandwidth pricing][Bandwidth pricing].

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



[Azure Private Link availability]: https://docs.microsoft.com/en-us/azure/private-link/availability
[Bandwidth pricing]: https://azure.microsoft.com/en-us/pricing/details/bandwidth/
[Diagnose a virtual machine routing problem - Diagnose using Azure portal]: https://docs.microsoft.com/en-us/azure/virtual-network/diagnose-network-routing-problem#diagnose-using-azure-portal
[How to configure virtual hub routing]: https://docs.microsoft.com/en-us/azure/virtual-wan/how-to-virtual-hub-routing
[How network security groups filter network traffic]: https://docs.microsoft.com/en-us/azure/virtual-network/network-security-group-how-it-works
[Hub-and-spoke network topology]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology
[Hub-spoke network topology in Azure]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli
[Integrate Azure services with virtual networks for network isolation]: https://docs.microsoft.com/en-us/azure/virtual-network/vnet-integration-for-azure-services
[Multi-region web app with private connectivity to database]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/sql-failover/app-service-private-sql-multi-region
[Private Link and DNS integration at scale]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale
[Securing your Microsoft Teams channel bot and web app behind a firewall]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/teams/securing-bot-teams-channel
[Serverless event stream processing in a VNet with private endpoints]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/serverless-event-processing-private-link
[SVG version of architecture diagram]: ./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.svg
[SVG version of decision tree]: ./images/private-link-hub-spoke-network-decision-tree.svg
[SVG version of Private Link diagram]: ./images/private-link-hub-spoke-network-private-link.svg
[Use Azure Firewall to inspect traffic destined to a private endpoint]: https://docs.microsoft.com/en-us/azure/private-link/inspect-traffic-with-azure-firewall
[Use Private Link in Virtual WAN]: https://docs.microsoft.com/en-us/azure/virtual-wan/howto-private-link
[View virtual hub effective routes]: https://docs.microsoft.com/en-us/azure/virtual-wan/effective-routes-virtual-hub
[Web app private connectivity to Azure SQL database]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/private-web-app/private-web-app
[What is Azure DNS?]: https://docs.microsoft.com/en-us/azure/dns/dns-overview
[What is Azure Private Endpoint?]: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview
[What is Azure Private Link?]: https://docs.microsoft.com/en-us/azure/private-link/private-link-overview?toc=/azure/virtual-network/toc.json
[What is Azure Virtual Network?]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview
[What is Azure Virtual WAN?]: https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about
[What is a private Azure DNS zone]: https://docs.microsoft.com/en-us/azure/dns/private-dns-privatednszone
