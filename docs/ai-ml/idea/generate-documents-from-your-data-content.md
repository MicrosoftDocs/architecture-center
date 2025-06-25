[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture demonstrates an AI-powered document generation solution that enables organizations to create intelligent form-based templates grounded in their enterprise data. The solution uses Azure OpenAI Service and Azure AI Search to identify relevant documents, summarize unstructured information, and generate contextual form-based templates. Users can generate form-based templates based on organizational knowledge, and export form-based templates in the Microsoft Word format.

This architecture shows how to build a simple system for generating form-based templates using AI. It combines retrieval, summarization, and generation to support faster form-based drafting. The system enables user interaction through natural language and helps embed organizational knowledge directly into document processing workflows.

## Architecture

:::image type="complex" border="false" source="./_images/generate-documents-from-your-data.png" alt-text="Diagram that shows a document generation solution architecture using Azure AI services." lightbox="./_images/generate-documents-from-your-data.png":::
   Document generation architecture showing the flow from sample data through Azure services to the web frontend for form-based template generation and export.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/generate-documents-from-your-data.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

1. Enterprise documents and templates are stored as sample data, providing the foundational knowledge base for document generation.

2. Azure Storage Account receives and stores the enterprise documents, making them available for processing and indexing by downstream services.

3. Azure AI Services processes the stored documents, extracting content, understanding context, and preparing data for intelligent search and generation capabilities.

4. Azure AI Search creates searchable indexes from the processed documents, enabling semantic search capabilities and rapid information retrieval for document generation.

5. Azure OpenAI Service utilizes the indexed content to power conversational interactions and generate contextual form-based templates based on user queries and organizational data.

6. App Service hosts the web frontend where users interact with the system to generate form-based templates, and export finished documents in DOCX format.

7. Azure Cosmos DB stores conversation history and user interactions to maintain context and enable continuous improvement of the document generation process.

8. Container Registry maintains versioned container images for the web application, enabling consistent deployment and rollback capabilities.

### Components

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service (PaaS) solution that provides a scalable web hosting environment for applications. In this architecture, App Service hosts the web frontend interface where users interact with their enterprise data through chat functionality. The interface also enables form-based template generation and DOCX export capabilities, providing a responsive and intuitive user experience.

- [Azure OpenAI Service](/azure/well-architected/service-guides/azure-openai) is a managed AI service that provides access to advanced language models for natural language processing and generation. In this architecture, Azure OpenAI Service powers the conversational interface and document generation capabilities, utilizing GPT models to understand user queries, summarize content, and generate contextual form-based templates based on enterprise data.

- [Azure AI Search](/azure/search/search-what-is-azure-search) is a cloud search service that provides rich search capabilities over diverse content types. In this architecture, Azure AI Search enables retrieval-augmented generation (RAG) by creating semantic search indexes of enterprise documents, allowing the system to quickly identify and retrieve relevant information for form-based template generation.

- [Azure AI Services](/azure/ai-services/) provides a collection of AI services for processing and understanding various types of content. In this architecture, Azure AI Services processes enterprise documents to extract text, understand structure, and prepare content for indexing and generation workflows.

- [Azure Storage Account](/azure/well-architected/service-guides/azure-blob-storage)is Microsoft's object storage solution optimized for storing massive amounts of unstructured data. In this architecture, Azure Storage Account stores enterprise documents and sample data. This provides durable and scalable storage for the document creation process.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multi-model database service that provides guaranteed low latency and elastic scalability. In this architecture, Cosmos DB stores chat history, user actions, document details, and system data. This maintains context across sessions and enables custom document creation.

- [Azure Key Vault](/azure/key-vault/general/overview) is a cloud service for securely storing and accessing secrets, keys, and certificates. In this architecture, Key Vault manages all connection strings, API keys, and security credentials for secure communication between Azure services. This ensures strong security throughout the document creation process.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed Docker registry service that stores and manages container images. In this architecture, Container Registry manages versioned container images for the web application, ensuring consistent deployment across environments and enabling reliable rollback capabilities for the document generation solution.

## Scenario details

This document generation solution addresses the common challenge organizations face when creating consistent, high-quality documents that use institutional knowledge. Traditional document creation often suffers from blank page syndrome, inconsistent formatting, missed relevant information, and significant time investment from subject matter experts who could be focusing on higher-value activities.

The solution enables organizations to put their enterprise data to work by providing an intelligent document generation assistant that can quickly draft form-based templates for various document types including invoices, contracts, purchase orders, investment proposals, and grant submissions. The system grounds all generated content in the organization's actual data, reducing hallucination risks while providing transparency through reference links to source materials.

### Potential use cases

### Legal and compliance documentation

**Contract template generation**: Auto-generate contract templates that are based on previous agreements, legal precedents, and company policies. This ensures consistency and compliance across all business relationships.

**Regulatory submission preparation**: Create compliance documentation by synthesizing relevant regulations, organizational policies, and historical submission data into properly formatted regulatory filings.

**Legal brief drafting**: Generate legal document drafts by analyzing case law, precedents, and client information stored in the organization's knowledge base.

### Business operations and proposals

**Investment proposal creation**: Synthesize market research, financial data, and strategic documents to generate comprehensive investment proposals tailored to specific opportunities and stakeholder requirements.

**Grant application development**: Create grant applications by combining project requirements, organizational capabilities, and historical successful submissions into compelling funding requests.

**RFP response generation**: Automatically draft responses to requests for proposals by analyzing requirements against organizational capabilities and previous successful proposals.

### Financial and procurement documentation

**Invoice template standardization**: Generate consistent invoice templates that incorporate organizational branding, legal requirements, and customer-specific terms based on historical billing data.

**Purchase order automation**: Create purchase orders by referencing vendor databases, procurement policies, and budget constraints to ensure compliance and accuracy.

**Financial report compilation**: Generate financial reports by synthesizing data from multiple sources into standardized templates that meet regulatory and stakeholder requirements.

### Healthcare and research applications

**Clinical protocol documentation**: Generate research protocols by combining regulatory requirements, institutional guidelines, and previous study designs into compliant and comprehensive documents.

**Patient care plan templates**: Create standardized care plan templates that incorporate best practices, institutional policies, and patient-specific considerations.

**Research grant proposals**: Develop research funding proposals by synthesizing scientific literature, institutional capabilities, and funding agency requirements.

## Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and trade-offs.

### Document generation approach

**Current approach:** This solution uses Azure OpenAI Service with custom prompt engineering and RAG patterns to generate documents grounded in enterprise data. The system maintains full control over the generation process, including content filtering, template customization, and output formatting.

**Alternative approach:** Use Azure AI Foundry's Document Intelligence service combined with pre-built form-based templates. This approach provides out-of-the-box document processing capabilities with less customization but faster initial deployment.

Consider this alternative if your workload has the following characteristics:

- You need standardized document formats with minimal customization requirements
- You prefer a low-code solution with pre-configured document processing workflows
- Your document generation needs are primarily focused on data extraction and form filling rather than content creation

### Search and retrieval strategy

**Current approach:** Azure AI Search provides semantic search capabilities with vector embeddings for intelligent content retrieval. This enables nuanced understanding of document relationships and context-aware content discovery.

**Alternative approach:** Use Azure Cognitive Search with traditional keyword-based search or implement a custom search solution using Azure Cosmos DB's vector search capabilities.

Consider this alternative if your workload has the following characteristics:

- Your documents are primarily structured with consistent metadata
- You require specialized search logic not available in standard search services
- Cost optimization is a primary concern and semantic search capabilities are not essential

For organizations with hybrid requirements, a combination approach can be effective where critical documents use semantic search while supporting materials use traditional search methods.

## Cost Optimization

Cost Optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For information about the costs of running this scenario, see this preconfigured [estimate in the Azure pricing calculator](https://azure.com/e/37a86dc60ce14daba3cc0356c444923b).

Pricing varies per region and usage, so it isn't possible to predict exact costs for your usage. Most of the Azure resources used in this infrastructure are on usage-based pricing tiers. However, Azure Container Registry has a fixed cost per registry per day.

Key cost considerations include:

- **Azure OpenAI Service**: Costs are based on token consumption for both input and output. Document generation workloads can be token-intensive, so monitor usage patterns and implement caching strategies for frequently requested templates.

- **Azure AI Search**: Pricing is based on search units and storage. Consider the Standard tier (S1) for production workloads, but evaluate if Basic tier meets development and testing requirements.

- **Azure Cosmos DB**: Costs scale with request units and storage. Implement appropriate indexing policies and consider using autoscale to optimize costs based on actual usage patterns.

## Deploy this scenario

To deploy an implementation of this architecture, follow the steps in the [GitHub repository](https://github.com/microsoft/document-generation-solution-accelerator).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Solomon Pickett](https://www.linkedin.com/in/gregory-solomon-pickett-307560130/) | Software Engineer II


Other contributor:

- [James Hunter](https://www.linkedin.com/in/hunterjam) | Principal Software Engineer


*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure OpenAI Service Documentation](/azure/ai-services/openai/)
- [Azure AI Search Documentation](/azure/search/)
- [Azure AI Foundry Documentation](/azure/ai-foundry/)
- [Building RAG Applications with Azure](/azure/ai-services/openai/concepts/use-your-data)
- [Document Generation Solution Accelerator GitHub Repository](https://github.com/microsoft/document-generation-solution-accelerator)