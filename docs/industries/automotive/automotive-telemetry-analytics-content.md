Automotive original equipment manufacturers (OEMs) need solutions to minimize the time between doing test drives and getting test drive diagnostic data to R&D engineers. As vehicles become more automated, software lifecycles are shorter, and digital feedback loops must become faster. New technology can democratize data access and provide R&D engineers with near real-time insights into test drive diagnostic data. The usage of Copilots for data analytics further reduces the time-to-insight. Secure data sharing can enhance collaboration between OEMs and suppliers, further shortening development cycles.

This example workload relates to both telemetry and batch test drive data ingestion scenarios. The workload focuses on the data platform that processes diagnostic data, and the connectors for visualization and reporting.

## Architecture

:::image type="content" source="images/analytics-dataflow.svg" alt-text="Diagram that shows the analytics dataflow for automotive streaming data and files." border="false" lightbox="images/analytics-dataflow.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/next-generation-telemetry-analytics-automotive.pptx) with all the diagrams in this article.*

### Dataflow

1. The *data capture device* is connected to the vehicle networks and collects high-resolution vehicle signal data and video. (**1a**) The device publishes live telemetry messages or (**1b**) requests upload of recorded data files using an MQTT client to Azure Event Grid's MQTT broker functionality using a Claim-Check pattern.

1. (**2a**) Event Grid routes live vehicle signal data  to an Azure Functions app that decodes the vehicle signals to JavaScript Object Notation (JSON) and posts it to an Event Stream.

   (**2b**) Event Grid orchestrates file upload with the device client to Lakehouse. A completed file upload triggers a pipeline that decodes the data and writes the decoded file to OneLine in a format suitable for ingestion, such as parquet or CSV.

1. (**3a**) The Event stream routes the decoded JSON vehicle signals for ingestion in Eventhouse.

    (**3b**) A data pipeline triggers ingestion of decoded files from Lakehouse.

1. Eventhouse uses [update policies](/azure/data-explorer/kusto/management/update-policy) to expand the JSON data into a suitable row format and to enrich the data. For example, cluster location data to support geospatial analytics. Every time a new row is ingested, the Real-Time Analytics engine invokes an associated `Update()` function.

1. Data Engineers and Data scientists use the [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) capabilities to build analytics use cases. Users store often-used cases as shareable user-defined functions. The engineers use build-in KQL functions such as aggregation, time series analysis, geospatial clustering, windowing, and machine learning (ML) plugins with Copilot support.

1. R&D engineers and Data Scientists use notebooks to analyze data and build test & validation use cases.
    1. The R&D engineers use [KQL Query Sets](/fabric/real-time-intelligence/kusto-query-set) to perform interactive data analysis, using the [Copilot for Real-Time Intelligence](/fabric/get-started/copilot-real-time-intelligence)
    1. Data Engineers and Data scientists use [notebooks](/fabric/real-time-intelligence/notebooks) to store and share their analysis processes. With notebooks, engineers can run analytics using Spark and [manage the notebook code](/fabric/data-engineering/notebook-source-control-deployment) with Git. Users can use the [Copilot for Data Engineering](/fabric/get-started/copilot-notebooks-overview) to support their workflow with contextual code suggestions.

1. R&D Engineers and Data Scientists can use Power BI with Dynamic Query or Real-Time Analytics Dashboards to create visualizations to share with business users. These visualizations invoke user-defined functions for ease of maintenance.

1. Engineers can also connect more tools to Fabric. As an example, it's possible to connect Azure managed Grafana to Eventhouse, or create a Web Application that queries Eventhouse directly.

1. Data and R&D Engineers use Data Activator(/fabric/data-activator/) to create Reflex items to monitor conditions and trigger actions such s triggering Power Automate flows for business integration. For example, notifying a teams channel in case that the health of a device degrades.

1. The *data collector configuration* enables engineers to change the data collection policies of the data capture device. Azure API Management abstracts and secures the partner configuration API, and provides observability.

### KQL database schema

:::image type="content" source="images/data-explorer-schema.svg" alt-text="Diagram that shows the KQL Database and methods for extracting, expanding, and enriching data." border="false":::

When [designing the table schema](/azure/data-explorer/kusto/concepts/fact-and-dimension-tables), it's useful to consider the difference between `fact`  and `dimension` tables. Telemetry is a `fact` table, as vehicle signals are progressively appended in either a streaming fashion or as part of a complete recording, and it doesn't change. The fleet metadata can be considered a `fact` table that updates slowly.

The vehicle telemetry lands in raw tables. You can use the following message processing concepts to organize the data for analysis and reporting:

1. Create update policies to expand the JSON telemetry files into individual vehicle signal records using methods such as:

   - `mv-expand()` to expand complex values stored in JSON structures into rows with individual signals.
   - `geo_point_to_h3cell()` or `geo_point_to_geohash()` to convert latitude and longitude to geohashes for geospatial analytics.
   - `todouble()` and `tostring()` to cast extracted values from dynamic JSON objects into the appropriate data types.
   - `lookup` to extend the records with values from a dimension table.

1. Create a **Signals Deduped** materialized view using the aggregation function `take_any()` on the unique key and timestamp to deduplicate signals.

1. Create a **Signals Last Known Values** materialized view using the aggregation funtion `arg_max()` on the timestamp to keep an up-to-date status of the vehicles.

1. Create a **Signals Downsampled** materialized view to aggregate signals using the [summarize operator](/azure/data-explorer/kusto/query/summarize-operator) with time bins such as *hourly* and *daily* to simplify reporting across the fleet.

1. Create user defined functions that provide anomaly detection or root cause analysis
    - Use time-series functions for [anomaly detection and forecasting](/azure/data-explorer/kusto/query/anomaly-detection) to detect potential problems and predict failures.
    - Use the [scan operator](/azure/data-explorer/kusto/query/scan-operator) to scan, match, and build sequences from the data. The scan operator enables engineers to detect sequences such as "If A happens, then B must happen within X seconds"
    - ML plugins like [autocluster](/azure/data-explorer/kusto/query/autocluster-plugin) find common patterns of discrete attributes.

1. Perform geospatial analytics with user defined functions. Use the [Geospatial Analytics](/azure/data-explorer/kusto/query/geospatial-grid-systems) functions to convert coordinates to a suitable grid system and perform aggregations on the data.

1. Create a **fleet metadata table** to store changes on the vehicle metadata and configuration. Create a **Fleet metadata last known values** materialized view to store the latest state of the vehicle fleet based on a last-time modified column.

### Components

The following key technologies implement this workload. For each component in the architecture, use the relevant Service Guide in the Well-Architected Framework where available. For additional information, see the [WAF Service Guides](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/?product=popular).

- [Microsoft Fabric Real Time Intelligence](/fabric/real-time-intelligence) enables extraction of insights and visualization of vehicle telemetry in motion. It contains event streams, the time-series KQL database to store and analyze data and Reflex for reacting to events.
- [Microsoft Fabric Data Activator](/fabric/data-activator/data-activator-introduction) is no code experience for automatically taking actions when patterns or conditions change in changing data.
- [Azure Event Grid](/azure/well-architected/service-guides/event-grid/reliability) is a Pub Sub message distribution service that supports the MQTT protocol. It enables vehicles to publish and subscribe to topics to publish telemetry and subscribe to command and control messages.
- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs/reliability) is a real time data streaming platform, well suited for streaming million of vehicle events per second with low latency.
- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) is a serverless solution that simplifies processing vehicle telemetry events at scale with event-driven triggers and bindings, using the language of your choice.
- [Azure Managed Grafana](/azure/managed-grafana) is a data visualization platform build on top of the Grafana software by Grafana Labs, fully operated and supported by Microsoft.
- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) enables you to build and host web apps, mobile back ends, and RESTful APIs that provide access to the vehicle telemetry data stored in Microsoft Fabric to simplify consumption.
- [Azure API Management](/azure/well-architected/service-guides/api-management/reliability) is a hybrid, multicloud management platform for APIs.

### Alternatives

This architecture can also be implemented using the following Azure services:

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) stores massive amounts of unstructured data, such as recordings, logs, and videos from the vehicles. It replaces OneLake storage.
- [Azure Data Explorer](/azure/data-explorer) is a fast, fully managed data analytics service for real-time analysis. It replaces the Fabric Real Time Intelligence KQL Database.

[Azure Batch](/azure/well-architected/service-guides/azure-batch/reliability) is a good alternative for complex file decoding. This scenario involves large numbers of files over 300 megabytes that require different decoding algorithms based on file version or type. This approach can be done both with Microsoft Fabric or with Blob Storage with Azure Data Explorer.

:::image type="content" source="images/batch-workflow.svg" alt-text="Diagram that shows an alternative Azure Batch method for decoding complex files." border="false":::

1. The user or recording device uploads a recorded data file to Lakehouse. When the upload is completed, it triggers a Functions app to schedule decoding.
1. The scheduler starts a Functions app that creates a batch job, taking into consideration the file type, size, and required decoding algorithm. The app selects a virtual machine (VM) with a suitable size from the pool and starts the job.
1. Azure Batch writes the resulting decoded file back to Lakehouse when the job completes. This file must be suitable for direct ingestion in a format that Eventhouse supports.
1. Lakehouse triggers a function that ingests the data into Eventhouseupon file write. This function creates the table and data mapping if necessary, and starts the ingestion process.
1. The KQL database  ingests the data files from Lakehouse.

This approach offers the following benefits:

- Azure Functions and Batch pools are able to handle scalable data processing tasks robustly and efficiently.
- Batch pools provide insight into processing statistics, task queues, and batch pool health. You can visualize status, detect problems, and rerun failed tasks.
- The combination of Azure Functions and Azure Batch supports plug-and-play processing in Docker containers.
- Cost savings with the use of [Spot Virtual Machines](/azure/batch/batch-spot-vms) to process files in off-peak times

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
- Automotive racing to understand and improve the performance of the vehicles before, during and after a race.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- [Azure availability zones](https://azure.microsoft.com/global-infrastructure/availability-zones) are unique physical locations within the same Azure region. Availability zones can protect Azure Data Explorer compute clusters and data from partial region failure.
- [Business continuity and disaster recovery (BCDR)](/azure/data-explorer/business-continuity-overview) in Azure Data Explorer lets your business continue operating in the face of disruption.
- [Follower databases](/azure/data-explorer/follower) separate compute resources between production and nonproduction use cases.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

It's important to understand the division of responsibility between the automotive OEM and Microsoft. In the vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform-as-a-service (PaaS) provides built-in security on the physical stack, including the operating system.

- Use [Azure Policy](https://azure.microsoft.com/services/azure-policy) to apply security guardrails.
- Review the [governance overview and guidance](/fabric/governance/governance-compliance-overview) for Microsoft Fabric
- Use Private endpoints for network security for all services.
  - [Private endpoints for Azure Data Explorer](/azure/data-explorer/security-network-private-endpoint)
  - [Allow access to Azure Event Hubs namespaces via private endpoints](/azure/event-hubs/private-link-service).
- Encrypt data at rest and in transit.
- Use Microsoft Entra identities and [Microsoft Entra Conditional Access](/azure/active-directory/conditional-access) policies.
- Use [row level security (RLS)](/azure/data-explorer/kusto/management/rowlevelsecuritypolicy) for KQL Databases and Azure Data Explorer.
- Use the [restrict](/azure/data-explorer/kusto/query/restrict-statement) statement when implementing middleware applications with access to the KQL database to create a logical model that restricts the user access to the data.

All these features help automotive OEMs create a secure environment for their vehicle telemetry data. For more information, see [Security in Microsoft Fabric](/fabric/security/security-overview).

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

- Consider using Azure Batch for decoding if the number and size of recorded data files is greater than 1,000 files or 300 MB a day.
- Consider performing common calculations and analysis after ingest and storing them in extra tables.
- Use [KQL query best practices](/azure/data-explorer/kusto/query/best-practices) to make your query run faster
- As the data grows in the KQL database and hits billions or trillions of records, it's critical to filter the data correctly, considering the active [partition policy](/azure/data-explorer/kusto/management/partitioning-policy). Use a `where` clause to define a time window to reduce the amount of data queried. Consider changing the data partition policy for the *Signals* table if your common search criteria is not time-based (for example, filtering by recording id and signal name).

> [!WARNING]
> Consult with your support team before altering a data partition policy.

## Deploy this scenario

Use the [step-by-step tutorial](https://github.com/microsoft/adx-automotive-demos/tree/main/mdf42adx) to deploy this scenario. The guide shows how to deploy a free instance, parse MDF files, ingest data, and perform some basic queries.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Boris Scholl](https://www.linkedin.com/in/bscholl) | Partner, Chief Architect
- [Frank Kaleck](https://www.linkedin.com/in/frank-kaleck) | Industry Advisor Automotive
- [Henning Rauch](https://www.linkedin.com/in/henning-rauch-adx) | Principal Program Manager
- [Mario Ortegon-Cabrera](https://www.linkedin.com/in/marioortegon) | Principal Program Manager, MCI Software-Defined Vehicle and Mobility

Other contributors:

- [Devang Shah](https://www.linkedin.com/in/shahdevang) | Principal Program Manager
- [Hans-Peter Bareiner](https://www.linkedin.com/in/hans-peter-bareiner-69039163) | Cloud Solution Architect
- [Jason Bouska](https://www.linkedin.com/in/jasonbouska) | Sr. Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Learn how to connect vehicles and devices to the cloud using the [MQTT broker feature in Azure Event Grid](/azure/event-grid/mqtt-overview).
- Understand how to transfer files without storing the payload in a MQTT message using the [Claim-Check pattern](/azure/architecture/patterns/claim-check).
- Connect your [datastream to a KQL destination](/fabric/real-time-intelligence/event-streams/add-destination-kql-database?pivots=enhanced-capabilities).
- Ingest recordings from [OneLake into a KQL database](/fabric/real-time-intelligence/get-data-onelake).
- Read about [materialized views](/azure/data-explorer/kusto/management/materialized-views/materialized-view-overview) to learn how to create materialized views, such as the last-known value tables.
- Create a [Real-Time Dashboard](/fabric/real-time-intelligence/dashboard-real-time-create) to visualize your vehicle data.
- Set up an [alert from a Real-Time Dashboard](/fabric/data-activator/data-activator-get-data-real-time-dashboard) using Data Activator  
- Create a [Power BI Report](/fabric/real-time-intelligence/create-powerbi-report) for business users using Direct Query.
- Connect your vehicle data stream to an [Azure managed Grafana instance](/azure/data-explorer/grafana).

## Related resources

The following reference architectures are related to the automotive fleet test and validation scenario:

- [Automotive messaging, data, and analytics reference architecture](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution) covers more automotive and device messaging scenarios using the Event Grid MQTT broker.
- [Software-defined vehicle DevOps toolchain](/azure/architecture/industries/automotive/software-defined-vehicle-reference-architecture) covers scenarios to develop, build, deploy, and test automotive software stacks for software-defined vehicles (SDV).
- [Autonomous vehicle operations design guide](../../guide/machine-learning/avops-design-guide.md) contains the approach for the development and model training of autonomous vehicle fleets.
