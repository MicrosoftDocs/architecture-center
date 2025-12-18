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

# Multitenancy and Azure OpenAI in Foundry Models

[Azure OpenAI in Foundry Models](/azure/ai-services/openai/overview) provides you with access to OpenAI's powerful language models. This article describes key features of Azure OpenAI that are beneficial for multitenant solutions. Review the recommended resources to help you plan your approach and use Azure OpenAI.

## Isolation models

When you have a multitenant system that uses Azure OpenAI, you need to determine the level of isolation that your tenants require. You should design your isolation model based on the following factors:

- The number of tenants that you plan to have
- Whether your tenants have compliance requirements that require network or infrastructure isolation
- Whether your tenants require models that are fine-tuned by using their own data
- Whether your tenants require different model versions or model life cycles

The following table summarizes the deployment approaches that you can take when you use Azure OpenAI in a multitenant system:

| Considerations | Dedicated Azure OpenAI service | Shared Azure OpenAI service, dedicated model deployment for each tenant | Shared Azure OpenAI service, shared model deployment | Tenant-provided Azure OpenAI service |
|-|-|-|-|-|
| Data isolation | High | Medium | Low | High |
| Performance isolation | High | High | Low to medium, depending on the token-per-minute (TPM) usage for each tenant. | High |
| Deployment complexity | Low to medium, depending on the number of tenants. | Medium, you need to manage deployment names and quotas. | Low | Not applicable, managed by customer. |
| Operational complexity | Low | Medium | High | Low for the provider. Medium to high for the tenant. |
| Example scenario | Single tenant deployments that require network isolation from other tenants. | Tenants that have specific model life cycle or fine-tuning requirements. | Large multitenant solutions that have a shared application tier. | Tenants that have specific compliance or fine-tuning requirements. |

### Dedicated Azure OpenAI service

If you're a service provider, consider deploying an Azure OpenAI instance for each tenant in your Azure subscription. This approach provides data isolation for each tenant. It requires you to deploy and manage an increasing number of Azure OpenAI resources as you increase the number of tenants.

Use this approach if you have separate application deployments for each tenant or if you need to circumvent limitations, such as the quota or request per minute. For more information, see [Azure OpenAI quotas and limits](/azure/ai-services/openai/quotas-limits#quota-and-limits-reference).

The following diagram illustrates the model for Azure OpenAI for each tenant in the provider's subscription.

:::image type="content" source="./media/openai/openai-providers-subscription.svg" alt-text="Diagram that shows the model for Azure OpenAI for each tenant in the provider's subscription." border="false" lightbox="./media/openai/openai-providers-subscription.svg":::

### Shared Azure OpenAI service

You might choose to share an instance of Azure OpenAI among multiple tenants. The Azure OpenAI resource is deployed in your (the service provider's) Azure subscription. You're responsible for managing it. This solution is the easiest to implement, but it provides the least data isolation and performance isolation.

Sharing an Azure OpenAI resource doesn't provide security segmentation for each model deployment. A tenant might be able to use a model that they aren't authorized to use. For this reason, avoid sharing an Azure OpenAI instance when you use fine-tuned models. You might expose sensitive information and allow unauthorized access to tenant-specific data or resources.

Sharing an instance of Azure OpenAI among multiple tenants can also lead to a [noisy neighbor](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) problem. It can cause higher latency for some tenants. You also need to make your application code multitenancy-aware. For example, if you want to charge your customers for the consumption cost of a shared Azure OpenAI instance, implement the logic to keep track of the total number of tokens for each tenant in your application.

You can also deploy multiple shared Azure OpenAI instances. For example, if you follow the [Deployment Stamps pattern](../approaches/overview.md#deployment-stamps-pattern), deploy a shared Azure OpenAI instance in each stamp. If you deploy a solution in multiple regions, you should deploy Azure OpenAI in each region to:

- Avoid cross-region traffic latency.
- Support data residency requirements.
- Enable the use of regional Azure OpenAI within other services that require same-region deployments.

When you have a shared Azure OpenAI instance, it's important to consider its [limits](/azure/ai-services/openai/quotas-limits#quotas-and-limits-reference) and to [manage your quota](/azure/ai-services/openai/how-to/quota).

The following diagram illustrates the shared Azure OpenAI model.

:::image type="content" source="./media/openai/openai-shared.svg" alt-text="Diagram that shows the shared Azure OpenAI model." border="false" lightbox="./media/openai/openai-shared.svg":::

When you deploy a shared Azure OpenAI service, you can decide whether the model deployments within the service are also shared or dedicated to specific customers.

#### Shared model deployment among tenants

Sharing a model deployment among tenants simplifies your operational burden because you have fewer deployments to manage and fewer model versions to track. Plan to use a shared model deployment if you can, and only create dedicated model deployments if you need the capabilities that they provide.

#### Dedicated model deployment for each tenant

You can create a model deployment for each tenant or for tenants that have special requirements that you can't meet by using a shared model deployment. Common reasons to use dedicated model deployments for a tenant include:

- **Quota and cost management.** Dedicated model deployments facilitate tenant-specific TPM allocation by tracking the number of tokens that each model uses. You can use this number to precisely allocate costs and manage each tenant's usage. If you use [provisioned throughput units (PTUs)](/azure/ai-services/openai/concepts/provisioned-throughput), you can assign the PTUs to specific customers and use other billing models for other customers.

- **Content filtering policies.** Sometimes, a specific tenant might require a unique content filtering policy, such as a tenant-specific block list of disallowed words. You specify the content filtering policy at the scope of a model deployment.

- **Model types and versions.** You might need to use different models or model versions for different tenants. A tenant might also require their own model life cycle management process.

- **Tenant-specific fine-tuning.** If you create distinct fine-tuned models for each tenant, you need to create a separate model deployment for each fine-tuned model.

    Remember that fine-tuning isn't required for most use cases. Usually, it's better to ground your model by using [Azure OpenAI On Your Data](#azure-openai-on-your-data) or another retrieval-augmented generation (RAG) approach.

- **Data residency.** This approach supports distinct data residency requirements. For example, you might provide a regional model deployment for a tenant that has strict data residency needs and use a global model deployment for other tenants.

Each model deployment has a unique URL, but it's important to remember that the underlying models are shared with other Azure customers. The models also share Azure infrastructure.

Azure OpenAI doesn't enforce access control for each model deployment, so your application needs to control which tenant can reach which model deployment.

### Tenant-provided Azure OpenAI resource

In some scenarios, your tenants might create the Azure OpenAI instance in their own Azure subscriptions and grant your application access to it. This approach might be appropriate in the following scenarios:

- Tenants have specific quotas and permissions from Microsoft, including access to different models, defined content filtering policies, and provisioned throughput usage.

- Tenants have a fine-tuned model that they need to use from your solution.

- Tenants require a component in their environment to process and send data through their customer-managed Azure OpenAI instance for processing.

To access an Azure OpenAI instance in your tenant's subscription, the tenant must provide your application with access. Your application must authenticate through its Microsoft Entra instance. One approach is to publish a [multitenant Microsoft Entra application](/entra/identity-platform/single-and-multi-tenant-apps). The following workflow outlines this approach:

1. The tenant registers the multitenant Microsoft Entra application in its own Microsoft Entra tenant.

1. The tenant grants the multitenant Microsoft Entra application the appropriate level of access to the Azure OpenAI resource. For example, the tenant might assign the application to the *Azure AI services user* role by using role-based access control.

1. The tenant provides the resource ID of the Azure OpenAI resource that it creates.

1. Your application code can use a service principal that's associated with the multitenant Microsoft Entra application in your own Microsoft Entra instance to access the tenant's Azure OpenAI instance.

Alternatively, you might ask each tenant to create a service principal for your service to use, and to provide you with its credentials. This approach requires you to securely store and manage credentials for each tenant, which is a potential security liability.

If your tenants configure network access controls on their Azure OpenAI instance, ensure that you can access them.

The following diagram illustrates the model for Azure OpenAI for each tenant in the tenant's subscription.

:::image type="content" source="./media/openai/openai-tenants-subscription.svg" alt-text="Diagram that shows the model for Azure OpenAI for each tenant in the tenant's subscription." border="false" lightbox="./media/openai/openai-tenants-subscription.svg":::

## Features of Azure OpenAI that support multitenancy

Azure OpenAI provides the following features that support multitenancy.

### Responses API

The [Responses API](/azure/ai-services/openai/how-to/responses) is a stateful API that unifies conversation management, tool invocation, file search, background task processing, and structured outputs in a single interface.

When you use the Responses API, it can be difficult to isolate data between tenants. Tenant identifiers can't be attached to all of the tools and capabilities.

However, if you choose to use the Responses API for a multitenant solution, you should consider tenant isolation in all stored data and operations that you control. The API stores conversation history by using response IDs, which link subsequent requests to previous context. You should ensure that response IDs are stored with tenant-scoped keys in your application. This approach ensures that a request can only reference response IDs that are associated with the same tenant.

The Responses API supports function calling and built-in tools. For function calling, where your application code handles the function invocation, you should ensure that any function calls that you make are multitenant-aware. One approach is to include the tenant ID in the call to the downstream API or function. For built-in tools, such as Code Interpreter, and any remote MCP server calls, the model infrastructure executes these operations. You can't reliably inject tenant context into these built-in tool invocations, so you should use dedicated containers or separate tool configurations for each tenant when you use these features.

When you use file search or retrieval-augmented generation (RAG) capabilities, you should ensure that file stores and vector indexes are scoped to the appropriate tenant. If you use shared indexes, apply tenant filters to all queries. If you deploy per-tenant indexes, map each request to the correct index based on the tenant identifier. For more information, see [Design a secure multitenant RAG inferencing solution](../../../ai-ml/guide/secure-multitenant-rag.md).

The Responses API supports a background mode for long-running operations. You should store task identifiers with the tenant context, and validate the tenant when you poll for results. Ensure that task queues and result storage prevent one tenant from accessing another tenant's background tasks or outputs.

### Assistants API

The [Assistants API](/azure/ai-services/openai/concepts/assistants) adds functionality to your Azure OpenAI service that makes it suitable for creating AI assistants. It includes the ability to call tools and APIs and to search files to ground the answers that the model generates. It enables the service to manage persistent conversational threads. The API can also generate and run code within a sandboxed environment. To support these capabilities, the Assistants API needs to store some data.

When you use the Assistants API in a multitenant solution, you can choose to create assistants that are dedicated to a single tenant, or you can share an assistant among multiple tenants. It's important to consider tenant isolation in all stored data, especially for shared assistants. For example, you should ensure that conversational threads are stored separately for each tenant.

The Assistants API supports function invocation, which sends your application instructions about which functions to invoke and which arguments to include. Ensure that any function calls that you make are multitenant-aware. One approach is to include the tenant ID in the call to the downstream system. Verify the tenant ID within your application, and don't rely on the language model to propagate the tenant ID for you.

### Azure OpenAI On Your Data

The Azure OpenAI On Your Data feature enables the large language model to directly query knowledge sources, like indexes and databases, as part of generating a response from the language model.

When you make a request, you can specify the data sources that should be queried. In a multitenant solution, ensure that your data sources are multitenancy-aware and that you can specify tenant filters on your requests. Propagate the tenant ID to the data source appropriately. For example, suppose that you query Azure AI Search. If you have data for multiple tenants in a single index, specify a filter to limit the retrieved results to the current tenant's ID. Or, if you create an index for each tenant, ensure that you specify the correct index for the current tenant.

### Batch deployments

You can deploy some models in Azure OpenAI by using a [batch deployment](/azure/ai-services/openai/how-to/batch). Batch deployments enable asynchronous processing of grouped requests by using a separate [batch quota](/azure/ai-services/openai/quotas-limits#batch-quota). Requests sent to a batch deployment have a 24-hour target turnaround time and cost less than standard deployments. Unlike standard deployments, batch quotas limit the number of enqueued tokens instead of the TPM.

This deployment type is ideal for scenarios where immediate responses aren't required and processing large volumes of requests can't disrupt real-time responses.

For example, a system that analyzes user feedback sentiment can use a batch deployment to avoid throttling the standard deployment quota that it needs to conduct real-time interactions in other applications. This approach also reduces processing costs.

In a multitenant solution, batch deployments can be shared among all tenants or created separately for each tenant.

- **Separate batch deployments for each tenant:**

    By assigning token quotas to each tenant-specific batch deployment, you prevent any single tenant from monopolizing resources. This approach also enables tracking token usage per tenant, which is useful for cost allocation.

- **Shared batch deployment:**

    A shared batch deployment can process requests from multiple tenants in combined or separate batch jobs. If you combine requests from multiple tenants into a single batch job, ensure that you can correctly map responses back to the appropriate tenant.

    Batch jobs are managed at the job level, so it's a good idea to separate them by tenant. This approach allows you to cancel or delete jobs for each tenant. Individual requests within a batch can't be canceled or deleted.

By carefully managing batch deployments, you can balance cost efficiency and resource allocation while maintaining tenant isolation and operational flexibility.

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
- [Checklist for architecting and building multitenant solutions on Azure](../../multitenant/checklist.md)
