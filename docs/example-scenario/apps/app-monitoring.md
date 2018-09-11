---
title: Web Application Monitoring on Azure
description: This example scenario is relevant to organizations that want to monitor their application hosted in Azure App Service.
author: adamboeglin
ms.date: 09/12/2018
---

# Web Application Monitoring on Azure

Platform-as-a-service (PaaS) offerings on Azure manage compute resources for you and in some ways change how you monitor deployments. Azure includes multiple monitoring services, each of which performs a specific role. Together, these services deliver a comprehensive solution for collecting, analyzing, and acting on telemetry from your applications and the Azure resources they use.

This scenario addresses the monitoring services you can use and describes a dataflow model for use with multiple data sources. When it comes to monitoring, many tools and services work with Azure deployments. In this scenario, we choose readily available services precisely because they are easy to consume. Other monitoring options are discussed later in this article.

## Potential use cases

Consider this scenario for the following use cases:

- Instrumenting a web application for monitoring telemetry.
- Collecting front-end and back-end telemetry for an application deployed on Azure.
- Monitoring metrics and quotas associated with services on Azure.

## Architecture

![App Monitor Architecture Diagram][architecture]

This scenario uses a managed Azure environment to host an application and data tier. The data flows through the scenario as follows:

1. User interacts with app.
2. Browser and App Service emit telemetry.
3. Azure Application Insights collects and analyzes application health, performance, and usage data.
4. Developers and administrators can review health, performance, and usage information.
5. SQL Database emits telemetry.
6. Azure Monitor collects and analyzes infrastructure metrics and quotas.
7. Log Analytics collects and analyzes logs and metrics.
8. Developers and administrators can review health, performance, and usage information.

### Components

- [Azure App Service](https://azure.microsoft.com/documentation/services/app-service/) is a PaaS service for building and hosting apps in managed virtual machines. The underlying compute infrastructures on which your apps run is managed for you. App Service provides monitoring of resource usage quotas and app metrics, logging of diagnostic information, and alerts based on metrics. Even better, you can use Application Insights to create [availability tests](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-monitor-web-app-availability) for testing your application from different regions.

- [Application Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview) is an extensible Application Performance Management (APM) service for developers and supports multiple platforms. It monitors the application, detects application anomalies such as poor performance and failures, and sends telemetry to the Azure portal.
- [Azure Monitor](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-azure-monitor) provides base-level infrastructure [metrics and logs](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-supported-metrics) for most services in Azure. You can interact with the metrics in several ways, including charting them in Azure portal, accessing them through the REST API, or querying them using PowerShell or CLI. Azure Monitor also offers its data directly into [Log Analytics and other services](Collect%20Azure%20service%20logs%20and%20metrics%20for%20use%20in%20Log%20Analytics), where you can query and combine it with data from other sources on premises or in the cloud.

- [Log Analytics](https://docs.microsoft.com/azure/log-analytics/log-analytics-overview) helps correlate the usage and performance data collected by Application Insights with configuration and performance data across the Azure resources that support the app. This scenario uses the [Azure Log Analytics agent](https://blogs.msdn.microsoft.com/sqlsecurity/2017/12/28/azure-log-analytics-oms-agent-now-collects-sql-server-audit-logs/) to push SQL Server audit logs into Log Analytics. You can write queries and view data in the Log Analytics blade of the Azure portal.

## Considerations

A best practice is to add Application Insights to your code at development using the [Application Insights SDKs](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-asp-net), and customize per application. These open source SDKs are available for most application frameworks. To enrich and control the data you collect, incorporate the use of the SDKs both for testing and production deployments into your development process. The main requirement is for the app to have a direct or indirect line of sight to the Applications Insights ingestion endpoint hosted with an Internet-facing address. You can then add telemetry or enrich an existing telemetry collection.

Runtime monitoring is another easy way to get started. The telemetry that is collected must be controlled through configuration files. For example, you can include runtime methods that enable tools such as [Application Insights Status Monitor](https://azure.microsoft.com/en-us/updates/application-insights-status-monitor-and-sdk-updated/) to deploy the SDKs into the correct folder and add the right configurations to begin monitoring.

Like Application Insights, Log Analytics provides tools for [analyzing data across sources](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-dashboards), creating complex queries, and [sending proactive alerts](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-alerts) on specified conditions. You can also view telemetry in [the Azure portal](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-tutorial-dashboards). Log Analytics adds value to existing monitoring services such as [Azure Monitor](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-get-started) and can also monitor on-premises environments.

Both Application Insights and Log Analytics use [Azure Log Analytics Query Language](https://docs.loganalytics.io/docs/Learn). You can also use [cross-resource queries](https://azure.microsoft.com/en-us/blog/query-across-resources/) to analyze the telemetry gathered by Application Insights and Log Analytics in a single query.

Azure Monitor, Application Insights, and Log Analytics all send [alerts](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-alerts). For example, Azure Monitor alerts on platform-level metrics such as CPU utilization, while Application Insights alerts on application-level metrics such as server response time. Azure Monitor alerts on new events in the Azure Activity Log, while Log Analytics can issue alerts about metrics or event data for the services configured to use it. [Alerts (Preview)](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-unified-alerts) is a new, unified alerting experience in Azure that uses a different taxonomy.

### Alternatives

This article describes conveniently available monitoring options with popular features, but you have many choices, including the option to create your own logging mechanisms. A best practice is to add monitoring services as you build out tiers in a solution. Here are some possible extensions and alternatives:

- Consolidate Azure Monitor and Application Insights metrics in Grafana using the [Azure Monitor Data Source For Grafana](https://grafana.com/plugins/grafana-azure-monitor-datasource).

- Automate monitoring functions using [Azure Automation](https://docs.microsoft.com/azure/automation/automation-intro).

- Add communication with [ITSM solutions](https://azure.microsoft.com/en-us/blog/itsm-connector-for-azure-is-now-generally-available/).

- Extend Log Analytics with a [management solution](https://docs.microsoft.com/en-us/azure/monitoring/monitoring-solutions).

### Scalability and availability

This scenario focuses on PaaS solutions for monitoring in large part because they conveniently handle availability and scalability for you and are backed by service-level agreements (SLAs). For example, App Services provides a guaranteed [SLA](https://azure.microsoft.com/en-us/support/legal/sla/app-service/v1_4/) for its availability.

High availability considerations for the app you run, however, are the developer's responsibility. For information about scale, for example, see the [Scalability considerations](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/basic-web-app#scalability-considerations) section in the basic web application reference architecture. After an app is deployed, you can set up tests to [monitor its availability](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-monitor-web-app-availability) using Application Insights.

### Security

Sensitive information and compliance requirements affect data collection, retention, and storage. Learn more about how [Application Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-data-retention-privacy#personally-identifiable-information) and [Log Analytics](https://docs.microsoft.com/azure/log-analytics/log-analytics-data-security) handle telemetry.

The following security considerations may also apply:

- Develop a plan to handle personal information if developers are allowed to collect their own data or enrich existing telemetry.
- Consider data retention. For example, Application Insights retains telemetry data for 90 days. Archive data you want access to for longer periods using Microsoft Power BI, Continuous Export, or the REST API. Storage rates apply.
- Limit access to Azure resources to control access to data and who can view telemetry from a specific application. To help lock down access to monitoring telemetry, see [Resources, roles, and access control in Application Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-resources-roles-access-control).
- Consider whether to control read/write access in application code to prevent users from adding version or tag markers that limit data ingestion from the application. With Application Insights, there is no control over individual data items once they are sent to a resource, so if a user has access to any data, they have access to all data in an individual resource.
- Add [governance](https://docs.microsoft.com/en-us/azure/security/governance-in-azure) mechanisms to enforce policy or cost controls over Azure resources if needed. For example, use Log Analytics for security-related monitoring such as policies and RBAC, or use [Azure Policy](https://docs.microsoft.com/en-us/azure/azure-policy/azure-policy-introduction) to create, assign and, manage policy definitions.

- To monitor potential security issues and get a central view of the security state of your Azure resources, consider using [Azure Security Center](https://docs.microsoft.com/en-us/azure/security-center/security-center-intro).

## Pricing

Monitoring charges can add up surprisingly fast, so make sure to consider pricing up front, understand what you are monitoring, and check the associated fees for each service. Azure Monitor provides [basic metrics](https://docs.microsoft.com/azure/monitoring-and-diagnostics/monitoring-supported-metrics) at no cost, while monitoring costs for [Application Insights](https://azure.microsoft.com/pricing/details/application-insights/) and [Log Analytics](https://azure.microsoft.com/pricing/details/log-analytics/) are based on the amount of data ingested and the number of tests you run.

To help you get started, use the [pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/#log-analyticsc126d8c1-ec9c-4e5b-9b51-4db95d06a9b1) to estimate costs. To see how the pricing would change for your particular use case, change the various options to match your expected deployment.

Telemetry from Application Insights is sent to the Azure portal during debugging and after you have published your app. For testing purposes and to avoid charges, a limited volume of telemetry is instrumented. To add more indicators, you can raise the telemetry limit. For more granular control, see [Sampling in Application Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-sampling).

After deployment, you can watch a [Live Metrics Stream](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-live-stream) of performance indicators. This data is not stored---you are viewing real-time metrics---but the telemetry can be collected and analyzed later. There is no charge for Live Stream data.

Log Analytics is billed per gigabyte (GB) of data ingested into the service. The first 5 GB of data ingested to the Azure Log Analytics service every month is offered free, and the data is retained at no charge for first 31 days in your Log Analytics workspace.

## Next steps

Check out these resources designed to help you get started with your own monitoring solution:

[Basic web application reference architecture](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/basic-web-app#scalability-considerations)

[Start monitoring your ASP.NET Web Application](https://docs.microsoft.com/en-us/azure/application-insights/quick-monitor-portal)

[Collect data about Azure Virtual Machines](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-quick-collect-azurevm)

## Related resources

[Monitoring Azure applications and resources](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview)

[Find and diagnose run-time exceptions with Azure Application Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-tutorial-runtime-exceptions)

<!-- links -->
[architecture]: ./media/architecture-diagram-app-monitoring.png