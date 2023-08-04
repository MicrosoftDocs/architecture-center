[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This example demonstrates how you can deploy portals that automate manual or paper-based processes and surface a rich user experience. Employ Azure API management and Azure Functions to connect custom APIs, which tap into your legacy systems. By using Azure-managed databases and a low-code approach to automating tasks, you can lower the overall solution costs while quickly building apps that are real-time, resilient, and scalable by default.

## Architecture

:::image type="content" border="false" source="../media/custom-business-processes-2.svg" alt-text="Diagram that shows dataflow in airline system with Azure components." lightbox="../media/custom-business-processes.png":::

*Download a [Visio file](https://arch-center.azureedge.net/custom-business-processes-2.vsdx) of this architecture.*

### Dataflow

The data flows through the solution as follows:

1. The airline system communicates with a custom API hosted in [Azure API Management](/azure/api-management).
1. A custom API coordinator receives notifications and handles incoming messages from the airline system. It sends them to [Power Apps](/power-apps), where flights are assigned to Microsoft Teams channels.
1. When a user selects a flight to monitor, or when the system assigns the user to a flight, the system queues a Graph API call in an Azure Storage Account queue for further processing.
1. [Azure Functions](/azure/azure-functions) runs the Graph API calls based on the incoming messages in the storage queue, sending notifications to Teams, and also streams all events to an [Azure Event Hubs](/azure/event-hubs/) for further analytics.
1. The airline's notification system is managed by a custom bot messaging service that employs [Azure Bot Service](/azure/bot-service).
1. Custom bots send flight updates to users in Teams.
1. An [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction) storage offers long-term retention and micro-batch processing of events from Event Hubs, ultimately generating insightful reports with Power BI.

### Components

Data is loaded from these different data sources using several Azure components:

- [Power Apps](https://powerapps.microsoft.com): Increase agility across your organization by rapidly building low-code apps that modernize processes and solve tough challenges.
- [Azure Functions](https://azure.microsoft.com/services/functions): Accelerate and simplify application development with serverless compute
- [Azure API management](https://azure.microsoft.com/services/api-management): Hybrid, multicloud management platform for APIs across all environments
- [Azure SQL Database](https://azure.microsoft.com//services/sql-database): Build apps that scale with the pace of your business with managed and intelligent SQL in the cloud
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db): Fast NoSQL database with open APIs for any scale
- [Azure Storage](https://azure.microsoft.com/product-categories/storage): Massively scalable, secure cloud storage for your data, apps, and workloads
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs): Simple, secure, and scalable real-time data ingestion
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage): Massively scalable and secure data lake for your high-performance analytics workloads
- [Azure Bot Service](https://azure.microsoft.com/services/bot-service): A managed service purpose-built for bot development
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory): Hybrid data integration service that simplifies ETL at scale
- [Power Automate](https://flow.microsoft.com): Streamline repetitive tasks and paperless processes
- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools to analyze data and share insights.

## Scenario details

### Potential use cases

The use of digital workflows isn't limited to any one industry. Document-based digital workflows use the same components but arrange them differently to meet the requirements of a process. Examples of industries that can benefit from automated processes include, but are not limited to:

- Manufacturing
- Healthcare
- Education
- Finance
- Law firms
- Airlines (aerospace)

## Next steps

- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [About Azure API Management](/azure/api-management/api-management-key-concepts)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [What is Azure Event Hubs?](/azure/event-hubs/event-hubs-about)
- [Introduction to Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure Bot Service](/azure/bot-service)
- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [Introduction to Power Apps](/training/modules/introduction-power-apps)

## Related resources

- [Design great API developer experiences using API Management and GitHub](../../example-scenario/web/design-api-developer-experiences-management-github.yml)