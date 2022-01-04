Automating document processing and data extraction has become an integral task in organizations across all industry verticals. Artificial intelligence (AI) is one of the proven solutions in this process, although achieving 100 percent accuracy is a distant reality. But using AI for digitization instead of a purely manual process can reduce manual effort by around 80 to 90 percent.

Optical character recognition (OCR) can extract content from images and PDF files, which make up the majority of documents that organizations use. This process uses key word search and regular expression matching. These mechanisms extract relevant data from full text and then create structured output. But this approach has drawbacks. Extensive maintenance is needed to tweak the post extraction process to meet changing document formats.

This article outlines a scalable and secure solution for building an automated document processing pipeline. The solution uses Azure Form Recognizer for the structured extraction of data. Natural language processing (NLP) models or custom models enrich the data.

## Potential use cases

The following tasks can benefit from this solution:

- Approving expense reports
- Processing invoices, receipts, or bills for insurance claims and financial audits
- Processing claims that include invoices, discharge summaries, and other documents
- Automating statement of work (SoW) approvals
- Automating ID extraction for verification purposes, as with passports or driver licenses
- Automating the process of entering business card data into visitor management systems
- Identifying purchase patterns and duplicate financial documents for fraud detection

## Architecture

:::image type="content" source="./media/automate-document-processing-azure-form-recognizer-architecture.png" alt-text="Architecture diagram that shows how data flows the extraction, enrichment, and analytics stages of document processing." border="false" lightbox="./media/automate-document-processing-azure-form-recognizer-architecture-lightbox.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Dataflow

Add intro statement.

#### Data ingestion and extraction

1. Documents are ingested through a browser at the front end of a web application. The documents contain images or are in PDF format. Azure App Service hosts a back-end application. The solution routes the documents to that application through Azure Application Gateway. This load balancer runs with the optional addition Azure Web Application Firewall, which helps to protect the application from common attacks and vulnerabilities.

1. The back-end application posts a request to a Form Recognizer REST API endpoint that uses one of these models:

   - Layout
   - Invoice
   - Receipt
   - ID document
   - Business card
   - General document, which is in preview

   The response from Form Recognizer contains raw OCR data and structured extractions.

1. The data enters Azure Cosmos DB for downstream application consumption. The App Service back-end application can also return the results to the front-end browser. Alternatively, the app can evaluate the extraction quality by using confidence values that Form Recognizer assigns to the extracted data. If the quality is below a specified threshold, the app flags the data. The extraction then undergoes manual verification before entering the database or returning to the front end.

1. Other sources provide images, PDF files, and other documents. Sources include email attachments and File Transfer Protocol (FTP) servers. Tools like Azure Data Factory and Az Copy transfer these files to Azure Blob Storage. Azure Logic Apps offers pipelines for automatically extracting attachments from emails.

1. When a document enters Azure Blob Storage, an Azure function is triggered. The function:

   - Posts a request to the relevant Azure Form Recognizer pre-built endpoint.
   - Receives the response.
   - Evaluates the extraction quality.

1. The extracted data enters Azure Cosmos DB.

#### Data enrichment

The pipeline that's used for data enrichment depends on the use case.

1. Data enrichment can include the following NLP capabilities:

   - Named entity recognition (NER)
   - The extraction of personally identifiable information (PII), key phrases, health information, and other domain-dependent entities

   To enrich the data, the web app:

   - Retrieves the extracted data from Cosmos DB.
   - Posts requests to these features of the Azure Cognitive Services for Language API:

     - [NER][What is Named Entity Recognition (NER) in Azure Cognitive Service for Language?]
     - [PII][What is Personally Identifiable Information (PII) detection in Azure Cognitive Service for Language?]
     - [Key phrase extraction][What is key phrase extraction in Azure Cognitive Service for Language?]
     - [Text analytics for health][What is Text Analytics for health in Azure Cognitive Service for Language?]
     - [Custom NER][What is Custom Named Entity Recognition (NER) (preview)?], which is in preview
     - [Sentiment analysis][Sentiment analysis]
     - [Opinion mining][Opinion mining]

   - Receives responses from the Azure Cognitive Service for Language API.

1. Custom models perform fraud detection, risk analysis, and other types of analysis on the data:

   - Azure Machine Learning services train and deploy the custom models.
   - The extracted data is retrieved from Cosmos DB.
   - The models derive insights from the data.

   These possibilities exist for inferencing:

   - Real-time processes. The models are deployed as a web service in Azure Kubernetes Service (AKS).
   - Batch inferencing in an Azure Virtual Machine.

1. The enriched data enters Azure Cosmos DB.

#### Analytics and visualizations

1. Applications use the raw OCR, structured data from Form Recognizer endpoints and the enriched data from NLP:

   - Power BI displays the data and presents reports on it.
   - The data functions as a source for Azure Cognitive Search.
   - Other applications consume the data.

### Components

- [Azure App Service][App Service] is a platform as a service (PaaS) offering on Azure. You can use App Service to host web applications that you can scale in or scale out manually or automatically. The service supports multiple languages and frameworks like ASP.NET, ASP.NET Core, Java, Ruby, Node.js, PHP, and Python.

- [Azure Application Gateway][What is Azure Application Gateway?] is a layer-7 (application layer) load balancer that manages traffic to web applications. You can run Application Gateway with [Azure Web Application Firewall][What is Azure Web Application Firewall on Azure Application Gateway?] to help protect web applications from common exploits and vulnerabilities.

- [Azure Functions][Introduction to Azure Functions] is a serverless compute platform that you can use to build applications. With Functions, you can use triggers and bindings to react to changes in Azure services like Azure Blob Storage and Azure Cosmos DB. Functions can run scheduled tasks, process data in real-time, and process messaging queues.

- [Azure Form Recognizer][What is Azure Form Recognizer?] is part of Azure Applied AI Services. Form Recognizer offers a collection of pre-built endpoints for extracting data from invoices, documents, receipts, ID cards, and business cards. This service maps each piece of extracted data to its field as a key-value pair. Form Recognizer also extracts table content and structure. The output format is JSON.

- [Azure Storage][Azure Storage documentation] is a cloud storage solution that includes object, blob, file, disk, queue, and table storage.

- [Data Lake Storage][Azure Data Lake Storage] is a scalable, secure data lake for high-performance analytics workloads. The data typically comes from multiple, heterogeneous sources and can be structured, semi-structured, or unstructured. Data Lake Storage Gen2 combines Data Lake Storage Gen1 capabilities with Blob Storage. This next-generation data lake solution provides file system semantics, file-level security, and scale. But it also offers the tiered storage, high availability, and disaster recovery capabilities of Blob Storage.

- [Azure Cosmos DB][Azure Cosmos DB] is a fully managed, highly responsive, scalable NoSQL database. Azure Cosmos DB offers enterprise-grade security and supports APIs for many databases, languages, and platforms. Examples include: SQL, MongoDB, Gremlin, Table, and Apache Cassandra. Serverless, automatic scaling options in Azure Cosmos DB efficiently manage capacity demands of applications.

- [Azure Cognitive Service for Language][What is Azure Cognitive Service for Language?] offers many NLP services that you can use to understand and analyze text. Some of these services are customizable, such as custom NER, custom text classification, conversational language understanding, and question answering.

- [Azure Machine Learning][What is Azure Machine Learning?] is an open platform for managing the development and secure deployment of machine learning models at scale. Machine Learning caters to skill levels of different users, such as data scientists or business analysts. The platform supports commonly used open frameworks and offers automated featurization and algorithm selection. You can deploy models to various targets. Examples include [AKS][Deploy Azure Machine Learning to AKS], [Azure Container Instances][Deploy Azure Machine Learning to ACI] as a web service for real-time inferencing at scale, and [Azure Virtual Machine for batch scoring][Tutorial: Build an Azure Machine Learning pipeline for batch scoring]. Managed endpoints in Azure Machine Learning abstract the required infrastructure for [real-time][Deploy and score a machine learning model by using an online endpoint (preview)] or [batch][Use batch endpoints (preview) for batch scoring] model inferencing.

- [AKS][Azure Kubernetes Service (AKS)] is a fully managed Kubernetes service that makes it easy to deploy and manage containerized applications. AKS offers serverless Kubernetes technology, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance.

- [Power BI][Power BI] is a collection of software services and apps that display analytics information.

- [Azure Cognitive Search][Azure Cognitive Search] is a cloud search service that supplies infrastructure, APIs, and tools for searching. You can use Azure Cognitive Search to build search experiences over private, heterogeneous content in web, mobile, and enterprise applications.

### Alternatives

- You can use [Azure Virtual Machines][Choose the right VM for your workload and reduce costs] instead of App Service to host your application.
[Choose the right VM for your workload and reduce costs]: https://azure.microsoft.com/en-in/services/virtual-machines/#overview

- You can use any relational database for persistent storage of the extracted data. Examples include [Azure SQL database][Azure SQL Database], [Azure Database for PostgreSQL][Azure Database for PostgreSQL], and [Azure Database for MySQL][Azure Database for MySQL].

## Considerations

Keep these points in mind when you use this solution.

### Availability

The availability of the architecture depends on the Azure services that make up the solution:

- Form Recognizer is part of Azure Applied AI Services. For this service's availability guarantee, see [SLA for Azure Applied AI Services][SLA for Azure Applied AI Services].

- Azure Cognitive Service for Language is part of Azure Cognitive Services. For availability guarantee for these services, see [SLA for Azure Cognitive Services][SLA for Azure Cognitive Services].

- Azure Cosmos DB provides high availability by maintaining four replicas of data within each region and by replicating data across regions. The exact availability guarantee depends on whether you replicate within a single region or across multiple regions. For more information, see [Achieve high availability with Cosmos DB][Achieve high availability with Cosmos DB].

- Azure Blob Storage offers redundancy options that help ensure high availability. You can use either of these approaches to replicate data three times in a primary region:

  - At a single physical location for locally redundant storage (LRS).
  - Across three availability zones that use differing availability parameters. For more information on these parameters, see [Durability and availability parameters][Durability and availability parameters]. This option works best for applications that require high availability.

- For the availability guarantees of other Azure services in the solution, see these resources:

  - [SLA for App Service][SLA for App Service]
  - [SLA for Azure Functions][SLA for Azure Functions]
  - [SLA for Application Gateway][SLA for Application Gateway]
  - [SLA for Azure Kubernetes Service (AKS)][SLA for Azure Kubernetes Service (AKS)]

### Scalability

- App Service can automatically scale out and in as the application load varies. For more information, see [Create an autoscale setting for Azure resources based on performance data or a schedule][Create an Autoscale Setting for Azure resources based on performance data or a schedule].

- Azure Functions can scale automatically or manually. The hosting plan that you choose determines the scaling behavior of your function apps. For more information, see [Azure Functions hosting options][Azure Functions hosting options].

- By default, Form Recognizer supports 15 concurrent requests per second. You can increase this value by [creating an Azure support ticket][Create an Azure support request] with a quota increase request.

- For custom models that you host as web services on AKS, azureml-fe automatically scales as needed. This front-end component routes incoming inference requests to deployed services. For more information, see [Deploy a model to an Azure Kubernetes Service cluster][Deploy a model to an Azure Kubernetes Service cluster - Autoscaling].

- For batch inferencing, Azure Machine Learning creates a compute cluster on demand that scales automatically. For more information, see [Tutorial: Build an Azure Machine Learning pipeline for batch scoring][Tutorial: Build an Azure Machine Learning pipeline for batch scoring]. Azure Machine Learning uses the [ParellelRunStep][ParallelRunStep Class] class to run the inferencing jobs in parallel.

- For Azure Cognitive Services for Language, data and rate limits apply. For more information, see these resources:

  - [How to use named entity recognition (NER)][How to use named entity recognition (NER) - Data limits]
  - [How to detect and redact personally identifying information (PII)][How to detect and redact Personally Identifying Information (PII) - Data limits]
  - [How to use sentiment analysis and opinion mining][How to: Use Sentiment analysis and Opinion Mining - Data limits]
  - [How to use Text Analytics for health][How to use Text Analytics for health - Data limits]

### Security

- Web Application Firewall helps protect your application from common vulnerabilities. This Application Gateway option uses Open Web Application Security Project (OWASP) rules to prevent attacks like cross-site scripting, session hijacks, and other exploits.

- To improve App Service security, consider these options:

  - App Service can access resources in Azure Virtual Network through Virtual Network integration.
  - You can use App Service in an App service environment (ASE), which you deploy to a dedicated virtual network. This approach helps to isolate the connectivity between App Service and other resources in the virtual network.

  For more information, see [Security in Azure App Service][Security in Azure App Service - Resources inside an Azure Virtual Network].

- Azure Blob Storage and Azure Cosmos DB encrypt data at rest. You can secure these services by using service end points or private end points.

- Azure Functions supports virtual network integration. By using this functionality, function apps can access resources inside a virtual network. For more information, see [Azure Functions networking options][Azure Functions networking options].

- You can configure Form Recognizer and Azure Cognitive Service for Language for access from specific virtual networks or from private endpoints. These services encrypt data at rest. You can use subscription keys, tokens, or Azure Active Directory to authenticate requests to these services. For more information, see [Authenticate requests to Azure Cognitive Services][Authenticate requests to Azure Cognitive Services].

- Azure Machine Learning provides many levels of security:

  - [Workspace authentication][Set up authentication for Azure Machine Learning resources and workflows] provides identity and access management.
  - You can use [authorization][Manage access to an Azure Machine Learning workspace] to manage access to the workspace.
  - By [securing workspace resources][Secure an Azure Machine Learning workspace with virtual networks], you can improve network security.
  - You can [use Transport Layer Security (TLS) to secure web services][Use TLS to secure a web service through Azure Machine Learning] that you deploy through Azure Machine Learning.
  - To protect data, you can [change the access keys for Azure Storage accounts][Regenerate storage account access keys] that Azure Machine Learning uses.

### Resiliency

The solution's resiliency depends on the failure modes of individual services like App Service, Azure Functions, Azure Cosmos DB, Azure Storage, and Application Gateway. For more information, see [Resiliency checklist for specific Azure services][Resiliency checklist for specific Azure services].

You can make Form Recognizer resilient by designing it to fail over to another region or by splitting the workload into two or more regions. For more information, see [Back up and recover your Form Recognizer models][Back up and recover your Form Recognizer models].

Azure Machine Learning services depend on many Azure services. To provide resiliency, you need to configure each service to be resilient. For more information, see [Failover for business continuity and disaster recovery][Failover for business continuity and disaster recovery].

## Deploy this scenario


## Pricing

The cost of implementing this solution depends on which components you use and which options you choose for each component.

Many factors can affect which pricing options you choose for each component:

- The amount of documents that you process
- The number of concurrent requests that your application receives
- The size of the data that you store after processing
- Your deployment region

These resources provide information on component pricing options:

- [Azure Form Recognizer pricing][Azure Form Recognizer pricing]
- [App Service pricing][App Service pricing]
- [Azure Functions pricing][Azure Functions pricing]
- [Application Gateway pricing][Application Gateway pricing]
- [Azure Blob Storage pricing][Azure Blob Storage pricing]
- [Azure Cosmos DB pricing][Azure Cosmos DB pricing]
- [Language Service pricing][Language Service pricing]
- [Azure Machine Learning pricing][Azure Machine Learning pricing]

After deciding on a pricing tier for each component, use the [Azure Pricing calculator][Azure Pricing calculator] to estimate the solution cost.

## Next steps

- [Get started: Form Recognizer Studio][Get started: Form Recognizer Studio]
- [Use Form Recognizer SDKs or REST API][Use Form Recognizer SDKs or REST API]
- [How to configure Azure Functions with a virtual network][How to configure Azure Functions with a virtual network]
- [Tutorial: How to access on-premises SQL Server from Data Factory Managed VNet using Private Endpoint][Tutorial: How to access on-premises SQL Server from Data Factory Managed VNet using Private Endpoint]

## Related resources

- [Extract text from objects using Power Automate and AI Builder][Extract text from objects using Power Automate and AI Builder]
- [Knowledge mining in business process management][Knowledge mining in business process management]
- [Knowledge mining in contract management][Knowledge mining in contract management]
- [Knowledge mining for content research][Knowledge mining for content research]

[Achieve high availability with Cosmos DB]: https://docs.microsoft.com/en-us/azure/cosmos-db/high-availability#slas-for-availability
[App Service]: https://azure.microsoft.com/en-us/services/app-service/
[App Service pricing]: https://azure.microsoft.com/en-in/pricing/details/app-service/windows/
[Application Gateway pricing]: https://azure.microsoft.com/en-in/pricing/details/application-gateway/
[Authenticate requests to Azure Cognitive Services]: https://docs.microsoft.com/en-us/azure/cognitive-services/authentication
[Azure Blob Storage pricing]: https://azure.microsoft.com/en-in/pricing/details/storage/blobs/
[Azure Cognitive Search]: https://azure.microsoft.com/en-us/services/search/
[Azure Cosmos DB]: https://azure.microsoft.com/en-us/services/cosmos-db/
[Azure Cosmos DB pricing]: https://azure.microsoft.com/en-us/pricing/details/cosmos-db/
[Azure Data Lake Storage]: https://azure.microsoft.com/en-us/services/storage/data-lake-storage/
[Azure Database for MySQL]: https://azure.microsoft.com/en-us/services/mysql/
[Azure Database for PostgreSQL]: https://azure.microsoft.com/en-us/services/postgresql/
[Azure Form Recognizer pricing]: https://azure.microsoft.com/en-us/pricing/details/form-recognizer/
[Azure Functions hosting options]: https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale
[Azure Functions networking options]: https://docs.microsoft.com/en-us/azure/azure-functions/functions-networking-options#virtual-network-integration
[Azure Functions pricing]: https://azure.microsoft.com/en-in/pricing/details/functions/
[Azure Kubernetes Service (AKS)]: https://azure.microsoft.com/en-us/services/kubernetes-service/
[Azure Machine Learning pricing]: https://azure.microsoft.com/en-in/pricing/details/machine-learning/#overview
[Azure Pricing calculator]: https://azure.microsoft.com/en-us/pricing/calculator/
[Azure SQL Database]: https://azure.microsoft.com/en-us/products/azure-sql/database/
[Azure Storage documentation]: https://docs.microsoft.com/en-us/azure/storage/
[Back up and recover your Form Recognizer models]: https://docs.microsoft.com/en-us/azure/applied-ai-services/form-recognizer/disaster-recovery
[Create an Autoscale Setting for Azure resources based on performance data or a schedule]: https://docs.microsoft.com/en-us/azure/azure-monitor/autoscale/tutorial-autoscale-performance-schedule
[Create an Azure support request]: https://docs.microsoft.com/en-us/azure/azure-portal/supportability/how-to-create-azure-support-request
[Deploy Azure Machine Learning to ACI]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-azure-container-instance#deploy-to-aci
[Deploy Azure Machine Learning to AKS]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-azure-kubernetes-service?tabs=python#deploy-to-aks
[Deploy a model to an Azure Kubernetes Service cluster - Autoscaling]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-azure-kubernetes-service?tabs=python#autoscaling
[Deploy and score a machine learning model by using an online endpoint (preview)]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-managed-online-endpoints
[Durability and availability parameters]: https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy#durability-and-availability-parameters
[Extract text from objects using Power Automate and AI Builder]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/ai/extract-object-text
[Failover for business continuity and disaster recovery]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-high-availability-machine-learning
[Get started: Form Recognizer Studio]: https://docs.microsoft.com/en-us/azure/applied-ai-services/form-recognizer/quickstarts/try-v3-form-recognizer-studio
[How to: Use Sentiment analysis and Opinion Mining - Data limits]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/sentiment-opinion-mining/how-to/call-api#data-limits
[How to configure Azure Functions with a virtual network]: https://docs.microsoft.com/en-us/azure/azure-functions/configure-networking-how-to
[How to detect and redact Personally Identifying Information (PII) - Data limits]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/personally-identifiable-information/how-to-call#data-limits
[How to use named entity recognition (NER) - Data limits]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/named-entity-recognition/how-to-call#data-limits
[How to use Text Analytics for health - Data limits]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/text-analytics-for-health/how-to/call-api?tabs=ner#data-limits
[Introduction to Azure Functions]: https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview
[Knowledge mining in business process management]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/business-process-management
[Knowledge mining for content research]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/content-research
[Knowledge mining in contract management]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/contract-management
[Language Service pricing]: https://azure.microsoft.com/en-us/pricing/details/cognitive-services/language-service/
[Manage access to an Azure Machine Learning workspace]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-assign-roles
[Opinion mining]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/sentiment-opinion-mining/overview#opinion-mining
[ParallelRunStep Class]: https://docs.microsoft.com/en-us/python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep?view=azure-ml-py
[Power BI]: https://powerbi.microsoft.com/en-us/
[Regenerate storage account access keys]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-change-storage-access-key
[Resiliency checklist for specific Azure services]: https://docs.microsoft.com/en-us/azure/architecture/checklist/resiliency-per-service
[Secure an Azure Machine Learning workspace with virtual networks]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-secure-workspace-vnet?tabs=pe
[Security in Azure App Service - Resources inside an Azure Virtual Network]: https://docs.microsoft.com/en-us/azure/app-service/overview-security#resources-inside-an-azure-virtual-network
[Sentiment analysis]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/sentiment-opinion-mining/overview#sentiment-analysis
[Set up authentication for Azure Machine Learning resources and workflows]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-setup-authentication
[SLA for App Service]: https://azure.microsoft.com/en-in/support/legal/sla/app-service/v1_4/
[SLA for Application Gateway]: https://azure.microsoft.com/en-in/support/legal/sla/application-gateway/v1_2/
[SLA for Azure Applied AI Services]: https://azure.microsoft.com/en-gb/support/legal/sla/azure-applied-ai-services/v1_0/
[SLA for Azure Cognitive Services]: https://azure.microsoft.com/en-in/support/legal/sla/cognitive-services/v1_1/
[SLA for Azure Functions]: https://azure.microsoft.com/en-in/support/legal/sla/functions/v1_2/
[SLA for Azure Kubernetes Service (AKS)]: https://azure.microsoft.com/en-in/support/legal/sla/kubernetes-service/v1_1/
[Tutorial: Build an Azure Machine Learning pipeline for batch scoring]: https://docs.microsoft.com/en-us/azure/machine-learning/tutorial-pipeline-batch-scoring-classification
[Tutorial: How to access on-premises SQL Server from Data Factory Managed VNet using Private Endpoint]: https://docs.microsoft.com/en-us/azure/data-factory/tutorial-managed-virtual-network-on-premise-sql-server
[Use batch endpoints (preview) for batch scoring]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-use-batch-endpoint
[Use Form Recognizer SDKs or REST API]: https://docs.microsoft.com/en-us/azure/applied-ai-services/form-recognizer/how-to-guides/try-sdk-rest-api?pivots=programming-language-python
[Use TLS to secure a web service through Azure Machine Learning]: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-secure-web-service
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1902078-automate-document-processing-azure-form-recognizer-architecture.vsdx
[What is Azure Application Gateway?]: https://docs.microsoft.com/en-us/azure/application-gateway/overview
[What is Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/overview
[What is Azure Form Recognizer?]: https://docs.microsoft.com/en-us/azure/applied-ai-services/form-recognizer/overview
[What is Azure Machine Learning?]: https://docs.microsoft.com/en-us/azure/machine-learning/overview-what-is-azure-machine-learning
[What is Azure Web Application Firewall on Azure Application Gateway?]: https://docs.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview
[What is Custom Named Entity Recognition (NER) (preview)?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/custom-named-entity-recognition/overview
[What is key phrase extraction in Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/key-phrase-extraction/overview
[What is Named Entity Recognition (NER) in Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/named-entity-recognition/overview
[What is Personally Identifiable Information (PII) detection in Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/personally-identifiable-information/overview
[What is Text Analytics for health in Azure Cognitive Service for Language?]: https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/text-analytics-for-health/overview?tabs=ner


