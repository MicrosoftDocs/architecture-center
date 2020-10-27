---
title: scaling for performance efficiency
description: Describes the scaling options for performance efficiency
author: v-aangie
ms.date: 10/29/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom: 
---

# Design for scaling

Scaling allows applications to react to variable load by increasing and decreasing the number of instances of roles, queues, and other services. However, the application must be designed with this in mind. For example, the application and the services it uses must be stateless to allow requests to be routed to any instance. Having stateless services also means that adding or removing an instance doesn't adversely impact current users.

## Plan for growth with scale units

For each resource, know the upper scaling limits, and use [sharding](https://docs.microsoft.com/azure/azure-sql/database/elastic-scale-introduction#sharding) or decomposition to go beyond those limits. Design the application so that it's easily scaled by adding one or more [scale units](https://docs.microsoft.com/archive/msdn-magazine/2017/february/azure-inside-the-azure-app-service-architecture#what-is-an-app-service-scale-unit). Determine the scale units for the system in terms of well-defined sets of resources. This makes applying scale-out operations easier and less prone to negative impact caused by a lack of resources in some part of the overall system. For example, adding X number of front-end VMs might require Y number of additional queues and Z number of storage accounts to handle the additional workload. So a scale unit could consist of X VM instances, Y queues, and Z storage accounts.

## Use autoscaling to manage load increases and decreases

Autoscaling enables you to run the right amount of resources to handle the load of your app. It adds resources (called scaling out) to handle an increase in load such as seasonal workloads and customer facing applications. Autoscaling saves money by removing idle resources (called scaling in) during a decrease in load such as during nights and weekends for some corporate apps.

Many of the compute offerings in Azure offer autoscale to ensure the right amount of resources are available to meet service user demand. This includes virtual machine scale sets, app service web apps, and API management services. This is critical for the service user experience.

The way it works is that metrics are collected for the resource (CPU and memory utilization) and the application (requests queued and requests per second). Rules can then be created off those metrics and time schedules to add and remove instances depending on how the rule evaluates. An [App Services](https://docs.microsoft.com/azure/app-service/overview-hosting-plans#how-does-my-app-run-and-scale) App Plan allows autoscale rules to be set for scale-out and scale-in.

[Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/intro-kubernetes) (AKS) offers two levels of autoscale:

- **Horizontal autoscale** - Can be enabled on service containers to add more or fewer pod instances within the cluster.

- **Cluster autoscale** - Can be enabled on the agent VM instances running an agent node-pool to add more or remove VM instances dynamically.

[Azure Service Fabric](https://docs.microsoft.com/azure/service-fabric/service-fabric-overview) has similar offerings and virtual machine scale sets offers autoscale capabilities for true IaaS scenarios. In addition, [Azure App Gateway](https://docs.microsoft.com/azure/application-gateway/overview) and [Azure API Management](https://docs.microsoft.com/azure/api-management/api-management-key-concepts) are PaaS offerings for ingress services that enable autoscale. Also, [Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview), [Azure Logic Apps](https://docs.microsoft.com/azure/logic-apps/logic-apps-overview), and [App Services](https://docs.microsoft.com/azure/app-service/overview) offer serverless pay-per-use consumption modeling that inherently provide autoscale.

Each service documents its autoscale capabilities. Review [Autoscale overview](https://docs.microsoft.com/azure/azure-monitor/platform/autoscale-overview) for a general discussion on Azure platform autoscale.

## Take advantage of platform autoscaling features

Here's how you can benefit from autoscaling features:

- Use built-in autoscaling features when possible rather than custom or third-party mechanisms.
- Use scheduled scaling rules where possible to ensure that resources are available without a startup delay.
- Add reactive autoscaling to the rules where appropriate to cope with unexpected changes in demand.

For more information, see [Autoscaling guidance](https://review.docs.microsoft.com/azure/architecture/best-practices/auto-scaling).

If your application isn't configured to scale out automatically as load increases, it's possible that your application's services will fail if they become saturated with user requests. For more information, see the following articles:

- General: [performance efficiency checklist](https://review.docs.microsoft.com/azure/architecture/framework/scalability/performance-efficiency)
- Azure App Service: [Scale instance count manually or automatically](https://review.docs.microsoft.com/azure/monitoring-and-diagnostics/insights-how-to-scale/)
- Cloud Services: [How to autoscale a Cloud Service](https://review.docs.microsoft.com/azure/cloud-services/cloud-services-how-to-scale/)
- Virtual machines: [Automatic scaling and virtual machine scale sets](https://review.docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview/)

<!--[## Next steps

[!div class="nextstepaction"]
LINK to next Design article]()-->