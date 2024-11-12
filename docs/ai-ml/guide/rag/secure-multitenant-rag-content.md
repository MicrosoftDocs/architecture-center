Retrieval-Augmented Generation (RAG) is a pattern for building applications where foundational models are used to reason over proprietary information, or information that is not publicly available on the internet. Generally a client application calls to an orchestration layer that fetches the appropriate information from a data store such as a vector database and passes that data as part of the context as grounding data to the foundational model. In multitenant scenarios, you will need to ensure that tenants, or individuals within tenants, are only able to fetch grounding data that they are authorized to see.

While there are multitenant concerns beyond ensuring that users only access the information they are supposed to see, this article focuses on that aspect of multitenancy. The article starts with an overview of single tenant RAG architectures, discusses the challenges with regard to multitenancy, and concludes with secure multitenancy considerations and recommendations.

> [!NOTE]
> This article discusses some Azure OpenAI-specific features, such as Azure OpenAI On Your Data. That said, most of the principles discussed in this document apply to most foundational AI models.

## Single tenant RAG architecture with orchestrator

:::image type="complex" source="./_images/multitenant-rag-single-tenant-architecture.svg" lightbox="./_images/multitenant-rag-single-tenant-architecture.svg" alt-text="Diagram showing a RAG architecture with a single database tenant instance." border="false":::
   The diagram shows a user connecting to an intelligent application (1). The intelligent application then connects to an identity provider (2). The intelligent application then connects to an orchestrator (3). The orchestrator then connects to databases and vector stores (4). The orchestrator then connects to foundational models (5).
:::image-end:::
*Figure 1. Single-tenant RAG architecture*

### Workflow

In this single tenant RAG architecture, an orchestrator has the responsibility of fetching the appropriate proprietary tenant data from the data stores and providing it as grounding data to the foundational model. The following is a high-level workflow:

1. A user issues a request to the intelligent web application.
2. An identity provider authenticates the requestor.
3. The intelligent application calls the orchestrator API with the user query.
4. The orchestration logic extracts the user's query from the request and calls the appropriate data store to fetch grounding data for the query. The grounding data is added to the prompt that is sent to the foundational model, for example a model exposed in Azure OpenAI, in the next step. For more information on the details of RAG, see [Designing and developing a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide).
5. The orchestration logic connects to the foundational model and sends the prompt that includes the retrieved grounding data. The results are returned to the intelligent application.

## Single tenant RAG architecture with direct data access

A variant of the single tenant RAG architecture takes advantage of [Azure OpenAI service's ability to integrate directly with data stores such as Azure Search](/azure/ai-services/openai/concepts/use-your-data). In this architecture, you either do not have an orchestrator, or your orchestrator has less responsibilities. The Azure OpenAI API has the responsibility to call into the data store to fetch the grounding data and pass that data to the language model. You, in turn, have less control of what grounding data to fetch.

> [!NOTE]
> The Azure OpenAI service, managed by Microsoft, integrates with the data store.

:::image type="complex" source="./_images/multitenant-rag-single-tenant-direct-architecture.svg" lightbox="./_images/multitenant-rag-single-tenant-direct-architecture.svg" alt-text="Diagram showing a RAG architecture with Azure OpenAI service direct access to a single database tenant instance." border="false":::
   The diagram shows a user connecting to an intelligent application (1) The intelligent application then connects to an identity provider (2) The intelligent application then connects to the Azure OpenAI service (3) The Azure OpenAI service then connects to supported data stores such as Azure AI Search and Azure Blob storage. The Azure AI Search service then passes the data as part of the context to the language model (4)
:::image-end:::
*Figure 2. Single-tenant RAG architecture with direct data access from Azure OpenAI service*

### Workflow

In this RAG architecture, the foundational model has the responsibility of fetching the appropriate proprietary tenant data from the data stores and using that data as grounding data to the foundational model. The following is a high-level workflow:

1. A user issues a request to the intelligent web application.
1. An identity provider authenticates the requestor.
1. The intelligent application then calls the Azure OpenAI service with the user query.
1. The Azure OpenAI service connects to supported data stores such as Azure AI Search and Azure Blob storage to fetch the grounding data. The grounding data is used as part of the context when the Azure OpenAI service calls the OpenAI language model. The results are returned to the intelligent application.

## Multitenancy in RAG architecture

:::image type="complex" source="./_images/multitenant-rag-multitenant-architecture.svg" lightbox="./_images/multitenant-rag-multitenant-architecture.svg" alt-text="Diagram showing a RAG architecture with a shared database, a multitenant datanase and two single tenant databases." border="false":::
   The diagram shows a user connecting to an intelligent application (1). The intelligent application then connects to an identity provider (2). The intelligent application then connects to an orchestrator (3). The orchestrator then connects to a single tenant database (4a), a multitenant database (4b), or the shared database (4c). The orchestrator then connects to foundational model (5).
:::image-end:::
*Figure 3: RAG architecture - with multiple data store tenants*

In multitenant solutions, tenant data might exist in a tenant-specific store or co-exist with other tenants in a multitenant store. There also might be data in a store that is shared across tenants. Only data that the user is authorized to see should be used as grounding data. The users should only see shared data or data from their tenant with filtering rules applied to ensure the user can only access the data within their tenant that they are authorized to see.

### Workflow

This workflow is the same as in [Single tenant RAG architecture with orchestrator](#single-tenant-rag-architecture-with-orchestrator) with the exception of step 4.

1. *See Single tenant RAG architecture with orchestrator workflow*
1. *See Single tenant RAG architecture with orchestrator workflow*
1. *See Single tenant RAG architecture with orchestrator workflow*
1. The orchestration logic extracts the user's query from the request and calls the appropriate data store to fetch grounding data for the query. The grounding data is added to the prompt that is sent to Azure OpenAI in the next step.
    1. The orchestration logic fetches grounding data from the appropriate data store tenant instance, potentially applying security trimming rules to ensure only the data the user is authorized to access is returned.
    2. The orchestration logic fetches the appropriate tenant's grounding data from the multitenant data store, potentially applying security trimming rules to ensure only the data the user is authorized to access is returned.
    3. The orchestration logic fetches data from a data store that is shared across tenants.
1. *See Single tenant RAG architecture with orchestrator workflow*

