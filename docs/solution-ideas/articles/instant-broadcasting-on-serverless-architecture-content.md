[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a serverless solution that uses a one-to-many model for instant broadcasting. The solution simplifies real-time communication.

## Architecture

:::image type="content" source="../media/instant-broadcasting-on-serverless-architecture.png" alt-text="Architecture diagram that shows the flow of data among storage, apps, functions, and Azure SignalR Service in an instant broadcast system." border="false":::

*Download an [SVG](../media/instant-broadcasting-on-serverless-architecture.svg) of this architecture.*

### Dataflow

1. A client pulls web app content from Azure Blob Storage.
1. A web app receives a SignalR token and endpoint.
1. The user connects to the web app.
1. The connection triggers a database event via Azure Functions.
1. Serverless functions push data to Azure SignalR Service.
1. Azure SignalR Service pushes the data to the client.

### Components

- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) stores large amounts of unstructured data, such as text or binary data, that you can access from anywhere in the world via HTTP or HTTPS. You can use Blob Storage to expose data publicly to the world, or to store application data privately.
- [Azure App Service](https://azure.microsoft.com/services/app-service) provides a framework that you can use to build and host web apps, mobile back ends, and RESTful APIs without managing infrastructure.
- [Functions](https://azure.microsoft.com/services/functions) is a serverless compute option. It uses an event-driven model, where a piece of code called a *function* is invoked by a trigger.
- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service) provides asynchronous communication between a client and server. It supports any scenario that requires pushing data from server to client in real time.
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a fully managed relational database with built-in intelligence.

## Scenario details

For real-time broadcasting, the solution uses Azure SignalR Service. This service pushes content to clients as soon as it's available. As a managed service, Azure SignalR Service simplifies the process of adding real-time communication to apps.

The solution uses Functions for serverless computing. Functions manages Azure SignalR Service endpoints, triggers database events, and pushes data to Azure SignalR Service. The functions that handle these tasks run at scale in the cloud. They use triggers and bindings in an event-driven model.

### Potential use cases

Common applications of serverless architecture include:

- Event-triggered computing
- Elastic resizing for live video broadcast
- IoT data processing
- Shared delivery dispatch systems

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Yee Shian Lee](https://www.linkedin.com/in/yeeshian) | Senior Cloud Architect

## Next steps

- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Azure App Service Overview](/azure/app-service/app-service-web-overview)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [What is Azure SignalR Service?](/azure/azure-signalr/signalr-overview)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)

## Related resources

- [Real-time IoT updates](../../example-scenario/iot/real-time-iot-updates-cloud-apps.yml)
- [Share a location in real time by using low-cost serverless Azure services](../../example-scenario/signalr/index.yml)
- [Real-time presence with Microsoft 365, Azure, and Power Platform](./presence-microsoft-365-power-platform.yml)