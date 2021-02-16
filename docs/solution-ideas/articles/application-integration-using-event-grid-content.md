


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Event Grid connects your app with other services. For example, create an application topic to send your app's event data to Event Grid and take advantage of its reliable delivery, advanced routing, and direct integration with Azure. Alternatively, you can use Event Grid with Logic Apps to process data anywhere, without writing code.

## Architecture

![Architecture Diagram](../media/application-integration-using-event-grid.png)
*Download an [SVG](../media/application-integration-using-event-grid.svg) of this architecture.*

## Data Flow

1. Configure different event sources (Blob Storage, Azure Cache for Redis, App Configuration, Event Hubs, Key Vault, Service Bus) subscribe to event grid topic.
1. Triggers event sources from various scenarios including different actions perform on the event sources.  
1. Use Azure Event Grid to support for the events coming from different Azure services.
1. Leverages different event handlers (Azure Functions, Event Hubs, Logic Apps, Blob Storage, Web Hook, Power Automate) to handle different use cases.
1. Use different types of actions to handle the result of the event handlers like blob storage and email for alert.

## Components

* [Azure Event Grid](https://azure.microsoft.com/services/event-grid/) get reliable event delivery at massive scale.
* [Azure Blob storage](https://azure.microsoft.com/services/storage/blobs) is a Massively scalable object storage for any type of unstructured data-images, videos, audio, documents, and more-easily and cost-effectively.
* [Azure Cache for Redis](https://azure.microsoft.com/services/cache/): A fully managed, open source–compatible in-memory data store to power fast, scalable applications.
* [Azure App Configuration](https://azure.microsoft.com/services/app-configuration/) store configuration for all your Azure apps in a universal, hosted location.
* [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) stream millions of events per second from any source to build dynamic data pipelines and immediately respond to business challenges.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault/): Safeguard cryptographic keys and other secrets used by cloud apps and services.
* [Azure Functions](https://azure.microsoft.com/services/functions/): An event-driven serverless compute platform that can also solve complex orchestration problems.
* [Azure Logic Apps](https://azure.microsoft.com/services/service-bus/) Quickly build powerful integration solutions.
* [Web Hook](https://docs.microsoft.com/azure/event-grid/handler-webhooks) for handling events.
* [Power Automate](https://flows.microsoft.com/) Easily create automated workflows.
* [Email](https://docs.microsoft.com/azure/connectors/connectors-create-api-office365-outlook) Create automated task and workflows with Azure Logic Apps and O365 Outlook Connector to send an email.

## Next steps

* [Azure Event Grid documentation](/azure/event-grid)
* [Azure Blob Storage documentation](/azure/storage/blobs/)
* [Azure Cache for Redis documentation](/azure/azure-cache-for-redis/)
* [Azure App Configuration](/azure/azure-app-configuration/)
* [Azure Event Hubs documentation](/azure/event-hubs)
* [Azure Key Vault documentation](/azure/key-vault/)
* [Azure Functions documentation](/azure/azure-functions)
* [Azure Logic Apps documentation](/azure/logic-apps/)
* [Power Automate documentation](/power-automate/)

## Pricing Calculator

* [Customize and get pricing estimates](https://azure.com/e/e146fd5535974f1dae5e32a06efb424d)