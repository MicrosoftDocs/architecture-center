---
title: Intelligent Apps on Azure
description: Proven solution for building intelligence into your Azure applications.
author: david-stanford
ms.date: 06/01/2018
---
# Intelligent Applications on Azure

In this example, image processing functions would invoke the Computer Vision Cognitive Service for automatically creating the caption and the tags from any supplied images. A mixture of pre-built AI in the form of Cognitive Services and custom AI in the form of Azure ML services would be used to process the text. Azure Functions would be used to coordinate the calls to the classifications and summary AI services which would run as containerized web services in Azure Container Service, while the Text Analytics API could be invoked directly to provide a sentiment score for each text.
Once all processing has completed, one final Azure Function could be used to insert the complete document into Azure Search for future searches. The document inserted would contain specific tabs and search metadata, so that it could always be tied back to the record store in Azure SQL Database.

## Potential use cases

You should use this solution for the following use cases:

* Classifying images on a fashion website.
* Classify images & text for insurance claims
* Capture and classify telemetry data from screenshots of games.

## Architecture diagram

The solution diagram below is an example of this solution:

![Intelligent apps architecture][architecture-intelligent-apps]

## Architecture components

These are the components found in this solution:

* [Computer Vision API][computer-vision-docs]
* [Azure Functions][functions-docs]

## Architecture considerations

Here we will discuss the major architectural components of the solution, what some of the alternative options are, and why we selected the things we did.

### Data storage

There are a couple types of data present in this scenario. Raw data that relates to each individual customer submission, data derived via machine learning, and finally the meta-data to relate raw data to the customer.

We are storing the raw image data in Azure blob storage, the other storage options are detailed in our [storage documentation][storage-documentation].

### AI Processing

In this solution we are primarily processing images, there are two main options in Azure to consider: Computer Vision API & the Custom Vision API. The main difference between the two is the computer vision API comes pre-trained and will give you a good amount of information by default. You need to provide training images and classifications to the custom vision API in order for it to give you back the information that you might be looking for.

## Deploy the solution

This section is intended to allow the customer to deploy a template into their own account.

**Prequisites.** You must have an existing Azure account.

To deploy the solution, perform the following steps.

1. Click the button below:<br><a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fhybrid-networking%2Fvpn%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
2. Wait for the link to open in the Azure portal, then follow these steps: 
   * The **Resource group** name is already defined in the parameter file, so select **Create New** and enter `ra-hybrid-vpn-rg` in the text box.
   * Select the region from the **Location** drop down box.
   * Do not edit the **Template Root Uri** or the **Parameter Root Uri** text boxes.
   * Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
   * Click the **Purchase** button.
3. Wait for the deployment to complete.

## Pricing

Explore the [cost][pricing] of running this solution.

<!-- links -->
[pricing]: https://azure.microsoft.com/en-us/pricing/calculator/
[functions-docs]: https://docs.microsoft.com/en-us/azure/azure-functions/
[computer-vision-docs]: https://docs.microsoft.com/en-us/azure/cognitive-services/computer-vision/home
[storage-documentation]: https://docs.microsoft.com/en-us/azure/storage/
[architecture-intelligent-apps]: ./media/architecture-intelligent-apps.png