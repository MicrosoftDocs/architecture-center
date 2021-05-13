# GIS Data Processing and Serving
Many possibilities exist for working with *geospatial data*, or information that includes a geographic component. For instance, geographic information system (GIS) software and standards are widely available. These technologies can store, process, and provide access to geospatial data. But it's often hard to configure and maintain such systems. And you need expert knowledge to integrate those systems with other systems.

This solution outlines a manageable way to make geospatial data available for analytics. It meets these goals:

- Collect large volumes of data on data assets with known locations.
- Combine the asset data with real-world reference data.
- Make the processed data available for spatial analytics in web apps.
- Use fully managed services with built-in features for maintenance, security, and scaling.

The solution, which is based on [Advanced Analytics Reference Architecture][Advanced analytics architecture], uses these Azure services:

- Databricks with GIS Spark libraries processes data.
- Azure PostgreSQL queries data through APIs.
- Azure Data Explorer handles very fast exploratory queries.
- Azure Maps visualizes geospatial data in web applications.
- The [Azure Maps Power BI visual][Getting started with the Azure Maps Power BI visual] feature of PowerBI provides customized reports.

## Potential use cases

This solution has applications in many areas:

- Processing, storing, and providing access to large amounts of raster data, such as maps or climate data.
- *Localizing* enterprise resource planning (ERP) system entities, or identifying their geographic position.
- Combining entity location data with GIS reference data.
- Storing Internet of Things (IoT) telemetry from moving devices.
- Running analytical geospatial queries.
- Embedding curated and contextualized geospatial data in web apps.

## Architecture

:::image type="complex" source="./media/geospatial-analytics-azure-architecture.png" alt-text="Architecture diagram showing how geospatial data flows through an Azure system. Various components receive, process, store, analyze, and publish the data." border="false":::
   The diagram contains several gray boxes, each with a different label. From left to right, the labels are Ingest, Prepare, Load, Serve, Visualize and explore. A final box underneath the others has the label Monitor and secure.
:::image-end:::


1. IoT data enters the system:
   - Event Hubs ingests streams of IoT data. The data contains coordinates or other information that identifies locations of devices.
   - Event Hubs uses Databricks for initial stream processing.
   - Event Hubs stores the data in Azure Data Lake Storage.

1. Databricks uses geospatial libraries to transform and standardize the data.

1. Geographic information system (GIS) data enters the system:

   - Azure Data Factory ingests raster GIS data and vector GIS data of any format.
   - Azure Data Factory stores the data in Azure Data Lake Storage.

1. Data Factory loads the prepared vector and raster data into Azure Database for PostgreSQL. The solution uses the PostGIS extension with this database.

1. Data Factory loads the prepared vector and raster data into Azure Data Explorer.

1. Azure Database for PostgreSQL stores the GIS data. APIs make this data available in standardized formats:

   - [GeoJSON][GeoJSON format] is based on JavaScript Object Notation (JSON). GeoJSON represents simple geographical features and their non-spatial properties.
   - [Well-known text (WKT)][Well Known Text Module] is a text markup language that represents vector geometry objects.
   - [Vector tiles][Vector tiles] are packets of geographic data. Their lightweight format improves mapping performance.

   A Redis cache improves performance by providing quick access to the data.

1. The Web Apps feature of Azure App Service works with Azure Maps to visualize the data.

1. Azure Data Explorer analyzes the large volumes of data. GIS features of this tool create insightful ad-hoc visualizations. Examples include creating scatterplots from geospatial data.

1. Power BI provides customized reports and business intelligence (BI). The Azure Maps visual for Power BI highlights the role of location data in business results.

Throughout the process:

- Azure Monitor collects information on events and performance.
- Log Analytics runs queries on Monitor logs and analyzes the results.
- Key Vault keeps secrets, passwords, and connection strings secure.

## Components

- [Event Hubs][Azure Event Hubs — A big data streaming platform and event ingestion service] is a big data streaming platform. As a Platform-as-a-Service (PaaS), this event ingestion service is fully managed. Through its partitioned consumer model, multiple applications can process the stream at the same time.

- [Data Factory][What is Azure Data Factory?] is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate data transformation workflows.

- [Azure Databricks][Azure Databricks Workspace concepts] is a data analytics platform. Its fully managed Spark clusters process large streams of data from multiple sources. Azure Databricks can transform geospatial data at large scale for use in analytics and data visualization.

- [Data Lake Storage][Introduction to Azure Data Lake Storage Gen2] is a scalable and secure data lake for high-performance analytics workloads. This service can manage multiple petabytes of information while sustaining hundreds of gigabits of throughput. The data typically comes from multiple, heterogeneous sources and may be structured, semi-structured, or unstructured.

- [Azure Database for PostgreSQL][What is Azure Database for PostgreSQL?] is a fully managed relational database service that's based on the community edition of the open-source [PostgreSQL][PostgreSQL] database engine.

- [PostGIS][PostGIS] is an extension for the PostgreSQL database that integrates with GIS servers. PostGIS can run SQL location queries that involve geographic objects.

- [Redis][Redis] is an open-source, in-memory data store. Redis caches keep frequently accessed data in server memory. The caches can then quickly process large volumes of application requests that involve the data.

- [Power BI][What is Power BI?] is a collection of software services and apps. You can use Power BI to connect and visualize unrelated sources of data.

- The [Azure Maps visual for Power BI][Getting started with the Azure Maps Power BI visual] provides a way to enhance maps with spatial data. You can use the visual to show how location data affects business metrics.

- [App Service][App Service documentation] and its [Web Apps][App Service overview] feature provide a framework for building, deploying, and scaling web apps. The App Service platform offers built-in infrastructure maintenance, security patching, and scaling.

- [GIS data APIs in Azure Maps][Create a data source for Azure Maps] store and retrieve map data in formats like GeoJSON and vector tiles.

- [Azure Data Explorer][What is Azure Data Explorer?] is a fast, fully managed data analytics service that can work with [large volumes of data][Azure Data Explorer performance update (EngineV3)]. Although this service originally focused on time series and log analytics, it now handles diverse data streams from applications, websites, IoT devices, and other sources. [Geospatial functionality][Azure Data Explorer extends geospatial functionality] in Azure Data Explorer provides options for rendering map data.

- [Azure Monitor][Azure Monitor overview] collects data on environments and Azure resources. This diagnostic information is helpful for maintaining availability and performance. Two data platforms make up Monitor:

  - [Azure Monitor Logs][Azure Monitor Logs overview] records and stores log and performance data.
  - [Azure Monitor Metrics][Azure Monitor Metrics overview] collects numerical values at regular intervals.

- [Log Analytics][Overview of Log Analytics in Azure Monitor] is an Azure portal tool. You can use this tool to write, test, and run queries on Monitor log data. Log Analytics also provides features for charting and statistically analyzing query results.

- [Azure Key Vault][About Azure Key Vault] stores and controls access to secrets such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates.

## Alternatives

- Instead of developing your own APIs, consider using [Martin][Urbica Martin]. This open-source tile server makes vector tiles available to web apps. Written in [Rust][Rust], Martin connects to PostgreSQL tables. You can deploy it as a container.

- If your goal is to provide a standardized interface for GIS data, consider using [GeoServer][GeoServer]. This open framework implements industry-standard [Open Geospatial Consortium (OGC)][Open Geospatial Consortium] protocols such as [Web Feature Service (WFS)][Web Feature Service]. It also integrates with common spatial data sources. You can deploy GeoServer as a container on a virtual machine. When custom web applications and exploratory queries are secondary, GeoServer provides a straightforward way to publish geospatial data.

- A variety of Spark libraries are available for working with geospatial data on Azure Databricks. This solution uses these libraries:

  - [Apache Sedona (GeoSpark)][Apache Sedona (incubating)]
  - [GeoPandas][GeoPandas 0.8.0 — GeoPandas 0.8.0 documentation]

  But [other solutions also exist for processing and scaling geospatial workloads with Databricks][Processing Geospatial Data at Scale With Databricks].

- Like Event Hubs, [Azure IoT Hub][What is Azure IoT Hub?] can ingest large amounts of data. But IoT Hub also offers bi-directional communication capabilities with devices. If you receive data directly from devices but also send commands and policies back to devices, consider IoT Hub instead of Event Hubs.

- To streamline the solution, omit these components:

  - Azure Data Explorer
  - Power BI

## Considerations

The following considerations, based on the [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework], apply to this solution:

### Availability considerations

- [Event Hubs spreads failure risk across clusters][Azure Event Hubs - Geo-disaster recovery].

  - Use a namespace with availability zones turned on to spread that risk across three physically separated facilities.
  - Use the Geo-Disaster recovery feature of Event Hubs to replicate the entire configuration of a namespace from a primary to a secondary namespace.

- See [business continuity features that Azure Database for PostgreSQL provides][Overview of business continuity with Azure Database for PostgreSQL - Single Server] that cover a range of recovery objectives.

- [App Service diagnostics][Azure App Service diagnostics overview] alerts you to problems in apps, such as downtime. Use this service to identify, troubleshoot, and resolve issues like outages.

- Consider using [App Service to back up application files][Basic web app availability considerations]. But be careful with backed-up files, which include app settings in plain text. Those settings may include secrets like connection strings.

### Scalability considerations

This solution was designed in an environment that met these conditions:

- Processed up to 10 million data sets per day. The data sets included batch or streaming events.
- Stored 100 million data sets in an Azure Database for PostgreSQL database.
- Queried 1 million or fewer data sets at the same time. A maximum of 30 users ran the queries.

The design environment used this configuration:

- An Azure Databricks cluster with four F8s_V2 worker nodes.
- A memory-optimized instance of Azure Database for PostgreSQL.
- An App Service plan with two Standard S2 instances.

Consider these factors to determine which adjustments to make for your implementation:

- Your data ingestion rate.
- Your volume of data.
- Your query volume.
- The number of parallel queries you need to support.

You can scale Azure components independently:

- Event Hubs automatically scales up to meet usage needs. But take steps to [manage throughput units][Throughput units] and [optimize partitions][Scaling with Event Hubs partitions].

- Data Factory handles large amounts of data. Its [serverless architecture supports parallelism at different levels][Copy performance and scalability achievable using ADF].

- [Data Lake Storage is scalable by design][Introduction to Azure Data Lake Storage Gen2 scalability].

- Azure Database for PostgreSQL offers [high-performance horizontal scaling][Quickstart: create a Hyperscale (Citus) server group in the Azure portal].

- [Azure Databricks clusters resize as needed][Introducing Databricks Optimized Autoscaling on Apache Spark].

- [Azure Data Explorer can elastically scale to terabytes of data in minutes][Azure Data Explorer].

- [App Service web apps scale up and out][Basic web application scalability considerations].

The [autoscale feature of Monitor][Overview of autoscale in Microsoft Azure] also provides scaling functionality. You can configure this feature to add resources to handle increases in load. It can also remove resources to save money.

### Security considerations

- Protect vector tile data. Vector tiles embed coordinates and attributes for multiple entities in one file. If you generate vector tiles, use a dedicated set of tiles for each permission level in your access control system. Then only users within each permission level have access to that level's data file.

- To improve security, use Key Vault with as many components as possible:

  - [Use Key Vault to manage keys that Event Hubs uses to encrypt data][Configure customer-managed keys for encrypting Azure Event Hubs data at rest by using the Azure portal].
  - [Store credentials that Data Factory uses during pipeline execution in Key Vault][Use Azure Key Vault secrets in pipeline activities].
  - [Store secrets and application settings that your App Service web app uses in Key Vault][Use Key Vault references for App Service and Azure Functions].

- See [Security in Azure App Service][Security in Azure App Service] for information on how App Service helps secure web apps. Consider these points, too:

  - See how to [get the certificate that you need if your app uses a custom domain name][Azure App Service SSL certificates available for purchase].
  - See how to [enforce HTTPS][Add a TLS/SSL certificate in Azure App Service].
  - Learn about [best practices for authentication in web apps][Basic web application authentication].

### Performance considerations

[Vector tiles][Mapbox Vector Tile specification] provide an efficient way to visualize GIS data on maps. This solution uses PostGIS to dynamically query vector tiles. This approach works well for simple queries and result sets that contain well under 1 million records. But in the following cases, a different approach may be better:

- Your queries are computationally expensive.
- Your data doesn't change frequently.
- You need to visualize large data sets.

In these situations, consider using [Tippecanoe][GitHub - mapbox/tippecanoe] to generate vector tiles. You can run Tippecanoe as part of your data processing flow, either as a container or with [Azure Functions][Introduction to Azure Functions]. You can make the resulting tiles available through APIs.

## Pricing

- To estimate the cost of implementing this solution, see a [cost profile][Pricing: Azure Architecture for GIS data processing and serving] for a single implementation of the environment described in [Scalability considerations][Scalability considerations]. Note that this profile doesn't include the cost of Azure Data Explorer. 
- To adjust the parameters and explore the cost of running this solution in your environment, use the [Azure pricing calculator][Pricing calculator].

## Next steps

To start implementing this solution, see this information:

### Related architectures

- [Big data analytics with Azure Data Explorer][Big data analytics with Azure Data Explorer]
- [Health data consortium on Azure][Health data consortium on Azure]
- [DataOps for the modern data warehouse][DataOps for the modern data warehouse]
- [Azure Data Explorer interactive analytics][Azure Data Explorer interactive analytics]

### Related guides

- [Compare the machine learning products and technologies from Microsoft - Azure Databricks][Compare the machine learning products and technologies from Microsoft - Azure Databricks]
- [Machine learning operations (MLOps) framework to upscale machine learning Lifecycle with Azure Machine Learning][Machine learning operations (MLOps) framework to upscale machine learning Lifecycle with Azure Machine Learning]
- [Azure Machine Learning decision guide for optimal tool selection][Azure Machine Learning decision guide for optimal tool selection]
- [Monitoring Azure Databricks][Monitoring Azure Databricks]

### Information on processing geospatial data

- [Functions for querying PostGIS for vector tiles][ST_AsMVT (postgis.net)].
- [Functions for loading PostGIS rasters][Chapter 4. PostGIS Usage].
- [Azure Data Explorer geospatial functions][Azure Data Explorer geo_distance_2points() function].
- [Data sources for vector tiles in Azure Maps][Create a data source for a map in Microsoft Azure Maps].
- [Approaches for processing geospatial data in Databricks][Processing Geospatial Data at Scale With Databricks].

## Related resources

- Connect a Web Map Service to Azure Maps: [Connect to a Web Feature Service (WFS) service | Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-maps/spatial-io-connect-wfs-service)
- Process open street maps data with Spark: [Frameworks - OpenStreetMap Wiki](https://wiki.openstreetmap.org/wiki/Frameworks)
- Inspirations for visualizing data with Azure maps: [Azure Maps Web SDK Samples (azuremapscodesamples.azurewebsites.net)](https://azuremapscodesamples.azurewebsites.net/)

[About Azure Key Vault]: /azure/key-vault/general/overview
[Add a TLS/SSL certificate in Azure App Service]: /azure/app-service/configure-ssl-certificate
[Advanced analytics architecture]: /azure/architecture/solution-ideas/articles/advanced-analytics-on-big-data
[Apache Sedona (incubating)]: http://sedona.apache.org/
[App Service documentation]: /azure/app-service/
[App Service overview]: /azure/app-service/overview
[Azure App Service diagnostics overview]: /azure/app-service/overview-diagnostics
[Azure App Service SSL certificates available for purchase]: https://azure.microsoft.com/updates/azure-app-service-ssl-certificates-available-for-purchase/
[Azure Data Explorer]: https://azure.microsoft.com/services/data-explorer/
[Azure Data Explorer extends geospatial functionality]: https://azure.microsoft.com/updates/adx-geo-updates/
[Azure Data Explorer geo_distance_2points() function]: /azure/data-explorer/kusto/query/geo-distance-2points-function
[Azure Data Explorer interactive analytics]: /azure/architecture/solution-ideas/articles/interactive-azure-data-explorer
[Azure Data Explorer performance update (EngineV3)]: https://docs.microsoft.com/azure/data-explorer/engine-v3
[Azure Databricks Workspace concepts]: /azure/databricks/getting-started/concepts
[Azure Event Hubs — A big data streaming platform and event ingestion service]: /azure/event-hubs/event-hubs-about
[Azure Event Hubs - Geo-disaster recovery]: /azure/event-hubs/event-hubs-geo-dr
[Azure Machine Learning decision guide for optimal tool selection]: /azure/architecture/example-scenario/mlops/aml-decision-tree
[Azure Monitor Logs overview]: /azure/azure-monitor/logs/data-platform-logs
[Azure Monitor Metrics overview]: /azure/azure-monitor/essentials/data-platform-metrics
[Azure Monitor overview]: /azure/azure-monitor/overview
[Basic web app availability considerations]: /azure/architecture/reference-architectures/app-service-web-app/basic-web-app#availability-considerations
[Basic web application scalability considerations]: /azure/architecture/reference-architectures/app-service-web-app/basic-web-app?tabs=cli#scalability-considerations
[Basic web application authentication]: /azure/architecture/reference-architectures/app-service-web-app/basic-web-app?tabs=cli#authentication
[Big data analytics with Azure Data Explorer]: /azure/architecture/solution-ideas/articles/big-data-azure-data-explorer
[Chapter 4. PostGIS Usage]: https://postgis.net/docs/postgis_usage.html#RT_Loading_Rasters
[Compare the machine learning products and technologies from Microsoft - Azure Databricks]: /azure/architecture/data-guide/technology-choices/data-science-and-machine-learning#azure-databricks
[Configure customer-managed keys for encrypting Azure Event Hubs data at rest by using the Azure portal]: https://docs.microsoft.com/azure/event-hubs/configure-customer-managed-key
[Copy performance and scalability achievable using ADF]: /azure/data-factory/copy-activity-performance#copy-performance-and-scalability-achievable-using-adf
[Create a data source for Azure Maps]: /azure/azure-maps/create-data-source-web-sdk#geojson-data-source
[Create a data source for a map in Microsoft Azure Maps]: /azure/azure-maps/create-data-source-web-sdk#vector-tile-source
[DataOps for the modern data warehouse]: /azure/architecture/example-scenario/data-warehouse/dataops-mdw
[GeoJSON format]: https://tools.ietf.org/html/rfc7946
[GeoPandas 0.8.0 — GeoPandas 0.8.0 documentation]: https://geopandas.org/
[GeoServer]: https://en.wikipedia.org/wiki/GeoServer
[Getting started with the Azure Maps Power BI visual]: /azure/azure-maps/power-bi-visual-getting-started
[GitHub - mapbox/tippecanoe]: https://github.com/mapbox/tippecanoe
[Health data consortium on Azure]: /azure/architecture/example-scenario/data/azure-health-data-consortium
[Introducing Databricks Optimized Autoscaling on Apache Spark]: https://databricks.com/blog/2018/05/02/introducing-databricks-optimized-auto-scaling.html
[Introduction to Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-introduction
[Introduction to Azure Data Lake Storage Gen2 scalability]: /azure/storage/blobs/data-lake-storage-introduction#scalability
[Introduction to Azure Functions]: /azure/azure-functions/functions-overview
[Machine learning operations (MLOps) framework to upscale machine learning Lifecycle with Azure Machine Learning]: /azure/architecture/example-scenario/mlops/mlops-technical-paper
[Mapbox Vector Tile specification]: https://github.com/mapbox/vector-tile-spec
[Microsoft Azure Well-Architected Framework]: /azure/architecture/framework/
[Monitoring Azure Databricks]: /azure/architecture/databricks-monitoring/
[Open Geospatial Consortium]: https://www.osgeo.org/partners/ogc/
[Overview of autoscale in Microsoft Azure]: /azure/azure-monitor/autoscale/autoscale-overview
[Overview of business continuity with Azure Database for PostgreSQL - Single Server]: /azure/postgresql/concepts-business-continuity
[Overview of Log Analytics in Azure Monitor]: /azure/azure-monitor/logs/log-analytics-overview
[PostGIS]: https://www.postgis.net/
[PostgreSQL]: https://www.postgresql.org/
[Pricing: Azure Architecture for GIS data processing and serving]: https://azure.com/e/dcb9fc8b3dba4785aa93eb1e9871528f
[Pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Processing Geospatial Data at Scale With Databricks]: https://databricks.com/blog/2019/12/05/processing-geospatial-data-at-scale-with-databricks.html
[Quickstart: create a Hyperscale (Citus) server group in the Azure portal]: /azure/postgresql/quickstart-create-hyperscale-portal
[Redis]: https://redis.io/
[Rust]: https://www.rust-lang.org/
[Scalability considerations]: #scalability-considerations
[Scaling with Event Hubs partitions]: /azure/event-hubs/event-hubs-scalability#partitions
[Security in Azure App Service]: /azure/app-service/overview-security
[ST_AsMVT (postgis.net)]: https://postgis.net/docs/ST_AsMVT.html
[Throughput units]: /azure/event-hubs/event-hubs-scalability#throughput-units
[Urbica Martin]: https://github.com/urbica/node-martin
[Use Azure Key Vault secrets in pipeline activities]: /azure/data-factory/how-to-use-azure-key-vault-secrets-pipeline-activities
[Use Key Vault references for App Service and Azure Functions]: /azure/app-service/app-service-key-vault-references
[Vector tiles]: https://wikipedia.org/wiki/Vector_tiles
[Web Feature Service]: https://en.wikipedia.org/wiki/Web_Feature_Service
[Well Known Text Module]: /bingmaps/v8-web-control/modules/well-known-text-module
[What is Azure Data Explorer?]: /azure/data-explorer/data-explorer-overview
[What is Azure Data Factory?]: /azure/data-factory/introduction
[What is Azure Database for PostgreSQL?]: /azure/postgresql/overview
[What is Azure IoT Hub?]: /azure/iot-hub/about-iot-hub
[What is Power BI?]: /power-bi/fundamentals/power-bi-overview
