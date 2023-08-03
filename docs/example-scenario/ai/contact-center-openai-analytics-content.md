This article describes how to extract insights from customer conversations at a contact center by using Azure AI services and Azure OpenAI Service. Use these real-time and post-call analytics to improve call center efficiency and customer satisfaction.

## Architecture

:::image type="content" source="./media/call-center-analytics.svg" alt-text="Diagram that shows the contact center AI architecture." border="false" lightbox="./media/call-center-analytics.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/call-center-analytics.pptx) of this architecture.*

## Dataflow

1. A phone call between an agent and a customer is recorded and stored in Azure Blob Storage. Audio files are uploaded to an Azure Storage account via a supported method, such as the UI-based tool, [Azure Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer), or a [Storage SDK or API](/azure/storage/blobs/reference).

1. Audio files are transcribed by using [Azure AI Speech](/azure/ai-services/speech-service/overview) in [batch mode](/azure/ai-services/speech-service/batch-transcription) asynchronously with speaker diarization enabled. The transcription results are persisted in Blob Storage.

1. [Personal data detection and redaction](/azure/ai-services/language-service/personally-identifiable-information/how-to-call-for-conversations) is performed by using [Azure AI Language](/azure/ai-services/language-service/overview) to identify, categorize, and redact sensitive information in the transcript.

   For batch mode transcription and personal data detection and redaction, use the [AI services Ingestion Client tool](/azure/ai-services/speech-service/ingestion-client). The Ingestion Client tool uses a no-code approach to call center transcription.

1. The transcript is processed to extract entities, [summarize the conversation](/azure/ai-services/openai/quickstart?tabs=command-line&pivots=programming-language-studio#try-text-summarization), and analyze sentiments by using [Azure OpenAI](/azure/ai-services/openai/overview). The processed output is stored in Blob Storage and then analyzed and visualized by using other services. You can also store the output in a datastore for keeping track of metadata and for reporting needs. Use Azure OpenAI to process the stored transcription information.

1. The output is visualized by using [Power BI](/power-bi/fundamentals/power-bi-overview) or a custom web application that's hosted by [App Service](/azure/app-service/overview). Both options provide near real-time insights. You can store this output in a CRM, so agents have contextual information about why the customer called and can quickly solve potential problems. This process is fully automated, which saves the agents time and effort.

### Components

- [Blob Storage](https://azure.microsoft.com/products/storage/blobs) is the object storage solution for raw files in this scenario. Blob Storage supports libraries for languages like .NET, Node.js, and Python. Applications can access files on Blob Storage via HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) for storing large amounts of data, which optimizes cost.

- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service) provides REST API access to the Azure OpenAI language models, including GPT-3, Codex, and the embeddings model series, for content generation, summarization, semantic search, and natural language-to-code translation. Users can access the service through REST APIs, Python SDK, or the web-based interface in the [Azure OpenAI Studio](https://oai.azure.com/).

- [Azure AI Speech](https://azure.microsoft.com/products/ai-services/ai-speech) is an AI-based API that provides speech capabilities like speech-to-text, text-to-speech, speech translation, and speaker recognition. This architecture uses the Azure AI Speech batch transcription functionality.

- [Azure AI Language](https://azure.microsoft.com/products/ai-services/ai-language) consolidates the Azure natural-language processing services. For information about prebuilt and customizable options, see [Azure AI Language available features](/azure/ai-services/language-service/overview#available-features).

- [Language Studio](https://aka.ms/languageStudio) provides a UI for exploring and analyzing AI services for language features. Language Studio provides options for building, tagging, training, and deploying custom models.

- [Power BI](https://powerbi.microsoft.com) is a software-as-a-service (SaaS) that provides visual and interactive insights for business analytics. It provides transformation capabilities and connects to other data sources.

### Alternatives

Depending on your scenario, you can add the following workflows.

- Perform [conversation summarization](/azure/ai-services/language-service/summarization/overview) by using the prebuilt model in Azure AI Language.
- Depending on the size and scale of your workload, you can use [Azure Functions](/azure/azure-functions/create-first-function-vs-code-python?source=recommendations&pivots=python-mode-configuration) as a code-first integration tool to perform text-processing steps, like text summarization on extracted data.
- Use [Azure AI Speech](/azure/architecture/solution-ideas/articles/speech-services) to transcribe calls, run full-text searches, detect sentiment and language, and create custom language and acoustic models.
- Deploy and implement a [custom speech-to-text solution](/azure/architecture/guide/ai/custom-speech-text-deploy).

## Scenario details

This solution uses Azure AI Speech to convert audio into written text. Azure AI Language redacts sensitive information in the conversation transcription. Azure OpenAI extracts insights from customer conversation to improve call center efficiency and customer satisfaction. Use this solution to process transcribed text, recognize and remove sensitive information, and perform sentiment analysis. Scale the services and the pipeline to accommodate any volume of recorded data.

### Potential use cases

This solution provides value to organizations in industries like telecommunications, financial services, and government. It applies to any organization that records conversations. Customer-facing or internal call centers or support desks benefit from using this solution.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Find the availability service level agreement (SLA) for each component in [SLAs for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).
- To design high-availability applications with Storage accounts, see [the configuration options](/azure/storage/common/geo-redundant-design).
- To ensure resiliency of the compute services and datastores in this scenario, use failure mode for services like Azure Functions and Storage. For more information, see the [resiliency checklist for Azure services](/azure/architecture/checklist/resiliency-per-service).
- [Back up and recover your Form Recognizer models](/azure/applied-ai-services/form-recognizer/disaster-recovery).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Implement data protection, identity and access management, and network security recommendations for [Blob Storage](/azure/storage/blobs/security-recommendations), [AI services](/security/benchmark/azure/baselines/cognitive-services-security-baseline), and [Azure Open AI](/azure/ai-services/openai/how-to/managed-identity).
- [Configure AI services virtual networks](/azure/ai-services/cognitive-services-virtual-networks).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The total cost of this solution depends on the pricing tier of your services. Factors that can affect the price of each component are:

- The number of documents that you process.
- The number of concurrent requests that your application receives.
- The size of the data that you store after processing.
- Your deployment region.

For more information, see the following resources:

- [Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/cognitive-services/openai-service)
- [Blob Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs)
- [Azure AI Language pricing](https://azure.microsoft.com/pricing/details/cognitive-services/language-service)
- [Azure Machine Learning pricing](https://azure.microsoft.com/pricing/details/machine-learning)

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate your solution cost.

### Performance efficiency

Performance efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

When high volumes of data are processed, it can expose performance bottlenecks. To ensure proper performance efficiency, understand and plan for the [scaling options](/azure/azure-functions/functions-scale#scale) to use with the [AI services autoscale feature](/azure/ai-services/autoscale).

The batch speech API is designed for high volumes, but other AI services APIs might have request limits depending on the subscription tier. Consider containerizing AI services APIs to avoid slowing down large-volume processing. Containers provide deployment flexibility in the cloud and on-premises. Mitigate side effects of new version rollouts by using containers. For more information, see [Container support in AI services](/azure/ai-services/cognitive-services-container-support).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- Dixit Arora | Senior Customer Engineer, FastTrack for Azure
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure AI Speech?](/azure/ai-services/speech-service/overview)
- [What is Azure OpenAI?](/azure/ai-services/openai/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Azure AI Language?](/azure/ai-services/language-service/overview)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Ingestion Client with AI services](/azure/ai-services/speech-service/ingestion-client)
- [Post-call transcription and analytics](/azure/ai-services/speech-service/call-center-quickstart)

## Related resources

- [Use a speech-to-text transcription pipeline to analyze recorded conversations](/azure/architecture/example-scenario/ai/speech-to-text-transcription-analytics)
- [Deploy a custom speech-to-text solution](/azure/architecture/guide/ai/custom-speech-text-deploy)
- [Create custom language and acoustic models](/azure/architecture/solution-ideas/articles/speech-services)