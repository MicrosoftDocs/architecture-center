---
title: Monitoring operations of cloud applications
description: Provides a monitoring checklist to monitor your workload for operational excellence.
author: v-stacywray
manager: david-stanford
ms.date: 11/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
ms.custom:
  - fasttrack-edit
  - article
categories:
  - management-and-governance
---

# Monitoring operations of cloud applications

Distributed applications and services running in the cloud are, by nature, complex pieces of software that include many moving parts. In a production environment, it's important to track the way customers use your system and monitor the health, and performance of your system. Use the following checklist as a diagnostic aid to detect, correct, and prevent issues from occurring.

## Checklist

**[How are you monitoring your workload?](monitor-pipeline.md)**
***
> [!div class="checklist"]
> - Ensure that the system remains healthy.
> - Track the availability of the system and its component elements.
> - Maintain performance to ensure that the throughput of the system doesn't degrade unexpectedly as the volume of work increases.
> - Guarantee that the system meets any service-level agreements (SLAs) established with customers.
> - Protect the privacy and security of the system, users, and their data.
> - Track the operations performed for auditing or regulatory purposes.
> - Monitor the day-to-day usage of the system and spot trends that might lead to problems if they're not addressed.
> - Track issues that occur, from initial report through to analysis of possible causes, rectification, consequent software updates, and deployment.
> - Trace operations and debug software releases.

## In this section

Follow these questions to assess the workload at a deeper level.

|Assessment|Description|
|---|---|
|[**Do you monitor your resources?**](monitor-data-sources.md)|Have an overall view of the workload resources. The information can come from application code, frameworks, external sources with which the application communicates, and the underlying infrastructure.
|[**Do you have detailed instrumentation in the application code?**](monitor-instrument.md)|Instrumentation lets you gather performance data, diagnose problems, and make decisions.|
|[**Do you correlate application events across all application components?**](monitor-collection-data-storage.md)|Collect data from various sources, consolidate and clean various formats, and store in reliable storage.|
|[**Do you interpret the collected data to spot issues and trends in application health?**](monitor-analysis.md)|Analyze the data collected from various data sources to assess the overall well-being of the workload.|
|[**Do you visualize monitoring data?**](monitor-visualize-data.md)| Present the analyzed data in a way that an operator can quickly spot any trends or problems.|
|[**Do you have alerts and response plans ready for the relevant teams when issues occur?**](monitor-alerts.md)| Present the analyzed data in a way that an operator can quickly spot any trends or problems.|
|[**Do you use the Azure platform notifications and updates?**](monitor-data-sources.md#infrastructure-metrics)| Consider the underlying infrastructure such as virtual machines, networks, and storage services to collect important platform-level diagnostic data.|
|[**Do you monitor and measure application health?**](health-monitoring.md)|Health monitoring generates a snapshot of the current health of the system so that you can verify all components are functioning as expected.|
|[**Do you monitor and track resource usage?**](usage.md)|Usage monitoring tracks how the features and components of an application are used.|
|[**Do you collect data from the reported issues**](issue-tracking.md)|Analyzing data, for unexpected events, can provide insight about the application health.|
|[**Do you collect audit logs for regulatory requirements?**](auditing.md)| Auditing can provide evidence useful for compliance attestations. |

## Azure offering

You can use any monitoring platform to manage your Azure resources. Microsoft's first party offering is [Azure Monitor](/azure/azure-monitor/overview), a comprehensive solution for metrics and logs from the infrastructure to the application code, including the ability to trigger alerts and automated actions as well as data visualization.


## Reference architecture

[Enterprise monitoring with Azure Monitor](/azure/architecture/example-scenario/monitoring/enterprise-monitoring) illustrates an architecture that has centralized monitoring management by using Azure Monitor features.


## Related links

- [Distributed tracing](/azure/architecture/microservices/logging-monitoring#distributed-tracing)
- [Application Insights](/azure/azure-monitor/app/app-insights-overview)

## Next steps

> [!div class="nextstepaction"]
> [Monitoring phases](monitor-pipeline.md)
