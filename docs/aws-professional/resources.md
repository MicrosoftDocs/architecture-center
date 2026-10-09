---
title: Compare AWS and Azure Resource Management
description: Compare resource management for Azure and AWS. Learn about the differences between Azure and AWS resource groups. Learn about Azure management interfaces.
author: WernerRall147
ms.author: weral
ms.date: 10/05/2026
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
ms.collection: 
 - migration
 - aws-to-azure
---

# Compare AWS and Azure resource management

The term *resource* is used in the same way in both Azure and Amazon Web Services (AWS). A resource is a manageable item. It can be a virtual machine, storage account, web app, database, or virtual network, for example.

## AWS resource groups vs. Azure resource groups

Resource groups in Azure and AWS are used to organize and manage resources. There are, however, some key differences:

- Deleting an AWS resource group doesn't affect the resources. Deleting an Azure resource group deletes all the resources in it.
- In Azure, most resources belong to exactly one resource group, and you must create the resource group before you create the resource. Some resource types, such as policy assignments and role assignments, deploy at subscription, management group, or tenant scope instead.
- In Azure, you can track costs by resource group. In AWS, you can use cost allocation tags to filter by specific resources.

## Resource deployment options

Azure provides several ways to manage your resources:

- [Azure portal](/azure/azure-resource-manager/templates/deploy-portal). Like an AWS dashboard, the Azure portal provides a web-based management interface for Azure resources.

- [REST API](/azure/azure-resource-manager/templates/deploy-rest). The Azure Resource Manager REST API provides programmatic access to most of the features that are available in the Azure portal.

- [Azure CLI](/azure/azure-resource-manager/templates/deploy-cli). Azure CLI provides a command-line interface that you can use to create and manage Azure resources. Azure CLI is available for [Windows, Linux, and macOS](/cli/azure).

- [Azure PowerShell](/azure/azure-resource-manager/management/manage-resources-powershell). You can use the Azure modules for PowerShell to run automated management tasks by using a script. PowerShell is available for [Windows, Linux, and macOS](/powershell/scripting/install/install-powershell).

- [ARM templates](/azure/azure-resource-manager/templates/template-tutorial-create-first-template?tabs=azure-powershell). Azure Resource Manager (ARM) templates provide JSON template-based resource management capabilities that are similar to those of the AWS CloudFormation service.

- [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep). Bicep is a domain-specific language that uses declarative syntax to deploy Azure resources.

- [Terraform](/azure/developer/terraform/get-started-azapi-resource). You can use Terraform to define, preview, and deploy cloud infrastructure by using HCL syntax.

- [Deployment stacks](/azure/azure-resource-manager/bicep/deployment-stacks). A deployment stack is an Azure resource that manages a group of resources as a single unit, across resource group, subscription, and management group scopes. It's the closest Azure equivalent to an AWS CloudFormation stack.

   A resource group is central to the creation, deployment, or modification of most Azure resources. But a resource group is an organizational container, not a deployment unit. If you want the lifecycle behavior of a CloudFormation stack, where the platform tracks which resources a template manages, use a deployment stack. When you remove a resource from the template, the deployment stack's `actionOnUnmanage` setting determines what happens next: the stack either detaches the resource and leaves it in place or deletes it. Set that value deliberately. CloudFormation deletes a removed resource unless you set a `DeletionPolicy` of `Retain`, so a stack configured to detach produces the opposite outcome from the one an AWS architect expects. Deployment stacks also support deny settings, which block changes to managed resources in a way that resembles the behavior of CloudFormation stack policies.

## Tagging

Tagging, in both Azure and AWS, enables you to organize and manage resources effectively by assigning metadata to the resources. Tags are key-value pairs that help you categorize, track, and manage costs across your cloud infrastructure. Both AWS and Azure support attribute-based access control (ABAC) based on tag values. Although Azure and AWS tagging are similar, there are some differences:

- Azure tag *names* are case-insensitive for operations, although the resource provider might preserve the casing that you supply. Azure tag *values* are case-sensitive. AWS treats both tag keys and values as case-sensitive.
- Neither platform automatically propagates tags from a parent to its children. Azure resources don't inherit tags from a resource group or subscription, but you can enforce inheritance by using [Azure Policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies). AWS doesn't natively support tag inheritance between parent and child resources, although it does support inheritance for AWS Cost Categories.
- AWS provides a tag editor tool for adding tags, whereas Azure provides tagging capabilities via the Azure portal and management interfaces.

Azure applies the following limits:

- Each resource, resource group, and subscription supports a maximum of 50 tag name-value pairs. Some resource types support only 15.
- Tag names are limited to 512 characters and tag values to 256 characters. For storage accounts, tag names are limited to 128 characters.
- You can tag resources, resource groups, and subscriptions, but not management groups.

> [!WARNING]
> Azure stores tags as plain text, so don't put sensitive values in them. Tag values can surface in cost reports, deployment history, exported templates, and monitoring logs.

For the full set of conditions and limitations, see [Use tags to organize your Azure resources and management hierarchy](/azure/azure-resource-manager/management/tag-resources).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Srinivasaro Thumala](https://www.linkedin.com/in/srini-thumala/) | Senior Customer Engineer

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | Director, Partner Technology Strategist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure resource group guidelines](/azure/azure-resource-manager/management/overview)
- [Deploy resources with ARM templates and Azure portal](/azure/azure-resource-manager/templates/deploy-portal)

## Related resources

- [Compare AWS and Azure accounts](accounts.md)
- [Compare AWS and Azure networking options](networking.md)
