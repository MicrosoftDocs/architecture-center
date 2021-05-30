---
title: Design for scaling
description: Describes the scaling options for performance efficiency
author: v-aangie
ms.date: 12/01/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - references_regions
---

# Design for scaling

Scaling is the ability of a system to handle increased load. Services covered by [Azure Autoscale](https://azure.microsoft.com/en-us/features/autoscale/) can scale automatically to match demand to accommodate workload. They will scale out to ensure capacity during workload peaks and scaling will return to normal automatically when the peak drops.

## Plan for growth

Planning for growth starts with understanding your current workloads. This can help to anticipate scale needs based on predictive usage scenarios. An example of a predictive usage scenario is an e-commerce site that recognizes that its infrastructure should scale appropriately for an anticipated high volume of holiday traffic.

Perform load tests and stress tests to determine the necessary infrastructure to support the predicted spikes in workloads. A good plan includes incorporating a buffer to accommodate for random spikes.

For more information on how to determine the upper and maximum limits of an application's capacity, see [Performance testing](./performance-test.md) in the Performance Efficiency pillar.

Another critical component of planning for scale is to make sure the region that hosts your application supports the necessary capacity required to accommodate load increase. If you are using a multiregion architecture, make sure the secondary regions can also support the increase. A region can offer the product but may not support the predicted load increase without the necessary SKUs (Stock Keeping Units) so you need to verify this.

To verify your region and available SKUs, first select the product and regions in [Products available by region](https://azure.microsoft.com/global-infrastructure/services/).

![Products available by region](../_images/design-scale-1a.png)

Then, check the SKUs available in the Azure portal.

### Add scale units

For each resource, know the upper scaling limits, and use [sharding](/azure/azure-sql/database/elastic-scale-introduction#sharding) or decomposition to go beyond those limits. Design the application so that it's easily scaled by adding one or more scale units, such as by using the [Deployment Stamps pattern](../../patterns/deployment-stamp.md). Determine the scale units for the system in terms of well-defined sets of resources.

The next step might be to use built-in scaling features or tools to understand which resources need to scale concurrently with other resources. For example, adding X number of front-end VMs might require Y number of additional queues and Z number of storage accounts to handle the additional workload. So a scale unit could consist of X VM instances, Y queues, and Z storage accounts.

## Use Autoscaling to manage load increases and decreases

Autoscaling enables you to run the right amount of resources to handle the load of your app. It adds resources (called scaling out) to handle an increase in load such as seasonal workloads. Autoscaling saves money by removing idle resources (called scaling in) during a decrease in load such as nights and weekends for some corporate apps.

You automatically scale between the minimum and maximum number of instances to run and add or remove VMs automatically based on a set of rules.

![Autoscale](../_images/design-autoscale.png)

For more information, see [Autoscaling](../../best-practices/auto-scaling.md).

### Understand scale targets

Scale operations (horizontal - changing the number of identical instances, vertical - switching to more/less powerful instances) can be fast, but usually take time to complete. It's important to understand how this delay affects the application under load and if degraded performance is acceptable.

For more information, see [Best practices for Autoscale](/azure/azure-monitor/platform/autoscale-best-practices#choose-the-thresholds-carefully-for-all-metric-types).

## Take advantage of platform autoscaling features

Here's how you can benefit from autoscaling features:

- Use built-in autoscaling features when possible rather than custom or third-party mechanisms.
- Use scheduled scaling rules where possible to ensure that resources are available.
- Add reactive autoscaling to the rules where appropriate to cope with unexpected changes in demand.

> [!NOTE]
> Providing your application is explicitly designed to handle some of its instances being terminated, remember to use autoscaling to scale down/in resources that are no longer necessary for the given load in order to reduce operational costs.

For more information, see [Autoscaling](../../best-practices/auto-scaling.md).

## Autoscale CPU or memory-intensive applications

In the case of CPU or memory-intensive applications, scaling up to a larger machine SKU with more CPU or memory may be required. Once the demand for CPU or memory has been reduced, instances can revert back to the original instance.

For example, you may have an application that processes images, videos or music. Given the process and requirements, it may make sense to scale up a server (e.g., add CPU or memory) to quickly process the large media file. While scaling *out* allows the system to process more files simultaneously, it does not impact processing speed of each individual file.

## Autoscale with Azure compute services

The way autoscaling works is that metrics are collected for the resource (CPU and memory utilization) and the application (requests queued and requests per second). Rules can then be created to add and remove instances depending on how the rule evaluates. An [App Services](/azure/app-service/overview-hosting-plans#how-does-my-app-run-and-scale) App Plan allows autoscale rules to be set for scale-out/scale-in and scale-up/scale-down. Scaling also applies to [Azure Automation](/azure/automation/automation-intro).

:::image type="icon" source="../_images/github.png" border="false"::: The [Application Service autoscaling](https://github.com/mspnp/samples/tree/master/PerformanceEfficiency/AppServiceAutoscalingSample) sample shows how to create an Azure App Service plan which includes an Azure App Service.

[Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS) offers two levels of autoscale:

- **Horizontal autoscale** - Can be enabled on service containers to add more or fewer pod instances within the cluster.
- **Cluster autoscale** - Can be enabled on the agent VM instances running an agent node-pool to add more or remove VM instances dynamically.

Other Azure services include the following:

- [**Azure Service Fabric**](/azure/service-fabric/service-fabric-overview) - Virtual machine scale sets offer autoscale capabilities for true IaaS scenarios.
- [**Azure App Gateway**](/azure/application-gateway/overview) and [**Azure API Management**](/azure/api-management/api-management-key-concepts) - PaaS offerings for ingress services that enable autoscale.
- [**Azure Functions**](/azure/azure-functions/functions-overview), [**Azure Logic Apps**](/azure/logic-apps/logic-apps-overview), and [**App Services**](/azure/app-service/overview) - Serverless pay-per-use consumption modeling that inherently provide autoscaling capabilities.
- [**Azure SQL Database**](/archive/blogs/sqlserverstorageengine/azure-sql-database-scalability) - PaaS platform to change performance characteristics of a database on the fly and assign more resources when needed or release the resources when they are not needed. Allows [scaling up/down](/archive/blogs/sqlserverstorageengine/azure-sql-database-scalability#scaling-updown), [read scale-out](/archive/blogs/sqlserverstorageengine/azure-sql-database-scalability#read-scale-out), and [global scale-out/sharding](/archive/blogs/sqlserverstorageengine/azure-sql-database-scalability#global-scale-outsharding) capabilities.

Each service documents its autoscale capabilities. Review [Autoscale overview](/azure/azure-monitor/platform/autoscale-overview) for a general discussion on Azure platform autoscale.

> [!NOTE]
> If your application does not have built-in ability to autoscale, or isn't configured to scale out automatically as load increases, it's possible that your application's services will fail if they become saturated with user requests. See [Azure Automation](/azure/virtual-desktop/set-up-scaling-script) for possible solutions.

## Next steps

>[!div class="nextstepaction"]
>[Plan for capacity](./design-capacity.md)
