[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to use image processing, natural language processing, and custom skills to capture domain-specific data. You can use that data to enrich text and image documents. Incorporate Azure AI Search with AI enrichment to help identify and explore relevant content at scale. This solution uses AI enrichment to extract meaning from the original complex, unstructured JFK Assassination Records (JFK Files) dataset.

## Architecture

:::image type="complex" border="false" source="../media/ai-search-skillsets.svg" alt-text="Diagram that shows the AI Search architecture to convert unstructured data into structured data." lightbox="../media/ai-search-skillsets.svg":::
   The image has three key sections: unstructured data, AI enrichment, and knowledge store. The unstructured data section includes Blob Storage, documents, and images. The AI enrichment section includes both built-in skills and custom skills. The knowledge store section includes Blob Storage and Table Storage. Numbered steps show the flow of data. In the steps, unstructured data is ingested, enriched, indexed, projected, and queried.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/ai-search-skillsets.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram. The dataflow describes how the unstructured JFK Files dataset passes through the AI Search skills pipeline to produce structured and indexable data.

1. Unstructured data in Azure Blob Storage, such as documents and images, is ingested into AI Search.

1. To initiate the indexing process, the *document cracking* step extracts images and text from the data and then enriches the content. The enrichment steps in this process depend on the data and type of skills that you select.

1. [Built-in skills](/azure/search/cognitive-search-predefined-skills) based on the Azure AI Vision and Azure AI Language APIs provide AI enrichments such as image optical character recognition (OCR), image analysis, text translation, entity recognition, and full-text search.

1. [Custom skills](/azure/search/cognitive-search-custom-skill-interface) support scenarios that require more complex AI models or services. Examples include Azure AI Document Intelligence, Azure Machine Learning models, and Azure Functions.

1. After the enrichment process is complete, the indexer saves the enriched and indexed documents in a [search index](/azure/search/search-what-is-an-index). Full-text search and other query forms can use this index.

1. The enriched documents can also project into a [knowledge store](/azure/search/knowledge-store-concept-intro), which downstream apps like knowledge mining apps or data science apps can use.

1. Queries access the enriched content in the search index. The index supports custom analyzers, fuzzy search queries, filters, and a scoring profile to tune search relevance.

1. Applications that connect to Blob Storage or to Azure Table Storage can access the knowledge store.

### Components

- [AI Search](/azure/search/search-what-is-azure-search) is a search service that enables indexing, querying, and enrichment of content by using built-in and custom AI skills. You can use AI Search to apply [prebuilt AI skills](/azure/search/cognitive-search-predefined-skills) to content. In this architecture, it indexes the content and powers the search user experience. This architecture also uses the service's extensibility mechanism to add [custom skills](/azure/search/cognitive-search-custom-skill-interface), which provide specific enrichment transformations.

- [Azure AI Vision](/azure/ai-services/computer-vision/overview) is a service that extracts text and visual information from images. In this architecture, it uses [text recognition](/azure/ai-services/computer-vision/overview-ocr) to extract and recognize text information from images. The [Read API](/azure/ai-services/computer-vision/overview-ocr#ocr-read-editions) uses OCR recognition models and is optimized for large, text-heavy documents and noisy images.

- [Azure AI Language](/azure/ai-services/language-service/overview) is a text analytics service that extracts structured information from unstructured text by using capabilities like [named entity recognition](/azure/ai-services/language-service/named-entity-recognition/overview) and [key phrase extraction](/azure/search/cognitive-search-skill-keyphrases). In this architecture, Language enriches the JFK Files by identifying named entities and key phrases to support semantic search and filtering.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a REST-based object storage solution optimized for large volumes of unstructured data. You can use Blob Storage to expose data publicly or to store application data privately. In this architecture, Blob Storage stores the original JFK Files dataset, including scanned documents and images, which are ingested into the AI enrichment pipeline.

- [Table Storage](/azure/storage/tables/table-storage-overview) is a NoSQL storage service for structured and semi-structured data. In this architecture, Table Storage supports the knowledge store, which enables downstream applications to access enriched and indexed data.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions) is a serverless compute service that runs small pieces of event-triggered code without having to explicitly provision or manage infrastructure. In this architecture, a Functions method applies the Central Intelligence Agency (CIA) cryptonyms list to the JFK Files as a custom skill.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a managed platform for building and hosting web applications. In this architecture, it hosts a standalone web app that demonstrates the enriched search experience and allows users to explore connections within the indexed JFK documents.

## Scenario details

Large, unstructured datasets can include typewritten and handwritten notes, photos, diagrams, and other unstructured data that standard search solutions can't parse. The [JFK Files](https://www.archives.gov/research/jfk/2017-release) contain over 34,000 pages of documents about the CIA investigation of the 1963 JFK assassination.

You can use AI enrichment in AI Search to extract and enhance searchable, indexable text from images, blobs, and other unstructured data sources like the JFK Files. AI enrichment uses pretrained machine learning skill sets from the Azure AI services [Vision](/azure/ai-services/computer-vision/overview) and [Language](/azure/ai-services/language-service/text-analytics-for-health/overview?tabs=ner) APIs. You can also create and attach [custom skills](/azure/search/cognitive-search-custom-skill-interface) to add special processing for domain-specific data like CIA cryptonyms. AI Search can then index and search that context.

The AI Search skills in this solution can be categorized into the following groups:

- **Image processing:** This solution uses built-in [text extraction](/azure/search/cognitive-search-concept-image-scenarios) and [image analysis](/azure/ai-services/computer-vision/overview-image-analysis?tabs=4-0) skills, including object and face detection, tag and caption generation, and celebrity and landmark identification. These skills create text representations of image content, which you can search by using the query capabilities of AI Search. *Document cracking* is the process of extracting or creating text content from nontext sources.

- **Natural language processing:** This solution uses built-in skills like [entity recognition](/azure/search/cognitive-search-skill-entity-recognition), [language detection](/azure/search/cognitive-search-skill-language-detection), and [key phrase extraction](/azure/search/cognitive-search-skill-keyphrases) that map unstructured text to searchable and filterable fields in an index.

- **Custom skills:** This solution uses custom skills that extend AI Search to apply specific enrichment transformations to content. You can [specify the interface for a custom skill](/azure/search/cognitive-search-custom-skill-interface) through the [custom web API skill](/azure/search/cognitive-search-custom-skill-web-api).

### Potential use cases

The JFK Files [sample project](https://github.com/microsoft/AzureSearch_JFK_Files) and [online demo](https://jfk-demo-2019.azurewebsites.net/#/) presents a specific AI Search use case. This solution idea isn't intended to be a framework or scalable architecture for all scenarios. Instead, this solution idea provides a general guideline and example. The code project and demo create a public website and publicly readable storage container for extracted images, so you shouldn't use this solution with nonpublic data.

You can also use this architecture to perform the following actions:

- Increase the value and utility of unstructured text and image content in search apps and data science apps.

- Use custom skills to integrate open-source code, non-Microsoft code, or Microsoft code into indexing pipelines.

- Make scanned JPG, PNG, or bitmap documents full-text searchable.

- Produce better outcomes than standard PDF text extraction for PDFs with combined image and text. Some scanned and native PDF formats might not parse correctly in AI Search.

- Create new information from inherently meaningful raw content or context that's hidden in large, unstructured documents or semi-structured documents.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Carlos Alexandre Santos](https://www.linkedin.com/in/carlosafsantos) | Senior Specialized AI Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn more about this solution:

- [JFK Files project](https://github.com/microsoft/AzureSearch_JFK_Files)
- [Video: Use AI Search to understand the JFK documents](/shows/AI-Show/Using-Cognitive-Search-to-Understand-the-JFK-Documents)
- [JFK Files online demo](https://jfk-demo-2019.azurewebsites.net/#/)

Read product documentation:

- [AI enrichment in AI Search](/azure/search/cognitive-search-concept-intro)
- [What is Vision?](/azure/ai-services/computer-vision/overview)
- [What is Language?](/azure/ai-services/language-service/overview)
- [What is OCR?](/azure/ai-services/computer-vision/overview-ocr)
- [What is named entity recognition in Language?](/azure/ai-services/language-service/named-entity-recognition/overview)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Introduction to Functions](/azure/azure-functions/functions-overview)

Try the learning path:

- [Implement knowledge mining with AI Search](/training/paths/implement-knowledge-mining-azure-cognitive-search)
