---
title: Monitor performance for scalability
description: Considerations for using monitoring for performance efficiency
author: v-aangie
ms.date: 01/28/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
ms.custom:
  - fasttrack-edit
  - article
---

# Monitor performance for scalability
Monitoring for scalability should be part of your overall monitoring strategy that utilizes [Azure Monitor](https://azure.microsoft.com/services/monitor/). The overall monitoring strategy should take into consideration not only scalability, but reliability (infrastructure, application, and dependent services) and application performance as well.

You can analyze data, set up alerts, get end-to-end views of your applications, and use machine learning–driven insights to identify and resolve problems quickly, with Azure Monitor. Azure monitor can also help diagnose networking related issues. For example, you can trigger a packet capture, diagnose routing issues, analyze network security group flow logs, and gain visibility and control over your Azure network.

[Azure Monitor Metrics](/azure/azure-monitor/platform/data-platform-metrics) is a feature of Azure Monitor that collects numeric data from monitored resources into a time series database. Metrics are numerical values that are collected at regular intervals and describe some aspect of a system at a particular time. To learn more about Azure Monitor Metrics, see [What can you do with Azure Monitor Metrics?](/azure/azure-monitor/platform/data-platform-metrics#what-can-you-do-with-azure-monitor-metrics)

Azure Monitor Metrics can store numeric data only in a particular structure, while [Azure Monitor Logs](/azure/azure-monitor/platform/data-platform-logs) can store various different data types each with their own structure. You can also perform complex analysis on logs data using log queries, which cannot be used for analysis of metrics data. While Azure Monitor Metrics collects numeric data from monitored resources into a time series database, Azure Monitor Logs is capable of supporting near real-time scenarios, making them useful for alerting and fast detection of issues. To learn more about Azure Monitor Logs, see [What can you do with Azure Monitor Logs?](/azure/azure-monitor/platform/data-platform-logs#what-can-you-do-with-azure-monitor-logs)

## Monitoring for scalability

For purposes of scalability, analyzing the metrics would allow you to scale up, scale out, scale in, and scale down. The ability to scale dynamically is one of the biggest values of moving to the cloud.

One of the challenges to metric data is that it often has limited information to provide context for collected values. Azure Monitor addresses this challenge with multi-dimensional metrics. Dimensions of a metric are name-value pairs that carry more data to describe the metric value. To learn about multi-dimensional metrics and an example for network throughput, see [multi-dimensional metrics](/azure/azure-monitor/platform/data-platform-metrics#multi-dimensional-metrics).

Most Azure services offer the ability to export logs and metrics to services such as Log Analytics and external service like Splunk. Furthermore, application technologies such as [Application Insights](/azure/azure-monitor/app/app-insights-overview) can enhance the telemetry coming out of applications. The metrics coming out of Azure services include metrics such as CPU and memory utilization, bandwidth information, current storage utilization information, and more. For more information, see [supported metrics for Azure Monitor](/azure/azure-monitor/platform/metrics-supported).

To learn more about Application Insights, see [What is Application Insights monitor?](/azure/azure-monitor/app/app-insights-overview)






