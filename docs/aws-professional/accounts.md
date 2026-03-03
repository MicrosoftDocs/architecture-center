---
title: Compare AWS and Azure Accounts
description: Learn the differences between Azure and AWS accounts and subscriptions. Understand the types of administrator accounts in Azure.
author: splitfinity81
ms.author: yubaijna
ms.date: 01/02/2025
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - aws-to-azure
---

# Compare AWS and Azure accounts

This article compares the account and organizational structure of Azure with that of Amazon Web Services (AWS).

For links to articles that compare other AWS and Azure services and a complete service mapping between AWS and Azure, see [Azure for AWS professionals](/azure/architecture/aws-professional/).

## Managing account hierarchy

A typical AWS environment uses an organizational structure like the one in the following diagram. There's an organization root and optionally a dedicated AWS management account. Under the root are organizational units that can be used to apply different policies to different accounts. AWS resources often use an AWS account as a logical and billing boundary.

:::image type="complex" source="../aws-professional/images/aws-accounts.jpg" lightbox="../aws-professional/images/aws-accounts.jpg" alt-text="Diagram of a typical AWS account organizational structure." border="false":::
   Diagram that shows an AWS account. There's an organization root and an optional AWS management account. Under the organization root, there are organizational units. Under the organizational units, there are AWS accounts and resources. 
:::image-end:::

An Azure structure looks similar, but, rather than a dedicated management account, it provides administrative permissions on the tenant. This design eliminates the need for an entire account just for management. Unlike AWS, Azure uses resource groups as a fundamental unit. Resources must be assigned to resource groups, and permissions can be applied at the resource-group level.

:::image type="complex" source="../aws-professional/images/azure-accounts.jpg" lightbox="../aws-professional/images/azure-accounts.jpg" alt-text="Diagram of a typical Azure account management structure." border="false":::
   Diagram that shows the Azure account hierarchy. It flows from tenant to management groups to subscriptions to resource groups to resources.
:::image-end:::

## AWS management account vs. Azure tenant

In Azure, when you create an Azure account, a Microsoft Entra tenant is created. You can manage your users, groups, and applications in this tenant. Azure subscriptions are created under the tenant. A Microsoft Entra tenant provides identity and access management. It helps ensure that authenticated and authorized users can access only the resources for which they have permissions.  

## AWS accounts vs. Azure subscriptions

In Azure, the equivalent of an AWS account is the Azure subscription. Azure subscriptions are logical units of Azure services that are linked to an Azure account in a Microsoft Entra tenant. Each subscription is linked to a billing account and provides the boundary within which resources are created, managed, and billed. Subscriptions are important to understanding cost allocation and adhering to budget limits. They help you ensure that every service used is tracked and billed correctly. Azure subscriptions, like AWS accounts, also act as boundaries for resource quotas and limits. Some resource quotas are adjustable, but others aren't.

Cross-account resource access in AWS enables resources from one AWS account to be accessed or managed by another AWS account. AWS also has Identity and Access Management (IAM) roles and resource-based policies for accessing resources across accounts. In Azure, you can grant access to users and services in different subscriptions by using Azure role-based access control (Azure RBAC), which is applied at different scopes (management group, subscription, resource group, or individual resources).  

## AWS OUs vs. Azure management groups

In Azure, the equivalent of AWS organizational units (OUs) is management groups. Both are used to organize and manage cloud resources at a high level across multiple accounts or subscriptions. You can use Azure management groups to efficiently manage access, policies, and compliance for Azure subscriptions. The governance conditions applied at the management-group level cascade to all associated subscriptions via inheritance. 

Important facts about management groups and subscriptions:

- A single directory supports as many as 10,000 management groups. 

- A management group tree supports as many as six levels of depth. 

- Each management group and subscription can have only one parent. 

- Each management group can have multiple children. 

- All subscriptions and management groups are within a single hierarchy in each directory. 

- The number of subscriptions per management group is unlimited. 

The root management group is the top-level management group that's associated with each directory. All management groups and subscriptions roll up to the root management group. This design enables you to implement global policies and Azure role assignments at the directory level.

## Service control policies vs. Azure Policy

The primary goal of service control policies (SCP) in AWS is to limit the maximum effective permissions within an AWS account. In Azure, maximum permissions are defined in Microsoft Entra and can be applied at the tenant, subscription, or resource-group level. Azure Policy has a wide range of use cases, a few of which align with typical SCP usage patterns. You can use both SCPs and Azure policies to enforce compliance with enterprise standards, like tagging or the use of specific SKUs. Both SCPs and Azure policies can block deployment of resources that don't meet compliance requirements. Azure policies can be more proactive than SCPs and can trigger remediations to bring resources into compliance. Azure policies can also assess both existing resources and future deployments.

## Comparison of the structure and ownership of AWS accounts with Azure subscriptions

An Azure account represents a billing relationship, and Azure subscriptions help you organize access to Azure resources. Account Administrator, Service Administrator, and Co-Administrator are the three classic subscription administrator roles in Azure:

- **Account Administrator**. The subscription owner and the billing owner for the resources used in the subscription. The account administrator can only be changed by transferring ownership of the subscription. Only one Account administrator is assigned per Azure Account.

- **Service Administrator**. This user has rights to create and manage resources in the subscription but isn't responsible for billing. By default, for a new subscription, the Account Administrator is also the Service Administrator. The account administrator can assign a separate user to the Service Administrator for managing the technical and operational aspects of a subscription. Only one Service Administrator is assigned per subscription.

- **Co-administrator**. There can be multiple co-administrators assigned to a subscription. Co-administrators have the same access privileges as the Service Administrator, but they can't change the Service Administrator.

Under the subscription level, user roles and individual permissions can also be assigned to specific resources, similarly to how permissions are granted to IAM users and groups in AWS. In Azure, all user accounts are associated with either a Microsoft account or an organizational account (an account managed through Microsoft Entra ID).

Like AWS accounts, subscriptions have default service quotas and limits. For a full list of these limits, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits). These limits can be increased up to the maximum by [filing a support request in the management portal](/archive/blogs/girishp/increasing-core-quota-limits-in-azure).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Srinivasaro Thumala](https://www.linkedin.com/in/srini-thumala/) | Senior Customer Engineer

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | 
Director, Partner Technology Strategist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure roles, Microsoft Entra roles, and classic subscription administrator roles](/azure/role-based-access-control/rbac-and-directory-admin-roles)
- [Add or change Azure subscription administrators](/azure/billing/billing-add-change-azure-subscription-administrator)
- [Download or view your Azure billing invoice](/azure/billing/billing-download-azure-invoice-daily-usage-date)

## Related resources

- [Compare AWS and Azure networking options](networking.md)
- [Compare AWS and Azure resource management](resources.md)
