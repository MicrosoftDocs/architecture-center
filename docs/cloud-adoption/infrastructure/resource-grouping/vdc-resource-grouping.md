---
title: "Fusion: Azure Virtual Datacenter - Resource grouping" 
description: Discussing the resource grouping approach to the Azure Virtual Datacenter model
author: rotycenh
ms.date: 12/28/2018
---
# Fusion: Azure Virtual Datacenter - Resource grouping

Jump to: [Resource groups](#resource-groups) | [Deployment templates](#deployment-templates)

The Azure Virtual Datacenter model relies heavily on resource grouping for organizing assets within a virtual datacenter (VDC). Resource grouping also serves as a pillar of access control and policy enforcement.

## Resource groups

The Azure Virtual Datacenter assumes that resources are grouped according to function within the hub or spoke for which they are a part of. For example, each hub should have a separate resource group for each of the following components:

| Resource group                | Use                                                              |
|-------------------------------|------------------------------------------------------------------|
| Operations and monitoring     | Hosts log analytics instance and other operational assets for the central hub environment |
| Key vault                     | Hosts the central hub Key Vault instance |
| Networking                    | Hosts the hub virtual network, networking rules and devices, and the gateway connection to the on-premises environments |
| Management                    | Hosts secure bastion virtual machines (VMs) used as management jump boxes for the hub environment |
| Shared Services               | Hosts servers providing Active Directory Domain Services and DNS for the hub environment  |
| Central Firewall              | Contains the central firewall devices that control the traffic allowed to pass in and out of the VDC and how that traffic is directed |

Spoke resource grouping will vary depending on workload, but will include the following resource groups to host the basic management and security infrastructure, as well as to enable connectivity to the hub network: 

| Resource group                | Use                                                              |
|-------------------------------|------------------------------------------------------------------|
| Operations and monitoring     | Hosts log analytics instance and other operational assets for the spoke and workload |
| Key vault                     | Hosts the workload-specific Key Vault instance |
| Networking                    | Hosts the spoke virtual network, and networking rules and devices |

Resources supporting workloads also have resource groups organized by function. For instance, for a spoke supporting an N-tier application, you can have separate resource groups for each of the web, data, and business tiers, each containing the relevant VMs and virtual devices for that functionality within the overall workload.

Access control and Azure policy settings can be applied at the resource group level. These groupings are one of the main ways consistent role-based access control (RBAC) and Policy are applied to resources in the Azure Datacenter model.  

## Deployment templates

As with any Azure deployment, developing [Resource Manager templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#template-deployment) can help you standardize your VDC deployments. 

Hub and spoke environments share a similar base infrastructure that needs to be created before other components can be deployed. Spokes will all have a minimum set of security and access control that get applied on creation. A VDC is well suited to the use of deployment templates as a way to standardize the provisioning of resources and instrumenting consistent policy standards. 

To help you build templates and automate the deployment of VDC resources, Azure has created the Azure Virtual Datacenter Automation Tookit [need public link]. This toolkit provides examples and code that uses a combination of python scripting, parameter files, and Resource Manager templates, allowing you to radically simplify and standardize your VDC deployment processes.

## Next steps

Learn  how [Azure Policy](../policy-enforcement/vdc-policy-enforcement.md) is used to implement policy enforcement within an Azure Virtual Datacenter.

> [!div class="nextstepaction"]
> [Azure Virtual Datacenter: Policy Enforcement](../policy-enforcement/vdc-policy-enforcement.md)
