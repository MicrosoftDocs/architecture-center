---
title: Architectural Approaches for a Multitenant Solution
description: This article introduces approaches for the main categories of Azure services that you can consider when you plan a multitenant architecture.
author: johndowns
ms.author: pnp
ms.date: 06/11/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
 - arb-saas
---

# Architectural approaches for a multitenant solution

You can design and build multitenant solutions in Azure in several ways. At one extreme, you can share every resource in your solution among all of your tenants. At the other extreme, you can deploy isolated resources for every tenant. It might seem simple to deploy separate resources for every tenant, and it can work for a few tenants. However, it typically lacks cost efficiency and makes resource management difficult. Several approaches fall between these extremes. Each approach requires trade-offs between scale, isolation, cost efficiency, performance, implementation complexity, and manageability.

This section describes approaches for the main categories of Azure services that comprise a solution, including [compute](compute.md), [storage and data](storage-data.md), [networking](networking.md), [deployment](deployment-configuration.md), [identity](identity.md), [messaging](messaging.md), [AI and machine learning](ai-machine-learning.md), and [Internet of Things (IoT)](iot.md). For each category, it includes antipatterns to avoid and key patterns and approaches to consider when you design a multitenant solution.

## Deployment Stamps pattern

Multitenant solutions often use the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml). This pattern deploys dedicated infrastructure for a tenant or a group of tenants. A single stamp might serve multiple tenants or only a single tenant.

:::image type="complex" source="media/overview/deployment-stamps.png" alt-text="Diagram that shows an example implementation of the Deployment Stamps pattern. In this scenario, each tenant has their own stamp that contains a database." lightbox="media/overview/deployment-stamps.png" border="false":::
The diagram has three tenants, Tenant A, B, and C. Tenants A and B point to deployment stamp 1, which contains a web server and a database for both tenants. Tenant C points to deployment stamp 2, which contains a dedicated web server and database.
:::image-end:::

Single-tenant stamps make the Deployment Stamps pattern easier to implement. Each stamp functions independently and doesn't require multitenancy logic or capabilities in the application layer. This pattern provides the highest level of isolation and helps to avoid the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). It also provides configuration or customization for tenants based on specific requirements, such as a target geopolitical region or high availability needs.

Multitenant stamps require extra patterns to manage multitenancy within the stamp, and the noisy neighbor problem still might occur. However, the Deployment Stamps pattern supports continued scaling as your solution grows.

The main drawback of using the Deployment Stamps pattern for a single tenant is the infrastructure cost. Each stamp requires its own dedicated infrastructure, and that infrastructure can't be shared with other tenants. You must also provision resources to handle the tenant's peak workload. Make sure that your [pricing model](../considerations/pricing-models.md) offsets the cost of deployment for the tenant's infrastructure.

Single-tenant stamps often work well with a few tenants. As your number of tenants grows, managing a fleet of single-tenant stamps becomes more difficult. For an example case study, see [Run one million databases on Azure SQL for a large provider](https://devblogs.microsoft.com/azure-sql/running-1m-databases-on-azure-sql-for-a-large-saas-provider-microsoft-dynamics-365-and-power-platform). You can also apply the Deployment Stamps pattern to create multitenant stamps. This approach supports resource sharing and reduces infrastructure costs.

To implement the Deployment Stamps pattern, use automated deployment approaches. Depending on your deployment strategy, you might manage your stamps within your deployment pipelines by using declarative infrastructure as code, such as Bicep files or Terraform templates. Or you might build custom code to deploy and manage each stamp by using [Azure SDKs](/dotnet/azure/sdk/azure-sdk-for-dotnet) or another tool.

## Intended audience

The articles in this section aim to help solution architects and lead developers of multitenant applications, including independent software vendors and startups who develop software as a service (SaaS) solutions. Much of the guidance in this section applies broadly to multiple Azure services within a category.

## Related resource

- Before you review the service-specific Azure guidance, review the [approaches for resource organization in a multitenant solution](resource-organization.md).
