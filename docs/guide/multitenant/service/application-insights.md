---
title: Multitenancy and Application Insights
description: Learn about tenancy models that you can use with Application Insights and features that are useful when you use this service in multitenant systems.
author: PlagueHO
ms.author: dascottr
ms.date: 08/01/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-saas
---

# Multitenancy and Application Insights

Application Insights is a service that monitors the performance, availability, and usage of your web applications. It can help you identify and diagnose problems, analyze user behavior, and track key metrics. This article describes some of the features of Application Insights that are useful for multitenant systems. It also describes various tenancy models.

> [!TIP]
> Application Insights is designed and optimized for monitoring solutions. It's not intended to be used to capture every event that happens in a system, which is a task that you might need to do for auditing or billing. To learn about how you can measure usage for billing purposes, see [Measure the consumption of each tenant](../considerations/measure-consumption.md).

## Isolation models

When you implement a multitenant system that uses Application Insights, you need to determine the required level of isolation. There are several isolation models that you can choose from. The following factors might influence your choice:

- The number of tenants that you plan to have.
- Whether you share your application tier among multiple tenants or deploy separate deployment stamps for each tenant.
- Whether you or your customers are sensitive about storing data alongside other tenants' data.
- Whether you want to approach tenancy differently in different tiers. For example, the application tier of your solution can be multitenant while the data tier is single tenant.
- Whether telemetry requirements vary among tenants.

> [!TIP]
> The main factors that determine the cost of Application Insights are the amount of data that you send to it and how long the data is retained. In a multitenant application, the overall cost is the same for a dedicated Application Insights instance as it is for a shared instance. For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

The following table summarizes the differences between the main tenancy models for Application Insights:

| Consideration | Globally shared Application Insights instance| One Application Insights instance for each region or stamp | One Application Insights instance for each tenant |
|-|-|-|-|
| Data isolation | Low | Low | High |
| Performance isolation | Low | Medium | High |
| Deployment complexity | Low to medium, depending on the number of tenants | Medium, depending on the number of tenants | High |
| Operational complexity | Low | Medium | High |
| Example scenario | Large multitenant solution that has a shared application tier | Multitenant solution that has regional deployments to better serve a global customer base | Individual application instances for each tenant |

### Globally shared Application Insights instance

You can use a single instance of Application Insights to track telemetry for tenants in a multitenant application.

:::image type="complex" border="false" source="media/application-insights/global-shared-app-insights.png" alt-text="Diagram that shows the globally shared Application Insights isolation model." lightbox="media/application-insights/global-shared-app-insights.png":::
   The diagram consists of three sections. The first section contains icons that represent tenants. The second section contains boxes that represent stamps. The third section represents Application Insights. Arrows point from Tenant 1 and Tenant 2 to the application in Stamp A. Arrows point from Tenant 3 and Tenant 4 to the application in Stamp B. An arrow points from Tenant 5 to the application in Stamp C. Arrows point from the stamps to the Application Insights section.
:::image-end:::

One benefit of this approach is simplified configuration and management of the application. You only need to instrument the application code one time. Drawbacks of this approach include the limits and quotas that are associated with a single Application Insights instance. To determine whether limits might affect your multitenant application, see [Application Insights limits](/azure/azure-monitor/service-limits#application-insights).

When you use a shared Application Insights resource, it might also be more difficult to isolate and filter the data for each tenant, especially if you have many tenants. All tenants share the same Log Analytics workspace and instrumentation keys, so security and privacy might also be a concern.

To address these concerns, you might need to implement logic and mechanisms to ensure that you can filter data by tenant and that your operations team can properly see per-tenant data. You can implement filtering by adding a [custom property](#custom-properties-and-metrics) to capture the tenant ID as part of every telemetry item. You can then use the tenant ID to query the data.

### One Application Insights instance for each stamp

Multitenant solutions often include multiple stamps, which might be deployed in different Azure regions. Stamps enable you to serve tenants that are local to a specific region so you can provide better performance. A single stamp might serve a single tenant or a subset of your tenants. To learn more about stamps, see [Deployment stamps pattern](../approaches/overview.md#deployment-stamps-pattern).

You might decide to deploy an Application Insights instance in each stamp and share the instance among all tenants that use the stamp. The following diagram illustrates this approach.

:::image type="complex" border="false" source="media/application-insights/shared-app-insights-per-stamp.png" alt-text="Diagram that shows the one-instance-per-stamp isolation model." lightbox="media/application-insights/shared-app-insights-per-stamp.png":::
   The diagram consists of two sections. The first section contains icons that represent tenants. The second section contains boxes that represent stamps. Each stamp box contains an application icon and an icon that represents Application Insights. Arrows point from Tenant 1 and Tenant 2 to Stamp A. Arrows point from Tenant 3 and Tenant 4 to Stamp B. An arrow points from Tenant 5 to Stamp C. An arrow points from the application icon to the Application Insights icon in each stamp.
:::image-end:::

This approach provides more flexibility with resource limits because the limits apply to each instance of Application Insights.

### One Application Insights instance for each tenant

You might decide to use a dedicated Application Insights instance for each tenant. The following diagram illustrates this approach.

:::image type="complex" border="false" source="media/application-insights/dedicated-app-insights-per-tenant.png" alt-text="Diagram that shows one Application Insights instance for each tenant." lightbox="media/application-insights/dedicated-app-insights-per-tenant.png":::
   The diagram consists of two sections. The first section contains icons that represent tenants. The second section contains boxes that represent stamps. Each stamp box contains an application icon and separate boxes that represent Application Insights instances for each tenant. Arrows point from Tenant 1 and Tenant 2 to Stamp A. Arrows point from Tenant 3 and Tenant 4 to Stamp B. An arrow points from Tenant 5 to Stamp C.
:::image-end:::

This approach gives you more flexibility and control over tenants' telemetry data and provides the strongest data isolation. When you use this model, you can configure tenant-specific settings and retention policies.

When you use this approach, you need to deploy several Application Insights instances, manage tenant-specific settings in a tenant catalog, and change application code when new tenants are onboarded. The decision to deploy a dedicated Application Insights instance for each tenant is separate from the decision to deploy an application tier for each tenant. For example, you can decide to deploy a single application instance in a stamp that multiple tenants share but deploy one Application Insights instance for each tenant.

You should consider using one Application Insights instance for each tenant if any of the following conditions apply:

- You require a high degree of data isolation between your tenants.
- You need different configurations for various tenants.
- The service limits of a single Application Insights instance don't meet your needs.  

This approach makes it difficult to aggregate and compare data across tenants because you must query multiple Application Insights instances separately. If you use this approach, consider using [cross-resource queries and Azure Monitor workbooks](#combine-multiple-application-insights-instances-into-a-single-view).

## Application Insights features that support multitenancy

You can use the following Application Insights features to support multitenancy in your workloads.

### Custom properties and metrics

Application Insights provides a way to enrich telemetry data by using custom properties and metrics. *Custom properties* are key-value pairs that you can attach to any telemetry item, such as requests or events. *Custom metrics* are numerical values that you can track over time, like a score or the length of a queue. You can use custom properties and metrics to add tenant-specific information, like tenant ID, tenant name, tenant location, and deployment stamp ID, to telemetry data.

You can use `TelemetryClient` or telemetry initializers to add custom properties to your telemetry.

#### TelemetryClient

[TelemetryClient](/azure/azure-monitor/app/api-custom-events-metrics) is an object that you can use to track any telemetry item. You can access the custom properties of any telemetry item via its `Properties` dictionary. The advantage of using `TelemetryClient` is that you have full control over what custom properties to add, and when to add them. The disadvantage of using `TelemetryClient` is that you need to access and modify each telemetry item that you want to enrich with custom properties.

#### Telemetry initializers

You can use [telemetry initializers](/azure/azure-monitor/app/api-filtering-sampling#addmodify-properties-itelemetryinitializer) to add information to all telemetry items or to modify properties that the standard telemetry modules set.

When you share an Application Insights instance across multiple tenants, a telemetry initializer often provides a good way to inject the tenant ID into every telemetry item. You can then use the ID to query and filter for reporting. The advantage of using telemetry initializers is that you can apply custom properties to all or some of the telemetry items in one place without needing to write code for each item. The disadvantage of using telemetry initializers is that you have less control over which custom properties to add to each telemetry item, so you might add unnecessary or redundant data.


### How to use your telemetry data

When you use either mechanism to add custom properties to telemetry data, you can use features of Application Insights to monitor and analyze multitenant applications in more granular and meaningful ways:

- Use Azure Monitor metrics explorer to create charts and graphs that show the performance and usage of the application for each tenant.

- Use Log Analytics to write complex queries that filter, aggregate, and join telemetry data based on tenant-specific properties or metrics.

- Use alerts to set up rules that notify you when specific conditions are met for a tenant.

- Use Azure Monitor workbooks to create interactive reports and dashboards that visualize the health and status of the application for each tenant.

### Combine multiple Application Insights instances into a single view

There are several ways to combine data from multiple Application Insights instances. Your choice depends on your needs and preferences. The following sections describe some of the options.

#### Cross-resource queries

You can use cross-resource queries to query data from multiple Application Insights instances in a single query. The instances can be in a single resource group, in more than one resource group, or in more than one subscription. As the number of Application Insights workspaces in a query increases, query performance might degrade. The number of Application Insights workspaces that you can include in a single query is also limited. For more information, see [Query across multiple workspaces and apps](/azure/azure-monitor/logs/cross-workspace-query).

#### Azure Monitor workbooks

You can use [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) to create interactive reports and dashboards based on data from multiple sources, including Application Insights. These reports and dashboards enable you to visualize and analyze data from multiple Application Insights instances in a single view.

## Latency

The time it takes for data on a monitored system to become available for analysis is known as [*latency*](/azure/azure-monitor/logs/data-ingestion-time). A shared Application Insights instance in a multitenant application doesn't incur more latency than a dedicated one unless the shared instance is throttled and the throttling prevents data from being ingested. In that scenario, latency increases.

## Rate limiting on ingestion

You can implement ingestion rate limiting in Application Insights by using [sampling](/azure/azure-monitor/app/opentelemetry-sampling) to limit the amount of telemetry data that your service ingests each day. Sampling helps prevent Application Insights from throttling telemetry because of ingestion limits. You can use fixed-rate sampling to determine an optimal sampling rate, based on the number of tenants and the daily cap, to stay within the limits.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Raj Nemani](https://www.linkedin.com/in/rajnemani/) | Director, Partner Technology Strategist, GPS-ISV

Other contributors:

- [Rob Bagby](https://www.linkedin.com/in/robbagby/) | Principal Content Developer, Azure Patterns & Practices
- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Rick Hallihan](https://www.linkedin.com/in/hallihan/) | Senior Software Engineer, Azure Patterns & Practices
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce/) | Customer Engineer, Azure CXP
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Senior Partner Technology Strategist, EPS
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, Azure CXP

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Training: Monitor app performance](/training/modules/monitor-app-performance)
- [What is Application Insights?](/azure/azure-monitor/app/app-insights-overview)
- [Application Insights limits](/azure/azure-monitor/service-limits#application-insights)
- [Query across multiple workspaces and apps](/azure/azure-monitor/logs/cross-workspace-query)
- [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview)
- [Capture Application Insights custom metrics with .NET and .NET Core](/azure/azure-monitor/app/tutorial-asp-net-custom-metrics)
- [Application Insights API for custom events and metrics](/azure/azure-monitor/app/api-custom-events-metrics)
- [Application Insights telemetry data model](/azure/azure-monitor/app/data-model-complete)
- [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/)
- [Log data ingestion time in Azure Monitor](/azure/azure-monitor/logs/data-ingestion-time)
- [Sampling in Application Insights](/azure/azure-monitor/app/opentelemetry-sampling)
- [Filter and preprocess telemetry in the Application Insights SDK](/azure/azure-monitor/app/api-filtering-sampling)

## Related resources

- [Architect multitenant solutions on Azure](overview.md)
- [Architectural considerations for a multitenant solution](../considerations/overview.yml)
- [Tenancy models for a multitenant solution](../considerations/tenancy-models.md)
