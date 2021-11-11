---
title: Set budgets and alerts
description: Use the Azure Cost Management alert feature to generate alerts when consumption reaches a threshold.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-cost-management
ms.custom:
  - article
---

# Set budgets and alerts

Azure Cost Management has an alert feature. Alerts are generated when consumption reaches a threshold.

Consider the metrics that each resource in the workload. For each metric, build alerts on baseline thresholds. This way, the admins can be alerted when the workload is using the services at capacity. The admins can then tune the resources to target SKUs based on current load.

You can also set alerts on allowed budgets at the resource group or management groups scopes. Both cloud services performance and budget requirements can be balanced through alerts on metrics and budgets.

Over time, the workload can be optimized to autoheal itself when alerts are triggered. For information about using alerts, see [Use cost alerts to monitor usage and spending](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending).

## Respond to alerts
When you receive an alert, check the current consumption data. Budget alerts aren't triggered in real time. There may be a delay between the alert and the current actual cost.  Look for significant difference between cost values when the alert happened and the current cost. Next, conduct a cost review to discuss the cost trend, possible causes, and any required action. For information about stakeholders in a cost review, see Cost reviews.

Determine short and long-term actions justified by business value. Can a temporary increase in the alert threshold be a feasible fix? Does the budget need to be increased longer-term? Any increase in budget must be approved.

If the alert was caused because of unnecessary or expensive resources, you can implement additional Azure Policy controls. You can also add budget automation to trigger resource scaling or shutdowns.

## Revise budgets

After you identify and analyze your spending patterns, you can set budget limits for applications or business units. You'll want to [assign access](/azure/cost-management/assign-access-acm-data) to view or manage each budget to the appropriate groups. Setting several alert thresholds for each budget can help track your burn down rate.
