---
title: Azure fundamental concepts
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn fundamental concepts and terms used in Azure, and how these concepts relate to one another.
author: alexbuckgit
ms.author: abuck
ms.date: 05/20/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Azure fundamental concepts

Learn fundamental concepts and terms used in Azure. Also learn how these concepts relate to one another.

## Azure terminology

The following definitions will help as you begin your Azure adoption.

- A **resource** is an entity managed by Azure. Examples include Azure virtual machines, virtual networks, or storage accounts.
- A **subscription** is a logical container for your resources. Each Azure resource is associated with exactly one subscription. Creating a subscription is the first step in adopting Azure.
- An **account** is an email address that you provide when you create an Azure subscription. The associated party is responsible for the monthly costs incurred by the resources in the subscription. When you create an account, you provide contact information along with billing details such as a credit card. An Azure account can be associated with multiple subscriptions.
- **Azure Active Directory** (Azure AD) is Microsoft’s cloud-based identity and access management service. Azure AD allows your employees to sign in and access resources.
- An **Azure AD tenant** is a dedicated and trusted instance of Azure AD that's automatically created when your organization first signs up for a Microsoft cloud service subscription, such as Microsoft Azure, Microsoft Intune, or Office 365. An Azure tenant represents a single organization.
- Each Azure AD tenant has a single dedicated and trusted **Azure AD directory**. The directory includes the tenant's users, groups, and apps and is used to perform identity and access management functions for tenant resources. Multiple subscriptions can be associated to the same directory, but each subscription is associated to a single directory.
- **Resource groups** are logical containers to group related resources within a subscription. Each resource can only exist in one resource group.
- **Management groups** are logical containers for one or more subscriptions. You can define a hierarchy of management groups, subscriptions, resource groups, and resources to enable efficient management of access, policies, and compliance through inheritance.
- A **region** is a set of Azure datacenters deployed within a latency-defined perimeter and connected through a dedicated regional low-latency network. Most Azure resources run in a specific Azure region.

## The purposes of Azure subscriptions

An Azure subscription serves several purposes:

- **A legal agreement.** Each subscription is associated with an [Azure offer](https://azure.microsoft.com/support/legal/offer-details) (such as a Free Trial or Pay-As-You-Go). Each offer has a specific rate plan, benefits, and associated terms and conditions. You choose an Azure offer when you create a subscription.
- **A payment agreement.** When you create a subscription, you provide payment information for that subscription such as a credit card number. Each month, the costs incurred by the resources deployed to that subscription are calculated and billed via that payment method.
- **A boundary of scale.** Scale limits are defined that a subscription’s resources cannot exceed. For example, there is limit to the number of virtual in a single subscription.
- **An administrative boundary.** A subscription can act as a boundary for administration, security, and policy. Azure also provides other mechanisms to meet these needs, such as management groups, resource groups, and role-based access control.

## Considerations when creating an Azure subscription

When you create an Azure subscription, you will make several key choices about the subscription.

- **Who is responsible for paying for the subscription?** The email address you provide is assigned as the subscription’s **account administrator**. The party associated with this email address is responsible for paying for all costs incurred by the subscription’s resources.
- **Which Azure offer am I interested in?** Each subscription is associated with a particular [Azure offer](https://azure.microsoft.com/support/legal/offer-details). You can choose the Azure offer that best meets your needs. For example, if you intend to use a subscription to run preproduction workloads, you could choose the Dev/Test offer or the Enterprise Dev/Test offer.

> [!NOTE]
> When you sign up for Azure, you may see phrases such as "create an Azure account". More specifically, these refer to creating an Azure subscription and associating it with the account you provide.

## Azure administrative roles

Azure defines three types of roles for administering subscriptions, identities, and resources:

- Classic subscription administrator roles.
- Azure role-based access control (RBAC) roles.
- Azure Active Directory (Azure AD) administrator roles.

When you create an Azure subscription, the account used is assigned as Account Administrator for the subscription. The Account Administrator is the billing owner of the subscription and can administer the subscription details via the [Azure Account Center](https://account.azure.com/Subscriptions).

By default, the account used is also assigned as the Service Administrator for the subscription. The Service Administrator has permissions equivalent to the RBAC-based Owner role for the subscription and has full access to the Azure portal. The Account Administrator can change the Service Administrator to a different account.

When you create a subscription, you can associate it with an existing Azure AD tenant. Otherwise, the process creates a new Azure AD tenant with an associated directory. The account used is assigned to the Global Administrator role in the directory.

An account can be associated with multiple Azure subscriptions. The Account Administrator can transfer a subscription to another account.

For a detailed explanation of the different roles defined in Azure, see [Classic subscription administrator roles, Azure RBAC roles, and Azure AD administrator roles](/azure/role-based-access-control/rbac-and-directory-admin-roles).

## Subscriptions and regions

Every Azure resource is logically associated with exactly one subscription. When you create a resource, you will choose which Azure subscription to deploy that resource to. Resources can be moved to other subscriptions later.

A subscription is not tied to a specific Azure region. However, each Azure resource is deployed to a single region. You can have resources in multiple regions associated with a single subscription.

> [!NOTE]
> Most types of Azure resources are deployed to a specific region. However, certain resource types are considered global resources, such as Azure policies.

## Related resources

The following resources provide detailed information about the concepts discussed in this article.

- [How does Azure work?](/azure/architecture/cloud-adoption/getting-started/what-is-azure)
- [Resource access management in Azure](/azure/architecture/cloud-adoption/getting-started/azure-resource-access)
- [Azure Resource Manager overview](/azure/azure-resource-manager/resource-group-overview)
- [Role-based access control (RBAC) for Azure resources](/azure/role-based-access-control/overview)
- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [Associate or add an Azure subscription to your Azure Active Directory tenant](/azure/active-directory/fundamentals/active-directory-how-subscriptions-associated-directory)
- [Topologies for Azure AD Connect](/azure/active-directory/hybrid/plan-connect-topologies)
- [Subscriptions, licenses, accounts, and tenants for Microsoft's cloud offerings](/office365/enterprise/subscriptions-licenses-accounts-and-tenants-for-microsoft-cloud-offerings)

## Next steps

Now that you understand fundamental Azure concepts, let’s discuss [scaling with multiple Azure subscriptions](./scaling-subscriptions.md).

> [!div class="nextstepaction"]
> [Scaling with multiple Azure subscriptions](./scaling-subscriptions.md)
