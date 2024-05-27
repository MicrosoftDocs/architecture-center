Automotive OEMs need solutions to minimize the time between doing test drives and getting test drive diagnostic data to R&D engineers. As vehicles become more automated, software lifecycles are shorter, and digital feedback loops must become faster. New technology can democratize data access and provide R&D engineers with near real-time insights into test drive diagnostic data. The usage of Copilots for data analytics further reduces the time-to-insight. Secure data sharing can enhance collaboration between OEMs and suppliers, further shortening development cycles.

This example workload relates to both telemetry and batch test drive data ingestion scenarios. The workload focuses on the data platform that processes diagnostic data, and the connectors for visualization and reporting.

## Architecture

:::image type="content" source="images/analytics-dataflow.svg" alt-text="Diagram that shows the analytics dataflow for automotive streaming data and files." border="false" lightbox="images/analytics-dataflow.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/next-generation-telemetry-analytics-automotive.pptx) with all the diagrams in this article.*

### Dataflow

1. The Data capture is connected to the vehicle networks and collects high-resolution vehicle signal data. The device publishes either live vehicle signal messages (**1b**) or requests upload of recorded data files (**1b**) using an MQTT client to Azure Event Grid's MQTT broker functionality.

1. Event Grid routes live vehicle signal data (**2a**) to an Azure Functions app that decodes the vehicle signals to JavaScript Object Notation (JSON) and posts it to an Azure Event Hubs namespace.

   Event Grid handles file upload with the device client(**2b**) to OneLake or Azure Blob Storage. A completed file upload triggers a pipeline that decodes the data and writes the decoded file to OneLine in a format suitable for ingestion, such as parquet or CSV.

1. An eventstream consumes the events from the Event Hubs namespace and triggers ingestion of decoded JSON vehicle signals into the KQL database (**3a**).

    A data pipeline triggers ingestion of decoded files from OneLake (**3b**).

1. The KQL database uses [update policies](/azure/data-explorer/kusto/management/update-policy) to expand the JSON data into a suitable row format and to enrich the data. For example, clusters location data to support geospatial analytics. Every time a new row is ingested, the Real-Time Analytics engine invokes an associated `Update()` function.

1. Data Engineers and Data scientists use the [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) capabilities to build analytics use cases. Users store often-used cases as shareable user-defined functions. The engineers use build-in KQL functions such as aggregation, time series analysis, geospatial clustering, windowing, and machine learning (ML) plugins.

1. R&D engineers and Data Scientists use notebooks to analyze data and build test & validation use cases.
    1. The R&D engineers use [KQL Query Sets](/real-time-intelligence/kusto-query-se) to perform interactive data analysis, using the [Copilot for Real-Time Intelligence](/fabric/get-started/copilot-real-time-intelligence)
    1. Data Engineers and Data scientists use [notebooks](/fabric/real-time-intelligence/notebooks) to store and share their analysis processes. With notebooks, engineers can run analytics using Spark and [manage the notebook code](/fabric/data-engineering/notebook-source-control-deployment) with Git.

1. R&D Engineers and Data Scientists can use Power BI with Dynamic Query or Real-Time Analytics Dashboards to create visualizations to share with business users. These visualizations apply the user-defined functions for ease of maintenance.

1. Engineers can also connect more tools to Fabric. As an example, it's possible to connect Azure managed Grafana to the KQL database, or create a Web Application that queries the KQL database directly.

1. The data collector configuration enables engineers to change the data collection policies of the data capture device. Azure API Management abstracts and secures the partner configuration API, and provides observability.

### KQL database schema

:::image type="content" source="images/data-explorer-schema.svg" alt-text="Diagram that shows the Azure Data Explorer functions and methods for extracting, expanding, and enriching data." border="false":::

When [designing the table schema](/azure/data-explorer/kusto/concepts/fact-and-dimension-tables), it's useful to consider the difference between `fact`  and `dimension` tables. Telemetry is a `fact` table, as vehicle signals are progressively appended in either a streaming fashion or as part of a complete recording, and it doesn't change. The fleet metadata can be considered a `fact` table that updates slowly. It requires a last-modified timestamp column.

The vehicle telemetry lands in raw tables. You can use the following functions to process the messages:

1. Create update policies to expand the JSON files using methods such as:

   - `mv-expand()` to expand complex values stored in JSON structures into rows with individual signals.
   - `geo_point_to_h3cell()` or `geo_point_to_geohash()` to convert latitude and longitude to geohashes for geospatial analytics.
   - `todouble()` and `tostring()` to cast extracted values from dynamic JSON objects into the appropriate data types.
   - `lookup` to extend the records with values from a dimension table.

1. The **Signals Deduped** materialized view uses `take_any()` on the unique key and timestamp to deduplicate signals.

1. The **Signals Last Known Values** materialized view uses `arg_max()` on the timestamp to keep an up-to-date status of the vehicles.

1. The **Signals Downsampled** materialized view aggregates signals by using predefined bins such as *hourly* and *daily* to simplify reporting across the fleet.

1. Create user defined functions that provide anomaly detection or root cause analysis
    - Use time-series functions for [anomaly detection and forecasting](/data-explorer/kusto/query/anomaly-detection) to detect potential problems and predict failures.
    - Use the [scan operator](/azure/data-explorer/kusto/query/scan-operator) to scan, match, and build sequences from the data. The scan operator enables engineers to detect sequences such as "If A happens, then B must happen within X seconds"
    - ML plugins like [autocluster](/azure/data-explorer/kusto/query/autocluster-plugin) find common patterns of discrete attributes.

1. Perform geospatial analytics with user defined functions. Use the [Geospatial Analytics](/kusto/query/geospatial-grid-systems) functions to convert coordinates to a suitable grid system and perform aggregations on the data.

1. The fleet metadata table reflects changes on the vehicle metadata and configuration. The **Fleet metadata last known values** materialized view shows the latest state of the vehicle fleet.

### Components

The following key technologies implement this workload:

- [Microsoft Fabric Real Time Intelligence](/fabric/real-time-intelligence) enables extraction of insights and visualization of vehicle telemetry in motion. It contains event streams, the time-series KQL database to store and analyze data and Reflex for reacting to events.
- [Azure Event Grid](/azure/event-grid) is a Pub Sub message distribution service that supports the MQTT protocol. It enables vehicles to publish and subscribe to topics to publish telemetry and subscribe to command and control messages.
- [Azure Event Hubs](/azure/event-hubs) is a real time data streaming platform, well suited for streaming million of vehicle events per second with low latency.
- [Azure Functions](/azure/functions) is a serverless solution that simplifies processing vehicle telemetry events at scale with event-driven triggers and bindings, using the language of your choice.
- [Azure Managed Grafana](/azure/managed-grafana) is a data visualization platform build on top of the Grafana software by Grafana Labs, fully operated and supported by Microsoft.
- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) enables you to build and host web apps, mobile back ends, and RESTful APIs that provide access to the vehicle telemetry data stored in Microsoft Fabric to simplify consumption.
- [Azure API Management](/azure/api-management) is a hybrid, multicloud management platform for APIs.

### Alternatives

This architecture can also be implemented using base Azure products:

- [Azure Blob Storage](/azure/storage/blobs) stores massive amounts of unstructured data, such as recordings, logs, and videos from the vehicles. It replaces OneLake storage
- [Azure Data Explorer](/azure/data-explorer) is a fast, fully managed data analytics service for real-time analysis. It replaces the Fabric Real Time Intelligence KQL Database

[Azure Batch](https://azure.microsoft.com/services/batch) is a good alternative for complex file decoding. This scenario involves large numbers of files over 300 megabytes that require different decoding algorithms based on file version or type.

:::image type="content" source="images/batch-workflow.svg" alt-text="Diagram that shows an alternative Azure Batch method for decoding complex files." border="false":::

1. The user uploads a recorded data file to Blob Storage. When the upload is completed, it triggers a Functions app to schedule decoding.
1. The scheduler starts a Functions app that creates a batch job, taking into consideration the file type, size, and required decoding algorithm. The app selects a suitable virtual machine (VM) from the pool and starts the job.
1. Batch writes the resulting decoded file back to Blob Storage when the job completes. This file must be suitable for direct ingestion in a format that Azure Data Explorer supports.
1. OneLake or Blob Storage triggers a function that ingests the data into Azure Data Explorer upon file write. This function creates the table and data mapping if necessary, and starts the ingestion process.
1. The KQL database or Azure Data Explorer ingests the data files from OneLake or Blob Storage.

This approach offers the following benefits:

- Azure Functions and Batch pools are able to handle scalable data processing tasks robustly and efficiently.
- Batch pools provide insight into processing statistics, task queues, and batch pool health. You can visualize status, detect problems, and rerun failed tasks.
- The combination of Azure Functions and Azure Batch supports plug-and-play processing in Docker containers.

## Scenario details

Automotive OEMs use large fleets of prototype and test vehicles to test and verify all kinds of vehicle functions. Test procedures are expensive, because real drivers and vehicles need to be involved, and certain specific real-world road testing scenarios must pass multiple times. Integration testing is especially important to evaluate interactions between electrical, electronic, and mechanical components in complex systems.

To validate vehicle functions and analyze anomalies and failures, petabytes of diagnostic data must be captured from electronic control unit (ECUs), computer nodes, vehicle communication buses like Controller Area Network (CAN) and Ethernet, and sensors. In the past, small data logger servers in the vehicles stored diagnostic data locally as Measurement Data Format (MDF), multimedia fusion extension (MFX), CSV, or JSON files. After test drives were complete, the servers uploaded diagnostic data to data centers, which processed it and provided it to R&D engineers for analytics. This process could take hours or sometimes days. More recent scenarios use telemetry ingestion patterns like Message Queuing Telemetry Transport (MQTT)-based synchronous data streams, or near real-time file uploads.

### Potential use cases

- Vehicle management evaluates the performance and collected data per vehicle across multiple test scenarios.
- System and component validation uses collected vehicle data to verify that the behavior of vehicle components falls within operational boundaries across trips.
- Anomaly detection locates deviation patterns of a sensor value relative to its typical baseline pattern in real time.
- Root cause analysis uses ML plugins such as clustering algorithms to identify changes in the distribution of values on multiple dimensions.
- Predictive maintenance combines multiple data sources, enriched location data, and vehicle signals to predict component time to failure.
- Sustainability evaluation uses driver behavior and energy consumption to evaluate the environmental impact of vehicle operations.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- [Azure availability zones](https://azure.microsoft.com/global-infrastructure/availability-zones) are unique physical locations within the same Azure region. Availability zones can protect Azure Data Explorer compute clusters and data from partial region failure.
- [Business continuity and disaster recovery (BCDR)](/azure/data-explorer/business-continuity-overview) in Azure Data Explorer lets your business continue operating in the face of disruption.
- [Follower databases](/azure/data-explorer/follower) separate compute resources between production and nonproduction use cases.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

It's important to understand the division of responsibility between the automotive OEM and Microsoft. In the vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform-as-a-service (PaaS) provides built-in security on the physical stack, including the operating system. You can apply the following capabilities on top of the infrastructure security components.

- Private endpoints for network security.
  - [Private endpoints for Azure Data Explorer](/azure/data-explorer/security-network-private-endpoint)
  - [Allow access to Azure Event Hubs namespaces via private endpoints](/azure/event-hubs/private-link-service).
- Encryption at rest and in transit.
- Identity and access management that uses Microsoft Entra identities and [Microsoft Entra Conditional Access](/azure/active-directory/conditional-access) policies.
- [Row Level Security (RLS)](/azure/data-explorer/kusto/management/rowlevelsecuritypolicy) for KQL Databases and Azure Data Explorer.
- Use the [restrict](/azure/data-explorer/kusto/query/restrict-statement) statement when implementing middleware applications with access to the KQL database to create a logical model that restricts the user access to the data.
- Infrastructure governance that uses [Azure Policy](https://azure.microsoft.com/services/azure-policy).
- Data governance that uses [Microsoft Purview](https://azure.microsoft.com/services/purview).

All these features help automotive OEMs create a safe environment for their vehicle telemetry data. For more information, see [Security in Azure Data Explorer](/azure/data-explorer/security).

### Cost optimization

Cost optimization looks at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

This solution uses the following practices to help optimize costs:

- Correctly configure hot caches and cold storage for the Raw and Signals tables. The hot data cache is stored in RAM or SSD and provides improved performance. Cold data, however, is 45 times cheaper. Set a hot cache policy that's adequate for your use case, such as 30 days.
- Set up a retention policy on the Raw and Signals tables. Determine when the signal data is no longer relevant, for example after 365 days, and set the retention policy accordingly.
- Consider which signals are relevant for analysis.
- Use materialized views when querying the signals last known values, signals deduped, and signals downsampled. Materialized views consume fewer resources than doing source table aggregations on each query.
- Consider your real-time data analytics needs. Setting up streaming ingestion for the live telemetry table enables latency of less than one second between ingestion and query, but at a higher cost of more CPU cycles.

### Performance efficiency

Performance efficiency is your workload's ability to scale efficiently to meet user demands. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Consider using Azure Batch for decoding ff the number and size of recorded data files is greater than 1,000 files or 300 MB a day.
- Consider performing common calculations and analysis after ingest and storing them in extra tables.
- Use [KQL query best practices](/azure/data-explorer/kusto/query/best-practices) to make your query run faster

As the data grows in the KQL database and hits billions or trillions of records, it's critical to filter the data correctly, considering the active [partition policy](/azure/data-explorer/kusto/management/partitioning-policy). Use a where clause by ingestion time to reduce the amount of extends loaded when performing the query.

> [!WARNING]
> Consult with the support team before altering a data sharding policy.

## Deploy this scenario

Use the [step-by-step tutorial](https://github.com/microsoft/adx-automotive-demos/tree/main/mdf42adx) to deploy this scenario. The guide shows how to deploy a free instance, parse MDF files, ingest data, and perform some basic queries.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Frank Kaleck](https://www.linkedin.com/in/frank-kaleck) | Industry Advisor Automotive
- [Mario Ortegon-Cabrera](https://www.linkedin.com/in/marioortegon) | Principal Program Manager
- [Henning Rauch](https://www.linkedin.com/in/henning-rauch-adx) | Principal Program Manager
- [Boris Scholl](https://www.linkedin.com/in/bscholl) | Partner, Chief Architect

Other contributors:

- [Hans-Peter Bareiner](https://www.linkedin.com/in/hans-peter-bareiner-69039163) | Cloud Solution Architect
- [Jason Bouska](https://www.linkedin.com/in/jasonbouska) | Sr. Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Learn how to connect vehicles and devices to the cloud using the [MQTT broker feature in Azure Event Grid](azure/event-grid/mqtt-overview).
- Connect your [datastream to a KQL destination](fabric/real-time-intelligence/event-streams/add-destination-kql-database?pivots=enhanced-capabilities).
- Ingest recordings from [OneLake into a KQL database](fabric/real-time-intelligence/get-data-onelake). 
- Take a look to [materialized views](/azure/data-explorer/kusto/management/materialized-views/materialized-view-overview) to learn how to create materialized views, such as the last-known value tables.
- Create a [Real-Time Dashboard](/fabric/real-time-intelligence/dashboard-real-time-create) to visualize your vehicle data.
- Create a [Power BI Report](/fabric/real-time-intelligence/create-powerbi-report) for business users using Direct Query.
- Connect your vehicle data stream to an [Azure managed Grafana instance](/azure/data-explorer/grafana).

## Related resources

The following reference architectures are related to the automotive fleet test and validation scenario:

- [Automotive messaging, data, and analytics reference architecture](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution) covers more automotive and device messaging scenarios using the Event Grid MQTT broker.
- [Software-defined vehicle DevOps toolchain](azure/architecture/industries/automotive/software-defined-vehicle-reference-architecture) covers scenarios to develop, build, deploy, and test automotive software stacks for software-defined vehicles (SDV).
- [Autonomous vehicle operations design guide](../../guide/machine-learning/avops-design-guide.md) contains the approach for the development and model training of autonomous vehicle fleets.
