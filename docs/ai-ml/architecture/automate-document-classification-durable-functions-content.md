
This article describes an architecture for processing documents of various types. It uses the Durable Functions extension of Azure Functions to implement the pipelines that process the documents using Azure AI Document Intelligence.

## Architecture

:::image type="content" source="_images/automate-document-classification-durable-functions.png" alt-text="Diagram of the architecture for identifying, classifying, and searching documents."  lightbox="_images/automate-document-classification-durable-functions.png" border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/US-2015210-automate-document-classification-durable-functions.vsdx) of this architecture.*

### Workflow

1. The user provides a document file that the web app uploads. The file contains multiple embedded documents of various types. It can, for instance, be a PDF or multipage TIFF file.
   - a - The document file is stored in Azure Blob Storage.
   - b - The web app adds a command message to a storage queue to initiate pipeline processing.
1. Durable Functions orchestration is triggered by the command message. The message contains metadata that identifies the location in Blob Storage of the document file to be processed. Each Durable Functions instance processes only one document file.
1. The _analyze_ activity function calls the Document Intelligence Analyze Document API, passing in the location in storage of the document file to be processed. Analysis will read and identify each known document contained within the document file. The name, type, page ranges, and content of each embedded document is returned to the orchestration.
1. The _metadata store_ activity function saves the document type, location, and page range information for each identified document in an Azure Cosmos DB store.
1. The _indexing_ activity function creates a new search document in the Azure AI Search service for each identified document and uses the [Azure AI Search libraries for .NET](/dotnet/api/overview/azure/search?view=azure-dotnet) to include in the search document the full OCR results and document information. A correlation ID is also added to the search document so that the search results can be matched with the corresponding document metadata from Azure Cosmos DB.
1. End users can search for documents by contents and metadata. Correlation IDs in the search result set can be used to look up document records that are in Azure Cosmos DB. The records include links to the original document file in Blob Storage.

### Components

- [Durable Functions](/azure/azure-functions/durable/durable-functions-overview) is an extension of [Azure Functions](https://azure.microsoft.com/products/functions) that makes it possible for you write stateful functions in a serverless compute environment. In this application, it's used for managing document ingestion and workflow orchestration. It lets you define stateful workflows by writing orchestrator functions that adhere to the Azure Functions programming model. Behind the scenes, the extension manages state, checkpoints, and restarts, leaving you free to focus on the business logic.
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is a globally distributed, multi-model database that makes it possible for your solutions to scale throughput and storage capacity across any number of geographic regions. Comprehensive service-level agreements (SLAs) guarantee throughput, latency, availability, and consistency.
- [Azure Storage](https://azure.microsoft.com/products/category/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Blob Storage](https://azure.microsoft.com/products/storage/blobs), [Azure Files](https://azure.microsoft.com/products/storage/files), [Azure Table Storage](https://azure.microsoft.com/products/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/products/storage/queues).
- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) provides a framework for building, deploying, and scaling web apps. The Web Apps feature is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. With Web Apps, you can develop in .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. Applications easily run and scale in Windows and Linux-based environments.
- [Azure AI services](https://azure.microsoft.com/en-us/products/ai-services/) provides intelligent algorithms to see, hear, speak, understand, and interpret your user needs by using natural methods of communication.
- [Azure AI Document Intelligence](https://azure.microsoft.com/services/cognitive-services/document-intelligence) is a set of services that enable you to extract insights from your documents, forms, and images.
- [Azure AI Search](https://azure.microsoft.com/products/search) provides a rich search experience over private, heterogeneous content in web, mobile, and enterprise applications.

### Alternatives

- This solution stores metadata in Azure Cosmos DB to facilitate global distribution. [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is another option for persistent storage of document metadata and information.
- You can use other messaging platforms, including [Azure Service Bus](https://azure.microsoft.com/products/service-bus), to trigger Durable Functions instances.

### Scenario details

The pipelines identify the documents in a document file, classify them by type, and store information that can be used in subsequent processing.

Many companies need to manage and process documents that have been scanned in bulk and that can contain several different document types. Typically, the documents are PDFs or multi-page TIFF images. These documents might originate from outside the organization, and the receiving company doesn't control the format.

Given these constraints, organizations have been forced to build their own document parsing solutions that can include custom technology and manual processes. A solution can include human intervention for splitting out individual document types and adding classifications qualifiers for each document.

Many of these custom solutions are based on the state machine workflow pattern and use database systems for persisting workflow state, with polling services that check for the states that they're responsible for processing. Maintaining and enhancing such solutions can be difficult and time consuming.

Organizations are looking for reliable, scalable, and resilient solutions for processing and managing document identification and classification for the types of documents their organization uses. This includes processing millions of documents per day with full observability into the success or failure of the processing pipeline.

### Potential use cases

This solution applies to many areas:

- **Title reporting.** Many government agencies and municipalities manage paper records that haven't been migrated to digital form. An effective automated solution can generate a file that contains all the documents that are required to satisfy a document request.
- **Maintenance records.** Aircraft, locomotive, and machinery maintenance records still exist in paper form that require scanning and sending to outside organizations.
- **Permit processing.** City and county permitting departments still maintain paper documents that are generated for permit inspection reporting. The ability to take a picture of several inspection documents and automatically identify, classify, and search across these records can be highly beneficial.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

A reliable workload is one that's both resilient and available. Resiliency is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. Availability is a measure of whether your users can access your workload when they need to.

For reliability information about solution components, see the following resources:

- [SLA Information for Azure Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1)

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The most significant costs for this architecture will potentially come from the storage of images in the storage account, Azure AI services image processing, and index capacity requirements in the Azure AI Search service.

Costs can be optimized by [right sizing](/azure/well-architected/service-guides/storage-accounts/cost-optimization) the storage account by using reserved capacity and lifecycle policies, proper [Azure AI Search planning](/azure/search/search-sku-manage-costs) for regional deployments and operational scale up scheduling, and using [commitment tier pricing](/azure/ai-services/commitment-tier) that's available for the Document Intelligence service to manage [predictable costs](/azure/ai-studio/how-to/costs-plan-manage).

Here are some guidelines for optimizing costs:

- Use the pay-as-you-go strategy for your architecture and [scale out](/azure/well-architected/cost-optimization/optimize-scaling-costs) as needed rather than investing in large-scale resources at the start.
- Consider opportunity costs in your architecture, and the balance between first-mover advantage versus fast follow. Use the [pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the initial cost and operational costs.
- Establish [budgets, and controls](/azure/well-architected/cost-optimization/collect-review-cost-data) that set cost limits for your solution, and utilize [budget alerting](/azure/cost-management-billing/costs/tutorial-acm-create-budgets?tabs=psbudget) to set up forecasting and actual cost alerts.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Periods when this solution processes high volumes can expose performance bottlenecks. Make sure that you understand and plan for the [scaling options for Azure Functions](/azure/azure-functions/functions-scale#scale), [Azure AI services autoscaling](/azure/ai-services/autoscale?tabs=portal), and [Azure Cosmos DB partitioning](/azure/cosmos-db/partitioning-overview) to ensure proper performance efficiency for your solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kevin Kraus](https://www.linkedin.com/in/kevin-w-kraus) | Principal Azure Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Introductory articles:

- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What are Durable Functions?](/azure/azure-functions/durable/durable-functions-overview)
- [What are Azure AI services?](/azure/ai-services/what-are-ai-services)
- [What is Document Intelligence?](/azure/ai-services/document-intelligence/overview)
- [What's Azure AI Search?](/azure/search/search-what-is-azure-search)
- [App Service overview](/azure/app-service/overview)
- [Introduction to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [What is Azure Service Bus?](/azure/service-bus-messaging/service-bus-messaging-overview)

Product documentation:

- [Azure documentation (all products)](/azure?product=all)
- [Durable Functions documentation](/azure/azure-functions/durable)
- [Azure AI services documentation](/azure/ai-services)
- [Azure AI Search documentation](/azure/search)

## Related resources

- [Custom document processing models on Azure](../../example-scenario/document-processing/build-deploy-custom-models.yml)
- [Automate document processing by using AI Document Intelligence](../../example-scenario/ai/automate-document-processing-azure-form-recognizer.yml)
- [Image classification on Azure](/azure/architecture/ai-ml/idea/intelligent-apps-image-processing)
