[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Monitor, Microsoft Sentinel, and Azure Data Explorer are based on a common technology that enables using Kusto Query Language (KQL) to analyze large volumes of data streamed in from multiple sources in near-real time.

This solution demonstrates how to leverage the tight integration between Azure Monitor, Microsoft Sentinel, and Azure Data Explorer to consolidate your data estate and augment your monitoring and analytics capabilities.

## Architecture

:::image type="content" source="../media/azure-augmented-monitoring.svg" alt-text="Augmented monitoring solution with Azure Monitor, Microsoft Sentinel, and Azure Data Explorer." lightbox="../media/azure-augmented-monitoring.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/monitor-azure-data-explorer.vsdx) of this architecture.*

### Scenario details

Platform as a Service (PaaS) and Software as a Service (SaaS) offerings provide you with different levels of control and management:

- Azure Monitor and Microsoft Sentinel are Azure’s native Software as a Service solutions for IT and application monitoring and security, which Microsoft develops, manages, and hones to the needs of Azure customers monitoring their Azure and hybrid IT deployments. 
    
    Both services store data in Log Analytics workspaces, and both support the subset of KQL capabilities that is useful for IT and security monitoring. You can query from one Log Analytics workspace to other workspaces, and across monitored resources and other services, such as Azure Data Explorer and Azure Resource Graph. 
- Azure Data Explorer provides is a Platform as a Service offering, which provides greater flexibility and fewer service limits. 

    Azure Data Explorer:
    - Enables querying data in Azure Monitor, Microsoft Sentinel, and other services that use KQL.
    - Provides connectors for various types of IT and non-IT data – for example, business, user, and geospatial data.
    - Supports the full set of KQL capabilities, some of which aren't required or supported for IT and security monitoring. 
    - Automatically scales horizontally as data volumes increase. 

An architecture built on the features and flexibility of provided by the three services gives you:

- A broad range of data ingestion options that span various types of data and data sources.
- A powerful set of native monitoring, security, and analytics features and capabilities.
- The ability to use cross-service queries to create a single-pane-of-glass view of your data by:
    - Querying IT monitoring and non-IT data.
    - Applying machine learning on a broad data set to discover patterns, anomaly detection, forecasting, and to gain other advanced insights. 
    - Creating workbooks and reports that let you monitor, correlate, and act on various types of data.  

### Dataflow

1. Ingest data using the combined ingestion capabilities of Azure Data Explorer, Azure Monitor, and Microsoft Sentinel:

    - Configure diagnostic settings to ingest data from Azure services such as Azure Kubernetes Service (AKS), Azure App Service, Azure SQL Database, and Azure Storage.
    - Use Azure Monitor Agent to ingest data from VMs, containers, and workloads.
    - Use a wide range of connectors, agents, and APIs supported by the three services - such as Logstash, Kafka, and Logstash connectors, OpenTelemetry agents, and Azure Monitor Log Ingestion API - to ingest data from on-premises resources and other clouds.
    - Stream in data using Azure data streaming services, such as Azure IoT Hub, Azure Event Hubs, Azure Stream Analytics. 

1. Store IT and application logs and metrics in Log Analytics workspaces for ongoing operational and security monitoring by Azure Monitor and Microsoft Sentinel. Store non-IT data in Azure Data Explorer.
1. Use Azure Monitor for monitoring the performance, availability, and health of applications, services, and IT resources to gain insights into the operational status of your cloud infrastructure, identify issues, and optimize performance.
1. Use Azure Sentinel as a cloud-native Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) solution to analyze and act on security-related data across your IT environment.
1. Apply advanced machine learning on a broad data set of data to discover patterns, detect anomalies, forecast, and gain other insights.
1. Leverage the tight integration between services to augment monitoring and analytics capabilities:
   
     - [Run cross-service queries from Azure Data Explorer](/azure/data-explorer/query-monitor-data) to analyze data from Microsoft Sentinel, Azure Monitor, and Azure Data Explorer in a single query without moving the data.
     - Consolidate a single-pane-of-glass view of your data estate with customized cross-service workbooks, dashboards, and reports.     
1. You can also continuously export data to Azure Storage in compressed, partitioned parquet format and seamlessly query from Azure Data Explorer.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Guy Wild](https://www.linkedin.com/in/guy-wild-596aa91a2) | Senior Content Developer

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
