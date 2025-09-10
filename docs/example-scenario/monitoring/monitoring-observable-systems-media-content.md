This architecture describes a solution that provides near real time monitoring and observability of systems and end-user device telemetry data. It focuses on a use case for the media industry.

## Architecture

:::image type="content" source="media/monitor-media.png" alt-text="Diagram that shows an architecture that provides near real time monitoring and observability of systems and end-user device telemetry data." lightbox="media/monitor-media.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/real-time-monitoring.vsdx) of this architecture.*

### Dataflow

In the observable system architecture shown in the diagram, raw telemetry is streamed to Microsoft Fabric via HTTP and connectors, and ingested using Eventstream. Fabric’s Real-Time Intelligence capabilities enable transformation, normalization, and persistence of telemetry data into Eventhouse, a scalable time-series database. Insights are delivered through Real-Time Dashboards, and Activator, which can trigger automated actions based on detected patterns.

More specifically, these are the elements of the system in the diagram:

1. **Instrumentation.** Instrumentation occurs via probes or agents that are installed in systems to monitor data. These agents come in various forms. For example, in a video-on-demand streaming platform, a company might use open-standards [dash.js](https://github.com/Dash-Industry-Forum/dash.js) to collect Quality of Experience metrics from customers.
2. **Ingestion.** Raw telemetry can be ingested directly from end clients via HTTP calls to service-specific endpoints, where Azure Functions may still be used to handle incoming data. Alternatively, telemetry can be uploaded through third-party systems into persistent storage solutions like Blob Storage or data lakes. Fabric Eventstream offers a no-code experience for routing this data to Fabric-native entities such as Eventhouse and Activator.
3. **Transformation and persistence.** Within Fabric, data transformation is handled using table update policies and materialized views. The transformed data is stored in Eventhouse, which supports high-throughput analytics on large time-series datasets. This approach complements existing ingestion mechanisms and provides a more integrated and scalable alternative to traditional pipelines that previously relied on Azure Functions and Data Explorer for transformation and analytics.
4. **Monitoring.** The Real-Time Hub within Fabric centralizes access to streaming events and monitoring data. While it enables users to visualize metrics, set alerts, and monitor performance across the Fabric tenant, the primary monitoring focus in this architecture is on the applications, services, and client devices with players—as shown on the left side of the diagram. These components generate the telemetry and operational signals that are ingested and analyzed, making them the core targets of observability.
5. **Anomaly detection.** Fabric’s Real-Time Intelligence includes built-in AI-powered anomaly detection through Activator, which can automatically identify unusual patterns or threshold breaches in streaming data and trigger responsive actions. These capabilities leverage machine learning models to detect anomalies in real time without manual configuration. Additionally, Eventhouse supports advanced anomaly detection functions that account for seasonality, trends, and historical baselines—enabling more accurate and context-aware insights across large time-series datasets.

### Components

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is used to hold raw telemetry, which may originate from your applications, services, or third-party vendors. This data can be treated as transient if no further analysis is required. The telemetry is routed through Fabric Eventstream into Eventhouse, where it can be transformed and persisted for high-throughput analytics using Fabric-native capabilities.
- [Azure Event Grid](/azure/well-architected/service-guides/event-grid/reliability) serves as a reliable event delivery system that listens to events published by Azure Blob Storage, such as blob creation or deletion. These events trigger downstream processing through Azure Functions, which subscribe to Event Grid notifications. This integration enables responsive, event-driven workflows that support telemetry ingestion and routing within the broader Fabric-based architecture.
- [Azure Event Hubs](/azure/well-architected/service-guides/azure-databricks-security) is a streaming data ingestion service that you can use to ingest millions of events per second from any source. Event hubs represent the front door, often called an event *ingestor*, for an event pipeline. An event ingestor is a component or service that's located between event publishers and event consumers. It decouples the production of an event stream from the consumption of the events.
- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) is a serverless solution that's used to parse and transform data ingested via HTTP and blob endpoints. The telemetry data is routed to Eventstream and Eventhouse for scalable transformation and analytics.
- [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview) is a feature that provides you with various source connectors to fetch event data from the various sources. The drag and drop experience a way to create your event data processing, transforming, and routing logic without writing code.
- [Fabric Eventhouse](/fabric/real-time-intelligence/eventhouse) is tailored to time-based, streaming events with structured, semistructured, and unstructured data. You can get data from multiple sources, in multiple pipelines (For example, Eventstream, Software Development Kits, Kafka, Logstash, data flows, and more) and multiple data formats. This data is automatically indexed and partitioned based on ingestion time.
- [Fabric Activator](/fabric/real-time-intelligence/data-activator/activator-introduction) is a no-code and low-latency event detection engine that automatically triggers actions when specific patterns or conditions are detected in data sources. It continuously monitors these data sources with subsecond latency, and initiates actions when thresholds are met or specific patterns are detected. These actions can include sending emails or Teams notifications, launching Power Automate flows, or integrating with third-party systems.

### Alternatives

[Azure Data Factory](/azure/data-factory/introduction) provides tools for building ETL workflows and the ability to track and retry jobs from a graphical interface. Note that Data Factory has a minimum lag of about 5 minutes from the time of ingestion to persistence. This lag might be acceptable in your monitoring system. If it is, we recommend that you consider these alternatives.

## Scenario details

Organizations often deploy varied and large-scale technologies to solve business problems. These systems, and end-user devices, generate large sets of telemetry data.

This architecture is based on a use case for the media industry. Media streaming for live and video-on-demand playback requires near real-time identification of and response to application problems. To support this real-time scenario, organizations need to collect a massive telemetry set, which requires scalable architecture. After the data is collected, other types of analysis, like AI and anomaly detection, are needed to efficiently identify problems across so large a data set.

When large-scale technologies are deployed, the system and end-user devices that interact with them generate massive sets of telemetry data. In traditional scenarios, this data is analyzed via a data warehouse system to generate insights that can be used to support management decisions. This approach might work in some scenarios, but it's not responsive enough for streaming media use cases. To solve this problem, real-time insights are required for the telemetry data that's generated from monitoring servers, networks, and the end-user devices that interact with them. Monitoring systems that catch failures and errors are common, but to catch them in near real-time is difficult. That's the focus of this architecture.

In a live streaming or video-on-demand setting, telemetry data is generated from systems and heterogeneous clients (mobile, desktop, and TV). The solution involves taking raw data and associating context with the data points, for example, dimensions like geography, end-user operating system, content ID, and CDN provider. The raw telemetry is collected, transformed, and saved in Fabric Eventhouse for analysis. You can then use AI to make sense of the data and automate the manual processes of observation and alerting. You can use Data Activator to read data from Real-Time Hub to show interactive dashboards and trigger alerts.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Business-critical applications need to keep running even during disruptive events like Azure region or CDN outages. There are two primary strategies and one hybrid strategy for building redundancy into your system:

- **Active/active.** Duplicate code and functions are running. Either system can take over during a failure.
- **Active/standby.** Only one node is active/primary. The other one is ready to take over in case the primary node goes down.
- **Mixed.** Some components/services are in the active/active configuration, and some are in active/standby.

Keep in mind that not all Azure services have built-in redundancy. For example, Azure Functions runs a function app only in a specific region. [Azure Functions geo-disaster recovery](/azure/azure-functions/functions-geo-disaster-recovery) describes various strategies that you can implement, depending on how your functions are triggered (HTTP versus pub/sub).

Fabric makes commercially reasonable efforts to support zone-redundant availability zones, where resources automatically replicate across zones, without any need for you to set up or configure. [Reliability in Microsoft Fabric](/azure/reliability/reliability-fabric?toc=%2Ffabric%2Fsecurity%2Ftoc.json&bc=%2Ffabric%2Fbreadcrumb%2Ftoc.json) Fabric offers cross-region replication for data stored in OneLake. You can opt in or out of this feature based on your requirements.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of this architecture depends on the number of ingress telemetry events, the storage of raw telemetry in Blob Storage and Fabric Eventhouse, and a dedicated or pay-as-you-go cost for Fabric capacity.

You can use the [Azure pricing calculator](https://azure.com/e/ed90eb013b60448684b3ef40d123ff13) to estimate your total costs.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Depending on the scale and frequency of incoming telemetry, the streaming in Microsoft Fabric may encounter performance constraints, primarily due to two factors:

- **Eventstream initialization delay.** Similar to cold starts in serverless environments, initializing Fabric Eventstream pipelines can introduce latency when new data sources are activated. This setup time is typically brief but should be considered in latency-sensitive scenarios.
- **High-Frequency Data Bursts.** If thousands of telemetry events arrive simultaneously, a single Eventstream configuration may not process them concurrently. To maintain real-time responsiveness, it's essential to scale out Eventstream pipelines and optimize routing rules across multiple destinations.

To mitigate these issues, we recommend using dedicated capacity workspaces on Fabric SKUs to:

- Ensure consistent performance by eliminating initialization delays.
- Support horizontal scaling of Eventstream pipelines to handle concurrent ingestion and transformation workloads.

For more information, see [Microsoft Fabric Real-Time Intelligence documentation](/fabric/real-time-intelligence/overview).

## Next steps

- [Real-Time Intelligence documentation](/fabric/real-time-intelligence/)
- [Real-Time Intelligence tutorial: Introduction](/fabric/real-time-intelligence/tutorial-introduction)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [Supplementary code samples](https://github.com/microsoft/fabricrealtimelab)

## Related resources

- [Monitor Media Services](/azure/media-services/latest/monitoring/monitor-media-services?toc=https%3A%2F%2Flearn.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Flearn.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
