---
title: Organize your Azure resources effectively | Microsoft docs
description: Best practices to effectively organize your Azure management environment 
author: laraaleite 
ms.author: laleite
ms.date: 4/4/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: fasttrack, new
---
# Organize your Azure resources

Use the following features and best practices to secure resources that are critical to your system, and tag resources so you can track them by values that make sense to your organization.

# [Azure management groups and hierarchy](#tab/AzureManagmentGroupsAndHierarchy)

Azure provides four levels of management: management groups, subscriptions, resource groups, and resources. The following image shows the relationship of these levels.

![Diagram that shows relationship of management hierarchy](./media/organize-resources/scope-levels.png)

- **Management groups**: These are containers that help you manage access, policy, and compliance across multiple subscriptions. All subscriptions within a management group automatically inherit the conditions applied to the management group.
- **Subscriptions**: A subscription groups together user accounts and the resources that have been created by those user accounts. For each subscription, there are limits or quotas on the amount of resources you can create and use. Organizations can use subscriptions to manage costs and the resources that are created by users, teams, or projects.
- **Resource groups**: A resource group is a logical container into which Azure resources like web apps, databases, and storage accounts are deployed and managed.
- **Resources**: Resources are instances of services that you create like virtual machines, storage, or SQL databases.

## Scope of management settings

You can apply management settings, like policies and role-based access controls, at any of the management levels. The level you select determines how widely the setting is applied. Lower levels inherit settings from higher levels. For example, when you apply a policy to a subscription, that policy is also applied to all resource groups and resources within that subscription.

Usually, it makes sense to apply critical settings at higher levels and project-specific requirements at lower levels. For example, you may want to make sure all resources for your organization are deployed to certain regions. To do that, apply a policy to the subscription that specifies the allowed locations. As other users in your organization add new resource groups and resources, the allowed locations are automatically enforced. Learn more about policies in the governance, security, and compliance section of this playbook.

As you plan your compliance strategy, we recommend you work with people in your organization with the roles: security and compliance, IT administration, enterprise architect, networking, finance, and procurement.

::: zone target="docs"

## Create a management level

You can create a management group, additional subscriptions, or resource groups.

### Create management group

To create a management group,

1. Go to [Management Groups](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade).
2. Select **Add management group**.

### Create subscription

To create an additional subscriptions,

1. Go to [Subscriptions](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade).
1. Select **Add**.

### Create resource group

To create a resource group, 
1. Go to [Resource Groups](https://portal.azure.com/#create/Microsoft.ResourceGroup).
1. Select **Add**.
1. Type **resource group name**.
1. Select the **Subscription** that you want your resource group created under.
1. Select **Resource group location**.

## Learn more

To learn more, see:

- [Understanding resource access management in Azure](/azure/architecture/cloud-adoption-guide/adoption-intro/azure-resource-access)
- [Organize your resources with Azure Management Groups](/azure/azure-resource-manager/management-groups-overview)
- [Subscription service limits](/azure/azure-subscription-service-limits)

::: zone-end

::: zone target="chromeless"

## Actions

**Create a management group**

To create a management group,

1. Go to **Management groups**.
1. Select **Add management group**.

::: form action="OpenBlade[#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade]" submitText="Go to Management groups" :::

**Create an additional subscription**

To create an additional subscription,

1. Go to **Subscriptions**.
1. Select **Add** in the top left corner.

::: form action="OpenBlade[#blade/Microsoft_Azure_Billing/SubscriptionsBlade]" submitText="Go to Subscriptions" :::

**Create a resource group**

To create a resource group,

1. Go to **Resource Groups**.
1. Select **Add**.
1. Type **resource group name**.
1. Select the **Subscription** that you want your resource group created under.
1. Select **Resource group location**.

::: form action="Create[#create/Microsoft.ResourceGroup]" submitText="Create a resource group" :::

::: zone-end

# [Naming standards](#tab/NamingStandards)

Well-designed naming standards allow you to identify resources in the portal, on a bill, and within scripts. Most likely, you already have naming standards for your on-premises infrastructure. When adding Azure to your environment, you should extend those naming standards to your Azure resources. Naming standard facilitate more efficient management of the environment at all levels. You can use Azure Policy as a tool to enforce naming standards across your entire Azure environment.

The [](/azure/architecture/best-practices/naming-conventions) guidance provides general recommendations on naming conventions as well as discussions of naming limitations and platform rules. The discussion extends beyond the generic guidance with more detailed recommendations aimed specifically at supporting enterprise cloud adoption efforts in the [CAF: Recommended naming and tagging conventions](../ready/considerations/naming-and-tagging).

When constructing your naming convention, you need to identify the key pieces of information that you want to reflect in a resource name. Different information will be relevant for different resource types, but the following list provides examples of information that are useful when constructing resource names.

Note: Keep the length of naming components short to prevent exceeding resource name length limits.

| Naming component           | Description                                                                                                                                                                                          | Examples                                         |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------|
| Business unit              | Top-level division of your company that owns the subscription or workload the resource belongs to. In smaller organizations, this may represent a single corporate top-level organizational element. | *fin*, *mktg*, *product*, *it*, *corp*           |
| Subscription type          | Summary description of the purpose of the subscription containing the resource. Often broken down by deployment environment type or specific workloads.                                              | *prod,* s*hared, client*                         |
| Application / Service name | Name of the application, workload, or service that the resource is a part of.                                                                                                                        | *navigator*, *emissions*, *sharepoint*, *hadoop* |
| Deployment environment     | The stage of the workload's development lifecycle that the resource is supporting.                                                                                                                   | *prod, dev, qa, stage, test*                     |
| Region                     | Azure region where the resource is deployed.                                                                                                                                                         | *westus, eastus2, westeurope, usgovia*           |


## Sample naming convention

The following section provides examples of naming schemes for common Azure resource types deployed during an enterprise cloud deployment.

### Subscriptions

| Asset type   | Scope                        | Format                                             | Examples                                     |
|--------------|------------------------------|----------------------------------------------------|----------------------------------------------|
| Subscription | Account/Enterprise Agreement | \<Business Unit\>-\<Subscription type\>-\<\#\#\#\> | <ul><li>mktg-prod-001 </li><li>corp-shared-001 </li><li>fin-client-001</li></ul> |

### Resource groups 

| Asset type     | Scope        | Format                                                     | Examples                                                                            |
|----------------|--------------|------------------------------------------------------------|-------------------------------------------------------------------------------------|
| Resource Group | Subscription | rg-\<App / Service name\>-\<Subscription type\>-\<\#\#\#\> | <ul><li>rg-mktgsharepoint-prod-001 </li><li>rg-acctlookupsvc-share-001 </li><li>rg-ad-dir-services-shared-001</li></ul> |

### Virtual Networking

| Asset type               | Scope           | Format                                                                | Examples                                                                                              |
|--------------------------|-----------------|-----------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| Virtual Network          | Resource group  | vnet-\<Subscription type\>-\<Region\>-\<\#\#\#\>                      | <ul><li>vnet-shared-eastus2-001 </li><li>vnet-prod-westus-001 </li><li>vnet-client-eastus2-001</li></ul>                                  |
| Vnet virtual gateway     | Virtual network | vnet-gw-v-\<Subscription type\>-\<Region\>-\<\#\#\#\>                 | <ul><li>vnet-gw-v-shared-eastus2-001 </li><li>vnet-gw-v-prod-westus-001 </li><li>vnet-gw-v-client-eastus2-001</li></ul>                   |
| Vnet local gateway       | Virtual gateway | vnet-gw-l-\<Subscription type\>-\<Region\>-\<\#\#\#\>                 | <ul><li>vnet-gw-l-shared-eastus2-001 </li><li>vnet-gw-l-prod-westus-001 </li><li>vnet-gw-l-client-eastus2-001</li></ul>                   |
| Site to site connections | Resource group  | cn-\<local gateway name\>-to-\<virtual gateway name\>                 | <ul><li>cn-l-gw-shared-eastus2-001-to-v-gw-shared-eastus2-001 </li><li>cn-l-gw-shared-eastus2-001-to-shared-westus-001</li></ul> |
| VNet Connections         | Resource group  | cn-\<subscription1\>\<region1\>-to-\<subscription2\>\<region2\>-      | <ul><li>cn-shared-eastus2-to-shared-westus </li><li>cn-prod-eastus2-to-prod-westus</li></ul>                                     |
| Subnet                   | Virtual network | snet-\<subscription\>-\<sub-region\>-\<\#\#\#\>                       | <ul><li>snet-shared-eastus2-001 </li><li>snet-prod-westus-001 </li><li>snet-client-eastus2-001</li></ul>                                  |
| NSG                      | Subnet or NIC   | nsg-\<policy name or appname\>-\<\#\#\#\>                             | <ul><li>nsg-weballow-001 </li><li>nsg-rdpallow-001 </li><li>nsg-sqlallow-001 </li><li>nsg-dnsbloked-001</li></ul>                                  |
| Public IP                | Resource group  | pip-\<vm name or app name\>-\<Environment\>-\<sub-region\>-\<\#\#\#\> | <ul><li>pip-dc1-shared-eastus2-001 </li><li>pip-hadoop-prod-westus-001</li></ul>                                                 |

### Virtual Machines

| Asset type         | Scope          | Format                                                              | Examples                                                                             |
|--------------------|----------------|---------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| Virtual Machine    | Resource group | vm\<policy name or appname\>\<\#\#\#\>                              | <ul><li>vmnavigator001 </li><li>vmsharepoint001 </li><li>vmsqlnode001 </li><li>vmhadoop001</li></ul>                              |
| VM Storage account | Global         | stvm\<performance type\>\<appname or prodname\>\<region\>\<\#\#\#\> | <ul><li>stvmstcoreeastus2001 </li><li>stvmpmcoreeastus2001 </li><li>stvmstplmeastus2001 </li><li>stvmsthadoopeastus2001</li></ul> |
| DNS Label          | Global         | \<A record of vm\>.[\<region\>.cloudapp.azure.com]                  | <ul><li>dc1.westus.cloudapp.azure.com </li><li>web1.eastus2.cloudapp.azure.com</li></ul>                        |
| Load Balancer      | Resource group | lb-\<app name or role\>\<Environment\>\<\#\#\#\>                    | <ul><li>lb-navigator-prod-001 </li><li>lb-sharepoint-dev-001</li></ul>                                          |
| NIC                | Resource group | nic-\<\#\#\>-\<vmname\>-\<subscription\>\<\#\#\#\>                  | <ul><li>nic-01-dc1-shared-001 </li><li>nic-02-vmhadoop1-prod-001 </li><li>nic-02-vmtest1-client-001</li></ul>            |

### PaaS Services

| Asset type     | Scope  | Format                                                              | Examples                                                                                 |
|----------------|--------|---------------------------------------------------------------------|------------------------------------------------------------------------------------------|
| App Service    | Global | azapp-\<App Name\>-\<Environment\>-\<\#\#\#\>.[{azurewebsites.net}] | <ul><li>azapp-navigator-prod-001.azurewebsites.net </li><li>azapp-accountlookup-dev-001.azurewebsites.net</li></ul> |
| Function App   | Global | azfun-\<App Name\>-\<Environment\>-\<\#\#\#\>.[{azurewebsites.net}] | <ul><li>azfun-navigator-prod-001.azurewebsites.net </li><li>azfun-accountlookup-dev-001.azurewebsites.net</li></ul> |
| Cloud Services | Global | azcs-\<App Name\>-\<Environment\>-\<\#\#\#\>.[{cloudapp.net}]       | <ul><li>azcs-navigator-prod-001.azurewebsites.net </li><li>azcs-accountlookup-dev-001.azurewebsites.net</li></ul>   |

Additional sample naming conventions can be found in [Azure Architecture Center's naming conventions for Azure resources](/azure/architecture/cloud-adoption/ready/considerations/naming-and-tagging#sample-naming-convention)

In general, avoid having any special characters (`-` or `_`) as the first or last character in any name. These characters cause most validation rules to fail.

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Resource group |Subscription |1-90 |Case insensitive |Alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters |`<service short name>-<environment>-rg` |`profx-prod-rg` |
|Availability set |Resource group |1-80 |Case insensitive |Alphanumeric, underscore, and hyphen |`<service-short-name>-<context>-as` |`profx-sql-as` |
|Tag |Associated entity |512 (name), 256 (value) |Case insensitive |Alphanumeric |`"key" : "value"` |`"department" : "Central IT"` |

# [Resource tags](#tab/ResourceTags)

Tags are useful to quickly identify your resources and resource groups. You apply tags to your Azure resources to logically organize them by categories. Each tag consists of a name and a value. For example, you can apply the name "Environment" and the value "Production" to all the resources in production.

After you apply tags, you can retrieve all the resources in your subscription with that tag name and value. Tags allow you to retrieve related resources from different resource groups which is helpful for organizing resources for billing or management.

You can also use tags for many other things. Common uses include:

- **Metadata / documentation**: Administrators can easily see detail about the resources they are working on like "ProjectOwner".
- **Automation**: You may have regularly running scripts that can take an action based on a tag value like "ShutdownTime" or "DeprovisionDate".
- **Billing**: Tags can appear on your invoice. So you can use them to help segment your bill like "CostCenter"  or "BillTo".

Each resource or resource group can only have a maximum of 15 tag name/value pairs. But this limitation only applies to tags directly applied to the resource group or resource.

For further information on tagging refer to [Azure Architecture Center's naming conventions for Azure resources](/azure/architecture/cloud-adoption/ready/considerations/naming-and-tagging#metadata-tags)

::: zone target="docs"

## Apply a resource tag

To apply a tag to a resource group,

1. Go to [Resource Groups](https://portal.azure.com/#blade/HubsExtension/Resources/resourceType/Microsoft.Resources%2Fsubscriptions%2FresourceGroups).
1. Select on a resource group.
1. Select **Tags**.
1. Type in a new name and value or select a existing name and value.

## Learn more

To learn more, see [Use tags to organize your Azure resources](/azure/azure-resource-manager/resource-group-using-tags).

::: zone-end

::: zone target="chromeless"

## Action

**Apply a resource tag**

To apply a tag to a resource group,

1. Go to **Resource Groups**.
1. Select on a resource group.
1. Select **Tags**.
1. Type in a new name and value or select a existing name and value.
 
::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Resources%2Fsubscriptions%2FresourceGroups]" submitText="Go to resource groups" :::

::: zone-end
