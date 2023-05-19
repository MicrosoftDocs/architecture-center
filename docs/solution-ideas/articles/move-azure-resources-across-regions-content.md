This solution moves Azure resources across regions efficiently, securely, and seamlessly. See key steps, considerations, and strategies for planning and carrying out a move.

## Architecture

:::image type="content" border="false" source="../media/move-azure-resources-architecture-diagram.svg" alt-text="Diagram that shows the dataflow of moving Azure resources across regions solution." lightbox="../media/move-azure-resources-architecture-diagram.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/move-azure-resources-across-regions.vsdx) of this architecture.*

### Dataflow

- **On-premises data center network**: A private local-area network running within an organization to support the on-premises resources.
- **ExpressRoute circuit**: ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends an on-premises network into Azure.
- **Local edge routers**: Routers that connect the on-premises network to the circuit managed by the third-party provider. Depending on how you've provisioned your connection, you may need to provide the public IP addresses that the routers use.
- **Microsoft edge routers**: Two routers in an active-active highly available configuration. These routers enable a third-party connectivity provider to connect their circuits directly to their datacenter. Depending on how you've provisioned your connection, you may need to provide the public IP addresses that the routers use.
- **VPN Gateway**: By using the VPN gateway service, you can connect the virtual network to the on-premises network.
- **Active Directory subnet**: Most enterprise organizations have an Active Directory Domain Services (AD DS) environment in their on-premises datacenter. To facilitate management of assets moved to Azure from your on-premises network that depends on AD DS, consider hosting AD DS domain controllers in Azure in a central Virtual Network (VNET) hub that dependent workloads can access.
- **VNET Peering**: Multiple VNETs with peering between them. VNET peering allows for group applications in respective virtual networks, and provides a low latency high-bandwidth connection.
- **Multitiered web applications running in the cloud environment**: This example architecture is applicable to many industries that need to deploy resilient multitier applications in the cloud. In this scenario, the application consists of three layers:

   * **Web tier**: The top layer, including the user interface. This layer parses user interactions and passes the actions to the next layer for processing.
   * **Business or App tier**: Processes the user interactions and makes logical decisions about the next steps. This layer connects the web tier and the data tier.
   * **Data tier**: Stores the application data. In this case, an SQL database stores the data.

- **Internal load balancer**: Network traffic from the VPN gateway is routed to the cloud application through an [internal load balancer (ILB) endpoint](/azure/application-gateway/configure-application-gateway-with-private-frontend-ip) located in the subnet of application tiers.
- **Platform as a Service (PaaS) resources**: In this example environment, there are a few PaaS services such as Azure IoT hub, Azure Key Vault, and Azure App Service.

### Components

The example architecture uses the following components:

* [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute)
* [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway)
* [Azure Active Directory Domain Services](https://azure.microsoft.com/services/active-directory-ds)
* [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub)
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault)
* [Azure App Service](https://azure.microsoft.com/services/app-service)
* [Cognitive services](https://azure.microsoft.com/services/cognitive-services)
* [Azure Automation](https://azure.microsoft.com/services/automation)

## Scenario details

With the growth of Microsoft Azure and its evolving set of regions worldwide, customers have a need to move deployments from one region to another. Moving applications across regions is an activity that demands a well thought-out plan, to ensure you move all resources seamlessly, and that applications are up and running in the new region with minimal downtime.

The recommendations and architecture in this example provide guidance on efficiently, securely, and seamlessly moving Azure resources across regions.

### Potential use cases

Some of the top reasons for moving resources to a different region include the following cases:

* Align to a region launch: Move resources to a newly introduced Azure region that wasn't previously available.
* Align for services or features: Move resources to take advantage of services or features that are available in a specific region.
* Respond to business developments: Move resources to a region in response to business changes, such as mergers or acquisitions.
* Align for proximity: Move resources to a region local to your business.

### Steps to move resources across regions

Since your requirements might differ from the example architecture, use the following recommendations as a starting point:

1. Verify the prerequisites for the move.

   * Planned downtime: Plan the region move as a maintenance activity with scheduled downtime to minimize customer impact.

   * Azure subscription limits and quota: Ensure that your subscription has enough resources to support the specific resource type. For example, ensure the target region supports virtual machines with sizes that match the virtual machines in your source region. Contact [support](https://azure.microsoft.com/support/options) to enable the required quota if needed. To learn more, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

   * Account permissions: If you created a free Azure account, you're the administrator of your subscription. If you're not the subscription administrator, work with the administrator to assign the permissions that you need to move the resources. Verify that your Azure subscription allows you to create the necessary resource in the target region.

   * Resource identification: Identify and categorize your resources based on the type of resource needed to export an [Azure Resource Manager (ARM)](https://azure.microsoft.com/features/resource-manager) template or to start replication using various technologies. For each of the resource types you want to move, the steps may be different. Refer to [Moving Azure resources across regions](/azure/azure-resource-manager/management/move-region) to identify the corresponding steps for each of the resource types.

1. Move the networking components.

   * Network Security Groups: You can't move network security groups from one region to another. However, you can use an ARM template to export the existing configuration and security rules of a network security group. You can then stage the resource in another region by exporting the group to a template, modifying the parameters to match the destination region, and then deploying the template to the new region.

   * Virtual Network: You can use an Azure Resource Manager template to complete the move of the virtual network to another region. Export the virtual network to a template, modify the parameters to match the destination region, and then deploy the template to the new region.

   * Virtual network peering: VNET peering won't be recreated, and VNET peers will fail if they're still present in the template. Before you export the template, remove any VNET peers. You can reestablish them after the virtual network move.

   * Public IP addresses: Since Azure Public IPs are region-specific, you can't move them from one region to another. However, you can use an ARM template to export the existing configuration and security rules of a network security group. You can then stage the resource in another region by exporting the group to a template, modifying the parameters to match the destination region, and then deploying the template to the new region.

1. Move the app components.

   * Virtual machine resources: Moving virtual machine resources requires [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery) to move the resources by replicating them in the target region. To understand more about a virtual machine move using Site Recovery, see [Move Azure VMs to another region](/azure/site-recovery/azure-to-azure-tutorial-migrate).

   * SQL resources: SQL databases make use of the SQL Failover Group mechanism to move across regions. To learn more about moving SQL databases, see [Move resources to new region - Azure SQL Database & Azure SQL Managed Instance](/azure/azure-sql/database/move-resources-across-regions).

1. Move the PaaS services: PaaS services have their own specific steps for orchestrating the move. To find the latest information on the list of supported services, see [Support for moving Azure resources across regions](/azure/azure-resource-manager/management/region-move-support).

1. Move the on-premises infrastructure: To ensure you have the full source region recreated on the target region, re-establish and configure your on-premises components as they were before and connect them to the Azure network.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Consider the following points when making a cross-regional move:

* Your plan for migrating across regions must take into account complex infrastructure. Modern infrastructure environments often span across on-premises infrastructure to the cloud. Some even have an extra level of complexity, with a multicloud strategy containing private or public deployments.

* Move resource types together. By combining the move of similar resource types (for example, 50 virtual machines or 20 SQL databases), you can plan the preparation step of your move more easily and ensure that long-running operations complete together, which helps reduce downtime.

* Move all resources within an application together. You can select the resources of an application and try to move them together in a set, to ensure that you're able to bring up the app on the target region in an orchestrated manner.

* Ensure that you cover your capacity needs. The ability to verify capacity or quota is available in the target region to support current and potential business growth before the actual move.

* There should be minimal or no impact to current business-critical applications or infrastructure in the source region while the move is in progress.

* To ensure business continuity, you should have a functional environment up and running on the target region with the least possible downtime.

* The capability to validate the migration before the final commit to the target side is critical, especially if you support Tier 0, Tier 1 workloads in the Financial Services Industry (FSI) or health care verticals.

* Ensure you do due diligence by testing and validating the original configurations, connectivity, proper security configuration, policies, data replication, and database connections before you commit the move to the target region.

* After you move the resources to the target, ensure the final configuration is up and running by making final changes like:
  * Change the DNS configuration to point to a new IP.
  * Delete resources in the source region to avoid double billing and to prevent issues due to the existence of two separate data sets that overlap in scope and configuration.
  * Delete any auxiliary resources created for the move. For example, delete any storage accounts that were used for intermediate transfer.

## Next steps

* [Moving Azure resources across regions](/azure/azure-resource-manager/management/move-region)
* [Support for moving Azure resources across regions](/azure/azure-resource-manager/management/region-move-support)
* [Move Azure VMs to another region](/azure/site-recovery/azure-to-azure-tutorial-migrate)
* [Move resources to new region - Azure SQL Database & Azure SQL Managed Instance](/azure/azure-sql/database/move-resources-across-regions)

## Related resources

- [Azure resource organization in multitenant solutions](../../guide/multitenant/approaches/resource-organization.yml)
- [Multi-region N-tier application](../../reference-architectures/n-tier/multi-region-sql-server.yml)
- [Multi-region load balancing with Traffic Manager and Application Gateway](../../high-availability/reference-architecture-traffic-manager-application-gateway.yml)
