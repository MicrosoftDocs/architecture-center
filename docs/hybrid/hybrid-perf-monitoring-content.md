This reference architecture shows how to use Azure Monitor to monitor the performance and availability of operating system (OS) workloads that run in virtual machines (VMs). The VMs can be in Microsoft Azure, in on-premises environments, or in non-Azure clouds.

## Architecture

![Diagram illustrating monitoring and availability functions of Azure Monitor for OS workloads in Azure, in on-premises environments, and with third-party cloud providers. Data is being sent into a Log Analytics workspace. The data is used by Application Insights, Analysis, Visualization, Alerts, and Autoscale services as part of Azure Monitor][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Workflow

- **On-premises main office - VM 1**. This component is a web application with internet access and a public-facing webpage, and both Log Analytics and Dependency agents installed. For information about agents, refer to [Log Analytics agent overview][agents-overview] and [Overview of Azure Monitor agents, Dependency agent][dependency-agent].
- **On-premises main office - VM 2**. This business-logic environment doesn't have internet access. It does, however, have Log Analytics and Dependency agents installed.
- **On-premises main office - VM 3**. This component is a datastore without internet access, but with Log Analytics and Dependency agents installed.
- **On-premises main office - Log Analytics gateway**. The Log Analytics gateway collects log and metric data from the three on-premises VMs, and delivers them into the *Log Analytics workspace* over Transmission Control Protocol (TCP) on port 443.
- **On-premises main office - Firewall**. Traffic to and from the on-premises environment is routed through the firewall.
- **Gateway**. The gateway provides connectivity to the branch office.
- **On-premises branch office - VM 4**. This component is the business application that's running without internet access, but with Log Analytics and Dependency agents installed. The Log Analytics agent installed on the VM is configured to transfer data directly to the Log Analytics workspace without the need for a Log Analytics gateway.
- **On-premises branch office - Gateway**. This gateway connects the branch office to the on-premises main office via a Virtual Private Network (VPN).
- **Third-party cloud provider - VM 5**. This component is a web application with internet access, a public-facing webpage, and both Log Analytics and Dependency agents installed.
- **Third-party cloud provider - VM 6**. This component is a datastore environment without internet access, but with both Log Analytics and Dependency agents installed. There is no direct connectivity from the third-party cloud provider environments to the on-premises environments.
- **Azure - VMSS**. This is a scale set that's created by using Azure Virtual Machine Scale Sets. It runs a business application with the log analytics and diagnostic agents installed.
- **Azure - Application server**. This server has a single VM running a business application, with Log Analytics and diagnostic agents installed.
- **Azure Monitor metrics**. Data collected by Azure Monitor metrics is stored in a time series database that's optimized for analyzing timestamped data. It also stores metrics sent from on-premises VMs and Azure VMs.
- **Azure Monitor - Log Analytics workspace**. This workspace stores logs sent from on-premises VMs, Azure VMs, and VMs on third-party cloud providers. The workspace is an Azure resource where data is aggregated, and it serves as an administrative boundary for accessing this data. Other Azure Monitor services then connect to the Log Analytics workspace and use the data for various purposes. For more information, see [Designing your Azure Monitor Logs deployment][design-deployment].
- **Azure Monitor - Insights - Application Insights**. Application Insights provides analyses of applications and insights into their use. In this example architecture, an availability ping test checks the availability of the on-premises web application. Alert rules are enabled to provide notification of a failed test. For more information, see [What is Application Insights?][app-insights] and [Monitor the availability of any website][website-availability].
- **Azure Monitor - Insights - Azure Monitor for VMs**. Azure Monitor for VMs monitors the performance and health of your virtual machines and virtual machine scale sets. The monitoring includes their running processes and dependencies on other resources. In this scenario, the Azure Monitor for VMs will provide insights into your virtual machines. For more information, see [What is Azure Monitor for VMs?][azmon-for-vms].
- **Azure Monitor - Analysis**. Log and metric data from the VMs is queried within Azure Monitor metrics and the Log Analytics workspace using the Kusto Query Language (KQL). The results provide insights into the infrastructure, topology, and resources. For more information, see [Kusto: Overview][kusto] and [Azure Monitor log query examples][query-examples].
- **Azure Monitor - Visualizations**. Azure Monitor uses visualization tools to review application and infrastructure components and communications between services in Azure Monitor. Visualization tools include **Application Map in Azure Application Insight**, **the Map feature of Azure Monitor for VMs**, **Azure Monitor Workbooks**, and various dashboard views available within Azure Monitor. For more information, see [Use the Map feature of Azure Monitor for VMs to understand application components][service-map], [Create and share dashboards of Log Analytics data][share-dashboards], and [Azure Monitor Workbooks][monitor-workbooks].
- **Azure Monitor - Integrations**. Azure Monitor integrates with a range of partner and third-party tools and extensions. These tools and extensions enhance and build upon existing Azure Monitor functionality, such as analysis and visualizations.
- **Azure Monitor - Actions - Alerts**. Variations in metric and log data can indicate the occurrence of events. Rules define the data variations that trigger alerts, provide notifications, and initiate remediation responses. In this architecture, when an alert is triggered, automation runbooks automatically remediate the on-premises VMs and Azure VMs. Webhook actions, Service Management integration, and other action types are also available. For more information, see [Create, view, and manage metric alerts using Azure Monitor][manage-metrics-alerts] and [Create, view, and manage log alerts using Azure Monitor][manage-log-alerts].
- **Azure Monitor - Actions - Autoscale**. Autoscale adds or removes VM instances according to deman, which maintains performance and increases cost effectiveness. In this architecture, Autoscale has conditions defined around average CPU load (in percentage). When conditions are met, Azure Monitor Autoscale will adjust the scale set according to demand. For more information, see [Overview of autoscale in Microsoft Azure][autoscale-overview].

### Components

The architecture consists of the following components:

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines)
- [Azure Monitor](https://azure.microsoft.com/products/monitor)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy)
- [Azure Event Hubs](https://azure.microsoft.com/products/event-hubs)
- [Azure Storage](https://azure.microsoft.com/product-categories/storage)

## Recommendations

The following best practices are recommendations that apply for most scenarios. Follow these practices unless you have a specific requirement that overrides them.

### Log Analytics workspace

Consider the following recommendations when designing the Log Analytics workspace:

- Place the workspace and resources in the same Azure region, if latency is an important factor.
- Start with a single Log Analytics workspace, and increase the number of workspaces as the requirements change.
- If you have geographically dispersed teams and resources, you might need one workspace per region.
- Your workspace doesn't need to be in the same subscription as the resources you're running.

### Alerts

For simpler scenarios, you can use metrics to flag alerts rather than logs. Metrics:

- Provide a count, or *numerical value*, for events such as CPU usage, available memory, or logical disk space.
- Have low latency.
- Offer greater granularity, for example per-second or per-minute intervals.
- Notify you about an issue quickly.

To collect custom performance indicators or business-specific metrics to provide deeper insights, use custom metrics. For more information, see [Custom metrics in Azure Monitor (Preview)][custom-metric-api].

Metrics alerts are not the answer in all situations. You might still want to use log-based alerts when you require more customization or more powerful correlations.

### Analysis and Diagnostics

Consider the following recommendations for analysis and diagnostics:

- Use logs for deeper analysis. Logs can:
  - Provide verbose detail about events (compared to metrics).
  - Happen intermittently.
  - Facilitate deeper diagnostics after an initial metric flag.

- Customize log data collection (which is similar to metrics) using the HTTP Data Collector API to send log data to a Log Analytics workspace. For more information, see [Send log data to Azure Monitor with the HTTP Data Collector API (public preview)][custom-log-api].

- Analyze your applications proactively with the **smart detection** feature of Application Insight. Smart detection applies the machine learning capabilities of Azure and statistical analysis <!-- If it's Azure's statistical analysis, rewrite as "capabilities and statistical analysis to..." -->to detect issues such as performance or failure anomalies, memory leaks, or general application degradation. For more information, see [Smart Detection in Application Insights][smart-detection].

- Use **Azure Monitor for VMs - Map** to review connections between servers, processes, inbound and outbound connection latency, and ports across any TCP-connected architecture. No configuration is required other than installing an agent. With **Azure Monitor for VMs - Map**, you can interact and engage with your servers as interconnected systems.

### Log Analytics queries

Query the data within a **Log Analytics workspace** by using KQL to search for terms, specific events, or states to identify trends and analyze patterns. Use the **Query explorer** to browse and select pre-written queries, modify them, or create your own. You can run, save, share, and export queries from within a workspace, and pin your favorite queries to a dashboard for reuse.

### Agent installation

Install agents automatically and at scale, rather than individually, by using automation options such as Azure Policy, Azure PowerShell, Resource Manager templates, or Desired State Configuration (DSC). For more information, see [Enable Azure Monitor for VMs by using Azure Policy][vms-by-policy], [Enable Azure Monitor for VMs using Azure PowerShell][vms-by-powershell], and [Enable Azure Monitor for VMs for a hybrid virtual machine - Desired State Configuration][vm-by-dsc].

### Dashboard

For critical applications, create an **Azure Dashboard** view. Share or make your dashboard available on a shared screen, in real time, to people who need critical application data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

The following considerations help to ensure availability in your environment.

- Availability tests. The URL ping test used in this architecture is the simplest *outside-in* availability test. However, other options are available, such as:
  - Multi-step web test. Plays back recordings of sequenced web requests to test complex scenarios. Multiple-step web tests are created in Microsoft Visual Studio Enterprise, and then uploaded to the portal for execution.
  - Custom track availability tests. Use the `TrackAvailability()` method to send test results to Application Insights.
- Alerts. When you create an availability test in Application Insights, event alert notifications are enabled by default. You can edit the alert rules by specifying the notification type and details, from **Azure Monitor** > **Alerts**.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The following items are considerations for making your environment more secure.

- Log Analytics workspace. Access modes are defined as one of the following contexts:
  - Workspace context. All logs that the workspace has permission to access can be queried. This is a vertical access approach. For example, a security team might need access to all resource data from the top down.
  - Resource context. Only logs for specific resources can be queried. For example, an application team can be granted access to logs for the particular resource they're working on.
- Secure data in transit to Log Analytics. Data in transit is secured using minimum Transport Layer Security (TLS) 1.2. You don't need to enable this feature explicitly. For more information, see [Log Analytics data security][data-security].
- Secure data at rest in Log Analytics. Data at rest in Log Analytics is secured, as per Azure Storage, using 256-bit Advanced Encryption Standard (AES) encryption by default.
- Smart Detection. Use Smart Detection in Application Insights to analyze the telemetry generated by your application, and to detect security issues. For more information, see [Application security detection pack (preview)][detection-pack].
- Integrate Azure Monitor with Security Information and Event Management (SIEM) tools. Route your monitoring data to an event hub with Azure Monitor to integrate external SIEM and monitoring tools. For more information, see [Stream Azure monitoring data to an event hub or external partner][event-hub].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The following items are considerations for controlling and managing costs in your environment.

- Azure Monitor. Azure Monitor costs are consumption-based, often referred to as *pay as you go*.
- Log Analytics. You pay for **data ingestion** and **data retention**. You can estimate and forecast the number of VMs, and the amount of data (in gigabytes) you expect to collect from each VM. A typical Azure VM consumes between 1 gigabyte (GB) and 3 GB of data each month. If you're evaluating data usage with Azure Monitor logs, use the data statistics from your own environment and obtain a discount with **Capacity reservations**.
- Application Insights. This component is billed according to the volume of telemetry data your application sends, and the number of web tests you run.
- Metric queries. Metric queries are billed by the number of calls made.
- Alerts. Alerts are billed based on the type, and number, of signals monitored.
- Notifications. Notifications are billed according to the type, and number, of notifications you send.
- Azure Monitor. The **Usage and estimated costs** section of Azure Monitor estimates your monthly costs based on the previous 31 days of usage.
- For more information, see [Azure Monitor pricing][monitor-pricing] and [Pricing calculator][pricing-calculator].

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### Manageability

The following are considerations for making your environment more manageable.

- Azure Workbooks. Use workbooks to help perform further analysis, and create rich reports. Workbooks combine text, log queries, metrics, and parameters into interactive reports. Team members with access to the same Azure resources can edit workbooks. For more information, see [Create interactive reports Azure Monitor for VMs with workbooks][interactive-workbooks].
- Partner integrations. Integrate Azure Monitor with partner and third-party tools to assist with analysis, visualization, alerts, or Service Management and Azure Pipelines. For more information, see [Azure Monitor partner integrations][partner-integrations].
- Integrate Azure Monitor with Microsoft System Center. Integrate Azure Monitor with the System Center product suite. For more information, see [Connect Operations Manager to Azure Monitor][ops-manager].
- Send data to Azure Event Hubs. For integrating Azure Monitor with visualization and external monitoring tools, refer to [Stream Azure monitoring data to an event hub or external partner][event-hub].
- Log Analytics gateway. For smaller environments such as the branch office, use the agent to transfer data into the Log Analytics workspace, rather than into a gateway. For more information, see [Establish connectivity to Azure Log Analytics][connect-to-la].

#### DevOps

The following are considerations for integrating your environment with DevOps processes and solutions.

- Application Insights. Integrate Application Insights into Azure Pipelines to help make performance and usability improvements. Application Insights can detect performance anomalies automatically. It connects to various development tools, such as Azure DevOps Services and GitHub.
- Application Instrumentation. *Instrument* applications by modifying application code to enable telemetry with Application Insights. The following methods are ways to instrument applications:
  - At runtime. Instrumenting your web application on the server at runtime is ideal for applications that are deployed already, as it avoids having to update code. Suitable scenarios include:
    - Microsoft ASP.NET or ASP.NET Core applications hosted on Azure Web Apps
    - ASP.NET applications hosted in Microsoft Internet Information Services (IIS) on a virtual machine or virtual machine scale set
    - ASP.NET applications hosted in IIS on an on-premises VM
    - Java-based Azure Functions
    - Node.JS apps on Linux App Services
    - Microservices hosted on AKS
  - At development time. Add Application Insights to your code to customize telemetry collection and send more data. Supported languages and platforms include:
    - ASP.NET applications
    - ASP.NET Core applications
    - .NET Console applications
    - Java
    - Node.js
    - Python
- Use IT Service Management Connector (ITSMC) to connect to external IT Service Management (ITSM) tools. ITSMC connects Azure to supported ITSM products and services, where issue-related work items typically reside. For more information, see [Connect Azure to ITSM tools using IT Service Management Connector][itsm].

### Performance efficiency

Performance efficiency is the ability of your workload to scale in an efficient manner to meet the demands that your users place on it. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

The following are considerations for scaling your environment.

- Automate installation and configuration of your resources and applications.
- Large-scale geographically dispersed applications. Use **Distributed Tracing** within Application Insights to track dependencies and calls across multiple application components, backend resources, and microservices environments. With **Distributed Tracing** you can debug applications that call across process boundaries, outside the local stack. (You don't need to enable **Distributed Tracing**, it's available automatically as part of App Insights.)
  - Two options for consuming distributed trace data are:
    - Transaction diagnostics experience. This experience is similar to a call stack with an added time dimension. The transaction diagnostics experience provides visibility into one single transaction/request. It's helpful for finding the root cause of reliability issues and performance bottlenecks on a per-request basis. For more information, see [What is Distributed Tracing?][distributed-tracing]
    - Application map experience. This aggregates many transactions to demonstrate how systems interact topologically, and provide average performance and error rates. For more information, see [Application Map: Triage Distributed Applications][triage-applications].

## Next steps

Learn more about the component technologies:

- [Azure Event Hubs — A big data streaming platform and event ingestion service](/azure/event-hubs/event-hubs-about)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [What are virtual machine scale sets?](/azure/virtual-machine-scale-sets/overview)
- [Overview of autoscale in Microsoft Azure](/azure/azure-monitor/autoscale/autoscale-overview)
- [What is Application Insights?](/azure/azure-monitor/app/app-insights-overview)

## Related resources

Explore related architectures:

- [Serverless event processing](../reference-architectures/serverless/event-processing.yml)
- [Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)
- [Unified logging for microservices applications](../example-scenario/logging/unified-logging.yml)
- [Microservices architecture on Azure Service Fabric](../reference-architectures/microservices/service-fabric.yml)

[architectural-diagram]: ./images/hybrid-perf-monitoring.svg
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/hybrid-perf-monitoring.vsdx
[agents-overview]: /azure/azure-monitor/platform/log-analytics-agent
[dependency-agent]: /azure/azure-monitor/platform/agents-overview#dependency-agent
[design-deployment]: /azure/azure-monitor/platform/design-logs-deployment
[app-insights]: /azure/azure-monitor/app/app-insights-overview
[website-availability]: /azure/azure-monitor/app/monitor-web-app-availability
[kusto]: /azure/data-explorer/kusto/query/
[query-examples]: /azure/azure-monitor/log-query/examples
[manage-metrics-alerts]: /azure/azure-monitor/platform/alerts-metric
[manage-log-alerts]: /azure/azure-monitor/platform/alerts-log
[autoscale-overview]: /azure/azure-monitor/platform/autoscale-overview
[service-map]: /azure/azure-monitor/insights/vminsights-maps
[share-dashboards]: /azure/azure-monitor/learn/tutorial-logs-dashboards
[monitor-workbooks]: /azure/azure-monitor/platform/workbooks-overview
[custom-metric-api]: /azure/azure-monitor/platform/metrics-custom-overview
[custom-log-api]: /azure/azure-monitor/platform/data-collector-api
[smart-detection]: /azure/azure-monitor/app/proactive-diagnostics
[vms-by-policy]: /azure/azure-monitor/insights/vminsights-enable-at-scale-policy
[vms-by-powershell]: /azure/azure-monitor/insights/vminsights-enable-at-scale-powershell
[vm-by-dsc]: /azure/azure-monitor/insights/vminsights-enable-hybrid-cloud#desired-state-configuration
[distributed-tracing]: /azure/azure-monitor/app/distributed-tracing
[triage-applications]: /azure/azure-monitor/app/app-map?tabs=net
[interactive-workbooks]: /azure/azure-monitor/insights/vminsights-workbooks
[partner-integrations]: /azure/azure-monitor/platform/partners
[ops-manager]: /azure/azure-monitor/platform/om-agents
[event-hub]: /azure/azure-monitor/platform/stream-monitoring-data-event-hubs
[connect-to-la]: /services-hub/health/establish-connectivity-to-azure
[data-security]: /azure/azure-monitor/platform/data-security
[detection-pack]: /azure/azure-monitor/app/proactive-application-security-detection-pack
[itsm]: /azure/azure-monitor/platform/itsmc-overview
[monitor-pricing]: https://azure.microsoft.com/pricing/details/monitor/
[pricing-calculator]: https://azure.microsoft.com/pricing/calculator/?service=monitor
[azmon-for-vms]: /azure/azure-monitor/insights/vminsights-overview
