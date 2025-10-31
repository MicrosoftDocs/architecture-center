---
title: Compare AWS and Azure Resource Management
description: Compare resource management for Azure and AWS. Learn about the differences between Azure and AWS resource groups. Learn about Azure management interfaces.
author: splitfinity81
ms.author: yubaijna
ms.date: 01/03/2025
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - aws-to-azure
---

# Compare AWS and Azure resource management

The term *resource* is used in the same way in both Azure and Amazon Web Services (AWS). A resource is a manageable item. It could be a virtual machine, storage account, web app, database, or virtual network, for example.

## AWS resource groups vs. Azure resource groups

Resource groups in Azure and AWS are used to organize and manage resources. There are, however, some key differences:

- Deleting an AWS resource group doesn't affect the resources. Deleting an Azure resource group deletes all the resources in it. 
- In Azure, you must create a resource group before you create a resource. A resource must be part of a single resource group.
- In Azure, you can track costs by resource group. In AWS, you can use cost allocation tags to filter on specific resources.

## Resource deployment options

Azure provides several ways to manage your resources:

- [Azure portal](/azure/azure-resource-manager/templates/deploy-portal). Like an AWS dashboard, the Azure portal provides a web-based management interface for Azure resources.

- [REST API](/azure/azure-resource-manager/templates/deploy-rest). The Azure Resource Manager REST API provides programmatic access to most of the features that are available in the Azure portal.

- [Azure CLI](/azure/azure-resource-manager/templates/deploy-cli). Azure CLI provides a command-line interface that you can use to create and manage Azure resources. Azure CLI is available for [Windows, Linux, and macOS](/cli/azure).

- [Azure PowerShell](/azure/azure-resource-manager/powershell-azure-resource-manager). You can use the Azure modules for PowerShell to run automated management tasks by using a script. PowerShell is available for [Windows, Linux, and macOS](/powershell/scripting/install/installing-powershell).

- [ARM Templates](/azure/azure-resource-manager/templates/template-tutorial-create-first-template?tabs=azure-powershell). Azure Resource Manager (ARM) templates provide JSON template-based resource management capabilities that are similar to those of the AWS CloudFormation service.

- [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep). Bicep is a domain-specific language that uses declarative syntax to deploy Azure resources.

- [Terraform](/azure/developer/terraform/get-started-azapi-resource). You can use Terraform to define, preview, and deploy cloud infrastructure by using HCL syntax.

With each of these interfaces, the resource group is central to the creation, deployment, or modification of Azure resources. The implementation is similar to the stack implementation that's used to group AWS resources during CloudFormation deployments.

## Tagging

Tagging, in both Azure and AWS, enables you to organize and manage resources effectively by assigning metadata to the resources. Tags are key-value pairs that help you categorize, track, and manage costs across your cloud infrastructure. Both AWS and Azure support attribute-based access control (ABAC) based on tag values. Although Azure and AWS tagging are similar, there are some differences:

- Azure tags are case-insensitive for operations, but casing can be preserved. AWS tags are case-sensitive. 
- Azure provides tag inheritance through policies. AWS doesn't natively support tag inheritance between parent and child resources. AWS does support tag inheritance for AWS Cost Categories. 
- AWS provides a tag editor tool for adding tags, whereas Azure provides tagging capabilities via the Azure portal and management interfaces.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Srinivasaro Thumala](https://www.linkedin.com/in/srini-thumala/) | Senior Customer Engineer

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | 
Director, Partner Technology Strategist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure resource group guidelines](/azure/azure-resource-manager/resource-group-overview#resource-groups)
- [Deploy resources with ARM templates and Azure portal](/azure/azure-resource-manager/templates/deploy-portal)

## Related resources

- [Compare AWS and Azure accounts](accounts.md)
- [Compare AWS and Azure networking options](networking.md)
