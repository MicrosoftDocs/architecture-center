---
title: Multitenancy and Azure OpenAI
titleSuffix: Azure Architecture Center
description: Learn how to deploy the Azure OpenAI models and work with the features associated with each model when you have a multitenant system.
author: PlagueHO
ms.author: dascottr
ms.date: 04/11/2025
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
products:
  - azure
  - azure-openai
categories:
  - ai-machine-learning
ms.custom:
  - arb-saas
  - arb-aiml
---

# Multitenancy and Azure OpenAI Service

[Azure OpenAI](/azure/ai-services/openai/overview) provides you with access to OpenAI's powerful language models. This article describes key features of Azure OpenAI that are beneficial for multitenant solutions. Review the recommended resources to help you plan your approach and use Azure OpenAI.

## Isolation models

When you have a multitenant system that uses Azure OpenAI service, you need to decide the level of isolation that your tenants require. You should determine your isolation model based on the following factors:

- How many tenants do you plan to have?
- Do your tenants have compliance requirements that require network or infrastructure isolation?
- Do your tenants require models that are fine-tuned on their own data?
- Do your tenants require different model versions or model lifecycles?

The following table summarizes the deployment approaches you can use when using Azure OpenAI Service in a multitenant system:

| Consideration | Dedicated Azure OpenAI service | Shared Azure OpenAI service, dedicated model deployment per tenant | Shared Azure OpenAI service, shared model deployment | Tenant-provided Azure OpenAI service |
|-|-|-|-|-|
| **Data isolation** | High | Medium | Low | High |
| **Performance isolation** | High | High | Low-medium, depending on the token per minute (TPM) usage for each tenant. | High |
| **Deployment complexity** | Low-medium, depending on the number of tenants. | Medium, need to manage deployment names and quotas. | Low | Not applicable, managed by customer. |
| **Operational complexity** | Low | Medium | High | Low for the provider, higher for the tenant. |
| **Example scenario** | Single tenant deployments requiring network isolation from other tenants. | Tenants with specific model lifecycle or fine-tuning requirements. | Large multitenant solutions with a shared application tier. | Tenants with specific compliance or fine-tuning requirements. |

### Dedicated Azure OpenAI service

If you're a service provider, consider deploying an Azure OpenAI instance for each tenant in your Azure subscription. This approach provides data isolation for each tenant. It requires that you deploy and manage an increasing number of Azure OpenAI resources as you increase the number of tenants.

Use this approach if you have separate application deployments for each tenant, or if you need to circumvent limitations, such as the quota or request per minute. For more information, see [Azure OpenAI quotas and limits](/azure/ai-services/openai/quotas-limits#quota-and-limits-reference).

The following diagram illustrates the model for Azure OpenAI for each tenant in the provider's subscription.

:::image type="content" source="./media/openai/openai-providers-subscription.svg" alt-text="Diagram that shows the model for Azure OpenAI for each tenant in the provider's subscription." border="false" lightbox="./media/openai/openai-providers-subscription.svg":::

### Shared Azure OpenAI service

You might choose to share an instance of Azure OpenAI among multiple tenants. The Azure OpenAI resource is deployed in your (the service provider's) Azure subscription. You're responsible for managing it. This solution is the easiest to implement, but it provides the least data isolation and performance isolation.

Sharing an Azure OpenAI resource doesn't provide security segmentation for each model deployment. A tenant might be able to use a model they aren't authorized to use. For this reason, avoid sharing an Azure OpenAI instance when you use fine-tuned models, because you might expose sensitive information and allow unauthorized access to tenant-specific data or resources.

Sharing an instance of Azure OpenAI among multiple tenants can also lead to a [Noisy Neighbor](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) problem. It can cause higher latency for some tenants. You also need to make your application code multitenancy-aware. For example, if you want to charge your customers for the consumption cost of a shared Azure OpenAI instance, implement the logic to keep track of the total number of tokens for each tenant in your application.

You can also deploy multiple shared Azure OpenAI instances. For example, if you follow the [Deployment Stamps pattern](../approaches/overview.yml#deployment-stamps-pattern), deploy a shared Azure OpenAI instance in each stamp. If you deploy a multiregion solution, you should deploy Azure OpenAI in each region to:

- Avoid cross-region traffic latency.
- Support data residency requirements.
- Enable the use of regional Azure OpenAI within other services that require same-region deployments.

When you have a shared Azure OpenAI instance, it's important to consider its [limits](/azure/ai-services/openai/quotas-limits#quotas-and-limits-reference) and to [manage your quota](/azure/ai-services/openai/how-to/quota).

The following diagram illustrates the shared Azure OpenAI model.

:::image type="content" source="./media/openai/openai-shared.svg" alt-text="Diagram that shows the shared Azure OpenAI model." border="false" lightbox="./media/openai/openai-shared.svg":::

When you deploy a shared Azure OpenAI service, you can decide whether the model deployments within the service are also shared, or if they're dedicated to specific customers.

#### Shared model deployment among tenants

Sharing a model deployment among tenants simplifies your operational burden because you have fewer deployments to manage, and model versions to track. Plan to use a shared model deployment if you can, and only create dedicated model deployments if you need the capabilities they offer.

#### Dedicated model deployment per tenant

You can create a model deployment for each tenant, or for tenants who have special requirements that can't be met by using a shared model deployment. Common reasons to use dedicated model deployments for a tenant include the following:

- **Quota and cost management:** It facilitates tenant-specific TPM allocation by tracking the number of tokens each model uses, which enables you to precisely cost allocate and manage each tenant's usage. If you use [provisioned throughput units (PTUs)](/azure/ai-services/openai/concepts/provisioned-throughput), you can assign the PTUs to specific customers and use other billing models for other customers.

- **Content filtering policies:** Sometimes, a specific tenant might require a unique content filtering policy, such as a tenant-specific blocklist of disallowed words. You specify the content filtering policy at the scope of a model deployment.

- **Model types and versions:** You might need to use different models or model versions for different tenants. A tenant might also require their own model lifecycle management process.

- **Tenant-specific fine tuning:** If you create distinct fine-tuned models for each tenant, you need to create a separate model deployment for each fine-tuned model.

    Remember that fine-tuning isn't required for most use cases. Usually, it's better to ground your model by using [Azure OpenAI On Your Data](#azure-openai-on-your-data) or another retrieval-augmented generation (RAG) approach.

- **Data residency:** This approach supports distinct data residency requirements. For example, you might provide a regional model deployment for a tenant with strict data residency needs, and use a global model deployment for other tenants without strict needs.

Each model deployment has its own distinct URL, but it's important to remember the underlying models are shared with other Azure customers. They also use shared Azure infrastructure.

Azure OpenAI doesn't enforce access control for each model deployment, so your application needs to control which tenant can reach which model deployment.

### Tenant-provided Azure OpenAI resource

In some situations, your tenants might create the Azure OpenAI instance in their own Azure subscriptions and grant your application access to it. This approach might be appropriate in the following situations:

- Tenants have specific quotas and permissions from Microsoft, such as access to different models, specific content filtering policies, or the use of provisioned throughput.
- The tenant has a fine-tuned model they need to use from your solution.
- They require a component in their environment to process and send data through their customer-managed Azure OpenAI instance for processing.

To access an Azure OpenAI instance in your tenant's subscription, the tenant must provide your application with access. Your application must authenticate through their Microsoft Entra instance. One approach is to publish a [multitenant Microsoft Entra application](/azure/active-directory/develop/single-and-multi-tenant-apps). The following workflow outlines the steps of this approach:

1. The tenant registers the multitenant Microsoft Entra application in their own Microsoft Entra tenant.
1. The tenant grants the multitenant Microsoft Entra application the appropriate level of access to their Azure OpenAI resource. For example, the tenant might assign the application to the *Azure AI services user* role by using role-based access control (RBAC).
1. The tenant provides the resource ID of the Azure OpenAI resource that they create.
1. Your application code can use a service principal that's associated with the multitenant Microsoft Entra application in your own Microsoft Entra instance to access the tenant's Azure OpenAI instance.

Alternatively, you might ask each tenant to create a service principal for your service to use, and to provide you with its credentials. This approach requires that you securely store and manage credentials for each tenant, which is a potential security liability.

If your tenants configure network access controls on their Azure OpenAI instance, ensure that you can access them.

The following diagram illustrates the model for Azure OpenAI for each tenant in the tenant's subscription.

:::image type="content" source="./media/openai/openai-tenants-subscription.svg" alt-text="Diagram that shows the model for Azure OpenAI for each tenant in the tenant's subscription." border="false" lightbox="./media/openai/openai-tenants-subscription.svg":::

## Features of Azure OpenAI Service that support multitenancy

### Assistants API

The [Assistants API](/azure/ai-services/openai/concepts/assistants) adds functionality to your Azure OpenAI service that makes it suitable for creating AI assistants. It includes the ability to call tools and APIs, as well as search files to ground the answers that the model generates. It enables persistent conversational threads to be managed by the service, and it can generate and execute code within a sandboxed environment. To support these capabilities, the Assistants API needs to store some data.

When you use the Assistants API in a multitenant solution, you can choose to create assistants that are dedicated to a single tenant, or you can share an assistant among multiple tenants. It's important that you consider tenant isolation in all data that's stored, especially for shared assistants. For example, you should ensure that conversational threads are stored separately for each tenant.

The Assistants API supports function invocation, which sends your application instructions on functions to invoke and arguments to include. Ensure that any functions calls you make are multitenant-aware, such as by including the tenant ID in the call to the downstream system. Verify the tenant ID within your application, and don't rely on the language model to propagate the tenant ID for you.

### Azure OpenAI On Your Data

Azure OpenAI On Your Data enables the large language model to directly query knowledge sources, like indexes and databases, as part of generating a response from the language model.

When you make a request, you can specify the data sources that should be queried. In a multitenant solution, ensure that your data sources are multitenancy-aware and that you can specify tenant filters on your requests. Propagate the tenant ID through to the data source appropriately. For example, suppose you're querying Azure AI Search. If you have data for multiple tenants in a single index, specify a filter to limit the retrieved results to the current tenant's ID. Or, if you've created an index for each tenant, ensure that you specify the correct index for the current tenant.

### Batch Deployment

Some models in Azure OpenAI Service can be deployed using a [Batch deployment](/azure/ai-services/openai/how-to/batch), which enables asynchronous processing of grouped requests using a separate [batch quota](/azure/ai-services/openai/quotas-limits#batch-quota). Requests sent to a batch deployment have a 24-hour target turnaround time and cost less than standard deployments. Unlike standard deployments, batch quotas limit the number of enqueued tokens rather than tokens per minute (TPM).

This deployment type is ideal for scenarios where immediate responses are not required, but processing large volumes of requests must not disrupt real-time responses. For example, a system analyzing user feedback sentiment could use a batch deployment to avoid throttling the standard deployment quota needed for real-time interactions, while also reducing processing costs.

In a multitenant solution, batch deployments can be shared among all tenants or created separately for each tenant:

- **Separate Batch Deployments per Tenant:**  
  Assigning enqueued token quotas to each tenant-specific batch deployment prevents any single tenant from monopolizing resources. This approach also enables tracking token usage per tenant, which is useful for cost allocation.

- **Shared Batch Deployment:**  
  A shared batch deployment can process requests from multiple tenants in combined or separate batch jobs. If combining requests, ensure you can correctly map responses back to the appropriate tenant. Note that batch jobs are managed at the job level, so individual tenant requests within a batch cannot be canceled or deleted. To avoid these issues, it is recommended to separate batch jobs by tenant.

By carefully managing batch deployments, you can balance cost efficiency and resource allocation while maintaining tenant isolation and operational flexibility.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Sofia Ferreira](https://linkedin.com/in/asofiamferreira) | Software Engineer, ISV & DN CoE

Other contributors:

- [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce) | Customer Engineer, ISV & DN CoE
- [Paolo Salvatori](https://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, ISV & DN CoE
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Solution Architect
- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv) | Principal Customer Engineer, ISV & DN CoE

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Architectural approaches for the deployment and configuration of multitenant solutions](../approaches/deployment-configuration.yml)
- [Architectural approaches for cost management and allocation in a multitenant solution](../../multitenant/approaches/cost-management-allocation.yml)
- [Checklist for architecting and building multitenant solutions on Azure](../../multitenant/checklist.md)
