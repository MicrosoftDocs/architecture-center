[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture allows you to combine any data at any scale with custom machine learning and get near real-time data analytics on streaming services.

## Architecture

:::image type="content" source="../media/advanced-analytics-on-big-data.svg" alt-text="Diagram of an advanced analytics architecture using Azure Synapse Analytics with Azure Data Lake Storage, Azure Analysis Services, Azure Cosmos DB, and Power BI." border="false" lightbox="../media/advanced-analytics-on-big-data.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/advanced-analytics-on-big-data.vsdx) of this architecture.*

### Dataflow

1. Bring together all your structured, unstructured, and semi-structured data (logs, files, and media) using Synapse Pipelines to Azure Data Lake Storage.
1. Use Apache Spark pools to clean and transform the structureless datasets and combine them with structured data from operational databases or data warehouses.
1. Use scalable machine learning/deep learning techniques, to derive deeper insights from this data using Python, Scala, or .NET, with notebook experiences in Apache Spark pool.
1. Apply  Apache Spark pool and Synapse Pipelines in Azure Synapse Analytics to access and move data at scale.
1. Query and report on data in [Power BI](/azure/analysis-services/analysis-services-connect-pbi).
1. Take the insights from Apache Spark pools to Azure Cosmos DB to make them accessible through web and mobile apps.

### Workflow

* [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is the fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store elastically and independently, with a massively parallel processing architecture.
* [Synapse Pipelines Documentation](/azure/data-factory/concepts-pipelines-activities) allows you to create, schedule, and orchestrate your ETL/ELT workflows.
* [Azure Blob storage](https://azure.microsoft.com/services/storage/blobs) is a Massively scalable object storage for any type of unstructured data-images, videos, audio, documents, and more-easily and cost-effectively.
* [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview) is a fast, easy, and collaborative Apache Spark-based analytics platform.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database service. Learn how to replicate your data across any number of Azure regions and scale your throughput independent from your storage.
* [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link) enables you to run near real-time analytics over operational data in Azure Cosmos DB, **without any performance or cost impact on your transactional workload**, by using the two analytics engines available from your Azure Synapse workspace: [SQL Serverless](/azure/synapse-analytics/sql/on-demand-workspace-overview) and [Spark Pools](/azure/synapse-analytics/spark/apache-spark-overview).
* [Azure Analysis Services](https://azure.microsoft.com/services/analysis-services) is an enterprise grade analytics as a service that lets you govern, deploy, test, and deliver your BI solution with confidence.
* [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. Connect to hundreds of data sources, simplify data prep, and drive unplanned analysis. Produce beautiful reports, then publish them for your organization to consume on the web and across mobile devices.

### Alternatives

- [Synapse Link](/azure/cosmos-db/synapse-link) is the Microsoft preferred solution for analytics on top of Azure Cosmos DB data.

## Scenario details

Transform your data into actionable insights using the best-in-class machine learning tools. This solution allows you to combine any data at any scale, and to build and deploy custom machine learning models at scale. To learn how enterprise-scale data platforms are designed as part of an enterprise landing zone, refer to the [Cloud Adoption Framework Data landing zone](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-landing-zone) documentation.

### Potential use cases

Organizations have the ability to access more data than ever before. Advanced analytics help take advantage of data insights. Areas include:

* Customer service.
* Predictive maintenance.
* Recommending products or services.
* System optimization of everything from supply chains to data center operations.
* Product and services development.

## Considerations

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

* [Customize and get pricing estimates](https://azure.com/e/96162a623bda4911bb8f631e317affc6)

## Next steps

* Learn about [enterprise-scale data platform](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-landing-zone) design
* Learn how to design and deploy an [end-to-end data analytics](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end) platform

See the following documentation about the services featured in this architecture:

* [Synapse Analytics Documentation](/azure/sql-data-warehouse)
* [Synapse Pipelines Documentation](/azure/data-factory/concepts-pipelines-activities)
* [Introduction to object storage in Azure](/azure/storage/blobs/storage-blobs-introduction)
* [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview)
* [Azure Cosmos DB Documentation](/azure/cosmos-db)
* [Analysis Services Documentation](/azure/analysis-services)
* [Power BI Documentation](/power-bi)

## Related resources

* [Secure a data lakehouse with Azure Synapse Analytics](/azure/architecture/example-scenario/analytics/secure-data-lakehouse-synapse)
* [Analyze operational data on MongoDB Atlas using Azure Synapse Analytics](/azure/architecture/example-scenario/analytics/azure-synapse-analytics-integrate-mongodb-atlas)
* [Big data analytics with enterprise-grade security using Azure Synapse](/azure/architecture/solution-ideas/articles/big-data-analytics-enterprise-grade-security)
* [Spaceborne data analysis with Azure Synapse Analytics](/azure/architecture/industries/aerospace/geospatial-processing-analytics)
* [Analytics end-to-end with Azure Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)
