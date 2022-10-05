The increasing value of [data virtualization](https://en.wikipedia.org/wiki/Data_virtualization) can be contributed to several factors:

* Data lakes are now a foundational part of modern data analytics platforms.
* The increase of [polyglot persistence](https://en.wikipedia.org/wiki/Polyglot_persistence) throughout enterprise IT environments.
* The convergence of data warehousing and big data workloads.

The logical data warehouse (LDW) pattern is the idea of laying a lightweight virtualized relational layer on top of data where it's stored (i.e. data lake, database, etc.). This virtualization layer surfaces data, without data movement, resembling access to data from a traditional data warehouse.

The LDW aligns closely with similar concepts like the [Data Lakehouse](https://databricks.com/glossary/data-lakehouse) pattern. LDW with Azure Synapse Analytics differs in its support for the [Hybrid Transactional/Analytical Processing (HTAP)](https://en.wikipedia.org/wiki/Hybrid_transactional/analytical_processing) pattern. Synapse SQL Serverless Pools support querying transactional data in Azure Cosmos DB and [Microsoft Dataverse](https://powerplatform.microsoft.com/dataverse) using the HTAP pattern. This provides value in avoiding the need for Extract Transform and Load (ETL) pipelines for data movement that are complex, expensive, and suffer from latency. Now the benefits of data warehousing can be achieved with data virtualization combining live transactional data joined with data in data lakes for a less complex more timely solution to service Business Intelligence (BI) and other reporting workloads.

## Architecture

A Logical Data Warehouse (LDW) in Azure Synapse Analytics is based on Serverless SQL Pools available with Synapse workspaces. An enhanced version of [OPENROWSET](https://docs.microsoft.com/azure/synapse-analytics/sql/develop-openrowset) available in Serverless SQL Pools is used to access data in an Azure Data Lake. Accessing data this way allows for relational database objects like tables and views to be created over collections of files containing data related to logical entities (i.e. products, customers, sales transactions). These logical entities can then be consumed as dimensions and fact tables by BI tools that connect using a standard SQL Server endpoint.

:::image type="content" source="images/logical-data-warehouse-architecture-1.png" alt-text="Diagram depicting the flow of external data to reporting layer using Synapse Serverless SQL Pool." lightbox="images/logical-data-warehouse-architecture-1.png":::

Synapse Serverless SQL Pools support the [Delta Lake](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake) format. This enables support for patterns like <i>"enrich in Spark, serve with SQL"</i>, where Spark services like Azure Synapse Spark Pools or Azure Databricks perform the data engineering tasks that create curated datasets in the data lake. Instead of needing to load these datasets into a physical data warehouse, a LDW can be defined to provide the model/serve layer for reporting.

:::image type="content" source="images/logical-data-warehouse-architecture.png" alt-text="Diagram depicting the flow of external data to reporting layer using Synapse Serverless SQL Pool." lightbox="images/logical-data-warehouse-architecture.png":::

This can be expanded further with the ability to access transactional data stores like Azure Cosmos DB or SQL Server. Accessing transactional data stores with a LDW provides realtime updates without interfering with live transactions. Access to transactional data stores is accomplished using the [Synapse Link](https://docs.microsoft.com/azure/cosmos-db/synapse-link) technology.

:::image type="content" source="images/logical-data-warehouse-architecture-2.png" alt-text="Diagram depicting the flow of external data to reporting layer using Synapse Serverless SQL Pool." lightbox="images/logical-data-warehouse-architecture-2.png":::

### Components

- [Azure Synapse Serverless SQL pools](/azure/synapse-analytics/sql/on-demand-workspace-overview). Used to query customer data in a data lake via T-SQL and SQL Server endpoint.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage). Scalable and cost-effective cloud storage that Customer Insights supports as a target for exporting data.
- [Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/introduction). A fully managed NoSQL database for modern app development.
- [Microsoft Dataverse](https://docs.microsoft.com/power-apps/maker/data-platform/data-platform-intro). Dataverse lets you securely store and manage data that's used by business applications.

## Scalability considerations

Scalability of a LDW is handled by the dynamic scaling capabilities of the [POLARIS distributed SQL engine](https://www.microsoft.com/research/publication/polaris-the-distributed-sql-engine-in-azure-synapse/) that Synapse Serverless SQL Pools are built on. When a query is submitted, the Polaris SQL engine will profile the dataset and determine how to partition the data in <i>"cells"</i>. The data cells are then assigned to instances of SQL Server processes (sqlserver.exe) that process their data cell. When processing of all data cells is completed by the distributed instances of SQL Server, the results are combined back into a single result dataset. This process is done dynamically and completely removes the responsibility of the developer or application to scale or size the Synapse Serverless SQL pool. The addition of built-in query execution fault-tolerance provides high reliability and success rates even for long-running queries involving large data sets.
This make the LDW architecture built with Synapse Serverless SQL pools a highly scalable architecture for big datasets residing in data lakes.

## Manageability considerations

A benefit of LDW as a data virtualization solution for data warehousing is a decrease in complexity. This is achieved by avoiding data movement and processing with accessing data at its source. This increases manageability by producing a solution that has less moving parts.

The guessing game of sizing cloud services is also removed by using Synapse Serverless SQL pools. There is no size selection or infrastructure to setup for these pools 

They are based on the [POLARIS distributed SQL engine](https://www.microsoft.com/research/publication/polaris-the-distributed-sql-engine-in-azure-synapse/) that dynamically scales at runtime.

Synapse Serverless SQL pools are charged by the amount of data processed. [Cost controls](https://docs.microsoft.com/azure/synapse-analytics/sql/data-processed#configure-cost-control-for-serverless-sql-pool-in-synapse-studio) are built into the pools to monitor cost and set quotes that keep consumption within budget.

## Security considerations

Synapse Serverless SQL pool offers mechanisms to secure access to your data. Security can be enforced using:

* Logins and users
* Credentials to control access to storage accounts
* Grant, deny, and revoke permissions per object level
* Azure Active Directory integration

The security controls for Synapse Serverless SQL pools are covered in detail, [here](https://docs.microsoft.com/azure/synapse-analytics/sql/on-demand-workspace-overview#security). These options should be familiar to SQL Server database administrators and are equivalent to the corresponding options available in SQL Server.

In addition to the SQL Server level controls mentioned above, security of the external data stores being accessed by Serverless SQL pools in the LDW pattern require consideration. Access to storage accounts (i.e. Azure Data Lake) can be configured in several ways covered in detail, [here](https://docs.microsoft.com/azure/synapse-analytics/sql/on-demand-workspace-overview#access-to-storage-accounts). Access to Cosmos DB data is covered, [here](https://docs.microsoft.com/azure/synapse-analytics/sql/on-demand-workspace-overview#access-to-cosmos-db).

Row-level security can also be implemented with the availability of the familiar SQL Server functions [SUSER_SNAME()](https://docs.microsoft.com/sql/t-sql/functions/suser-sname-transact-sql?view=azure-sqldw-latest) and [IS_ROLEMEMBER()](https://docs.microsoft.com/sql/t-sql/functions/is-rolemember-transact-sql?view=azure-sqldw-latest). An example of implementing row-level security is provided, [here](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/how-to-implement-row-level-security-in-serverless-sql-pools/ba-p/2354759).

## Next steps

* [Query storage files with serverless SQL pool in Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/sql/query-data-storage)
* [Tutorial: Create Logical Data Warehouse with serverless SQL pool](https://docs.microsoft.com/azure/synapse-analytics/sql/)

## Related resources

* [POLARIS: the distributed SQL engine in azure synapse](https://www.microsoft.com/research/publication/polaris-the-distributed-sql-engine-in-azure-synapse/)
* [What is Delta Lake](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake)
* [Data Lakehouse](https://databricks.com/glossary/data-lakehouse)