
## Architecture

:::image type="content" source="./media/smart-places-diagram.svg" alt-text="Diagram that illustrates the recommended architecture for a smart space solution." border="false" lightbox="./media/smart-places-diagram.svg":::

Download an [SVG][SVG version of architecture diagram] of this architecture.

1. Event Hubs for Kafka streams events from Kafka producers.

1. Apache Spark consumes events. AKS provides a managed environment for the Apache Spark jobs.

1. An application that uses the Cassandra API for Cosmos DB writes events to Cassandra. This database serves as a storage platform for events. AKS hosts the microservices that write to Cassandra. 

1. The Change Feed feature of Cosmos DB processes events in real-time.

1. Batch processes run on events stored in Cassandra.

1. Reference data stores enrich event information. Batch-oriented applications write the enriched event information to PostgreSQL. Typical reference data stores include:

   - Azure Data Lake Storage, which can store data in open formats such as parquet.
   - Open-source relational data stores like PostgreSQL and MySQL.

1. A batch-oriented application processes Cassandra data and stores the processed data in Azure Database for PostgreSQL. This relational data store provides data to downstream applications that require enriched information.

1. Reporting applications and tools analyze the PostgreSQL database data. For example, Power BI can connect to the database by using the Azure Database for PostgreSQL connector. This reporting service can then display rich visuals of the data.

1. Azure Cache for Redis provides an in-memory cache. In this solution, the cache stores contains critical events that applications like websites need to access quickly. An application stores and retrieves data from the cache.

1. Applications like websites use the cached data to improve responsiveness. When data's not available in the cache, websites retrieve data from Cassandra in Cosmos DB by using the [cache-aside pattern][Cache-Aside pattern] or a similar strategy.







## Deploy the solution

Keep these points in mind when you deploy this solution:

- When you deploy Event Hubs for Kafka, refer to [Quickstart: Data streaming with Event Hubs using the Kafka protocol][Quickstart: Data streaming with Event Hubs using the Kafka protocol]. This article provides the following information:

  - How to send and receive messages with Kafka in Event Hubs
  - Sample code for a publishing application
  - How to switch existing Kafka applications to Event Hubs for Kafka by making configuration changes

- Concerning Apache Spark:

  - For information on building a simple Spark application, refer to [Connect your Apache Spark application with Azure Event Hubs][Connect your Apache Spark application with Azure Event Hubs].
  - To host the Spark application on AKS, refer to [Running Apache Spark jobs on AKS][Running Apache Spark jobs on AKS].

- Consider using a Java application to write events to Cassandra. For information on developing a Java application for writing events, see [Quickstart: Build a Java app to manage Azure Cosmos DB Cassandra API data (v4 Driver)][Quickstart: Build a Java app to manage Azure Cosmos DB Cassandra API data (v4 Driver)].

- When you use the Cosmos DB change feed, refer to [Change feed in the Azure Cosmos DB API for Cassandra][Change feed in the Azure Cosmos DB API for Cassandra] for this information:

  - How to use query predicates in CQL to query the change feed API
  - Sample code for a Java application

- For information on batch processing events that you've stored in Cassandra, refer to [Tutorial: Query data from a Cassandra API account in Azure Cosmos DB][Tutorial: Query data from a Cassandra API account in Azure Cosmos DB]. This article also contains sample Java code for using CQL commands to retrieve data from tables.

- For information on using a batch-oriented application to write data to Azure Database for PostgreSQL, see [Quickstart: Use Java and JDBC with Azure Database for PostgreSQL][Quickstart: Use Java and JDBC with Azure Database for PostgreSQL]. This article also contains sample Java code for storing data.









## Pricing

To estimate the cost of this solution, use the [Azure pricing calculator][Azure pricing calculator]. Also keep these points in mind:

- [Azure Event Hubs][Event Hubs pricing] is available in Basic, Standard, Premium, and Dedicated tiers. The Premium or Dedicated tier is usually best for large-scale streaming workloads. You can scale up throughput, so consider starting small and then scaling up as demand increases.
- [Azure Cosmos DB][Azure Cosmos DB pricing] offers two models:

  - A provisioned throughput model that's ideal for demanding workloads. This model is available in two capacity management options: standard and autoscale.
  - A serverless model that's better suited to run small, spiky workloads.

- An [Azure Kubernetes Service][Azure Kubernetes Service (AKS) pricing] cluster consists of a set of nodes, or VMs, that run in Azure. The cost of the compute, storage, and networking components make up a cluster's primary costs.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL pricing] is available in Single Server, Flexible Server, and Hyperscale (Citus) tiers. Different tiers cater to different scenarios, such as predicable, burstable, and high-performance workloads. The costs mainly depend on the choice of compute nodes and storage capacity.

- [Azure Cache for Redis][Azure Cache for Redis pricing] is available in multiple tiers to suit caches ranging from 250 megabytes to several terabytes. Requirements such as the need for clustering, persistence, and active geo-replication also affect the choice of tier.






[Azure Cache for Redis pricing]: https://azure.microsoft.com/pricing/details/cache/
[Azure Cosmos DB pricing]: https://azure.microsoft.com/en-us/pricing/details/cosmos-db/
[Azure Database for PostgreSQL pricing]: https://azure.microsoft.com/pricing/details/postgresql/server/
[Azure Kubernetes Service (AKS) pricing]: https://azure.microsoft.com/en-us/pricing/details/kubernetes-service/
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Cache-Aside pattern]: https://docs.microsoft.com/en-us/azure/architecture/patterns/cache-aside
[Change feed in the Azure Cosmos DB API for Cassandra]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/cassandra-change-feed?tabs=java
[Connect your Apache Spark application with Azure Event Hubs]: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-kafka-spark-tutorial
[Event Hubs pricing]: https://azure.microsoft.com/en-us/pricing/details/event-hubs/
[Quickstart: Build a Java app to manage Azure Cosmos DB Cassandra API data (v4 Driver)]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/manage-data-java-v4-sdk
[Quickstart: Data streaming with Event Hubs using the Kafka protocol]: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-quickstart-kafka-enabled-event-hubs
[Quickstart: Use Java and JDBC with Azure Database for PostgreSQL]: https://docs.microsoft.com/en-us/azure/postgresql/connect-java
[Running Apache Spark jobs on AKS]: https://docs.microsoft.com/en-us/azure/aks/spark-job
[Tutorial: Query data from a Cassandra API account in Azure Cosmos DB]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/query-data
