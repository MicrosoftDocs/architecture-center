---
title: Choose an Azure Compute Service
description: Use this chart and other information to decide which compute service, or hosting model for computing resources, best suits your application.
author: stephen-sumner
ms.author: pnp
ms.date: 02/04/2025
ms.reviewer: ssumner
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
- arb-web
- fcp
- linux-related-content
---

# Choose an Azure compute service

Azure provides many ways to host your application code. The term *compute* refers to the hosting model for the resources that your application runs on. This article helps you choose a compute service for your application.

## Architecture

Use the following flowchart to select a candidate compute service.

:::image type="complex" border="false" source="images/compute-choices.svg" alt-text="Diagram that shows a decision tree for Azure compute services." lightbox="images/compute-choices.svg":::
   The image shows a flowchart for selecting an appropriate Azure service based on whether the user is migrating an existing workload or building a new one. The flowchart begins with a Start node and splits into two primary branches labeled Migrate and Build new. The Migrate branch includes decision points that assess whether the application is optimized for the cloud and whether it can be lifted and shifted. Depending on the answers, the flow leads to services such as Azure App Service, Azure VMware Solution, or Virtual Machines. The Build new branch includes decision points that evaluate the need for full control, high-performance computing, event-driven workloads, managed web hosting, and orchestration requirements. These decisions guide the user toward services such as Virtual Machines, Azure Batch, Azure Functions, App Service, Azure Container Instances, Azure Service Fabric, Azure Red Hat OpenShift, Azure Kubernetes Service, or Azure Container Apps. A branching section for your own orchestration implementation on Virtual Machines includes VMware Tanzu on Virtual Machines, Kubernetes on Virtual Machines, and OpenShift on Virtual Machines. At the bottom of the image, two boxed sections list container-exclusive services and container-compatible services. The container-exclusive section includes Azure Container Instances, Azure Red Hat OpenShift, Kubernetes on Virtual Machines, OpenShift on Virtual Machines, and VMware Tanzu on Virtual Machines. The container-compatible section includes Azure Batch, Azure Functions, Service Fabric, and App Service.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/compute-choices.vsdx) of this architecture.*

The previous diagram refers to two migration strategies:

- **Lift and shift:** A strategy for migrating a workload to the cloud without redesigning the application or making code changes. It's also known as *rehosting*. For more information, see [Azure cloud migration and modernization center](https://azure.microsoft.com/migration).

- **Cloud optimized:** A strategy for migrating to the cloud by refactoring an application to take advantage of cloud-native features and capabilities.

The output from this flowchart is your starting point. Next, evaluate the service to see if it meets your needs.

This article includes several tables that can help you choose a service. The initial candidate from the flowchart might be unsuitable for your application or workload. In that case, expand your analysis to include other compute services.

If your application consists of multiple workloads, evaluate each workload separately. A complete solution can incorporate two or more compute services.

## Understand the basic features

If you're not familiar with the Azure service that you select in the previous section, see the following overview documentation:

- [Azure App Service](/azure/app-service) is a managed service for hosting web apps, mobile app back ends, RESTful APIs, or automated business processes.

- [Azure Batch](/azure/batch/batch-technical-overview) is a managed service for running large-scale parallel and high-performance computing (HPC) applications.

- [Azure Container Apps](/azure/container-apps) is a managed service built on Kubernetes, which simplifies the deployment of containerized applications in a serverless environment.

- [Azure Container Instances](/azure/container-instances/container-instances-overview) is a service for running a single container or group of containers in Azure. Container Instances doesn't provide full container orchestration, but you can implement containers without having to provision virtual machines (VMs) or adopt a higher-level service.

- [Azure Functions](/azure/azure-functions/functions-overview) is a service that provides managed functions that run based on a variety of trigger types for event-driven applications.

- [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) is a managed Kubernetes service for running containerized applications.

- [Azure Red Hat OpenShift](/azure/openshift) is a fully managed OpenShift cluster for running containers in production with Kubernetes.

- [Azure Service Fabric](/azure/service-fabric/service-fabric-overview) is a distributed systems platform that can run in many environments, including Azure or on-premises.

- [Azure VMware Solution](/azure/azure-vmware/introduction) is a managed service for running VMware workloads natively on Azure.

- [Azure Virtual Machines](/azure/virtual-machines) is a service where you deploy and manage VMs inside an Azure virtual network.

## Understand the hosting models

For hosting models, cloud services fall into three categories:

- **Infrastructure as a service (IaaS)** lets you provision VMs along with the associated networking and storage components. Then you can deploy any software and applications on those VMs. This model is the closest to a traditional on-premises environment. Microsoft manages the infrastructure, and you manage the VMs.

- **Platform as a service (PaaS)** provides a managed hosting environment where you can deploy your application without needing to manage VMs or networking resources. App Service and Container Apps are PaaS services.

- **Functions as a service (FaaS)** lets you deploy your code to the service, which automatically runs it. Azure Functions is a FaaS service.

  > [!NOTE]
  > Azure Functions is an [Azure serverless](https://azure.microsoft.com/solutions/serverless/#solutions) compute offering. To see how this service compares with other Azure serverless offerings, such as Azure Logic Apps for serverless workflows, see [Choose the right integration and automation services in Azure](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs).

There's a spectrum from IaaS to fully managed PaaS. For example, Azure VMs can automatically scale by using virtual machine scale sets. This capability isn't strictly PaaS, but it resembles the management features in PaaS.

There's a trade-off between control and ease of management. IaaS provides the most control, flexibility, and portability. However, you have to provision, configure, and manage the VMs and network components that you create. FaaS services automatically manage nearly all aspects of running an application. PaaS provides partial management while requiring some user configuration.

| Service | Application composition | Density | Minimum number of nodes | State management | Web hosting |
|---|---|---|---|---|---|
| Virtual Machines | Agnostic | Agnostic | 1 <a href="#note2"><sup>2</sup></a> | Stateless or stateful | Agnostic |
| App Service | Applications, containers | Multiple apps for each instance by using App Service plan | 1 | Stateless | Built-in |
| Azure Functions | Functions, containers | Serverless <a href="#note1"><sup>1</sup></a> | Serverless <a href="#note1"><sup>1</sup></a> | Stateless or stateful <a href="#note6"><sup>6</sup></a> | Not applicable |
| AKS | Containers | Multiple containers for each node | 3 <a href="#note3"><sup>3</sup></a> | Stateless or stateful | Agnostic |
| Container Apps | Containers | Serverless | Serverless | Stateless or stateful | Agnostic |
| Container Instances | Containers | No dedicated instances | No dedicated nodes | Stateless | Agnostic |
| Azure Red Hat OpenShift | Containers | Multiple containers for each node | 6 <a href="#note5"><sup>5</sup></a> | Stateless or stateful | Agnostic |
| Service Fabric | Services, guest executables, containers | Multiple services for each VM | 5 <a href="#note3"><sup>3</sup></a> | Stateless or stateful | Agnostic |
| Batch | Scheduled jobs | Multiple apps for each VM | 1 <a href="#note4"><sup>4</sup></a> | Stateless | No |
| Azure VMware Solution | Agnostic | Agnostic | 3 <a href="#note7"><sup>7</sup></a> | Stateless or stateful | Agnostic |

**Notes:**

<sup>1</sup> <span id="note1">For Azure Functions, the Consumption plan is serverless. For an App Service plan, functions run on the VMs allocated for that plan. [Choose the correct service plan for Azure Functions][function-plans].</span>

<sup>2</sup> <span id="note2">Higher service-level agreement (SLA) that has two or more instances.</span>

<sup>3</sup> <span id="note3">Recommended for production environments.</span>

<sup>4</sup> <span id="note4">Can scale down to zero after the job completes.</span>

<sup>5</sup> <span id="note5">Three primary nodes and three worker nodes.</span>

<sup>6</sup> <span id="note6">When you use [durable functions][durable-functions].</span>

<sup>7</sup> <span id="note7">See [Hosts][azure-vmware-plans].</span>

## Networking

| Service | Virtual network integration | Hybrid connectivity |
|----------|-----------------|-------------|
| Virtual Machines | Supported | Supported |
| App Service | Supported <a href="#note1b"><sup>1</sup></a> | Supported <a href="#note2b"><sup>2</sup></a> |
| Azure Functions | Supported <a href="#note1b"><sup>1</sup></a> | Supported <a href="#note3b"><sup>3</sup></a> |
| AKS | [Supported](/azure/aks/networking-overview) | Supported |
| Container Apps | Supported | Supported |
| Container Instances | [Supported](/azure/container-instances/container-instances-vnet) | [Supported](/azure/container-instances/container-instances-virtual-network-concepts#scenarios)  |
| Azure Red Hat OpenShift | [Supported](/azure/openshift/concepts-networking) | Supported |
| Service Fabric | Supported | Supported |
| Batch | Supported | Supported |
| Azure VMware Solution | [Supported](/azure/azure-vmware/configure-site-to-site-vpn-gateway) | [Supported](/azure/azure-vmware/enable-managed-snat-for-workloads) |

**Notes:**

<sup>1</sup> <span id="note1b">Requires App Service Environment or a dedicated compute pricing tier.</span>

<sup>2</sup> <span id="note2b">Use [App Service Hybrid Connections][app-service-hybrid].</span>

<sup>3</sup> <span id="note3b">Requires an App Service plan or [Azure Functions Premium plan][func-premium].</span>

## DevOps

| Service | Local debugging | Programming model | Application update |
|---|---|---|---|
| Virtual Machines | Agnostic | Agnostic | No built-in support |
| App Service | IIS Express, others <a href="#note1c"><sup>1</sup></a> | Web and API applications, WebJobs for background tasks | Deployment slots |
| Azure Functions | Visual Studio or Azure Functions CLI | Serverless, event-driven | Deployment slots |
| AKS | Minikube, Docker, others | Agnostic | Rolling update |
| Container Apps | Local container runtime | Agnostic | Revision management |
| Container Instances | Local container runtime | Agnostic | Not applicable |
| Azure Red Hat OpenShift | Minikube, Docker, others | Agnostic | Rolling update |
| Service Fabric | Local node cluster | Guest executable, Service model, Actor model, containers | Rolling upgrade for each service |
| Batch | Not supported | Command-line application | Not applicable |
| Azure VMware Solution | Agnostic | Agnostic | No built-in support |

**Note:**

<sup>1</sup> <span id="note1c">Options include IIS Express for ASP.NET or node.js (iisnode), PHP web server, Azure Toolkit for IntelliJ, and Azure Toolkit for Eclipse. App Service also supports remote debugging of deployed web apps.</span>

## Scalability

| Service | Autoscaling | Load balancer | Scale limit<a href="#note3d"><sup>3</sup></a> |
|---|---|---|---|
| Virtual Machines | Virtual machine scale sets | Azure Load Balancer | Platform image: 1,000 nodes for each scale set. Custom image: 600 nodes for each scale set. |
| App Service | Built-in service | Integrated | 30 instances, 100 with App Service Environment |
| Azure Functions | Built-in service | Integrated | 200 instances for each function app |
| AKS | Pod autoscaling<a href="#note1d"><sup>1</sup></a>, cluster autoscaling<a href="#note2d"><sup>2</sup></a> | Load Balancer or Azure Application Gateway | 5,000 nodes when you use [uptime SLA][uptime-sla] |
| Container Apps | Scaling rules<a href="#note4d"><sup>4</sup></a> | Integrated | 15 environments for each region (default limit), unlimited container apps for each environment and replicas for each container app (depending on available cores) |
| Container Instances | Not supported | No built-in support | 100 container groups for each subscription (default limit) |
| Azure Red Hat OpenShift | Pod autoscaling, cluster autoscaling | Load Balancer or Application Gateway | 250 nodes for each cluster (default limit) |
| Service Fabric | Virtual machine scale sets | Load Balancer | 100 nodes for each virtual machine scale set |
| Batch | Not applicable | Load Balancer | Core limit of 900 dedicated and 100 low-priority (default limit) |
| Azure VMware Solution | Built-in service<a href="#note5d"><sup>5</sup></a> | Integrated<a href="#note6d"><sup>6</sup></a> | 3 to 16 VMware ESXi hosts per VMware vCenter |

**Notes:**

<sup>1</sup> <span id="note1d">See [Autoscale pods](/azure/aks/tutorial-kubernetes-scale#autoscale-pods).</span>

<sup>2</sup> <span id="note2d">See [Automatically scale a cluster to meet application demands on AKS](/azure/aks/cluster-autoscaler).</span>

<sup>3</sup> <span id="note3d">See [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits)</span>

<sup>4</sup> <span id="note4d">See [Set scaling rules in Container Apps](/azure/container-apps/scale-app)</span>

<sup>5</sup> <span id="note5d">See [Scale Azure VMware Solution](/azure/azure-vmware/tutorial-scale-private-cloud)</span>

<sup>6</sup> <span id="note6d">See [VMware NSX](/azure/azure-vmware/configure-nsx-network-components-azure-portal)</span>

## Availability

| Service | Multiregion failover option |
|---|---|
| Virtual Machines | Azure Traffic Manager, Azure Front Door, and cross-region Load Balancer |
| App Service | Traffic Manager and Azure Front Door |
| Azure Functions | Traffic Manager and Azure Front Door |
| AKS | Traffic Manager, Azure Front Door, and Multiregion Cluster |
| Container Apps | Traffic Manager and Azure Front Door |
| Container Instances | Traffic Manager and Azure Front Door |
| Azure Red Hat OpenShift | Traffic Manager and Azure Front Door |
| Service Fabric | Traffic Manager, Azure Front Door, and cross-region Load Balancer |
| Batch | Not applicable |
| Azure VMware Solution | Not applicable |

For guided learning on service guarantees, see [Azure architecture and service guarantees](/training/modules/explore-azure-infrastructure).

## Security

Review and understand the available security controls and visibility for each of the following services:

- [AKS](/azure/aks/security-baseline)
- [App Service](/azure/app-service/overview-security)
- [Azure Functions](/azure/azure-functions/security-baseline)
- [Virtual Machines for Linux](/azure/virtual-machines/linux/security-baseline)
- [Azure VMware Solution](/security/benchmark/azure/baselines/azure-vmware-solution-security-baseline)
- [Virtual Machines for Windows](/azure/virtual-machines/windows/security-baseline)
- [Batch](/azure/batch/security-baseline)
- [Container Apps](/security/benchmark/azure/baselines/azure-container-apps-security-baseline)
- [Container Instances](/azure/container-instances/security-baseline)
- [Service Fabric](/azure/service-fabric/security-baseline)

## Other criteria

| Service | TLS | Cost | Suitable architecture styles |
|---|---|---|---|
| Virtual Machines | Configured in VM | [Windows][cost-windows-vm], [Linux][cost-linux-vm] | [N-tier][n-tier], [big compute][big-compute] (HPC) |
| App Service | Supported | [App Service pricing][cost-app-service] | [Web-queue-worker][w-q-w] |
| Azure Functions | Supported | [Azure Functions pricing][cost-functions] | [Microservices][microservices], [event-driven architecture][event-driven] |
| AKS | [Ingress controller](/azure/aks/ingress) | [AKS pricing][cost-acs] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Container Apps |  [Ingress controller](/azure/container-apps/ingress) | [Container Apps pricing][cost-container-apps] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Container Instances | Use [sidecar](../../patterns/sidecar.yml) container | [Container Instances pricing](https://azure.microsoft.com/pricing/details/container-instances) | [Microservices][microservices], task automation, batch jobs |
| Azure Red Hat OpenShift | Supported | [Azure Red Hat OpenShift pricing][cost-aro] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Service Fabric | Supported | [Service Fabric pricing][cost-service-fabric] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Batch | Supported | [Batch pricing][cost-batch] | [Big compute][big-compute] (HPC) |
| Azure VMware Solution | Configured in VM | [Azure VMware Solution pricing][cost-avs] | VM workload based on VMware format |

## Consider limits and cost

Along with the previous comparison tables, do a more detailed evaluation of the following aspects of the candidate service:

- [Cost](https://azure.microsoft.com/pricing)
- [Regional availability](https://azure.microsoft.com/global-infrastructure/services)
- [Service limits](/azure/azure-subscription-service-limits)
- [SLAs](https://azure.microsoft.com/support/legal/sla)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | Senior Program Manager
- [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | Principal Service Engineer
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski) | Senior Service Engineer
- [Phil Huang](https://www.linkedin.com/in/phil-huang-09b09895) | Senior Cloud Solution Architect
- [Julie Ng](https://www.linkedin.com/in/julie-io) | Senior Service Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Azure compute options](/training/paths/azure-fundamentals-describe-azure-architecture-services/)

## Related resources

- [Choose an Azure compute option for microservices](../../microservices/design/compute-options.md)
- [Technology choices for Azure solutions](technology-choices-overview.md)

[app-service-hybrid]: /azure/app-service/app-service-hybrid-connections
[azure-vmware-plans]: /azure/azure-vmware/architecture-private-clouds#hosts
[big-compute]: ../architecture-styles/big-compute.md
[cost-acs]: https://azure.microsoft.com/pricing/details/kubernetes-service
[cost-app-service]: https://azure.microsoft.com/pricing/details/app-service
[cost-aro]:https://azure.microsoft.com/pricing/details/openshift
[cost-avs]: https://azure.microsoft.com/pricing/details/azure-vmware
[cost-batch]: https://azure.microsoft.com/pricing/details/batch
[cost-container-apps]: https://azure.microsoft.com/pricing/details/container-apps
[cost-functions]: https://azure.microsoft.com/pricing/details/functions
[cost-linux-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/linux
[cost-service-fabric]: https://azure.microsoft.com/pricing/details/service-fabric
[cost-windows-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/windows
[durable-functions]: /azure/azure-functions/durable/durable-functions-overview
[event-driven]: ../architecture-styles/event-driven.md
[func-premium]: /azure/azure-functions/functions-premium-plan#private-network-connectivity
[function-plans]: /azure/azure-functions/functions-scale
[microservices]: ../architecture-styles/microservices.md
[n-tier]: ../architecture-styles/n-tier.md
[uptime-sla]: /azure/aks/uptime-sla
[w-q-w]: ../architecture-styles/web-queue-worker.md
