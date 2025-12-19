[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture demonstrates a document generation solution that lets organizations create intelligent structured and unstructured documents grounded in their enterprise data. The solution uses Foundry IQ to identify relevant data, summarize information, and generate contextual content through conversational interactions. Users can generate documents based on this organizational knowledge and receive them in Word format.

The architecture combines retrieval, summarization, and generation with document persistence to support faster document creation workflows. The system enables user interaction through natural language and helps embed organizational knowledge directly into document processing workflows. It also caches generated content to avoid regeneration overhead and accelerate document creation.

## Architecture

:::image type="complex" border="false" source="./_images/generate-documents.svg" alt-text="Diagram that shows a document generation solution architecture that uses Azure AI services." lightbox="./_images/generate-documents.svg":::
   This diagram shows a flow from sample data through Azure services to the web front end for form-based template generation and export. The flow begins with enterprise data, which passes through an enterprise data sync process. This process loads PDF files into a Storage account, and IQ processes the files and indexes the content. The indexed content flows through Azure App Service and then into Microsoft Foundry, which handles chat completion, conversation loops, and JSON mode via SDK. App Service also links to a web front end and Azure Cosmos DB. The web front-end lets users chat with their own data, generate document templates, and export those templates.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/generate-documents.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Line-of-business (LOB) applications or other processes in the organization generate enterprise documents and reference materials that serve as foundational knowledge for document generation.

1. A sync process periodically manages the ingestion and updating of enterprise data from various sources into the workload.

1. An Azure Storage account receives and stores enterprise documents, including PDF files. It makes them available for downstream services to process and index. A storage account also stores the generated documents from user sessions later.

1. IQ creates searchable indexes from the processed and enriched documents, which enables semantic search capabilities and rapid information retrieval for document generation. Indexing skills might maintain the index in Azure AI Search.

1. Microsoft Foundry uses the indexed content to power conversational interactions through chat completion, conversation loops, and JSON mode via SDK. This process generates contextual documents based on user queries and organizational data.

1. Azure App Service hosts the web front end where users interact with the system by using natural language to generate documents.

1. Azure Cosmos DB stores conversation history and user interactions, while maintaining context for continuous improvement.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service (PaaS) solution that provides a scalable web hosting environment for applications. In this architecture, App Service hosts the web front-end interface where users interact with their enterprise data through conversational AI functionality. App Service also generates DOCX files by using the docx React library and stores them in Storage for delivery. The interface supports both structured and unstructured document generation and DOCX export capabilities, which provides a responsive and intuitive user experience.

- [Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) is a unified Azure PaaS offering for enterprise AI operations, model builders, and application development. This foundation combines production-grade infrastructure with developer‑oriented interfaces. These interfaces let developers focus on building applications rather than managing infrastructure. In this architecture, Foundry provides the foundation for deploying and managing AI models used in the chat interface and is the gateway into the connected AI services, like IQ.

  - [Foundry Agent Service](/azure/ai-foundry/agents/overview) is a managed platform within Foundry that integrates core components like models, tools, and frameworks into a unified agentic runtime. It manages conversations, orchestrates tool calls, enforces content safety, and integrates with identity, networking, and observability systems. In this architecture, Agent Service is invoked in the chat interface to power the chat completion, conversation loop, and JSON mode via the Microsoft Agent Framework SDK.

  - [IQ](/azure/search/agentic-retrieval-overview) is a scalable search infrastructure that indexes heterogeneous content and enables retrieval through APIs, applications, and AI agents. The platform provides native integrations with the Azure AI stack (Azure OpenAI in Foundry Models, Foundry, Azure Machine Learning) and supports extensible architectures for non‑Microsoft and open source model integration. In this architecture, IQ creates and manages vectorized representations of PDF files. This approach enables semantic search and retrieval-augmented generation (RAG) patterns to identify relevant documents, summarize unstructured information, and generate document templates.

- [Storage](/azure/well-architected/service-guides/azure-blob-storage) is a Microsoft object storage solution optimized for storing massive amounts of unstructured data. In this architecture, a Storage account stores enterprise documents and reference materials, including PDF files, that provide the foundational knowledge base for the document generation process. A Storage account also stores generated documents for caching purposes.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multi-model database service that provides guaranteed low latency and elastic scalability. In this architecture, Azure Cosmos DB stores conversation history and user interactions. This capability maintains context across sessions, enables intelligent document retrieval, and eliminates regeneration overhead for improved performance.

## Scenario details

This document generation solution addresses the challenges that organizations encounter when they want to create consistent, high-quality business documents that use institutional knowledge. Traditional document creation often suffers from blank page syndrome, inconsistent formatting, missed relevant information, and significant time investment from subject matter experts (SMEs). This solution transforms document creation through conversational AI that generates structured documents like contracts, invoices, and promissory notes, and unstructured documents like proposals, reports, and briefings, all grounded in organizational data.

This architecture supports transactional usage only. It enables focused, real-time document generation workflows that maintain quality and consistency for individual document requests. It doesn't support batch processing.

### Potential use cases

Consider the following use cases.

#### Legal and compliance documentation

**Contract template generation:** Automatically generate contract templates based on previous agreements, legal precedents, and company policies. This approach ensures consistency and compliance across all business relationships.

**Regulatory submission preparation:** Create compliance documentation by synthesizing relevant regulations, organizational policies, and historical submission data into properly formatted regulatory filings.

**Legal brief drafting:** Generate legal document drafts by analyzing case law, precedents, and client information stored in an organization's knowledge base.

#### Business operations and proposals

**Investment proposal creation:** Synthesize market research, financial data, and strategic documents to generate comprehensive investment proposals tailored to specific opportunities and stakeholder requirements.

**Grant application development:** Create grant applications by combining project requirements, organizational capabilities, and historical successful submissions into compelling funding requests.

**Requests for Proposals (RFP) response generation:** Automatically draft responses to RFPs by analyzing requirements against organizational capabilities and previous successful proposals.

#### Financial and procurement documentation

**Invoice template standardization:** Generate consistent invoice templates that incorporate organizational branding, legal requirements, and customer-specific terms based on historical billing data.

**Purchase order automation:** Create purchase orders by referencing vendor databases, procurement policies, and budget constraints to ensure compliance and accuracy.

**Financial report compilation:** Generate financial reports by synthesizing data from multiple sources into standardized templates that meet regulatory and stakeholder requirements.

#### Healthcare and research applications

**Clinical protocol documentation:** Generate research protocols by combining regulatory requirements, institutional guidelines, and previous study designs into compliant and comprehensive documents.

**Patient care plan templates:** Create standardized care plan templates that incorporate best practices, institutional policies, and patient-specific considerations.

**Research grant proposals:** Develop research funding proposals by synthesizing scientific literature, institutional capabilities, and funding agency requirements.

### Alternatives

This architecture includes a component that you can substitute with another Azure service or approach, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and trade-offs.

#### Document generation approach

**Current approach:** Use custom AI-powered generation that includes enterprise data grounding and intelligent caching for both structured and unstructured documents.

**Alternative approach:** Use Azure Document Intelligence in Foundry Tools with prebuilt forms for structured documents only, combined with traditional document management systems.

Consider the alternative if your workload primarily focuses on standardized forms that have minimal unstructured content requirements.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This preconfigured [estimate in the Azure pricing calculator](https://azure.com/e/b7574e1a2952486e94073601a26ad52f) shows the costs to run this scenario.

Pricing varies based on region and usage, so you can't predict exact costs for your scenario. Most of the Azure resources used in this infrastructure are on usage-based pricing tiers.

## Deploy this scenario

To deploy an implementation of this architecture, follow the [deployment steps](https://github.com/microsoft/document-generation-solution-accelerator).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Solomon Pickett](https://www.linkedin.com/in/gregory-solomon-pickett-307560130/) | Software Engineer II

Other contributors:

- [Anish Arora](https://www.linkedin.com/in/aniarora/) | Senior Software Engineer
- [Malory Rose](https://www.linkedin.com/in/malory-rose-8aa503135/) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [AI Search documentation](/azure/search/)

## Related resource

- [Design and develop a RAG solution](../guide/rag/rag-solution-design-and-evaluation-guide.md)
