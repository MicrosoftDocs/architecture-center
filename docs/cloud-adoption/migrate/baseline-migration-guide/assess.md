---
title: "CAF: Assess the digital estate"
description: Assess the digital estate
author: matticusau
ms.author: mlavery
ms.date: 4/14/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack - new"
---

# Assess the digital estate

Not everything should be migrated to the cloud. Further, every asset is not compatible with cloud platforms. Before migrating assets to the cloud, it is important to assess the workload and each asset.

The tools and assets provided in this section will assist you in performing the assessment of your environment to determine it's suitability for migration and possible methodologies to utilize.

# [Tools](#tab/Tools)

The following tools can assist you with performing the assessment of your environment to ascertain the suitability and best approach for migration.

## Azure Migrate

The Azure Migrate service assesses on-premises workloads for migration to Azure. The service assesses the migration suitability of on-premises machines, performs performance-based sizing, and provides cost estimations for running on-premises machines in Azure. If you're contemplating lift-and-shift migrations, or are in the early assessment stages of migration, this service is for you. After the assessment, you can use services such as Azure Site Recovery and Azure Database Migration Service, to migrate the machines to Azure.

![Azure migrate overview](media/azuremigrate-overview-1.png)

::: zone target="docs"

### Read more

* [Azure Migration Overview](https://docs.microsoft.com/en-us/azure/migrate/migrate-overview)
* [Azure Migrate in the Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade)
* [Create Migration project in the Azure Portal](https://ms.portal.azure.com/#create/Microsoft.AzureMigrate)

::: zone-end

::: zone target="chromeless"

### Create a new Migration Project

1. Select **Azure Migrate**
1. Create a new Migration Project
1. Select **Discover and Assess**
1. Follow the **Discover machines** wizard
    1. Download, create, configure the collector appliance for on-premises
1. Follow the **Create assessment** wizard

::: form action="OpenBlade[#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade]" submitText="Go to Azure Migration" :::

::: form action="OpenBlade[#create/Microsoft.AzureMigrate]" submitText="Create new Migration Project" :::

::: zone-end

# [Scenarios and Stakeholders](#tab/Scenarios)

add text

# [Timelines](#tab/Timelines)

Based on this narrative, what is the expected timeline?
What variables would influence that timeline?

# [Cost Management](#tab/ManageCost)

As you assess your environment this presents a perfect opportunity to include a cost analysis step within those activities. Utilizing the data collected by the assessment activities you should be able to analyse and predict costs. This cost predication should factor both the consumption service costs in addition to any one time costs (increased data ingress, etc).
