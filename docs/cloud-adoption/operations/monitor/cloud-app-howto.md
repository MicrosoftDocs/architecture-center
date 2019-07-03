---
title: Cloud monitoring guide – Monitoring Azure cloud apps
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Choose when to use Azure Monitor or System Center Operations Manager in Microsoft Azure
services: azure-monitor
keywords: 
author: mgoedtel
ms.author: magoedte
ms.date: 06/26/2019
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Cloud monitoring guide: Monitoring Azure cloud applications

This article includes our recommended monitoring strategy for each of the cloud deployment models, based on the following criteria:

* You require continued commitment to Operations Manager or other enterprise monitoring platform because of integration with your IT operations processes, knowledge and expertise, or because certain functionality is not available yet in Azure Monitor.
* You have to monitor workloads both on-premise and in the public cloud, or just in the cloud.
* Your cloud migration strategy includes modernizing IT operations and moving to our cloud monitoring services and solutions.
* You may have critical systems that are air gapped or physically isolated, hosted in a private cloud or on physical hardware, and need to be monitored. 

## Azure cloud monitoring

For cloud solutions built on Azure supporting a business capability that is based on VM workloads to more complex architectures using microservices and other platform resources, Azure Monitor is the platform service that provides a single source for monitoring Azure resources. It monitors all layers of the stack starting with tenant services such as Azure AD Domain Services, subscription-level events and Azure service health, infrastructure resources like VMs, storage, and network resources, and at the top layer  –  your application.  Monitoring each of these dependencies and collecting the right signals each can emit allows IT operations, developers, and service owners provide observability of applications and the key infrastructure they rely on.  

The following table summarizes the recommended approach to monitoring each layer of the stack using Azure Monitor and other supporting services and solutions in Azure.

Layer | Resource | Scope | Method
---|---|---|----
Application | Web-based application running on .NET, .NET Core, Java, JavaScript, and Node.js platform on an Azure VM, Azure App Services, Service Fabric, Azure Functions, and Azure Cloud Services | Monitor a live web application to automatically detect performance anomalies, identify code exceptions and issues, and collect usability telemetry. |  Application Insights
Containers | Azure Kubernetes Service/Azure Container Instances | Monitor capacity, availability, and performance of workloads running on containers and container instances. | Azure Monitor for containers
Guest OS | Linux and Windows VM operating system | Monitor capacity, availability, and performance. Map dependencies hosted on each VM, including visibility of active network connections between servers, inbound and outbound connection latency, and ports across any TCP-connected architecture. | Azure Monitor for VMs
Azure resources - PaaS | Azure Database services (SQL, mySQL, etc.) | Azure Database for SQL performance metrics. | Enable diagnostic logging to stream SQL data to Azure Monitor Logs.
Azure resources - IaaS | 1. Azure Storage<br/> 2. Application Gateways<br/> 3. Azure Key Vault<br/> 4 Network Security Groups<br/> 5. Traffic Manager | 1. Capacity, availability, and performance.<br/>2. Performance and diagnostic logs (activity, access, performance, and firewall)<br/>3. Monitor how and when your key vaults are accessed, and by whom.<br/>4. Monitor events when rules are applied and rule counter for how many times rule applied to deny/allow.<br/>5. Monitor endpoint status availability. | 1. Storage metrics for blob storage (table and queues available at later date). <br/> 2. Enable diagnostic logging and configure streaming to Azure Monitor Logs. <br/> 3. Enable diagnostic logging of Network Security Groups and configure streaming to Azure Monitor Logs. <br/> 4.Enable diagnostic logging of Traffic Manager endpoints and configure streaming to Azure Monitor Logs.
Network| Communication between your virtual machine and one or more endpoints (another VM, a fully qualified domain name, a uniform resource identifier, or IPv4 address). | Monitor reachability, latency, and network topology changes that occur between the VM and the endpoint. | Azure Network Watcher
Azure subscription | Azure service health and basic resource health | - Administrative actions performed on a service or resource<br/>- Service health with an Azure service is in a degraded or unavailable state<br/>- Health issues detected with an Azure resource from the Azure service perspective<br/>- Operations performed with Azure autoscale engine indicating a failure or exception <br/>- Operations performed with Azure Policy indicating an allowed or denied action occurred<br/>- Record of alerts generated by Azure Security Center |Delivered in the Activity Log for monitoring and alerting using Azure Resource Manager.
Azure tenant|Azure Active Directory || Enable diagnostic logging and configure streaming to Azure Monitor logs.

## Hybrid cloud monitoring

For most organizations that proceed with migrating to the cloud starting with the hybrid model, some are not ready to embrace the latest DevOps practices and cloud innovations to manage their heterogenous environments with Azure Monitor.  In understanding this challenge, we share several strategies that are intended to support your business and IT operational goals, realizing the need for integration and phased migration from your current tools to Azure Monitor.  

The following are the approaches we recognize as likely candidates for this scenario:  

* Collect data from Azure resources supporting the workload and forward them to your existing on-premise or managed service provider tools.
* Maintain investment in System Center Operations Manager and configure it to monitor IaaS and PaaS resources running in Azure.  Optionally, because you are monitoring two environments with different characteristics, based on your requirements, you determine integrating with Azure Monitor supports your strategy.   
* As part of your modernization strategy, you commit to Azure Monitor for monitoring the resources in Azure and on your corporate network in an effort to standardize on a single tool and reduce costs/complexity.

### Collect and stream monitoring data to third party or on-prem tools

To collect metrics and logs from Azure infrastructure and platform resources, you enable Azure diagnostic logs for those resources.  For Azure VMs, you can collect metrics and logs from the guest operating system, and other diagnostic data using the Diagnostics extension.  The diagnostic data emitted from Azure resources can be configured to stream it using [Event Hubs](https://docs.microsoft.com/azure/azure-monitor/platform/diagnostic-logs-stream-event-hubs) to forward to your on-premises tools or managed service provider. 

### Monitor with System Center Operations Manager

System Center Operations Manager is the best choice for customers who require a monitoring platform that provides full visibility and holistic health monitoring of the application, including the workload components that have been migrated to Azure and that are still on-prem.  The knowledge defined in management packs describes how to monitor the individual dependencies and components, such as the guest operating system (Windows and Linux), the workloads running on the VM (IIS, SQL Server, Apache Tomcat, etc.), and resources hosted in Azure using the Azure Management Pack.  To describe and measure end-to-end health of the application, you customize Operations Manager to build a model representing the relationship between the components of the application.  This model allows you to view overall health of the application at any point in time, as well as measure its availability of your application against defined SLAs.

With Azure or other cloud providers existing as an extension of your own on premises network, with Operations Manager you can monitor the Linux and Windows VMs as if they were on your corporate network and intranet.  Monitoring VMs requires deploying the Operations Manager monitoring agent on the VMs at a minimum, and the applicable operating system management pack that supports the version of the OS installed on the VMs.  

At the application tier, Operations Manager can offer basic APM capabilities for some versions of .NET and Java. If certain applications within your hybrid cloud environment operate in an offline or network isolated mode such that they cannot under any circumstances communicate with a public cloud service, Operations Manager may be your best option. For applications hosted both on premises and in any public cloud that are able to allow communication through a firewall to Azure, use Azure Monitor Application Insights, as it offers deep code-level monitoring with first class support for .NET, .NET Core, Java, JavaScript, and Node.js. For any web application that can be reached externally, enable availability monitoring. Knowing if your application or a critical HTTP/HTTPS endpoint that your app relies on is up or down from a customer perspective, as well as its responsiveness is extremely important. Application Insights availability monitoring allows you to have the tests run from multiple Azure datacenters and provide insight into the health of your application from a global perspective.

Once availability monitoring is in place, Application Insights offers two core forms of code level monitoring: **live application monitoring** or **SDK-based monitoring**.

**Live app monitoring** is currently only available for .NET/.NET Core and allows instrumenting an application without modifying its internal code. Live app monitoring can be used to quickly add monitoring to an already deployed live application you wrote. It also allows you to perform deep application monitoring against third-party .NET applications where you don’t necessarily have access to the source code. Live app monitoring can collect: 

* Requests and exceptions
* Dependency diagnostic information including SQL Command text
* System performance counters

**SDK-based monitoring** is where you integrate the Application Insights SDK directly into your app’s codebase. It is therefore much more flexible and allows a level of granularity in monitoring that would otherwise not be possible as you can add custom tracking to any part of your code.  A subset of SDK-based monitoring is client-side monitoring where JavaScript is used to collect information on the customer’s in browser experience of your web app. This collection allows for deep user behavior analytics of both the server-side and client-side experiences.

Integrating Azure Monitor with Operations Manager provides several advantages:

- Azure Monitor logs delivers a scalable and powerful integrated analytics platform that compliments the Operations Manager data warehouse database for collecting specific and valued performance and log data. Azure Monitor delivers better analytics, performance when querying large data volume, and retention than the Operations Manager data warehouse.  The Kusto query language allows you to create much more complex and sophisticated queries with an ability to run queries across terabytes of data in seconds, and quickly transform your data into pie charts, time charts, and many other visualizations.  No longer are you constrained working with reports in Operations Manager based on SQL Server Reporting Services, custom SQL queries, or other workarounds to analyze this data. 

- Analyze alerts using the Azure Monitor Alerts Management solution.  Alerts that are generated in Operations Manager management group are forwarded to Azure Monitor Log Analytics workspace. The subscription responsible for forwarding alerts from Operations Manager to Azure Monitor logs can be configured to only forward alerts that meet your criteria for querying in support of problem management for trends and investigation of root cause of failures or problems through a single pane of glass. Additionally, you can correlate other log data from Application Insights or other sources to gain insight to help improve user experience, increase uptime, and reduce time to resolve incidents.   

- Use the System Center Operations Manager Health Check solution to assess the risk and health of your System Center Operations Manager management group on a regular interval.

- With the Map feature of Azure Monitor for VMs, you can monitor standard connectivity metrics from network connections between your Azure VMs and on-prem VMs such as response time, requests per minute, traffic throughput, and links. This subfeature of Map provides additional insight by identifying failed connections, and helps you with troubleshooting, migration validation, security analysis, and verifying the overall architecture of the service.  It can automatically discover application components on Windows and Linux systems and maps the communication between services, and help identify connections and dependencies you were unaware of, plan and validate migration to Azure, and help minimize speculation during incident resolution.  

- Monitor the network connectivity between your corporate network and Azure, between mission critical multi-tier applications/micro-services, and between user locations and web-based applications (HTTP/HTTPs) using Network Performance Monitor solution.  This strategy can deliver visibility of the network layer without the need for SNMP and present in an interactive topology map the hop-by-hop topology of routes between the source and destination endpoint. It may be a better choice than attempting to accomplish the same result with network monitoring in Operations Manager or other network monitoring tools currently used in your organization.  

### Monitor with Azure Monitor

If you are committed to migrating from one or more on-premise enterprise monitoring tools as part of your cloud migration strategy to reduce cost, complexity, and transform your IT operations to adopt DevOps methodologies using native Azure services, you will use Azure Monitor.  While Azure Monitor has undergone a transformation to become our SaaS monitoring platform in Azure, it was not designed with the intention of replacing a mature product like Operations Manager. There are distinct features available in Operations Manager and other on-premise enterprise monitoring platforms that Azure Monitor doesn’t provide. 

If you are accustomed to the full monitoring visibility delivered with Operations Manager or are considering it after reviewing this document or supporting technical documentation, it is important you understand what the differences are with Azure Monitor so you can determine how they may impact your requirements.  Understand that we did not have in mind the intention of designing Azure Monitor to replace System Center Operations Manager and replicate all of its functionality, and this list only serves to highlight that certain experiences or expectations you have already with your on-premise monitoring tool is not currently in Azure Monitor and may never be if they aren’t relevant or can be done better.  

* Azure Monitor for VMs introduces health monitoring in the cloud, but does not support monitoring VMs outside of Azure, nor other infrastructure or platform resources supporting the application.  Additionally, it does not include support for creating custom health monitoring criteria you may need to include to meet your monitoring requirements. 
* Azure Monitor does not include the notion of a service model that represents the components and relationships between them running on a VM, or infrastructure and platform resources, and include that configuration in a consumable manner.  Instead you enable data collection from each resource and configure your monitoring logic once the data is written to the metric or logs store so it becomes meaningful to you and your organization, following the principals of cloud computing.  
* If you are migrating from System Center Operations Manager and want to transition the monitoring configuration from management packs targeting the guest OS and workloads running on the VM, there is no conversion tool available today to transform them into a Resource Manager template.
* Suppression of alerts during planned or emergency maintenance windows is not in general availability at this time. Alert notification suppression using a new feature called Action Rules is currently in public preview.
* Visualizing data in Azure Monitor is delivered using several different features in Azure. These features include Azure Dashboards, Azure Monitor views delivered with monitoring solutions for log data, and Workbooks that are interactive documents useful for incident investigation.  Each of these visualization methods is applicable across several scenarios or use cases. However, there are limitations where considering Grafana for rich dashboards or exporting the data to Power BI to deliver business/IT-centric dashboards and reports for different personas in the organization is recommended.  
* Centralized and effective management of predefined monitoring configuration (solutions, data collection, alerting, visualizations, etc.), verification of applying a config change, and how to best define targeting, grouping of affected resources, etc. is not available today. As such, this goal must be achieved using different techniques.
* Alerting in Azure Monitor was recently consolidated from other services, such as Log Analytics and Application Insights, to deliver a centralized alerting service that is new presently compared to mature monitoring platforms that have been on the market for some time. It is a service that is designed to take advantage of cloud services such as machine learning to deliver a powerful alerting experience. Advanced alerting features found in the other monitoring platforms that you come to expect, such as searching alerts based on a query, customized notification messages, and suppression of alerts are areas where we will continue to invest to improve the experience.
* Azure Monitor identifies if the agent stops sending data to the service using a heartbeat event it generates and sends every 60 seconds. It does not monitor and alert if other aspects of agent health, such as resource utilization or from other indicators, as well as if there is latency between the agent to the service.  Monitoring the agent requires custom-developed monitoring logic with Azure Monitor to proactively identify symptoms affecting agent performance and reliability.  

## Private cloud monitoring

Holistic monitoring of Azure Stack and the workloads running in the tenant, resource level, on the virtual machines, and the infrastructure hosting Azure Stack (physical servers and network switches) can be achieved with System Center Operations Manager, or monitoring can be achieved with a combination of  [infrastructure monitoring capabilities](/azure/azure-stack/azure-stack-monitor-health ) included in Azure Stack that help you view health and alerts for an Azure Stack region and the [Azure Monitor service](/azure/azure-stack/user/azure-stack-metrics-azure-data ) in Azure Stack, which provides base-level infrastructure metrics and logs for most services.

Customers who have already invested in Operations Manager should monitor the availability and health state of the Azure Stack deployments, regions, resource providers, updates, update runs, scale units, unit nodes, infrastructure roles, and their instances (logical entities comprised of the hardware resources) with the Azure Stack management pack.  It uses the Health and Update resource provider REST APIs to communicate with Azure Stack. Including the physical servers and storage devices can be achieved using the OEM vendors (Lenovo, Hewlett Packard, Dell, EMC, etc.) management pack that they provide to their customers.  Operations Manager can natively monitor the network switches to collect basic statistics using SNMP protocol. Monitoring the tenant workloads is possible with the Azure management pack following two basic steps - you need to configure the subscription that you want to monitor, and then you need to add the monitors for that subscription.

## Summary

To summarize, the following table highlights the monitoring scenarios between Azure, hybrid, and private cloud and how our monitoring platforms support each.  

Scenario | Azure Monitor | Operations Manager
:--|:---|:---
Infrastructure monitoring  | Currently delivers health monitoring experience for Azure VMs (in public preview) somewhat similar to Operations Manager. | Supports monitoring most of the infrastructure from corporate network. Tracks availability state, metrics, and alerts for Azure VMs, SQL, and storage via Azure management pack (polling Azure Resource Manager APIs).
Monitor server workloads  | Can collect IIS and SQL Server error logs, Windows events, and performance counters. Requires creating custom queries, alerts, and visualizations.   | Supports monitoring most of the server workloads with available management packs.  Requires either the Log Analytics Windows agent or Operations Manager agent on the VM, reporting back to the management group on the corporate network. 
Web application monitoring  | Application Insights includes support for the latest versions of .Net, Java, and other platforms.  Comprehensive web application monitoring to detect and help diagnose issues with code, capacity, and responsiveness. | Supports monitoring older versions of .NET and Java web servers.  GSM benefit retired.  Integration with Azure Monitor App Insights using Azure MP to query alerts raised is being retired.  Requires creating a custom MP using REST API to query data from Application Insights and stream to Operations Manager.
Azure service monitoring  | [Azure Service Health](https://docs.microsoft.com/en-us/azure/service-health/overview) provides the ability to monitor your service and how the health of the underlying Azure infrastructure affects your service. | While there is no native monitoring of Azure Service health provided today through a management pack, customers can create custom workflows to query Azure service health alerts using the Azure REST API and get alerts through your existing notifications.
Network performance  monitoring  | Azure Monitor Network Insights monitors Azure networking stack, network perf., NSGs, etc. Azure Monitor for VM's Map feature includes connectivity metrics between Azure and other environment VMs.  | Supports availability checks and collects basic statistics from network devices using SNMP protocol from corporate network.  
Data aggregation  | Azure Monitor logs and alert management support processing data from Operations Manager, Nagios, Zabbix, etc.   | Relies on SQL Reporting Services pre-canned or custom reports, third-party visualization solution, or custom Power BI implementation.  Scale and performance limitations with Operations Manager data warehouse. Integrate with Azure Monitor logs as an alternative for data aggregation requirements. Integration is achieved by configuring Log Analytics connector available in product.
End-to-end diagnostics, root-cause analysis, and timely troubleshooting | Azure Monitor delivers end-to-end diagnostics and root-cause analysis for developer and IT operations from your cloud and on-premises environments through several features and tools that provide valuable insights into your applications and other resources that they depend on.| Supports end-to-end diagnostics and troubleshooting only for on-premise infrastructure and applications leveraging other System Center components or partner solutions.
Experiences – Dashboards, reports, integrations with IT/DevOps tools… | Currently supports integration with Azure dashboards, Power BI, Grafana, and integration with ITSM tools to forward collected data and alerts. | Supports dashboards natively or using partner solutions from Squared Up and Savision.  Integrates with ITSM tools using custom code, System Center Orchestrator, or partner solutions based on Operations Manager SDK.  

## Next steps

> [!div class="nextstepaction"]
> [Collecting the right data](./data-collection.md)
