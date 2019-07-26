---
title: Cloud monitoring guide – Monitoring Azure cloud apps
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Choose when to use Azure Monitor or System Center Operations Manager in Microsoft Azure
author: mgoedtel
ms.author: magoedte
ms.date: 06/26/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: operate
services: azure-monitor
---

# Cloud monitoring guide: Monitoring Azure cloud applications

This article includes our recommended monitoring strategy for each of the cloud deployment models, based on the following criteria:

- You require continued commitment to Operations Manager or other enterprise monitoring platform. This is because of integration with your IT operations processes, knowledge and expertise, or because certain functionality isn't available yet in Azure Monitor.
- You have to monitor workloads both on-premises and in the public cloud, or just in the cloud.
- Your cloud migration strategy includes modernizing IT operations and moving to our cloud monitoring services and solutions.
- You might have critical systems that are air-gapped or physically isolated, hosted in a private cloud or on physical hardware, and need to be monitored.

## Azure cloud monitoring

Azure Monitor is the platform service that provides a single source for monitoring Azure resources. It's designed for cloud solutions that are built on Azure, and that support a business capability that is based on VM workloads or complex architectures that use microservices and other platform resources. It monitors all layers of the stack, starting with tenant services such as Azure Active Directory Domain Services, and subscription-level events and Azure service health. It also monitors infrastructure resources like VMs, storage, and network resources, and, at the top layer, your application. Monitoring each of these dependencies, and collecting the right signals that each can emit, gives you the observability of applications and the key infrastructure you need.

The following table summarizes the recommended approach to monitoring each layer of the stack.

<!-- markdownlint-disable MD033 -->

Layer | Resource | Scope | Method
---|---|---|----
Application | Web-based application running on .NET, .NET Core, Java, JavaScript, and Node.js platform on an Azure VM, Azure App Services, Azure Service Fabric, Azure Functions, and Azure Cloud Services | Monitor a live web application to automatically detect performance anomalies, identify code exceptions and issues, and collect usability telemetry. |  Application Insights
Containers | Azure Kubernetes Service/Azure Container Instances | Monitor capacity, availability, and performance of workloads running on containers and container instances. | Azure Monitor for containers
Guest operating system | Linux and Windows VM operating system | Monitor capacity, availability, and performance. Map dependencies hosted on each VM, including the visibility of active network connections between servers, inbound and outbound connection latency, and ports across any TCP-connected architecture. | Azure Monitor for VMs
Azure resources - PaaS | Azure Database services (for example, SQL or mySQL) | Azure Database for SQL performance metrics. | Enable diagnostic logging to stream SQL data to Azure Monitor Logs.
Azure resources - IaaS | 1. Azure Storage<br/> 2. Azure Application Gateway<br/> 3. Azure Key Vault<br/> 4. Network security groups<br/> 5. Azure Traffic Manager | 1. Capacity, availability, and performance.<br/> 2. Performance and diagnostic logs (activity, access, performance, and firewall).<br/> 3. Monitor how and when your key vaults are accessed, and by whom.<br/> 4. Monitor events when rules are applied, and the rule counter for how many times a rule is applied to deny or allow.<br/>5. Monitor endpoint status availability. | 1. Storage metrics for Blob storage.<br/> 2. Enable diagnostic logging and configure streaming to Azure Monitor Logs.<br/> 3. <br/> 4. Enable diagnostic logging of network security groups, and configure streaming to Azure Monitor Logs.<br/> 5. Enable diagnostic logging of Traffic Manager endpoints, and configure streaming to Azure Monitor Logs.
Network| Communication between your virtual machine and one or more endpoints (another VM, a fully qualified domain name, a uniform resource identifier, or an IPv4 address). | Monitor reachability, latency, and network topology changes that occur between the VM and the endpoint. | Azure Network Watcher
Azure subscription | Azure service health and basic resource health | <li> Administrative actions performed on a service or resource.<br/><li> Service health with an Azure service is in a degraded or unavailable state.<br/><li> Health issues detected with an Azure resource from the Azure service perspective.<br/><li> Operations performed with Azure Autoscale indicating a failure or exception. <br/><li> Operations performed with Azure Policy indicating that an allowed or denied action occurred.<br/><li> Record of alerts generated by Azure Security Center. |Delivered in the Activity Log for monitoring and alerting by using Azure Resource Manager.
Azure tenant|Azure Active Directory || Enable diagnostic logging, and configure streaming to Azure Monitor Logs.

<!-- markdownlint-enable MD033 -->

## Hybrid cloud monitoring

Some organizations aren't ready to embrace the latest DevOps practices and cloud innovations to manage their heterogenous environments with Azure Monitor. For this situation, Microsoft has several strategies intended to support your business and IT operational goals, realizing the need for integration and phased migration from your current tools to Monitor.

The following are the likely candidates for this scenario:  

- You need to collect data from Azure resources supporting the workload, and forward them to your existing on-premises or managed service provider tools.
- You need to maintain investment in System Center Operations Manager, and configure it to monitor IaaS and PaaS resources running in Azure. Optionally, because you are monitoring two environments with different characteristics, based on your requirements, you determine integrating with Monitor supports your strategy.
- As part of your modernization strategy, you commit to Monitor for monitoring the resources in Azure and on your corporate network. This decision represents an effort to standardize on a single tool, and reduce costs and complexity.

### Collect and stream monitoring data to third-party or on-premises tools

To collect metrics and logs from Azure infrastructure and platform resources, you enable Azure diagnostic logs for those resources. For Azure VMs, you can collect metrics and logs from the guest operating system, and other diagnostic data using the Azure Diagnostics extension. By using [Event Hubs](https://docs.microsoft.com/azure/azure-monitor/platform/diagnostic-logs-stream-event-hubs), you can stream diagnostic data emitted from Azure resources to your on-premises tools or managed service provider.

### Monitor with System Center Operations Manager

This is the best choice if you require a monitoring platform that provides full visibility and holistic health monitoring of the application. This includes monitoring the workload components that have been migrated to Azure and that are still on-premises. The knowledge defined in management packs describes how to monitor the individual dependencies and components. These include the guest operating system (Windows and Linux), the workloads running on the VM (for example, SQL Server and Apache Tomcat), and resources hosted in Azure that use the Azure Management Pack. To describe and measure the end-to-end health of the application, you customize Operations Manager to build a model representing the relationship among the components of the application. This model allows you to view the overall health of the application at any point in time, as well as measure the availability of your application against defined SLAs.

With Azure or other cloud providers existing as an extension of your own on-premises network, with Operations Manager you can monitor the Linux and Windows VMs as if they were on your corporate network and intranet. At a minimum, monitoring VMs requires deploying the Operations Manager monitoring agent on the VMs. You must also deploy the applicable operating system management pack that supports the version of the operating system installed on the VMs.

At the application tier, Operations Manager offers basic application performance monitoring capabilities for some versions of .NET and Java. If certain applications within your hybrid cloud environment operate in an offline or network-isolated mode, such that they can't communicate with a public cloud service, Operations Manager might be your best option. For applications, hosted both on-premises and in any public cloud, that allow communication through a firewall to Azure, use Azure Monitor Application Insights. This offers deep, code-level monitoring, with first-class support for .NET, .NET Core, Java, JavaScript, and Node.js.

For any web application that can be reached externally, enable availability monitoring. It's extremely important to know if your application, or a critical HTTP/HTTPS endpoint that your app relies on, is available and responsive. Application Insights availability monitoring allows you to run tests from multiple Azure datacenters, and provide insight into the health of your application from a global perspective.

After availability monitoring is in place, Application Insights offers two core forms of code level monitoring: live application monitoring or SDK-based monitoring.

**Live app monitoring** is available for .NET and .NET Core. It allows instrumenting an application without modifying its internal code. You can use live app monitoring to quickly add monitoring to an already deployed live application that you wrote. You can also perform deep application monitoring against third-party .NET applications, where you don’t necessarily have access to the source code. Live app monitoring can collect:

- Requests and exceptions.
- Dependency diagnostic information, including SQL Command text.
- System performance counters.

**SDK-based monitoring** integrates the Application Insights SDK directly into your app’s codebase. It's therefore much more flexible, and allows a level of granularity in monitoring that wouldn't otherwise be possible as you can add custom tracking to any part of your code. A subset of SDK-based monitoring is *client-side monitoring*, where JavaScript is used to collect information on the customer’s in-browser experience of your web app. This collection allows for deep user behavior analytics of both the server-side and client-side experiences.

Integrating Azure Monitor with Operations Manager provides several advantages:

- Monitor Logs delivers a scalable, powerful, integrated analytics platform. It complements the Operations Manager data warehouse database when you want to collect specific and valued performance and log data. Monitor delivers better analytics, performance when querying large data volume, and retention than the Operations Manager data warehouse. The Kusto query language allows you to create much more complex and sophisticated queries, with an ability to run queries across terabytes of data in seconds. You can quickly transform your data into pie charts, time charts, and many other visualizations. No longer are you constrained by working with reports in Operations Manager based on SQL Server Reporting Services, custom SQL queries, or other workarounds to analyze this data.

- Analyze alerts using the Azure Monitor Alerts Management solution. Alerts generated in the Operations Manager management group are forwarded to the Azure Monitor Logs Analytics workspace. You can configure the subscription responsible for forwarding alerts from Operations Manager to Monitor Logs to only forward certain alerts. For example, you can forward only alerts that meet your criteria for querying in support of problem management for trends, and investigation of the root cause of failures or problems, through a single pane of glass. Additionally, you can correlate other log data from Application Insights or other sources, to gain insight to help improve user experience, increase uptime, and reduce time to resolve incidents.

- Use the System Center Operations Manager Health Check solution to assess the risk and health of your System Center Operations Manager management group on a regular interval.

- With the Map feature of Azure Monitor for VMs, you can monitor standard connectivity metrics from network connections between your Azure VMs and on-premises VMs. These metrics include response time, requests per minute, traffic throughput, and links. You can identify failed connections, troubleshoot, perform migration validation, perform security analysis, and verify the overall architecture of the service. Map can automatically discover application components on Windows and Linux systems, and map the communication between services. This helps you identify connections and dependencies you were unaware of, plan and validate migration to Azure, and minimize speculation during incident resolution.

- By using Network Performance Monitor, monitor the network connectivity between:

  - Your corporate network and Azure.
  - Mission critical multitier applications and micro-services.
  - User locations and web-based applications (HTTP/HTTPs).
  
  This strategy can deliver visibility of the network layer, without the need for SNMP. It can also present in an interactive topology map the hop-by-hop topology of routes between the source and destination endpoint. It can be a better choice than attempting to accomplish the same result with network monitoring in Operations Manager, or other network monitoring tools currently used in your organization.

### Monitor with Azure Monitor

Use Azure Monitor to migrate from one or more on-premises enterprise monitoring tools, as part of your cloud migration strategy. But understand that it was not designed with the intention of replacing a mature product like Operations Manager. There are distinct features available in Operations Manager and other on-premises enterprise monitoring platforms that Monitor doesn’t provide.

- Azure Monitor for VMs introduces health monitoring in the cloud, but doesn't support monitoring VMs outside of Azure, nor other infrastructure or platform resources supporting the application. Additionally, it doesn't include support for creating the custom health monitoring criteria you might need to meet your monitoring requirements.
- Azure Monitor doesn't include the notion of a service model that represents the components and relationships among them. Instead, you enable data collection from each resource, and configure your monitoring logic after the data is written to the metric or logs store.
- You can't convert your monitoring configuration from System Center Operations Manager into a Resource Manager template. For example, if you want to transition the monitoring configuration from management packs targeting the guest operating system and workloads running on the VM, there is no conversion tool available.
- You can't suppress alerts during planned or emergency maintenance windows.
- Visualizing data in Azure Monitor is delivered by using several different features in Azure. These features include Azure dashboards, Monitor views delivered with monitoring solutions for log data, and workbooks for incident investigation. Each of these visualization methods is applicable across several scenarios. However, there are limitations pertaining to Grafana for rich dashboards, and to exporting the data to Power BI to deliver business and IT-centric dashboards. We recommend using reports for different personas in the organization.
- Centralized and effective management of a predefined monitoring configuration (solutions, data collection, alerting, and visualizations) isn't available. Neither is verification of applying a configuration change, and how to best define targeting and grouping of affected resources.
- Microsoft consolidated alerting in Monitor to deliver a centralized alerting service. It takes advantage of cloud services, such as machine learning. Monitor alerting doesn't have some features, such as searching alerts based on a query, customized notification messages, and suppression of alerts.
- Monitor identifies if the agent stops sending data to the service, by using a heartbeat event it generates and sends every 60 seconds. It doesn't monitor and alert other aspects of agent health, such as resource utilization, nor does it monitor and alert if there is latency between the agent to the service. Monitoring the agent requires custom-developed monitoring logic with Azure Monitor to proactively identify symptoms affecting agent performance and reliability.

## Private cloud monitoring

You can achieve holistic monitoring of Azure Stack with System Center Operations Manager. Specifically, you can monitor the workloads running in the tenant, the resource level, on the virtual machines, and the infrastructure hosting Azure Stack (physical servers and network switches). You can also achieve holistic monitoring with a combination of [infrastructure monitoring capabilities](/azure/azure-stack/azure-stack-monitor-health) included in Azure Stack. These capabilities help you view health and alerts for an Azure Stack region and the [Azure Monitor service](/azure/azure-stack/user/azure-stack-metrics-azure-data) in Azure Stack, which provides base-level infrastructure metrics and logs for most services.

If you've already invested in Operations Manager, use the Azure Stack management pack to monitor the availability and health state of Azure Stack deployments. This includes regions, resource providers, updates, update runs, scale units, unit nodes, infrastructure roles, and their instances (logical entities comprised of the hardware resources). It uses the Health and Update resource provider REST APIs to communicate with Azure Stack. To monitor physical servers and storage devices, use the OEM vendors' management pack (for example, provided by Lenovo, Hewlett Packard, or Dell). Operations Manager can natively monitor the network switches to collect basic statistics by using the SNMP protocol. Monitoring the tenant workloads is possible with the Azure management pack by following two basic steps. Configure the subscription that you want to monitor, and then add the monitors for that subscription.

## Summary

To summarize, the following table highlights monitoring scenarios and how our monitoring platforms support each scenario.

Scenario | Azure Monitor | Operations Manager
:--|:---|:---
Infrastructure monitoring | Currently delivers health monitoring experience for Azure VMs, somewhat similar to Operations Manager. | Supports monitoring most of the infrastructure from the corporate network. Tracks availability state, metrics, and alerts for Azure VMs, SQL, and storage via the Azure management pack (polling Azure Resource Manager APIs).
Monitor server workloads | Can collect IIS and SQL Server error logs, Windows events, and performance counters. Requires creating custom queries, alerts, and visualizations. | Supports monitoring most of the server workloads with available management packs. Requires either the Log Analytics Windows agent or Operations Manager agent on the VM, reporting back to the management group on the corporate network.
Web application monitoring | Application Insights includes support for the latest versions of .NET, Java, and other platforms. Comprehensive web application monitoring to detect and help diagnose issues with code, capacity, and responsiveness. | Supports monitoring older versions of .NET and Java web servers. Requires creating a custom management pack by using REST API to query data from Application Insights and stream to Operations Manager.
Azure service monitoring | [Azure Service Health](https://docs.microsoft.com/azure/service-health/overview) provides the ability to monitor your service, and how the health of the underlying Azure infrastructure affects your service. | While there is no native monitoring of Azure service health provided today through a management pack, you can create custom workflows to query Azure service health alerts. Use the Azure REST API, and get alerts through your existing notifications.
Network performance monitoring | Azure Monitor Network Insights monitors the Azure networking stack, network performance, and NSGs. Azure Monitor for VM's Map feature includes connectivity metrics between Azure and other environment VMs. | Supports availability checks, and collects basic statistics from network devices by using the SNMP protocol from the corporate network.
Data aggregation | Azure Monitor Logs and alert management support processing data from Operations Manager and other platforms. | Relies on SQL Server Reporting Services pre-canned or custom reports, third-party visualization solutions, or a custom Power BI implementation. There are scale and performance limitations with the Operations Manager data warehouse. Integrate with Azure Monitor Logs as an alternative for data aggregation requirements. Integration is achieved by configuring the Log Analytics connector.
End-to-end diagnostics, root-cause analysis, and timely troubleshooting | Azure Monitor delivers end-to-end diagnostics and root-cause analysis for developer and IT operations, from your cloud and on-premises environments. It does this through several features and tools that provide valuable insights into your applications and other resources that they depend on.| Supports end-to-end diagnostics and troubleshooting only for on-premises infrastructure and applications. It uses other System Center components or partner solutions.
Experiences – Dashboards, reports, integrations with IT/DevOps tools | Supports integration with Azure dashboards, Power BI, Grafana, and integration with ITSM tools to forward collected data and alerts. | Supports dashboards natively, or by using partner solutions from Squared Up and Savision. Integrates with ITSM tools by using custom code, System Center Orchestrator, or partner solutions based on the Operations Manager SDK.

## Next steps

> [!div class="nextstepaction"]
> [Collecting the right data](./data-collection.md)
