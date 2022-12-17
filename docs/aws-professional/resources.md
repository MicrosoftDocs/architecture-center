---
title: Compare AWS and Azure resource management
description: Compare resource management between Azure and AWS. See the difference between Azure resource groups and AWS resource groups. Explore Azure management interfaces.
author: martinekuan
categories: azure
ms.date: 05/21/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: cloud-fundamentals
azureCategories:
  - analytics 
  - compute
  - developer-tools
  - devops
  - networking
  - web
products:
  - azure-devops
  - azare-dev-tool-integrations
  - azure-managed-applications
  - azure-resource-manager
---

# Resource management on Azure and AWS

The term "resource" in Azure is used in the same way as in AWS, meaning any compute instance, storage object, networking device, or other entity you can create or configure within the platform.

Azure resources are deployed and managed using one of two models: [Azure Resource Manager](/azure/azure-resource-manager/resource-group-overview), or the older Azure [classic deployment model](/azure/azure-resource-manager/resource-manager-deployment-model). Any new resources are created using the Resource Manager model.

## Resource groups

Both Azure and AWS have entities called "resource groups" that organize resources such as VMs, storage, and virtual networking devices. However, [Azure resource groups](/azure/virtual-machines/windows/infrastructure-example) are not directly comparable to AWS resource groups.

While AWS allows a resource to be tagged into multiple resource groups, an Azure resource is always associated with one resource group. A resource created in one resource group can be moved to another group, but can only be in one resource group at a time. Resource groups are the fundamental grouping used by Azure Resource Manager.

Resources can also be organized using [tags](/azure/azure-resource-manager/resource-group-using-tags). Tags are key-value pairs that allow you to group resources across your subscription irrespective of resource group membership.

## Management interfaces

Azure offers several ways to manage your resources:

- [Web interface](/azure/azure-resource-manager/resource-group-portal). Like the AWS Dashboard, the Azure portal provides a full web-based management interface for Azure resources.

- [REST API](/rest/api). The Azure Resource Manager REST API provides programmatic access to most of the features available in the Azure portal.

- [Command Line](/azure/azure-resource-manager/cli-azure-resource-manager). The Azure CLI provides a command-line interface capable of creating and managing Azure resources. The Azure CLI is available for [Windows, Linux, and Mac OS](/cli/azure).

- [PowerShell](/azure/azure-resource-manager/powershell-azure-resource-manager). The Azure modules for PowerShell allow you to execute automated management tasks using a script. PowerShell is available for [Windows, Linux, and Mac OS](https://github.com/PowerShell/PowerShell).

- [Templates](/azure/azure-resource-manager/resource-group-authoring-templates). Azure Resource Manager templates provide similar JSON template-based resource management capabilities to the AWS CloudFormation service.

In each of these interfaces, the resource group is central to how Azure resources get created, deployed, or modified. This is similar to the role a "stack" plays in grouping AWS resources during CloudFormation deployments.

The syntax and structure of these interfaces are different from their AWS equivalents, but they provide comparable capabilities. In addition, many third-party management tools used on AWS, like [Hashicorp's Terraform](https://www.terraform.io/docs/providers/azurerm) and [Netflix Spinnaker](https://www.spinnaker.io), are also available on Azure.

## See also

- [Azure resource group guidelines](/azure/azure-resource-manager/resource-group-overview#resource-groups)
