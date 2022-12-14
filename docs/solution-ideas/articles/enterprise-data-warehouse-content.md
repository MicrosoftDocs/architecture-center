[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

An enterprise data warehouse lets you bring together all your data at any scale easily, and to get insights through analytical dashboards, operational reports, or advanced analytics for all your users.



## Architecture

:::image type="content" source="../media/enterprise-data-warehouse.png" alt-text="Diagram of an enterprise data warehouse architecture using Azure Synapse Analytics with Azure Data Lake Storage Gen2, Azure Analysis Services and Power BI." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/enterprise-data-warehouse.vsdx) of this architecture.*

### Dataflow

1. Combine all your structured, unstructured and semi-structured data (logs, files, and media) using Azure Synapse Analytics Pipelines to Azure Blob Storage.
1. Leverage data in Azure Blob Storage to perform scalable analytics with Azure Synapse Analytics Spark pool and achieve cleansed and transformed data.
1. Cleansed and transformed data can be combined with existing structured data, creating one hub for all your data with Azure Synapse Analytics.
1. Build operational reports and analytical dashboards on top of dedicated SQL pool to derive insights from the data, and use Azure Analysis Services to serve thousands of end users.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is the fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store elastically and independently, with a massively parallel processing architecture.
- [Synapse Pipelines Documentation](/azure/data-factory/concepts-pipelines-activities) allows you to create, schedule and orchestrate your ETL/ELT workflows.
- [Azure Blob storage](https://azure.microsoft.com/services/storage/blobs) is a Massively scalable object storage for any type of unstructured data-images, videos, audio, documents, and more-easily and cost-effectively.
- [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview) is a parallel processing framework that supports in-memory processing to boost the performance of big-data analytic applications.
- [Azure Analysis Services](https://azure.microsoft.com/services/analysis-services) is an enterprise grade analytics as a service that lets you govern, deploy, test, and deliver your BI solution with confidence.
- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. Connect to hundreds of data sources, simplify data prep, and drive ad hoc analysis. Produce beautiful reports, then publish them for your organization to consume on the web and across mobile devices.

## Scenario details

Many business scenarios involves a large volume of data that comes from various sources. The data is in various formats and can be structured, semi-structured, or unstructured. In such a situation, the main challenge is to store the data in a centralized location where it's available for fast analytics [see data warehouse purpose].

To gather the data into one location, this solution uses Azure Synapse Analytics pipelines. These pipelines offer ELT/ETL [spell out] capabilities. Specifically, you can use the pipelines to move data in data-driven workflows. The pipelines work with various data formats and structures.

The pipelines store the data in Data Lake Storage, which is built on Azure Blob Storage. This storage service can handle large volumes of unstructured data.

Azure Synapse Analytics Spark pools form a key part of the solution. These pools clean and transform data that's stored in Azure. Their parallel processing framework supports in-memory processing for speed and efficiency. The pools also support auto-scaling, so they can add or remove nodes as needed.

A dedicated SQL pool makes the processed data available for analysis queries. This pool stores data in relational tables with columnar storage, a format that significantly reduces the cost of data storage. It also improves query performance, so you can run analytics at massive scale.

The solution uses Azure Analysis Services to deliver insights. This analytics engine provides an easy and fast way for users to perform ad hoc data analysis. It also takes advantage of the scaling benefits of the cloud, so it's suitable for a large volume of users.

### Potential use cases

This approach can be used to:

- Establish a data warehouse to be a single source of truth for your data.
- Integrate relational data sources with other unstructured datasets.
- Use semantic modeling and powerful visualization tools for simpler data analysis.

## Pricing

- [Customize and get pricing estimates](https://azure.com/e/4269bfbeee564d3cb88348a033e022e8)

## Next steps

- [Azure Synapse Analytics Documentation](/azure/synapse-analytics)
- [Synapse Pipelines Documentation](/azure/data-factory/concepts-pipelines-activities)
- [Introduction to object storage in Azure](/azure/storage/blobs/storage-blobs-introduction)
- [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview)
- [Analysis Services Documentation](/azure/analysis-services)
- [Power BI Documentation](/power-bi)
