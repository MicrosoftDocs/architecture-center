[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

An enterprise data warehouse lets you bring together all your data at any scale easily, and to get insights through analytical dashboards, operational reports, or advanced analytics for all your users.

## Architecture

:::image type="content" source="../media/enterprise-data-warehouse.png" alt-text="Diagram of an enterprise data warehouse architecture using Azure Synapse Analytics with Azure Data Lake Storage Gen2, Azure Analysis Services and Power BI." border="false":::

*Download an [SVG](../media/enterprise-data-warehouse.svg) of this architecture.*

### Data flow

1. Combine all your structured, unstructured and semi-structured data (logs, files, and media) using Azure Synapse Analytics Pipelines to Azure Blob Storage.
1. Leverage data in Azure Blob Storage to perform scalable analytics with Azure Synapse Analytics Spark pool and achieve cleansed and transformed data.
1. Cleansed and transformed data can be combined with existing structured data, creating one hub for all your data with Azure Synapse Analytics.
1. Build operational reports and analytical dashboards on top of dedicated SQL pool to derive insights from the data, and use Azure Analysis Services to serve thousands of end users.

### Components

* [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is the fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store elastically and independently, with a massively parallel processing architecture.
* [Synapse Pipelines Documentation](/azure/data-factory/concepts-pipelines-activities) allows you to create, schedule and orchestrate your ETL/ELT workflows.
* [Azure Blob storage](https://azure.microsoft.com/services/storage/blobs) is a Massively scalable object storage for any type of unstructured data-images, videos, audio, documents, and more-easily and cost-effectively.
* [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview) is a parallel processing framework that supports in-memory processing to boost the performance of big-data analytic applications.
* [Azure Analysis Services](https://azure.microsoft.com/services/analysis-services) is an enterprise grade analytics as a service that lets you govern, deploy, test, and deliver your BI solution with confidence.
* [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. Connect to hundreds of data sources, simplify data prep, and drive ad hoc analysis. Produce beautiful reports, then publish them for your organization to consume on the web and across mobile devices.

## Pricing

* [Customize and get pricing estimates](https://azure.com/e/4269bfbeee564d3cb88348a033e022e8)

## Next steps

* [Azure Synapse Analytics Documentation](/azure/synapse-analytics)
* [Synapse Pipelines Documentation](/azure/data-factory/concepts-pipelines-activities)
* [Introduction to object storage in Azure](/azure/storage/blobs/storage-blobs-introduction)
* [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview)
* [Analysis Services Documentation](/azure/analysis-services)
* [Power BI Documentation](/power-bi)
