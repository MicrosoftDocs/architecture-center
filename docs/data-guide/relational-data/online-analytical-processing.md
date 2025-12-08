---
title: Online Analytical Processing
description: Learn about online analytical processing solutions to organize large databases and support complex analysis without affecting transactional systems.
author: amattas
ms.author: amattas
ms.date: 04/11/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-data
---

# Online analytical processing

Online analytical processing (OLAP) is a technology that organizes large business databases to perform complex calculations and trend analysis. This method enables intricate queries without disrupting transactional systems.

Business transactions and records are stored in databases known as *online transaction processing (OLTP) databases*, which are optimized for individual record entries. These databases hold valuable information, but they're not designed for analysis, so data retrieval is time-consuming and difficult.

To address this problem, OLAP systems efficiently extract business intelligence from data. OLAP databases are optimized for heavy-read and low-write tasks. They're modeled and cleansed for effective analysis. OLAP databases often preserve historical data for time-series analysis.

OLAP systems traditionally use multidimensional data cubes to organize data in a way that supports complex queries and analysis. The following diagram shows a traditional OLAP system architecture.

:::image type="complex" source="../images/olap-data-pipeline.svg" lightbox="../images/olap-data-pipeline.svg" alt-text="Diagram that shows a traditional OLAP logical architecture in Azure that uses Analysis Services." border="false":::
This diagram shows a flow from the client applications, to the OLTP system, to the OLAP system, and finally to analytics and reporting. The client applications contain web apps, API apps, and logic apps. The OLTP system contains SQL Database, SQL Server on VMs, Azure Database for MySQL, and Azure Database for PostgreSQL. The OLAP system contains Azure Analysis Services. Analytics and reporting contains Power BI and SQL Server reporting services. Orchestration runs along the bottom of the OLTP system and the OLAP system. It contains SQL Server Integration Services and Azure Data Factory.
:::image-end:::

As technology progresses and both data and computation scales increase, OLAP systems transition to massively parallel processing (MPP) architectures that [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) supports. For more information, see [Fabric analytical data store](https://techcommunity.microsoft.com/blog/analyticsonazure/decision-guide-for-selecting-an-analytical-data-store-in-microsoft-fabric/4362079).

The following diagram shows a modern OLAP system architecture.

:::image type="complex" source="../images/olap-fabric.svg" lightbox="../images/olap-fabric.svg" alt-text="Diagram that shows a modern OLAP logical architecture in Azure that uses Fabric." border="false":::
This diagram shows a flow from the client application, to the OLTP system, to the OLAP system - Fabric. The client application contains web apps, API apps, and logic apps. The OLTP system contains on-premises databases, Azure databases, Azure Database for MySQL, and Azure Database for PostgreSQL. The OLAP system contains One Lake and Power BI. Orchestration runs along the bottom of the OLTP systems and is integrated with the OLAP system. It contains Azure Data Factory.
:::image-end:::

## Semantic modeling

A semantic data model is a conceptual model that describes the meaning of the data elements that it contains. Organizations often have their own terms for items, and sometimes those terms have synonyms. Organizations might also have different meanings for the same term. For example, an inventory database might track a piece of equipment by using an asset ID and a serial number. But a sales database might refer to the serial number as the asset ID. There's no simple way to relate these values without a model that describes the relationship.

Semantic modeling provides a level of abstraction over the database schema so that users don't need to know the underlying data structures. End users can easily query data without performing aggregates and joins over the underlying schema. Columns are often renamed to more user-friendly names to make the context and meaning of the data more obvious.

Semantic modeling is predominately for read-heavy scenarios, such as analytics and business intelligence (OLAP), rather than more write-heavy transactional data processing (OLTP). Semantic modeling suits read-heavy scenarios because of the characteristics of a typical semantic layer:

- Aggregation behaviors are set so that reporting tools display them properly.
- Business logic and calculations are defined.
- Time-oriented calculations are included.
- Data is often integrated from multiple sources.
- Real-time analytics are supported.

Traditionally, the semantic layer is placed over a data warehouse for these reasons.

:::image type="complex" source="../images/semantic-modeling.png" lightbox="../images/semantic-modeling.png" alt-text="Diagram that shows a semantic layer between a data warehouse and a reporting tool." border="false":::
The diagram flow starts at source data. The source data goes to the data warehouse, to the semantic layer, and then to reporting and analysis. The semantic layer contains the data model, calculations, and relationships. 
:::image-end:::

There are two primary types of semantic models:

- **Tabular models** use relational modeling constructs, such as models, tables, and columns. Internally, metadata is inherited from OLAP modeling constructs, such as cubes, dimensions, and measures. Code and script use OLAP metadata.

- **Multidimensional models** use traditional OLAP modeling constructs, such as cubes, dimensions, and measures.

[Analysis Services](https://azure.microsoft.com/services/analysis-services/) and [Fabric](/fabric/get-started/microsoft-fabric-overview) provide the necessary infrastructure and tools to implement semantic modeling effectively.

## Example use case

An organization stores data in a large database. It wants to make this data available to business users and customers to create their own reports and do analysis.

They could give those users direct access to the database, but this option has drawbacks, including security management and access control. And users might have difficulty understanding the design of the database, including the names of tables and columns. This option requires users to know which tables to query, how those tables should be joined, and how to apply other business logic to get the correct results. Users also need to know a query language like SQL. Typically, this option leads to multiple users reporting the same metrics but with different results.

A better option is to encapsulate all the information that users need into a semantic model. Users can more easily query the semantic model by using a reporting tool of their choice. The data that the semantic model provides comes from a data warehouse, which ensures that all users view a single source of truth. The semantic model also provides user-friendly table and column names, defines relationships between tables, includes descriptions and calculations, and enforces row-level security.

## Typical traits of semantic modeling

Semantic modeling and analytical processing tends to have the following traits.

| Requirement | Description |
| --- | --- |
| Schema | Schema on write, strongly enforced|
| Uses transactions | No |
| Locking strategy | None |
| Updateable | No, typically requires recomputing cube |
| Appendable | No, typically requires recomputing cube |
| Workload | Heavy reads, read-only |
| Indexing | Multidimensional indexing |
| Datum size | Small to massively large size |
| Model | Tabular or multidimensional |
| Data shape | Cube, star, or snowflake schema |
| Query flexibility | Highly flexible |
| Scale | Large, hundreds of gigabytes (GBs) to multiple petabytes (PBs) |

## When to use this solution

Consider using OLAP for the following scenarios:

- You need to run complex analytical and on-demand queries rapidly, without negatively affecting your OLTP systems.

- You want to provide business users with a simple way to generate reports from your data.
- You want to provide several aggregations that allow users to get fast, consistent results.

OLAP is especially useful for applying aggregate calculations over large amounts of data. OLAP systems are optimized for read-heavy scenarios. OLAP also allows users to segment multidimensional data into slices that they can view in two dimensions, such as a pivot table. Or they can filter the data by specific values. Users can do these processes, known as *slicing and dicing* the data, regardless of whether the data is partitioned across several data sources. Users can easily explore the data without knowing the details of traditional data analysis.

Semantic models can help business users abstract relationship complexities and make it easier to analyze data quickly.

## Challenges

OLAP systems also produce challenges:

- Transactions that flow in from various sources constantly update data in OLTP systems. OLAP data stores typically refresh at much slower intervals, depending on business needs. OLAP systems suit strategic business decisions, rather than immediate responses to changes. You must also plan some level of data cleansing and orchestration to keep the OLAP data stores up-to-date.

- Unlike traditional, normalized relational tables in OLTP systems, OLAP data models tend to be multidimensional. So it's difficult or impossible to directly map them to entity-relationship or object-oriented models, where each attribute corresponds to one column. Instead, OLAP systems typically use a star or snowflake schema instead of traditional normalization.

## OLAP in Azure

In Azure, data in OLTP systems, such as Azure SQL Database, is copied into OLAP systems like [Fabric](/fabric/get-started/microsoft-fabric-overview) or [Analysis Services](/azure/analysis-services/). Data exploration and visualization tools like [Power BI](https://powerbi.microsoft.com), Excel, and non-Microsoft options connect to Analysis Services servers and provide users with highly interactive and visually rich insights into the modeled data. You can use SQL Server Integration Services to orchestrate the flow of data from OLTP systems to OLAP systems. To implement SQL Server Integration Services, use [Azure Data Factory](/azure/data-factory/concepts-integration-runtime).

The following Azure data stores meet the core requirements for OLAP:

- [Fabric](/fabric/get-started/microsoft-fabric-overview)
- [SQL Server with columnstore indexes](/sql/relational-databases/indexes/columnstore-indexes-overview)
- [Analysis Services](/azure/analysis-services/)
- [SQL Server Analysis Services](/analysis-services/ssas-overview)

SQL Server Analysis Services provides OLAP and data-mining functionality for business intelligence applications. You can either install SQL Server Analysis Services on local servers or host it within a virtual machine (VM) in Azure. Analysis Services is a fully managed service that provides the same major features as SQL Server Analysis Services. Analysis Services supports connecting to [various data sources](/azure/analysis-services/analysis-services-datasource) in the cloud and on-premises in your organization.

Clustered columnstore indexes are available in SQL Server 2014 and higher and in SQL Database. These indexes are ideal for OLAP workloads. Beginning with SQL Server 2016, including SQL Database, you can take advantage of hybrid transactional and analytical processing (HTAP) through updateable nonclustered columnstore indexes. Use HTAP to perform OLTP and OLAP processing on the same platform. This approach eliminates the need for multiple copies of your data and separate OLTP and OLAP systems. For more information, see [Columnstore for real-time operational analytics](/sql/relational-databases/indexes/get-started-with-columnstore-for-real-time-operational-analytics).

## Key selection criteria

To narrow the choices, answer the following questions:

- **Do you want a managed service rather than managing your own servers?**

- **Do you require Microsoft Entra ID for secure authentication?**

- **Do you need to integrate data from several sources, beyond your OLTP data store?**

- **Do you want to conduct real-time analytics?**

  [Fabric Real-Time Intelligence](/fabric/real-time-intelligence/overview) is a powerful service within Fabric that you can use to extract insights and visualize your data in motion. It provides an end-to-end solution for event-driven scenarios, streaming data, and data logs. Whether you manage GBs or PBs of data, all organizational data in motion converges in the Real-Time hub.

- **Do you need to use pre-aggregated data, for example to provide semantic models that make analytics easier for business users?**

  If yes, choose an option that supports multidimensional cubes or tabular semantic models.

  Provide aggregates to help users consistently calculate data aggregates. Pre-aggregated data can also provide a large performance boost if you have several columns across many rows. You can pre-aggregate data in multidimensional cubes or tabular semantic models.

## Capability matrix

The following tables summarize the key differences in capabilities between these services:
- Fabric
- Analysis Services
- SQL Server Analysis Services
- SQL Server with columnstore indexes
- SQL Database with columnstore indexes

### General capabilities

| Capability | Fabric | Analysis Services | SQL Server Analysis Services | SQL Server with columnstore indexes | SQL Database with columnstore indexes |
| --- | --- | --- | --- | --- | --- |
| Is a managed service | Yes | Yes | No | No | Yes |
| MPP | Yes | No | No | No | No |
| Supports multidimensional cubes | No | No | Yes | No | No |
| Supports tabular semantic models | Yes |Yes | Yes | No | No |
| Easily integrates multiple data sources | Yes |Yes | Yes | No <sup>1</sup> | No <sup>1</sup> |
| Supports real-time analytics | Yes |No | No | Yes | Yes |
| Requires a process to copy data from sources | Optional&nbsp;<sup>3</sup> | Yes | Yes | No | No |
| Microsoft Entra integration | Yes |Yes | No | No <sup>2</sup> | Yes |

[1] SQL Server and SQL Database can't query from and integrate multiple external data sources, but you can build a pipeline to do these functions by using [SQL Server Integration Services](/sql/integration-services/sql-server-integration-services) or [Azure Data Factory](/azure/data-factory/). Azure VM-hosted SQL Server has more options, such as linked servers and [PolyBase](/sql/relational-databases/polybase/polybase-guide). For more information, see [Choose a data pipeline orchestration technology](../technology-choices/pipeline-orchestration-data-movement.md).

[2] A Microsoft Entra account doesn't support connecting to Azure VM-hosted SQL Server. Use a domain Windows Server Active Directory account instead.

[3] Fabric provides the flexibility to integrate data sources by moving data into OneLake via Azure Data Factory pipelines or mirroring. You can also create shortcuts or do real-time analytics on data streams without moving the data.

### Scalability capabilities

| Capability | Fabric | Analysis Services | SQL Server Analysis Services | SQL Server with columnstore indexes | SQL Database with columnstore indexes |
|-----|--------------------------------------------------|-------------------------|------------------------------|-------------------------------------|---------------------------------------------|
| Redundant regional servers for high availability | Yes |           Yes           |              No              |                 Yes                 |                     Yes                     |
|             Supports query scale-out             |      Yes |     Yes           |              No              |                 Yes                 |                     Yes                      |
|          Dynamic scalability, scale-up          |  Yes |         Yes           |              No              |                 Yes                 |                     Yes                      |

## Next steps

- [Fabric analytical data store](https://techcommunity.microsoft.com/blog/analyticsonazure/decision-guide-for-selecting-an-analytical-data-store-in-microsoft-fabric/4362079)
- [Columnstore indexes](/sql/relational-databases/indexes/columnstore-indexes-overview)
- [Create an Analysis Services server](/azure/analysis-services/analysis-services-create-server)
- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)

## Related resources

- [Big data architecture style](../../guide/architecture-styles/big-data.md)
