[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture shows how [knowledge mining](https://azure.microsoft.com/solutions/knowledge-mining) can help customer support teams quickly find answers to customer questions or assess customer sentiment at scale.

## Architecture

There are three steps in knowledge mining: ingest, enrich, and explore.

[ ![Architecture diagram: knowledge mining for customer feedback and analytics with 3 steps: ingest, enrich, explore.](../media/knowledge-mining-customer-feedback-and-analytics.png)](../media/knowledge-mining-customer-feedback-and-analytics.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/knowledge-mining-customer-feedback-and-analytics.vsdx) of this architecture.*

### Dataflow

- **Ingest**

The ingest step aggregates content from a range of sources, including structured and unstructured data. For customer support and feedback analysis, you can ingest different types of content. This content includes customer support tickets, chat logs, call transcriptions, customer emails, customer payment history, product reviews, social media feeds, online comments, feedback forms, and surveys.

- **Enrich**

The enrich step uses AI capabilities to extract information, find patterns, and deepen understanding. You can enrich content by using key phrase extraction, sentiment analysis, language translation, bot services, custom models to focus on specific products or company policies.

- **Explore**

The explore step is explorer data via search, existing business applications, or analytics solutions. For example, you can compile enriched documents in the knowledge store and project them into tabular or object stores. The stores can be used to surface trends in an analytics dashboard identifying frequent issues or popular products. Or, you can integrate the search index into customer service support applications.

### Components

The following key technologies are used to implement tools for technical content review and research:

- [Azure Cognitive Search](https://azure.microsoft.com/services/search) is a cloud search service that supplies infrastructure, APIs, and tools for searching. You can use Azure Cognitive Search to build search experiences over private, heterogeneous content in web, mobile, and enterprise applications.
- The [web API custom skill interface](/azure/search/cognitive-search-custom-skill-interface) is used to integrate a custom skill into an Azure Cognitive Search enrichment pipeline.
- [Azure Cognitive Service for Language](https://azure.microsoft.com/services/cognitive-services/language-service) is part of [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services) that offers many natural language processing services. You can use these services to understand and analyze text.
- [Text analytics](https://azure.microsoft.com/services/cognitive-services/text-analytics) is a collection of APIs and other features from Azure Cognitive Service for Language that you can use to extract, classify, and understand text within documents.
- [Cognitive Services Translator](https://azure.microsoft.com/services/cognitive-services/translator) is part of the Cognitive Services family of REST APIs. You can use Translator for real-time document and text translation.

## Scenario details

For many companies, customer support is costly and doesn't always operate efficiently. [Knowledge mining](https://azure.microsoft.com/solutions/knowledge-mining) can help customer support teams quickly find the best answers to customer questions or assess customer sentiment at scale.

### Potential use cases

This solution is optimized for the retail industry.

[Azure Cognitive Search](/azure/search/search-what-is-azure-search) is a key part of knowledge mining solutions. Azure Cognitive Search creates a search index over aggregated and analyzed content.

With queries using the search index, companies can discover trends about what customers are saying and use that information to improve products and services.

## Next steps

- To build an initial knowledge mining prototype with Azure Cognitive Search, use the [knowledge mining solution accelerator](/samples/azure-samples/azure-search-knowledge-mining/azure-search-knowledge-mining).
- Build an Azure Cognitive Search [custom skill](/azure/search/cognitive-search-custom-skill-interface).
- Explore the learning path [Knowledge mining with Azure Cognitive Search](/training/paths/implement-knowledge-mining-azure-cognitive-search).
- To learn more about the components in this solution, see these resources:

  - [Azure Cognitive Search documentation](/azure/search)
  - [Text analytics REST API reference - Azure Cognitive Services](/rest/api/cognitiveservices-textanalytics)
  - [What is Azure Cognitive Services Translator?](/azure/cognitive-services/translator/translator-overview)

## Related resources

- [Knowledge mining in auditing, risk, and compliance management](./auditing-and-risk-compliance.yml)
- [Knowledge mining in business process management](./business-process-management.yml)
- [Knowledge mining for content research](./content-research.yml)
- [Knowledge mining in contract management](./contract-management.yml)
- [Knowledge mining in digital asset management](./digital-asset-management.yml)
