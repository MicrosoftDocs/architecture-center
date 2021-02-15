


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Event Grid connects your app with other services. For example, create an application topic to send your app's event data to Event Grid and take advantage of its reliable delivery, advanced routing, and direct integration with Azure. Alternatively, you can use Event Grid with Logic Apps to process data anywhere, without writing code.

## Architecture

![Architecture Diagram](../media/application-integration-using-event-grid.png)
*Download an [SVG](../media/application-integration-using-event-grid.svg) of this architecture.*

## Data Flow

1. Bring together all your structured, unstructured and semi-structured data (logs, files, and media) using Azure Data Factory to Azure Data Lake Storage.
1. Use Azure Databricks to clean and transform the structureless datasets and combine them with structured data from operational databases or data warehouses.
1. Use scalable machine learning/deep learning techniques, to derive deeper insights from this data using Python, R or Scala, with inbuilt notebook experiences in Azure Databricks.
1. Leverage native connectors between Azure Databricks and Azure Synapse Analytics to access and move data at scale.
1. Power users take advantage of the inbuilt capabilities of Azure Databricks to perform root cause determination and raw data analysis.
1. Query and report on data in [Power BI](/azure/analysis-services/analysis-services-connect-pbi).
1. Take the insights from Azure Databricks to Cosmos DB to make them accessible through web and mobile apps.

## Components

* [Azure Event Grid](https://azure.microsoft.com/services/event-grid/) get reliable event delivery at massive scale.
* [Azure Blob storage](https://azure.microsoft.com/services/storage/blobs) is a Massively scalable object storage for any type of unstructured data-images, videos, audio, documents, and more-easily and cost-effectively.
* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service): Simplify the deployment, management, and operations of Kubernetes
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
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Cache for Redis documentation](/azure/azure-cache-for-redis/)
* [Azure App Configuration](/azure/azure-app-configuration/)
* [Azure Event Hubs documentation](/azure/event-hubs)
* [Azure Key Vault documentation](/azure/key-vault/)
* [Azure Functions documentation](/azure/azure-functions)
* [Azure Logic Apps documentation](/azure/logic-apps/)
* [Power Automate documentation](/power-automate/)

## Pricing Calculator

* [Customize and get pricing estimates](https://azure.com/e/e146fd5535974f1dae5e32a06efb424d)