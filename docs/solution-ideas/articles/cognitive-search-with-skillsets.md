---
title: AI enrichment with Azure Cognitive Search
titleSuffix: Azure Example Scenarios
author: jocontr
ms.date: 06/01/2020
description: Learn how to use Azure Cognitive Search pre-built skills and custom extensibility to enrich large unstructured data sets into indexable structured data.
ms.custom: fcp
---

# AI enrichment with Azure Cognitive Search

The [JFK Files](https://www.archives.gov/research/jfk/2017-release), containing over 34,000 pages of documents about the CIA investigation of the 1963 JFK assassination, include a large amount of unstructured data, typewritten and handwritten notes, photos and other images that standard search solutions can't parse.

*AI enrichment* in Azure Cognitive Search can extract and enhance searchable, indexable text from images, blobs, and other unstructured data sources by using pre-trained machine learning skillsets from the Cognitive Services [Computer Vision](https://docs.microsoft.com/azure/cognitive-services/computer-vision/home) and [Text Analytics](https://docs.microsoft.com/azure/cognitive-services/text-analytics/overview) APIs. You can also create and attach [custom skills](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface) to add special processing for domain-specific data. Azure Cognitive Search can then index and search the context.

- *Natural language processing* skills like [entity recognition](https://docs.microsoft.com/azure/search/cognitive-search-skill-entity-recognition), [language detection](https://docs.microsoft.com/azure/search/cognitive-search-skill-language-detection), [key phrase extraction](https://docs.microsoft.com/azure/search/cognitive-search-skill-keyphrases), and [text recognition](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text) map unstructured text to searchable and filterable fields in an index.

- *Image processing skills* like [Optical Character Recognition (OCR)](https://docs.microsoft.com/azure/search/cognitive-search-skill-ocr), [Read](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text#read-api), and [image analysis](https://docs.microsoft.com/azure/search/cognitive-search-skill-image-analysis) include object and face detection, tag and caption generation, and celebrity and landmark identification. These skills create text representations of image content, which are searchable using the query capabilities of Azure Cognitive Search.

This example solution uses Azure Cognitive Search AI enrichment to extract meaning from the original complex, unstructured JFK files dataset. You can work through the project, watch the process in action in an [online video](https://channel9.msdn.com/Shows/AI-Show/Using-Cognitive-Search-to-Understand-the-JFK-Documents), or explore the JFK files with an [online demo](https://aka.ms/jfkfiles-demo).

## Potential use cases

- Increase the value and utility of unstructured text and image content in search and data science apps.
- Use custom skills to integrate open-source, third-party, or first-party code into indexing pipelines.
- Make scanned BMP or JPG documents full-text searchable.
- Produce better outcomes than standard PDF text extraction for PDFs with combined image and text.
- Create new information from inherently meaningful raw content or context that's hidden in larger unstructured or semi-structured documents.

## Architecture

![Cognitive Search architecture to convert unstructured into structured data](../media/cognitive-search.png)

This diagram illustrates the process of passing unstructured data through the Cognitive Search skills pipeline to produce structured, indexable data.

1. Blob storage provides unstructured document and image data to Cognitive Search.
1. Cognitive Search applies pre-built cognitive skillsets to the data, including OCR, text and handwriting recognition, image analysis, entity recognition, and full-text search.
1. The Cognitive Search extensibility mechanism uses an Azure Function to apply the CIA Cryptonyms custom skill to the data.
1. The pre-built and custom skillsets deliver structured knowledge that Azure Cognitive Search can index.

## Components

Azure Cognitive Search works with other Azure components to provide this solution.

### Azure Blob Storage

[Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) is REST-based object storage for data that you can access from anywhere in the world via HTTPS. You can use Blob storage to expose data publicly to the world, or to store application data privately. Blob storage is ideal for large amounts of unstructured data like text or graphics.

### Azure Cognitive Search

[Cognitive Search](https://azure.microsoft.com/services/search/) indexes the content and powers the user experience. You use Cognitive Search capabilities to apply [pre-built cognitive skills](https://docs.microsoft.com/azure/search/cognitive-search-predefined-skills) to the content, and use the extensibility mechanism to add [custom skills](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface).

- The [Computer Vision API](https://azure.microsoft.com/services/cognitive-services/computer-vision/) uses [text recognition APIs](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text) to extract and recognize text information from images. [Read](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text#read-api) uses the latest recognition models, and is optimized for large, text-heavy documents and noisy images. [OCR](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text#ocr-optical-character-recognition-api) isn't optimized for large documents, but supports more languages. The current example uses OCR to produce data in the [hOCR format](https://en.wikipedia.org/wiki/HOCR).

- The [Text Analytics API](https://docs.microsoft.com/azure/cognitive-services/text-analytics/overview) extracts text information from unstructured documents by using capabilities like [Named Entity Recognition (NER)](https://docs.microsoft.com/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking), [key phrase extraction](https://docs.microsoft.com/azure/search/cognitive-search-skill-keyphrases), and [full-text search](https://docs.microsoft.com/azure/search/search-lucene-query-architecture).

- [Custom skills](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface) extend Cognitive Search to apply specific enrichment transformations to content. The current example creates a custom skill to apply [CIA Cryptonyms](https://www.maryferrell.org/php/cryptdb.php), which decode uppercased code names in CIA documents. For example, the CIA assigned the cryptonym `GPFLOOR` to Lee Harvey Oswald, so the custom *CIA Cryptonym* skill links any JFK files containing that cryptonym with Oswald.

### Azure Functions

[Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview) is a serverless compute service that lets you run small pieces of event-triggered code without having to explicitly provision or manage infrastructure. This example uses an Azure Function method to apply the *CIA Cryptonyms* list to the JFK files as a custom skill.

### Azure App Service

The example solution also builds a standalone web app in [Azure App Service](https://docs.microsoft.com/azure/app-service/) for testing, demonstrating, searching the index, and exploring connections in the enriched and indexed documents.

## Issues and considerations

- The code project and demo showcase a particular Cognitive Search use case. This example isn't intended to be a framework or scalable architecture for all scenarios, but to provide a general guideline and example.
- [OCR](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text#ocr-optical-character-recognition-api) results vary greatly depending on scan and image quality. - [Read](https://docs.microsoft.com/azure/cognitive-services/computer-vision/concept-recognizing-text#read-api) uses the latest recognition models, but has less [language support](https://docs.microsoft.com/azure/cognitive-services/computer-vision/language-support#text-recognition) than OCR. 
- Some scanned and native PDF formats may not parse correctly in Cognitive Search.
- The JFK Files sample project and demo create a public website and publicly readable storage container for extracted images. Don't use this project for non-public data.

## Next steps

- [The JFK Files lab](https://github.com/microsoft/AzureSearch_JFK_Files)
- [Get started with AI enrichment](https://docs.microsoft.com/azure/search/cognitive-search-concept-intro)
- [How to use Named Entity Recognition in Text Analytics](https://docs.microsoft.com/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking)
- [Azure Blob storage](https://docs.microsoft.com/azure/storage/blobs/storage-blobs-introduction)
- [Azure Cognitive Search](https://docs.microsoft.com/azure/search/cognitive-search-resources-documentation)
- [Azure Functions](https://docs.microsoft.com/azure/azure-functions/)
