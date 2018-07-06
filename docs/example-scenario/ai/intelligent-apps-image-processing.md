---
title: Intelligent apps - image processing on Azure
description: Proven solution for building image processing into your Azure applications.
author: david-stanford
ms.date: 07/05/2018
---
# Insurance claim image classification on Azure

This example scenario is applicable for businesses that need to process images.

Potential applications include classifying images for a fashion website, analyzing text and images for insurance claims, or understanding telemetry data from game screenshots. Traditionally, companies would need to develop expertise in machine learning models, train the models, and finally run the images through their custom process to get the data out of the images.

By using Azure services such as the Computer Vision API and Azure Functions, companies can eliminate the need to manage individual servers, while reducing costs and leveraging the expertise that Microsoft has already developed around processing images with Cognitive services. This scenario specifically addresses an image processing scenario. If you have different AI needs, consider the full suite of [Cognitive Services][cognitive-docs].

## Potential use cases

Consider this solution for the following use cases:

* Classify images on a fashion website.
* Classify images for insurance claims
* Classify telemetry data from screenshots of games.

## Architecture

![Intelligent apps architecture - computer vision][architecture-computer-vision]

This solution covers the back-end components of a web or mobile application. Data flows through the solution as follows:

1. Azure Functions acts as the API layer. These APIs enable the application to upload images and retrieve data from Cosmos DB.

2. When an image is uploaded via an API call, it's stored in Blob storage.

3. Adding new files to Blob storage triggers an EventGrid notification to be sent to an Azure Function.

4. Azure Functions sends a link to the newly uploaded file to the Computer Vision API to analyze.

5. Once the data has been returned from the Computer Vision API, Azure Functions makes an entry in Cosmos DB to persist the results of the analysis alongside the image metadata.

### Components

* [Computer Vision API][computer-vision-docs] is part of the Cognitive Services suite and is used to retrieve information about each image.

* [Azure Functions][functions-docs] provides the backend API for the web application, as well as the event processing for uploaded images.

* [Event Grid][eventgrid-docs] triggers an event when a new image is uploaded to blob storage. The image is then processed with Azure functions.

* [Blob Storage][storage-docs] stores all of the image files that are uploaded into the web application, as well any static files that the web application consumes.

* [Cosmos DB][cosmos-docs] stores metadata about each image that is uploaded, including the results of the processing from Computer Vision API.

## Alternatives

* [Custom Vision Service][custom-vision-docs]. The Computer Vision API returns a set of [taxonomy-based categories][cv-categories]. If you need to process information that isn't returned by the Computer Vision API, consider the Custom Vision Service, which lets you build custom image classifiers.

* [Azure Search][azure-search-docs]. If your use case involves querying the metadata to find images that meet specific criteria, consider using Azure Search. Currently in preview, [Cognitive search][cognitive-search] seamlessly integrates this workflow.

## Considerations

### Scalability

For the most part all of the components of this solution are managed services that will automatically scale. A couple notable exceptions: Azure Functions has a limit of a maximum of 200 instances. If you need to scale beyond, consider multiple regions or app plans.

Cosmos DB doesn’t auto-scale in terms of provisioned request units (RUs).  For guidance on estimating your requirements see [request units][request-units] in our documentation. To fully take advantage of the scaling in Cosmos DB you should also take a look at [partition keys][partition-key].

NoSQL databases frequently trade consistency (in the sense of the CAP theorem) for availability, scalability and partition.  However, in the case of key-value data models which is used in this scenario, transaction consistency is rarely needed as most operations are by definition atomic. Additional guidance to [Choose the right data store](../../guide/technology-choices/data-store-overview.md) is available in the architecture center.

For general guidance on designing scalable solutions, see the [scalability checklist][scalability] in the Azure Architecture Center.

### Security

[Managed service identities][msi] (MSI) are used to provide access to other resources internal to your account and then assigned to your Azure Functions. Only allow access to the requisite resources in those identities to ensure that nothing extra is exposed to your functions (and potentially to your customers).  

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

All of the components in this solution are managed, so at a regional level they are all resilient automatically. 

For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Pricing

To explore the cost of running this solution, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic (we assume all images are 100kb in size):

* [Small][pricing]: this correlates to processing &lt; 5000 images a month.
* [Medium][medium-pricing]: this correlates to processing 500,000 images a month.
* [Large][large-pricing]: this correlates to processing 50 million images a month.

## Related Resources

For a guided learning path of this solution, see [Build a serverless web app in Azure][serverless].  

Before putting this in a production environment, review the Azure Functions [best practices][functions-best-practices].

<!-- links -->
[pricing]: https://azure.com/e/f9b59d238b43423683db73f4a31dc380
[medium-pricing]: https://azure.com/e/7c7fc474db344b87aae93bc29ae27108
[large-pricing]: https://azure.com/e/cbadbca30f8640d6a061f8457a74ba7d
[functions-docs]: /azure/azure-functions/
[computer-vision-docs]: /azure/cognitive-services/computer-vision/home
[storage-docs]: /azure/storage/
[azure-search-docs]: /azure/search/
[cognitive-search]: /azure/search/cognitive-search-concept-intro
[architecture-computer-vision]: ./media/architecture-computer-vision.png
[serverless]: /azure/functions/tutorial-static-website-serverless-api-with-database
[cosmos-docs]: /azure/cosmos-db/
[eventgrid-docs]: /azure/event-grid/
[cognitive-docs]: /azure/#pivot=products&panel=ai
[custom-vision-docs]: /azure/cognitive-services/Custom-Vision-Service/home
[cv-categories]: /azure/cognitive-services/computer-vision/home#the-86-category-concept
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
[functions-best-practices]: /azure/azure-functions/functions-best-practices
[msi]: /azure/app-service/app-service-managed-service-identity
[request-units]: /azure/cosmos-db/request-units
[partition-key]: /azure/cosmos-db/partition-data