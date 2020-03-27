---
title: AI-first approach to content understanding with Azure Cognitive Search
titleSuffix: Azure Solution Ideas
author: jocontr
ms.date: 03/27/2020
description: Convert large amounts of unstructured data such as the JFK Files into indexable, structured data with Azure Cognitive Search.
ms.custom: Azure Cognitive Search, cognitive skills, JKF Files Lab, 'https://azure.microsoft.com/solutions/architecture/jfk-files-lab/'
---
# AI-first approach to content understanding with Azure Cognitive Search

[!INCLUDE [header_file](../header.md)]

Cognitive Search is an Azure service that ingests your data from almost any data source, enriches it using a set of cognitive skills, and finally enables you to explore the data using Azure Search. This scenario shows how to use the Cognitive Search skills to convert unstructured into structured data. The JFK Lab provides an example of how this can be successfully applied to a complex dataset.

## Architecture

![Detailed diagram of the JFK Cognitive Search architecture to convert unstructured into structured data. On the left, the storage blob and unstructured data provide input to Azure Search. Within Azure Search, they're first processed by the Cognitive Search Skillsets for enriching JFK documents. This includes documents, images, OCR, Handwriting, Computer Vision, Redaction, Full text, Entities, and Cryptonyms. These skillsets deliver structure knowledge that can be indexed.](../media/jfk-cognitive-search.jpg)

## Data Flow

1. The storage blob and unstructured data provide input to Azure Search.
1. Within Azure Search, data is first processed by the Cognitive Search Skillsets for enriching JFK documents. This includes documents, images, OCR, Handwriting, Computer Vision, Redaction, Full text, Entities, and Cryptonyms.
1. These skillsets deliver structure knowledge.
1. Azure Search can now index the dataset.
1. A JFK Files frontend is deployed to an Azure web app that you can immediately interact with.

## Components

* [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/): REST-based object storage for large amounts of unstructured data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. You can use Blob storage to expose data publicly to the world, or to store application data privately.
* [Azure Search](https://azure.microsoft.com/services/search/): This service is used to index the content and power the UX experience. We use the new Cognitive Search capabilities to apply pre-built cognitive skills to the content, and we also use the extensibility mechanism to add custom skills using [Azure Functions](https://azure.microsoft.com/services/functions/):
  * [Cognitive Services Vision API](https://azure.microsoft.com/services/cognitive-services/computer-vision/): It's used to extract text information from the image via OCR, handwriting, and image captioning.
  * Named Entity Recognition: It's applied to extract named entities from the documents.
  * [CIA Cryptonyms](https://www.maryferrell.org/php/cryptdb.php): In the specific scenario of the JFK Files, it may be interesting to annotate text using a custom CIA Cryptonyms skill. Other datasets will require different custom skills.
  * [HOCR content](https://en.wikipedia.org/wiki/HOCR): It's generated based on results.
* A standalone web application to search the index and explore connections between the documents.

## Next Steps

* [Learn more about Azure Blob storage](https://docs.microsoft.com/azure/storage/blobs/storage-blobs-introduction)
* [Learn more about Azure Cognitive Search](https://docs.microsoft.com/azure/search/cognitive-search-resources-documentation)
* [Learn more about Azure Functions](https://docs.microsoft.com/azure/azure-functions/)
* [Learn more about Cognitive Services](https://docs.microsoft.com/azure/cognitive-services/)
* [Learn more about Named Entity Recognition](https://docs.microsoft.com/azure/search/cognitive-search-skill-named-entity-recognition)
* [Learn more about the JFK Files lab](https://github.com/microsoft/AzureSearch_JFK_Files)

[!INCLUDE [js_include_file](../../_js/index.md)]
