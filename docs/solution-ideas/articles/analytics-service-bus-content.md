[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to use Azure Data Explorer and Azure Service Bus to enhance an existing message broker architecture with near real-time analytics. It's intended for IT administrators, cloud architects, and operations and monitoring teams.

## Architecture

:::image type="content" source="../media/analytics-service-bus.png" alt-text="Diagram that shows an architecture for implementing near real-time analytics." lightbox="../media/analytics-service-bus.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/analytics-service-bus.vsdx) of this architecture.*

*The Grafana logo is a trademark of Raintank, Inc., dba Grafana Labs. No endorsement is implied by the use of this mark.*

The diagram shows two data paths. The main path, which is represented by solid lines and boxes 1 through 5, is the ingestion of data from various sources into a service bus, where it's processed by a stream analytics job and stored in a SQL database. The second path, which is represented by dotted lines and boxes, shows the data flowing from the service bus to an Azure Data Explorer cluster, where it can be queried and analyzed via Kusto Query Language (KQL).

Service Bus is used to implement a [Queue-Based Load Leveling](../../patterns/queue-based-load-leveling.yml) pattern for a transactional application.

Azure Data Explorer is used to run analytics in near real-time and expose data via either APIs or direct queries to, for example, Power BI, Azure Managed Grafana, or Azure Data Explorer dashboards.

### Dataflow

The data source in the architecture is an existing Online Transaction Processing (OLTP) application. Service Bus is used to asynchronously scale out the application.

1. The OLTP application (the data source), hosted in Azure App Service, sends data to Service Bus.

1. Data flows from Service Bus in two directions:

   1. In the existing OLTP application flow, it triggers a function app to store data in Azure SQL Database, Azure Cosmos DB, or a similar operational database.

   1. In the near real-time analytics flow, it triggers an orchestration flow.

1. The orchestration flow sends data to Azure Data Explorer for near real-time analytics. The flow can use either:

   - A function app that uses SDKs to send data in micro batches or that uses managed streaming ingestion support provided by Azure Data Explorer when it's [configured for streaming ingestion](/azure/data-explorer/ingest-data-streaming).
   - A polling service, like an application that's hosted on Azure Kubernetes Service (AKS) or an Azure VM, that sends data to Azure Data Explorer in micro batches. This option doesn't require configuring Azure Data Explorer streaming ingestion.

1. Azure Data Explorer processes the data, by using [schema mapping](/azure/data-explorer/kusto/management/mappings) and [update policies](/azure/data-explorer/kusto/management/updatepolicy), and makes it available through an API, SDK, or connector for interactive analytics or reporting. Optionally, Azure Data Explorer can also ingest or reference data from other data sources, like SQL Database or Azure Data Lake Storage.

1. Applications, custom services, or reporting services like [Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards), Power BI, and Azure Managed Grafana can query the data in Azure Data Explorer in near real-time.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) enables you to build and host web apps, mobile back ends, and RESTful APIs in the programming language of your choice without managing infrastructure. In this architecture, App Service hosts the source OLTP application which generates the data to be ingested into Azure Service Bus.

- [Service Bus](/azure/well-architected/service-guides/service-bus/reliability) provides reliable cloud messaging as a service. In this architecture, Service Bus captures data generated at source and triggers the orchestration flow.
- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a fully managed SQL database that's built for the cloud. It provides automatic updates, provisioning, scaling, and backups. In this architecture, the SQL Database is an operational database which stores data output from the Function app.
- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multimodel database for applications of any scale. Azure Cosmos DB, just like SQL Database, can also be used as an operational database to store data output from the Functions app.
- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is an event-driven serverless compute platform. With Functions, you can deploy and operate at scale in the cloud and use triggers and bindings to integrate services. In this architecture, Azure Functions is used to send data to an operational database via an orchestration flow or directly to Azure Data Explorer.
- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a highly available, highly secure, and fully managed Kubernetes service for application and microservices workloads. AKS hosts a polling service, which sends data to Azure Data Explorer in micro batches.
- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) is a fast, fully managed, and highly scalable data analytics service for real-time analysis of large volumes of data that streams from applications, websites, IoT devices, and more. Azure Data Explorer is used to run analytics in near real-time and expose data via either APIs or direct queries.
- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction), built on Azure Blob Storage, provides massively scalable data lake functionality. In this architecture, Azure Data Explorer pulls data from Data Lake Storage and combines it with data ingested from App Service for analytics.
- [Power BI](/power-bi/fundamentals/power-bi-overview) can help you turn your data into coherent, visually immersive, interactive insights. Power BI is used as a visualization tool for the data received from App Service.
- [Azure Managed Grafana](/azure/managed-grafana/overview) is a fully managed service that enables you to deploy Grafana without spending time on configuration. In this architecture, similar to Power BI or Azure Data Explorer dashboards, Azure Managed Grafana can be used as a visualization tool to create analytics dashboards on the data received from App Service.

## Scenario details

Real-time analytics is the process of analyzing data as soon as it's generated to get insights into the current state of the system. Organizations are increasingly adopting real-time analytics to gain a competitive edge. Near real-time analytics is a variant of real-time analytics that provides insights within seconds or minutes of data generation.

These processes enable organizations to gain insights faster, make better decisions, and respond to changing conditions more effectively. Near real-time analytics can be applied to various domains, like e-commerce, healthcare, manufacturing, and finance. For example, an e-commerce company can use near real-time analytics to monitor customer behavior, optimize pricing, and personalize recommendations.

Many organizations implement near real-time analytics in existing solutions. This solution idea demonstrates how to add near real-time analytics to an existing architecture that's based on a message broker and that's part of an operational OLTP application.

OLTP stands for Online Transaction Processing. It's a type of data processing that manages transaction-oriented applications, typically for data entry and retrieval transactions in a real-time environment. OLTP systems are designed to process small, fast transactions that are frequently financial in nature, like bank transactions or credit card purchases.

### Potential use cases

Here are some use cases that illustrate the benefits of near real-time analytics:

- Healthcare providers can track patient outcomes, detect anomalies, and improve quality of care.
- Manufacturing companies can optimize production, reduce waste, and prevent downtime.
- Financial institutions can monitor transactions, detect fraud, manage risk, and ensure compliance with regulations.
- Commerce companies can monitor campaigns and gain insights to support promotion.
- Companies can monitor, optimize, analyze, and forecast supply chains.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Shlomo Sagir](https://il.linkedin.com/in/shlomo-sagir) | Senior Content Developer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Service Bus samples](/azure/service-bus-messaging/service-bus-samples)
- [Azure Data Explorer data ingestion samples](https://github.com/Azure/azure-kusto-python/blob/master/azure-kusto-ingest/tests/sample.py)

## Related resources

- [Near real-time lakehouse data processing](../../example-scenario/data/real-time-lakehouse-data-processing.yml)
