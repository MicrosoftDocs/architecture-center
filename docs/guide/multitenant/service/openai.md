---
title: Multitenancy and Azure OpenAI
description: Learn how to deploy Azure OpenAI models and work with the features associated with each model when you have a multitenant system.
author: PlagueHO
ms.author: dascottr
ms.date: 10/28/2025
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom:
  - arb-saas
  - arb-aiml
---

# Multitenancy and Azure OpenAI

[Azure OpenAI](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure) provides access to OpenAI language models. This article describes key features of Azure OpenAI that support multitenant solutions and helps you plan your deployment approach.

## Isolation models

When you have a multitenant system that uses Azure OpenAI, determine the level of isolation that your tenants require. Design your isolation model based on the following factors:

- The number of tenants that you plan to have
- Whether your tenants have compliance requirements that require network or infrastructure isolation
- Whether your tenants require models that you fine-tune by using their own data
- Whether your tenants require different model versions or model life cycles

The following table summarizes Azure OpenAI deployment approaches in a multitenant system.

| Considerations | Dedicated Azure OpenAI instance | Shared Azure OpenAI instance, dedicated model deployment for each tenant | Shared Azure OpenAI instance, shared model deployment | Tenant-provided Azure OpenAI instance |
|-|-|-|-|-|
| Data isolation | High | Medium | Low | High |
| Performance isolation | High | High | Low to medium, depending on the token-per-minute (TPM) usage for each tenant | High |
| Deployment complexity | Low to medium, depending on the number of tenants | Medium, you manage deployment names and quotas | Low | Not applicable, customer-managed |
| Operational complexity | Low | Medium | High | Low for the provider, medium to high for the tenant |
| Example scenario | Single tenant deployments that require network isolation from other tenants | Tenants that have specific model life cycle or fine-tuning requirements | Large multitenant solutions that have a shared application tier | Tenants that have specific compliance or fine-tuning requirements |

### Dedicated Azure OpenAI instance

If you're a service provider, consider deploying a separate Azure OpenAI instance for each tenant in your Azure subscription. This approach provides data isolation between tenants. But as your tenant count grows, you must deploy and manage more Azure OpenAI resources.

Use this approach if you have separate application deployments for each tenant or if you need to avoid limitations, like quota and rate limits. For more information, see [Azure OpenAI quotas and limits](/azure/ai-foundry/openai/quotas-limits).

The following diagram shows an Azure OpenAI instance for each tenant in the provider's subscription.

:::image type="complex" source="./media/openai/openai-providers-subscription.svg" alt-text="Diagram that shows an Azure OpenAI instance for each tenant in the provider's subscription." border="false" lightbox="./media/openai/openai-providers-subscription.svg":::
The diagram shows a provider subscription that contains an app and three separate Azure OpenAI instances. Three tenants outside the subscription point to the app and their own Azure OpenAI instance.
:::image-end:::

### Shared Azure OpenAI instance

You can share an instance of Azure OpenAI among multiple tenants. You deploy and manage the Azure OpenAI resource in your (the service provider's) Azure subscription. This solution is the easiest to implement, but it provides the least data isolation and performance isolation.

A shared Azure OpenAI resource doesn't provide security segmentation for each model deployment. A tenant can potentially use a model that they aren't authorized to use. Don't share an Azure OpenAI instance when you use fine-tuned models. You might expose sensitive information and allow unauthorized access to tenant-specific data or resources.

A shared Azure OpenAI instance can also lead to a [noisy neighbor](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) problem, which causes higher latency for some tenants. You must make your application code multitenancy-aware. For example, to charge customers for their consumption of a shared instance, implement logic to track token usage for each tenant in your application.

You can also deploy multiple shared Azure OpenAI instances. For example, if you follow the [Deployment Stamps pattern](../approaches/overview.md#deployment-stamps-pattern), deploy a shared Azure OpenAI instance in each stamp. If you deploy a solution in multiple regions, deploy Azure OpenAI in each region to get the following benefits:

- Avoid cross-region traffic latency
- Support data residency requirements
- Allow Azure services that require same-region deployments to connect to Azure OpenAI

When you share an Azure OpenAI instance, understand its [limits](/azure/ai-foundry/openai/quotas-limits#quotas-and-limits-reference) and [manage your quota](/azure/ai-foundry/openai/how-to/quota) carefully.

The following diagram shows the shared Azure OpenAI model.

:::image type="complex" source="./media/openai/openai-shared.svg" alt-text="Diagram that shows the shared Azure OpenAI model." border="false" lightbox="./media/openai/openai-shared.svg":::
The diagram shows a provider subscription that contains an app and a shared Azure OpenAI instance. Three tenants outside the subscription point to the app and the shared Azure OpenAI instance.
:::image-end:::

Within a shared Azure OpenAI instance, you can share model deployments among tenants or create dedicated deployments for specific tenants.

#### Shared model deployment among tenants

A shared model deployment reduces your operational burden. You manage fewer deployments and track fewer model versions. Use a shared model deployment when possible, and create dedicated deployments only when tenants need specific capabilities.

#### Dedicated model deployment for each tenant

If tenants have requirements that you can't meet with a shared deployment, create a dedicated model deployment. This model provides the following capabilities:

- **Quota and cost management:** You can allocate TPM quotas per tenant and track token usage for precise cost allocation. If you use [provisioned throughput units (PTUs)](/azure/ai-foundry/openai/concepts/provisioned-throughput), you can assign them to specific customers and use different billing models for other customers.

- **Content filtering policies:** Some tenants might need a custom content filtering policy, like a block list of disallowed words. Configure the content filtering policy at the model deployment level.

- **Model types and versions:** Different tenants might require different models, model versions, or independent model life cycle management.

- **Tenant-specific fine-tuning:** Each fine-tuned model requires its own deployment. But fine-tuning isn't required for most use cases. You can usually ground your model by using the [Azure OpenAI on your data feature](#azure-openai-on-your-data-feature) or another retrieval-augmented generation (RAG) approach.

- **Data residency:** This approach supports distinct data residency requirements. For example, you might provide a regional model deployment for a tenant that has strict data residency needs and use a global model deployment for other tenants.

Each model deployment has a unique URL, but all Azure OpenAI deployments share the same underlying model infrastructure.

Azure OpenAI doesn't enforce access control for each model deployment. Your application must enforce the tenant-to-deployment access rules.

### Tenant-provided Azure OpenAI resource

Your tenants can create Azure OpenAI instances in their own Azure subscriptions and grant your application access. Consider this approach for the following scenarios:

- Tenants have specific quotas and permissions from Microsoft, including access to specific models, defined content filtering policies, or provisioned throughput usage.

- Tenants have a fine-tuned model that they need to use from your solution.

- Tenants require a component in their environment to process and send data through their customer-managed Azure OpenAI instance for processing.

To access an Azure OpenAI instance in your tenant's subscription, the tenant must grant your application access. Your application must authenticate through its Microsoft Entra instance. One approach is to publish a [multitenant Microsoft Entra application](/entra/identity-platform/single-and-multi-tenant-apps). The following workflow outlines this approach:

1. The tenant registers the multitenant Microsoft Entra application in its own Microsoft Entra tenant.

1. The tenant grants the multitenant Microsoft Entra application the appropriate level of access to the Azure OpenAI resource. For example, the tenant might assign the application to the *Azure OpenAI User* role by using role-based access control (RBAC).

1. The tenant provides the resource ID of the Azure OpenAI resource that it creates.

1. Your application code can use a service principal that's associated with the multitenant Microsoft Entra application in your own Microsoft Entra instance to access the tenant's Azure OpenAI instance.

Alternatively, each tenant can create a service principal for your service to use and give you its credentials. This approach requires you to securely store and manage credentials for each tenant, which is a potential security liability.

If your tenants configure network access controls on their Azure OpenAI instance, ensure that you can access them.

The following diagram shows an Azure OpenAI instance for each tenant in the tenant subscription.

:::image type="complex" source="./media/openai/openai-tenants-subscription.svg" alt-text="Diagram that shows an Azure OpenAI instance for each tenant in the tenant subscription." border="false" lightbox="./media/openai/openai-tenants-subscription.svg":::
The diagram shows three tenant subscriptions. Each subscription contains customer users and an Azure OpenAI instance. The customer users point to an app that's shared among all tenants. The app points to each Azure OpenAI instance. The app resides in the provider subscription.
:::image-end:::

## Features of Azure OpenAI that support multitenancy

Azure OpenAI provides the following features that support multitenancy.

### Responses API

The [Responses API](/azure/ai-foundry/openai/how-to/responses) is a stateful API that unifies conversation management, tool invocation, file search, background task processing, and structured outputs in a single interface.

The Responses API makes tenant data isolation between tenants challenging because you can't attach tenant identifiers to all tools and capabilities.

If you use the Responses API in a multitenant solution, consider tenant isolation for all stored data and operations that you control. The API stores conversation history by using response IDs that link requests to previous context. Store response IDs with tenant-scoped keys in your application so that requests can only reference response IDs associated with the same tenant.

The Responses API supports function calling and built-in tools. For function calling, your application code handles the function invocation, so ensure that your function calls are multitenant-aware. Include the tenant ID in calls to downstream APIs or functions. For built-in tools like Code Interpreter and remote Model Context Protocol (MCP) server calls, the model infrastructure runs these operations. You can't reliably inject tenant context into built-in tool invocations, so use dedicated containers or separate tool configurations for each tenant.

When you use file search or RAG capabilities, scope file stores and vector indexes to the appropriate tenant. For shared indexes, apply tenant filters to all queries. For per-tenant indexes, map each request to the correct index based on the tenant identifier. For more information, see [Design a secure multitenant RAG inferencing solution](../../../ai-ml/guide/secure-multitenant-rag.md).

The Responses API supports a background mode for long-running operations. Store task identifiers with the tenant context and validate the tenant when you poll for results. Ensure that task queues and result storage prevent tenants from accessing each other's background tasks or outputs.

### Assistants API

The [Assistants API](/azure/ai-foundry/openai/concepts/assistants) extends Azure OpenAI with capabilities to create AI assistants. The API can call tools and other APIs, search files to ground model responses, manage persistent conversation threads, and generate and run code in a sandboxed environment. To support these capabilities, the Assistants API stores data.

In a multitenant solution, you can dedicate assistants to individual tenants or share assistants across tenants. Consider tenant isolation in all stored data, especially for shared assistants. For example, store conversational threads separately for each tenant.

The Assistants API supports function invocation, which sends your application instructions about which functions to call and which arguments to include. Ensure that your function calls are multitenant-aware by including the tenant ID in calls to downstream systems. Verify the tenant ID in your application code. Don't rely on the language model to propagate tenant information.

### Azure OpenAI on your data feature

The [Azure OpenAI on your data feature](/azure/ai-foundry/openai/concepts/use-your-data) lets the large language model directly query your knowledge sources, like indexes and databases, to ground its responses. When you make a request, you can specify the data sources to query.

In a multitenant solution, ensure that your data sources are multitenancy-aware and that you can specify tenant filters on your requests. Propagate the tenant ID to the data source appropriately. For example, if you query Azure AI Search that stores data for multiple tenants in a single index, specify a filter to return only the current tenant's ID. If you create an index for each tenant, specify the correct index for the current tenant.

### Batch deployments

[Batch deployments](/azure/ai-foundry/openai/how-to/batch) process grouped requests asynchronously by using a separate [batch quota](/azure/ai-foundry/openai/quotas-limits#batch-quota). Batch requests have a 24-hour target turnaround and cost less than standard deployments. Unlike standard deployments, batch quotas limit enqueued tokens rather than TPM.

Use batch deployments when you don't need immediate responses and want to process large volumes of requests without disrupting real-time workloads. For example, a sentiment analysis system can use a batch deployment to avoid throttling the standard deployment quota that it needs to conduct real-time interactions in other applications. This approach also reduces processing costs.

In a multitenant solution, you can share batch deployments among tenants or create separate deployments for each tenant:

- **Separate batch deployments for each tenant:** Assign token quotas to each tenant-specific batch deployment to prevent any single tenant from monopolizing resources. This approach also lets you track token usage per tenant for cost allocation.

- **Shared batch deployment:** A shared batch deployment can process requests from multiple tenants in combined or separate batch jobs. If you combine requests into a single batch job, ensure that you can map responses back to the correct tenant. You manage batch jobs at the job level, so separate batch jobs by tenant. Then you can cancel or delete jobs independently. You can't cancel or delete individual requests within a batch.

Carefully manage batch deployments to balance cost efficiency and resource allocation while maintaining tenant isolation and operational flexibility.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Sofia Ferreira](https://www.linkedin.com/in/asofiamferreira) | Software Engineer, ISV & DN CoE

Other contributors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce) | Customer Engineer, ISV & DN CoE
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, ISV & DN CoE
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Solution Architect
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, ISV & DN CoE

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Architectural approaches for the deployment and configuration of multitenant solutions](../approaches/deployment-configuration.md)
- [Architectural approaches for cost management and allocation in a multitenant solution](../../multitenant/approaches/cost-management-allocation.md)
- [Multitenancy checklist on Azure](../../multitenant/checklist.md)
