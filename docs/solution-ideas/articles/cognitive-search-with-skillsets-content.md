[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution that enriches text and image documents by using image processing, natural language processing, and custom skills to capture domain-specific data. Azure Cognitive Search with AI enrichment can help identify and explore relevant content at scale. This solution uses AI enrichment to extract meaning from the original complex, unstructured JFK Assassination Records (JFK Files) dataset.

## Architecture

:::image type="content" alt-text="Diagram that shows Azure Cognitive Search architecture to convert unstructured into structured data." source="../media/cognitive-search-for-ai-enrichment.svg" lightbox="../media/cognitive-search-for-ai-enrichment.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/cognitive-search-with-skillsets.vsdx) of this architecture.*

### Dataflow

The above diagram illustrates the process of passing the unstructured JFK Files dataset through the Azure Cognitive Search skills pipeline to produce structured, indexable data:

1. Unstructured data in Azure Blob Storage, such as documents and images, ingest into Azure Cognitive Search.
1. The *document cracking* step initiates the indexing process by extracting images and text from the data, followed by content enrichment. The enrichment steps that occur in this process depend on the data and type of skills selected.
1. [*Built-in skills*](/azure/search/cognitive-search-predefined-skills) based on the Computer Vision and Language Service APIs enable AI enrichments including image optical character recognition (OCR), image analysis, text translation, entity recognition, and full-text search.
1. [*Custom skills*](/azure/search/cognitive-search-custom-skill-interface) support scenarios that require more complex AI models or services. Examples include Forms Recognizer, Azure Machine Learning models, and Azure Functions.
1. Following the enrichment process, the indexer saves the outputs into a [*search index*](/azure/search/search-what-is-an-index) that contains the enriched and indexed documents. Full-text search and other query forms can use this index.
1. The enriched documents can also project into a [*knowledge store*](/azure/search/knowledge-store-concept-intro), which downstream apps like knowledge mining or data science can use.
1. Queries access the enriched content in the search index. The index supports custom analyzers, fuzzy search queries, filters, and a scoring profile to tune search relevance.
1. Any application that connects to Blob Storage or to Azure Table Storage can access the knowledge store.

### Components

Azure Cognitive Search works with other Azure components to provide this solution.

#### Azure Cognitive Search

[Azure Cognitive Search](https://azure.microsoft.com/services/search) indexes the content and powers the user experience in this solution. Azure Cognitive Search can apply [pre-built cognitive skills](/azure/search/cognitive-search-predefined-skills) to the content, and the extensibility mechanism can add [custom skills](/azure/search/cognitive-search-custom-skill-interface) for specific enrichment transformations.

#### Azure Computer Vision

[Azure Computer Vision](https://azure.microsoft.com/services/cognitive-services/computer-vision) uses [text recognition](/azure/cognitive-services/computer-vision/overview-ocr) to extract and recognize text information from images. The [Read API](/azure/cognitive-services/computer-vision/overview-ocr#read-api) uses the latest OCR recognition models, and is optimized for large, text-heavy documents and noisy images.

The [legacy OCR API](https://westus.dev.cognitive.microsoft.com/docs/services/computer-vision-v3-2/operations/56f91f2e778daf14a499f20d) isn't optimized for large documents, but supports more languages. OCR results can vary depending on scan and image quality. The current solution idea uses OCR to produce data in the [hOCR format](https://en.wikipedia.org/wiki/HOCR).

#### Azure Cognitive Service for Language

[Azure Cognitive Service for Language](https://azure.microsoft.com/services/cognitive-services/language-service) extracts text information from unstructured documents by using [text analytics](/azure/cognitive-services/language-service/overview#available-features) capabilities like [Named Entity Recognition (NER)](/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking), [key phrase extraction](/azure/search/cognitive-search-skill-keyphrases), and [full-text search](/azure/search/search-lucene-query-architecture).

#### Azure Storage

[Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) is REST-based object storage for data that you can access from anywhere in the world via HTTPS. You can use Blob Storage to expose data publicly to the world or to store application data privately. Blob Storage is ideal for large amounts of unstructured data like text or graphics.

[Azure Table Storage](https://azure.microsoft.com/services/storage/tables) stores highly available, scalable, structured or semi-structured NoSQL data in the cloud.

#### Azure Functions

[Azure Functions](https://azure.microsoft.com/services/functions) is a serverless compute service that lets you run small pieces of event-triggered code without having to explicitly provision or manage infrastructure. This solution uses an Azure Functions method to apply the CIA Cryptonyms list to the JFK Assassination Records as a custom skill.

#### Azure App Service

This solution idea also builds a standalone web app in [Azure App Service](https://azure.microsoft.com/services/app-service) to test, demonstrate, search the index, and explore connections in the enriched and indexed documents.

## Scenario details

Large, unstructured datasets can include typewritten and handwritten notes, photos and diagrams, and other unstructured data that standard search solutions can't parse. The [JFK Assassination Records](https://www.archives.gov/research/jfk/2017-release) contain over 34,000 pages of documents about the CIA investigation of the 1963 JFK assassination.

The JFK Files [sample project](https://github.com/microsoft/AzureSearch_JFK_Files) and [online demo](https://aka.ms/jfkfiles-demo) showcase a particular Azure Cognitive Search use case. This solution idea isn't intended to be a framework or scalable architecture for all scenarios, but to provide a general guideline and example. The code project and demo create a public website and publicly readable storage container for extracted images, so you shouldn't use this solution with non-public data.

AI enrichment in Azure Cognitive Search can extract and enhance searchable, indexable text from images, blobs, and other unstructured data sources like the JFK Files. AI enrichment uses pre-trained machine learning skill sets from the Cognitive Services [Computer Vision](/azure/cognitive-services/computer-vision/home) and [Cognitive Service for Language](/azure/cognitive-services/text-analytics/overview) APIs. You can also create and attach [custom skills](/azure/search/cognitive-search-custom-skill-interface) to add special processing for domain-specific data like CIA Cryptonyms. Azure Cognitive Search can then index and search that context.

The Azure Cognitive Search skills in this solution fall into the following categories:

- *Image processing*. Built-in [text extraction](/azure/cognitive-services/computer-vision/concept-recognizing-text#read-api) and [image analysis](/azure/search/cognitive-search-skill-image-analysis) skills include object and face detection, tag and caption generation, and celebrity and landmark identification. These skills create text representations of image content, which are searchable by using the query capabilities of Azure Cognitive Search. *Document cracking* is the process of extracting or creating text content from non-text sources.

- *Natural language processing*. Built-in skills like [entity recognition](/azure/search/cognitive-search-skill-entity-recognition), [language detection](/azure/search/cognitive-search-skill-language-detection), and [key phrase extraction](/azure/search/cognitive-search-skill-keyphrases) map unstructured text to searchable and filterable fields in an index.

- *Custom skills* extend Azure Cognitive Search to apply specific enrichment transformations to content. You [specify the interface for a custom skill](/azure/search/cognitive-search-custom-skill-interface) through the [Custom Web API skill](/azure/search/cognitive-search-custom-skill-web-api).

### Potential use cases

- Increase the value and utility of unstructured text and image content in search and data science apps.
- Use custom skills to integrate open-source, third-party, or first-party code into indexing pipelines.
- Make scanned JPG, PNG, or bitmap documents full-text searchable.
- Produce better outcomes than standard PDF text extraction for PDFs with combined image and text. Some scanned and native PDF formats might not parse correctly in Azure Cognitive Search.
- Create new information from inherently meaningful raw content or context that's hidden in larger unstructured or semi-structured documents.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

 * [Carlos Alexandre Santos](https://www.linkedin.com/in/carlosafsantos) | Senior Specialized AI Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn more about this solution:

- Explore the [JFK Files project](https://github.com/microsoft/AzureSearch_JFK_Files) on GitHub.
- Watch the process in action in an [online video](/shows/AI-Show/Using-Cognitive-Search-to-Understand-the-JFK-Documents).
- Explore the JFK Files [online demo](https://aka.ms/jfkfiles-demo).

Read product documentation:

- [AI enrichment in Azure Cognitive Search](/azure/search/cognitive-search-resources-documentation)
- [What is Computer Vision?](/azure/cognitive-services/computer-vision/home)
- [What is Azure Cognitive Service for Language?](/azure/cognitive-services/language-service/overview)
- [What is optical character recognition?](/azure/cognitive-services/computer-vision/overview-ocr)
- [What is Named Entity Recognition (NER) in Azure Cognitive Service for Language?](/azure/cognitive-services/language-service/named-entity-recognition/overview)
- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)

Try the learning path:

- [Implement knowledge mining with Azure Cognitive Search](/training/paths/implement-knowledge-mining-azure-cognitive-search)

## Related resources

See the related architectures and guidance:

- [Intelligent product search engine for e-commerce](/azure/architecture/example-scenario/apps/ecommerce-search)
- [Process free-form text for search](/azure/architecture/data-guide/scenarios/search)
- [Keyword search and speech-to-text with OCR digital media](/azure/architecture/solution-ideas/articles/digital-media-speech-text)
- [Suggest content tags with NLP using deep learning](/azure/architecture/solution-ideas/articles/website-content-tag-suggestion-with-deep-learning-and-nlp)
- [Knowledge mining for content research](/azure/architecture/solution-ideas/articles/content-research)
- [Knowledge mining in digital asset management](/azure/architecture/solution-ideas/articles/digital-asset-management)
