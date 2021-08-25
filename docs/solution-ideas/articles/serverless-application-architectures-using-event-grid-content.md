[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Event Grid connects data sources and event handlers. For example, using Event Grid instantly triggers a serverless function to run image analysis whenever someone adds a new photo to a blob storage container.

## Architecture

![Architecture Diagram](../media/serverless-application-architectures-using-event-grid.png)
*Download an [SVG](../media/serverless-application-architectures-using-event-grid.svg) of this architecture.*

## Components

- [Azure Event Grid](https://azure.microsoft.com/services/event-grid/)
- [Azure Functions](https://azure.microsoft.com/services/functions/)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/)

## Next steps

Learn more about the component technologies:

- [What is Azure Event Grid?](/azure/event-grid/overview)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [Introduction to Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)

Explore related architectures:

- [Application integration using Event Grid](./application-integration-using-event-grid.yml)
- [Ops automation using Event Grid](./ops-automation-using-event-grid.yml)
- [Event-based cloud automation](../../reference-architectures/serverless/cloud-automation.yml)
- [Gridwich cloud media system](../../reference-architectures/media-services/gridwich-architecture.yml)