[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This example demonstrates how you can deploy portals that automate manual or paper-based processes and surface rich user experience. Leverage Azure API management and Azure Functions to connect custom APIs which tap into your legacy systems. Using Azure managed databases and low-code approach to automate tasks, you can lower the overall solution costs while easily building apps that are real-time, resilient, and scalable by default.

## Architecture

![Architecture Diagram](../media/custom-business-processes.png)

### Dataflow

The data flows through the solution as follows:

1. The airline system assigns flights to Teams channel which are also displayed in [Power Apps](/power-apps/).
2. Custom API Coordinator hosted in [Azure API Management](/azure/api-management) receives notifications and handles incoming messages from the airline system.
3. When a user selects a flight to monitor or the system assigns the user to a flight, Graph API call is queued for coordinator to process.
4. [Azure Functions](/azure/azure-functions) run the Graph API calls which are processed in [Azure Storage](/azure/storage/).
5. Notifications from airline system are managed by a custom bot messaging service that leverages [Azure Bot Service](/azure/bot-service).
6. Custom bots sends flight updates to users in Teams.
7. Power BI generates reports from the [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction), based on Teams activity.

### Components

Data is loaded from these different data sources using several Azure components:

- [Power Apps](https://powerapps.microsoft.com/): Increase agility across your organization by rapidly building low-code apps that modernize processes and solve tough challenges.
- [Azure Functions](https://azure.microsoft.com/services/functions/): Accelerate and simplify application development with serverless compute
- [Azure API management](https://azure.microsoft.com/services/api-management/): Hybrid, multi-cloud management platform for APIs across all environments
- [Azure SQL Database](https://azure.microsoft.com//services/sql-database/): Build apps that scale with the pace of your business with managed and intelligent SQL in the cloud
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/): Fast NoSQL database with open APIs for any scale
- [Azure Storage](https://azure.microsoft.com/product-categories/storage/): Massively scalable, secure cloud storage for your data, apps, and workloads
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/): Simple, secure, and scalable real-time data ingestion
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/): Massively scalable and secure data lake for your high-performance analytics workloads
- [Azure Bot Service](https://azure.microsoft.com/services/bot-service/): A managed service purpose-built for bot development
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/): Hybrid data integration service that simplifies ETL at scale
- [Power Automate](https://flow.microsoft.com/): Streamline repetitive tasks and paperless processes
- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools to analyze data and share insights.

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
- [Introduction to Power Apps](/learn/modules/introduction-power-apps/)

## Related resources

- [Design great API developer experiences using API Management and GitHub](../../example-scenario/web/design-api-developer-experiences-management-github.yml)
- [API-first SaaS business model](./aks-api-first.yml)
- [Modern customer support portal](./modern-customer-support-portal-powered-by-an-agile-business-process.yml)
