[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea shows how to publish events in Azure blob storage using Event Grid, then use the build-in support in Azure Functions to process the event.  By using it, developers only need to focus on implementing the business logic in Azure Functions, and Event Grid will provide a reliable near-real-time notifications system for the event integration. 

The core design concept is using Event Grid to connect data sources and event handlers. For example, using Event Grid instantly triggers a serverless function to run image process (e.g., shrink image) whenever someone adds a new photo to a blob storage container.


## Architecture

![Architecture Diagram](../media/serverless-application-architectures-using-event-grid.png)
*Download an [SVG](../media/serverless-application-architectures-using-event-grid.svg) of this architecture.*

1. A user uploads a photo to a blob storage container.
2. Blob storage publishes storage object events to Event Grid.
3. Event Grid triggers an Azure Function based  the event criteria the Function subscribed.  
4. The function retrieves the photo and runs the image process (e.g., shrink image) on it.



### Components

- [Azure Event Grid](https://azure.microsoft.com/services/event-grid/)
- [Azure Functions](https://azure.microsoft.com/services/functions/)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/)

## Next steps

Learn more about the component technologies:

- [What is Azure Event Grid?](/azure/event-grid/overview)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [Introduction to Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)

## Related resources

Explore related architectures:

- [Application integration using Event Grid](./application-integration-using-event-grid.yml)
- [Ops automation using Event Grid](./ops-automation-using-event-grid.yml)
- [Event-based cloud automation](../../reference-architectures/serverless/cloud-automation.yml)
- [Gridwich cloud media system](../../reference-architectures/media-services/gridwich-architecture.yml)
