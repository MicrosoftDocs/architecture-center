---
title: Choose an Azure Compute Service
description: Use this chart and other information to decide which compute service, or hosting model for computing resources, best suits your application.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/18/2026
ms.reviewer: ssumner
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Choose an Azure compute service

Azure provides many ways to host your application code. The term *compute* refers to the hosting model for the resources that your application runs on. This article helps you choose the right compute service for your scenario and focuses on general-purpose compute offerings.

## Architecture

Use the following flowchart to select a candidate compute service.

:::image type="complex" border="false" source="images/compute-choices.svg" alt-text="Diagram that shows a decision tree for Azure compute services." lightbox="images/compute-choices.svg":::
   The image shows a flowchart for selecting an appropriate Azure service based on whether the user migrates an existing workload or builds a new workload. The flowchart begins with a start node and splits into two primary branches labeled migrate and build new. The migrate branch includes decision points that assess whether the application is optimized for the cloud and whether it can be lifted and shifted. Depending on the answers, the flow leads to services like Azure App Service, Azure VMware Solution, or Azure Virtual Machines. The build new branch includes decision points that evaluate the need for full control, high-performance computing (HPC), event-driven workloads, managed web hosting, and orchestration requirements. These decisions guide the user toward services like Virtual Machines, Azure Batch, Azure Functions, App Service, Azure Container Instances, Azure Red Hat OpenShift, Azure Kubernetes Service (AKS), or Azure Container Apps. A branching section for your own orchestration implementation on Virtual Machines includes VMware Tanzu on Virtual Machines, Kubernetes on Virtual Machines, and OpenShift on Virtual Machines. At the bottom of the image, two boxed sections list container-exclusive services and container-compatible services. The container-exclusive section includes Container Instances, Azure Red Hat OpenShift, Kubernetes on Virtual Machines, OpenShift on Virtual Machines, and VMware Tanzu on Virtual Machines. The container-compatible section includes Azure Batch, Azure Functions, and App Service.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/compute-choices.vsdx) of this architecture.*

The previous diagram refers to two migration strategies:

- **Lift and shift:** A strategy for migrating a workload to the cloud without redesigning the application or making code changes. It's also known as *rehosting*. We recommend that workload teams that perform migrations use a like-for-like approach and defer optimization unless their timeline and budget support redesign for cloud-native functionality. For more information, see [Migrate workloads to Azure from other cloud platforms](/azure/migration/migrate-to-azure).

- **Cloud optimized:** A strategy for migrating to the cloud by refactoring an application to take advantage of cloud-native features and capabilities. You can also use this strategy to describe greenfield (new) workloads designed from the start to use cloud-native features.

The output from this flowchart is your starting point. Then evaluate the service to see whether it meets your needs.

This article includes several tables that can help you choose a service. The initial candidate from the flowchart might not suit your application or workload. In that case, expand your analysis to include other compute services.

If your workload consists of distinct compute components, evaluate each application's needs separately. A complete solution can include two or more compute services.

## Understand the basic features

If you're unfamiliar with the Azure service that you select in the previous section, see the following overview documentation:

- [Azure Virtual Machines](/azure/virtual-machines/overview) is a service that you can use to deploy and manage virtual machines (VMs) inside an Azure virtual network.

- [Azure App Service](/azure/app-service/overview) is a managed service for hosting web apps, mobile app back ends, RESTful APIs, or automated business processes.

- [Azure Functions](/azure/azure-functions/functions-overview) is a service that provides managed functions that run based on various trigger types for event-driven applications.

- [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks) is a managed Kubernetes service for running containerized applications. It provides direct access to the Kubernetes API and control plane.

- [Azure Container Apps](/azure/container-apps/overview) is a managed service built on Kubernetes, which simplifies the deployment of containerized applications in a serverless environment. It doesn't provide direct access to the underlying Kubernetes APIs. Use AKS if you require access to the Kubernetes APIs and control plane.

- [Azure Container Instances](/azure/container-instances/container-instances-overview) is a service for running a single container or group of containers in Azure. Container Instances doesn't provide full container orchestration, but you can implement containers without the need to provision VMs or adopt a higher-level service.

- [Azure Red Hat OpenShift](/azure/openshift/intro-openshift) is a fully managed OpenShift cluster for running containers in production with Kubernetes.

- [Azure Batch](/azure/batch/batch-technical-overview) is a managed service for running large-scale parallel and high-performance computing (HPC) applications.

- [Azure VMware Solution](/azure/azure-vmware/introduction) is a managed service for running VMware workloads natively on Azure.

## Understand the hosting models

For hosting models, cloud services fall into three categories:

- **Infrastructure as a service (IaaS)** lets you provision VMs along with the associated networking and storage components. You can then deploy any software and applications on those VMs. This model is the most similar to a traditional on-premises environment. Microsoft manages the infrastructure, and you manage the VMs.

- **Platform as a service (PaaS)** provides a managed hosting environment where you can deploy your application without the need to manage VMs. App Service and Container Apps are PaaS services.

- **Functions as a service (FaaS)** lets you deploy your code to the service, which automatically runs it. Azure Functions is a FaaS service.

  > [!NOTE]
  > Azure Functions is an [Azure serverless](https://azure.microsoft.com/solutions/serverless/#solutions) compute offering. To see how this service compares with other Azure serverless offerings, like Azure Logic Apps for serverless workflows, see [Choose the right integration and automation services in Azure](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs).

Cloud compute services range from IaaS to fully managed FaaS. For example, Azure VMs can automatically scale by using virtual machine scale sets. Automatic scaling capabilities are often associated with PaaS or FaaS, but capabilities vary by service rather than by compute category.

A trade-off exists between control and ease of management. IaaS provides the most control, flexibility, and portability, but you must provision, set up, and manage the VMs and network components that you create. FaaS services automatically manage nearly all aspects of running an application. PaaS provides partial management and requires some user configuration.

| Service | Application composition | Density | Minimum number of nodes | State management | Web hosting |
| :------ | :---------------------- | :------ | :---------------------- | :--------------- | :---------- |
| Virtual Machines | Agnostic | Agnostic | 1 <a href="#note1"><sup>1</sup></a> | Stateless or stateful | Agnostic |
| App Service | Applications, containers | Multiple apps for each instance by using an App Service plan | 1 | Stateless | Built-in |
| Azure Functions | Functions, containers | Serverless <a href="#note2"><sup>2</sup></a> | Serverless <a href="#note2"><sup>2</sup></a> | Stateless or stateful <a href="#note3"><sup>3</sup></a> | Not applicable |
| AKS | Containers | Multiple containers for each node | 6 <a href="#note4"><sup>4</sup></a> | Stateless or stateful | Agnostic |
| Container Apps | Containers | Serverless | Serverless | Stateless or stateful | Agnostic |
| Container Instances | Containers | No dedicated instances | No dedicated nodes | Stateless | Agnostic |
| Azure Red Hat OpenShift | Containers | Multiple containers for each node | 6 <a href="#note5"><sup>5</sup></a> | Stateless or stateful | Agnostic |
| Batch | Scheduled jobs | Multiple apps for each VM | 1 <a href="#note6"><sup>6</sup></a> | Stateless | No |
| Azure VMware Solution | Agnostic | Agnostic | 3 <a href="#note7"><sup>7</sup></a> | Stateless or stateful | Agnostic |

**Notes:**

<sup>1</sup> <span id="note1">Higher service-level agreement (SLA) that has two or more instances.</span>

<sup>2</sup> <span id="note2">For Azure Functions, the [Consumption and Flex Consumption plans](/azure/azure-functions/flex-consumption-plan) are serverless. For an App Service plan, functions run on the VMs allocated for that plan. [Choose the right service plan for Azure Functions][function-plans].</span>

<sup>3</sup> <span id="note3">When you use [durable functions][durable-functions].</span>

<sup>4</sup> <span id="note4">Recommended for production environments. Three in the system node pool and three for each user node pool.</span>

<sup>5</sup> <span id="note5">Three primary nodes and three worker nodes.</span>

<sup>6</sup> <span id="note6">Can scale down to zero after the job completes.</span>

<sup>7</sup> <span id="note7">See [Hosts][azure-vmware-plans].</span>

For more information, see [Choose an Azure container service](../choose-azure-container-service.md).

## Networking

Your application platform likely needs to interface with networks both as a server for your applications and as a client. For example, it might function as a client to get operating system (OS) updates. You must select a platform that supports both your east-west and north-south traffic requirements.

| Service | Virtual network integration | Hybrid connectivity |
| :------ | :-------------------------- | :------------------ |
| Virtual Machines | Supported | Supported |
| App Service | Supported <a href="#note1b"><sup>1</sup></a> | Supported <a href="#note2b"><sup>2</sup></a> |
| Azure Functions | Supported <a href="#note1b"><sup>1</sup></a> | Supported <a href="#note3b"><sup>3</sup></a> |
| AKS | [Supported](/azure/aks/configure-azure-cni) | Supported |
| Container Apps | Supported | Supported |
| Container Instances | [Supported](/azure/container-instances/container-instances-vnet) | [Supported](/azure/container-instances/container-instances-virtual-network-concepts#scenarios) |
| Azure Red Hat OpenShift | [Supported](/azure/openshift/concepts-networking) | Supported |
| Batch | Supported | Supported |
| Azure VMware Solution | [Supported](/azure/azure-vmware/configure-site-to-site-vpn-gateway) | [Supported](/azure/azure-vmware/enable-managed-snat-for-workloads) |

**Notes:**

<sup>1</sup> <span id="note1b">Requires an App Service Environment or a dedicated compute pricing tier.</span>

<sup>2</sup> <span id="note2b">Use [App Service Hybrid Connections][app-service-hybrid].</span>

<sup>3</sup> <span id="note3b">Requires an App Service plan, [Azure Functions Premium plan][func-premium], or [Azure Functions Flex Consumption plan](/azure/azure-functions/flex-consumption-plan#virtual-network-integration).</span>

## DevOps

| Service | Local debugging | Remote debugging | Programming model | Application update |
| :------ | :-------------- | :--------------- | :---------------- | :----------------- |
| Virtual Machines | Agnostic | [Remote Tools for Visual Studio](/visualstudio/debugger/remote-debugging) | Agnostic | No built-in support |
| App Service | IIS Express, others <a href="#note1c"><sup>1</sup></a> | [Limited support](/visualstudio/debugger/remote-debugging-azure-app-service) | Web and API applications, WebJobs for background tasks | Deployment slots |
| Azure Functions | [Visual Studio or Azure Functions Core Tools](/azure/azure-functions/functions-develop-local) | Not supported | Serverless, event-driven | Deployment slots |
| AKS | Minikube, Docker, others | Non-Microsoft tools <a href="#note2c"><sup>2</sup></a> | Agnostic | Rolling update |
| Container Apps | Local container runtime | [Debug console](/azure/container-apps/container-debug-console) | Agnostic | Revision management |
| Container Instances | Local container runtime | Not supported | Agnostic | Not applicable |
| Azure Red Hat OpenShift | Minikube, Docker, others | Non-Microsoft tools <a href="#note2c"><sup>2</sup></a> | Agnostic | Rolling update |
| Batch | Not supported | Not applicable | Command-line application | Not applicable |
| Azure VMware Solution | Agnostic | [Remote Tools for Visual Studio](/visualstudio/debugger/remote-debugging) | Agnostic | No built-in support |

**Notes:**

<sup>1</sup> <span id="note1c">Options include IIS Express, Visual Studio Code, and other standard development tools based on your application stack.</span>

<sup>2</sup> <span id="note2c">Use non-Microsoft tools like [Telepresence](/azure/aks/use-telepresence-aks) or [mirrord](https://metalbear.com/mirrord/) for local-to-cluster debugging.</span>

## Team skills and operational overhead

| Service | Required skills | Operational overhead | Best for teams that have these characteristics |
| :------ | :-------------- | :------------------- | :------------------ |
| Virtual Machines | OS administration, networking, security patching | High: Full infrastructure management | Traditional IT operations experience |
| App Service | Web development, application deployment | Low: Platform handles infrastructure | Application developers focused on code |
| Azure Functions | Event-driven programming, serverless patterns | Very low: Serverless management | Developers who build event-driven solutions |
| AKS | Kubernetes administration, container orchestration | High: Cluster management, upgrades, security | DevOps teams that have Kubernetes expertise |
| Container Apps | Container basics, cloud-native patterns | Low: Abstracted Kubernetes management | Teams that want modern patterns without Kubernetes complexity |
| Container Instances | Container basics | Very low: No orchestration | Teams that need simple container execution |
| Azure Red Hat OpenShift | OpenShift or Kubernetes administration | High: Cluster management | Teams that have OpenShift investment |
| Batch | Job scheduling, parallel processing | Medium: Job and pool management | Teams that run HPC or batch workloads |
| Azure VMware Solution | VMware administration | Medium: VMware-managed infrastructure | Teams that have VMware platform requirements |

## Scalability

Quota and limits can affect scalability. Review the latest [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits) when you design your workload.

| Service | Autoscaling | Load balancer | Scale limit |
| :------ | :---------- | :------------ | :---------- |
| Virtual Machines | Virtual machine scale sets | Azure Load Balancer | - Platform image: 1,000 nodes for each scale set <br><br> - Custom image: 600 nodes for each scale set |
| App Service | Built-in service | Integrated | 30 instances, 200 with an App Service Environment |
| Azure Functions | Built-in service | Integrated | 200 instances (Consumption), 1,000 instances (Flex Consumption) |
| AKS | Pod autoscaling<a href="#note1d"><sup>1</sup></a>, cluster autoscaling<a href="#note2d"><sup>2</sup></a> | Load Balancer or Azure Application Gateway | 5,000 nodes when you use [uptime SLA][uptime-sla] |
| Container Apps | Scaling rules<a href="#note3d"><sup>3</sup></a> | Integrated | 1,000 replicas for each revision, 15 environments in each region |
| Container Instances | Not supported | No built-in support | 100 container groups for each subscription (default limit) |
| Azure Red Hat OpenShift | Pod autoscaling, cluster autoscaling | Load Balancer or Application Gateway | 250 nodes for each cluster (default limit) |
| Batch | Not applicable | Load Balancer | Core limit of 900 dedicated cores and 100 low-priority cores (default limit) |
| Azure VMware Solution | Built-in service<a href="#note4d"><sup>4</sup></a> | Integrated<a href="#note5d"><sup>5</sup></a> | 3 to 16 VMware ESXi hosts for each VMware vCenter |

**Notes:**

<sup>1</sup> <span id="note1d">See [Autoscale pods](/azure/aks/tutorial-kubernetes-scale#autoscale-pods).</span>

<sup>2</sup> <span id="note2d">See [Scale a cluster automatically to meet application demands on AKS](/azure/aks/cluster-autoscaler).</span>

<sup>3</sup> <span id="note3d">See [Set scaling rules in Container Apps](/azure/container-apps/scale-app).</span>

<sup>4</sup> <span id="note4d">See [Scale clusters in a private cloud](/azure/azure-vmware/tutorial-scale-private-cloud).</span>

<sup>5</sup> <span id="note5d">See [VMware NSX](/azure/azure-vmware/configure-nsx-network-components-azure-portal).</span>

## Built-in multiregion capabilities

All of the application platforms that this decision guide addresses are regional. They require external routing to enable [multiregion, active-active topologies](/azure/architecture/high-availability/reference-architecture-traffic-manager-application-gateway) for resiliency and active-passive topologies for recoverability. When you deploy multiple instances of the application platform, with at least one instance in each region, an external router or load balancer can direct traffic where needed across regions.

| Service | Multiregion option |
| :------ | :----------------- |
| Virtual Machines | Single region only. <br><br> Must use external router combined with multiple VM deployments. |
| App Service | Single region only. <br><br> Must use external router combined with multiple App Service Plan instances. |
| Azure Functions | Single region only. <br><br> Must use external router combined with multiple host instances. |
| AKS | Single region only. <br><br> Must use external router combined with [multiple clusters](/azure/architecture/reference-architectures/containers/aks-multi-region/aks-multi-cluster). |
| Container Apps | Single region only. <br><br> Must use external router combined with multiple Container Apps environments. |
| Container Instances | Single region only. |
| Azure Red Hat OpenShift | [Single region only](/azure/openshift/openshift-faq#can-a-cluster-have-compute-nodes-across-multiple-azure-regions). <br><br> Must use external router combined with multiple clusters. |
| Batch | Single region only. |
| Azure VMware Solution | Single region only. <br><br> Must use external router combined with [multiple Azure VMware Solution instances](/azure/cloud-adoption-framework/scenarios/azure-vmware/dual-region-virtual-wan-global-reach). |

## Security

Review and understand the available security controls and visibility for each of the following services:

- [Virtual Machines for Linux](/security/benchmark/azure/baselines/virtual-machines-linux-virtual-machines-security-baseline)
- [Virtual Machines for Windows](/security/benchmark/azure/baselines/virtual-machines-windows-virtual-machines-security-baseline)
- [App Service](/azure/app-service/overview-security)
- [Azure Functions](/security/benchmark/azure/baselines/functions-security-baseline)
- [AKS](/security/benchmark/azure/baselines/azure-kubernetes-service-aks-security-baseline)
- [Container Apps](/security/benchmark/azure/baselines/azure-container-apps-security-baseline)
- [Container Instances](/security/benchmark/azure/baselines/container-instances-security-baseline)
- [Azure VMware Solution](/security/benchmark/azure/baselines/azure-vmware-solution-security-baseline)

## Other criteria

| Service | Transport Layer Security (TLS) | Cost | Graphics processing unit (GPU) support | Suitable architecture styles |
| :------ | :-- | :--- | :--- | :--------------------------- |
| Virtual Machines | Set up in VM | [Windows][cost-windows-vm], <br> [Linux][cost-linux-vm] | [Supported](/azure/virtual-machines/sizes/overview#gpu-accelerated) | [N-tier][n-tier], [big compute][big-compute] (HPC) |
| App Service | Supported | [App Service pricing][cost-app-service] | Not supported | [Web-queue-worker][w-q-w] |
| Azure Functions | Supported | [Azure Functions pricing][cost-functions] | Not supported | [Microservices][microservices], [event-driven architecture][event-driven] |
| AKS | [Ingress controller](/azure/aks/ingress) | [AKS pricing][cost-acs] | [Supported](/azure/aks/use-nvidia-gpu) | [Microservices][microservices], [event-driven architecture][event-driven] |
| Container Apps | [Ingress controller](/azure/container-apps/ingress-overview) | [Container Apps pricing][cost-container-apps] | [Supported](/azure/container-apps/gpu-serverless-overview) | [Microservices][microservices], [event-driven architecture][event-driven] |
| Container Instances | Use [sidecar](../../patterns/sidecar.md) container | [Container Instances pricing](https://azure.microsoft.com/pricing/details/container-instances/) | [Not supported](/azure/container-instances/container-instances-gpu) | [Microservices][microservices], task automation, batch jobs |
| Azure Red Hat OpenShift | Supported | [Azure Red Hat OpenShift pricing][cost-aro] | [Supported](/azure/openshift/howto-gpu-workloads) | [Microservices][microservices], [event-driven architecture][event-driven] |
| Batch | Supported | [Batch pricing][cost-batch] | [Supported](/azure/batch/batch-pool-compute-intensive-sizes) | [Big compute][big-compute] (HPC) |
| Azure VMware Solution | Set up in VM | [Azure VMware Solution pricing][cost-avs] | Not supported | VM workload based on VMware format |

## Consider limits and cost

Use the previous comparison tables as context and evaluate the following aspects of the candidate service in more detail:

- [Azure pricing](https://azure.microsoft.com/pricing) and [cost calculator](https://azure.microsoft.com/pricing/calculator/)
- [Azure service availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table)
- [Service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits)
- [SLAs](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services)

## Specialty workloads

Some workloads have specific requirements and don't typically follow the general recommendations in this application platform selection guide. These workloads are usually software or database products that have characteristics that limit the service options to a narrow set of supported choices.

| Scenario | Explore these options |
| :------- | :-------------------- |
| HPC scheduling | [Azure CycleCloud](/azure/cyclecloud/overview) |
| SAP on Azure VMs | [Use Azure to host and run SAP workload scenarios](/azure/sap/workloads/get-started) |
| Oracle on Azure VMs | [Oracle databases on Azure infrastructure](/azure/virtual-machines/workloads/oracle/oracle-overview#oracle-databases-on-azure-infrastructure) <br><br> [Applications on Oracle Linux and WebLogic server](/azure/virtual-machines/workloads/oracle/oracle-overview#applications-on-oracle-linux-and-weblogic-server) |
| Complex, intermixed state and compute with opinionated programming models | [Azure Service Fabric](/azure/service-fabric/service-fabric-application-scenarios) |
| Mainframe | [Rehost a mainframe on Azure](/azure/architecture/example-scenario/mainframe/mainframe-rehost-architecture-azure) <br><br> [Refactor a mainframe application for Azure](/azure/architecture/example-scenario/mainframe/general-mainframe-refactor) |
| Marketplace offerings | [Browse partner offerings on Azure compute](https://marketplace.microsoft.com/search/products?product=azure) |
| Quantum computing | [Azure Quantum](/azure/quantum/overview-azure-quantum) |
| Virtual desktop hosting | [Virtual desktop architecture design](/azure/architecture/guide/virtual-desktop/start-here) |
| Bare metal or dedicated compute workloads | [Azure Dedicated Hosts](/azure/virtual-machines/dedicated-hosts) <br><br> [Nutanix Cloud Clusters on Azure](/azure/baremetal-infrastructure/workloads/nc2-on-azure/about-nc2-on-azure) |

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
[cost-acs]: https://azure.microsoft.com/pricing/details/kubernetes-service/
[cost-app-service]: https://azure.microsoft.com/pricing/details/app-service/linux/
[cost-aro]:https://azure.microsoft.com/pricing/details/openshift/
[cost-avs]: https://azure.microsoft.com/pricing/details/azure-vmware/
[cost-batch]: https://azure.microsoft.com/pricing/details/batch/
[cost-container-apps]: https://azure.microsoft.com/pricing/details/container-apps/
[cost-functions]: https://azure.microsoft.com/pricing/details/functions/
[cost-linux-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/linux/
[cost-windows-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/windows/
[durable-functions]: /azure/azure-functions/durable/durable-functions-overview
[event-driven]: ../architecture-styles/event-driven.md
[func-premium]: /azure/azure-functions/functions-premium-plan#private-network-connectivity
[function-plans]: /azure/azure-functions/functions-scale
[microservices]: ../architecture-styles/microservices.md
[n-tier]: ../architecture-styles/n-tier.md
[uptime-sla]: /azure/aks/free-standard-pricing-tiers
[w-q-w]: ../architecture-styles/web-queue-worker.md
