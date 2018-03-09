---
title: "Explainer: Administrative accounts and roles in Azure"
description: Explains how administrative accounts and roles work in Azure
author: alexbuckgit
---

# Explainer: Administrative accounts and roles in Azure

Azure uses several different types of accounts and roles to manage privileges in Azure:
    - Subscription administrators
    - Azure AD directory roles
    - Role-based access control (RBAC) roles

This article will help you distinguish between each of these roles and understand how to use accounts and roles to secure your Azure resources.

## Subscription administrators

When you create an Azure subscription, you specify an **account** to associate with the subscription. This account is assigned as the **Account Administrator** for the subscription. The Account Administrator is a property of the subscription, and indicates who is responsible for ensuring payment for subscription usage.

Before Azure supported role-based access control (RBAC), the **Service Administrator** for a subscription defined what account had full administrative privileges for all resources in the subscription. Other accounts designated as **co-administrators** also had full control over those resources. While these ["classic deployment model"](/azure/azure-resource-manager/resource-manager-deployment-model) resources can still exist in an Azure subscription, using these resources is now strongly discouraged. Instead, you should use RBAC roles to control access to your Azure resources.

## Azure AD directory roles 

Directory roles determine the permissions an account has to manage Azure AD resources in your tenant. A user account in an Azure AD tenant is assigned to one of three top-level **directory role** categories.
    - **User**. An account with no administrative privileges for the directory.
    - **Global Administrator**. An account with full administrative privileges for the directory.
    - **Limited Administator**. An account that are assigned one or more **administrative roles** for the directory.

When you create a subscription, a new Azure AD tenant is created. A new user is created in the Azure AD tenant, and this user is automatically assigned to the Global Administrator directory role. If you [change your subscription to a different tenant](/azure/active-directory/active-directory-how-subscriptions-associated-directory), the assigned account may have more limited directory role in that tenant.

## Role-based access control (RBAC) roles

Azure provides a [role-based access control (RBAC)](/azure/active-directory/role-based-access-control-what-is) model with [built-in roles](/azure/active-directory/role-based-access-built-in-roles) for managing Azure resources. You can assign users to RBAC roles at the subscription, resource group, or resource level.

When an Azure subscription is created, the account you assigned as the Account Administrator is also assigned as an **Owner** at the subscription level. "Owner" is an RBAC role that grants full permissions to manage resources at the assigned scope.

> [!NOTE] 
> A subscription belongs to exactly one Azure AD tenant to provide digital identity for accessing Azure resources. Each Azure AD tenant has a dedicated, trusted Azure AD directory. (The terms _tenant_, _Azure AD_, and _Azure AD directory_ are often used interchangeably.) Azure AD stores the accounts that will access your resources.

## Enterprise roles

Subscriptions enrolled under an Enterprise Agreement add several additional administrative roles, such as Enterprise Administrator, Department Administrator, and Account Owner. Enterprise management of Azure subscriptions is discussed later in this guide.

## Recommendations

- Administrative accounts need to be associated with a monitored mailbox to receive enrollment and account notifications.
- Don't add co-administrators to your subscription if you haven't deployed any classic resources.
- Minimize the number of accounts assigned to the Owner role in a subscription.
- Use groups to collect users, then assign roles to groups.
- Use [Azure AD Connect](/azure/active-directory/connect/active-directory-aadconnect) to integrate your Azure AD tenant with your on-premises directories.
- Use [Azure Multi-Factor Authentication (MFA)](/azure/multi-factor-authentication/multi-factor-authentication), especially for privileged accounts.

## Next steps

Review the following articles for more information on Azure accounts and roles.
- [Understand Azure identity solutions](/azure/active-directory/understand-azure-identity-solutions)
- [Subscriptions: Administrator accounts in your Azure subscription](/azure/billing/billing-add-change-azure-subscription-administrator)
- [Azure AD: Administrator roles in your Azure AD directory](/azure/active-directory/active-directory-assign-admin-roles-azure-portal)
- [Azure AD: Managing access to Azure resources](/azure/active-directory/manage-access-to-azure-resources)
