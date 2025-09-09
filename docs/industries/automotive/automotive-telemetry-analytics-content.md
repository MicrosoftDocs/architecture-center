Automotive original equipment manufacturers (OEMs) need solutions to minimize the time between test drives and delivering test drive diagnostic data to R&D engineers. As vehicles become more automated, the software development lifecycles become shorter, which requires faster digital feedback loops. New technology can democratize data access and provide R&D engineers with near real-time insights into test drive diagnostic data. Use Copilot for Data Science and Data Engineering for data analytics to further reduce the time to insight. Secure data sharing can enhance collaboration between OEMs and suppliers and reduce development cycle times.

The guidance in this article is for telemetry scenarios and batch test drive data ingestion scenarios. This architecture focuses on the data platform that processes diagnostic data and the connectors for data visualization and data reporting.

## Architecture

:::image type="content" source="images/analytics-dataflow.svg" alt-text="Diagram that shows the analytics dataflow for streaming automotive data and files." border="false" lightbox="images/analytics-dataflow.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/next-generation-telemetry-analytics-automotive.pptx) with all the diagrams in this article.*

### Dataflow

The following dataflow corresponds to the preceding diagram:

1. The data capture device is connected to the vehicle networks and collects high-resolution vehicle signal data and video. (**1a**) The device publishes real-time telemetry messages or (**1b**) requests the upload of recorded data files to the Azure Event Grid MQTT broker functionality by using an MQTT client. This functionality uses a Claim-Check pattern.

1. (**2a**) Event Grid routes live vehicle signal data to an Azure Functions app. This app decodes the vehicle signals to the JavaScript Object Notation (JSON) format and posts them to an eventstream.

   (**2b**) Event Grid coordinates the file upload from the device client to the lakehouse. A completed file upload triggers a pipeline that decodes the data and writes the decoded file to OneLine in a format that's suitable for ingestion, such as parquet or CSV.

1. (**3a**) The eventstream routes the decoded JSON vehicle signals for ingestion in the Eventhouse.

    (**3b**) A data pipeline triggers the ingestion of decoded files from the lakehouse.

1. The Eventhouse uses [update policies](/azure/data-explorer/kusto/management/update-policy) to enrich the data and to expand the JSON data into a suitable row format, for example location data might be clustered to align with geospatial analytics. Every time a new row is ingested, the real-time analytics engine invokes an associated `Update()` function.

1. Data engineers and data scientists use [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) to build analytics use cases. Users store frequently used cases as shareable user-defined functions. The engineers use built-in KQL functions such as aggregation, time-series analysis, geospatial clustering, windowing, and machine learning plugins with Copilot support.

1. R&D engineers and data scientists use notebooks to analyze data and build test and validation use cases.

    1. R&D engineers use [KQL query sets](/fabric/real-time-intelligence/kusto-query-set) and [Copilot for Real-Time Intelligence](/fabric/get-started/copilot-real-time-intelligence) to perform interactive data analysis.

    1. Data engineers and data scientists use [notebooks](/fabric/real-time-intelligence/notebooks) to store and share their analysis processes. With notebooks, engineers can use Azure Spark to run analytics and use Git to [manage the notebook code](/fabric/data-engineering/notebook-source-control-deployment). Users can take advantage of [Copilot for Data Science and Data Engineering](/fabric/get-started/copilot-notebooks-overview) to support their workflow with contextual code suggestions.

1. R&D engineers and data scientists can use Power BI with dynamic queries or real-time analytics dashboards to create visualizations to share with business users. These visualizations invoke user-defined functions for ease of maintenance.

1. Engineers can also connect more tools to Microsoft Fabric. For instance, they can connect Azure Managed Grafana to the Eventhouse or create a web application that queries the Eventhouse directly.

1. Data engineers and R&D engineers use [Data Activator](/fabric/data-activator/) to create reflex items to monitor conditions and trigger actions, such as triggering Power Automate flows for business integration. For example, Data Activator can notify a Teams channel if the health of a device degrades.

1. The data collector configuration enables engineers to change the data collection policies of the data capture device. Azure API Management abstracts and secures the partner configuration API and provides observability.

### KQL database schema

:::image type="content" source="images/data-explorer-schema.svg" alt-text="Diagram that shows the KQL database and methods to extract, expand, and enrich data." border="false" lightbox="images/data-explorer-schema.svg":::

When [you design the table schema](/azure/data-explorer/kusto/concepts/fact-and-dimension-tables), consider the difference between `fact` tables and `dimension` tables. Telemetry is a `fact` table because vehicle signals are progressively appended in a streaming fashion or as part of a complete recording, and telemetry doesn't change. You can classify fleet metadata as a `fact` table that updates slowly.

The vehicle telemetry lands in raw tables. You can use the following message processing concepts to organize the data for analysis and reporting:

- Create update policies to expand the JSON telemetry files into individual vehicle signal records by using methods such as:

   - `mv-expand()` expands complex values that are stored in JSON structures into rows with individual signals.
   - `geo_point_to_h3cell()` or `geo_point_to_geohash()` converts latitude and longitude to geohashes for geospatial analytics.
   - `todouble()` and `tostring()` casts extracted values from dynamic JSON objects into the appropriate data types.
   - `lookup` extends the records with values from a dimension table.

- Create a **Signals Deduped** materialized view by using the aggregation function `take_any()` on the unique key and timestamp. This materialized view deduplicates signals.

- Create a **Signals Last Known Values** materialized view by using the aggregation function `arg_max()` on the timestamp. This materialized view provides an up-to-date status of the vehicles.

- Create a **Signals Downsampled** materialized view by using the [summarize operator](/azure/data-explorer/kusto/query/summarize-operator) with time bins such as *hourly* and *daily*. This materialized view aggregates signals and simplifies reporting across the fleet.

- Create user-defined functions that provide anomaly detection or root cause analysis.

    - Use time-series functions for [anomaly detection and forecasting](/azure/data-explorer/kusto/query/anomaly-detection) to detect potential problems and predict failures.

    - Use the [scan operator](/azure/data-explorer/kusto/query/scan-operator) to scan, match, and build sequences from the data. Engineers can use the `scan` operator to detect sequences. For example, if a specific event occurs, then a subsequent event must occur within a certain amount of time.

    - Use machine learning plugins like [autocluster](/azure/data-explorer/kusto/query/autocluster-plugin) to find common patterns of discrete attributes.

- Perform geospatial analytics with user-defined functions. Use the [geospatial analytics](/azure/data-explorer/kusto/query/geospatial-grid-systems/) functions to convert coordinates to a suitable grid system and perform aggregations on the data.

- Create a **fleet metadata table** to store changes on the vehicle metadata and configuration. Create a **fleet metadata last known values** materialized view to store the latest state of the vehicle fleet based on a last-time modified column.

### Components

The following key technologies implement this workload. For each component in the architecture, use the relevant service guide in the Well-Architected Framework where available. For more information, see [Well-Architected Framework service guides](/azure/well-architected/service-guides).

- [Fabric Real-Time Intelligence](/fabric/real-time-intelligence) is a service that ingests, analyzes, and reacts to streaming data via eventstreams and KQL databases. In this architecture, it stores and processes vehicle telemetry in motion, which enables real-time analytics and triggers automated actions through reflexes.

- [Data Activator](/fabric/data-activator/data-activator-introduction) is a no-code automation tool that responds to data patterns and conditions. In this architecture, it monitors telemetry data and triggers actions such as alerts or Power Automate flows when data meets predefined conditions.

- [Event Grid](/azure/well-architected/service-guides/event-grid/reliability) is a managed event routing service that supports MQTT and other protocols. In this architecture, it distributes telemetry and file upload events from vehicles to downstream services like Azure Functions and the lakehouse. Vehicles can use Event Grid to publish and subscribe to topics. For example, they can publish telemetry and subscribe to command and control messages. 

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs/reliability) is a real-time data streaming platform designed for high-throughput scenarios. In this architecture, it ingests millions of vehicle telemetry events per second with low latency for real-time processing.

- [Functions](/azure/well-architected/service-guides/azure-functions-security) is a serverless compute service that runs code in response to events. In this architecture, it decodes telemetry data, orchestrates file ingestion, and triggers downstream analytics workflows. It simplifies processing vehicle telemetry events at scale with event-driven triggers and bindings by using the language of your choice.

- [Azure Managed Grafana](/azure/managed-grafana/overview) is a data visualization platform based on the software from Grafana Labs. Microsoft manages and supports Azure Managed Grafana. In this architecture, it visualizes telemetry data stored in the eventhouse, which supports dashboards for engineering and operations teams.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a service for building and hosting web apps and APIs. In this architecture, it exposes vehicle telemetry data stored in Fabric through RESTful APIs that external applications consume.

- [API Management](/azure/well-architected/service-guides/api-management/reliability) is a hybrid multicloud platform for managing APIs. In this architecture, it secures and abstracts access to partner-facing APIs used for configuring data capture devices and integrating business workflows.

### Alternatives

You can also use the following Azure services to implement this architecture:

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) stores massive amounts of unstructured data, such as recordings, logs, and videos from the vehicles. It replaces OneLake storage.

- [Azure Data Explorer](https://azure.microsoft.com/products/data-explorer/) is a fast, fully managed data analytics service for real-time analysis. It replaces the Fabric Real-Time Intelligence KQL database.

- [Azure Batch](/azure/batch/) is an alternative that you can use to decode complex files. This scenario involves a large number of files that are over 300 megabytes each. The files require different decoding algorithms based on the file version or the file type. You can use either Fabric or use Blob Storage and Azure Data Explorer to implement the following approach.

:::image type="content" source="images/batch-workflow.svg" alt-text="Diagram that shows an alternative Batch method for decoding complex files." border="false" lightbox="images/batch-workflow.svg":::

1. The user or recording device uploads a recorded data file to the lakehouse. When the upload finishes, it triggers a Functions app that schedules decoding.

1. The scheduler starts a Functions app that creates a batch job based on the file type, file size, and required decoding algorithm. The app selects a virtual machine with a suitable size from the pool and starts the job.

1. Batch writes the resulting decoded file back to the lakehouse when the job finishes. This file must be suitable for direct ingestion in a format that the Eventhouse supports.

1. The lakehouse triggers a function that ingests the data into the Eventhouse upon file write. This function creates the table and data mapping if necessary and starts the ingestion process.

1. The KQL database ingests the data files from the lakehouse.

This approach provides the following benefits:

- Functions and Batch pools can handle scalable data processing tasks robustly and efficiently.

- Batch pools provide insight into processing statistics, task queues, and batch pool health. You can visualize status, detect problems, and rerun failed tasks.

- The combination of Functions and Batch supports plug-and-play processing in Docker containers.

- You can use [spot virtual machines](/azure/batch/batch-spot-vms) to process files during off-peak times. This approach saves money.

## Scenario details

Automotive OEMs use large fleets of prototype and test vehicles to test and verify several vehicle functions. Test procedures are expensive because they require real drivers and vehicles, and specific real-world road testing scenarios must pass multiple times. Integration testing is especially important to evaluate interactions between electrical, electronic, and mechanical components in complex systems.

To validate vehicle functions and analyze anomalies and failures, you must capture petabytes of diagnostic data from electronic control units (ECUs), computer nodes, vehicle communication buses like Controller Area Network (CAN) and Ethernet, and sensors.

In the past, small data logger servers in the vehicles stored diagnostic data locally as Measurement Data Format (MDF), multimedia fusion extension (MFX), CSV, or JSON files. After test drives were complete, the servers uploaded diagnostic data to datacenters, which processed it and sent it to R&D engineers for analytics. This process could take hours or sometimes days. More recent scenarios use telemetry ingestion patterns like Message Queuing Telemetry Transport (MQTT)-based synchronous data streams or near real-time file uploads.

### Potential use cases

- Vehicle management evaluates the performance and collected data per vehicle across multiple test scenarios.

- System and component validation uses collected vehicle data to verify that the behavior of vehicle components falls within operational boundaries across trips.

- Anomaly detection locates deviation patterns of a sensor value relative to its typical baseline pattern in real time.

- Root cause analysis uses machine learning plugins such as clustering algorithms to identify changes in the distribution of values on multiple dimensions.

- Predictive maintenance combines multiple data sources, enriched location data, and vehicle signals to predict component time to failure.

- Sustainability evaluation uses driver behavior and energy consumption to evaluate the environmental impact of vehicle operations.

- Automotive racing to understand and improve the performance of the vehicles before, during, and after a race.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- [Azure availability zones](https://azure.microsoft.com/global-infrastructure/availability-zones) are unique physical locations within the same Azure region. Availability zones can protect Azure Data Explorer compute clusters and data from partial region failure.

- [Business continuity and disaster recovery (BCDR)](/azure/data-explorer/business-continuity-overview) in Azure Data Explorer lets your business continue operating in the face of disruption.

- [Follower databases](/azure/data-explorer/follower) separate compute resources between production and nonproduction use cases.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

It's important to understand the division of responsibility between the automotive OEM and Microsoft. In the vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform as a service (PaaS) provides built-in security on the physical stack, including the operating system.

- Use [Azure Policy](https://azure.microsoft.com/services/azure-policy) to apply security guardrails.

- Review the [governance overview and guidance](/fabric/governance/governance-compliance-overview) for Fabric.

- Use private endpoints to provide network security for all services.

  - Use [private endpoints for Azure Data Explorer](/azure/data-explorer/security-network-private-endpoint).
  
  - [Allow access to Event Hubs namespaces through private endpoints](/azure/event-hubs/private-link-service).
  
- Encrypt data at rest and data in transit.

- Use Microsoft Entra identities and [Microsoft Entra Conditional Access](/entra/identity/conditional-access/plan-conditional-access) policies.

- Use [row level security (RLS)](/azure/data-explorer/kusto/management/rowlevelsecuritypolicy) for KQL databases and Azure Data Explorer.

- Use the [restrict statement](/azure/data-explorer/kusto/query/restrict-statement) when you implement middleware applications with access to the KQL database. This configuration creates a logical model that restricts user access to the data.

All these features help automotive OEMs create a secure environment for their vehicle telemetry data. For more information, see [Security in Fabric](/fabric/security/security-overview).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This solution uses the following practices to help optimize costs:

- Correctly configure hot caches and cold storage for the raw and signals tables. The hot data cache is stored in RAM or SSD and provides improved performance. Cold data, however, is 45 times cheaper. Set a hot cache policy that's adequate for your use case, such as 30 days.

- Set up a retention policy on the raw table and signals table. Determine when the signal data is no longer relevant, such as after 365 days, and set the retention policy accordingly.

- Consider which signals are relevant for analysis.

- Use materialized views when you query the signals last-known values, signals deduped, and signals downsampled. Materialized views consume fewer resources than doing source table aggregations on each query.

- Consider your real-time data analytics needs. Set up streaming ingestion for the live telemetry table to provide latency of less than one second between ingestion and query. This approach increases CPU cycles and cost.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Consider using Batch to perform decoding if the number and size of recorded data files is more than 1,000 files or 300 MB per day.

- Consider performing common calculations and analysis after ingest and storing them in extra tables.

- Use [KQL query best practices](/azure/data-explorer/kusto/query/best-practices) to make your query run faster.

- Use a `where` clause to define a time window to reduce the amount of data that's queried. Consider changing the data partition policy for the signals table if your common search criteria aren't time-based, for instance if you filter by recording ID and signal name. When the KQL database expands to contain billions or trillions of records, proper data filtration becomes essential, especially considering the active [partition policy](/azure/data-explorer/kusto/management/partitioning-policy).

> [!WARNING]
> Consult with your support team before you alter a data partition policy.

## Deploy this scenario

Use the [step-by-step tutorial](https://github.com/microsoft/adx-automotive-demos/) to deploy this scenario. The guide shows how to deploy a free instance, parse MDF files, ingest data, and perform several basic queries.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Boris Scholl](https://www.linkedin.com/in/bscholl) | Partner, Chief Architect
- [Frank Kaleck](https://www.linkedin.com/in/frank-kaleck) | Industry Advisor Automotive
- [Henning Rauch](https://www.linkedin.com/in/henning-rauch-adx) | Principal Program Manager
- [Mario Ortegon-Cabrera](https://www.linkedin.com/in/marioortegon) | Principal Program Manager

Other contributors:

- [Devang Shah](https://www.linkedin.com/in/shahdevang) | Principal Program Manager
- [Hans-Peter Bareiner](https://www.linkedin.com/in/hans-peter-bareiner-69039163) | Cloud Solution Architect
- [Jason Bouska](https://www.linkedin.com/in/jasonbouska/) | Senior Software Engineer, Azure Patterns & Practices

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [MQTT broker feature in Event Grid](/azure/event-grid/mqtt-overview)
- [Add a KQL database destination to an eventstream](/fabric/real-time-intelligence/event-streams/add-destination-kql-database?pivots=enhanced-capabilities)
- [Get data from OneLake](/fabric/real-time-intelligence/get-data-onelake)
- [Materialized views](/azure/data-explorer/kusto/management/materialized-views/materialized-view-overview)
- [Create a real-time dashboard](/fabric/real-time-intelligence/dashboard-real-time-create)
- [Create Data Activator alerts from a real-time dashboard](/fabric/data-activator/data-activator-get-data-real-time-dashboard)
- [Power BI report](/fabric/real-time-intelligence/create-powerbi-report)
- [Visualize data from Azure Data Explorer in Grafana](/azure/data-explorer/grafana)
- [Automotive messaging, data, and analytics reference architecture](/industry/mobility/architecture/automotive-connected-fleets-content)

## Related resources

- [Software-defined vehicle DevOps toolchain](/industry/mobility/architecture/autonomous-vehicle-operations-dataops-content)
- [Reference architecture for autonomous vehicle operations (AVOps)](/industry/mobility/architecture/ra-mobility-avops)
- [Claim-Check pattern](../../patterns/claim-check.yml)
