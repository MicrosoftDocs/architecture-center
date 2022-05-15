[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Simplify one-to-many real-time communication and updates using serverless code.

## Architecture

![Architecture Diagram](../media/instant-broadcasting-on-serverless-architecture.png)
*Download an [SVG](../media/instant-broadcasting-on-serverless-architecture.svg) of this architecture.*

### Data flow

1. The client pulls web app content from Azure Blob storage.
1. The web app receives a SignalR token and endpoint.
1. The user connects to the web app.
1. The connection triggers a database event via Azure Functions
1. Functions pushes data to Azure SignalR Service.
1. In turn, SignalR Service pushes the data to the client.

### Components

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs): Stores large amounts of unstructured data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. You can use Blob storage to expose data publicly to the world, or to store application data privately.
- [Azure App Service](https://azure.microsoft.com/services/app-service): Build and host web apps, mobile back ends, and RESTful APIs without managing infrastructure.
- [Azure Functions](https://azure.microsoft.com/services/functions) is a serverless compute option. It uses an event-driven model, where a piece of code (a *function*) is invoked by a trigger.
- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service) provides asynchronous communication between the client and the server. It supports any scenario that requires pushing data from server to client in real time.
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a fully managed relational database with built-in intelligence.

## Next steps

- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Azure App Service Overview](/azure/app-service/app-service-web-overview)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [What is Azure SignalR Service?](/azure/azure-signalr/signalr-overview)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
