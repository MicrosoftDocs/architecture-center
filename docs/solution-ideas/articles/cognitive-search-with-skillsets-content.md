[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to enrich text and image documents by using image processing, natural language processing, and custom skills to capture domain-specific data. You can use Azure AI Search with AI enrichment to help identify and explore relevant content at scale. This solution uses AI enrichment to extract meaning from the original complex, unstructured JFK Assassination Records (JFK Files) dataset.

## Architecture

:::image type="content" alt-text="Diagram that shows the AI Search architecture to convert unstructured data into structured data." source="../media/ai-search-with-ai-enrichment.svg" lightbox="../media/ai-search-with-ai-enrichment.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/cognitive-search-with-skillsets.vsdx) of this architecture.*

### Dataflow

The previous diagram illustrates how to pass the unstructured JFK Files dataset through the Azure Cognitive Search skills pipeline to produce structured and indexable data:

1. Unstructured data in Azure Blob Storage, such as documents and images, is ingested into AI Search.

1. To initiate the indexing process, the *document cracking* step extracts images and text from the data and then enriches the content. The enrichment steps in this process depend on the data and type of skills that you select:

    1. [Built-in skills](/azure/search/cognitive-search-predefined-skills) based on the Azure AI Vision and AI Language APIs provide AI enrichments such as image optical character recognition (OCR), image analysis, text translation, entity recognition, and full-text search.

    1. [Custom skills](/azure/search/cognitive-search-custom-skill-interface) support scenarios that require more complex AI models or services. Examples include AI Document Intelligence, Azure Machine Learning models, and Azure Functions.

1. After the enrichment process is complete, the indexer saves the outputs into a [search index](/azure/search/search-what-is-an-index) that contains the enriched and indexed documents. Full-text search and other query forms can use this index.

    1. You can also project the enriched documents into a [knowledge store](/azure/search/knowledge-store-concept-intro), which downstream apps like knowledge mining or data science can use.

1. Queries access the enriched content in the search index. The index supports custom analyzers, fuzzy search queries, filters, and a scoring profile to tune search relevance.

1. Applications that connect to Blob Storage or to Azure Table Storage can access the knowledge store.

### Components

AI Search works with other Azure components to provide this solution.

#### AI Search

[AI Search](https://azure.microsoft.com/services/search) indexes the content and powers the user experience in this solution. You can use AI Search to apply [prebuilt AI skills](/azure/search/cognitive-search-predefined-skills) to the content and the extensibility mechanism to add [custom skills](/azure/search/cognitive-search-custom-skill-interface) for specific enrichment transformations.

#### Azure AI Vision

[Vision](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-computer-vision/) uses [text recognition](/azure/cognitive-services/computer-vision/overview-ocr) to extract and recognize text information from images. The [Read API](/azure/cognitive-services/computer-vision/overview-ocr#read-api) uses the latest OCR recognition models, and is optimized for large, text-heavy documents and noisy images.

The [legacy OCR API](https://westus.dev.cognitive.microsoft.com/docs/services/computer-vision-v3-2/operations/56f91f2e778daf14a499f20d) isn't optimized for large documents but supports more languages. The accuracy of OCR results can vary based on the quality of the scan and the image. The current solution idea uses OCR to produce data in the [hOCR format](https://en.wikipedia.org/wiki/HOCR).

#### Azure AI Language

[Azure AI Language](https://azure.microsoft.com/services/cognitive-services/language-service) uses [text analytics](/azure/cognitive-services/language-service/overview#available-features) capabilities like [Named Entity Recognition (NER)](/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking) and [key phrase extraction](/azure/search/cognitive-search-skill-keyphrases) to extract text information from unstructured documents.

#### Azure Storage

[Blob Storage](https://azure.microsoft.com/services/storage/blobs) is REST-based object storage for data that you can access from anywhere in the world through HTTPS. You can use Blob Storage to expose data publicly to the world or to store application data privately. Blob Storage is ideal for large amounts of unstructured data like text or graphics.

[Table Storage](https://azure.microsoft.com/services/storage/tables) stores highly available, scalable, structured, or semi-structured NoSQL data in the cloud.

#### Azure Functions

[Functions](https://azure.microsoft.com/services/functions) is a serverless compute service that you can use to run small pieces of event-triggered code without having to explicitly provision or manage infrastructure. This solution uses a Functions method to apply the CIA Cryptonyms list to the JFK Assassination Records as a custom skill.

#### Azure App Service

This solution idea builds a standalone web app in [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) to test, demonstrate, search the index, and explore connections in the enriched and indexed documents.

## Scenario details

Large, unstructured datasets can include typewritten and handwritten notes, photos, diagrams, and other unstructured data that standard search solutions can't parse. The [JFK Assassination Records](https://www.archives.gov/research/jfk/2017-release) contain over 34,000 pages of documents about the CIA investigation of the 1963 JFK assassination.

The JFK Files [sample project](https://github.com/microsoft/AzureSearch_JFK_Files) and [online demo](https://aka.ms/jfkfiles-demo) presents a particular AI Search use case. This solution idea isn't intended to be a framework or scalable architecture for all scenarios. Instead, this solution idea provides a general guideline and example. The code project and demo create a public website and publicly readable storage container for extracted images, so you shouldn't use this solution with nonpublic data.

You can use AI enrichment in AI Search to extract and enhance searchable, indexable text from images, blobs, and other unstructured data sources like the JFK Files. AI enrichment uses pretrained machine learning skill sets from the AI Services [AI Vision](/azure/cognitive-services/computer-vision/home) and [AI Language](/azure/cognitive-services/text-analytics/overview) APIs. You can also create and attach [custom skills](/azure/search/cognitive-search-custom-skill-interface) to add special processing for domain-specific data like CIA Cryptonyms. AI Search can then index and search that context.

The AI Search skills in this solution can be categorized into the following groups:

- **Image processing**: Built-in [text extraction](/azure/cognitive-services/computer-vision/concept-recognizing-text#read-api) and [image analysis](/azure/search/cognitive-search-skill-image-analysis) skills that include object and face detection, tag and caption generation, and celebrity and landmark identification. These skills create text representations of image content, which you can search by using the query capabilities of Azure Cognitive Search. *Document cracking* is the process of extracting or creating text content from nontext sources.

- **Natural language processing**: Built-in skills like [entity recognition](/azure/search/cognitive-search-skill-entity-recognition), [language detection](/azure/search/cognitive-search-skill-language-detection), and [key phrase extraction](/azure/search/cognitive-search-skill-keyphrases) that you can use to map unstructured text to searchable and filterable fields in an index.

- **Custom skills**: Skills that you can use to apply specific enrichment transformations to content by [specifying the interface for a custom skill](/azure/search/cognitive-search-custom-skill-interface) through the [Custom Web API skill](/azure/search/cognitive-search-custom-skill-web-api).

### Potential use cases

- Increase the value and utility of unstructured text and image content in search and data science apps.

- Use custom skills to integrate open-source code, third-party code, or first-party code into indexing pipelines.

- Make scanned JPG, PNG, or bitmap documents full-text searchable.

- Produce better outcomes than standard PDF text extraction for PDFs with combined image and text. Some scanned and native PDF formats might not parse correctly in AI Search.

- Create new information from inherently meaningful raw content or context hidden in larger unstructured documents or semi-structured documents.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

 * [Carlos Alexandre Santos](https://www.linkedin.com/in/carlosafsantos) | Senior Specialized AI Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn more about this solution:

- [JFK Files project](https://github.com/microsoft/AzureSearch_JFK_Files)
- [Using Cognitive Search to understand the JFK documents](/shows/AI-Show/Using-Cognitive-Search-to-Understand-the-JFK-Documents)
- [JFK Files online demo](https://aka.ms/jfkfiles-demo)

Read product documentation:

- [AI enrichment in AI Search](/azure/search/cognitive-search-resources-documentation)
- [What is AI Vision?](/azure/cognitive-services/computer-vision/home)
- [What is Language?](/azure/cognitive-services/language-service/overview)
- [What is OCR?](/azure/cognitive-services/computer-vision/overview-ocr)
- [What is Named Entity Recognition (NER) in Language?](/azure/cognitive-services/language-service/named-entity-recognition/overview)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Introduction to Functions](/azure/azure-functions/functions-overview)

Try the learning path:

- [Implement knowledge mining with AI Search](/training/paths/implement-knowledge-mining-azure-cognitive-search)

## Related resources

- [Intelligent product search engine for e-commerce](/azure/architecture/example-scenario/apps/ecommerce-search)
- [Keyword search and speech-to-text with OCR digital media](/azure/architecture/solution-ideas/articles/digital-media-speech-text)
- [Suggest content tags with natural language processing by using deep learning](/azure/architecture/solution-ideas/articles/website-content-tag-suggestion-with-deep-learning-and-nlp)
