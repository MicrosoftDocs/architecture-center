---
title: scaling for performance efficiency
description: Describes the scaling options for performance efficiency
author: v-aangie
ms.date: 11/04/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom: 
---

# Design for scaling

Scaling allows applications to react to variable load by increasing and decreasing the number of instances of roles, queues, and other services. However, the application must be designed with this in mind.

For example, for optimal performance, the application and the services it uses should be stateless to allow requests to be routed to any instance. Having stateless services also means that adding or removing an instance doesn't adversely impact current users. If an application is stateful, however, then additional design considerations will be necessary, such as session-handling for deprecated instances.

## Plan for growth

Planning for growth starts with understanding your current workloads. This can help to anticipate scale needs based on predictive usage scenarios. An example of a predictive usage scenario is an e-commerce site that recognizes that its infrastructure should scale appropriately for an anticipated high volume of holiday traffic.

Perform load tests and stress tests to determine the necessary infrastructure to support the predicted spikes in workloads. A good plan includes incorporating a buffer to accommodate for random spikes.

For more information on how to determine the upper and maximum limits of an application's capacity, see the Performance Testing article in the Performance Efficiency pillar. <!--LINK to new Performance Testing article-->

Another critical component of planning for scale is to make sure the region that hosts your application supports the necessary scale required to accommodate load increase. If you are using a multi-region architecture, make sure the secondary regions can also support the increase. A region can offer the product but may not support the predicted load increase without the necessary SKUs so you need to verify this. If you do not take this step, you will most likely need to upgrade your product to the next available pricing tier.

To verify your region and available SKUs, first select the product and regions in [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=).

![Products available by region](../_images/design-scale-1a.png)

Then, check the SKUs available in the Azure portal.

### Add scale units

For each resource, know the upper scaling limits, and use [sharding](https://docs.microsoft.com/azure/azure-sql/database/elastic-scale-introduction#sharding) or decomposition to go beyond those limits. Design the application so that it's easily scaled by adding one or more [scale units](https://docs.microsoft.com/archive/msdn-magazine/2017/february/azure-inside-the-azure-app-service-architecture#what-is-an-app-service-scale-unit). Determine the scale units for the system in terms of well-defined sets of resources. This makes applying scale-out operations easier and less prone to negative impact caused by a lack of resources in some part of the overall system. 

The next step might be to use built-in scaling features or tools such as Azure Automation to autoscale. For example, adding X number of front-end VMs might require Y number of additional queues and Z number of storage accounts to handle the additional workload. So a scale unit could consist of X VM instances, Y queues, and Z storage accounts.

## Use Autoscaling to manage load increases and decreases

Autoscaling enables you to run the right amount of resources to handle the load of your app. It adds resources (called scaling out) to handle an increase in load such as seasonal workloads and customer facing applications. Autoscaling saves money by removing idle resources (called scaling in) during a decrease in load such as during nights and weekends for some corporate apps.

### CPU or memory-intensive applications

In the case of CPU or memory-intensive applications, scaling up may be required. Once CPU or memory has been reduced, instances can be scaled down.

For example, you may have an application that processes images, videos or music. Given the process and requirements, it may make sense to scale up a server (e.g., add CPU or memory) to quickly process the large media file. While scaling *out* allows the system to process more files simultaneously, it does not impact processing speed of each individual file.

## Autoscale with Azure compute services

Many of the Azure compute services offer autoscale to ensure the right amount of resources are available to meet service user demand. This includes virtual machine scale sets, app service web apps, and API management services. This is critical for the service user experience.

The way it works is that metrics are collected for the resource (CPU and memory utilization) and the application (requests queued and requests per second). Rules can then be created off those metrics and time schedules to add and remove instances depending on how the rule evaluates. An [App Services](https://docs.microsoft.com/azure/app-service/overview-hosting-plans#how-does-my-app-run-and-scale) App Plan allows autoscale rules to be set for scale-out/scale-in and scale-up/scale-down. Scaling also applies to [Azure Automation](https://docs.microsoft.com/azure/automation/automation-intro).

[Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/intro-kubernetes) (AKS) offers two levels of autoscale:

- **Horizontal autoscale** - Can be enabled on service containers to add more or fewer pod instances within the cluster.
- **Cluster autoscale** - Can be enabled on the agent VM instances running an agent node-pool to add more or remove VM instances dynamically.

Other Azure services include the following:

- [**Azure Service Fabric**](https://docs.microsoft.com/azure/service-fabric/service-fabric-overview) - Virtual machine scale sets offer autoscale capabilities for true IaaS scenarios.
- [**Azure App Gateway**](https://docs.microsoft.com/azure/application-gateway/overview) and [**Azure API Management**](https://docs.microsoft.com/azure/api-management/api-management-key-concepts) - PaaS offerings for ingress services that enable autoscale.
- [**Azure Functions**](https://docs.microsoft.com/azure/azure-functions/functions-overview), [**Azure Logic Apps**](https://docs.microsoft.com/azure/logic-apps/logic-apps-overview), and [**App Services**](https://docs.microsoft.com/azure/app-service/overview) - Serverless pay-per-use consumption modeling that inherently provide autoscale.
- [**Azure SQL Database**](https://docs.microsoft.com/archive/blogs/sqlserverstorageengine/azure-sql-database-scalability) - PaaS platform to change performance characteristics of a database on the fly and assign more resources when needed or release the resources when they are not needed. Allows [scaling up/down](https://docs.microsoft.com/archive/blogs/sqlserverstorageengine/azure-sql-database-scalability#scaling-updown), [read scale-out](https://docs.microsoft.com/archive/blogs/sqlserverstorageengine/azure-sql-database-scalability#read-scale-out), and [global scale-out/sharding](https://docs.microsoft.com/archive/blogs/sqlserverstorageengine/azure-sql-database-scalability#global-scale-outsharding) capabilities.

Each service documents its autoscale capabilities. Review [Autoscale overview](https://docs.microsoft.com/azure/azure-monitor/platform/autoscale-overview) for a general discussion on Azure platform autoscale.

## Take advantage of platform autoscaling features

Here's how you can benefit from autoscaling features:

- Use built-in autoscaling features when possible rather than custom or third-party mechanisms.
- Use scheduled scaling rules where possible to ensure that resources are available without a startup delay.
- Add reactive autoscaling to the rules where appropriate to cope with unexpected changes in demand.

> [!NOTE]
> Remember to use autoscaling to scale down/in resources that are no longer necessary for the given load in order to reduce operational costs.

For more information, see [Autoscaling guidance](https://review.docs.microsoft.com/azure/architecture/best-practices/auto-scaling).

If your application isn't configured to scale out automatically as load increases, it's possible that your application's services will fail if they become saturated with user requests. For more information, see the following articles: 

- General: [performance efficiency checklist](https://review.docs.microsoft.com/azure/architecture/framework/scalability/performance-efficiency)
- Azure App Service: [Scale instance count manually or automatically](https://review.docs.microsoft.com/azure/monitoring-and-diagnostics/insights-how-to-scale/)
- Cloud Services: [How to autoscale a Cloud Service](https://review.docs.microsoft.com/azure/cloud-services/cloud-services-how-to-scale/)
- Virtual machines: [Automatic scaling and virtual machine scale sets](https://review.docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview/)

## Next step

>[!div class="nextstepaction"]
>[Plan for capacity](https://review.docs.microsoft.com/en-us/azure/architecture/framework/scalability/capacity?branch=pr-en-us-1963)