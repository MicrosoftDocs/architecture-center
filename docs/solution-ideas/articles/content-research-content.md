
<!-- cSpell:ignore pracjain -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture describes how [knowledge mining](https://azure.microsoft.com/solutions/knowledge-mining/) can be used for content research.

When organizations task employees to review and research of technical data, it can be tedious to read page after page of dense text. Knowledge mining helps employees quickly review these dense materials. In industries where bidding competition is fierce, or when the diagnosis of a problem must be quick or in near real-time, companies can use knowledge mining to avoid costly mistakes and improve content research.

## Data flow in knowledge mining

![Architecture diagram: knowledge mining in content research, with three steps: ingest, enrich, and explore.](../media/knowledge-mining-content-research.png)

There are three steps: Ingest, Enrich and Exploration. First, the unstructured and structured data is ingested then enrichment of this data with AI to extract information and find and finally explore the newly structured data via search, existing business applications or analytics solutions.

- **Ingest**

  The ingest step aggregates content from a range of sources, including structured and unstructured data. For content research, you can ingest different types of technical content like product manuals, user guides, engineering standard documents, patent records, medical journals, and pharmaceutical fillings.

- **Enrich**

  The enrich step uses AI capabilities to extract information, find patterns, and deepen understanding. This content is enriched by using optical character recognition, key phrase extraction, entity recognition, language translation, customized models to extract industry-specific terms such as product names or engineering standards, customized models to flag potential risks or other essential information, customized models for HIPAA compliance.

- **Explore**

  The explore step enables the data to be explored via search, bots, existing business applications, and data visualizations. For example, you can integrate the search index in to a searchable directory or a existing business application.

## Components

Key technologies used to implement tools for technical content review and research

- [Azure Cognitive Search](/azure/search/)
- [Microsoft Text Analytics API](https://azure.microsoft.com/services/cognitive-services/text-analytics/)
- [Microsoft Translator Text API](https://azure.microsoft.com/services/cognitive-services/translator-text-api/)
- [Microsoft Form Recognizer](https://azure.microsoft.com/services/cognitive-services/form-recognizer/)
- [Web API custom skill interface](/azure/search/cognitive-search-custom-skill-interface)

## Next steps

- Use the [knowledge mining solution accelerator](/samples/azure-samples/azure-search-knowledge-mining/azure-search-knowledge-mining/) to build an initial knowledge mining prototype with Azure Cognitive Search.

- Build and Azure Cognitive Search [custom skill](/azure/search/cognitive-search-custom-skill-interface).

- Explore the Microsoft Learning Path [knowledge mining with Azure Cognitive Search](/learn/paths/implement-knowledge-mining-azure-cognitive-search/).
