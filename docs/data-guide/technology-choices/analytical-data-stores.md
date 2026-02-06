---
title: Choose an Analytical Data Store in Azure
description: Evaluate analytical data store options for big data by reviewing key selection criteria and a capability matrix to compare database models and features.
author: rajasekharreddy-duddugunta
ms.author: rduddugunta
ms.date: 03/26/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Choose an analytical data store in Azure

In a [big data](../big-data/index.yml) architecture, there's often a need for an analytical data store that serves processed data in a structured format that can be queried by using analytical tools. Analytical data stores that support querying of both hot-path and cold-path data are collectively referred to as the *serving layer*, or *data serving storage*.

The serving layer handles processed data from both the hot path and the cold path. In the [Lambda architecture](/azure/architecture/databases/guide/big-data-architectures#lambda-architecture), the serving layer is subdivided into two layers. The *speed serving* layer contains the incrementally processed data. The *batch serving* layer contains the batch-processed output. The serving layer requires strong support for random reads that have low latency. Data storage for the speed layer should also support random writes because batch loading data into this store introduces undesired delays. Alternatively, data storage for the batch layer needs to support batch writes, not random writes.

There's no single best data management choice for all data storage tasks. Different data management solutions are optimized for different tasks. Most real-world cloud apps and big data processes have various data storage requirements and often use a combination of data storage solutions.

Modern analytical solutions, such as [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview), provide a comprehensive platform that integrates various data services and tools to meet diverse analytical needs. Fabric includes OneLake, which is a single, unified, logical data lake for your entire organization. OneLake is designed to store, manage, and secure all organizational data in one location. This flexibility allows your organization to address a wide range of data storage and processing requirements.

## Choose an analytical data store

There are several options for data serving storage in Azure, depending on your needs:

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview), specifically:
  - [Fabric Lakehouse](/fabric/data-engineering/lakehouse-overview)
  - [Fabric Warehouse](/fabric/data-warehouse/data-warehousing)
  - [Fabric Eventhouse](/fabric/real-time-intelligence/eventhouse)
  - [Fabric SQL Databases](/fabric/database/sql/overview)
- [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks)
- [Azure SQL Database](/azure/sql-database/)
- [SQL Server in Azure VM](/sql/sql-server/sql-server-technical-documentation)
- [Azure Analysis Services](/azure/analysis-services/analysis-services-overview)
- [Azure Cosmos DB](/azure/cosmos-db/introduction)

The following database models are optimized for different types of tasks:

- [Key-value databases](../big-data/non-relational-data.yml#keyvalue-data-stores) store a single serialized object for each key value. They're well-suited for managing large volumes of data when retrieval is based on a specific key, without the need to query other item properties.

- [Document databases](../big-data/non-relational-data.yml#document-data-stores) are key-value databases in which the values are *documents*. In this context, a document is a collection of named fields and values. The database typically stores the data in a format such as XML, YAML, JSON, or binary JSON, but might use plain text. Document databases can query on non-key fields and define secondary indexes to improve querying efficiency. This capability makes a document database more suitable for applications that need to retrieve data based on criteria that's more complex than the value of the document key. For example, you could query on fields such as product ID, customer ID, or customer name.

- [Column store databases](../big-data/non-relational-data.yml#columnar-data-stores) are key-value data stores that store each column separately on disk. A *wide column store* database is a type of column store database that stores *column families*, not only single columns. For example, a census database might have a separate column family for each of the following items:

  - A person's first, middle, and last name

  - That person's address

  - That person's profile information, like their date of birth or gender 
  
  The database can store each column family in a separate partition, while keeping all the data for one person related to the same key. An application can read a single column family without scanning all the data for an entity.

- [Graph databases](../big-data/non-relational-data.yml#graph-data-stores) store information as a collection of objects and relationships. A graph database can efficiently perform queries that traverse the network of objects and the relationships between them. For example, the objects might be employees in a human resources database, and you might want to facilitate queries such as "find all employees who directly or indirectly work for Scott."

- Telemetry and time-series databases are an append-only collection of objects. Telemetry databases efficiently index data in various column stores and in-memory structures. This capability makes them the optimal choice for storing and analyzing vast quantities of telemetry and time-series data.

[Fabric](/fabric/fundamentals/microsoft-fabric-overview) supports various database models, including key-value, document, column store, graph, and telemetry databases. This flexibility ensures scalability for a wide range of analytical tasks. To choose the right Fabric datastore for your analytical workloads, see [Fabric decision guide: choose a datastore](/fabric/fundamentals/decision-guide-data-store).

## Key selection criteria

To refine the selection process, consider the following criteria:

- Do you need serving storage that can serve as a hot path for your data? If yes, narrow your options to those that are optimized for a speed serving layer.

- Do you need massively parallel processing support, where queries are automatically distributed across several processes or nodes? If yes, select an option that supports query scale-out.

- Do you prefer to use a relational data store? If you do, narrow your options to those that have a relational database model. However, some nonrelational stores support SQL syntax for querying, and tools such as SQL Endpoint can be used to query nonrelational data stores such as OneLake.

- Do you collect time-series data? Do you use append-only data? Fabric OneLake supports multiple analytical engines, including Analysis Services, T-SQL, and Apache Spark. Fabric Eventhouse makes it suitable for various data processing and querying needs of time-series data.

## Capability matrix

The following tables summarize the key differences in capabilities in these managed services.

### General capabilities

| Capability | Fabric Lakehouse | Fabric Warehouse | Fabric Eventhouse | Fabric SQL Database| Azure SQL Database | Azure Cosmos DB | Analysis Services  | 
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Primary database model | Unified data lake, relational, user managed delta lake format using apache parquet | Unified data lake, relational, system managed delta lake format using apache parquet | Time series append oriented data store, graph, vector | Relational (column store format when you use columnstore indexes) | Relational (column store format when you use columnstore indexes) | Document store, graph, key-value store, wide column store | Tabular semantic models |  
| SQL language support | Yes<sup>1</sup> | Yes | Yes<sup>2</sup> | Yes | Yes | Yes | No |
| Optimized for speed serving layer | Yes  | Yes  | Yes<sup>3</sup> | Yes<sup>4</sup> | Yes<sup>5</sup> | Yes | No | 

[1] T-SQL via SQL Analytics Endpoint.

[2] KQL has partial T-SQL language support.

[3] Supports queued ingestion and streaming ingestion.

[4] Supports transactional precision with low-latency access and real-time updates.

[5] Using memory-optimized tables and hash or nonclustered indexes.


### Scalability capabilities

| Capability | Fabric Lakehouse | Fabric Warehouse | Fabric Eventhouse | Fabric SQL Database| Azure SQL Database | Azure Cosmos DB | Analysis Services  | 
| :------| :--------| :---------| :--------| :-------| :--------| :--------| :-----|
| Redundant regional servers for high availability |     Yes<sup>1,2</sup>      |        Yes<sup>1,2</sup>         |        Yes         |       Yes   |            Yes             |           Yes           |           Yes        |
|             Supports query scale-out             |      Yes<sup>3</sup>      |        Yes<sup>4</sup>         |        Yes<sup>5</sup>         |         Yes         |         No             |          Yes           |           Yes           |
|          Dynamic scalability (scale up)          |     Yes<sup>3</sup>      |        Yes<sup>4</sup>       |        Yes<sup>5</sup>         |        Yes           |             Yes            |           Yes           |           Yes           |
|        Supports in-memory caching of data        |     Yes<sup>6</sup>      |        Yes<sup>6</sup>         |        Yes<sup>7</sup>         |            Yes         |        Yes             |          Yes           |           No          |

[1] SQL Endpoints are routed via global traffic managers, but data is always processed in the assigned Fabric capacity region.

[2] Lakehouse and Warehouse store data in OneLake using Delta Parquet format, which supports querying and replication across engines.

[3] Lakehouse supports Spark-based scale-out for unstructured and structured data.

[4] Warehouse uses T-SQL and supports multi-table transactions, autonomous workload management, and distributed query processing (DQP). DQP acts like a cluster manager, dynamically allocating compute resources based on query complexity.

[5] Eventhouse supports KQL and SQL federation, enabling real-time analytics across multiple sources as well as scale up compute resources if hot cache usage exceeds ~95%.

[6] Intelligent cache for Spark jobs, [in-memory caching](/fabric/data-warehouse/caching), [result set caching](/fabric/data-warehouse/result-set-caching) for SQL analytics endpoints.

[7] Frequently accessed data is stored in a hot cache which includes in-memory and SSD storage.

### Security capabilities

| Capability | Fabric Lakehouse | Fabric Warehouse | Fabric Eventhouse | Fabric SQL Database| Azure SQL Database | Azure Cosmos DB | Analysis Services  |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Authentication  |Microsoft Entra ID |Microsoft Entra ID | Microsoft Entra ID | Microsoft Entra ID | SQL or Microsoft Entra ID | Database users or Microsoft Entra ID via access control (identity and access management) |Microsoft Entra ID   |
| Data encryption at rest | Yes | Yes | Yes | Yes | Yes<sup>1</sup> | Yes | Yes |
| Row-level security | Yes | Yes | Yes | Yes  | Yes | No | Yes |
| Supports firewalls | Yes<sup>2</sup> | Yes<sup>2</sup> | Yes<sup>3</sup> | Yes | Yes | Yes | Yes |
| Dynamic data masking | Yes<sup>4</sup> | Yes<sup>4</sup> | No | Yes | Yes | No | No |

[1] Requires you to use transparent data encryption to encrypt and decrypt your data at rest.

[2] Private Links and Entra Conditional Access can be used to restrict access to Fabric resources.

[3] Fabric Eventhouse and Real-Time Intelligence workloads can ingest data from secure sources like Kafka, Azure Event Hubs, and AMQP, with routing through secure endpoints.

[4] It can be applied at the Fabric SQL Endpoint Level

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Mohit Agarwal](https://www.linkedin.com/in/mohitagarwal01/) |  Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*


## Next steps

- [Bring your Data to OneLake with Lakehouse](/fabric/onelake/create-lakehouse-onelake)
- [Create a Fabric Warehouse](/fabric/data-warehouse/create-warehouse)
- [Create an Eventhouse](/fabric/real-time-intelligence/create-eventhouse)
- [Analyze data in a relational data warehouse](/training/modules/design-multidimensional-schema-to-optimize-analytical-workloads)
- [Create a single database in SQL Database](/azure/azure-sql/database/single-database-create-quickstart)
- [Create an Azure Databricks workspace](/azure/databricks/getting-started)
- [Explore Azure database and analytics services](/training/modules/azure-database-fundamentals)
- [Query Azure Cosmos DB by using the API for NoSQL](/azure/cosmos-db/nosql/tutorial-query)

## Related resources

- [Fabric decision guide: choose a datastore](/fabric/fundamentals/decision-guide-data-store)
- [Query the SQL analytics endpoint or Warehouse in Microsoft Fabric](/fabric/data-warehouse/get-started-lakehouse-sql-analytics-endpoint)
- [Technology choices for Azure solutions](../../guide/technology-choices/technology-choices-overview.md)
- [Nonrelational data and NoSQL](../../data-guide/big-data/non-relational-data.yml)
