---
title: Multitenancy and Azure OpenAI
titleSuffix: Azure Architecture Center
description: Learn how to deploy the Azure OpenAI models and work with the features associated with each model when you have a multitenant system.
author: soferreira
ms.author: soferreira
ms.date: 09/21/2023
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
products:
  - azure
  - azure-openai
categories:
  - ai-machine-learning
ms.custom:
  - arb-saas
---

# Multitenancy and Azure OpenAI Service

[Azure OpenAI](/azure/ai-services/openai/overview) provides you with access to OpenAI's powerful language models. This article describes key features of Azure OpenAI that are beneficial for multitenant solutions. Review the recommended resources to help you plan your approach and use Azure OpenAI.

## Isolation models

When you have a multitenant system that uses Azure OpenAI, decide the level of isolation that you want. Determine your isolation model based on the following factors:

- How many tenants do you plan to have?
- Do you share your application tier between multiple tenants? If yes, do you deploy single-tenant application instances, or do you create separate deployments for each tenant?
- Do your tenants have compliance requirements that require access to a separate instance?

The following table summarizes the main tenancy models for Azure OpenAI.

| Consideration | Azure OpenAI for each tenant in the provider's subscription | Azure OpenAI for each tenant in the tenant's subscription | Shared Azure OpenAI |
|-|-|-|-|
| **Data isolation** | High | Very high | Low |
| **Performance isolation** | High | High | Low-medium, depending on the token per minute (TPM) usage for each tenant. |
| **Deployment complexity** | Low-medium, depending on the number of tenants. | High. The tenant must correctly grant access to the provider. | Low |
| **Operational complexity** | High | Low for the provider, higher for the tenant. | Low |
| **Example scenario** | Individual application instances for each tenant. | Tenants with specific compliance requirements or custom models. | Large multitenant solution with a shared application tier. |

### Azure OpenAI for each tenant in the provider's subscription

If you're a service provider, consider deploying an Azure OpenAI instance for each tenant in your Azure subscription. This approach provides data isolation for each tenant. It requires that you deploy and manage an increasing number of Azure OpenAI resources as you increase the number of tenants.

Use this approach if you have separate application deployments for each tenant, or if you need to circumvent limitations, such us the quota or request per minute. For more information, see [Azure OpenAI quotas and limits](/azure/ai-services/openai/quotas-limits#quota-and-limits-reference).

The following diagram illustrates the model for Azure OpenAI for each tenant in the provider's subscription.

:::image type="content" source="./media/openai/openai-providers-subscription.svg" alt-text="Diagram that shows the model for Azure OpenAI for each tenant in the provider's subscription." border="false" lightbox="./media/openai/openai-providers-subscription.svg":::

### Azure OpenAI for each tenant in the tenant's subscription

In some situations, your tenants might create the Azure OpenAI instance in their own Azure subscriptions and grant your application access to it. This approach is appropriate when tenants have specific quotas and permissions from Microsoft, such as access to the latest models, less strict filtering, or the use of provisioned throughput. You can also use this approach if the tenant has a fine-tuned model. Or if they require a component in their environment to process and send data via their customer-managed Azure OpenAI instance for processing.

To access an Azure OpenAI instance in your tenant's subscription, the tenant must provide your application with access. Your application must authenticate through their Microsoft Entra instance. One approach is to publish a [multitenant Microsoft Entra application](/azure/active-directory/develop/single-and-multi-tenant-apps). The following workflow outlines the steps of this approach:

1. The tenant registers the multitenant Microsoft Entra application in their own Microsoft Entra tenant.
1. The tenant grants the multitenant Microsoft Entra application the appropriate level of access to their Azure OpenAI resource. For example, the tenant might assign the application to the *Azure AI services user* role by using role-based access control (RBAC).
1. The tenant provides the resource ID of the Azure OpenAI resource that they create.
1. Your application code can use a service principal that's associated with the multitenant Microsoft Entra application in your own Microsoft Entra instance to access the tenant's Azure OpenAI instance.

Alternatively, you might ask each tenant to create a service principal for your service to use, and to provide you with its credentials. This approach requires that you securely store and manage credentials for each tenant, which is a potential security liability. If your tenants configure network access controls on their Azure OpenAI instance, ensure that you can access them.

The following diagram illustrates the model for Azure OpenAI for each tenant in the tenant's subscription.

:::image type="content" source="./media/openai/openai-tenants-subscription.svg" alt-text="Diagram that shows the model for Azure OpenAI for each tenant in the tenant's subscription." border="false" lightbox="./media/openai/openai-tenants-subscription.svg":::

### Shared Azure OpenAI

You might choose to share an instance of Azure OpenAI among multiple tenants. The Azure OpenAI resource is deployed in your, or the solution provider's, Azure subscription. You're responsible for managing it. This solution is the easiest to implement, but it provides the least data isolation and performance isolation.

Sharing Azure OpenAI doesn't offer access security at the model deployment level. Other tenants can use unauthorized models. It's strongly discouraged to share an Azure OpenAI instance when you use fine-tuned models. It can expose sensitive information and allow unauthorized access to tenant-specific resources.

Sharing an instance of Azure OpenAI among multiple tenants can also lead to a [Noisy Neighbor](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) problem. It can cause higher latency for some tenants. You also need to make your application code multitenancy-aware. For example, if you want to charge your customers for the consumption cost of a shared Azure OpenAI instance, implement the logic to keep track of the total number of tokens for each tenant in your application.

You can also deploy multiple shared Azure OpenAI instances. For example, if you follow the [Deployment Stamps pattern](../approaches/overview.yml#deployment-stamps-pattern), deploy a shared Azure OpenAI instance in each stamp. If you deploy a multiregion solution, you should deploy Azure OpenAI in each region to:

- Avoid cross-region traffic latency.
- Support data residency requirements.
- Enable the use of regional Azure OpenAI within other services that require same-region deployments.

When you have a shared Azure OpenAI instance, it's important to consider its [limits](/azure/ai-services/openai/quotas-limits#quotas-and-limits-reference) and to [manage your quota](/azure/ai-services/openai/how-to/quota).

The following diagram illustrates the shared Azure OpenAI model.

:::image type="content" source="./media/openai/openai-shared.svg" alt-text="Diagram that shows the shared Azure OpenAI model." border="false" lightbox="./media/openai/openai-shared.svg":::

#### Shared Azure OpenAI instance with the same model for each tenant

When you use a shared Azure OpenAI instance, deploying individual instances of the same model for each tenant can offer significant benefits. This approach provides enhanced parameter customization for each deployment. It facilitates tenant-specific TPM allocation by tracking the number of tokens each model uses, which enables you to precisely cost allocate and manage each tenant's usage. This approach can optimize resource utilization to ensure that each tenant only pays for their required resources, which ensures a cost-effective solution. This approach also promotes scalability and adaptability because tenants can adjust their resource allocation based on their evolving needs and usage patterns.

> [!NOTE]
> When you customize models for unique needs, you need to consider the approaches that are available. Every tenant might have distinct requirements and use cases. You might not use fine-tuning for most use cases. Explore other options, such as grounding. Take the time to evaluate these factors to help ensure that you choose the approach that best meets your needs.

## Managed identities

Use Microsoft Entra managed identities to provide access to Azure OpenAI from other resources that are authenticated by Microsoft Entra ID. When you use managed identities, you don't need to use an Azure OpenAI API key. You can also use managed identities to grant fine-grained permissions to your Azure OpenAI identity using RBAC.

When you use managed identities, consider your isolation model. For more information, see [Azure OpenAI with managed identities](/azure/ai-services/openai/how-to/managed-identity).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Sofia Ferreira](https://linkedin.com/in/asofiamferreira) | Software Engineer, ISV & DN CoE

Other contributors:

- [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce) | Customer Engineer, ISV & DN CoE
- [Paolo Salvatori](https://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, ISV & DN CoE
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Tech Strategist
- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv) | Principal Customer Engineer, ISV & DN CoE

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Architectural approaches for the deployment and configuration of multitenant solutions](../approaches/deployment-configuration.yml)
- [Architectural approaches for cost management and allocation in a multitenant solution](../../multitenant/approaches/cost-management-allocation.yml)
- [Checklist for architecting and building multitenant solutions on Azure](../../multitenant/checklist.md)
