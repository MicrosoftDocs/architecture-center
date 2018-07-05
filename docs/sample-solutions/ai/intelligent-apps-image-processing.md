---
title: Intelligent apps - image processing on Azure
description: Proven solution for building image processing into your Azure applications.
author: david-stanford
ms.date: 07/05/2018
---
# Insurance claim image classification on Azure

This sample solution is applicable for businesses that have an image processing need.

Potential applications include classifying images for a fashion website, analyzing text and images for insurance claims or understanding telemetry data from game screenshots. Traditionally, companies would need to develop expertise in machine learning models, train the models, and then finally run the images through their custom process to get the data out of the images.

By leveraging Azure services such as the Computer Vision API and Azure Functions, companies can remove the undifferentiated heavy lifting of an on-premises or IaaS deployment, while reducing costs and leveraging the expertise that Microsoft has already developed around processing images with Cognitive services. This scenario will specifically solve an image processing scenario, however, if you have different AI needs, you may want to consider the full suite of [Cognitive Services][cognitive-docs].

## Potential use cases

You should consider this solution for the following use cases:

* Classify images on a fashion website.
* Classify images for insurance claims
* Classify telemetry data from screenshots of games.

## Architecture

![Intelligent apps architecture - computer vision][architecture-computer-vision]

This solution covers the back-end components of a web or mobile application, the data flows through the solution as follows:

1. The first point of contact the application has with the solution is Azure Functions which acts as the API layer. The APIs enable a couple behaviors for the application: the ability to upload images, and the ability to retrieve data from Cosmos DB.

2. When an image is uploaded via an API call it is stored in Blob storage.

3. New files add to Blob storage trigger an EventGrid notification to be sent to an Azure Function.

4. Azure Functions sends a link to the newly uploaded file to the Computer Vision API to analyze.

5. Once the data has been returned from the Computer Vision API, Azure Functions makes an entry in Cosmos DB to persist the results of the analysis alongside the image metadata.

### Components

* [Computer Vision API][computer-vision-docs] is part of the Cognitive Services suite and is used to retrieve information about each image.

* [Azure Functions][functions-docs]: this provides the backend API for the web application, as well as the event processing for uploaded images.

* [Event Grid][eventgrid-docs]: triggers an event when a new image is uploaded to blob storage, that is then processed with Azure functions.

* [Blob Storage][storage-docs]: you use Azure Blob storage to host all of the image files that are uploaded into your web application, as well any static files that your web application consumes.

* [Cosmos DB][cosmos-docs]: Cosmos DB is used to hold metadata about each image that is uploaded, including the results of the processing from Computer Vision API.

## Alternatives

* [Custom Vision API][custom-vision-docs]: If you need to process images to retrieve information that isn't returned by the Computer Vision API, which returns these [86 categories][cv-categories]. Then you should consider the Custom Vision API.

* [Azure Search][azure-search-docs]: If your use case involves querying the metadata to find images that meet specific criteria then you should consider leverage Azure Search for that purpose.  Currently, in preview, [Cognitive search][cognitive-search] seamlessly integrates this workflow.

## Considerations

### Availability

All of the components of this solution are managed services that automatically scale.  Azure Functions has a limit of a maximum of 200 instances, so if you are going to scale beyond that you should consider multiple regions / app plans.  

### Scalability

You use Cosmos DB in this situation as the lookups will consistently be by the key, and you will not be querying by value.  Which is one of the ways that a NoSQL database excels. Additional guidance to [Choose the right data store](../../guide/technology-choices/data-store-overview.md) is available in the architecture center.

For other scalability topics please see the  [scalability checklist][] available in the architecure center.

### Security

[Managed service identities][msi] (MSI) are used to provide access to other resources internal to your account and then assigned to your Azure Functions. Only allow access to the requisite resources in those identities to ensure that nothing extra is exposed to your functions (and potentially to your customers).  

For a deeper discussion on [security][] please see the relevant article in the architecure center.

### Resiliency

All of the components in this solution are managed, so at a regional level they are all resilient automatically.  For a deeper exploration of [resiliency][] please see the relevant article in the architecure center.

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic (we assume all images are 100kb in size):

* [Small][pricing]: this correlates to processing &lt; 5000 images a month.
* [Medium][medium-pricing]: this correlates to processing 500,000 images a month.
* [Large][large-pricing]: this correlates to processing 50 million images a month.

## Related Resources

For a guided learning path of this solution please see [Build a serverless web app in Azure][serverless].  

Before putting this in a production environment review the Azure Functions [best practices][functions-best-practices].

<!-- links -->
[pricing]: https://azure.com/e/f9b59d238b43423683db73f4a31dc380
[medium-pricing]: https://azure.com/e/7c7fc474db344b87aae93bc29ae27108
[large-pricing]: https://azure.com/e/cbadbca30f8640d6a061f8457a74ba7d
[functions-docs]: https://docs.microsoft.com/en-us/azure/azure-functions/
[computer-vision-docs]: https://docs.microsoft.com/en-us/azure/cognitive-services/computer-vision/home
[storage-docs]: https://docs.microsoft.com/en-us/azure/storage/
[azure-search-docs]: https://docs.microsoft.com/en-us/azure/search/
[cognitive-search]: https://docs.microsoft.com/en-us/azure/search/cognitive-search-concept-intro
[architecture-computer-vision]: ./media/architecture-computer-vision.png
[serverless]: https://docs.microsoft.com/en-us/azure/functions/tutorial-static-website-serverless-api-with-database
[cosmos-docs]: https://docs.microsoft.com/en-us/azure/cosmos-db/
[eventgrid-docs]: https://docs.microsoft.com/en-us/azure/event-grid/
[cognitive-docs]: https://docs.microsoft.com/en-us/azure/#pivot=products&panel=ai
[custom-vision-docs]: https://docs.microsoft.com/en-us/azure/cognitive-services/Custom-Vision-Service/home
[cv-categories]: https://docs.microsoft.com/en-us/azure/cognitive-services/computer-vision/home#the-86-category-concept
[resiliency]: https://docs.microsoft.com/en-us/azure/architecture/resiliency/
[security]: https://docs.microsoft.com/en-us/azure/architecture/patterns/category/security
[scalability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability
[functions-best-practices]: https://docs.microsoft.com/en-us/azure/azure-functions/functions-best-practices
[msi]: https://docs.microsoft.com/en-us/azure/app-service/app-service-managed-service-identity