---
title: Move Azure resources across regions
titleSuffix: Azure Example Scenarios
description: Learn how to migrate Azure resources across regions.
author: doodlemania2
ms.date: 09/08/2020
ms.topic: example-scenario
ms.custom:
- fcp
---

# Move Azure resources across regions

This architecture guidance document shows best practices on how to plan and move Azure Resource across regions. 
With the growth of Azure and its evolving set of regions worldwide, customers have a need to move deployments from one region to another region. Moving applications across regions demands a well thought through planned activity, to ensure all resources are moved seamlessly and applications are up and running in the new region with minimal downtime.

## Need for Cross-Region move

A cross-region move can provide a variety of benefits.

* Define and maintain infrastructure deployments across multiple clusters.
* Deploy and automate a secure end-to-end GitOps workflow.
* Deploy and manage service workloads from source code to their deployment in-cluster.
* Observe ongoing deployments across multiple services, their revisions, and multiple clusters using those services.

## Architecture

Let’s take an example of hypothetical customer with the following architecture configuration:

![Diagram architecture configuration.](./media/figure-010.png)

1. On-premises/data center network: A private local-area network running within an organization to support the on-prem resources.
2. ExpressRoute circuit: ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends on-premises network into Azure.
3. Local edge routers: Routers that connect the on-premises network to the circuit managed by the third-party provider. Depending on how your connection is provisioned, you may need to provide the public IP addresses used by the routers.
4. Microsoft edge routers: Two routers in an active-active highly available configuration. These routers enable a third-party connectivity provider to connect their circuits directly to their datacenter. Depending on how your connection is provisioned, you may need to provide the public IP addresses used by the routers
5. VPN Gateway: The VPN gateway service enables you to connect the virtual network to the on-premises network. 
6. Identity: Most enterprise organizations have an Active Directory Domain Services (AD DS) environment in their on-premises datacenter. To facilitate management of assets moved to Azure from your on-premises network that depend on AD DS, it is recommended to host AD DS domain controllers in Azure in a central VNET (hub) that dependent workloads can access.
7. VNET Peering: Multiple VNETs with peering between them which allows to group applications in respective virtual networks and provide a low latency high bandwidth connection.
8. Multi-tier web application running in the cloud environment: This example scenario is applicable to many industries that needs to deploy resilient multitier applications in the cloud. In this scenario, the application consists of three layers.

  * Web tier: The top layer including the user interface. This layer parses user interactions and passes the actions to next layer for processing.
  * Business/App tier: Processes the user interactions and makes logical decisions about the next steps. This layer connects the web tier and the data tier.
  * Data tier: Stores the application data. In this case, we have a SQL DB to store the data.

9. Internal load balancer. Network traffic from the VPN gateway is routed to the cloud application through an internal load balancer. There is a load balancer located in the subnet of application tiers.
10. PaaS resources: In this example environment, there are few PaaS services such as IoT hub, Key Vault, App Service etc.


## Steps to move resources across regions

Bedrock makes use of the following components.

Your requirements might differ from the architecture described here. Use the recommendations in this section as a starting point.

1.	Verify pre-requisites:
* Planned downtime: The region move should be preferable be planned as maintenance activity with scheduled downtime to ensure the customers are not impacted minimize customer impact.

* Azure Subscription limits and quota: Please ensure that your subscription has enough resources to support the specific resource type. E.g.: Target region supports VMs with sizes that match your source VMs. Contact support to enable the required quota if needed. 

Learn More

* Verify account permissions: If you created your free Azure account, you're the administrator of your subscription. If you're not the subscription administrator, work with the administrator to assign the permissions that you need to move the resources. Ensure your Azure subscription allows you to create the necessary resource in the target region. 

* Identify and categorize your resources: Based on the type of resource you would need to export an ARM template or start replication using various technologies. For each of the resource type you want to move, the steps may be different – please refer to doc link below for identifying the corresponding steps for each of the resource type.

Resources types for region move

2.	Move your networking components
* Network Security Groups (NSGs) : Network security groups can't be moved from one region to another. You can however, use an Azure Resource Manager template to export the existing configuration and security rules of an NSG. You can then stage the resource in another region by exporting the NSG to a template, modifying the parameters to match the destination region, and then deploy the template to the new region.
* Virtual Network: You can use an Azure Resource Manager template to complete the move of the virtual network to another region. You do this by exporting the virtual network to a template, modifying the parameters to match the destination region, and then deploying the template to the new region.
* Virtual network peering: VNET peering won't be re-created, and they'll fail if they're still present in the template. Before you export the template, you have to remove any virtual network peers. You can then reestablish them after the virtual network move.
* Public IP addresses: Azure Public IPs are region specific and can't be moved from one region to another. You can however, use an Azure Resource Manager template to export the existing configuration of a public IP. You can then stage the resource in another region by exporting the public IP to a template, modifying the parameters to match the destination region, and then deploy the template to the new region.

3.	Move the app components
* VM resources: VMs would need ASR as the replication engine underneath to move the resource across regions.
To understand more about the VM move using ASR , see VM region move
* SQL resources: SQL DBs would leverage SQL Failover Group mechanism to move SQL DBs across regions.
To learn more more about the SQL move, see SQL region move

4.	Move of PaaS services: Many of the PaaS services have their own specific steps for orchestrating the move. To find latest information on the list of services supported, 
please see: Services supported for region move

5.	Move of the On-prem infrastructure: To ensure you have full source region recreated on the target region, please re-establish and configure on-prem components as before and connect them to the Azure network.



## Considerations

Considerations for a Cross-Region move:

As Customers have businesses that serve a diverse set of industries and customer segments, key considerations need to be thought through to ensure a smooth cross-regional move. Some of them are listed below:

* Complex infrastructure needs: Today’s customers have a complex infrastructure environment that spans across On-prem to the Cloud, while some have additional level of complexity with a multi-cloud strategy with private or public deployments. Move across regions needs to factor in this complexity and provide a seamless path to migrate into a new region.
* Resource Patterns: Customers are not only looking for the move of similar resources together (E.g.: Set of VMs or SQL DB resources), but also a group of resources that form an application.
* Ensure Capacity needs are met: Ability to verify capacity or quota is available in the target region to support current and potential business growth before the actual move.
* No impact to existing source region: While move is in-progress, customers are looking for no/minimal impact to their current business critical applications or infrastructure on the source region. 
* Minimal downtime to ensure business continuity: Customers are looking for functional environment up and running on target region with the least possible downtime, so it has minimal impact to the business.
* Validation prior to final move: Capability to validate the migration before the final cut over or commit on target side is also critical for many customers supporting Tier 0 , Tier 1 workloads in FSI, HealthCare verticals.

Some best practices to consider:

* Move patterns: Some common patterns observed to move resources are mentioned below.
Move resource types together: You can combine move of similar resources together. This helps to plan the prepare step of move journey and ensure all the long running operations complete together and help reduce the downtime window. E.g.: Move of 50 VMs or 20 SQL DBs together

* Move of all resource within an application: When you are moving an application across regions, you can select the resources of that application and try to move them together in a set, to ensure you are able to bring up the app on the target region in a seamless orchestrated manner.

* Validation prior to Commit: Ensure due diligence is done to do some testing and validation to check the original configurations, connectivity, proper security configuration, policies, and data replication and database connections, before you commit the move to target region.

* Post Move: Once the resources are moved to the target, make final changes to ensure the final configuration is up and running. This may include and not limited to changing the DNS configuration to point to a new IP etc. Also Delete resources in the source region to avoid double billing and to prevent split brain issues due to existing of two separate data sets that overlap in scope and configuration etc. Ensure to delete any auxiliary resources created for the move (Vault, storage account for intermediate transfer).



## Next steps

* [A First Workload With Bedrock](https://github.com/microsoft/bedrock/tree/master/docs/firstWorkload)

## Related resources

* [Bedrock CLI](https://github.com/Microsoft/Bedrock-cli)
* [Spektate](https://github.com/Microsoft/Spektate)
* [Fabrikate](https://github.com/Microsoft/Fabrikate)
* [Fabrikate Cloud Native](https://github.com/timfpark/fabrikate-cloud-native)
* [Fabrikate HLD Definitions](https://github.com/microsoft/fabrikate-definitions)
* [Building GitOps Pipelines](https://github.com/microsoft/bedrock/blob/master/gitops/README.md)
* [Guide to GitOps](https://www.weave.works/technologies/gitops/)
* [GitOps - Frequently Asked Questions](https://www.weave.works/technologies/gitops-frequently-asked-questions/)
* [Flux on GitHub](https://github.com/fluxcd/flux)
* [Terraform on GitHub](https://github.com/hashicorp/terraform)
