[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes how to use the TimeXtender graphical interface to define a data estate. 

## Architecture

![Diagram showing the dataflow for TimeXtender with cloud scale analytics solution.](../media/cloud-scale-analytics-with-discovery-hub.svg)

*Download a [Visio file](https://arch-center.azureedge.net/cloud-scale-analytics-with-discovery-hub.vsdx) of this architecture.*

### Dataflow

1. Combine all your structured and semi-structured data in Azure Data Lake Storage using TimeXtender's data engineering pipeline with hundreds of native data connectors.
1. Clean and transform data using the powerful analytics and computational ability of Azure Databricks.
1. Move cleansed and transformed data to Azure Synapse Analytics, creating one hub for all your data. Take advantage of native connectors between Azure Databricks (PolyBase) and Azure Synapse Analytics to access and move data at scale.
1. Build operational reports and analytical dashboards on top of SQL Database to derive insights from the data and use Azure Analysis Services to serve the data.
1. Run ad-hoc queries directly on data within Azure Databricks.

### Components

* [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage): Massively scalable, secure data lake functionality built on Azure Blob Storage
* [Azure Databricks](https://azure.microsoft.com/services/databricks): Fast, easy, and collaborative Apache Spark-based analytics platform
* [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics): Limitless analytics service with unmatched time to insight (formerly SQL Data Warehouse)
* [Azure Analysis Services](https://azure.microsoft.com/services/analysis-services): Enterprise-grade analytics engine as a service
* [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded): Embed fully interactive, stunning data visualizations in your applications

## Scenario details

You can use TimeXtender to define a data estate via a graphical user interface. Definitions are stored in a metadata repository. Code for building the data estate is generated automatically while remaining fully customizable. The results are a modern data warehouse that is ready to support cloud scale analytics and AI.

### Potential use cases

* No infrastructure issues or maintenance
* Consistent performance
* Deploy and manage both the architecture and the data pipelines, data models and semantic models

## Next steps

* [Azure Data Lake Storage documentation](https://azure.microsoft.com/services/storage/data-lake-storage)
* [Azure Databricks documentation](https://azure.microsoft.com/services/databricks)
* [Azure Synapse Analytics documentation](https://azure.microsoft.com/services/sql-data-warehouse)
* [Azure Analysis Services documentation](https://azure.microsoft.com/services/analysis-services)
* [Power BI Embedded documentation](https://azure.microsoft.com/services/power-bi-embedded)

## Related resources

- [Modern data warehouse for small and medium business](../../example-scenario/data/small-medium-data-warehouse.yml)
- [Data warehousing and analytics](../../example-scenario/data/data-warehouse.yml)
- [Modern analytics architecture with Azure Databricks](../../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml)
