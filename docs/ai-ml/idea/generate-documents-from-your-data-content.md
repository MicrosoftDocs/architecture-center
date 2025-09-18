[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture demonstrates a document generation solution that enables organizations to create intelligent structured and unstructured documents grounded in their enterprise data. The solution uses Azure AI Document Intelligence to identify relevant data, summarize information, and generate contextual content through conversational interactions. Users can generate documents based on this organizational knowledge and receive them in Word format.

The architecture combines retrieval, summarization, and generation with document persistence to support faster document creation workflows. The system enables user interaction through natural language and helps embed organizational knowledge directly into document processing workflows. It also caches generated content to avoid regeneration overhead and accelerate document creation.

## Architecture

:::image type="complex" border="false" source="./_images/generate-documents.svg" alt-text="Diagram that shows a document generation solution architecture that uses Azure AI services." lightbox="./_images/generate-documents.svg":::
   This diagram shows a flow from sample data through Azure services to the web front end for form-based template generation and export. The flow begins with enterprise data, which passes through an enterprise data sync process. This process loads PDF files into a Storage account, and Azure AI Document Intelligence processes the files and indexes the content. The indexed content flows through App Service and then into Azure AI Foundry, which handles chat completion, conversation loops, and JSON mode via SDK. App Service also links to a web front end and Azure Cosmos DB. The web front-end enables users to chat with their own data, generate document templates, and export those templates.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/generate-documents.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Line-of-business applications or other processes in the organization generate enterprise documents and reference materials that serve as foundational knowledge for document generation.

1. A synchronization process periodically manages the ingestion and updating of enterprise data from various sources into this workload.

1. An Azure Storage account receives and stores enterprise documents, including PDF files. It makes them available for downstream services to process and index. A storage account also stores the generated documents from user sessions later.

1. Azure AI Document Intelligence creates searchable indexes from the processed and enriched documents, which enables semantic search capabilities and rapid information retrieval for document generation. Indexing skills might maintain the index in Azure AI Search.

1. Azure AI Foundry uses the indexed content to power conversational interactions through chat completion, conversation loops, and JSON mode via SDK. This process generates contextual documents based on user queries and organizational data.

1. Azure App Service hosts the web front end where users interact with the system by using natural language to generate documents.

1. Azure Cosmos DB stores conversation history and user interactions, while maintaining context for continuous improvement.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service (PaaS) solution that provides a scalable web hosting environment for applications. In this architecture, App Service hosts the web front-end interface where users interact with their enterprise data through conversational AI functionality. App Service also generates DOCX files by using the docx React library and stores them in Storage for delivery. The interface enables both structured and unstructured document generation and DOCX export capabilities, which provides a responsive and intuitive user experience.

- [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) is a managed AI service that provides access to advanced language models for natural language processing and generation. In this architecture, Azure AI Foundry provides models as a service (MaaS) for the Semantic Kernel-based agents to invoke.

- [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/?view=doc-intel-4.0.0) is a cloud-based Azure AI service that uses machine learning models to automate data processing in applications and workflows. Azure AI Document Intelligence helps enhance data-driven strategies and enrich document search capabilities.

- [Azure Storage](/azure/well-architected/service-guides/azure-blob-storage) is a Microsoft object storage solution optimized for storing massive amounts of unstructured data. In this architecture, a Storage account stores enterprise documents and reference materials, including PDF files, that provide the foundational knowledge base for the document generation process. A Storage account also stores generated documents for caching purposes.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multi-model database service that provides guaranteed low latency and elastic scalability. In this architecture, Azure Cosmos DB stores conversation history and user interactions. This capability maintains context across sessions, enables intelligent document retrieval, and eliminates regeneration overhead for improved performance.

## Scenario details

This document generation solution addresses the challenge that organizations encounter when they want to create consistent, high-quality business documents that use institutional knowledge. Traditional document creation often suffers from blank page syndrome, inconsistent formatting, missed relevant information, and significant time investment from subject matter experts. This solution transforms document creation through conversational AI that generates structured documents such as contracts, invoices, and promissory notes, and unstructured documents such as proposals, reports, and briefings, all grounded in organizational data.

This architecture supports transactional usage only. It enables focused, real-time document generation workflows that maintain quality and consistency for individual document requests. It doesn't support batch processing.

### Potential use cases

### Legal and compliance documentation

**Contract template generation:** Automatically generate contract templates based on previous agreements, legal precedents, and company policies. This approach ensures consistency and compliance across all business relationships.

**Regulatory submission preparation:** Create compliance documentation by synthesizing relevant regulations, organizational policies, and historical submission data into properly formatted regulatory filings.

**Legal brief drafting:** Generate legal document drafts by analyzing case law, precedents, and client information stored in an organization's knowledge base.

### Business operations and proposals

**Investment proposal creation:** Synthesize market research, financial data, and strategic documents to generate comprehensive investment proposals tailored to specific opportunities and stakeholder requirements.

**Grant application development:** Create grant applications by combining project requirements, organizational capabilities, and historical successful submissions into compelling funding requests.

**Requests for Proposals (RFP) response generation:** Automatically draft responses to RFPs by analyzing requirements against organizational capabilities and previous successful proposals.

### Financial and procurement documentation

**Invoice template standardization:** Generate consistent invoice templates that incorporate organizational branding, legal requirements, and customer-specific terms based on historical billing data.

**Purchase order automation:** Create purchase orders by referencing vendor databases, procurement policies, and budget constraints to ensure compliance and accuracy.

**Financial report compilation:** Generate financial reports by synthesizing data from multiple sources into standardized templates that meet regulatory and stakeholder requirements.

### Healthcare and research applications

**Clinical protocol documentation:** Generate research protocols by combining regulatory requirements, institutional guidelines, and previous study designs into compliant and comprehensive documents.

**Patient care plan templates:** Create standardized care plan templates that incorporate best practices, institutional policies, and patient-specific considerations.

**Research grant proposals:** Develop research funding proposals by synthesizing scientific literature, institutional capabilities, and funding agency requirements.

## Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and trade-offs.

### Document generation approach

**Current approach:** Use custom AI-powered generation that includes enterprise data grounding and intelligent caching for both structured and unstructured documents.

**Alternative approach:** Use Azure AI Document Intelligence with prebuilt forms for structured documents only, combined with traditional document management systems.

Consider the alternative if your workload primarily focuses on standardized forms that have minimal unstructured content requirements.

## Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This preconfigured [estimate in the Azure pricing calculator](https://azure.com/e/c42b93df96a64d9d9067d2cbc1c0c4d2) shows the costs to run this scenario.

Pricing varies based on region and usage, so you can't predict exact costs for your scenario. Most of the Azure resources used in this infrastructure are on usage-based pricing tiers.

## Deploy this scenario

To deploy an implementation of this architecture, follow the [deployment steps](https://github.com/microsoft/document-generation-solution-accelerator).

## Next steps

- [AI Search documentation](/azure/search/)
- [Design and develop a retrieval-augmented generation (RAG) solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide)