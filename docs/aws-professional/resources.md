---
title: Compare AWS and Azure resource management
description: Compare resource management between Azure and AWS. See the difference between Azure resource groups and AWS Resource Groups. Explore Azure management interfaces.
author: scaryghosts
ms.author: adamcerini
categories: azure
ms.date: 12/18/2024
ms.topic: conceptual
ms.service: azure-architecture-center
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
  - azure-dev-tool-integrations
  - azure-managed-applications
  - azure-resource-manager
---

# Compare AWS and Azure resource management

The term resource in Azure is used in the same way as in AWS; it’s a manageable item could be virtual machines, storage accounts, web apps, databases, virtual networks, etc. 

## AWS Resource groups vs Azure RGs

Resource groups in Azure and AWS serve the purpose of organizing and managing resources. However, Azure resource groups aren't directly comparable to AWS Resource Groups. 
Here are some key differences.

- Deleting an AWS Resource group doesn’t impact the resources, but deleting an Azure Resource group deletes all the resources under it. 
- In Azure, it's mandatory to create a resource group before creating a resource.  A resource must be part of a single resource group.
- In Azure, you can track costs by resource group. In AWS, you can use cost allocation tags to filter on specific resources.


## Resource deployment options

Azure offers several ways to manage your resources:

- [Azure portal](/azure/azure-resource-manager/templates/deploy-portal). Like the AWS Dashboard, the Azure portal provides a full web-based management interface for Azure resources.

- [REST API](/azure/azure-resource-manager/templates/deploy-rest). The Azure Resource Manager REST API provides programmatic access to most of the features available in the Azure portal.

- [Azure CLI](/azure/azure-resource-manager/templates/deploy-cli). The Azure CLI provides a command-line interface capable of creating and managing Azure resources. The Azure CLI is available for [Windows, Linux, and macOS](/cli/azure).

- [PowerShell](/azure/azure-resource-manager/powershell-azure-resource-manager). The Azure modules for PowerShell allow you to execute automated management tasks using a script. PowerShell is available for [Windows, Linux, and macOS](https://github.com/PowerShell/PowerShell).

- [ARM Templates](/azure/azure-resource-manager/templates/template-tutorial-create-first-template?tabs=azure-powershell). Azure Resource Manager templates provide similar JSON template-based resource management capabilities to the AWS CloudFormation service.

- [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep). Bicep is a domain-specific language that uses declarative syntax to deploy Azure Resources.

- [Terraform](/azure/developer/terraform/get-started-azapi-resource). Terraform enables the definition, preview, and deployment of cloud infrastructure using HCL syntax.

In each of these interfaces, the resource group is central to how Azure resources get created, deployed, or modified. This implementation is similar to the role a "stack" plays in grouping AWS resources during CloudFormation deployments.

## Tagging 
Tagging in Azure and AWS allows you to organize and manage resources effectively by assigning metadata to resources. Tags are key-value pairs that help you categorize, track, and manage costs across your cloud infrastructure. Both AWS and Azure support Attribute Based Access Control (ABAC) based on tag values.  Although Azure and AWS have similar tagging concepts, there are some differences in how each platform handles tagging.

Key differences between Azure and AWS Tagging:

- Azure tags are case-insensitive for operations, but casing may be preserved. AWS tags are case sensitive. 
- Azure offers Tag inheritance through policies, while AWS doesn't natively support tag inheritance between parent and child resources.  AWS does support tag inheritance for AWS Cost Categories. 
- AWS provides a Tag editor tool for adding tags, whereas Azure integrates the tagging capabilities through Azure portal and management interfaces. 



## See also

- [Azure resource group guidelines](/azure/azure-resource-manager/resource-group-overview#resource-groups)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Srinivasaro Thumala](https://www.linkedin.com/in/srini-thumala/)

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini)

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps
## Related resources
