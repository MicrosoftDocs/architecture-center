---
title: Migration-focused cost control mechanisms | Microsoft docs
description: Learn how to set up budgets, payments, and understand invoices for your Azure resources.
author: dchimes
ms.author: kfollis
ms.date: 04/09/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack-edit"
---
# Migration-focused cost control mechanisms

The cloud introduces a few shifts in how we work, regardless of the role we each play on the technology team. Cost is a great example of this shift. In the past, only finance and IT leadership were concerned with the cost of IT assets. The cloud empowers every member of IT to make and act on decisions that better support the end user. However, with that power comes the responsibility to be cost conscious in those decisions. 

This article will introduce the tools that can help make wise cost decisions before, during, and after a migration to Azure. 

The tools in this article include:

> * Azure Migrate
> * Azure Pricing Calculator
> * Azure TCO Calculator
> * Azure Cost Management
> * Azure Advisor

The processes described in this article may also require a partnership with IT managers, finance, and/or Line of Business (LOB) application owners. For guidance on partnering with these roles, see the Cloud Adoption Framework article on [Establishing a Cost-Conscious organization]().

# [Estimate VM Costs prior to migration](#tab/EstimateVMCosts)

Prior to migration of any asset (Infrastructure, Application, or Data), there is an opportunity to estimate costs and refine sizing based on observed performance criteria for those assets. Estimating costs serves two purposes, it allows for cost control AND provides a check point to ensure that current budgets account for necessary performance requirements.

## Cost calculators

For manual cost calculations, there are two handy calculators which can provide a quick cost estimate based on the architecture of the workload to be migrated. 

* The Azure [pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/) provides cost estimates based on manually entered azure products.
* Sometimes decisions require a comparison of the future state, cloud costs and the current state, on-prem costs. The [Total Cost of Ownership (TCO) calculator](https://azure.microsoft.com/en-us/pricing/tco/calculator/) can provide such a comparison.

These manual cost calculators can be used on their own to forecast potential spend and savings. They can also be used in conjunction with Azure Migrate's cost forecasting tools to adjust the cost expectations to fit alternative architectures or performance constraints.

## Azure Migrate calculations

Prerequisites: The remainder of this tab assumes the reader has already populated Azure Migrate with a collection of assets to be migrated. The prior article on assessments provides instructions on collecting the initial data. Once the data is populated, follow the next few steps to estimate monthly costs based on the data collected.

Warning: The next version of Azure Migrate is available in a public preview. The features of that new version will be updated in this article upon release. Currently the following instructions are based on the General Availability version of Azure Migrate.

Azure Migrate calculates **monthly cost estimates** based on data captured by the collector and service map. The following steps will load the cost estimates:

1. Navigate to the Azure Migrate Assessment Blade in the portal.
1. In the project **Overview** page, click **+Create assessment**.
1. Click **View all** to review the assessment properties.
1. Create the group, and specify a group name.
1. Select the machines that you want to add to the group.
1. Click **Create Assessment**, to create the group and the assessment.
1. After the assessment is created, view it in Overview > Dashboard.
1. In the Assessment Details section of the blade navigation, click on **Cost details**

The resulting estimate, pictured below, identifies the monthly costs of compute and storage, which often represent the largest portion of cloud costs.

![compute-storage-monthly-cost-estimate.png](./media/compute-storage-monthly-cost-estimate.png)
_Figure 1. Image of the Cost Details view of an assessment in Azure Migrate_

## Additional Resources

* [Creating and viewing assessments with Azure Migrate](https://docs.microsoft.com/en-us/azure/migrate/tutorial-assessment-vmware#create-and-view-an-assessment)
* For a more comprehensive plan on cost management across larger numbers of assets (Infra, Apps, and Data), see the [CAF Governance Model](../../governance/journeys/overview). In particular, guidance on the [Cost Management Discipline](../../governance/cost-management/overview) and the [Cost Management Evolution of Large Enterprise Guide](../../governance/journeys/large-enterprise/cost-management-evolution).

# [Estimate and Optimize VM Costs during and after migration](#tab/EstimateOptimize)

Estimating cost prior to migration provides a solid target for cost expectations. It also provides opportunities to consider the performance and cost needs of each asset (Infra, Apps, and Data) to be migrated. However, it is still an estimate. Once the asset is migrated and under load, more accurate cost calculations can be made, based on actual or synthesized load.

## Azure Advisor Cost Recommendations

Within 24 hours of assets being migrated to Azure, Azure Advisor will begin monitoring the assets performance to provide you with feedback on the asset. One point of feedback collected is regarding the balance between cost and utilization.

The following steps will provide cost recommendations on assets within your current subscription(s):

1. Navigate to the **Azure Advisor** Blade in the portal. To do so, click **Advisor** in the left navigation pane of the Azure Portal. If you do not see Advisor in the left pane, click **All services**. In the service menu pane, under **Monitoring and Management**, click **Advisor**.
1. The Advisor dashboard will display a summary of your recommendations for all selected subscriptions. You can choose the subscriptions that you want recommendations to be displayed for using the subscription filter dropdown.
1. To see cost recommendations, click on the Cost tab

## Azure Cost Management

Azure Cost Management can provide a more holistic view of spending habits, including detailed view of costs and spending trends over time. For large or complex migrations, this view may provide the insights needed to make broad sweeping cost management decisions.

Prerequisites: The remainder of this tab assumes the reader has completed setup of Azure Cost Management during completion of the Azure Readiness Guide. For more details on configuring Azure Cost Management see this [article in the Azure Readiness Guide](). Once the data is populated, follow the next few steps to estimate monthly costs based on the data collected.

The following steps will load Azure Cost Management cost analysis data for your subscription(s):

1. Navigate to the **Cost Management + Billing** Blade in the portal. If you do not see Cost Management + Billing in the left pane, click **All services**. In the service menu pane, under **Monitoring and Management**, click **Cost Management + Billing**.
1. In the Cost Management + Billing Blade, click on **Cost Management** in the left navigation for the open blade to begin analyzing and optimizing cloud costs.
1. In the Cost Management Blade, click on **Cost analysis**
    1. Use the **Scope** pill to switch to a different scope in cost analysis.

This analysis will allow you to review Total costs, Budget (if available), and Accumulated costs. Each calculation can be view by service, by resource, and over time. Most importantly, costs can be analyzed by tags. Properly naming and tagging assets is the fundamental starting point of all sound governance and cost management processes. Proper tags allow for better management of costs and clearer impacts from performance/cost optimizations.

## Additional Resources

* For a more comprehensive plan on cost management across larger numbers of assets (Infra, Apps, and Data), see the [CAF Governance Model](../../governance/journeys/overview). In particular, guidance on the [Cost Management Discipline](../../governance/cost-management/overview) and the [Cost Management Evolution of Large Enterprise Guide](../../governance/journeys/large-enterprise/cost-management-evolution).
* For more information about Azure Advisor see [Reducing service costs using Azure Advisor](https://docs.microsoft.com/en-us/azure/advisor/advisor-cost-recommendations).
* For more information about Azure Cost Management, see [Understand and work with scopes](https://docs.microsoft.com/en-us/azure/cost-management/understand-work-scopes) and [Explore and analyze costs with Cost Analysis](https://docs.microsoft.com/en-us/azure/cost-management/quick-acm-cost-analysis).

# [Tips and Tricks to Optimize Costs](#tab/TipsTricks)

In addition to the tools mentioned in this article, there are a number of tips and tricks which can help quickly reduce overall cloud costs. The following are a few high-level tips to be aware of:

## Avoid unnecessary spend

Most assets (Infra, App, and Data) in an existing datacenter could theoretically be migrated to the cloud. However, that doesn’t mean they should be. During assessment of each workload, validate that the workload should be migrated. The Cloud Adoption Framework article on [incremental rationalization](../../digital-estate/rationalize) can help determine which assets should be migrated.

## Reduce waste

After you've deployed your infrastructure in Azure, it's important to make sure it is being used. The easiest way to start saving immediately is to review your resources and remove any that aren't being used.

## Reduce over provisioning

Even with the best approaches to estimation, there are likely to be overprovisioned and underutilized assets. Review of those assets using the tools in the prior two tabs will identify potential means of reducing asset sizing to better match performance requirements and reduce costs.

## Take advantage of available discounts

Speak with your Microsoft account representative to understand how you can take advantage of current discount options. The following are a few examples of discounts that are commonly used to reduce costs.

## Azure Reservations

[Azure Reservations](https://docs.microsoft.com/en-us/azure/billing/billing-save-compute-costs-reservations) allow you to prepay for one-year or three-years of virtual machine or SQL Database compute capacity. Pre-paying will allow you to get a discount on the resources you use. Azure reservations can significantly reduce your virtual machine or SQL database compute costs — up to 72 percent on pay-as-you-go prices with one-year or three-year upfront commitment. Reservations provide a billing discount and don't affect the runtime state of your virtual machines or SQL databases.

## Use Azure Hybrid Benefit

If you already have Windows Server or SQL Server licenses in your on-premises deployments, you can use the [Azure Hybrid Benefit](https://azure.microsoft.com/en-us/pricing/hybrid-benefit/) program to save in Azure. With the Windows Server benefit, each license covers the cost of the OS (up to two virtual machines), and you only pay for base compute costs. You can use existing SQL Server licenses to save up to 55 percent on vCore-based SQL Database options. Options include SQL Server in Azure Virtual Machines and SQL Server Integration Services.

## Low Priority VMs with Batch

For lower priority background processes, Batch offers a means of managing the background service VMs and reducing costs. However, it is important to understand the performance impact of [low priority VMs with Batch](https://docs.microsoft.com/en-us/azure/batch/batch-low-pri-vms) before choosing this discounting option.

## Additional Resources

* For a more comprehensive plan on cost management across larger numbers of assets (Infra, Apps, and Data), see the [CAF Governance Model](../../governance/journeys/overview). In particular, guidance on the [Cost Management Discipline](../../governance/cost-management/overview) and the [Cost Management Evolution of Large Enterprise Guide](../../governance/journeys/large-enterprise/cost-management-evolution).
