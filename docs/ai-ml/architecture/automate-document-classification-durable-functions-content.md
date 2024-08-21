
This article describes an architecture that you can use to process various documents. The architecture uses the durable functions feature of Azure Functions to implement pipelines. The pipelines process documents via Azure AI Document Intelligence.

## Architecture

:::image type="content" source="_images/automate-document-classification-durable-functions.svg" alt-text="Diagram that shows an architecture to identify, classify, and search documents."  lightbox="_images/automate-document-classification-durable-functions.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/automate-document-classification-durable-functions.vsdx) of this architecture.*

### Workflow

1. A user uploads a document file to a web app. The file contains multiple embedded documents of various types, such as PDF or multipage Tag Image File Format (TIFF) files. The document file is stored in Azure Blob Storage (**1a**). To initiate pipeline processing, the web app adds a command message to a storage queue (**1b**).

1. The command message triggers the durable functions orchestration. The message contains metadata that identifies the Blob Storage location of the document file to be processed. Each durable functions instance processes only one document file.
1. The _analyze_ activity function calls the Document Intelligence Analyze Document API, which passes the storage location of the document file to be processed. The analyze function reads and identifies each document within the document file. This function returns the name, type, page ranges, and content of each embedded document to the orchestration.
1. The _metadata store_ activity function saves the document type, location, and page range information for each document in an Azure Cosmos DB store.
1. The _indexing_ activity function creates a new search document in Azure AI Search for each document. In the search document, this function uses the [AI Search libraries for .NET](/dotnet/api/overview/azure/search) to include the full optical character recognition (OCR) results and document information. A correlation ID is also added to the search document so that the search results can be matched with the corresponding document metadata from Azure Cosmos DB.
1. Users can search for documents by using contents and metadata. To look up document records that are in Azure Cosmos DB, they can use correlation IDs in the search result set. The records include links to the original document file in Blob Storage.

### Components

- [Durable functions](/azure/azure-functions/durable/durable-functions-overview) is a feature of [Azure Functions](https://azure.microsoft.com/products/functions/) that you can use to write stateful functions in a serverless compute environment. In this architecture, a message in a storage queue triggers a durable functions instance, which initiates and orchestrates the document-processing pipeline.

- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db/) is a globally distributed, multi-model database that you can use in your solutions to scale throughput and storage capacity across any number of geographic regions. Comprehensive service-level agreements (SLAs) guarantee throughput, latency, availability, and consistency. This architecture uses Azure Cosmos DB as the metadata store for the document classification information.
- [Azure Storage](https://azure.microsoft.com/products/category/storage/) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Blob Storage](https://azure.microsoft.com/products/storage/blobs/), [Azure Files](https://azure.microsoft.com/products/storage/files/), [Azure Table Storage](https://azure.microsoft.com/products/storage/tables/), and [Azure Queue Storage](https://azure.microsoft.com/products/storage/queues/). This architecture uses Blob Storage to store the document files that the user uploads and that the durable functions pipeline processes.
- [Azure App Service](https://azure.microsoft.com/products/app-service/) provides a framework to build, deploy, and scale web apps. The Web Apps feature of App Service is an HTTP-based tool that you can use to host web applications, REST APIs, and mobile back ends. Use Web Apps to develop in .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. Applications can easily run and scale in Windows and Linux-based environments. In this architecture, users interact with the document-processing system through an App Service-hosted web app.
- [AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence) is a service that you can use to extract insights from your documents, forms, and images. This architecture uses AI Document Intelligence to analyze the document files and extract the embedded documents along with content and metadata information.
- [AI Search](https://azure.microsoft.com/products/ai-services/ai-search/) provides a rich search experience for private, diverse content in web, mobile, and enterprise applications. This architecture uses AI Search to index the extracted document content and metadata information so that users can search and retrieve documents.

### Alternatives

- To facilitate global distribution, this solution stores metadata in Azure Cosmos DB. [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is another persistent storage option for document metadata and information.

- To trigger durable functions instances, you can use other messaging platforms, including [Azure Service Bus](https://azure.microsoft.com/products/service-bus).

### Scenario details

In this architecture, the pipelines identify the documents in a document file, classify them by type, and store information to use in subsequent processing.

Many companies need to manage and process documents that they scan in bulk and that contain several different document types, such as PDFs or multi-page TIFF images. These documents might originate from outside the organization, and the receiving company doesn't control the format.

Given these constraints, organizations must build their own document-parsing solutions that can include custom technology and manual processes. For example, someone might manually separate individual document types and add classification qualifiers for each document.

Many of these custom solutions are based on the state machine workflow pattern. The solutions use database systems to persist workflow state and use polling services that check for the states that they need to process. Maintaining and enhancing these solutions can increase complexity and effort.

Organizations need reliable, scalable, and resilient solutions to process and manage document identification and classification for their organization's document types. This solution can process millions of documents each day with full observability into the success or failure of the processing pipeline.

### Potential use cases

You can use this solution to:

- **Report titles.** Many government agencies and municipalities manage paper records that don't have a digital form. An effective automated solution can generate a file that contains all the documents that you need to satisfy a document request.

- **Manage maintenance records.** You might need to scan and send paper records, such as aircraft, locomotive, and machinery maintenance records, to outside organizations.
- **Process permits.** City and county permitting departments maintain paper documents that they generate for permit inspection reporting. You can take a picture of several inspection documents and automatically identify, classify, and search across these records.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

A reliable workload has both resiliency and availability. Resiliency is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. Availability measures whether your users can access your workload when they need to.

For reliability information about solution components, see [SLA information for Azure online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The most significant costs for this architecture include storing images in the storage account, processing the Azure AI services image, and index capacity requirements in AI Search.

To optimize costs:

- Use reserved capacity and lifecycle policies to [rightsize storage accounts](/azure/well-architected/service-guides/storage-accounts/cost-optimization).

- Plan for [regional deployments and operational scale-up scheduling](/azure/search/search-sku-manage-costs) in AI Search.

- Use [commitment tier pricing](/azure/ai-services/commitment-tier) for AI Document Intelligence to manage [predictable costs](/azure/ai-studio/how-to/costs-plan-manage).

- Use the pay-as-you-go strategy for your architecture and [scale out](/azure/well-architected/cost-optimization/optimize-scaling-costs) as needed rather than investing in large-scale resources at the start.

- Consider opportunity costs in your architecture and balance a first-mover advantage strategy versus a fast-follow strategy. To estimate the initial cost and operational costs, use the [pricing calculator](https://azure.microsoft.com/pricing/calculator).
- Establish [budgets and controls](/azure/well-architected/cost-optimization/collect-review-cost-data) that set cost limits for your solution. To set up forecasting and actual cost alerts, use [budget alerting](/azure/cost-management-billing/costs/tutorial-acm-create-budgets).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This solution can expose performance bottlenecks when you processes high volumes of data. To ensure proper performance efficiency for your solution, make sure that you understand and plan for [Azure Functions scaling options](/azure/azure-functions/functions-scale#scale), [Azure AI services autoscaling](/azure/ai-services/autoscale), and [Azure Cosmos DB partitioning](/azure/cosmos-db/partitioning-overview).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Kevin Kraus](https://www.linkedin.com/in/kevin-w-kraus) | Principal Azure Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Introductory articles:

- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What are durable functions?](/azure/azure-functions/durable/durable-functions-overview)
- [What is Azure AI services?](/azure/ai-services/what-are-ai-services)
- [What is AI Document Intelligence?](/azure/ai-services/document-intelligence/overview)
- [What's AI Search?](/azure/search/search-what-is-azure-search)
- [App Service overview](/azure/app-service/overview)
- [Introduction to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [What is Azure Service Bus?](/azure/service-bus-messaging/service-bus-messaging-overview)

Product documentation:

- [Azure documentation for all products](/azure?product=all)
- [Durable functions documentation](/azure/azure-functions/durable)
- [Azure AI services documentation](/azure/ai-services)
- [AI Search documentation](/azure/search)

## Related resources

- [Custom document processing models on Azure](../../example-scenario/document-processing/build-deploy-custom-models.yml)
- [Automate document processing by using AI Document Intelligence](../../example-scenario/ai/automate-document-processing-azure-form-recognizer.yml)
- [Image classification on Azure](../../ai-ml/idea/intelligent-apps-image-processing.yml)
