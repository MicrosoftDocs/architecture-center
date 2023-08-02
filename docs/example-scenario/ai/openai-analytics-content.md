This article describes how to extract insights from customer conversations at a contact center by using Azure AI services. Use these real-time and post-call analytics to improve call center efficiency and customer satisfaction.

## Architecture

![](RackMultipart20230802-1-7i03i9_html_9a57caaa0db8d632.png)

![](RackMultipart20230802-1-7i03i9_html_e2433a1279c118e2.png)

## Workflow

1. Phone calls between an agent and a customer are recorded and stored in Azure Storage. Audio files are uploaded to a Storage account via a supported method, such as a UI-based tool like [Azure Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer) or a [storage SDK or API](/azure/storage/blobs/reference).

1. Audio files are transcribed by using [Azure Speech service](/azure/cognitive-services/speech-service/) in [batch mode](/azure/cognitive-services/speech-service/batch-transcription) asynchronously with speaker diarization enabled. The transcription results are persisted in Azure Blob Storage.

1. [Personally identifiable information detection and redaction](/azure/cognitive-services/language-service/personally-identifiable-information/how-to-call-for-conversations) is performed by using [Azure Language service](/azure/cognitive-services/language-service/) to identify, categorize, and redact sensitive information in the transcript.

   For batch mode transcription and personally identifiable information detection and redaction, use the [AI services Ingestion Client tool](/azure/cognitive-services/speech-service/ingestion-client). The Ingestion Client tool uses a no-code approach to call center transcription.

1. The transcripts are processed to extract entities, [summarize conversations](/azure/cognitive-services/openai/quickstart?tabs=command-line&pivots=programming-language-studio#try-text-summarization), and analyze sentiments by using [Azure OpenAI](/azure/cognitive-services/openai/). The processed output is stored in Blob Storage and then analyzed and visualized by using other services. You can also store the output in a datastore to keep track of metadata and for reporting needs. Use Azure OpenAI to process the information from the stored transcriptions.

1. The output is visualized by using [Power BI](/power-bi/fundamentals/power-bi-overview) or a custom web application that's hosted by [App Service](/azure/app-service/). Both options provide near real-time insights. You can store this output in a CRM, so agents have contextual information about reasons why a customer called and can quickly solve problems. This process is fully automated, which saves the agents time and effort.

## Components

- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is the object storage solution for raw files in this scenario. Blob Storage supports libraries for languages like .NET, Node.js, and Python. Applications can access files on Blob Storage via HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) for storing large amounts of data, which optimizes cost.

- [Azure OpenAI](/azure/ai-services/openai/overview) provides REST API access to the Azure OpenAI language models, including the GPT-3 model, the Codex model, and embeddings model series, for content generation, summarization, semantic search, and natural language-to-code translation. Users can access the service through REST APIs, Python SDK, or the web-based interface in the [Azure OpenAI Studio](https://oai.azure.com/).

- [AI services Speech service](https://azure.microsoft.com/services/cognitive-services/speech-services) is an an AI-based API that provides speech capabilities like speech-to-text, text-to-speech, speech translation, and speaker recognition. This architecture uses the Speech service batch transcription functionality.

- [AI services Language service](https://azure.microsoft.com/services/cognitive-services/language-service) consolidates the Azure natural-language-processing services. The suite offers prebuilt and customizable options. For more information, see the [AI services for language available features](/azure/cognitive-services/language-service/overview#available-features).

- [Language Studio](https://aka.ms/languageStudio) provides a UI for exploring and analyzing AI services for Language features. Language Studio provides options for building, tagging, training, and deploying custom models.

- [Power BI](https://powerbi.microsoft.com/) is a software-as-a-service (SaaS) for business analytics that provides visual and interactive insights. It provides connectors to various data sources, transformation capabilities, and sophisticated visualization.

## Alternatives

You can add more workflows to this scenario based on specific use cases.

- You can do [conversation summarization](/azure/cognitive-services/language-service/text-summarization/overview) by using the prebuilt model in AI services for Language.
- Depending on the size and scale of your workload, you can use [Azure Functions](/azure/azure-functions/create-first-function-vs-code-python?source=recommendations&pivots=python-mode-configuration) as a code-first integration tool to do the text-processing steps like text summarization on extracted data .
- You can use [AI services Speech service](/azure/architecture/solution-ideas/articles/speech-services) to transcribe calls, run full-text searches, detect sentiment and language, and create custom language and acoustic models.
- Deploy and implement a [custom speech-to-text solution](/azure/architecture/guide/ai/custom-speech-text-deploy).

## Scenario details

Customer care centers are an integral part of the success of many businesses in many industries. This solution uses [Speech service](/azure/cognitive-services/speech-service/) to convert the audio into written text. [Azure Language](/azure/cognitive-services/language-service/) redacts sensitive information in the conversation transcription. Azure OpenAI extracts insights from customer conversation to improve call center efficiency and customer satisfaction. Use this solution to process transcribed text, recognize and remove sensitive information, and perform sentiment analysis. Scale the services and the pipeline to accommodate any volume of recorded data.

### Potential use cases

This solution provides value to organizations in industries like telecommunications, financial services, and government. It applies to any organization that records conversations. Customer-facing or internal call centers or support desks benefit from the insights of this solution.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

For this example, workload implementing each pillar depends on optimally configuring and using each component Azure service.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Availability

- See the availability service level agreements (SLA) for each component:
  - [SLA for Azure OpenAI](/azure/cognitive-services/openai/faq#what-are-the-slas-for-api-responses-in-azure-openai-)
  - [SLA for Azure Speech Service](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1)
  - AI services for Language - [SLA for AI services](https://azure.microsoft.com/support/legal/sla/cognitive-services/v1_1)
  - [SLA for Azure Functions](https://azure.microsoft.com/support/legal/sla/functions/v1_2)
  - [SLA for Storage accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5/)
- To design high-availability applications with Storage accounts, see the configuration options in [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design).
- To ensure resiliency of the compute services and datastores in this scenario, use failure mode for services like Azure Functions and Storage. For more information, see [Resiliency checklist for Azure services](/azure/architecture/checklist/resiliency-per-service).
- [Back up and recover your Form Recognizer models](/azure/applied-ai-services/form-recognizer/disaster-recovery).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Implement data protection, identity and access management, and network security recommendations for [Blob Storage](/azure/storage/blobs/security-recommendations), [AI services](/security/benchmark/azure/baselines/cognitive-services-security-baseline), and [Azure Open AI](/azure/cognitive-services/openai/how-to/managed-identity).
- [Configure AI services virtual network](/azure/cognitive-services/cognitive-services-virtual-networks?context=%2Fazure%2Fcognitive-services%2Fopenai%2Fcontext%2Fcontext&tabs=portal).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The total cost of this solution depends on the pricing tier of the services that you choose.

Factors that can affect the price of each component are:

- The number of documents that you process.
- The number of concurrent requests that your application receives.
- The size of the data that you store after processing.
- Your deployment region.

For more information on pricing for components, see the following resources:

- [Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/cognitive-services/openai-service)
- [Blob Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs)
- [Language service pricing](https://azure.microsoft.com/pricing/details/cognitive-services/language-service)
- [Azure Machine Learning pricing](https://azure.microsoft.com/pricing/details/machine-learning/#overview)

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate your solution cost.

### Performance efficiency

Performance efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Periods when this solution processes high volumes can expose performance bottlenecks. Make sure that you understand and plan for the [scaling options for](/azure/azure-functions/functions-scale#scale)[Cognitive Services autoscaling](/azure/cognitive-services/autoscale?tabs=portal)to ensure proper performance efficiency for your solution .

The batch speech API is designed for high volume, but other Cognitive Services APIs might have request limits for each subscription tier. Consider containerizing these APIs to avoid throttling large-volume processing.Containers give you flexibility in deployment, in the cloud or on-premises. You can also mitigate side effects of new version rollouts by using containers. For more information, see [Container support in AI services](/azure/cognitive-services/cognitive-services-container-support).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Dixit Arora](http://linkedin.com/ProfileURL) | Senior Customer Engineer
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624) | Principal Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Speech Service?](/azure/cognitive-services/speech-service/overview)
- [What is Azure OpenAI?](/azure/ai-services/openai/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What are AI services for Language?](/azure/cognitive-services/language-service/overview)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Ingestion Client with AI services?](/azure/cognitive-services/speech-service/ingestion-client)
- [Post-call transcription and analytics](/azure/cognitive-services/speech-service/call-center-quickstart)

## Related resources

- [Use a speech-to-text transcription pipeline to analyze recorded conversations](/azure/architecture/example-scenario/ai/speech-to-text-transcription-analytics)
- [Deploy a custom speech-to-text solution](/azure/architecture/guide/ai/custom-speech-text-deploy)
- [Azure Speech Services and create custom language and acoustic models](/azure/architecture/solution-ideas/articles/speech-services)