---
title: Criteria for choosing a data store
titleSuffix: Azure Application Architecture Guide
description: Overview of Azure compute options.
author: dsk-2015
ms.date: 06/01/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom: seojan19
---

# Choose an Azure data store for your application

Azure offers a number of managed data storage solutions, each providing different features and capabilities. This article will help you to choose a data store for your application. 

If your application consists of multiple workloads, evaluate each workload separately. A complete solution may incorporate multiple data stores. 

## Choose a candidate data store

Use the following flowchart to select a candidate data store.

![](../images/data-store-decision-tree.svg)

The output from this flowchart is a **starting point** for consideration. Next, perform a more detailed evaluation of the data store to see if it meets your needs.

## Understand the data storage models

Modern business systems manage increasingly large volumes of heterogeneous data. A single data store is usually not the best approach. Instead, it's often better to store different types of data in different data stores, each focused on a specific workload or usage pattern. The term *polyglot persistence* refers to solutions that use a mix of data store technologies. Therefore, it's important to understand the main storage models and their tradeoffs.

### Relational database management systems

Relational databases organize data as a series of two-dimensional tables with rows and columns. Most vendors provide a dialect of the Structured Query Language (SQL) for retrieving and managing data. An RDBMS typically implements a transactionally consistent mechanism that conforms to the ACID (Atomic, Consistent, Isolated, Durable) model for updating information.

An RDBMS typically supports a schema-on-write model, where the data structure is defined ahead of time, and all read or write operations must use the schema. 

This model is very useful when strong consistency guarantees are important &mdash; where all changes are atomic, and transactions always leave the data in a consistent state. However, an RDBMS generally can't scale out horizontally without sharding the data in some way. Also, the data in an RDBMS must normalized, which isn't appropriate for every data set. 

#### Azure services

- [Azure SQL Database][sql-db]
- [Azure Database for MySQL][mysql]
- [Azure Database for PostgreSQL][postgres]
- [Azure Database for MariaDB][mariadb]

#### Workload

- Records are frequently created and updated.
- Multiple operations have to be completed in a single transaction.
- Relationships are enforced using database constraints.
- Indexes are used to optimize query performance.

#### Data type

- Data is highly normalized.
- Database schemas are required and enforced.
- Many-to-many relationships between data entities in the database.
- Constraints are defined in the schema and imposed on any data in the database.
- Data requires high integrity. Indexes and relationships need to be maintained accurately.
- Data requires strong consistency. Transactions operate in a way that ensures all data are 100% consistent for all users and processes.
- Size of individual data entries is small to medium-sized.

#### Examples

- Inventory management
- Order management
- Reporting database
- Accounting

### Key/value stores

A key/value store associates each data value with a unique key. Most key/value stores only support simple query, insert, and delete operations. To modify a value (either partially or completely), an application must overwrite the existing data for the entire value. In most implementations, reading or writing a single value is an atomic operation.

An application can store arbitrary data as a set of values. Any schema information must be provided by the application. The key/value store simply retrieves or stores the value by key.

![Diagram of a key-value store](./images/key-value.png)

Key/value stores are highly optimized for applications performing simple lookups, but are less suitable if you need to query data across different key/value stores. Key/value stores are also not optimized for querying by value.

A single key/value store can be extremely scalable, as the data store can easily distribute data across multiple nodes on separate machines.

#### Azure services

- [Cosmos DB][cosmos-db]
- [Azure Cache for Redis][redis]

#### Workload

- Data is accessed using a single key, like a dictionary.
- No joins, lock, or unions are required.
- No aggregation mechanisms are used.
- Secondary indexes are generally not used.

#### Data type

- Each key is associated with a single value.
- There is no schema enforcement.
- No relationships between entities.

#### Examples

- Data caching
- Session management
- User preference and profile management
- Product recommendation and ad serving

### Document databases

A document database stores a collection of *documents*, where each document consists of named fields and data. The data can be simple values or complex elements such as lists and child collections. Documents are retrieves by unique keys.

Typically, a document contains the data for single entity, such as a customer or an order. A document may contain information that would be spread across several relational tables in an RDBMS. Documents don't need to have the same structure. Applications can store different data in documents as business requirements change.

![Diagram of a document store](./images/document.png)

#### Azure service

- [Cosmos DB][cosmos-db]

#### Workload

- Insert and update operations are common. 
- No object-relational impedance mismatch. Documents can better match the object structures used in application code.
- Individual documents are retrieved and written as a single block.
- Data requires index on multiple fields.

#### Data type

- Data can be managed in de-normalized way.
- Size of individual document data is relatively small.
- Each document type can use its own schema.
- Documents can include optional fields.
- Document data is semi-structured, meaning that data types of each field are not strictly defined.

#### Examples

- Product catalog
- Content management
- Inventory management

### Graph databases

A graph database stores two types of information, nodes and edges. Edges specify relationships between nodes. Nodes and edges can have properties that provide information about that node or edge, similar to columns in a table. Edges can also have a direction indicating the nature of the relationship.

Graph databases can efficiently perform queries across the network of nodes and edges and analyze the relationships between entities. The following diagram shows an organization's personnel database structured as a graph. The entities are employees and departments, and the edges indicate reporting relationships and the departments in which employees work.

![Diagram of a document database](./images/graph.png)

This structure makes it straightforward to perform queries such as "Find all employees who report directly or indirectly to Sarah" or "Who works in the same department as John?" For large graphs with lots of entities and relationships, you can perform very complex analyses very quickly. Many graph databases provide a query language that you can use to traverse a network of relationships efficiently.


#### Azure service

- [Cosmos DB Gremlin API][cosmos-gremlin]

#### Workload

 - Complex relationships between data items involving many hops between related data items.
 - The relationship between data items are dynamic and change over time.
 - Relationships between objects are first-class citizens, without requiring foreign-keys and joins to traverse.

#### Data type

 - Nodes and relationships.
 - Nodes are similar to table rows or JSON documents.
 - Relationships are just as important as nodes, and are exposed directly in the query language.
 - Composite objects, such as a person with multiple phone numbers, tend to be broken into separate, smaller nodes, combined with traversable relationships 

#### Examples

 - Organization charts
 - Social graphs
 - Fraud detection
 - Recommendation engines

### Data analytics

Data analytics stores provide massively parallel solutions for ingesting, storing, and analyzing data. The data is distributed across multiple servers to maximize scalability.

#### Azure services

- [Azure Synapse Analytics][sql-dw]
- [Azure Data Lake][data-lake]
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/)

#### Workload

- Data analytics
- Enterprise BI

#### Data type

- Historical data from multiple sources.
- Usually denormalized in a &quot;star&quot; or &quot;snowflake&quot; schema, consisting of fact and dimension tables.
- Usually loaded with new data on a scheduled basis.
- Dimension tables often include multiple historic versions of an entity, referred to as a <em>slowly changing dimension</em>.

#### Examples

- Enterprise data warehouse

### Search Engine Databases

A search engine database allows applications to search for information held in external data stores. A search engine database can index massive volumes of data and provide near real-time access to these indexes. 

Indexes can be multi-dimensional and may support free-text searches across large volumes of text data. Indexing can be performed using a pull model, triggered by the search engine database, or using a push model, initiated by external application code.

Searching can be exact or fuzzy. A fuzzy search finds documents that match a set of terms and calculates how closely they match. Some search engines also support linguistic analysis that can return matches based on synonyms, genre expansions (for example, matching `dogs` to `pets`), and stemming (matching words with the same root).

#### Azure service

- [Azure Search][search]

#### Workload

- Data indexes from multiple sources and services.
- Queries are ad-hoc and can be complex.
- Full text search is required.
- Ad hoc self-service query is required.

#### Data type

- Semi-structured or unstructured text
- Text with reference to structured data

#### Examples

- Product catalogs
- Site search
- Logging

### Time series databases

Time series data is a set of values organized by time. Time series databases  typically collect large amounts of data in real time from a large number of sources. Updates are rare, and deletes are often done as bulk operations. Although the records written to a time-series database are generally small,  there are often a large number of records, and total data size can grow rapidly.

#### Azure service

- [Time Series Insights][time-series]

#### Workload

- Records are generally appended sequentially in time order.
- An overwhelming proportion of operations (95-99%) are writes.
- Updates are rare.
- Deletes occur in bulk, and are made to contiguous blocks or records.
- Data is read sequentially in either ascending or descending time order, often in parallel.

#### Data type

 - A timestamp is used as the primary key and sorting mechanism.
 - Tags may define additional information about the type, origin, and other information about the entry.

#### Examples

- Monitoring and event telemetry.
- Sensor or other IoT data.

### Object storage

Object storage is optimized for storing and retrieving large binary objects (images, files, video and audio streams, large application data objects and documents, virtual machine disk images). Object stores can manage extremely large amounts of unstructured data.

#### Azure service

- [Blob Storage][blob]

#### Workload

- Identified by key.
- Content is typically an asset such as a spreadsheet, image, or video file.
- Content must be durable and external to any application tier.

#### Data type

- Data size is large.
- Value is opaque.

#### Examples

- Images, videos, office documents, PDFs
- Static HTML, JSON, CSS
- Log and audit files
- Database backups

### Shared files

Sometimes, using simple flat files can be the most effective means of storing and retrieving information. Using file shares enables files to be accessed across a network. Given appropriate security and concurrent access control mechanisms, sharing data in this way can enable distributed services to provide highly scalable data access for performing basic, low-level operations such as simple read and write requests.

#### Azure service

[File Storage][file-storage]

### Shared files

#### Workload

- Migration from existing apps that interact with the file system.
- Requires SMB interface.

#### Data type

- Files in a hierarchical set of folders.
- Accessible with standard I/O libraries.

#### Examples

- Legacy files
- Shared content accessible among a number of VMs or app instances

## General considerations

Keep the following considerations in mind when making your selection. 

### Functional requirements

- **Data format**. What type of data are you intending to store? Common types include transactional data, JSON objects, telemetry, search indexes, or flat files.

- **Data size**. How large are the entities you need to store? Will these entities need to be maintained as a single document, or can they be split across multiple documents, tables, collections, and so forth?

- **Scale and structure**. What is the overall amount of storage capacity you need? Do you anticipate partitioning your data?

- **Data relationships**. Will your data need to support one-to-many or many-to-many relationships? Are relationships themselves an important part of the data? Will you need to join or otherwise combine data from within the same dataset, or from external datasets?

- **Consistency model**. How important is it for updates made in one node to appear in other nodes, before further changes can be made? Can you accept eventual consistency? Do you need ACID guarantees for transactions?

- **Schema flexibility**. What kind of schemas will you apply to your data? Will you use a fixed schema, a schema-on-write approach, or a schema-on-read approach?

- **Concurrency**. What kind of concurrency mechanism do you want to use when updating and synchronizing data? Will the application perform many updates that could potentially conflict. If so, you may require record locking and pessimistic concurrency control. Alternatively, can you support optimistic concurrency controls? If so, is simple timestamp-based concurrency control enough, or do you need the added functionality of multi-version concurrency control?

- **Data movement**. Will your solution need to perform ETL tasks to move data to other stores or data warehouses?

- **Data lifecycle**. Is the data write-once, read-many? Can it be moved into cool or cold storage?

- **Other supported features**. Do you need any other specific features, such as schema validation, aggregation, indexing, full-text search, MapReduce, or other query capabilities?

### Non-functional requirements

- **Performance and scalability**. What are your data performance requirements? Do you have specific requirements for data ingestion rates and data processing rates? What are the acceptable response times for querying and aggregation of data once ingested? How large will you need the data store to scale up? Is your workload more read-heavy or write-heavy?

- **Reliability**. What overall SLA do you need to support? What level of fault-tolerance do you need to provide for data consumers? What kind of backup and restore capabilities do you need?

- **Replication**. Will your data need to be distributed among multiple replicas or regions? What kind of data replication capabilities do you require?

- **Limits**. Will the limits of a particular data store support your requirements for scale, number of connections, and throughput?

### Management and cost

- **Managed service**. When possible, use a managed data service, unless you require specific capabilities that can only be found in an IaaS-hosted data store.

- **Region availability**. For managed services, is the service available in all Azure regions? Does your solution need to be hosted in certain Azure regions?

- **Portability**. Will your data need to be migrated to on-premises, external datacenters, or other cloud hosting environments?

- **Licensing**. Do you have a preference of a proprietary versus OSS license type? Are there any other external restrictions on what type of license you can use?

- **Overall cost**. What is the overall cost of using the service within your solution? How many instances will need to run, to support your uptime and throughput requirements? Consider operations costs in this calculation. One reason to prefer managed services is the reduced operational cost.

- **Cost effectiveness**. Can you partition your data, to store it more cost effectively? For example, can you move large objects out of an expensive relational database into an object store?

### Security

- **Security**. What type of encryption do you require? Do you need encryption at rest? What authentication mechanism do you want to use to connect to your data?

- **Auditing**. What kind of audit log do you need to generate?

- **Networking requirements**. Do you need to restrict or otherwise manage access to your data from other network resources? Does data need to be accessible only from inside the Azure environment? Does the data need to be accessible from specific IP addresses or subnets? Does it need to be accessible from applications or services hosted on-premises or in other external datacenters?

### DevOps

- **Skill set**. Are there particular programming languages, operating systems, or other technology that your team is particularly adept at using? Are there others that would be difficult for your team to work with?

- **Clients** Is there good client support for your development languages?

<!-- markdownlint-enable MD033 -->

<!-- links -->

[blob]: https://azure.microsoft.com/services/storage/blobs/
[cosmos-db]: /azure/cosmos-db/
[cosmos-gremlin]: /azure/cosmos-db/graph-introduction
[data-lake]: https://azure.microsoft.com/solutions/data-lake/
[file-storage]: https://azure.microsoft.com/services/storage/files/
[hbase]: /azure/hdinsight/hdinsight-hbase-overview
[mysql]: https://azure.microsoft.com/services/mysql/
[postgres]: https://azure.microsoft.com/services/postgresql/
[mariadb]: https://azure.microsoft.com/services/mariadb/
[redis]: https://azure.microsoft.com/services/cache/
[search]: https://azure.microsoft.com/services/search/
[sql-db]: https://azure.microsoft.com/services/sql-database
[sql-dw]: https://azure.microsoft.com/services/sql-data-warehouse/
[time-series]: https://azure.microsoft.com/services/time-series-insights/