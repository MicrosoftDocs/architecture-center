[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture shows a content processing solution that extracts data and applies schemas across multi-modal content with confidence scoring and user validation. The solution processes claims, invoices, contracts, and other documents by extracting information from unstructured content and mapping it to structured formats. This architecture applies Azure AI Foundry, Azure AI Content Understanding Service, Azure OpenAI in Foundry Models, and other Azure services to transform large volumes of unstructured content through event-driven processing pipelines.

This architecture shows how to build scalable systems for processing content. The systems handle text, images, tables, and graphs. They include automatic quality checks and human review for business document workflows.

## Architecture

:::image type="complex" border="false" source="./_images/multi-modal-content-processing.png" alt-text="Diagram that shows a typical content processing architecture." lightbox="./_images/multi-modal-content-processing.png":::
   TODO - Add long description
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/multi-modal-content-processing.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Users upload multi-modal content (documents, images, contracts, invoices) through the web frontend interface. Content is submitted with specific processing requirements and target schemas.

2. Container App Website receives the content upload request and calls the processing API hosted in Container Apps. Both of these are custom coded solutions for this scenario. The API determines the appropriate processing pipeline and initiates content analysis workflows.

3. Container Apps manage the processing workflow. They connect Azure AI Content Understanding Service (which handles Optical Character Recognition or OCR and text extraction) with Azure OpenAI in Foundry Models (which maps schemas and converts data).

4. Azure AI Content Understanding Service performs machine learning-based OCR for efficient text extraction from various content formats including images, tables, and graphs.

5. Azure OpenAI in Foundry Models with GPT Vision processes the extracted content, maps it to custom or industry-defined schemas, and generates structured JSON output with confidence scoring.

6. The orchestration code in Container Apps stores processed results, confidence scores, schema mappings, and historical processing data for audit trails and continuous improvement in Azure Cosmos DB.

7. The orchestration code in Container Apps uses Azure Blob Storage to store source documents, intermediate processing artifacts, and final structured outputs for reliable data persistence and retrieval.

8. Azure Queue Storage manages event-driven processing workflows between this solution's services, ensuring reliable message handling and processing coordination across the pipeline components.

### Components

- [Azure Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a serverless container platform that enables you to run microservices and containerized applications on a serverless platform. In this architecture, Container Apps host the processing pipeline API that orchestrates content analysis, coordinates between AI services, and manages the extraction and transformation workflows. The code running on here is custom coded by your software engineering team.

- [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) is a managed AI service that provides access to advanced language models for natural language processing and generation. In this architecture, Azure AI Foundry provides the foundation for deploying and managing AI models used in the content processing pipeline and is the gateway into the connected AI services, like the Azure AI Content Understanding Service.

  - [Azure OpenAI in Foundry Models](/azure/well-architected/service-guides/azure-openai) provides language models including GPT-4o and GPT-4o mini. In this architecture, the models are hosted as a service in Azure AI Foundry. The models perform schema-based data transformation, maps extracted content to structured formats, and calculates confidence scores for extraction accuracy.

  - [Azure AI Content Understanding Service](/azure/ai-services/content-understanding/overview) analyzes various media content—such as audio, video, text, and images—transforming it into structured, searchable data. In this architecture, it performs advanced OCR and content extraction from multi-modal documents with high accuracy.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multi-model database service that provides guaranteed low latency and elastic scalability. In this architecture, Cosmos DB stores processed results, confidence scores, validation outcomes, and historical processing data for audit trails and performance optimization.

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is Microsoft's object storage solution optimized for storing massive amounts of unstructured data. In this architecture, Blob Storage maintains source documents, intermediate processing artifacts, and final structured outputs with reliable durability and global accessibility.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed Docker registry service that stores and manages container images. In this architecture, Container Registry manages versioned container images for the processing pipeline components, ensuring consistent deployment and rollback capabilities.

- [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction) enables storing large numbers of messages and accessing them from anywhere via HTTPS. In this architecture, Queue Storage stores the messages used in the event-driven processing workflows.

## Scenario details

This content processing solution addresses the challenge of extracting meaningful data from large volumes of unstructured, multi-modal content that organizations receive daily. Traditional manual processing of documents like contracts, invoices, claims, and compliance reports are time-consuming, error-prone, and doesn't scale with business growth. Organizations struggle with inconsistent data quality, lack of standardization, and the inability to quickly integrate extracted information into downstream business processes.

This solution uses advanced AI services to automatically extract, transform, and validate content from various document types. The system provides confidence scoring to enable automated processing for high-confidence extractions while flagging lower-confidence results for human review. This approach ensures both speed and accuracy while maintaining the flexibility to handle diverse content formats and custom business schemas.

### Potential use cases

### Financial services processing

**Claims processing automation:** Extract policy details, damage assessments, and cost estimates from insurance claims documents, photos, and adjuster reports with automated validation and compliance checking.

**Invoice and contract processing:** Automatically extract vendor information, line items, terms, and conditions from invoices and contracts, mapping to enterprise systems with confidence scoring for approval workflows.

**Regulatory document analysis:** Process regulatory filings, compliance reports, and audit documentation to extract key metrics and ensure adherence to financial regulations and reporting requirements.

### Healthcare documentation

**Clinical document processing:** Extract patient information, diagnoses, treatment plans, and medication details from medical records, lab reports, and clinical notes for electronic health record integration.

**Medical billing automation:** Process medical claims, billing statements, and insurance forms to extract procedure codes, patient details, and coverage information for automated billing workflows.

**Research data extraction:** Analyze clinical trial documents, research papers, and patient consent forms to extract study parameters, outcomes, and compliance data for medical research workflows.

### Legal and compliance

**Contract analysis and extraction:** Process legal contracts, agreements, and amendments to extract key terms, obligations, dates, and parties for contract management and compliance monitoring.

**Legal document discovery:** Analyze legal briefs, depositions, and case files to extract relevant facts, citations, and evidence for litigation support and case preparation.

**Compliance documentation:** Process regulatory submissions, audit reports, and compliance certificates to extract requirements, findings, and corrective actions for governance workflows.

### Manufacturing and supply chain

**Quality documentation processing:** Extract inspection results, test data, and certification details from quality control documents and certificates for compliance tracking and process improvement.

**Supplier documentation:** Process vendor certifications, material specifications, and shipping documents to extract compliance data and supply chain information for procurement workflows.

**Maintenance record analysis:** Extract equipment data, maintenance schedules, and repair histories from technical documentation for predictive maintenance and asset management systems.

## Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and trade-offs.

### Content extraction approach

**Current approach:** This solution uses Azure AI Content Understanding Service for advanced OCR and content extraction combined with Azure OpenAI Service for schema mapping and transformation. This approach provides high accuracy for complex multi-modal content with flexible schema customization.

**Alternative approach:** Use Azure AI Document Intelligence for document processing with pre-built models for common document types like invoices, receipts, and forms. This approach provides faster implementation for standard document types but with less flexibility for custom schemas.

Consider this alternative if your workload has the following characteristics:

- You primarily process standard document types with well-defined formats.
- You need faster time-to-market with pre-built extraction models.
- Your schema requirements align with standard document intelligence models.
- You have limited custom development resources for schema mapping.

### Processing orchestration

**Current approach:** This solution uses Azure Container Apps to host custom processing logic that orchestrates the content analysis pipeline. This provides maximum control over processing workflows, error handling, and custom business logic integration.

**Alternative approach:** Use Azure Logic Apps or Azure Functions for workflow orchestration with built-in connectors to AI services. This approach provides visual workflow design and managed service benefits but with less control over processing logic.

Consider this alternative if your workload has the following characteristics:

- You prefer visual workflow design over custom code development.
- Your processing workflows are relatively simple with standard conditional logic.
- You want to minimize infrastructure management overhead.
- Your team has more expertise in low-code/no-code solutions than containerized applications.

## Cost Optimization

Cost Optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For information about the costs of running this scenario, see this preconfigured [estimate in the Azure pricing calculator](https://azure.com/e/8d37476a9c784204b58909d57c1890a1).

Pricing varies per region and usage, so it isn't possible to predict exact costs for your usage. Most the Azure resources used in this infrastructure are on usage-based pricing tiers. However, Azure Container Registry has a fixed cost per registry per day.

## Deploy this scenario

To deploy an implementation of this architecture, follow the steps in the [GitHub repo](https://github.com/microsoft/content-processing-solution-accelerator).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Solomon Pickett](https://www.linkedin.com/in/gregory-solomon-pickett-307560130/) | Software Engineer II

Other contributor:

- [Todd Herman](https://www.linkedin.com/in/todd-herman) | Principal Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure AI Content Understanding Service documentation](/azure/ai-services/content-understanding/)
- [Azure OpenAI Service documentation](/azure/ai-services/openai/)
- [Content processing solution implementation deployment guide](https://github.com/microsoft/content-processing-solution-accelerator/blob/main/docs/DeploymentGuide.md)