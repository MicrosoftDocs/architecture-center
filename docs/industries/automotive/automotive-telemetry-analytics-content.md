Automotive OEMs need solutions to minimize the time between doing test drives and getting test drive diagnostic data to R&D engineers. As vehicles become more automated, software lifecycles are shorter, and digital feedback loops must become faster. New technology can democratize data access and provide R&D engineers with near real-time insights into test drive diagnostic data. Secure data sharing can enhance collaboration between OEMs and suppliers, further shortening development cycles.

This example workload relates to both telemetry and batch test drive data ingestion scenarios. The workload focuses on the data platform that processes diagnostic data, and the connectors for visualization and reporting.

## Architecture

:::image type="content" source="images/analytics-dataflow.png" alt-text="Diagram that shows the analytics dataflow for automotive streaming data and files." border="false" lightbox="images/analytics-dataflow.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/NextGenerationTelemetryAnalyticsforAutomotive.pptx) with all the diagrams in this article.*

### Dataflow

1. Azure IoT Hub ingests live, raw telemetry data (**A**) and uploads recorded data files (**B**) from the vehicle.

1. IoT Hub sends the live telemetry (**A**) to an Azure Functions app that decodes the telemetry to JavaScript Object Notation (JSON) and posts it to Azure Event Hubs.

   IoT Hub sends the recorded data files (**B**) to Azure Blob Storage. A completed file upload triggers a Functions app that decodes the data and writes the decoded file into Blob Storage in a comma-separated values (CSV) format suitable for ingestion.

1. Azure Data Explorer ingests decoded JSON telemetry data from Event Hubs (**A**) into a raw telemetry table, and ingests the decoded CSV files (**B**) from Blob Storage.

1. Azure Data Explorer uses the `Update` function to expand the JSON data into a suitable row format and to enrich the data. For example, the function clusters location data to support geospatial analytics.

1. Data scientists and R&D engineers use Kusto Query Language (KQL) capabilities to build analytics use cases that they store as user-defined functions. KQL functions include aggregation, time series analysis, geospatial clustering, windowing, and machine learning (ML) plugins.

1. Power BI uses Dynamic Query to create visualizations with the user-defined queries. The Grafana data source plugin for Azure Data Explorer uses the user-defined queries for near real-time updates.

1. An Azure App Service app uses Azure Maps data source rendering capabilities to visualize user-defined query results that use GeoJSON format.

1. Azure API Management provides access to stored raw data files from vehicles, and a configuration API that manages third-party data collection policies.

### Azure Data Explorer schema

:::image type="content" source="images/data-explorer-schema.png" alt-text="Diagram that shows the Azure Data Explorer functions and methods for extracting, expanding, and enriching data." border="false":::

1. The `Update()` function uses methods such as:

   - `mv-expand()` to expand complex values stored in JSON structures into rows with individual signals.
   - `geo_point_to_h3cell()` or `geo_point_to_geohash()` to convert latitude and longitude to geohashes for geospatial analytics.
   - `todouble()` and `tostring()` to cast extracted values from dynamic JSON objects into the appropriate data types.

1. The **Fleet Metadata Last Known Values** view joins other views as part of ingestion to provide context. The historical fleet metadata is useful if new use cases require reprocessing of the raw telemetry.

1. If necessary, a **Signals Deduped** materialized view uses `take_any()` to deduplicate signals.

1. The **Signals Last Known Values** materialized view uses `arg_max()` on the timestamp for real-time reporting.

1. The **Signals Downsampled** materialized view aggregates signals by using predefined bins such as *hourly* and *daily* to simplify reporting across the fleet.

1. Stored plugin functions like `DetectAnomaly()` find anomalies in data series. ML plugins like autocluster find common patterns of discrete attributes.

1. The `GetGeospatial()` function generates GeoJSON files that contain grouped signals by geohashes.

### Components

The following key technologies implement this workload:

- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer)
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs)
- [Azure Functions](https://azure.microsoft.com/services/functions)
- [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana)
- [Azure App Service](https://azure.microsoft.com/services/app-service)
- [Azure Maps](https://azure.microsoft.com/services/azure-maps)
- [Azure API Management](https://azure.microsoft.com/services/api-management)
- [Power BI](https://powerbi.microsoft.com)

### Alternatives

[Azure Batch](https://azure.microsoft.com/services/batch) is a good alternative for complex file decoding. This scenario involves large numbers of files over 300 megabytes that require different decoding algorithms based on file version or type.

:::image type="content" source="images/batch-workflow.png" alt-text="Diagram that shows an alternative Azure Batch method for decoding complex files." border="false":::

1. Uploading a recorded data file to Blob Storage triggers a Functions app to schedule decoding.
1. The Functions app creates a batch job, taking into consideration the file type, size, and required decoding algorithm. The app selects a suitable virtual machine (VM) from the pool and starts the job.
1. When the job completes, Batch writes the resulting decoded file back to Blob Storage. This file must be suitable for direct ingestion in a format that Azure Data Explorer supports.
1. Uploading a decoded signal file to Blob Storage triggers a function that ingests the data into Azure Data Explorer. This function creates the table and data mapping if necessary, and starts the ingestion process.
1. Azure Data Explorer directly ingests the data files from Blob Storage.

This approach offers the following benefits:

- Azure Functions and Batch pools are able to handle scalable data processing tasks robustly and efficiently.
- Batch pools provide insight into processing statistics, task queues, and batch pool health. You can visualize status, detect problems, and rerun failed tasks.
- The combination of Azure Functions and Azure Batch supports plug-and-play processing in Docker containers.

## Scenario details

Automotive OEMs use large fleets of prototype and test vehicles to test and verify all kinds of vehicle functions. Test procedures are expensive, because real drivers and vehicles need to be involved, and certain specific real-world road testing scenarios must pass multiple times. Integration testing is especially important to evaluate interactions between electrical, electronic, and mechanical components in complex systems.

To validate vehicle functions and analyze anomalies and failures, gigabytes of diagnostic data must be captured from electronic control unit (ECUs), computer nodes, vehicle communication buses like Controller Area Network (CAN) and Ethernet, and sensors. In the past, small data logger servers in the vehicles stored diagnostic data locally as master database (MDF), multimedia fusion extension (MFX), CSV, or JSON files. After test drives were complete, the servers uploaded diagnostic data to data centers, which processed it and provided it to R&D engineers for analytics. This process could take hours or sometimes days. More recent scenarios use telemetry ingestion patterns like Message Queuing Telemetry Transport (MQTT)-based synchronous data streams, or near real-time file uploads.

### Potential use cases

- Vehicle management evaluates the performance and collected data per vehicle across multiple test scenarios.
- System and component validation uses collected vehicle data to verify that the behavior of vehicle components falls within operational boundaries across trips.
- Anomaly detection locates deviation patterns of a sensor value relative to its typical baseline pattern in real time.
- Root cause analysis uses ML plugins such as clustering algorithms to identify changes in the distribution of values on multiple dimensions.
- Predictive maintenance combines multiple data sources, enriched location data, and telemetry to predict component time to failure.
- Sustainability evaluation uses driver behavior and energy consumption to evaluate the environmental impact of vehicle operations.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- [Azure availability zones](https://azure.microsoft.com/global-infrastructure/availability-zones) are unique physical locations within the same Azure region. Availability zones can protect Azure Data Explorer compute clusters and data from partial region failure.
- [Business continuity and disaster recovery (BCDR)](/azure/data-explorer/business-continuity-overview) in Azure Data Explorer lets your business continue operating in the face of disruption.
- Consider using a [follower database](/azure/data-explorer/follower) in Azure Data Explorer to separate compute resources between production and non-production use cases.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

It's important to understand the division of responsibility between the automotive OEM and Microsoft. In the vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform-as-a-service (PaaS) provides built-in security on the physical stack, including the operating system. You can apply the following capabilities on top of the infrastructure security components.

- Private endpoints for network security. For more information, see [Private endpoints for Azure Data Explorer](/azure/data-explorer/security-network-private-endpoint) and [Allow access to Azure Event Hubs namespaces via private endpoints](/azure/event-hubs/private-link-service).
- Encryption at rest and in transit.
- Identity and access management that uses Azure Active Directory (Azure AD) identities and [Azure AD Conditional Access](/azure/active-directory/conditional-access) policies.
- [Row Level Security (RLS)](/azure/data-explorer/kusto/management/rowlevelsecuritypolicy) for Azure Data Explorer.
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

- If the number and size of recorded data files is greater than 1,000 files or 300 MB a day, consider using Azure Batch for decoding.
- Consider performing common calculations and analysis after ingest and storing them in additional tables.

## Deploy this scenario

To deploy Azure Data Explorer and ingest MDF files, you can follow the [step-by-step](https://github.com/microsoft/adx-automotive-demos/tree/main/mdf42adx) tutorial demonstrating how to deploy a free instance, parse MDF files, ingest and perform some basic queries.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Frank Kaleck](https://www.linkedin.com/in/frank-kaleck) | Digital Architect Automotive
- [Mario Ortegon-Cabrera](https://www.linkedin.com/in/marioortegon) | Principal Program Manager
- [Henning Rauch](https://www.linkedin.com/in/henning-rauch-adx) | Principal Program Manager
- [Boris Scholl](https://www.linkedin.com/in/bscholl) | Partner, Chief Architect

Other contributors:

- [Hans-Peter Bareiner](https://www.linkedin.com/in/hans-peter-bareiner-69039163) | Cloud Solution Architect
- [Jason Bouska](https://www.linkedin.com/in/jasonbouska) | Sr. Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Ingest data from event hub into Azure Data Explorer](/azure/data-explorer/ingest-data-event-hub)
- [Upload files with IoT Hub](/azure/iot-hub/iot-hub-devguide-file-upload)
- [Materialized views](/azure/data-explorer/kusto/management/materialized-views/materialized-view-overview)
- [Visualize data from Azure Data Explorer in Grafana](/azure/data-explorer/grafana)
- [Visualize data from Azure Data Explorer in Power BI](/azure/data-explorer/visualize-power-bi)
- [Create a data source for a map in Microsoft Azure Maps](/azure/azure-maps/create-data-source-web-sdk)

## Related resources

- [Big data analytics with Azure Data Explorer](../../solution-ideas/articles/big-data-azure-data-explorer.yml)
- [Predictive insights with vehicle telematics](../../solution-ideas/articles/predictive-insights-with-vehicle-telematics.yml)
- [Automated guided vehicles fleet control](../../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)
- [Building blocks for autonomous-driving simulation environments](building-blocks-autonomous-driving-simulation-environments.yml)
- [Process real-time vehicle data using IoT](../../example-scenario/data/realtime-analytics-vehicle-iot.yml)
