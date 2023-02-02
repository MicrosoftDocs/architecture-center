[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea demonstrates low-latency, high-throughput ingestion of large volumes of Content Delivery Network (CDN) logs. You can use this data to create near real-time analytics dashboards.

## Architecture

:::image type="content" source="../media/content-delivery-network-azure-data-explorer.svg" alt-text="Content delivery network analytics with Azure Data Explorer." lightbox="../media/content-delivery-network-azure-data-explorer.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/content-delivery-network-analytics-azure-data-explorer.vsdx) of this architecture.*

### Dataflow

1. Content Delivery Network providers such as Verizon and Fastly ingest huge amounts of CDN logs into Azure Data Explorer to analyze latencies, health, and performance of CDN assets.
1. Most CDN scenarios ingest data through Azure Storage ([Blob](/azure/storage/blobs) or [ADLS Gen2](/azure/storage/blobs/data-lake-storage-introduction)), which uses [Azure Event Grid](/azure/data-explorer/ingest-data-event-grid) and triggers the ingestion pipeline to Azure Data Explorer. Alternatively you can bulk ingest the data using the [LightIngest tool](/azure/data-explorer/lightingest). You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in [Continuous data export overview](/azure/data-explorer/kusto/management/data-export/continuous-data-export).
1. Azure Data Explorer provides easy to use native operators and functions to process, aggregate, and analyze time series and log data, as well as supply insights at lightning speed. You can build near real-time analytics dashboards using [Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards), [Power BI](/power-bi/transform-model/service-dataflows-best-practices), or [Grafana](/azure/data-explorer/grafana).
1. Create and schedule alerts and notifications using [Azure Data Explorer connector for Azure Logic Apps](/azure/data-explorer/kusto/tools/logicapps).

### Components

- [Azure Storage Azure Data Explorer connector](/azure/data-explorer/ingest-data-event-grid): Continuous ingestion from Azure Storage (Blob storage and ADLSv2) with Azure Event Grid subscription to stream these notifications to Azure Data Explorer.
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer): Fast, fully managed and highly scalable data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more.
- [Azure Data Explorer Dashboards](/azure/data-explorer/azure-data-explorer-dashboards): Natively export Kusto queries that were explored in the Web UI to optimized dashboards.
- [Azure Logic Apps Azure Data Explorer connector](/azure/data-explorer/kusto/tools/logicapps): Run Kusto queries and commands automatically as part of a scheduled or triggered task.

## Scenario details

You can use this solution to ingest large volumes of CDN logs for the purpose of creating near real-time analytics dashboards.

### Potential use cases

* Log analytics
* Time series analytics
* IoT
* General-purpose exploratory analytics

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Ornat Spodek](https://www.linkedin.com/in/ornat-s-89123544) | Senior Content Manager

## Next steps

For more information, see [Azure Data Explorer documentation](/azure/data-explorer).

## Related resources

- [Analytics architecture design](analytics-start-here.yml)
- [Choose an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)
- [Big data analytics with Azure Data Explorer](big-data-azure-data-explorer.yml)
- [Azure Data Explorer monitoring](monitor-azure-data-explorer.yml)
