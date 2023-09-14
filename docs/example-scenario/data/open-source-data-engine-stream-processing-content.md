This article presents an example of a streaming solution that uses fully managed Azure data services. 

## Architecture

:::image type="content" source="./media/open-source-data-engine-stream-processing-architecture.svg" alt-text="Architecture diagram showing how streaming data flows through a system. Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components make up the system." border="false" lightbox="./media/open-source-data-engine-stream-processing-architecture.svg":::

Download a [Visio file][Visio version of architecture diagram] of this architecture.

### Workflow

1. The Event Hubs for Apache Kafka feature streams events from Kafka producers.

1. Apache Spark consumes events. AKS provides a managed environment for the Apache Spark jobs.

1. An application that uses Azure Cosmos DB for Apache Cassandra writes events to Cassandra. This database serves as a storage platform for events. AKS hosts the microservices that write to Cassandra.

1. The change feed feature of Azure Cosmos DB processes events in real time.

1. Scheduled applications run batch-oriented processing on events stored in Cassandra.

1. Stores of reference data enrich event information. Batch-oriented applications write the enriched event information to PostgreSQL. Typical reference data stores include:

   - [Azure Data Lake Storage][Introduction to Azure Data Lake Storage Gen2], which can store data in open formats such as [Parquet][Parquet].
   - Open-source relational data stores like [PostgreSQL][What is Azure Database for PostgreSQL?] and [MySQL][What is Azure Database for MySQL?].

1. A batch-oriented application processes Cassandra data. That application stores the processed data in Azure Database for PostgreSQL. This relational data store provides data to downstream applications that require enriched information.

1. Reporting applications and tools analyze the PostgreSQL database data. For example, [Power BI][What is Power BI?] connects to the database by using the Azure Database for PostgreSQL connector. This reporting service then displays rich visuals of the data.

1. Azure Cache for Redis provides an in-memory cache. In this solution, the cache contains data on critical events. An application stores data to the cache and retrieves data from the cache.

1. Websites and other applications use the cached data to improve response times. Sometimes data isn't available in the cache. In those cases, these applications use the [cache-aside pattern][Cache-Aside pattern] or a similar strategy to retrieve data from Cassandra in Azure Cosmos DB.

### Components

- [Event Hubs][Azure Event Hubs — A big data streaming platform and event ingestion service] is a fully managed streaming platform that can process millions of events per second. Event Hubs provides an [endpoint][Use Azure Event Hubs from Apache Kafka applications] for [Apache Kafka][Apache Kafka], a widely used open-source stream-processing platform. When organizations use the endpoint feature, they don't need to build and maintain Kafka clusters for stream processing. Instead, they can benefit from the fully managed Kafka implementation that Event Hubs offers.

- [Azure Cosmos DB][Welcome to Azure Cosmos DB] is a fully managed NoSQL and relational database that offers multi-master replication. Azure Cosmos DB supports open-source APIs for many databases, languages, and platforms. Examples include:

  - [Apache Cassandra][Apache Cassandra].
  - [Gremlin][The Gremlin Graph Traversal Machine and Language].
  - [MongoDB][MongoDB].

  Through the [Azure Cosmos DB for Apache Cassandra][Introduction to Azure Cosmos DB for Apache Cassandra], you can access Azure Cosmos DB data by using Apache Cassandra tools, languages, and drivers. Apache Cassandra is an open-source NoSQL database that's well suited for heavy write-intensive workloads.

- [AKS][Azure Kubernetes Service (AKS) marketing page] is a highly available, secure, and fully managed Kubernetes service. [Kubernetes][Kubernetes] is a rapidly evolving open-source platform for managing containerized workloads. [AKS][Azure Kubernetes Service] hosts open-source big data processing engines such as [Apache Spark][Apache Spark]. By using AKS, you can run large-scale stream processing jobs in a managed environment.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL marketing page] is a fully managed relational database service. It provides [high availability, elastic scaling, patching, and other management capabilities][What is Azure Database for PostgreSQL?] for PostgreSQL. [PostgreSQL][PostgreSQL] is a widely adopted open-source relational database management system.

- [Azure Cache for Redis][Azure Cache for Redis marketing page] provides an in-memory data store based on the Redis software. [Redis][Redis] is a popular open-source in-memory data store. Session stores, content caches, and other storage components use Redis to improve performance and scalability. [Azure Cache for Redis][About Azure Cache for Redis] provides open-source Redis capabilities as a fully managed offering.

### Alternatives

You can replace the open-source-compatible products and services in this solution with others. For details on open-source services available in Azure, see [Open source on Azure][Open source on Azure].

## Scenario details

Fully managed Azure data services that run open-source engines make up this streaming solution:

- Azure Event Hubs offers a [Kafka][Apache Kafka] implementation for stream ingestion.
- Azure Cosmos DB supports event storage in [Cassandra][Apache Cassandra].
- Azure Kubernetes Service (AKS) hosts [Kubernetes][Kubernetes] microservices for stream processing.
- Azure Database for PostgreSQL manages relational data storage in [PostgreSQL][PostgreSQL].
- Azure Cache for Redis manages [Redis][Redis] in-memory data stores.

Open-source technologies offer many benefits. For instance, organizations can use open-source technologies to:

- Migrate existing workloads.
- Tap into the broad open-source community.
- Limit vendor lock-in.

By making open-source technologies accessible, Azure tools and services help organizations take advantage of these benefits and develop the solutions of their choice.

This solution uses fully managed [platform as a service (PaaS)][What is PaaS?] services. As a result, Microsoft handles patching, service-level agreement (SLA) maintenance, and other management tasks. Another benefit is the native integration with the Azure security infrastructure.

### Potential use cases

This solution applies to various scenarios:

- Using Azure PaaS services to build modern streaming solutions that use open-source technologies
- Migrating open-source stream processing solutions to Azure

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Design and implement each service with best practices in mind. For guidelines on each service, see the [Microsoft documentation site](/). Also review the information in the following sections:

### Performance

- Implement [connection pooling for Azure Database for PostgreSQL][Performance best practices for using Azure Database for PostgreSQL – Connection Pooling]. You can use a connection pooling library within the application. Or you can use a connection pooler such as [PgBouncer][PgBouncer] or [Pgpool][Pgpool Wiki]. Establishing a connection with PostgreSQL is an expensive operation. With connection pooling, you can avoid degrading application performance. PgBouncer is [built-in][PgBouncer in Azure Database for PostgreSQL Flexible Server] in Azure Database for PostgreSQL Flexible Server.

- Configure Azure Cosmos DB for Apache Cassandra for best performance by using an appropriate [partitioning strategy][Partitioning in Azure Cosmos DB for Apache Cassandra]. Decide whether to use a single field primary key, a compound primary key, or a composite partition key when partitioning tables.

### Scalability

- Take your streaming requirements into account when choosing an [Event Hubs tier][Event Hubs pricing]:

  - For mid-range throughput requirements of less than 120 MBps, consider the [Premium tier][Overview of Event Hubs Premium (Preview)]. This tier scales elastically to meet streaming requirements.
  - For high-end streaming workloads with an ingress of gigabytes of data, consider the [Dedicated tier][Overview of Event Hubs Dedicated]. This tier is a single-tenant offering with a guaranteed capacity. You can scale dedicated clusters up and down.

- Consider [autoscale-provisioned throughput][Create Azure Cosmos containers and databases with autoscale throughput] for Azure Cosmos DB if your workloads are unpredictable and spiky. You can configure Azure Cosmos DB to use manually provisioned throughput or autoscale-provisioned throughput. With autoscale, Azure automatically and instantly scales the request units per second according to your usage.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Use [Azure Private Link][What is Azure Private Link?] to make Azure services part of your virtual network. When you use Private Link, traffic between the services and your network flows over the Azure backbone without traversing the public internet. The Azure services in this solution support Private Link for selected SKUs.

- Check your organization's security policies. With Azure Cosmos DB for Apache Cassandra, keys provide access to resources like key spaces and tables. The Azure Cosmos DB instance stores those keys. Your security policies might require you to [propagate those keys to a key management service][Secure Azure Cosmos keys using Azure Key Vault] such as [Azure Key Vault][About Azure Key Vault]. Also make sure to [rotate keys][Key rotation and regeneration] according to your organization's policies.

### Resiliency

Consider using [Availability zones][Availability Zones] to protect business-critical applications from datacenter failures. This solution's services support availability zones for selected SKUs in [availability zone–enabled regions][Azure regions with Availability Zones]. For up-to-date information, review the [list of services that support availability zones][Azure Services that support Availability Zones].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To estimate the cost of this solution, use the [Azure pricing calculator][Azure pricing calculator]. Also keep these points in mind:

- [Event Hubs][Event Hubs pricing] is available in Basic, Standard, Premium, and Dedicated tiers. The Premium or Dedicated tier is best for large-scale streaming workloads. You can scale throughput, so consider starting small and then scaling up as demand increases.
- [Azure Cosmos DB][Azure Cosmos DB pricing] offers two models:

  - A provisioned throughput model that's ideal for demanding workloads. This model is available in two capacity management options: standard and autoscale.
  - A serverless model that's well suited for running small, spiky workloads.

- An [AKS][Azure Kubernetes Service (AKS) pricing] cluster consists of a set of nodes, or virtual machines (VMs), that run in Azure. The cost of the compute, storage, and networking components make up a cluster's primary costs.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL pricing] is available in Single Server and Flexible Server tiers. Different tiers cater to different scenarios, such as predicable, burstable, and high-performance workloads. The costs mainly depend on the choice of compute nodes and storage capacity. For new workloads, consider choosing the Flexible Server tier since it has a wider range of [supported capabilities][Comparison between Single Server and Flexible Server] over the Single Server tier. 

- [Azure Cache for Redis][Azure Cache for Redis pricing] is available in multiple tiers. These tiers accommodate caches that range from 250 megabytes to several terabytes. Besides size, other requirements also affect the choice of tier:

  - Clustering
  - Persistence
  - Active geo-replication

## Deploy this scenario

Keep these points in mind when you deploy this solution:

- When you deploy Event Hubs for Kafka, refer to [Quickstart: Data streaming with Event Hubs using the Kafka protocol][Quickstart: Data streaming with Event Hubs using the Kafka protocol]. This article provides the following information:

  - How to send and receive messages with Kafka in Event Hubs
  - Sample code for a publishing application
  - How to switch existing Kafka applications to Event Hubs for Kafka by making configuration changes

- Concerning Apache Spark:

  - For information on building a basic Spark application, see [Connect your Apache Spark application with Azure Event Hubs][Connect your Apache Spark application with Azure Event Hubs].
  - To host the Spark application on AKS, see [Running Apache Spark jobs on AKS][Running Apache Spark jobs on AKS].

- Consider using a Java application to write events to Cassandra. For more information, see [Quickstart: Build a Java app to manage Azure Cosmos DB for Apache Cassandra data (v4 Driver)][Quickstart: Build a Java app to manage Azure Cosmos DB for Apache Cassandra data (v4 Driver)].

- When you use the [Azure Cosmos DB change feed][Change feed in Azure Cosmos DB], refer to [Change feed in Azure Cosmos DB for Apache Cassandra][Change feed in Azure Cosmos DB for Apache Cassandra] for this information:

  - How to use query predicates in [Cassandra Query Language (CQL)][The Cassandra Query Language (CQL)] to query the change feed API
  - Sample code for a Java application

- For information on processing the events that you've stored in Cassandra, refer to [Tutorial: Query data from Azure Cosmos DB for Apache Cassandra][Tutorial: Query data from Azure Cosmos DB for Apache Cassandra]. This article also contains sample Java code for using CQL commands to retrieve data from tables.

- For information on writing data to Azure Database for PostgreSQL with a batch-oriented application, see [Quickstart: Use Java and JDBC with Azure Database for PostgreSQL][Quickstart: Use Java and JDBC with Azure Database for PostgreSQL]. This article also contains sample Java code for storing data.

- For information on data storage and retrieval with Azure Cache for Redis, see [Quickstart: Use Azure Cache for Redis in Java][Quickstart: Use Azure Cache for Redis in Java]. This article also contains sample Java code for accessing a cache.

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Ajit Ananthram](https://www.linkedin.com/in/ajit-ananthram) | Cloud Solution Architect

## Next steps

- [Apache Kafka developer guide for Azure Event Hubs][Apache Kafka developer guide for Azure Event Hubs]
- [Frequently asked questions about Azure Cosmos DB for Apache Cassandra][Frequently asked questions about Azure Cosmos DB for Apache Cassandra]
- [Best practices for building an application with Azure Database for PostgreSQL][Best practices for building an application with Azure Database for PostgreSQL]
- [Azure Cache for Redis FAQ][Azure Cache for Redis FAQ]

## Related resources

To learn about related solutions, see the following information:

- [Analytics architecture design][Analytics architecture design]
- [Choose an analytical data store in Azure][Choose an analytical data store in Azure]
- [Choose a data analytics technology in Azure][Choose a data analytics technology in Azure]
- [Azure Kubernetes in event stream processing][Azure Kubernetes in event stream processing]
- [Data streaming with AKS][Data streaming with AKS]

[About Azure Cache for Redis]: /azure/azure-cache-for-redis/cache-overview
[About Azure Key Vault]: /azure/key-vault/general/overview
[Analytics architecture design]: ../../solution-ideas/articles/analytics-start-here.yml
[Apache Cassandra]: https://cassandra.apache.org/_/index.html
[Apache Kafka]: https://kafka.apache.org
[Apache Kafka developer guide for Azure Event Hubs]: /azure/event-hubs/apache-kafka-developer-guide
[Apache Spark]: https://spark.apache.org
[Availability Zones]: /azure/availability-zones/az-overview#availability-zones
[Azure Cache for Redis FAQ]: /azure/azure-cache-for-redis/cache-faq
[Azure Cache for Redis marketing page]: https://azure.microsoft.com/services/cache
[Azure Cache for Redis pricing]: https://azure.microsoft.com/pricing/details/cache
[Azure Cosmos DB pricing]: https://azure.microsoft.com/pricing/details/cosmos-db
[Azure Database for PostgreSQL marketing page]: https://azure.microsoft.com/services/postgresql
[Azure Database for PostgreSQL pricing]: https://azure.microsoft.com/pricing/details/postgresql/server
[Azure Event Hubs — A big data streaming platform and event ingestion service]: /azure/event-hubs/event-hubs-about
[Azure Kubernetes in event stream processing]: ../../solution-ideas/articles/serverless-event-processing-aks.yml
[Azure Kubernetes Service]: /azure/aks/intro-kubernetes
[Azure Kubernetes Service (AKS) marketing page]: https://azure.microsoft.com/services/kubernetes-service
[Azure Kubernetes Service (AKS) pricing]: https://azure.microsoft.com/pricing/details/kubernetes-service
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Azure regions with Availability Zones]: /azure/availability-zones/az-region#azure-regions-with-availability-zones
[Azure Services that support Availability Zones]: /azure/availability-zones/az-region
[Best practices for building an application with Azure Database for PostgreSQL]: /azure/postgresql/application-best-practices
[Cache-Aside pattern]: ../../patterns/cache-aside.yml
[The Cassandra Query Language (CQL)]: https://cassandra.apache.org/doc/latest/cassandra/cql/index.html
[Change feed in Azure Cosmos DB]: /azure/cosmos-db/change-feed
[Change feed in Azure Cosmos DB for Apache Cassandra]: /azure/cosmos-db/cassandra/cassandra-change-feed?tabs=java
[Choose an analytical data store in Azure]: ../../data-guide/technology-choices/analytical-data-stores.md
[Choose a data analytics technology in Azure]: ../../data-guide/technology-choices/analysis-visualizations-reporting.md
[Connect your Apache Spark application with Azure Event Hubs]: /azure/event-hubs/event-hubs-kafka-spark-tutorial
[Create Azure Cosmos containers and databases with autoscale throughput]: /azure/cosmos-db/provision-throughput-autoscale
[Data streaming with AKS]: ../../solution-ideas/articles/data-streaming-scenario.yml
[Event Hubs pricing]: https://azure.microsoft.com/pricing/details/event-hubs
[Frequently asked questions about Azure Cosmos DB for Apache Cassandra]: /azure/cosmos-db/cassandra/cassandra-faq
[The Gremlin Graph Traversal Machine and Language]: https://tinkerpop.apache.org/gremlin.html
[Introduction to Azure Cosmos DB for Apache Cassandra]: /azure/cosmos-db/cassandra/cassandra-introduction
[Introduction to Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-introduction
[Key rotation and regeneration]: /azure/cosmos-db/secure-access-to-data?tabs=using-primary-key#key-rotation
[Kubernetes]: https://kubernetes.io
[MongoDB]: https://www.mongodb.com
[Open source on Azure]: https://azure.microsoft.com/overview/open-source/
[Overview of Event Hubs Dedicated]: /azure/event-hubs/event-hubs-dedicated-overview
[Overview of Event Hubs Premium (Preview)]: /azure/event-hubs/event-hubs-premium-overview
[Parquet]: https://parquet.apache.org
[Partitioning in Azure Cosmos DB for Apache Cassandra]: /azure/cosmos-db/cassandra/cassandra-partitioning
[Performance best practices for using Azure Database for PostgreSQL – Connection Pooling]: https://azure.microsoft.com/blog/performance-best-practices-for-using-azure-database-for-postgresql-connection-pooling
[PgBouncer]: https://www.pgbouncer.org
[Pgpool Wiki]: https://www.pgpool.net/mediawiki/index.php/Main_Page
[PostgreSQL]: https://www.postgresql.org
[Quickstart: Build a Java app to manage Azure Cosmos DB for Apache Cassandra data (v4 Driver)]: /azure/cosmos-db/cassandra/manage-data-java-v4-sdk
[Quickstart: Data streaming with Event Hubs using the Kafka protocol]: /azure/event-hubs/event-hubs-quickstart-kafka-enabled-event-hubs
[Quickstart: Use Azure Cache for Redis in Java]: /azure/azure-cache-for-redis/cache-java-get-started
[Quickstart: Use Java and JDBC with Azure Database for PostgreSQL]: /azure/postgresql/flexible-server/connect-java?tabs=passwordless
[Redis]: https://redis.io
[Running Apache Spark jobs on AKS]: /azure/aks/spark-job
[Secure Azure Cosmos keys using Azure Key Vault]: /azure/cosmos-db/access-secrets-from-keyvault
[Tutorial: Query data from Azure Cosmos DB for Apache Cassandra]: /azure/cosmos-db/cassandra/query-data
[Use Azure Event Hubs from Apache Kafka applications]: /azure/event-hubs/event-hubs-for-kafka-ecosystem-overview
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1874059-open-source-data-engine-stream-processing-architecture.vsdx
[Welcome to Azure Cosmos DB]: /azure/cosmos-db/introduction
[What is Azure Database for MySQL?]: /azure/mysql/overview
[What is Azure Database for PostgreSQL?]: /azure/postgresql/overview
[What is Azure Private Link?]: /azure/private-link/private-link-overview
[What is PaaS?]: https://azure.microsoft.com/overview/what-is-paas/
[What is Power BI?]: /power-bi/fundamentals/power-bi-overview
[Comparison between Single Server and Flexible Server]: /azure/postgresql/flexible-server/concepts-compare-single-server-flexible-server#comparison-table
[PgBouncer in Azure Database for PostgreSQL Flexible Server]: /azure/postgresql/flexible-server/concepts-pgbouncer
