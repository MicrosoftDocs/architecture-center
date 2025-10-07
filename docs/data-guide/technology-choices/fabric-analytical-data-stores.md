---
title: Choose an Analytical Data Store in Microsoft Fabric
description: Evaluate analytical data store options in Microsoft Fabric based on data volumes, types, compute engine, ingestion, transformation, and query patterns.
author: slavatrofimov
ms.author: slavatrofimov
ms.date: 04/15/2025
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
categories:
  - storage
products:
  - azure
  - Microsoft Fabric
ms.custom:
  - guide
---

# Choose an analytical data store in Microsoft Fabric

Analytical data stores form the foundation for analytical solutions by storing, processing, and serving data for a wide range of analytical workloads. [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a unified data platform that provides multiple analytical data stores, such as SQL Databases, Data Warehouses, Lakehouses, and Eventhouses, in a convenient SaaS (Software as a Service) form factor. Each data store provides a compelling blend of functionality and capabilities, which make Microsoft Fabric uniquely capable of handling diverse analytical needs. The choice of an optimal analytical data store is influenced by numerous factors, such as data volumes, data types, desired compute engines, data ingestion patterns, data transformation capabilities, data retrieval patterns, need for granular access controls, the need for integration with OneLake and other components of Microsoft Fabric. This document compares analytical data stores and provides a decision guide for selecting a suitable data store for common workloads.

## Overview of primary analytical data stores in Microsoft Fabric

This article covers SQL Databases, Data Warehouses, Lakehouses, and Eventhouses as the primary analytical data stores in Microsoft Fabric. Note that Microsoft Fabric provides other types of items that might physically store data, but are excluded from the list of primary analytical data stores. For example, Power BI Semantic Models might physically store data; yet, they typically serve as the semantic layer over other analytical data stores. Similarly, other Power BI items, such as Dataflows Gen 1, are excluded from this article due to their narrower focus on storing data exclusively for Power BI solutions.

### SQL databases

SQL Databases in Microsoft Fabric are designed for structured data and can support transactional and analytical workloads. They're ideal for scenarios where data volumes are moderate, typically ranging from several gigabytes to a few terabytes. SQL Databases support a wide variety of structured data types, ranging from integers, strings, and dates to more specialized types, such as geometry, geography, JSON, XML, and more. SQL Databases fully implement the mature and efficient T-SQL-based relational database engine, making them suitable for high-frequency updates and operations that require transactional consistency and referential integrity. SQL Databases support batch and transactional data ingestion patterns and provide data transformation capabilities through stored procedures, views, user defined functions, and SQL queries. They're optimized for low-latency queries, highly selective lookups, and highly concurrent data retrieval patterns. SQL Databases provide robust granular access controls, including object-level, column-level, and row-level security. Furthermore, because of automatic OneLake mirroring, SQL Databases in Fabric seamlessly integrate with the broader Fabric ecosystem to support data processing by any Fabric compute engine, cross-warehouse queries, Direct Lake mode semantic models in Power BI, and more.

### Data warehouses

Data Warehouses in Microsoft Fabric are optimized for large-scale analytical workloads and can effectively handle data volumes, ranging from gigabytes to petabytes. They primarily support structured data types and are optimized for diverse queries and analytical workloads. Data Warehouses use a relational engine and are designed for high-throughput batch data ingestion and flexible transformations using stored procedures, views, and other T-SQL queries. Data Warehouses are optimized for analytical data retrieval patterns and excel at executing diverse queries over large volumes of data. Efficient workload management and burstable capacities allow Data Warehouses to reach high levels of concurrency. Data Warehouses provide extensive access controls including object-level, column-level, and row-level security. Fabric Data Warehouses physically store data in OneLake and expose it in Delta format to any Fabric compute engine.

### Lakehouses

Lakehouses combine the features of data lakes and data warehouses, providing a unified platform for both structured and unstructured data. They can manage up to petabytes of data and support a wide range of data types, including structured, semi-structured, and unstructured. Lakehouses use flexible and scalable Spark compute engine, which supports PySpark, Spark SQL, Scala and R for data engineering and data science workloads. They support both batch and real-time data ingestion patterns, making their versatility an asset for diverse analytical workloads. Lakehouses provide data transformation capabilities through Spark-based processing, enabling complex data engineering and data science scenarios. Lakehouses are built on top of OneLake and typically store their data in the Delta format, which promotes sharing and interoperability across the entire enterprise. The integrated SQL Analytics Endpoint provides Lakehouses with the ability to query data that is physically stored in OneLake using the T-SQL language in a manner that resembles a relational data warehouse. Lakehouses tend to excel at analytical data retrieval patterns and can effectively query massive volumes of data. The SQL Analytics Endpoint of a Lakehouse provides granular access controls, including object-level, column-level, and row-level security.

### Eventhouses

Eventhouses in Microsoft Fabric are designed for real-time event processing and analytics, capable of handling high-velocity data streams and processing millions of events per second. They support structured, semi-structured, and unstructured data, tailored for streaming events and time series analysis. Eventhouses use Kusto Query Language (KQL) and a subset of T-SQL for real-time analytics and event processing. They support real-time data ingestion patterns, optimized for high-velocity data streams, but might also ingest data in a batch manner. Eventhouses provide data transformation capabilities through KQL queries (often implemented as update policies), enabling real-time data processing, and analytics. They're optimized for efficient, scalable, and highly concurrent query patterns that are often required for real-time analytics. KQL databases in Eventhouses support granular access controls to ensure that data is only accessed by authorized users. Eventhouses can be configured to make their data automatically available in OneLake, making it suitable for consumption by other Fabric experiences, albeit with some extra latency.

## Comparison of analytical data stores

The following table provides a comparison of key features of analytical data stores in Microsoft Fabric. Throughout this table, a ✅ symbol indicates that the capability is readily supported and recommended. The ⚠️ symbol indicates that the capability is supported with some considerations or limitations. The ❌ symbol indicates that the capability is typically not supported or not recommended.

Note: there is no commonly accepted definition for the terms *small data* and *big data*, and definitions of these terms will continue to change over time along with evolving capabilities of data platforms. Nevertheless, in this decision guide at the time of this writing, *small data* generally refers to total data volumes ranging from megabytes to hundreds of gigabytes, with individual tables up to a hundred gigabytes in size and up to tens of gigabytes of data ingested per day. The term *big data* generally refers to data volumes measured in tens of terabytes to petabytes, individual tables that are multiple terabytes in size and data ingestion rates exceeding hundreds of gigabytes per day. Data volumes that fall between the *small data* and *big data* thresholds can be described as *moderate* or *medium* data.

| Capability || SQL Database | Data Warehouse | Lakehouse | Eventhouse |
|---|---|:---:|:---:|:---:|:---:|
| **Data volumes** ||||||
|| Small | ✅ | ✅<sup>1</sup> | ✅<sup>1</sup>| ✅<sup>1</sup> |
|| Moderate | ✅ | ✅ | ✅ | ✅ |
|| Big data | ❌ | ✅ | ✅ | ✅ |
| **Supported types of data** ||||||
|| Structured | ✅ | ✅ | ✅ | ✅ |
|| Semi-structured | ⚠️ | ⚠️ | ✅ | ✅ |
|| Unstructured | ❌ | ❌ | ✅ | ✅|
| **Primary compute engine** ||||||
|| Write operations | T-SQL | T-SQL | Spark | KQL |
||||| (PySpark, Spark SQL,  Scala, R), Python ||
|| Read operations | T-SQL | T-SQL | T-SQL, Spark | KQL, T-SQL |
||||| (PySpark, Spark SQL, Scala, R), Python ||
| **Data ingestion patterns** ||||||
|| Typical ingestion frequency | Moderate-high | Moderate | Moderate-high | High |
|| Recommended batch size | Small-medium | Medium-large | Small-large | Small-large |
|| Efficiency of appends | High | High | High | High |
|| Efficiency of updates/deletes | High | Moderate | Moderate | Low |
| **Data ingestion tools (in Microsoft Fabric)** ||||||
|| Pipelines | ✅ | ✅ | ✅ | ✅ |
|| Dataflows Gen 2 | ✅ | ✅ | ✅ | ✅ |
|| Shortcuts | ❌ | ⚠️ | ✅ | ✅ |
|| Eventstreams | ❌ | ❌  | ✅ | ✅ |
|| Spark Connectors | ⚠️ | ⚠️ | ✅ | ⚠️ |
|| T-SQL Commands | ✅ | ✅ | ❌ | ❌ |
|| KQL Commands | ❌ | ❌ | ❌ | ✅ |
| **Data transformation capabilities** ||||||
|| Variety of supported structured data types | High | Moderate | Moderate | Moderate |
|| Parsing of semi-structured data | ⚠️ | ⚠️ | ✅ | ✅ |
|| Parsing of unstructured data | ❌  | ❌  | ✅ | ⚠️ |
|| SQL support (any dialect) | ✅ | ✅ | ✅ | ⚠️ |
|| SQL surface area (any dialect) | Broad | Moderate | Broad | Limited<sup>2</sup> |
|| T-SQL surface area  | Broad | Moderate | Limited<sup>2</sup> | Limited<sup>2</sup> |
|| Python support | ❌ | ❌ | ✅ | ⚠️ |
|| Spark support (PySpark, Spark SQL, Scala, R) | ❌ | ❌ | ✅ | ❌ |
|| KQL support | ❌ | ❌ | ❌ | ✅  |
|| Transformation extensibility<sup>3</sup> | Moderate | Moderate | Very high | High |
|| Single-table transaction support | ✅ | ✅  | ✅  | ✅ |
|| Multi-table transaction support  | ✅ | ✅  | ❌ | ⚠️ |
| **Data retrieval patterns** ||||||
|| Optimized for selective lookups | ✅ | ❌ | ❌ | ✅ |
|| Optimized for large scans and aggregations | ⚠️ | ✅ | ✅ | ✅ |
|| Ideal query execution time<sup>4</sup> | Milliseconds+ | Tens of milliseconds+ | Tens of milliseconds+ | Milliseconds+ |
|| Realistic query execution time<sup>5</sup> | Subsecond+ | Seconds+ | Seconds+ | Subsecond+ |
|| Peak query concurrency<sup>6</sup> | High | High | High | High |
|| Peak query throughput<sup>7</sup> | Very high | High | High | Very high |
| **Granular access controls** ||||||
|| Object-level security  | Yes | Yes | Yes | Yes<sup>8</sup> |
|| Column-level security | Yes | Yes | Yes<sup>9</sup> | No |
|| Row-level security | Yes | Yes | Yes<sup>9</sup> | Yes |
| **OneLake integration** ||||||
|| Data available in OneLake | Yes<sup>10</sup> | Yes | Yes | Yes<sup>11</sup>  |
|| Data stored in open format (Delta) | Yes<sup>10</sup> | Yes | Yes | Yes<sup>11</sup> |
|| Can be a source of shortcuts | Yes<sup>10</sup> | Yes | Yes  | Yes<sup>11</sup> |
|| Access data via shortcuts | No | Yes<sup>12</sup> | Yes | Yes |
|| Cross warehouse/lakehouse queries | Yes<sup>13</sup>| Yes | Yes | Yes<sup>11</sup> |
| **Compute management** ||||||
|| Ability to customize size and configuration of compute resources | Low | Low | High | Low |
| | Administrative skillset needed to manage or tune compute resources | Low | Low | Moderate-High | Low |

**Footnotes**

<sup>1.</sup> Data Warehouses, Lakehouses, and Eventhouses don't have minimum data volume requirements and provide equivalent functionality at all data volumes. Yet, some benefits provided by these highly-scalable systems might not be fully realized with small data volumes.

<sup>2.</sup> Lakehouses and Eventhouses support a subset of T-SQL surface area and are limited to read-only operations.

<sup>3.</sup> Refers to the ability to extend data transformations using user-defined functions, methods, referencing external modules or libraries, etc.

<sup>4.</sup> Represents lower bounds of execution times for light queries using small volumes of data from warm cache, excluding network latency or the time needed to render results in a client application. Query execution times can be heavily influenced by numerous factors and results might vary with your particular workload.

<sup>5.</sup> Represents lower bounds of response times to mixed queries using moderate volumes of data, excluding network latency or the time needed to render results in a client application. Query execution times can be heavily influenced by numerous factors and results might vary with your particular workload.

<sup>6.</sup> Peak number of queries that can be executing simultaneously, relative to other analytical data stores.

<sup>7.</sup> Peak number of queries that can be completed over a given period of time, relative to other analytical data stores. This number is influenced by concurrency, query duration, and other factors.

<sup>8.</sup> Partial object-level security is implemented using Restricted View Access Policies.

<sup>9.</sup> Granular access controls are available for the SQL Analytics Endpoint.

<sup>10.</sup> OneLake integration is implemented via automatic database mirroring.

<sup>11.</sup> Via automatic sync from KQL Database to OneLake.

<sup>12.</sup> Indirectly, via cross-database queries to Lakehouses.

<sup>13.</sup> Available for mirrored data accessed via the SQL Analytics Endpoint.

## Decision tree for analytical store selection in Microsoft Fabric

The following decision guide serves as a practical tool to help you select a suitable data store for a specific use case by answering a series of questions. In addition to selecting the primary data store, this decision guide might also suggest a complementary secondary data store to support your requirements more fully for a mixed analytical workload. This decision guide is intended to be applied for each use case or each individual data product with the understanding that multiple analytical data stores might be used to accommodate diverse workloads across your entire data estate.

:::image type="complex" border="false" source="../images/fabric-data-stores-decision-tree.png" alt-text="Diagram that shows a decision tree describing how to select an appropriate data store in Microsoft Fabric for different scenarios." lightbox="../images/fabric-data-stores-decision-tree.png":::
   Decision tree diagram for selecting an analytical data store in Microsoft Fabric. The diagram begins by asking about the volume of data (small, moderate, or big data), then guides users through questions about data type (structured, semi-structured, or unstructured), ingestion pattern (batch or real-time), and query requirements (selective lookups, large scans, aggregations, or real-time analytics). Based on the answers, the tree directs users to the recommended data store: SQL Database, Data Warehouse, Lakehouse, or Eventhouse. The diagram visually illustrates how different workload characteristics map to the most suitable analytical data store in Microsoft Fabric.
:::image-end:::

## Conclusion

SQL Databases, Data Warehouses, Lakehouses, and Eventhouses enable Microsoft Fabric to handle diverse analytical workloads. Each of these analytical data stores provides a unique blend of capabilities and limitations that must be matched to the workload to achieve optimal results. While some use cases can be addressed using a single analytical data store, certain complex use cases that involve mixed workloads are best served by using multiple complementary analytical data stores which are readily available in Microsoft Fabric as the unified data platform.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Slava Trofimov](https://www.linkedin.com/in/slava-trofimov/) | Principal Technical Specialist

Other contributors:

- [Panos Antonopoulos](https://www.linkedin.com/in/panagiotis-antonopoulos) |
- [Miles Cole](https://www.linkedin.com/in/mileswcole/) |
- [Anna Hoffman](https://www.linkedin.com/in/amthomas46) |
- [Joanna Podgoetsky](https://www.linkedin.com/in/joanpo) |
- [Shane Risk](https://www.linkedin.com/in/shanerisk/) |
- [Brad Schacht](https://www.linkedin.com/in/bradleyschacht/) |
- [Marcelo Silva](https://www.linkedin.com/in/marcelo-silva-azure/) |
- [Buck Woody](https://www.linkedin.com/in/buckwoody/) |

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Fabric decision guide: Choose a data store](/fabric/fundamentals/decision-guide-data-store)
- [Microsoft Fabric decision guide: Choose between Warehouse and Lakehouse](/fabric/fundamentals/decision-guide-lakehouse-warehouse)
- [SQL database in Microsoft Fabric](/fabric/database/sql/overview)
- [Lakehouse in Microsoft Fabric](/fabric/data-engineering/lakehouse-overview)
- [Data Warehouse in Microsoft Fabric](/fabric/data-warehouse/data-warehousing)
- [Eventhouse in Microsoft Fabric](/fabric/real-time-intelligence/eventhouse)
