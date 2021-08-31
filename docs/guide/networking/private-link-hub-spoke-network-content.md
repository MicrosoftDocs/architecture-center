This article provides guidelines for integrating Azure Private Link inside a hub-and-spoke network topology. The target audience is network architects and cloud solution architects. Specifically, this guide discusses how to access platform as a service (PaaS) services over Azure Private Endpoint in a virtual network.

This guide doesn't cover virtual network integration, service endpoints, and other solutions for connecting infrastructure as a service (IaaS) components to Azure PaaS resources. For more information on these alternatives, see [Integrate Azure services with virtual networks for network isolation][Integrate Azure services with virtual networks for network isolation].

## Overview

Add filler sentence since stacked headings aren't allowed.

### Azure hub-and-spoke topologies

Hub and spoke is a network topology that you can use on Azure. It works best for efficiently managing communication services and meeting security requirements at scale. See [Hub-and-spoke network topology][Hub-and-spoke network topology] for more information on hub-and-spoke networking models.

A hub-and-spoke architecture provides these benefits:

- You can deploy individual workloads between central IT teams and workload teams.
- By minimizing redundant resources, you can save costs.
- By centralizing services that multiple workloads share, you can efficiently manage services.
- You can overcome limits associated with single Azure subscriptions.

This diagram shows a typical hub-and-spoke topology that customers deploy in Azure.

:::image type="complex" source="./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.png" alt-text="Architecture diagram showing how Azure Databricks works with data storage services to refine and analyze data and make it available for other services." border="false":::
   The diagram contains three gray rectangles: one labeled Process, one labeled Serve, and one labeled Store. The Process and Serve rectangles are next to each other in the upper part of the diagram. The Serve rectangle contains a white box with icons for Machine Learning and Azure Kubernetes Service. Another white box straddles the Process and Serve rectangles. It contains icons for Azure Databricks and MLflow. An arrow points from that box to the white box in the Serve rectangle. Below the Process rectangle is the Store rectangle. It contains a white box with icons for Data Lake Storage, Delta Lake, and three database tables labeled Bronze, Silver, and Gold. Three lines connect the Process and Store rectangles, with arrows at each end of each line.
:::image-end:::

*Download an [SVG][SVG version of architecture diagram] of this architecture.*
[SVG version of architecture diagram]: ./images/private-link-hub-spoke-network-basic-hub-spoke-diagram.svg

This architecture is one of two options that Azure supports. This classic reference design uses basic network components like Azure Virtual Networks, Vnet Peering, and user-defined routes (UDRs). You're responsible for configuring the services and ensuring that the network meets security and routing requirements.

[Azure Virtual WAN][What is Azure Virtual WAN?] provides an alternative for deployments at scale. This service simplifies the network design. Azure Virtual WAN also reduces the configuration overhead associated with routing and security.

Private Link supports different options for traditional hub-and-spoke networks and for Azure Virtual WAN networks.

### What Azure Private Link is and what it provides
















[Hub-and-spoke network topology]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology
[Integrate Azure services with virtual networks for network isolation]: https://docs.microsoft.com/en-us/azure/virtual-network/vnet-integration-for-azure-services
[What is Azure Virtual WAN?]: https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about
