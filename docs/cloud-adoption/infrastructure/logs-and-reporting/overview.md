---
title: "Fusion: Logs, Reporting, and Monitoring" 
description: Discussion of Logs, Reporting, and Monitoring as a core service in Azure migrations
author: rotycenh
ms.date: 11/07/2018
---

# Fusion: Logs, Reporting, and Monitoring

All organizations need mechanisms notifying IT teams of performance, uptime, and security issues before they become serious problems. A successful monitoring strategy allows you to understand how the individual components that make up your workloads and networking infrastructure are performing. Within the context of a public cloud migration, integrating logging and reporting with any of your existing monitoring systems, while surfacing important events and metrics to the appropriate IT staff, is critical in ensuring your organization is meeting uptime, security, and policy compliance goals.


## Logging and Reporting Decision Guide

![Plotting logging, reporting, and monitoring options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-logs-and-reporting.png)

Jump to: [Planning your monitoring infrastructure](#planning-your-monitoring-infrastructure) | [Cloud native](#cloud-native) | [Hybrid monitoring (on-premises)](#hybrid-monitoring-on-premises) | [Hybrid monitoring (cloud-based)](#hybrid-monitoring-cloud-based) | [Gateway](#gateway) | [Multi-cloud](#multi-cloud) | [Reporting and monitoring in Azure](#reporting-and-monitoring-in-azure)

The inflection point when deciding a cloud identity strategy is based primarily on existing investments your organization has made in Operational Processes, and to some degree any requirements you have to support a multi-cloud strategy.

There are a number of ways to log and report on activities in the cloud. Cloud Native and Centralized logging are two common Software as a service (SaaS) options that are driven by the subscription design and the number of subscriptions. (Article on [Service Provider or Central Logs](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-service-providers?toc=/azure/azure-monitor/toc.json) discusses a similar decision point, assume Service Provider and Cloud Native are the same for that article.)

## Planning your monitoring infrastructure

When planning your deployment, you will need to consider where logging data is
stored and how you integrate cloud-based reporting and monitoring services with
your existing processes and tools.

| Question                                                                               | Cloud native | Hybrid cloud | On-premises |
|----------------------------------------------------------------------------------------|--------------|--------------|-------------|
| Do you have existing on-premise monitoring infrastructure?                             | No           | Yes          | Yes         |
| Do you have requirements preventing storage of log data on external storage locations? | No           | No           | Yes         |
| Do you need to integrate cloud monitoring with on-premises systems?                    | No           | Yes          | No          |

### Cloud native

If your organization currently lacks established logging and reporting systems, or if your planned cloud deployment does not need to be integrated with existing on-premises or other external monitoring systems, a cloud native SaaS solution is likely the simplest choice.

In this scenario log data is recorded and stored in the same cloud environment as your workload, while the logging and reporting tools that process and surface information to IT staff are offered as part of the could platform.

Cloud native logging solutions can be implemented ad-hoc per subscriptions or workload for smaller or experimental deployments or organized in a centralized manner to monitor log data across your entire cloud estate.

**Cloud native assumptions:** Using a cloud native logging and reporting system assumes the following:

- You do not need to integrate the log data from you cloud workloads into existing on-premises systems.
- You will not be using your cloud-based reporting systems to monitor on-premises systems.

### Hybrid monitoring (on-premises)

A hybrid monitoring solution combines log data from both your on-premises and cloud resources to provide an integrated view into your IT estate's operational status.

If you have an existing investment in on-premises monitoring systems that would be difficult or costly to replace, you may need to integrate the telemetry from your cloud workloads into preexisting on-premises monitoring solutions. In a hybrid on-premises monitoring system, on-premises telemetry data continues to use the existing on-premises monitoring system. Cloud-based telemetry data is either sent to the cloud monitoring system directly, or the data is stored on the cloud alongside your workloads and then compiled and ingested into the on-premises system at regular intervals.

**On-premises hybrid monitoring assumptions:** Using an on-premises logging and reporting system for hybrid monitoring assumes the following:

- You need to use existing on-premises reporting systems to monitor cloud workloads.
- You need to maintain ownership of log data on-premises.
- Your on-premises management systems have APIs or other mechanisms available to ingest log data from cloud-based systems.

> [!TIP]
> As part of the iterative nature of cloud migration, transitioning from distinct cloud native and on-premises monitoring to some kind of partial hybrid is likely. Make sure to keep changes to your monitoring architecture in line with your overall IT and operational processes.

### Hybrid monitoring (cloud-based)

If you do not have a compelling need to maintain an on-premises monitoring system, or want to replace on-premises monitoring systems with a SaaS solution, you can also choose to integrate on-premises log data with a centralized cloud-based monitoring system.

Mirroring the on-premises centered approach, in this scenario cloud workloads would use their default cloud logging mechanism, and on-premises applications and services would either send telemetry directory to the cloud-based logging system, or aggregate that data for ingestion into the cloud system at regular intervals. The cloud-based monitoring system would then serve as your primary monitoring and reporting system for your entire IT estate.

**Cloud-based hybrid monitoring assumptions:** Using cloud-based logging and reporting systems for hybrid monitoring assumes the following:

- You are not tied to existing on-premises monitoring systems.
- Your workloads do not have regulatory or policy requirements to store log data on-premises.
- Your cloud-based monitoring systems have APIs or other mechanisms available to ingest log data from on-premises applications and services.

> [!NOTE]
> The Azure Virtual Datacenter model's [monitoring and reporting strategy](vdc-monitoring.md) relies heavily on cloud hosted services such as [Azure Monitor](#reporting-and-monitoring-in-azure). Part of planning for a VDC deployment will include choosing the best hybrid monitoring approach to take for creating an integrated monitoring and reporting solution. 

### Gateway

For scenarios where the amount of cloud-based telemetry data is very large or existing on-premises monitoring systems need log data modified before it can be processed, a log data [gateway aggregation](https://docs.microsoft.com/en-us/azure/architecture/patterns/gateway-aggregation) service may be needed. 

A gateway service is deployed to your cloud provider, and relevant applications and services are configured to submit telemetry data to the gateway instead of a default logging system. The gateway can then process the data: aggregating, combining, or otherwise formatting it before then submitting it to your monitoring service for ingestion and analysis.

A gateway can be used to aggregate and pre-process telemetry data bound for cloud-native or hybrid systems.

**Gateway assumptions:**

- You expect very high levels of telemetry data from your cloud-based applications or services.
- You need to format or otherwise optimize telemetry data before submitting it to your monitoring systems.
- Your monitoring systems have APIs or other mechanisms available to ingest log data after processing by the gateway.

### On-premises only

In scenarios where you need to integrate cloud telemetry with on-premises systems that do not support hybrid logging and reporting, you will need to provide a mechanism for cloud-based systems to send data directly to on-premises storage locations.

In order to support this approach, your cloud resources will need to be able to community directly with your on-premises systems with a combination of [hybrid networking](../software-defined-networks/hybrid.md) and [replication of directory services](../identity/overview.md#directory-migration-with-federation) in your cloud environment. With this in place the cloud virtual networks function as a network extension of the on-premises environment, and cloud hosted workloads can communicate directly with the on-premises logging and reporting system.

**On-premises only assumptions:**

- You need to maintain log data in your on-premises environment, either in support of operations being tied to your existing system, or due to regulatory or policy requirements.
- Your on-premises systems do not support hybrid logging and reporting or gateway aggregation solutions.
- You can connect your on-premises network and directory services with their cloud-based counterparts. 
- Your workloads are not dependent on PaaS or SaaS services that require cloud-based logging and reporting.

### Multi-cloud

Integrating logging and reporting capabilities across multiple cloud platform can be complicated. Services offered between platforms are often not directly comparable, and logging and telemetry capabilities provided by these services differ as well. 

Multi-cloud logging support often requires the use of gateway services to process log data into a common format before submitting data to a hybrid logging solution. 

## Reporting and monitoring in Azure

[Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) is the default reporting and monitoring service on Azure. It consists of several tools capable of logging, visualizing, analyzing, and reporting on telemetry data generated by Azure resources. It's capable of providing insights into virtual machines, guest operating systems, virtual network, and workload application events. It also provides import and export mechanisms for integrating with on-premises or third-party systems.

### Log Analytics

[Azure Log
Analytics](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-queries)
is the component of Azure Monitor used to collect telemetry information from
virtual machines and guest operating systems hosted in the Azure cloud. The tool
also provides the mechanisms to analyze this data or created alerts. [In hybrid
scenarios](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-concept-hybrid),
on-premises or other externally hosted physical servers and virtual machines can
be configured to send telemetry to your azure-based Log Analytics instance for
integrated analysis and reporting.

### Application Insights

[Application
Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview?toc=/azure/azure-monitor/toc.json)
is the Azure Monitor component designed to capture telemetry data from applications and workloads. Applications can include the Application Insights SDK, or the hosting web server can be configured to send telemetry without requiring modification to application code.

### Azure Monitor Integration

Azure Monitor provides a [REST API](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-rest-api-walkthrough)
for integration with external services and automation of monitoring and alerting services.

In addition, Azure Monitor offers [integration with may popular 3rd party
vendors](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-partners).

## Next steps

See [guidance and examples](../overview.md#azure-examples-and-guidance) of how to use core infrastructure components in the Azure cloud.

> [!div class="nextstepaction"]
> [Azure Examples and Guidance](../overview.md#azure-examples-and-guidance)