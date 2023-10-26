[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea demonstrates how to add near real-time analytics to an existing architecture that's based on a message broker and that's part of an operational Online Transaction Processing (OLTP) application.

## Architecture

:::image type="content" source="../media/analytics-service-bus.png" alt-text="Diagram that shows an archictecture for implementing near real-time analytics." lightbox="../media/analytics-service-bus.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/analytics-service-bus.vsdx) of this architecture.*

The diagram shows two data paths. The main path, which is represented by solid lines and boxes 1 through 5, is the ingestion of data from various sources into a service bus, where it's processed by a stream analytics job and stored in a SQL database. The second path, which is represented by dotted lines and boxes, shows the data flowing from the service bus to an Azure Data Explorer cluster, where it can be queried and analyzed via Kusto Query Language (KQL).

This architecture describes how to implement near real-time analytics for multiple use cases. Azure Service Bus is used to implement a [Queue-Based Load Leveling](../../patterns/queue-based-load-leveling-content.yml) pattern for transactional applications.

In the arcthitecture, Azure Data Explorer is used to run analytics in near real-time and expose data via either APIs or direct queries to, for example, Power BI, Azure Managed Grafana, or Azure Data Explorer dashboards.

### Dataflow

The data source in the architecture is an existing transactional application that uses Service Bus to asynchronously scale out the OLTP application.

1. The OLTP application (data source) in App Services sends data to Azure Service Bus.

1. Data flows from Azure Service Bus in two directions:

   1. In the existing OLTP application flow, it triggers a functions app to store data in Azure SQL Database, Azure Cosmos DB, or a similar operational database.

   1. In the near real-time analytics flow, it triggers an orchestration flow.

1. The orchestration flow sends data to Azure Data Explorer for near real-time analytics. The flow can use either:

   - A functions app that uses SDKs to send data in micro batches or using managed streaming ingestion support provided by Azure Data Explorer when it's [configured for streaming ingestion].
   - A polling service, such as an application hosted on Azure Kubernetes Service or an Azure VM, that sends data to Azure Data Explorer in micro batches. This option doesn't require configuring Azure Data Explorer streaming ingestion.

1. Azure Data Explorer can process the data using schema mapping and update policies, and make it available through an API, SDK, or connector for interactive analytics or reporting. Optionally, Azure Data Explorer can also ingest or reference data from other data sources, such as Azure SQL Database or Azure Data Lake Storage.

1. Applications, self-developed or reporting services such as Azure Data Explorer Dashboards. Power Bl, and Azure Managed Grafana, can query the data in Azure Data Explorer in near real-time.

### Components

- [Azure App Service](https://azure.microsoft.com/products/app-service)
- [Azure Service Bus](https://azure.microsoft.com/products/service-bus/): Service Bus is a secure, reliable message broker.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/): A fully managed SQL database built for the cloud with automatic updates, provisioning, scaling, and backups.
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db/): Is a globally distributed, multi-model database for any scale.
- [Azure Functions](https://azure.microsoft.com/products/functions/): is an event-driven serverless compute platform. With Functions, you can deploy and operate at scale in the cloud and use triggers and bindings to integrate services.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/products/kubernetes-service/): is a highly available, secure, and fully managed Kubernetes service for application and microservice base workloads.
- [Azure Data Explorer](https://azure.microsoft.com/products/data-explorer/): Fast, fully managed and highly scalable data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more.
- [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage/): Massively scalable, secure data lake functionality built on Azure Blob Storage
- [Power BI](https://powerbi.microsoft.com): can help you turn your data into coherent, visually immersive, and interactive insights. It's used here to visualize customer profiles and metrics.
- [Azure Managed Grafana](https://azure.microsoft.com/products/managed-grafana/): A fully managed service, Azure Managed Grafana lets you deploy Grafana without having to deal with setup.

## Scenario details

Real-time analytics is a process of analyzing data as soon as it is generated, providing insights into the current state of the system. Organizations are increasingly adopting real-time analytics to gain a competitive edge by making informed decisions quickly. Near real-time analytics is a variant of real-time analytics that provides insights within seconds or minutes of data generation. 

This enables organizations to gain insights faster, make better decisions, and respond to changing conditions more effectively. Near real-time analytics can be applied to various domains, such as e-commerce, health care, manufacturing, and finance. For example, an e-commerce company can use near real-time analytics to monitor customer behavior, optimize pricing, and personalize recommendations. 

A health care provider can use near real-time analytics to track patient outcomes, detect anomalies, and improve quality of care. A manufacturing company can use near real-time analytics to optimize production, reduce waste, and prevent downtime. A financial institution can use near real-time analytics to detect fraud, manage risk, and comply with regulations. These are just some of the potential use cases that illustrate the importance and benefits of near real-time analytics for organizations.

Many organizations today bring near real-time analytics into their existing solutions. This solution idea demonstrates how to add near real-time analytics to an existing architecture that's based on a message broker and that's part of an operational OLTP application.

OLTP stands for Online Transaction Processing. It is a type of software application that manages transaction-oriented applications, typically for data entry and retrieval transactions in a real-time environment. OLTP systems are designed to process small, fast transactions that are typically financial in nature, such as bank transactions or credit card purchases.

This article is intended for IT administrators, cloud architects, operations and monitoring teams who want to enhance their existing message broker-based architecture with near real-time analytics.

### Potential use cases

These uses cases have similar design patterns:

Transaction monitoring in FinTech

Campaign promotion and monitoring in marketing

Supply chain management – monitoring, optimization, analytics and forecasting.

## Contributors

## Next steps

- Build an app using Azure Service Bus samples - [Azure Service Bus samples or examples](/azure/service-bus-messaging/service-bus-samples)
- Azure Data Explorer data ingest samples - <https://github.com/Azure/azure-kusto-python/blob/master/azure-kusto-ingest/tests/sample.py>

