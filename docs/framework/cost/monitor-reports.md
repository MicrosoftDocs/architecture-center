---
title: Generate cost reports
description: Explore ways to gather cost data for reporting purposes. Use Azure cost tools, consumption APIs, and custom scripts. Analyze and visualize the data.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-cost-management
ms.custom:
  - article
  - internal-intro
---

# Generate cost reports

To monitor the cost of the workload, use Azure cost tools or custom reports. The reports can be scoped to business units, applications, IT infrastructure shared services, and so on. Make sure that the information is consistently shared with the stakeholders.

## Azure cost tools

Azure provides cost tools that can help track cloud spend and make recommendations.

- [Azure Advisor](/azure/advisor/advisor-cost-recommendations)
- [Advisor Score](/azure/advisor/azure-advisor-score)
- [Azure Cost Management](/azure/cost-management-billing/costs/)

### Cost analysis

**Cost analysis** is a tool in Azure Cost Management that allows you to view aggregated costs over a period. This view can help you understand your spending trends.

View costs at different scopes, such as for a resource group or specific resource tags. Cost Analysis provides built-in charts and custom views. You can also download the cost data in CSV format to analyze with other tools.

For more information, see: [Quickstart: Explore and analyze costs with cost analysis](/azure/cost-management/quick-acm-cost-analysis).

> [!NOTE]
> There are many ways of purchasing Azure services. Not all are supported by Azure Cost Management. For example, detailed billing information for services purchased through a Cloud Solution Provider (CSP) must be obtained directly from the CSP. For more information about the supported cost data, [see Understand cost management data](/azure/cost-management/quick-acm-cost-analysis).

### Advisor recommendations

Azure Advisor recommendations for cost can highlight the over-provisioned services and ways to lower cost. For example, the virtual machines that should be resized to a lower SKU, unprovisioned ExpressRoute circuits, and idle virtual network gateways.

For more information, see [Advisor cost management recommendations](/azure/advisor/advisor-cost-recommendations).

## Consumption APIs

Granular and custom reports can help track cost over time. Azure provides a set of Consumption APIs to generate such reports. These APIs allow you to query and create various cost data. Data includes usage data for Azure services and third-party services through Marketplace, balances, budgets, recommendations on reserved instances, among others. You can configure Azure role-based access control (Azure RBAC) policies to allow only a certain set of users or applications access the data.

For example, you want to determine the cost of all resources used in your workload for a given period. One way of getting this data is by querying usage meters and the rate of those meters. You also need to know the billing period of the usage. By combining these APIs, you can estimate the consumption cost.

- [Billing account API](/rest/api/billing/2019-10-01-preview/billingaccounts): To get your billing account to manage your invoices, payments, and track costs.
- [Billing Periods API](/rest/api/billing/enterprise/billing-enterprise-api-billing-periods): To get billing periods that have consumption data.
- [Usage Detail API](/rest/api/billing/enterprise/billing-enterprise-api-usage-detail): To get the breakdown of consumed quantities and estimated charges.
- [Marketplace Store Charge API](/rest/api/billing/enterprise/billing-enterprise-api-marketplace-storecharge): To get usage-based marketplace charges for third-party services.
- [Price Sheet API](/rest/api/billing/enterprise/billing-enterprise-api-pricesheet): To get the applicable rate for each meter.

The result of the APIs can be imported into analysis tools.

> [!NOTE]
> Consumption APIs are supported for Enterprise Enrollments and Web Direct Subscriptions (with exceptions). Check [Consumption APIs](/rest/api/consumption/) for updates to determine support for other types of Azure subscriptions.

For more information about common cost scenarios, see [Billing automation scenarios](/azure/cost-management-billing/manage/cost-management-automation-scenarios).

## Custom scripts

Use Azure APIs to schedule custom scripts that identify orphaned or empty resources. For example, unattached managed disks, load balancers, application gateways, or Azure SQL Servers with no databases. These resources incur a flat monthly charge while unused. Other resources may be stale, for example VM diagnostics data in blob or table storage. To determine if the item should be deleted, check its last use and modification timestamps.

## Analyze and visualize

Start with the usage details in the invoice. Review that information against relevant business data and events. If there are anomalies, evaluate the significant changes in business or applications that might have contributed those changes.

Power BI Desktop has a connector that allows you to connect billing data from Azure Cost Management. You can create custom dashboards and reports, ask questions of your data and publish, and share your work.

> [!NOTE]
> Sharing requires Power BI Premium licenses.

For more information, see [Create visuals and reports with the Azure Cost Management connector in Power BI Desktop](/power-bi/desktop-connect-azure-cost-management).

You can also use the [Cost Management App](https://appsource.microsoft.com/product/power-bi/costmanagement.azurecostmanagementapp). The app uses Azure Cost Management Template app for Power BI. You can import and analyze usage data and incurred cost within Power BI.
