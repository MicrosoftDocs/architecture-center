---
title: Intelligent Apps on Azure
description: Proven solution for building intelligence into your Azure applications.
author: david-stanford
ms.date: 06/01/2018
---
# Intelligent Applications on Azure

In this example, image processing functions would invoke the Computer Vision Cognitive Service for automatically creating the caption and the tags from any supplied images. A mixture of pre-built AI in the form of Cognitive Services and custom AI in the form of Azure ML services would be used to process the text. Azure Functions would be used to coordinate the calls to the classifications and summary AI services which would run as containerized web services in Azure Container Service, while the Text Analytics API could be invoked directly to provide a sentiment score for each text. 
Once all processing has completed, one final Azure Function could be used to insert the complete document into Azure Search for future searches. The document inserted would contain specific tabs and search metadata, so that it could always be tied back to the record store in Azure SQL Database.
Hero Services: Azure SQL DB, Azure Search, Azure Functions, Azure Storage, Azure Cognitive Services, Azure ML Services.

## Architecture

The solution diagram below is an example of a solution built using this reference architecture:

