[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Use Discovery Hub to define a data estate using a graphical user interface, with definitions stored in a metadata repository. Code for building the data estate is generated automatically while remaining fully customizable. The resulting modern data warehouse is ready to support cloud scale analytics and AI.

## Architecture

![Architecture Diagram](../media/cloud-scale-analytics-with-discovery-hub.png)
*Download an [SVG](../media/cloud-scale-analytics-with-discovery-hub.svg) of this architecture.*

### Data flow

1. Combine all your structured and semi-structured data in Azure Data Lake Storage using Discovery Hub's data engineering pipeline with hundreds of native data connectors.
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

## Next steps

* [Azure Data Lake Storage documentation](https://azure.microsoft.com/services/storage/data-lake-storage)
* [Azure Databricks documentation](https://azure.microsoft.com/services/databricks)
* [Azure Synapse Analytics documentation](https://azure.microsoft.com/services/sql-data-warehouse)
* [Azure Analysis Services documentation](https://azure.microsoft.com/services/analysis-services)
* [Power BI Embedded documentation](https://azure.microsoft.com/services/power-bi-embedded)
