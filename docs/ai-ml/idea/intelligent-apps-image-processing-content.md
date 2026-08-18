[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

By using Azure services such as Azure Content Understanding and Azure Functions, you can add image classification and metadata extraction to a web or mobile application without managing servers or training your own models. This solution idea targets image classification and tagging. If you have other AI needs, see the broader [Microsoft Foundry](/azure/foundry/what-is-foundry) and [Foundry Tools](/azure/ai-services/what-are-ai-services) catalogs.

## Architecture

:::image type="complex" source="_images/architecture-intelligent-apps-image-processing.svg" border="false" lightbox="_images/architecture-intelligent-apps-image-processing.svg" alt-text="Diagram that shows an intelligent image-processing pipeline that uses Azure services.":::
    The diagram shows five steps in the image-processing pipeline. On the left, a box contains image uploads, a storage account, and Azure Blob Storage. This box represents the origin of all data in the pipeline. Step one shows an arrow that points rightward from the image uploads box to Azure Event Grid, which is labeled event trigger. Step two shows an arrow that continues rightward to Azure Functions, which is labeled API or event processor. Step three shows a bidirectional arrow that points downward to Azure Content Understanding. Step four shows an arrow that points rightward from Functions to Azure Cosmos DB, which is labeled data storage. Step five shows an arrow that continues rightward to a web or mobile front end. Overall, data originates at Blob Storage on the left, propagates rightward through Event Grid and Functions, branches downward to Content Understanding for AI analysis, continues rightward into Cosmos DB for storage, and finally reaches the web or mobile front end.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/architecture-intelligent-apps-image-processing.vsdx) of this architecture.*

### Data flow

This scenario covers the back-end components of a web or mobile application. The following data flow corresponds to the previous image:

1. A user uploads an image to Azure Blob Storage, either directly or by using a web or mobile application. The upload triggers an event in Azure Event Grid.

1. Event Grid sends a notification to Azure Functions to process the uploaded image.

1. The function generates a time-limited, least-privilege shared access signature URL scoped to the target blob and passes it to Content Understanding. Content Understanding uses this URL to access the image directly from Blob Storage, then analyzes it by using a prebuilt analyzer.

1. The function stores the structured output that Content Understanding returns, along with image metadata, in Azure Cosmos DB for NoSQL.

1. A web or mobile application receives the results. This data flow returns the classification output and metadata, but not the original image file.

### Components

- [Content Understanding](/azure/ai-services/content-understanding/overview) is a Foundry Tool that uses generative AI to extract user-defined structured output from documents, images, video, and audio. In this architecture, Content Understanding analyzes each uploaded image by using a [prebuilt analyzer](/azure/ai-services/content-understanding/concepts/prebuilt-analyzers) that defines the categories, attributes, and labels that you want returned, such as product type, color, or defect class. The output is JSON that maps directly to your application's data model.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless compute platform. In this architecture, Azure Functions provides the back-end API and the event-processing layer for uploaded images. The function orchestrates the workflow. It calls Content Understanding, processes the response, and writes the result to the database. This architecture uses the [Flex Consumption plan](/azure/azure-functions/flex-consumption-plan) to support virtual network integration, instance memory choice, and fast scaling.

- [Azure Event Grid](/azure/well-architected/service-guides/azure-event-grid) is a managed event-routing service that uses a publish-subscribe model. In this architecture, an Event Grid system topic on the storage account emits a `Microsoft.Storage.BlobCreated` event when a new image is uploaded and delivers it to the function.

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object store for unstructured data. In this architecture, it stores all uploaded images and any static assets that the web application serves. Blob Storage is the source of truth for incoming images.

- [Azure Cosmos DB for NoSQL](/azure/well-architected/service-guides/cosmos-db) is a managed NoSQL database. In this architecture, it stores the metadata for each image, including the structured output that Content Understanding returns.

### Alternatives

- [AutoML in Azure Machine Learning](/azure/machine-learning/concept-automated-ml#computer-vision) supports computer vision tasks. You can train custom image classification and object detection models from your labeled data by using classic machine learning techniques. Choose AutoML when you have a labeled dataset and need a deterministic, deployable model for narrow domains where generative approaches don't fit. Examples include manufacturing defect detection or medical imaging. Microsoft recommends AutoML for customers migrating from Azure AI Custom Vision who want to keep a classic machine learning model.

- [Vision-enabled models in Foundry](/azure/foundry/openai/how-to/gpt-with-vision) let you call or fine-tune multimodal models (GPT-4.1, GPT-4o, and Phi-4 multimodal) directly. Choose this path when you need fine-grained control over the prompt and model, want to fine-tune on your own data, or need visual question answering and image-grounded chat instead of structured extraction.

- [Azure AI Search](/azure/search/search-what-is-azure-search) indexes the metadata so that users can query and filter images by tag, caption, or other attributes. The [AI enrichment skillset](/azure/search/cognitive-search-concept-intro) can call vision and generative AI services and write the results directly to a search index without a separate function.

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a fit when you don't need real-time reaction to uploads. A workflow that runs on a [recurring or sliding-window trigger](/azure/logic-apps/concepts-schedule-automated-recurring-tasks-workflows) can poll for new blobs and call Content Understanding in batch.

- [Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) extracts images that are embedded in documents by using the [layout model](/azure/ai-services/document-intelligence/concept-layout#figures), so you can run downstream classification on embedded figures. Use [custom classification models](/azure/ai-services/document-intelligence/train/custom-classifier) when input files contain multiple document types and you need to identify each one before further processing.

## Scenario details

This scenario applies to businesses that process images at scale and want to attach structured metadata such as tags, captions, or category labels to each image without training and operating their own models.

Typical applications include classifying images on a fashion site, analyzing photos for insurance claims, and extracting context from game screenshots. Building this capability in-house traditionally requires expertise in computer vision, training data, and model lifecycle management. The architecture in this article replaces that work with managed Azure services.

### Potential use cases

This solution applies to retail, e-commerce, gaming, finance, and insurance. Common use cases include:

- **Tagging images on a retail or fashion site.** Sellers upload product photos. Content Understanding returns the tags, captions, and attributes that you define in the analyzer. The platform uses the returned metadata to autofill listing fields, drive visual search, and reduce manual tagging effort.

- **Categorizing products in an e-commerce catalog.** A Content Understanding analyzer assigns category and subcategory metadata, such as *footwear* and *running shoe*, and visual attributes such as color and material. Buyers get more accurate search and filtering, and sellers spend less time correcting categories.

- **Classifying telemetry from game screenshots.** Streaming platforms misclassify a stream when a creator forgets to update the title after switching games. A function that classifies periodic screenshots can detect the change and update the stream metadata. For narrow domains where generative classification underperforms, use AutoML for Images to train a deterministic classifier.

- **Routing insurance claim photos.** Content Understanding identifies vehicle damage, natural-disaster damage, or property type from claim photos. The metadata routes the claim to the correct adjuster queue and shortens triage time.

### Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).


#### Security

Security provides protections against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use [managed identities](/entra/identity/managed-identities-azure-resources/overview) for the function app to authenticate to Blob Storage, Azure Cosmos DB, and the Microsoft Foundry resource that hosts Content Understanding. Avoid storing connection strings or API keys in app settings.

- Restrict the Foundry resource and Cosmos DB to [private endpoints](/azure/private-link/private-endpoint-overview) and turn off public network access when the workload runs inside a virtual network. The [Flex Consumption plan](/azure/azure-functions/flex-consumption-plan) supports virtual network integration.

- Validate uploaded images before you invoke the vision service. Enforce content-type and size limits at the upload boundary, scan for malware, and store uploads in a container that public users can't read directly.

- This architecture is only suitable for images that you decide are appropriate for a cloud solution to process. Local or offline image processing isn't supported.

#### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Limit the analyzer in Content Understanding to the fields that the application actually consumes. Each extra field increases token usage and per-call cost. For the current rates, see [Foundry pricing](https://azure.microsoft.com/pricing/details/microsoft-foundry/).

- For Azure Functions, use the [Flex Consumption plan](/azure/azure-functions/flex-consumption-plan) to handle spikes in event-driven workloads. The plan scales to zero and bills per second on active instances.

- For Cosmos DB, evaluate [serverless](/azure/cosmos-db/serverless) or [autoscale throughput](/azure/cosmos-db/provision-throughput-autoscale) when traffic is uneven. Serverless suits low-traffic and dev/test workloads, while autoscale suits production with variable load.

#### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Send Functions, Event Grid, and Foundry diagnostics to a shared Log Analytics workspace and use [Application Insights](/azure/azure-monitor/app/app-insights-overview) for distributed tracing across the upload-to-result flow.

- Configure an Event Grid [dead-letter destination](/azure/event-grid/manage-event-delivery#set-dead-letter-location) so that events the function can't process land in a separate blob container for replay.

- Version Content Understanding analyzer schemas as code and deploy them through the same pipeline that deploys the function. Treat schema changes as breaking changes for downstream consumers.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ananya Ghosh Chowdhury](https://www.linkedin.com/in/ananyaghoshchowdhury/) | Principal Cloud Solution Architect

Other contributors:

- [Delyn Choong](https://www.linkedin.com/in/delynchoong/) | Senior Cloud Solutions Architect – Data & AI
- [Abhishek Singh](https://www.linkedin.com/in/abhishek-singh-54710243/) | Tech Support Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Content Understanding?](/azure/ai-services/content-understanding/overview)
- [Microsoft Foundry models overview](/azure/ai-foundry/concepts/foundry-models-overview)
- [Azure Vision Image Analysis migration options](/azure/ai-services/computer-vision/migration-options)
- [AI enrichment in Azure AI Search](/azure/search/cognitive-search-concept-intro)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [Azure Functions Flex Consumption plan](/azure/azure-functions/flex-consumption-plan)
- [What is Azure Event Grid?](/azure/event-grid/overview)
- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)

For guided learning paths, see:

- [Develop a vision-enabled generative AI application](/training/modules/develop-generative-ai-vision-apps/)
- [Train custom image classification models with AutoML](/training/modules/find-best-classification-model-automated-machine-learning/)

## Related resources

- [Use AI enrichment with image and text processing](../../solution-ideas/articles/ai-search-skillsets.yml)
- [Get started with multimodal vision chat apps by using Azure OpenAI](/azure/developer/ai/get-started-app-chat-vision?tabs=github-codespaces)
