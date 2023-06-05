This architecture describes a solution that provides real-time monitoring and observability of systems and end-user device telemetry data. It focuses on a use case for the media industry.

*[Grafana](https://grafana.com) is a trademark of its respective company. No endorsement is implied by the use of this mark.*

## Architecture

:::image type="content" source="media/monitor-media.png" alt-text="Diagram that shows an architecture that provides real-time monitoring and observability of systems and end-user device telemetry data." lightbox="media/monitor-media.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/real-time-monitoring.vsdx) of this architecture.*

### Dataflow

In the observable system shown in the diagram, raw telemetry is streamed to Azure Blob Storage via HTTP and connectors. The raw telemetry is processed, transformed, normalized, and saved in Azure Data Explorer for analysis. Systems like Grafana and Azure Metrics Advisor read data from Data Explorer and provide insights to end users.

More specifically, these are the elements of the system in the diagram:

1.	**Instrumentation.** Instrumentation occurs via probes or agents that are installed in systems to monitor data. These agents come in various forms. For example, in a video-on-demand streaming platform, a company might use open-standards [dash.js](https://github.com/Dash-Industry-Forum/dash.js) to collect Quality of Experience metrics from customers.
2.	**Ingestion.** This raw telemetry can come directly from end clients via HTTP calls. Alternatively, you can upload it via third-party systems to persistent storage and data lakes like Blob Storage. Blog Storage supports the ability to invoke an Azure function when a new file is uploaded. You can use this trigger mechanism to move raw telemetry to structured data warehouses.
3.	**Transformation and persistence.** You might need a transformation system to normalize your data. An Azure Functions app transforms the data as needed and then writes it to Data Explorer. Data Explorer is ideal for big data analytics because it's designed for high performance and throughput on large data sets.
4.	**Monitoring.** Azure Managed Grafana supports integration with Data Explorer. You can use the drag-and-drop features of Grafana to quickly build dashboards and charts. Grafana is a good fit for media monitoring because it provides sub-minute refreshing of dashboard tiles and can also be used for alerting.
5.	**Anomaly detection.** The Grafana dashboard provides support for manual monitoring in the NOC. However, with a large data set and a user base spread across geographies and using various devices, manual identification of issues via charts and alert rules that have hard-coded thresholds becomes inefficient. You can use AI to address this problem. Services like Metrics Advisor use machine learning algorithms to automatically understand and detect anomalies based on time-series data. In addition, the Kusto data platform has built-in anomaly detection functions that account for seasonality and baseline trends in the data.

### Components

- [Data Explorer](https://azure.microsoft.com/products/data-explorer) is a managed data analytics service for real-time analysis of large volumes of data. Data Explorer is a great tool for handling large datasets that require high speed and throughput of data retrieval. This architecture uses Data Explorer to store and query datasets for analysis.
- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is used to hold raw telemetry. This telemetry can come from your applications and services or from third-party vendors. The data can be treated as transient if you don't need to perform more analysis later. The data from Blob Storage is ingested into Data Explorer clusters.
- [Azure Event Grid](https://azure.microsoft.com/products/event-grid) is an event delivery system. It's used to listen to events that are published by Blob Storage. Azure Storage events allow applications to react to events like the creation and deletion of blobs. An Azure function subscribes to events that are published by Event Grid.
- [Azure Event Hubs](https://azure.microsoft.com/products/event-hubs) is a real-time data ingestion service that you can use to ingest millions of events per second from any source. Event hubs represent the front door, often called an event *ingestor*, for an event pipeline. An event ingestor is a component or service that's located between event publishers and event consumers. It decouples the production of an event stream from the consumption of the events.
- [Azure Functions](https://azure.microsoft.com/products/functions) is a serverless solution that's used to parse and transform data ingested via HTTP and blob endpoints and write to the Data Explorer cluster.
- [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana) connects easily to Data Explorer. In this architecture, it generates charts and dashboards that visualize telemetry data. Azure Managed Grafana provides deep integration with Azure Active Directory (Azure AD) so that you can implement role-based access to dashboards and views.
- [Metrics Advisor](https://azure.microsoft.com/products/metrics-advisor) is a part of Azure Applied AI Services. It uses AI to perform data monitoring and anomaly detection in time-series data. Metrics Advisor automates the process of applying models to data and provides a set of APIs and a web-based workspace for data ingestion, anomaly detection, and diagnostics. You can use it even if you have no knowledge of machine learning.

### Alternatives

[Azure Data Factory](https://azure.microsoft.com/products/data-factory) and [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) provide tools and workspaces for building ETL workflows and the ability to track and retry jobs from a graphical interface. Note that Data Factory and Azure Synapse both have a minimum lag of about 5 minutes from the time of ingestion to persistence. This lag might be acceptable in your monitoring system. If it is, we recommend that you consider these alternatives.

## Scenario details

Organizations often deploy varied and large-scale technologies to solve business problems. These systems, and end-user devices, generate large sets of telemetry data. 

This architecture is based on a use case for the media industry. Media streaming for live and video-on-demand playback requires near real-time identification of and response to application problems. To support this real-time scenario, organizations need to collect a massive telemetry set, which requires scalable architecture. After the data is collected, other types of analysis, like AI and anomaly detection, are needed to efficiently identify problems across so large a data set.

When large-scale technologies are deployed, the system and end-user devices that interact with them generate massive sets of telemetry data. In traditional scenarios, this data is analyzed via a data warehouse system to generate insights that can be used to support management decisions. This approach might work in some scenarios, but it's not responsive enough for streaming media use cases. To solve this problem, real-time insights are required for the telemetry data that's generated from monitoring servers, networks, and the end-user devices that interact with them. Monitoring systems that catch failures and errors are common, but to catch them in near real-time is difficult. That's the focus of this architecture.

In a live streaming or video-on-demand setting, telemetry data is generated from systems and heterogeneous clients (mobile, desktop, and TV). The solution involves taking raw data and associating context with the data points, for example, dimensions like geography, end-user operating system, content ID, and CDN provider. The raw telemetry is collected, transformed, and saved in Data Explorer for analysis. You can then use AI to make sense of the data and automate the manual processes of observation and alerting. You can use systems like Grafana and Metrics Advisor to read data from Data Explorer to show interactive dashboards and trigger alerts.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Business-critical applications need to keep running even during disruptive events like Azure region or CDN outages. There are two primary strategies and one hybrid strategy for building redundancy into your system:

- **Active/active.** Duplicate code and functions are running. Either system can take over during a failure.
- **Active/standby.** Only one node is active/primary. The other one is ready to take over in case the primary node goes down.
- **Mixed.** Some components/services are in the active/active configuration, and some are in active/standby.

Keep in mind that not all Azure services have built-in redundancy. For example, Azure Functions runs a function app only in a specific region. [Azure Functions geo-disaster recovery](/azure/azure-functions/functions-geo-disaster-recovery) describes various strategies that you can implement, depending on how your functions are triggered (HTTP versus pub/sub).

The ingestion and transformation function app can run in active/active mode. You can run Data Explorer in both [active/active and active/standby configurations](https://techcommunity.microsoft.com/t5/azure-data-explorer-blog/azure-data-explorer-and-business-continuity/ba-p/1332767).

Azure Managed Grafana supports [availability zone redundancy](/azure/managed-grafana/how-to-enable-zone-redundancy). One strategy for creating cross-region redundancy is to set up Grafana in each region in which your Data Explorer cluster is deployed.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost of this architecture depends on the number of ingress telemetry events, your storage of raw telemetry in Blob Storage and Data Explorer, an hourly cost for Azure Managed Grafana, and a static cost for the number of time-series charts in Metrics Advisor.

You can use the [Azure pricing calculator](https://azure.com/e/ed90eb013b60448684b3ef40d123ff13) to estimate your hourly or monthly costs.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Depending on the scale and frequency of incoming requests, the function app might be a bottleneck, for two main reasons:

- **Cold start.** Cold start is a consequence of serverless executions. It refers to the scheduling and setup time that's required to spin up an environment before the function first starts running. At most, the required time is a few seconds.
- **Frequency of requests.** Say you have 1,000 HTTP requests but only a single-threaded server to handle them. You won't be able to service all 1,000 HTTP requests concurrently. To serve these requests in a timely manner, you need to deploy more servers. That is, you need to scale horizontally. 

We recommend that you use Premium or Dedicated SKUs to:

- Eliminate cold start.
- Handle requirements for concurrent requests by scaling the number of servicing virtual machines up or down.

For more information, see [Select a SKU for your Azure Data Explorer cluster](/azure/data-explorer/manage-cluster-choose-sku).

## Deploy this scenario

For information about deploying this scenario, see  [real-time-monitoring-and-observability-for-media](https://github.com/Azure-Samples/real-time-monitoring-and-observability-for-media) on GitHub. This code sample includes the necessary infrastructure-as-code (IaC) to bootstrap development and Azure functions to ingest and transform the data from HTTP and blob endpoints.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [John Hauppa](https://www.linkedin.com/in/johnhauppa) | Senior Technical Program Manager
- [Uffaz Nathaniel](https://www.linkedin.com/in/uffaz-nathaniel-85588935) | Principal Software Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 
- [Dilmurod Makhamadaliev](https://www.linkedin.com/in/dilmurod-makhamadaliev) | Software Engineer
- [Omeed Musavi](https://www.linkedin.com/in/omusavi) | Principal Software Engineer Lead
- [Ayo Mustapha](https://www.linkedin.com/in/ayo-mustapha) | Principal Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Supplementary code samples](https://github.com/Azure-Samples/real-time-monitoring-and-observability-for-media) 
- [Azure Data Explorer documentation](/azure/data-explorer)
- [Introduction to Azure Data Explorer - Training](/training/modules/intro-to-azure-data-explorer)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)

## Related resources 

- [Monitor Media Services](/azure/media-services/latest/monitoring/monitor-media-services?toc=https%3A%2F%2Flearn.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Flearn.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
- [Big data analytics with Azure Data Explorer](../../solution-ideas/articles/big-data-azure-data-explorer.yml)