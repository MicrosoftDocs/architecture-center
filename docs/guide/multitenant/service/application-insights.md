---
title: Multitenancy and Application Insights
description: Learn about the features of Application Insights that are useful when you work with multitenant systems.
author: rajnemani
ms.author: ranema
ms.date: 08/21/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure-application-insights
categories:
 - analytics
---

# Multitenancy and Application Insights

Application Insights is a service that monitors the performance, availability, and usage of your web applications. It can help you identify and diagnose problems, analyze user behavior, and track key metrics. This article describes some of the features of Application Insights that are useful for multitenant systems. It also provides links to guidance and examples.

> [!TIP]
> Application Insights is designed and optimized for monitoring solutions. It's not intended to be used to capture every event that happens in a system, as you might need to do for auditing or billing. To learn about how you can measure usage for billing purposes, see [Considerations for measuring consumption in multitenant solutions](../considerations/measure-consumption.md).

## Isolation models

When you work with a multitenant system that uses Application Insights, you need to determine the required level of isolation. There are several isolation models that you can choose from. Here are some factors that might influence your choice:

- How many tenants do you plan to have?
- Do you share your application tier among multiple tenants, or do you deploy separate deployment stamps for each tenant?
- Are you or your customers sensitive about storing data alongside other tenants' data?
- Is the application tier of your solution multitenant, and the data tier single tenant?
- Do telemetry requirements vary among tenants?

> [!TIP]
> The main factors that determine the cost of Application Insights are the amount of data that you send to it and how long the data is retained. In a multitenant application, the overall cost is the same for a dedicated Application Insights instance as it is for a shared instance. For more information, see the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/).

This table summarizes the differences between the main tenancy models for Application Insights:

| Consideration | Globally shared Application Insights instance| One Application Insights instance per region/stamp | One Application Insights instance per tenant |
|-|-|-|-|
| **Data isolation** | Low | Low | High |
| **Performance isolation** | Low | Medium | High |
| **Deployment complexity** | Low to medium, depending on the number of tenants | Medium, depending on the number of tenants | High |
| **Operational complexity** | Low |Medium | High |
| **Example scenario** | Large multitenant solution with a shared application tier | Multitenant solution with regional deployments to better serve a global customer base | Individual application instances per tenant |

### Globally shared Application Insights instance

You can use a single instance of Application Insights to track telemetry for tenants in a multitenant application, as shown here:

![Diagram that shows the globally shared Application Insights isolation model.](media/application-insights/global-shared-app-insights.png)

Benefits of this approach include simplified configuration and management of the application, because you need to instrument the application code only once. Drawbacks of this approach include the limits and quotas that are associated with a single Application Insights instance. To determine whether limits might affect your multitenant application, see the [Application Insights limits](/azure/azure-monitor/service-limits#application-insights).

When you use a shared Application Insights resource, it might also be more difficult to isolate and filter the data for each tenant, especially if you have a large number of tenants. Because all tenants share the same Log Analytics workspace and instrumentation keys, security and privacy might also be a concern.

To address these concerns, you might need to implement logic and mechanisms to ensure that data can be filtered by tenant and that your operations team can properly see per-tenant data. You can implement filtering by adding a [custom property](#custom-properties-and-metrics) to capture the tenant ID as part of every telemetry item. The tenant ID can then be used to query the data.

### One Application Insights instance per stamp

Multitenant solutions often include multiple stamps, which might be deployed in different Azure regions. Stamps enable you to serve tenants that are local to a particular region so you can provide better performance. A single stamp might serve a single tenant or a subset of your tenants. To learn more about stamps, see [Deployment stamps pattern](../approaches/overview.yml#deployment-stamps-pattern).

You might decide to deploy an Application Insights instance in each stamp, sharing the instance among all tenants that use the stamp, as shown here:

![Diagram that shows the one-instance-per-stamp isolation model.](media/application-insights/shared-app-insights-per-stamp.png)

This approach provides more flexibility with resource limits because the limits apply per instance of Application Insights.

### One Application Insights instance per tenant

You might decide to use a dedicated Application Insights instance for each tenant:

![Diagram that shows one instance per tenant.](media/application-insights/dedicated-app-insights-per-tenant.png)

This approach gives you more flexibility and control over the tenant's telemetry data and provides the strongest data isolation. When you use this model, you can configure tenant-specific settings and retention policies. 

When you use this approach, however, you need to deploy a large number of Application Insights instances, manage-tenant specific settings in a tenant catalog, and change application code when new tenants are onboarded. Note that the decision to deploy a dedicated Application Insights instance per tenant is separate from the decision to deploy an application tier for each tenant. For example, you can decide to deploy a single application instance in a stamp that's shared by multiple tenants but deploy one Application Insights instance for each tenant.

You should consider using one Application Insights instance per tenant if you require a high degree of data isolation between your tenants, you need different configurations for various tenants, or the service limits of a single Application Insights instance don't meet your needs.  

With this approach, it might be difficult to aggregate data and compare it across all tenants because you need to query multiple Application Insights instances separately. If you use this approach, consider using [cross-resource queries and Azure Monitor workbooks](#unify-multiple-application-insights-instances-into-a-single-view).

## Application Insights features that support multitenancy

### Custom properties and metrics

Application Insights provides a way to enrich telemetry data with custom properties and metrics. *Custom properties* are key-value pairs that you can attach to any telemetry item, like a request or an event. *Custom metrics* are numerical values that you can track over time, like a score or the length of a queue. You can use custom properties and metrics to add tenant-specific information, like tenant ID, tenant name, tenant location, and deployment stamp ID, to telemetry data.

There are two ways to add custom properties to your telemetry: by using `TelemetryClient` or by using telemetry initializers.

#### TelemetryClient

[TelemetryClient](/azure/azure-monitor/app/api-custom-events-metrics) is an object that you can use to track any telemetry item. You can access the custom properties of any telemetry item via its `Properties` dictionary. The advantage of using `TelemetryClient` is that you have full control over what custom properties to add, and when to add them. The disadvantage is that you need to access and modify each telemetry item that you want to enrich with custom properties.

#### Telemetry initializers

You can use [telemetry initializers](/azure/azure-monitor/app/api-filtering-sampling?tabs=sdkloaderscript#addmodify-properties-itelemetryinitializer) to add information to all telemetry items, or to modify properties that are set by the standard telemetry modules.

When you share an Application Insights instance across multiple tenants, a telemetry initializer often provides a good way to inject the tenant ID into every telemetry item. You can then use the ID to query and filter for reporting. The advantage of using telemetry initializers is that you can apply custom properties to all or some of the telemetry items in one place without needing to write code for each item. The disadvantage is that you have less control over which custom properties to add to each telemetry item, so you might add unnecessary or redundant data.

When you add custom properties to telemetry data, by using either mechanism, you can use powerful features of Application Insights to monitor and analyze multitenant applications in a more granular and meaningful way. For example, you can:

- Use metrics explorer to create charts and graphs that show the performance and usage of the application for each tenant.
- Use Log Analytics to write complex queries that filter, aggregate, and join telemetry data based on tenant-specific properties or metrics.
- Use alerts to set up rules that notify you when certain conditions are met or exceeded for a tenant.
- Use Azure Monitor workbooks to create interactive reports and dashboards that visualize the health and status of the application for each tenant.

### Unify multiple Application Insights instances into a single view

There are several ways to unify data from multiple Application Insights instances. Your choice depends on your needs and preferences. The following sections describe some of the options.

#### Cross-resource queries

You can use cross-resource queries to [query](/azure/azure-monitor/logs/cross-workspace-query) data from multiple Application Insights instances in a single query. The instances can be in a single resource group, in more than one resource group, or in more than one subscription. As the number of Application Insights workspaces in a query increases, query performance might degrade. The number of Application Insights workspaces that you can include in a single query is also limited. For more information, see [Query across multiple workspaces and apps](/azure/azure-monitor/logs/cross-workspace-query).

#### Azure Monitor workbooks

You can use [Azure Monitor workbooks](/training/modules/visualize-data-workbooks/) to create interactive reports and dashboards based on data from multiple sources, including Application Insights. These reports and dashboards enable you to visualize and analyze data from multiple Application Insights instances in a single view.

## Latency

The time it takes for data on a monitored system to become available for analysis is referred to as [latency](/azure/azure-monitor/logs/data-ingestion-time). A shared Application Insights instance in a multitenant application doesn't incur more latency than a dedicated one unless the shared instance is throttled and the throttling prevents data from being ingested. In that scenario, latency increases.

## Rate limiting on ingestion

You can perform ingestion rate limiting in Application Insights by using [sampling](/azure/azure-monitor/app/sampling) to limit the amount of telemetry data that's ingested by your service per day. Sampling helps prevent Application Insights from throttling telemetry due to ingestion limits. You can use fixed-rate sampling to determine an optimal sampling rate, based on the number of tenants and the daily cap, in order to say within the limits.  

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Raj Nemani](http://linkedin.com/in/rajnemani) | Director, Partner Technology Strategist, GPS-ISV

Other contributors:

* [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
* [Rob Bagby](http://linkedin.com/in/robbagby/) | Principal Content Developer, C+E Skilling Content R&D
* [John Downs](http://linkedin.com/in/john-downs) | Principal Program Manager, MCAPS
* [Rick Hallihan](http://linkedin.com/in/hallihan/) | Senior Software Engineer, C+E Skilling Content R&D
* [Landon Pierce](http://linkedin.com/in/landon-pierce) | Customer Engineer, Azure CXP
* [Daniel Scott-Raynsford](http://linkedin.com/in/dscottraynsford) | Partner Technology Strategist, OCP
* [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, Azure CXP

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Training: Monitor app performance](/training/modules/monitor-app-performance)
- [What is Application Insights?](/azure/azure-monitor/app/app-insights-overview)
- [Application Insights limits](/azure/azure-monitor/service-limits#application-insights)
- [Query across multiple workspaces and apps](/azure/azure-monitor/logs/cross-workspace-query)
- [Training: Visualize data combined from multiple data sources by using Azure Workbooks](/training/modules/visualize-data-workbooks)
- [Capture Application Insights custom metrics with .NET and .NET Core](/azure/azure-monitor/app/tutorial-asp-net-custom-metrics)
- [Application Insights API for custom events and metrics](/azure/azure-monitor/app/api-custom-events-metrics)
- [Application Insights telemetry data model](/azure/azure-monitor/app/data-model-complete)
- [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/)
- [Log data ingestion time in Azure Monitor](/azure/azure-monitor/logs/data-ingestion-time)
- [Sampling in Application Insights](/azure/azure-monitor/app/sampling)
- [Filter and preprocess telemetry in the Application Insights SDK](/azure/azure-monitor/app/api-filtering-sampling)

## Related resources

- [Architect multitenant solutions on Azure](overview.md)
- [Architectural considerations for a multitenant solution](../considerations/overview.yml)
- [Tenancy models for a multitenant solution](../considerations/tenancy-models.yml)