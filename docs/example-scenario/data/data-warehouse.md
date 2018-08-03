---
title: Example scenario for data consolidation and analytics using a data warehouse in Azure
description: Use a data warehouse in Azure to consolidate data from multiple systems and optimize data analytics.
author: alexbuckgit
ms.date: 07/09/2018
---

# Example scenario for data consolidation and analytics using a data warehouse in Azure

In this scenario, a sales and marketing company builds incentive programs that reward customers, suppliers, salespeople, or employees. Data is fundamental to these programs, and the company wants to leverage the capabilities of Azure services to improve the insights gained through data analytics.

The company has numerous data sources across many different platforms, such as SQL Server on-premises, Oracle on-premises, Azure SQL Database, Azure table storage, and Cosmos DB. The company wants to modernize their data analytics approach to ensure they have the right data at the right time when making decisions. The company's goals include:
* Consolidating data from numerous heterogenous data sources to a cloud-scale data platform
* Transforming source data into a common taxonomy and structure for consistency and comparability.   
* Leveraging highly parallelized data loading to support thousands of incentive programs without the expense of on-premises infrastructure deployment and maintenance
* Significantly improving the ratio of time spent gathering and transforming data vs. time spent analyzing data

This example scenario is relevant to organizations that want to an integrated data pipeline from multiple data sources into a cloud-scale platform for advanced analysis and business intelligence capabilities. Potential applications include sales and marketing, e-commerce, healthcare, government, or other industry solutions involving large volumes of data that can deliver high business value through analysis. 

Using managed Azure services such as Data Factory and SQL Data Warehousecan significantly reduce costs by leveraging Microsoft's expertise in globally distributed cloud-scale data storage and analysis. If you have additional data service needs, you should review the list of available [fully managed intelligent database services in Azure][product-category].

## Potential use cases

Consider this solution for the following use cases:

* Creation and incremental revision of a data warehouse that serves as a single source of truth for your organization's data.
* Integration of relational data with binary data or other non-relational datasets.
* Analysis of large datasets by business data analysts through a well-defined semantic model and robust visualization tools.

## Architecture

![Architecture for a data warehouse scenario in Azure][architecture]

This example scenario is based on the [Azure automated enterprise BI reference architecture](/azure/architecture/reference-architectures/data/enterprise-bi-adf). The data flows through the solution as follows:

1. Data from each data source is periodically exported into Azure Blob storage, which serves as a staging area for the source data. Each export contains only the data that has changed since the previous export. 
2. Data Factory incrementally loads the staged data from Blob storage into staging tables in SQL Data Warehouse. Data cleansing and transformation happens at this stage, and Polybase can be used to parallelized the process for large volumes of data.
3. After a new batch of data is loaded into the warehouse, a previously created Analysis Services tabular model is refreshed. This provides a semantic model that simplifies the analysis of business data and relationships by business analysts.
4. Business analysts use Power BI to analyze data in the warehouse via the Analysis Services semantic model.

### Components

* [SQL Server](/sql/sql-server) databases containing source data may be located on-premises or in cloud-hosted virtual machines.
* [Azure SQL Database](/azure/sql-database) is a general-purpose relational database managed service in Microsoft Azure that can provide data to a consolidated data warehouse.
* [Cosmos DB](/azure/cosmos-db/) is a globally distributed, multi-model database service that can provide data to a consolidated data warehouse.
* [Blob storage](/azure/storage/blobs) provides a staging area for the source data prior to loading it into SQL Data Warehouse.
* [Data Factory](/azure/data-factory) orchestrates the transformation of staged data into a common structure in SQL Data Warehouse.
* [SQL Data Warehouse](/azure/sql-data-warehouse) is a distributed system for performing analytics on large data. Its use of massive parallel processing (MPP) makes it suitable for running high-performance analytics. SQL Data Warehouse can use [PolyBase](/sql/relational-databases/polybase/polybase-guide) to rapidly load data from Blob storage.
* [Analysis Services](/azure/analysis-services) provides a semantic model for your data and can increase system performance when analyzing your data. 
* [Power BI](/power-bi) Power BI is a suite of business analytics tools to analyze data and share insights. Power BI can query a semantic model stored in Analysis Services, or it can query SQL Data Warehouse directly.
* [Azure Active Directory (Azure AD)](/azure/active-directory/) authenticates users who connect to the Analysis Services server through Power BI. Data Factory can also use Azure AD to authenticate to SQL Data Warehouse via a service principal or Managed Service Identity (MSI).

### Alternatives

* This example demonstrates using an on-premises SQL Server database and an external dataset as the data sources to integrate via the pipeline. However, this architecture is suitable for loading a wide range of both relational and non-relational data sources.
* Data Factory is designed for automating your data pipeline workflows. For jobs requiring high performance, considering [using Data Factory with Polybase](/azure/data-factory/connector-azure-sql-data-warehouse#use-polybase-to-load-data-into-azure-sql-data-warehouse). For one-time or on-demand jobs, you could also use available tools like SQL Server bulk copy (bcp) and AzCopy. For a general comparison, see [Choosing a data pipeline orchestration technology in Azure](/azure/architecture/data-guide/technology-choices/pipeline-orchestration-data-movement).
* If you are working with very large datasets, consider using [Data Lake Storage](/azure/storage/data-lake-storage/introduction), which provides limitless storage for analytics data.
* An on-premises [SQL Server Parallel Data Warehouse](/sql/analytics-platform-system) appliance is another option for processing big data. However, the operating costs are often substantially lower using a managed cloud-based solution such as SQL Data Warehouse. 
* For comparisons of different relevant technology options, see the following in the [Azure Data Architecture Guide](/azure/architecture/data-guide/):

    * [Choosing a data pipeline orchestration technology in Azure](/azure/architecture/data-guide/technology-choices/pipeline-orchestration-data-movement)
    * [Choosing a batch processing technology in Azure](/azure/architecture/data-guide/technology-choices/batch-processing)
    * [Choosing an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores)
    * [Choosing a data analytics technology in Azure](/azure/architecture/data-guide/technology-choices/analysis-visualizations-reporting)

## Considerations

### Availability

SQL Data Warehouse has [guaranteed SLAs](http://azure.microsoft.com/support/legal/sla/sql-data-warehouse/v1_0/) and [recommended practices for achieving high availability](http://azure/sql-data-warehouse/sql-data-warehouse-best-practices).

Azure Analysis Services also has [guaranteed SLAs](https://azure.microsoft.com/support/legal/sla/analysis-services/v1_0/) and [recommended practices for achieving high availability](/azure/analysis-services/analysis-services-bcdr).

For other availability topics, see the [availability checklist][availability] in the Azure Architecure Center.

### Scalability

The [massively parallel processing architecture](/azure/sql-data-warehouse/massively-parallel-processing-mpp-architecture) of SQL Data Warehouse provides scalability and high performance. [SQL Data Warehouse Gen2](/azure/sql-data-warehouse/memory-and-concurrency-limits) offers the greatest level of scale (up to 30,000 Data Warehouse Units) and providing unlimited columnar storage. You can also [scale SQL Data Warehouse on demand](/azure/sql-data-warehouse/sql-data-warehouse-manage-compute-overview), reducing or even pausing compute during periods of low demand or inactivity to lower your overall costs.

Azure Analysis Services can be [configured for scale-out](/azure/analysis-services/analysis-services-scale-out). With scale-out, client queries can be distributed among multiple query replicas in a query pool, reducing response times during high query workloads. You can also separate processing from the query pool, ensuring client queries are not adversely affected by processing operations. 

For other scalability topics, see the [scalability checklist][scalability] in the Azure Architecure Center.

### Security

The [SQL Data Warehouse security model](/azure/sql-data-warehouse/sql-data-warehouse-overview-manage-security) provides connection security, [authentication and authorization](/azure/sql-data-warehouse/sql-data-warehouse-authentication) via Azure AD or SQL Server authentication, and encryption. [Azure Analysis Services](/azure/analysis-services/analysis-services-manage-users) uses Azure Active Directory (Azure AD) for identity management and user authentication. 

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Pricing

To explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: this correlates to a small data pipeline with part-time availability.
* [Medium][medium-pricing]: this correlates to a midsize data pipeline with full availabilty.
* [Large][large-pricing]: this correlates to a large data pipeline with full availability.

## Related Resources

This example scenario is based on a version of this architecture used by  [Maritz Motivation Solutions](https://maritz.com) For more information, see their [customer story][source-document]. 

* Guidance on [data warehousing, online analytical processing (OLAP), and ETL and ELT pipelines](/azure/architecture/data-guide/relational-data/) is available in the Azure Data Architecture Guide.
* Guidance on [big data architectures](/azure/architecture/data-guide/big-data/) is available in the Azure Data Architecture Guide.

<!-- links -->
[source-customer]: https://www.maritzmotivation.com/
[source-document]: https://customers.microsoft.com/story/maritz
[small-pricing]: https://azure.com/e/9444b5ce08b7490a9b9f2207203e67f5
[medium-pricing]: https://azure.com/e/b798fb70c53e4dd19fdeacea4db78276
[large-pricing]: https://azure.com/e/f204c450314141a7ac803d72d2446a24
[architecture]: ./images/architecture-diagram-data-warehouse.png
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
