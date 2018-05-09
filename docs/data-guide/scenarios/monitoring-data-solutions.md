# Monitoring Data Solutions

[About]()  
[When to use this data architecture](#whentouse)  
[Benefits](#benefits)  
[Challenges](#challenges)  
[Monitoring data solutions in Azure](#inazure)   
[Where to go from here](#wheretogo)  

<a name="about"></a>

Cloud applications are complex with many moving parts. Implementing a well-designed monitoring architecture will create the capability to ensure that your applications and data pipelines are up and running and in a healthy state end-to-end. It also helps to stave off potential problems or troubleshoot past ones. In addition, you can use monitoring data to gain deep insights about your various solutions. This knowledge can help you to improve performance or maintainability, or automate actions that would otherwise require manual intervention.

When dealing with data, the range of things you need to monitor is both deep and wide. A high-level overview of what to monitor is as follows:

* Usage
* Data Movement
* Infrastructure & Services
* Performance
* Security & Access

For instance, you might be using memory-optimized database tables, putting pressure on your available memory. When you run out of memory, the system will no longer allow most write operations. If you're not using alerting features in Azure, you are at risk of discovering the issue when it's too late. Another example is monitoring data [pipeline orchestration](../technology-choices/pipeline-orchestration-data-movement.md) for moving and transforming data. Monitoring your orchestration pipeline will ensure that your [ETL/ELT or data flow & control flow](../common-architectures/data-pipeline.md) tasks are running as expected.

### Monitoring - things to consider

A good monitoring solution implements proper data collection so you do not have visibility gaps. Polling cycles that are too long can cause you to completely miss traffic spikes that only last a few seconds.

Monitoring could be done to include [time series](../pipeline-patterns/time-series.md) data so you can monitor performance trends, raw data retention offering high data granularity, and high frequency polling. When working with [big data](../common-architectures/big-data.md), the ability to capture your data at massive scale is very important. You don't want to start making decisions on what you will and will not monitor, because you can't handle the increased capacity of your data logs.

#### Performance monitoring

Performance monitoring is especially vulnerable to two things; gaps in the data collection time series and not having a comparision baseline. You need to establish a baseline for your performance, so you know what levels are outside the expected range at a given time. This means having regular snapshots of your baseline so you know when to expect more load on your system, based on historical data. This is crucial information when it comes to your scaling strategy, whether manual or automatic.

### Alerting

Alerting, in general, prevents you from having to constantly watch logs and reports. This is especially important if you have a noisy environment, meaning lots of data points one must consider. Alerts also serve to grab your attention when a certain threshold is hit (for example 95% CPU usage). However, with machine learning, we can expect more intelligent alerts that can detect anomalies. Anomalies, for example, could be a slow decrease in free memory over a long time, which can be indicative of a memory leak, or the number of web service requests that are stable in a range might dramatically increase or decrease. These are duration-based anomalies, like slow positive trend or slow negative trend. Anomaly detection relies on established baselines, as discussed in the performance monitoring topic.

Alerts are also important in security monitoring. This type of monitoring should ideally monitor traffic, collect logs, and analyze data for threats. This analysis is usually based on known behavior patterns used to discover malicious behavior, as well as anomaly detection by recognizing deviations from established baselines that conform to a potential attack vector.

### Troubleshooting & diagnostics

Azure services (IaaS, PaaS, SaaS, and so on) generate a large number of logs, many of which you can opt in or out of as well as set the level of detail. The challenge is in monitoring these logs and easily accessing the information within so you can troubleshoot and diagnose issues. The important thing is to ensure you have enabled ample logging, but logs are just the starting point. Data operations that you run, and the applications that invoke the operations, could emit telemetry that you can collect and analyze. An example of this could be specific values and user events that flow through your system that you could later use to correlate with any errors that occur. This allows you to answer questions like, "when this error shows up, what does my data normally look like at that time, or what steps did the user take leading up to the issue?"

## <a name="whentouse"></a>When to use this architecture

Ideally, monitoring your data solutions should be practiced from the moment of inception. Realistically, monitoring and alerting should be applied in production to your most critical services and components. The earlier you apply data monitoring practices, the better chance you have at selecting the right things to monitor and be alerted on, and will have a better sense of your solution's overall capacity and resiliency, based on real evidence.

## <a name="benefits"></a>Benefits

Monitoring offers the following benefits:

* Detect potential issues before they become real problems. In other words, predict problems before they happen.
* Gain insight on the current state of your solution, based on historical records and having established a baseline.
* Know when performance is taking a hit so you can scale accordingly, and research into what has changed to cause the issue.
* You have a better chance at being proactive in ensuring smooth operation of your solution, rather than always reactively responding to issues and putting out fires that shouldn't have started in the first place.
* Gather valuable data that will help you troubleshoot issues.
* Make huge diagnostic logs usable by adding search and alerting mechanisms.
* Allows you to save money by monitoring resource utilization. By doing this you can detect overprovisioning of resources and optimize your workloads accordingly

## <a name="challenges"></a>Challenges

Establishing monitoring can have some of the following challenges:

* Aggregating diagnostic and performance data into a single overall view can become its own big data problem.
* Controlling access to sensitive logs and the personally identifiable information (PII) within those logs.
* Capitalizing on being able to add alerts to key services by setting useful thresholds and other triggers on the services you need most.

## <a name="inazure"></a>Monitoring in Azure

The flexibility of Azure means that you have many choices when it comes to monitoring solutions. In this section we will have a closer look at how you can monitor your Azure workloads with Azure Monitor and a wide range of other specialized monitoring tools that Azure provides.

Here is a high-level overview of the different monitoring in Azure:
![](images/monitoring-products-overview.png)

However, you can also use any number of third-party solutions, such as Stackify, Nagios, Splunk, DataDog, and so on hosted on virtual machines or as part of a service offering. 


### Azure Monitor - Centralized Monitoring Experience
[Azure Monitor](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-azure-monitor) is thé centralized monitoring experience in Azure. It provides you a set of operational services such as:

- [Alerts](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitor-alerts-unified-usage) that will notify you when a certain criteria is met. This can be configured on Azure Monitor metrics, Application Insights metics, Log Analytics queries, and more. Every alert is linked to a specific [action group](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-action-groups) that resembles a set of users that need to investigate and will be notified automatically such as via SMS, webhook, etc.
- [Metrics](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-metrics) are numerical values generated by an Azure resource to help you understand the operation and performance of the resource. These can be visualized with the Metrics Explorer.
- [Service health](https://docs.microsoft.com/en-us/azure/service-health/service-health-overview) identifies any issues with Azure services that might affect your application.
- [Activity logs](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-activity-logs) provides data about the operation of an Azure resource such as recommendations, incidents, etc.
- [Diagnostic logs](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-of-diagnostic-logs) is information that is emitted by an Azure service that provides rich data about the operation of that resource.

Azure Monitor is also built on top of data managed by two other monitoring services in Azure:

- [Log Analytics](https://docs.microsoft.com/azure/log-analytics/log-analytics-overview), which is part of the [Operations Management Suite](https://docs.microsoft.com/azure/operations-management-suite/operations-management-suite-overview) (OMS). This service monitors your Azure and on-premises environments to give you a single pane of glass through which you can view logging and other monitoring data from multiple sources. This helps address one of the primary monitoring challenges mentioned above. It also assists in searching your diagnostic logs, performance data, and custom data, as well as setting alerts.

- [Application Insights](https://docs.microsoft.com/azure/application-insights/app-insights-overview) is an extensible application performance management (APM) service for developers on multiple platforms. It also automatically detects performance anomalies. It includes powerful analytics tools to help you diagnose issues and to understand what users actually do with your app. You can use it to monitor your live web, mobile, container applications and more. By using Application Insights you can quickly get insights in your availability, dependency, requests, trace logging, metrics, user usage and much more.

More information can be found [here](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview).

### Specialized monitoring tools

- [Azure Security Center](https://docs.microsoft.com/azure/security-center/security-center-intro) automatically collects, analyzes, and integrates security logs and data from your Azure and on-premises resources, the network, storage, data, and connected partner solutions, like firewall and endpoint protection solutions, to detect real threats and reduce false positives. A list of security recommendations is shown in Security Center with the information you need to review and take action to tighten the security of the resources monitored by Security Center. ASC generates security alerts and incidents with information needed to quickly detect and respond to the threats and attacks.

- [Azure Storage Analytics](https://docs.microsoft.com/rest/api/storageservices/fileservices/storage-analytics) performs logging and provides metrics data for a storage account. You can use this data to trace requests, analyze usage trends, and diagnose issues with your storage account. Storage Analytics logging is available for the Blob, Queue, and Table services. Storage Analytics logs detailed information about successful and failed requests to a storage service. This information can be used to monitor individual requests and to diagnose issues with a storage service. Requests are logged on a best-effort basis. Log entries are created only if there are requests made against the service endpoint. For example, if a storage account has activity in its Blob endpoint but not in its Table or Queue endpoints, only logs pertaining to the Blob service is created.

- [Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/monitor-visually) allows you to visualize all your data pipelines, what their status is and what steps, also known as activities, are part of every data pipeline. This allows you to very easily determine how your business processes are doing and diagnose what is wrong. As of the time of writing, Azure Data Factory 2.0 is still in public preview and thus this experience is not finished yet and more features will be added later on.

- [Azure Advisor](https://docs.microsoft.com/en-us/azure/advisor/advisor-overview) does not monitor your resources from an application or runtime perspective but it bundles all the recommendations from sources such as Azure Security Center and others in one centralized management blade. By doing this, you get a quick overview of all your resources in your subscriptions that have an impact on **cost**, **performance**, **security** & **high availability**.

- For security monitoring on your managed Azure SQL Database instances, you can take advantage of [Azure SQL Database Threat Detection](https://docs.microsoft.com/azure/sql-database/sql-database-threat-detection), a security intelligence feature built into the Azure SQL Database service. Working around the clock to learn, profile, and detect anomalous database activities, Azure SQL Database Threat Detection identifies potential threats to the database. Security officers or other designated administrators can receive an immediate notification about suspicious database activities as they occur. Each notification provides details of the suspicious activity and recommends how to further investigate and mitigate the threat.

- Another option for monitoring the health of your Azure SQL Database instances, is to use [Azure SQL Analytics](https://docs.microsoft.com/azure/log-analytics/log-analytics-azure-sql), which is a solution within Azure Log Analytics. This solution helps you collect and visualize important Azure SQL Database and elastic pool metrics across multiple Azure subscriptions. To use Azure SQL Analytics, you need a to [create a Log Analytics workspace](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-quick-create-workspace) or use an existing one, and enable Azure Diagnostics for your Azure SQL databases and elastic pools, and [configure them to send their data to Log Analytics](https://docs.microsoft.com/azure/sql-database/sql-database-metrics-diag-logging).

- [Anomaly Detection API](https://docs.microsoft.com/azure/machine-learning/team-data-science-process/apps-anomaly-detection-api) is built with Azure Machine Learning and is useful for detecting different types of anomalous patterns in your time series data. The API assigns an anomaly score to each data point in the time series that can be used for generating alerts, monitoring through dashboards or connecting with your ticketing systems.

 - Another option for taking advantage of the intelligent analytics that Azure Machine Learning provides, is to use the [ANOMALYDETECTION operator](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-machine-learning-anomaly-detection) in Stream Analytics. Up to now, IoT customers, and others, who monitor streaming data relied on expensive custom machine learning models. Implementers needed to have intimate familiarity with the use case and the problem domain, and integrating these models with the stream processing mechanisms required complex data pipeline engineering. The high barrier to entry precluded adoption of anomaly detection in streaming pipelines despite the associated value for many industrial IoT sites. This new capability makes it quick and easy to do service monitoring by tracking key performance indicators (KPIs) over time, as well as usage monitoring through metrics such as number of searches/clicks, or performance monitoring through counters like memory, CPU, and file IO over time.

## <a name="wheretogo"></a>Where to go from here
Read next:
[Data ingest technology choices](../technology-choices/data-ingest.md)

See also:

Related technology choices
- [Analysis, Visualizations, & Reporting](../technology-choices/analysis-visualizations-reporting.md)
- [Data Serving Storage](../technology-choices/data-serving-storage.md)
- [Real-time Processing](../technology-choices/real-time-processing.md)
