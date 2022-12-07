
<!-- cSpell:ignore pracjain -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture demonstrates how to use [knowledge mining](https://azure.microsoft.com/solutions/knowledge-mining) in auditing, risk, and compliance management.

## Architecture

There are three steps in knowledge mining: ingest, enrich, and explore.

:::image type="content" alt-text="Architecture Diagram: knowledge mining in auditing, risk, and compliance management." source="../media/knowledge-mining-auditing-and-risk-compliance.png" lightbox="../media/knowledge-mining-auditing-and-risk-compliance.png":::

*Download a [Visio file](https://arch-center.azureedge.net/knowledge-mining-auditing-and-risk-compliance.vsdx) of this architecture.*

### Dataflow

There are three steps:

- **Ingest**

  The ingest step aggregates content from a range of sources, including structured and unstructured data. For auditing, risk, and compliance management, you can ingest different types of content including but not limited to: affidavits, meeting minutes, operating agreements, agreements, privacy policies, terms of use, memorandums of understanding, licensing agreements, letters of intent, power of attorney, deeds, discovery documentation, company bylaws, operating agreements, bank statements, legal agreements, balance sheets, income statements, cash flow statements, company disclosures, SEC documents, annual reports, and transcripts from shareholder meetings.

- **Enrich**

  The enrich step uses AI capabilities to extract information, find patterns, and deepen understanding. You can enrich content with key phrase extraction, language detection, language translation, and entity extraction (organizations and people). Use custom models to identify certain regulatory obligations and custom models to identify specific legal terms and clauses.

- **Explore**

  The explore step is exploring the data via search, bots, existing business applications, and data visualizations. For example, you can integrate the search index into an internal application or web application for financial risks.

### Components

This solution uses the following key technologies to implement tools for technical content review and research:

- [Azure Cognitive Search](https://azure.microsoft.com/services/search) is a cloud search service that supplies infrastructure, APIs, and tools for searching. You can use Azure Cognitive Search to build search experiences over private, heterogeneous content in web, mobile, and enterprise applications.
- The [web API custom skill interface](/azure/search/cognitive-search-custom-skill-interface) is used to integrate a custom skill into an Azure Cognitive Search enrichment pipeline.
- [Azure Cognitive Service for Language](https://azure.microsoft.com/services/cognitive-services/language-service) is part of [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services) that offers many natural language processing services. You can use these services to understand and analyze text.
- [Text analytics](https://azure.microsoft.com/services/cognitive-services/text-analytics) is a collection of APIs and other features from Azure Cognitive Service for Language that you can use to extract, classify, and understand text within documents.
- [Azure Cognitive Services Translator](https://azure.microsoft.com/services/cognitive-services/translator) is part of the Cognitive Services family of REST APIs. You can use Translator for real-time document and text translation.

## Scenario details

In the ever-changing world of regulations, organizations face the challenge of staying on top of audits and compliance. Mistakes in contracts and record-keeping can have serious financial ramifications. At the enterprise level, teams of lawyers might not be enough to catch everything when faced with thousands of pages of documentation. Knowledge mining can help organizations looking to stay compliant by enabling attorneys to quickly find information from documents and flag important ideas.

### Potential use cases

Key industries for this scenario include government, nonprofit, finance and financial services, professional services, and legal services. Organizations can utilize knowledge mining in order to:

- Discover the root causes faster.
- Forecast auditing times.
- Assess and enforce compliance levels and risks.
- Automate compliance reporting.

## Next steps

- To build an initial knowledge mining prototype with Azure Cognitive Search, use the [knowledge mining solution accelerator](/samples/azure-samples/azure-search-knowledge-mining/azure-search-knowledge-mining).
- Build an Azure Cognitive Search [custom skill](/azure/search/cognitive-search-custom-skill-interface).
- Explore the Microsoft Learning Path [knowledge mining with Azure Cognitive Search](/training/paths/implement-knowledge-mining-azure-cognitive-search).
- To learn more about the components in this solution, see these resources:

  - [Azure Cognitive Search documentation](/azure/search)
  - [Text analytics REST API reference - Azure Cognitive Services](/rest/api/cognitiveservices-textanalytics)
  - [What is Azure Cognitive Services Translator?](/azure/cognitive-services/translator/translator-overview)

## Related resources

- [Knowledge mining in business process management](./business-process-management.yml)
- [Knowledge mining for content research](./content-research.yml)
- [Knowledge mining in contract management](./contract-management.yml)
- [Knowledge mining for customer support and feedback analysis](./customer-feedback-and-analytics.yml)
- [Knowledge mining in digital asset management](./digital-asset-management.yml)
