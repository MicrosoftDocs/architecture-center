This article describes how Azure AI services could be used both in real-time and post-call analytics scenarios for an Intelligent Contact Center. By combining It uses [Azure Speech](/azure/cognitive-services/speech-service/), [Azure Language](/azure/cognitive-services/language-service/) and [Azure OpenAI services ](/azure/cognitive-services/openai/overview)to extract rich insights from customer conversation, you can improve your that provides rich business insights, improving call center efficiency & customer satisfaction.

## Architecture

![](RackMultipart20230802-1-7i03i9_html_9a57caaa0db8d632.png)

![](RackMultipart20230802-1-7i03i9_html_e2433a1279c118e2.png)

## Workflow

1. [Azure OpenAI Service](/azure/cognitive-services/openai/overview) allows us to extract rich insights from customer conversation in the contact center. The first step begins with the collection of data. Calls between an agent and a customer are recorded and stored in Azure Storage. Audio files can be uploaded to an Azure Storage account via any supported method. You can use a UI-based tool like [Azure Storage Explorer](https://learn.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer) or use a [storage SDK or API](https://learn.microsoft.com/en-us/azure/storage/blobs/reference)

1. The workflow of transcription and analysis of a call helps in improving customer experience by providing business insights and suggesting actions to agents. Key technical components of this part of the workflow are:

2. The Aaudio files are then transcribed using [Azure Speech Service](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/) in [batch mode](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/batch-transcription) asynchronously with speaker diarization enabled and the transcription results are persisted inthe transcription results to the Azure Blob Storage.

3. Further, [PII detection and redaction](https://learn.microsoft.com/en-us/azure/cognitive-services/language-service/personally-identifiable-information/how-to-call-for-conversations) is done using [Azure Language Service](https://learn.microsoft.com/en-us/azure/cognitive-services/language-service/) to identify, categorize and redact sensitive information in the transcript.

For both batch mode transcription, and PII detection and redaction, the Azure Cognitive Services Ingestion client ([Ingestion Client with Azure Cognitive Services](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/ingestion-client)) can be used.

The Ingestion Client is a tool released by Microsoft for a call center transcription with a no-code approach.

4. The transcripts are then further processed to extract entities, [summarize conversation](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/quickstart?tabs=command-line&pivots=programming-language-studio#try-text-summarization)s, and analyze sentiments using [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/). and then tThe processed output is stored in Azure Blob Storage for extensive analytics and for visualization using other services. Optionally, output can be stored in any datastoreDB of your choice to keep track of metadata and any reporting needs. Also, Azure OpenAI service can also be used to process the relevant information from the stored transcriptions.

5. Typically, agents take multiple minutes to manually write down insights from customer conversation this data, but here, it is fully automated, which saves the agents time and efforta few minutes per call. The output can be visualized using [PowerBI](https://learn.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview) or a custom web application that's hosted by [App Service](https://learn.microsoft.com/en-us/azure/app-service/)for near real-time insights, so operators can understand what is happening in the contact center. Furthermore, this information can be stored in a CRM, so agents have contextual informationa rich view ofn why a customer called in the past and are able to solve problems quicker.

**Components**

- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is the object storage solution for raw files in this scenario. Blob Storage supports libraries for multiple languages, such as .NET, Node.js, and Python. Applications can access files on Blob Storage via HTTP/HTTPS. Blob Storage has [hot, cool, and archive access tiers](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview) to support cost optimization for storing large amounts of data.

- [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/overview) provides REST API access to OpenAI's powerful language models including the GPT-3, Codex and Embeddings model series for content generation, summarization, semantic search, and natural language to code translation. Users can access the service through REST APIs, Python SDK, or our web-based interface in the [Azure OpenAI Studio](https://oai.azure.com/).

- [Azure Cognitive Services Speech service.](https://azure.microsoft.com/services/cognitive-services/speech-services) Is an An AI-based API that provides speech capabilities like speech-to-text, text-to-speech, speech translation, and speaker recognition. Its batch transcription functionality is used in this


- [Azure Cognitive Service for Language](https://azure.microsoft.com/services/cognitive-services/language-service) consolidates the Azure natural language processing services. The suite offers prebuilt and customizable options. For more information, see the Cognitive Service for Language [available features](https://learn.microsoft.com/en-us/azure/cognitive-services/language-service/overview#available-features).

[Language Studio](https://aka.ms/languageStudio) provides a UI for exploring and analyzing Azure Cognitive Service for Language features. Language Studio also provides options for building, tagging, training, and deploying custom models.

- [Power BI](https://powerbi.microsoft.com/) is Azure software as a service (SaaS) for business analytics and visually immersive and interactive insights. It provides a rich set of connectors to various data sources, easy transformation capabilities, and sophisticated visualization.

**Alternatives**

You can add more workflows to this scenario based on specific use cases.

- You can do [conversation summarization](https://learn.microsoft.com/en-us/azure/cognitive-services/language-service/text-summarization/overview) by using the prebuilt model in Azure Cognitive Service for Language.
- You might be able to use [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-python?source=recommendations&pivots=python-mode-configuration) as a code-first integration tool to do text processing steps like text summarization on extracted data depending on the size and scale of the workload.
- You can use[Azure Speech Services](https://learn.microsoft.com/en-us/azure/architecture/solution-ideas/articles/speech-services) to transcribe calls and then run full-text searches, detect sentiment and language, and create custom language and acoustic models.
- You can deploy and implement a [custom speech-to-text solution.](https://learn.microsoft.com/en-us/azure/architecture/guide/ai/custom-speech-text-deploy)

**Scenario details**

Customer care centers are an integral part of the success of many businesses in many industries. This solution uses [Azure Speech](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/) to convert the audio into written text, [Azure Language](https://learn.microsoft.com/en-us/azure/cognitive-services/language-service/) to redact sensitive information in conversation transcription and [Azure OpenAI services ](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/overview)to extract rich insights from customer conversation that provides rich business insights, improving call center efficiency & customer satisfaction.

You can use the services and pipeline described here to process transcribed text to recognize and remove sensitive information, perform sentiment analysis, and more. You can scale the services and pipeline to accommodate any volume of recorded data.

**Potential use cases**

This solution can provide value to organizations in many industries, including telecommunications, financial services, and government. It applies to any organization that records conversations. In particular, customer-facing or internal call centers or support desks can benefit from the insights derived from this solution.

**Considerations**

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework).

For this example, workload implementing each pillar depends on optimally configuring and using each component Azure service.

**Reliability**

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/overview).

**Availability**

- See the availability service level agreements (SLAs) for each component Azure services:
  - Azure OpenAI Service – [SLA for Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/faq#what-are-the-slas-for-api-responses-in-azure-openai-)
  - Azure Speech Service - [SLA for Azure Speech Service](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1)
  - Azure Cognitive Service for Language - [SLA for Azure Cognitive Services](https://azure.microsoft.com/support/legal/sla/cognitive-services/v1_1)
  - Azure Functions - [SLA for Azure Functions](https://azure.microsoft.com/support/legal/sla/functions/v1_2)
  - Azure Storage - [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5/)
- For configuration options to design high availability applications with Azure storage accounts, see [Use geo-redundancy to design highly available applications](https://learn.microsoft.com/en-us/azure/storage/common/geo-redundant-design).
- Handle failure modes of individual services like Azure Functions and Azure Storage to ensure resiliency of the compute services and data stores in this scenario. For more information, see [Resiliency checklist for specific Azure services](https://learn.microsoft.com/en-us/azure/architecture/checklist/resiliency-per-service).
- For Form Recognizer, [back up and recover your Form Recognizer models](https://learn.microsoft.com/en-us/azure/applied-ai-services/form-recognizer/disaster-recovery).

**Security**

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/security/overview).

- Implement data protection, identity and access management, and network security recommendations for [Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/security-recommendations), [Cognitive Services](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/cognitive-services-security-baseline) and [Azure Open AI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/managed-identity).
- [Azure Cognitive Services Virtual network configuration](https://learn.microsoft.com/en-us/azure/cognitive-services/cognitive-services-virtual-networks?context=%2Fazure%2Fcognitive-services%2Fopenai%2Fcontext%2Fcontext&tabs=portal)

**Cost optimization**

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/cost/overview).

The total cost of implementing this solution depends on the pricing tier of the services you choose.

Many factors that can affect the price of each component:

- The number of documents that you process
- The number of concurrent requests that your application receives
- The size of the data that you store after processing
- Your deployment region

For more information on pricing for specific components, see the following resources:

- [Azure OpenAI Service pricing](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/#:~:text=Pricing%20details%3A%20%20%20%20Instance%20%20,%20%240.54%20%2Fhour%20%206%20more%20rows%20)
- [Azure Blob Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs)
- [Language Service pricing](https://azure.microsoft.com/pricing/details/cognitive-services/language-service)
- [Azure Machine Learning pricing](https://azure.microsoft.com/pricing/details/machine-learning/#overview)

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to add your selected component options and estimate the overall solution cost.

**Performance efficiency**

Performance efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](https://learn.microsoft.com/en-us/azure/architecture/framework/scalability/overview).

Periods when this solution processes high volumes can expose performance bottlenecks. Make sure that you understand and plan for the [scaling options for](https://learn.microsoft.com/en-us/azure/azure-functions/functions-scale#scale)[Cognitive Services autoscaling](https://learn.microsoft.com/en-us/azure/cognitive-services/autoscale?tabs=portal)to ensure proper performance efficiency for your solution .

The batch speech API is designed for high volume, but other Cognitive Services APIs might have request limits for each subscription tier. Consider containerizing these APIs to avoid throttling large-volume processing.Containers give you flexibility in deployment, in the cloud or on-premises. You can also mitigate side effects of new version rollouts by using containers. For more information, see [Container support in Azure Cognitive Services](https://learn.microsoft.com/en-us/azure/cognitive-services/cognitive-services-container-support).

## Next steps

- [What is Azure Speech Service?](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/overview)
- [What is Azure OpenAI Service?](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/overview)
- [What is Azure Machine Learning?](https://learn.microsoft.com/en-us/azure/machine-learning/overview-what-is-azure-ml)
- [Introduction to Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)
- [What is Azure Cognitive Service for Language?](https://learn.microsoft.com/en-us/azure/cognitive-services/language-service/overview)
- [Introduction to Azure Data Lake Storage Gen2](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)
- [What is Power BI?](https://learn.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview)
- [Ingestion Client with Azure Cognitive Services?](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/ingestion-client)

## Related resources

- [Post-call transcription and analytics](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/call-center-quickstart)
- [Use a speech-to-text transcription pipeline to analyze recorded conversations](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/ai/speech-to-text-transcription-analytics)
- [Deploy a custom speech-to-text solution](https://learn.microsoft.com/en-us/azure/architecture/guide/ai/custom-speech-text-deploy)
- [Azure Speech Services and create custom language and acoustic models](https://learn.microsoft.com/en-us/azure/architecture/solution-ideas/articles/speech-services)