<!-- cSpell:ignore pracjain -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution demonstrates how to use [knowledge mining](https://azure.microsoft.com/solutions/knowledge-mining) in business process management.

## Potential use cases

This solution is ideal for the finance industry. When organizations task employees with the review and research of technical data, it can be tedious to read page after page of dense text. Knowledge mining helps employees quickly review these materials. Knowledge mining can help avoid costly mistakes in scenarios where bidding competition is fierce or where you have to diagnosis problems quickly or in near real time. Examples include the following areas:

- Sales
- IT service management
- Finances
- Logistics

## Architecture

![Architecture Diagram: knowledge mining in business process management, with three steps: ingest, enrich, and explore.](../media/knowledge-mining-business-process-management.png)

### Dataflow

There are three steps in knowledge mining: ingest, enrich, and explore.

- **Ingest**

  The ingest step aggregates content from a range of sources, including structured and unstructured data.

  For business process management, you can ingest different types of content like project-related items including SOWs, requests for proposal, and sales team correspondence. Or, financial-related content can be ingested including: invoice archives, W2 forms, receipts, healthcare claim forms, bank statements, legal agreements, balance sheets, income statements, cash flow statements, company disclosures, SEC documents, and annual reports.

- **Enrich**

  The enrich step uses AI capabilities to extract information, find patterns, and deepen understanding.

  In this step, you can use optical character recognition, forms recognition, layout understanding, table extraction, and key-value pair extraction.

- **Explore**

  The explore step is exploring the data via search, bots, existing business applications, and data visualizations.

  Explore the content by automatically populating data from invoices into ELP systems, databases, or compile enriched documents in the knowledge store and project them into tabular or object stores. Projected stores can be used to surface trends in an analytics dashboard, such as frequent issues, popular products, and much more.

### Components

This solution uses the following key technologies to implement tools for technical content review and research:

- [Azure Cognitive Search](https://azure.microsoft.com/services/search) is a cloud search service that supplies infrastructure, APIs, and tools for searching. You can use Azure Cognitive Search to build search experiences over private, heterogeneous content in web, mobile, and enterprise applications.
- The [web API custom skill interface](/azure/search/cognitive-search-custom-skill-interface) is used to integrate a custom skill into an Azure Cognitive Search enrichment pipeline.
- [Azure Form Recognizer](https://azure.microsoft.com/services/cognitive-services/form-recognizer) is part of Azure Applied AI Services. Form Recognizer uses machine-learning models to extract key-value pairs, text, and tables from documents such as invoices, receipts, ID cards, and business cards.

## Next steps

- To build an initial knowledge mining prototype with Azure Cognitive Search, use the [knowledge mining solution accelerator](/samples/azure-samples/azure-search-knowledge-mining/azure-search-knowledge-mining).
- Build an Azure Cognitive Search [custom skill](/azure/search/cognitive-search-custom-skill-interface).
- Explore the Microsoft Learning Path [knowledge mining with Azure Cognitive Search](/learn/paths/implement-knowledge-mining-azure-cognitive-search).
- To learn more about the components in this solution, see these resources:

  - [Azure Cognitive Search documentation](/azure/search)
  - [What is Azure Form Recognizer?](/azure/applied-ai-services/form-recognizer/overview)

## Related resources

- [Knowledge mining in auditing, risk, and compliance management](./auditing-and-risk-compliance.yml)
- [Knowledge mining for content research](./content-research.yml)
- [Knowledge mining in contract management](./contract-management.yml)
- [Knowledge mining for customer support and feedback analysis](./customer-feedback-and-analytics.yml)
- [Knowledge mining in digital asset management](./digital-asset-management.yml)
