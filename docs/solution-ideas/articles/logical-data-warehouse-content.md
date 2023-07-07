[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The logical data warehouse (LDW) pattern lays a lightweight virtualized relational layer on top of data that's stored in a data lake or database. This virtualization layer provides data warehouse access without requiring data movement. This solution can combine online transaction processing (OLTP) data with analytical data from data lakes for a low-complexity, low-latency way to serve business intelligence (BI) and analytics workloads.

*Apache Spark™ is a trademark of the Apache Software Foundation in the United States and/or other countries/regions. No endorsement by The Apache Software Foundation is implied by the use of this mark.*

## Architecture

:::image type="content" source="../media/logical-data-warehouse-architecture-dataflow.svg" alt-text="Diagram showing a flow of data from left to right as the steps describe." border="false" lightbox="../media/logical-data-warehouse-architecture-dataflow.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/ldw-images.pptx) of all the diagrams in this article.*

### Dataflow

1. Azure Data Factory integrates data from source systems into the enterprise data lake.
1. Device and sensor data also streams from edge devices into the cloud through Azure IoT Hub. Azure Stream Analytics processes the data and sends it to the enterprise data lake.
1. Azure Synapse serverless SQL pools define an LDW that has logical tables and views accessible through the Azure Synapse workspace [serverless SQL pool on-demand endpoint](/azure/synapse-analytics/sql/connect-overview#serverless-sql-pool).
1. Azure Synapse Link for Azure Cosmos DB queries real-time transactional data through the Azure Synapse serverless SQL pools. This data joins with cold batch and hot streaming data from the enterprise data lake to create logical views.
1. Reporting, BI, and other analytics applications access LDW data and views by using the Azure Synapse workspace serverless SQL endpoint.

   > [!NOTE]
   > The Azure Synapse workspace serverless SQL endpoint is accessible from any tool or service that supports Tabular Data Stream (TDS) connections to SQL Server.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics.
  - [Azure Synapse serverless SQL pools](/azure/synapse-analytics/sql/on-demand-workspace-overview) query data lakes by using T-SQL and serverless SQL on-demand endpoints.
  - [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link) queries Azure Cosmos DB OLTP data by using Azure Synapse serverless SQL pools.
- [Data Factory](https://azure.microsoft.com/products/data-factory) offers cloud-scale data integration and data flow orchestration.
- [IoT Hub](https://azure.microsoft.com/products/iot-hub) enables secure and reliable communication between internet of things (IoT) applications and devices.
- [Stream Analytics](https://azure.microsoft.com/products/stream-analytics) provides serverless, real-time streaming analytics pipelines.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) offers scalable, cost-effective cloud storage.
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is a fully managed NoSQL database for modern app development.

## Scenario details

By using an LDW with Azure Synapse serverless SQL pools, you can join cold batch data, hot streaming data, and live transactional data in a single T-SQL query or view definition.

This solution avoids moving data through complex, expensive, and latency-prone extract, transform, and load (ETL) pipelines. The LDW concept is similar to a [data lakehouse](/azure/databricks/lakehouse), but LDW with Azure Synapse Analytics includes support for [hybrid transaction/analytical processing (HTAP)](https://wikipedia.org/wiki/Hybrid_transactional/analytical_processing). HTAP uses Azure Synapse serverless SQL pools to query OLTP data that's stored in Azure Cosmos DB.

An Azure Synapse Analytics LDW is based on serverless SQL pools that are available with all Azure Synapse workspaces. An enhanced version of the [OPENROWSET](/azure/synapse-analytics/sql/develop-openrowset) function enables serverless SQL pools to access data in Data Lake Storage.

This data access allows creation of relational database objects like tables and views over collections of data files that represent logical entities, like products, customers, and sales transactions. BI tools that connect by using a standard SQL Server endpoint can consume these logical entities as dimensions and fact tables.

:::image type="complex" source="../media/logical-data-warehouse-architecture-concept.svg" alt-text="Diagram showing side by side comparison of the LDW conceptual design, next to an implementation of LDW with Azure Synapse serverless SQL pool." border="false" lightbox="../media/logical-data-warehouse-architecture-concept.svg":::
   Each diagram has three layers. The bottom layer shows files in cloud storage. The second layer is the logical database showing tables with arrows from the cloud storage files to the logical tables. The top layer is the logical tables being accessed by a dashboard for reporting and analytics. The implementation with Azure Synapse diagram shows the logical layer being implemented with a serverless SQL database. A SQL Server endpoint is shown above the logical layer tables. Power BI and SSMS access the SQL endpoint. The Azure Synapse components like SQL endpoint and serverless SQL database are inside a box with an Azure Synapse logo."
:::image-end:::

The ability to access transactional data stores like Azure Cosmos DB through the Azure Synapse Link for Azure Cosmos DB expands these capabilities. Accessing OLTP data by using HTAP architecture provides instant updates without interfering with live transactions.

:::image type="content" source="../media/logical-data-warehouse-architecture-data.svg" alt-text="Diagram that shows the flow of external data to the reporting layer using Azure Synapse serverless SQL pool." border="false" lightbox="../media/logical-data-warehouse-architecture-data.svg":::

Each Azure Synapse workspace includes an on-demand SQL endpoint. The endpoint lets SQL Server administrators and developers use familiar environments to work with LDWs that Azure Synapse serverless SQL pools define.

The following screenshot shows SQL Server Management Studio (SSMS) connected to an Azure Synapse serverless SQL pool.

:::image type="content" source="../media/logical-data-warehouse-ssms-connect.png" alt-text="Screenshot that shows SSMS connected to the Azure Synapse SQL Server endpoint." border="false" lightbox="../media/logical-data-warehouse-ssms-connect.png":::

Azure Synapse serverless SQL pools support the following file formats:

- Delimited text, such as CSV, TSV, and TXT
- JSON
- Parquet

Azure Synapse serverless SQL pools also support the [Delta Lake](/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake) format. This support allows patterns like *enrich in Spark, serve with SQL*, where Apache Spark™ services like [Azure Databricks](https://azure.microsoft.com/products/databricks) or [Apache Spark pools in Azure Synapse](/azure/synapse-analytics/spark/apache-spark-overview) engineer data to create curated datasets in the data lake. Instead of having to load these datasets into a physical data warehouse, you can define an LDW over the data lake to provide the model/serve layer for reporting.

:::image type="content" source="../media/logical-data-warehouse-architecture.svg" alt-text="Diagram that shows the flow of external data to the reporting layer with Azure Synapse serverless SQL pool." border="false" lightbox="../media/logical-data-warehouse-architecture.svg":::

The LDW with Azure Synapse serverless SQL pools is an implementation of the [Data Lakehouse](/azure/databricks/lakehouse) pattern. Using Databricks SQL to implement an LDW is an alternative solution. However, Databricks SQL lacks the HTAP capability of Azure Synapse Link for Cosmos DB.

### Potential use cases

This pattern is useful for the following cases:

- Data warehouse serving layer for BI and other analytical use cases.
- Ad-hoc exploration of raw data in a data lake.
- Cost-effective data streaming into a data lake that doesn't require its own compute resources to write data. A logical database table, view, or ad-hoc T-SQL query can access the data instantly from the data lake.
- Instant access to Azure Cosmos DB transactional data to build real-time aggregation pipelines or join with analytical data stored in the data lake.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:
- [Jon Dobrzeniecki](https://www.linkedin.com/in/jonathan-dobrzeniecki) | Sr. Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Query storage files with serverless SQL pool in Azure Synapse Analytics](/azure/synapse-analytics/sql/query-data-storage)
- [Tutorial: Create Logical Data Warehouse with serverless SQL pool](/azure/synapse-analytics/sql/tutorial-logical-data-warehouse)
- [What is Azure Synapse Link for Azure Cosmos DB?](/azure/cosmos-db/synapse-link)
- [POLARIS: The distributed SQL engine in Azure Synapse](https://www.microsoft.com/research/publication/polaris-the-distributed-sql-engine-in-azure-synapse)
- [What is Delta Lake?](/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake)

## Related resources

- [Enterprise data warehouse](enterprise-data-warehouse.yml)
- [Secure a data lakehouse with Azure Synapse Analytics](../../example-scenario/analytics/secure-data-lakehouse-synapse.yml)
- [Near real-time lakehouse data processing](../../example-scenario/data/real-time-lakehouse-data-processing.yml)
- [Query a data lake or lakehouse by using Azure Synapse serverless](../../example-scenario/data/synapse-exploratory-data-analytics.yml)
