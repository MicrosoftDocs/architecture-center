[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The logical data warehouse (LDW) pattern lays a lightweight virtualized relational layer on top of data that's stored in a data lake or database. This virtualization layer provides data access like a traditional data warehouse without requiring data movement.

The LDW concept is similar to a [data lakehouse](/azure/databricks/lakehouse), but LDW with Azure Synapse Analytics includes support for [hybrid transaction/analytical processing (HTAP)](https://wikipedia.org/wiki/Hybrid_transactional/analytical_processing), which uses Azure Synapse serverless SQL pools to query transactional (OLTP) data stored in Azure Cosmos DB.

Data warehousing with data virtualization combines live OLTP data with analytical data from data lakes. This solution avoids moving data through complex, expensive, and latency-prone extract, transform, and load (ETL) pipelines for a less complex, faster way to serve business intelligence (BI) and analytical workloads.

### Architecture

The flexibility of an LDW with Azure Synapse serverless SQL pools allows you to join cold batch data, hot streaming data, and live transactional data in a single T-SQL query or view definition.

:::image type="content" source="../media/logical-data-warehouse-architecture-dataflow.png" alt-text="Diagram showing a flow of data from left to right as the steps describe." lightbox="../media/logical-data-warehouse-architecture-dataflow.png":::

### Dataflow

1. Azure Data Factory integrates data from source systems into the enterprise data lake.
1. Device and sensor data also streams from edge devices into the cloud through Azure IoT Hub. Azure Stream Analytics processes the data and sends it to the enterprise data lake.
1. Azure Synapse serverless SQL pools define an LDW that has logical tables and views accessible through the Azure Synapse workspace [on-demand SQL endpoint](/azure/synapse-analytics/sql/connect-overview#find-your-server-name).
1. Azure Synapse Link for Azure Cosmos DB queries realtime transactional data through the Azure Synapse serverless SQL pools. This data joins with cold batch and hot streaming data from the enterprise data lake to create logical views.
1. BI, reporting, and other analytical applications access LDW data by using the Azure Synapse workspace on-demand SQL endpoint.

> [!NOTE]
> The Azure Synapse workspace on-demand SQL endpoint is accessible from any tool or service that supports tabular data stream (TDS) connections to SQL Server.

### Components

- [Azure Synapse Analytics]() 
- [Azure Synapse Serverless SQL pools](/azure/synapse-analytics/sql/on-demand-workspace-overview) query data lakes via T-SQL and SQL Server endpoints.
- [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link) queries Azure Cosmos DB OLTP data by using Azure Synapse serverless SQL pools.
- [Azure Data Factory]() offers cloud-scale data integration and data flow orchestration.
- [IoT Hub]()
- [Stream Analytics]()
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides scalable, cost-effective cloud storage.
- [Azure Cosmos DB]() is a fully managed NoSQL database for modern app development.

**Alternative**

The LDW with Azure Synapse serverless SQL pools is an implementation of the [Data Lakehouse](/azure/databricks/lakehouse) pattern. Therefore, using Databricks SQL to implement a LDW is an alternative solution. However, Databricks SQL lacks the HTAP capability of Azure Synapse Link for Cosmos DB.

## Scenario details

An Azure Synapse Analytics LDW is based on serverless SQL pools that are available with all Azure Synapse workspaces. An enhanced version of the [OPENROWSET](/azure/synapse-analytics/sql/develop-openrowset) function in serverless SQL pools can access data in Data Lake Storage. This data access allows creation of relational database objects like tables and views over collections of data files that represent logical entities, like products, customers, and sales transactions. BI tools that connect by using a standard SQL Server endpoint can consume these logical entities as dimensions and fact tables.

:::image type="content" source="../media/logical-data-warehouse-architecture-concept.png" alt-text="Side by side comparison of the LDW conceptual design, next to an implementation of LDW with Azure Synapse Serverless SQL pool. Starting from the bottom, each diagram has three layers. The first layer shows files in cloud storage. The second layer is the logical database showing tables with arrows from the cloud storage files to the logical tables. The final layer is the logical tables being accessed by a dashboard for reporting and analytics. The implementation with Azure Synapse diagram shows the logical layer being implemented with a serverless SQL database. A SQL Server endpoint is shown above the logical layer tables. Power BI and SSMS access the SQL endpoint. The SQL endpoint and serverless SQL database are inside a box with an Azure Synapse logo, which shows that these are components of Azure Synapse." lightbox="../media/logical-data-warehouse-architecture-concept.png":::

The ability to access transactional data stores like Azure Cosmos DB through the Azure Synapse Link for Azure Cosmos DB expands these capabilities. Accessing OLTP data by using HTAP architecture provides instant updates without interfering with live transactions.

:::image type="content" source="../media/logical-data-warehouse-architecture-data.png" alt-text="Diagram that shows the flow of external data to the reporting layer using Azure Synapse serverless SQL pool." lightbox="../media/logical-data-warehouse-architecture-data.png":::

Each Azure Synapse workspace comes with an on-demand SQL endpoint. The endpoint lets SQL Server administrators and developers use a familiar environment to work with an LDW implemented with Azure Synapse serverless SQL pools. For example, the following screenshot shows SQL Server Management Studio (SSMS) connected to a Azure Synapse serverless SQL pool.

:::image type="content" source="../media/logical-data-warehouse-ssms-connect.png" alt-text="Screenshot that shows SQL Server Management Studio connected to the Azure Synapse on-demand SQL Server endpoint. In SSMS Object Explorer, Databases is expanded with a database named Gold. The Gold database shows several Fact and Dim views." lightbox="../media/logical-data-warehouse-ssms-connect.png":::

Azure Synapse serverless SQL pools support the following file formats:

- Delimited text, such as CSV, TSV, and TXT
- JSON
- Parquet

Azure Synapse serverless SQL pools also support the [Delta Lake](/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake) format. This support allows patterns like *enrich in Spark, serve with SQL*, where Apache Spark services like [Apache Spark pools in Azure Synapse](/azure/synapse-analytics/spark/apache-spark-overview) or [Azure Databricks](https://azure.microsoft.com/products/databricks) engineer data to create curated datasets in the data lake. Instead of having to load these datasets into a physical data warehouse, you can define an LDW over the data lake to provide the model/serve layer for reporting.

:::image type="content" source="../media/logical-data-warehouse-architecture.png" alt-text="Diagram that shows the flow of external data to the reporting layer with Azure Synapse serverless SQL pool." lightbox="../media/logical-data-warehouse-architecture.png":::

## Potential use cases

This pattern is useful for the following cases:

- Data warehouse serving layer for BI and other analytical use cases.
- Ad-hoc exploration of raw data in a data lake.
- Cost-effective data streaming into a data lake that doesn't require its own compute resources to write data. A logical database table, view, or ad-hoc T-SQL query can access the data instantly from the data lake.
- Instant access to Azure Cosmos DB transactional data to build realtime aggregation pipelines or join with analytical data stored in the data lake.

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
