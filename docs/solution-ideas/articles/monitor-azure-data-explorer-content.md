[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Microsoft Sentinel, Azure Monitor, and Azure Data Explorer are based on a common technology and use Kusto Query Language (KQL) to analyze large volumes of data streamed in from multiple sources in near-real time.

This solution demonstrates how to leverage the tight integration between Microsoft Sentinel, Azure Monitor, and Azure Data Explorer to consolidate a single interactive data lake and augment your monitoring and analytics capabilities. 

> [!NOTE]
> This solution applies to Azure Data Explorer and also to [Real-Time Analytics KQL databases](/fabric/real-time-analytics/create-database), which provide SaaS-grade real-time log, time-series, and advanced analytics capabilities as part of [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview). 

## Architecture

:::image type="content" source="../media/azure-augmented-monitoring-analytics.svg" alt-text="Augmented monitoring and analytics solution with Azure Monitor, Microsoft Sentinel, and Azure Data Explorer." lightbox="../media/azure-augmented-monitoring-analytics.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/monitor-azure-data-explorer.vsdx) of this architecture.*

### Scenario details

Use cross-service queries to build a single, interactive data lake, joining data in Microsoft Sentinel, Azure Monitor, and Azure Data Explorer:

- Microsoft Sentinel is Azure’s cloud-native solution for Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR). 

    Microsoft Sentinel offers:

    - Connectors and APIs for collecting security data from various sources, such as Azure resources, Microsoft 365, and other cloud and on-premises solutions.
    - Advanced built-in analytics, machine learning, and threat intelligence capabilities for detecting and investigating threats.
    - Rules-based case management and incident response automation capabilities using modular, reusable, Logic Apps-based playbooks. 
    - KQL query capabilities that let you analyze security data and hunt for threats by correlating data from multiple sources and services.

- Azure Monitor is Azure’s managed solution for IT and application monitoring. 

    Azure Monitor offers:

    - Natively ingestion of monitoring data from Azure resources, and agents, connectors, and APIs for collect monitoring data from Azure resources and any sources, applications, and workloads in Azure and hybrid environments.
    - IT monitoring tools and analytics features, including Artificial Intelligence for IT Operations (AIOps) features and prebuilt workbooks for monitoring specific resources, such as virtual machines, containers, and applications.
    - End-to-end observability capabilities that let you improve IT and application efficiency and performance.
    - KQL query capabilities that let you analyze data and troubleshoot operational issues by correlating data across resources and services.
 
- Azure Data Explorer is part of the Azure data platform, providing real-time, advanced analytics of any type of structure and unstructured data. 

    Azure Data Explorer offers:

    - Connectors and APIs for various types of IT and non-IT data – for example, business, user, and geospatial data.
    - The full set of KQL's analytics capabilities, including hosting of machine learning algorithms in python and federated queries to other data technologies, such as SQL Server, data lakes, and Cosmos DB.  
    - Scalable data management capabilities, including full schema control, processing of incoming data using KQL, materialized views, partitioning, granular retention, and caching controls.  
    - Cross-service query capabilities that let you correlate collected data with data in Microsoft Sentinel, Azure Monitor, and other services.

An architecture built on the features and flexibility provided by the three services gives you:

- A broad range of data ingestion options that span various types of data and data sources.
- A powerful set of native security, observability, and data analytics features and capabilities.
- The ability to use cross-service queries to create a single-pane-of-glass view of your data by:
    - Querying IT monitoring and non-IT data.
    - Applying machine learning on a broad data set to discover patterns, anomaly detection, forecasting, and to gain other advanced insights. 
    - Creating workbooks and reports that let you monitor, correlate, and act on various types of data.  

### Dataflow

1. Ingest data using the combined ingestion capabilities of Microsoft Sentinel, Azure Monitor, and Azure Data Explorer:

    - Configure diagnostic settings to ingest data from Azure services such as Azure Kubernetes Service (AKS), Azure App Service, Azure SQL Database, and Azure Storage.
    - Use Azure Monitor Agent to ingest data from VMs, containers, and workloads.
    - Use a wide range of connectors, agents, and APIs supported by the three services - such as Logstash, Kafka, and Logstash connectors, OpenTelemetry agents, Azure Data Explorer APIs, and Azure Monitor Log Ingestion API - to ingest data from on-premises resources and other clouds.
    - Stream in data using Azure data streaming services, such as Azure IoT Hub, Azure Event Hubs, Azure Stream Analytics. 
1. Use Azure Sentinel to monitor, investigate, and act on security-related data across your IT environment.
1. Use Azure Monitor for monitoring the performance, availability, and health of applications, services, and IT resources to gain insights into the operational status of your cloud infrastructure, identify issues, and optimize performance.
1. Use Azure Data Explorer for any data that requires custom or more flexible handling or analytics, including full schema control, cache or retention control, deep data platform integrations, and machine learning execution. 
1. Optionally, apply advanced machine learning on a broad set of data from your entire data estate to discover patterns, detect anomalies, forecast, and gain other insights.
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
