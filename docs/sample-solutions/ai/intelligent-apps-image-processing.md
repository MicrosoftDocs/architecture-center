---
title: Intelligent apps - image processing on Azure
description: Proven solution for building image processing into your Azure applications.
author: david-stanford
ms.date: 06/01/2018
---
# Intelligent Applications - Image Processing on Azure

This sample solution is applicable for businesses that have an image processing need.

Potential applications include classifying images for a fashion website, analyzing text and images for insurance claims or understanding telemetry data from game screenshots. Traditionally, companies would need to develop expertise in machine learning models, train the models, and then finally run the images through their custom process to get the data out of the images. 

By leveraging Azure services such as the Computer Vision API and Azure Functions, companies can remove the undifferentiated heavy lifting of an on-premises or IaaS deployment, while reducing costs and leveraging the expertise that Microsoft has already developed around processing images with Cognitive services… This scenario will specifically solve an image processing scenario, however, if you have different AI needs, you may want to consider the full suite of [Cognitive Services][cognitive-docs].

## Potential use cases

You should consider this solution for the following use cases:

* Classify images on a fashion website.
* Classify images for insurance claims
* Classify telemetry data from screenshots of games.

## Architecture diagram

The solution diagram below is an example of this solution:

![Intelligent apps architecture - computer vision][architecture-computer-vision]

## Architecture

This solution covers the back-end components of a web or mobile application, the data flows through the solution as follows:

1. The first point of contact the application has with the solution is Azure Functions which acts as the API layer. The APIs enable a couple behaviors for the application: the ability to upload images, and the ability to retrieve data from Cosmos DB.

2. When an image is uploaded via an API call it is stored in Blob storage.

3. New files add to Blob storage trigger an EventGrid notification to be sent to an Azure Function.

4. Azure Functions sends a link to the newly uploaded file to the Computer Vision API to analyze.

5. Once the data has been returned from the Computer Vision API, Azure Functions makes an entry in Cosmos DB to persist the results of the analysis alongside the image metadata.

These are the components found in this solution:

* [Resource Groups][resource-groups] is a logical container for Azure resources.

* [Computer Vision API][computer-vision-docs] is part of the Cognitive Services suite and is used to retrieve information about each image.

* [Azure Functions][functions-docs]: this provides the backend API for the web application, as well as the event processing for uploaded images.

* [Event Grid][eventgrid-docs]: triggers an event when a new image is uploaded to blob storage, that is then processed with Azure functions.

* [Blob Storage][storage-docs]: you use Azure Blob storage to host all of the image files that are uploaded into your web application, as well any static files that your web application consumes.

* [Cosmos DB][cosmos-docs]: Cosmos DB is used to hold metadata about each image that is uploaded, including the results of the processing from Computer Vision API.

### Data storage

There are a couple types of data present in this scenario. Raw data that relates to each individual customer submission, data derived via machine learning, and finally the metadata to relate raw image data to the customer.

In this scenario you're storing the raw image data in Azure blob storage with all of your metadata about the images and customers stored in Cosmos DB.

You use Cosmos DB in this situation as the lookups will consistently be by the key, and you will not be querying by value.  Which is one of the ways that a NoSQL database excels. Additional guidance to [Choose the right data store](../../guide/technology-choices/data-store-overview.md) is available in the architecture center.

### AI Processing

In this solution we are processing images, there are two main options in Azure to consider: Computer Vision API & the Custom Vision API. The main difference between the two is the Computer Vision API comes pre-trained and will give you a good amount of information by default. If this default set of data covers what you need then this is the appropriate choice.

If you need to process images to retrieve information that isn't returned by the Computer Vision API then you should consider the Custom Vision API. As you can train this service with your own image data to retrieve the information that you care about for your application.

## Deploy the solution

To deploy this sample solution into your account follow the directions below:

**Prerequisites.** You must have an existing Azure account.

To deploy the solution, perform the following steps.
1. Select the button below:<br><a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Farchitecture-center%2Fmaster%2Fsample-solutions%2Fai%2Ftemplates%2Fintelligent-apps-image-processing.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
2. Wait for the link to open in the Azure portal, then follow these steps: 
   * The **Resource group** name is already defined in the parameter file, so select **Create New** and enter `computer-vision-solution` in the text box.
   * Select the region from the **Location** drop down box.
   * Do not edit the **Template Root Uri** or the **Parameter Root Uri** text boxes.
   * Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
   * Click the **Purchase** button.
3. Wait for the deployment to complete.

## Pricing

Explore the [cost][pricing] of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

## Related Resources

For a guided learning path of this solution please see [Build a serverless web app in Azure][serverless]

<!-- links -->
[pricing]: https://azure.com/e/d886c0e6c8b2414a9485d67c4691cf2c
[functions-docs]: https://docs.microsoft.com/en-us/azure/azure-functions/
[computer-vision-docs]: https://docs.microsoft.com/en-us/azure/cognitive-services/computer-vision/home
[storage-docs]: https://docs.microsoft.com/en-us/azure/storage/
[architecture-computer-vision]: ./media/architecture-computer-vision.png
[serverless]: https://docs.microsoft.com/en-us/learn/build-serverless-app/index
[cosmos-docs]: https://docs.microsoft.com/en-us/azure/cosmos-db/
[eventgrid-docs]: https://docs.microsoft.com/en-us/azure/event-grid/
[resource-groups]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview
[cognitive-docs]: https://docs.microsoft.com/en-us/azure/#pivot=products&panel=ai
