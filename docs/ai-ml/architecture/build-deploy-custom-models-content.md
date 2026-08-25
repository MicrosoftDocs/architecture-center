This article describes Azure solutions for building, training, deploying, and using custom document processing models. These Azure services also provide user interface (UI) capabilities for labeling or tagging text during processing.

## Architecture

:::image type="complex" border="false" source="_images/build-deploy-custom-models.svg" alt-text="Diagram that shows several alternatives for a custom document processing model build and deployment process." lightbox="_images/build-deploy-custom-models.svg":::
   This diagram shows several alternatives for a custom document processing model build and deployment process. This data flow begins with orchestrators, such as Azure Logic Apps, Azure Functions, or Azure Data Factory. These orchestrators ingest messages, email attachments, and files from sources like email servers, FTP servers, or web applications. The data is then stored in Azure Blob Storage or Azure Data Lake Storage and organized by attributes such as file extensions or customer details. Next, it's used to train custom models with tools like Document Intelligence Studio for extracting key-value pairs or classifying documents, Azure Language in Foundry Tools for custom named-entity recognition (NER), Azure Machine Learning for advanced workflows with frameworks like PyTorch or TensorFlow, or Azure OpenAI in Foundry Models for fine-tuning models for tasks like summarization or Q&A. Lastly, the trained models are deployed for inferencing by using SDKs, REST APIs, managed endpoints, or Azure Kubernetes Service (AKS), with support for real-time and batch inferencing.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/build-deploy-custom-models.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Orchestrators like Azure Logic Apps, Azure Data Factory, or Azure Functions ingest messages and attachments from email servers and files from file transfer protocol servers or web applications.

   - Azure Functions and Logic Apps enable serverless workloads. The service that you choose depends on your preference for service capabilities like development, connectors, management, and operational context. For more information, see [Compare Azure Functions and Logic Apps](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-azure-functions-and-azure-logic-apps).

   - Consider using Azure Data Factory to move data in bulk.

1. The orchestrators send ingested data to Azure Blob Storage or Azure Data Lake Storage. They organize the data within these stores based on characteristics like file extensions or customer details.

1. You can use the following Azure services, either independently or in combination, for tagging documents and building custom models to address various use cases.

   - [Document Intelligence Studio](https://documentintelligence.ai.azure.com/studio): If the document requires you to extract key-value pairs or create a custom table from an image or PDF, use Document Intelligence Studio to tag the data and train the custom model. If there's a requirement to identify the type of document, called *document classification*, before you invoke the correct extraction model, use Document Intelligence Studio to label the documents and build the models.

   - [Azure Language in Foundry Tools](https://ai.azure.com/): For domain-specific entity extraction like custom named-entity recognition (NER), you can [train a custom model](/azure/ai-services/language-service/custom-named-entity-recognition/quickstart?pivots=microsoft-foundry) to extract custom entity categories by using Microsoft Foundry.

   - [Azure Machine Learning studio](https://ml.azure.com/): For labeling data for text classification or entity extraction to use with open-source frameworks like PyTorch or TensorFlow, use [Machine Learning studio](/azure/machine-learning/how-to-train-with-ui), the [Python SDK, Azure CLI, or the REST API](/azure/machine-learning/how-to-train-model). Machine Learning studio provides a [model catalog](/azure/machine-learning/concept-model-catalog) of foundation models. These foundation models have fine-tuning capabilities for various tasks like text classification, question answering, and summarization. To fine-tune foundation models, use the [Machine Learning studio UI](/azure/machine-learning/how-to-use-foundation-models) or [code](https://github.com/Azure/azureml-examples/tree/main/sdk/python/foundation-models/system/finetune).

   - [Azure OpenAI in Foundry Models](/azure/ai-services/openai/concepts/fine-tuning-considerations): To [fine-tune Azure OpenAI models](/azure/ai-services/openai/how-to/fine-tuning) on your own data or domain for various tasks like text summarization and question answering, use the [Foundry portal](/azure/ai-services/openai/how-to/fine-tuning?branch=main&tabs=azure-openai%2Cpython-new&pivots=programming-language-studio), [Python SDK](/azure/ai-services/openai/how-to/fine-tuning?tabs=azure-openai%2Cpython-new&pivots=programming-language-python), or [REST API](/azure/ai-services/openai/how-to/fine-tuning?tabs=azure-openai%2Cpython-new&pivots=rest-api).

1. To deploy the custom models and use them for inferencing:

   - Azure Document Intelligence in Foundry Tools has built-in model deployment. Inferencing with the custom models is done by using [SDKs](/python/api/overview/azure/ai-documentintelligence-readme) or [document models REST API](/rest/api/aiservices/document-models/get-analyze-result). The [modelId](/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-model), or *model name*, specified during model creation is included in the request URL for document analysis. Azure Document Intelligence doesn't require any further deployment steps.

   - Foundry provides an option to [deploy custom language models](/azure/ai-services/language-service/custom-named-entity-recognition/how-to/deploy-model?tabs=azure-ai-foundry). Get the REST endpoint [prediction URL](/azure/ai-services/language-service/custom-named-entity-recognition/how-to/call-api) by selecting the model for deployment. You can run inference on models by using either the REST endpoint or the Azure SDK client libraries.

   - Machine Learning deploys custom models to online or batch [Machine Learning managed endpoints](/azure/machine-learning/concept-endpoints). Models deployed through managed compute can be inferenced by using managed endpoints, which include online endpoints for real-time inferencing and batch endpoints for batch inferencing. These custom models can also be deployed on [Azure Kubernetes Service (AKS) clusters](/azure/machine-learning/how-to-attach-kubernetes-anywhere?view=azureml-api-2).

   - Foundry provides multiple options to [deploy fine-tuned Azure OpenAI models](/azure/ai-foundry/openai/how-to/fine-tuning-deploy). You can deploy these models by using the Python SDK or REST API.

### Components

- [Logic Apps](/azure/logic-apps/logic-apps-overview) is part of [Azure Integration Services](/shows/azure-friday/an-overview-of-azure-integration-services). Logic Apps creates automated workflows that integrate apps, data, services, and systems. In this architecture, Logic Apps orchestrates the ingestion of documents and data from various sources and triggers downstream processes for document processing. Use [managed connectors](/azure/connectors/managed) for services like Azure Storage and Microsoft 365 to trigger workflows when a file arrives in the storage account or an email is received.

- [Azure Data Factory](/azure/data-factory/introduction) is a managed data integration service for orchestrating and automating data movement and transformation. In this architecture, Azure Data Factory adds [transformation activities](/azure/data-factory/transform-data) like invoking a REST endpoint or running a notebook on the ingested data to the pipeline.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless compute service that can host event-driven workloads that have short-lived processes. In this architecture, Functions enables workloads to process incoming documents and trigger model processing pipelines.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage solution for storing unstructured data. Blob Storage supports libraries for multiple languages, such as .NET, Node.js, and Python. Applications can access files on Blob Storage via HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) to support cost optimization for storing large amounts of data. In this architecture, this account is the solution for raw files that use a hot tier.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a scalable, cloud-based repository for storing and organizing large volumes of unstructured data. In this architecture, Data Lake Storage organizes and maintains large volumes of ingested data to support analytics, labeling, and machine learning workflows.

- [Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) is a component of [Foundry Tools](/azure/ai-services/what-are-ai-services). In this architecture, it provides built-in document analysis capabilities for extracting printed and handwritten text, tables, and key-value pairs. Azure Document Intelligence has prebuilt models for extracting data from invoices, documents, receipts, ID cards, and business cards. Azure Document Intelligence also has a [custom template](/azure/ai-services/document-intelligence/train/custom-template) form model and a [custom neural](/azure/ai-services/document-intelligence/train/custom-neural) document model that you can use to train and use custom models.

- [Document Intelligence Studio](/azure/ai-services/document-intelligence/studio-overview) provides an interface to explore Azure Document Intelligence features and models. Use the interface to label data and build custom document processing models.

- [Azure Language](/azure/ai-services/language-service/overview) provides natural language processing features like PII detection, language detection, prebuilt and customer NER, and text analytics for health.

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a managed machine learning platform for model development and deployment at scale. In this architecture, it labels data, trains custom models (including with open-source frameworks), and deploys the models for inference tasks.

  - Machine Learning studio provides data labeling options for [images](/azure/machine-learning/how-to-create-image-labeling-projects#image-labeling-capabilities) and [text](/azure/machine-learning/how-to-create-text-labeling-projects). It supports model training workflows within this architecture.

  - [Export labeled data](/azure/machine-learning/how-to-use-labeled-dataset#export-data-labels) as [COCO](https://cocodataset.org) or Machine Learning datasets. Use these datasets to train and deploy models in Machine Learning notebooks.

- [Azure OpenAI](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure) provides language and multimodal models through REST APIs. In this architecture, you fine-tune and deploy Azure OpenAI models for tasks such as text summarization and question answering.

### Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and their trade-offs.

- If the document is an image or a PDF, you can extract the data by using the [Azure Document Intelligence Read API](/azure/ai-services/document-intelligence/prebuilt/read), [Azure Content Understanding in Foundry Tools](/azure/ai-services/content-understanding/overview), or open-source libraries.

   - Azure Content Understanding is a service that uses generative AI to transform unstructured content across documents, audio, images, and video to structured outputs for multiple use cases like intelligent document processing, search and retrieval-augmented generation (RAG), robotic process automation (RPA), and analytics and reporting.

   - Use [Azure Content Understanding Studio](https://contentunderstanding.ai.azure.com/home) to create a custom analyzer by defining a field schema that extracts structured data from the document.

   - Create [custom classifiers](/azure/ai-services/content-understanding/how-to/classification-content-understanding-studio?tabs=portal%2Cstudio#step-1-create-a-basic-classifier) to classify documents into custom categories.

   - Route each category to a [custom analyzer](/azure/ai-services/content-understanding/how-to/classification-content-understanding-studio?tabs=portal%2Cstudio#step-2-classify-and-route-with-custom-analyzers) for field extraction. This approach combines classification and data extraction in a single pipeline.

- Choose between Azure Content Understanding services and a custom solution based on your business requirements. For more information, see [Choose the right tool for document processing](/azure/ai-services/content-understanding/choosing-right-ai-tool).

- Use the [Foundry (classic) portal](/azure/foundry-classic/what-is-foundry) to [fine-tune](/azure/foundry-classic/concepts/fine-tuning-overview) models for classification and custom text extraction from documents and to deploy these models.

## Scenario details

Document processing covers a wide range of tasks. It can be difficult to meet all your document processing needs by using the prebuilt models available in Language and Azure Document Intelligence. You might need to build custom models to automate document processing for different applications and domains.

Major challenges in model customization include:

- Labeling or tagging text data with relevant key-value pair entities to classify text for extraction.

- Managing training infrastructure, such as compute and storage, and their integrations.

- Deploying models at scale for applications to consume.

### Potential use cases

The following use cases can take advantage of custom models for document processing:

- Build custom NER and text classification models based on open-source frameworks.

- Extract custom key values from documents for various industry verticals like insurance and healthcare.

- Tag and extract specific domain-dependent entities beyond the [prebuilt NER models](/azure/ai-services/language-service/named-entity-recognition/concepts/named-entity-categories) for domains like security or finance.

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

- To improve the availability of an Azure Document Intelligence-based solution, create two different resources in separate regions. Orchestrate either a failover to the other region or split workloads between the regions. Ensure that the custom models and custom classifiers are in sync in both regions. You can achieve this synchronization by copying these custom models from one Azure Document Intelligence resource to another in a supported region by using the [Copy API](/azure/ai-services/document-intelligence/how-to-guides/disaster-recovery#copy-api-overview).

- When you build custom NER models by using Azure Language in Foundry Tools, [replicate your project from one region to another supported region](/azure/ai-services/language-service/custom-named-entity-recognition/fail-over). Project replication copies only project settings and tagged data, so train and deploy the model in the secondary project. During a regional outage, route requests to that deployment. This approach helps ensure high availability (HA).

- For more information about the service-level agreements for each architecture component, see [Licensing documents](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

- For more information about configuration options to design highly available applications with Storage accounts, see [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design).

#### Resiliency

- Address failure modes of individual services like Functions and Storage to help ensure resiliency of the compute services and data stores in this scenario. For more information, see [Reliability guides by service](/azure/reliability/overview-reliability-guidance).

- Machine Learning depends on constituent services like Blob Storage, compute services, and AKS. To provide reliability for Machine Learning, configure each of these services to be reliable. For more information on designing for recovery, see [Failover for business continuity and disaster recovery (BCDR)](/azure/machine-learning/how-to-high-availability-machine-learning).

- When you use Azure OpenAI models via Foundry, you must explicitly design resiliency by using deployments in multiple regions and failover strategies for [HA and disaster recovery (DR)](/azure/foundry/how-to/high-availability-resiliency). You can achieve this resiliency by deploying Azure OpenAI model endpoints across multiple Azure regions and by configuring explicit failover routing to maintain operations during a regional outage or capacity event.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Implement data protection, identity and access management, and network security recommendations for [Blob Storage](/azure/storage/blobs/security-recommendations), [Foundry Tools](/security/benchmark/azure/baselines/cognitive-services-security-baseline) for Azure Document Intelligence and Azure Language, [Azure AI workloads](/azure/security/fundamentals/ai-security-best-practices) for Machine Learning and Azure OpenAI.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The total cost of implementing this solution depends on the custom models training and inferencing solution that you choose.

- Azure Document Intelligence pricing includes the custom model training cost and the inferencing cost (for example, custom classification).

  If you build your own custom models for training, you pay the compute cost to train and deploy machine learning models. To help optimize costs, choose the right node type, cluster size, and number of nodes. Machine Learning provides options for training, such as setting the minimum number of compute cluster nodes to zero and defining the idle time before scaling down. For more information, see [Manage and optimize Machine Learning costs](/azure/machine-learning/how-to-manage-optimize-cost).

- Data orchestration duration and activities. For Azure Data Factory, the charges for copy activities on the Azure integration runtime are based on the number of data integration units used and the time taken to complete the activities. Added orchestration activity runs are also charged, based on their number.

  Logic Apps pricing plans depend on the resources that you create and use. The following articles can help you choose the right plan for specific use cases:

  - [Costs that typically accrue with Logic Apps](/azure/logic-apps/plan-manage-costs#costs-that-typically-accrue-with-azure-logic-apps)

  - [Single-tenant versus multitenant environment for Logic Apps](/azure/logic-apps/single-tenant-overview-compare)

  - [Usage metering, billing, and pricing models for Logic Apps](/azure/logic-apps/logic-apps-pricing)

To estimate the cost of this solution, use this [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/a87d001c7a4f49b28939a000899c1eed). Adjust the values to match your expected document processing volumes, model training frequency, and inference workload.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

#### Scalability

- To scale Functions automatically or manually, [choose the right hosting plan](/azure/azure-functions/functions-scale).

- On the Standard tier, Azure Document Intelligence allows 15 analyze transactions per second by default. To request a higher quota, [create an Azure support ticket](/azure/azure-portal/supportability/how-to-create-azure-support-request).

- For Machine Learning custom models hosted as web services on AKS, see [Machine Learning CLI and Python SDK v2](/azure/machine-learning/concept-v2?view=azureml-api-2).

- For deployments as managed endpoints, support autoscaling by integrating with the [Azure Monitor autoscale feature](/azure/azure-monitor/autoscale/autoscale-overview). For more information, see [Endpoints for inference in production](/azure/machine-learning/concept-endpoints).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- Dixit Arora | Senior Engineer
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624) | Sr. Account Executive

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Get started with custom projects in Document Intelligence Studio](/azure/ai-services/document-intelligence/quickstarts/try-document-intelligence-studio)
- [Use Azure Document Intelligence models](/azure/ai-services/document-intelligence/how-to-guides/use-sdk-rest-api)
- [What is Language?](/azure/ai-services/language-service/overview)
- [What is optical character recognition?](/azure/ai-services/computer-vision/overview-ocr)
- [How to configure Functions with a virtual network](/azure/azure-functions/configure-networking-how-to)

## Related resources

- [Extract text from objects by using Power Automate and AI Builder](../../example-scenario/ai/extract-object-text.yml)
- [Suggest content tags with NLP by using deep learning](../../data-guide/technology-choices/natural-language-processing.md)
