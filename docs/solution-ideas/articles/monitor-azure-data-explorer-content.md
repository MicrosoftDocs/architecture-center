[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Microsoft Sentinel, Azure Monitor, and Azure Data Explorer are based on a common technology and use Kusto Query Language (KQL) to analyze large volumes of data streamed in from multiple sources in near-real time.

This solution demonstrates how to leverage the tight integration between Azure Monitor, Microsoft Sentinel, and Azure Data Explorer to consolidate a single interactive data lake and augment your monitoring and analytics capabilities. 

> [!NOTE]
> This solution applies to Azure Data Explorer and also to [Real-Time Analytics KQL databases](/fabric/real-time-analytics/create-database), which provide SaaS-grade real-time log, time-series, and advanced analytics capabilities as part of [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview). 

## Architecture

:::image type="content" source="../media/azure-augmented-monitoring-analytics.svg" alt-text="Augmented monitoring and analytics solution with Azure Monitor, Microsoft Sentinel, and Azure Data Explorer." lightbox="../media/azure-augmented-monitoring-analytics.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/monitor-azure-data-explorer.vsdx) of this architecture.*

### Scenario details

Use cross-service queries to build a single, interactive data lake, joining data in Microsoft Sentinel, Azure Monitor, and Azure Data Explorer:

- Microsoft Sentinel is Azure’s cloud-native Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) solution. 

    Use Microsoft Sentinel to:

    - Collect security data from various sources, such as Azure resources, Microsoft 365, and other cloud and on-premises solutions, using a variety of connectors and APIs.
    - Detect and investigate threats using advanced analytics, machine learning, and Microsoft threat intelligence.
    - Respond to incidents and automate common case-management tasks using automation rules and logic apps-based playbooks.
    - Analyze security data and hunt for threats by correlating data from multiple sources and services in Microsoft Sentinel using KQL.

- Azure Monitor is Azure’s managed solution for IT and application monitoring. 

    Use Azure Monitor to:

    - Collect monitoring data from Azure resources and any sources, applications, and workloads in Azure and hybrid environments using a set of agents, connectors, and APIs.
    - Track, alert, and act on monitoring data using out-of-the box IT monitoring tools and analytics features, including Artificial Intelligence for IT Operations (AIOps) features and prebuilt workbooks for monitoring specific resources, such as virtual machines, containers, and applications.
    - Improve IT and application efficiency and performance and troubleshoot operational issues.
    - Query and analyze data in Azure Monitor and other services, such as Azure Data Explorer and Azure Resource Graph, using KQL.
 
- Azure Data Explorer is part of the Azure data platform, providing real-time, advanced analytics of any type of structure and unstructured data. 

    Use Azure Data Explorer to:

    - Collect various types of IT and non-IT data – for example, business, user, and geospatial data - using a range of connectors and APIs.
    - Maximize data management capabilities, with full schema control, processing of incoming data using KQL, materialized views, partitioning, granular retention, and caching controls.  
    - Take advantage of the full set of KQL's analytics capabilities, including hosting machine learning algorithms in python and federated queries to other data technologies, such as SQL server, data lakes, and Cosmos DB. 
    - Query data in Azure Monitor, Microsoft Sentinel, and other services that use KQL.

An architecture built on the features and flexibility provided by the three services gives you:

- A broad range of data ingestion options that span various types of data and data sources.
- A powerful set of native security, observability, and data analytics features and capabilities.
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
1. Use Azure Sentinel as a cloud-native Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) solution to analyze and act on security-related data across your IT environment.
1. Use Azure Monitor for monitoring the performance, availability, and health of applications, services, and IT resources to gain insights into the operational status of your cloud infrastructure, identify issues, and optimize performance.
1. Use Azure Data Explorer for all kinds of data that require custom or more flexible handling or analytics. Common examples are user and business data and other data streams that are not handled natively by Sentinel and Azure Monitor. 
1. Apply advanced machine learning on a broad set of data from your entire data estate to discover patterns, detect anomalies, forecast, and gain other insights.
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
