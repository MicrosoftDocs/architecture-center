Data-driven enterprises need to keep their back-end and analytics systems in near real-time sync with customer-facing applications. The effects of transactions, updates, and changes must reflect accurately through end-to-end processes, related applications, and online transaction processing (OLTP) systems. The tolerable latency for changes in OLTP applications to reflect in the downstream systems that use the data might only be a few minutes.

This article describes an end-to-end solution for near real-time data processing to keep lakehouse data in sync. The solution uses Azure Event Hubs, Azure Synapse Analytics, and Azure Data Lake Storage for data processing and analytics.

> [!NOTE]
> You can implement a similar architecture by using Microsoft Fabric, which provides a unified software as a service (SaaS) platform for data ingestion, transformation, storage, and analytics. In this case, Fabric replaces the Azure Synapse Analytics components of the architecture and provides integrated capabilities for real-time data processing and analysis. For more information, see [Fabric Real-Time Intelligence](/fabric/real-time-intelligence/overview).

*Apache® and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="complex" border="false" source="media/real-time-lakehouse-data-processing/azure-near-realtime-data-processing.svg" alt-text="A diagram that shows the dataflow for the end-to-end data processing solution." lightbox="media/real-time-lakehouse-data-processing/azure-near-realtime-data-processing.svg":::
   The diagram shows streaming data sources like mobile apps and customer-facing applications flowing through OLTP databases to Debezium connectors that extract and send events. These connectors feed into Event Hubs. From Event Hubs, data flows in two directions: directly to Azure Synapse Analytics Spark pools for structured stream processing or to Data Lake Storage as a landing zone for raw data storage. Batch data sources like partner datasets and File Transfer Protocol (FTP) also connect to Azure Synapse Analytics pipelines via Data Lake Storage. Data Lake Storage passes the data to Azure Synapse Analytics pipelines for processing. From the validated data zone, processed data loads into Azure Synapse Analytics Spark pools to dedicated SQL pools, Azure Cosmos DB, or Azure AI Search. The dedicated SQL pools connect to Power BI to create dashboards and reports. Azure Cosmos DB and AI Search connect to APIs for downstream consumption. Validated data also flows from Data Lake Storage to Azure Machine Learning for model training and deployment or to Azure Synapse Analytics serverless SQL pools to be passed to customers for analysis.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-near-realtime-data-processing.vsdx) of this architecture.*

### Dataflow

1. Change data capture (CDC) is a prerequisite for source systems to listen to changes. [Debezium connectors](https://debezium.io/documentation/reference/stable/connectors/index.html) can connect to different source systems and tap into changes as they happen. The connectors can capture changes and produce events from various relational database management systems (RDBMS). Installing a Debezium connector requires a Kafka connect system.

1. The connectors extract change data and send the captured events to Event Hubs. Event Hubs can receive large amounts of data from multiple sources.

1. Event Hubs directly streams the data to Azure Synapse Analytics Spark pools or sends the data to a Data Lake Storage landing zone in raw format.

1. Other batch data sources can use Azure Synapse Analytics pipelines to copy data to Data Lake Storage and make it available for processing. An end-to-end extract, transform, and load (ETL) workflow might need to chain different steps or add dependencies between steps. Azure Synapse Analytics pipelines can orchestrate workflow dependencies within the overall processing framework.

1. Azure Synapse Analytics Spark pools use fully supported Apache Spark structured streaming APIs to process data in the Spark Streaming framework. The data processing step incorporates data quality checks and high-level business rule validations.

1. Data Lake Storage stores the validated data in the open [Delta Lake](https://docs.delta.io/latest/delta-intro.html) format. Delta Lake provides atomicity, consistency, isolation, and durability (ACID) semantics and transactions, scalable metadata handling, and unified streaming and batch data processing for existing data lakes.

   Using indexes for query acceleration improves Delta Lake performance. Data from the Data Lake Storage validated zone can also be a source for further advanced analytics and machine learning.

1. Data from the Data Lake Storage validated zone, transformed and enriched with more rules into its final processed state, loads to a dedicated SQL pool for running large-scale analytical queries.

1. Power BI uses the data that's exposed through the dedicated SQL pool to build enterprise-grade dashboards and reports.

1. You can also use captured raw data in Data Lake Store and the validated data in the Delta format for the following tasks:

   - Unplanned and exploratory analysis through Azure Synapse Analytics serverless SQL pools

   - Machine learning model training and deployment through Azure Machine Learning

1. For some low-latency interfaces, data must be denormalized for single-digit server latencies. This use case is mainly for API responses. This scenario queries documents in a NoSQL datastore such as Azure Cosmos DB for single-digit millisecond responses.

1. The Azure Cosmos DB partitioning strategy might not efficiently support all query patterns. If that's the case, you can augment the solution by indexing the data that the APIs need to access with Azure AI Search. Azure Cosmos DB and AI Search can fulfill most scenarios that require low-latency query responses. For example, a retail application stores product catalog data in Azure Cosmos DB but needs full-text search capabilities and flexible indexing. AI Search can index the data and provide advanced search features like autocomplete, synonyms, and semantic ranking. These features are useful when Azure Cosmos DB indexing limitations restrict complex search scenarios.

### Components

This solution uses the following Azure components:

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a managed, distributed ingestion service that can scale to ingest large amounts of data. By using the Event Hubs publisher-subscriber mechanism, different applications can send messages to Event Hubs topics, and downstream consumers can connect to and process those messages. The Event Hubs capture feature can write messages to Data Lake Storage in Avro format as they arrive. This ability enables easy micro-batch processing and long-term retention scenarios. Event Hubs also provides a Kafka-compatible API and supports schema registry. In this architecture, Event Hubs receives CDC events from multiple sources and distributes them to downstream consumers.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a scalable and secure data lake solution. It forms the storage subsystem that stores all data in raw and validated formats. In this architecture, Data Lake Storage handles transactions at scale and supports different file formats and sizes. Hierarchical namespaces help organize data into a familiar folder structure and support Portable Operating System Interface for Unix (POSIX) permissions. The Azure Blob Filesystem (ABFS) driver provides a Hadoop-compatible API.

- [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is a limitless analytics service that combines data integration, enterprise data warehousing, and big data analytics. This solution uses the following features of the Azure Synapse Analytics ecosystem:

  - [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview) are clusters that provide an on-demand Spark runtime that adds built-in performance enhancements to open-source Spark. In this architecture, customers can configure flexible autoscale settings, submit jobs remotely through the Apache Livy endpoint, and use the Synapse Studio notebook interface for interactive experiences.

  - [Azure Synapse Analytics serverless SQL pools](/azure/synapse-analytics/sql/on-demand-workspace-overview) are a query-on-demand feature that provides an interface for querying lakehouse data using familiar T-SQL syntax. There's no infrastructure to set up, and the Azure Synapse Analytics workspace deployment automatically creates the endpoint. In this architecture, Azure Synapse Analytics serverless SQL pools enable basic discovery and exploration of data in place for unplanned query analysis.

  - [Azure Synapse Analytics dedicated SQL pools](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) are provisioned data warehousing resources. They store data in relational tables by using columnar storage. In this architecture, Dedicated SQL pools use a scale-out architecture to distribute data processing across multiple nodes. PolyBase queries bring the data into SQL pool tables. The tables can connect to Power BI for analysis and reporting.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a business analytics service that provides a visual interface to create and access reports and dashboards. Power BI Desktop can connect to various data sources, combine the sources into a data model, and build reports or dashboards. In this architecture, you can use Power BI to transform data based on business requirements and share visuals and reports with customers.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed NoSQL database service. This solution uses Azure Cosmos DB for applications that require single-digit millisecond response times and high availability. Azure Cosmos DB provides multiple-region writes across all Azure regions.

- [AI Search](/azure/search/search-what-is-azure-search) is an AI-powered platform as a service (PaaS) that enables developers to build rich search experiences for their applications and websites. Use AI Search in this solution when the Azure Cosmos DB indexing model is too rigid for advanced search scenarios. AI Search enables flexible querying with features like typo tolerance, autocomplete, semantic ranking, and synonym matching. You can query indexed data by using a REST API or the .NET SDK. If you need to retrieve data from multiple indexes, you can either consolidate them into a single index or use [complex data types](/azure/search/search-howto-complex-data-types) to model nested structures.

## Scenario details

The end-to-end workflow to process changes in near real-time requires:

- A CDC technology. The OLTP applications might have different back-end data stores, such as SQL Server, MySQL, and Oracle. The first step is to listen to changes as they happen, and propagate them forward.

- An ingestion buffer to publish the change events at scale. This service should have the ability to handle large amounts of data as messages arrive. Individual subscribers can connect to this system and process the data.

- Distributed and scalable storage for data as-is in a raw format.

- A distributed, efficient stream processing system that lets users restart and manage state.

- An analytics system that runs at scale to power business decisions.

- A self-serve analytics interface.

- For low-latency API responses, a NoSQL database to store denormalized representations of the data.

- For some cases, a system to index data, refresh the index at regular intervals, and make the latest data available for downstream consumption.

All of the preceding technologies should use relevant security constructs for perimeter security, authentication, authorization, and data encryption.

### Potential use cases

This solution suits the following use cases:

- Industries that need to propagate changes from OLTP to online analytics processing (OLAP).

- Applications that require data transformation or enrichment.

The real-time data processing scenario is especially important for financial services industries. For example, if an insurance, credit card, or bank customer makes a payment and then immediately contacts customer service, the customer support agent needs to have the latest information.

Similar scenarios apply to the retail, commerce, and healthcare sectors. Enabling these scenarios streamlines operations and leads to greater organizational productivity and increased customer satisfaction.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Event Hubs provides 90-day data retention on the premium and dedicated tiers. For failover scenarios, you can set up a secondary namespace in the paired region and activate it during failover. Enable zone redundancy to ensure resilience against datacenter failures. You can use the Event Hubs capture feature to persist data to Data Lake Storage for replay and recovery scenarios.

- Azure Synapse Analytics Spark pool jobs are recycled every seven days as nodes are taken down for maintenance. Consider this activity as you work through the service-level agreements (SLAs) tied to the system. This limitation isn't a problem for many scenarios where the recovery time objective (RTO) is around 15 minutes. Ensure autoscaling is configured to handle load spikes and node failures.

- Use dedicated SQL pools that have geo-backup and zone-redundant storage (ZRS) to protect against regional and zonal outages.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- You can select from different Event Hubs tiers based on workload characteristics. Event Hubs bills capture storage separately based on the amount of data that's stored on Data Lake Storage.

- Consider object life cycle management through tiers on Data Lake Storage. As data ages, you can move data from a hot tier, where you need to access recent data for analytics, to a cold storage tier that costs less. The cold storage tier is a cost-effective option for long-term retention.

- You can pause the dedicated SQL pool when you're not using it in your development or test environments. You can schedule a script to pause the pool as needed, or you can pause the pool manually through the portal.

- For Azure Synapse Analytics Spark pools, use autoscaling to dynamically allocate resources based on workload demand and to avoid overprovisioning. Choose the smallest pool size that meets performance needs and use automatic termination settings to promptly shut down idle pools. Optimize Spark jobs by minimizing shuffle operations, caching intermediate results, and tuning partition sizes to reduce run time and resource consumption. Monitor usage by using Azure Synapse Analytics monitoring tools and adjust configurations based on job performance and cost trends.

- To optimize cost efficiency in Azure Cosmos DB, tailor your indexing policies to include only necessary paths, which reduces storage and request unit (RU) consumption. Choose the appropriate API and consistency level to match workload needs without overprovisioning. Use autoscale throughput to dynamically adjust RUs based on demand, and consolidate workloads into fewer containers when possible to minimize overhead. Regularly monitor usage by using Microsoft Cost Management and set alerts to avoid unexpected charges.

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate pricing.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- You can scale Event Hubs through partitioning, which distributes events across multiple parallel logs (partitions) to increase throughput. To preserve the order of related events, such as events from the same customer or device, use a consistent [partition key](/azure/event-hubs/event-hubs-features#mapping-of-events-to-partitions) when you publish events. This practice ensures that all related events are routed to the same partition, where Event Hubs maintains their order. Tune throughput units (TUs) based on expected event volume. Use the capture feature to write directly to Data Lake Storage in Avro or Parquet format for efficient downstream processing.

- You can set up Azure Synapse Analytics Spark pools with small, medium, or large virtual machine (VM) SKUs based on the workload. You can also configure autoscale on Azure Synapse Analytics Spark pools to account for activity spikes in workloads. If you need more compute resources, the clusters automatically scale up to meet the demand and scale down after processing completes.

- Delta Lake plays a central role in ensuring high-performance, reliable, and scalable data processing in this architecture:

   - Enable the auto optimize and auto compaction features in Delta Lake to automatically manage small files and optimize data layout during write operations. These features are ideal for streaming or frequent micro-batch ingestion scenarios because they reduce the need for manual intervention.

   - Use `OPTIMIZE` to manually compact small files into larger ones. This practice is especially useful when you want to improve read efficiency and reduce metadata overhead after streaming ingestion creates many small files.

   - Use `OPTIMIZE` with `ZORDER BY` on frequently queried columns, such as timestamps or customer IDs, to colocate related data. This query improves query performance by reducing the amount of data that's scanned during reads.

- To optimize performance in dedicated SQL pools for near real-time analytics, do the following tasks:

   - Use appropriate distribution methods like hash, round-robin, replicated methods.
   - Partition large tables by time or region to improve query pruning.
   - Use materialized views and result set caching for frequently accessed data.
   - Maintain up-to-date statistics and indexes to run queries efficiently. 
   - Assign resource classes to manage memory and concurrency.
   - Monitor performance by using built-in tools like SQL Insights and Dynamic Management Views (DMVs). 
   
   These practices help ensure low-latency, high-throughput performance in large-scale analytical workloads.

- To optimize Azure Cosmos DB for performance in real-time analytics scenarios, configure appropriate indexing policies to reduce query latency and storage overhead, and choose the right consistency level to balance performance with data accuracy. Use partitioning effectively to distribute workloads evenly and avoid hot partitions. Enable multiple-region writes for low-latency global access and monitor throughput by using RUs to scale dynamically based on demand. These practices help ensure responsive, scalable performance for high-ingestion, low-latency workloads.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Pratima Valavala](https://www.linkedin.com/in/pratimavalavala) | Cloud Solution Architect

Other contributor:

- [Rajesh Mittal](https://www.linkedin.com/in/rajeshmittalpmp) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Scalability with Event Hubs](/azure/event-hubs/event-hubs-scalability)
- [Index data from Azure Cosmos DB](/azure/search/search-howto-index-cosmosdb)
- [Best practices for dedicated SQL pools](/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool)
- [Best practices for serverless SQL pools](/azure/synapse-analytics/sql/best-practices-serverless-sql-pool)
- [Build data analytics solutions by using Azure Synapse Analytics serverless SQL pools](/training/paths/build-data-analytics-solutions-using-azure-synapse-serverless-sql-pools)
- [Query a data lake or lakehouse by using Azure Synapse Analytics serverless SQL pools](/azure/synapse-analytics/sql/on-demand-workspace-overview)

## Related resources

- [Databases architecture design](../../databases/index.yml)
- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
