Data-driven enterprises need to keep their back end and analytics systems in near real-time sync with customer-facing applications. The impact of transactions, updates, and changes must reflect accurately through end-to-end processes, related applications, and online transaction processing (OLTP) systems. The tolerable latency for changes in OLTP applications to reflect in the downstream systems that use the data might be just a few minutes.

This article describes an end-to-end solution for near real-time data processing to keep lakehouse data in sync. The solution uses Azure Event Hubs, Azure Synapse Analytics, and Azure Data Lake Storage for data processing and analytics.

Note: A similar architecture can also be implemented using Microsoft Fabric, which provides a unified SaaS platform for data ingestion, transformation, storage, and analytics. In this case, Microsoft Fabric would replace the Azure Synapse Analytics components of the architecture, offering integrated capabilities for real-time data processing and analysis.  See the [Microsoft Fabric Real-Time Intelligence](/fabric/real-time-intelligence/overview) for details.

*Apache® and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

[![A diagram that shows the dataflow for the end-to-end data processing solution.](media/real-time-lakehouse-data-processing/real-time-lakehouse-data-processing.svg)](media/real-time-lakehouse-data-processing/real-time-lakehouse-data-processing.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/azure-near-realtime-data-processing.vsdx) of this architecture.*

### Dataflow

1. Change data capture is a prerequisite for source systems to listen to changes. [Debezium connectors](https://debezium.io/documentation/reference/stable/connectors/index.html) can connect to different source systems and tap into changes as they happen. The connectors can capture changes and produce events from various relational database management systems (RDBMS). Installing a Debezium connector requires a Kafka connect system.

1. The connectors extract change data and send the captured events to Azure Event Hubs. Event Hubs can receive large amounts of data from multiple sources.

1. Event Hubs directly streams the data to Azure Synapse Analytics Spark pools, or can send the data to an Azure Data Lake Storage landing zone in raw format.

1. Other batch data sources can use Azure Synapse pipelines to copy data to Data Lake Storage and make it available for processing. An end-to-end extract, transform, and load (ETL) workflow might need to chain different steps or add dependencies between steps. Azure Synapse pipelines can orchestrate workflow dependencies within the overall processing framework.

1. Azure Synapse Spark pools use fully supported Apache Spark structured streaming APIs to process data in the Spark Streaming framework. The data processing step incorporates data quality checks and high-level business rule validations.

1. Data Lake Storage stores the validated data in the open [Delta Lake](https://docs.delta.io/latest/delta-intro.html) format. Delta Lake provides atomicity, consistency, isolation, and durability (ACID) semantics and transactions, scalable metadata handling, and unified streaming and batch data processing for existing data lakes.

   Using indexes for query acceleration augments Delta with further performance enhancements. Data from the Data Lake Storage validated zone can also be a source for further advanced analytics and machine learning.

1. Data from the Data Lake Storage validated zone, transformed and enriched with more rules into its final processed state, loads to a dedicated SQL pool for running large scale analytical queries.

1. Power BI uses the data exposed through the dedicated SQL pool to build enterprise-grade dashboards and reports.

1. You can also use captured raw data in the Data Lake Store landing zone and validated data in the Delta format for:

   - Further ad-hoc and exploratory analysis through Azure Synapse SQL serverless pools.
   - Machine learning through Azure Machine Learning.

1. For some low-latency interfaces, data must be denormalized for single-digit server latencies. This usage scenario is mainly for API responses. This scenario queries documents in a NoSQL datastore such as Azure Cosmos DB for single-digit millisecond responses.

1. The Azure Cosmos DB partitioning strategy might not efficiently support all query patterns. If that's the case, you can augment the solution by indexing the data that the APIs need to access with Azure AI Search. Cosmos DB and AI Search can fulfill most scenarios that require low latency query responses. For example, if a retail application stores product catalog data in Cosmos DB, but needs full-text search capabilities with flexible indexing, AI Search can index the data and provide advanced search features like autocomplete, synonyms, and semantic ranking. This is particularly useful when Cosmos DB’s indexing limitations hinder complex search scenarios.

### Components

This solution uses the following Azure components:

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a managed, distributed ingestion service that can scale to ingest large amounts of data. With the Event Hubs subscriber-publisher mechanism, different applications can send messages to topics in Event Hubs, and downstream consumers can connect to and process messages. The Event Hubs Capture feature can write messages to Data Lake Storage in Avro format as they arrive. This ability enables easy micro-batch processing and long-term retention scenarios. Event Hubs also offers a Kafka-compatible API and supports schema registry.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) forms the storage subsystem that stores all data in raw and validated formats. Data Lake Storage can handle transactions at scale, and supports different file formats and sizes. Hierarchical namespaces help organize data into a familiar folder structure and support Portable Operating System Interface for Unix (POSIX) permissions. The Azure Blob Filesystem (ABFS) driver offers a Hadoop-compatible API.

- [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. This solution uses the following features of the Azure Synapse Analytics ecosystem:

  - [Azure Synapse Spark pools](/azure/synapse-analytics/spark/apache-spark-overview) offer an on-demand Spark runtime that adds built-in performance enhancements to open-source Spark. Customers can configure flexible autoscale settings, submit jobs remotely through the Apache Livy endpoint, and use the Synapse Studio notebook interface for interactive experiences.

  - [Azure Synapse SQL serverless pools](/azure/synapse-analytics/sql/on-demand-workspace-overview) provide an interface to query lakehouse data by using a familiar T-SQL syntax. There's no infrastructure to set up, and Azure Synapse workspace deployment automatically creates the endpoint. Azure Synapse SQL serverless pools enable basic discovery and exploration of data in place, and are a good option for user ad-hoc query analysis.

  - [Azure Synapse dedicated SQL pools](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) store data in relational tables with columnar storage. Dedicated SQL pools use a scale-out architecture to distribute data processing across multiple nodes. PolyBase queries bring the data into SQL pool tables. The tables can connect to Power BI for analysis and reporting.

- [Power BI](/power-bi/fundamentals/power-bi-overview) provides a visual interface to create and access reports and dashboards. Power BI Desktop can connect to various data sources, combine the sources into a data model, and build reports or dashboards. With Power BI, you can transform data based on business requirements, and share visuals and reports with others through the Power BI service.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a managed, multi-modal NoSQL database that supports open APIs such as MongoDB and Cassandra. This solution uses Azure Cosmos DB for applications that require single-digit millisecond response times and high availability. Azure Cosmos DB offers multi-region writes across all Azure regions. 

- [Azure AI Search](https://azure.microsoft.com/services/search) Azure AI Search is an alternative when Cosmos DB indexing limitations prevent flexible querying. For example, if a retail application stores product catalog data in Cosmos DB, but users need to search by product name, description, and tags with typo tolerance and autocomplete, Azure AI Search can index the data and provide advanced search features like semantic ranking and synonyms. This is particularly useful when Cosmos DB’s indexing model is too rigid for complex search scenarios. You can query the indexed data by using a REST API or the .NET SDK. To get data from two separate indexes, you can combine them into a single index or use [complex data types](/azure/search/search-howto-complex-data-types).

## Scenario details

The end-to-end workflow to process changes in near real-time requires:

- A change data capture (CDC) technology. The OLTP applications might have different back-end data stores, such as SQL Server, MySQL, and Oracle. The first step is to listen to changes as they happen, and propagate them forward.
- An ingestion buffer to publish the change events at scale. This service should have the ability to handle large amounts of data as messages arrive. Individual subscribers can connect to this system and process the data.
- Distributed and scalable storage for data as-is in a raw format.
- A distributed, efficient stream processing system that lets users restart and manage state.
- An analytics system that runs at scale to power business decisions.
- A self-serve analytics interface.
- For low-latency API responses, a NoSQL database to store denormalized representation of the data.
- For some cases, a system to index data, refresh the index at regular intervals, and make the latest data available for downstream consumption.

All the preceding technologies should use relevant security constructs for perimeter security, authentication, authorization, and data encryption.

### Potential use cases

This solution is well-suited for:

- Industries that need to propagate changes from OLTP to online analytics processing (OLAP).
- Applications that require data transformation or enrichment.

The real-time data processing scenario is especially important for financial services industries. For example, if an insurance, credit card, or bank customer makes a payment and then immediately contacts customer service, the customer support agent needs to have the latest information.

Similar scenarios apply to retail, commerce, and healthcare sectors. Enabling these scenarios streamlines operations, leading to greater organizational productivity and increased customer satisfaction.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Event Hubs offers 90-day data retention on the premium and dedicated tiers. For failover scenarios, you can set up a secondary namespace in the paired region and activate it during failover. Enable zone redundancy to ensure resilience against datacenter failures. Event hubs capture can be used to persist data to Azure Data Lake Storage for replay and recovery scenarios.

- Azure Synapse Spark pool jobs are recycled every seven days as nodes are taken down for maintenance. Consider this activity as you work through the service level agreements (SLAs) tied to the system. This limitation isn't an issue for many scenarios where recovery time objective (RTO) is around 15 minutes. Ensure autoscaling is configured to handle load spikes and node failures.

- Use dedicated SQL pools with geo-backup and zone-redundant storage (ZRS) to protect against regional and zonal outages.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- You can select from different Event Hubs tiers based on workload characteristics. Event Hubs bills Capture storage separately, based on the amount of data being stored on Data Lake Storage.

- Consider object lifecycle management through tiers on Azure Data Lake Storage. As data ages, you can move data from a hot tier, where you need to access recent data for analytics, to a cold storage tier that is priced much lower. The cold storage tier is a cost-effective option for long-term retention.

- You can pause the dedicated SQL pool when you're not using it in your development or test environments. You can schedule a script to pause the pool as needed, or you can pause the pool manually through the portal.

- For Synapse Spark pools, use autoscaling to dynamically allocate resources based on workload demand and avoid overprovisioning. Choose the smallest pool size that meets performance needs and shut down idle pools promptly using automatic termination settings. Optimize Spark jobs by minimizing shuffle operations, caching intermediate results, and tuning partition sizes to reduce execution time and resource consumption. Monitor usage with Azure Synapse monitoring tools and adjust configurations based on job performance and cost trends.

- To optimize cost efficiency in Azure Cosmos DB, tailor your indexing policies to include only necessary paths, reducing storage and RU consumption. Choose the appropriate API and consistency level to match workload needs without overprovisioning. Use autoscale throughput to dynamically adjust RU/s based on demand, and consolidate workloads into fewer containers when possible to minimize overhead. Regularly monitor usage with Azure Cost Management and set alerts to avoid unexpected charges.

- You can estimate pricing using the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

### Performance Efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- You can scale Event Hubs through partitioning. Consider partitioning your data to preserve the order of events through a commit log. Partitioning lets you create multiple parallel logs by maximizing the available throughput capacity. Tune throughput units (TUs) based on expected event volume. Use Capture to write directly to Data Lake in Avro or Parquet format for efficient downstream processing.

- You can set up Azure Synapse Spark pools with small, medium, or large virtual machine (VM) SKUs, based on the workload. You can also configure autoscale on Azure Synapse Spark pools to account for spiky workloads. If you need more compute resources, the clusters automatically scale up to meet the demand, and scale down after processing is complete.

- Delta Lake plays a central role in ensuring high-performance, reliable, and scalable data processing in this architecture. Use `OPTIMIZE` with `ZORDER BY` on frequently queried columns (e.g., timestamps, customer IDs) to co-locate related data blocks, significantly improving query performance by reducing I/O scans.
Streaming ingestion often creates many small files. Use `OPTIMIZE` to compact these into larger files, which improves read efficiency and reduces metadata overhead. Enable Auto Optimize and Auto Compaction features in Delta Lake to automatically compact small files and optimize data layout during write operations, reducing the need for manual intervention.

- To optimize performance in dedicated SQL pools for near real-time analytics, use appropriate distribution methods (hash, round-robin, replicated) and partition large tables by time or region to improve query pruning. Leverage materialized views and result set caching for frequently accessed data, and maintain up-to-date statistics and indexes to support efficient query execution. Assign resource classes to manage memory and concurrency, and monitor performance using built-in tools like SQL Insights and DMVs. These practices help ensure low-latency, high-throughput performance in large-scale analytical workloads.

- To optimize Azure Cosmos DB for performance in real-time analytics scenarios, configure appropriate indexing policies to reduce query latency and storage overhead, and choose the right consistency level to balance performance with data accuracy. Use partitioning effectively to distribute workloads evenly and avoid hot partitions. Enable multi-region writes for low-latency global access and monitor throughput using RUs to scale dynamically based on demand. These practices help ensure responsive, scalable performance for high-ingestion, low-latency workloads.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Pratima Valavala](https://www.linkedin.com/in/pratimavalavala) | Cloud Solution Architect

Other contributor:

- [Rajesh Mittal](https://www.linkedin.com/in/rajeshmittalpmp) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Event Hubs connector for Apache Spark](https://github.com/Azure/azure-event-hubs-spark)
- [Scalability with Event Hubs](/azure/event-hubs/event-hubs-scalability)
- [Index data from Azure Cosmos DB](/azure/search/search-howto-index-cosmosdb)
- [Best practices for dedicated SQL pool](/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool)
- [Best practices for serverless SQL pool](/azure/synapse-analytics/sql/best-practices-serverless-sql-pool)
- [Model, query, and explore data in Azure Synapse](/training/paths/model-query-explore-data-for-azure-synapse)
- [Build data analytics solutions using Azure Synapse serverless SQL pools](/training/paths/build-data-analytics-solutions-using-azure-synapse-serverless-sql-pools)

## Related resources

- [Secure a data lakehouse with Azure Synapse Analytics](../analytics/secure-data-lakehouse-synapse.yml)
- [Query a data lake or lakehouse by using Azure Synapse serverless](synapse-exploratory-data-analytics.yml)
- [Automated enterprise BI](../../reference-architectures/data/enterprise-bi-adf.yml)
- [Demand forecasting for shipping and distribution](../../solution-ideas/articles/demand-forecasting-for-shipping-and-distribution.yml)
- [Big data analytics with enterprise grade security using Azure Synapse](../../solution-ideas/articles/big-data-analytics-enterprise-grade-security.yml)

