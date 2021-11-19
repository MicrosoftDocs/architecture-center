---
title: Monitor the performance of a cloud application
description: Review a checklist about using monitoring for performance efficiency. Consider scalability, app and infrastructure performance, and resiliency.
author: v-aangie
ms.date: 10/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
  - azure-application-insights
categories:
  - management-and-governance
ms.custom:
  - fasttrack-edit
  - article
---

# Monitor the performance of a cloud application
Troubleshooting an application's performance requires monitoring and reliable investigation. Issues in performance can arise from database queries, connectivity between services, under-provisioned resources, or memory leaks in code.

Continuously monitoring services and checking the health state of current workloads is key in maintaining the overall performance of the workload. An overall monitoring strategy consider these factors:
- Scalability
- Resiliency of the infrastructure, application, and dependent services
- Application and infrastructure performance

## Checklist

**How are you monitoring to ensure the workload is scaling appropriately?**
***
> [!div class="checklist"]
>
> - Enable and capture telemetry throughout your application to build and visualize end-to-end transaction flows for the application.
> - See metrics from Azure services such as CPU and memory utilization, bandwidth information, current storage utilization, and more.
> - Use resource and platform logs to get information about what events occur and under which conditions.
> - For scalability, look at the metrics to determine how to provision resources dynamically and scale with demand.
> - In the collected logs and metrics look for signs that might make a system or its components suddenly become unavailable.
> - Use log aggregation technology to gather information across all application components.
> - Store logs and key metrics of critical components for statistical evaluation and predicting trends.
> - Identify antipatterns in the code.

## In this section

Follow these questions to assess the workload at a deeper level.

|Assessment|Description|
|---|---|
|[**Are application logs and events correlated across all application components?**](monitor-application.md)|Correlate logs and events for subsequent interpretation. This correlation will give you visibility into end-to-end transaction flows.|
|[**Are you collecting Azure Activity Logs within the log aggregation tool?**](monitor-infrastructure.md)|Collect platform metrics and logs to get visibility into the health and performance of services that are part of the architecture.|
|[**Are application and resource level logs aggregated in a single data sink, or is it possible to cross-query events at both levels?**](monitor-analyze.md))|Implement a unified solution to aggregate and query application and resource level logs, such as Azure Log Analytics.|

## Azure services

The monitoring operations should utilize [Azure Monitor](https://azure.microsoft.com/services/monitor/). You can analyze data, set up alerts, get end-to-end views of your applications, and use machine learning–driven insights to identify and resolve problems quickly. Export logs and metrics to services such as Azure Log Analytics or an external service like Splunk. Furthermore, application technologies such as [Application Insights](/azure/azure-monitor/app/app-insights-overview) can enhance the telemetry coming out of applications.

## Next section

Based on insights gained through monitoring, optimize your code. One option might be to consider other Azure services that may be more appropriate for your objectives.

> [!div class="nextstepaction"]
> [Optimize](optimize.md)

## Related links

> [Back to the main article](overview.md)
