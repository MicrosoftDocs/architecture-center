---
title: Measure consumption
description: This article describes the considerations for measuring the consumption of each tenant in a multitenant solution.
author: PlagueHO
ms.author: dascottr
ms.date: 11/12/2024
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Measure the consumption of each tenant

As a solution provider, it's important to measure the consumption of each tenant in your multitenant solution. By measuring the consumption of each tenant, you can ensure that the cost of goods sold (COGS), for delivering the service to each tenant, is profitable. On this page, we provide guidance for technical decision-makers about the importance of measuring consumption, and the approaches you can consider to measure a tenant's consumption, as well as the tradeoffs involved.

There are two primary concerns driving the need for measuring each tenant's consumption:

- You need to measure the actual cost to serve each tenant. This is important to monitor the profitability of the solution for each tenant.
- You need to determine the amount to charge the tenant, when you're using [consumption-based pricing](./pricing-models.md#consumption-based-pricing).

However, it can be difficult to measure the actual resources used by a tenant in a multitenant solution. Most services that can be used as part of a multitenant solution don't automatically differentiate or break down usage, based on whatever you define a tenant to be. For example, consider a service that stores data for all of your tenants in a single relational database. It's difficult to determine exactly how much capacity each tenant uses of that relational database, either in terms of data storage or of the compute resources required to service any queries and requests.

By contrast, for a single-tenant solution, you can use [Microsoft Cost Management](/azure/cost-management-billing/costs/overview-cost-management) within the Azure portal, to get a complete cost breakdown for all the Azure resources that are consumed by that tenant.

Therefore, when facing these challenges, it's important to consider how to measure consumption.

> [!NOTE]
> In some cases, it's commercially acceptable to take a loss on delivering service to a tenant, for example, when you enter a new market or region. This is a commercial choice. Even in these situations, it's still a good idea to measure the consumption of each tenant, so that you can plan for the future.

## Indicative consumption metrics

Modern applications (built for the cloud) are usually made up of many different services, each with different measures of consumption. For example, a storage account measures consumption based on the amount of data stored, the data transmitted, and the numbers of transactions. In contrast, Azure App Service consumption is measured by the amount of compute resources allocated over time. If you have a solution that includes a storage account and App Service resources, then combining all these measurements together to calculate the actual COGS (cost of goods sold) can be a very difficult task.

Often, it's easier to use a single indicative measurement to represent consumption in the solution. For example, if a multitenant solution shares a single relational database, then the data stored by a tenant might be a good indicative consumption metric.

Even if you use the volume of data stored by a tenant as an indicative consumption measure, it might not be a true representation of consumption for every tenant. If a tenant generates far more read activity than write activity or heavily uses reporting capabilities, then that tenant might use much more compute from the solution than the storage requirements indicate.

> [!TIP]
> Occasionally you should measure and review the actual consumption across your tenants, to create a baseline model. This model helps you to determine whether the assumptions you're making about your indicative metrics are correct.

## Transaction metrics

An alternative way of measuring consumption is to identify a key transaction that is representative of the COGS for the solution. For example, in a document management solution, it could be the number of documents created. This can be useful, if there's a core function or feature within a system that is transactional, and if it can be easily measured.

This method is usually easy and cost effective to implement, as there's usually only a single point in your application that needs to record the number of transactions that occur.

## Per-request metrics

In solutions that are primarily API-based, it might make sense to use a consumption metric that's based around the number of API requests being made to the solution. This can often be quite simple to implement, but it does require you to use APIs as the primary interface to the system. There is an increased operational cost of implementing a per-request metric, especially for high volume services, because of the need to record the request utilization (for audit and billing purposes).

User-facing solutions that consist of a single-page application (SPA), or a mobile application that uses the APIs, might not be a good fit for the per-request metric. This is because there's little understanding by the end user of the relationship between the use of the application and the consumption of APIs. Your application might be chatty (it makes many API requests) or chunky (it makes too few API requests), and the user wouldn't notice a difference. However, if you only need an approximate idea of each tenant's consumption, it might still be a reasonable choice.

> [!WARNING]
> Make sure you store request metrics in a reliable data store that's designed for this purpose. For example, although Azure Application Insights can track requests and can even track tenant IDs (by using [properties](/azure/azure-monitor/app/api-custom-events-metrics#properties)), Application Insights isn't designed to store every piece of telemetry. It removes data, as part of its [sampling behavior](/azure/azure-monitor/app/sampling). For billing and metering purposes, choose a data store that gives you a high level of accuracy.

## Estimate consumption

When measuring the consumption for a tenant, it might be easier to provide an estimate of the consumption for the tenant, rather than trying to calculate the exact amount of consumption. For example, for a multitenant solution that serves many thousands of tenants in a single deployment, it's reasonable to approximate that the cost of serving the tenant is just a percentage of the cost of the Azure resources.

You might consider estimating the COGS for a tenant, in the following cases:

- You aren't using [consumption-based pricing](./pricing-models.md#consumption-based-pricing).
- The usage patterns and cost for every tenant is similar, regardless of size.
- Each tenant consumes a low percentage (say, <2%), of the overall resources in the deployment.
- The per-tenant cost is low.

You might also choose to estimate consumption in combination with [indicative consumption metrics](#indicative-consumption-metrics), [transaction metrics](#transaction-metrics), or [per-request metrics](#per-request-metrics). For example, for an application that primarily manages documents, the percentage of overall storage used by a tenant, to store its documents, gives a close enough representation of the actual COGS. This can be a useful approach, when measuring the COGS is difficult or when it would add too much complexity to the application.

## On-charging your costs

In some solutions, you can charge your customers the COGS for their tenant's resources. For example, you might use [Azure resource tags](/azure/azure-resource-manager/management/tag-resources) to allocate billable Azure resources to tenants. You can then determine the cost to each tenant for the set of resources that's dedicated to them, plus a margin for profit and operation.

> [!NOTE]
> Some [Azure services don't support tags](/azure/azure-resource-manager/management/tag-support). For these services, you need to attribute the costs to a tenant based on other characteristics, like the resource name, resource group, or subscription.

[Azure Cost Analysis](/azure/cost-management-billing/costs/quick-acm-cost-analysis) can be used to analyze Azure resource costs for single tenant solutions that use tags, resource groups, or subscriptions to attribute costs.

However, this becomes prohibitively complex in most modern multitenant solutions, because of the challenge of accurately determining the exact COGS to serve a single tenant. This method should only be considered for very simple solutions, solutions that have single-tenant resource deployments, or custom tenant-specific add-on features within a larger solution.

Some Azure services provide features that allow other methods of attribution of costs in a multitenant environment. For example, Azure Kubernetes Service supports [multiple node pools](/azure/aks/use-multiple-node-pools), where each tenant is allocated a node pool with [node pool tags](/azure/aks/use-multiple-node-pools#setting-nodepool-azure-tags), which are used to attribute costs.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Partner Technology Strategist

Other contributors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer, Azure Patterns & Practices
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Consider the [update deployment model to use](updates.md).
