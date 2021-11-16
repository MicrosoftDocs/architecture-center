---
title: Checklist - Monitor cost
description: Review a checklist to monitor your Azure workload cost. Checklist items include getting cost data from diverse sources, using resource tag policies, and more.
author: david-stanford
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-cost-management
ms.custom:
  - article
---

# Checklist - Monitor cost
Use this checklist to monitor the cost of the workload.

- **Gather cost data from diverse sources to create reports**. Start with tools like [Azure Advisor](/azure/advisor/advisor-cost-recommendations), [Advisor Score](/azure/advisor/azure-advisor-score), and [Azure Cost Management](/azure/cost-management-billing/costs/). Build custom reports relevant for the business by using [Consumption APIs](/rest/api/consumption/).
    - [Cost reports](./monitor-reports.md)
    - [Review costs in cost analysis](/azure/cost-management-billing/costs/quick-acm-cost-analysis#review-costs-in-cost-analysis)

- **Use resource tag policies to build reports**. Tags can be used to identify the owners of systems or applications and create custom reports.
    - [Follow a consistent tagging standard](/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#metadata-tags)
    - [Video: How to review tag policies with Azure Cost Management](https://www.youtube.com/watch?v=nHQYcYGKuyw)

- **Use Azure built-in roles for cost**. Only give access to users who are intended to view and analyze cost reports. The roles are defined per scope. For example, use the **Cost Management Reader role** to enable users to view costs for their resources in subscriptions or resource groups.
    - [Provide the right level of cost access](/azure/cloud-adoption-framework/ready/azure-best-practices/track-costs#provide-the-right-level-of-cost-access)
    - [Azure RBAC scopes](/azure/cost-management-billing/costs/understand-work-scopes#azure-rbac-scopes)

- **Respond to alerts and have a response plan according to the constraints.** Respond to alerts quickly and identify possible causes and any required action.
    - [Budget and alerts](monitor-alert.md)
    - [Use cost alerts to monitor usage and spending](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending)

- **Adopt both proactive and reactive approaches for cost reviews**. Conduct cost reviews at a regular cadence to determine the cost trend. Also review reports that are created because of alerts.
    - [Conduct cost reviews](./monitor-reviews.md)
    - [Participate in central governance cost reviews](/azure/cloud-adoption-framework/govern/cost-management/compliance-processes)

- **Analyze the cost at all scopes** by using Cost analysis. Identify services that are driving the cost through different dimensions, such as location, usage meters, and so on. Review whether certain optimizations are bringing results. For example, analyze costs associated with reserved instances and Spot VMs against business goals.
    - [Quickstart: Explore and analyze costs with cost analysis](/azure/cost-management-billing/costs/quick-acm-cost-analysis)

- **Detect anomalies** and identify changes in business or applications that might have contributed changes in cost. Focus on these factors:

    - Traffic pattern as the application scales.
    - Budget for the usage meters on resources.
    - Performance bottle necks.
    - CPU utilization and network throughput.
    - Storage footprint for blobs, backups, archiving.

- **Use Visualization tools to analyze cost information.**
    - [Create visuals and reports with the Azure Cost Management connector in Power BI Desktop](/power-bi/desktop-connect-azure-cost-management)
    - [Cost Management App](https://appsource.microsoft.com/product/power-bi/costmanagement.azurecostmanagementapp)
