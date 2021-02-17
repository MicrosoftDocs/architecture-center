


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

## Architecture

![Architecture diagram](/docs/solution-ideas/media/anomaly-detector.png)
*Download an [SVG](/docs/solution-ideas/media/anomaly-detector.svg) of this architecture.*

## Data Flow

1. Ingests data from the various stores that contain raw data to be monitored by Anomaly Detector.
1. Aggregates, samples, and computes the raw data to generate the time series, or calls the Anomaly Detector API directly if the time series are already prepared and gets a response with the detection results.
1. Queues the anomaly related meta data.
1. Based on the anomaly related meta data, calls the customized alerting service.
1. Stores the anomaly detection meta data.
1. Visualizes the results of the time series anomaly detection.

## Components

* [Service Bus](https://azure.microsoft.com/services/service-bus): Reliable cloud messaging as a service (MaaS) and simple hybrid integration
* [Azure Databricks](https://azure.microsoft.com/services/databricks): Fast, easy, and collaborative Apache Spark–based analytics service
* [Power BI](https://powerbi.microsoft.com): Interactive data visualization BI tools
* [Storage Accounts](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage

## Next steps

* [Service Bus Documentation](/azure/service-bus)
* [Azure Databricks Documentation](/azure/azure-databricks)
* [Power BI Documentation](/power-bi)
* [Storage Documentation](/azure/storage)
