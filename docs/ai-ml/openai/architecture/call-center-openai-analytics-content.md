This article describes a batch processing architecture that extracts insights from customer conversations in a call center. The solution uses Foundry Tools and Azure OpenAI to analyze post-call transcripts after calls complete rather than in near real-time. With this approach, you can analyze call intent and sentiment, extract key entities, and summarize calls offline to help improve customer interactions and satisfaction.

## Architecture

:::image type="complex" border="false" source="_images/call-center-analytics.svg" alt-text="Diagram that shows the call center AI architecture." lightbox="_images/call-center-analytics.svg":::
   The architecture diagram shows the post‑call analytics workflow. In step 1, a caller connects to a call center agent through a person‑to‑person conversation line, and both connect to a telephony server. An arrow labeled file upload points from the telephony server to Azure Blob Storage to store recorded audio files. In step 2, Azure Speech batch transcription reads the audio files from Blob Storage and writes the transcription results back into Storage. In step 3, language enrichment processes the transcripts. In step 4, the App Service app sends the enriched transcripts to Azure OpenAI for analysis. In step 5, the processed analytics data flows from Blob Storage to three destinations in the interact and visualize section: Power BI for insights visualization, a web app, and a customer relationship management (CRM) system that displays call summaries, call reasons, and detailed call history.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/call-center-analytics.pptx) of this architecture.*

## Data flow

1. The telephony server records a phone call between an agent and a customer and stores it in Azure Blob Storage. You upload audio files to an Azure Storage account via a supported method, such as the UI-based tool [Azure Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer), or a [Storage SDK or API](/azure/storage/blobs/reference).

1. You configure an Azure function with one of the following triggers to start the intelligent transcription process:

   - **[Timer trigger](/azure/azure-functions/functions-bindings-timer):** Configure a time-based trigger to process a batch of audio files accumulated over a specified time period.

   - **[Blob trigger](/azure/azure-functions/functions-bindings-storage-blob-trigger):** Configure a blob trigger to initiate intelligent transcription when you upload an audio file to the blob container.

1. The Azure function triggers an Azure App Service app that runs the following steps in sequence. It calls [Azure Speech batch transcription](/azure/ai-services/speech-service/batch-transcription) to transcribe the audio files and optionally saves the raw transcription file in Blob Storage for future reference. The App Service app passes the raw data to Azure Language to [detect and redact personal data](/azure/ai-services/language-service/how-to-call-for-conversations) in the transcript.

1. The App Service app sends the redacted data to Azure OpenAI text processing models such as GPT-4o models to perform various post-call analytics, including identifying call intent and sentiment, extracting entities, or summarizing the conversation to evaluate the call's effectiveness. The solution stores the processed output in Azure Storage for visualization or consumption by downstream applications or other datastores used for reporting.

1. [Power BI](/power-bi/fundamentals/power-bi-overview) visualizes the post-call analytics based on the criteria that the business defines. You can also store this output in a customer relationship management (CRM) system, so agents have contextual information about why the customer called and can quickly solve potential problems. This automated process saves agents time and effort.

### Components

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage service that supports libraries for languages such as .NET, Node.js, and Python. Applications can access files on Blob Storage by using HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) to store large amounts of data and optimize cost. In this architecture, Blob Storage stores raw audio files and processed outputs.

- [Foundry Models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure) is a service that provides access to multiple models that have different capabilities, including language models, audio models, image and video generation models, and embeddings models. You can access the service through REST APIs, SDKs, or the Foundry portal. In this architecture, Foundry Models provides AI capabilities for transcription and analysis.

- [Speech](/azure/ai-services/speech-service/overview) is an AI-based API that includes speech capabilities such as speech-to-text, text-to-speech, speech translation, and speaker recognition. In this architecture, Speech batch transcription converts recorded audio files into text.

- [Language](/azure/ai-services/language-service/overview) is a service that consolidates the Azure natural language processing services into a unified API. In this architecture, Language detects and redacts personally identifiable information (PII) from call transcripts.

- [Language Studio](/azure/ai-services/language-service/language-studio) is a UI-based tool for exploring, building, tagging, training, and deploying custom language models. In this architecture, Language Studio customizes language processing features for your specific call center domain.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a software as a service (SaaS) that provides visual and interactive insights for business analytics. The service includes transformation capabilities and connects to other data sources. In this architecture, Power BI visualizes post-call analytics based on business requirements.

### Alternatives

You can choose the following workflows, depending on your scenario.

- Detect PII by configuring the [guardrails](/azure/foundry/guardrails/how-to-create-guardrails) in Foundry and applying those guardrails to deployed models, including language models and Azure OpenAI models. You can filter different types of personal data, including personal information such as email, phone number, address, financial information, and government IDs. The system supports two modes:

  - *Annotate*, which flags the personal data in the output

  - *Annotate and block*, which blocks the entire output if the system detects personal data

  Set these modes for each personal category individually.

- Use the [fast transcription API](/azure/ai-services/speech-service/fast-transcription-create) to convert speech to text synchronously. [LLM speech (preview)](/azure/ai-services/speech-service/llm-speech) uses a language model-enhanced speech model to transcribe audio files and includes built-in features like translation.

- Use the speech analytics feature in [Azure Content Understanding](/azure/ai-services/content-understanding/audio/overview) to orchestrate the batch post-call analytics process.

- Use [GPT audio](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-models) [speech‑to‑text models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#speech-to-text-models) to generate audio transcripts and store them in Blob Storage for call analytics.

- Use the [ingestion client](/azure/ai-services/speech-service/ingestion-client) to deploy the post-call analytics solution to Azure. This solution uses Speech and Language services as the intelligence layer, without the generative AI capabilities that Azure OpenAI models provide.
  
- For virtual agents, you can use:
  
  - The [voice live API](/azure/ai-services/speech-service/voice-live) for speech-to-speech conversations through [telephony integration without a public switched telephone network (PSTN)](/azure/ai-services/speech-service/voice-live-telephony). This service supports [different generative AI models](/azure/ai-services/speech-service/voice-live#supported-models-and-regions), including [Azure OpenAI realtime models](/azure/foundry/openai/how-to/realtime-audio). If you choose a nonmultimodal model such as GPT‑4o, Azure speech to text automatically becomes the audio input. You can store the audio and transcription of the conversation in Blob Storage to analyze and gather insights for the business. The voice live API doesn't support session initiation protocol (SIP), but it works with external SIP trunking solutions.

  - [GPT-realtime models](/azure/foundry/openai/how-to/realtime-audio) to achieve low-latency speech-to-speech conversations. You can also use the GPT-realtime API by using [webRTC](/azure/foundry/openai/how-to/realtime-audio-webrtc), [WebSockets](/azure/foundry/openai/how-to/realtime-audio-websockets), or [SIP](/azure/foundry/openai/how-to/realtime-audio-sip) to send audio input and receive audio responses in real time and store them with the transcription for analytics.

## Scenario details

This solution uses the Speech batch transcription API to convert call-center audio into written text. Language redacts sensitive information in the conversation transcription. Azure OpenAI extracts insights from customer conversations to improve call center efficiency and customer satisfaction.

Use this solution to process transcribed text, recognize and remove sensitive information, and perform analytics on the extractions like the reason for the call, whether a resolution was provided, the sentiment of the call, and a list of product and service offerings based on the number of queries or customer complaints. Scale the services and the pipeline to accommodate any volume of recorded data.

### Potential use cases

This solution benefits organizations across multiple industries that have customer support agents. Post-call analytics can help improve the company's products, services, and customer support systems. The solution applies to organizations that record conversations, including organizations that have customer-facing agents, internal call centers, or support desks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Find the availability service-level agreement (SLA) for each component in [SLAs for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

- Design high-availability applications with Storage accounts by reviewing the [configuration options](/azure/storage/common/geo-redundant-design).

- Ensure resiliency of the compute services and datastores in this scenario by using failure mode for services such as Azure Functions and Storage. For more information, see [Reliability guides by service](/azure/reliability/overview-reliability-guidance).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Implement data protection, identity and access management, and network security recommendations for [Blob Storage](/azure/storage/blobs/security-recommendations), [Foundry Tools](/security/benchmark/azure/baselines/cognitive-services-security-baseline), and [Azure OpenAI](/azure/foundry-classic/openai/how-to/managed-identity).

- Configure [Foundry Tools virtual networks](/azure/ai-services/cognitive-services-virtual-networks).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The total cost of this solution depends on the pricing tier of your services. Factors that can affect the price of each component are:

- The number of documents that you process.
- The number of concurrent requests that your application receives.
- The size of the data that you store after processing.
- Your deployment region.

For more information, see the following resources:

- [Foundry](https://azure.microsoft.com/pricing/details/microsoft-foundry/)
- [Azure OpenAI pricing](https://azure.microsoft.com/pricing/details/azure-openai/)
- [Blob Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs/)
- [Language pricing](https://azure.microsoft.com/pricing/details/language/)

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate your solution cost.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

When you process high volumes of data, the system can expose performance bottlenecks. To ensure proper performance efficiency, learn about [scaling options](/azure/azure-functions/functions-scale#scale) to use with the [Foundry Tools autoscale feature](/azure/ai-services/autoscale).

The batch speech API handles high volumes, but other Foundry Tools APIs might have request limits, depending on the subscription tier. Consider containerizing Foundry Tools APIs to avoid slowdowns during large-volume processing. Containers provide deployment flexibility in the cloud and on-premises. Use containers to mitigate side effects of new version rollouts. For more information, see [Container support in Foundry Tools](/azure/ai-services/cognitive-services-container-support).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- Dixit Arora | Senior Customer Engineer, EngOps CRE
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624/) | Sr. Account Executive

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Speech overview](/azure/ai-services/speech-service/overview)
- [Foundry Models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Language overview](/azure/ai-services/language-service/overview)
- [Introduction to Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [Power BI overview](/power-bi/fundamentals/power-bi-overview)
- [Post-call transcription and analytics](/azure/ai-services/speech-service/call-center-quickstart)
- [Create custom language and acoustic models](/azure/ai-services/speech-service/how-to-custom-speech-train-model)
