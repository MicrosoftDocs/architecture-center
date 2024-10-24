This article describes how to extract insights from customer conversations at a call center by using Azure AI services and Azure OpenAI Service. Get insights on the products and service offerings, improving call- center efficiency and customer satisfaction.

## Architecture

:::image type="content" source="_images/call-center-analytics.svg" alt-text="Diagram that shows the call center AI architecture." border="false" lightbox="_images/call-center-analytics.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/call-center-analytics.pptx) of this architecture.*

## Dataflow

1. A phone call between an agent and a customer is recorded and stored in Azure Blob Storage. Audio files are uploaded to an Azure Storage account via a supported method, such as the UI-based tool, [Azure Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer), or a [Storage SDK or API](/azure/storage/blobs/reference).

1. [Azure function](azure/azure-functions/functions-overview) can be configured with two types of triggers to start the intelligent transcription process

   - [Timer trigger](/azure/azure-functions/functions-bindings-timer): To process a batch of audio files accumulated over a specified time period, a time-based trigger needs to be configured. 

   - [Blob trigger](zure/azure-functions/functions-bindings-storage-blob-trigger): To initiate intelligent transcription as soon as an audio file is uploaded to the blob container, a blob trigger needs to be set up. 

1. The azure function will trigger a [App Service](/azure/app-service/overview) which will execute the following steps in sequence:

   - Call [Azure AI Speech to text service](/azure/ai-services/speech-service/overview)  (Azure speech to text service batch API) to transcribe the file(s).  In [Batch transcription](/azure/ai-services/speech-service/batch-transcription), you may pass a list of urls of audio files (time-based trigger) or a single url (for Blob trigger) as the [payload](/azure/ai-services/speech-service/batch-transcription-create?pivots=rest-api#create-a-transcription-job). 
You must also define a “locale”, the expected language of conversation. If the conversations are multi-lingual in nature, the expected languages can also be passed as a list in the payload using the [languageIdentification](/azure/ai-services/speech-service/language-identification?tabs=once&pivots=programming-language-python#implement-speech-to-text-batch-transcription) property. The languages and supported locales can be found here. You can also use a [custom model](azure/ai-services/speech-service/batch-transcription-create?pivots=rest-api#use-a-custom-model) along with the batch transcription API using the “model” property. Details on different configuration options while using batch transcription API can be found [here](azure/ai-services/speech-service/batch-transcription-create?pivots=rest-api#request-configuration-options).

   - Optionally, save this raw file in the [Azure blob container](azure/storage/blobs/storage-blobs-introduction) for future reference if it needs to be accessible later by specifying a [destination container url](azure/ai-services/speech-service/batch-transcription-create?pivots=rest-api#specify-a-destination-container-url) while calling the batch transcription API.  
While retrieving the transcription results, first check the status of the transcription using [GET](azure/ai-services/speech-service/batch-transcription-get?pivots=rest-api#get-transcription-status) operation.  If the “status” is “Succeeded” you can get the transcribed files urls  corresponding to the audio files using a [GET](azure/ai-services/speech-service/batch-transcription-get?pivots=rest-api#get-transcription-status) request.

   - Pass the raw data to the [Azure AI Language service](/azure/ai-services/language-service/overview) to [detect and redact personal data](/azure/ai-services/language-service/personally-identifiable-information/how-to-call-for-conversations)in the transcript. 

   - Send the PII redacted data to the [Azure OpenAI](/azure/ai-services/openai/overview) to perform various post call analytics like understand the intent of the call, extract entities, [summarize the conversation](/azure/ai-services/openai/quickstart?tabs=command-line&pivots=programming-language-studio#try-text-summarization), analyse the sentiments and thereby evaluating the effectiveness of the call etc. 


   - The processed output is further stored in the Azure Storage account for visualization or consumption by downstream applications for further processing.

1. [Power BI](/power-bi/fundamentals/power-bi-overview) can be used to visualize the post call analytics on different criteria as required by the business use case. You can also store this output in a customer relationship management (CRM), so agents have contextual information about why the customer called and can quickly solve potential problems. This process is fully automated, which saves the agents time and effort. 

### Components

- [Blob Storage](https://azure.microsoft.com/products/storage/blobs) is the object storage solution for raw files in this scenario. Blob Storage supports libraries for languages like .NET, Node.js, and Python. Applications can access files on Blob Storage via HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) for storing large amounts of data, which optimizes cost.

- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service) provides access to the Azure OpenAI language models, including GPT-3, Codex, and the embeddings model series, for content generation, summarization, semantic search, and natural language-to-code translation. You can access the service through REST APIs, Python SDK, or the web-based interface in the [Azure OpenAI Studio](https://oai.azure.com/).

- [Azure AI Speech](https://azure.microsoft.com/products/ai-services/ai-speech) is an AI-based API that provides speech capabilities like speech-to-text, text-to-speech, speech translation, and speaker recognition. This architecture uses the Azure AI Speech batch transcription functionality.

- [Azure AI Language](https://azure.microsoft.com/products/ai-services/ai-language) consolidates the Azure natural-language processing services. For information about prebuilt and customizable options, see [Azure AI Language available features](/azure/ai-services/language-service/overview#available-features).

- [Language Studio](https://aka.ms/languageStudio) provides a UI for exploring and analyzing AI services for language features. Language Studio provides options for building, tagging, training, and deploying custom models.

- [Power BI](https://powerbi.microsoft.com) is a software-as-a-service (SaaS) that provides visual and interactive insights for business analytics. It provides transformation capabilities and connects to other data sources.

### Alternatives

Depending on your scenario, you can add the following workflows.

- Perform [conversation summarization](/azure/ai-services/language-service/summarization/overview) by using the prebuilt model in Azure AI Language.
- Azure also offers Speech Analytics (currently in Preview) which provides the entire orchestration for post call analytics in batch.

## Scenario details

This solution uses Azure AI Speech to Text (Batch transcription) to convert audio into written text. Azure AI Language redacts sensitive information in the conversation transcription. Azure OpenAI extracts insights from customer conversation to improve call center efficiency and customer satisfaction. Use this solution to process transcribed text, recognize and remove sensitive information, and perform analytics on the extractions like reason for the call, resolution provided or not, sentiment of the call, listing product /service offering based on the number of queries/customer complaints etc. Scale the services and the pipeline to accommodate any volume of recorded data.

### Potential use cases

This solution provides value to organizations offering products and/or services to customers which has customer support agents /solutions in place across all industry verticals. The post call analytics can help in improving the products & service offerings, the efficiency of the customer support systems in place etc.  It applies to any organization that records conversations. Customer-facing or internal call centers or support desks benefit from using this solution.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Find the availability service-level agreement (SLA) for each component in [SLAs for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).
- To design high-availability applications with Storage accounts, see the [configuration options](/azure/storage/common/geo-redundant-design).
- To ensure resiliency of the compute services and datastores in this scenario, use failure mode for services like Azure Functions and Storage. For more information, see the [resiliency checklist for Azure services](/azure/architecture/checklist/resiliency-per-service).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Implement data protection, identity and access management, and network security recommendations for [Blob Storage](/azure/storage/blobs/security-recommendations), [AI services](/security/benchmark/azure/baselines/cognitive-services-security-baseline), and [Azure OpenAI](/azure/ai-services/openai/how-to/managed-identity).
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

The batch speech API is designed for high volumes, but other AI services APIs might have request limits, depending on the subscription tier. Consider containerizing AI services APIs to avoid slowing down large-volume processing. Containers provide deployment flexibility in the cloud and on-premises. Mitigate side effects of new version rollouts by using containers. For more information, see [Container support in AI services](/azure/ai-services/cognitive-services-container-support).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

<!-- docutune:ignoredChange ISV -->

Principal authors:

- Dixit Arora | Senior Customer Engineer, ISV DN CoE
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624) | Principal Customer Engineer, ISV DN CoE

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

## Related resource

- [Create custom language and acoustic models](/azure/ai-services/speech-service/how-to-custom-speech-train-model)
