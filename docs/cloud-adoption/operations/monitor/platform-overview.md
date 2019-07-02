---
title:  Cloud monitoring guide – Azure Monitoring platform overview
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

# Cloud monitoring guide: Overview of the Azure monitoring platform

Microsoft provides a range of monitoring capabilities from two products: System Center Operations Manager for on-premises and Azure Monitor for the cloud. These offerings deliver core monitoring like alerting and service uptime tracking to application and infrastructure health monitoring to performance and failure diagnostics to analytics over log, events, and metrics.  Customers are embracing the latest practices for DevOps agility and cloud innovations to manage their heterogenous environments, but are concerned about their ability to make appropriate and responsible decisions regarding how to monitor those workloads with our offerings.  

This article describes and compare the current offerings available and outline our recommended strategy based on the following factors:

* Your current investment in Operations Manager or other monitoring platform on your corporate network and whether it’s tightly integrated with your IT operations processes.
* Your migration approach to Azure. This approach could be a staged one extending your corporate network to Azure or redesigning applications and services to run natively in Azure using a combination of IaaS and PaaS resources.  

Our strategy includes support for monitoring infrastructure (compute, storage, and server workloads), application (end-user, exceptions, and client), and network resources to deliver a complete service-oriented monitoring perspective.

Every journey has a story, so before we dive into the detailed overview, let’s start with a brief retrospective look at where it all began when we entered the monitoring field and how our strategy has evolved over time.

## Story of System Center Operations Manager

In 2000, we entered the operations management field with Microsoft Operations Manager (MOM) 2000.  In 2007, we introduced a re-engineered version of the product named System Center Operations Manager that moved beyond simple monitoring of a Windows server and concentrated on robust end-to-end service and application monitoring including heterogenous platforms, network devices, and other application or service dependencies.  It is an established enterprise-grade monitoring platform for on-premises environments that is in the same class as IBM Tivoli or HP Operations Manager in the industry, and has evolved to support monitoring compute and platform resources running in Azure, Amazon Web Services (AWS), and other cloud providers.    

Operations Manager monitors these different platforms, devices, applications, and infrastructure services with a management pack.  Defined in a management pack are all the elements required for monitoring an IT service or application with Operations Manager including the service model, health model, discovery rules, views, and reports.  Once the management pack is imported into the management group, it automatically detects if the agent is running the components supporting the application or IT service and if so, run the workflows that proactively monitor them.  

As an extensible platform, Operations Manager is supported by a broad ecosystem of partners and communities that provide a variety of solutions that include:

* Management packs to monitor non-Microsoft applications, vendor hardware, and other technologies to deliver full-stack monitoring or to automate and extend features of Operations Manager. 
* Visualization products that include advanced dashboarding capabilities and engaging data visualizations to easily analyze the data on any browser or device in the enterprise 
* Integration with other ITSM products or orchestration tools to support incident recording, configuration management, incident autoremediation, etc.
* Automate and extend Operations Manager with custom code using its published APIs. 

## Story of Azure Monitor


![Timeline](./media/monitoring-management-guidance-cloud-and-on-premises/timeline-v2-opt.svg)

When Azure cloud was released in 2010, monitoring of cloud services was provided with the Azure Diagnostics agent, which delivered a way to collect diagnostic data from Azure compute and platform resources. In addition to viewing this data in the Azure portal, you could optionally persist it to Azure storage and view the data with one of several available tools, such as Server Explorer in Visual Studio and Azure Storage Explorer.  This capability was considered a general monitoring tool, as it lacked many features that were available in enterprise-class monitoring platforms and wasn’t consistent between each service that supported this method. In addition, as new Azure services were released, each provided its own monitoring method.  Azure services lacked an overall common monitoring methodology and framework. We realized this issue and began working on Azure Insights. It provided a common framework to collect platform metrics and logs from any Azure service that started using the framework.  

In 2015, Azure Operational Insights was made generally available. It delivered the Log Analytics analysis service that collected and searched data from machines in Azure, on-prem or other cloud environments, and connected to System Center Operations Manager.  Intelligence packs were offered that delivered different pre-packaged management and monitoring configurations that contained a collection of query and analytic logic, visualizations, and data collection rules for such scenarios as capacity planning, security auditing, health assessments, and alert management. As part of this release, Azure Operational Insights was added to the new Operations Management Suite (OMS), which intended to provide a unified IT management experience for organizations by bringing together a collection of IT management solutions, including Automation, Backup, Recovery, and Security. 
 
Early on, Microsoft realized the need for a common monitoring framework and began working on Azure Insights, which provided a way to a collect and route platform metrics and logs from any Azure service into a central pipeline.  At Microsoft Ignite conference in 2016, we announced that Azure Insights rebranded as Azure Monitor and released for public preview and to general availability in March 2017. Even before release, we began consolidation of the various alerting capabilities into the newly branded Azure Monitor.  

At Microsoft Ignite conference in 2018, we announced that Azure Monitor expanded to include several different services that were originally developed for independent functionality: 

* **Log Analytics** provided rich analytical insight of log data from services and applications. It shared the same agent as Operations Manager to collect monitoring data from VMs both in the cloud and on-premises. Monitoring solutions in Log Analytics were like management packs in Operations Manager, providing packaged logic to monitor a particular product or service.
* **Application Insights** grew from Application Performance Monitoring in Operations Manager. It provided rich monitoring of web applications written in a variety of languages. Application Insights collects details on application performance, requests and exceptions, and traces.
* **Azure Insights** (briefly branded Azure Monitor before Ignite 2018) provided core metrics and resource diagnostics logs for only Azure platform resources. It also included alerting and notification based on those metrics. The notification system included the ability to integrate with partner applications through webhooks and ITSM software and later Azure Logic Apps and Automation in addition to common notification methods such as voice, SMS, and email.
* **Azure Network Watcher** to monitor, diagnose, and view metrics for resources in an Azure virtual network.

Now that you understand the history, let’s move on to review the fundamental way Operations Manager monitors applications and infrastructure services and understand the advantages Azure Monitor provides as a SaaS monitoring platform for organizations.  

## Infrastructure requirements

### Operations Manager

Operations Manager requires significant infrastructure to support a management group, which is a basic unit of functionality.  At a minimum, a management group consists of one or more management servers, a SQL Server hosting the operational and reporting data warehouse database, and agents.  The complexity of a management group design depends on a number of factors such as the scope of workloads to monitor, how many devices or computers support the workloads, and if high availability and site resiliency are required.  

![Timeline](./media/monitoring-management-guidance-cloud-and-on-premises/operations-manager-management-group-optimized.svg)

Each of these components requires infrastructure and software within your corporate network that must be maintained.

### Azure Monitor
Azure Monitor is a SaaS service where all the infrastructure supporting it is running in the Azure cloud and is managed by us. It is designed to do monitoring, analytics, and diagnostics at scale and is available in all national clouds.  Core parts of the infrastructure - collectors, metrics and logs store, and analytics are necessary to support Azure Monitor.  

![Timeline](./media/monitoring-management-guidance-cloud-and-on-premises/azure-monitor-greyed-optimized.svg)

## Data collection

### Operations Manager

#### Agents

Operations Manager only collects data directly from agents installed on [Windows computers](https://docs.microsoft.com//system-center/scom/plan-planning-agent-deployment?view=sc-om-1807#windows-agent). It can accept data from the Operations Manager SDK, but this setup is typically used for partners extending the product with custom applications and typically not used to collect monitoring data. It collects data from other sources such [Linux computers](https://docs.microsoft.com/system-center/scom/plan-planning-agent-deployment?view=sc-om-1807#linuxunix-agent) and network devices by using special modules that run on the Windows agent remotely accessing these other devices.

![Timeline](./media/monitoring-management-guidance-cloud-and-on-premises/data-collection-opsman-agents-optimized.svg)

The Operations Manager agent can collect from multiple data sources on the local computer such as event log, custom logs, and performance counters.  It can also run scripts, which can collect data from the local computer or from external sources. You can write custom scripts to collect data that can’t be collected with other means or from a variety of remote devices that can’t otherwise be monitored.

#### Management packs

All monitoring in Operations Manager is performed with workflows (rules, monitors, and discoveries) that are packaged together in a [management pack](https://docs.microsoft.com/system-center/scom/manage-overview-management-pack?view=sc-om-2019) and deployed to agents. Management packs are available for a variety of products and services that include predefined rules and monitors, or you can author your own management pack for your own applications and custom scenarios.

#### Workflows

Management packs can contain hundreds of workflows, and a single agent will simultaneously run all workflows from all the management packs it has loaded. Each instance of each workflow runs independently and will act immediately on the data that it collects. This setup is how Operations Manager can achieve near real-time alerting and current health state of monitored resources.

For example, a monitor might sample a performance counter every few minutes. If that counter exceeds a threshold, it will immediately set the health state of its target object, which will immediately trigger an alert. A scheduled rule might watch for a particular event to be created and immediately fire an alert when that event is created in the local event log.

Because workflows are isolated from each other and work from the individual sources of data, Operations Manager has challenges correlating data between multiple sources. It’s also difficult to react to data once it’s been collected. You can run workflows that access the Operations Manager database, but this scenario isn’t common and it typically used for a limited number of special purpose workflows.

![Timeline](./media/monitoring-management-guidance-cloud-and-on-premises/operations-manager-management-group-optimized.svg)

### Azure Monitor

#### Data sources

Azure Monitor collects data from a variety of sources, including Azure infrastructure and platform resources, agents on Windows and Linux computers, and monitoring data collected in Azure storage. Any REST client can write log data to Azure Monitor using an API, and you can define custom metrics for your web applications. Some metric data can be routed to different locations depending on its usage – fast-as-possible alerting or long-term trend analysis searched in conjunction with other log data.  

Monitoring solutions and Insights
Monitoring solutions leverage the logs platform in Azure Monitor to provide monitoring for a particular application or service. They typically define data collection from agents or from Azure services and provide log queries and views to analyze that data. They typically don’t provide alert rules, meaning that you must define your own alert criteria based on collected data.

Insights leverage the logs and metrics platform of Azure Monitor to provide a customized monitoring experience for an application or service in the Azure portal. They may provide health monitoring and alerting conditions in addition to customized analysis of collected data.

#### Workflows

Azure Monitor separates data collection from actions taken against that data, which supports distributed microservices in a cloud environment. It consolidates data from multiple sources into a common data platform and provides features or performing such monitoring tasks as analysis, visualization, and alerting base on that collected data. 

All data collected by Azure Monitor is stored as either logs or metrics, and different features of Azure Monitor will rely on either. Metrics contain numerical values in time series that are well-suited for near real-time alerting and fast detection of issues. Logs contain text or numerical data and are supported by a powerful query language that make them especially useful for performing complex analysis.

Because Azure Monitor separates data collection from actions against that data, it may not be able to provide near real time alerting in many cases. All log data must be retrieved using a log query which is scheduled in alerts. This behavior allows Azure Monitor to easily correlate data from all monitored sources, and you can interactively analyze data in a variety of ways.

## Health monitoring

### Operations Manager

Management Packs in Operations Manager include a service model that describes the components of the application being monitored and their relationship. Monitors identify the current health state of each component based on data and scripts on the agent. Health states roll up so that you quickly view the summarized health state of monitored computers and applications. 

### Azure Monitor

Azure Monitor doesn’t provide a standard means of implementing a service model or monitors that indicate the current health state of any service components. Since monitoring solutions are based on standard features of Azure Monitor, they don’t provide state level monitoring. Insights in Azure Monitor are beginning to deliver this kind of monitoring. For example, 

* **Application Insights** builds a composite map of your web application and provides a health state for each application component or dependency, including alerts status and drill-down to more detailed diagnostics if your app uses Azure services.
* **Azure Monitor for VMs** delivers a health monitoring experience for the guest Azure VMs similar to Operations Manager when monitoring Windows and Linux virtual machines.  It evaluates the health of key operating system components from the perspective of availability and performance to determine current health state. When it determines the guest VM is experiencing sustained resource utilization, disk space capacity, or an issue related to core OS functionality, it generates an alert to bring this state to your attention.  
* **Azure Monitor for containers** monitors the performance and health of Azure Kubernetes Services or Azure Container Instances. It collects memory and processor metrics from controllers, nodes, and containers that are available in Kubernetes through the Metrics API. Container logs and inventory data about containers and their images are also collected. Pre-defined health criteria based on the performance data collected helps identify if there is a resource bottleneck or capacity issue, and understand overall performance or from a specific Kubernetes object type (pod, node, controller, container).  

## Analyzing data

### Operations Manager

Operations Manager provides four basic ways to analyze data after it’s collected.

1. With **Health Explorer**, you can find out which monitor is reflecting a health state issue and review knowledge about the monitor and possible causes for actions related to it.

1. **Views** are predefined visualizations of collected data, such as a graph of performance data or a list of monitored components and their current health state. Diagram views visually present the service model of an application.

1. **Reports** allow you to summarize historical data stored in the Operations Manager data warehouse. You can customize the data that views and reports are based on, but there is no feature to allow for complex or interactive analysis of collected data.

1. **Operations Manager Command Shell**, which extends Windows PowerShell with an additional set of cmdlets, can query and visualize collected data, including graphs and other visualizations natively with PowerShell or with the Operations Manager HTML-based Web console.  

### Azure Monitor

Azure Monitor has a powerful analytics engine that allows you to interactively work with detailed or aggregated log data. Views and dashboards allow you to visualize query data in different ways from the Azure portal, import into Power BI, or with Grafana. Monitoring solutions include queries and views to present the data they collect. Insights such as Application Insights, Azure Monitor for VMs, and Azure Monitor for containers include customized visualizations to support interactive monitoring scenarios.

## Alerting

### Operations Manager

Operations Manager creates alerts in response to important events on an agent, when a performance threshold is crossed, and when the health state of a monitored component changes. It includes complete management of alerts allowing you to set their resolution and assign them to different operators. You can set notification rules that specify which alerts will send proactive notifications.

Management packs include various predefined alerting rules for different critical conditions in the application being monitored. You can tune these rules to the particular requirements of your environment.

### Azure Monitor

Azure Monitor allows you to create alerts based on a metric crossing a threshold or a scheduled query returning results. Alerts based on metrics can achieve near real-time results, while queries are run on a schedule and have a longer response time, which varies based on the speed of data ingestion and indexing. Instead of being limited to a specific agent, log query alerts in Azure Monitor allow you to analyze data across all data stored in multiple workspaces and include data from a specific Application Insights app using a cross-workspace query. 

While monitoring solutions can include alert rules, you will typically create them based on your own requirements. 

## Workflows

### Operations Manager
Management packs in Operations Manager contain hundreds of individual workflows and determine both what data to collect and what action to perform with that data. For example, a rule might sample a performance counter every few minutes storing its results for analysis. A monitor might sample the same performance counter and compare its value to a threshold to determine the health state of a monitored object. Another rule might run a script to collect and analyze some data on an agent computer and fire an alert if it returned a particular value.

Workflows in Operations Manager are independent of each other, so analysis across multiple monitored objects is difficult. These monitoring scenarios must be based on data after it's collected, which is possible but can be difficult and isn’t common.

### Azure Monitor

Azure Monitor separates data collection from actions and analysis taken from that data. Agents and other data sources write log data to a Log Analytics workspace and metric data to the metric database without any analysis of that data or knowledge of how it might be used. Alerting and other actions are performed from the stored data, which allows you to perform analysis across data from all sources.

## Extending base platform

### Operations Manager

All monitoring logic in Operations Manager is implemented in a management pack, which you either create yourself or obtain from us or a partner. When you install a management pack, it automatically discovers components of the application or service on different agents and deploys appropriate rules and monitors. The management pack will contain health definitions, alert rules, performance and event collection rules, and views to provide complete monitoring supporting the infrastructure service or application.

The Operations Manager SDK enables Operations Manager to not only integrate with third-party monitoring platforms or ITSM software, it is also used by some partner management packs to support monitoring network devices, deliver custom presentation experiences like the Squared Up HTML5 dashboard or our Visio integration, perform administrative tasks, and support other scenarios.

### Azure Monitor

Azure Monitor will collect metrics and logs from Azure resources with little to no configuration. Monitoring solutions add logic for monitoring an application or service, but still work within the standard log queries and views in Azure Monitor. Insights such as Application Insights and Azure Monitor for VMs use the Azure Monitor platform for data collecting and processing, but provide additional tools to visualize and analyze the data. You can combine data collected by insights with other data using core Azure Monitor features such as log queries and alerts. 

Azure Monitor supports several methods to collect monitoring or management data from Azure or external resources, extract and forward data from the metric or log stores to your ITSM or monitoring tools, or perform administrative tasks using the Azure Monitor REST API.

## Next steps

> [!div class="nextstepaction"]
> [Monitoring Azure cloud applications](./cloud-app-howto.md)