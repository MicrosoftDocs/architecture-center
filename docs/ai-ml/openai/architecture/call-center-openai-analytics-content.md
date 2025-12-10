This article describes how to extract insights from customer conversations at a call center by using Azure AI services and Azure OpenAI Service. Use these services to improve your customer interactions and satisfaction by analyzing call intent and sentiment, extracting key entities, and summarizing call content.

## Architecture

:::image type="content" source="_images/call-center-analytics.svg" alt-text="Diagram that shows the call center AI architecture." border="false" lightbox="_images/call-center-analytics.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/call-center-analytics.pptx) of this architecture.*

## Dataflow

1. A phone call between an agent and a customer is recorded and stored in Azure Blob Storage. Audio files are uploaded to an Azure Storage account via a supported method, such as the UI-based tool, [Azure Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer), or a [Storage SDK or API](/azure/storage/blobs/reference).

1. An Azure function is configured with one of the following triggers to start the intelligent transcription process:

   - [Timer trigger](/azure/azure-functions/functions-bindings-timer): Configure a time-based trigger to process a batch of audio files accumulated over a specified time period.

   - [Blob trigger](/azure/azure-functions/functions-bindings-storage-blob-trigger): Configure a blob trigger to initiate intelligent transcription as soon as an audio file is uploaded to the blob container.

1. The Azure function will trigger an Azure App Service which will execute the following steps in sequence:

   1. Call the Azure AI Speech to transcribe the files.

   1. Optionally, save this raw file in Azure blob storage for future reference.

   1. Pass the raw data to the Azure AI Language service to [detect and redact personal data](/azure/ai-services/language-service/personally-identifiable-information/how-to-call-for-conversations) in the transcript.

   1. Send the redacted data to the Azure OpenAI service to conduct various post call analytics like understand the intent and sentiment of the call, extract entities, or [summarize the conversation](/azure/ai-services/openai/quickstart#try-text-summarization) to evaluate the effectiveness of the call.

   1. Store the processed output in Azure Storage for visualization or consumption by downstream applications for further processing.

1. [Power BI](/power-bi/fundamentals/power-bi-overview) can be used to visualize the post call analytics on different criteria as required by the business use case. You can also store this output in a customer relationship management (CRM), so agents have contextual information about why the customer called and can quickly solve potential problems. This process is fully automated, which saves the agents time and effort.

### Components

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is the object storage solution for raw files in this scenario. Blob Storage supports libraries for languages like .NET, Node.js, and Python. Applications can access files on Blob Storage via HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) for storing large amounts of data, which optimizes cost.

- [Azure OpenAI](/azure/ai-foundry/openai/overview) provides access to the Azure OpenAI language models, including GPT-3, Codex, and the embeddings model series, for content generation, summarization, semantic search, and natural language-to-code translation. You can access the service through REST APIs, Python SDK, or the web-based interface in the [Azure OpenAI studio](https://oai.azure.com/).

- [Azure AI Speech](/azure/ai-services/speech-service/overview) is an AI-based API that provides speech capabilities like speech-to-text, text-to-speech, speech translation, and speaker recognition. This architecture uses the Azure AI Speech batch transcription functionality.

- [Azure AI Language](/azure/ai-services/language-service/overview) consolidates the Azure natural-language processing services. For more information about prebuilt and customizable options, see [Azure AI Language available features](/azure/ai-services/language-service/overview#available-features).

- [Language Studio](/azure/ai-services/language-service/language-studio) provides a UI for exploring and analyzing AI services for language features. Language Studio provides options for building, tagging, training, and deploying custom models.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a software-as-a-service (SaaS) that provides visual and interactive insights for business analytics. It provides transformation capabilities and connects to other data sources.

### Alternatives

Depending on your scenario, you can add the following workflows.

- Use [conversation summarization](/azure/ai-services/language-service/summarization/overview) by using the prebuilt model in Azure AI Language.
- Azure also offers Speech Analytics which provides the entire orchestration for post call analytics in batch.

## Scenario details

This solution uses Azure AI Speech to Text to convert call-center audio into written text. Azure AI Language redacts sensitive information in the conversation transcription. Azure OpenAI extracts insights from customer conversation to improve call center efficiency and customer satisfaction. Use this solution to process transcribed text, recognize and remove sensitive information, and run analytics on the extractions like reason for the call, resolution provided or not, sentiment of the call, listing product /service offering based on the number of queries/customer complaints, and so on. Scale the services and the pipeline to accommodate any volume of recorded data.

### Potential use cases

This solution provides value to organizations across multiple industries that have customer support agents. The post call analytics can help improve the company's products and services, and the effectiveness of the customer support systems. The solution applies to any organization that records conversations, including customer-facing agents, internal call centers, or support desks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Find the availability service-level agreement (SLA) for each component in [SLAs for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).
- To design high-availability applications with Storage accounts, see the [configuration options](/azure/storage/common/geo-redundant-design).
- To ensure resiliency of the compute services and datastores in this scenario, use failure mode for services like Azure Functions and Storage. For more information, see [Reliability guides by service](/azure/reliability/overview-reliability-guidance).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Implement data protection, identity and access management, and network security recommendations for [Blob Storage](/azure/storage/blobs/security-recommendations), [AI services](/security/benchmark/azure/baselines/cognitive-services-security-baseline), and [Azure OpenAI](/azure/ai-services/openai/how-to/managed-identity).
- [Configure AI services virtual networks](/azure/ai-services/cognitive-services-virtual-networks).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

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

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

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
