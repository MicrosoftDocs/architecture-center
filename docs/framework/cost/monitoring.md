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

## Perform cost reviews

Effective ongoing cost management includes informed cost reviews with key stakeholders. Reviews should be scheduled on a regular cadence. You may also need to have reactive cost reviews, for example when a budget limit causes an alert.

### Identify stakeholders

Which of your regular financial stakeholders need visibility and input for your cloud costs? Do they understand cloud billing, capabilities, and business benefits to enable them to understand both the financial metrics and the impact of their decisions? Consider what additional knowledge or training they may need to help them understand cloud cost metering and cloud architectures.

Which additional stakeholders also need to be present? This could include key application owners, systems administrators who monitor and back-up cloud systems, and business unit representatives.

Which other stakeholders may be required but only when necessary? Are your resources appropriately tagged so you can easily identify owners of systems or applications that are contributing to cost noise? Are they aware that their participation in cost reviews may be required and what is expected of them?

### Determine frequency

You may have regular business reviews where it would make sense to also review, or you may wish to schedule an additional meeting. Cloud costs can be reviewed:

- During the billing period for an awareness of the estimated pending billing.

- After the billing period to review actual spend with activity that occurred that month

- On an ad-hoc basis – usually triggered by a [budget alert](/azure/cost-management/cost-mgt-alerts-monitor-usage-spending) or Azure Advisor recommendation.

Web Direct (pay as you go) and CSP billing occurs monthly. While Enterprise Agreement (EA) billing occurs annually, costs should still be reviewed monthly.

## Responding to cost alerts

In the Provisioning section, we looked at how to set budget amounts, time periods and email alerts. What happens when you receive a cost alert?

Check the current consumption data first. Budget alerts do not fire in real time and there may be a delay (up to 8 hrs) between this alert and your current actual cost. Check for any significant difference between when the alert happened and your current costs.

Next gather the right stakeholders to discuss the cost trend, possible causes and any required action. That will likely include application owners, who should be known through your resource tagging. Who else do you need to involve (for example, business department owners) to provide the bigger picture of why a budget limit has been reached? 

You'll need to agree on a plan for short and long-term action. Do you need to temporarily increase the budget alert threshold? Does the budget need to be increased longer-term? Who needs to approve a budget increase? Who will make the decision that the increased budget is justified by business value?

Are the costs due to unnecessary or expensive resources? Do you need to implement additional Azure Policy controls to prevent this in the future? Do you need to add [budget automation](/azure/billing/billing-cost-management-budget-scenario) to trigger resource scaling or shutdowns?

## Define budgets

After you identify and analyze your spending patterns, you can set budget limits for applications or business units. You will want to [assign access](/azure/cost-management/assign-access-acm-data) to view or manage each budget to the appropriate groups. Setting several alert thresholds for each budget can help track your burn down rate.

## Gather information

It's natural to reach for the invoice as the source of truth for your costs. Stakeholders should review this information in relation to other data and events. Do you understand what your cloud costs usually are? Have there been significant changes in either the business or applications that may have contributed to cost changes? Identify the business data that's relevant to your cost conversation to ensure that all factors are considered.

In addition to usage details on your invoice, Azure provides tools that can make recommendations on cost savings. It's important to consider building custom solutions to maximize cost savings where it makes sense for your business.

### Azure Cost Management – Cost Analysis

Cost Analysis allows you to view aggregated costs to understand your spending trends. Spending can be viewed by time period against your budgets. You can also view costs at different scopes, such as for a resource group or specific resource tag. Cost Analysis provides built-in charts as well as custom views. You can also download your cost data in CSV format to analyze with other tools. For more information, see: [quick acm cost analysis](/azure/cost-management/quick-acm-cost-analysis)

### Azure Cost Management - Advisor

Advisor cost management recommendations highlight over provisioned services and steps you can take to realize cost savings. This includes virtual machines which could be resized to a lower SKU, unprovisioned ExpressRoute circuits and idle virtual network gateways. You can act on these recommendations, postpone them or download them as a CSV or PDF file. To get started visit [Advisor cost management recommendations](/azure/advisor/advisor-cost-recommendations).

### Power BI and Azure Consumption Insights

For more flexibility with your cost reports, Azure Consumption Insights data can be used in Microsoft's Power BI service. With Power BI, you can create custom dashboards and reports, ask questions of your data and publish & share your work. Note: Sharing requires Power BI Premium licenses. To connect your billing data to Power BI, visit [connect to azure consumption insights](/power-bi/service-connect-to-azure-consumption-insights)

#### Azure Billing API and Azure Consumption API

If you have another preferred data analysis tool Azure provides Billing APIs (in Preview). You can use these APIs to import invoices, resource usage, and rate cards. To learn more visit [billing usage rate card overview](/azure/billing/billing-usage-rate-card-overview). To get additional usage data including Budgets and Reserved Instances consumption, review [billing consumption api overview](/azure/billing/billing-consumption-api-overview).

>[!NOTE]
> There are several different ways of purchasing Azure services and not all of them are supported by Azure Cost Management. For example, detailed billing information for services purchased through a Cloud Solution Provider must be obtained directly from your CSP. Review [understand cost management data](/azure/cost-management/understand-cost-mgt-data) for information on supported cost data.

### Custom Solutions

Leverage Azure APIs to schedule custom scripts that identify orphaned or empty resources, such as unattached managed disks, load balancers, application gateways, or Azure SQL Servers with no databases. These orphaned resources incur a flat monthly charge while unused. Other resources may be stale in utilization, for example VM diagnostics data in blob or table storage. Check for timestamps of last-use or modification of the item to determine if it should deleted.

Regardless of how you gather your cost data, make sure you develop and communicate a consistent business process to capture and share this information to your stakeholders.
