[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Monitor and Microsoft Sentinel – Azure’s managed services for end-to-end IT, application performance, and security monitoring – are built on top of the Azure Data Explorer platform, which enables processing and analyzing large volumes of data streamed in from multiple sources in near-real time.

This solution demonstrates how to use the Azure Data Explorer platform in synergy with Azure Monitoring and Microsoft Sentinel to consolidate your data estate and augment your monitoring and analytics capabilities.

## Architecture

:::image type="content" source="../media/azure-augmented-monitoring.svg" alt-text="Augmented monitoring solution with Azure Monitor, Microsoft Sentinel, and Azure Data Explorer." lightbox="../media/azure-augmented-monitoring.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/monitor-azure-data-explorer.vsdx) of this architecture.*

### Scenario details
Azure Data Explorer is a Platform as a Service (PaaS) offering that enables ingesting, storing, querying, and visualizing large volumes of data in near-real time. It offers a powerful query language called Kusto Query Language (KQL), used by all Azure services built on top of the platform, and automatically manages its underlying infrastructure to ensure performance and availability.
Azure Monitor and Microsoft Sentinel are Azure’s native Software as a Service (SaaS) solutions for IT and application monitoring and security, which Microsoft develops and hones to the needs of Azure customers monitoring their Azure and hybrid IT deployments.

:::image type="content" source="../media/azure-monitor-micorosoft-sentinel-azure-data-explorer.svg" alt-text="A diagram that illustrates how Azure Monitor and Microsoft are built on top of Azure Data Explorer and share visualization and alerting capabilities." lightbox="../media/azure-monitor-micorosoft-sentinel-azure-data-explorer.svg" border="false":::

### More value together 

Platform as a Service and Software as a Service offerings provide you with different levels of control and management:
-	Azure Data Explorer provides flexibility with the platform’s underlying storage and analysis capabilities, and automatically scales horizontally as data volumes increase. It provides connectors that let you ingest and store various types of data – for example, business, user, and geospatial data – and provides a full set of KQL capabilities, some of which aren't required or supported for IT and security monitoring. It also provides you with the flexibility to query data in other services that are built on top of Data Explorer clusters.
-	Azure Monitor and Microsoft Sentinel (SaaS) store data in Log Analytics workspaces, which are partitions of Azure Data Explorer clusters. You can query from one Log Analytics workspace to other workspaces and across monitored resources, which means your analysis in these services is limited to IT and security data.
Azure Monitor and Microsoft Sentinel have query and service limits, based on customers’ real-world needs.    

Incorporating the features and flexibility of all three services in your architecture, gives you:

-	A broad range of data ingestion options that span various types of data and data sources.
-	The ability to query all three services from Azure Data Explorer. This enables a single-pane-of-glass view of your data by:
    -	Querying IT monitoring and non-IT data.
    -	Apply machine learning on a broad data set to discover patterns, anomaly detection, forecasting, and to gain other advanced insights. 
    -	Creating workbooks and reports that let you monitor, correlate, and act on various types of data.  
-	The flexibility to overcome Azure Monitor and Microsoft Sentinel service limits when you require exceptionally large and complex queries by querying from Azure Data Explorer – for instance, for annual audits and to analyze yearly trends. 

### Dataflow

1. Ingest data using the combined ingestion capabilities of Azure Data Explorer, Azure Monitor, and Microsoft Sentinel:

    - Configure diagnostic settings to ingest data from Azure services such as Azure Kubernetes Service (AKS), Azure App Service, Azure SQL Database, and Azure Storage.
    - Use Azure Monitor Agent to ingest data from VMs, containers, and workloads.
    - Use a wide range of connectors, agents, and APIs supported by the three services - such as Logstash, Kafka, and Logstash connectors, OpenTelemetry agents, and Azure Monitor Log Ingestion API - to ingest data from on-premises resources and other clouds.
    - Steam in data using Azure data streaming services, such as Azure IoT Hub, Azure Event Hubs, Azure Stream Analytics. 

1. Store IT and application logs and metrics in Log Analytics workspaces for ongoing operational and security monitoring by Azure Monitor and Microsoft Sentinel. Store non-IT data in Azure Data Explorer.
1. Combine features provided by Microsoft Sentinel and Azure Monitor with Azure Data Explorer to optimize flexibility and costs, and augment monitoring and analytics:
   - Use Azure Sentinel as a cloud-native Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) solution to analyze and act on security-related data across your IT environment.
   - Use Azure Monitor for monitoring the performance, availability, and health of applications, services, and IT resources to gain insights into the operational status of your cloud infrastructure, identify issues, and optimize performance.
   - Use Azure Data Explorer to increase flexibility and control and consolidate a single-pane-of-glass view of your data estate:
     - Use [Azure Data Explorer proxy](/azure/data-explorer/query-monitor-data) to analyze data from Microsoft Sentinel, Azure Monitor, and Azure Data Explorer in a single query without moving the data.
     - Apply advanced machine learning on a broad data set to discover patterns, detect anomalies, forecast, and gain other insights. Azure Data Explorer is well integrated with ML services such as Azure Machine Learning and Azure Synapse Analytics. This integration allows you to build models using other tools and services and export ML models to Azure Data Explorer for scoring data.
     - Overcome Azure Monitor and Microsoft Sentinel service limits when you require exceptionally large and complex queries – for instance, for annual audits and to analyze yearly trends. 
1. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query from Azure Data Explorer.



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