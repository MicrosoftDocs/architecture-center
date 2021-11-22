---
title: Performance data integration
description: Analyze performance data holistically to detect fault types, bottlenecks regressions, and health states.
author: PageWriter-MSFT
ms.date: 11/01/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
categories:
  - management-and-governance
ms.custom:
  - fasttrack-edit
---

# Performance data integration

Performance testing and investigation should be based on data captured from repeatable processes. To understand how an application's performance is affected by code and infrastructure changes, retain data for analysis. Additionally, it's important to measure how performance has changed _over time_, not just compared to the last measurement taken.

This article describes some considerations and tools you can use to aggregate data for troubleshooting and analyzing performance trends.

## Key points
> [!div class="checklist"]
> - Analyze performance data holistically to detect fault types, bottleneck regressions, and health states.
> - Use log aggregation technologies to consolidate data into a single workspace and analyze using a sophisticated query language.
> - Retain data in a time-series database to predict performance issues before they occur.
> - Balance the retention policy and service pricing plans with the cost expectation of the organization.

## Data interpretation

The overall performance can be impacted by both application-level issues and resource-level failures. It's vital that all data is correlated and evaluated together. This will optimize the detection of issues and troubleshooting of detected issues. This approach will help to distinguish between transient and non-transient faults.

Use a holistic approach to quantify what _healthy_ and _unhealthy_ states represent across all application components. It's highly recommended that a *traffic light* model is used to indicate a healthy state. For example, green light to show key non-functional requirements and targets are fully satisfied and resources are optimally used. For example, a healthy state can be 95% of requests are processed in <= 500 ms with AKS node utilization at x%, and so on. Also, An [Application Map](/azure/azure-monitor/app/app-map?tabs=net) can to help spot performance bottlenecks or failure hotspots across components of a distributed application.

Also, analyze long-term operational data to get historical context and detect if there have been any regressions. For example, check the average response times to see if they have been slowly increasing over time and getting closer to the maximum target.

## Aggregated view
Log aggregation technologies should be used to collate logs and metrics across all application components, including infrastructural components for later evaluation.

Resources may include Azure IaaS and PaaS services and third-party appliances such as firewalls or Anti-Malware solutions used in the application. For example, if Azure Event Hub is used, the Diagnostic Settings should be configured to push logs and metrics to the data sink.

[Azure Monitor](/azure/azure-monitor/data-platform) has the capability of collecting and organizing log and performance data from monitored resources. Data is consolidated into an Azure Log Analytics workspace so they can be analyzed together using a sophisticated query language that can quickly analyzing millions of records. Splunk is another popular choice.

**How is aggregated monitoring enforced?**
***

All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. Use [Azure Policy](/azure/governance/policy/overview) to ensure the consistent use of diagnostic settings across the application and to enforce the desired configuration for each Azure service.

## Long-term data
Store long-term operational data to understand the history of application performance. This data store is important for analyzing performance trends and regressions.

**Are long-term trends analyzed to predict performance issues before they occur?**
***
It's often helpful to store such data in a time-series database (TSDB) and then view the data from an operational dashboard. An [Azure Data Explorer cluster](https://azure.microsoft.com/services/data-explorer/) is a powerful TSDB that can store any schema of data, including performance test metrics. [Grafana](https://grafana.com/), an open-source platform for observability dashboards, can then be used to query your Azure Data Explorer cluster to view performance trends in your application.

**Have retention times been defined for logs and metrics, with housekeeping mechanisms configured?**
***

Clear retention times should be defined to allow for suitable historic analysis but also control storage costs. Suitable housekeeping tasks should also be used to archive data to cheaper storage or aggregate data for long-term trend analysis.

## Cost considerations

While correlating data is recommended, there are cost implications to storing long-term data. For example, Azure Monitor is capable of collecting, indexing, and storing massive amounts of data in Log Analytics workspace. The cost of a Log Analytics workspace is based on amount of storage, retention period, and the plan. For more information about how you can balance cost, see [Manage usage and costs with Azure Monitor Logs](/azure/azure-monitor/logs/manage-cost-storage).

If you are using Application Insights to collect instrumentation data, there are cost considerations. For more information, see [Manage usage and costs for Application Insights](/azure/azure-monitor/app/pricing).

## Next
> [!div class="nextstepaction"]
> [Scalability and reliability considerations](monitor-analyze.md)

## Related links
-  [Application Map](/azure/azure-monitor/app/app-map?tabs=net)
- [Azure Policy](/azure/governance/policy/overview)
- [Azure Data Explorer cluster](https://azure.microsoft.com/services/data-explorer/)
- [Manage usage and costs with Azure Monitor Logs](/azure/azure-monitor//logs/manage-cost-storage)
- [Manage usage and costs for Application Insights](/azure/azure-monitor//app/pricing)
> [Back to the main article](checklist.md)
