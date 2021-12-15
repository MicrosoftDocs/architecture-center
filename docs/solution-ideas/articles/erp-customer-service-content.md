[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Today's organizations are generating ever-increasing amounts of structured and unstructured data. With Azure managed databases and Azure Synapse Analytics, they can deliver insights to their employees via ERP applications and Power BI, as well as superior customer service through web and mobile applications, scaling without limits as data volumes and application users increase.

## Architecture

![Architecture Diagram](../media/erp-customer-service.png)

### Data flow

First, the company must ingest data from various sources.

1. Use Azure Synapse Pipelines to ingest data of all formats.
2. Land data in Azure Data Lake Storage Gen 2, a highly scalable data lake.

From there, they use Azure SQL Database Hyperscale to run a highly scalable ERP system:

1. Ingest relational data using Azure Synapse Pipelines into Azure SQL Database. The company's ERP system runs on Azure SQL Database and applies the Hyperscale service tier to scale compute or storage up to 100 TB.
2. This data is surfaced via ERP client applications to help the company manage their business processes.

To improve service to their customers, they build highly scalable customer service applications that can scale to millions of users:

1. Provide near real-time analytics and insight into user interaction with applications by applying Azure Synapse Link for Azure Cosmos DB HTAP capabilities, with no ETL needed.
2. Power customer service applications with Azure Cosmos DB for automatic and instant scalability and SLA-backed speed, availability, throughput, and consistency.

Finally, they surface business intelligence insights to users across the company to power data-driven decisions:

1. Power BI tightly integrates with Azure Synapse Analytics to provide powerful insights over operational, data warehouse, and data lake data.

### Components

- [Azure Data Lake Storage Gen 2](/azure/storage/blobs/data-lake-storage-introduction) provides massively scalable and secure data lake storage for high-performance analytics workloads.
- [Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) is an analytics service that brings together enterprise data warehousing and Big Data analytics within a unified experience.
- [Azure SQL Database Hyperscale](/azure/azure-sql/database/service-tier-hyperscale) is a storage tier in Azure SQL Database that uses Azure architecture to scale out storage and compute resources.  Hyperscale supports up to 100 TB of storage and provides nearly instantaneous backups and fast database restores in minutes – regardless of the size of data operation.
- [Azure Cosmos DB](/azure/cosmos-db/introduction) is a fully managed NoSQL database service for building and modernizing scalable, high-performance applications.
- [Power BI](/power-bi/fundamentals/power-bi-overview) is a suite of business tools for self-service and enterprise business intelligence (BI). Here, it's used to analyze and visualize data.

## Next Steps

- Read the [H&R Block customer story](https://customers.microsoft.com/story/724156-hr-block-professional-services-azure-sql-server) to learn how they use Azure SQL to unify data sources to deliver seamless multichannel experiences and provide better customer service.
- Find comprehensive architectural guidance for designing data-centric solutions on [Azure in the Azure Data Architecture Guide](../../data-guide/index.md).
- Learn more about how [Azure Synapse Link](/azure/cosmos-db/synapse-link) can enable you to run near real-time analytics over operational data in Azure Cosmos DB, and [explore common use cases](/azure/cosmos-db/synapse-link-use-cases) like real-time personalization, predictive maintenance and anomaly detection in IoT scenarios, and supply chain analytics, forecasting, and reporting.
