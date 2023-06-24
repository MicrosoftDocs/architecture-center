
This article describes an architecture for processing document files that contain multiple documents of various types. It uses the Durable Functions extension of Azure Functions to implement the pipelines that process the files.

## Architecture

:::image type="content" source="media/automate-document-classification-durable-functions.png" alt-text="Diagram of the architecture for identifying, classifying, and searching documents."  lightbox="media/automate-document-classification-durable-functions.png" border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/US-2015210-automate-document-classification-durable-functions.vsdx) of this architecture.*

### Workflow

1. The user provides a document file that the web app uploads. The file contains multiple documents of various types. It can, for instance, be a PDF or multipage TIFF file.
   1. The document file is stored in Azure Blob Storage.
   1. The web app adds a command message to a storage queue to initiate pipeline processing.
1. Durable Functions orchestration is triggered by the command message. The message contains metadata identifying the location of the document file in Blob Storage to be processed. Each Durable Functions instance processes only one document file.
1. The Scan activity function calls the Computer Vision Read API, passing in the location in storage of the document to be processed. Optical character recognition (OCR) results are returned to the orchestration to be used by subsequent activities.
1. The Classify activity function calls the document classifier service hosted in an Azure Kubernetes Service (AKS) cluster. This service uses regular expression pattern matching to identify each known document's starting page and calculate how many document types are contained in the document file. The types and page ranges of the documents are calculated and returned to the orchestration.

   > [!NOTE]
   > Azure doesn’t offer a service that can classify multiple document types in a single file. This solution uses a non-Azure service that's hosted in AKS.

1. The Metadata Store activity function saves the document type and page range information in an Azure Cosmos DB store.
1. The Indexing activity function creates a new search document for each identified document type in the Cognitive Search service. It uses the [Azure Cognitive Search libraries for .NET](/dotnet/api/overview/azure/search?view=azure-dotnet) to include the full OCR results and document information in the search document. A correlation ID is also added to the search document to match the search results with the corresponding document metadata from Azure Cosmos DB.
1. End users can search for documents by content and metadata. Correlation IDs in the search result set can be used to look up document records in Azure Cosmos DB. The records include links to the original document file in Blob Storage.

### Components

- [Durable Functions](/azure/azure-functions/durable/durable-functions-overview?tabs=csharp) is an extension of [Azure Functions](https://azure.microsoft.com/products/functions) that makes it possible for you to write stateful functions in a serverless compute environment. This application it's used for managing document ingestion and workflow orchestration. It lets you define stateful workflows by writing orchestrator functions that adhere to the Azure Functions programming model. Behind the scenes, the extension manages state, checkpoints, and restarts, leaving you free to focus on the business logic.
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is a globally distributed, multi-model database that allows your solutions to scale throughput and storage capacity across any number of geographic regions. Comprehensive service level agreements (SLAs) guarantee throughput, latency, availability, and consistency.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a massively scalable and secure cloud service for data, apps, and workloads. It includes [Blob Storage](https://azure.microsoft.com/products/storage/blobs), [Azure Files](https://azure.microsoft.com/products/storage/files), [Azure Table Storage](https://azure.microsoft.com/products/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/products/storage/queues).
- [Azure App Service](https://azure.microsoft.com/products/app-service) provides a framework for building, deploying, and scaling web apps. The Web Apps feature is an HTTP-based service hosting web applications, REST APIs, and mobile backends. With Web Apps, you can develop in .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. Applications efficiently run and scale in Windows and Linux-based environments.
- [Azure Cognitive Services](https://azure.microsoft.com/products/cognitive-services) provides intelligent algorithms to see, hear, speak, understand, and interpret your user needs using natural communication methods.
- [Azure Cognitive Search](https://azure.microsoft.com/products/search) provides a rich search experience over private, heterogeneous content in web, mobile, and enterprise applications.
- [AKS](https://azure.microsoft.com/products/kubernetes-service) is a highly available, secure, and fully managed Kubernetes service. AKS makes it easy to deploy and manage containerized applications.

### Alternatives

- The [Form Recognizer read (OCR) model](/azure/applied-ai-services/form-recognizer/concept-read?view=form-recog-3.0.0) is an alternative to Computer Vision Read.
- This solution stores metadata in Azure Cosmos DB to facilitate global distribution. [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is another option for persistent storage of document metadata and information.
- To trigger Durable Functions instances, you can use other messaging platforms, including [Azure Service Bus](https://azure.microsoft.com/products/service-bus).
- For a solution accelerator that helps in clustering and segregating data into templates, see [Azure/form-recognizer-accelerator (github.com)](https://github.com/Azure/form-recognizer-accelerator).

### Scenario details

This article describes an architecture that uses Durable Functions to implement automated pipelines for processing document files that contain multiple documents of various types. The pipelines identify the documents in a document file, classify them by type, and store information that can be used in subsequent processing.

Many companies need to manage and process document files containing documents scanned in bulk, which can contain several different document types. Typically the document files are PDFs or multi-page TIFF images. These files usually originate from outside the organization, and the receiving company doesn't control the content.

Given these constraints, organizations have been forced to build document-parsing solutions that can include custom technology and manual processes. A solution can include human intervention for splitting individual document types into their files and adding classification qualifiers for each document.

Many of these custom solutions are based on the state machine workflow pattern and use database systems for persisting workflow state, with polling services that check for the states that they're responsible for the processing. Maintaining and enhancing such solutions can be difficult and time-consuming.

Organizations are looking for reliable, scalable, and resilient solutions for processing and managing document identification and classification for the types of files their organization uses. This includes processing millions of documents per day with full observability of the success or failure of the processing pipeline.

### Potential use cases

This solution applies to many areas:

- **Title reporting.** Many government agencies and municipalities manage paper records that haven't been migrated to digital form. An effective automated solution can generate a file containing all the documents required to satisfy a document request.
- **Maintenance records.** Aircraft, locomotive, and machinery maintenance records still exist in paper form that requires scanning and sending to outside organizations.
- **Permit processing.** City and county permitting departments maintain paper documents generated for permit inspection reporting. The ability to take a picture of several inspection documents and automatically identify, classify, and search across these records can be highly beneficial.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework)

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

A reliable workload is both resilient and available. Resiliency is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after failure. Availability measures whether your users can access your workload when they need to.

For reliability information about solution components, see the following resources:

- [SLA for Azure Cognitive Search](https://azure.microsoft.com/support/legal/sla/search/v1_0)
- [SLA for Azure Applied AI Services](https://azure.microsoft.com/support/legal/sla/azure-applied-ai-services/v1_0)
- [SLA for Azure Functions](https://azure.microsoft.com/support/legal/sla/functions/v1_2)
- [SLA for App Service](https://azure.microsoft.com/support/legal/sla/app-service/v1_5)
- [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5)
- [SLA for Azure Kubernetes Service (AKS)](https://azure.microsoft.com/support/legal/sla/kubernetes-service/v1_1)
- [SLA for Azure Cosmos DB](https://azure.microsoft.com/support/legal/sla/cosmos-db/v1_5)

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The highest costs for this architecture will potentially come from the storage of image files in the storage account, Cognitive Services image processing, and index capacity requirements in the Azure Cognitive Search service.

Costs can be optimized by [right sizing](/azure/architecture/framework/services/storage/storage-accounts/cost-optimization) the storage account by using reserved capacity and lifecycle policies, proper [Azure Cognitive Search planning](/azure/search/search-sku-manage-costs) for regional deployments and operational scale up scheduling, and using [commitment tier pricing](/azure/cognitive-services/commitment-tier) that's available for the Computer Vision – OCR service to manage [predictable costs](/azure/cognitive-services/plan-manage-costs).

Here are some guidelines for optimizing costs:

- Use the pay-as-you-go strategy for your architecture and [scale out](/azure/architecture/framework/cost/optimize-autoscale) as needed rather than investing in large-scale resources at the start.
- Consider opportunity costs in your architecture and the balance between first-mover advantage versus fast follow. The [pricing calculator](https://azure.microsoft.com/pricing/calculator) is used to estimate the initial and operational costs.
- Establish [policies](/azure/architecture/framework/cost/principles), [budgets, and controls](/azure/architecture/framework/cost/monitor-alert) that set cost limits for your solution.

### Performance efficiency

Performance efficiency is the ability of your workload to scale efficiently to meet the demands that users place on it. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Periods when this solution processes high volumes, can expose performance bottlenecks. Make sure that you understand and plan for the [scaling options for Azure Functions](/azure/azure-functions/functions-scale#scale), [Cognitive Services autoscaling](/azure/cognitive-services/autoscale?tabs=portal), and  [Azure Cosmos DB partitioning](/azure/cosmos-db/partitioning-overview) to ensure proper performance efficiency for your solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kevin Kraus](https://www.linkedin.com/in/kevin-w-kraus) | Principal Cloud Solution Architect
- [Andrea Martini](https://www.linkedin.com/in/andreamartini) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Introductory articles:

- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What are Durable Functions?](/azure/azure-functions/durable/durable-functions-overview?tabs=csharp)
- [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
- [What’s Azure Cognitive Search?](/azure/search/search-what-is-azure-search)
- [App Service overview](/azure/app-service/overview)
- [Introduction to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
- [What is Azure Service Bus?](/azure/service-bus-messaging/service-bus-messaging-overview)

Product documentation:

- [Azure documentation (all products)](/azure?product=all)
- [Durable Functions documentation](/azure/azure-functions/durable)
- [Azure Cognitive Services documentation](/azure/cognitive-services)
- [Azure Cognitive Search documentation](/azure/search)

## Related resources

- [Custom document processing models on Azure](../document-processing/build-deploy-custom-models.yml)
- [Automate document processing by using Azure Form Recognizer](automate-document-processing-azure-form-recognizer.yml)
- [Image classification on Azure](/azure/architecture/example-scenario/ai/intelligent-apps-image-processing)
