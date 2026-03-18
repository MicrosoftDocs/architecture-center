[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to use Azure Data Explorer to add near real-time analytics capabilities to an existing message broker architecture that's based on Azure Service Bus. The solution keeps operational systems optimized for transactional workloads while analytics queries run independently with minimal latency. This architecture is intended for IT administrators, cloud architects, and operations and monitoring teams.

## Architecture

:::image type="complex" source="../media/analytics-service-bus.svg" alt-text="Diagram that illustrates an architecture for implementing near real-time analytics." lightbox="../media/analytics-service-bus.svg" border="false":::
   Diagram that shows two data paths: a dotted line for the existing OLTP flow and a solid line for the new near real-time analytics flow. An OLTP application hosted in Azure App Service sends data to Azure Service Bus. From Azure Service Bus, the dotted line path shows data triggering an Azure Functions app, which sends processed data to an operational database like SQL Database or Azure Cosmos DB. The solid line path shows data flowing from Azure Service Bus to Azure Data Explorer, either through an Azure Functions app or through a polling service hosted on AKS or an Azure VM. Azure Data Explorer also ingests or references data from SQL Database and Azure Data Lake Storage. Applications and reporting services, including Azure Data Explorer dashboards, Power BI, and Azure Managed Grafana, query data from Azure Data Explorer for near real-time analytics.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/analytics-service-bus.vsdx) of this architecture.*

*The Grafana logo is a trademark of Raintank, Inc., dba Grafana Labs. No endorsement is implied by the use of this mark.*

## Data flow

The diagram shows two data paths. The dotted line path represents the existing architecture of the Online Transaction Processing (OLTP) application, while the solid line path represents the new architecture that adds near real-time analytics capabilities to the existing OLTP application.


1. The OLTP application (the data source), hosted in **App Service**, sends data to **Service Bus**. 

1. Data flows from Service Bus in two directions: 

    a. In the existing OLTP application flow, the data triggers an **Azure Functions** app that processes data from Service Bus. The Functions app then sends the processed data to an operational database, like an **Azure SQL database** or an **Azure Cosmos DB** database. The dotted line in the diagram represents this flow.

    b. In the near real-time analytics flow, data from Service Bus is sent to **Azure Data Explorer** for analytics. The solid line in the diagram represents this flow.

1. The orchestration flow sends data to **Azure Data Explorer** for near real-time analytics by using one of the following approaches:

   - An **Azure Functions** app uses SDKs to send data in micro batches or uses managed streaming ingestion when Azure Data Explorer is [configured for streaming ingestion](/azure/data-explorer/ingest-data-streaming).
   
   - A polling service, like an application hosted on **Azure Kubernetes Service (AKS)** or an **Azure virtual machine (VM)**, sends data to Azure Data Explorer in micro batches. This option doesn't require configuring streaming ingestion.

1. Azure Data Explorer processes the data by using [schema mapping](/azure/data-explorer/kusto/management/mappings) and [update policies](/azure/data-explorer/kusto/management/updatepolicy). Azure Data Explorer makes the data available for interactive analytics and reporting through APIs, SDKs, or connectors. Azure Data Explorer also ingests or references data from other sources, like Azure SQL Database or Azure Data Lake Storage.

1. Applications, custom services, and reporting services like [Azure Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards), Power BI, and Azure Managed Grafana query data in Azure Data Explorer in near real time.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) provides a managed platform where you can build and host web apps, mobile back ends, and RESTful APIs in the programming language of your choice, without managing infrastructure. In this architecture, App Service hosts the source OLTP application that generates the data that Service Bus ingests.

- [Service Bus](/azure/well-architected/service-guides/service-bus/reliability) provides reliable cloud messaging as a service. In this architecture, Service Bus captures data generated at the source and triggers the orchestration flow.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a fully managed SQL database that's built for the cloud. SQL Database provides automatic updates, provisioning, scaling, and backups. In this architecture, SQL Database is an operational database that stores data output from the Functions app.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multimodel database for applications of any scale. Azure Cosmos DB, like SQL Database, can also serve as an operational database that stores data output from the Functions app.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is an event-driven, serverless compute platform. With Functions, you can deploy and operate at scale in the cloud and use triggers and bindings to integrate services. In this architecture, Azure Functions sends data to an operational database via an orchestration flow or directly to Azure Data Explorer.

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a highly available, managed Kubernetes service for application and microservices workloads. In this architecture, AKS hosts a polling service, which sends data to Azure Data Explorer in micro batches.

- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) is a managed, highly scalable data analytics service for real-time analysis of large volumes of data that streams from applications, websites, and Internet of Things (IoT) devices. In this architecture, Azure Data Explorer runs analytics in near real time and exposes data via APIs or direct queries.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction), built on Azure Blob Storage, provides massively scalable data lake functionality. In this architecture, Azure Data Explorer pulls data from Data Lake Storage and combines it with data ingested from Azure App Service for analytics.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a business analytics service that helps turn your data into coherent, visually immersive, interactive insights. In this architecture, Power BI serves as a visualization tool for the data received from Azure App Service.

- [Azure Managed Grafana](/azure/managed-grafana/overview) is a fully managed service that you can use to deploy Grafana without spending time on configuration. In this architecture, similar to Power BI or Azure Data Explorer dashboards, Azure Managed Grafana serves as a visualization tool to create analytics dashboards on the data received from Azure App Service.

## Scenario details

Real-time analytics is the process of immediately analyzing data when it's generated to get insights into the current state of the system. Organizations are increasingly adopting real-time analytics to gain a competitive edge. Near real-time analytics is a variant of real-time analytics that provides insights within seconds or minutes of data generation.

Organizations can use these processes to gain insights faster, make better decisions, and respond to changing conditions more effectively. You can apply near real-time analytics to various domains, like e-commerce, healthcare, manufacturing, and finance. For example, an e-commerce company can use near real-time analytics to monitor customer behavior, optimize pricing, and personalize recommendations.

Many organizations implement near real-time analytics in existing solutions. This solution idea demonstrates how to add near real-time analytics to an existing architecture that's based on a message broker and that's part of an operational OLTP application.

OLTP is a type of data processing that manages transaction-oriented applications, typically for data entry and retrieval transactions in a real-time environment. OLTP systems process small, fast transactions that are often financial in nature, like bank transactions or credit card purchases.

### Potential use cases

The following use cases illustrate the benefits of near real-time analytics:

- Healthcare providers can track patient outcomes, detect anomalies, and improve quality of care.

- Manufacturing companies can optimize production, reduce waste, and prevent downtime.

- Financial institutions can monitor transactions, detect fraud, manage risk, and ensure compliance with regulations.

- Commerce companies can monitor campaigns and gain insights to support promotion.

- Companies can monitor, optimize, analyze, and forecast supply chains.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Shlomo Sagir](https://il.linkedin.com/in/shlomo-sagir) | Senior Content Developer

Other contributors:

- [Sreedhar Pelluru](https://www.linkedin.com/in/sreedharpelluru/) | Senior Content Developer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Service Bus samples](/azure/service-bus-messaging/service-bus-samples)
- [Azure Data Explorer data ingestion samples](https://github.com/Azure/azure-kusto-python/blob/master/azure-kusto-ingest/tests/sample.py)

## Related resource

- [Near real-time lakehouse data processing](../../example-scenario/data/real-time-lakehouse-data-processing.yml)
