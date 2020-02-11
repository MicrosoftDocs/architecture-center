---
title: Data warehousing and analytics for sales and marketing
titleSuffix: Azure Example Scenarios
description: Consolidate data from multiple sources and optimize data analytics.
author: alexbuckgit
ms.date: 11/20/2019
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
  - data-analytics
  - data-warehouse
social_image_url: /azure/architecture/example-scenario/data/media/architecture-data-warehouse.png
---

# Data warehousing and analytics for sales and marketing

This example scenario demonstrates a data pipeline that integrates large amounts of data from multiple sources into a unified analytics platform in Azure. This specific scenario is based on a sales and marketing solution, but the design patterns are relevant for many industries requiring advanced analytics of large datasets such as e-commerce, retail, and healthcare.

This example demonstrates a sales and marketing company that creates incentive programs. These programs reward customers, suppliers, salespeople, and employees. Data is fundamental to these programs, and the company wants to improve the insights gained through data analytics using Azure.

The company needs a modern approach to analysis data, so that decisions are made using the right data at the right time. The company's goals include:

- Combining different kinds of data sources into a cloud-scale platform.
- Transforming source data into a common taxonomy and structure, to make the data consistent and easily compared.
- Loading data using a highly parallelized approach that can support thousands of incentive programs, without the high costs of deploying and maintaining on-premises infrastructure.
- Greatly reducing the time needed to gather and transform data, so you can focus on analyzing the data.

## Relevant use cases

This approach can also be used to:

- Establish a data warehouse to be a single source of truth for your data.
- Integrate relational data sources with other unstructured datasets.
- Use semantic modeling and powerful visualization tools for simpler data analysis.

## Architecture

![Architecture for a data warehousing and analysis scenario in Azure][architecture]

The data flows through the solution as follows:

1. For each data source, any updates are exported periodically into a staging area in Azure Blob storage.
2. Data Factory incrementally loads the data from Blob storage into staging tables in Azure Synapse Analytics. The data is cleansed and transformed during this process. Polybase can parallelize the process for large datasets.
3. After loading a new batch of data into the warehouse, a previously created Analysis Services tabular model is refreshed. This semantic model simplifies the analysis of business data and relationships.
4. Business analysts use Microsoft Power BI to analyze warehoused data via the Analysis Services semantic model.

### Components

The company has data sources on many different platforms:

- SQL Server on-premises
- Oracle on-premises
- Azure SQL Database
- Azure table storage
- Cosmos DB

Data is loaded from these different data sources using several Azure components:

- [Blob storage](/azure/storage/blobs/storage-blobs-introduction) is used to stage source data before it's loaded into Azure Synapse.
- [Data Factory](/azure/data-factory) orchestrates the transformation of staged data into a common structure in Azure Synapse. Data Factory [uses Polybase when loading data into Azure Synapse](/azure/data-factory/connector-azure-sql-data-warehouse#use-polybase-to-load-data-into-azure-sql-data-warehouse) to maximize throughput.
- [Azure Synapse](/azure/sql-data-warehouse/sql-data-warehouse-overview-what-is) is a distributed system for storing and analyzing large datasets. Its use of massive parallel processing (MPP) makes it suitable for running high-performance analytics. Azure Synapse can use [PolyBase](/sql/relational-databases/polybase/polybase-guide) to rapidly load data from Blob storage.
- [Analysis Services](/azure/analysis-services) provides a semantic model for your data. It can also increase system performance when analyzing your data.
- [Power BI](/power-bi) is a suite of business analytics tools to analyze data and share insights. Power BI can query a semantic model stored in Analysis Services, or it can query Azure Synapse directly.
- [Azure Active Directory (Azure AD)](/azure/active-directory) authenticates users who connect to the Analysis Services server through Power BI. Data Factory can also use Azure AD to authenticate to Azure Synapse via a service principal or [Managed identity for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview).

### Alternatives

- The example pipeline includes several different kinds of data sources. This architecture can handle a wide variety of relational and non-relational data sources.
- Data Factory orchestrates the workflows for your data pipeline. If you want to load data only one time or on demand, you could use tools like SQL Server bulk copy (bcp) and AzCopy to copy data into Blob storage. You can then load the data directly into Azure Synapse using Polybase.
- If you have very large datasets, consider using [Data Lake Storage](/azure/storage/data-lake-storage/introduction), which provides limitless storage for analytics data.
- An on-premises [SQL Server Parallel Data Warehouse](/sql/analytics-platform-system) appliance can also be used for big data processing. However, operating costs are often much lower with a managed cloud-based solution like Azure Synapse.
- Azure Synapse is not a good fit for OLTP workloads or data sets smaller than 250 GB. For those cases you should use Azure SQL Database or SQL Server.
- For comparisons of other alternatives, see:

  - [Choosing a data pipeline orchestration technology in Azure](/azure/architecture/data-guide/technology-choices/pipeline-orchestration-data-movement)
  - [Choosing a batch processing technology in Azure](/azure/architecture/data-guide/technology-choices/batch-processing)
  - [Choosing an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores)
  - [Choosing a data analytics technology in Azure](/azure/architecture/data-guide/technology-choices/analysis-visualizations-reporting)

## Considerations

The technologies in this architecture were chosen because they met the company's requirements for scalability and availability, while helping them control costs.

- The [massively parallel processing architecture](/azure/sql-data-warehouse/massively-parallel-processing-mpp-architecture) of Azure Synapse provides scalability and high performance.
- Azure Synapse has [guaranteed SLAs](https://azure.microsoft.com/support/legal/sla/sql-data-warehouse) and [recommended practices for achieving high availability](/azure/sql-data-warehouse/sql-data-warehouse-best-practices).
- When analysis activity is low, the company can [scale Azure Synapse on demand](/azure/sql-data-warehouse/sql-data-warehouse-manage-compute-overview), reducing or even pausing compute to lower costs.
- Azure Analysis Services can be [scaled out](/azure/analysis-services/analysis-services-scale-out) to reduce response times during high query workloads. You can also separate processing from the query pool, so that client queries aren't slowed down by processing operations.
- Azure Analysis Services also has [guaranteed SLAs](https://azure.microsoft.com/support/legal/sla/analysis-services) and [recommended practices for achieving high availability](/azure/analysis-services/analysis-services-bcdr).
- The [Azure Synapse security model](/azure/sql-data-warehouse/sql-data-warehouse-overview-manage-security) provides connection security, [authentication and authorization](/azure/sql-data-warehouse/sql-data-warehouse-authentication) via Azure AD or SQL Server authentication, and encryption. [Azure Analysis Services](/azure/analysis-services/analysis-services-manage-users) uses Azure AD for identity management and user authentication.

## Pricing

Review a [pricing sample for a data warehousing scenario][calculator] via the Azure pricing calculator. Adjust the values to see how your requirements affect your costs.

- [Azure Synapse](https://azure.microsoft.com/pricing/details/sql-data-warehouse/gen2) allows you to scale your compute and storage levels independently. Compute resources are charged per hour, and you can scale or pause these resources on demand. Storage resources are billed per terabyte, so your costs will increase as you ingest more data.
- [Data Factory](https://azure.microsoft.com/pricing/details/data-factory) costs are based on the number of read/write operations, monitoring operations, and orchestration activities performed in a workload. Your Data Factory costs will increase with each additional data stream and the amount of data processed by each one.
- [Analysis Services](https://azure.microsoft.com/pricing/details/analysis-services) is available in developer, basic, and standard tiers. Instances are priced based on query processing units (QPUs) and available memory. To keep your costs lower, minimize the number of queries you run, how much data they process, and how often they run.
- [Power BI](https://powerbi.microsoft.com/pricing) has different product options for different requirements. [Power BI Embedded](https://azure.microsoft.com/pricing/details/power-bi-embedded) provides an Azure-based option for embedding Power BI functionality inside your applications. A Power BI Embedded instance is included in the pricing sample above.

## Next Steps

- Review the [Azure reference architecture for automated enterprise BI](/azure/architecture/reference-architectures/data/enterprise-bi-adf), which includes instructions for deploying an instance of this architecture in Azure.
- Read the [Maritz Motivation Solutions customer story][source-document]. That story describes a similar approach to managing customer data.
- Find comprehensive architectural guidance on data pipelines, data warehousing, online analytical processing (OLAP), and big data in the [Azure Data Architecture Guide](/azure/architecture/data-guide).

<!-- links -->

[source-document]: https://customers.microsoft.com/story/maritz
[calculator]: https://azure.com/e/b798fb70c53e4dd19fdeacea4db78276
[architecture]: ./media/architecture-data-warehouse.png
