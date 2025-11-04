This architecture describes a solution that provides near real-time monitoring and observability of systems and user device telemetry data. It focuses on a use case for the media industry.

## Architecture

:::image type="complex" source="media/monitor-media.svg" alt-text="Diagram that shows an architecture that provides near real time monitoring and observability of systems and user device telemetry data." lightbox="media/monitor-media.svg" border="false":::
The diagram shows two data flows. On the left, users connect to client devices by using players that generate telemetry via HTTP triggers (step 1). The data flows into Azure where a function processes it to collect device telemetry (step 2). The data routes through Azure Event Hubs to Azure Blob Storage (step 2), to Azure Event Grid, and then to an ingest-and-transform eventstream. Or the data can go directly from Event Hubs to the eventstream. The processed data flows to an eventhouse (step 3), and finally to the Real-Time Intelligence hub (step 4). The eventhouse also connects to Data Activator (step 5). The ingest-and-transform eventstream connects to Data Activator via a dashed line. In the second data flow, applications and services on the left connect via telemetry and connectors to Blob Storage or Event Hubs (step 1). This flow follows the same path as the first flow from Blob Storage, to Event Grid, and then to the eventstream. The function, Event Hubs, Blob Storage, and Event Grid reside in a section that represents Azure. The eventstream, eventhouse, Data Activator, and the Real-Time Intelligence hub reside in a section that represents Fabric.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/real-time-monitoring-rti.vsdx) of this architecture.*

### Data flow

Client devices and applications stream raw telemetry to Microsoft Fabric via HTTP and connectors. Eventstreams ingest the data. Fabric Real-Time Intelligence capabilities transform, normalize, and persist telemetry data into an eventhouse, which is a scalable time-series database. Real-Time Intelligence dashboards deliver insights, and Data Activator triggers automated actions based on detected patterns.

The following data flow corresponds to the previous diagram:

1. **Instrumentation:** Instrumentation occurs via probes or agents that are installed in systems to monitor data. These agents have various forms. For example, in a video-on-demand streaming platform, a company might use open-standards [dash.js](https://github.com/Dash-Industry-Forum/dash.js) to collect Quality of Experience (QoE) metrics from customers.

1. **Ingestion:** Clients ingest raw telemetry directly via HTTP calls to service-specific endpoints. Azure Functions handles incoming data. Alternatively, you can upload telemetry through external systems into persistent storage solutions, like Azure Blob Storage or data lakes. Fabric eventstreams provide a no-code experience to route this data to Fabric-native entities, such as an eventhouse or Data Activator.
1. **Transformation and persistence:** Fabric manages data transformation by using table update policies and materialized views. An eventhouse stores the transformed data and supports high-throughput analytics on large time-series datasets. This approach complements existing ingestion mechanisms. It also provides a more integrated and scalable alternative to traditional pipelines that rely on Azure Functions and Data Explorer for transformation and analytics.
1. **Monitoring:** The Real-Time Intelligence hub within Fabric centralizes access to streaming events and monitoring data. You can use it to visualize metrics, set alerts, and monitor performance across the Fabric tenant. This architecture primarily focuses on monitoring the applications, services, and client devices that have players—as shown on the left side of the diagram. These components generate the telemetry and operational signals that other components ingest and analyze. They serve as the core targets of observability.
1. **Anomaly detection:** Real-Time Intelligence includes built-in AI-powered anomaly detection through Data Activator. This feature can automatically identify unusual patterns or threshold breaches in streaming data and trigger responsive actions. These capabilities use machine learning models to detect anomalies in real time without manual configuration. Eventhouses also support advanced anomaly detection functions that account for seasonality, trends, and historical baselines. This capability enables more accurate and context-aware insights across large time-series datasets.

### Components

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a scalable object storage service for unstructured data. In this architecture, Blob Storage stores raw telemetry that originates from applications, services, or external vendors. Treat this data as transient if no further analysis is required. The telemetry routes through a Fabric eventstream into an eventhouse. You can use Fabric-native capabilities to transform and persist the data for high-throughput analytics.

- [Azure Event Grid](/azure/well-architected/service-guides/event-grid/reliability) is a managed event routing service that enables event-driven architectures. In this architecture, Event Grid serves as a reliable event delivery system that listens to events that Blob Storage publishes, such as blob creation or deletion. These events trigger downstream processing through Azure functions, which subscribe to Event Grid notifications. This integration enables responsive, event-driven workflows that support telemetry ingestion and routing within the broader Fabric-based architecture.

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs) is a big data streaming platform and event ingestion service that can receive and process millions of events per second. In this architecture, Event Hubs serves as the front door, often called an event *ingestor*, for the event pipeline. An event ingestor is a component or service located between event publishers and event consumers. It decouples the production of an eventstream from the consumption of the events.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) is a serverless compute service that you can use to run event-triggered code without having to explicitly provision or manage infrastructure. In this architecture, Azure Functions parses and transforms data ingested via HTTP and blob endpoints. The telemetry data routes to eventstreams and eventhouses for scalable transformation and analytics.

- A [Fabric eventstream](/fabric/real-time-intelligence/event-streams/overview) is a feature in Fabric that enables real-time event ingestion, transformation, and routing. In this architecture, Fabric eventstreams provide various source connectors to fetch event data from various sources. You can use this approach to create your event data processing, transforming, and routing logic without writing code.

- A [Fabric eventhouse](/fabric/real-time-intelligence/eventhouse) is an analytics databases optimized for time-series data and real-time analytics workloads. In this architecture, eventhouses are tailored to time-based, streaming events that contain structured, semistructured, and unstructured data. You can get data from multiple sources, in multiple pipelines and multiple data formats. This data is indexed and partitioned based on ingestion time.

- [Data Activator](/fabric/real-time-intelligence/data-activator/activator-introduction) is a no-code feature in Fabric that automatically takes actions when it detects patterns in changing data. In this architecture, Data Activator serves as a low-latency event detection engine that triggers actions when it detects specific patterns or conditions in data sources. It monitors these data sources with subsecond latency and initiates actions when data meets thresholds or it detects specific patterns. These actions include sending emails or Teams notifications, launching Power Automate flows, or integrating with external systems.

### Alternatives

[Azure Data Factory](/azure/data-factory/introduction) provides tools to build extract, transform, and load (ETL) workflows and to track and retry jobs from a graphical user interface (GUI). Data Factory has a minimum lag of about 5 minutes from the time of ingestion to persistence. If your monitoring system can tolerate this lag, consider this alternative.

## Scenario details

Organizations often deploy varied and large-scale technologies to solve business problems. These systems, and user devices, generate large sets of telemetry data.

This architecture is based on a use case for the media industry. Media streaming for live and video-on-demand playback requires near real-time identification of and response to application problems. To support this real-time scenario, organizations need to collect a massive telemetry set, which requires scalable architecture. After they collect data, they must perform other types of analysis, like AI and anomaly detection, to efficiently identify problems across such a large dataset.

When large-scale technologies are deployed, the system and user devices that interact with them generate massive sets of telemetry data. In traditional scenarios, organizations analyze this data via a data warehouse system to generate insights that support management decisions. This approach might work in some scenarios, but it's not responsive enough for streaming media use cases. To solve this problem, organizations require real-time insights for the telemetry data that monitoring servers, networks, and user devices generate. Monitoring systems often detect failures and errors, but detecting them in near real-time is difficult. This architecture focuses on solving that problem.

In a live streaming or video-on-demand setting, systems and diverse clients, such as mobile devices, desktops, and TVs, generate telemetry data. The solution takes the raw data and associates context with each data point. Context examples include dimensions like geography, user operating system, content ID, and content delivery network provider. The system collects, transforms, and saves raw telemetry in a Fabric eventhouse for analysis. AI tools can interpret the data and automate the manual processes of observation and alerting. Data Activator reads data from the Real-Time Intelligence hub to display interactive dashboards and trigger alerts.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Business-critical applications must remain active even during disruptive events like Azure region or content delivery network outages. The following strategies, two primary strategies and one hybrid strategy, support building redundancy into your system:

- **Active/active:** Duplicate code and functions run. Either system can take over during a failure.

- **Active/standby:** Only one node serves as the active or primary node. The other node remains ready to take over if the primary node fails.
- **Mixed:** Some components or services use the active-active configuration, while others use the active-standby configuration.

Not all Azure services have built-in redundancy. For example, Azure Functions runs a function app only in a specific region. For more information about strategies to implement, depending on how you trigger functions (HTTP versus publish/subscribe), see [Reliability in Azure Functions](/azure/reliability/reliability-functions).

Fabric supports zone-redundant availability zones, where resources automatically replicate across zones, without any need for you to configure it. For more information about cross-region replication for data stored in OneLake, see [Reliability in Fabric](/azure/reliability/reliability-fabric). You can opt in or out of this feature based on your requirements.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of this architecture depends on the number of incoming telemetry events, the storage of raw telemetry in Blob Storage and Fabric eventhouses, and either a dedicated pricing model or a pay-as-you-go pricing model for Fabric capacity.

To estimate your total costs, use the [Azure pricing calculator](https://azure.com/e/e9fb45165e1c4ef0b46d880d818355cb).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Depending on the scale and frequency of incoming telemetry, streaming in Fabric might encounter performance constraints. These constraints typically result from the following factors:

- **Cold start:** Serverless invocations require time to schedule and set up the environment before the function runs. This setup takes up to a few seconds.

- **Frequency of requests:** For example, if 1,000 HTTP requests arrive but only a single-threaded server is available, the system can't process all requests concurrently. To handle them efficiently, you need to scale horizontally by deploying more servers.
- **Eventstream initialization delay:** When new data sources activate, Fabric eventstream pipelines might introduce latency. This delay resembles a cold start. Although brief, it can affect latency-sensitive scenarios.
- **High-frequency data bursts:** If thousands of telemetry events arrive at once, a single eventstream configuration might not process them concurrently. To maintain real-time responsiveness, you must scale out eventstream pipelines and optimize routing rules across multiple destinations.

To mitigate these problems, use dedicated capacity workspaces on Fabric SKUs. This approach provides the following benefits:

- Ensures consistent performance by removing initialization delays

- Supports horizontal scaling of eventstream pipelines to handle concurrent ingestion and transformation workloads

For more information, see [Fabric Real-Time Intelligence](/fabric/real-time-intelligence/overview).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Hauppa](https://www.linkedin.com/in/johnhauppa) | Senior Technical Program Manager
- [Uffaz Nathaniel](https://www.linkedin.com/in/uffaz-nathaniel-85588935) | Principal Software Engineer

Other contributors:

- [Dilmurod Makhamadaliev](https://www.linkedin.com/in/dilmurod-makhamadaliev) | Software Engineer
- [Omeed Musavi](https://www.linkedin.com/in/omusavi) | Principal Software Engineer Lead

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Real-Time Intelligence documentation](/fabric/real-time-intelligence)
- [Real-Time Intelligence tutorial: Introduction](/fabric/real-time-intelligence/tutorial-introduction)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [Supplementary code samples](https://github.com/microsoft/fabricrealtimelab)
- [Monitor Azure Media Services](/azure/media-services/latest/monitoring/monitor-media-services)

## Related resource

- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
