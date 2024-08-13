[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Microsoft Sentinel, Azure Monitor, and Azure Data Explorer are based on a common technology and use Kusto Query Language (KQL) to analyze large volumes of data streamed in from multiple sources in near-real time.

This solution demonstrates how to take advantage of the tight integration between Microsoft Sentinel, Azure Monitor, and Azure Data Explorer. You can use these services to consolidate a single interactive data estate and augment your monitoring and analytics capabilities. 

> [!NOTE]
> This solution applies to Azure Data Explorer and also to [Real-Time Analytics KQL databases](/fabric/real-time-analytics/create-database), which provide SaaS-grade real-time log, time-series, and advanced analytics capabilities as part of [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview). 

*The Grafana and Jupyter logos and are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture

:::image type="content" source="../media/azure-augmented-security-monitoring-analytics.svg" alt-text="Diagram that shows an augmented monitoring and analytics solution that uses Monitor, Microsoft Sentinel, and Azure Data Explorer." lightbox="../media/azure-augmented-security-monitoring-analytics.svg" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-augmented-security-monitoring-analytics.pptx) of this architecture.*


### Dataflow

1. Ingest data by using the combined ingestion capabilities of [Microsoft Sentinel](/azure/sentinel/connect-data-sources), [Azure Monitor](/azure/azure-monitor/essentials/data-collection), and [Azure Data Explorer](/azure/data-explorer/ingest-data-overview):

    - Configure diagnostic settings to ingest data from Azure services like Azure Kubernetes Service (AKS), Azure App Service, Azure SQL Database, and Azure Storage.
    - Use Azure Monitor Agent to ingest data from VMs, containers, and workloads.
    - Use a wide range of connectors, agents, and APIs supported by the three services to ingest data from on-premises resources and other clouds. Supported connectors, agents, and APIs include Logstash, Kafka, and Logstash connectors, OpenTelemetry agents, Azure Data Explorer APIs, and the Azure Monitor Log Ingestion API. 
    - Stream data in by using Azure services like Azure IoT Hub, Azure Event Hubs, and Azure Stream Analytics. 
1. Use Microsoft Sentinel to monitor, investigate, and alert and act on security-related data across your IT environment.
1. Use Azure Monitor to monitor, analyze, and alert and act on the performance, availability, and health of applications, services, and IT resources. Doing so enables you to gain insights into the operational status of your cloud infrastructure, identify problems, and optimize performance.
1. Use Azure Data Explorer for any data that requires custom or more flexible handling or analytics, including full schema control, cache or retention control, deep data platform integrations, and machine learning. 
1. Optionally, apply advanced machine learning on a broad set of data from your entire data estate to discover patterns, detect anomalies, get forecasts, and gain other insights.
1. Take advantage of the tight integration between services to augment monitoring and analytics capabilities:
   
     - Run cross-service queries from [Microsoft Sentinel, Monitor](/azure/azure-monitor/logs/azure-monitor-data-explorer-proxy), and [Azure Data Explorer](/azure/data-explorer/query-monitor-data) to analyze and correlate data in all three services in one query without moving the data.
     - Consolidate a single-pane-of-glass view of your data estate with customized cross-service workbooks, dashboards, and reports.     

### Components

Use cross-service queries to build a consolidated, interactive data estate, joining data in Microsoft Sentinel, Monitor, and Azure Data Explorer:

- [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel) is the Azure cloud-native solution for security information and event management (SIEM) and security orchestration, automation, and response (SOAR). Microsoft Sentinel has the following features:

    - Connectors and APIs for collecting security data from various sources, like Azure resources, Microsoft 365, and other cloud and on-premises solutions.
    - Advanced built-in analytics, machine learning, and threat intelligence capabilities for detecting and investigating threats.
    - Rules-based case management and incident response automation capabilities that use modular, reusable playbooks that are based on Azure Logic Apps.
    - KQL query capabilities that let you analyze security data and hunt for threats by correlating data from multiple sources and services.

- [Azure Monitor](https://azure.microsoft.com/products/monitor/) is the Azure managed solution for IT and application monitoring. Monitor has the following features:


    - Native ingestion of monitoring data from Azure resources. Agents, connectors, and APIs for collecting monitoring data from Azure resources and any sources, applications, and workloads in Azure and hybrid environments.
    - IT monitoring tools and analytics features, including AI for IT operations (AIOps) features, alerting and automated actions, and prebuilt workbooks for monitoring specific resources, like virtual machines, containers, and applications.
    - End-to-end observability capabilities that help you improve IT and application efficiency and performance.
    - KQL query capabilities that enable you to analyze data and troubleshoot operational issues by correlating data across resources and services.
 
- [Azure Data Explorer](https://azure.microsoft.com/products/data-explorer/) is part of the Azure data platform. It provides real-time advanced analytics for any type of structured and unstructured data. It has the following features:

    - Connectors and APIs for various types of IT and non-IT data, for example, business, user, and geospatial data.
    - The full set of KQL's analytics capabilities, including hosting of machine learning algorithms in Python and federated queries to other data technologies, like SQL Server, data lakes, and Azure Cosmos DB.  
    - Scalable data management capabilities, including full schema control, processing of incoming data by using KQL, materialized views, partitioning, granular retention, and caching controls.  
    - Cross-service query capabilities that enable you to correlate collected data with data in Microsoft Sentinel, Monitor, and other services.

## Scenario details

An architecture built on the features and flexibility provided by Microsoft Sentinel, Monitor, and Azure Data Explorer gives you:

- A broad range of data ingestion options that span various types of data and data sources.
- A powerful set of native security, observability, and data analytics features and capabilities.
- The ability to use cross-service queries to create a single-pane-of-glass view of your data by:
    - Querying IT monitoring and non-IT data.
    - Applying machine learning on a broad dataset to discover patterns, implement anomaly detection and forecasting, and get other advanced insights. 
    - Creating workbooks and reports that enable you to monitor, correlate, and act on various types of data.  

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
