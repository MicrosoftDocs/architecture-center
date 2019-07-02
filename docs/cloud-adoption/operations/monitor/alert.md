---
title: Cloud monitoring guide – Alerting
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

# Cloud monitoring guide: Alerting

For years, IT organizations have struggled to combat alert fatigue created by the monitoring tools deployed in the enterprise. Many systems generate a high volume of alerts often considered meaningless, while others are relevant but are either overlooked or ignored.  As a result, IT and developer operations have struggled to meet service-level quality promised to the internal or external customer.  It is essential to understand the state of your infrastructure and applications to ensure reliability and identify causes quickly to minimize service degradation and disruption or decrease impact of or reduce number of incidents.  

## Successful alerting strategy

*You can’t fix what you don’t know is broken.*

Alerting on what matters is critical, it is underpinned by collecting and measuring the right metrics and logs, as well a monitoring tool that is capable of storing, aggregating, visualizing, analyzing, and initiating an automated response when conditions are met.  Improving observability of your services and applications can only be accomplished if you fully understand its composition in order to map/translate that into a detailed monitoring configuration to be applied by the monitoring platform, including the predictable failure states (the symptoms not the cause of the failure) that make sense to alert on.  Consider the following principles for determining if a symptom is an appropriate candidate to alert on:

- **Does it matter?** - Is the issue symptomatic of a real problem or issue influencing overall health of the application?  Do I care if the CPU utilization is high on the resource or that a particular SQL query running on a SQL database instance on that resource is consuming high CPU utilization over a sustained period?  Being the CPU utilization condition is a real issue, you should alert on it but not notify the team because it doesn’t help point to what is causing the condition in the first place.  Alerting and notifying on the SQL query process utilization issue is both relevant and actionable.  
- **Is it urgent?** -  Is the issue real and does it need urgent attention?  If so, the team responsible should be immediately notified.   
- **Are my customers affected?** - Are users of the service or application impacted as a result of the issue?
- **Are other dependent systems affected?** - Are there alerts from dependencies that are interrelated that could possibly be correlated to avoid notifying different teams all working on the same problem?  

These questions should be asked when initially developing a monitoring configuration. The assumptions should be tested and validated in a pre-production environment, and then deployed into production. Monitoring configurations are derived from known failure modes, test results of simulated failures, and experience from different members of the team.  After release, observed learnings such as high alert volume, issues unnoticed by monitoring but noticed by end users, what was the best actions to have taken, etc. should be evaluated, change identified, agreed upon, and implemented to improve service delivery as part of an ongoing continuous monitoring improvement process.  It’s not just about evaluating alert noise or missed alerts, but also effectiveness of how you are monitoring the workload, effectiveness of your alert policies and process, and overall culture to determine if you are improving.

Both Operations Manager and Azure Monitor support alerts based on static or even dynamic thresholds and actions set up on top of them, such as email, SMS, voice calls for simple notifications.  They also support ITSM integration to automate the creation of incident records and escalate to the correct support team, or any other alert management system using a webhook.  When possible, automating recovery actions depending on the situation can be accomplished using System Center Orchestrator, Azure Automation, Azure Logic Apps, or autoscaling in the case of elastic workloads.  While notifying responsible teams is the most common action for alerting, automating corrective actions as needed and where it makes sense, can help streamline the entire incident management process.  Automating these recovery tasks can also reduce the risk of human error, where some may be honest mistakes but still are a concern for service owners and the business.  

## Azure Monitor alerting

If you are using the Azure Monitor platform exclusively, the following guidance applies. 

There are six repositories that store monitoring data, depending on the feature and configuration you are using.

- **Azure Monitor metrics database** -  A time-series database used primarily for Azure Monitor platform metrics, but also has Application Insights metric data mirrored into it. Information entering this database has the fastest alert times. 

- **Application Insights logs store** – A database which stores most Application Insights telemetry in log form. 

- **Azure Monitor logs store** – Primary store for Azure Log data. Other tools can route data to it and can be analyzed in Azure Monitor logs.  Log alert queries have higher latency due to ingestion and indexing latency, which is generally in the five to ten-minute range, but can be higher under certain circumstances.   

- **Activity log store** – Used for all activity log and service health events. Dedicated alerting is possible. Holds subscription level events that occur on objects in your subscription as seen from the outside of those objects. For example when policy is set, a resource accessed or deleted. 

- **Azure Storage** – General-purpose storage supported by Azure Diagnostics extension and other monitoring tools that is a low-cost option for long-term retention of monitoring telemetry. Alerting is not supported from data stored in this service. 

- **Event Hubs** – Generally used to stream data into on-premises or other partners monitoring/ITSM tools. 

There are four types of alerts in Azure Monitor, which are somewhat tied to the repository the data is stored in.

- [Metric alert](/azure/azure-monitor/platform/alerts-metric) - Alerts on data in Azure Monitor metrics database. Alerts occur when a monitored value crossed a user-defined threshold. goes beyond a threshold (active) and then again when it returns to “normal” state.  

- [Log query alert](/azure/azure-monitor/platform/alerts-log-query) – Available to alerts on content in the Application Insights or Azure Logs stores. Can also alert based on cross-workspace queries. 

- [Activity Log alert](/azure/azure-monitor/platform/alerts-activity-log) – Alert on items in the Activity Log store, with the exception of Service Health data. Activity Log 

- [Service Health alert](/azure/azure-monitor/platform/alerts-activity-log-service-notifications?toc=%2fazure%2fservice-health%2ftoc.json) – A special type of alert just for Service Health issues coming from the Activity log store.  

Follow these guidelines when considering speed, cost, and storage volume in Azure Monitor.

### Alerting through partner tools  

If you are using an external alerting solution, then route as much as you can through Event Hubs, as that’s the fastest path out of Azure Monitor. You’ll have to pay for ingestion into Event Hub.  If cost is an issue and speed is not, you could use Azure Storage as a cheaper alternative as long as your monitoring or ITSM tools can read Azure Storage to extract the data.

Azure Monitor includes support for integrating with other monitoring platforms, ITSM software such as ServiceNow, so you can use Azure alerting and still trigger actions outside of Azure as require by your incident management or DevOps process.  If you want to alert in Azure Monitor and automate the response, you can initiate automated actions using Azure Functions, Logic Apps, or Azure Automation based on your scenario and requirements.  

### Specialized Azure monitoring offerings

[Management solutions](/azure/azure-monitor/insights/solutions-inventory) generally store their data in the Azure Logs store.  The two exceptions are Azure Monitor for VMs and Azure Monitor for containers, and the following table describes the alerting experience based on the particular data type and where it is stored.

Solution| Data type | Alert behavior
:---|:---|:---
Azure Monitor for containers | Calculated average performance data from nodes and pods are written to the Metrics store. | Create metric alerts if you want to be alerted based on variation of measured utilization performance aggregated over a period of time.  
|| Calculated performance data using percentiles from nodes, controllers, containers, and pods are written to the Logs store. Container logs and inventory information are also written to the Logs store.  | Create log query alerts if you want to be alerted based on variation of measured utilization from clusters and containers.  Log query alerts can also be configured based on pod-phase counts and status node counts.  
Azure Monitor for VMs | Health criteria are metrics written to the Metrics store.   | Alerts are generated when health state changes from healthy to unhealthy condition. Only supports Action Groups configured to send SMS or email notification. 
|| Map and guest OS performance log data are written to the Logs store.  | Create log query alerts 

### Fastest speed driven by cost

One of the most critical decisions driving alerting and quick resolution of issues impacting your service is latency.  If you require near real-time alerting under five minutes, evaluate first if you have or can get alerts on your telemetry where it is stored by default. In general, this strategy is also the cheapest option as the tool you are using is already sending its data to that location.

There are some important footnotes to this rule.

**Guest OS telemetry** has a number of paths to get into the system.

* The fastest way to alert on this data is to import it as custom metrics using the Azure Diagnostics extension and then use a metric alert. However, custom metrics are currently in preview and are [more expensive than other options](https://azure.microsoft.com/pricing/details/monitor/). 

* The cheapest but slowest method is to send it to Azure Logs Kusto store.  Running the Log Analytics agent on the VM is the best way to get all Guest OS metric and log data into this store.  

* You can send to both stores by running both the extension and the agent on the same VM. Then you can alert quickly, but also use the Guest OS data as part of more complex searches when combined with other telemetry.

**Importing data from on-premises** – If you are trying to query and monitor across machines running in Azure and on premises, you can use the Log Analytics agent to collect guest OS data and then use a feature called [Logs to Metrics](/azure/azure-monitor/platform/alerts-metric-logs) to streamline those metrics into the metrics store. This method bypasses part of the ingestion process into the Azure Logs store and thus is available sooner in the metrics database.

### Minimize alerts

**Using Azure Monitor for VMs**

If you use a solution like Azure Monitor for VMs and find the default health criteria that monitors performance utilization acceptable, then don’t create overlapping metric or log query alerts based on the same performance counters.  

If you aren’t using Azure Monitor for VMs, we recommend you explore the following features to make your job of creating alerts and managing notifications easier.  

**Specialized Metric features**

> [!NOTE] 
> These features apply only to metric alerts; that is, alerts based on data being send to the Azure Monitor metric database. They do not apply to the other types of alerts. As mentioned previously, metric alerts primary concern is alerting speed over cost. If getting an alert in less than 5-minutes is not of primary concern, we suggest you use a log query alert.

* [Dynamic Thresholds](/azure/azure-monitor/platform/alerts-dynamic-thresholds) – Dynamic thresholds look at the activity of the resource over a time period and create upper and lower "normal behavior" thresholds. When the metric being monitored falls outside of these thresholds (either above or below as you specify), you get an alert.

* [Multi-signal alerts](https://azure.microsoft.com/blog/monitor-at-scale-in-azure-monitor-with-multi-resource-metric-alerts/) - You can create a metric alert that uses the combination of two different inputs from two different resource types. So for example, if you want to fire an alert when the CPU of a VM is over 90% and the number of messages in a certain Service Bus queue feeding that VM exceeds a certain amount, you can do that without creating a log query. This only works for two signals. If you have a more complex query with more than two signals, you have fed your metric data into the Azure Monitor Log store and use a log query.

* [Multi-resource alerts](https://azure.microsoft.com/blog/monitor-at-scale-in-azure-monitor-with-multi-resource-metric-alerts/) – Azure Monitor allows a single metric alert rule that applies to all VM resources. Using this feature can save you time as you do not need to create individual alerts for each VM. Pricing for this type of alert is the same.  If you created 50 alerts for monitoring CPU usage for 50 VMs or 1 alert that monitors CPU usage for all 50 VMs, it costs you the same amount. You can use these types of alerts in combination with dynamic thresholds as well. 

Used together, these features can save time by minimizing alert notifications and the management of the underlying alerts.

### Alerts limitations

Be sure to note the [limitations](/azure/azure-subscription-service-limits#monitor-limits) of how many alerts can be created per subscription, etc. Some, but not all, limits can be increased by calling support.

### Best query experience

If you are looking for trends across all your data, then it makes sense to import all your data into Azure Logs, unless it’s already in the Application Insights.  You can create cross-workspace queries across both workspaces so there is no need to move data between them. You can also import Activity Log and Service Health data into your Log Analytics workspace.  While you pay for this ingestion and storage, you now have all your data in one place for analysis and querying, giving you the ability to also create complex query conditions and alert on them. 
