---
title: Organize your Azure resources effectively
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Best practices to effectively organize your Azure resources for ease of management.
author: laraaleite
ms.author: kfollis
ms.date: 04/09/2019
ms.topic: conceptual
ms.service: cloud-adoption-framework
ms.subservice: ready
ms.custom: fasttrack-edit, AQC
ms.localizationpriority: high
---

# Organize your Azure resources

Organizing your cloud-based resources is critical to securing, managing, and tracking the costs related to your workloads. To organize your resources, use the management hierarchies within the Azure platform, implement well-thought-out naming conventions, and apply resource tagging.

<!-- markdownlint-disable MD024 MD025 -->

# [Azure management groups and hierarchy](#tab/AzureManagmentGroupsAndHierarchy)

Azure provides four levels of management scope: management groups, subscriptions, resource groups, and resources. The following image shows the relationship of these levels.

   ![Diagram that shows relationship of management hierarchy](./media/organize-resources/scope-levels.png)

- **Management groups:** These groups are containers that help you manage access, policy, and compliance for multiple subscriptions. All subscriptions in a management group automatically inherit the conditions applied to the management group.
- **Subscriptions:** A subscription groups together user accounts and the resources that were created by those user accounts. Each subscription has limits or quotas on the amount of resources you can create and use. Organizations can use subscriptions to manage costs and the resources that are created by users, teams, or projects.
- **Resource groups:** A resource group is a logical container into which Azure resources like web apps, databases, and storage accounts are deployed and managed.
- **Resources:** Resources are instances of services that you create, like virtual machines, storage, or SQL databases.

## Scope of management settings

You can apply management settings, like policies and role-based access controls, at any of the management levels. The level you select determines how widely the setting is applied. Lower levels inherit settings from higher levels. For example, when you apply a policy to a subscription, that policy is also applied to all resource groups and resources in that subscription.

Usually, it makes sense to apply critical settings at higher levels and project-specific requirements at lower levels. For example, you might want to make sure all resources for your organization are deployed to certain regions. To do that, apply a policy to the subscription that specifies the allowed locations. As other users in your organization add new resource groups and resources, the allowed locations are automatically enforced. Learn more about policies in the governance, security, and compliance section of this guide.

If you have only a few subscriptions, it's relatively simple to manage them independently. If the number of subscriptions you use increases, consider creating a management group hierarchy to simplify the management of your subscriptions and resources. For more information on how to manage multiple subscriptions, see [scaling with multiple Azure subscriptions](../considerations/scaling-subscriptions.md).

As you plan your compliance strategy, work with people in your organization with these roles: security and compliance, IT administration, enterprise architect, networking, finance, and procurement.

::: zone target="docs"

## Create a management level

You can create a management group, additional subscriptions, or resource groups.

### Create a management group

Create a management group to help you manage access, policy, and compliance for multiple subscriptions.

1. Go to [Management groups](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade).
2. Select **Add management group**.

### Create a subscription

Use subscriptions to manage costs and resources that are created by users, teams, or projects.

1. Go to [Subscriptions](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade).
1. Select **Add**.

### Create a resource group

Create a resource group to hold resources like web apps, databases, and storage accounts that share the same lifecycle, permissions, and policies.

1. Go to [Resource groups](https://portal.azure.com/#create/Microsoft.ResourceGroup).
1. Select **Add**.
1. Select the **Subscription** that you want your resource group created under.
1. Enter a name for the **Resource group**.
1. Select a **Region** for the resource group location.

## Learn more

To learn more, see:

- [Azure fundamentals](../considerations/fundamental-concepts.md)
- [Scaling with multiple Azure subscriptions](../considerations/scaling-subscriptions.md)
- [Understand resource access management in Azure](../../getting-started/azure-resource-access.md)
- [Organize your resources with Azure management groups](/azure/azure-resource-manager/management-groups-overview)
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

1. Go to **Resource groups**.
1. Select **Add**.
1. Select the **Subscription** that you want your resource group created under.
1. Enter a name for the **Resource group**.
1. Select a **Region** for the resource group location.

::: form action="Create[#create/Microsoft.ResourceGroup]" submitText="Create a resource group" :::

::: zone-end

# [Naming standards](#tab/NamingStandards)

A good naming standard helps to identify resources in the Azure portal, on a bill, and in scripts. Your naming strategy should include business and operational details as components of resource names:

- The business-related side of this strategy should ensure that resource names include the organizational information that's needed to identify the teams. Use a resource along with the business owners who are responsible for resource costs.

- The operational side should ensure that names include information that IT teams need. Use the details that identify the workload, application, environment, criticality, and other information that's useful for managing resources.

Different resource types might have different length limits and allowable characters, many of which are listed in the Azure best practices [naming conventions article](/azure/architecture/best-practices/naming-conventions). For more information and recommendations aimed specifically at supporting enterprise cloud adoption efforts, see the Cloud Adoption Framework's [guidance on naming and tagging](../considerations/name-and-tag.md).

The following table includes naming patterns for a few sample types of Azure resources.

::: zone target="docs"

>[!TIP]
>Avoid using any special characters (`-` or `_`) as the first or last character in any name. These characters cause most validation rules to fail.

::: zone-end

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Resource group |Subscription |1-90 |Case insensitive |Alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters |`<service short name>-<environment>-rg` |`profx-prod-rg` |
|Availability set |Resource group |1-80 |Case insensitive |Alphanumeric, underscore, and hyphen |`<service-short-name>-<context>-as` |`profx-sql-as` |
|Tag |Associated entity |512 (name), 256 (value) |Case insensitive |Alphanumeric |`"key" : "value"` |`"department" : "Central IT"` |

# [Resource tags](#tab/ResourceTags)

Tags are useful to quickly identify your resources and resource groups. You apply tags to your Azure resources to logically organize them by categories. Each tag consists of a name and a value. For example, you can apply the name "Environment" and the value "Production" to all the resources in production. Tags should include context about the resource's associated workload or application, operational requirements, and ownership information.

After you apply tags, you can retrieve all the resources in your subscription with that tag name and value. When you organize resources for billing or management, tags can help you retrieve related resources from different resource groups.

You can also use tags for many other things. Common uses include:

- **Metadata and documentation:** Administrators can easily see detail about the resources they're working on by applying a tag like "ProjectOwner."
- **Automation:** You might have regularly running scripts that can take an action based on a tag value like "ShutdownTime" or "DeprovisionDate."
- **Billing:** Tags can appear on your invoice. You can use them to help segment your bill by using tags like "CostCenter" or "BillTo."

Each resource or resource group can have a maximum of 15 tag name and value pairs. This limitation only applies to tags directly applied to the resource group or resource.

For more tagging recommendations and examples, see the Cloud Adoption Framework's [guidance on tagging](../considerations/name-and-tag.md).

::: zone target="docs"

## Apply a resource tag

To apply a tag to a resource group:

1. Go to [Resource groups](https://portal.azure.com/#blade/HubsExtension/Resources/resourceType/Microsoft.Resources%2Fsubscriptions%2FresourceGroups).
1. Select a resource group.
1. Select **Assign tags**.
1. Enter a new name and value, or use the drop-down list to select an existing name and value.

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
1. Enter a new name and value, or select an existing name and value.

::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Resources%2Fsubscriptions%2FresourceGroups]" submitText="Go to resource groups" :::

::: zone-end
