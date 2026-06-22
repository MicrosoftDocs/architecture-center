---
title: Compare AWS and Azure Accounts
description: Learn the differences between Azure and AWS accounts and subscriptions. Understand the types of administrator accounts in Azure.
author: juanosorioms
ms.author: jcosorio
ms.date: 04/28/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
---

# Compare AWS and Azure accounts

This article compares the account and organizational structures of Azure and Amazon Web Services (AWS).

For links to articles that compare other AWS and Azure services, and for a complete service mapping between AWS and Azure, see [Azure for AWS professionals](/azure/architecture/aws-professional/).

## Managing account hierarchy

A typical AWS environment uses an organizational structure like the one in the following diagram. There's an organization root and optionally a dedicated AWS management account. Under the root are organizational units that can be used to apply different policies to different accounts. AWS resources often use an AWS account as a logical and billing boundary.

:::image type="complex" source="../aws-professional/images/aws-accounts.jpg" lightbox="../aws-professional/images/aws-accounts.jpg" alt-text="Diagram of a typical AWS account organizational structure." border="false":::
   Diagram that shows an AWS account. There's an organization root and an optional AWS management account. Under the organization root, there are organizational units. Under the organizational units, there are AWS accounts and resources. 
:::image-end:::

Azure follows a similar structure, but instead of a dedicated management account, you centralize administration at the tenant level. This design eliminates the need for an entire account just for management. Unlike AWS, Azure uses resource groups as a fundamental unit. You must assign resources to resource groups, and you can apply permissions at the resource-group level.

:::image type="complex" source="../aws-professional/images/azure-accounts.jpg" lightbox="../aws-professional/images/azure-accounts.jpg" alt-text="Diagram of a typical Azure account management structure." border="false":::
   Diagram that shows the Azure account hierarchy. It flows from tenant to management groups to subscriptions to resource groups to resources.
:::image-end:::

## AWS management account vs. Azure tenant

When you create an Azure account, you also create a Microsoft Entra tenant. You can manage your users, groups, and applications in this tenant. You create Azure subscriptions under the tenant. This tenant provides identity and access management. It helps ensure that authenticated and authorized users can access only the resources for which they have permissions.

## AWS accounts vs. Azure subscriptions

In Azure, the equivalent of an AWS account is the Azure subscription. Azure subscriptions are logical units of Azure services that are linked to an Azure account in a Microsoft Entra tenant. Each subscription is linked to a billing account and provides the boundary within which resources are created, managed, and billed. Subscriptions are important for understanding cost allocation and adhering to budget limits. They help ensure that every service used is tracked and billed correctly. Azure subscriptions, like AWS accounts, also act as boundaries for resource quotas and limits. Some resource quotas are adjustable, but others aren't.

In AWS, cross-account resource access lets one AWS account access or manage resources that belong to another AWS account. AWS also has IAM roles and resource-based policies for accessing resources across accounts. In Azure, you can grant access to users and services in different subscriptions by using Azure role-based access control (Azure RBAC), which you apply at different scopes (management group, subscription, resource group, or individual resources).

## AWS OUs vs. Azure management groups

In Azure, the equivalent of AWS organizational units (OUs) is management groups. Both are used to organize and manage cloud resources at a high level across multiple accounts or subscriptions. You can use Azure management groups to efficiently manage access, policies, and compliance for Azure subscriptions. The governance conditions applied at the management-group level cascade to all associated subscriptions via inheritance. 

Consider these important facts about management groups and subscriptions:

- A single Microsoft Entra tenant can support up to 10,000 management groups.

- In a management group hierarchy, up to six management group levels can exist below the root management group.

- Each management group and subscription can have only one parent. 

- Each management group can have multiple children. 

- A single hierarchy in each Microsoft Entra tenant contains all management groups and subscriptions.

- The number of subscriptions per management group is unlimited. 

The root management group is the top-level management group for each Microsoft Entra tenant. All other management groups and subscriptions are subordinates of the root management group. You can use the root management group to implement global policies and Azure role assignments at the tenant level.

## Service control policies vs. Azure Policy

In AWS, service control policies (SCPs) centrally cap the maximum permissions available to IAM users and roles across member accounts in an AWS organization. You can attach SCPs to the organization root, OUs, or individual member accounts, but they don't apply to the management account. SCPs never grant permissions by themselves. They act as guardrails that filter what identity-based or resource-based policies can ultimately allow.

In Azure, you implement permission boundaries by using Azure RBAC assignments and Azure Policy. You can apply these boundaries at the management group, subscription, resource group, or individual resource scope.

## Comparison of the structure and ownership of AWS accounts with Azure subscriptions

An Azure account represents a billing relationship, and Azure subscriptions help you organize access to Azure resources. Access to an Azure subscription is managed through two complementary systems:

- **Billing roles**, which manage the billing relationship and are defined by your billing account type (Microsoft Customer Agreement, Enterprise Agreement, or Microsoft Online Services Program). The primary billing role is the billing account administrator (historically called Account Administrator), who can create and cancel subscriptions, update payment methods, and transfer billing ownership.
- **Azure RBAC**, which manages access to Azure resources. Microsoft recommends Azure RBAC for all resource access management. Common built-in roles include Owner, Contributor, and Reader, which you can assign at the management group, subscription, resource group, or resource scope.

> [!IMPORTANT]
> The classic subscription administrator roles (Service Administrator and Co-Administrator) were retired on August 31, 2024, along with Azure Service Manager and Azure classic resources. If any subscription still has active classic administrator assignments, convert them to Azure RBAC immediately. For more information, see [Azure classic subscription administrators](/azure/role-based-access-control/classic-administrators).

Below the subscription level, you can also assign roles and permissions directly to specific resources, similar to how permissions are granted to IAM users and groups in AWS. In Azure, user accounts are either personal Microsoft accounts (such as Outlook.com, Hotmail, or Xbox identities) or work or school accounts managed through Microsoft Entra ID.

Like AWS accounts, subscriptions have default service quotas and limits. For a full list of these limits and information about how to increase them, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Srinivasaro Thumala](https://www.linkedin.com/in/srini-thumala/) | Senior Customer Engineer

Other contributors:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | Director, Partner Technology Strategist
- [Juan Carlos Osorio](https://www.linkedin.com/in/juan-carlos-osorio-6252bba7/) | Senior CSA AI & Apps 

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure roles, Microsoft Entra roles, and classic subscription administrator roles](/azure/role-based-access-control/rbac-and-directory-admin-roles)
- [Add or change Azure subscription administrators](/azure/billing/billing-add-change-azure-subscription-administrator)
- [Download or view your Azure billing invoice](/azure/billing/billing-download-azure-invoice-daily-usage-date)

## Related resources

- [Compare AWS and Azure networking options](networking.md)
- [Compare AWS and Azure resource management](resources.md)
