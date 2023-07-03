[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea demonstrates a hybrid end-to-end monitoring solution integrated with Microsoft Sentinel and Azure Monitor for ingesting streamed and batched logs from diverse sources, on-premises, or any cloud, within an enterprise ecosystem.

*Apache® and [Apache Nifi®](https://projects.apache.org/project.html?nifi) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks. 
[Fluentd](https://www.fluentd.org/),  [Logstash](https://www.elastic.co/logstash/), [Grafana](https://grafana.com/), and [Jupyter Notebooks](https://jupyter.org/) are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

:::image type="content" source="../media/monitor-azure-data-explorer.svg" alt-text="Monitoring solution with Azure Data Explorer." lightbox="../media/monitor-azure-data-explorer.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/monitor-azure-data-explorer.vsdx) of this architecture.*

### Dataflow

1. Combine features provided by Microsoft Sentinel and Azure Monitor with Azure Data Explorer to build a flexible and cost-optimized end-to-end monitoring solution.  Below are some examples:
   - Use Microsoft Sentinel as a SIEM and SOAR component in the overall monitoring solution where you can ingest security logs from firewalls, Defender for Cloud, and so on. SIEM is short for *security information and event management*, whereas SOAR is short for *security orchestration, automation and response*.
   - Use Azure Monitor's native capabilities for IT asset monitoring, dashboarding, and alerting so you can ingest logs from VMs, services, and so on.
   - Use Azure Data Explorer for full flexibility and control in all aspects for all types of logs in the following scenarios:
     - No *out of the box* features provided by Microsoft Sentinel and Azure Monitor SaaS solutions such as application trace logs.
     - Greater flexibility for building quick and easy near-real-time analytics dashboards, granular role-based access control, [time series analysis](/azure/data-explorer/time-series-analysis), pattern recognition, [anomaly detection and forecasting](/azure/data-explorer/anomaly-detection), and [machine learning](/azure/data-explorer/machine-learning-clustering). Azure Data Explorer is also well integrated with ML services such as Databricks and Azure Machine Learning. This integration allows you to build models using other tools and services and export ML models to Azure Data Explorer for scoring data.
     - Longer data retention is required in cost effective manner.
     - Centralized repository is required for different types of logs. Azure Data Explorer, as a unified big data analytics platform, allows you to build advanced analytics scenarios.
1. Query across different products without moving data using the [Azure Data Explorer proxy](/azure/data-explorer/query-monitor-data) feature to analyze data from Microsoft Sentinel, Azure Monitor, and Azure Data Explorer in a single query.
1. To ingest logs with low latency and high throughput from on-premises or any other cloud, use native Azure Data Explorer connectors such as [Logstash](/azure/data-explorer/ingest-data-logstash), [Azure Event Hubs](/azure/data-explorer/ingest-data-event-hub), or [Kafka](/azure/data-explorer/ingest-data-kafka).
1. Alternatively, ingest data through Azure Storage (Blob or ADLS Gen2) using Apache [Nifi](https://nifi.apache.org), [Fluentd](https://www.fluentd.org), or [Fluentbit](https://fluentbit.io) connectors. Then use [Azure Event Grid](/azure/data-explorer/ingest-data-event-grid) to trigger the ingestion pipeline to Azure Data Explorer.
1. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query that data as detailed in the [Continuous data export overview](/azure/data-explorer/kusto/management/data-export/continuous-data-export).

> [!NOTE]
> Microsoft Sentinel is built on Azure Monitor (Log Analytics) which in turn, is built on Azure Data Explorer. Therefore, switching between these services is seamless. This allows you to reuse Kusto query language queries and dashboards across these services.

### Components

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs): Fully managed, real-time data ingestion service that's simple, trusted, and scalable.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub): Managed service to enable bi-directional communication between IoT devices and Azure.
- [Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction): Easy, cost-effective, enterprise-grade service for open source analytics with Apache Kafka.
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer): Fast, fully managed and highly scalable data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more.
- [Azure Data Explorer Dashboards](/azure/data-explorer/azure-data-explorer-dashboards): Natively export Kusto queries that were explored in the Web UI to optimized dashboards.
- [Microsoft Sentinel](https://azure.microsoft.com/services/azure-sentinel): Intelligent security analytics for your entire enterprise.
- [Azure Monitor](https://azure.microsoft.com/services/monitor): Full observability into your applications, infrastructure, and network

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Ornat Spodek](https://www.linkedin.com/in/ornat-s-89123544) | Senior Content Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Data Explorer documentation](/azure/data-explorer)
- [Training: Introduction to Azure Data Explorer](/training/modules/intro-to-azure-data-explorer)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [What is Microsoft Sentinel?](/azure/sentinel/overview)

## Related resources

- [Big data analytics with Azure Data Explorer](big-data-azure-data-explorer.yml)
- [Azure Data Explorer interactive analytics](interactive-azure-data-explorer.yml)
- [IoT analytics with Azure Data Explorer](iot-azure-data-explorer.yml)