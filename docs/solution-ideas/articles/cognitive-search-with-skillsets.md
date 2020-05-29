---
title: AI enrichment with Azure Cognitive Search
titleSuffix: Azure Solution Ideas
author: jocontr
ms.date: 05/28/2020
description: Learn how to use Azure Cognitive Search pre-built skills and custom extensibility to enrich large unstructured data sets like the JFK Files into indexable, structured data.
ms.custom: fcp
---

# AI enrichment with Azure Cognitive Search

*AI enrichment* in Azure Cognitive Search extracts searchable, indexable text from images, blobs, and other unstructured data sources by using pre-trained machine learning skillsets from the Cognitive Services [Computer Vision](https://docs.microsoft.com/azure/cognitive-services/computer-vision/home) and [Text Analytics](https://docs.microsoft.com/azure/cognitive-services/text-analytics/overview) APIs. Cognitive Search AI enrichment is extensible, so you can also create and attach [custom skills](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface) to integrate custom processing for domain-specific data.

*Natural language processing* skills like [entity recognition](https://docs.microsoft.com/azure/search/cognitive-search-skill-entity-recognition), [language detection](https://docs.microsoft.com/azure/search/cognitive-search-skill-language-detection), [key phrase extraction](https://docs.microsoft.com/azure/search/cognitive-search-skill-keyphrases), and [text recognition](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text) map unstructured text to searchable and filterable fields in an index.

*Image processing skills* like [Optical Character Recognition (OCR)](https://docs.microsoft.com/azure/search/cognitive-search-skill-ocr) and [image analysis](https://docs.microsoft.com/azure/search/cognitive-search-skill-image-analysis) create text representations of image content, which are searchable using the query capabilities of Azure Cognitive Search.

This article presents an example project and demo that apply Cognitive Search to a complex unstructured dataset, the original [JFK Assassination Files][jfk-files-lab].

## Architecture

![Cognitive Search architecture to convert unstructured into structured data](../media/cognitive-search.png)

1. Blob storage provides unstructured document and image data to Azure Cognitive Search.
1. Cognitive Search applies pre-built cognitive skillsets to the data, including OCR, text and handwriting recognition, image analysis, [entity recognition](https://docs.microsoft.com/azure/search/cognitive-search-skill-entity-recognition), and [full-text search](https://docs.microsoft.com/azure/search/search-lucene-query-architecture).
1. The Cognitive Search extensibility mechanism uses an Azure Function to apply the CIA Cryptonyms [custom skill](https://docs.microsoft.com/azure/search/cognitive-search-create-custom-skill-example) to the data.
1. The pre-built and custom skillsets deliver structured knowledge that Azure Cognitive Search can index.

## Components

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) is REST-based object storage for data that you can access from anywhere in the world via HTTPS. You can use Blob storage to expose data publicly to the world, or to store application data privately. Blob storage is ideal for large amounts of unstructured data like text or graphics.
- [Azure Cognitive Search](https://azure.microsoft.com/services/search/) indexes the content and powers the user experience. You use Cognitive Search capabilities to apply [pre-built cognitive skills](https://docs.microsoft.com/azure/search/cognitive-search-predefined-skills) to the content, and use the extensibility mechanism with [Azure Functions](https://azure.microsoft.com/services/functions/) to add [custom skills](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface).
  - The [Computer Vision API](https://azure.microsoft.com/services/cognitive-services/computer-vision/) uses the [Read, OCR, and Recognize Text APIs](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text) to extract and recognize text information from images. The [Read API](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text#read-api) uses the latest recognition models and is optimized for text-heavy and noisy images. The [OCR API](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text#ocr-optical-character-recognition-api) produces data in the [hOCR format](https://en.wikipedia.org/wiki/HOCR) and isn't optimized for large documents, but supports more languages.
  - The [Text Analytics API](https://docs.microsoft.com/azure/cognitive-services/text-analytics/overview) extracts text information from unstructured documents by using capabilities like [Named Entity Recognition (NER)](https://docs.microsoft.com/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking) and [key phrase extraction](https://docs.microsoft.com/azure/search/cognitive-search-skill-keyphrases).
  - [CIA Cryptonyms](https://www.maryferrell.org/php/cryptdb.php) is a custom CIA Cryptonyms skill for annotating text like the JFK Files. Other datasets require different custom skills.
- You can use an Azure App Service standalone web app to search the index and explore connections between the documents.

## Limitations and considerations

- The code project and demo showcase a particular Cognitive Search use case. This example isn't intended to be a framework or scalable architecture for all scenarios.
- OCR results vary greatly depending on scan and image quality.
- Cognitive Search supports most file formats and data sources, but some scanned and native PDF formats may not be parsed correctly.
- The JFK Files sample project and demo create a public website and a publicly readable storage container for extracted images. They aren't for use with non-public data.

## Next steps

- [Getting started with AI enrichment](https://docs.microsoft.com/azure/search/cognitive-search-concept-intro)
- [How to use Named Entity Recognition in Text Analytics](https://docs.microsoft.com/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking)
- [Azure Blob storage](https://docs.microsoft.com/azure/storage/blobs/storage-blobs-introduction)
- [Azure Cognitive Services](https://docs.microsoft.com/azure/cognitive-services/)
- [Azure Cognitive Search](https://docs.microsoft.com/azure/search/cognitive-search-resources-documentation)
- [Azure Functions](https://docs.microsoft.com/azure/azure-functions/)
- [The JFK Files lab][jfk-files-lab]

[jfk-files-lab]: https://github.com/microsoft/AzureSearch_JFK_Files
