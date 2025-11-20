This article describes an architecture that processes various documents. The architecture uses the durable functions feature of Azure Functions to implement pipelines. The pipelines process documents via Azure AI Document Intelligence for document splitting, named entity recognition (NER), and classification. Retrieval-augmented generation (RAG)-based natural language processing (NLP) uses document content and metadata to find and generate relevant information.

## Architecture

:::image type="complex" border="false" source="_images/automate-document-classification-durable-functions.svg" alt-text="Diagram that shows an architecture to identify, classify, and search documents." lightbox="_images/automate-document-classification-durable-functions.svg":::
The image is a flowchart that has multiple sections. The ingestion section contains an Azure web app. It connects via arrows to the document store section that contains Azure Blob Storage and the activation section that contains an Azure Service Bus queue. The Azure Functions orchestration section contains icons that represent analyze activity, metadata store activity, and embedding activity. Arrows point from these icons to the document processing, document metadata collection, and vectorize and index sections. The chat with your data section contains Microsoft Foundry. The ingestion section points to the vectorize and index data section and the chat with your data section.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/automate-document-classification-durable-functions.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. A user uploads a document file to a web app. The file contains multiple embedded documents of various types, like PDF or multiple-page Tag Image File Format (TIFF) files. Azure Blob Storage stores the document file (**1a**). To initiate pipeline processing, the web app adds a command message to an Azure Service Bus queue (**1b**).

1. The command message triggers the durable functions orchestration. The message contains metadata that identifies the Blob Storage location of the document file to process. Each durable functions instance processes only one document file.

1. The *analyze* activity function calls the Document Intelligence Analyze Document API, which passes the storage location of the document file to process. The analyze function reads and identifies each document within the document file. This function returns the name, type, page ranges, and content of each embedded document to the orchestration.

1. The *metadata store* activity function saves the document type, location, and page range information for each document in an Azure Cosmos DB store.

1. The *embedding* activity function uses Semantic Kernel to chunk each document and create embeddings for each chunk. The function sends the embeddings and associated content to Azure AI Search and stores them in a vector-enabled index. The function also adds a correlation ID to the search document so that the search results match the corresponding document metadata from Azure Cosmos DB.

1. Semantic Kernel retrieves embeddings from the AI Search vector store for NLP.

1. Users can chat with their data by using NLP. Grounded data retrieved from the vector store powers this conversation. To look up document records in Azure Cosmos DB, users use correlation IDs included in the search result set. The records include links to the original document file in Blob Storage.

### Components


- [Durable functions](/azure/azure-functions/durable/durable-functions-overview) is a feature of [Azure Functions](/azure/well-architected/service-guides/azure-functions) that you can use to write stateful functions in a serverless compute environment. In this architecture, a message in a Service Bus queue triggers a durable functions instance. This instance then initiates and orchestrates the document-processing pipeline.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multiple-model database that can scale throughput and storage capacity across any number of geographic regions. Comprehensive service-level agreements (SLAs) guarantee throughput, latency, availability, and consistency. In this architecture, Azure Cosmos DB serves as the metadata store for the document classification information.

- [Azure Storage](/azure/storage/common/storage-introduction) is a set of scalable and secure cloud services for data, apps, and workloads. It includes [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage), [Azure Files](/azure/well-architected/service-guides/azure-files), [Azure Table Storage](/azure/storage/tables/table-storage-overview), and [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction). In this architecture, Blob Storage stores the document files that the user uploads and that the durable functions pipeline processes.

- [Service Bus](/azure/well-architected/service-guides/service-bus/reliability) is a managed enterprise message broker that has message [queues](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions#queues) and publish-subscribe [topics](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions#topics-and-subscriptions). In this architecture, Service Bus triggers durable functions instances.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) provides a framework to build, deploy, and scale web apps. The Web Apps feature of App Service is an HTTP-based tool that hosts web applications, REST APIs, and mobile back ends. You can use Web Apps to develop in .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. Applications can run and scale in Windows-based and Linux-based environments. In this architecture, users interact with the document-processing system through an App Service-hosted web app.

- [Document Intelligence](/azure/ai-services/document-intelligence/overview) is a service that extracts insights from your documents, forms, and images. This architecture uses Document Intelligence to analyze the document files and extract the embedded documents along with content and metadata information.

- [AI Search](/azure/search/search-what-is-azure-search) provides a search experience for private, diverse content in web, mobile, and enterprise applications. In this architecture, AI Search [vector storage](/azure/search/vector-store) indexes embeddings of the extracted document content and metadata information so that users can search and retrieve documents by using NLP.

- [Semantic Kernel](/semantic-kernel/overview) is a framework that integrates large language models (LLMs) into applications. In this architecture, Semantic Kernel creates embeddings for the document content and metadata information, which are stored in AI Search.

- [Microsoft Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) is a platform that you use to build, test, and deploy AI solutions and models as a service (MaaS). In this architecture, Foundry deploys an Azure OpenAI model.

  - [Foundry projects](/azure/ai-foundry/how-to/create-projects) are specialized workspaces that you can use to establish connections to data sources, define agents, and invoke deployed models, including Azure OpenAI models. This architecture has a single Foundry project within the Foundry account.

  - [Foundry Models](/azure/ai-foundry/concepts/foundry-models-overview) is a platform that deploys flagship models, including OpenAI models, from the Azure AI catalog in a Microsoft-hosted environment. This approach uses MaaS deployment. This architecture deploys models by using the [Global Standard](/azure/ai-foundry/foundry-models/concepts/deployment-types#global-standard) configuration with a fixed quota.

### Alternatives

- To facilitate global distribution, this solution stores metadata in Azure Cosmos DB. [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is another persistent storage option for document metadata and information.

- To trigger durable functions instances, you can use other messaging platforms, including [Azure Event Grid](/azure/event-grid/overview).

- Instead of Semantic Kernel, you can use [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) or [Azure AI services](/azure/ai-services/what-are-ai-services) to create embeddings.

- You can use the [Microsoft Agent Framework](/agent-framework/overview/agent-framework-overview) instead of Semantic Kernel to orchestrate the workflows.

- To provide a natural language interface for users, you can use other language models within Foundry. The platform supports various models from different providers, including Mistral, Meta, Cohere, and Hugging Face.

### Scenario details

In this architecture, the pipelines identify the documents in a document file, classify them by type, and store information to use in subsequent processing.

Many companies need to manage and process documents that they scan in bulk and that contain several different document types, like PDFs or multiple-page TIFF images. These documents might originate from outside the organization, and the receiving company doesn't control the format.

Because of these constraints, organizations must build their own document-parsing solutions that can include custom technology and manual processes. For example, someone might manually separate individual document types and add classification qualifiers for each document type.

Many of these custom solutions are based on the state machine workflow pattern. The solutions use database systems to persist workflow state and use polling services that check for the states that they need to process. Maintaining and enhancing these solutions can increase complexity and effort.

Organizations need reliable, scalable, and resilient solutions to process and manage document identification and classification for their organization's document types. This solution can process millions of documents each day with full observability into the success or failure of the processing pipeline.

NLP lets users interact with the system in a conversational manner. Users can ask questions about the documents and receive answers based on the content of the documents.

### Potential use cases

- **Generate report titles.** Many government agencies and municipalities manage paper records that don't have a digital form. An effective automated solution can generate a file that contains all the documents that you need to satisfy a document request.

- **Manage maintenance records.** Scan and send paper records, like aircraft, locomotive, and machinery maintenance records, to outside organizations.

- **Process permits.** City and county permitting departments maintain paper documents that they generate for permit inspection reporting. You can take a picture of several inspection documents and automatically identify, classify, and search across these records.

- **Analyze planograms.** Retail and consumer goods companies manage inventory and compliance through store shelf planogram analysis. You can take a picture of a store shelf and extract label information from different products to automatically identify, classify, and quantify the product information.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

To ensure reliability and high availability when you invoke models from Foundry projects that use OpenAI models hosted in Azure, consider using a generative API gateway like [Azure API Management](/azure/api-management/genai-gateway-capabilities). This approach manages requests across multiple model deployments or Foundry endpoints. The Azure back-end gateway supports round-robin, weighted, and priority-based routing across deployments and provides full control of traffic distribution. This approach lets your Foundry project implement resilient failover strategies and intelligent load distribution tuned to your performance, regional availability, or cost requirements.

For learning and early proof-of-concept work, use a [Global Standard](/azure/ai-foundry/foundry-models/concepts/deployment-types#global-standard) deployment. Global Standard is pay-as-you-go, provides the highest default quota, and uses the Azure global infrastructure to route each request to the most available region. This approach reduces the chance of encountering regional quota or capacity constraints while you experiment and aligns with the Microsoft guidance to use Global Standard as the default starting point.

For production workloads, choose the [deployment type](/azure/ai-foundry/foundry-models/concepts/deployment-types) based on the following criteria:

- **Data-processing location:**

  - Use *Global Standard or Global Provisioned* when you want the highest availability and inferencing can occur in any Microsoft Foundry region, while data at rest remains in your selected geography.

  - Use *Data Zone Standard or Data Zone Provisioned* when you must keep inferencing within a Microsoft-defined data zone, for example US-only or EU-only, to meet data residency requirements.

- **Throughput and cost model:**

  - Use *Standard deployment types, like Global Standard, Data Zone Standard, and Regional Standard* for low-to-medium, bursty, or exploratory workloads. These types use a pay-as-you-go model with no reserved capacity. Choose these types in early stages before you understand your traffic patterns.

  - Use *Provisioned deployment types, like Global Provisioned, Data Zone Provisioned, and Regional Provisioned* for predictable, higher-volume workloads that need reserved throughput, consistent latency, and the option to use reservations for cost optimization.

Most teams begin with **Global Standard** for development, or use **Data Zone Standard** when data residency is important. After they determine their steady-state throughput and latency requirements, they move critical paths to **Provisioned** SKUs.

For more information about reliability in solution components, see [SLA information for Azure online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The most significant costs for this architecture include the following components:

- Model inference usage via Microsoft Foundry, which includes OpenAI or other models
- Document ingestion and processing via Document Intelligence
- Indexing and search consumption via AI Search

To optimize costs, consider the following recommendations:

- **Use provisioned throughput units (PTUs) or reservations for Microsoft Foundry deployments** instead of pay-per-token usage when the workload is predictable.

  - For more information, see the following resources:

    - [Provisioned throughput overview](/azure/ai-foundry/openai/concepts/provisioned-throughput)
    - [Save costs with Microsoft Foundry reservations](/azure/cost-management-billing/reservations/microsoft-foundry)
    - [Plan and manage Microsoft Foundry costs](/azure/ai-foundry/how-to/costs-plan-manage)

- **Plan for [regional deployments and operational scale-up scheduling](/azure/search/search-sku-manage-costs) in AI Search.**

- **Use [commitment tier pricing](/azure/ai-services/commitment-tier) for Document Intelligence** to manage [predictable costs](/azure/ai-foundry/how-to/costs-plan-manage).

- **Use reserved capacity and life cycle policies** to [rightsize storage accounts](/azure/storage/blobs/storage-blob-reserved-capacity).

- **Use the pay-as-you-go strategy for your architecture and [scale out](/azure/well-architected/cost-optimization/optimize-scaling-costs) as needed** instead of investing in large-scale resources at the start. As your solution matures, you can use [App Service reservations](/azure/cost-management-billing/reservations/reservation-discount-app-service) to help reduce costs where applicable.

- **Consider opportunity costs in your architecture and balance a first-mover advantage strategy with a fast-follow strategy.** To estimate the initial cost and operational costs, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

- **Establish [budgets and controls](/azure/well-architected/cost-optimization/collect-review-cost-data) that set cost limits for your solution.** To set up forecasting and actual cost alerts, use [budget alerting](/azure/cost-management-billing/costs/tutorial-acm-create-budgets).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This solution can expose performance bottlenecks when you process high volumes of data. To ensure proper performance efficiency for your solution, understand and plan for [Azure Functions scaling options](/azure/azure-functions/functions-scale#scale), [AI services autoscaling](/azure/ai-services/autoscale), and [Azure Cosmos DB partitioning](/azure/cosmos-db/partitioning-overview).

- **Apply scalable compute and orchestration** by using durable functions, which is part of Azure Functions, for the document-processing pipeline and tune its scaling behavior. For more information, see [Performance and scale in durable functions](/azure/azure-functions/durable/durable-functions-perf-and-scale).

- **Choose the appropriate deployment model in Microsoft Foundry** for inference workloads. Use serverless APIs for variable workloads and provisioned throughput models when you expect heavy, consistent traffic. For more information, see [Provisioned throughput for Foundry Models](/azure/ai-foundry/openai/concepts/provisioned-throughput) and [Performance and latency optimization for Azure OpenAI and Foundry Models](/azure/ai-foundry/openai/how-to/latency).

- **Optimize indexing and retrieval performance** by configuring appropriate partitioning, replicas, and schema for AI Search. For more information, see [AI Search performance tips](/azure/search/search-performance-tips).

- **Establish performance baselines and feedback loops.** Define realistic latency and throughput targets early, monitor actual system performance continuously, and refine architecture and operational configurations as usage patterns evolve. For more information, see [Performance Efficiency design principles](/azure/well-architected/performance-efficiency/principles).

Apply these practices to help ensure that your document classification solution remains responsive and cost effective as the solution scales.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Kevin Kraus](https://www.linkedin.com/in/kevin-w-kraus) | Principal Solution Engineer

Other contributor:

- [Brian Swiger](https://www.linkedin.com/in/brianswiger) | Principal Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

The following articles provide an introduction to relevant technologies:

- [What is Blob Storage?](/azure/storage/blobs/storage-blobs-overview)
- [What is Service Bus?](/azure/service-bus-messaging/service-bus-messaging-overview)
- [Get started with App Service](/azure/app-service/getting-started)
- [Introduction to Azure Cosmos DB](/azure/cosmos-db/introduction)

For product documentation, see the following resources:

- [Azure documentation for all products](/azure?product=all)
- [Durable functions documentation](/azure/azure-functions/durable)
- [Microsoft Foundry documentation](/azure/ai-foundry)
- [Document Intelligence documentation](/azure/ai-services/document-intelligence)
- [AI Search documentation](/azure/search)
- [Semantic Kernel documentation](/semantic-kernel/overview)

## Related resources

- [Custom document processing models on Azure](../../example-scenario/document-processing/build-deploy-custom-models.yml)
- [Image classification on Azure](../../ai-ml/idea/intelligent-apps-image-processing.yml)
