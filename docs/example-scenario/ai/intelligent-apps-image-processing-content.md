This scenario is relevant for businesses that need to process images.

Potential applications include classifying images for a fashion website, analyzing text and images for insurance claims, or understanding telemetry data from game screenshots. Traditionally, companies would need to develop expertise in machine learning models, train the models, and finally run the images through their custom process to get the data out of the images.

By using Azure services such as the Computer Vision API and Azure Functions, companies can eliminate the need to manage individual servers, while reducing costs and leveraging the expertise that Microsoft has already developed around processing images with Cognitive Services. This example scenario specifically addresses an image-processing use case. If you have different AI needs, consider the full suite of [Cognitive Services](/azure/cognitive-services/).

## Potential use cases

Other relevant use cases include:

- Classifying images on a fashion website.
- Classifying telemetry data from screenshots of games.
- Classifying images for insurance claims.

## Architecture

![Architecture for image classification][architecture]

### Workflow

This scenario covers the back-end components of a web or mobile application. Data flows through the scenario as follows:

1. The API layer is built using [Azure Functions](/azure/azure-functions/functions-overview). These APIs enable the application to upload images and retrieve data from [Azure Cosmos DB](/azure/cosmos-db/introduction).
2. When an image is uploaded via an API call, it's stored in [Blob storage](/azure/storage/blobs/storage-blobs-introduction).
3. Adding new files to Blob storage triggers an Event Grid notification to be sent to an Azure Function.
4. Azure Functions sends a link to the newly uploaded file to the [Computer Vision API](/azure/cognitive-services/computer-vision/home) to analyze.
5. Once the data has been returned from the Computer Vision API, Azure Functions makes an entry in Cosmos DB to persist the results of the analysis along with the image metadata.

### Components

- [Computer Vision API](https://azure.microsoft.com/services/cognitive-services/computer-vision) is part of the Cognitive Services suite and is used to retrieve information about each image.
- [Azure Functions](https://azure.microsoft.com/services/functions) provides the back-end API for the web application. This platform also provides event processing for uploaded images.
- [Azure Event Grid](https://azure.microsoft.com/services/event-grid) triggers an event when a new image is uploaded to blob storage. The image is then processed with Azure functions.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) stores all of the image files that are uploaded into the web application, as well any static files that the web application consumes.
- [Azure Cosmos DB](https://azure.microsoft.com/free/cosmos-db) stores metadata about each image that is uploaded, including the results of the processing from Computer Vision API.

### Alternatives

- [Custom Vision Service](https://azure.microsoft.com/services/cognitive-services/custom-vision-service). The Computer Vision API returns a set of [taxonomy-based categories][cv-categories]. If you need to process information that isn't returned by the Computer Vision API, consider the Custom Vision Service, which lets you build custom image classifiers.
- [Cognitive Search](https://azure.microsoft.com/services/search) (formerly Azure Search). If your use case involves querying the metadata to find images that meet specific criteria, consider using Cognitive Search. Currently in preview, [Cognitive search](https://azure.microsoft.com/services/search) seamlessly integrates this workflow.
- [Logic Apps](https://azure.microsoft.com/services/logic-apps). If you don't need to react in real-time on added files to a blob, you might consider using Logic Apps. A logic app which can check if a file was added might be start by the [recurrence trigger or sliding windows trigger](/azure/logic-apps/concepts-schedule-automated-recurring-tasks-workflows).

## Considerations

### Scalability

The majority of the components used in this example scenario are managed services that will automatically scale. A couple of notable exceptions: Azure Functions has a limit of a maximum of 200 instances. If you need to scale beyond this limit, consider multiple regions or app plans.

You can provision Cosmos DB to [autoscale](/azure/cosmos-db/how-to-provision-autoscale-throughput?tabs=api-async) for SQL API only. If you plan to use other APIs see guidance on estimating your requirements, see [request units](/azure/cosmos-db/request-units) in our documentation. To fully take advantage of the scaling in Cosmos DB, understand how [partition keys](/azure/cosmos-db/partition-data) work in Cosmos DB.

NoSQL databases frequently trade consistency (in the sense of the CAP theorem) for availability, scalability, and partitioning. In this example scenario, a key-value data model is used and transaction consistency is rarely needed as most operations are by definition atomic. Additional guidance to [Choose the right data store](../../guide/technology-choices/data-store-overview.md) is available in the Azure Architecture Center. If your implementation requires high consistency, you can [choose your consistency level](/azure/cosmos-db/consistency-levels) in Cosmos DB.

For general guidance on designing scalable solutions, see the [performance efficiency checklist][scalability] in the Azure Architecture Center.

### Security

[Managed identities for Azure resources][msi] are used to provide access to other resources internal to your account and then assigned to your Azure Functions. Only allow access to the requisite resources in those identities to ensure that nothing extra is exposed to your functions (and potentially to your customers).

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

All of the components in this scenario are managed, so at a regional level they are all resilient automatically.

For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Pricing

To explore the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic (we assume all images are 100 kb in size):

- [Small][small-pricing]: this pricing example correlates to processing &lt; 5000 images a month.
- [Medium][medium-pricing]: this pricing example correlates to processing 500,000 images a month.
- [Large][large-pricing]: this pricing example correlates to processing 50 million images a month.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal authors:**

 * [David Stanford](https://www.linkedin.com/in/das0) | Principal PM

## Next steps

Product documentation
- [What is Computer Vision?](/azure/cognitive-services/computer-vision/home)
- [AI enrichment in Azure Cognitive Search](/azure/search/cognitive-search-concept-intro)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [What is Azure Event Grid?](/azure/event-grid/overview)
- [Introduction to Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)

For a guided learning path, see:
- [Build a serverless web app in Azure][serverless]
- [Classify images with the Custom Vision service](/learn/modules/classify-images-custom-vision)
- [Use AI to recognize objects in images by using the Custom Vision service](/learn/modules/train-custom-vision-ai/)
- [Classify endangered bird species with Custom Vision](/learn/modules/cv-classify-bird-species/)
- [Classify images with the Microsoft Custom Vision Service](/learn/modules/classify-images-with-custom-vision-service/)
- [Detect objects in images with the Custom Vision service](/learn/modules/detect-objects-images-custom-vision/)

Before deploying this example scenario in a production environment, review recommended practices for [optimizing the performance and reliability of Azure Functions][functions-best-practices].

## Related resources

- [Knowledge mining in digital asset management](../../solution-ideas/articles/digital-asset-management.yml)
- [AI enrichment with image and natural language processing in Azure Cognitive Search](../../solution-ideas/articles/cognitive-search-with-skillsets.yml)


<!-- links -->
[architecture]: ./media/architecture-intelligent-apps-image-processing.png
[small-pricing]: https://azure.com/e/ee2cac4c69e84a328b578fcd3a398653
[medium-pricing]: https://azure.com/e/7c7fc474db344b87aae93bc29ae27108
[large-pricing]: https://azure.com/e/cbadbca30f8640d6a061f8457a74ba7d
[serverless]: /learn/paths/create-serverless-applications/
[cv-categories]: /azure/cognitive-services/computer-vision/category-taxonomy
[resiliency]: /azure/architecture/framework/resiliency/principles
[security]: /azure/security
[scalability]: /azure/architecture/framework/scalability/performance-efficiency
[functions-best-practices]: /azure/azure-functions/functions-best-practices
[msi]: /azure/app-service/app-service-managed-service-identity
