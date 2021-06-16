---
title: Measure consumption
titleSuffix: Azure Architecture Center
description: This article describes the considerations for measuring the consumption of each tenant in a multitenant solution.
author: PlagueHO
ms.author: dascottr
ms.date: 05/27/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
categories:
 - management-and-governance
ms.category:
  - fcp
ms.custom:
  - guide
---

# Measure the consumption of each tenant

It's important to measure the consumption of each tenant in a multitenant solution. By measuring the consumption of each tenant, you can ensure that the cost of good sold (COGS) for delivering the service to each tenant is profitable.

> [!NOTE]
> In some cases it will be commercially acceptable to take a loss on delivering service to a tenant, for example, when entering a new market or region. But this is a commercial choice and doesn't require additional architectural planning.

There are two primary concerns driving the need for measuring per tenant consumption:

- Measuring the actual cost to serve each tenant. This is important for monitoring profitability of the solution for each tenant.
- Determining the amount to charge the tenant when [consumption-based pricing](./pricing-models.md#consumption-based-pricing) is being used.

However, measuring the actual amount of resource used by a tenant in a multitenant solution is a non-trivial task. Most services that can be used as part of a multitenant solution don't automatically differentiate or break down usage based on whatever you define a tenant to be. For example, consider a service that stores data for all of your tenants in a single relational database. It is difficult to determine exactly how much each tenant uses of that relational database, either in terms of storage or compute capacity required to service their queries and requests.

By contrast, for a single tenant solution we're simply able to use Azure Cost Management within the Azure portal to get a complete cost breakdown for all Azure resources consumed by a tenant.

Therefore, it is important when considering how to measure consumption that you're taking these challenges into account.

## Indicative consumption metrics

Modern applications that are built for the cloud are usually made up of many different services, each with different measures of consumption. For example, a storage account measures consumption based on the amount of data stored, the data transmitted, and the numbers of transactions. However, Azure App Service consumption is measured by the amount of compute resources allocated over time. If you have a solution that includes a storage account and App Service resources, then combining all these measurements together to calculate the actual COGS can be a very difficult task. Often it is easier to use a single indicative measurement that is used to represent consumption in the solution.

For example, in the case of a multitenant solution sharing a single relational database, you may determine that the data stored is a good indicative consumption metric.

> [!NOTE]
> Even if you choose to use the volume of data stored by a tenant as an indicative consumption measure, it may not be a true representation of consumption for every tenant. For example, if a particular tenant does a lot more read/reporting from the solution but doesn't write a lot of data, they could use a lot more compute than their storage requirements would indicate.

It is important to occasionally measure and review the actual consumption across your tenants to determine whether the assumptions you're making about your indicative metrics are correct.

## Transaction metrics

An alternative way of measuring consumption may be to identify a key transaction that is representative of the COGS for the solution. For example, in a document management solution it may be the number of documents created. This can be useful if there is a core function or feature within a system that is transactional and can be easily measured.

This method is usually easy and cost effective to implement as there is usually only a single point in your application that needs to record the number of transactions that occur.

## Per-request metrics

In solutions that are primarily API-based it might make sense to use a consumption metric that is based around the number of API requests being made to the solution. This can often be quite simple to implement, but does require that APIs are the primary interface to the system. There will be an increased operational cost of implementing a per-request metric, especially for high volume services, because of the need to record the request utilization for audit and billing purposes.

> [!NOTE]
> User-facing solutions consisting of an single page application (SPA) or a mobile application using the APIs may not be a good fit for the per-request metric because there is little understanding by the end-user of the relationship between the use of the application and the consumption of APIs.

> [!WARNING]
> Make sure you store request metrics in a reliable data store designed for this purpose. For example, although Azure Application Insights can track requests and even track tenant IDs by using [properties](/azure/azure-monitor/app/api-custom-events-metrics#properties), Application Insights is not designed to store every piece of telemetry and it removes data as part of its [sampling behavior](/azure/azure-monitor/app/sampling). For billing and metering purposes, choose a data store that will give you a high level of accuracy.

## Estimate consumption

When measuring the consumption for a tenant, it may be easier to provide an estimate of the consumption for the tenant rather than trying to calculate it exactly. For example, for a multitenant solution that serves many thousands of tenants in a single deployment, it may be reasonable to approximate that the cost of serving the tenant is just a percentage of the cost of the Azure resources.

You might consider estimating the COGS for a tenant when:

- You aren't using [consumption-based pricing](./pricing-models.md#consumption-based-pricing).
- The usage patterns and cost for every tenant is similar, regardless of size.
- Each tenant consumes a low percentage (say, <2%) of the overall resources in the deployment.
- The per-tenant cost is low.

You might also choose to estimate consumption in combination with [indicative consumption metrics](#indicative-consumption-metrics), [transaction metrics](#transaction-metrics) or [per-request metrics](#Per-request-metrics). For example, for an application that primarily manages documents, the percentage of overall storage used by a tenant to store their documents gives a close enough representation of the actual COGS. This can be useful approach when measuring the COGS is difficult or would add too much complexity to the application.

## On-charging your costs

In some solutions, you can simply charge tenants the COGS for their resources. For example, you might use [Azure resource tags](/azure/azure-resource-manager/management/tag-resources) to allocate billable Azure resources to tenants. You can then determine the cost to each tenant for the set of resources dedicated to them, plus a margin for profit and operation.

However, this becomes prohibitively complex in most modern multitenant solutions because of the challenge of accurately determining the exact COGS to serve a single tenant. This method should only be considered for very simple solutions, solutions that result in single-tenant resource deployments, or custom add-on features within a larger solution.

## Next steps

Return to the [architectural considerations overview](overview.md).
