---
title: Architectural Approaches for Cost Management and Allocation in a Multitenant Solution
description: Learn about cost management and allocation approaches for multitenant solutions, including Azure resource tagging, consumption tracking, and optimization.
author: johndowns
ms.author: pnp
ms.date: 08/19/2025 
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
- arb-saas
---

# Architectural approaches for cost management and allocation in a multitenant solution

Multitenant solutions often require special consideration when you measure, allocate, and optimize costs. This article includes key guidance to help you evaluate and manage costs effectively as a solution architect who works with multitenant applications.

## Key considerations and requirements

Consider the requirements that you have for measuring consumption in your solution. These requirements are described in more detail in [Measure the consumption of each tenant](../considerations/measure-consumption.md).

### Purpose of measurement

It's important to decide what your goal is. Consider the following example goals:

- **Calculate an approximate cost of goods sold for each tenant.** For example, if you deploy a significant number of shared resources, you might only require a rough approximation of the cost incurred for each tenant.

- **Calculate the exact cost that each tenant incurs.** For example, if you charge your tenants for the exact amount of consumption that they incur, you need to have precise information about how much each tenant's resources cost.

- **Identify outlier tenants that cost significantly more than other tenants.** For example, if you provide a [flat-rate pricing model](../considerations/pricing-models.md#flat-rate-pricing), you might need to determine whether any tenants are consuming a disproportionate amount of your provisioned capacity so that you can apply fair-use policies. In many scenarios, this use case doesn't require precise measurement of costs.

- **Reduce the overall Azure cost for your solution.** For example, you might want to assess the cost of every component and then determine whether you have overprovisioned for the workload.

By understanding the goal of measuring consumption by a tenant, you can determine whether cost allocations need to be approximate or precise. This distinction affects the specific tools that you can use and the practices that you should follow.

### Shared components

You might be able to reduce the cost of a multitenant solution by moving tenants to shared infrastructure. However, you need to carefully consider the impact of sharing resources, such as whether your tenants begin to experience the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml).

You also need to consider how you measure and allocate the costs of shared components. For example, you can evenly divide the cost between each of the tenants that use the shared component. Or you can meter each tenant's usage to get a more precise measurement of their consumption of shared components.

## Approaches and patterns to consider

When you plan cost allocation in a multitenant architecture, consider the following strategies and design patterns to ensure transparency, fairness, and scalability.

### Allocate costs by using resource tags

Azure enables you to [apply tags to your resources](/azure/azure-resource-manager/management/tag-resources). A tag is a key-value pair. You use tags to add custom metadata. Tags are useful for many management operations, and they're also useful for analyzing the cost of your Azure consumption. After you apply tags, you can [determine costs associated with each tag](/azure/cost-management-billing/costs/cost-analysis-common-uses#view-costs-for-a-specific-tag).

The way that you use tags in a multitenant solution is likely to vary depending on your architecture.

In some solutions, you might deploy dedicated resources for each tenant. For example, you might deploy dedicated [deployment stamps](../../../patterns/deployment-stamp.yml) for each tenant. In these scenarios, it's clear that any Azure consumption associated with those resources should be allocated to the corresponding tenant. To support this approach, you can tag your Azure resources with the tenant ID.

In other scenarios, you might have sets of shared resources. For example, when you apply the [Sharding pattern](../../../patterns/sharding.yml), you might deploy multiple databases and spread your tenants across them. Consider tagging the resources with an identifier for the *group* of tenants. You might not be able to easily allocate costs to a single tenant. However, you can use this approach to narrow down the cost to a defined group of tenants. You can also use the consumption information to help you rebalance tenants across the shards if you notice that a specific shard accrues higher costs than the other shards.

> [!NOTE]
> There's a [limit to the number of tags](/azure/azure-resource-manager/management/tag-resources#limitations) that can be applied to a resource. When you work with shared resources, it's best not to add a tag for every tenant that shares the resource. Instead, consider adding a tag with the shard ID or another way to identify the group of tenants.

Consider an example multitenant solution that's built by using the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) and a [vertically partitioned tenancy model](../considerations/tenancy-models.md#vertically-partitioned-deployments). Each deployment stamp includes a shared web server and sharded databases. You can apply tags to each of the Azure components, as shown in the following diagram.

:::image type="complex" border="false" source="media/cost-management-allocation/tags.png" alt-text="Diagram that shows two stamps, with tags added to each component." lightbox="media/cost-management-allocation/tags.png":::
   The image shows three tenants: Tenant A, Tenant B, Tenant C. It shows Deployment stamp 1 and Deployment stamp 2. Arrows points from Tenant A and Tenant B to Deployment stamp 1. The Deployment stamp 1 sections contains the web server and Tenants A and B. A line connects a section labeled stamp-id:d1 to the web server in Deployment stamp 1. Another line connects a section labeled stamp-id:d1, shard-id:s1 to tenants A and B in Deployment stamp 1. An arrow points from Tenant C to the Deployment stamp 2 section. The Deployment stamp 2 section includes Tenant C and a Web server section that's dedicated to Tenant C. A line connects a section labeled stamp-id:d2, tenant-id:c to the Web server section. Another line connects a section labeled stamp-id:d2, shard-id:s2, tenant-id:c to Tenant C in Deployment stamp 2.
:::image-end:::

Consider the following tagging strategy:

- Every resource has a `stamp-id` tag.
- Every sharded database has a `shard-id` tag.
- Every resource that's dedicated to a specific tenant has a `tenant-id` tag.

By using this tagging strategy, it's easy to filter the cost information to a single stamp. It's also easy to find the cost of the tenant-specific resources, such as the total cost of the database for tenant C. Shared components don't have a `tenant-id` tag, but the cost of the shared components for a stamp can be divided between the tenants who are assigned to use that stamp or shard.

### Instrument your application

In scenarios where you don't have a direct relationship between an Azure resource and a tenant, consider instrumenting your application to collect telemetry.

Your application tier might already collect logs and metrics that are helpful for answering questions about metering. Consider the following usage characteristics:

- The number of API requests made for each tenant over time.
- The peak activity periods for specific tenants throughout the day.
- The differences in usage patterns between tenant A and tenant B.

In Azure, [Application Insights](/azure/azure-monitor/app/app-insights-overview) often captures these metrics. By using [telemetry initializers](/azure/azure-monitor/app/api-filtering-sampling), you can enrich the telemetry that Application Insights captures to include a tenant identifier or other custom data.

However, Application Insights and other logging and monitoring solutions aren't appropriate for precise cost measurement or for metering purposes. Application Insights is designed to [sample data](/azure/azure-monitor/app/opentelemetry-sampling), especially when your application has a high volume of requests. Sampling is designed to reduce the cost of monitoring your solution because capturing every piece of telemetry can often become expensive.

If you need to track precise details about consumption or usage for billing purposes, you should instead build a custom pipeline to log the necessary data. You should then aggregate the data, based on your requirements. Azure services that can be helpful for this purpose include [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) to capture large volumes of telemetry and [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics) to process it in real time.

### Use Azure reservations and Azure savings plan to reduce costs

**[Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations)** enable you to reduce your Azure costs by pre-committing to a specific level of spend. Reservations apply to many Azure resource types.

Reservations can be used effectively in a multitenant solution. Consider the following factors:

- When you deploy a multitenant solution that includes shared resources, consider the baseline level of consumption that you need for the workload. You might consider a reservation for that baseline consumption and then pay standard rates for higher consumption during unpredictable peaks.

- When you deploy resources for each tenant, consider whether you can pre-commit to the resource consumption for a specific tenant or across your portfolio of tenants.

Azure reservations enable you to [scope your reservations](/azure/cost-management-billing/reservations/prepare-buy-reservation#scope-reservations) to apply to a resource group, a subscription, or a set of subscriptions. This capability means that you can take advantage of reservations, even if you shard your workload across multiple subscriptions.

Reservation scopes can also be helpful when your tenants have unpredictable workloads. For example, consider a solution in which tenant A only needs one instance of a specific resource, but tenants B and C each need two instances. Then, tenant B becomes less busy, so you reduce the instance count, and tenant A gets busier, so you increase the instance count. Your reservations are applied to the tenants that need them.

**Azure savings plan for compute** is a flexible cost-saving plan that generates significant savings compared to pay-as-you-go prices. You agree to a one-year or three-year contract and receive discounts on eligible compute services. These services include virtual machines, dedicated hosts, container instances, Azure premium functions, and Azure app services. Savings apply to these compute services regardless of the region, instance size, or operating system. For more information, see [Azure savings plan overview](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) and [Azure savings plan documentation](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview).

**Combine reservations and a savings plan** to further optimize cost and flexibility.

## Antipatterns to avoid

- **Ignore cost tracking entirely.** It's important to have at least an approximate idea of the costs that you incur and how each tenant affects the cost of delivering your solution. Otherwise, if your costs change over time, you have no baseline to compare against. You also might not be able to predict how a growth in tenants can affect your costs and profitability.

- **Assume or guess without data.** Ensure that your cost measurement is based on real information. You might not require precise measurements, but base your estimates on actual data.

- **Overengineer for precision.** You might not need to have a detailed accounting of every cost that every tenant incurs. Building unnecessarily precise cost measurement and optimization processes can be counterproductive because they add engineering complexity and create brittle processes.

- **Measure costs in real time.** Most solutions don't need up-to-the-minute cost measurements. Because metering and consumption data can be complex to process, you should log the necessary data and then asynchronously aggregate and process the data later.

- **Use monitoring tools for billing.** Ensure that you [use tools that are designed for cost monitoring and metering](#instrument-your-application). Application monitoring solutions aren't typically good candidates for this type of data, especially when you need high precision.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Sherri Babylon](https://www.linkedin.com/in/sbabylon/) | Senior Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Measure the consumption of each tenant](../considerations/measure-consumption.md)
