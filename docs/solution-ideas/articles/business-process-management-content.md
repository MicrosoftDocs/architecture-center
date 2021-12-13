<!-- cSpell:ignore pracjain -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution demonstrates how to use [knowledge mining](https://azure.microsoft.com/solutions/knowledge-mining/) in business process management.

## Potential use cases

When organizations task employees with the review and research of technical data, it can be tedious to read page after page of dense text. Knowledge mining helps employees quickly review these materials. Knowledge mining can help avoid costly mistakes in industries where bidding competition is fierce. Or, in scenarios when the diagnosis of a problem must be quick or in near real time.

## Architecture

![Architecture Diagram: knowledge mining in business process management, with three steps: ingest, enrich, and explore.](../media/knowledge-mining-business-process-management.png)

### Data flow

There are three steps in knowledge mining: ingest, enrich, and explore.

- **Ingest**

  The ingest step aggregates content from a range of sources, including structured and unstructured data.

  For business process management, you can ingest different types of content like project-related items including SOWs, requests for proposal, and sales team correspondence. Or, financial-related content can be ingested including invoice archives, W2 forms, receipts, healthcare claim forms, bank statements, legal agreements, balance sheets, income statements, cash flow statements, company disclosures, SEC documents, and annual reports.

- **Enrich**

  The enrich step uses AI capabilities to extract information, find patterns, and deepen understanding.

  In this step, you can use optical character recognition, forms recognition, layout understanding, table extraction, and key-value pair extraction.

- **Explore**

  The explore step is exploring the data via search, bots, existing business applications, and data visualizations.

  Explore the content by automatically populating data from invoices into ELP systems or databases or compile enriched documents in the knowledge store and project them into tabular or object stores. Projected stores can be used to surface trends in an analytics dashboard, such as frequent issues, popular products, and much more.

### Components

Key technologies used to implement tools for technical content review and research

- [Azure Cognitive Search](/azure/search/)
- [Cognitive Services Form Recognizer](https://azure.microsoft.com/services/cognitive-services/form-recognizer)
- [Web API custom skill interface](/azure/search/cognitive-search-custom-skill-interface)

## Next steps

- Use the [knowledge mining solution accelerator](/samples/azure-samples/azure-search-knowledge-mining/azure-search-knowledge-mining/) to build an initial knowledge mining prototype with Azure Cognitive Search.

- Build an Azure Cognitive Search [custom skill](/azure/search/cognitive-search-custom-skill-interface).

- Explore the Microsoft Learning Path [knowledge mining with Azure Cognitive Search](/learn/paths/implement-knowledge-mining-azure-cognitive-search/).
