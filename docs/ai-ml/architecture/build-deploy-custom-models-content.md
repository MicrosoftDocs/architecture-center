This article describes Azure solutions for building, training, deploying, and using custom document processing models. These Azure services also provide user interface (UI) capabilities for labeling or tagging text during processing.

## Architecture

:::image type="complex" border="false" source="_images/build-deploy-custom-models.svg" alt-text="Diagram that shows several alternatives for a custom document processing model build and deployment process." lightbox="_images/build-deploy-custom-models.svg":::
   This diagram shows several alternatives for a custom document processing model build and deployment process. This dataflow begins with orchestrators, such as Azure Logic Apps, Azure Functions, or Azure Data Factory. These orchestrators ingest messages, email attachments, and files from sources like email servers, FTP servers, or web applications. The data is then stored in Azure Blob Storage or Azure Data Lake Storage and organized by attributes such as file extensions or customer details. Next, it's used to train custom models with tools like Document Intelligence Studio for extracting key-value pairs or classifying documents, Language Studio for custom text classification and named entity recognition (NER), Azure Machine Learning for advanced workflows with frameworks like PyTorch or TensorFlow, or Azure OpenAI Service for fine-tuning models for tasks like summarization or Q&A. Lastly, the trained models are deployed for inferencing by using SDKs, REST APIs, managed endpoints, or Azure Kubernetes Service, with support for real-time and batch inferencing.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/build-deploy-custom-models.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Orchestrators like Azure Logic Apps, Azure Data Factory, or Azure Functions ingest messages and attachments from email servers and files from file transfer protocol servers or web applications.

   - Azure Functions and Azure Logic Apps enable serverless workloads. The service that you choose depends on your preference for service capabilities like development, connectors, management, and operational context. For more information, see [Compare Azure Functions and Azure Logic Apps](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-azure-functions-and-azure-logic-apps).

   - Consider using Azure Data Factory to move data in bulk.

1. The orchestrators send ingested data to Azure Blob Storage or Azure Data Lake Storage. They organize the data within these stores based on characteristics like file extensions or customer details.

1. You can use the following Azure services, either independently or in combination, for training documents and building custom models to address various use cases.

   - [Document Intelligence Studio](https://documentintelligence.ai.azure.com/studio): If the document requires you to extract key-value pairs or create a custom table from an image or PDF, use Document Intelligence Studio to tag the data and train the custom model. If there's a requirement to identify the type of document, called *document classification*, before you invoke the correct extraction model, use Document Intelligent Studio to label the documents and build the models.

   - [Language Studio](https://language.cognitive.azure.com/): For document classification based on content, or for domain-specific entity extraction, you can train a custom text classification or named entity recognition (NER) model in Language Studio.

   - [Azure Machine Learning studio](https://ml.azure.com/): For labeling data for text classification or entity extraction to use with open-source frameworks like PyTorch or TensorFlow, use [Machine Learning studio](/azure/machine-learning/how-to-train-with-ui), the [Python SDK, Azure CLI, or the REST API](/azure/machine-learning/how-to-train-model). Machine Learning studio provides a [model catalog](/azure/machine-learning/concept-model-catalog) of foundation models. These foundation models have fine-tuning capabilities for various tasks like text classification, question answering, and summarization. To fine-tune foundation models, use the [Machine Learning studio UI](/azure/machine-learning/how-to-use-foundation-models) or [code](https://github.com/Azure/azureml-examples/tree/main/sdk/python/foundation-models/system/finetune).

   - [Azure OpenAI Service](/azure/ai-services/openai/concepts/fine-tuning-considerations): To [fine-tune Azure OpenAI models](/azure/ai-services/openai/how-to/fine-tuning) on your own data or domain for various tasks like text summarization and question answering, use [Azure AI Foundry portal](/azure/ai-services/openai/how-to/fine-tuning?branch=main&tabs=azure-openai%2Cpython-new&pivots=programming-language-studio), [Python SDK](/azure/ai-services/openai/how-to/fine-tuning?tabs=azure-openai%2Cpython-new&pivots=programming-language-python), or [REST API](/azure/ai-services/openai/how-to/fine-tuning?tabs=azure-openai%2Cpython-new&pivots=rest-api).

1. To deploy the custom models and use them for inferencing:

   - Azure AI Document Intelligence has built-in model deployment. Inferencing with the custom models is done by using [SDKs](/python/api/overview/azure/ai-documentintelligence-readme) or [document models REST API](/rest/api/aiservices/document-models/get-analyze-result). The [modelId](/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-model), or *model name*, specified during model creation is included in the request URL for document analysis. Document Intelligence doesn't require any further deployment steps.

   - Language Studio provides an option to deploy custom language models. Get the REST endpoint [prediction URL](/azure/ai-services/language-service/custom-named-entity-recognition/how-to/call-api) by selecting the model for deployment. You can inference models by using either the REST endpoint or the Azure SDK client libraries.

   - Machine Learning deploys custom models to online or batch [Machine Learning managed endpoints](/azure/machine-learning/concept-endpoints). You can also use the Machine Learning SDK to [deploy to Azure Kubernetes Service (AKS)](/azure/machine-learning/how-to-deploy-azure-kubernetes-service) as a web service. Fine-tuned foundation models can be deployed from the model catalog via managed compute or a [serverless API](/azure/machine-learning/how-to-deploy-models-serverless). Models deployed through managed compute can be inferenced by using managed endpoints, which include online endpoints for real-time inferencing and batch endpoints for batch inferencing.

   - Azure AI Foundry provides multiple options to [deploy fine-tuned Azure OpenAI models](/azure/ai-foundry/openai/how-to/fine-tuning-deploy). You can deploy these models by using the Python SDK or REST API. You can also deploy fine-tuned foundation models from providers like Meta or Llama as [serverless APIs](/azure/ai-foundry/how-to/fine-tune-serverless) or by using [managed compute](/azure/ai-foundry/how-to/fine-tune-managed-compute).

### Components

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is part of [Azure Integration Services](/shows/azure-friday/an-overview-of-azure-integration-services). Logic Apps creates automated workflows that integrate apps, data, services, and systems. In this architecture, Logic Apps orchestrates the ingestion of documents and data from various sources and triggers downstream processes for document processing. You can use [managed connectors](/azure/connectors/managed) for services like Azure Storage and Microsoft 365 to trigger workflows when a file arrives in the storage account or an email is received.

- [Azure Data Factory](/azure/data-factory/introduction) is a managed data integration service for orchestrating and automating data movement and transformation. In this architecture, Azure Data Factory adds [transformation activities](/azure/data-factory/transform-data) like invoking a REST endpoint or running a notebook on the ingested data to the pipeline.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless compute service that can host event-driven workloads that have short-lived processes. In this architecture, Functions enables workloads to process incoming documents and trigger model processing pipelines.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage solution for storing unstructured data. Blob Storage supports libraries for multiple languages, such as .NET, Node.js, and Python. Applications can access files on Blob Storage via HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) to support cost optimization for storing large amounts of data. In this architecture, this account is the solution for raw files that use a hot tier.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a scalable, cloud-based repository for storing and organizing large volumes of unstructured data. In this architecture, Data Lake Storage organizes and maintains large volumes of ingested data to support analytics, labeling, and machine learning workflows.

- [Document Intelligence](/azure/ai-services/document-intelligence/overview) is a component of [Azure AI services](/azure/ai-services/what-are-ai-services). In this architecture, it provides built-in document analysis capabilities for extracting printed and handwritten text, tables, and key-value pairs. Document Intelligence has prebuilt models for extracting data from invoices, documents, receipts, ID cards, and business cards. Document Intelligence also has a [custom template](/azure/ai-services/document-intelligence/train/custom-template) form model and a [custom neural](/azure/ai-services/document-intelligence/train/custom-neural) document model that you can use to train and deploy custom models.

- [Document Intelligence Studio](/azure/ai-services/document-intelligence/studio-overview) provides an interface to explore Document Intelligence features and models. You can use the interface to label data and build custom document processing models.

- [Azure AI Language](/azure/ai-services/language-service/overview) consolidates the Azure natural language processing (NLP) services. It provides [prebuilt and customizable options](/azure/ai-services/language-service/overview#available-features) and language understanding capabilities. Use it to classify documents, recognize named entities, and complete other NLP tasks.

- [Language Studio](/azure/ai-services/language-service/overview) is a web-based UI in Language that you can use to build, train, manage, and deploy language models. In this architecture, it supports tagging, training, and deploying custom language models for tasks like classification and entity extraction within the document processing pipeline. [Autolabeling](/azure/ai-services/language-service/custom-text-classification/how-to/use-autolabeling) supports custom text classification and can automatically label documents into different classes or categories. The studio also provides options to view [model performance](/azure/ai-services/language-service/custom-text-classification/how-to/view-model-evaluation), including F1 score, precision, and recall.

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a managed machine learning platform for model development and deployment at scale. In this architecture, it labels data, trains custom models (including with open-source frameworks), and deploys the models for inference tasks.

  - Machine Learning studio provides data labeling options for [images](/azure/machine-learning/how-to-create-image-labeling-projects#image-labeling-capabilities) and [text](/azure/machine-learning/how-to-create-text-labeling-projects). It supports model training workflows within this architecture.

  - [Export labeled data](/azure/machine-learning/how-to-use-labeled-dataset#export-data-labels) as [COCO](https://cocodataset.org) or Machine Learning datasets. You can use these datasets to train and deploy models in Machine Learning notebooks.

- [Azure OpenAI](/azure/ai-foundry/openai/overview) provides powerful [language models and multimodal models](/azure/ai-services/openai/concepts/models) as REST APIs that you can use to complete various tasks. In this architecture, Azure OpenAI models handle advanced language tasks such as [fine-tuning models](/azure/ai-services/openai/concepts/models#fine-tuning-models) to improve how the model works with data that's missing or underrepresented when the base model is first trained. You can also use foundation models from multiple providers to complete these tasks.

### Alternatives

You can add more workflows to this scenario based on specific use cases.

- If the document is an image or PDF, you can extract the data by using Azure [optical character recognition](/azure/ai-services/computer-vision/overview-ocr), the [Document Intelligence Read API](/azure/ai-services/document-intelligence/prebuilt/read), or open-source libraries.

- You can use the prebuilt model in Language for [document and conversation summarization](/azure/ai-services/language-service/summarization/overview).

- Use preprocessing code to run text processing steps. These steps include cleaning, stop words removal, lemmatization, stemming, and text summarization on extracted data according to document processing requirements. You can expose the code as REST APIs for automation. Manually complete or automate these steps by integrating with the [Azure Logic Apps](/azure/logic-apps/logic-apps-custom-api-host-deploy-call) or [Azure Functions](/samples/azure-samples/flask-app-on-azure-functions/azure-functions-python-create-flask-app) ingestion process.

- You can use [Azure AI Foundry portal](/azure/ai-foundry/what-is-ai-foundry) to [fine-tune](/azure/ai-foundry/concepts/fine-tuning-overview) and deploy foundation models, and build generative AI applications.

  Azure AI Foundry provides two compute options for models as a platform (MaaP) hosting, [serverless compute and managed compute](/azure/ai-foundry/concepts/fine-tuning-overview#serverless-or-managed-compute). [Specific models and regions](/azure/ai-foundry/how-to/deploy-models-serverless-availability) support deployment through serverless API, which provides models as a service (MaaS).

  Machine Learning and Azure AI Foundry share capabilities, so [evaluate both platforms](/ai/ai-studio-experiences-overview) and choose the best one for your scenario.

- You can use [Azure AI Content Understanding](/azure/ai-services/content-understanding/overview) to create a [custom analyzer](/azure/ai-services/content-understanding/quickstart/use-rest-api?tabs=document) by defining a field schema for extracting structured data from the document.

## Scenario details

Document processing covers a wide range of tasks. It can be difficult to meet all your document processing needs by using the prebuilt models available in Language and Document Intelligence. You might need to build custom models to automate document processing for different applications and domains.

Major challenges in model customization include:

- Labeling or tagging text data with relevant key-value pair entities to classify text for extraction.

- Managing training infrastructure, such as compute and storage, and their integrations.

- Deploying models at scale for applications to consume.

### Potential use cases

The following use cases can take advantage of custom models for document processing:

- Build custom NER and text classification models based on open-source frameworks.

- Extract custom key values from documents for various industry verticals like insurance and healthcare.

- Tag and extract specific domain-dependent entities beyond the [prebuilt NER models](/azure/ai-services/luis/luis-concept-prebuilt-model) for domains like security or finance.

- Create custom tables from documents.

- Extract signatures.

- Label and classify emails or other documents based on content.

- Summarize documents or create custom question-and-answer models based on your data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

For this example workload, implementing each pillar depends on optimally configuring and using each component Azure service.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Availability

- For more information about the service-level agreements for each architecture component, see [Licensing documents](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

- For more information about configuration options to design high-availability applications with Storage accounts, see [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design).

#### Resiliency

- Address failure modes of individual services like Functions and Storage to help ensure resiliency of the compute services and data stores in this scenario. For more information, see [Reliability guides by service](/azure/reliability/overview-reliability-guidance).

- [Back up and recover your Document Intelligence models](/azure/ai-services/document-intelligence/how-to-guides/disaster-recovery).

- Back up and recover your custom [text classification models](/azure/ai-services/language-service/custom-text-classification/fail-over) and [NER models](/azure/ai-services/language-service/custom-named-entity-recognition/fail-over) in Language.

- Machine Learning depends on constituent services like Blob Storage, compute services, and AKS. To provide reliability for Machine Learning, configure each of these services to be reliable. For more information on designing for recovery, see [Failover for business continuity and disaster recovery (BCDR)](/azure/machine-learning/how-to-high-availability-machine-learning).

- For Azure OpenAI, help ensure continuous availability by provisioning two or more Azure OpenAI resources in different regions. This approach allows failover to another region if there's a problem. For more information, see [BCDR with Azure OpenAI](/azure/ai-services/openai/how-to/business-continuity-disaster-recovery).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Implement data protection, identity and access management, and network security recommendations for [Blob Storage](/azure/storage/blobs/security-recommendations), [AI services](/security/benchmark/azure/baselines/cognitive-services-security-baseline) for Document Intelligence and Language Studio, [Machine Learning](/security/benchmark/azure/baselines/machine-learning-security-baseline), and [Azure OpenAI](/security/benchmark/azure/baselines/azure-openai-security-baseline).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The total cost of implementing this solution depends on the pricing of the services that you choose.

The major costs for this solution include:

- The compute cost to train and deploy Machine Learning models.

    To help optimize costs, choose the right node type, cluster size, and number of nodes. Machine Learning provides options for training, such as setting the minimum number of compute cluster nodes to zero and defining the idle time before scaling down. For more information, see [Manage and optimize Machine Learning costs](/azure/machine-learning/how-to-manage-optimize-cost).

- Data orchestration duration and activities. For Azure Data Factory, the charges for copy activities on the Azure integration runtime are based on the number of data integration units used and the time taken to run the activities. Added orchestration activity runs are also charged, based on their number.

  Azure Logic Apps pricing plans depend on the resources that you create and use. The following articles can help you choose the right plan for specific use cases:

  - [Costs that typically accrue with Azure Logic Apps](/azure/logic-apps/plan-manage-costs#costs-that-typically-accrue-with-azure-logic-apps)

  - [Single-tenant versus multitenant environment for Azure Logic Apps](/azure/logic-apps/single-tenant-overview-compare)

  - [Usage metering, billing, and pricing models for Azure Logic Apps](/azure/logic-apps/logic-apps-pricing)

For more information about pricing for specific components, see the following resources:

- [Azure AI Document Intelligence pricing](https://azure.microsoft.com/pricing/details/ai-document-intelligence/)
- [Functions pricing](https://azure.microsoft.com/pricing/details/functions)
- [Azure Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/)
- [Azure Data Factory pricing](https://azure.microsoft.com/pricing/details/data-factory/data-pipeline)
- [Blob Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs)
- [Language pricing](https://azure.microsoft.com/pricing/details/cognitive-services/language-service)
- [Machine Learning pricing](https://azure.microsoft.com/pricing/details/machine-learning/#overview)
- [Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/cognitive-services/openai-service/)

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to add the component options that you choose and estimate the overall cost of the solution.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

#### Scalability

- To scale Functions automatically or manually, [choose the right hosting plan](/azure/azure-functions/functions-scale).

- By default, Document Intelligence supports 15 concurrent requests per second. To increase this quota, [create an Azure support ticket](/azure/azure-portal/supportability/how-to-create-azure-support-request).

- For Machine Learning custom models hosted as web services on AKS, the [azureml-fe](/azure/machine-learning/how-to-deploy-azure-kubernetes-service) front-end component automatically scales as needed. This component also routes incoming inference requests to deployed services.

- For deployments as managed endpoints, support autoscaling by integrating with the [Azure Monitor autoscale feature](/azure/azure-monitor/autoscale/autoscale-overview). For more information, see [Endpoints for inference in production](/azure/machine-learning/concept-endpoints).

- The API service limits on [custom NER](/azure/ai-services/language-service/custom-named-entity-recognition/service-limits#api-limits) and [custom text classification](/azure/ai-services/language-service/custom-text-classification/service-limits#api-limits) for inferencing are 20 GET or POST requests per minute.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- Dixit Arora | Senior Engineer
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624) | Principal Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Get started with custom projects in Document Intelligence Studio](/azure/ai-services/document-intelligence/quickstarts/try-document-intelligence-studio)
- [Use Document Intelligence models](/azure/ai-services/document-intelligence/how-to-guides/use-sdk-rest-api)
- [What is Azure AI Language?](/azure/ai-services/language-service/overview)
- [What is optical character recognition?](/azure/ai-services/computer-vision/overview-ocr)
- [How to configure Functions with a virtual network](/azure/azure-functions/configure-networking-how-to)

## Related resources

- [Extract text from objects by using Power Automate and AI Builder](../../example-scenario/ai/extract-object-text.yml)
- [Suggest content tags with NLP by using deep learning](../../data-guide/technology-choices/natural-language-processing.md)
