The focus of this article is to showcase a practical architecture that uses Azure Cloud Services to process large volumes of geospatial data. It provides a path forward when on-premises solutions don't scale. It also allows for continued use of the current geospatial analysis tools.

*Apache®, Apache Spark®, GeoSpark®, and Sedona® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

*GeoPandas®, QGIS®, and ArcGIS® are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

:::image type="content" border="false" source="media/geospatial-analysis-telecommunications-industry.svg" alt-text="Diagram for an architecture that uses Azure Cloud Services to process large volumes of geospatial data." lightbox="media/geospatial-analysis-telecommunications-industry.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1925417-geospatial-analysis-telecommunications-industry.vsdx) of this architecture.*

### Workflow

1. Azure Data Factory ingests geospatial data into Azure Data Lake Storage. The source of this data is geospatial databases such as Teradata, Oracle Spatial, and PostgreSQL.
1. Azure Key Vault secures passwords, credentials, connection strings, and other secrets.
1. Data is placed in various folders and file systems in Data Lake Storage according to how it has been processed. The diagram shows a *multi-hop* architecture. The bronze container holds raw data, the silver container holds semi-curated data, and the gold container holds fully curated data.
1. Data is stored in formats such as [GeoJson](https://geojson.org), [WKT](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) and [Vector tiles](https://en.wikipedia.org/wiki/Vector_tiles). Azure Databricks and the GeoSpark / [Sedona](https://sedona.apache.org) package can convert formats and efficiently load, process, and analyze large-scale spatial data across machines.
1. Azure Databricks and Apache Sedona do various kinds of processing at scale:
   1. Joins, intersections, and tessellations
   1. Spatial sampling and statistics
   1. Spatial indexing and partitioning
1. [GeoPandas](https://geopandas.org/en/stable) exports data in various formats for use by third-party GIS applications such as QGIS and ARCGIS.
1. Azure Machine Learning extracts insights from geospatial data, determining, for example, where and when to deploy new wireless access points.
1. Power BI and Azure Maps Power BI visual (Preview) render a map canvas to visualize geospatial data. Power BI uses an Azure Databricks native connector to connect to an Azure Databricks cluster.
1. Log Analytics, a tool in the Azure portal, runs queries against data in Azure Monitor Logs to implement a robust and fine-grained logging system to analyze events and performance.

### Components

- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) is a scalable and secure data lake for high-performance analytics workloads. You can use Data Lake Storage to manage petabytes of data with high throughput. It can accommodate multiple, heterogeneous sources, and data that's in structured, semi-structured, or unstructured formats.
- [Azure Databricks](https://azure.microsoft.com/services/databricks) is a data analytics platform that uses Spark clusters. The clusters are optimized for the Azure Cloud Services platform.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a fully managed, scalable, and serverless data integration service. It provides a data integration and transformation layer that works with various data stores.
- [Microsoft Power BI](https://powerbi.microsoft.com) is a collection of software services, apps, and connectors that work together to turn multiple sources of data into coherent, visually immersive, and interactive insights.
- [Azure Maps](https://azure.microsoft.com/services/azure-maps) is a collection of geospatial services and SDKs that use fresh mapping data to provide geographic context to web and mobile applications.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a fully managed cloud service that's used to train, deploy, and manage machine learning models at scale.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) is a service that can be used to securely store, manage, and tightly control access to tokens, credentials, certificates, API Keys, and other secrets.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) is a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. You can use it to maximize the availability and performance of your applications and services.

### Alternatives

- You can use [Synapse Spark Pools](/azure/synapse-analytics/spark/apache-spark-overview) for geospatial analytics instead of Azure Databricks, using the same open-source frameworks.
- Instead of using Data Factory to ingest data, you can use [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs). It can receive massive amounts of data directly or from other event streaming services such as Kafka. Then you can use Azure Databricks to process the data. For more information, see [Stream Processing with Azure Databricks](../../reference-architectures/data/stream-processing-databricks.yml).
- Instead of Azure Databricks, you can use [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) or [Azure SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance) to query and process geospatial data. These databases provide the familiar T-SQL language, which you can use for geospatial analysis. For more information, see [Spatial Data (SQL Server)](/sql/relational-databases/spatial/spatial-data-sql-server?view=sql-server-ver15).
- Like Event Hubs, [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) can ingest large amounts of data from sensor and telecom IoT devices. You can use the IoT Hub bi-directional capability to communicate securely with devices and potentially manage and control them from a centralized platform in the cloud.
- You can use [Azure Maps](/azure/azure-maps/about-azure-maps) to provide geographic context to your web and mobile applications. In addition to location intelligence, Azure Maps can search services to locate addresses, places, and points of interest to get real-time traffic information. [Azure Maps Power BI Visual](/azure/azure-maps/power-bi-visual-get-started) provides the same capabilities in both [Power BI Desktop](/power-bi/fundamentals/desktop-what-is-desktop) and the [Power BI service](/power-bi/fundamentals/power-bi-service-overview).

## Scenario details

Location intelligence and geospatial analytics can uncover important regional trends and behaviors that affect telecommunications companies. The companies can use such knowledge to enhance their radio signal and wireless coverage, and thus gain competitive advantage.

Telecommunications companies have large volumes of geographically dispersed asset data, most of which is user telemetry. The data comes from radio networks, IoT sensing devices, and remote sensing devices that capture geospatial data. It's in various structured and semi-structured formats such as imagery, GPS, satellite, and textural. Making use of it requires aggregating it and joining it with other sources such as regional maps and traffic data.

After the data is aggregated and joined, the challenge is to extract insights from it. Historically, telecommunications companies relied on legacy systems such as on-premises databases with geospatial capabilities. Eventually such systems hit scalability limits due to the ever-increasing amount of data. Also, they require third-party software to perform tasks that the geospatial database systems can't.

### Potential use cases

This solution is ideal for the telecommunications industry, and it applies to the following scenarios:

- Analyzing signal information across locations to assess network quality
- Analyzing real-time network infrastructure data to guide maintenance and repair
- Analyzing market segmentation and market demand
- Identifying relationships between customer locations and company marketing campaigns
- Creating capacity and coverage plans to ensure connectivity and quality of service

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Consider following the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/index) when you implement this solution. The framework provides technical guidance across five pillars: cost optimization, security, reliability, performance efficiency, and operational excellence.

### Performance

- Follow [Apache Sedona programming guides](https://sedona.apache.org/1.3.1-incubating/tutorial/sql/) on design patterns and performance tuning best practices.
- Geospatial indexing is crucial for processing large-scale geospatial data. Apache Sedona and other open-source indexing frameworks such as [H3](https://h3geo.org/docs/core-library/overview) provide this capability.
- The GeoPandas framework doesn't have the distributed features of GeoSpark / Apache Sedona. Therefore, as much as possible, use Sedona framework for geospatial processing.
- Consider using Sedona’s built-in functions to validate geometry formatting before processing.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For better security, consider following this guidance:

- [Create an Azure Key Vault-backed secret scope](/azure/databricks/security/secrets/secret-scopes#--create-an-azure-key-vault-backed-secret-scope)
- [Secure cluster connectivity (No Public IP / NPIP)](/azure/databricks/security/secure-cluster-connectivity)
- [Store credentials in Azure Key Vault](/azure/data-factory/store-credentials-in-key-vault)
- [Deploy dedicated Azure services into virtual networks](/azure/virtual-network/virtual-network-for-azure-services)
- [Consider using Azure Databricks Premium tier instead of Standard for more security features](https://azure.microsoft.com/pricing/details/databricks)
- [Databricks security guide](/azure/databricks/security)

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- To estimate the cost of implementing this solution, use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) for the services mentioned above.
- Power BI comes with various licensing offerings. For more information, see [Power BI pricing](https://powerbi.microsoft.com/pricing).
- Your costs increase if you have to scale your Azure Databricks cluster configurations. This depends on the amount of data and the complexity of the analysis. For best practices on cluster configuration, see Azure Databricks [Best practices: Cluster configuration](/azure/databricks/clusters/cluster-config-best-practices).
- See [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview) for ways to minimize costs.
- For the third-party components such as QGIS and ARCGIS, see the vendor websites for pricing information.
- The frameworks mentioned in this solution, such as Apache Sedona and GeoPandas, are free open-source frameworks.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Arash Mosharraf](https://www.linkedin.com/in/arashaga) | Senior Cloud Solution Architect

## Next steps

- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [What is Azure Maps?](/azure/azure-maps/about-azure-maps)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [About Azure Key Vault](/azure/key-vault/general/overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Azure Maps samples](https://samples.azuremaps.com)
- [Azure Data Factory tutorials](/azure/data-factory/data-factory-tutorials)
- [Apache Sedona programming guides](https://sedona.apache.org/1.3.1-incubating/tutorial/sql/)
- [Getting Started](https://geopandas.org/en/stable/getting_started.html) with GeoPandas
- [Getting started](https://www.geomesa.org/documentation/stable/user/getting_started) with GeoMesa
- [Processing Geospatial Data at Scale With Databricks](https://www.databricks.com/blog/2019/12/05/processing-geospatial-data-at-scale-with-databricks.html)
- [GIS file formats](https://en.wikipedia.org/wiki/GIS_file_formats)
- [Apache Sedona reference](https://sedona.apache.org/)
- [Overview of the H3 Geospatial Indexing System](https://h3geo.org/docs/core-library/overview)
- [Power BI and Esri ArcGIS](https://powerbi.microsoft.com/power-bi-esri-arcgis)
- [QGIS](https://www.qgis.org/en/site)
- [H3: A Hexagonal Hierarchical Geospatial Indexing System](https://github.com/uber/h3)
- [How To Turn Visitor Cellphone Roaming Data Into Revenue?](https://customers.microsoft.com/story/nos-spgs-media-telco-azure-sql-r-server-portugal)
- [5G positioning: What you need to know](https://www.ericsson.com/en/blog/2020/12/5g-positioning--what-you-need-to-know)

## Related resources

- [Geospatial data processing and analytics](geospatial-data-processing-analytics-azure.yml)
- [Solutions for the telecommunications industry](../../industries/telecommunications.md)
