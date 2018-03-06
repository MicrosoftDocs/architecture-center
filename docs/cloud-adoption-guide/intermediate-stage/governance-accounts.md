---
title: "Explainer: Administrative accounts and roles in Azure"
description: Explains how administrative accounts and roles work in Azure
author: alexbuckgit
---

# Explainer: Administrative accounts and roles in Azure

Azure uses several different types of accounts and roles to manage privileges in Azure:
    - Subscription administrators
    - Rold-based access control (RBAC) roles
    - Azure AD directory roles

This article will help you distinguish between each of these roles and understand how to use accounts and roles to secure your Azure resources.

## Subscription administrators

When you create an Azure subscription, you specify an **account** to associate with the subscription. This account is assigned as the **Account Administrator** for the subscription. The Account Administrator is a property of the subscription, and indicates who is responsible for ensuring payment for subscription usage.

> ![NOTE]
> This account is also initially assigned as the Service Administrator for this subscription. Before Azure supported role-based access control (RBAC), the Service Administrator property of a subscription determined who had full privileges to manage Azure resources. This model (now known as the "classic model") also allowed the assignment of subscription co-administrators. Use of classic model resources and permissions is now discouraged; you should use RBAC roles instead to provide access to your Azure resources.

## Role-based access control (RBAC) roles

Azure provides a [role-based access control (RBAC)](/azure/active-directory/role-based-access-control-what-is) model that provides [built-in roles](/azure/active-directory/role-based-access-built-in-roles) for managing Azure resources. You can assign users to RBAC roles at the subscription, resource group, or resource level.

When an Azure subscription is created, the account you assigned as the Account Administrator is also assigned as an **Owner** at the subscription level. "Owner" is an RBAC role that grants full permissions to manage resources at the assigned scope.

> [!NOTE] 
> A subscription trusts exactly one Azure AD tenant to provide digital identity for accessing Azure resources. Each Azure AD tenant has a dedicated, trusted Azure AD directory. (The terms _tenant_, _Azure AD_, and _Azure AD directory_ are often used interchangeably.) Aure AD stores the accounts that will access your resources, as well as the RBAC role assignments for those users.

## Azure AD directory roles 

Directory roles determine what permissions an account has to manage Active Directory resources in your Azure AD tenant. A user account in an Azure AD tenant is assigned to one of three top-level **directory role** categories.
    - **User**. Accounts with no administrative privileges for the directory.
    - **Global Administrator**. Accounts with full administrative privileges for the directory.
    - **Limited Administator**. Accounts that are assigned one or more **administrative roles** for the directory.

When you create a subscription, a new Azure AD tenant is created. A new user is created in the Azure AD tenant, and this user is automatically assigned to the Global Administrator directory role and the RBAC **Owner** role. If you [change your subscription to a different tenant](/azure/active-directory/active-directory-how-subscriptions-associated-directory), the assigned account may have more limited directory role in that tenant.

## Other administrative controls in Azure

Several other capabilities in Azure introduce additional levels of control for Azure resources.
    - Enterprise Agreements allow organizations to define a management hierarchy for their subscriptions. Enterprise management of Azure subscriptions is discussed later in this guide.
    - [Azure AD Privileged Identity Management](/azure/active-directory/active-directory-privileged-identity-management-configure) (available with the Azure Active Directory Premium P2 edition) provides advanced capabilities for [securing privileged access](/azure/active-directory/privileged-identity-management/active-directory-securing-privileged-access) by administrative accounts in Azure.

## Guidance/recommendations

- Administrative accounts need to be associated with a monitored mailbox to receive enrollment and account notifications. You can create distribution lists with matching external SMTP addresses for any service accounts used.
- Avoid deployment or use of classic resources in your subscription.
- Don't add co-administrators to your subscription if you haven't deployed any classic resources.
- Minimize the number of accounts assigned to the Owner role in a subscription. Periodically review and remove account that no longer need the Owner role.
- Periodically remove any deprecated accounts that no longer need access to resources in the subscription.
- Do not grant permissions to external accounts.
- Use groups to collect users, then assign roles to groups.
- Use [Azure AD Connect](/azure/active-directory/connect/active-directory-aadconnect) to integrate your Azure AD tenant with your on-premises directories.
- Use [Azure Multi-Factor Authentication (MFA)](https://docs.microsoft.com/en-us/azure/multi-factor-authentication/multi-factor-authentication), especially for privileged accounts like an Account Admin or a Global Administrator.

## Additional resources / next steps:

- [Understand Azure identity solutions](https://docs.microsoft.com/en-us/azure/active-directory/understand-azure-identity-solutions)
- [Subscriptions: Administrator accounts in your Azure subscription](https://docs.microsoft.com/en-us/azure/billing/billing-add-change-azure-subscription-administrator)
- [Azure AD: Administrator roles in your Azure AD directory](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-assign-admin-roles-azure-portal)
- [Azure AD: Managing access to Azure resources](https://docs.microsoft.com/en-us/azure/active-directory/manage-access-to-azure-resources)
- [Introduction to Azure enterprise and subscription management](https://blogs.msdn.microsoft.com/azureedu/2016/10/29/introduction-to-azure-enterprise-and-subscription-management/)


<!-- links -->
[azure-account-center]: https://account.azure.com/
[azure-portal]: https://portal.azure.com
[azure-change-sa]: /azure/billing/billing-add-change-azure-subscription-administrator
[azure-available-offers]: https://azure.microsoft.com/en-us/support/legal/offer-details/
[azure-change-subscription-offer]: /azure/billing/billing-how-to-switch-azure-offer
[azure-transfer-subscription]: /azure/billing/billing-subscription-transfer
