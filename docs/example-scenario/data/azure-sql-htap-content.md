This article outlines a solution for a hybrid transaction/analytical processing (HTAP) architecture. To process transactions, most systems use low-latency, high-volume operational workloads. For analytics, higher-latency, lower-volume workloads are more typical. HTAP architectures offer a solution for both workload types. By using in-memory databases, HTAP consolidates technologies to optimize queries on large volumes of data.

## Architecture

:::image type="content" alt-text="Architecture diagram showing how data flows through an H T A P solution with Azure SQL Database at its center." source="./media/azure-sql-htap.svg" lightbox="./media/azure-sql-htap.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-sql-htap.vsdx) of this architecture.*

### Dataflow

1. Event Hubs ingests telemetry from on-premises facilities.
1. Blob Storage captures the Event Hubs data and stores it for future analysis.
1. Stream Analytics processes the data. In the solution's hot path, Azure Cosmos DB queries data from the previous two months. Azure Cosmos DB guarantees single-digit millisecond response times.
1. If errors occur during data processing or storage, the system logs them in Azure Table Storage.
1. Azure Functions uses the SQL Database [elastic database client library][Building scalable cloud databases] to archive the data. This process partitions the data to optimize insert operations. The solution forms shards by horizontally distributing the data over several Azure SQL databases. Each database uses a partitioned clustered columnar index to compress tables. Response times on this cold path are usually below one second.
1. An Azure Databricks cluster reprocesses the Blob Storage data. Specifically, Azure Databricks deserializes Avro files and sends the data to Event Hubs for optional analysis.

### Components

- [Event Hubs][Event Hubs] is a fully managed streaming platform for big data.

- [Stream Analytics][Azure Stream Analytics] provides real-time serverless stream processing by running queries in the cloud and on edge devices.

- [Azure Cosmos DB][Azure Cosmos DB] is a globally distributed, multi-model database. With Azure Cosmos DB, your solutions can elastically scale throughput and storage across any number of geographic regions.

- [Table Storage][Table storage] is part of [Azure Storage][Azure Storage documentation]. This service stores structured NoSQL data in the cloud.

- [SQL Database][Azure SQL Database] is a relational database service that's part of the [Azure SQL][Azure SQL] family. As a fully managed service, SQL Database handles database management functions. SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and Hyperscale storage options automatically scale resources on demand.

- [Elastic database tools][Get started with Elastic Database Tools] help you create and manage scaled-out databases. This feature of SQL Database includes a client library that you can use to develop sharded applications.

- [Blob Storage][Azure Blob Storage] is a service that's part of [Storage][Azure Storage documentation]. Blob Storage offers optimized cloud object storage for large amounts of unstructured data.

- [Azure Databricks][Azure Databricks] is a data analytics platform. Its fully managed Spark clusters process large streams of data from multiple sources. Azure Databricks cleans and transforms structureless data sets. It combines the processed data with structured data from operational databases or data warehouses. Azure Databricks also trains and deploys scalable machine learning and deep learning models.

- [Power BI][Power BI] is a collection of analytics services and apps. You can use Power BI to connect and display unrelated sources of data.

## Scenario details

Azure SQL Database forms the core of this HTAP solution. The approach divides the data into horizontally distributed databases, or shards. Other main components include:

- Azure Event Hubs for data ingestion.
- Azure Stream Analytics for data processing.
- Azure Functions for partitioning.
- Azure Blob Storage for event storage.

Together, these services provide an HTAP solution that:

- Reduces costs by providing fast access to insights on archived data. Latencies on the cool path  drop from hours to less than seconds with this solution.
- Simplifies archiving by automatically adding data to long-term storage.
- Maximizes scalability by sharding data and using an elastic database.

### Potential use cases

This solution applies to organizations that need low-latency access to large volumes of historical data. Examples include:

- Online retailers that access customer history and demographic information to provide personalized experiences.
- Energy providers that combine device data with analytics to manage smart power grids.
- Businesses that engage in fraud prevention by identifying patterns in historical and real-time data. This scenario applies to the finance and financial services industries.
- Manufacturers that rely on real-time event processing to identify problems. This scenario applies to the manufacturing industry.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

This solution makes the following assumptions:

- After you archive the data, you don't need to update or delete it.
- The data schema only changes minimally over time.

Keep the following considerations in mind when implementing this solution:

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- To optimize performance:

  - Combine sharding with table compression.
  - Partition tables by date. Each shard contains data from a different period.
  - Align indexes with the date partitioning.

- To scale up to more than 50,000 messages per second, use the [elastic database client library][Building scalable cloud databases] from within Functions to:

  - Group messages by partition.
  - Split insert statements into small batches.

  This approach is suitable for systems that use 10 Standard S3 databases of type SQL Database. To host a columnar index, you need at least the Standard tier.

- For best performance during insert operations, use [table-valued parameters with stored procedures][Use Table-Valued Parameters (Database Engine)].
- When you use the CREATE COLUMNSTORE INDEX statement, use the [COLUMNSTORE_ARCHIVE][CREATE COLUMNSTORE INDEX - DATA_COMPRESSION option] option. This option provides the highest possible level of compression. A high compression level increases the time you need to store and retrieve data. But the resulting I/O performance should still be satisfactory.

### Scalability

- Use shards so that you can expand your system to meet demanding workloads. When you use sharded databases, you can add or remove shards to scale out or in. The split-merge tool helps you [split and merge partitions][Deploy a split-merge service to move data between sharded databases].
- Take advantage of the scaling functionality in Functions. Create functions that scale based on CPU and memory usage. Configure the functions to start new instances to accommodate unexpected workloads.
- Increase the size of your Azure Databricks cluster to scale up Avro file reprocessing. The solution uses Azure Databricks to reprocess Avro files that Blob Storage has captured. Spark clusters in Azure Databricks can process all or part of the Avro file's path. By increasing the Azure Databricks cluster size, you can reprocess all the data within a required time frame. To handle increased volume from Azure Databricks, add instances of Event Hubs to the namespace as needed.

### Resiliency

- All of the components in this scenario are managed. At a regional level, they offer built-in resiliency.
- For general guidance on designing resilient solutions, see [Overview of the reliability pillar][Overview of the reliability pillar].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, use the [Azure pricing calculator][Azure pricing calculator], which preconfigures all Azure services. Adjust the parameters to match the traffic that you expect to receive.

The following table lists sample cost profiles for varying amounts of 1-kilobyte messages:

|Size | Message volume | Profile |
|---|---|---|
| Small | Fewer than 500 messages per second | [Small profile][Small cost profile] |
| Medium | 1,500 messages per second | [Medium profile][Medium cost profile] |
| Large | More than 5,000 messages per second | [Large profile][Large cost profile] |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Pablo Ahumada Koschitzky](https://es.linkedin.com/in/pahumadakoschitzky/es) | Sr Cloud Solution Architect

## Next steps

- [Stream processing with Azure Stream Analytics][Stream processing with Azure Stream Analytics]
- [Scaling out with Azure SQL Database][Scaling out with Azure SQL Database]

## Related resources

- [Deliver highly scalable customer service and ERP applications][Deliver highly scalable customer service and ERP applications]
- [Optimized storage – time based with Data Lake][Optimized storage – time based with Data Lake]
- [Analytics end-to-end with Azure Synapse][Analytics end-to-end with Azure Synapse]

[Azure Blob Storage]: https://azure.microsoft.com/services/storage/blobs
[Azure Cosmos DB]: https://azure.microsoft.com/services/cosmos-db
[Azure Databricks]: https://azure.microsoft.com/services/databricks
[Analytics end-to-end with Azure Synapse]: ../dataplate2e/data-platform-end-to-end.yml
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Azure SQL]: https://azure.microsoft.com/products/azure-sql
[Azure SQL Database]: https://azure.microsoft.com/products/azure-sql/database
[Azure Storage documentation]: /azure/storage
[Azure Stream Analytics]: https://azure.microsoft.com/services/stream-analytics
[Building scalable cloud databases]: /azure/azure-sql/database/elastic-database-client-library#client-capabilities
[CREATE COLUMNSTORE INDEX - DATA_COMPRESSION option]: /sql/t-sql/statements/create-columnstore-index-transact-sql?view=sql-server-ver15#data_compression--columnstore--columnstore_archive
[Deliver highly scalable customer service and ERP applications]: ../../solution-ideas/articles/erp-customer-service.yml
[Deploy a split-merge service to move data between sharded databases]: /azure/azure-sql/database/elastic-scale-configure-deploy-split-and-merge
[Event Hubs]: https://azure.microsoft.com/services/event-hubs
[Get started with Elastic Database Tools]: /azure/azure-sql/database/elastic-scale-get-started
[Large cost profile]: https://azure.com/e/0d1106de9a5e428a83bcdcb4440e0ea4
[Medium cost profile]: https://azure.com/e/1fafd04b0a3f4896873550e16eef19ab
[Optimized storage – time based with Data Lake]: ../../solution-ideas/articles/optimized-storage-time-based-data-lake.yml
[Overview of the reliability pillar]: /azure/architecture/framework/resiliency/overview
[Power BI]: https://powerbi.microsoft.com
[Scaling out with Azure SQL Database]: /azure/azure-sql/database/elastic-scale-introduction
[Small cost profile]: https://azure.com/e/48812c1a50dd4415a005d8c9bc620a30
[Stream processing with Azure Stream Analytics]: ../../reference-architectures/data/stream-processing-stream-analytics.yml
[SVG file of architecture diagram]: ./media/azure-sql-htap.svg
[Table storage]: https://azure.microsoft.com/services/storage/tables
[Use Table-Valued Parameters (Database Engine)]: /sql/relational-databases/tables/use-table-valued-parameters-database-engine?view=sql-server-ver15#Benefits
