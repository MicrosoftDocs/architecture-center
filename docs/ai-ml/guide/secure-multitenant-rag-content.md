Retrieval-Augmented Generation (RAG) is a pattern for building applications where foundational models are used to reason over proprietary information or other information that isn't publicly available on the internet. Generally, a client application calls to an orchestration layer that fetches relevant information from a data store, such as a vector database. The orchestration layer passes that data as part of the context as grounding data to the foundational model.

A multitenant solution is used by multiple customers, where each customer (tenant) consists of multiple users from the same organization, company, or group. In multitenant scenarios, you need to ensure that tenants, or individuals within tenants, are only able to incorporate grounding data that they're authorized to see.

While there are multitenant concerns beyond ensuring that users only access the information they're supposed to see, this article focuses on that aspect of multitenancy. The article starts with an overview of single tenant RAG architectures, discusses the challenges regarding multitenancy with RAG and some common approaches to follow, and concludes with secure multitenancy considerations and recommendations.

> [!NOTE]
> This article discusses some Azure OpenAI-specific features, such as Azure OpenAI On Your Data. That said, most of the principles discussed in this document apply to most foundational AI models, regardless of their host platform.

## Single tenant RAG architecture with orchestrator

:::image type="complex" source="./_images/multitenant-rag-single-tenant-architecture.svg" lightbox="./_images/multitenant-rag-single-tenant-architecture.svg" alt-text="Diagram showing a RAG architecture with a single database tenant instance." border="false":::
   The diagram shows a user connecting to an intelligent application (1). The intelligent application then connects to an identity provider (2). The intelligent application then connects to an orchestrator (3). The orchestrator then connects to databases and vector stores (4). The orchestrator then connects to foundational models (5).
:::image-end:::
*Figure 1. Single-tenant RAG architecture*

### Workflow

In this single tenant RAG architecture, an orchestrator has the responsibility of fetching relevant proprietary tenant data from the data stores and providing it as grounding data to the foundational model. The following is a high-level workflow:

1. A user issues a request to the intelligent web application.
2. An identity provider authenticates the requestor.
3. The intelligent application calls the orchestrator API with the user query.
4. The orchestration logic extracts the user's query from the request and calls the appropriate data store to fetch relevant grounding data for the query. The grounding data is added to the prompt that is sent to the foundational model, for example a model exposed in Azure OpenAI, in the next step.
5. The orchestration logic connects to the foundational model's inferencing API and sends the prompt that includes the retrieved grounding data. The results are returned to the intelligent application.

For more information on the details of RAG, see [Designing and developing a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide).

## Single tenant RAG architecture with direct data access

A variant of the single tenant RAG architecture takes advantage of [Azure OpenAI service's ability to integrate directly with data stores such as Azure Search](/azure/ai-services/openai/concepts/use-your-data). In this architecture, you either don't have your own orchestrator, or your orchestrator has fewer responsibilities. The Azure OpenAI API has the responsibility to call into the data store to fetch the grounding data and pass that data to the language model. You, in turn, have less control over what grounding data to fetch and the relevancy of that data.

> [!NOTE]
> The Azure OpenAI service, managed by Microsoft, integrates with the data store. The model itself does not integrate with the data stores. The model receives grounding data in the exact same manner as it does if the data is fetched by an orchestrator.

:::image type="complex" source="./_images/multitenant-rag-single-tenant-direct-architecture.svg" lightbox="./_images/multitenant-rag-single-tenant-direct-architecture.svg" alt-text="Diagram showing a RAG architecture with Azure OpenAI service direct access to a single database tenant instance." border="false":::
   The diagram shows a user connecting to an intelligent application (1) The intelligent application then connects to an identity provider (2) The intelligent application then connects to the Azure OpenAI service (3) The Azure OpenAI service then connects to supported data stores such as Azure AI Search and Azure Blob storage. The Azure AI Search service then passes the data as part of the context to the language model (4)
:::image-end:::
*Figure 2. Single-tenant RAG architecture with direct data access from Azure OpenAI service*

### Workflow

In this RAG architecture, the service providing the foundational model has the responsibility of fetching the appropriate proprietary tenant data from the data stores and using that data as grounding data to the foundational model. The following is a high-level workflow (italicized steps are identical to the Single tenant RAG architecture with orchestrator workflow):

1. *A user issues a request to the intelligent web application.*
1. *An identity provider authenticates the requestor.*
1. The intelligent application then calls the Azure OpenAI service with the user query.
1. The Azure OpenAI service connects to supported data stores such as Azure AI Search and Azure Blob storage to fetch the grounding data. The grounding data is used as part of the context when the Azure OpenAI service calls the OpenAI language model. The results are returned to the intelligent application.

In order to consider this architecture in a multitenant solution, the service, such as Azure OpenAI, that is performing direct access must support the multitenant logic required by your solution.

## Multitenancy in RAG architecture

In multitenant solutions, tenant data might exist in a tenant-specific store or coexist with other tenants in a multitenant store. There also might be data in a store that is shared across tenants. Only data that the user is authorized to see should be used as grounding data. The users should only see common (all tenant) data or data from their tenant with filtering rules applied to ensure they only see data they're authorized to see.

:::image type="complex" source="./_images/multitenant-rag-multitenant-architecture.svg" lightbox="./_images/multitenant-rag-multitenant-architecture.svg" alt-text="Diagram showing a RAG architecture with a shared database, a multitenant database and two single tenant databases." border="false":::
   The diagram shows a user connecting to an intelligent application (1). The intelligent application then connects to an identity provider (2). The intelligent application then connects to an orchestrator (3). The orchestrator then connects to a single tenant database (4a), a multitenant database (4b), or the shared database (4c). The orchestrator then connects to foundational model (5).
:::image-end:::
*Figure 3: RAG architecture - with multiple data store tenants*

### Workflow

This workflow is the same as in [Single tenant RAG architecture with orchestrator](#single-tenant-rag-architecture-with-orchestrator) except step 4.

1. *A user issues a request to the intelligent web application.*
1. *An identity provider authenticates the requestor.*
1. *The intelligent application calls the orchestrator API with the user query.*
1. The orchestration logic extracts the user's query from the request and calls the appropriate data store(s) to fetch tenant-authorized, relevant grounding data for the query. The grounding data is added to the prompt that is sent to Azure OpenAI in the next step. Some or all of the following steps are involved:
    1. The orchestration logic fetches grounding data from the appropriate tenant-specific data store instance, potentially applying security filtering rules to return only the data the user is authorized to access.
    2. The orchestration logic fetches the appropriate tenant's grounding data from the multitenant data store, potentially applying security filtering rules to return only the data the user is authorized to access.
    3. The orchestration logic fetches data from a data store that is shared across tenants.
1. *The orchestration logic connects to the foundational model's inferencing API and sends the prompt that includes the retrieved grounding data. The results are returned to the intelligent application.*

## Design considerations for multitenant data in RAG

### Choosing store isolation models

There are two main [architectural approaches for storage and data in multitenant scenarios](/azure/architecture/guide/multitenant/approaches/storage-data): store-per-tenant and multitenant stores. These approaches are in addition to stores that contain data that is shared across tenants. This section touches on each approach. It should be noted that your multitenant solution can use a combination of these approaches.

#### Store-per-tenant

In store-per-tenant, as the name suggests, each tenant has its own store. The advantages of this approach include both data and performance isolation. Each tenant's data is encapsulated in its own store. In most data services, the isolated stores aren't susceptible to the noisy neighbor problem of other tenants. This approach also simplifies cost allocation, as the entire cost of a store deployment can be attributed to a single tenant.

The challenges of this approach potentially include higher management and operation overhead and higher cost. This approach shouldn't be considered when there are a large number of small tenants such as business to consumer scenarios.

In the context of this AI scenario, a store-per-tenant would mean that the grounding data necessary to bring relevancy into the context would come from an existing or new data store that only contains grounding data for the tenant. In this topology, the database instance is the discriminator used per tenant.
#### Multitenant stores

In multitenant stores, multiple tenants data coexists in the same store. The advantages of this approach include the potential for cost optimization, the ability to handle a higher number of tenants than the store-per-tenant model, and lower management overhead due to the lower number of store instances.

The challenges of using shared stores include the need to ensure data isolation, data management, the potential for noisy neighbor challenges, and challenges allocating costs to tenants. Ensuring data isolation is the most important concern with this approach. You have the responsibility of implementing the security approach to ensure tenants are only able to access their data. Data management can also be a challenge if tenants have different data lifecycles that may require operations such as building indexes on different schedules.

Some platforms have features that you can take advantage of when you're implementing tenant data isolation in shared stores. For example, Azure Cosmos DB has native support for partitioning and sharding, and it's common to use a tenant identifier as a partition key to provide some level of isolation between tenants. Azure SQL and Postgres Flex support row-level security, although this feature isn't commonly used in multitenant solutions because you have to design your solution around these features if you plan to use them in your multitenant store.

In the context of this AI scenario, that would mean that grounding data for all tenants are comingled in the same data store, in such a way that your query to that data store must contain a tenant discriminator to ensure responses are restricted to bring back only relevant data within the context of the tenant.

#### Shared stores

Multitenant solutions often have data that is shared across tenants. In an example multitenant solution for the healthcare domain, there may be a database that stores general medical information or information that isn't tenant specific.

In the context of this AI scenario, this would be a generally accessible grounding data store that does not specifically need filtering based on any tenant as the data is relevant and authorized for all tenants in the system.

### Identity

[Identity is a key aspect to multitenant solutions](/azure/architecture/guide/multitenant/considerations/identity) including secure multitenant RAG. The intelligent application should integrate with an identity provider (IdP) to authenticate the identity of the user. The multitenant RAG solution needs an [identity directory](/azure/architecture/guide/multitenant/considerations/identity#identity-directory) where either authoritative identities or references to identities are stored. This identity needs to flow through the request chain, allowing downstream services such as the orchestrator or even the data store itself to identify the user.

You also require a means of [mapping a user to a tenant](/azure/architecture/guide/multitenant/considerations/identity#grant-users-access-to-tenant-data) so you can grant access to that tenant data.

### Define your tenant and authorization requirements

When building a multitenant RAG solution, you must [define what a tenant is for your solution](/azure/architecture/guide/multitenant/considerations/tenancy-models#define-a-tenant). The two common models to choose from are business to business (B2B) and business to consumer (B2C). This determination helps inform you of areas you should consider when you architect your solution. Understanding the number of tenants is critical for deciding the data store model. A large number of tenants may necessitate a model with multiple tenants per store, while a smaller number might allow for a store per tenant model. The amount of per-tenant data is also important. If tenants have large amounts of data that may prevent you from using multitenant stores because of size limitations on the data store.

In existing workloads that are being expanded to support this AI scenario, you may have already made this choice. Generally speaking, you'll be able to use your existing data storage topology for the grounding data if that data store can provide sufficient relevancy and meet any other non-functional requirements. However, if you are introducing new components such as a dedicated vector search store as a dedicated grounding store, then you'll need to make this decision, considering factors such as your current deployment stamp strategy, your application control plane impact, and any per-tenant data lifecycle differences (such as pay-for-performance situations.)

Once you define what a tenant is for your solution, you must then define your authorization requirements for data. While tenants will only access data from their tenant, your authorization requirements may be more granular. For example, in a healthcare solution you might have rules such as:

- A patient can only access their own patient data
- A healthcare professional can access their patients' data
- A finance user can access only finance-related data
- A clinical auditor can see all patients' data
- All users can access base medical knowledge in a shared data store

In a document-based RAG application, you might want to restrict users access to documents based on a tagging scheme or sensitivity levels set on documents.

Once you have a definition of what a tenant is and have a clear understanding of the authorization rules, use that information as requirements for your data store solution.

### Filtering

Filtering, also known as security trimming, refers to exposing only the data to users that they're authorized to see. In a multitenant RAG scenario, a user may be mapped to a tenant-specific store. That doesn't mean that the user should be able to access all the data in that store. In [define your tenant and authorization requirements](#define-your-tenant-and-authorization-requirements), we discussed the importance of defining the authorization requirements for your data. These authorization rules should be used as the basis for filtering.

Filtering can be accomplished by using data platform capabilities such as row-level security or it may necessitate custom logic, data, or metadata. Again, these platform features aren't commonly used in multitenant solutions due to the need to design your system around these features.

### Encapsulating multitenant data logic

It is recommended to have an API in front of whatever storage mechanism you are using. The API acts as a gatekeeper, enforcing that users only get access to the information they should get access to.

:::image type="complex" source="./_images/multitenant-rag-multitenant-api-architecture.svg" lightbox="./_images/multitenant-rag-multitenant-api-architecture.svg" alt-text="Diagram showing a RAG architecture with a shared database, a multitenant database and two single tenant databases with an API layer between the orchestrator and databases." border="false":::
   The diagram shows a user connecting to an intelligent application. The intelligent application then connects to an identity provider. The intelligent application then connects to an orchestrator. The orchestrator connects to an API layer. The API layer connects to databases and vector stores. The orchestrator then connects to foundational models.
:::image-end:::
*Figure 4. Multitenant RAG architecture with an API encapsulating multitenant tenant data access logic*

As noted earlier in this article, user access to data can be limited by:

- The user's tenant
- Platform features
- Custom security filtering/trimming rules.

This layer should have the following responsibilities:

- Route the query to a tenant-specific store in a store-per-tenant model
- Select only data from the user's tenant in multitenant stores
- Use the appropriate identity for a user to support platform-enabled authorization logic
- Enforce custom security trimming logic

Code that needs to access tenant data shouldn't be able to query the backend stores directly. All requests for data should flow through this API layer. This API layer provides a single point of governance or security layer over top of your tenant data. This approach keeps the tenant and user data access authorization logic from bleeding into different areas of the application. This logic is encapsulated in the API layer. This encapsulation makes the solution easier to validate and test.

## Summary

When designing a multitenant RAG inferencing solution, you must take into account how to architect the grounding data solution for your tenants. Get an understanding of the number of tenants and the amount of per-tenant data you store. This information helps you design your data tenancy solution. We recommend that you implement an API layer that encapsulates the data access logic, including both multitenant and filtering logic.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer
- [Daniel Scott-Raynsford](https://linkedin.com/in/dscottraynsford) | Partner Technology Strategist

## Next steps

> [!div class="nextstepaction"]
> [Design and evaluate RAG solutions](./rag/rag-solution-design-and-evaluation-guide.yml)

## Related resources

- [SaaS and multitenant solution architecture](../../guide/saas-multitenant-solution-architecture/index.md)
- [Basic OpenAI end-to-end chat reference architecture](../architecture/basic-openai-e2e-chat.yml)
- [Baseline OpenAI end-to-end chat reference architecture](../architecture/baseline-openai-e2e-chat.yml)
- [Access Azure OpenAI and other language models through a gateway](./azure-openai-gateway-guide.yml)
