---
title: Understanding data models
description: Learn the major Azure data store models, how they differ, and how to choose and combine them using comparative characteristics of relational and non-relational options.
author: claytonsiemens77
ms.author: csiemens
ms.topic: conceptual
ms.subservice: architecture-guide
ms.date: 08/21/2025
---

# Understanding data models

Modern solutions handle diverse data (transactions, events, documents, telemetry, binary assets, analytical facts). A single data store rarely satisfies all access patterns efficiently. Most production systems adopt *polyglot persistence*: selecting multiple storage models intentionally. This article centralizes the canonical definitions of the primary data store models available on Azure and provides comparative tables to speed model selection before you pick specific services.

Use this sequence:
1. Identify workload access patterns (point reads, aggregations, full‑text, similarity, time-window scans, object delivery).
2. Map patterns to storage models below.
3. Shortlist Azure services that implement those models.
4. Apply evaluation criteria (consistency, latency, scale, governance, cost).
5. Combine models only where access patterns or lifecycle clearly diverge.

## How to use this guide

Each model section includes a concise definition, typical workloads, data characteristics, example scenarios, and links to representative Azure services. Each section also includes a table to help you choose the right Azure service for your use case. In some cases, there are separate articles to help you make more informed choices about Azure service options. Those articles are linked in the respective model sections.

Two comparative tables summarize non-relational model traits so you avoid duplicative re-reading. 

## Classification overview

| Category | Primary purpose | Typical Azure services (examples) |
|----------|-----------------|------------------------------------|
| Relational (OLTP) | Strongly consistent transactional operations | Azure SQL Database, Azure Database for PostgreSQL, Azure Database for MySQL |
| Non-relational (document / key/value / column-family / graph) | Flexible schema or relationship-centric workloads | Azure Cosmos DB APIs, Azure Managed Redis, Managed Cassandra, HBase |
| Time series | High-ingest timestamped metrics and events | Azure Data Explorer |
| Object & file | Large binary or semi-structured file storage | Blob Storage, Data Lake Storage Gen2 |
| Search & indexing | Full-text and multi-field relevance, secondary indexing | Azure AI Search |
| Vector | Semantic or ANN similarity |  Azure AI Search, Azure Cosmos DB variants |
| Analytics / OLAP / MPP | Large-scale historical aggregation, BI | Microsoft Fabric, Synapse, Azure Data Explorer, Analysis Services, Databricks |

>[!NOTE]
> A single service may offer multiple models (multi-model). Prefer the best-fit model instead of forcing an awkward multi-model consolidation that complicates operations.

## Relational data stores

Relational database management systems organize data into normalized tables with schema-on-write, enforcing integrity and supporting ACID transactions and rich SQL queries.

**Use when** you require multi-row transactional consistency, complex joins, strong relational constraints, and mature tooling around reporting, administration, and governance.

**Constraints:** Horizontal scale generally requires sharding or partitioning; normalization can increase join cost for read-heavy denormalized views.

**Workloads:** Order management, inventory, financial ledger, billing, operational reporting.

### Selecting an Azure service for relational data stores

- **[Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview)** is a fully managed relational database for modern cloud applications using SQL Server engine.
- **[Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)** is a near-complete SQL Server environment in the cloud, ideal for lift-and-shift migrations.
- **[Azure SQL Database (Hyperscale)](/azure/azure-sql/database/service-tier-hyperscale)** is a highly scalable SQL tier designed for massive workloads with fast autoscaling and rapid backups.
- **[Azure Database for PostgreSQL](/azure/postgresql/flexible-server/overview)** is a managed PostgreSQL service supporting open-source extensions and flexible deployment options.
- **[Azure Database for MySQL](/azure/mysql/flexible-server/overview)** is a fully managed MySQL database for web apps and open-source workloads.
- **[SQL Database in Microsoft Fabric](/fabric/database/sql/overview)** is a developer-friendly transactional database, based on Azure SQL Database, that allows you to easily create your operational database in Fabric. 

Use this table to help determine which Azure service meets your use case requirements.

|**Service**|**Best for**|**Key features**|**Example use case**|
:-----:|:-----:|:-----:|:-----:|
|**[Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview)**|Cloud-native apps|Fully managed, elastic pools, Hyperscale, built-in HA, advanced security|Building a modern SaaS application with scalable SQL backend|
|**[Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)**|Legacy enterprise apps|Full SQL Server compatibility, lift-and-shift support, VNet, advanced auditing|Migrating an on-prem SQL Server app with minimal code changes|
|**[Azure SQL Database (Hyperscale)](/azure/azure-sql/database/service-tier-hyperscale)**|Global distribution|Multi-region read scalability, geo-replication, rapid autoscaling|Serving a globally distributed app with high read throughput|
|**[Azure Database for PostgreSQL](/azure/postgresql/flexible-server/overview)**|Open-source, analytics workloads|PostGIS, Hyperscale, Flexible Server, open-source extensions|Developing a geospatial analytics app using PostgreSQL and PostGIS|
|**[Azure Database for MySQL](/azure/mysql/flexible-server/overview)**|Lightweight web apps|Flexible Server, open-source compatibility, cost-effective|Hosting a WordPress-based e-commerce site|
|**[SQL Database in Microsoft Fabric](/fabric/database/sql/overview)**|OLTP workloads in the Fabric ecosystem|Built on the Azure SQL database engine, scalable and integrated into Fabric|Building AI apps on an operational, relational data model with native vector search capabilities|

## Non-relational data stores

Non-relational (NoSQL) databases optimize for flexible schemas, horizontal scale, and specific access or aggregation patterns. They typically relax some aspects of relational behavior (schema rigidity, transaction scope) for scalability or agility.

### Document data stores <a id="document-data-stores"></a>

Store semi-structured documents (often JSON) where each document consists of named fields and data. The data can be simple values or complex elements such as lists and child collections. Per-document schema flexibility enables gradual evolution.

**Strengths:** Natural application object mapping, denormalized aggregates, multi-field indexing.  

**Considerations:** Document size growth, selective transactional scope, need for careful data shape design for high-scale queries.  

**Workloads:** Product catalogs, content management, profile stores.  

#### Selecting an Azure service for document data stores

- **[Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/)** is a schema-less, multi-region NoSQL database with low-latency reads and writes.
- **[Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb/overview)** is a globally distributed database with MongoDB wire protocol compatibility and automatic scaling.
- **[Cosmos DB in Microsoft Fabric](/fabric/database/cosmos-db/overview)** is a schema-less, NoSQL database with low-latency reads and writes, simplified management experience and built-in analytics of Microsoft Fabric.

Use this table to help determine which Azure service meets your use case requirements.

| Service | Best For | Key Features | Example Use Case |
|--------|----------|--------------|------------------|
| **[Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/)** | Custom JSON document models with SQL-like querying | Rich query language, multi-region writes, TTL, change feed | Building a multi-tenant SaaS platform with flexible schemas |
| **[Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb/overview)** | Apps using MongoDB drivers or JSON-centric APIs | Global distribution, autoscale, native MongoDB wire protocol | Migrating a Node.js app from MongoDB to Azure |
| **[Cosmos DB in Microsoft Fabric](/fabric/database/cosmos-db/overview)** | Real-time analytics over NoSQL data | Automatic ETL to One Lake with tight Microsoft Fabric integration | Transactional apps with real-time analytical dashboards |

### Column-family (wide-column) data stores <a id="columnar-data-stores"></a>

A column-family database organizes sparse data into rows with dynamic columns grouped as column families for co-access. Column orientation improves scans over selected column sets.

**Strengths:** High write throughput, efficient retrieval of wide or sparse datasets, dynamic schema within families.

**Considerations:** Up-front row key and column family design; secondary index support varies; query flexibility lower than relational.  

**Workloads:** IoT telemetry, time-series style tall data (when dedicated time series DB not chosen), personalization, analytics pre-aggregation.  

#### Selecting an Azure service for column-family data stores

- **[Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra)** is a fully managed service for pure open-source Apache Cassandra clusters.
- **[Azure HBase on HDInsight](/azure/hdinsight/hbase/apache-hbase-overview)** a scalable NoSQL store for big data workloads built on Apache HBase and Hadoop ecosystem.
- **[Azure Data Explorer (Kusto)](/azure/data-explorer/data-explorer-overview)** is a lightning-fast analytics engine for telemetry, logs, and time-series data using KQL.

Use this table to help determine which Azure service meets your use case requirements.

| Service | Best For | Key Features | Example Use Case |
|--------|----------|--------------|------------------|
| **[Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra)** | New and migrated Cassandra workloads | Fully managed, native Apache Cassandra | IoT device telemetry ingestion with Cassandra compatibility |
| **[Azure HBase on HDInsight](/azure/hdinsight/hbase/apache-hbase-overview)** | Hadoop ecosystem, batch analytics | HDFS integration, large-scale batch processing | Batch processing of sensor data in a manufacturing plant |
| **[Azure Data Explorer (Kusto)](/azure/data-explorer/data-explorer-overview)** | High-ingest telemetry, time-series analytics | KQL, fast ad hoc queries, time-window functions | Real-time analytics for application logs and metrics |

### Key/value data stores <a id="key/value-data-stores"></a>

A key/value store associates each data value with a unique key. Most key/value stores only support simple query, insert, and delete operations. To modify a value (either partially or completely), an application must overwrite the existing data for the entire value. In most implementations, reading or writing a single value is an atomic operation.

**Strengths:** Extreme simplicity, low latency, linear scalability.

**Considerations:** Limited query expressiveness; redesign needed for value-based lookups; large value overwrite cost.  

**Workloads:** Caching, sessions, feature flags, user profiles, recommendation lookups.  

#### Selecting an Azure service for key/value data stores

- **[Azure Managed Redis](/azure/redis/overview)** is a fully managed in-memory data store based on the latest Redis Enterprise version, offering low latency and high throughput.
- **[Azure Cosmos DB for Table](azure/cosmos-db/table/overview)** is a key-value store optimized for fast access to structured NoSQL data.
- **[Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/)** is a document data store, optimized for fast access to structured NoSQL data and provides horizontal scalability.
Use this table to help determine which Azure service meets your use case requirements.

| Service | Best For | Key Features | Example Use Case |
|--------|----------|--------------|------------------|
| **[Azure Managed Redis](/azure/redis/overview)** | High-speed caching, session state, pub/sub | In-memory store, sub-millisecond latency, Redis protocol | Caching product pages for an e-commerce site |
| **[Azure Cosmos DB for Table](azure/cosmos-db/table/overview)** | Migrating existing Azure Table Storage workloads | Azure Table Storage API compatibility | Storing user preferences and settings in a mobile app |
| **[Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/)** | High speed caching with massive scale and high availability | Schema-less, multi-region, autoscale | Caching, session state, serving layer |

### Graph data stores <a id="graph-data-stores"></a>

A graph database stores information as nodes and edges, where edges define relationships and both can have properties like table columns. It efficiently analyzes connections between entities, such as employees and departments.

**Strengths:** Relationship-first querying patterns; efficient variable-depth traversals.  

**Considerations:** Overhead if relationships are shallow; requires careful modeling for performance; not ideal for bulk analytical scans.  

**Workloads:** Social networks, fraud rings, knowledge graphs, supply chain dependencies.  

#### Selecting an Azure service for graph data stores

**[SQL Server graph extensions](/sql/relational-databases/graphs/sql-graph-overview)** is the only current Azure service recommended for storing graph data. The graph extension extends the capabilities of SQL Server, Azure SQL Database, and Azure SQL Managed Instance to enable modeling and querying complex relationships using graph structures directly within a relational database.

#### Time series data stores <a id="time-series-data-stores"></a>

Time series data stores manage a set of values organized by time. They support features like time-based queries and aggeregations and are optimized for ingesting and analyzing large volumes of data in near real-time.

**Strengths:** Compression, windowed query performance, out-of-order ingestion handling.  

**Considerations:** Tag cardinality management, retention cost, downsampling strategy.  

**Workloads:** IoT sensor metrics, application telemetry, monitoring, industrial data.  

### Selecting an Azure service for time series data stores

**[Azure Data Explorer](/azure/data-explorer/data-explorer-overview)** is the only current Azure service recommended for storing time series data. Azure Data Explorer is a fully managed, high-performance, big data analytics platform that makes it easy to analyze high volumes of data in near real time.

### Object data stores <a id="object-data-stores"></a>

Persist large binary or semi-structured objects with metadata (immutable or infrequently changing).

**Strengths:** Virtually unlimited scale, tiered cost, durability, parallel read capability.  

**Considerations:** Whole-object operations; metadata query limited; eventual listing behaviors.  

**Workloads:** Media assets, backups, data lake raw zones, log archives.  

#### Selecting an Azure service for object data stores

- **[Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)** is a big data-optimized object store that combines hierarchical namespace and HDFS compatibility for advanced analytics and large-scale data processing.
- **[Azure Blob Storage](azure/storage/blobs/storage-blobs-introduction)** is a scalable, general-purpose object store for unstructured data like images, documents, and backups, with tiered access for cost optimization

Use this table to help determine which Azure service meets your use case requirements.

|Service|Best for|Key features|Example use case|
:-----:|:-----:|:-----:|:-----:
|**[Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)**|Big data analytics and hierarchical data|Hadoop-compatible file system (HDFS), hierarchical namespace, optimized for analytics|Storing and querying petabytes of structured and unstructured data using Azure Synapse or Databricks|
|**[Azure Blob Storage](azure/storage/blobs/storage-blobs-introduction)**|General-purpose object storage|Flat namespace, tiered storage (hot, cool, archive), simple REST API|Hosting images, documents, backups, and static website content|

### Search and indexing data stores <a id="search-engine-databases"></a>

A search engine database allows applications to search for information held in external data stores. A search engine database can index massive volumes of data and provide near real-time access to these indexes.

**Strengths:** Full-text queries, scoring, linguistic analysis, fuzzy matching.

**Considerations:** Eventual consistency of indexes; separate ingestion / indexing pipeline; cost of large index updates.

**Workloads:** Site/product search, log search, metadata filtering, multi-attribute discovery.  

#### Selecting an Azure service for search data stores

Refer to the [Choose a search data store in Azure](/azure/architecture/data-guide/technology-choices/search-options) article for guidance on choosing the right search data store for your workload.

### Vector search data stores

Vector search data stores store and retrieve high-dimensional vector representations of data, often generated by machine learning models.

**Strengths:** Semantic search, ANN algorithms.

**Considerations:** Indexing complexity, storage overhead, latency vs accuracy, integration challenges.

**Workloads:** Semantic document search, recommendation engines, image and video retrieval, fraud and anomaly detection.

#### Selecting an Azure service for vector search data stores

Refer to the [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search) article for guidance on choosing the right vector data store for your workload.

### Anaytics data stores <a id="data-analytics"></a>

Analytics data stores store big data and persist it throughout an analytics pipeline lifecycle.

**Strengths**: Scalable compute and storage, support for SQL and Spark, integration with BI tools, time-series and telemetry analysis.

**Considerations**: Cost and complexity of orchestration, query latency for ad hoc workloads, governance across multiple data domains.

**Workloads**: Enterprise reporting, big data analytics, telemetry aggregation, operational dashboards, data science pipelines.

#### Selecting an Azure service for analytics data stores

Refer to the [Choose an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores) article for guidance on choosing the analytics data store for your workload.

## Comparative characteristics (core non-relational models)  <a id="comparison-core-non-relational-models"></a>

| Aspect | Document | Column-family | Key/value | Graph |
|--------|----------|---------------|-----------|-------|
| Normalization | Denormalized | Denormalized | Denormalized | Normalized relationships |
| Schema approach | Schema on read | Column families defined; columns schema on read | Schema on read | Schema on read |
| Consistency (typical) | Tunable / per-item | Per-row / family | Per-key | Per-edge / traversal semantics |
| Atomicity scope | Document | Row (family/table impl-dependent) | Single key | Graph transaction (varies) |
| Locking / Concurrency | Optimistic (ETag) | Pessimistic or optimistic (impl) | Optimistic (key) | Optimistic (pattern) |
| Access pattern | Aggregate (entity) | Wide sparse aggregates | Point lookup by key | Relationship traversals |
| Indexing | Primary + secondary | Primary + limited secondary | Primary (key) | Primary + sometimes secondary |
| Data shape | Flexible hierarchical | Sparse tabular wide | Opaque value | Nodes & edges |
| Sparse / wide suitability | Yes / Yes | Yes / Yes | Yes / No | No / No |
| Typical datum size | Small–medium | Medium–large | Small | Small |
| Scale dimension | Partition count | Partition + column family width | Key space | Node/edge count |

## Comparative characteristics (specialized non-relational models)  <a id="comparison-specialized-non-relational-models"></a>

| Aspect | Time series | Object (blob) | Search / indexing |
|--------|------------|---------------|-------------------|
| Normalization | Normalized | Denormalized | Denormalized |
| Schema | Schema on read (tags) | Opaque value + metadata | Schema on write (index mapping) |
| Atomicity scope | N/A (append) | Object | Per document/index operation |
| Access pattern | Time-slice scans, window agg | Whole-object ops | Text queries + filters |
| Indexing | Time + optional secondary | Key (path) only | Inverted + optional facets |
| Data shape | Tabular (timestamp, tags, value) | Binary/blob with metadata | Tokenized text + structured fields |
| Write profile | High-rate append | Bulk / infrequent updates | Batch or streaming index |
| Read profile | Aggregated ranges | Whole or partial downloads | Ranked result sets |
| Growth driver | Event rate * retention | Object count & size | Indexed doc volume |
| Consistency tolerance | Eventual for late data | Read-after-write per object | Eventual for new docs |

## Choosing among models (heuristics)

| Need | Prefer |
|------|-------|
| Strict multi-entity transactions | Relational |
| Evolving aggregate shape, JSON-centric APIs | Document |
| Extreme low-latency key lookups / caching | Key/value |
| Wide, sparse, write-heavy telemetry | Column-family or Time series |
| Deep relationship traversal | Graph |
| Massive historical analytical scans | Analytics / OLAP |
| Large unstructured binaries or lake zones | Object |
| Full-text relevance and filtering | Search & indexing |
| High-ingest timestamp metrics with window queries | Time series |
| Rapid similarity (semantic / vector) | Vector search |

## Combining models and avoiding pitfalls

Use more than one model when:
- Access patterns diverge (point lookup vs wide analytical scan vs full-text relevance).
- Lifecycle and retention differ (immutable raw vs curated structured).
- Latency vs throughput requirements conflict.

Avoid premature fragmentation:
- Keep to one service if performance, scale, and governance objectives are still met.
- Centralize shared classification logic; do not duplicate transformation pipelines across stores without necessity.

Common anti-patterns:
- Shared database used by multiple microservices (coupling).
- “Just add another model” without operational maturity (monitoring, backups).
- Overusing a search index as a primary data store.

## When to re-evaluate your model choice

| Signal | Possible Action |
|--------|-----------------|
| Increasing ad-hoc joins on a document store | Introduce relational read model |
| High CPU on search index due to analytical aggregations | Offload to analytics engine |
| Large denormalized documents causing partial update contention | Re-shape aggregates or split |
| Time-window queries slow on column-family store | Adopt purpose-built time series DB |
| Point lookup latency rising with graph traversal depth | Add derived materialized views |

## Next steps

**Choosing a specialized data store guidance**

Use the following articles to help you choose a specialized data store.

- [Choose a big data storage technology in Azure](/azure/architecture/data-guide/technology-choices/data-storage)
- [Choose a search data store in Azure](/azure/architecture/data-guide/technology-choices/search-options)
- [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search)

**Explore reference architectures**

Learn about reference architectures using the Azure services discussed in this article.

- The [Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant) architecture uses Azure SQL Database as its relational data store.
- The [Deploy microservices with Azure Container Apps and Dapr](/azure/architecture/example-scenario/serverless/microservices-with-container-apps-dapr) architecture uses Azure Database, Cosmos DB, and Azure Cache for Redis as data stores.
- The [Automate document classification in Azure](azure/architecture/ai-ml/architecture/automate-document-classification-durable-functions) architecture uses Cosmos DB as its data store.

## Related resources

- Learn about [online analytical processing (OLAP)](/azure/architecture/data-guide/relational-data/online-analytical-processing).
- Learn about [online transaction processing (OLTP](/azure/architecture/data-guide/relational-data/online-transaction-processing).
- Learn about [data lakes](/azure/architecture/data-guide/scenarios/data-lake).
- Learn about [extract, transform, and load (ETL)](/azure/architecture/data-guide/relational-data/etl).
- Review the [Cloud Adoption Framework Secure methodology](/azure/cloud-adoption-framework/secure/overview) for detailed guidance on data security across your adoption journey.
- Review the [Zero Trust Framework data security](/security/zero-trust/deploy/data) guidance.

<!-- Legacy anchor aliases (from consolidated sources) -->
<a id="columnar-data-stores"></a>
<a id="column-family-databases"></a>
<a id="key/value-data-stores"></a>
<a id="document-data-stores"></a>
<a id="graph-data-stores"></a>
<a id="time-series-data-stores"></a>
<a id="object-data-stores"></a>
<a id="external-index-data-stores"></a>
<a id="search-engine-databases"></a>
<a id="data-analytics"></a>
