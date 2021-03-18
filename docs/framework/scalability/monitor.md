---
title: Monitoring for performance efficiency
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

# Monitoring for performance efficiency

Monitoring for scalability should be part of your overall monitoring strategy that utilizes [Azure Monitor](https://azure.microsoft.com/services/monitor/). The overall monitoring strategy should take into consideration not only scalability, but reliability (infrastructure, application, and dependent services) and application performance as well.

You can analyze data, set up alerts, get end-to-end views of your applications, and use machine learning–driven insights to identify and resolve problems quickly, with Azure Monitor. Azure monitor can also help diagnose networking related issues. For example, you can trigger a packet capture, diagnose routing issues, analyze network security group flow logs, and gain visibility and control over your Azure network.

[Azure Monitor Metrics](/azure/azure-monitor/platform/data-platform-metrics) is a feature of Azure Monitor that collects numeric data from monitored resources into a time series database. Metrics are numerical values that are collected at regular intervals and describe some aspect of a system at a particular time. To learn more about Azure Monitor Metrics, see [What can you do with Azure Monitor Metrics?](/azure/azure-monitor/platform/data-platform-metrics#what-can-you-do-with-azure-monitor-metrics)

Azure Monitor Metrics can store numeric data only in a particular structure, while [Azure Monitor Logs](/azure/azure-monitor/platform/data-platform-logs) can store various different data types each with their own structure. You can also perform complex analysis on logs data using log queries, which cannot be used for analysis of metrics data. While Azure Monitor Metrics collects numeric data from monitored resources into a time series database, Azure Monitor Logs is capable of supporting near real-time scenarios, making them useful for alerting and fast detection of issues. To learn more about Azure Monitor Logs, see [What can you do with Azure Monitor Logs?](/azure/azure-monitor/platform/data-platform-logs#what-can-you-do-with-azure-monitor-logs)

## Monitoring for scalability

For purposes of scalability, analyzing the metrics would allow you to scale up, scale out, scale in, and scale down. The ability to scale dynamically is one of the biggest values of moving to the cloud.

One of the challenges to metric data is that it often has limited information to provide context for collected values. Azure Monitor addresses this challenge with multi-dimensional metrics. Dimensions of a metric are name-value pairs that carry more data to describe the metric value. To learn about multi-dimensional metrics and an example for network throughput, see [multi-dimensional metrics](/azure/azure-monitor/platform/data-platform-metrics#multi-dimensional-metrics).

Most Azure services offer the ability to export logs and metrics to services such as Log Analytics and external service like Splunk. Furthermore, application technologies such as [Application Insights](/azure/azure-monitor/app/app-insights-overview) can enhance the telemetry coming out of applications. The metrics coming out of Azure services include metrics such as CPU and memory utilization, bandwidth information, current storage utilization information, and more. For more information, see [supported metrics for Azure Monitor](/azure/azure-monitor/platform/metrics-supported).

To learn more about Application Insights, see [What is Application Insights monitor?](/azure/azure-monitor/app/app-insights-overview)

## Monitoring for reliability

Improve the reliability of your workloads by implementing high availability, disaster recovery, backup, and monitoring in Azure. Monitoring systems should capture comprehensive details so that applications can be restored efficiently and, if necessary, designers and developers can modify the system to prevent the situation from recurring.

The raw data for monitoring can come from various sources, including:

- Application logs, such as those produced by [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview).
- Operating system performance metrics collected by [Azure monitoring agents](/azure/azure-monitor/platform/agents-overview).
- [Azure resources](/azure/azure-monitor/platform/metrics-supported), including metrics collected by Azure Monitor.
- [Azure Service Health](/azure/service-health/overview), which offers a dashboard to help you track active events.
- [Azure AD logs](/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-log-analytics) built into the Azure platform.

To learn more, see [Monitoring health for reliability](../resiliency/monitoring.md).

Monitor your application for early warning signs that might require proactive intervention. Tools that assess the overall health of the application and its dependencies help you to recognize quickly when a system or its components suddenly become unavailable. Use them to implement an early warning system. For more information, see [Monitoring application health for reliability](../resiliency/monitoring.md#early-warning-system).

## Metered metrics monitoring

The basic Azure Monitor billing model is a cloud-friendly, consumption-based pricing ("pay-as-you-go"). You only pay for what you use. Pricing details are available for [metrics](https://azure.microsoft.com/pricing/details/monitor/) as well as alerting, notifications, Log Analytics and Application Insights.

If you are actively using Azure services, use Azure to monitor your [usage and estimated costs](/azure/azure-monitor/platform/usage-estimated-costs).

If you have not yet purchased Azure Monitor, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/) for pricing details and FAQs. You can also use the [Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) to determine your pricing. The Pricing Calculator will help you estimate your likely costs based on your expected utilization.

## Application level monitoring

Application Performance Monitoring (APM) technology, such as [Application Insights](/azure/azure-monitor/app/app-insights-overview), can be used to manage the performance and availability of the application, aggregating application level logs and events for subsequent interpretation. It's designed to help you continuously improve performance and usability. For example, instrumentation of your code allows precise detection of under-performing pieces when load or stress tests are applied. It is critical to have this data available to improve and identify performance opportunities in the application code.

Here are some questions that can help maximize your application level monitoring:

**Are application events correlated across all application components?**
***

Event correlation between the layers of the application will provide the ability to connect tracing data of the complete application stack. Once this connection is made, you can see a complete picture of where time is spent at each layer. This will typically mean having a tool that can query the repositories of tracing data in correlation to a unique identifier that represents a completed transaction that has flowed through the system.

**Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?**
***

Application level metrics should include end-to-end transaction times of key technical functions, such as database queries, response times for external API calls, failure rates of processing steps, etc.

**Is the end-to-end performance of critical system flows monitored?**
***

It should be possible to correlate application log events across critical system flows, such as user login, to fully assess the health of key scenarios in the context of targets and NFRs.

## Resource/Infrastructure Level Monitoring

Log aggregation technologies, such as Azure Log Analytics or Splunk, should be used to collate logs and metrics across all application components, including infrastructural components, for subsequent evaluation. Resources may include Azure IaaS and PaaS services as well as third-party appliances such as firewalls or Anti-Malware solutions used in the application. For example, if Azure Event Hub is used, the Diagnostic Settings should be configured to push logs and metrics to the data sink.

Here are some questions that can help maximize your resource/infrastructure level monitoring:

**Are you collecting Azure Activity Logs within the log aggregation tool?**
***

Azure Activity Logs provide audit information about when an Azure resource is modified, such as when a virtual machine is started or stopped. This information is useful for the interpretation and troubleshooting of issues. It provides transparency around configuration changes that can be mapped to adverse performance events.

**Is resource level monitoring enforced throughout the application?**
***

All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. [Azure Policy](/azure/governance/policy/overview) should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service.

**Are logs and metrics available for critical internal dependencies?**
***

To be able to build a robust application health model, ensure there is visibility into the operational state of critical internal dependencies, such as a shared NVA (network virtual appliance) or Express Route connection.

**Are critical external dependencies monitored?**
***

Monitor critical external dependencies, such as an API service, to ensure operational visibility of performance. For exaMple, a probe could be used to measure the latency of an external API.

## Data Interpretation & Health Modeling

To build a robust application health model, it is vital that application and resource level data be correlated and evaluated together to optimize the detection of issues and troubleshooting of detected issues. The overall performance can be impacted by both application-level issues as well as resource-level failures. This can also help to distinguish between transient and non-transient faults.

A holistic application health model should be used to quantify what "healthy" and "unhealthy" states represent across all application components. It is highly recommended that a *traffic light* model be used to indicate a healthy state (green light) when key non-functional requirements and targets are fully satisfied and resources are optimally utilized. For example, a healthy state can be 95% of requests are processed in <= 500ms with AKS node utilization at x% etc. Also, An [Application Map](/azure/azure-monitor/app/app-map?tabs=net) can to help spot performance bottlenecks or failure hotspots across components of a distributed application.

Here are some questions that can help maximize your data interpretation and health modeling monitoring:

**Are long-term trends analyzed to predict performance issues before they occur?**
***

Analytics should be performed across long-term operational data to provide the history of application performance and detect if there have been any regressions. An example of a regression is if the average response times have been slowly increasing over time and getting closer to the maximum target.

**Have retention times been defined for logs and metrics, with housekeeping mechanisms configured?**
***

Clear retention times should be defined to allow for suitable historic analysis but also control storage costs. Suitable housekeeping tasks should also be used to archive data to cheaper storage or aggregate data for long-term trend analysis.

## Best practices for monitoring

- Know the minimum number of instances that should run at any given time.
- Determine what metrics are best for your solution to base your auto scaling rules.
- Configure the auto scaling rules for those services that include it.
- Create alert rules for the services that could be scaled manually.
- Monitor your environment to make sure that autoscaling is working as expected. For example, watch out for scaling events from the telemetry coming out of the management plane.
- Monitor web applications using Azure Application Insights.
- Monitor network performance.
  - Consider reviewing as applicable, [network performance monitor](/azure/azure-monitor/insights/network-performance-monitor-performance-monitor), [service connectivity monitor](/azure/azure-monitor/insights/network-performance-monitor-service-connectivity), and [ExpressRoute monitor](/azure/azure-monitor/insights/network-performance-monitor-expressroute).
- For long-term storage, consider archiving of the Monitoring Data.
- Track activities using [Azure Security and Audit Logs](/azure/security/fundamentals/log-audit).