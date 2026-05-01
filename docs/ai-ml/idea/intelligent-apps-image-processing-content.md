[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

By using Azure services such as Azure AI Content Understanding and Azure Functions, you can add image classification and metadata extraction to a web or mobile application without managing servers or training your own models. This solution idea targets image classification and tagging. If you have other AI needs, see the broader [Foundry Tools](/azure/ai-services/what-are-ai-services) and [Microsoft Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) catalogs.

## Architecture

![Diagram of an architecture used for image classification tasks.][architecture]

*Download a [Visio file][visio-download] of this solution idea.*

### Data flow

This scenario covers the back-end components of a web or mobile application. Data flows through the scenario as follows:

1. New files (image uploads) added to Blob Storage trigger an event in Azure Event Grid. The upload is orchestrated by a web or mobile application, or images are uploaded directly to Blob Storage.
2. Event Grid sends a notification that triggers an Azure function.
3. The function calls Content Understanding to analyze the newly uploaded image against a defined analyzer schema. Content Understanding accesses the image through a time-limited SAS URL, or equivalent temporary access token, that the function passes in the request and scopes to least-privilege read access for only the target blob.
4. The function persists the structured output that Content Understanding returns, along with image metadata, in Azure Cosmos DB for NoSQL.
5. The web or mobile front end consumes the results. This dataflow returns the classification output and metadata; it doesn't return the original image bytes.

### Components

- [Content Understanding](/azure/ai-services/content-understanding/overview) is a Microsoft Foundry capability that uses generative AI to extract user-defined structured output from documents, images, video, and audio. In this architecture, it analyzes each uploaded image against an [analyzer schema](/azure/ai-services/content-understanding/concepts/analyzer-templates) that defines the categories, attributes, and labels you want returned (for example, product type, color, defect class). The output is JSON that maps directly to your application's data model.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless compute platform. In this architecture, Azure Functions provides the back-end API and the event-processing layer for uploaded images. The function orchestrates the workflow. It calls Content Understanding, processes the response, and writes the result to the database. This architecture uses the [Flex Consumption plan](/azure/azure-functions/flex-consumption-plan) to support virtual network integration, instance memory choice, and fast scaling.

- [Azure Event Grid](/azure/well-architected/service-guides/event-grid/reliability) is a managed event-routing service that uses a publish-subscribe model. In this architecture, an Event Grid system topic on the storage account emits a `Microsoft.Storage.BlobCreated` event when a new image is uploaded and delivers it to the function.

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object store for unstructured data. In this architecture, it stores all uploaded images and any static assets that the web application serves. Blob Storage is the source of truth for incoming images.

- [Azure Cosmos DB for NoSQL](/azure/well-architected/service-guides/cosmos-db) is a managed NoSQL database. In this architecture, it stores the metadata for each image, including the structured output that Content Understanding returns.

### Alternatives

- [Azure Machine Learning AutoML for Images](/azure/machine-learning/concept-automated-ml#computer-vision) trains custom image classification and object detection models from your labeled data using classic machine learning techniques. Choose AutoML when you have a labeled dataset and need a deterministic, deployable model for narrow domains (for example, manufacturing defect detection or medical imaging) where generative approaches don't fit. AutoML is the path that Microsoft recommends for customers migrating from Custom Vision when they want to keep a classic ML model.

- [Microsoft Foundry vision-enabled models](/azure/foundry/openai/how-to/gpt-with-vision) let you call or fine-tune multimodal models (GPT-4.1, GPT-4o, and Phi-4 multimodal) directly. Choose this path when you need fine-grained control over the prompt and model, want to fine-tune on your own data, or need visual question answering and image-grounded chat instead of structured extraction.

- [Azure AI Search](/azure/search/search-what-is-azure-search) indexes the metadata so that users can query and filter images by tag, caption, or other attributes. The [AI enrichment skillset](/azure/search/cognitive-search-concept-intro) can call vision and generative AI services and write the results directly to a search index without a separate function.

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a fit when you don't need real-time reaction to uploads. A workflow that runs on a [recurrence or sliding-window trigger](/azure/logic-apps/concepts-schedule-automated-recurring-tasks-workflows) can poll for new blobs and call Content Understanding in batch.

- [Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) extracts images that are embedded in documents through the [layout model](/azure/ai-services/document-intelligence/concept-layout#figures), so you can run downstream classification on those embedded figures. Use [custom classification models](/azure/ai-services/document-intelligence/train/custom-classifier) when input files contain multiple document types and you need to identify each one before further processing.

## Scenario details

This scenario applies to businesses that process images at scale and want to attach structured metadata such as tags, captions, or category labels to each image without training and operating their own models.

Typical applications include classifying images on a fashion site, analyzing photos for insurance claims, and extracting context from game screenshots. Building this in-house traditionally requires expertise in computer vision, training data, and model lifecycle management. The architecture in this article replaces that work with managed Azure services.

### Potential use cases

This solution applies to retail, e-commerce, gaming, finance, and insurance. Common use cases include:

- **Tagging images on a retail or fashion site.** Sellers upload product photos. Content Understanding returns the tags, captions, and attributes that you define in the analyzer schema. The platform uses them to autofill listing fields, drive visual search, and reduce manual tagging effort.

- **Categorizing products in an e-commerce catalog.** A Content Understanding analyzer assigns category and subcategory metadata (for example, footwear to running shoe) and visual attributes such as color and material. Buyers get more accurate search and filtering, and sellers spend less time correcting categories.

- **Classifying telemetry from game screenshots.** Streaming platforms misclassify a stream when a creator forgets to update the title after switching games. A function that classifies periodic screenshots can detect the change and update the stream metadata. For narrow domains where generative classification underperforms, use AutoML for Images to train a deterministic classifier.

- **Routing insurance claim photos.** Content Understanding identifies vehicle damage, natural-disaster damage, or property type from claim photos. The metadata routes the claim to the correct adjuster queue and shortens triage time.

### Considerations

These considerations implement the pillars of the [Azure Well-Architected Framework](/azure/well-architected/), a set of guiding tenets that you can use to improve the quality of a workload.

#### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) for the function app to authenticate to Blob Storage, Azure Cosmos DB, and the Microsoft Foundry resource that hosts Content Understanding. Avoid storing connection strings or API keys in app settings.
- Restrict the Foundry resource and Cosmos DB to [private endpoints](/azure/private-link/private-endpoint-overview) and disable public network access when the workload runs inside a virtual network. The [Flex Consumption plan](/azure/azure-functions/flex-consumption-plan) supports virtual network integration.
- Validate uploaded images before invoking the vision service. Enforce content-type and size limits at the upload boundary, scan for malware, and store uploads in a container that public users can't read directly.
- This architecture is only suitable for images that you decide are appropriate to be processed by a cloud solution, local/offline image processing isn't supported.

#### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Limit the analyzer schema in Content Understanding to the fields that the application actually consumes. Each additional field increases token usage and per-call cost. Review [Microsoft Foundry pricing](https://azure.microsoft.com/pricing/details/ai-foundry/) for the current rates.
- For Azure Functions, use the [Flex Consumption plan](/azure/azure-functions/flex-consumption-plan) for spiky event-driven workloads. It scales to zero and bills per second on active instances.
- For Azure Cosmos DB, evaluate [serverless](/azure/cosmos-db/serverless) or [autoscale throughput](/azure/cosmos-db/provision-throughput-autoscale) when traffic is uneven. Serverless suits low-traffic and dev/test workloads; autoscale suits production with variable load.

#### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Send Azure Functions, Event Grid, and Microsoft Foundry diagnostics to a shared Log Analytics workspace and use [Application Insights](/azure/azure-monitor/app/app-insights-overview) for distributed tracing across the upload-to-result flow.
- Configure an Event Grid [dead-letter destination](/azure/event-grid/manage-event-delivery#set-dead-letter-location) so that events the function can't process land in a separate blob container for replay.
- Version Content Understanding analyzer schemas as code and deploy them through the same pipeline that deploys the function. Treat schema changes as breaking changes for downstream consumers.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Ananya Ghosh Chowdhury](https://www.linkedin.com/in/ananyaghoshchowdhury/) | Principal Cloud Solution Architect

Other contributors:

- [Delyn Choong](https://www.linkedin.com/in/delynchoong/) | Senior Cloud Solutions Architect – Data & AI
- [Abhishek Singh](https://www.linkedin.com/in/abhisheksinghkholiya/) | Tech Support Engineer

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
- [Get started with multimodal vision chat apps using Azure OpenAI](/azure/developer/ai/get-started-app-chat-vision?tabs=github-codespaces)

<!-- links -->
[architecture]: _images/architecture-intelligent-apps-image-processing.svg
[serverless]: /training/paths/create-serverless-applications/
[visio-download]: https://arch-center.azureedge.net/architecture-intelligent-apps-image-processing.vsdx
