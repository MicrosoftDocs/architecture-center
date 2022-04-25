The increasing value of data virtualization can be contributed to several factors:

* Data lakes are now a foundational part of modern data analytics platforms.
* The increase of [polyglot persistence](https://en.wikipedia.org/wiki/Polyglot_persistence) throughout enterprise IT environments.
* The convergence of data warehousing and big data workloads.

The logical data warehouse (LDW) pattern is the idea of laying a lightweight virtualized relational layer on top of data where it's stored (i.e. data lake, database, etc.). This virtualization layer surfaces data, without data movement, resembling access to data from a traditional data warehouse.

The LDW aligns closely with similar concepts like the [Data Lakehouse](https://databricks.com/glossary/data-lakehouse) pattern. LDW with Azure Synapse Analytics differs in its support for the [Hybrid Transactional/Analytical Processing (HTAP)](https://en.wikipedia.org/wiki/Hybrid_transactional/analytical_processing) pattern. Synapse SQL Serverless Pools support querying transactional data in SQL Server, Azure Cosmos DB, Azure Data Explorer, and [Microsoft Dataverse](https://powerplatform.microsoft.com/dataverse) using the HTAP pattern. This provides value in avoiding the need for Extract Transform and Load (ETL) pipelines for data movement that are complex, expensive, and suffer from latency. Now the benefits of data warehousing can be achieved with data virtualization combining live transactional data joined with data in data lakes for a less complex more timely solution to service Business Intelligence (BI) and other reporting workloads.

## Architecture

A Logical Data Warehouse (LDW) in Azure Synapse Analytics is based on Serverless SQL Pools available with Synapse workspaces. An enhanced version of [OPENROWSET](https://docs.microsoft.com/azure/synapse-analytics/sql/develop-openrowset) available in Serverless SQL Pools is used to access data in an Azure Data Lake. Accessing data this way allows for relational database objects like tables and views to be created over collections of files containing data related to logical entities (i.e. products, customers, sales transactions). These logical entities can then be consumed as dimensions and fact tables by BI tools that connect using a standard SQL Server endpoint.

:::image type="content" source="images/logical-data-warehouse-architecture-1.png" alt-text="Diagram depicting the flow of external data to reporting layer using Synapse Serverless SQL Pool." lightbox="../media/customer-dimension-example.png":::

Synapse Serverless SQL Pools support the [Delta Lake](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake) format. This enables support for patterns like <i>"enrich in Spark, serve with SQL"</i>, where Spark services like Azure Synapse Spark Pools or Azure Databricks perform the data engineering tasks that create curated datasets in the data lake. Instead of needing to load these datasets into a physical data warehouse, a LDW can be defined to provide the model/serve layer for reporting.

:::image type="content" source="images/logical-data-warehouse-architecture.png" alt-text="Diagram depicting the flow of external data to reporting layer using Synapse Serverless SQL Pool." lightbox="../media/customer-dimension-example.png":::

This can be expanded further with the ability to access transactional data stores like Azure Cosmos DB or SQL Server. Accessing transactional data stores with a LDW provides realtime updates without interfering with live transactions. Access to transactional data stores is accomplished using the [Synapse Link](https://docs.microsoft.com/azure/cosmos-db/synapse-link) technology.

:::image type="content" source="images/logical-data-warehouse-architecture-2.png" alt-text="Diagram depicting the flow of external data to reporting layer using Synapse Serverless SQL Pool." lightbox="../media/customer-dimension-example.png":::

### Workflow

The architecture consists of the following components:

- **Thing 1**. Description

- **Thing 2**. Description

### Components

- [Azure Synapse serverless SQL pools](/azure/synapse-analytics/sql/on-demand-workspace-overview). Used to query customer data in a data lake via T-SQL and SQL Server endpoint.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage). Scalable and cost-effective cloud storage that Customer Insights supports as a target for exporting data.
- [Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/introduction). A fully managed NoSQL database for modern app development.
- [SQL Server 2022](https://www.microsoft.com/sql-server/sql-server-2022). Drive insights in near real-time by breaking the wall between operational and analytical stores, enabling you to analyze all your data using both Spark and SQL runtimes in the cloud with Azure Synapse Link. 
- [Microsoft Dataverse](https://docs.microsoft.com/power-apps/maker/data-platform/data-platform-intro). Dataverse lets you securely store and manage data that's used by business applications.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

_Include considerations for deploying or configuring the elements of this architecture._

## Scalability considerations

_Identify and address scalability concerns relevant to the architecture in this scenario._

## Availability considerations

_Identify and address availability concerns relevant to the architecture in this scenario._

## Manageability considerations

A benefit of LDW as a data virtualization solution for data warehousing is a decrease in complexity. This is achieved by avoiding data movement and processing with accessing data at its source. This increases manageability by producing a solution that has less moving parts.

The guessing game of sizing cloud services is also removed by using Synapse Serverless SQL pools. There is no size selection for these pools. They are based on the [POLARIS distributed SQL engine](https://www.microsoft.com/research/publication/polaris-the-distributed-sql-engine-in-azure-synapse/) that dynamically scales at runtime.

Synapse Serverless SQL pools are charged by the amount of data processed. [Cost controls](https://docs.microsoft.com/azure/synapse-analytics/sql/data-processed#configure-cost-control-for-serverless-sql-pool-in-synapse-studio) are built into the pools to monitor cost and set quotes that keep consumption within budget.

## Security considerations

_Identify and address security concerns relevant to the architecture in this scenario._

## Next steps

* [Query storage files with serverless SQL pool in Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/sql/query-data-storage)
* [Tutorial: Create Logical Data Warehouse with serverless SQL pool](https://docs.microsoft.com/azure/synapse-analytics/sql/)

## Related resources

* [POLARIS: the distributed SQL engine in azure synapse](https://www.microsoft.com/research/publication/polaris-the-distributed-sql-engine-in-azure-synapse/)
* [What is Delta Lake](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake)
* [Data Lakehouse](https://databricks.com/glossary/data-lakehouse)