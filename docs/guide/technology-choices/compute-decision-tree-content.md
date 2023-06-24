Azure offers many ways to host your application code. The term *compute* refers to the hosting model for the resources that your application runs on. This article helps you choose a compute service for your application.

## Choose a candidate service

You can use the following flowchart to select a candidate compute service.

:::image type="content" source="./images/compute-choices.png" alt-text="Diagram of decision tree for Azure compute services." border="false":::

This diagram refers to these two migration strategies:

- *Lift and shift* is a strategy for migrating a workload to the cloud without redesigning the application or making code changes. It's also called *rehosting*. For more information, see [Azure migration and modernization center](https://azure.microsoft.com/migration).
- *Cloud optimized* is a strategy for migrating to the cloud by refactoring an application to take advantage of cloud-native features and capabilities.

The output from this flowchart is your starting point. Next, evaluate the service in more detail to see if it meets your needs.

This article includes several tables that can help you choose a service. The initial candidate from the flowchart might be unsuitable for your application or workload. In that case, expand your analysis to include other compute services.

If your application consists of multiple workloads, evaluate each workload separately. A complete solution can incorporate two or more compute services.

## Understand the basic features

If you're not familiar with the Azure service selected in the previous section, see this overview documentation:

- [Azure Virtual Machines](/azure/virtual-machines). A service where you deploy and manage virtual machines (VMs) inside an Azure virtual network.
- [Azure App Service](/azure/app-service). A managed service for hosting web apps, mobile app back ends, RESTful APIs, or automated business processes.
- [Azure Functions](/azure/azure-functions/functions-overview). A managed function as a service (FaaS) service.
- [Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS). A managed Kubernetes service for running containerized applications.
- [Azure Container Apps](/azure/container-apps). A managed service built on Kubernetes, which simplifies the deployment of containerized applications in a serverless environment.
- [Azure Container Instances](/azure/container-instances/container-instances-overview). This service is a fast and simple way to run a container in Azure. You don't have to provision any virtual machines or adopt a higher-level service.
- [Azure Red Hat OpenShift](/azure/openshift). A fully managed OpenShift cluster for running containers in production with Kubernetes.
- [Azure Spring Apps](/azure/spring-apps). A managed service designed and optimized for hosting Spring Boot apps.
- [Azure Service Fabric](/azure/service-fabric/service-fabric-overview). A distributed systems platform that can run in many environments, including Azure or on-premises.
- [Azure Batch](/azure/batch/batch-technical-overview). A managed service for running large-scale parallel and high-performance computing (HPC) applications.

## Understand the hosting models

For hosting models, cloud services fall into three categories:

- **Infrastructure-as-a-Service** (IaaS) lets you provision virtual machines and the associated networking and storage components. Then deploy whatever software and applications you want onto those virtual machines. This model is the closest to a traditional on-premises environment. Microsoft manages the infrastructure. You still manage the virtual machines.

- **Platform-as-a-Service** (PaaS) provides a managed hosting environment where you can deploy your application without needing to manage virtual machines or networking resources. Azure App Service and Azure Container Apps are PaaS services.

- **Functions-as-a-Service** (FaaS) lets you deploy your code to the service, which automatically runs it. Azure Functions is a FaaS service.

  > [!NOTE]
  > Azure Functions is an [Azure serverless](https://azure.microsoft.com/solutions/serverless/#solutions) compute offering. To see how this service compares with other Azure serverless offerings, such as Logic Apps, which provides serverless workflows, see [Choose the right integration and automation services in Azure](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs).

There's a spectrum from IaaS to pure PaaS. For example, Azure virtual machines can automatically scale using virtual machine scale sets. This capability isn't strictly a PaaS, but it's the type of management feature in PaaS.

There's a tradeoff between control and ease of management. IaaS gives the most control, flexibility, and portability, but you must provision, configure, and manage the virtual machines and network components you create. FaaS services automatically manage nearly all aspects of running an application. PaaS falls somewhere in between.

| Service | Application composition | Density | Minimum number of nodes | State management | Web hosting |
|----------|-----------------|-------------|---------|----------------|-----------------|
| **Azure Virtual Machines** | Agnostic | Agnostic | 1 <a href="#note2"><sup>2</sup></a> | Stateless or stateful | Agnostic |
| **Azure App Service** | Applications, containers | Multiple apps per instance by using app service plan | 1 | Stateless | Built in |
| **Azure Functions** | Functions, containers | Serverless <a href="#note1"><sup>1</sup></a> | Serverless <a href="#note1"><sup>1</sup></a> | Stateless or stateful <a href="#note6"><sup>6</sup></a> | Not applicable |
| **Azure Kubernetes Service** | Containers | Multiple containers per node | 3 <a href="#note3"><sup>3</sup></a> | Stateless or stateful | Agnostic |
| **Azure Container Apps** | Containers | Serverless | Serverless | Stateless or stateful | Agnostic |
| **Azure Container Instances** | Containers | No dedicated instances | No dedicated nodes | Stateless | Agnostic |
| **Azure Red Hat OpenShift** | Containers | Multiple containers per node | 6 <a href="#note5"><sup>5</sup></a> | Stateless or stateful | Agnostic |
| **Azure Spring Apps** | Applications, microservices | Multiple apps per service instance | 2 | Stateless | Built in |
| **Azure Service Fabric** | Services, guest executables, containers | Multiple services per VM | 5 <a href="#note3"><sup>3</sup></a> | Stateless or stateful | Agnostic |
| **Azure Batch** | Scheduled jobs | Multiple apps per VM | 1 <a href="#note4"><sup>4</sup></a> | Stateless | No |

Notes

1. <span id="note1">If you're using a Consumption plan. For an App Service plan, functions run on the VMs allocated for your App Service plan. See [Choose the correct service plan for Azure Functions][function-plans].</span>
2. <span id="note2">Higher SLA with two or more instances.</span>
3. <span id="note3">Recommended for production environments.</span>
4. <span id="note4">Can scale down to zero after the job completes.</span>
5. <span id="note5">Three for primary and worker nodes.</span>
6. <span id="note6">When using [Durable Functions][durable-functions].</span>

## Networking

| Service | VNet integration | Hybrid connectivity |
|----------|-----------------|-------------|
| **Azure Virtual Machines** | Supported | Supported |
| **Azure App Service** | Supported <a href="#note7"><sup>1</sup></a> | Supported <a href="#note8"><sup>2</sup></a> |
| **Azure Functions** | Supported <a href="#note7"><sup>1</sup></a> | Supported <a href="#note9"><sup>3</sup></a> |
| **Azure Kubernetes Service** | [Supported](/azure/aks/networking-overview) | Supported |
| **Azure Container Apps** | Supported | Supported |
| **Azure Container Instances** | [Supported](/azure/container-instances/container-instances-vnet) | [Supported](/azure/container-instances/container-instances-virtual-network-concepts#scenarios)  |
| **Azure Red Hat OpenShift** | [Supported](/azure/openshift/concepts-networking) | Supported |
| **Azure Spring Apps** | Supported | Supported |
| **Azure Service Fabric** | Supported | Supported |
| **Azure Batch** | Supported | Supported |

Notes

1. <span id="note7">Requires App Service Environment (ASE).</span>
2. <span id="note8">Use [Azure App Service Hybrid Connections][app-service-hybrid].</span>
3. <span id="note9">Requires App Service plan or [Azure Functions Premium plan][func-premium].</span>

## DevOps

| Service | Local debugging | Programming model | Application update|
|----------|-----------------|-----------------|-----------------|
| **Azure Virtual Machines** | Agnostic | Agnostic | No built-in support |
| **Azure App Service** | IIS Express, others <a href="#note1b"><sup>1</sup></a> | Web and API applications, WebJobs for background tasks | Deployment slots |
| **Azure Functions** | Visual Studio or Azure Functions CLI | Serverless, event-driven | Deployment slots |
| **Azure Kubernetes Service** | Minikube, Docker, others | Agnostic | Rolling update |
| **Azure Container Apps** | Local container runtime | Agnostic | Revision management |
| **Azure Container Instances** | Local container runtime | Agnostic | Not applicable |
| **Azure Red Hat OpenShift** | Minikube, Docker, others | Agnostic | Rolling update |
| **Azure Spring Apps** | Visual Studio Code, Intellij, Eclipse | Spring Boot, Steeltoe | Rolling upgrade, Blue-green deployment |
| **Azure Service Fabric** | Local node cluster | Guest executable, Service model, Actor model, Containers | Rolling upgrade (per service) |
| **Azure Batch** | Not supported | Command line application | Not applicable |

Notes

1. <span id="note1b">Options include IIS Express for ASP.NET or node.js (iisnode), PHP web server, Azure Toolkit for IntelliJ, and Azure Toolkit for Eclipse. App Service also supports remote debugging of deployed web app.</span>

## Scalability

| Service | Autoscaling | Load balancer | Scale limit<a href="#note3c"><sup>3</sup></a>|
|----------|-----------------|-----------------|-----------------|
| **Azure Virtual Machines** | Virtual machine scale sets | Azure Load Balancer | Platform image: 1000 nodes per scale set, Custom image: 600 nodes per scale set |
| **Azure App Service** | Built-in service | Integrated | 30 instances, 100 with App Service Environment |
| **Azure Functions** | Built-in service | Integrated | 200 instances per Function app |
| **Azure Kubernetes Service** | Pod auto-scaling<a href="#note1c"><sup>1</sup></a>, cluster auto-scaling<a href="#note2c"><sup>2</sup></a> | Azure Load Balancer or Application Gateway | 5,000 nodes when using [Uptime SLA][uptime-sla] |
| **Azure Container Apps** | Scaling rules<a href="#note4c"><sup>4</sup></a> | Integrated | 5 environments per region, 20 container apps per environment, 30 replicas per container app |
| **Azure Container Instances** | Not supported | No built-in support | 20 container groups per subscription (default limit) |
| **Azure Red Hat OpenShift** | Pod auto-scaling, cluster auto-scaling | Azure Load Balancer or Application Gateway | 60 nodes per cluster (default limit) |
| **Azure Spring Apps** | Built-in service | Integrated | 500 app instances in Standard |
| **Azure Service Fabric** | Virtual machine scale sets | Azure Load Balancer | 100 nodes per virtual machine scale set |
| **Azure Batch** | Not applicable | Azure Load Balancer | 20 core limit (default limit) |

Notes

1. <span id="note1c">See [Autoscale pods](/azure/aks/tutorial-kubernetes-scale#autoscale-pods).</span>
2. <span id="note2c">See [Automatically scale a cluster to meet application demands on Azure Kubernetes Service (AKS)](/azure/aks/cluster-autoscaler).</span>
3. <span id="note3c">See [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits)</span>.
4. <span id="note4c">See [Set scaling rules in Azure Container Apps](/azure/container-apps/scale-app)</span>.

## Availability

| Service | SLA | Multi region failover |
|----------|-----------------|-----------------|
| **Azure Virtual Machines** | [SLA for Virtual Machines][sla-vm] | Azure Traffic Manager, Azure Front Door, and cross-region Azure Load Balancer |
| **Azure App Service** | [SLA for App Service][sla-app-service] | Azure Traffic Manager and Azure Front Door |
| **Azure Functions** | [SLA for Functions][sla-functions] | Azure Traffic Manager and Azure Front Door |
| **Azure Kubernetes Service** | [SLA for AKS][sla-acs] | Azure Traffic Manager, Azure Front Door, and Multi-Region Cluster |
| **Azure Container Apps** | [SLA for Azure Container Apps][sla-aca] | Azure Traffic Manager and Azure Front Door |
| **Azure Container Instances** | [SLA for Container Instances](https://azure.microsoft.com/support/legal/sla/container-instances) | Azure Traffic Manager and Azure Front Door |
| **Azure Red Hat OpenShift** | [SLA for Azure Red Hat OpenShift][sla-aro] | Azure Traffic Manager and Azure Front Door |
| **Azure Spring Apps** | [SLA for Azure Spring Apps][sla-azure-spring-apps] | Azure Traffic Manager, Azure Front Door, and Multi-Region Cluster |
| **Azure Service Fabric** | [SLA for Service Fabric][sla-sf] | Azure Traffic Manager, Azure Front Door, and cross-region Azure Load Balancer |
| **Azure Batch** | [SLA for Azure Batch][sla-batch] | Not applicable |

For guided learning on Service Guarantees, review [Core Cloud Services - Azure architecture and service guarantees](/training/modules/explore-azure-infrastructure).

## Security

Review and understand the available security controls and visibility for each service:

- [Azure Windows Virtual machine](/azure/virtual-machines/windows/security-baseline)
- [Azure Linux Virtual machine](/azure/virtual-machines/linux/security-baseline)
- [Azure App Service](/azure/app-service/overview-security)
- [Azure Functions](/azure/azure-functions/security-baseline)
- [Azure Kubernetes Service](/azure/aks/security-baseline)
- [Azure Container Instances](/azure/container-instances/security-baseline)
- [Azure Spring Apps](/azure/spring-cloud/concept-security-controls)
- [Azure Service Fabric](/azure/service-fabric/security-baseline)
- [Azure Batch](/azure/batch/security-baseline)

## Other criteria

| Service | TLS | Cost | Suitable architecture styles|
|----------|-----------------|-----------------|-----------------|
| **Azure Virtual Machines** | Configured in VM | [Windows][cost-windows-vm], [Linux][cost-linux-vm] | [N-Tier][n-tier], [Big compute][big-compute] (HPC) |
| **Azure App Service** | Supported | [App Service pricing][cost-app-service] | [Web-Queue-Worker][w-q-w] |
| **Azure Functions** | Supported | [Azure Functions pricing][cost-functions] | [Microservices][microservices], [Event-driven architecture][event-driven] |
| **Azure Kubernetes Service** | [Ingress controller](/azure/aks/ingress) | [AKS pricing][cost-acs] | [Microservices][microservices], [Event-driven architecture][event-driven] |
| **Azure Container Apps** |  [Ingress controller](/azure/container-apps/ingress) | [Azure Container Apps pricing][cost-container-apps] | [Microservices][microservices], [Event-driven architecture][event-driven] |
| **Azure Container Instances** | Use [sidecar](../../patterns/sidecar.yml) container | [Azure Container Instances pricing](https://azure.microsoft.com/pricing/details/container-instances) | [Microservices][microservices], task automation, batch jobs |
| **Azure Red Hat OpenShift** | Supported | [Azure Red Hat OpenShift pricing][cost-aro] | [Microservices][microservices], [Event-driven architecture][event-driven] |
| **Azure Spring Apps** | Supported | [Azure Spring Apps pricing][cost-azure-spring-apps] | Spring Boot, [Microservices][microservices] |
| **Azure Service Fabric** | Supported | [Azure Service Fabric pricing][cost-service-fabric] | [Microservices][microservices], [Event-driven architecture][event-driven] |
| **Azure Batch** | Supported | [Azure Batch pricing][cost-batch] | [Big compute][big-compute] (HPC) |

## Consider limits and cost

Along with the previous comparison tables, do a more detailed evaluation of the following aspects of the candidate service:

- [Service limits](/azure/azure-subscription-service-limits)
- [Cost](https://azure.microsoft.com/pricing)
- [SLA](https://azure.microsoft.com/support/legal/sla)
- [Regional availability](https://azure.microsoft.com/global-infrastructure/services)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | Senior Program Manager
- [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | Principal Service Engineer
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski) | Senior Service Engineer
- [Phil Huang](https://www.linkedin.com/in/phil-huang-09b09895) | Senior Cloud Solution Architect
- [Julie Ng](https://www.linkedin.com/in/julie-io) | Senior Service Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Core Cloud Services - Azure compute options](/training/modules/intro-to-azure-compute). This Microsoft Learn module explores how compute services can solve common business needs.

## Related resources

- [Choose an Azure compute option for microservices](../../microservices/design/compute-options.md)
- [Lift and shift to containers with Azure App Service](../../solution-ideas/articles/migrate-existing-applications-to-container-apps.yml)
- [Technology choices for Azure solutions](technology-choices-overview.md)

[cost-linux-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/linux
[cost-windows-vm]: https://azure.microsoft.com/pricing/details/virtual-machines/windows
[cost-app-service]: https://azure.microsoft.com/pricing/details/app-service
[cost-service-fabric]: https://azure.microsoft.com/pricing/details/service-fabric
[cost-azure-spring-apps]: https://azure.microsoft.com/pricing/details/spring-cloud/
[cost-functions]: https://azure.microsoft.com/pricing/details/functions
[cost-acs]: https://azure.microsoft.com/pricing/details/kubernetes-service
[cost-batch]: https://azure.microsoft.com/pricing/details/batch
[cost-container-apps]: https://azure.microsoft.com/pricing/details/container-apps
[cost-aro]:https://azure.microsoft.com/pricing/details/openshift

[function-plans]: /azure/azure-functions/functions-scale
[sla-acs]: https://azure.microsoft.com/support/legal/sla/kubernetes-service
[sla-app-service]: https://azure.microsoft.com/support/legal/sla/app-service
[sla-azure-spring-apps]: https://azure.microsoft.com/support/legal/sla/spring-apps
[sla-batch]: https://azure.microsoft.com/support/legal/sla/batch
[sla-functions]: https://azure.microsoft.com/support/legal/sla/functions
[sla-sf]: https://azure.microsoft.com/support/legal/sla/service-fabric
[sla-vm]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[sla-aro]: https://azure.microsoft.com/support/legal/sla/openshift/
[sla-aca]: https://azure.microsoft.com/support/legal/sla/container-apps

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
