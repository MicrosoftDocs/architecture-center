- what the solution does
- brief description of the main Azure services that make up the solution



## Potential use cases

This solution applies to scenarios that require low-latency access to large volumes of historical data. Examples include:

- Online retailers that access customers' history and demographic information to provide personalized experiences.
- Financial institutions that combine transation data with analytics to calculate portfolio values.
- Manufacturers that rely on real-time event processing to identify problems as they unfold.


## Architecture

1. Azure Event Hub ingests telemetry from on-premises facilities.
1. Azure Blob Storage captures the Event Hub data and stores it for future analysis.
1. Azure Stream Analytics processes the data. In the solution's hot path, Azure Cosmos DB queries data from the previous two months. Azure Cosmos DB guarantees single-digit millisecond response times.
1. If errors occur during data processing or storage, the system logs them in Azure Table Storage.
1. Azure Functions uses the Azure SQL Database [elastic database client library][Building scalable cloud databases] to archive the data. This process partitions the data to optimize insert operations. The solution forms shards by horizontally distributing the data over several Azure SQL databases. Each database uses a partitioned clustered columnar index to compress tables. Response times for this cold-path data are are usually below one second.
1. An Azure Databricks cluster reprocesses the Azure Data Lake Storage data. Specifically, Azure Databricks deserializes Avro files and sends the data to Event Hub for optional analysis.

## Components



## Considerations

This solution makes the following assumptions:

- After you archive the data, you don't need to update or delete it.
- The data scheme only changes minimally over time.

Keep the following considerations in mind when implementing this solution:

### Performance considerations

- First bullet on performance: waiting on Rick to respond.
- To scale up to more than 50,000 messages per second, use the [elastic database client library][Building scalable cloud databases] from within Azure Functions to:

  - Group messages by partition.
  - Split insert statements into small batches.

  This approach is suitable for systems that use 10 Standard S3 databases of type Azure SQL Database. To host a columnar index, you need at least the Standard tier.

- For best performance during insert operations, use [table-valued parameters with stored procedures][Use Table-Valued Parameters (Database Engine)].
- When you use the CREATE COLUMNSTORE INDEX statement, use the [COLUMNSTORE_ARCHIVE][CREATE COLUMNSTORE INDEX - DATA_COMPRESSION option] option. This option provides the highest possible level of compression. A high compression level increases the time you need to store and retrieve data. But the resulting I/O performance is still sufficient.

### Scalability considerations

- Use shards so that you can expand your system indefinitely. When you use sharded databases, you can [split and merge partitions][Deploy a split-merge service to move data between sharded databases] to scale up or out.
- Take advantage of the scaling functionality in Azure Functions. Create functions that scale based on CPU and memory usage. Configure the functions to start new instances to accommodate unexpected workloads.
- The solution uses Azure Databricks to reprocess Avro files that Azure Blob Storage captures. Spark clusters in Azure Databricks can process all or part of the Avro file's path. Increase the size of the Azure Databricks cluster to reprocess all the data within a required time frame. Add instances of Event Hub to the namespace to handle the increased volume from Azure Databricks.

### Resiliency considerations

- All of the components in this scenario are managed. At a regional level, they offer built-in resiliency.
- For general guidance on designing resilient solutions, see [Overview of the reliability pillar][Overview of the reliability pillar].

## Pricing

To explore the cost of running this scenario, use the [Azure pricing calculator][Azure pricing calculator], which preconfigures all Azure services. Adjust the parameters to match the traffic that you expect to receive.

The following table lists sample cost profiles for varying amounts of 1-kilobyte messages:

|Size | Message volume | Profile |
|---|---|---|
| Small | Less than 500 messages per second | [Small profile][Small cost profile] |
| Medium | 1,500 messages per second | [Medium profile][Medium cost profile] |
| Large | More than 5,000 messages per second | [Large profile][Large cost profile] |

## Next steps

- [Stream processing with Azure Stream Analytics][Stream processing with Azure Stream Analytics]
- [Scaling out with Azure SQL Database][Scaling out with Azure SQL Database]

## Related resources







[Azure pricing calculator]: https://azure.microsoft.com/en-us/pricing/calculator/
[Building scalable cloud databases]: https://docs.microsoft.com/en-us/azure/azure-sql/database/elastic-database-client-library#client-capabilities
[CREATE COLUMNSTORE INDEX - DATA_COMPRESSION option]: https://docs.microsoft.com/en-us/sql/t-sql/statements/create-columnstore-index-transact-sql?view=sql-server-ver15#data_compression--columnstore--columnstore_archive
[Deploy a split-merge service to move data between sharded databases]: https://docs.microsoft.com/en-us/azure/azure-sql/database/elastic-scale-configure-deploy-split-and-merge
[Large cost profile]: https://azure.com/e/0d1106de9a5e428a83bcdcb4440e0ea4
[Medium cost profile]: https://azure.com/e/1fafd04b0a3f4896873550e16eef19ab
[Overview of the reliability pillar]: https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/overview
[Scaling out with Azure SQL Database]: https://docs.microsoft.com/en-us/azure/azure-sql/database/elastic-scale-introduction
[Small cost profile]: https://azure.com/e/48812c1a50dd4415a005d8c9bc620a30
[Stream processing with Azure Stream Analytics]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/data/stream-processing-stream-analytics
[Use Table-Valued Parameters (Database Engine)]: https://docs.microsoft.com/en-us/sql/relational-databases/tables/use-table-valued-parameters-database-engine?view=sql-server-ver15#Benefits
