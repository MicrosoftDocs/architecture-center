---
title: Migration-focused cost control mechanisms
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn how to set up budgets, payments, and understand invoices for your Azure resources.
author: bandersmsft
ms.author: banders
ms.date: 08/08/2019
ms.topic: conceptual
ms.service: cloud-adoption-framework
ms.subservice: migrate
ms.custom: fasttrack-edit, AQC
ms.localizationpriority: high
---

# Migration-focused cost control mechanisms

The cloud introduces a few shifts in how we work, regardless of our role on the technology team. Cost is a great example of this shift. In the past, only finance and IT leadership were concerned with the cost of IT assets (infrastructure, apps, and data). The cloud empowers every member of IT to make and act on decisions that better support the end user. However, with that power comes the responsibility to be cost conscious when making those decisions.

This article introduces the tools that can help make wise cost decisions before, during, and after a migration to Azure.

The tools in this article include:

> - Azure Migrate
> - Azure pricing calculator
> - Azure TCO calculator
> - Azure Cost Management
> - Azure Advisor

The processes described in this article may also require a partnership with IT managers, finance, or line-of-business application owners. For guidance on partnering with these roles, see the Cloud Adoption Framework article on establishing a cost-conscious organization (coming in Q3 2019).

<!-- markdownlint-disable MD024 MD025 -->

# [Estimate VM costs prior to migration](#tab/EstimateVMCosts)

Prior to migration of any asset (infrastructure, app, or data), there is an opportunity to estimate costs and refine sizing based on observed performance criteria for those assets. Estimating costs serves two purposes: it allows for cost control, and it provides a checkpoint to ensure that current budgets account for necessary performance requirements.

## Cost calculators

For manual cost calculations, there are two handy calculators which can provide a quick cost estimate based on the architecture of the workload to be migrated.

- The Azure [pricing calculator](https://azure.microsoft.com/pricing/calculator) provides cost estimates based on manually entered Azure products.
- Sometimes decisions require a comparison of the future cloud costs and the current on-premises costs. The [Total Cost of Ownership (TCO) calculator](https://azure.microsoft.com/pricing/tco/calculator) can provide such a comparison.

These manual cost calculators can be used on their own to forecast potential spend and savings. They can also be used in conjunction with Azure Migrate's cost forecasting tools to adjust the cost expectations to fit alternative architectures or performance constraints.

## Azure Migrate calculations

**Prerequisites:** The remainder of this tab assumes the reader has already populated Azure Migrate with a collection of assets (infrastructure, apps, and data) to be migrated. The prior article on assessments provides instructions on collecting the initial data. Once the data is populated, follow the next few steps to estimate monthly costs based on the data collected.

Azure Migrate calculates **monthly cost estimates** based on data captured by the collector and service map. The following steps will load the cost estimates:

1. Navigate to the Azure Migrate Assessment blade in the portal.
1. In the project **Overview** page, select **+Create assessment**.
1. Click **View all** to review the assessment properties.
1. Create the group, and specify a group name.
1. Select the machines that you want to add to the group.
1. Click **Create Assessment**, to create the group and the assessment.
1. After the assessment is created, view it in Overview > Dashboard.
1. In the Assessment Details section of the blade navigation, select **Cost details**.

The resulting estimate, pictured below, identifies the monthly costs of compute and storage, which often represent the largest portion of cloud costs.

![compute-storage-monthly-cost-estimate.png](./media/manage-costs/compute-storage-monthly-cost-estimate.png)
*Figure 1 - Image of the Cost Details view of an assessment in Azure Migrate.*

## Additional resources

- [Set up and review an assessment with Azure Migrate](/azure/migrate/tutorial-assess-vmware#set-up-an-assessment)
- For a more comprehensive plan on cost management across larger numbers of assets (infrastructure, apps, and data), see the [Cloud Adoption Framework governance model](../../governance/journeys/index.md). In particular, guidance on the [Cost Management discipline](../../governance/cost-management/index.md) and the [Cost Management improvement in the large enterprise guide](../../governance/journeys/large-enterprise/cost-management-evolution.md).

# [Estimate and optimize VM costs during and after migration](#tab/EstimateOptimize)

Estimating cost prior to migration provides a solid target for cost expectations. It also provides opportunities to consider the performance and cost needs of each asset (infrastructure, apps, and data) to be migrated. However, it is still an estimate. Once the asset is migrated and under load, more accurate cost calculations can be made, based on actual or synthesized load.

## Azure Advisor cost recommendations

Within 24 hours of migrating assets (infrastructure, apps, and data) to Azure, Azure Advisor begins monitoring each asset's performance to provide you with feedback on the asset. One item of feedback collected relates to the balance between cost and utilization.

The following steps provide cost recommendations for assets (infrastructure, apps, and data) within your current subscriptions:

1. Navigate to the **Azure Advisor** blade in the portal. To do so, select **Advisor** in the left navigation pane of the Azure portal. If you do not see Advisor in the left pane, select **All services**. In the service menu pane, under **Monitoring and Management**, select **Advisor**.
1. The Advisor dashboard will display a summary of your recommendations for all selected subscriptions. You can choose the subscriptions that you want recommendations to be displayed for using the subscription filter dropdown.
1. To see cost recommendations, select the Cost tab.

## Azure Cost Management

Azure Cost Management can provide a more holistic view of spending habits, including detailed view of costs and spending trends over time. For large or complex migrations, this view may provide the insights needed to make broad sweeping cost management decisions.

Prerequisites: The remainder of this tab assumes the reader has completed setup of Azure Cost Management during completion of the Azure readiness guide. For more details on configuring Azure Cost Management see this [article in the Azure readiness guide](/azure/architecture/cloud-adoption/ready/azure-readiness-guide/manage-costs). Once the data is populated, follow the next few steps to estimate monthly costs based on the data collected.

The following steps will load Azure Cost Management cost analysis data for your subscriptions:

1. Navigate to the **Cost Management + Billing** blade in the portal. If you do not see Cost Management + Billing in the left pane, click **All services**. In the service menu pane, under **Monitoring and Management**, click **Cost Management + Billing**.
1. In the Cost Management + Billing blade, select **Cost Management** in the left navigation for the open blade to begin analyzing and optimizing cloud costs.
1. In the Cost Management blade, select **Cost analysis**.
    1. Use the **Scope** pill to switch to a different scope in cost analysis.

This analysis will allow you to review total costs, budget (if available), and accumulated costs. Each calculation can be viewed by service, by resource, and over time. Most importantly, costs can be analyzed by tags. Properly naming and tagging assets (infrastructure, apps, and data) is the fundamental starting point of all sound governance and cost management processes. Proper tags allow for better management of costs and clearer impacts of performance and cost optimizations.

## Additional resources

- For a more comprehensive plan on cost management across larger numbers of assets (infrastructure, apps, and data), see the [Cloud Adoption Framework governance model](../../governance/journeys/index.md). In particular, guidance on the [Cost Management discipline](../../governance/cost-management/index.md) and the [incremental Cost Management improvement in the large enterprise guide](../../governance/journeys/large-enterprise/cost-management-evolution.md).
- For more information about Azure Advisor, see [Reducing service costs using Azure Advisor](/azure/advisor/advisor-cost-recommendations).
- For more information about Azure Cost Management, see [Understand and work with scopes](/azure/cost-management/understand-work-scopes) and [Explore and analyze costs with Cost Analysis](/azure/cost-management/quick-acm-cost-analysis).

# [Tips and tricks to optimize costs](#tab/TipsTricks)

In addition to the tools mentioned in this article, there are some tips and tricks which can help quickly reduce overall cloud costs. The following are a few high-level tips to be aware of:

## Avoid unnecessary spending

Most assets (infrastructure, apps, and data) in an existing datacenter could theoretically be migrated to the cloud. However, that doesn’t mean they should be. During assessment of each workload, validate that the workload should be migrated. The Cloud Adoption Framework article on [incremental rationalization](../../digital-estate/rationalize.md) can help determine which assets should be migrated.

## Reduce waste

After you've deployed your infrastructure in Azure, it's important to make sure it is being used. The easiest way to start saving immediately is to review your resources and remove any that aren't being used.

## Reduce overprovisioning

Even with the best approaches to estimation, there are likely to be overprovisioned and underutilized assets (infrastructure, apps, and data). Review of those assets using the tools in the prior two tabs will identify potential means of reducing asset sizing to better match performance requirements and reduce costs.

## Take advantage of available discounts

Speak with your Microsoft account representative to understand how you can take advantage of current discount options. The following are a few examples of discounts that are commonly used to reduce costs.

## Azure Reservations

[Azure Reservations](/azure/billing/billing-save-compute-costs-reservations) allow you to prepay for one year or three years of virtual machine or SQL Database compute capacity. Prepaying will allow you to get a discount on the resources you use. Azure reservations can significantly reduce your virtual machine or SQL database compute costs, up to 72 percent on pay-as-you-go prices with either a one-year or three-year upfront commitment. Reservations provide a billing discount and don't affect the runtime state of your virtual machines or SQL databases.

## Use Azure Hybrid Benefit

If you already have Windows Server or SQL Server licenses in your on-premises deployments, you can use the [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit) program to save in Azure. With the Windows Server benefit, each license covers the cost of the OS (up to two virtual machines), and you only pay for base compute costs. You can use existing SQL Server licenses to save up to 55 percent on vCore-based SQL Database options. Options include SQL Server in Azure Virtual Machines and SQL Server Integration Services.

## Low-priority VMs with Batch

For lower priority background processes, Batch offers a means of managing the background service VMs and reducing costs. However, it is important to understand the performance impact of [low-priority VMs with Batch](/azure/batch/batch-low-pri-vms) before choosing this discounted option.

## Additional resources

For a more comprehensive plan on cost management across larger numbers of assets (infrastructure, apps, and data), see the [Cloud Adoption Framework governance model](../../governance/journeys/index.md). In particular, guidance on the [Cost Management discipline](../../governance/cost-management/index.md) and the [incremental Cost Management improvements in the large enterprise governance guide](../../governance/journeys/large-enterprise/cost-management-evolution.md).
