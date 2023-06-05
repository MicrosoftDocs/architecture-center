[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Mining companies can have Azure continually monitor the performance data from their equipment or from other assets. Analysis of the data identifies anomalies and results in recommendations for maintenance and repair. Such monitoring can prevent failures and reduce operating costs.

## Architecture

:::image type="content" source="../media/monitor-mining-equipment.svg" alt-text="Diagram showing the architecture for monitoring mining equipment." lightbox="../media/monitor-mining-equipment.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1816419-PR-2777-monitor-mining-equipment.vsdx) of this architecture.*

### Dataflow

The data flows through the solution as follows:

1. Equipment and other assets have integrated sensor systems that deliver sensor data (in CSV files) to a folder in an FTP server or to Azure Storage.
1. Azure Logic App monitors the folder for new or modified files.
1. Logic App triggers the Data Factory pipeline when a file is added to the folder, or when a previously added file is modified.
1. Azure Data Factory obtains the data from the FTP server or from Azure Storage, and stores it to a data lake that Azure Data Lake provides. The Delta Lake open-source software augments Data Lake capabilities.
1. The cloudFiles feature of Azure Databricks Auto Loader automatically processes new files as they arrive at the data lake, and can also process existing files.
   1. cloudFiles uses structured streaming APIs to check if sensor values exceed thresholds. If so, it copies the values to a separate storage folder (Alerts).
   1. After appropriate cleansing and transforming of the data, it moves the data to Delta Lake Bronze/Silver/Gold folders. The folders contain various transformations of the data; for example, ingested (Bronze), to refined (Silver), to aggregated (Gold).
1. An Azure Synapse connector in Azure Databricks moves the data from the data lake to an Azure Synapse Analytics dedicated SQL pool.
1. Whenever a new alert arrives in the Alerts folder, Azure Function Apps sends notifications to Azure Notification Hub.
1. Notification Hub then sends notifications to various mobile platforms to alert operators and administrators of events that require attention.
1. Monitoring advisors can create visual reports to explore the data. They can publish and share them, and collaborate with others. Power BI integrates with other tools, including Power Apps. Advisors can integrate Power BI reports into a Canvas App in Power Apps for a good user experience.

### Components

Data is loaded from these different data sources using several Azure components:

- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) makes Azure Storage the foundation for building enterprise data lakes on Azure. It can quickly process massive amounts of data (petabytes).
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a managed service that orchestrates and automates data movement and data transformation. In this architecture, it copies the data from the source to Azure Storage.
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) are automated workflows for common enterprise orchestration tasks. Logic Apps includes [connectors](/connectors/) for many popular cloud services, on-premises products, and other applications.
- [Azure Databricks](https://azure.microsoft.com/services/databricks) is an Apache Spark-based analytics platform optimized for the Microsoft Azure cloud services platform. Databricks is integrated with Azure to provide one-click setup, streamlined workflows, and an interactive workspace that was designed in collaboration with the founders of Apache Spark.
- [Azure Databricks – Auto Loader](/azure/databricks/spark/latest/structured-streaming/auto-loader) provides a structured streaming source called cloudFiles. The cloudFiles source automatically processes new files as they arrive at a directory, and can also process other files in the directory.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is a distributed system for storing and analyzing large datasets. Its use of massive parallel processing (MPP) makes it suitable for running high-performance analytics.
- [Azure Functions](https://azure.microsoft.com/services/functions) allows you to run small pieces of code (called "functions") without worrying about application infrastructure. Azure Functions is a great solution for processing bulk data, integrating systems, working with the internet-of-things (IoT), and building simple APIs and micro-services.
- [Power BI](/power-bi/) is a suite of business analytics tools to analyze data and provide insights. Power BI can query a semantic model stored in Analysis Services, or it can query Azure Synapse directly.
- [Power Apps](/powerapps/powerapps-overview) is a suite of apps, services, and connectors for building custom business apps. It includes an underlying data platform ([Microsoft Dataverse](/powerapps/maker/data-platform/data-platform-intro)) and a rapid development environment.

## Scenario details

### Potential use cases

- Monitor mining equipment and other equipment that can provide the needed data. This solution is ideal for the energy industry.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Ansley Yeo](https://www.linkedin.com/in/ansleyyeo) | Technology Leader and IoT

## Next steps

- [Create, monitor, and manage FTP files by using Azure Logic Apps](/azure/connectors/connectors-create-api-ftp)
- [Copy data from FTP server by using Azure Data Factory](/azure/data-factory/connector-ftp)
- [Load files from Azure Blob storage and Azure Data Lake Storage Gen1 and Gen2 using Auto Loader](/azure/databricks/spark/latest/structured-streaming/auto-loader)
- [Azure Synapse Analytics](/azure/databricks/data/data-sources/azure/synapse-analytics)
- [On GitHub: azure-notificationhubs-dotnet/Samples/AzFunctions/
](https://github.com/Azure/azure-notificationhubs-dotnet/tree/main/Samples/AzFunctions)
- [Azure SQL Data Warehouse with DirectQuery](/power-bi/connect-data/service-azure-sql-data-warehouse-with-direct-connect)
- [Power Apps visual for Power BI](/powerapps/maker/canvas-apps/powerapps-custom-visual)

Information about the Delta Lake open-source project for building a Lakehouse architecture:

- [Delta Lake Key Features](https://delta.io)
- [What is Delta Lake](/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake)
- [Delta Lake and Delta Engine guide](/azure/databricks/delta)

## Related resources

See the following related database architectural guidance:

- [Azure Data Architecture Guide](../../data-guide/index.md)
- [Non-relational data and NoSQL](../../data-guide/big-data/non-relational-data.yml)
- [Big data architectures](../../data-guide/big-data/index.yml)
- [Batch processing](../../data-guide/big-data/batch-processing.yml)
- [Choosing a batch processing technology in Azure](../../data-guide/technology-choices/batch-processing.md)
- [Data lakes](../../data-guide/scenarios/data-lake.md)
- [Choosing a big data storage technology in Azure](../../data-guide/technology-choices/data-storage.md)
- [Modernize mainframe & midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
- [Master data management with Profisee and Azure Data Factory](../../reference-architectures/data/profisee-master-data-management-data-factory.yml)
- [Master Data Management powered by CluedIn](../../reference-architectures/data/cluedin.yml)
- [DataOps for the modern data warehouse](../../example-scenario/data-warehouse/dataops-mdw.yml)
- [Data warehousing and analytics](../../example-scenario/data/data-warehouse.yml)
- [Real Time Analytics on Big Data Architecture](./real-time-analytics.yml)

See the following related IoT architectural guidance:

- [IoT solutions conceptual overview](../../example-scenario/data/big-data-with-iot.yml)
- [Vision with Azure IoT Edge](../../guide/iot-edge-vision/index.md)
- [Azure Industrial IoT Analytics Guidance](../../guide/iiot-guidance/iiot-architecture.yml)
- [Azure IoT reference architecture](../../reference-architectures/iot.yml)
- [IoT and data analytics](../../example-scenario/data/big-data-with-iot.yml)