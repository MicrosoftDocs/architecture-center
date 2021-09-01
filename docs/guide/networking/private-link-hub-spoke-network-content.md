This article provides guidelines for using Azure Private Link in a hub-and-spoke network topology. The target audience is network architects and cloud solution architects. Specifically, this guide discusses how to use Azure Private Endpoint to access platform as a service (PaaS) services in a virtual network.

This guide doesn't cover virtual network integration, service endpoints, and other solutions for connecting infrastructure as a service (IaaS) components to Azure PaaS resources. For more information on these alternatives, see [Integrate Azure services with virtual networks for network isolation][Integrate Azure services with virtual networks for network isolation].

## Overview

Add filler sentence since stacked headings aren't allowed.

### Azure hub-and-spoke topologies

Hub and spoke is a network topology that you can use on Azure. It works well for efficiently managing communication services and meeting security requirements at scale. See [Hub-and-spoke network topology][Hub-and-spoke network topology] for more information on hub-and-spoke networking models.

By using a hub-and-spoke architecture you can take advantage of these benefits:

- Deploy individual workloads between central IT teams and workload teams
- Save costs by minimizing redundant resources
- Manage networks efficiently by centralizing services that multiple workloads share
- Overcome limits associated with single Azure subscriptions

This diagram shows a typical hub-and-spoke topology that customers deploy in Azure.

:::image type="complex" source="./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.png" alt-text="Architecture diagram showing how Azure Databricks works with data storage services to refine and analyze data and make it available for other services." border="false":::
   The diagram contains three gray rectangles: one labeled Process, one labeled Serve, and one labeled Store. The Process and Serve rectangles are next to each other in the upper part of the diagram. The Serve rectangle contains a white box with icons for Machine Learning and Azure Kubernetes Service. Another white box straddles the Process and Serve rectangles. It contains icons for Azure Databricks and MLflow. An arrow points from that box to the white box in the Serve rectangle. Below the Process rectangle is the Store rectangle. It contains a white box with icons for Data Lake Storage, Delta Lake, and three database tables labeled Bronze, Silver, and Gold. Three lines connect the Process and Store rectangles, with arrows at each end of each line.
:::image-end:::

*Download an [SVG][SVG version of architecture diagram] of this architecture.*

This architecture is one of two options for network topology that Azure supports. This classic reference design uses basic network components like Azure Virtual Networks, virtual network peering, and user-defined routes (UDRs). When you use hub and spoke, you're responsible for configuring the services. You also need to ensure that the network meets security and routing requirements.

[Azure Virtual WAN][What is Azure Virtual WAN?] provides an alternative for deployments at scale. This service uses a simplified network design. Azure Virtual WAN also reduces the configuration overhead associated with routing and security.

Private Link supports different options for traditional hub-and-spoke networks and for Azure Virtual WAN networks.

### What Azure Private Link is and what it provides

Azure Private Link provides access to services over the Private Endpoint network interface. Private Endpoint uses a private IP address from your virtual network. You can access various services over that private IP address:

- Azure PaaS Services
- Customer-owned services that Azure hosts
- Partner services that Azure hosts

Traffic between your virtual network and the service that you're accessing travels across the Azure network backbone. As a result, you no longer access the service over a public endpoint. For more information, see [What is Azure Private Link?][What is Azure Private Link?].

:::image type="complex" source="./images/private-link-hub-spoke-private-link-diagram.png" alt-text="Architecture diagram showing how Azure Databricks works with data storage services to refine and analyze data and make it available for other services." border="false":::
   The diagram contains three gray rectangles: one labeled Process, one labeled Serve, and one labeled Store. The Process and Serve rectangles are next to each other in the upper part of the diagram. The Serve rectangle contains a white box with icons for Machine Learning and Azure Kubernetes Service. Another white box straddles the Process and Serve rectangles. It contains icons for Azure Databricks and MLflow. An arrow points from that box to the white box in the Serve rectangle. Below the Process rectangle is the Store rectangle. It contains a white box with icons for Data Lake Storage, Delta Lake, and three database tables labeled Bronze, Silver, and Gold. Three lines connect the Process and Store rectangles, with arrows at each end of each line.
:::image-end:::

*Download an [SVG][SVG version of Private Link diagram] of this architecture.*

The following recommendations apply both to Azure PaaS Services and Azure hosted customer-owned/partner services. There is no difference from the user point of view.

## Decision tree for Private Link deployment in hub and spoke

Consider these questions when you're deciding where to deploy Private Endpoint inside your network architecture:

### Is Azure Virtual WAN your network connectivity solution?

If you use Azure Virtual WAN, you can only provision Private Endpoint on spoke virtual networks that you connect to your virtual hub. You can't deploy resources into your virtual hub or secure hub.

For more information on integrating Private Endpoint into your network, see these articles:

- [Use Private Link in Virtual WAN][Use Private Link in Virtual WAN]
- [How to configure virtual hub routing][How to configure virtual hub routing]

### Do you use Azure Firewall or an NVA?

Traffic to Private Endpoint use the Azure network backbone and is encrypted. However, you might need to log or filter that traffic.

In certain cases, you might want to use a firewall to analyze traffic flowing to Private Endpoint. Specifically, you might use a firewall if you use one for traffic in any of these areas:

- Across spokes
- Between your hub and spokes
- Between on-premises components and and your Azure networks

In this case, deploy Private Endpoint in your hub in a dedicated subnet. This arrangement helps you to:

- Simplify your secure network address translation (SNAT) rule configuration. You can create a single SNAT rule inside your NVA for traffic to the dedicated subnet that contains Private Endpoint. You can route traffic to other applications without applying SNAT.
- Simplify your route table configuration. For traffic that's flowing to Private Endpoint, you can add a rule to route that traffic through your NVA. You can reuse that rule across all your spokes, virtual private network (VPN) gateways, and ExpressRoute gateways.  
- Apply network security group rules for inbound traffic in the subnet that you dedicate to Private Endpoint. These rules work on top of your firewall by filtering traffic to your resources. From a single place, you can use these rules to control access to resources.
- Centralize management of private endpoints. If you deploy all private endpoints in one place, you can more efficiently manage them in all your virtual networks and subscriptions.

### Do you use Private Endpoint from an on-premises system?

If you plan on using Private Endpoint to access resources from an on-premises system, deploy Private Endpoint in your hub. With this arrangement, you can take advantage of some of the benefits that the previous section describes:

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

Consider the points in the following sections when you deploy Private Endpoint:

### Networking

When you use Private Endpoint inside a spoke virtual network, the subnet's default route table includes a /32 route of type Interface Endpoint.

- If you use a traditional hub-and-spoke topology:

  - You can see this effective route at the network-interface level of your virtual machines.
  - For more information, see [Diagnose a virtual machine routing problem][Diagnose a virtual machine routing problem - Diagnose using Azure portal].

- If you use Azure Virtual WAN:

  - You can see this effective route in the virtual hub effective routes.
  - For more information, see [View virtual hub effective routes][View virtual hub effective routes].

That Interface Endpoint route gets propagated to these areas:

- Any virtual network peering that you've configured
- Any VPN or ExpressRoute Gateway connection to an on-premises system

To restrict access from your hub or on-premises system to Private Endpoint, use a network security group in the subnet where you've deployed Private Endpoint. Configure appropriate inbound rules.

### Name resolution

Private endpoints require a specific DNS setup to resolve the private IP address that your virtual network associates with them. If you use a corporate custom DNS solution, it's best to use DNSZoneGroups. With this configuration, you can integrate Private Endpoint with a centralized instance of Azure Private DNS Zone. It doesn't matter whether you've deployed resources in a hub or a spoke. You only need to link Private DNS Zone with all virtual networks that need to resolve your Private Endpoint DNS name.






[Diagnose a virtual machine routing problem - Diagnose using Azure portal]: https://docs.microsoft.com/en-us/azure/virtual-network/diagnose-network-routing-problem#diagnose-using-azure-portal
[How to configure virtual hub routing]: https://docs.microsoft.com/en-us/azure/virtual-wan/how-to-virtual-hub-routing
[Hub-and-spoke network topology]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology
[Integrate Azure services with virtual networks for network isolation]: https://docs.microsoft.com/en-us/azure/virtual-network/vnet-integration-for-azure-services
[SVG version of architecture diagram]: ./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.svg
[SVG version of decision tree]: ./images/private-link-hub-spoke-network-decision-tree.svg
[SVG version of Private Link diagram]: ./images/private-link-hub-spoke-private-link-diagram.svg
[Use Private Link in Virtual WAN]: https://docs.microsoft.com/en-us/azure/virtual-wan/howto-private-link
[View virtual hub effective routes]: https://docs.microsoft.com/en-us/azure/virtual-wan/effective-routes-virtual-hub
[What is Azure Private Link?]: https://docs.microsoft.com/en-us/azure/private-link/private-link-overview?toc=/azure/virtual-network/toc.json
[What is Azure Virtual WAN?]: https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about
