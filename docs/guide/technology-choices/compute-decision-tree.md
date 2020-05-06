---
title: Choosing an Azure compute service
description: A flowchart for selecting a compute service.
author: MikeWasson
ms.date: 01/10/2020
ms.topic: guide
ms.service: architecture-center
ms.category:
  - compute
ms.subservice: reference-architecture
---

# Choose an Azure compute service for your application

Azure offers a number of ways to host your application code. The term *compute* refers to the hosting model for the computing resources that your application runs on. The following flowchart will help you to choose a compute service for your application.

If your application consists of multiple workloads, evaluate each workload separately. A complete solution may incorporate two or more compute services.

## Choose a candidate service

Use the following flowchart to select a candidate compute service.

![Decision tree for Azure compute services](../images/compute-decision-tree.svg)

Definitions:

- **"Lift and shift"** is a strategy for migrating a workload to the cloud without redesigning the application or making code changes. Also called *rehosting*. For more information, see [Azure migration center](https://azure.microsoft.com/migration/).
- **Cloud optimized** is a strategy for migrating to the cloud by refactoring an application to take advantage of cloud-native features and capabilities.

The output from this flowchart is a **starting point** for consideration. Next, perform a more detailed evaluation of the service to see if it meets your needs. 

## Understand the basic features

If you're not familiar with the Azure service selected in the previous step, read the overview documentation to understand the basics of the service.

- [App Service](https://docs.microsoft.com/azure/app-service/). A managed service for hosting web apps, mobile app back ends, RESTful APIs, or automated business processes.
- [Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/intro-kubernetes) (AKS). A managed Kubernetes service for running containerized applications.
- [Batch](https://docs.microsoft.com/azure/batch/batch-technical-overview). A managed service for running large-scale parallel and high-performance computing (HPC) applications
- [Container Instances](https://docs.microsoft.com/azure/container-instances/container-instances-overview). The fastest and simplest way to run a container in Azure, without having to provision any virtual machines and without having to adopt a higher-level service.
- [Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview). A managed FaaS service.
- [Service Fabric](https://docs.microsoft.com/azure/service-fabric/service-fabric-overview). A distributed systems platform that can run in many environments, including Azure or on premises.
- [Virtual machines](https://docs.microsoft.com/azure/virtual-machines/). Deploy and manage VMs inside an Azure virtual network.

## Understand the hosting models

Cloud services, including Azure services, generally fall into three categories: IaaS, PaaS, or FaaS. (There is also SaaS, software-as-a-service, which is out of scope for this article.) It's useful to understand the differences.

**Infrastructure-as-a-Service** (IaaS) lets you provision individual VMs along with the associated networking and storage components. Then you deploy whatever software and applications you want onto those VMs. This model is the closest to a traditional on-premises environment, except that Microsoft manages the infrastructure. You still manage the individual VMs.

**Platform-as-a-Service** (PaaS) provides a managed hosting environment, where you can deploy your application without needing to manage VMs or networking resources. Azure App Service is a PaaS service.

**Functions-as-a-Service** (FaaS) goes even further in removing the need to worry about the hosting environment. In a FaaS model, you simply deploy your code and the service automatically runs it. Azure Functions are a FaaS service.

There is a spectrum from IaaS to pure PaaS. For example, Azure VMs can autoscale by using virtual machine scale sets. This automatic scaling capability isn't strictly PaaS, but it's the type of management feature found in PaaS services. 

In general, there is a tradeoff between control and ease of management. IaaS gives the most control, flexibility, and portability, but you have to provision, configure and manage the VMs and network components you create. FaaS services automatically manage nearly all aspects of running an application. PaaS services fall somewhere in between.

## Consider limits and cost

Next, perform a more detailed evaluation, looking at the following aspects of the service:

- [Service limits](https://docs.microsoft.com/azure/azure-subscription-service-limits)
- [Cost](https://azure.microsoft.com/pricing/)
- [SLA](https://azure.microsoft.com/support/legal/sla/)
- [Regional availability](https://azure.microsoft.com/global-infrastructure/services/)

Based on this analysis, you may find that the initial candidate isn't suitable for your particular application or workload. In that case, expand your analysis to include other compute services.

The following tables contain additional comparison points, which may be useful when choosing.

### Hosting model

<!-- markdownlint-disable MD033 -->

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Application composition | Agnostic | Applications, containers | Services, guest executables, containers | Functions | Containers | Containers | Scheduled jobs  |
| Density | Agnostic | Multiple apps per instance via app service plans | Multiple services per VM | Serverless <a href="#note1"><sup>1</sup></a> | Multiple containers per node |No dedicated instances | Multiple apps per VM |
| Minimum number of nodes | 1 <a href="#note2"><sup>2</sup></a>  | 1 | 5 <a href="#note3"><sup>3</sup></a> | Serverless <a href="#note1"><sup>1</sup></a> | 3 <a href="#note3"><sup>3</sup></a> | No dedicated nodes | 1 <a href="#note4"><sup>4</sup></a> |
| State management | Stateless or Stateful | Stateless | Stateless or stateful | Stateless | Stateless or Stateful | Stateless | Stateless |
| Web hosting | Agnostic | Built in | Agnostic | Not applicable | Agnostic | Agnostic | No |
| Can be deployed to dedicated VNet? | Supported | Supported<a href="#note5"><sup>5</sup></a> | Supported | Supported <a href="#note5"><sup>5</sup></a> | [Supported](https://docs.microsoft.com/azure/aks/networking-overview) | Not supported | Supported |
| Hybrid connectivity | Supported | Supported <a href="#note6"><sup>6</sup></a>  | Supported | Supported <a href="#note7"><sup>7</sup></a> | Supported | Not supported | Supported |

Notes

1. <span id="note1">If using Consumption plan. If using App Service plan, functions run on the VMs allocated for your App Service plan. See [Choose the correct service plan for Azure Functions][function-plans].</span>
2. <span id="note2">Higher SLA with two or more instances.</span>
3. <span id="note3">Recommended for production environments.</span>
4. <span id="note4">Can scale down to zero after job completes.</span>
5. <span id="note5">Requires App Service Environment (ASE).</span>
6. <span id="note6">Use [Azure App Service Hybrid Connections][app-service-hybrid].</span>
7. <span id="note7">Requires App Service plan.</span>

### DevOps

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Local debugging | Agnostic | IIS Express, others <a href="#note1b"><sup>1</sup></a> | Local node cluster | Visual Studio or Azure Functions CLI | Minikube, others | Local container runtime | Not supported |
| Programming model | Agnostic | Web and API applications, WebJobs for background tasks | Guest executable, Service model, Actor model, Containers | Functions with triggers | Agnostic | Agnostic | Command line application |
| Application update | No built-in support | Deployment slots | Rolling upgrade (per service) | Deployment slots | Rolling update | Not applicable |

Notes

1. <span id="note1b">Options include IIS Express for ASP.NET or node.js (iisnode); PHP web server; Azure Toolkit for IntelliJ, Azure Toolkit for Eclipse. App Service also supports remote debugging of deployed web app.</span>
2. <span id="note2b">See [Resource Manager providers, regions, API versions and schemas][resource-manager-supported-services].</span>

### Scalability

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| Autoscaling | Virtual machine scale sets | Built-in service | Virtual machine scale sets | Built-in service | Pod auto-scaling<a href="#note1c"><sup>1</sip></a>, cluster auto-scaling<a href="#note2c"><sup>2</sip></a> | Not supported | N/A |
| Load balancer | Azure Load Balancer | Integrated | Azure Load Balancer | Integrated | Azure Load Balancer or Application Gateway |  No built-in support | Azure Load Balancer |
| Scale limit<a href="#note3c"><sup>3</sup></a> | Platform image: 1000 nodes per scale set, Custom image: 600 nodes per scale set | 20 instances, 100 with App Service Environment | 100 nodes per scale set | 200 instances per Function app | 100 nodes per cluster (default limit) |20 container groups per subscription (default limit). | 20 core limit (default limit). |

Notes

1. <span id="note1c">See [Autoscale pods](https://docs.microsoft.com/azure/aks/tutorial-kubernetes-scale#autoscale-pods).</span>
2. <span id="note2c">See [Automatically scale a cluster to meet application demands on Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/cluster-autoscaler).</span>
3. <span id="note3c">See [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/azure/azure-subscription-service-limits)</span>.

### Availability

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| SLA | [SLA for Virtual Machines][sla-vm] | [SLA for App Service][sla-app-service] | [SLA for Service Fabric][sla-sf] | [SLA for Functions][sla-functions] | [SLA for AKS][sla-acs] | [SLA for Container Instances](https://azure.microsoft.com/support/legal/sla/container-instances/) | [SLA for Azure Batch][sla-batch] |
| Multi region failover | Traffic manager | Traffic manager | Traffic manager, Multi-Region Cluster | Not supported | Traffic manager | Not supported | Not Supported |

For guided learning on Service Guarantees, review [Core Cloud Services - Azure architecture and service guarantees](https://docs.microsoft.com/learn/modules/explore-azure-infrastructure).

### Other criteria

| Criteria | Virtual Machines | App Service | Service Fabric | Azure Functions | Azure Kubernetes Service | Container Instances | Azure Batch |
|----------|-----------------|-------------|----------------|-----------------|-------------------------|----------------|-------------|
| SSL | Configured in VM | Supported | Supported  | Supported | [Ingress controller](https://docs.microsoft.com/azure/aks/ingress) | Use [sidecar](../../patterns/sidecar.md) container | Supported |
| Cost | [Windows][cost-windows-vm], [Linux][cost-linux-vm] | [App Service pricing][cost-app-service] | [Service Fabric pricing][cost-service-fabric] | [Azure Functions pricing][cost-functions] | [AKS pricing][cost-acs] | [Container Instances pricing](https://azure.microsoft.com/pricing/details/container-instances/) | [Azure Batch pricing][cost-batch]
| Suitable architecture styles | [N-Tier][n-tier], [Big compute][big-compute] (HPC) | [Web-Queue-Worker][w-q-w], [N-Tier][n-tier] | [Microservices][microservices], [Event-driven architecture][event-driven] | [Microservices][microservices], [Event-driven architecture][event-driven] | [Microservices][microservices], [Event-driven architecture][event-driven] | [Microservices][microservices], task automation, batch jobs  | [Big compute][big-compute] (HPC) |

The output from this flowchart is a **starting point** for consideration. Next, perform a more detailed evaluation of the service to see if it meets your needs. 

## Understand the basic features

If you're not familiar with the Azure service selected in the previous step, read one of the following overview articles:

- [App Service](https://docs.microsoft.com/azure/app-service/)
- [Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/intro-kubernetes)
- [Batch](https://docs.microsoft.com/azure/batch/batch-technical-overview)
- [Container Instances](https://docs.microsoft.com/azure/container-instances/container-instances-overview)
- [Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview)
- [Service Fabric](https://docs.microsoft.com/azure/service-fabric/service-fabric-overview)
- [Virtual machines](https://docs.microsoft.com/azure/virtual-machines/)

## Consider limits and cost

Next, perform a more detailed evaluation, looking at the following aspects of the service:

- [Service limits](https://docs.microsoft.com/azure/azure-subscription-service-limits)
- [Cost](https://azure.microsoft.com/pricing/)
- [SLA](https://azure.microsoft.com/support/legal/sla/)
- [Regional availability](https://azure.microsoft.com/global-infrastructure/services/)
- [Compute comparison tables](./compute-decision-tree.md)

Based on this analysis, you may find that the initial candidate isn't suitable for your particular application or workload. In that case, expand your analysis to include other compute services. 

## Next steps

- [Core Cloud Services - Azure compute options](https://docs.microsoft.com/learn/modules/intro-to-azure-compute/). This Microsoft Learn module explores how compute services can solve common business needs. 

[cost-linux-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/linux
[cost-windows-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/windows
[cost-app-service]: https://azure.microsoft.com/pricing/details/app-service
[cost-service-fabric]: https://azure.microsoft.com/pricing/details/service-fabric
[cost-functions]: https://azure.microsoft.com/pricing/details/functions
[cost-acs]: https://azure.microsoft.com/pricing/details/kubernetes-service
[cost-batch]: https://azure.microsoft.com/pricing/details/batch

[function-plans]: https://docs.microsoft.com/azure/azure-functions/functions-scale
[sla-acs]: https://azure.microsoft.com/support/legal/sla/kubernetes-service
[sla-app-service]: https://azure.microsoft.com/support/legal/sla/app-service
[sla-batch]: https://azure.microsoft.com/support/legal/sla/batch
[sla-functions]: https://azure.microsoft.com/support/legal/sla/functions
[sla-sf]: https://azure.microsoft.com/support/legal/sla/service-fabric
[sla-vm]: https://azure.microsoft.com/support/legal/sla/virtual-machines

[resource-manager-supported-services]: https://docs.microsoft.com/azure/azure-resource-manager/resource-manager-supported-services

[n-tier]: ../architecture-styles/n-tier.md
[w-q-w]: ../architecture-styles/web-queue-worker.md
[microservices]: ../architecture-styles/microservices.md
[event-driven]: ../architecture-styles/event-driven.md
[big-compute]: ../architecture-styles/big-compute.md

[app-service-hybrid]: https://docs.microsoft.com/azure/app-service/app-service-hybrid-connections
