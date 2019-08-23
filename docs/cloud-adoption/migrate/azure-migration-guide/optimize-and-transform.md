---
title: "Optimize and Transform"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Optimize and Transform
author: matticusau
ms.author: mlavery
ms.date: 04/04/2019
ms.topic: conceptual
ms.service: cloud-adoption-framework
ms.subservice: migrate
ms.custom: fasttrack-new, AQC
ms.localizationpriority: high
---

# Optimize and transform

Now that you have migrated your services to Azure, the next phase includes reviewing the solution for possible areas of optimization. This could include reviewing the design of the solution, right-sizing the services, and analyzing costs.

This phase is also an opportunity to optimize your environment and perform possible transformations of the environment. For example, you may have performed a "rehost" migration, and now that your services are running on Azure you can revisit the solutions configuration or consumed services, and possibly perform some "refactoring" to modernize and increase the functionality of your solution.

# [Right-size assets](#tab/optimize)

All Azure services that provide a consumption-based cost model can be resized through the Azure portal, CLI, or PowerShell. The first step in correctly sizing a service is to review its usage metrics. The Azure Monitor service provides access to these metrics. You may need to configure the collection of the metrics for the service you are analyzing, and allow an appropriate time to collect meaningful data based on your workload patterns.

1. Go to **Monitor**.
1. Select **Metrics** and configure the chart to show the metrics for the service to analyze.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/metrics]" submitText="Go to Monitor" :::

::: zone-end

The following are some common services that you can resize.

## Resize a Virtual Machine

Azure Migrate performs a right-sizing analysis as part of its premigration assessment phase, and virtual machines migrated using this tool will likely already be sized based on your premigration requirements.

However, for virtual machines created or migrated using other methods, or in cases where your post-migration virtual machine requirements need adjustment, you may want to further refine your virtual machine sizing.

1. Go to **Virtual machines**.
1. Select the desired virtual machine from the list.
1. Select **Size** and the desired new size from the list. You may need to adjust the filters to find the size you need.
1. Select **Resize**.

Note that resizing production virtual machines has the potential to cause service disruptions. Try to apply the correct sizing for your VMs before you promote them to production.


::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Compute%2FVirtualMachines]" submitText="Go to Virtual Machines" :::

::: zone-end

::: zone target="docs"

- [Manage Reservations for Azure resources](/azure/billing/billing-manage-reserved-vm-instance)
- [Resize a Windows VM](/azure/virtual-machines/windows/resize-vm)
- [Resize a Linux virtual machine using Azure CLI](/azure/virtual-machines/linux/change-vm-size)

Partners can use the Partner Center to review the usage.

- [Microsoft Azure VM sizing for maximum reservation usage](/partner-center/azure-usage)

::: zone-end

## Resize a storage account

1. Go to **Storage accounts**.
1. Select the desired storage account.
1. Select **Configure** and adjust the properties of the storage account to match your requirements.
1. Select **Save**.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Storage%2FStorageAccounts]" submitText="Go to Storage Accounts" :::

::: zone-end

## Resize a SQL Database

1. Go to either **SQL databases**, or **SQL servers** and then select the server.
1. Select the desired database.
1. Select **Configure** and the desired new service tier size.
1. Select **Apply**.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Sql%2Fservers%2Fdatabases]" submitText="Go to SQL Databases" :::

::: zone-end

# [Cost Management](#tab/ManageCost)

It's important to perform ongoing cost analysis and review. This provides you with an opportunity to resize resources as needed to balance cost and workload.

Azure Cost Management works with Azure Advisor to provide cost optimization recommendations. Azure Advisor helps you optimize and improve efficiency by identifying idle and underutilized resources.

1. Select **Cost Management + Billing**.
1. Select **Advisor recommendations** and the **Costs** tab.
1. Use the **Impact** and **Potential yearly savings** to review the potential benefits.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Billing/ModernBillingMenuBlade/Overview]" submitText="Go to Cost Management + Billing" :::

::: zone-end

You can also use **Advisor** and select the **Costs** tab to identify recommendations for potential cost reductions.

> [!TIP]
> For services that don't require continuous availability, implementing a solution to start, stop, or pause the service as needed can help manage the cost (for example, Azure Virtual Machines or Azure SQL Data Warehouse).
>

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Expert/AdvisorBlade]" submitText="Go to Azure Advisor" :::

::: zone-end

::: zone target="docs"

- [Tutorial: Optimize costs from recommendations](/azure/cost-management/tutorial-acm-opt-recommendations)
- [Prevent unexpected charges with Azure billing and cost management](/azure/billing/billing-getting-started)
- [Explore and analyze costs with Cost analysis](/azure/cost-management/quick-acm-cost-analysis)

::: zone-end
