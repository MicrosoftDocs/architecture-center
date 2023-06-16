[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for an enterprise data warehouse in Azure that:

- Brings together all your data, no matter the scale or format.
- Provides a way for all your users to get insights from your data through analytical dashboards, operational reports, and advanced analytics.

*Apache® and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="../media/enterprise-data-warehouse.svg" lightbox="../media/enterprise-data-warehouse.svg" alt-text="Architecture diagram of an enterprise data warehouse that uses Azure Synapse Analytics, Data Lake Storage, Analysis Services, and Power BI." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/enterprise-data-warehouse.vsdx) of this architecture.*

### Dataflow

1. Azure Synapse Analytics pipelines bring together structured, unstructured, and semi-structured data, such as logs, files, and media. The pipelines store the data in Azure Data Lake Storage.
1. Apache Spark pools in Azure Synapse Analytics clean and transform the Data Lake Storage data.
1. Azure Synapse Analytics combines the processed data with existing structured data, creating one unified data hub.
1. A dedicated SQL pool makes the data available for operational reports and analytical dashboards that derive insights. Azure Analysis Services serves the reports and dashboards to thousands of end users.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service for data warehouses and big data systems. This tool uses a massively parallel processing architecture and has deep integration with Azure services.
- [Azure Synapse Analytics pipelines](https://azure.microsoft.com/products/synapse-analytics/#use-cases) provide a way for you to create, schedule, and orchestrate workflows, such as extract, load, transform (ELT) and extract, transform, load (ETL) workflows.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) provides massively scalable, cost-effective object storage for any type of unstructured data—images, videos, audio, documents, and more.
- [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) is a storage repository that holds a large amount of data in its native, raw format. Data Lake Storage is built on top of Blob Storage. As a result, Data Lake Storage offers the scalability, tiered storage, high availability, and disaster recovery capabilities of Blob Storage.
- [Azure Synapse Analytics Spark pools](https://azure.microsoft.com/products/synapse-analytics/#use-cases) provide a parallel processing framework that supports in-memory processing to boost the performance of big-data analytic applications.
- [Analysis Services](https://azure.microsoft.com/services/analysis-services) is an enterprise-grade analytics engine that provides an easy way for users to perform ad hoc data analysis. You can use Analysis Services to govern, test, and deliver business solutions at scale.
- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. You can use Power BI to connect to hundreds of data sources, simplify data preparation, and drive ad hoc analysis. You can also produce beautiful reports and publish them for your organization to consume on the web and across mobile devices.

## Scenario details

An enterprise data warehouse brings all your data together, no matter the source, format, or scale. A data warehouse also provides a way for you to run high-performance analytics on your data, so you can gain insights through analytical dashboards, operational reports, and advanced analytics.

This solution establishes a data warehouse that:

- Is a single source of truth for your data.
- Integrates relational data sources with other unstructured datasets.
- Uses semantic modeling and powerful visualization tools for simpler data analysis.

To integrate data into a unified platform, this solution uses Azure Synapse Analytics pipelines. These pipelines offer ELT and ETL capabilities. Specifically, you can use the pipelines to move data in data-driven workflows. The pipelines work with various data formats and structures.

The pipelines store the data in Data Lake Storage, which is built on Blob Storage. This storage service can handle large volumes of unstructured data.

Azure Synapse Analytics Spark pools form a key part of the solution. These pools clean and transform data that's stored in Azure. Their parallel processing framework supports in-memory processing for speed and efficiency. The pools also support auto-scaling, so they can add or remove nodes as needed.

A dedicated SQL pool makes the processed data available for high-performance analytics. This pool stores data in relational tables with columnar storage, a format that significantly reduces the cost of data storage. It also improves query performance, so you can run analytics at massive scale.

### Potential use cases

You can use this solution in scenarios like the following ones that involve large volumes of data:

- IoT device integration
- Customer data platforms
- Natural language processing
- Machine learning algorithms

## Pricing

To view an estimate of the cost of this solution, see a [pricing sample in the pricing calculator](https://azure.com/e/4269bfbeee564d3cb88348a033e022e8).

## Next steps

- [Azure Synapse Analytics documentation](/azure/synapse-analytics)
- [Azure Synapse Analytics pipelines documentation](/azure/data-factory/concepts-pipelines-activities)
- [Introduction to object storage in Azure](/azure/storage/blobs/storage-blobs-introduction)
- [Azure Synapse Analytics Spark pools](/azure/synapse-analytics/spark/apache-spark-overview)
- [Analysis Services documentation](/azure/analysis-services)
- [Power BI documentation](/power-bi)

## Related resources

- [Data warehousing in Microsoft Azure](../../data-guide/relational-data/data-warehousing.yml)
- [Data warehousing and analytics](../../example-scenario/data/data-warehouse.yml)
- [Big data analytics with enterprise-grade security using Azure Synapse](./big-data-analytics-enterprise-grade-security.yml)
- [Logical data warehouse with Azure Synapse serverless SQL pools](./logical-data-warehouse.yml)
- [Modern data warehouse for small and medium business](../../example-scenario/data/small-medium-data-warehouse.yml)
