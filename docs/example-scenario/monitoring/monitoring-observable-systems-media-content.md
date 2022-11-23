Organizations often deploy varied and large-scale technologies to solve their business problems. These systems and end-user devices generate large sets of telemetry data. 

This architecture highlights a use case in the media industry and showcases solutions that provide real-time monitoring and observability of systems and end-user device telemetry data. Media streaming for live and video-on-demand playback requires near real-time identification of and response to application problems. To support this real-time scenario, organizations need to collect a massive telemetry set, which requires scalable architecture. After the data is collected, additional analysis approaches, like AI and anomaly detection, are needed to efficiently identify problems across so large a data set.

Problem Statement

When large-scale technologies are deployed, the system and end-user devices that interact with them generate massive sets of telemetry data. In traditional scenarios, these data are analyzed via a data warehouse system to generate insights that can be used to support management decisions. This approach might work in some scenarios, but it's not responsive enough for streaming media use cases. To solve this problem, real-time insights are required for the telemetry data generated from monitoring servers, networks, and the end-user devices that interact with them. Monitoring systems that catch failures and errors are common, but to catch them in near real-time is difficult. That's the focus of this architecture.

Solution Summary

In a live streaming or video-on-demand setting, telemetry data is generated from systems and heterogeneous clients (mobile, desktop, and TV). The solution involves taking raw data and associating context with the data points, for example, dimensions like geography, end-user operating system, content ID, and CDN provider. The raw telemetry is collected, transformed, and saved in Azure Data Explorer for analysis. You can then use AI to make sense of the data and automate the manual processes of observation and alerting. You can use systems like Grafana and Azure Metrics Advisor to read data from Data Explorer to show interactive dashboards and trigger alerts.

## Architecture

diagram 

link

In the observable system shown in the diagram, raw telemetry is streamed to Azure Blob Storage via HTTP and connectors. The raw telemetry is processed, transformed, normalized, and saved in Data Explorer for analysis. Systems like Grafana and Metrics Advisor read data from Data Explorer and provide insights to end users.

More specifically, these are the elements of the system in the diagram:

1.	**Instrumentation.** Instrumentation occurs via probes or agents that are installed in systems to monitor data. These agents come in a variety of forms. For example, in a video-on-demand streaming platform, a company might use open-standards [dash.js](https://github.com/Dash-Industry-Forum/dash.js) to collect Quality of Experience metrics from customers.
2.	**Ingestion.** This raw telemetry can come directly from end clients via HTTP calls.Alternatively, you can upload it via third-party systems to persistent storage and data lakes like Blob Storage. Blog Storage supports the ability to invoke an Azure function when a new file is uploaded. You can use this trigger mechanism to move raw telemetry to structured data warehouses.
3.	**Transformation and persistence.** You might need a transformation system to normalize your data. An Azure Functions app transforms the data as needed and then writes it to Data Explorer. Data Explorer is ideal for big data analytics because it's designed for high performance and throughput on extremely large data sets.
4.	**Monitoring.** Azure Managed Grafana supports integration with Data Explorer. You can use the drag-and-drop features of Grafana to quickly build dashboards and charts. Grafana is a good fit for media monitoring because it provides sub-minute refreshing of dashboard tiles and can also be used for alerting.
5.	**Anomaly detection.** The Grafana dashboard provides support for manual monitoring in the NOC. However, with a large data set and a user base spread across an array of geographies and devices, manual identification of issues via charts and alert rules with hard-coded thresholds becomes inefficient. You can use AI to address this problem. Services like Metrics Advisor use machine learning algorithms to automatically understand and detect anomalies based on time-series data. In addition, the Kusto data platform has built-in anomaly detection functions that account for seasonality and baseline trends in the data.

### Components

- [Data Explorer](https://azure.microsoft.com/products/data-explorer) is a managed data analytics service for real-time analysis of large volumes of data. Data Explorer is a great tool for handling large datasets that require high speed and throughput of data retrieval. This architecture uses Data Explorer to store and query datasets for analysis.
- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is used to hold raw telemetry. This telemetry can come from your applications and services or from third-party vendors. The data can be treated as transient if you don't need to perform more analysis later. The data from Blob Storage is ingested into Data Explorer clusters.
- [Azure Event Grid](https://azure.microsoft.com/products/event-grid) is an event delivery system. It's used to listen to events that are published by Blob Storage. Azure Storage events allow applications to react to events like the creation and deletion of blobs. An Azure function subscribes to events that are published by Event Grid.
- [Azure Event Hubs](https://azure.microsoft.com/products/event-hubs) is a real-time data ingestion service that you can use to ingest millions of events per second from any source. Event hubs represent the front door, often called an event *ingestor*, for an event pipeline. An event ingestor is a component or service that's located between event publishers and event consumers. It decouples the production of an event stream from the consumption of the events.
- [Azure Functions](https://azure.microsoft.com/products/functions) is a serverless solution that's used to parse and transform data ingested via HTTP and blob endpoints and write to the Data Explorer cluster.
- [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana) connects easily to Data Explorer. In this architecture, it generates charts and dashboards that visualize telemetry data. Azure Managed Grafana provides deep integration with Azure Active Directory so you can implement role-based access of dashboards and views.
- [Azure Metrics Advisor](https://azure.microsoft.com/products/metrics-advisor) is a part of Azure Applied AI Services. It uses AI to perform data monitoring and anomaly detection in time-series data. Metrics Advisor automates the process of applying models to data and provides a set of APIs and a web-based workspace for data ingestion, anomaly detection, and diagnostics. You can use it without any knowledge of machine learning.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Your business-critical application needs to run despite a disruptive event like an Azure region or CDN outage. In this case, there are two primary strategies and one hybrid strategy for building redundancy into your system:

- **Active/Active** – Your code and functions are operating in a duplicate manner and either system can take over in case of a failure.
- **Active/Standby** – In this configuration, only one node is active/primary while the other one is waiting to take over in case the primary node goes down.
- **Mixed** – In this strategy, you have some components/services in Active/Active configuration and some in Active/Standby.

It is important to note that not all Azure services have built-in redundancy. For example, Azure Functions run a function app *only* in a specific region. Depending on how the Function is triggered (HTTP versus pub/sub), there are different strategies discussed in detail [here](/azure/azure-functions/functions-geo-disaster-recovery). 

While the ingestion and transformation Function App can run in active/active mode, for Azure Data Explorer, you can run in both [active/active and active/standby configurations](https://techcommunity.microsoft.com/t5/azure-data-explorer-blog/azure-data-explorer-and-business-continuity/ba-p/1332767).

The last piece of monitoring is Grafana. Azure Managed Grafana supports [availability zone redundancy out of the box](/AZURE/managed-grafana/how-to-enable-zone-redundancy). To build cross-region redundancy, one strategy is to set up Grafana in each region where your Azure Data Explorer cluster is deployed. 

Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost of this architecture is a function of the number of ingress telemetry events, storage of raw telemetry in Blob Storage and Azure Data Explorer, an hourly cost for managed Grafana, and a static cost for the number of time series charts in Metrics Advisor.

Please see the [Cost Estimate](https://azure.com/e/ed90eb013b60448684b3ef40d123ff13) calculator to calculate your hourly or monthly cost of using Azure.

Performance efficiency

Depending on the scale and frequency of incoming requests, you will find the Function App to be a chokepoint. There are two major factors for this:

1.	**Cold start** – This is a phenomenon of serverless executions and refers to the scheduling and set-up time required to spin up an environment until the function first starts to execute. In the worst case, this can be on the order of a few seconds.
2.	**Frequency of requests** – Imagine you have 1000 HTTP requests but only a single-threaded server to handle these incoming requests. You will not be able to service all the 1000 HTTP requests concurrently. To serve these requests in a timely fashion, you need to deploy more servers, i.e., scale horizontally. 

In both cases, it is recommended you use Premium or Dedicated SKUs to 1) eliminate cold start, and 2) handle requirements for concurrent requests by scaling up/down the number of servicing virtual machines. More details on SKUs can be found here.

Alternatives

Azure Data Factory and Azure Synapse

*Azure Data Factory* and *Azure Synapse* provide industry-leading tools and workspaces to build ETL workflows with the ability to track and retry jobs from a graphical interface. The main thing to note here is that *Data Factory* and *Synapse* both have a minimum lag of ~5 minutes from the time of ingestion to persistence. This lag may be acceptable in your monitoring system. If so, we strongly recommend you weigh Data Factory and Synapse heavily in your decision-making process.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors:*

Principal authors:

- Uffaz Nathaniel | Principal Software Engineer
- John Hauppa | Senior Technical Program Manager

Other contributors:

- Dilmurod Makhamadaliev | Software Engineer
- Omeed Musavi| Principal Software Engineer Lead
- Ayo Mustapha | Principal Technical Program Manager

other line

## Next steps

- Read the associated blog post: [Chrysalis (microsoft.com)](https://chrysalis.microsoft.com/assets/5a2ee1a3-5132-452a-9fa6-6098f753eb33)  
- Code samples to bootstrap your development: https://github.com/Azure-Samples/real-time-monitoring-and-observability-for-media 

## Related resources 