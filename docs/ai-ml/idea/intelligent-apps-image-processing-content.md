[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

By using Azure services, such as the Computer Vision API and Azure Functions, companies can eliminate the need to manage individual servers, while reducing costs and utilizing the expertise that Microsoft has already developed with processing images with Azure AI services. This solution idea specifically addresses an image-processing use case. If you have different AI needs, consider the full suite of [Azure AI services](/azure/ai-services/what-are-ai-services).

## Architecture

![Diagram of an architecture for used for image classification tasks.][architecture]

*Download a [Visio file][visio-download] of this solution idea.*

### Dataflow

This scenario covers the back-end components of a web or mobile application. Data flows through the scenario as follows:

1. Adding new files (image uploads) in Blob storage triggers an event in Azure Event Grid. The uploading process can be orchestrated via the web or a mobile application. Alternatively, images can be uploaded separately to the Azure Blob storage.
2. Event Grid sends a notification that triggers the Azure functions.
3. Azure Functions calls the Azure AI Vision API to analyze the newly uploaded image. Azure AI Vision accesses the image via the blob URL that's parsed by Azure Functions.
4. Azure Functions persists the AI Vision API response in Azure Cosmos DB. This response includes the results of the analysis, along with the image metadata.
5. The results can be consumed and reflected on the web or mobile front end. This approach retrieves the results of the classification but not the uploaded image.

### Components

- [Azure AI Vision](/azure/ai-services/computer-vision/overview) is part of the Azure AI services suite. In this architecture, it retrieves information about each image. It analyzes newly uploaded images and provides metadata and classification results. These results enable automated image understanding.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless solution that you can use to build robust apps with less code and less infrastructure. In this architecture, Azure Functions provides the back-end API for the web application. This platform also provides event processing for uploaded images. Azure Functions orchestrates workflow steps, including calling the AI Vision API, processing analysis results, and persisting metadata in the database.

- [Azure Event Grid](/azure/well-architected/service-guides/event-grid/reliability) is a managed event-routing service that enables uniform event consumption by using a publish-subscribe model. In this architecture, Azure Event Grid triggers an event when a new image is uploaded to blob storage and initiates automated processing workflows by alerting Azure Functions of new uploads.

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage solution for storing unstructured data in the cloud. In this architecture, it stores all of the image files that are uploaded into the web application, as well any static files that the web application consumes. Blob Storage is the primary repository for incoming image data, serving as both the source for processing and a reference for image access.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a NoSQL database. In this architecture, Azure Cosmos DB stores metadata about each image that is uploaded, including the results of the processing from Computer Vision API.

### Alternatives

- [Azure OpenAI GPT-4o and GPT-4o-mini](/azure/ai-services/openai/concepts/gpt-with-vision). GPT-4o and GPT-4o-mini are multimodal chat models from OpenAI that can answer general questions about what's present in the images you provide.
- [Custom Vision Service](/azure/ai-services/custom-vision-service/overview). The Computer Vision API returns a set of [taxonomy-based categories][cv-categories]. If you need to process information that isn't returned by the Computer Vision API, consider the Custom Vision Service, which lets you build custom image classifiers. To learn about this service, follow the quick start [Build an image classification model with the Custom Vision](/azure/ai-services/custom-vision-service/getting-started-build-a-classifier).
- [Azure AI Search](/azure/search/search-what-is-azure-search). If your use case involves querying the metadata to find images that meet specific criteria, consider using Azure AI Search.
- [Logic Apps](https://azure.microsoft.com/services/logic-apps). If you don't need to react in real-time on added files to a blob, you might consider using Logic Apps. A logic app which can check if a file was added might be start by the [recurrence trigger or sliding windows trigger](/azure/logic-apps/concepts-schedule-automated-recurring-tasks-workflows).
- If you have images embedded in documents, use [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/concept-layout#figures) to locate those images. With that information, you can extract and perform further computer vision tasks on the embedded images. Use Document Intelligence to gather data about those embedded images, such page number or caption text which can be stored along with the images' other metadata received through the Computer Vision API. If your images are mainly photos or scans of documents, use the [Document Intelligence custom classification models](/azure/ai-services/document-intelligence/train/custom-classifier?view=doc-intel-4.0.0) to perform classification of an input file one page at a time to identify the documents within. This approach can also identify multiple documents or multiple instances of a single document within an input file.

## Scenario details

This scenario is relevant for businesses that need to process images.

Potential applications include classifying images for a fashion website, analyzing text and images for insurance claims, or understanding telemetry data from game screenshots. Traditionally, companies would need to develop expertise in machine learning models, train the models, and finally run the images through their custom process to get the data out of the images.

### Potential use cases

This solution is ideal for the retail, game, finance, and insurance industries. Other relevant use cases include:

- **Classifying images on a fashion website.** Image classification can be used by sellers while uploading pictures of products on the platform for sale. They can then automate the consequent manual tagging involved. The customers can also search through the visual impression of the products.

- **Classifying telemetry data from screenshots of games.** The classification of video games from screenshots is evolving into a relevant problem in social media, coupled with computer vision. For example, when Twitch streamers play different games in succession, they might skip manually updating their stream information. Failure to update stream information could result in the misclassification of streams in user searches and might lead to the loss of potential viewership for both the content creators and the streaming platforms. While introducing novel games, a custom model route could be helpful to introduce the capability to detect novel images from those games.

- **Classifying images for insurance claims.** Image classification can help reduce the time and cost of claims processing and underwriting. It could help analyze natural-disaster damage, vehicle-damage, and identify residential and commercial properties.

## Next steps

Product documentation

- [What is Azure AI Vision?](/azure/ai-services/computer-vision/overview)
- [AI enrichment in Azure AI Search](/azure/search/cognitive-search-concept-intro)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [What is Azure Event Grid?](/azure/event-grid/overview)
- [Introduction to Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)

For a guided learning path, see:

- [Build a serverless web app in Azure][serverless]
- [Classify images with Azure AI Custom Vision](/training/modules/classify-images-custom-vision/)
- [Use AI to recognize objects in images by using the Custom Vision service](/training/modules/train-custom-vision-ai/)
- [Classify endangered bird species with Custom Vision](/training/modules/cv-classify-bird-species/)
- [Classify images with Azure AI Custom Vision services](/training/modules/classify-images/)
- [Detect objects in images with Azure AI Custom Vision](/training/modules/detect-objects-images-custom-vision/)

## Related resources

- [Use AI enrichment with image and text processing](../../solution-ideas/articles/ai-search-skillsets.yml)
- [Get started with multimodal vision chat apps using Azure OpenAI](/azure/developer/ai/get-started-app-chat-vision?tabs=github-codespaces)

<!-- links -->
[architecture]: _images/architecture-intelligent-apps-image-processing.png
[serverless]: /training/paths/create-serverless-applications/
[cv-categories]: /azure/ai-services/computer-vision/category-taxonomy
[visio-download]: https://arch-center.azureedge.net/architecture-image-classification-on-azure.vsdx
