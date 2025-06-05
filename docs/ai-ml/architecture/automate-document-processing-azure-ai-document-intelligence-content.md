This article outlines a scalable and secure solution for building an automated document processing pipeline. The solution uses Azure AI Document Intelligence for the structured extraction of data. Natural language processing (NLP) models and custom models enrich the data.

## Architecture

:::image type="content" source="_images/automate-document-processing-document-intelligence-architecture.svg" alt-text="Architecture diagram that shows how data flows through the extraction, enrichment, and analytics stages of document processing." border="false" lightbox="_images/automate-document-processing-document-intelligence-architecture.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Dataflow

The following sections describe the various stages of the data extraction process.

#### Data ingestion and extraction

1. Documents are ingested through a browser at the front end of a web application. The documents contain images or are in PDF format. Azure App Service hosts a back-end application. The solution routes the documents to that application through Azure Application Gateway. This load balancer runs with Azure Web Application Firewall, which helps to protect the application from common attacks and vulnerabilities.

1. The back-end application posts a request to an Azure AI Document Intelligence REST API endpoint that uses one of the [models](/azure/ai-services/document-intelligence/concept/choose-model-feature) based on the use case requirement.
   
   1. Pretrained document analysis models include:
   
       - [Read OCR model](/azure/ai-services/document-intelligence/prebuilt/read)
       - [Layout analysis model][Document intelligence layout model]
       - [General document][Document intelligence general document model]. You can also use Layout analysis model with optional query string parameter `features=keyValuePairs` enabled.)

   1. [Pretrained scenario-specific](/azure/ai-services/document-intelligence/concept/choose-model-feature#pretrained-scenario-specific-models) models include (not limited to):
      - [Invoice][Document Intelligence invoice model]
      - [Receipt][Document Intelligence receipt model]
      - [ID document][Document Intelligence ID document model]
      - [Contract model](/azure/ai-services/document-intelligence/prebuilt/contract) 
      - [US tax document models](/azure/ai-services/document-intelligence/prebuilt/tax-document)
      - [US mortgage document model](/azure/ai-services/document-intelligence/prebuilt/mortgage-documents)
      - [US Health Insurance card model](/azure/ai-services/document-intelligence/prebuilt/health-insurance-card)

   1. [Custom Extraction models](/azure/ai-services/document-intelligence/concept/choose-model-feature#custom-extraction-models)

   The response from Azure AI Document Intelligence contains raw optical character recognition (OCR) data and structured extractions depending on the model.

1. The App Service back-end application uses the confidence values to check the extraction quality. If the quality is below a specified threshold, the app flags the data for manual verification. When the extraction quality meets requirements, the data enters [Azure Cosmos DB][Welcome to Azure Cosmos DB] for downstream application consumption. The app can also return the results to the front-end browser.

1. Other sources provide images, PDF files, and other documents. Sources include email attachments and File Transfer Protocol (FTP) servers. Tools like [Azure Data Factory][Load data into Azure Data Lake Storage Gen2 with Azure Data Factory] and [AzCopy][Get started with AzCopy] transfer these files to Azure Blob Storage. [Azure Logic Apps][Tutorial: Automate tasks to process emails by using Azure Logic Apps, Azure Functions, and Azure Storage] offers pipelines for automatically extracting attachments from emails.

1. When a document enters Blob Storage, an Azure function is triggered. The function:

   - Posts a request to the relevant Azure AI Document Intelligence pre-built endpoint.
   - Receives the response.
   - Evaluates the extraction quality.

1. The extracted data enters Azure Cosmos DB for downstream application consumption.

1. The extracted data can also be pushed to [Azure AI search for indexing to build RAG applications](/azure/ai-services/document-intelligence/concept/retrieval-augmented-generation).
   

#### Data enrichment

The pipeline that's used for data enrichment depends on the use case.

1. Data enrichment can include the following NLP capabilities:

   - Named entity recognition (NER)
   - The extraction of personal information, key phrases, health information, and other domain-dependent entities

   To enrich the data, the web app:

   - Retrieves the extracted data from Azure Cosmos DB.
   - Posts requests to these features of the AI Language API:

     - [NER][What is Named Entity Recognition (NER) in Azure AI Language?]
     - [Personal information][What is Personal Information detection in Azure AI Language?]
     - [Key phrase extraction][What is key phrase extraction in Azure AI Language?]
     - [Text Analytics for health][What is Text Analytics for health in Azure AI Language?]
     - [Custom NER][What is Custom Named Entity Recognition (NER) (preview)?], which is in preview
     - [Sentiment analysis][Sentiment analysis]
     - [Opinion mining][Opinion mining]

   - Receives responses from the AI Language API.

1. Custom models perform fraud detection, risk analysis, and other types of analysis on the data:

   - Azure Machine Learning services train and deploy the custom models.
   - The extracted data is retrieved from Azure Cosmos DB.
   - The models derive insights from the data.

   These possibilities exist for inferencing:

   - Real-time processes. The models can be deployed to [managed online endpoints](/azure/machine-learning/concept-endpoints#managed-online-endpoints) or Kubernetes online endpoints, where managed Kubernetes cluster can be anywhere including [Azure Kubernetes Service (AKS)][What is Kubernetes?].
   - Batch inferencing can be done at [batch endpoints](/azure/machine-learning/concept-endpoints#what-are-batch-endpoints) or in Azure Virtual Machines.

1. Data enrichment like consolidation of specific information, summarization, and checking for correctness can also be done by passing the extracted data to the Azure OpenAI endpoint.

1. The enriched data enters Azure Cosmos DB.

#### Analytics and visualizations

1. Applications use the raw OCR, structured data from Azure AI Document Intelligence endpoints, and the enriched data from NLP:

   - Power BI displays the data and presents reports on it.
   - The data functions as a source for Azure AI Search.
   - Other applications consume the data.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service (PaaS) offering on Azure. You can use App Service to host web applications that you can scale in or scale out manually or automatically. The service supports various languages and frameworks, such as ASP.NET, ASP.NET Core, Java, Ruby, Node.js, PHP, and Python.

- [Application Gateway][Application Gateway service page] is a layer-7 (application layer) load balancer that manages traffic to web applications. You can run Application Gateway with [Azure Web Application Firewall][Azure Web Application Firewall service page] to help protect web applications from common exploits and vulnerabilities.

- [Azure Functions][Azure Functions service page] is a serverless compute platform that you can use to build applications. With Functions, you can use triggers and bindings to react to changes in Azure services like Blob Storage and Azure Cosmos DB. Functions can run scheduled tasks, process data in real time, and process messaging queues.

- [Azure AI Document Intelligence][Document Intelligence service page] is part of Azure AI services. Azure AI Document Intelligence offers a collection of pre-built endpoints for extracting data from variety of documents and forms for building intelligent document processing solutions across organizations without training and building specific models from scratch for each document type/solution. The service also offers to build your own custom models with minimal effort and use the model through the corresponding model ID at scale. Multiple custom models can be assigned to a single model ID by creating a [composed model](/azure/ai-services/document-intelligence/how-to-guides/compose-custom-models). The [input requirements](/azure/ai-services/document-intelligence/model-overview?view=doc-intel-4.0.0#input-requirements) varies from model to model. The output format is JSON.

- [Azure Storage][Azure Storage service page] is a cloud storage solution that includes object, blob, file, disk, queue, and table storage.

   - [Blob Storage][Azure Blob Storage] is a service that's part of Azure Storage. Blob Storage offers optimized cloud object storage for large amounts of unstructured data.

   - [Azure Data Lake Storage][Azure Data Lake Storage] is a scalable, secure data lake for high-performance analytics workloads. The data typically comes from multiple heterogeneous sources and can be structured, semi-structured, or unstructured. Azure Data Lake Storage Gen2 combines Azure Data Lake Storage Gen1 capabilities with Blob Storage. As a next-generation solution, Data Lake Storage Gen2 provides file system semantics, file-level security, and scale. But it also offers the tiered storage, high availability, and disaster recovery capabilities of Blob Storage.

- [Azure Cosmos DB][Azure Cosmos DB] is a fully managed, highly responsive, scalable NoSQL database. Azure Cosmos DB offers enterprise-grade security and supports APIs for many databases, languages, and platforms. Examples include SQL, MongoDB, Gremlin, Table, and Apache Cassandra. Serverless, automatic scaling options in Azure Cosmos DB efficiently manage capacity demands of applications.

- [AI Language][Azure AI services service page] offers many NLP services that you can use to understand and analyze text. Some of these services are customizable, such as custom NER, custom text classification, conversational language understanding, and question answering.

- [Machine Learning][Azure Machine Learning service page] is an open platform for managing the development and deployment of machine-learning models at scale. Machine Learning caters to skill levels of different users, such as data scientists or business analysts. The platform supports commonly used open frameworks and offers automated featurization and algorithm selection. You can deploy models for [inferencing using endpoints](/azure/machine-learning/concept-endpoints) where you can use [online endpoints](/azure/machine-learning/concept-endpoints-online) for real-time inferencing and [batch endpoints](/azure/machine-learning/concept-endpoints-batch) to perform asynchronous or long-running inferencing. If you are building a custom model by finetuning a foundation model from [model catalog](/azure/machine-learning/concept-model-catalog), you can also deploy this model as [Serverless API endpoints](/azure/machine-learning/how-to-deploy-models-serverless).You can also deploy models to [AKS and Azure Arc-enabled Kubernetes Cluster](/azure/machine-learning/how-to-attach-kubernetes-anywhere) for inferencing. 

- [AKS][Azure Kubernetes Service (AKS)] is a fully managed Kubernetes service that makes it easy to deploy and manage containerized applications. AKS offers serverless Kubernetes technology, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance.

- [Power BI][Power BI] is a collection of software services and apps that display analytics information.

- [Azure AI Search][Azure AI Search] is a cloud search service that supplies infrastructure, APIs, and tools for searching. You can use Azure AI Search to build search experiences over private, heterogeneous content in web, mobile, and enterprise applications.

### Alternatives

- You can use [Document Intelligence Batch Analysis API](/azure/ai-services/document-intelligence/prebuilt/batch-analysis)
  to process the documents in bulk.
  
- You can use [Azure OpenAI multimodal models](/azure/ai-services/openai/concepts/models?tabs=global-standard%2Cstandard-chat-completions#gpt-4o-and-gpt-4-turbo) for extracting text from images.
   
- You can use [Azure AI Content Understanding (Preview)](/azure/ai-services/content-understanding/overview) for ingesting documents, images, videos and audio different [use cases](/azure/ai-services/content-understanding/overview#content-understanding-use-cases).

- You can use [Azure AI Foundry](/azure/ai-foundry/what-is-ai-foundry) for building, testing & deploying custom models and also developing, evaluating, deploying & monitoring generative AI applications. 
  
- You can choose another [Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree) instead of App Service to host your application.

- You can use any relational database for persistent storage of the extracted data, including:

  - [Azure SQL Database][Azure SQL Database].
  - [Azure Database for PostgreSQL][Azure Database for PostgreSQL].
  - [Azure Database for MySQL][Azure Database for MySQL].

## Scenario details

Automating document processing and data extraction is an integral task in organizations across all industry verticals. AI is one of the proven solutions in this process, although achieving 100 percent accuracy is a distant reality. But, using AI for digitization instead of purely manual processes can reduce manual effort by up to 90 percent.

Optical character recognition (OCR) can extract content from images and PDF files, which make up most of the documents that organizations use. This process uses key word search and regular expression matching. These mechanisms extract relevant data from full text and then create structured output. This approach has drawbacks. Revising the post-extraction process to meet changing document formats requires extensive maintenance effort.

### Potential use cases

This solution is ideal for the finance industry. It can also apply to the automotive, travel, and hospitality industries. The following tasks can benefit from this solution:

- Approving expense reports
- Processing invoices, receipts, and bills for insurance claims and financial audits
- Processing claims that include invoices, discharge summaries, and other documents
- Automating statement of work (SoW) approvals
- Automating ID extraction for verification purposes, as with passports or driver licenses
- Automating the process of entering business card data into visitor management systems
- Identifying purchase patterns and duplicate financial documents for fraud detection
- Automating structured extraction of data from unstructured document in Retrieval Augmented Generation scenarios 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Resiliency

- The solution's resiliency depends on the failure modes of individual services like App Service, Functions, Azure Cosmos DB, Storage, and Application Gateway. For more information, see [Resiliency checklist for specific Azure services][Resiliency checklist for specific Azure services].

- You can make Azure AI Document Intelligence resilient. Possibilities include designing it to fail over to another region and splitting the workload into two or more regions. For more information, see [Back up and recover your Azure AI Document Intelligence models][Back up and recover your Document Intelligence models].

- Machine Learning services depend on many Azure services. To provide resiliency, you need to configure each service to be resilient. For more information, see [Failover for business continuity and disaster recovery][Failover for business continuity and disaster recovery].

#### Availability

The availability of the architecture depends on the Azure services that make up the solution:

- Azure AI Document Intelligence is part of Azure AI services. For this service's availability guarantee, see [Service-level agreement (SLA) for Azure AI services][SLA for Azure AI services].

- AI Language is part of Azure AI services. For the availability guarantee for these services, see [SLA for Azure AI services][SLA for Azure AI services].

- Azure Cosmos DB provides high availability by maintaining four replicas of data within each region and by replicating data across regions. The exact availability guarantee depends on whether you replicate within a single region or across multiple regions. For more information, see [Achieve high availability with Azure Cosmos DB][Achieve high availability with Azure Cosmos DB].

- Blob Storage offers redundancy options that help ensure high availability. You can use either of these approaches to replicate data three times in a primary region:

  - At a single physical location for locally redundant storage (LRS).
  - Across three availability zones that use differing availability parameters. For more information, see [Durability and availability parameters][Durability and availability parameters]. This option works best for applications that require high availability.

- For the availability guarantees of other Azure services in the solution, see these resources:

  - [SLA for App Service][SLA for App Service]
  - [SLA for Azure Functions][SLA for Azure Functions]
  - [SLA for Application Gateway][SLA for Application Gateway]
  - [SLA for Azure Kubernetes Service (AKS)][SLA for Azure Kubernetes Service (AKS)]

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Azure Web Application Firewall helps protect your application from common vulnerabilities. This Application Gateway option uses Open Worldwide Application Security Project (OWASP) rules to prevent attacks like cross-site scripting, session hijacks, and other exploits.

- To improve App Service security, consider these options:

  - App Service can access resources in Azure Virtual Network through virtual network integration.
  - You can use App Service in an App Service Environment, which you deploy to a dedicated virtual network. This approach helps to isolate the connectivity between App Service and other resources in the virtual network.

  For more information, see [Security in Azure App Service][Security in Azure App Service - Resources inside an Azure Virtual Network].

- Blob Storage and Azure Cosmos DB encrypt data at rest. You can secure these services by using service endpoints or private endpoints.

- Azure Functions supports virtual network integration. By using this functionality, function apps can access resources inside a virtual network. For more information, see [Azure Functions networking options](/azure/azure-functions/functions-networking-options).

- You can configure Azure AI Document Intelligence and AI Language for access from specific virtual networks or from private endpoints. These services encrypt data at rest. You can use subscription keys, tokens, or Microsoft Entra ID to authenticate requests to these services. For more information, see [Authenticate requests to Azure AI services][Authenticate requests to Azure AI services].

- Machine Learning offers many levels of security:

  - [Workspace authentication][Set up authentication for Azure Machine Learning resources and workflows] provides identity and access management.
  - You can use [authorization][Manage access to an Azure Machine Learning workspace] to manage access to the workspace.
  - By [securing workspace resources][Secure an Azure Machine Learning workspace with virtual networks], you can improve network security.
  - You can [use Transport Layer Security (TLS) to secure web services][Use TLS to secure a web service through Azure Machine Learning] that you deploy through Machine Learning.
  - To protect data, you can [change the access keys for Azure Storage accounts][Regenerate storage account access keys] that Machine Learning uses.

### Cost Optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of implementing this solution depends on which components you use and which options you choose for each component.

Many factors can affect the price of each component:

- The number of documents that you process
- The number of concurrent requests that your application receives
- The size of the data that you store after processing
- Your deployment region

These resources provide information on component pricing options:

- [Document Intelligence pricing][Document Intelligence pricing]
- [App Service pricing][App Service pricing]
- [Azure Functions pricing][Azure Functions pricing]
- [Application Gateway pricing][Application Gateway pricing]
- [Azure Blob Storage pricing][Azure Blob Storage pricing]
- [Azure Cosmos DB pricing][Azure Cosmos DB pricing]
- [Language Service pricing][Language Service pricing]
- [Azure Machine Learning pricing][Azure Machine Learning pricing]
- [Azure OpenAI Service pricing](https://azure.microsoft.com/pricing/details/cognitive-services/openai-service)

After deciding on a pricing tier for each component, use the [Azure Pricing calculator][Azure Pricing calculator] to estimate the solution cost.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- App Service can automatically scale out and in as the application load varies. For more information, see [Create an autoscale setting for Azure resources based on performance data or a schedule][Create an Autoscale Setting for Azure resources based on performance data or a schedule].

- Azure Functions can scale automatically or manually. The hosting plan that you choose determines the scaling behavior of your function apps. For more information, see [Azure Functions hosting options][Azure Functions hosting options].

- By default, Azure AI Document Intelligence supports 15 concurrent requests per second. You can increase this value by [creating an Azure Support ticket][Create an Azure support request] with a quota increase request.

- For custom models that you deploy to online endpoints for real-time inferencing, [autoscaling can be enabled](/azure/machine-learning/how-to-autoscale-endpoints) through the autoscale feature in Azure Monitor. This can be managed using Azure CLI, REST API, Python SDK, Azure portal etc.

- For batch inferencing, models are deployed to batch endpoints which run on Azure Machine Learning (AML) compute clusters or Kubernetes clusters. In the case of AML compute clusters, [autoscaling of the compute and scaling compute down to zero](/azure/machine-learning/concept-endpoints) are supported. The min and max number of instances is defined during the creation of the compute cluster while the number of instances that would be used for batch inferencing is defined in the [batch deployment definition](/azure/machine-learning/how-to-use-batch-model-deployments).

- For AI Language, data and rate limits apply. For more information, see these resources:

  - [How to use named entity recognition (NER)][How to use named entity recognition (NER) - Data limits]
  - [How to detect and redact personal information][How to detect and redact Personal Information - Data limits]
  - [How to use sentiment analysis and opinion mining][How to: Use Sentiment analysis and Opinion Mining - Data limits]
  - [How to use Text Analytics for health][How to use Text Analytics for health - Data limits]

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jyotsna Ravi](https://in.linkedin.com/in/jyotsna-ravi-50182624) | Principal Customer Engineer
- Dixit Arora | Senior Customer Engineer

## Next steps

- [What is Document Intelligence?][What is Document Intelligence?]
- [Use Azure AI Document Intelligence SDKs or REST API][Use Document Intelligence SDKs or REST API]
- [What is AI Language?][What is Azure AI Language?]
- [What is Azure Machine Learning?][What is Azure Machine Learning?]
- [Introduction to Azure Functions][Introduction to Azure Functions]
- [How to configure Azure Functions with a virtual network][How to configure Azure Functions with a virtual network]
- [What is Azure Application Gateway?][What is Azure Application Gateway?]
- [What is Azure Web Application Firewall on Azure Application Gateway?][What is Azure Web Application Firewall on Azure Application Gateway?]
- [Tutorial: How to access on-premises SQL Server from Data Factory Managed virtual network using Private Endpoint][Tutorial: How to access on-premises SQL Server from Data Factory Managed VNet using Private Endpoint]
- [Azure Storage documentation][Azure Storage documentation]

## Related resources

- [Extract text from objects using Power Automate and AI Builder][Extract text from objects using Power Automate and AI Builder]

[Achieve high availability with Azure Cosmos DB]: /azure/cosmos-db/high-availability#slas-for-availability
[App Service pricing]: https://azure.microsoft.com/pricing/details/app-service/windows
[Application Gateway pricing]: https://azure.microsoft.com/pricing/details/application-gateway
[Application Gateway service page]: /azure/well-architected/service-guides/azure-application-gateway
[Authenticate requests to Azure AI services]: /azure/ai-services/authentication
[Azure Blob Storage]: /azure/well-architected/service-guides/azure-blob-storage
[Azure Blob Storage pricing]: https://azure.microsoft.com/pricing/details/storage/blobs
[Azure AI Search]: /azure/search/search-what-is-azure-search
[Azure AI services service page]: /azure/ai-services/language-service/overview
[Azure Cosmos DB]: /azure/well-architected/service-guides/cosmos-db
[Azure Cosmos DB pricing]: https://azure.microsoft.com/pricing/details/cosmos-db
[Azure Data Lake Storage]: /azure/storage/blobs/data-lake-storage-introduction
[Azure Database for MySQL]: /azure/mysql/flexible-server/overview
[Azure Database for PostgreSQL]: /azure/well-architected/service-guides/postgresql
[Document Intelligence pricing]: https://azure.microsoft.com/pricing/details/ai-document-intelligence
[Document Intelligence service page]:/azure/ai-services/document-intelligence/overview
[Azure Functions hosting options]: /azure/azure-functions/functions-scale
[Azure Functions pricing]: https://azure.microsoft.com/pricing/details/functions
[Azure Functions service page]: /azure/azure-functions/functions-overview
[Azure Kubernetes Service (AKS)]: /azure/well-architected/service-guides/azure-kubernetes-service
[Azure Machine Learning pricing]: https://azure.microsoft.com/pricing/details/machine-learning/#overview
[Azure Machine Learning service page]: /azure/well-architected/service-guides/azure-machine-learning
[Azure Pricing calculator]: https://azure.com/e/fc7dda9761974210a1ae73625a68dcd2
[Azure SQL Database]: /azure/well-architected/service-guides/azure-sql-database-well-architected-framework
[Azure Storage documentation]: /azure/storage
[Azure Storage service page]: /azure/storage/common/storage-introduction
[Azure Web Application Firewall service page]: /azure/web-application-firewall/ag/ag-overview
[Back up and recover your Document Intelligence models]: /azure/ai-services/document-intelligence/how-to-guides/disaster-recovery
[Create an Autoscale Setting for Azure resources based on performance data or a schedule]: /azure/azure-monitor/autoscale/tutorial-autoscale-performance-schedule
[Create an Azure support request]: /azure/azure-portal/supportability/how-to-create-azure-support-request
[Deploy and score a machine learning model by using an online endpoint (preview)]: /azure/machine-learning/how-to-deploy-managed-online-endpoints
[Durability and availability parameters]: /azure/storage/common/storage-redundancy#durability-and-availability-parameters
[Extract text from objects using Power Automate and AI Builder]: ../../example-scenario/ai/extract-object-text.yml
[Failover for business continuity and disaster recovery]: /azure/machine-learning/how-to-high-availability-machine-learning
[Document Intelligence general document model]: /azure/ai-services/document-intelligence/prebuilt/general-document?view=doc-intel-4.0.0&view%3C=doc-intel-3.1.0&preserve-view=true
[Document Intelligence ID document model]: /azure/ai-services/document-intelligence/prebuilt/id-document
[Document Intelligence invoice model]: /azure/ai-services/document-intelligence/prebuilt/invoice
[Document intelligence layout model]: /azure/ai-services/document-intelligence/prebuilt/layout
[Document Intelligence receipt model]: /azure/ai-services/document-intelligence/prebuilt/receipt
[US tax document models]: /azure/ai-services/document-intelligence/concept-tax-document
[Get started: Document Intelligence Studio]: /azure/ai-services/document-intelligence/quickstarts/try-document-intelligence-studio?view=doc-intel-3.1.0
[Get started with AzCopy]: /azure/storage/common/storage-use-azcopy-v10
[How to: Use Sentiment analysis and Opinion Mining - Data limits]: /azure/ai-services/language-service/sentiment-opinion-mining/how-to/call-api#data-limits
[How to configure Azure Functions with a virtual network]: /azure/azure-functions/configure-networking-how-to
[How to detect and redact Personal Information - Data limits]: /azure/ai-services/language-service/personally-identifiable-information/how-to-call#data-limits
[How to use named entity recognition (NER) - Data limits]: /azure/ai-services/language-service/named-entity-recognition/how-to-call#data-limits
[How to use Text Analytics for health - Data limits]: /azure/ai-services/language-service/text-analytics-for-health/how-to/call-api?tabs=ner#data-limits
[Introduction to Azure Functions]: /azure/azure-functions/functions-overview
[Language Service pricing]: https://azure.microsoft.com/pricing/details/cognitive-services/language-service
[Load data into Azure Data Lake Storage Gen2 with Azure Data Factory]: /azure/data-factory/load-azure-data-lake-storage-gen2
[Manage access to an Azure Machine Learning workspace]: /azure/machine-learning/how-to-assign-roles
[Opinion mining]: /azure/ai-services/language-service/sentiment-opinion-mining/overview#opinion-mining
[ParallelRunStep Class]: /python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep?view=azure-ml-py
[Power BI]: /power-bi/fundamentals/power-bi-overview
[Regenerate storage account access keys]: /azure/machine-learning/how-to-change-storage-access-key
[Resiliency checklist for specific Azure services]: ../../checklist/resiliency-per-service.md
[Secure an Azure Machine Learning workspace with virtual networks]: /azure/machine-learning/how-to-secure-workspace-vnet?tabs=pe
[Security in Azure App Service - Resources inside an Azure Virtual Network]: /azure/app-service/overview-security#resources-inside-an-azure-virtual-network
[Sentiment analysis]: /azure/ai-services/language-service/sentiment-opinion-mining/overview#sentiment-analysis
[Set up authentication for Azure Machine Learning resources and workflows]: /azure/machine-learning/how-to-setup-authentication
[SLA for App Service]: https://azure.microsoft.com/support/legal/sla/app-service/v1_4
[SLA for Application Gateway]: https://azure.microsoft.com/support/legal/sla/application-gateway/v1_2
[SLA for Azure AI services]: https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1
[SLA for Azure Functions]: https://azure.microsoft.com/support/legal/sla/functions/v1_2
[SLA for Azure Kubernetes Service (AKS)]: https://azure.microsoft.com/support/legal/sla/kubernetes-service/v1_1
[Tutorial: Automate tasks to process emails by using Azure Logic Apps, Azure Functions, and Azure Storage]: /azure/logic-apps/tutorial-process-email-attachments-workflow
[Tutorial: How to access on-premises SQL Server from Data Factory Managed VNet using Private Endpoint]: /azure/data-factory/tutorial-managed-virtual-network-on-premise-sql-server
[Use batch endpoints (preview) for batch scoring]: /azure/machine-learning/how-to-use-batch-endpoint
[Use Document Intelligence SDKs or REST API]: /azure/ai-services/document-intelligence/how-to-guides/use-sdk-rest-api
[Use TLS to secure a web service through Azure Machine Learning]: /azure/machine-learning/how-to-secure-web-service
[Visio version of architecture diagram]: https://arch-center.azureedge.net/automate-document-processing-document-intelligence-architecture.vsdx
[Welcome to Azure Cosmos DB]: /azure/cosmos-db/introduction
[What is Azure Application Gateway?]: /azure/application-gateway/overview
[What is Azure AI Language?]: /azure/ai-services/language-service/overview
[What is Document Intelligence?]: /azure/ai-services/document-intelligence/overview
[What is Azure Machine Learning?]: /azure/machine-learning/overview-what-is-azure-machine-learning
[What is Azure Web Application Firewall on Azure Application Gateway?]: /azure/web-application-firewall/ag/ag-overview
[What is Custom Named Entity Recognition (NER) (preview)?]: /azure/ai-services/language-service/custom-named-entity-recognition/overview
[What is key phrase extraction in Azure AI Language?]: /azure/ai-services/language-service/key-phrase-extraction/overview
[What is Kubernetes?]: https://azure.microsoft.com/topic/what-is-kubernetes/#overview
[What is Named Entity Recognition (NER) in Azure AI Language?]: /azure/ai-services/language-service/named-entity-recognition/overview
[What is Personal Information detection in Azure AI Language?]: /azure/ai-services/language-service/personally-identifiable-information/overview
[What is Text Analytics for health in Azure AI Language?]: /azure/ai-services/language-service/text-analytics-for-health/overview
