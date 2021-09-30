This article presents an example of a streaming solution. Fully managed Azure data services that run open-source engines make up the solution:

- Azure Event Hubs offers a [Kafka][Apache Kafka] implementation for stream ingestion.
- Azure Cosmos DB supports event storage in [Cassandra][Apache Cassandra].
- Azure Kubernetes Service (AKS) hosts [Kubernetes][Kubernetes] microservices for stream processing.
- Azure Database for PostgreSQL manages relational data storage in [PostgreSQL][PostgreSQL].
- Azure Cache for Redis manages [Redis][Redis] in-memory data stores.

Azure tools and services help organizations take advantage of open-source technology benefits. For instance, organizations can use open-source technologies to:

- Migrate existing workloads.
- Tap into the broad open-source community.
- Limit vendor lock-in.

With access to open-source technologies, organizations can develop the solutions of their choice. Microsoft handles patching, service-level agreement (SLA) maintenance, and other management tasks. This architecture uses fully managed platform as a service (PaaS) services. As a result, organizations also benefit from the native integration with Azure's security infrastructure.

## Potential use cases

This solution applies to various scenarios:

- Using Azure PaaS services to build modern streaming solutions that use open-source technologies
- Migrating existing stream processing solutions that use open-source technologies to Azure

## Architecture

:::image type="content" source="./media/open-source-data-engine-stream-processing-architecture.svg" alt-text="Architecture diagram showing how streaming data flows through a solution that includes Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components." border="false":::

Download a [Visio file][Visio version of architecture diagram] of this architecture.

1. Event Hubs for Kafka streams events from Kafka producers.

1. Apache Spark consumes events. AKS provides a managed environment for the Apache Spark jobs.

1. An application that uses the Cassandra API for Azure Cosmos DB writes events to Cassandra. This database serves as a storage platform for events. AKS hosts the microservices that write to Cassandra.

1. The change feed feature of Azure Cosmos DB processes events in real-time.

1. Batch processes run on events stored in Cassandra.

1. Reference data stores enrich event information. Batch-oriented applications write the enriched event information to PostgreSQL. Typical reference data stores include:

   - Azure Data Lake Storage, which can store data in open formats such as Parquet.
   - Open-source relational data stores like PostgreSQL and MySQL.

1. A batch-oriented application processes Cassandra data and stores the processed data in Azure Database for PostgreSQL. This relational data store provides data to downstream applications that require enriched information.

1. Reporting applications and tools analyze the PostgreSQL database data. For example, Power BI can connect to the database by using the Azure Database for PostgreSQL connector. This reporting service can then display rich visuals of the data.

1. Azure Cache for Redis provides an in-memory cache. In this solution, the cache stores contains critical events that applications like websites need to access quickly. An application stores and retrieves data from the cache.

1. Applications like websites use the cached data to improve responsiveness. When data's not available in the cache, websites retrieve data from Cassandra in Azure Cosmos DB by using the [cache-aside pattern][Cache-Aside pattern] or a similar strategy.

### Components

- [Event Hubs][Azure Event Hubs — A big data streaming platform and event ingestion service] is a fully managed streaming platform that can process millions of events per second. Event Hubs provides an [endpoint][Use Azure Event Hubs from Apache Kafka applications] for [Apache Kafka][Apache Kafka], a widely used open-source stream-processing platform. By using the endoint feature, organizations no longer need to build and maintain Kafka clusters for stream processing. Instead, they can benefit from the fully managed Kafka implementation that Event Hubs offers.

- [Azure Cosmos DB][Welcome to Azure Cosmos DB] is a multi-model NoSQL database that offers multi-master replication. Azure Cosmos DB supports open-source APIs for many databases, languages, and platforms. Examples include:

  - [Apache Cassandra][Apache Cassandra]
  - [Gremlin][The Gremlin Graph Traversal Machine and Language]
  - [MongoDB][MongoDB]

  Through the [Cassandra API][Introduction to the Azure Cosmos DB Cassandra API], you can access Azure Cosmos DB data by using Apache Cassandra tools, languages, and drivers. Apache Cassandra is an open-source NoSQL database that's well suited for heavy write-intensive workloads.

- [AKS][Azure Kubernetes Service (AKS) marketing page] is a highly available, secure, and fully managed Kubernetes service. [Kubernetes][Kubernetes] is a rapidly evolving open-source platform for managing containerized workloads. [AKS][Azure Kubernetes Service] hosts open-source big data processing engines such as [Apache Spark][Apache Spark]. By using AKS, you can run large-scale stream processing jobs in a managed environment.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL marketing page] is a fully managed relational database service. It provides [high availability, elastic scaling, patching, and other management capabilities for PostgreSQL][What is Azure Database for PostgreSQL?]. [PostgreSQL][PostgreSQL] is a widely adopted open-source relational database management system.

- [Azure Cache for Redis][Azure Cache for Redis marketing page] provides an in-memory data store based on the Redis software. [Redis][Redis] is a popular open-source in-memory data store. Session stores, content caches, and other storage components use Redis to improve performance and scalability. [Azure Cache for Redis][About Azure Cache for Redis] provides open-source Redis capabilities as a fully managed offering.

### Alternatives

You can substitute other open-source-compatible products and services for the ones in this solution. For details on open-source services available in Azure, see [Open source on Azure][Open source on Azure].

## Considerations

Design and implement each service with best practices in mind. For guidelines on each service, see [Microsoft Docs][Microsoft Docs]. Also review the information in the following sections:

### Performance considerations

- Implement [connection pooling for Azure Database for PostgreSQL][Performance best practices for using Azure Database for PostgreSQL – Connection Pooling]. You can use a connection pooling library within the application. Or you can use a connection pooler such as [PgBouncer][PgBouncer] or [Pgpool][Pgpool Wiki]. Establishing a connection with PostgreSQL is an expensive operation. With connection pooling, you can avoid degrading application performance.

- Configure Azure Cosmos DB Cassandra API for optimum performance by using an appropriate [partitioning strategy][Partitioning in Azure Cosmos DB Cassandra API]. Decide whether to use a single field primary key, a compound primary key, or a composite partition key when partitioning tables.

### Scalability considerations

- Take your streaming requirements into account when choosing an [Event Hubs tier][Event Hubs pricing]:

  - For mid-range throughput requirements of less than 120 MBps, consider the [Premium tier][Overview of Event Hubs Premium (Preview)]. This tier scales elastically to meet streaming requirements.
  - For high-end streaming workloads with an ingress of gigabytes of data, consider the [Dedicated tier][Overview of Event Hubs Dedicated]. This tier is a single-tenant offering with a guaranteed capacity. You can scale dedicated clusters up and down.

- You can configure Azure Cosmos DB to use manually provisioned throughput or [autoscale-provisioned throughput][Create Azure Cosmos containers and databases with autoscale throughput]. With autoscale, Azure Cosmos DB automatically and instantly scales the request units per second according to your usage. Consider using autoscale for unpredictable, spiky workloads.

### Security considerations

- [Azure Private Link][What is Azure Private Link?] makes Azure services part of your virtual network. When you use Private Link, traffic between the network and the services flows over the Azure backbone without traversing the public internet. The Azure services in this solution support Private Link for selected SKUs.

- With Azure Cosmos DB Cassandra API, you use keys to access resources like keyspaces and tables. The Azure Cosmos DB instance stores those keys. Check whether your organization's security policies require you to [propagate those keys to a key management service][Secure Azure Cosmos keys using Azure Key Vault] such as [Azure Key Vault][About Azure Key Vault]. Also make sure to [rotate keys][Key rotation and regeneration] according to your organization's policies.

### Resiliency considerations

[Availability zones][Availability Zones] protect business-critical applications from datacenter failures. For selected SKUs, this solution's services support availability zones in [availability zone–enabled regions][Azure regions with Availability Zones]. For up-to-date information, review the [list of services that support availability zones][Azure Services that support Availability Zones].

## Deploy the solution

Keep these points in mind when you deploy this solution:

- When you deploy Event Hubs for Kafka, refer to [Quickstart: Data streaming with Event Hubs using the Kafka protocol][Quickstart: Data streaming with Event Hubs using the Kafka protocol]. This article provides the following information:

  - How to send and receive messages with Kafka in Event Hubs
  - Sample code for a publishing application
  - How to switch existing Kafka applications to Event Hubs for Kafka by making configuration changes

- Concerning Apache Spark:

  - For information on building a simple Spark application, see [Connect your Apache Spark application with Azure Event Hubs][Connect your Apache Spark application with Azure Event Hubs].
  - To host the Spark application on AKS, see [Running Apache Spark jobs on AKS][Running Apache Spark jobs on AKS].

- Consider using a Java application to write events to Cassandra. For more information, see [Quickstart: Build a Java app to manage Azure Cosmos DB Cassandra API data (v4 Driver)][Quickstart: Build a Java app to manage Azure Cosmos DB Cassandra API data (v4 Driver)].

- When you use the Azure Cosmos DB change feed, refer to [Change feed in the Azure Cosmos DB API for Cassandra][Change feed in the Azure Cosmos DB API for Cassandra] for this information:

  - How to use query predicates in Cassandra Query Language (CQL) to query the change feed API
  - Sample code for a Java application

- For information on processing the events that you've stored in Cassandra, refer to [Tutorial: Query data from a Cassandra API account in Azure Cosmos DB][Tutorial: Query data from a Cassandra API account in Azure Cosmos DB]. This article also contains sample Java code for using CQL commands to retrieve data from tables.

- For information on using a batch-oriented application to write data to Azure Database for PostgreSQL, see [Quickstart: Use Java and JDBC with Azure Database for PostgreSQL][Quickstart: Use Java and JDBC with Azure Database for PostgreSQL]. This article also contains sample Java code for storing data.

- For information on storing and retrieving data from Azure Cache for Redis, see [Quickstart: Use Azure Cache for Redis in Java][Quickstart: Use Azure Cache for Redis in Java]. This article also contains sample Java code for accessing a cache.

## Pricing

To estimate the cost of this solution, use the [Azure pricing calculator][Azure pricing calculator]. Also keep these points in mind:

- [Event Hubs][Event Hubs pricing] is available in Basic, Standard, Premium, and Dedicated tiers. The Premium or Dedicated tier is usually best for large-scale streaming workloads. You can scale up throughput, so consider starting small and then scaling up as demand increases.
- [Azure Cosmos DB][Azure Cosmos DB pricing] offers two models:

  - A provisioned throughput model that's ideal for demanding workloads. This model is available in two capacity management options: standard and autoscale.
  - A serverless model that's better suited to run small, spiky workloads.

- An [AKS][Azure Kubernetes Service (AKS) pricing] cluster consists of a set of nodes, or virtual machines (VMs), that run in Azure. The cost of the compute, storage, and networking components make up a cluster's primary costs.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL pricing] is available in Single Server, Flexible Server, and Hyperscale (Citus) tiers. Different tiers cater to different scenarios, such as predicable, burstable, and high-performance workloads. The costs mainly depend on the choice of compute nodes and storage capacity.

- [Azure Cache for Redis][Azure Cache for Redis pricing] is available in multiple tiers to suit caches ranging from 250 megabytes to several terabytes. Requirements such as the need for clustering, persistence, and active geo-replication also affect the choice of tier.

## Next steps

- [Apache Kafka developer guide for Azure Event Hubs][Apache Kafka developer guide for Azure Event Hubs]
- [Frequently asked questions about the Cassandra API in Azure Cosmos DB][Frequently asked questions about the Cassandra API in Azure Cosmos DB]
- [Best practices for building an application with Azure Database for PostgreSQL][Best practices for building an application with Azure Database for PostgreSQL]
- [Azure Cache for Redis FAQ][Azure Cache for Redis FAQ]

## Related resources

To learn about related solutions, see the following information:

### Analytics overview

[Analytics architecture design][Analytics architecture design]

### Related architecture guides

- [Choose an analytical data store in Azure][Choose an analytical data store in Azure]
- [Choose a data analytics technology in Azure][Choose a data analytics technology in Azure]

### Reference architectures

- [Azure Kubernetes in event stream processing][Azure Kubernetes in event stream processing]
- [Data streaming with AKS][Data streaming with AKS]
- [Build web and mobile applications][Build web and mobile applications]

[About Azure Cache for Redis]: https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview
[About Azure Key Vault]: https://docs.microsoft.com/en-us/azure/key-vault/general/overview
[Analytics architecture design]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/analytics-start-here
[Apache Cassandra]: https://cassandra.apache.org/_/index.html
[Apache Kafka]: https://kafka.apache.org/
[Apache Kafka developer guide for Azure Event Hubs]: https://docs.microsoft.com/en-us/azure/event-hubs/apache-kafka-developer-guide
[Apache Spark]: https://spark.apache.org/
[Availability Zones]: https://docs.microsoft.com/en-us/azure/availability-zones/az-overview#availability-zones
[Azure Cache for Redis FAQ]: https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-faq
[Azure Cache for Redis marketing page]: https://azure.microsoft.com/en-us/services/cache/
[Azure Cache for Redis pricing]: https://azure.microsoft.com/pricing/details/cache/
[Azure Cosmos DB pricing]: https://azure.microsoft.com/en-us/pricing/details/cosmos-db/
[Azure Database for PostgreSQL marketing page]: https://azure.microsoft.com/en-us/services/postgresql/
[Azure Database for PostgreSQL pricing]: https://azure.microsoft.com/pricing/details/postgresql/server/
[Azure Event Hubs — A big data streaming platform and event ingestion service]: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about
[Azure Kubernetes in event stream processing]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/serverless-event-processing-aks
[Azure Kubernetes Service]: https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes
[Azure Kubernetes Service (AKS) marketing page]: https://azure.microsoft.com/en-us/services/kubernetes-service/
[Azure Kubernetes Service (AKS) pricing]: https://azure.microsoft.com/en-us/pricing/details/kubernetes-service/
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Azure regions with Availability Zones]: https://docs.microsoft.com/en-us/azure/availability-zones/az-region#azure-regions-with-availability-zones
[Azure Services that support Availability Zones]: https://docs.microsoft.com/en-us/azure/availability-zones/az-region
[Best practices for building an application with Azure Database for PostgreSQL]: https://docs.microsoft.com/en-us/azure/postgresql/application-best-practices
[Build web and mobile applications]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/webapps
[Cache-Aside pattern]: https://docs.microsoft.com/en-us/azure/architecture/patterns/cache-aside
[Change feed in the Azure Cosmos DB API for Cassandra]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/cassandra-change-feed?tabs=java
[Choose an analytical data store in Azure]: https://docs.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/analytical-data-stores
[Choose a data analytics technology in Azure]: https://docs.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/analysis-visualizations-reporting
[Connect your Apache Spark application with Azure Event Hubs]: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-kafka-spark-tutorial
[Create Azure Cosmos containers and databases with autoscale throughput]: https://docs.microsoft.com/en-us/azure/cosmos-db/provision-throughput-autoscale
[Data streaming with AKS]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/data-streaming-scenario
[Event Hubs pricing]: https://azure.microsoft.com/en-us/pricing/details/event-hubs/
[Frequently asked questions about the Cassandra API in Azure Cosmos DB]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/cassandra-faq
[The Gremlin Graph Traversal Machine and Language]: https://tinkerpop.apache.org/gremlin.html
[Introduction to the Azure Cosmos DB Cassandra API]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/cassandra-introduction
[Key rotation and regeneration]: https://docs.microsoft.com/en-us/azure/cosmos-db/secure-access-to-data?tabs=using-primary-key#key-rotation
[Kubernetes]: https://kubernetes.io/
[Microsoft Docs]: https://docs.microsoft.com
[MongoDB]: https://www.mongodb.com/
[Open source on Azure]: https://azure.microsoft.com/en-au/overview/open-source/
[Overview of Event Hubs Dedicated]: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-dedicated-overview
[Overview of Event Hubs Premium (Preview)]: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-premium-overview
[Partitioning in Azure Cosmos DB Cassandra API]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/cassandra-partitioning
[Performance best practices for using Azure Database for PostgreSQL – Connection Pooling]: https://azure.microsoft.com/en-us/blog/performance-best-practices-for-using-azure-database-for-postgresql-connection-pooling/
[PgBouncer]: https://www.pgbouncer.org/
[Pgpool Wiki]: https://www.pgpool.net/mediawiki/index.php/Main_Page
[PostgreSQL]: https://www.postgresql.org/
[Quickstart: Build a Java app to manage Azure Cosmos DB Cassandra API data (v4 Driver)]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/manage-data-java-v4-sdk
[Quickstart: Data streaming with Event Hubs using the Kafka protocol]: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-quickstart-kafka-enabled-event-hubs
[Quickstart: Use Azure Cache for Redis in Java]: https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-java-get-started
[Quickstart: Use Java and JDBC with Azure Database for PostgreSQL]: https://docs.microsoft.com/en-us/azure/postgresql/connect-java
[Redis]: https://redis.io/
[Running Apache Spark jobs on AKS]: https://docs.microsoft.com/en-us/azure/aks/spark-job
[Secure Azure Cosmos keys using Azure Key Vault]: https://docs.microsoft.com/en-us/azure/cosmos-db/access-secrets-from-keyvault
[Tutorial: Query data from a Cassandra API account in Azure Cosmos DB]: https://docs.microsoft.com/en-us/azure/cosmos-db/cassandra/query-data
[Use Azure Event Hubs from Apache Kafka applications]: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1874059-open-source-data-engine-stream-processing-architecture.vsdx
[Welcome to Azure Cosmos DB]: https://docs.microsoft.com/en-us/azure/cosmos-db/introduction
[What is Azure Database for PostgreSQL?]: https://docs.microsoft.com/en-us/azure/postgresql/overview
[What is Azure Private Link?]: https://docs.microsoft.com/en-us/azure/private-link/private-link-overview
