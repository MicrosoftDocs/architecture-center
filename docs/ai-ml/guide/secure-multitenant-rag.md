---
title: Design a Secure Multitenant RAG Inferencing Solution
description: Learn about the considerations and recommendations for improved security that you should consider when you design a multitenant RAG inferencing solution.
author: claytonsiemens77
ms.author: pnp
ms.date: 08/19/2026
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot  
ms.subservice: architecture-guide
ai-usage: ai-assisted
ms.custom:
  - arb-saas
  - arb-aiml
---

# Design a secure multitenant RAG inferencing solution

Retrieval-Augmented Generation (RAG) is a pattern for building applications that use foundation models to reason over proprietary information or other data that isn't publicly available on the internet. Generally, a client application calls an orchestration layer that fetches relevant information from a data store, such as a vector database. The orchestration layer passes that data as part of the context as grounding data to the foundation model.

A multitenant solution is used by multiple customers. Each customer, or tenant, consists of multiple users from the same organization, company, or group. In multitenant scenarios, you need to make sure that tenants, or individuals within tenants, are only able to incorporate grounding data that they're authorized to access.

There are multitenant concerns beyond ensuring that users only access the information they're authorized to access. However, this article focuses on that aspect of multitenancy. This article begins with an overview of single-tenant RAG architectures. It discusses the challenges that you might encounter in multitenancy with RAG and some common approaches to take. It also outlines multitenancy considerations and recommendations for improved security.

> [!NOTE]
> This article uses Microsoft Foundry Models as an example. However, you can apply most of the principles described in this article to foundation models on any platform.

## Single-tenant RAG architecture with an orchestrator

:::image type="complex" source="./_images/multitenant-rag-single-tenant-architecture.svg" lightbox="./_images/multitenant-rag-single-tenant-architecture.svg" alt-text="Diagram that shows a RAG architecture that uses a single-tenant database instance." border="false":::
   In the diagram, a user connects to an intelligent application. The intelligent application connects to an identity provider. The intelligent application then connects to an orchestrator. The orchestrator connects to databases and vector stores. The orchestrator then connects to the foundation model.
:::image-end:::

### Workflow

In this single-tenant RAG architecture, an orchestrator fetches relevant proprietary tenant data from the data stores and provides it as grounding data to the foundation model. The following steps describe a high-level workflow.

1. A user issues a request to the intelligent web application.
2. An identity provider authenticates the requestor.
3. The intelligent application calls the orchestrator API with the user's query and the authorization token for the user.
4. The orchestration logic extracts the user's query from the request and calls the appropriate data store to fetch relevant grounding data for the query. The grounding data is added to the prompt that's sent to a deployed model in the next step.
5. The orchestration logic calls the deployed model's inference API and sends the prompt that includes the retrieved grounding data. The results are returned to the intelligent application.

For more information, see [Design and develop a RAG solution](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide).

## Single-tenant RAG architecture with Responses API file search

This variant of the single-tenant RAG architecture uses the [Responses API file search tool](/rest/api/microsoft-foundry/azureopenai/responses) with a deployed Foundry Model to retrieve grounding data from vector stores like Azure AI Search.

In this architecture, you either don't have your own orchestrator, or your orchestrator has fewer responsibilities. The Responses API file search tool retrieves relevant content from configured vector stores and adds it to the model context. This method gives you less control over indexing, retrieval, tenant routing, and authorization enforcement than application-controlled retrieval, such as a direct Azure AI Search query.

> [!NOTE]
> The Responses API file search tool integrates with vector stores, but the deployed model itself doesn't. The model receives grounding data in the same way as it does when an orchestrator retrieves the data.

:::image type="complex" source="./_images/multitenant-rag-single-tenant-direct-architecture.svg" lightbox="./_images/multitenant-rag-single-tenant-direct-architecture.svg" alt-text="Diagram that shows a RAG architecture that uses the Foundry Models Responses API file search tool to access a single-tenant vector store." border="false":::
   In the diagram, a user connects to an intelligent application. The intelligent application connects to an identity provider. The intelligent application then connects to the Responses API in Foundry Models. The Responses API searches a vector store such as Azure AI Search that contains data for one tenant and passes the retrieved data as part of the context to the deployed model.
:::image-end:::

### Workflow

In this RAG architecture, the Responses API file search tool retrieves relevant tenant data from configured vector stores and adds it to the model context. The following steps describe a high-level workflow. The italicized steps are identical to the preceding single-tenant RAG architecture with an orchestrator workflow.

1. *A user issues a request to the intelligent web application.*
1. *An identity provider authenticates the requestor.*
1. The intelligent application derives the tenant context and authorization rules from the authenticated request. It configures the Responses API file search tool with authorized vector stores and file-attribute filters.
1. The intelligent application calls the Responses API with the user's query. The file search tool retrieves authorized grounding data, adds it to the model context, and returns the model response to the intelligent application.

## Multitenancy in RAG architecture

In multitenant solutions, tenant data might exist in a tenant-specific store or coexist with other tenants in a multitenant store. Data might also be in a store that's shared across tenants. Only data that the user is authorized to access should be used as grounding data. The user should see only common or all-tenant data or data from their tenant that's filtered to help ensure that they see only the data that they're authorized to access.

:::image type="complex" source="./_images/multitenant-rag-multitenant-architecture.svg" lightbox="./_images/multitenant-rag-multitenant-architecture.svg" alt-text="Diagram that shows a RAG architecture that uses a shared database, a multitenant database, and two single-tenant databases." border="false":::
   In the diagram, a user connects to an intelligent application. The intelligent application connects to an identity provider. The intelligent application then connects to an orchestrator. The orchestrator connects to a single-tenant database, a multitenant database, or a shared database. The orchestrator then connects to the foundation model.
:::image-end:::

### Workflow

The following steps describe a high-level workflow. The italicized steps are identical to the [single-tenant RAG architecture with an orchestrator](#single-tenant-rag-architecture-with-an-orchestrator) workflow.

1. *A user issues a request to the intelligent web application.*
1. *An identity provider authenticates the requestor.*
1. *The intelligent application calls the orchestrator API with the user's query and the authorization token for the user.*
1. The orchestration logic extracts the user's query from the request and calls the appropriate data stores to fetch tenant-authorized, relevant grounding data for the query. The grounding data is added to the prompt that's sent to a deployed Foundry Model in the next step. Some or all of the following steps are included:
    1. The orchestration logic fetches grounding data from the appropriate tenant-specific data store instance and potentially applies security filtering rules to return only the data that the user is authorized to access.
    2. The orchestration logic fetches the appropriate tenant's grounding data from the multitenant data store and potentially applies security filtering rules to return only the data that the user is authorized to access.
    3. The orchestration logic fetches data from a data store that's shared across tenants.
1. *The orchestration logic connects to the foundation model's inferencing API and sends the prompt that includes the retrieved grounding data. The results are returned to the intelligent application.*

## Design considerations for multitenant data in RAG

Consider the following options when you design your multitenant RAG inferencing solution.

### Choose a store isolation model

The two main [architectural approaches for storage and data in multitenant scenarios](/azure/architecture/guide/multitenant/approaches/storage-data) are store-per-tenant and multitenant stores. These approaches are in addition to stores that contain data shared across tenants. Your multitenant solution can use a combination of these approaches.

#### Store-per-tenant stores

In store-per-tenant stores, each tenant has its own store. The advantages of this approach include both data and performance isolation. Each tenant's data is encapsulated in its own store. In most data services, the isolated stores aren't susceptible to the noisy neighbor problem of other tenants. This approach also simplifies cost allocation because the entire cost of a store deployment can be attributed to a single tenant.

This approach might present challenges such as increased management and operational overhead and higher costs. You shouldn't use this approach if you have a large number of small tenants, like in business-to-consumer scenarios. This approach might also reach or exceed [service limits](/azure/search/search-limits-quotas-capacity).

In the context of this AI scenario, a store-per-tenant store means that the necessary grounding data to bring relevancy into the context comes from an existing or new data store that only contains grounding data for the tenant. In this topology, the database instance is the discriminator that's used for each tenant.

#### Multitenant stores

In multitenant stores, multiple tenants' data coexists in the same store. The advantages of this approach include the potential for cost optimization, the ability to handle a higher number of tenants than the store-per-tenant model, and lower management overhead because of the lower number of store instances.

The challenges of using shared stores include the need for data isolation and management, the potential for the [noisy neighbor antipattern](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor), and more complex cost allocation to tenants. Data isolation is the most important concern when you use this approach. You need to implement secure approaches to help ensure that tenants can only access their data. Data management can also be challenging if tenants have different data lifecycles that require operations such as building indexes on different schedules.

Some platforms have features that you can use when you implement tenant data isolation in shared stores. For example, Azure Cosmos DB has native support for data partitioning and sharding. It's typical to use a tenant identifier as a partition key to provide some isolation between tenants. Azure SQL and Azure Database for PostgreSQL support row-level security. However, these features aren't typically used in multitenant solutions because you have to design your solution around these features if you plan to use them in your multitenant store.

In the context of this AI scenario, grounding data for all tenants commingle in the same data store. Therefore, every retrieval request must include a tenant discriminator and any user-level authorization filters. Apply these filters before you pass grounding data to the model.

#### Shared stores

Multitenant solutions often share data across tenants. In an example multitenant solution for the healthcare domain, a database might store general medical information or information that isn't specific to the tenant.

In the context of this AI scenario, the grounding data store is generally accessible and doesn't need filtering based on specific tenants because the data is relevant and authorized for all tenants in the system.

### Identity

[Identity is a key aspect of multitenant solutions](/azure/architecture/guide/multitenant/considerations/identity), including multitenant RAG solutions. The intelligent application should integrate with an identity provider to authenticate the identity of the user. The multitenant RAG solution needs an [identity directory](/azure/architecture/guide/multitenant/considerations/identity#identity-directory) that stores authoritative identities or references to identities. This identity needs to flow through the request chain and allow downstream services, such as the orchestrator or the data store itself, to identify the user.

You also need a way to [map a user to a tenant](/azure/architecture/guide/multitenant/considerations/identity#grant-users-access-to-tenant-data) so that you can grant access to that tenant data.

### Define your tenant and authorization requirements

When you build a multitenant RAG solution, you must [define what a tenant is for your solution](/azure/architecture/guide/multitenant/considerations/tenancy-models#define-a-tenant). The two common models to choose from are business-to-business and business-to-consumer models. The model that you choose helps you determine what other factors you should consider when you build your solution. Understanding the number of tenants is critical for choosing the data store model. A large number of tenants might require a model that has multiple tenants for each store. A smaller number of tenants might allow for a store-per-tenant model. The amount of data for each tenant is also important. Tenants that have large amounts of data might prevent you from using multitenant stores because of size limitations on the data store.

If you intend to expand an existing workload to support this AI scenario, you might have made this decision already. Generally speaking, you can use your existing data storage topology for the grounding data if that data store can provide sufficient relevancy and meet any other nonfunctional requirements. However, if you plan to introduce new components, such as a dedicated vector search store as a dedicated grounding store, then you still need to make this decision. Consider factors such as your current deployment stamp strategy, your application control plane impact, and any per-tenant data lifecycle differences, such as pay-for-performance situations.

After you define what a tenant is for your solution, you need to define your authorization requirements for data. Tenants only access data from their tenant, but your authorization requirements might be more granular. For example, in a healthcare solution, you might have rules such as:

- A patient can only access their own patient data.
- A healthcare professional can access their patients' data.
- A finance user can access only finance-related data.
- A clinical auditor can see all patients' data.
- All users can access basic medical knowledge in a shared data store.

In a document-based RAG application, you might want to restrict users' access to documents based on a tagging scheme or sensitivity levels assigned to the documents.

After you have a definition of what a tenant is and have a clear understanding of the authorization rules, use that information as requirements for your data store solution.

### Data filtering

Restricting access to only the data that users are authorized to access is known as *filtering* or *security trimming*. In a multitenant RAG scenario, a user might be mapped to a tenant-specific store. That doesn't mean that the user should be able to access all the data in that store. [Define your tenant and authorization requirements](#define-your-tenant-and-authorization-requirements) discusses the importance of defining authorization requirements for your data. You should use these authorization rules as the basis for filtering.

You can use data platform capabilities like row-level security, Azure AI Search security filters, or custom logic, data, or metadata to implement filtering. Apply filtering to every retrieval request, whether the application retrieves grounding data before it calls a model or an agent retrieves data during its execution loop. These platform features require a system design that preserves the tenant and user authorization context.

### Encapsulate multitenant data logic

We recommend that you have an API in front of the storage mechanism that you use. The API acts like a gatekeeper that helps ensure that users only get access to information they're authorized to access.

:::image type="complex" source="./_images/multitenant-rag-multitenant-api-architecture.svg" lightbox="./_images/multitenant-rag-multitenant-api-architecture.svg" alt-text="Diagram that shows a RAG architecture with a shared database, a multitenant database, and two single-tenant databases. An API layer is between the orchestrator and the databases." border="false":::
   In the diagram, a user connects to an intelligent application. The intelligent application connects to an identity provider. The intelligent application then connects to an orchestrator. The orchestrator connects to an API layer. The API layer connects to databases and vector stores. The orchestrator then connects to the foundation model.
:::image-end:::

Users' access to data can be limited by:

- The user's tenant.
- Platform features.
- Custom security filtering or trimming rules.

The API layer should:

- Route the query to a tenant-specific store in a store-per-tenant model.
- Select only data from the user's tenant in multitenant stores.
- Use the appropriate identity for a user to support platform-enabled authorization logic.
- Enforce custom security trimming logic.
- Store access logs of grounding information for audit purposes.

Code that needs to access tenant data shouldn't be able to query the back-end stores directly. All requests for data should flow through the API layer. This API layer provides a single point of governance or security on top of your tenant data. This approach prevents the tenant and user data access authorization logic from reaching other areas of the application. This logic is encapsulated in the API layer. This encapsulation makes the solution easier to validate and test.

## Summary

When you design a multitenant RAG inferencing solution, you must consider how to architect the grounding data solution for your tenants. Understand the number of tenants and the amount of per-tenant data that you store. This information helps you design your data tenancy solution. We recommend that you implement an API layer that encapsulates the data access logic, including multitenant logic and filtering logic.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Sr. Partner Solution Architect, Data & AI

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

> [!div class="nextstepaction"]
> [Design and develop a RAG solution](./rag/rag-solution-design-and-evaluation-guide.md)

## Related resources

- [SaaS and multitenant solution architecture](../../guide/saas-multitenant-solution-architecture/index.md)
- [Baseline Microsoft Foundry chat reference architecture](../architecture/baseline-microsoft-foundry-chat.yml)
- [Access Foundry Models and other language models through a gateway](./azure-openai-gateway-guide.md)
