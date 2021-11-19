---
title: Monitoring for operational excellence
description: Provides a monitoring checklist to monitor your workload for operational excellence.
author: v-stacywray
manager: david-stanford
ms.date: 11/16/2021
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

# Monitoring for operational excellence

Distributed applications and services running in the cloud are, by nature, complex pieces of software that include many moving parts. In a production environment, it's important to track the way customers use your system and monitor the health, and performance of your system. Use the following checklist as a diagnostic aid to detect, correct, and prevent issues from occurring.

## Checklist

**[How are you monitoring your resources?](/assessments/?mode=questionnaire&question=resource-monitoring&category=Operational&session=82dede39-6b48-4bc5-b93b-4354fc5af197)**
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
|[Are application events correlated across all application components?](monitoring.md#event-correlation)|Correlate events for later interpretation. This correlation will give you visibility into end-to-end transaction flows.|
|[How is security monitored in this workload?](/azure/architecture/framework/security/monitor-security-operations)|Monitor the security posture across workloads. Ensure the SecOps team monitors security-related telemetry data and investigates security breaches.|
|[Are log levels used to capture different types of application events?](/aspnet/core/fundamentals/logging/?view=aspnetcore-5.0&preserve-view=true)|Pre-configure and apply log levels within relevant environments to support operational scenarios where it's necessary to raise log levels.|
|[Can you evaluate critical application performance targets and non-functional requirements (NFRs)?](monitoring.md)|Correlate application log events across critical system flows to fully assess the health of performance targets and NFRs.|
|[Are log messages captured in a structured format?](/azure/architecture/best-practices/monitoring#information-to-include-in-the-instrumentation-data)|Capture application events in a structured format to help parse and analyze logs. Structured data can be easily indexed, searched, and reported.|
|[Is sensitive information detected and removed automatically for this workload?](/azure/architecture/framework/security/design-app-dependencies#secrets)|Don't store secrets and sensitive information in application logs. Ensure you apply protective measure such as obfuscation.|
|[Do you have detailed instrumentation in the application code?](/azure/architecture/best-practices/monitoring#instrumenting-an-application)|Code instrumentation allows you to precisely detect underperforming workloads during load or stress tests.|
|[Are application logs collected from different application environments?](monitoring.md#application-monitoring)|Collect application logs to better understand how your application operates in various environments, events, and conditions.|
|[Does your organization have a central SecOps team to monitor security-related telemetry data and to investigate security breaches?](/azure/architecture/framework/security/monitor-security-operations#incident-response)|Establish a SecOps team and monitor security-related events.|
|[Do you use an Application Performance Management (APM) tool to collect application-level logs?](monitoring.md#application-monitoring)|Use an APM tool to manage the performance and availability of the application, aggregate logs, and events for later interpretation.|
|[Does the organization actively monitor identity-related risk events potentially connected to compromised identities of this workload?](monitor-alerts.md)|Establish a detection and response strategy for identity risks.|

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
