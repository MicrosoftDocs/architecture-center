---
title: Criteria for choosing an Azure compute service
titleSuffix: Azure Application Architecture Guide
description: Compare Azure compute services across several axes.
author: MikeWasson
ms.date: 08/08/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom: seojan19
---

# Criteria for choosing an Azure compute service

The term *compute* refers to the hosting model for the computing resources that your applications runs on. The following tables compare Azure compute services across several axes. Refer to these tables when selecting a compute option for your application.

## Hosting model

<!-- markdownlint-disable MD033 -->

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Application composition | Agnostic | Applications, containers | Services, guest executables, containers | Functions | Containers | Containers | Scheduled jobs  |
| Density | Agnostic | Multiple apps per instance via app service plans | Multiple services per VM | Serverless <a href="#note1"><sup>1</sup></a> | Multiple containers per node |No dedicated instances | Multiple apps per VM |
| Minimum number of nodes | 1 <a href="#note2"><sup>2</sup></a>  | 1 | 5 <a href="#note3"><sup>3</sup></a> | Serverless <a href="#note1"><sup>1</sup></a> | 3 <a href="#note3"><sup>3</sup></a> | No dedicated nodes | 1 <a href="#note4"><sup>4</sup></a> |
| State management | Stateless or Stateful | Stateless | Stateless or stateful | Stateless | Stateless or Stateful | Stateless | Stateless |
| Web hosting | Agnostic | Built in | Agnostic | Not applicable | Agnostic | Agnostic | No |
| Can be deployed to dedicated VNet? | Supported | Supported<a href="#note5"><sup>5</sup></a> | Supported | Supported <a href="#note5"><sup>5</sup></a> | [Supported](/azure/aks/networking-overview) | Not supported | Supported |
| Hybrid connectivity | Supported | Supported <a href="#note6"><sup>6</sup></a>  | Supported | Supported <a href="#note7"><sup>7</sup></a> | Supported | Not supported | Supported |

Notes

1. <span id="note1">If using Consumption plan. If using App Service plan, functions run on the VMs allocated for your App Service plan. See [Choose the correct service plan for Azure Functions][function-plans].</span>
2. <span id="note2">Higher SLA with two or more instances.</span>
3. <span id="note3">Recommended for production environments.</span>
4. <span id="note4">Can scale down to zero after job completes.</span>
5. <span id="note5">Requires App Service Environment (ASE).</span>
6. <span id="note6">Use [Azure App Service Hybrid Connections][app-service-hybrid].</span>
7. <span id="note7">Requires App Service plan.</span>

## DevOps

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Local debugging | Agnostic | IIS Express, others <a href="#note1b"><sup>1</sup></a> | Local node cluster | Visual Studio or Azure Functions CLI | Minikube, others | Local container runtime | Not supported |
| Programming model | Agnostic | Web and API applications, WebJobs for background tasks | Guest executable, Service model, Actor model, Containers | Functions with triggers | Agnostic | Agnostic | Command line application |
| Application update | No built-in support | Deployment slots | Rolling upgrade (per service) | Deployment slots | Rolling update | Not applicable |

Notes

1. <span id="note1b">Options include IIS Express for ASP.NET or node.js (iisnode); PHP web server; Azure Toolkit for IntelliJ, Azure Toolkit for Eclipse. App Service also supports remote debugging of deployed web app.</span>
2. <span id="note2b">See [Resource Manager providers, regions, API versions and schemas][resource-manager-supported-services].</span>

## Scalability

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Autoscaling | Virtual machine scale sets | Built-in service | Virtual machine scale sets | Built-in service | Pod auto-scaling<a href="#note1c"><sup>1</sip></a>, cluster auto-scaling<a href="#note2c"><sup>2</sip></a> | Not supported | N/A |
| Load balancer | Azure Load Balancer | Integrated | Azure Load Balancer | Integrated | Azure Load Balancer or Application Gateway |  No built-in support | Azure Load Balancer |
| Scale limit<a href="#note3c"><sup>3</sup></a> | Platform image: 1000 nodes per scale set, Custom image: 600 nodes per scale set | 20 instances, 100 with App Service Environment | 100 nodes per scale set | 200 instances per Function app | 100 nodes per cluster (default limit) |20 container groups per subscription (default limit). | 20 core limit (default limit). |

Notes

1. <span id="note1c">See [Autoscale pods](/azure/aks/tutorial-kubernetes-scale#autoscale-pods).</span>
2. <span id="note2c">See [Automatically scale a cluster to meet application demands on Azure Kubernetes Service (AKS)](/azure/aks/cluster-autoscaler).</span>
3. <span id="note3c">See [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits)</span>.

## Availability

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| SLA | [SLA for Virtual Machines][sla-vm] | [SLA for App Service][sla-app-service] | [SLA for Service Fabric][sla-sf] | [SLA for Functions][sla-functions] | [SLA for AKS][sla-acs] | [SLA for Container Instances](https://azure.microsoft.com/support/legal/sla/container-instances/) | [SLA for Azure Batch][sla-batch] |
| Multi region failover | Traffic manager | Traffic manager | Traffic manager, Multi-Region Cluster | Not supported | Traffic manager | Not supported | Not Supported |

For guided learning on Service Guarantees, review [Core Cloud Services - Azure architecture and service guarantees](/learn/modules/explore-azure-infrastructure).

## Other

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| SSL | Configured in VM | Supported | Supported  | Supported | [Ingress controller](/azure/aks/ingress) | Use [sidecar](../../patterns/sidecar.md) container | Supported |
| Cost | [Windows][cost-windows-vm], [Linux][cost-linux-vm] | [App Service pricing][cost-app-service] | [Service Fabric pricing][cost-service-fabric] | [Azure Functions pricing][cost-functions] | [AKS pricing][cost-acs] | [Container Instances pricing](https://azure.microsoft.com/pricing/details/container-instances/) | [Azure Batch pricing][cost-batch]
| Suitable architecture styles | [N-Tier][n-tier], [Big compute][big-compute] (HPC) | [Web-Queue-Worker][w-q-w], [N-Tier][n-tier] | [Microservices][microservices], [Event-driven architecture][event-driven] | [Microservices][microservices], [Event-driven architecture][event-driven] | [Microservices][microservices], [Event-driven architecture][event-driven] | [Microservices][microservices], task automation, batch jobs  | [Big compute][big-compute] (HPC) |



<!-- markdownlint-enable MD033 -->

[cost-linux-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/linux/
[cost-windows-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/windows/
[cost-app-service]: https://azure.microsoft.com/pricing/details/app-service/
[cost-service-fabric]: https://azure.microsoft.com/pricing/details/service-fabric/
[cost-functions]: https://azure.microsoft.com/pricing/details/functions/
[cost-acs]: https://azure.microsoft.com/pricing/details/kubernetes-service/
[cost-batch]: https://azure.microsoft.com/pricing/details/batch/

[function-plans]: /azure/azure-functions/functions-scale
[sla-acs]: https://azure.microsoft.com/support/legal/sla/kubernetes-service
[sla-app-service]: https://azure.microsoft.com/support/legal/sla/app-service/
[sla-batch]: https://azure.microsoft.com/support/legal/sla/batch/
[sla-functions]: https://azure.microsoft.com/support/legal/sla/functions/
[sla-sf]: https://azure.microsoft.com/support/legal/sla/service-fabric/
[sla-vm]: https://azure.microsoft.com/support/legal/sla/virtual-machines/

[resource-manager-supported-services]: /azure/azure-resource-manager/resource-manager-supported-services
[scale-acs]: /azure/container-service/kubernetes/container-service-scale#scaling-considerations

[n-tier]: ../architecture-styles/n-tier.md
[w-q-w]: ../architecture-styles/web-queue-worker.md
[microservices]: ../architecture-styles/microservices.md
[event-driven]: ../architecture-styles/event-driven.md
[big-date]: ../architecture-styles/big-data.md
[big-compute]: ../architecture-styles/big-compute.md

[app-service-hybrid]: /azure/app-service/app-service-hybrid-connections
