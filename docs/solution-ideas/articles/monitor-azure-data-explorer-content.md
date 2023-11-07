[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Monitor, Microsoft Sentinel, and Azure Data Explorer are based on a common technology and use Kusto Query Language (KQL) to analyze large volumes of data streamed in from multiple sources in near-real time.

This solution demonstrates how to leverage the tight integration between Azure Monitor, Microsoft Sentinel, and Azure Data Explorer to consolidate a single interactive data lake and augment your monitoring and analytics capabilities. 

> [!NOTE]
> This solution applies to Azure Data Explorer and also to [KQL databases](/fabric/real-time-analytics/create-database), which provide real-time analytics capabilities in [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview). 

## Architecture

:::image type="content" source="../media/azure-augmented-monitoring-analytics.svg" alt-text="Augmented monitoring and analytics solution with Azure Monitor, Microsoft Sentinel, and Azure Data Explorer." lightbox="../media/azure-augmented-monitoring-analytics.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/monitor-azure-data-explorer.vsdx) of this architecture.*

### Scenario details

Use cross-service queries to build a single, interactive data lake, joining data in Azure Monitor and Microsoft Sentinel, Azure's managed solutions for monitoring and security, with any data you collect for real-time analytics in Azure Data Explorer:

- Azure Monitor and Microsoft Sentinel are Azure’s native solutions for IT and application monitoring and security, which Microsoft develops, manages, and hones to the needs of Azure customers monitoring their Azure and hybrid IT deployments. 
    
    Azure Monitor and Microsoft Sentinel:
    - Provide out-of-the box monitoring, security, and analytics features and capabilities that are tailored to the needs of IT and security professionals.
    - Natively ingest monitoring data from Azure resources, and provide agents, connectors, and APIs for collecting data from resources, applications and workloads in Azure and hybrid environments.
    - Store data in Log Analytics workspaces and support KQL. You can query from one Log Analytics workspace to other workspaces, and across monitored resources and other services, such as Azure Data Explorer and Azure Resource Graph. 
 
- Azure Data Explorer is an Azure real-time data analytics offering that's not tailored to a specific business or IT scenario. 

    Azure Data Explorer:
    - Provides connectors for various types of IT and non-IT data – for example, business, user, and geospatial data.
    - Supports the full set of KQL capabilities, some of which aren't required or supported for IT and security monitoring. 
    - Enables querying data in Azure Monitor, Microsoft Sentinel, and other services that use KQL.

An architecture built on the features and flexibility provided by the three services gives you:

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
    - Use a wide range of connectors, agents, and APIs supported by the three services - such as Logstash, Kafka, and Logstash connectors, OpenTelemetry agents, Azure Data Explorer APIs, and Azure Monitor Log Ingestion API - to ingest data from on-premises resources and other clouds.
    - Stream in data using Azure data streaming services, such as Azure IoT Hub, Azure Event Hubs, Azure Stream Analytics. 

1. Store IT infrastructure and application log data in Log Analytics workspaces for ongoing operational and security monitoring by Azure Monitor and Microsoft Sentinel. Store data in Azure Data Explorer based on other real-time analytics needs.
1. Use Azure Monitor for monitoring the performance, availability, and health of applications, services, and IT resources to gain insights into the operational status of your cloud infrastructure, identify issues, and optimize performance.
1. Use Azure Sentinel as a cloud-native Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) solution to analyze and act on security-related data across your IT environment.
1. Apply advanced machine learning on a broad data set of data to discover patterns, detect anomalies, forecast, and gain other insights.
1. Leverage the tight integration between services to augment monitoring and analytics capabilities:
   
     - [Run cross-service queries](/azure/data-explorer/query-monitor-data) to analyze data from Microsoft Sentinel, Azure Monitor, and Azure Data Explorer in a single query without moving the data.
     - Consolidate a single-pane-of-glass view of your data estate with customized cross-service workbooks, dashboards, and reports.     

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
