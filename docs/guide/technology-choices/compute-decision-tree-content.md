Azure offers many ways to host your application code. The term *compute* refers to the hosting model for the resources that your application runs on. This article helps choose a compute service for your application.

## Choose a candidate service

Use the following flowchart to select a candidate compute service.

:::image type="content" source="./images/compute-choices.svg" alt-text="Diagram that shows a decision tree for Azure compute services." lightbox="./images/compute-choices.svg" border="false":::

[Download a Visio file](https://arch-center.azureedge.net/compute-choices.vsdx) of this decision tree.

This diagram refers to two migration strategies:

- **Lift and shift**: A strategy for migrating a workload to the cloud without redesigning the application or making code changes. It's also called *rehosting*. For more information, see [Azure migration and modernization center](https://azure.microsoft.com/migration).
- **Cloud optimized**: A strategy for migrating to the cloud by refactoring an application to take advantage of cloud-native features and capabilities.

The output from this flowchart is your starting point. Next, evaluate the service to see if it meets your needs.

This article includes several tables that can help you choose a service. The initial candidate from the flowchart might be unsuitable for your application or workload. In that case, expand your analysis to include other compute services.

If your application consists of multiple workloads, evaluate each workload separately. A complete solution can incorporate two or more compute services.

## Understand the basic features

If you're not familiar with the Azure service selected in the previous section, see this overview documentation:

- [Azure Virtual Machines](/azure/virtual-machines): A service where you deploy and manage virtual machines (VMs) inside an Azure virtual network.
- [Azure App Service](/azure/app-service): A managed service for hosting web apps, mobile app back ends, RESTful APIs, or automated business processes.
- [Azure Functions](/azure/azure-functions/functions-overview): A service that provides managed functions that run based on a variety of trigger types for event-driven applications.
- [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes): A managed Kubernetes service for running containerized applications.
- [Azure Container Apps](/azure/container-apps): A managed service built on Kubernetes, which simplifies the deployment of containerized applications in a serverless environment.
- [Azure Container Instances](/azure/container-instances/container-instances-overview): This service is a fast and simple way to run a single container or group of containers in Azure. Azure Container Instances doesn't provide full container orchestration, but you can implement them without having to provision any VMs or adopt a higher-level service.
- [Azure Red Hat OpenShift](/azure/openshift): A fully managed OpenShift cluster for running containers in production with Kubernetes.
- [Azure Service Fabric](/azure/service-fabric/service-fabric-overview): A distributed systems platform that can run in many environments, including Azure or on-premises.
- [Azure Batch](/azure/batch/batch-technical-overview): A managed service for running large-scale parallel and high-performance computing (HPC) applications.
- [Azure VMware Solution](/azure/azure-vmware/introduction): A managed service for running VMware workloads natively on Azure.

## Understand the hosting models

For hosting models, cloud services fall into three categories:

- **Infrastructure as a service (IaaS)**: Lets you provision VMs along with the associated networking and storage components. Then you can deploy whatever software and applications you want onto those VMs. This model is the closest to a traditional on-premises environment. Microsoft manages the infrastructure. You still manage the VMs.
- **Platform as a service (PaaS)**: Provides a managed hosting environment where you can deploy your application without needing to manage VMs or networking resources. Azure App Service and Azure Container Apps are PaaS services.
- **Functions as a service (FaaS)**: Lets you deploy your code to the service, which automatically runs it. Azure Functions is a FaaS service.

  > [!NOTE]
  > Azure Functions is an [Azure serverless](https://azure.microsoft.com/solutions/serverless/#solutions) compute offering. To see how this service compares with other Azure serverless offerings, such as Logic Apps, which provides serverless workflows, see [Choose the right integration and automation services in Azure](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs).

There's a spectrum from IaaS to pure PaaS. For example, Azure VMs can automatically scale by using virtual machine scale sets. This capability isn't strictly a PaaS, but it's the type of management feature found in PaaS.

There's a tradeoff between control and ease of management. IaaS gives the most control, flexibility, and portability, but you have to provision, configure, and manage the VMs and network components you create. FaaS services automatically manage nearly all aspects of running an application. PaaS falls somewhere in between.

| Service | Application composition | Density | Minimum number of nodes | State management | Web hosting |
|----------|-----------------|-------------|---------|----------------|-----------------|
| Azure Virtual Machines | Agnostic | Agnostic | 1 <a href="#note2"><sup>2</sup></a> | Stateless or stateful | Agnostic |
| Azure App Service | Applications, containers | Multiple apps per instance by using App Service plan | 1 | Stateless | Built in |
| Azure Functions | Functions, containers | Serverless <a href="#note1"><sup>1</sup></a> | Serverless <a href="#note1"><sup>1</sup></a> | Stateless or stateful <a href="#note6"><sup>6</sup></a> | Not applicable |
| Azure Kubernetes Service | Containers | Multiple containers per node | 3 <a href="#note3"><sup>3</sup></a> | Stateless or stateful | Agnostic |
| Azure Container Apps | Containers | Serverless | Serverless | Stateless or stateful | Agnostic |
| Azure Container Instances | Containers | No dedicated instances | No dedicated nodes | Stateless | Agnostic |
| Azure Red Hat OpenShift | Containers | Multiple containers per node | 6 <a href="#note5"><sup>5</sup></a> | Stateless or stateful | Agnostic |
| Azure Service Fabric | Services, guest executables, containers | Multiple services per VM | 5 <a href="#note3"><sup>3</sup></a> | Stateless or stateful | Agnostic |
| Azure Batch | Scheduled jobs | Multiple apps per VM | 1 <a href="#note4"><sup>4</sup></a> | Stateless | No |
| Azure VMware Solution | Agnostic | Agnostic | 3 <a href="#note7"><sup>7</sup></a> | Stateless or stateful | Agnostic |

Notes

1. <span id="note1">If you're using a Consumption plan. For an App Service plan, functions run on the VMs allocated for your App Service plan. See [Choose the correct service plan for Azure Functions][function-plans].</span>
1. <span id="note2">Higher service-level agreement (SLA) with two or more instances.</span>
1. <span id="note3">Recommended for production environments.</span>
1. <span id="note4">Can scale down to zero after job completes.</span>
1. <span id="note5">Three for primary nodes and three for worker nodes.</span>
1. <span id="note6">When using [Durable Functions][durable-functions].</span>
1. <span id="note7">Require minimum number of [three nodes][azure-vmware-plans].</span>

## Networking

| Service | Virtual network integration | Hybrid connectivity |
|----------|-----------------|-------------|
| Azure Virtual Machines | Supported | Supported |
| Azure App Service | Supported <a href="#note1b"><sup>1</sup></a> | Supported <a href="#note2b"><sup>2</sup></a> |
| Azure Functions | Supported <a href="#note1b"><sup>1</sup></a> | Supported <a href="#note3b"><sup>3</sup></a> |
| Azure Kubernetes Service | [Supported](/azure/aks/networking-overview) | Supported |
| Azure Container Apps | Supported | Supported |
| Azure Container Instances | [Supported](/azure/container-instances/container-instances-vnet) | [Supported](/azure/container-instances/container-instances-virtual-network-concepts#scenarios)  |
| Azure Red Hat OpenShift | [Supported](/azure/openshift/concepts-networking) | Supported |
| Azure Service Fabric | Supported | Supported |
| Azure Batch | Supported | Supported |
| Azure VMware Solution | [Supported](/azure/azure-vmware/configure-site-to-site-vpn-gateway) | [Supported](/azure/azure-vmware/enable-managed-snat-for-workloads) |

Notes

1. <span id="note1b">Requires App Service Environment.</span>
2. <span id="note2b">Use [Azure App Service Hybrid Connections][app-service-hybrid].</span>
3. <span id="note3b">Requires App Service plan or [Azure Functions Premium plan][func-premium].</span>

## DevOps

| Service | Local debugging | Programming model | Application update|
|----------|-----------------|-----------------|-----------------|
| Azure Virtual Machines | Agnostic | Agnostic | No built-in support |
| Azure App Service | IIS Express, others <a href="#note1c"><sup>1</sup></a> | Web and API applications, WebJobs for background tasks | Deployment slots |
| Azure Functions | Visual Studio or Azure Functions CLI | Serverless, event-driven | Deployment slots |
| Azure Kubernetes Service | Minikube, Docker, others | Agnostic | Rolling update |
| Azure Container Apps | Local container runtime | Agnostic | Revision management |
| Azure Container Instances | Local container runtime | Agnostic | Not applicable |
| Azure Red Hat OpenShift | Minikube, Docker, others | Agnostic | Rolling update |
| Azure Service Fabric | Local node cluster | Guest executable, Service model, Actor model, Containers | Rolling upgrade (per service) |
| Azure Batch | Not supported | Command-line application | Not applicable |
| Azure VMware Solution | Agnostic | Agnostic | No built-in support |

Notes

1. <span id="note1c">Options include IIS Express for ASP.NET or node.js (iisnode), PHP web server, Azure Toolkit for IntelliJ, and Azure Toolkit for Eclipse. App Service also supports remote debugging of deployed web app.</span>

## Scalability

| Service | Autoscaling | Load balancer | Scale limit<a href="#note3d"><sup>3</sup></a>|
|----------|-----------------|-----------------|-----------------|
| Azure Virtual Machines | Virtual machine scale sets | Azure Load Balancer | Platform image: 1,000 nodes per scale set, Custom image: 600 nodes per scale set |
| Azure App Service | Built-in service | Integrated | 30 instances, 100 with App Service Environment |
| Azure Functions | Built-in service | Integrated | 200 instances per function app |
| Azure Kubernetes Service | Pod autoscaling<a href="#note1d"><sup>1</sup></a>, cluster autoscaling<a href="#note2d"><sup>2</sup></a> | Azure Load Balancer or Azure Application Gateway | 5,000 nodes when using [Uptime SLA][uptime-sla] |
| Azure Container Apps | Scaling rules<a href="#note4d"><sup>4</sup></a> | Integrated | 15 environments per region (default limit), unlimited container apps per environment and replicas per container app (depending on available cores) |
| Azure Container Instances | Not supported | No built-in support | 100 container groups per subscription (default limit) |
| Azure Red Hat OpenShift | Pod autoscaling, cluster autoscaling | Azure Load Balancer or Azure Application Gateway | 250 nodes per cluster (default limit) |
| Azure Service Fabric | Virtual machine scale sets | Azure Load Balancer | 100 nodes per virtual machine scale set |
| Azure Batch | Not applicable | Azure Load Balancer | Core limit of 900 dedicated and 100 low-priority (default limit) |
| Azure VMware Solution | Built-in service<a href="#note5d"><sup>5</sup></a> | Integrated<a href="#note6d"><sup>6</sup></a> | Per VMware vCenter can manage between 3 ~ 16 VMware ESXi hosts |

Notes

1. <span id="note1d">See [Autoscale pods](/azure/aks/tutorial-kubernetes-scale#autoscale-pods).</span>
2. <span id="note2d">See [Automatically scale a cluster to meet application demands on Azure Kubernetes Service](/azure/aks/cluster-autoscaler).</span>
3. <span id="note3d">See [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits)</span>.
4. <span id="note4d">See [Set scaling rules in Azure Container Apps](/azure/container-apps/scale-app)</span>.
5. <span id="note5d">See [Scale a Azure VMware Solution](/azure/azure-vmware/tutorial-scale-private-cloud)</span>.
6. <span id="note6d">See [VMware NSX](/azure/azure-vmware/configure-nsx-network-components-azure-portal)</span>.

## Availability

| Service | Multiregion failover option |
|----------|-----------------|
| Azure Virtual Machines | Azure Traffic Manager, Azure Front Door, and cross-region Azure Load Balancer |
| Azure App Service | Azure Traffic Manager and Azure Front Door |
| Azure Functions | Azure Traffic Manager and Azure Front Door |
| Azure Kubernetes Service (AKS) | Azure Traffic Manager, Azure Front Door, and Multiregion Cluster |
| Azure Container Apps | Azure Traffic Manager and Azure Front Door |
| Azure Container Instances | Azure Traffic Manager and Azure Front Door |
| Azure Red Hat OpenShift | Azure Traffic Manager and Azure Front Door |
| Azure Service Fabric | Azure Traffic Manager, Azure Front Door, and cross-region Azure Load Balancer |
| Azure Batch | Not applicable |
| Azure VMware Solution | Not applicable |

For guided learning on service guarantees, see [Core Cloud Services - Azure architecture and service guarantees](/training/modules/explore-azure-infrastructure).

## Security

Review and understand the available security controls and visibility for each service:

- [Azure Windows virtual machine](/azure/virtual-machines/windows/security-baseline)
- [Azure Linux virtual machine](/azure/virtual-machines/linux/security-baseline)
- [Azure App Service](/azure/app-service/overview-security)
- [Azure Functions](/azure/azure-functions/security-baseline)
- [Azure Kubernetes Service](/azure/aks/security-baseline)
- [Azure Container Instances](/azure/container-instances/security-baseline)
- [Azure Service Fabric](/azure/service-fabric/security-baseline)
- [Azure Batch](/azure/batch/security-baseline)
- [Azure VMware Solution](/security/benchmark/azure/baselines/azure-vmware-solution-security-baseline)

## Other criteria

| Service | TLS | Cost | Suitable architecture styles|
|----------|-----------------|-----------------|-----------------|
| Azure Virtual Machines | Configured in VM | [Windows][cost-windows-vm], [Linux][cost-linux-vm] | [N-tier][n-tier], [big compute][big-compute] (HPC) |
| Azure App Service | Supported | [App Service pricing][cost-app-service] | [Web-queue-worker][w-q-w] |
| Azure Functions | Supported | [Functions pricing][cost-functions] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Azure Kubernetes Service (AKS) | [Ingress controller](/azure/aks/ingress) | [AKS pricing][cost-acs] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Azure Container Apps |  [Ingress controller](/azure/container-apps/ingress) | [Container Apps pricing][cost-container-apps] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Azure Container Instances | Use [sidecar](../../patterns/sidecar.yml) container | [Container Instances pricing](https://azure.microsoft.com/pricing/details/container-instances) | [Microservices][microservices], task automation, batch jobs |
| Azure Red Hat OpenShift | Supported | [Azure Red Hat OpenShift pricing][cost-aro] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Azure Service Fabric | Supported | [Service Fabric pricing][cost-service-fabric] | [Microservices][microservices], [event-driven architecture][event-driven] |
| Azure Batch | Supported | [Batch pricing][cost-batch] | [Big compute][big-compute] (HPC) |
| Azure VMware Solution | Configured in VM | [Azure VMware Solution pricing][cost-avs] | VM workload based on VMware format |

## Consider limits and cost

Along with the previous comparison tables, do a more detailed evaluation of the following aspects of the candidate service:

- [Service limits](/azure/azure-subscription-service-limits)
- [Cost](https://azure.microsoft.com/pricing)
- [SLA](https://azure.microsoft.com/support/legal/sla)
- [Regional availability](https://azure.microsoft.com/global-infrastructure/services)

## Contributors

This article is maintained by Microsoft. It was originally written by the following contributors:

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | Senior Program Manager
- [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | Principal Service Engineer
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski) | Senior Service Engineer
- [Phil Huang](https://www.linkedin.com/in/phil-huang-09b09895) | Senior Cloud Solution Architect
- [Julie Ng](https://www.linkedin.com/in/julie-io) | Senior Service Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer

To see nonpublic LinkedIn profiles, sign in to LinkedIn.

## Next steps

[Core Cloud Services - Azure compute options](/training/modules/intro-to-azure-compute). This Learn module explores how compute services can solve common business needs.

## Related resources

- [Choose an Azure compute option for microservices](../../microservices/design/compute-options.md)
- [Technology choices for Azure solutions](technology-choices-overview.md)

[cost-linux-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/linux
[cost-windows-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/windows
[cost-app-service]: https://azure.microsoft.com/pricing/details/app-service
[cost-service-fabric]: https://azure.microsoft.com/pricing/details/service-fabric
[cost-functions]: https://azure.microsoft.com/pricing/details/functions
[cost-acs]: https://azure.microsoft.com/pricing/details/kubernetes-service
[cost-batch]: https://azure.microsoft.com/pricing/details/batch
[cost-container-apps]: https://azure.microsoft.com/pricing/details/container-apps
[cost-aro]:https://azure.microsoft.com/pricing/details/openshift
[cost-avs]: https://azure.microsoft.com/pricing/details/azure-vmware

[function-plans]: /azure/azure-functions/functions-scale
[azure-vmware-plans]: /azure/azure-vmware/architecture-private-clouds#hosts

[resource-manager-supported-services]: /azure/azure-resource-manager/resource-manager-supported-services

[n-tier]: ../architecture-styles/n-tier.yml
[w-q-w]: ../architecture-styles/web-queue-worker.yml
[microservices]: ../architecture-styles/microservices.yml
[event-driven]: ../architecture-styles/event-driven.yml
[big-compute]: ../architecture-styles/big-compute.yml

[app-service-hybrid]: /azure/app-service/app-service-hybrid-connections
[func-premium]: /azure/azure-functions/functions-premium-plan#private-network-connectivity
[durable-functions]: /azure/azure-functions/durable/durable-functions-overview
[uptime-sla]: /azure/aks/uptime-sla
