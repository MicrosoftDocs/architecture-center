---
title: Organize your Azure resources effectively
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Best practices to effectively organize your Azure resources for ease of management.
author: laraaleite
ms.author: kfollis
ms.date: 04/09/2019
ms.topic: conceptual
ms.service: cloud-adoption-framework
ms.subservice: migrate
ms.custom: fasttrack-edit, AQC
ms.localizationpriority: high
---
# Organize your Azure resources

Use the following features and best practices to secure resources that are critical to your system. Tag resources so you can track them by values that make sense to your organization.

<!-- markdownlint-disable MD024 MD025 -->

# [Azure management groups and hierarchy](#tab/AzureManagmentGroupsAndHierarchy)

The organizing structure for resources in Azure has four levels: management groups, subscriptions, resource groups, and resources. The following image shows the relationship of these levels.

![Diagram that shows relationship of management hierarchy](./media/organize-resources/scope-levels.png)

- **Management groups:** These are containers that help you manage access, policy, and compliance for multiple subscriptions. All subscriptions in a management group automatically inherit the conditions applied to the management group.
- **Subscriptions:** A subscription groups together user accounts and the resources that have been created by those user accounts. For each subscription, there are limits or quotas on the amount of resources you can create and use. Organizations can use subscriptions to manage costs and the resources that are created by users, teams, or projects.
- **Resource groups:** A resource group is a logical container into which Azure resources like web apps, databases, and storage accounts are deployed and managed.
- **Resources:** Resources are instances of services that you create, like virtual machines, storage, or SQL databases.

## Scope of management settings

You can apply management settings, like policies and role-based access controls, at any of the management levels. The level you select determines how widely the setting is applied. Lower levels inherit settings from higher levels. For example, when you apply a policy to a subscription, that policy is also applied to all resource groups and resources in that subscription.

Usually, it makes sense to apply critical settings at higher levels and project-specific requirements at lower levels. For example, you may want to make sure all resources for your organization are deployed to certain regions. To do that, apply a policy to the subscription that specifies the allowed locations. As other users in your organization add new resource groups and resources, the allowed locations are automatically enforced. Learn more about policies in the governance, security, and compliance section of this guide.

As you plan your compliance strategy, we recommend you work with people in your organization with these roles: security and compliance, IT administration, enterprise architect, networking, finance, and procurement.

::: zone target="docs"

## Create a management level

You can create a management group, additional subscriptions, or resource groups.

### Create management group

Create a management group to help you manage access, policy, and compliance for multiple subscriptions.

1. Go to [Management Groups](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade).
2. Select **Add management group**.

### Create subscription

Use subscriptions to manage costs and resources that are created by users, teams, or projects.

1. Go to [Subscriptions](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade).
1. Select **Add**.

### Create resource group

Create a resource group to hold resources like web apps, databases, and storage accounts that share the same lifecycle, permissions, and policies.

1. Go to [Resource Groups](https://portal.azure.com/#create/Microsoft.ResourceGroup).
1. Select **Add**.
1. Select the **Subscription** that you want your resource group created under.
1. Enter a name for the **Resource group**.
1. Select a **Region** for the resource group location.

## Learn more

To learn more, see:

- [Understanding resource access management in Azure](../../governance/resource-consistency/azure-resource-access.md)
- [Organize your resources with Azure Management Groups](/azure/azure-resource-manager/management-groups-overview)
- [Subscription service limits](/azure/azure-subscription-service-limits)

::: zone-end

::: zone target="chromeless"

## Actions

**Create a management group:**

Create a management group to help you manage access, policy, and compliance for multiple subscriptions.

1. Go to **Management groups**.
1. Select **Add management group**.

::: form action="OpenBlade[#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade]" submitText="Go to Management groups" :::

**Create an additional subscription:**

Use subscriptions to manage costs and resources that are created by users, teams, or projects.

1. Go to **Subscriptions**.
1. Select **Add**.

::: form action="OpenBlade[#blade/Microsoft_Azure_Billing/SubscriptionsBlade]" submitText="Go to Subscriptions" :::

**Create a resource group:**

Create a resource group to hold resources like web apps, databases, and storage accounts that share the same lifecycle, permissions, and policies.

1. Go to **Resource Groups**.
1. Select **Add**.
1. Select the **Subscription** that you want your resource group created under.
1. Enter a name for the **Resource group**.
1. Select a **Region** for the resource group location.

::: form action="Create[#create/Microsoft.ResourceGroup]" submitText="Create a resource group" :::

::: zone-end

# [Naming standards](#tab/NamingStandards)

A good naming standard helps identify resources in the portal, on a bill, and in scripts. You may already have naming standards for your on-premises infrastructure. When adding Azure to your environment, you should extend those naming standards to your Azure resources. Naming standards help you manage your environment more efficiently at all levels. You can use Azure Policy as a tool to enforce naming standards across your entire Azure environment.

::: zone target="docs"

We recommend you review and adopt the [Patterns and Practices guidance](/azure/architecture/best-practices/naming-conventions).

>[!TIP]
>Avoid using any special characters (`-` or `_`) as the first or last character in any name. These characters cause most validation rules to fail.

::: zone-end

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Resource group |Subscription |1-90 |Case insensitive |Alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters |`<service short name>-<environment>-rg` |`profx-prod-rg` |
|Availability set |Resource group |1-80 |Case insensitive |Alphanumeric, underscore, and hyphen |`<service-short-name>-<context>-as` |`profx-sql-as` |
|Tag |Associated entity |512 (name), 256 (value) |Case insensitive |Alphanumeric |`"key" : "value"` |`"department" : "Central IT"` |

# [Resource tags](#tab/ResourceTags)

Tags are useful to quickly identify your resources and resource groups. You apply tags to your Azure resources to logically organize them by categories. Each tag consists of a name and a value. For example, you can apply the name "Environment" and the value "Production" to all the resources in production.

After you apply tags, you can retrieve all the resources in your subscription with that tag name and value. Tags let you retrieve related resources from different resource groups which is helpful for organizing resources for billing or management.

You can also use tags for many other things. Common uses include:

- **Metadata and documentation:** Administrators can easily see detail about the resources they are working on by applying a tag like "ProjectOwner".
- **Automation:** You may have regularly running scripts that can take an action based on a tag value like "ShutdownTime" or "DeprovisionDate".
- **Billing:** Tags can appear on your invoice. You can use them to help segment your bill by using tags like "CostCenter" or "BillTo".

Each resource or resource group can have a maximum of 15 tag name/value pairs. However, this limitation only applies to tags directly applied to the resource group or resource.

For further information on tagging refer to [Azure Architecture Center's naming conventions for Azure resources](../../ready/considerations/name-and-tag.md#metadata-tags)

::: zone target="docs"

## Apply a resource tag

To apply a tag to a resource group:

1. Go to [Resource groups](https://portal.azure.com/#blade/HubsExtension/Resources/resourceType/Microsoft.Resources%2Fsubscriptions%2FresourceGroups).
1. Select a resource group.
1. Select **Tags**.
1. Enter a new name and value or use the drop-down to select an existing name and value.

## Learn more

To learn more, see [Use tags to organize your Azure resources](/azure/azure-resource-manager/resource-group-using-tags).

::: zone-end

::: zone target="chromeless"

## Action

**Apply a resource tag:**

To apply a tag to a resource group:

1. Go to **Resource groups**.
1. Select a resource group.
1. Select **Tags**.
1. Enter a new name and value or select an existing name and value.

::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Resources%2Fsubscriptions%2FresourceGroups]" submitText="Go to resource groups" :::

::: zone-end
