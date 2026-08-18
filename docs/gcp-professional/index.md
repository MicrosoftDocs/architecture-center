---
title: Azure for Google Cloud Professionals
description: Learn how Microsoft Azure accounts, services, and resources compare to Google Cloud, and learn the key differences between the two platforms.
author: juanlldc
ms.author: juanll
ms.date: 4/28/2026
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - gcp-to-azure
---

# Azure for Google Cloud professionals

This article helps Google Cloud experts understand the basics of Microsoft Azure accounts, services, and resources. It also covers key similarities and differences between the Google Cloud and Azure platforms.

> [!NOTE]
> Google Cloud was previously known as *Google Cloud Platform (GCP)*.

In this article, you learn:

- How accounts and resources are organized in Azure.
- How available solutions are structured in Azure.
- How the major Azure services differ from Google Cloud services.

Azure and Google Cloud built their capabilities independently over time, so they have significant implementation and design differences.

## Similarities between Azure and Google Cloud

Like Google Cloud, Microsoft Azure is built around a core set of compute, storage, database, and networking services. In many cases, both platforms offer comparable capabilities and support highly available solutions on Linux or Windows hosts. If you're used to development using Linux and open-source software, both platforms can do the job.

Although the platforms share similar capabilities, the resources that provide those capabilities are often organized differently. Direct service-to-service mappings aren't always clear, and some services are available only on one platform.

## Manage accounts and subscriptions

Azure provides a hierarchy of management groups, subscriptions, and resource groups to help you manage resources effectively. This hierarchy is similar to the folders and project structure for resources in Google Cloud. The following diagram shows the hierarchy of management scope in Azure:

:::image type="complex" source="./images/subscription-hierarchy.png" border="false" lightbox="./images/subscription-hierarchy.png" alt-text="Diagram that shows a tree structure with management groups as the root, then subscriptions, then resource groups as leaf nodes.":::
   The tree diagram shows the four-level Azure management hierarchy. At the top sits a single management group labeled corporate IT. Directly below corporate IT, three child management groups branch out horizontally from left to right: production, development, and QA. Connecting lines indicate that policies and access controls defined at the corporate IT level are inherited by all three. Below the production management group, three subscriptions are arranged from left to right: mission critical, protected data, other production. Below the development management group is a single subscription labeled non-production. Below the QA management group is a single subscription labeled staging. At the bottom level, resource groups contain application resources.
:::image-end:::

- **Management groups:** These groups are containers that help you manage access, policy, and compliance for multiple subscriptions. All subscriptions in a management group automatically inherit the conditions applied to the management group.

- **Subscriptions:** A [subscription](/azure/cost-management-billing/manage/cloud-subscription) logically associates user accounts and the resources that those user accounts create. Each subscription has limits or quotas on the number of resources you can create and use. Organizations can use subscriptions to manage costs and the resources that users, teams, or projects create.

    You can create an unlimited number of Azure subscriptions. Each subscription links to a single Microsoft Entra tenant (an *account*, in Google Cloud terms). A tenant can contain an unlimited number of subscriptions, whereas Google Cloud has a default soft limit that varies per account and can be increased through a request.

    A Google Cloud *project* is conceptually similar to the Azure subscription, in terms of billing, quotas, and limits. However, in function, a Google Cloud project more closely resembles an Azure resource group—a logical container into which cloud resources are deployed.

- **Resource groups:** A resource group is a logical container into which you deploy and manage Azure resources like web apps, databases, and storage accounts.

- **Resources:** Resources are instances of services that you create, like virtual machines (VMs), storage, or SQL databases.

Azure offers several purchasing options to fit organizations of different sizes and needs. For more information, see the [pricing overview](https://azure.microsoft.com/pricing).

You manage access to Azure resources through [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/rbac-and-directory-admin-roles), which includes more than 100 built-in roles. You can also create your own custom roles.

Each subscription also has an account administrator, which represents the subscription owner and the account billed for the resources used in the subscription. You can only change the account administrator by transferring ownership of the subscription.

Beneath the subscription level, you can assign user roles and individual permissions to specific resources. In Azure, all user accounts are associated with either a Microsoft Account or Organizational Account (an account managed through Microsoft Entra ID).

Subscriptions have default service quotas and limits. For a full list of these limits, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits). You can increase some of these limits by [filing a support request in the management portal](/azure/azure-resource-manager/troubleshooting/error-resource-quota).

To learn more about managing accounts and subscriptions, see the following resources:

- [Add or change Azure subscription administrators](/azure/billing/billing-add-change-azure-subscription-administrator)
- [Download or view your Azure billing invoice](/azure/billing/billing-download-azure-invoice-daily-usage-date)

## Resource management

In Azure, a resource is any compute instance, storage object, networking device, or other entity that you can create or configure within the platform.

You can deploy and manage Azure resources by using [Azure Resource Manager](/azure/azure-resource-manager/management/overview).

### Resource groups

Azure also provides [resource groups](/azure/azure-resource-manager/management/overview#resource-groups) that organize resources such as VMs, storage, and virtual networking devices. You always associate an Azure resource with one resource group. You can move a resource from one resource group to another, but it can only be in one resource group at a time. For more information, see [Move Azure resources to a new resource group or subscription](/azure/azure-resource-manager/management/move-resource-group-and-subscription). Azure Resource Manager uses resource groups as the fundamental grouping.

You can also organize resources by using [tags](/azure/azure-resource-manager/management/tag-resources). Tags are key-value pairs that you can use to group resources across your subscription regardless of resource group membership.

### Management interfaces

Azure offers several ways to manage your resources:

- [Azure portal](/azure/azure-resource-manager/management/manage-resources-portal): The Azure portal provides a full web-based management interface for Azure resources.
- [REST API](/rest/api/resources): The Azure Resource Manager REST API provides programmatic access to most of the features available in the Azure portal.
- [Command line](/cli/azure/install-azure-cli): The Azure CLI provides a command-line interface capable of creating and managing Azure resources. The Azure CLI is available for [Windows, Linux, and macOS](/cli/azure).
- [PowerShell](/azure/azure-resource-manager/management/manage-resources-powershell): You can use the Azure modules for PowerShell to run automated management tasks by using a script. PowerShell is available for [Windows, Linux, and macOS](/powershell/scripting/install/install-powershell).
- [Templates](/azure/azure-resource-manager/templates/syntax): Azure Resource Manager templates provide template-based resource management capabilities. These templates are typically written in Bicep or Terraform.
- [Azure SDKs](/azure/developer/#azure-sdks): The SDKs are a collection of libraries that you can use to programmatically manage and interact with Azure services.

Across all these interfaces, the resource group is central to creating, deploying, and managing Azure resources.

In addition, many non-Microsoft management tools, like [HashiCorp's Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) and [Spinnaker](https://spinnaker.io), are available on Azure.

## Regions and availability zones

Cloud failures vary widely in scope and severity. Localized hardware failures or configuration problems can affect individual resources or groups of resources in a workload. Less common are failures that disrupt a whole datacenter, such as loss of power in a datacenter. In rare situations, an entire region can become unavailable.

One of the main ways to make an application resilient is through redundancy. However, you need to plan for this redundancy when you design the application. Also, the level of redundancy that you need depends on your business requirements. Not every application needs redundancy across regions to guard against a regional outage. In general, a tradeoff exists between greater redundancy and reliability versus higher cost and complexity.

In Google Cloud, a region has two or more availability zones. An availability zone corresponds with a physically isolated datacenter in the geographic region. Azure has numerous features for providing application redundancy at every level of potential failure, including *availability zones* and *paired regions*.

The following table summarizes each option.

| | **Availability zone** | **Paired region** |
| --- | --- | --- |
| **Scope of failure** | Datacenter | Region |
| **Request routing** | Cross-zone Azure Load Balancer | Azure Traffic Manager |
| **Network latency** | Low | Mid to high |
| **Virtual networking** | Virtual network | Cross-region virtual network peering |

### Availability zones

Like Google Cloud, Azure regions can have [availability zones](/azure/reliability/availability-zones-overview), which are physically separate zones within an Azure region. Each availability zone has a distinct power source, network, and cooling. Deploying VMs across availability zones helps protect an application against datacenter-wide failures.

:::image type="complex" source="./images/availability-zones.png" border="false" lightbox="./images/availability-zones.png" alt-text="Diagram that shows a zone-redundant virtual machine deployment across three availability zones within a single Azure region.":::
   Diagram that shows a zone-redundant virtual machine deployment within a single Azure region. A large outer rectangle labeled region contains the entire layout. Inside the region, three horizontal rectangular zones are stacked vertically from top to bottom, labeled zone 1, zone 2, and zone 3. Each zone contains one virtual machine. A vertical dashed rectangle overlays the virtual machines in all three zones. This dashed rectangle represents a single subnet that spans all three availability zones simultaneously. The label subnet appears at the bottom edge of the dashed rectangle. The layout illustrates that deploying virtual machines in each zone, connected through a shared subnet, provides redundancy in case of a failure in one zone.
:::image-end:::

To learn more about availability zones and regions, see [Architecture strategies for using availability zones and regions](/azure/well-architected/reliability/regions-availability-zones).

### Paired regions

To protect an application against a regional outage, deploy the application across multiple regions and use [Azure Traffic Manager](/azure/traffic-manager) to distribute internet traffic to different regions. Each Azure region pairs with another region. Together, these regions form a [region pair](/azure/reliability/regions-paired). Except for Brazil South, region pairs are located within the same geography to meet data residency requirements for tax and law enforcement jurisdiction purposes.

Unlike availability zones, which are physically separate datacenters but might be in relatively nearby geographic areas, paired regions are typically separated by at least 300 miles. This design ensures that large-scale disasters only affect one of the regions in the pair. You can set neighboring pairs to sync database and storage service data. They're configured so that platform updates roll out to only one region in the pair at a time.

Azure [geo-redundant storage](/azure/storage/common/storage-redundancy-grs) automatically backs up to the appropriate paired region. For all other resources, you need to deploy a complete copy of your solution in each region to achieve full redundancy.

:::image type="complex" source="./images/region-pairs.png" border="false" alt-text="Diagram that shows the nested containment relationship between a geography, a region pair, two regions, and their datacenters.":::
   Diagram that shows the nested containment hierarchy of Azure region pairs. The outermost rectangle represents a geography. Nested inside the geography is a region pair. Inside the region pair, two regions sit side by side. Within each region is a datacenter. The nesting of the shapes illustrates the containment relationships: datacenters are physically located inside regions, two regions together form a region pair, and a region pair belongs to a single geography.
:::image-end:::

### Reliability guides by service

To explore reliability recommendations for each Azure service, see [Reliability guides by service](/azure/reliability/overview-reliability-guidance).

To learn more, see the following resources:

- [High availability for Azure applications](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)
- [Architecture strategies for disaster recovery](/azure/well-architected/reliability/disaster-recovery)

## Services

To see how Google Cloud services map to their Azure equivalents, see [Google Cloud to Azure services comparison](./services.md).

Not all Azure products and services are available in all regions. For more information, see [Products by region](https://azure.microsoft.com/global-infrastructure/services). You can find the uptime guarantees and downtime credit policies for each Azure product or service in the [Service-level agreements for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services) document.

## Next step

> [!div class="nextstepaction"]
> [Get started with Azure](https://azure.microsoft.com/get-started)

## Related content

- [Azure reference architectures](../browse/index.yml)
