---
title: "Fusion: Azure Virtual Datacenter - Resource Grouping" 
description: Discussing the resource grouping approach to the Azure Virtual Datacenter (VDC) model
author: rotycen
ms.date: 11/08/2018
---
# Fusion: Azure Virtual Datacenter - Resource grouping

Jump to: [Resource groups](#resource-groups) | [Deployment templates](#deployment-templates)

The Azure Virtual Datacenter model relies heavily on resource grouping for organizing assets within a VDC. They also server as a pillar of access control and policy enforcement.

## Resource groups

Resources in the VDC model are assumed to be grouped according to function within the hub or spoke they are a part of. For example, each hub is assumed to have a separate resource group for each of the following components:

| Resource group                | Use                                                              |
|-------------------------------|------------------------------------------------------------------|
| Operations and monitoring     | Hosts log analytics instance and other operational assets for the central hub environment. |
| Key vault                     | Hosts the central hub Key Vault instance. |
| Networking                    | Hosts the hub virtual network, networking rules and devices, and the gateway connection to the on-premises environments. |
| Jump box                      | Hosts secure bastion VMs used as management jump boxes for the hub environment. |
| ADDS                          | Hosts servers providing Active Directory Domain Services and DNS for the hub environment.  |

Likewise spokes will have at least the following resource groups: 

| Resource group                | Use                                                              |
|-------------------------------|------------------------------------------------------------------|
| Operations and monitoring     | Hosts log analytics instance and other operational assets for the spoke and workload. |
| Key vault                     | Hosts the workload-specific Key Vault instance. |
| Networking                    | Hosts the spoke virtual network, and networking rules and devices. |

In addition to these default groups any assets supporting workloads also have resource groups organized functionally. For instance, for a spoke supporting an N-tier application, you might have separate resource groups for each of the web, data, and business tiers.

Access control and Azure policy settings can be applied at the resource group level, so these groupings are one of the main ways consistent RBAC and policy are applied to resources in the VDC model.  

## Deployment templates

As with any other Azure deployment, developing [Resource Manager templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#template-deployment) can help you standardize your VDC deployments. 

Hub and spoke environments share similar base infrastructure that needs to be created before other components can be deployed. Spokes will all have a minimum set of security and access control that get applied on creation. A VDC is well suited to the use of deployment templates as a way to standardize the provisioning of resources and instrumenting consistent policy standards. 

To help you build templates and automate the deployment of VDC resources, the Azure team has created the Azure Virtual Datacenter Automation Tookit [need public link]. This toolkit provides examples and code that, using a combination of python scripting, parameter files, and Resource Manager templates, allows you to radically simplify and standardize the VDC deployment process.   

## Next steps

Learn  how [policy enforcement](../policy-enforcement/vdc-policy-enforcement.md) is implemented within an Azure Virtual Datacenter.

> [!div class="nextstepaction"]
> [Azure Virtual Datacenter: Policy Enforcement](../policy-enforcement/vdc-policy-enforcement.md)