


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

- [Application integration using Event Grid](/azure/architecture/solution-ideas/articles/application-integration-using-event-grid)
- [Ops automation using Event Grid](/azure/architecture/solution-ideas/articles/ops-automation-using-event-grid)
- [Event-based cloud automation](/azure/architecture/reference-architectures/serverless/cloud-automation)
- [Gridwich cloud media system](/azure/architecture/reference-architectures/media-services/gridwich-architecture)
