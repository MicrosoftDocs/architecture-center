[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The logical data warehouse (LDW) pattern is the idea of laying a lightweight virtualized relational layer on top of data where it's stored (i.e. data lake, database, etc.). This virtualization layer surfaces data, without data movement, providing the familiar access of a traditional data warehouse.

The LDW aligns closely with similar concepts like the [Data Lakehouse](https://databricks.com/glossary/data-lakehouse). LDW with Azure Synapse Analytics differentiates with support for [Hybrid Transactional/Analytical Processing (HTAP)](https://en.wikipedia.org/wiki/Hybrid_transactional/analytical_processing). The HTAP pattern is achieved with Synapse Serverless SQL pool support for querying transactional data stored in Azure Cosmos DB. This adds value by avoiding the need for Extract Transform and Load (ETL) pipelines that result in data movement that is complex, expensive, and suffers from latency.

Now the benefits of data warehousing can be achieved with data virtualization, adding the additional benefit of combining live transactional data joined with analytical data in data lakes for a less complex more timely solution to serve Business Intelligence (BI) and analytical workloads.

## Potential use cases

- Data warehouse serving layer for business intelligence (BI) and other analytical use cases.

- Ad-hoc data exploration of raw data landed in a data lake.

- A cost-effective architecture for streaming data. Data can be streamed into a data lake that does not require its own compute to write data. The data can then be accessed instantly from the data lake using a logical database table, view, or ad-hoc T-SQL query.

- Instant access to transactional data in Cosmos DB that can be used to build realtime aggregation pipelines or join together with analytical data stored in the data lake.

## Architecture

A Logical Data Warehouse (LDW) in Azure Synapse Analytics is based on Serverless SQL Pools available with Synapse workspaces. An enhanced version of [OPENROWSET](https://docs.microsoft.com/azure/synapse-analytics/sql/develop-openrowset) available in Serverless SQL Pools is used to access data in Azure Data Lake. Accessing data this way allows for relational database objects like tables and views to be created over collections of files containing data that represents logical entities (i.e. products, customers, sales transactions). These logical entities can then be consumed as dimensions and fact tables by BI tools that connect using a standard SQL Server endpoint.

:::image type="content" source="../media/logical-data-warehouse-architecture-1.png" alt-text="Side by side comparison of the LDW conceptual design, next to an implementation of LDW with Azure Synapse Serverless SQL pool. Starting from the bottom each diagram has three layers. The first layer is cloud storage depicting files in cloud storage. The second layer is the logical database depicting tables with arrows from the cloud storage files to the logical tables. The final layer is the logical tables being accessed by a dashboard for reporting and analytics. The implementation with Azure Synapse diagram shows the logical layer being implemented with a Serverless SQL database. Then a SQL Server endpoint is shown above the logical layer tables. Power BI and SSMS are access the SQL endpoint. The SQL endpoint and Serverless SQL database inside a blue box with an Azure Synapse logo. This signifies that these are components of Azure Synapse." lightbox="../media/logical-data-warehouse-architecture-1.png":::

This can be expanded further with the ability to access transactional data stores like Azure Cosmos DB. Accessing transactional data stores using HTAP architecture provides instant updates without interfering with live transactions. Access to transactional data stores is accomplished using the [Synapse Link](https://docs.microsoft.com/azure/cosmos-db/synapse-link) technology.

:::image type="content" source="../media/logical-data-warehouse-architecture-3.png" alt-text="Diagram depicting the flow of external data to reporting layer using Synapse Serverless SQL pool." lightbox="../media/logical-data-warehouse-architecture-3.png":::

Each Azure Synapse workspace comes with an [on-demand SQL endpoint](https://learn.microsoft.com/azure/synapse-analytics/sql/connect-overview#find-your-server-name). This offers a familiar environnement for SQL Server administrators and developers to work with an LDW implemented using Synapse Serverless SQL pools. For example, the image below shows SQL Server Management Studio (SSMS) connected to a Synapse Serverless SQL pool.

:::image type="content" source="../media/logical-data-warehouse-ssms-connect.png" alt-text="SQL Server Management Studio connected to the Synapse On-demand SQL Server endpoint. In Object explorer, Databases is expanded with a database named Gold. There are several Fact and Dim views seen in the Gold database." lightbox="../media/logical-data-warehouse-ssms-connect.png":::

Synapse Serverless SQL pools support the following popular file formats:

- Delimited text (i.e. CSV, TSV, TXT, etc..)
- JSON
- Parquet

In addition, Synapse Serverless SQL pools support the [Delta Lake](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake) format. This enables support for patterns like <i>"enrich in Spark, serve with SQL"</i>, where Spark services like Azure Synapse Spark Pools or Azure Databricks perform the data engineering tasks to create curated datasets in the data lake. Instead of needing to load these datasets into a physical data warehouse, a LDW can be defined over the data lake to provide the model/serve layer for reporting.

:::image type="content" source="../media/logical-data-warehouse-architecture.png" alt-text="Diagram depicting the flow of external data to reporting layer using Synapse Serverless SQL Pool." lightbox="../media/logical-data-warehouse-architecture.png":::

### Dataflow

The flexibility of a LDW with Synapse Serverless SQL pools allows you to join together cold batch data, hot streaming data, and live transactional data in a single T-SQL query or view definition. This section depicts an example of this.

:::image type="content" source="../media/logical-data-warehouse-architecture-dataflow.png" alt-text="A flow of data from right to left described in the 5 steps in the Dataflow section of this doc." lightbox="../media/logical-data-warehouse-architecture-dataflow.png":::

1. Azure Data Factory integrates data from source system into the enterprise data lake.
1. Device and sensor data from edge devices streams into the cloud through [Azure IoT Hub](https://learn.microsoft.com/azure/iot-hub/iot-concepts-and-iot-hub). Data is processed by [Azure Stream Analytics](https://learn.microsoft.com/azure/stream-analytics/stream-analytics-introduction) and landed into the enterprise data lake.
1. A logical data warehouse (LDW) is defined using Azure Synapse Serverless SQL pools. Logical tables and views are defined and made accessible through the Azure Synapse workspaces [on-demand SQL endpoint](https://learn.microsoft.com/azure/synapse-analytics/sql/connect-overview#find-your-server-name).
1. [Synapse Link for Azure Cosmos DB](https://learn.microsoft.com/azure/cosmos-db/synapse-link) is established to query realtime transactional (OLTP) data using Azure Synapse Serverless SQL pools. This data can be joined with cold and hot (streaming) data from the enterprise data lake to create logical views.
1. Business Intelligence (BI), reporting, and other analytical applications access the Logical Data Warehouse (LDW) using the Azure Synapse workspaces [on-demand SQL endpoint](https://learn.microsoft.com/azure/synapse-analytics/sql/connect-overview#find-your-server-name).

> [!NOTE]
> The Synapse workspace on-demand SQL endpoint is accessible from <b>any</b> tool or service that supports TDS connections to SQL Server.

### Components

- [Azure Synapse Serverless SQL pools](https://docs.microsoft.com/azure/synapse-analytics/sql/on-demand-workspace-overview) - Used to query a data lake via T-SQL and SQL Server endpoint.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) - Scalable cost-effective cloud storage.
- [Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/introduction) - A fully managed NoSQL database for modern app development.

### Alternatives

The LDW with Synapse Serverless SQL pools can be considered an implementation of the [Data Lakehouse](https://databricks.com/glossary/data-lakehouse) pattern. Data Lakehouse is a term originally coined by Databricks. Therefore, using Databricks SQL to implement a LDW is an alternative solution. However, Databricks SQL will lack the HTAP capability that Synapse Link offers with Cosmos DB.

## Next Steps

- [Query storage files with serverless SQL pool in Azure Synapse Analytics](https://learn.microsoft.com/azure/synapse-analytics/sql/query-data-storage)
- [Tutorial: Create Logical Data Warehouse with serverless SQL pool](https://docs.microsoft.com/azure/synapse-analytics/sql/)
- [What is Azure Synapse Link for Azure Cosmos DB?](https://learn.microsoft.com/azure/cosmos-db/synapse-link)

## Related resources

- [POLARIS: the distributed SQL engine in azure synapse](https://www.microsoft.com/research/publication/polaris-the-distributed-sql-engine-in-azure-synapse/)
- [What is Delta Lake](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake)
- [Data Lakehouse](https://databricks.com/glossary/data-lakehouse)