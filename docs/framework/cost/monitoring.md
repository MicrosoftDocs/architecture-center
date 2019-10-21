---
title: Monitoring your cloud costs
description: Describes strategies that you can leverage to monitor your cloud costs, and act on them appropriately.
author: david-stanford
ms.date: 10/21/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Monitoring your cloud costs

## Performing cost reviews

Effective ongoing cost management includes informed cost reviews with key stakeholders. These can happen on a regular cadence but may also be required reactively if the cost management tools alert to a potential cost issue, such as a budget limit being reached.

### Identify stakeholders

Which of your regular financial stakeholders need visibility of and input into your Cloud costs? Do they have a fundamental knowledge of Cloud billing, capabilities and business benefits to enable them to understand both the financial metrics and the impact of their recommendations or decisions? Consider what additional knowledge or training they may need to help them understand Cloud cost metering and Cloud architectures.

Which additional stakeholders also need to be present? This could include key application owners, systems administrators who monitor and back-up Cloud systems, and business unit representatives.

Which other stakeholders may be required but only when necessary? Are your Cloud resources appropriately tagged so you can easily identify owners of systems or applications that are contributing to cost noise? Are they aware that their participation in cost reviews may be required and what is expected of them?

### Determine frequency

Within your existing business processes, there may be other cost reviews that occur which would align with adding a review of your Cloud costs, or maybe you need to schedule an additional meeting. Cloud costs can be reviewed:

- During the billing period – for an awareness of the estimated pending billing;

- After the billing period – to review actual spend with activity that occurred that month or

- On an ad-hoc basis – usually triggered by a [budget alert](https://docs.microsoft.com/en-us/azure/cost-management/cost-mgt-alerts-monitor-usage-spending) or Azure Advisor recommendation.

Web Direct (pay as you go) and CSP billing occurs monthly. Note that while Enterprise Agreement (EA) billing occurs annually, each month's consumption counts towards your EA budget, so these costs should still be reviewed monthly.

## Responding to cost alerts

In the Implementation section, you established your cost budget amounts, time periods and email alerts. Like any systems monitoring, this may need refining over time. So what happens when one of those alerts lands in your Inbox?

First, check the current consumption data. Budget alerts do not fire in real time and there may be a delay (up to 8 hrs) between this alert and your current incurred cost actuals. Is there any significant difference between the alert level and what you're seeing now?

Then you'll need to gather the appropriate people to discuss the cost trend, possible causes and any required action. That is likely to include people like application owners, who should be clearly identifiable through appropriate resource tagging. Who else do you need to involve (for example, business department owners) to provide the bigger picture of why a budget limit has nearly been reached? Remember this isn't just a systems question – it may also involve taking into account recent business activities which have been unexpectedly high.

And finally, you'll need to reach an agreement on any action that is required, either short term or long term. Do you need to temporarily increase the budget alert threshold? Will you diarise to reduce it again for the next billing period or does it need to remain at a new, higher level? Who needs to sign off that increase in spend? Who will make the business decision that the increased budget it justified, for the business value it delivers or the demand it meets?

Were the costs due to the creation or overrunning of unnecessary or expensive resources? Do you need to implement additional Azure Policy controls to prevent this in the future, or add automation to ensure scheduled virtual machine shutdowns?

## Define budgets

## Gather information

It's natural to reach for the invoice as the source of truth for your costs. Stakeholders should review this information in relation to other factors and data sources. Do you understand what your Cloud costs usually are? Do you know if there have been significant changes in either the business or the I.T. capabilities that may have contributed to a change in these costs? Make sure you identify which business-related data is relevant to your Cloud cost conversation, to ensure that all aspects are considered.

In addition to detailed usage information on your invoice, Azure provides you with tools that surface information such as incurred costs and makes recommendations on cost savings (such as downsizing virtual machines). Nonetheless, it's important to consider building additional custom solutions to fully maximize cost savings where identifiable:

### Azure Cost Management – Cost Analysis

Cost Analysis allows you to view aggregated costs to understand where they have occurred over time and to identify your spending trends. This can be broken down into time periods and viewed against your budgets. You can also set the scope of the costs, for example view all costs incurred by resources with a certain tag or within a specific resource group. Cost Analysis provides inbuilt charts but also supports custom views and the ability to download grouped and filtered data in CSV format. For more information: https://docs.microsoft.com/en-us/azure/cost-management/quick-acm-cost-analysis

### Azure Cost Management - Advisor

Advisor cost management recommendations proactively highlight areas of service underuse and steps that you can take to realize cost savings. This includes virtual machines which could be resized to a lower SKU, un-provisioned ExpressRoute circuits and idle virtual network gateways. You can act on these recommendations, postpone them or download them as a CSV or PDF file. To get started with Advisor cost management recommendations, visit: https://docs.microsoft.com/en-gb/azure/advisor/advisor-cost-recommendations. It's important to note, while Azure Advisor is a great tool offered at no additional cost, it does not provide an exhaustive list of recommendations across all underutilized or orphaned resources in Azure.

### Power BI and Azure Consumption Insights

For more flexibility with your cost reports, Azure Consumption Insights can be read into Microsoft's Power BI service. With Power BI, you can then create custom dashboards and reports, ask questions of your data and publish & share your work. Note: Sharing requires Power BI Premium licenses. To connect your billing data to Power BI, visit: https://docs.microsoft.com/en-gb/power-bi/service-connect-to-azure-consumption-insights

#### Azure Billing API and Azure Consumption API

If you have another preferred data analysis tool, Azure comes with Billing APIs (in Preview) that you can connect to. Import invoices, resource usage and rate cards: https://docs.microsoft.com/en-us/azure/billing/billing-usage-rate-card-overview or connect to additional usage data including Budgets and Reserved Instances consumption: https://docs.microsoft.com/en-us/azure/billing/billing-consumption-api-overview

>[!NOTE]
> There are several different ways of purchasing Azure services and not all of them are supported by Azure Cost Management. For example, detailed billing information for services purchased through a Cloud Solution Provider must be obtained directly from your CSP. For more information on supported cost data, visit https://docs.microsoft.com/en-us/azure/cost-management/understand-cost-mgt-data

### Custom Solutions

Leverage Azure APIs to build custom scripts that can run on a schedule and identify resources that are orphaned, such as unattached managed disks, load balancers, application gateways, etc. These orphaned resources, while unused, still incur a monthly flat rate. Further resources that are empty such as Azure SQL servers with no user databases. Just as orphaned resources, these empty resources incur a monthly flat fee separate from the pay-per-GB fees. Finally, resources that are stale in utilization, for example, blobs or tables in storage accounts being a result of VM diagnostics. Check for timestamps of last-use or modification of the item to determine if it should deleted.

Regardless of how you gather your cost information, make sure you develop and communicate a consistent business process for capturing and communicating this incurred cost information to your stakeholders.