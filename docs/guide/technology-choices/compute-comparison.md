---
title: Criteria for choosing an Azure compute option
description: Compare Azure compute services across several axes.
author: MikeWasson
layout: LandingPage
---

# Criteria for choosing an Azure compute option

The term *compute* refers to the hosting model for the computing resources that your applications runs on. The following tables compare Azure compute services across several axes. Refer to these tables when selecting a compute option for your application.

## Hosting model

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Container Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Application composition | Agnostic | Applications | Services, guest executables, containers | Functions | Containers | Containers | Scheduled jobs  |
| Density | Agnostic | Multiple apps per instance via app plans | Multiple services per VM | No dedicated instances <a href="#note1"><sup>1</sup></a> | Multiple containers per VM |No dedicated instances | Multiple apps per VM |
| Minimum number of nodes | 1 <a href="#note2"><sup>2</sup></a>  | 1 | 5 <a href="#note3"><sup>3</sup></a> | No dedicated nodes <a href="#note1"><sup>1</sup></a> | 3 | No dedicated nodes | 1 <a href="#note4"><sup>4</sup></a> |
| State management | Stateless or Stateful | Stateless | Stateless or stateful | Stateless | Stateless or Stateful | Stateless | Stateless |
| Web hosting | Agnostic | Built in | Agnostic | Not applicable | Agnostic | Agnostic | No |
| OS | Windows, Linux | Windows, Linux  | Windows, Linux | Not applicable | Windows (preview),  Linux | Windows, Linux | Windows, Linux |
| Can be deployed to dedicated VNet? | Supported | Supported <a href="#note5"><sup>5</sup></a> | Supported | Not supported | Supported | Not supported | Supported |
| Hybrid connectivity | Supported | Supported <a href="#note1"><sup>6</sup></a>  | Supported | Not supported | Supported | Not supported | Supported |

Notes

1. <span id="note1">If using Consumption plan. If using App Service plan, functions run on the VMs allocated for your App Service plan. See [Choose the correct service plan for Azure Functions][function-plans].</a>
2. <span id="note2">Higher SLA with two or more instances.</a>
3. <span id="note3">For production environments.</a>
4. <span id="note4">Can scale down to zero after job completes.</a>
5. <span id="note5">Requires App Service Environment (ASE).</a>
6. <span id="note7">Requires ASE or BizTalk Hybrid Connections</a>

## DevOps

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Container Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Local debugging | Agnostic | IIS Express, others <a href="#note1b"><sup>1</sup></a> | Local node cluster | Azure Functions CLI | Local container runtime | Local container runtime | Not supported |
| Programming model | Agnostic | Web application, WebJobs for background tasks | Guest executable, Service model, Actor model, Containers | Functions with triggers | Agnostic | Agnostic | Command line application |
| Application update | No built-in support | Deployment slots | Rolling upgrade (per service) | No built-in support | Depends on orchestrator. Most support rolling updates | Update container image | Not applicable |

Notes

1. <span id="note1b">Options include IIS Express for ASP.NET or node.js (iisnode); PHP web server; Azure Toolkit for IntelliJ, Azure Toolkit for Eclipse. App Service also supports remote debugging of deployed web app.</a>
2. <span id="note2b">See [Resource Manager providers, regions, API versions and schemas][resource-manager-supported-services]. 


## Scalability

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Container Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Auto-scaling | VM scale sets | Built-in service | VM Scale Sets | Built-in service | Not supported | Not supported | N/A |
| Load balancer | Azure Load Balancer | Integrated | Azure Load Balancer | Integrated | Azure Load Balancer |  No built-in support | Azure Load Balancer |
| Scale limit | Platform image: 1000 nodes per VMSS, Custom image: 100 nodes per VMSS | 20 instances, 50 with App Service Environment | 100 nodes per VMSS | Infinite <a href="#note1c"><sup>1</sup></a> | 100 |20 container groups per subscription <a href="#note2c"><sup>2</sup></a> | 20 core limit by default. Contact customer service for increase. |

Notes

1. <span id="note1c">If using Consumption plan. If using App Service plan, the App Service scale limits apply. See [Choose the correct service plan for Azure Functions][function-plans].</a>
2. <span id="note2c">See [Quotas and region availability for Azure Container Instances](/azure/container-instances/container-instances-quotas).</a>


## Availability

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Container Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| SLA | [SLA for Virtual Machines][sla-vm] | [SLA for App Service][sla-app-service] | [SLA for Service Fabric][sla-sf] | [SLA for Functions][sla-functions] | [SLA for Azure Container Service][sla-acs] | [SLA for Container Instances](https://azure.microsoft.com/support/legal/sla/container-instances/) | [SLA for Azure Batch][sla-batch] |
| Multi region failover | Traffic manager | Traffic manager | Traffic manager, Multi-Region Cluster | Not supported	 | Traffic manager | Not supported | Not Supported |

## Other

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Container Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| SSL | Configured in VM | Supported | Supported  | Supported | Configured in VM | Not supported | Supported |
| Cost | [Windows][cost-windows-vm], [Linux][cost-linux-vm] | [App Service pricing][cost-app-service] | [Service Fabric pricing][cost-service-fabric] | [Azure Functions pricing][cost-functions] | [Azure Container Service pricing][cost-acs] | [Container Instances pricing](https://azure.microsoft.com/pricing/details/container-instances/) | [Azure Batch pricing][cost-batch]
| Suitable architecture styles | N-Tier, Big compute (HPC) | Web-Queue-Worker | Microservices, Event driven architecture (EDA) | Microservices, EDA | Microservices, EDA | Microservices, task automation, batch jobs  | Big Compute |

[cost-linux-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/linux/
[cost-windows-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/windows/
[cost-app-service]: https://azure.microsoft.com/pricing/details/app-service/
[cost-service-fabric]: https://azure.microsoft.com/pricing/details/service-fabric/
[cost-functions]: https://azure.microsoft.com/pricing/details/functions/
[cost-acs]: https://azure.microsoft.com/pricing/details/container-service/
[cost-batch]: https://azure.microsoft.com/pricing/details/batch/

[function-plans]: /azure/azure-functions/functions-scale
[sla-acs]: https://azure.microsoft.com/support/legal/sla/container-service/
[sla-app-service]: https://azure.microsoft.com/support/legal/sla/app-service/
[sla-batch]: https://azure.microsoft.com/support/legal/sla/batch/
[sla-functions]: https://azure.microsoft.com/support/legal/sla/functions/
[sla-sf]: https://azure.microsoft.com/support/legal/sla/service-fabric/
[sla-vm]: https://azure.microsoft.com/support/legal/sla/virtual-machines/

[resource-manager-supported-services]: /azure/azure-resource-manager/resource-manager-supported-services