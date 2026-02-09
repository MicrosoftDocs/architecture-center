[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture describes a conversation knowledge mining solution that extracts actionable insights from large volumes of conversational data, like from a call center. The solution uses Azure Content Understanding, Foundry IQ, Microsoft Foundry, and supporting Azure services. These services analyze unstructured dialogue and transform it into meaningful, structured insights through natural language processing and vector-based search capabilities.

The architecture demonstrates how to do the following capabilities:

- Build scalable conversation analytics pipelines that process audio and text inputs through event-driven workflows

- Extract entities and relationships
- Enable interactive exploration of insights through natural language chat interfaces for enterprise-grade conversation intelligence

## Architecture

:::image type="complex" border="false" source="./_images/unlock-insights-from-conversational-data.svg" alt-text="Diagram that shows a conversation knowledge mining architecture." lightbox="./_images/unlock-insights-from-conversational-data.svg":::
   The diagram shows the flow from call audio files and transcripts through Content Understanding for entity extraction, to Foundry IQ for vectorized storage, and finally to an interactive web front end that uses Foundry and Microsoft Agent Framework for natural language exploration of conversation insights. Two boxes labeled Call audio files and Call transcripts appear at the top left and serve as entry points. Arrows lead from these boxes to a component labeled Sync call data, which connects to a Storage account labeled Load call transcripts. An arrow points from Sync call data to Content Understanding, which includes the label Get conversation details from audio and text files. This component connects to Azure SQL Database, which contains the label Extracted entities. Foundry IQ and Vectorized call transcripts are also in this section. Two arrows point from Topic modeling to this section and to Foundry. The Azure App Service section includes Agent Framework and is labeled Orchestration to handle chat requests. An arrow points from App Service to this section. App Service also has arrows to Azure Container Registry and to a section that reads Web front end to explore call insights, chat to ask questions, and chart generations. The final component in the flow is Azure Cosmos DB, labeled Chat history.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/unlock-insights-from-conversational-data.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Raw call audio files and call transcripts reside in their source systems.

1. A data sync process uploads the audio files and transcripts to an Azure Storage account as the initial data sources. The data processing pipeline analyzes audio and transcript files from customer service calls and creates a searchable knowledge base. In this ingestion phase, speech-to-text technology converts audio files to text, while the pipeline directly processes transcripts for content analysis. This process occurs daily, but your scenario might require a different frequency.

1. Content Understanding processes both audio and text files to extract conversation details, entities, relationships, and contextual information. This service performs topic modeling and key phrase extraction to identify meaningful patterns within the conversational data. This data includes call-specific elements like resolution status, customer satisfaction indicators, and compliance markers.

1. Azure SQL Database stores extracted entities and processed conversation data for structured queries. Foundry IQ stores vectorized representations of call transcripts. These embeddings enable semantic search across the full set of transcripts and support complex queries related to call outcomes, agent performance, and customer sentiment trends.

1. Custom application code performs topic modeling on the extracted call transcript data from step 3. The code automatically identifies and categorizes conversation themes, like billing problems, technical support, or product feedback. This process uses Azure OpenAI in Foundry Models as a managed service.

   Microsoft Agent Framework orchestrates the workflow to analyze transcripts and extract topics. Topic modeling applies machine learning algorithms to discover patterns in language usage. It identifies groups of related words or phrases, then tags each conversation with relevant topic labels and confidence scores. The application saves the results to SQL Database, which enables automatic categorization and insight generation from customer calls at scale.

1. A scheduled batch processing pipeline runs periodically to process new data stored in the Storage account from steps 1 and 2. The pipeline uses Content Understanding services to analyze call audio files and transcripts. It extracts insights and transforms raw data into structured, searchable information.

   The pipeline writes the processed results to two locations. Foundry IQ stores vectorized call transcripts to enable semantic search capabilities. SQL Database stores extracted entities and structured data.
  
   The pipeline can operate in single-threaded mode for sequential processing. Or it can operate in parallel across multiple threads to handle larger data volumes and improve processing throughput, depending on workload requirements and system capacity.

1. The orchestration layer within Azure App Service coordinates the overall workflow by managing the data flow between services and providing API endpoints. This layer integrates Azure OpenAI models and Agent Framework for intelligent processing and response generation. It uses function calling capabilities to enhance the conversation analysis workflow. This orchestration applies specifically to handling chat requests.

1. Users access a web front end hosted on App Service to explore call insights, chat with the data by using natural language queries, and generate visualizations. The interface provides conversational access to the processed knowledge base and enables queries like *Show me unresolved billing complaints from last month* or *What are the most common reasons for escalations?*

1. Azure Cosmos DB stores chat history and session data. It maintains conversation context for the interactive front-end experience and enables persistent user sessions across the application. Azure Cosmos DB stores the chat history, so it only interacts with the app to pull the user's previous questions and answers. When users ask new questions, the system queries SQL Database and Foundry IQ for the actual call data and insights.

### Components

- A [Storage account](/azure/storage/common/storage-account-overview) is a scalable cloud storage service that provides secure and durable storage for various data types. In this architecture, the Storage account serves as the primary ingestion point for call audio files and transcripts. It provides a reliable foundation for the conversation analysis pipeline. It supports hot, cool, and archive storage tiers to optimize costs for long-term conversation data retention.

- [Content Understanding](/azure/ai-services/content-understanding/overview) is an AI service that extracts insights from unstructured content, including audio and text. In this architecture, Content Understanding processes conversational data to identify entities, relationships, and key themes. It transforms raw dialogue into structured, analyzable information. This information includes call center-specific insights like resolution indicators, escalation triggers, and compliance markers.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed relational database service that provides high availability and scalability. In this architecture, SQL Database stores extracted entities, conversation metadata, and structured insights. This configuration lets you efficiently query and analyze conversation intelligence data, including call metrics, agent performance data, and customer satisfaction scores.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service (PaaS) offering for building and hosting web applications. In this architecture, App Service hosts both the orchestration APIs that coordinate data processing workflows and the interactive web front end where users explore conversation insights through natural language interaction.

- [Agent Framework](/agent-framework/overview/agent-framework-overview) is an open-source SDK that integrates large language models with conventional programming languages. In this architecture, Agent Framework orchestrates the interaction between Azure OpenAI and other Azure AI services. It also manages function calling and coordinates intelligent workflows.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multiple-model database service that has low latency. In this architecture, Azure Cosmos DB stores chat history and user session data. This storage enables fast access to conversation context for the interactive front-end experience.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed Docker registry service for storing and managing container images. In this architecture, Container Registry manages container images for the application components. This management ensures consistent deployment and version control across the solution.

- [Foundry](/azure/ai-foundry/what-is-foundry) is a unified Azure PaaS offering for enterprise AI operations, model builders, and application development. It combines production-grade infrastructure with developer-friendly interfaces, which enables developers to focus on building applications rather than managing infrastructure. In this architecture, Foundry provides the foundation for deploying and managing AI models in the chat interface. It also serves as the gateway to connected AI services, like Foundry IQ.

  - [Azure OpenAI](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure) is a cloud-based platform from Microsoft that provides access to advanced language models for natural language processing and generation. In this architecture, Azure OpenAI models power the conversational chat interface. This interface lets users ask questions about their conversation data and receive contextual responses through the RAG pattern.

  - [Foundry Agent Service](/azure/ai-foundry/agents/overview) is a managed runtime service that connects the core pieces of Foundry, like models, tools, and frameworks, into a single runtime. It manages conversations, orchestrates tool calls, enforces content safety, and integrates with identity, networking, and observability systems. These activities help ensure that agents remain secure, scalable, and production ready. In this architecture, the chat interface invokes Foundry Agent Service to power the chat completion.

  - [Foundry IQ](/azure/ai-foundry/agents/how-to/foundry-iq-connect) is a capability that uses Azure AI Search to provide agent‑aware retrieval over enterprise data. In this architecture, Foundry IQ creates and searches vectorized representations of call transcripts. This approach enables semantic search and retrieval-augmented generation (RAG) patterns for intelligent conversation exploration. It uses optimized indexing strategies to handle millions of conversation records efficiently.

### Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Evaluate the following alternatives and trade-offs to align with your specific goals.

#### Content processing approach

- **Current approach:** This solution uses Content Understanding as the primary service for extracting entities, relationships, and insights from conversational data. It provides specialized conversation analysis capabilities with built-in understanding of dialogue patterns and conversational context.

- **Alternative approach:** Combine Azure Document Intelligence with Azure OpenAI to process transcripts and extract structured information by using prompt engineering and few-shot learning (FSL) techniques.

Consider the alternative approach if your workload has the following characteristics:

- You need to process conversations that already exist in well-structured document formats.

- You require custom entity extraction that goes beyond standard conversation analysis.

- You want more control over the extraction logic through custom prompts and examples.

- Your conversations include complex formatting or mixed content types that require document-specific processing.

#### Search and retrieval strategy

- **Current approach:** This solution uses Foundry IQ with vector embeddings to enable semantic search across conversation transcripts. It supports natural language queries and RAG-based interactions.

- **Alternative approach:** Implement a pure vector database solution by using Azure DocumentDB with vector search capabilities. Alternatively, use Azure Database for PostgreSQL with the *pgvector* extension.

Consider the alternative approach if your workload has the following characteristics:

- You need high-performance vector similarity search with minimal latency.

- Your solution requires tight integration with existing MongoDB or PostgreSQL ecosystems.

- You want to minimize the number of different services in your architecture.

- You only need vector-based search and don't require traditional full-text search.

## Scenario details

Organizations accumulate large volumes of unstructured conversational data from customer interactions, support calls, sales conversations, and internal meetings. This conversation knowledge mining solution extracts actionable insights from that data. Traditional analysis methods struggle to process conversational data at scale and extract meaningful patterns. As a result, organizations face limitations in understanding customer sentiment, identifying operational problems, and uncovering opportunities for improvement.

The solution uses advanced AI capabilities to automatically process audio recordings and text transcripts. It extracts key entities and relationships, then creates searchable knowledge bases. Users can explore these knowledge bases through natural language interaction. These capabilities help analysts and business users quickly identify trends, understand customer feedback patterns, and make data-driven decisions without requiring technical expertise in data analysis or query languages.

### Potential use cases

Consider the following potential use cases.

#### Customer service optimization

- **Contact center quality improvement:** Analyze customer support calls to identify common problems, measure resolution effectiveness, and discover training opportunities for support agents across different product lines and service categories.

- **Agent performance evaluation:** Analyze conversation patterns to identify techniques that top-performing agents use, identify common resolution strategies, and highlight coaching opportunities. Track metrics like first-call resolution rates and escalation patterns.

- **Customer sentiment analysis:** Extract emotional indicators and satisfaction trends from customer interactions to improve service delivery. Use these insights to identify at-risk accounts and refine strategies to enhance customer experience.

- **Support ticket correlation:** Connect conversation themes with support ticket outcomes to optimize routing and reduce resolution times. This approach helps proactively address recurring customer concerns.

- **Quality scoring automation:** Extract conversation elements that correlate with customer satisfaction scores. Use these insights to automate quality assurance processes and ensure consistent evaluation across all interactions.

#### Sales and marketing intelligence

- **Sales conversation analysis:** Extract insights from sales calls to identify successful conversation patterns, objection-handling techniques, and competitive intelligence. Use these insights to improve sales effectiveness and enhance training programs.

## Considerations
These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For more information about the costs to run this scenario, see the [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/c0979505ef6a45409c218c24ee4033de).

Pricing varies by region and usage, so you can't predict exact costs for your specific workload. Most Azure resources in this infrastructure follow usage-based pricing tiers. But some services, like Container Registry, incur fixed daily costs for each registry. Other services, like SQL Database and Azure Cosmos DB, might generate baseline charges when you provision them, regardless of actual usage.

## Deploy this scenario

To deploy an implementation of this architecture, follow the [steps in the GitHub repository](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

The deployment includes automated infrastructure as code (IaC) templates, sample conversation data for testing, and setup documentation to help you get started.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Solomon Pickett](https://www.linkedin.com/in/gregory-solomon-pickett-307560130/) | Software Engineer II

Other contributor:

- [Anish Arora](https://www.linkedin.com/in/aniarora/) | Senior Software Engineer
- [Malory Rose](https://www.linkedin.com/in/malory-rose-8aa503135/) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [AI Search vector search capabilities](/azure/search/vector-search-overview)

## Related resource

- [Design and develop a RAG solution](../guide/rag/rag-solution-design-and-evaluation-guide.md)
