This article describes a batch processing architecture that extracts insights from customer conversations in a call center. The solution uses Foundry Tools and Foundry Models to analyze post-call transcripts after calls complete rather than in near real time. With this approach, you can analyze call intent and sentiment, extract key entities, and summarize calls offline to help improve customer interactions and satisfaction.

## Architecture

:::image type="complex" border="false" source="_images/call-center-analytics.svg" alt-text="Diagram that shows the call-center AI architecture." lightbox="_images/call-center-analytics.svg":::
   The diagram shows a post-call analytics workflow from left to right. A caller and a call-center agent connect through a person-to-person conversation on a telephony server. The server uploads recorded audio files to Blob Storage. In the primary upper path, Azure speech to text extracts a transcript, another Blob Storage instance stores it, and Microsoft Foundry, marked as step 4, analyzes it. In the alternate lower path, audio files flow directly from the first Blob Storage instance to Azure Content Understanding, marked as step 5, which extracts the transcript and insights. Both paths write results to a Blob Storage instance marked as step 6. From there, arrows lead right to Power BI for insights, a web app, and a CRM system that shows detailed call history, summaries, and reasons for calling. The extraction, storage, and analysis components are grouped inside an Intelligent transcription boundary, and the three destinations are grouped inside an Interact and visualize boundary.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/call-center-analytics.vsdx) of this architecture.*

## Data flow

The following data flow corresponds to the previous diagram:

1. The telephony server records a phone call between an agent and a customer and stores it in Azure Blob Storage. Audio files are uploaded to an Azure Storage account through a supported method, such as the UI-based tool [Azure Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer) or a [Storage SDK or API](/azure/storage/blobs/reference).

1. An Azure function uses one of the following triggers to start the intelligent transcription process:

   - **[Timer trigger](/azure/azure-functions/functions-bindings-timer):** Configure a time-based trigger to process a batch of audio files accumulated over a specified time period.

   - **[Blob trigger](/azure/azure-functions/functions-bindings-storage-blob-trigger):** Configure a blob trigger to initiate intelligent transcription when an audio file is uploaded to the blob container.

1. The Azure function triggers a custom application that runs one of the two flows as explained below.

   - Speech-to-text and language model flow:

     1. The app calls [Azure Speech batch transcription](/azure/ai-services/speech-service/batch-transcription) to transcribe the audio files and optionally stores the raw transcription file in Blob Storage for future reference.

     1. The app uses [Conversation PII](/azure/ai-services/language-service/personally-identifiable-information/how-to/redact-conversation-pii) (preview) to detect and redact personal data in the transcript before it sends the redacted transcript to a language model, such as a GPT-5 model from Microsoft Foundry Models. Configure [personal-data guardrails](/azure/foundry/guardrails/how-to-create-guardrails) separately to detect personal data in the model output. The model performs post-call analytics such as identifying call intent and sentiment, extracting entities, and summarizing the conversation. The app stores the processed output in Azure Storage for visualization or consumption by downstream applications or reporting data stores.

   - Azure Content Understanding in Foundry Tools flow:

     1. The audio files are loaded into Azure Content Understanding in Foundry Tools, which uses the prebuilt call-center audio analyzer to transcribe the audio file with speaker diarization and generate a call summary, sentiments, and entities like companies and people. It also understands the call categories.

     1. The app performs a custom PII redaction step on the extraction results that Azure Content Understanding in Foundry Tools returns, if the scenario requires it. Then the app stores that data in Blob Storage or another data store for reporting.

1. [Power BI](/power-bi/fundamentals/power-bi-overview) visualizes the post-call analytics based on the criteria that the business defines. You can also store this output in a customer relationship management (CRM) system, so agents have contextual information about why the customer called and can quickly solve potential problems. This automated process saves agents time and effort.

### Components

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage service that supports libraries for languages such as .NET, Node.js, and Python. Applications can access files on Blob Storage by using HTTP or HTTPS. Blob Storage has [hot, cool, and archive access tiers](/azure/storage/blobs/access-tiers-overview) to store large amounts of data and optimize cost. In this architecture, Blob Storage stores raw audio files and processed outputs.

- [Foundry Models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure) is the model catalog and model access layer in Microsoft Foundry. It provides access to multiple models that have different capabilities, including language models, audio models, image and video generation models, and embeddings models. You can access the catalog through REST APIs, SDKs, or the Foundry portal. In this architecture, Foundry Models provides AI capabilities for transcription and analysis.

- [Speech](/azure/ai-services/speech-service/overview) is an AI-based API that includes speech capabilities such as speech to text, text to speech, speech translation, and speaker recognition. In this architecture, Speech batch transcription converts recorded audio files into text.

- [Language](/azure/ai-services/language-service/overview) is a Foundry Tool that consolidates the Azure natural language processing services into a unified API. In this architecture it detects and redacts personal data from call transcripts in the speech-to-text and language model flow.

- [Azure Content Understanding in Foundry Tools](/azure/ai-services/content-understanding/overview) allows you to ingest and process different types of content (documents, images, audio, and video) into a user-defined output format using generative AI. [Analyzers](/azure/ai-services/content-understanding/concepts/analyzer-reference) in Azure Content Understanding define the way content is analyzed and information is extracted. The service provides [prebuilt analyzers](/azure/ai-services/content-understanding/concepts/prebuilt-analyzers) and also provides options for creating custom analyzers. In this architecture, Content Understanding is used to transcribe the audio files. During development, you work with the service in [Microsoft Foundry or in Content Understanding Studio](/azure/ai-services/content-understanding/foundry-vs-content-understanding-studio).

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a software as a service (SaaS) that provides visual and interactive insights for business analytics. The service includes transformation capabilities and connects to other data sources. In this architecture, Power BI visualizes post-call analytics based on business requirements.

### Alternatives

Choose from the following workflows, depending on your scenario:

- Use the [Fast Transcription API](/azure/ai-services/speech-service/fast-transcription-create) to convert speech to text synchronously. [LLM speech (preview)](/azure/ai-services/speech-service/llm-speech) uses an LLM-enhanced speech model to transcribe audio files and includes built-in features like translation.

- Use [GPT audio](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-models) [speech-to-text models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#speech-to-text-models) to generate audio transcripts and store them in Blob Storage for call analytics.

- Use the [ingestion client](/azure/ai-services/speech-service/ingestion-client) to deploy the post-call analytics solution to Azure. This solution uses Speech and Language services as the intelligence layer, without the generative AI capabilities that Foundry models provide.

- For virtual agents, use:

  - The [Voice Live API](/azure/ai-services/speech-service/voice-live) for speech-to-speech conversations through [telephony integration without a public switched telephone network (PSTN)](/azure/ai-services/speech-service/voice-live-telephony). The Voice Live API supports [different generative AI models](/azure/ai-services/speech-service/voice-live#supported-models-and-regions), including [Azure OpenAI realtime models](/azure/foundry/openai/how-to/realtime-audio). If you choose a nonmultimodal model such as GPT-4o, Azure speech to text automatically becomes the audio input. Store the audio and transcription of the conversation in Blob Storage to analyze and gather insights for your business. The Voice Live API doesn't support session initiation protocol (SIP), but it works with external SIP trunking solutions.

  - Use [GPT-realtime models](/azure/foundry/openai/how-to/realtime-audio) to achieve low-latency speech-to-speech conversations. You can also use the GPT Realtime API via [WebRTC](/azure/foundry/openai/how-to/realtime-audio-webrtc), [WebSockets](/azure/foundry/openai/how-to/realtime-audio-websockets), or [SIP](/azure/foundry/openai/how-to/realtime-audio-sip) to send audio input and receive audio responses in real time and store them with the transcription for analytics.

## Scenario details

This solution uses the Batch Transcription API in Speech to convert call-center audio into written text. Language redacts sensitive information in the conversation transcription. Foundry Tools and models extract insights from customer conversations to improve call-center efficiency and customer satisfaction.

Use this solution to process transcribed text, recognize and remove sensitive information, and extract insights like call reason, resolution status, sentiment, and product or service trends based on query volume or customer complaints. Scale the services and pipeline to accommodate any volume of recorded data.

### Potential use cases

This solution benefits organizations across multiple industries that have customer support agents. Post-call analytics can help improve the company's products, services, and customer support systems. The solution applies to organizations that record conversations, including organizations that have customer-facing agents, internal call centers, or support desks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Find the availability service-level agreement (SLA) for each component in [SLAs for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

- Design high-availability applications with Storage accounts by reviewing the [configuration options](/azure/storage/common/geo-redundant-design).

- Ensure resilience of the compute services and data stores in this scenario by testing failure modes for core services such as Azure Functions and Storage. For more information, see [Reliability guides by service](/azure/reliability/overview-reliability-guidance).

- Make a copy of the prebuilt analyzer in Azure Content Understanding in Foundry Tools so changes to its definition across API versions don't alter the output schema.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Implement data protection, identity and access management, and network security recommendations for [Blob Storage](/azure/storage/blobs/security-recommendations), and [Microsoft Foundry](/azure/foundry/concepts/authentication-authorization-foundry).

- Configure [Foundry Tools virtual networks](/azure/ai-services/cognitive-services-virtual-networks).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The total cost of this solution depends on the pricing tier of your services. Factors that can affect the price of each component are:

- The total duration of the audio, plus contextualization and model-token usage for the selected analyzer.
- The number of concurrent requests that your application receives.
- The size of the data that you store after processing.
- Your deployment region.

For more information, see the following resources:

- [Foundry](https://azure.microsoft.com/pricing/details/microsoft-foundry/)
- [Foundry Models pricing](https://azure.microsoft.com/pricing/details/ai-foundry-models/model-router/)
- [Blob Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs/)

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate your solution cost.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

When you process high volumes of data, the system can expose performance bottlenecks. To ensure proper performance efficiency, learn about [scaling options](/azure/azure-functions/functions-scale#scale) to use with the [Foundry Tools autoscale feature](/azure/ai-services/autoscale).

The Batch Speech API handles high volumes, but other Foundry Tools APIs might have request limits, depending on the subscription tier. Consider containerizing Foundry Tools APIs to avoid slowdowns during large-volume processing. Containers provide deployment flexibility in the cloud and on-premises. Use containers to mitigate side effects of new version rollouts. For more information, see [Container support in Foundry Tools](/azure/ai-services/cognitive-services-container-support).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- Dixit Arora | Senior Customer Engineer, EngOps CRE
- [Jyotsna Ravi](https://www.linkedin.com/in/jyotsna-ravi-50182624/) | Sr. Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Speech overview](/azure/ai-services/speech-service/overview)
- [Foundry Models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Introduction to Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [Power BI overview](/power-bi/fundamentals/power-bi-overview)
- [Post-call transcription and analytics](/azure/ai-services/speech-service/call-center-quickstart)
- [Create custom language and acoustic models](/azure/ai-services/speech-service/how-to-custom-speech-train-model)
