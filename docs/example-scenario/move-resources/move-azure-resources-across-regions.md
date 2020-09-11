---
title: Move Azure resources across regions
titleSuffix: Azure Example Scenarios
description: Learn the key steps, considerations, and strategies for moving Azure resources across regions by examining an example scenario.
author: doodlemania2
ms.date: 09/08/2020
ms.topic: example-scenario
ms.custom:
- fcp
---

# Move Azure resources across regions

With the growth of Microsoft Azure and its evolving set of regions worldwide, customers have a need to move deployments from one region to another. Moving applications across regions is an activity that demands a well thought-out plan, to ensure that all resources are moved seamlessly, and that applications are up and running in the new region with minimal downtime.

The recommendations and architecture in this example provide guidance for how to plan and move Azure resources across regions.

## Use cases

The following are some of the top reasons for moving resources to a different region:

* Align to a region launch: Move your resources to a newly introduced Azure region that wasn't previously available.
* Align for services/features: Move resources to take advantage of services or features that are available in a specific region.
* Respond to business developments: Move resources to a region in response to business changes, such as mergers or acquisitions.
* Align for proximity: Move resources to a region local to your business.
* Meet data requirements: Move resources in order to align with data residency requirements, or data classification needs. Learn more.
* Respond to deployment requirements: Move resources that were deployed in error, or move in response to capacity needs.
* Respond to decommissioning: Move resources due to decommissioning of regions.

## Architecture

![Diagram architecture configuration.](./media/move-azure-resources-architecture-diagram.png)

1. **On-premises/data center network**: A private local-area network running within an organization to support the on-premises resources.
2. **ExpressRoute circuit**: ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends an on-premises network into Azure.
3. **Local edge routers**: Routers that connect the on-premises network to the circuit managed by the third-party provider. Depending on how your connection is provisioned, you may need to provide the public IP addresses used by the routers.
4. **Microsoft edge routers**: Two routers in an active-active highly available configuration. These routers enable a third-party connectivity provider to connect their circuits directly to their datacenter. Depending on how your connection is provisioned, you may need to provide the public IP addresses used by the routers.
5. **VPN Gateway**: The VPN gateway service enables you to connect the virtual network to the on-premises network. 
6. **Identity**: Most enterprise organizations have an Active Directory Domain Services (AD DS) environment in their on-premises datacenter. To facilitate management of assets moved to Azure from your on-premises network that depends on AD DS, we recommended that you host AD DS domain controllers in Azure in a central Virtual Network (VNET) hub that dependent workloads can access.
7. **VNET Peering**: Multiple VNETs with peering between them. VNET peering allows for group applications in respective virtual networks, and provides a low latency high-bandwidth connection.
8. **Multi-tier web application running in the cloud environment**: This example architecture is applicable to many industries that need to deploy resilient multitier applications in the cloud. In this scenario, the application consists of three layers.

   * **Web tier**: The top layer including the user interface. This layer parses user interactions and passes the actions to the next layer for processing.
   * **Business/App tier**: Processes the user interactions and makes logical decisions about the next steps. This layer connects the web tier and the data tier.
   * **Data tier**: Stores the application data. In this case, we have a SQL DB to store the data.

9. **Internal load balancer**: Network traffic from the VPN gateway is routed to the cloud application through an internal load balancer located in the subnet of application tiers.
10. **Platform as a Service (PaaS) resources**: In this example environment, there are a few PaaS services such as Azure IoT hub, Azure Key Vault, Azure App Service, etc.

## Components

The following components are used in the example architecture:

* [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/)
* [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway/)
* [Azure Active Directory Domain Services](https://azure.microsoft.com/services/active-directory-ds/)
* [Azure App Service](https://azure.microsoft.com/free/apps/search/)
* [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/)
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault/)
* [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services/)
* [Azure Automation Service](https://azure.microsoft.com/services/automation/)

## Steps to move resources across regions

Your requirements might differ from the example architecture, so use the recommendations in this section as a starting point.

1. Verify the pre-requisites for the move.

   * Planned downtime: The region move should be planned as maintenance activity with scheduled downtime to minimize customer impact.

   * Azure Subscription limits and quota: Ensure that your subscription has enough resources to support the specific resource type. For example, ensure the target region supports VMs with sizes that match your source VMs. Contact [support](https://azure.microsoft.com/support/options/) to enable the required quota if needed. To learn more, see [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits)

   * Verify account permissions: If you created your free Azure account, you're the administrator of your subscription. If you're not the subscription administrator, work with the administrator to assign the permissions that you need to move the resources. Ensure your Azure subscription allows you to create the necessary resource in the target region.

   * Identify and categorize your resources: Based on the type of resource you would need to export an [Azure Resource Manager](https://azure.microsoft.com/features/resource-manager/) template or start replication using various technologies. For each of the resource types you want to move, the steps may be different. Refer to the following article to identify the corresponding steps for each of the resource types, [Moving Azure resources across regions](https://docs.microsoft.com/azure/azure-resource-manager/management/move-region)

2. Move the networking components.

   * Network Security Groups (NSGs): NSGs can't be moved from one region to another. You can however, use an ARM template to export the existing configuration and security rules of an NSG. You can then stage the resource in another region by exporting the NSG to a template, modifying the parameters to match the destination region, and then deploy the template to the new region.

   * Virtual Network: You can use an Azure Resource Manager template to complete the move of the virtual network to another region. Export the virtual network to a template, modify the parameters to match the destination region, and then deploy the template to the new region.

   * Virtual network peering: VNET peering won't be re-created, and VNET peers will fail if they're still present in the template. Before you export the template, remove any VNET peers. You can reestablish them after the virtual network move.

   * Public IP addresses: Azure Public IPs are region-specific and can't be moved from one region to another. You can however, use an Azure Resource Manager template to export the existing configuration of a public IP. You can then stage the resource in another region by exporting the public IP to a template, modifying the parameters to match the destination region, and then deploy the template to the new region.

3. Move the app components.

   * Virtual Machine (VM) resources: Moving VM resources requires [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery) to move the resources by replicating them in the target region. To understand more about a VM move using Site Recovery, see [Move Azure VMs to another region](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-tutorial-migrate).

   * SQL resources: SQL DBs make use of the SQL Failover Group mechanism to move across regions. To learn more about the moving SQL DBs, see [Move resources to new region - Azure SQL Database & Azure SQL Managed Instance](https://docs.microsoft.com/azure/azure-sql/database/move-resources-across-regions).

4. Move the PaaS services.

   * Many of the PaaS services have their own specific steps for orchestrating the move. To find the latest information on the list of supported services, see [Support for moving Azure resources across regions](https://docs.microsoft.com/azure/azure-resource-manager/management/region-move-support).

5. Move the on-premises infrastructure.

   * To ensure you have the full source region recreated on the target region, re-establish and configure your on-premises components as they were before and connect them to the Azure network.

## Considerations

The following are some of the considerations for making a cross-regional move:

* Today’s customers have a complex infrastructure environment that spans across their on-premises infrastructure to the Cloud. Some even have an additional level of complexity, with a multi-cloud strategy containing private or public deployments. A plan for migrating across regions must take these complex infrastructures into account.

* Customers are looking to move similar resources together, so consider these common patterns when moving resources:  
  * Move resource types together. By combining the move of similar resource types, you can plan the preparation step of your move more easily and ensure that long running operations complete together, which helps reduce downtime. For example, the move of 50 VMs or 20 SQL DBs together.
  * Move all resources within an application together. You can select the resources of an application and try to move them together in a set, to ensure that you are able to bring up the app on the target region in an orchestrated manner.

* Ensure that capacity needs are met. The ability to verify capacity or quota is available in the target region to support current and potential business growth before the actual move.

* There should be no impact to the existing source region while the move is in-progress. Customers are looking for minimal or no impact to their current business critical applications or infrastructure on the source region.

* Customers are looking for a functional environment up and running on the target region with the least possible downtime to ensure business continuity.

* The capability to validate the migration before the final cut over and commit to the target side is critical for many customers who support Tier 0, Tier 1 workloads in FSI, or HealthCare verticals.

* Ensure due diligence is done by testing and validating the original configurations, connectivity, proper security configuration, policies, data replication, and database connections, before you commit the move to the target region.

* Once the resources are moved to the target, make final changes like the following, to ensure the final configuration is up and running:
  * Change the DNS configuration to point to a new IP.
  * Delete resources in the source region to avoid double billing and to prevent split brain issues due to the existence of two separate data sets that overlap in scope and configuration.
  * Delete any auxiliary resources created for the move. For example, any storage accounts used for intermediate transfer.

## Next steps

* [Moving Azure resources across regions](https://docs.microsoft.com/azure/azure-resource-manager/management/move-region)

## Related resources

* [Support for moving Azure resources across regions](https://docs.microsoft.com/azure/azure-resource-manager/management/region-move-support)
* [Move Azure VMs to another region](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-tutorial-migrate)
* [Move resources to new region - Azure SQL Database & Azure SQL Managed Instance](https://docs.microsoft.com/azure/azure-sql/database/move-resources-across-regions)
