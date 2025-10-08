---
title: Choose an Analytical Data Store in Microsoft Fabric
description: Evaluate analytical data store options in Microsoft Fabric based on data volumes, types, compute engine, ingestion, transformation, and query patterns.
author: slavatrofimov
ms.author: slavatrofimov
ms.date: 04/15/2025
ms.topic: conceptual
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

Analytical data stores are essential for storing, processing, and serving data to support various analytical workloads. [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a unified data platform that provides several analytical data stores, including SQL databases, data warehouses, lakehouses, and eventhouses, delivered as software as a service (SaaS). Each data store provides distinct capabilities to address different analytical requirements. Selecting the right analytical data store depends on factors such as data volume, data type, compute engine, ingestion and transformation patterns, query needs, access controls, and integration with OneLake and other Microsoft Fabric components. This article compares the available analytical data stores and provides a decision guide to help you choose the best option for common workloads.

## Overview of primary analytical data stores in Microsoft Fabric

This article covers SQL databases, data warehouses, lakehouses, and eventhouses as the primary analytical data stores in Microsoft Fabric. Microsoft Fabric also has other items that can store data but aren't treated as primary analytical data stores. For example, Power BI semantic models can store data, but they're typically used as a semantic layer. Similarly, other Power BI items, like Power BI Dataflows Gen 1, store data for Power BI solutions only and aren't included in this article.

### SQL databases

SQL databases in Microsoft Fabric support structured data and accommodate both transactional and analytical workloads. They're ideal for moderate data volumes, typically between several gigabytes (GB) and a few terabytes (TB). SQL databases handle a broad range of data types, from integers, strings, and dates to geometry, geography, JSON, and XML.

A mature and efficient T-SQL-based relational engine underpins SQL databases. It handles high-frequency updates and operations that require transactional consistency and referential integrity. SQL databases support batch and transactional data ingestion. They also perform data transformation through stored procedures, views, user-defined functions, and SQL queries.

SQL databases provide low-latency queries, highly selective lookups, and concurrent data retrieval. They enforce granular access controls at the object, column, and row levels. Automatic OneLake mirroring ensures that SQL databases integrate seamlessly with the broader Fabric ecosystem. You can process data with any Fabric compute engine, run cross-warehouse queries, connect to Direct Lake mode semantic models in Power BI, and more.

### Data warehouses

Data warehouses in Microsoft Fabric support large-scale analytical workloads and handle data volumes that range from GB to petabytes (PB). They use a relational engine that delivers high-throughput batch data ingestion and flexible transformations through stored procedures, views, and other T-SQL queries. Data warehouses excel at diverse query patterns and complex analytics over vast data sets. Efficient workload management and burstable capacity ensure high concurrency and extensive access controls at the object, column, and row levels. Fabric data warehouses store data in OneLake and expose it in Delta format to any Fabric compute engine.

### Lakehouses

Lakehouses combine features of data lakes and data warehouses and provide a unified platform for structured and unstructured data. They handle can manage up to PB of data and support structured, semi-structured, and unstructured types.

Lakehouses use a flexible, scalable Spark compute engine that supports PySpark, Spark SQL, Scala, and R for data engineering and data science. They support both batch and real-time ingestion to meet diverse analytical workloads. Spark-based processing supports complex engineering and data science scenarios.

Lakehouses sit on OneLake and store data in Delta format to promote sharing and interoperability across the enterprise. An integrated SQL analytics endpoint lets you query OneLake data with T-SQL as if it's a relational data warehouse. It enforces granular access controls at the object, column, and row levels. Lakehouses excel at analytical data retrieval and can query massive data volumes.

### Eventhouses

Eventhouses in Microsoft Fabric handle real-time event processing and analytics at millions of events per second. They ingest structured, semi-structured, and unstructured data for streaming events and time series analysis. Kusto Query Language (KQL) and a subset of T-SQL power real-time analytics and event processing in Eventhouses. Real-time ingestion patterns optimize for high-velocity streams, and batch ingestion is also supported. KQL update policies transform data and enable real-time analytics.

Eventhouses scale efficiently to support concurrent query patterns and enforce granular access controls at the object, column, and row levels. You can configure Eventhouses to publish data automatically to OneLake for consumption by other Fabric experiences. This configuration adds some latency but makes it suitable for consumption by other Fabric experiences.

## Comparison of analytical data stores

The following table provides a comparison of key features of analytical data stores in Microsoft Fabric. Throughout this table, a ✅ symbol indicates that the capability is readily supported and recommended. The ⚠️ symbol indicates that the capability is supported with some considerations or limitations. The ❌ symbol indicates that the capability is typically not supported or not recommended.

There's no commonly accepted definition for the terms *small data* and *big data*, and definitions of these terms will continue to change over time along with evolving capabilities of data platforms. In this decision guide, *small data* generally refers to the total data volumes that range from megabytes (MB) to hundreds of GB, with individual tables up to a hundred GB in size and up to tens of GB of data ingested per day. The term *big data* generally refers to data volumes measured in tens of TB to PB, individual tables that are multiple TB in size, and data ingestion rates that exceed hundreds of GB per day. Data volumes that fall between the *small data* and *big data* thresholds can be described as *moderate* or *medium* data.

| Capability || SQL database | Data warehouse | Lakehouse | Eventhouse |
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
||||| (PySpark, Spark SQL, Scala, R), Python ||
|| Read operations | T-SQL | T-SQL | T-SQL, Spark | KQL, T-SQL |
||||| (PySpark, Spark SQL, Scala, R), Python ||
| **Data ingestion patterns** ||||||
|| Typical ingestion frequency | Moderate-high | Moderate | Moderate-high | High |
|| Recommended batch size | Small-medium | Medium-large | Small-large | Small-large |
|| Efficiency of appends | High | High | High | High |
|| Efficiency of updates and deletes | High | Moderate | Moderate | Low |
| **Data ingestion tools (in Microsoft Fabric)** ||||||
|| Pipelines | ✅ | ✅ | ✅ | ✅ |
|| Dataflows Gen 2 | ✅ | ✅ | ✅ | ✅ |
|| Shortcuts | ❌ | ⚠️ | ✅ | ✅ |
|| Eventstreams | ❌ | ❌ | ✅ | ✅ |
|| Spark connectors | ⚠️ | ⚠️ | ✅ | ⚠️ |
|| T-SQL commands | ✅ | ✅ | ❌ | ❌ |
|| KQL commands | ❌ | ❌ | ❌ | ✅ |
| **Data transformation capabilities** ||||||
|| Various types of supported structured data | High | Moderate | Moderate | Moderate |
|| Parsing of semi-structured data | ⚠️ | ⚠️ | ✅ | ✅ |
|| Parsing of unstructured data | ❌  | ❌  | ✅ | ⚠️ |
|| SQL support (any dialect) | ✅ | ✅ | ✅ | ⚠️ |
|| SQL surface area (any dialect) | Broad | Moderate | Broad | Limited<sup>2</sup> |
|| T-SQL surface area  | Broad | Moderate | Limited<sup>2</sup> | Limited<sup>2</sup> |
|| Python support | ❌ | ❌ | ✅ | ⚠️ |
|| Spark support (PySpark, Spark SQL, Scala, R) | ❌ | ❌ | ✅ | ❌ |
|| KQL support | ❌ | ❌ | ❌ | ✅ |
|| Transformation extensibility<sup>3</sup> | Moderate | Moderate | Very high | High |
|| Single-table transaction support | ✅ | ✅ | ✅ | ✅ |
|| Multi-table transaction support  | ✅ | ✅ | ❌ | ⚠️ |
| **Data retrieval patterns** ||||||
|| Optimized for selective lookups | ✅ | ❌ | ❌ | ✅ |
|| Optimized for large scans and aggregations | ⚠️ | ✅ | ✅ | ✅ |
|| Ideal query run time<sup>4</sup> | Milliseconds+ | Tens of milliseconds+ | Tens of milliseconds+ | Milliseconds+ |
|| Realistic query run time<sup>5</sup> | Subsecond+ | Seconds+ | Seconds+ | Subsecond+ |
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
| | Administrative skillset needed to manage or tune compute resources | Low | Low | Moderate-high | Low |

**Notes:**

<sup>1</sup> Data warehouses, lakehouses, and eventhouses don't have minimum data volume requirements and provide equivalent functionality at all data volumes. However, some benefits provided by these highly scalable systems might not be fully realized with small data volumes.

<sup>2</sup> Lakehouses and eventhouses support a subset of T-SQL surface area and are limited to read-only operations.

<sup>3</sup> Refers to the ability to extend data transformations by using user-defined functions, methods, referencing external modules or libraries, and other methods.

<sup>4</sup> Represents lower bounds of run times for light queries by using small volumes of data from warm cache, excluding network latency or the time needed to render results in a client application. Numerous factors can heavily influence query run times. Results might vary based on your specific workload.

<sup>5</sup> Represents lower bounds of response times to mixed queries using moderate volumes of data, excluding network latency or the time needed to render results in a client application. Query run times can be heavily influenced by numerous factors and results might vary with your specific workload.

<sup>6</sup> Peak number of queries that can be executing simultaneously, relative to other analytical data stores.

<sup>7</sup> Peak number of queries that can be completed over a given period of time, relative to other analytical data stores. Concurrency, query duration, and other factors affect the number of queries.

<sup>8</sup> Partial object-level security is implemented using Restricted View Access Policies.

<sup>9</sup> Granular access controls are available for the SQL analytics endpoint.

<sup>10</sup> OneLake integration is implemented via automatic database mirroring.

<sup>11</sup> Via automatic sync from KQL Database to OneLake.

<sup>12</sup> Indirectly, via cross-database queries to Lakehouses.

<sup>13</sup> Available for mirrored data accessed via the SQL analytics endpoint.

## Decision tree for analytical store selection in Microsoft Fabric

The following decision guide helps you select a suitable data store for each use case or data product. You might need more than one analytical data store to support different workloads in your data estate.

:::image type="complex" border="false" source="../images/fabric-data-stores-decision-tree.png" alt-text="Diagram that shows a decision tree describing how to select an appropriate data store in Microsoft Fabric for different scenarios." lightbox="../images/fabric-data-stores-decision-tree.png":::
  Decision tree diagram for selecting an analytical data store in Microsoft Fabric. The diagram begins by asking about the volume of data, such as small, moderate, or big data. It then guides users through questions about data type, including structured, semi-structured, or unstructured data. Next, it considers the ingestion pattern, which can be batch or real-time, and query requirements, such as selective lookups, large scans, aggregations, or real-time analytics. Based on the answers, the tree directs users to the recommended data store: SQL database, Data warehouse, Lakehouse, or Eventhouse. The diagram visually illustrates how different workload characteristics map to the most suitable analytical data store in Microsoft Fabric.
:::image-end:::

## Conclusion

SQL databases, data warehouses, lakehouses, and eventhouses enable Microsoft Fabric to handle diverse analytical workloads. Each of these analytical data stores provides a unique blend of capabilities and limitations that must be matched to the workload to achieve optimal results. Some use cases can be addressed by using a single analytical data store. However, specific complex use cases that involve mixed workloads are best served by using multiple complementary analytical data stores, which are readily available in Microsoft Fabric as the unified data platform.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Slava Trofimov](https://www.linkedin.com/in/slava-trofimov/) | Principal Technical Specialist

Other contributors:

- [Panos Antonopoulos](https://www.linkedin.com/in/panagiotis-antonopoulos) | Distinguished Engineer
- [Miles Cole](https://www.linkedin.com/in/mileswcole/) | Principal Program Manager
- [Anna Hoffman](https://www.linkedin.com/in/amthomas46) | Principal Group Product Manager
- [Joanna Podgoetsky](https://www.linkedin.com/in/joanpo) | Principal PM Manager
- [Shane Risk](https://www.linkedin.com/in/shanerisk/) | Principal PM Manager
- [Brad Schacht](https://www.linkedin.com/in/bradleyschacht/) | Principal Program Manager
- [Marcelo Silva](https://www.linkedin.com/in/marcelo-silva-azure/) | Senior Data Engineer
- [Buck Woody](https://www.linkedin.com/in/buckwoody/) | Principal Data Scientist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Fabric decision guide: Choose a data store](/fabric/fundamentals/decision-guide-data-store)
- [Microsoft Fabric decision guide: Choose between Warehouse and Lakehouse](/fabric/fundamentals/decision-guide-lakehouse-warehouse)
- [SQL database in Microsoft Fabric](/fabric/database/sql/overview)
- [Lakehouse in Microsoft Fabric](/fabric/data-engineering/lakehouse-overview)
- [Data warehouse in Microsoft Fabric](/fabric/data-warehouse/data-warehousing)
- [Eventhouse in Microsoft Fabric](/fabric/real-time-intelligence/eventhouse)
