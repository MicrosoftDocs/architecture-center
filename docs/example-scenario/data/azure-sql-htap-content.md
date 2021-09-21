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

























[Building scalable cloud databases]: https://docs.microsoft.com/en-us/azure/azure-sql/database/elastic-database-client-library#client-capabilities
