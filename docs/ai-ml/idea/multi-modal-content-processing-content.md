[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture describes a content processing solution that extracts data and applies schemas across multi-modal content by using confidence scoring and user validation. It processes claims, invoices, contracts, and other documents by extracting information from unstructured content and mapping it to structured formats. This architecture applies Azure AI Foundry, Azure AI Content Understanding, Azure OpenAI in Azure AI Foundry Models, and other Azure services to transform large volumes of unstructured content through event-driven processing pipelines.

This architecture shows how to build scalable systems for processing content. The systems handle text, images, tables, and graphs and include automatic quality checks and human review for business document workflows.

## Architecture

:::image type="complex" border="false" source="./_images/multi-modal-content-processing.svg" alt-text="Diagram that shows a typical content processing architecture." lightbox="./_images/multi-modal-content-processing.svg":::
   The image contains key sections that correspond to the workflow. The Client browser section has text that reads Upload file. An arrow points from this text to the Container Apps section. Four lines point from Content processor in the Container Apps section. The top line in this section splits into two lines. One line reads Extract or map and points to Azure OpenAI in Foundry Models. The other line reads Extract and points to Azure AI Content Understanding. The next line in this section reads Task result and points to Blob Storage. The next line reads Task history or result and points to Azure Cosmos DB. An arrow that reads Dequeue points to Azure Queue Storage. An arrow that reads Enqueue points from Content processor API to Queue Storage. An arrow points from the Monitor or update process section to Power BI. Another arrow points from Azure Cosmos DB to Power BI.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/multi-modal-content-processing.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Users upload multi-modal content, like documents, images, contracts, and invoices, through the web front-end interface. Content is submitted with specific processing requirements and target schemas.

1. The Azure Container Apps website receives the content upload request and invokes the processing API hosted in Container Apps. Both components are custom-coded solutions tailored for this scenario. The API selects the appropriate processing pipeline and initiates content analysis workflows.

1. Container Apps manages the processing workflow. It connects Content Understanding, which performs optical character recognition (OCR) and extracts text, with Azure OpenAI in Foundry Models. These models map schemas and convert the extracted data into structured formats.

1. Content Understanding performs machine learning-based OCR for efficient text extraction from various content formats, including images, tables, and graphs.

1. Azure OpenAI in Foundry Models with GPT Vision processes the extracted content, maps it to custom or industry-defined schemas, and generates a structured JSON output with confidence scoring.

1. The orchestration code in Container Apps stores processed results, confidence scores, schema mappings, and historical processing data for audit trails and continuous improvement in Azure Cosmos DB.

1. The orchestration code in Container Apps uses Azure Blob Storage to store source documents, intermediate processing artifacts, and final structured outputs for reliable data persistence and retrieval.

1. Azure Queue Storage manages event-driven processing workflows between this solution's services. This management ensures reliable message handling and processing coordination across the pipeline components.

1. The content processor monitor website displays the processed results to users through the web interface. Users can review the structured JSON output, correct any inaccuracies, add comments for context or feedback, and save the final validated results to the system.

1. The content processor monitor website feeds processing metrics and user feedback data directly into Power BI dashboards. Processed data and metadata stored in Azure Cosmos DB provide comprehensive analytics on the content processing pipeline. These insights include KPIs, success rates, document type distributions, confidence score trends, user correction patterns, and other operational metrics that support data-driven optimization of the content processing pipeline.

### Components

- [Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a serverless container platform that you can use to run microservices and containerized applications on a serverless platform. In this architecture, Container Apps hosts the processing pipeline API that orchestrates content analysis, coordinates between AI services, and manages the extraction and transformation workflows. The code that runs is custom coded by your software engineering team.

- [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) is a managed AI service that provides access to advanced language models for natural language processing and generation. In this architecture, Azure AI Foundry provides the foundation for deploying and managing AI models used in the content processing pipeline and is the gateway into the connected AI services, like Content Understanding.

  - [Azure OpenAI in Foundry Models](/azure/ai-foundry/openai/overview) is a component of Azure AI Foundry that provides language models, including GPT-4o and GPT-4o mini. In this architecture, the models are hosted as a service in Azure AI Foundry. These models perform schema-based data transformation, map extracted content to structured formats, and calculate confidence scores for extraction accuracy.

  - [Content Understanding](/azure/ai-services/content-understanding/overview) is a multi-modal AI service that analyzes various media content, such as audio, video, text, and images, and transforms it into structured, searchable data. In this architecture, Content Understanding accurately performs advanced OCR and content extraction from multi-modal documents.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multiple-model database service that provides guaranteed low latency and elastic scalability. In this architecture, Azure Cosmos DB stores processed results, confidence scores, validation outcomes, and historical processing data for audit trails and performance optimization.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is Microsoft's object storage solution optimized for storing massive amounts of unstructured data. In this architecture, Blob Storage maintains source documents, intermediate processing artifacts, and final structured outputs with reliable durability and global accessibility.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed Docker registry service that stores and manages container images. In this architecture, Container Registry manages versioned container images for the processing pipeline components. This system ensures consistent deployment and rollback capabilities.

- [Power BI](/power-bi/fundamentals/power-bi-service-overview) is a collection of software services, apps, and connectors that work together to help you create, share, and consume business insights in the way that best serves you and your organization. In this architecture, Power BI connects to Azure Cosmos DB and receives real-time processing metrics from the monitoring web application to deliver comprehensive analytics on document processing performance, user feedback patterns, and operational KPIs.

## Scenario details

This content processing solution addresses the challenge of extracting meaningful data from large volumes of unstructured, multi-modal content that organizations receive daily. Traditional manual processing of documents such as contracts, invoices, claims, and compliance reports is time-consuming, error-prone, and doesn't scale with business growth. As a result, organizations face inconsistent data quality, lack of standardization, and difficulty integrating extracted information into downstream business processes.

This solution uses advanced AI services to automatically extract, transform, and validate content from various document types. The system provides confidence scoring to enable automated processing for high-confidence extractions while flagging lower-confidence results for human review. This approach ensures both speed and accuracy while maintaining the flexibility to handle diverse content formats and custom business schemas.

### Potential use cases

#### Financial services processing

**Claims processing automation:** Extract policy details, damage assessments, and cost estimates from insurance claims documents, photos, and adjuster reports by using automated validation and compliance checks.

**Invoice and contract processing:** Automatically extract vendor information, line items, terms, and conditions from invoices and contracts, and map them to enterprise systems by using confidence scoring for approval workflows.

**Regulatory document analysis:** Process regulatory filings, compliance reports, and audit documentation to extract key metrics and ensure adherence to financial regulations and reporting requirements.

#### Healthcare documentation

**Clinical document processing:** Extract patient information, diagnoses, treatment plans, and medication information from medical records, lab reports, and clinical notes for electronic health record integration.

**Medical billing automation:** Process medical claims, billing statements, and insurance forms to extract procedure codes, patient details, and coverage information for automated billing workflows.

**Research data extraction:** Analyze clinical trial documents, research papers, and patient consent forms to extract study parameters, outcomes, and compliance data for medical research workflows.

#### Legal and compliance

**Contract analysis and extraction:** Process legal contracts, agreements, and amendments to extract key terms, obligations, dates, and parties for contract management and compliance monitoring.

**Legal document discovery:** Analyze legal briefs, depositions, and case files to extract relevant facts, citations, and evidence for litigation support and case preparation.

**Compliance documentation:** Process regulatory submissions, audit reports, and compliance certificates to extract requirements, findings, and corrective actions for governance workflows.

#### Manufacturing and supply chain

**Quality documentation processing:** Extract inspection results, test data, and certification details from quality control documents and certificates for compliance tracking and process improvement.

**Supplier documentation:** Process vendor certifications, material specifications, and shipping documents to extract compliance data and supply chain information for procurement workflows.

**Maintenance record analysis:** Extract equipment data, maintenance schedules, and repair histories from technical documentation for predictive maintenance and asset management systems.

## Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and trade-offs.

### Content extraction approach

**Current approach:** This solution uses Content Understanding for advanced OCR and content extraction combined with Azure OpenAI for schema mapping and transformation. This approach provides high accuracy for complex multi-modal content with flexible schema customization.

**Alternative approach:** Use Azure AI Document Intelligence for document processing by using prebuilt models for common document types like invoices, receipts, and forms. This approach provides faster implementation for standard document types but less flexibility for custom schemas.

Consider this alternative if your workload has the following characteristics:

- You primarily process standard document types that have well-defined formats.

- You need faster time-to-market with prebuilt extraction models.

- Your schema requirements align with standard document intelligence models.

- You have limited custom development resources for schema mapping.

### Processing orchestration

**Current approach:** This solution uses Container Apps to host custom processing logic that orchestrates the content analysis pipeline. This approach provides maximum control over processing workflows, error handling, and custom business logic integration.

**Alternative approach:** Use Azure Logic Apps or Azure Functions for workflow orchestration with built-in connectors to AI services. This approach provides visual workflow design and managed service benefits but less control over processing logic.

Consider this alternative if your workload has the following characteristics:

- You prefer visual workflow design over custom code development.

- Your processing workflows are relatively simple and use standard conditional logic.

- You want to minimize infrastructure management overhead.

- Your team has more expertise in low-code and no-code solutions than in containerized applications.

## Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For more information about the costs to run this scenario, see the preconfigured [estimate in the Azure pricing calculator](https://azure.com/e/46ff2147f30f40dcb61a5a3f2e405117).

Pricing varies by region and usage, so it's not possible to predict exact costs for your deployment. Most Azure resources used in this infrastructure follow usage-based pricing tiers. However, Container Registry incurs a fixed cost per registry per day.

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

- [Content Understanding documentation](/azure/ai-services/content-understanding/)
- [Azure OpenAI documentation](/azure/ai-services/openai/)
- [Content processing solution implementation deployment guide](https://github.com/microsoft/content-processing-solution-accelerator/blob/main/docs/DeploymentGuide.md)
