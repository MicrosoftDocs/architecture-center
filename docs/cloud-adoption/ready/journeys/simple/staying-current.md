---
title: Learn how to stay current with Azure in todays cloud cadence | Microsoft docs
description: Learn how to stay current with Azure in todays cloud cadence.
author: "Jelle Druyts"   
ms.author: jelled
ms.date: 03/12/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack - new"
---
# Manage access to your Azure environment with role-based access controls

Managing access to your Azure resources and subscriptions, who can access what, forms an important part of your Azure governance strategy. Role-based access control (RBAC) is the primary method of managing access in Azure.

RBAC provides fine-grained access management of resources in Azure. It helps you manage who has access to Azure resources, what they can do with those resources, and what scopes they can access.

When planning your access control strategy, grant users the least privilege to get their work done. The following image shows a suggested pattern for assigning RBAC.

![Diagram that shows RBAC roles](./media/manage-access/role-examples.png)

When you plan your access and control methodology, we recommend you work with people in your organizations with the following roles: security and compliance, IT administration, and enterprise architect.

::: zone target="chromeless"

## Actions

**Grant resource group access**

To add a user to a resource group,

1. Go to **Resource Groups**.
2. Select a resource group.
3. Select **Access control (IAM)**.
4. Add a user.

::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Resources%2Fsubscriptions%2FresourceGroups]" submitText="Go to resource groups" ::: form-end

**Grant subscription access**

To add a user to a subscription,

1. Go to **Subscriptions**.
1. Select a subscription.
1. Select **Access control (IAM)**.
1. Add a user.

::: form action="OpenBlade[#blade/Microsoft_Azure_Billing/SubscriptionsBlade]" submitText="Go to subscriptions" ::: form-end

::: zone-end

::: zone target="docs"

## Grant resource group access

To add a user to a resource group,

1. Go to [Resource Group](https://portal.azure.com/#blade/HubsExtension/Resources/resourceType/Microsoft.Resources%2Fsubscriptions%2FresourceGroups).
1. Select a resource group.
1. Select **Access control (IAM)**.
1. Add a user.

## Grant subscription access

To add a user to a subscription,

1. Go to [Subscriptions](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade)
1. Select a subscription.
1. Select **Access control (IAM)**.
1. Add a user.

## Learn more

To learn more, see [What is role-based access control (RBAC)?](/azure/role-based-access-control/overview)

::: zone-end
