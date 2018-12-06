---
title: "Fusion: Azure Virtual Datacenter - Naming and Tagging" 
description: Discusses how naming and tagging are used to organize resources and improve management and access control of assets within an Azure Virtual Datacenter.
author: rotycenh
ms.date: 11/08/2018
---
# Fusion: Azure Virtual Datacenter - VDC naming and tagging recommendations

Jump to: [Naming recommendations](#naming-recommendations) | [Tagging](#tagging)

Resource naming standards and tagging policy in the [Azure Virtual Datacenter model](../virtual-datacenter/overview.md) should comply when possible with your existing organization standards and policy, and support your overall subscription design. 

The VDC model does not enforce prescriptive tagging and naming guidance beyond limits described in [Azure naming convention best practices](https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions). However, it does provide recommendations to help make resource groups and individual resources easy to find and manage.  

## Naming recommendations

It's important that resources deployed to a VDC are named uniquely and descriptively. At the resource group level, it's recommended you use names that include major organizational and structural elements of the VDC:

    [Organization Name]-[Hub/Spoke Name]-[Functional Subsection]-rg

For example, the resource group containing virtual networking resources should be named something like this: *contoso-hub1-net-rg*

At the individual resource level:

    [Organization Name]-[Hub/Spoke Name]-[Resource Name]

So an NSG associated with a hub virtual network's gateway subnet should be named something like this: *contoso-hub1-gatewaynsg*

Note some resources, such as Azure Storage accounts, do not allow dashes in their names and have limits to the number of name characters. In these cases a simplified \[Hub/Spoke Name\]\[Resource Name\] standard (for example, *hub1jbdiagstorage*) is usually enough to uniquely identify these assets.

The information used in these names break down as follows:

| Name component       | Description                                                                                    |
|----------------------|------------------------------------------------------------------------------------------------|
| Organization name    | The name of the IT organization responsible for owning and maintaining the VDC.                |
| Hub/Spoke name       | Name of the spoke or hub environment where the resources are deployed.                         |
| Subsection           | Functional grouping ([resource group](../resource-grouping/vdc-resource-grouping.md)) where the resource is used (network, management, etc...). |
| Resource Name        | The identifier of the individual resource itself.                                              |


## Tagging

Tagging policy varies widely across organizations. The VDC model does recommended that, at a minimum, the following tags (or their equivalents using your organization's tagging standards) are applied to all assets at either the resource group or individual resource level:

| Tag                  | Description                                                                                    |
|----------------------|------------------------------------------------------------------------------------------------|
| environment          | How is the resource used (Dev, UAT, Staging, Prod, etc...)?                                    |
| managedBy            | Who is the user or group responsible for managing the asset.                                   |
| dataClassification   | How sensitive is the data stored or processed by the resource?                                 |
| supportTier          | How rapidly to issues with the resource need to be involved?                                   |
| costCenter           | What is the associated cost center ID for the resource?                                        |


## Next steps

Learn how the Azure Virtual Datacenter [networking infrastructure](../software-defined-networks/vdc-networking.md) enables secure, centrally managed access between on-premises and cloud resources, while isolating VDC networks from the public internet and other Azure hosted networks.

> [!div class="nextstepaction"]
> [Azure Virtual Datacenter: Networking](../software-defined-networks/vdc-networking.md)