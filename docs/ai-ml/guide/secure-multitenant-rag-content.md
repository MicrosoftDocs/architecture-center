Retrieval-Augmented Generation (RAG) is a pattern for building applications that use foundational models to reason over proprietary or other information that isn't publicly available on the internet. Generally, a client application calls to an orchestration layer that fetches relevant information from a data store, such as a vector database. The orchestration layer passes that data as part of the context as grounding data to the foundational model.

A multitenant solution is used by multiple customers. Each customer, or tenant, consists of multiple users from the same organization, company, or group. In multitenant scenarios, you need to ensure that tenants, or individuals within tenants, are only able to incorporate grounding data that they're authorized to see.

Although there are multitenant concerns beyond ensuring that users only access the information they're supposed to see, this article focuses on that aspect of multitenancy. This article begins with an overview of single-tenant RAG architectures. It discusses the challenges that you might encounter in multitenancy with RAG and some common approaches to take. It also outines secure multitenancy considerations and recommendations.

> [!NOTE]
> This article discusses some Azure OpenAI Service-specific features, such as the Azure OpenAI on your data feature. However, most of the principles that this article covers apply to most foundational AI models, regardless of their host platform.

## Single-tenant RAG architecture with an orchestrator

:::image type="content" source="./_images/multitenant-rag-single-tenant-architecture.svg" lightbox="./_images/multitenant-rag-single-tenant-architecture.svg" alt-text="Diagram that shows a RAG architecture that uses a single-tenant database instance." border="false":::

### Workflow

In this single-tenant RAG architecture, an orchestrator fetches relevant proprietary tenant data from the data stores and provides it as grounding data to the foundational model. The following steps describe a high-level workflow.

1. A user issues a request to the intelligent web application.
2. An identity provider authenticates the requestor.
3. The intelligent application calls the orchestrator API with the user's query and the authorization token for the user.
4. The orchestration logic extracts the user's query from the request and calls the appropriate data store to fetch relevant grounding data for the query. The grounding data is added to the prompt that is sent to the foundational model, like a model that's exposed in Azure OpenAI, in the next step.
5. The orchestration logic connects to the foundational model's inferencing API and sends the prompt that includes the retrieved grounding data. The results are returned to the intelligent application.

For more information, see [Design and developing a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide).

## Single-tenant RAG architecture with direct data access

This variant of the single-tenant RAG architecture uses the [on your data feature](/azure/ai-services/openai/concepts/use-your-data) of Azure OpenAI to integrate directly with data stores like Azure AI Search. In this architecture, you either don't have your own orchestrator, or your orchestrator has fewer responsibilities. The Azure OpenAI API calls into the data store to fetch the grounding data and passes that data to the language model. This method gives you less control over what grounding data to fetch and the relevancy of that data.

> [!NOTE]
> Azure OpenAI, managed by Microsoft, integrates with the data store. The model itself doesn't integrate with the data store. The model receives grounding data in the exact same way as it does when an orchestrator fetches the data.

:::image type="content" source="./_images/multitenant-rag-single-tenant-direct-architecture.svg" lightbox="./_images/multitenant-rag-single-tenant-direct-architecture.svg" alt-text="Diagram that shows a RAG architecture that uses Azure OpenAI direct access to a single-tenant database instance." border="false":::

### Workflow

In this RAG architecture, the service that provides the foundational model fetches the appropriate proprietary tenant data from the data stores and uses that data as grounding data to the foundational model. The following steps describe a high-level workflow. The italicized steps are identical to the preceding single-tenant RAG architecture with an orchestrator workflow.

1. *A user issues a request to the intelligent web application.*
1. *An identity provider authenticates the requestor.*
1. The intelligent application calls Azure OpenAI with the user's query.
1. Azure OpenAI connects to supported data stores, such as AI Search and Azure Blob Storage, to fetch the grounding data. The grounding data is used as part of the context when Azure OpenAI calls the OpenAI language model. The results are returned to the intelligent application.

If you want to use this architecture in a multitenant solution, the service, such as Azure OpenAI, that is directly accessing the grounding data must support the multitenant logic required by your solution.

## Multitenancy in RAG architecture

In multitenant solutions, tenant data might exist in a tenant-specific store or coexist with other tenants in a multitenant store. Data might also be in a store that is shared across tenants. Only data that the user is authorized to see should be used as grounding data. The user should see only common or all-tenant data or data from their tenant that is filtered to ensure that they see only the data that they're authorized to see.

:::image type="content" source="./_images/multitenant-rag-multitenant-architecture.svg" lightbox="./_images/multitenant-rag-multitenant-architecture.svg" alt-text="Diagram that shows a RAG architecture that uses a shared database, a multitenant database, and two single-tenant databases." border="false":::

### Workflow

The following steps describe a high-level workflow. The italicized steps are identical to the [Single-tenant RAG architecture with an orchestrator](#single-tenant-rag-architecture-with-orchestrator) workflow.

1. *A user issues a request to the intelligent web application.*
1. *An identity provider authenticates the requestor.*
1. *The intelligent application calls the orchestrator API with the user's query and the authorization token for the user.*
1. The orchestration logic extracts the user's query from the request and calls the appropriate data stores to fetch tenant-authorized, relevant grounding data for the query. The grounding data is added to the prompt that is sent to Azure OpenAI in the next step. Some or all of the following steps are involved:
    1. The orchestration logic fetches grounding data from the appropriate tenant-specific data store instance and potentially applies security filtering rules to return only the data that the user is authorized to access.
    2. The orchestration logic fetches the appropriate tenant's grounding data from the multitenant data store and potentially applies security filtering rules to return only the data that the user is authorized to access.
    3. The orchestration logic fetches data from a data store that is shared across tenants.
1. *The orchestration logic connects to the foundational model's inferencing API and sends the prompt that includes the retrieved grounding data. The results are returned to the intelligent application.*

## Design considerations for multitenant data in RAG

Consider the following options as you design your secure, multitenant RAG inferencing solution.

### Choose a store isolation model

There are two main [architectural approaches for storage and data in multitenant scenarios](/azure/architecture/guide/multitenant/approaches/storage-data): store-per-tenant and multitenant stores. These approaches are in addition to stores that contain data that is shared across tenants. Your multitenant solution can use a combination of these approaches.

#### Store-per-tenant stores

In store-per-tenant stores, as the name suggests, each tenant has its own store. The advantages of this approach include both data and performance isolation. Each tenant's data is encapsulated in its own store. In most data services, the isolated stores aren't susceptible to the noisy neighbor problem of other tenants. This approach also simplifies cost allocation because the entire cost of a store deployment can be attributed to a single tenant.

The challenges of this approach potentially include higher management and operation overhead and higher cost. You shouldn't use this approach if there is a large number of small tenants, such as in business-to-consumer scenarios. This approach might also reach or exceed [service limitations](/azure/search/search-limits-quotas-capacity).

In the context of this AI scenario, a store-per-tenant store means that the necessary grounding data to bring relevancy into the context comes from an existing or new data store that only contains grounding data for the tenant. In this topology, the database instance is the discriminator used for each tenant.

#### Multitenant stores

In multitenant stores, multiple tenants' data coexists in the same store. The advantages of this approach include the potential for cost optimization, the ability to handle a higher number of tenants than the store-per-tenant model, and lower management overhead because of the lower number of store instances.

The challenges of using shared stores include the need to ensure data isolation and management, the potential for the [noisy neighbor antipattern](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor), and more difficult cost allocation to tenants. Ensuring data isolation is the most important concern when you use this approach. You're responsible for implementing the security approach to ensure that tenants can only access their data. Data management can also be challenging if tenants have different data lifecycles that require operations such as building indexes on different schedules.

Some platforms have features that you can use when you implement tenant data isolation in shared stores. For example, Azure Cosmos DB has native support for partitioning and sharding, and it's common to use a tenant identifier as a partition key to provide some isolation between tenants. Azure SQL and Azure Database for PostgreSQL - Flexible Server support row-level security. However, these features aren't typically used in multitenant solutions because you have to design your solution around these features if you plan to use them in your multitenant store.

In the context of this AI scenario, grounding data for all tenants commingle in the same data store. Therefore, your query to that data store must contain a tenant discriminator to ensure that responses are restricted to bring back only relevant data within the context of the tenant.

#### Shared stores

Multitenant solutions often share data across tenants. In an example multitenant solution for the healthcare domain, a database might store general medical information or information that isn't tenant specific.

In the context of this AI scenario, the grounding data store is generally accessible and doesn't need filtering based on specific tenants because the data is relevant and authorized for all tenants in the system.

### Identity

[Identity is a key aspect of multitenant solutions](/azure/architecture/guide/multitenant/considerations/identity), including secure, multitenant RAG solutions. The intelligent application should integrate with an identity provider to authenticate the identity of the user. The multitenant RAG solution needs an [identity directory](/azure/architecture/guide/multitenant/considerations/identity#identity-directory) that stores either authoritative identities or references to identities. This identity needs to flow through the request chain and allow downstream services, such as the orchestrator or even the data store itself, to identify the user.

You also need a way to [map a user to a tenant](/azure/architecture/guide/multitenant/considerations/identity#grant-users-access-to-tenant-data) so that you can grant access to that tenant data.

### Define your tenant and authorization requirements

When you build a multitenant RAG solution, you must [define what a tenant is for your solution](/azure/architecture/guide/multitenant/considerations/tenancy-models#define-a-tenant). The two common models to choose from are business-to-business and business-to-consumer models. Choosing a model helps you determine what other factors you should consider as you build your solution. Understanding the number of tenants is critical for choosing the data store model. A large number of tenants might require a model that has multiple tenants for each store. A smaller number of tenants might allow for a store-per-tenant model. The amount of data for each tenant is also important. Tenants that have large amounts of data might prevent you from using multitenant stores because of size limitations on the data store.

If you're expanding an existing workload to support this AI scenario, you might have already made this choice. Generally speaking, you can use your existing data storage topology for the grounding data if that data store can provide sufficient relevancy and meet any other nonfunctional requirements. However, if you're introducing new components, such as a dedicated vector search store as a dedicated grounding store, then you still need to make this decision. Consider factors such as your current deployment stamp strategy, your application control plane impact, and any per-tenant data lifecycle differences, such as pay-for-performance situations.

After you define what a tenant is for your solution, you need to define your authorization requirements for data. Although tenants only access data from their tenant, your authorization requirements might be more granular. For example, in a healthcare solution, you might have rules such as:

- A patient can only access their own patient data.
- A healthcare professional can access their patients' data.
- A finance user can access only finance-related data.
- A clinical auditor can see all patients' data.
- All users can access base medical knowledge in a shared data store.

In a document-based RAG application, you might want to restrict users' access to documents based on a tagging scheme or sensitivity levels set on documents.

After you have a definition of what a tenant is and have a clear understanding of the authorization rules, use that information as requirements for your data store solution.

### Filtering

Filtering, also known as security trimming, refers to exposing only the data to users that they're authorized to see. In a multitenant RAG scenario, a user may be mapped to a tenant-specific store. That doesn't mean that the user should be able to access all the data in that store. In [Define your tenant and authorization requirements](#define-your-tenant-and-authorization-requirements), we discussed the importance of defining the authorization requirements for your data. These authorization rules should be used as the basis for filtering.

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
- Store access logs of grounding information for audit purposes

Code that needs to access tenant data shouldn't be able to query the backend stores directly. All requests for data should flow through this API layer. This API layer provides a single point of governance or security layer over top of your tenant data. This approach keeps the tenant and user data access authorization logic from bleeding into different areas of the application. This logic is encapsulated in the API layer. This encapsulation makes the solution easier to validate and test.

## Summary

When designing a multitenant RAG inferencing solution, you must take into account how to architect the grounding data solution for your tenants. Get an understanding of the number of tenants and the amount of per-tenant data you store. This information helps you design your data tenancy solution. We recommend that you implement an API layer that encapsulates the data access logic, including both multitenant and filtering logic.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer
- [Daniel Scott-Raynsford](https://linkedin.com/in/dscottraynsford) | Sr. Partner Solution Architect, Data & AI

## Next steps

> [!div class="nextstepaction"]
> [Design and evaluate RAG solutions](./rag/rag-solution-design-and-evaluation-guide.md)

## Related resources

- [SaaS and multitenant solution architecture](../../guide/saas-multitenant-solution-architecture/index.md)
- [Basic OpenAI end-to-end chat reference architecture](../architecture/basic-openai-e2e-chat.yml)
- [Baseline OpenAI end-to-end chat reference architecture](../architecture/baseline-openai-e2e-chat.yml)
- [Access Azure OpenAI and other language models through a gateway](./azure-openai-gateway-guide.yml)
