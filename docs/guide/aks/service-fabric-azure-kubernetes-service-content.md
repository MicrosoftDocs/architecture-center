Many organizations have moved to containerized apps over the last several years as part of a push towards adopting modern app development, maintenance practices, and cloud native architectures.  As technologies continue to evolve and mature, part of this adoption is testing some of the many containerized app platforms that are available in the public cloud.

There is no one-size-fits-all solution for all apps, but organizations often find that the [Azure Kubernetes Service (AKS)](/azure/aks/release-tracker) can meet their requirements for many of their containerized applications. AKS is a hosted Kubernetes service that simplifies application deployments via Kubernetes by managing the control plane to provide core services for your application workloads. Most have moved towards standardizing AKS as their primary infrastructure platform and have begun transitioning workloads hosted on other platforms to AKS. The following article focuses on migrating containerized apps from [Azure Service Fabric](/azure/service-fabric/service-fabric-azure-clusters-overview) (ASF) to AKS. This article therefore assumes that you are already knowledgeable about ASF but are interested in how its features and functionality compare to AKS, while also providing a series of best practices to consider during the migration.

## Comparing the Azure Kubernetes Service to Service Fabric

To start, first take a look at this [article](../technology-choices/compute-decision-tree.yml) comparing the two hosting platforms alongside other Azure compute services. This section will highlight notable similarities and differences relevant to migration. 

While both Service Fabric and AKS are container orchestrators, Service Fabric offers support for several different programming models whereas AKS only supports containers.

- **Programming models:** Azure Service Fabric supports multiple ways to write and manage your services, including Linux and Windows containers, reliable services, reliable actors, ASP.NET Core, and Guest executables.  
- **Containers on AKS:** AKS is focused entirely on containerization with Windows and Linux containers running on  the container runtime [containerd](/azure/aks/cluster-configuration#container-runtime-configuration), which is managed automatically.

Both Service Fabric and AKS offer integrations with other Azure services including Azure Pipelines, Azure Monitor, Azure Key Vault, Azure Active Directory, and more.

## Key differences

When deploying a *Service Fabric [traditional cluster](/azure/service-fabric/service-fabric-azure-clusters-overview)*, you need to explicitly define a cluster resource alongside a number of supporting resources in your ARM templates or Bicep modules, such as a virtual machine scale set (VMSS) for each cluster node type, network security groups (NSG), load balancers, etc. It's your responsibility to make sure that these resources are correctly configured for your cluster services to function properly. The encapsulation model for *Service Fabric [managed clusters](/azure/service-fabric/overview-managed-cluster)* consists of a single, Service Fabric managed cluster resource. All underlying resources for the cluster are abstracted away and managed by Azure on your behalf.  

[Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure and is Azure’s flagship offering for developing and managing cloud native applications. As a hosted Kubernetes service, Azure handles critical tasks like infrastructure health monitoring and maintenance. Since Kubernetes masters are managed by Azure, you only manage and maintain the agent nodes. You can read more on Azure Kubernetes Service here: [Introduction to Azure Kubernetes Service](/azure/aks/intro-kubernetes). 

To move your workload from Service Fabric to AKS you will need to understand the differences in the underlying infrastructure so you can confidently and safely migrate your containerized applications. The following table compares the capabilities and features of the two hosting platforms: 


|Capability/Feature/Component|Service Fabric|Azure Kubernetes Service| 
|-|-|-|
|Non-containerized applications |Yes| No| 
|Linux and Windows containers |Yes|Yes| 
|Azure-managed control plane|No|Yes|
|Support for both stateless and stateful workloads|Yes|Yes|
|Worker node placement|VMSS – customer configured|VMSS – Azure managed |
|Configuration manifest |XML|YAML| 
|Azure Monitor integration |Yes|Yes|
|Native Support for Reliable Services and Reliable Actor Pattern|Yes|No|
|WCF-based communication stack for Reliable Services|Yes|No|
|Persistent Storage|Azure volume driver|Support for various storage systems such as managed disks, Azure Files, and Azure Blob Storage via CSI Storage classes, persistent volume, and persistent volume claims |
|Networking modes|Azure Virtual Network integration|Support for multiple network plugins (Azure CNI, kubenet, BYOCNI), network policies (Azure, Calico), and ingress controllers (Application Gateway Ingress Controller, NGINX, etc.)|
|Ingress Controllers |The [reverse proxy](/azure/service-fabric/service-fabric-reverseproxy) built into Azure Service Fabric helps microservices running in a Service Fabric cluster discover and communicate with other services that have http endpoints. You can also use [Traefik](https://doc.traefik.io/traefik/v1.7/configuration/backends/servicefabric/) on Azure Service Fabric.  |BYO Ingress Controllers (open source, commercial) that leverage Platform managed Public or Internal Load Balancers e.g. [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/#azure) and [Application Gateway Ingress Controller](/azure/application-gateway/ingress-controller-overview) |

> [!Note]
> If you’re already using Windows containers on Service Fabric, we recommend keeping the same on AKS as the migration will be easier.

Example architecture 

AKS and Azure provide flexibility to configure your environment to fit your business needs. AKS can be configured in many ways and is well integrated with other Azure services. Below is an example architecture, the AKS baseline architecture.

image 

Figure 1: Example [AKS Architecture](../../reference-architectures/containers/aks/baseline-aks.yml). 

As a starting point, we recommend that you familiarize yourself with key Kubernetes concepts for AKS and then take a look through some example architectures in AKS:

- [Concepts - Kubernetes basics for Azure Kubernetes Services (AKS) - Azure Kubernetes Service](/azure/aks/concepts-clusters-workloads) 
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../../reference-architectures/containers/aks/baseline-aks.yml)

> [!Note]
> When migrating a workload from Service Fabric to Azure Kubernetes Service, [Service Fabric Reliable Actors](/azure/service-fabric/service-fabric-reliable-actors-platform) can be replaced with the Dapr [Actors](/azure/service-fabric/service-fabric-reliable-actors-platform) building block, while [Service Fabric Reliable Collections](/azure/service-fabric/service-fabric-reliable-services-reliable-collections) can be replaces using the Dapr [State Management](https://docs.dapr.io/developing-applications/building-blocks/state-management/state-management-overview/) building block. The [Distributed Application Runtime (Dapr)](https://dapr.io/) provides APIs that simplify microservice connectivity. Whether your communication pattern is service to service invocation or pub/sub messaging, Dapr helps you write resilient and secured microservices. For more information, see [Introduction to the Distributed Application Runtime](https://docs.dapr.io/concepts/overview/).

## Application and service manifest

Service Fabric and AKS differ in application and service manifest file types and constructs. Service Fabric uses XML files for application and service definition, while AKS uses Kubernetes’ YAML file manifest to define Kubernetes objects. There are no specific tools to migrate a Service Fabric XML file into a Kubernetes YAML file, however you can find more information on how YAML files work on Kubernetes here:

- Kubernetes official documentation: [Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/). 
- AKS documentation for Windows nodes/applications: [Create a Windows Server container on an AKS cluster by using Azure CLI](/azure/aks/learn/quick-windows-container-deploy-cli).

You can use [Helm](https://helm.sh/) to define parameterized YAML manifests and create generic templates by replacing static, hardcoded values with placeholders that can be filled in with custom values supplied at deployment time. The resulting templates with the values filled in are rendered as valid manifests for Kubernetes.  

[Kustomize](https://kustomize.io/) introduces a template-free way to customize application configuration that simplifies the use of off-the-shelf applications. You can use Kustomize as an alternative or companion tool to Helm.  

For more information on Helm and Kustomize, see the following resources:

- [Helm Documentation](https://helm.sh/docs/)
- [Artifact Hub](https://artifacthub.io/)
- [Kustomize Documentation](https://kubectl.docs.kubernetes.io/references/kustomize/)  
- [kustomization](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)
- [Declarative Management of Kubernetes Objects Using Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)

## Networking concepts

AKS provides two options for the underlying network: You can create a new Azure Virtual Network and place the AKS cluster in it, or you can let the AKS resource provider create a new Azure Virtual Network for you in the node resource group which contains all the Azure resources used by a cluster. If you choose the latter, Azure will manage the virtual network for you. 

Unlike ASF where you don’t have a choice, in AKS, you must select a network plugin:

- [Kubenet](/azure/aks/configure-kubenet): with *kubenet*, nodes get an IP address from the Azure virtual network subnet. Pods receive an IP address from a logically different address space to the Azure virtual network subnet of the nodes. Network address translation (NAT) is then configured so that the pods can reach resources on the Azure virtual network. The source IP address of the traffic is NAT'd to the node's primary IP address. This approach greatly reduces the number of IP addresses that you need to reserve in your network space for pods to use. 
- [Azure CNI](/azure/aks/configure-azure-cni): With [Azure Container Networking Interface (CNI)](https://github.com/Azure/azure-container-networking/blob/master/docs/cni.md), every pod gets an IP address from the subnet and can be accessed directly. These IP addresses must be unique across your network space, and must be planned in advance. Each node has a configuration parameter for the maximum number of pods that it supports. The equivalent number of IP addresses per node are then reserved up front for that node. This approach requires more planning, and often leads to IP address exhaustion or the need to rebuild clusters in a larger subnet as your application demands grow. You can configure the maximum pods deployable to a node at cluster create time or when creating new node pools.
- [Azure CNI Overlay networking](/azure/aks/azure-cni-overlay): With Azure CNI Overlay, the cluster nodes are deployed into an Azure Virtual Network (VNet) subnet, whereas pods are assigned IP addresses from a private CIDR logically different from the VNet hosting the nodes. Pod and node traffic within the cluster use an overlay network, and Network Address Translation (using the node's IP address) is used to reach resources outside the cluster. This solution saves a significant amount of VNet IP addresses and enables you to seamlessly scale your cluster to very large sizes. An added advantage is that the private CIDR can be reused in different AKS clusters, truly extending the IP space available for containerized applications in AKS. 
- [Azure CNI Powered by Cilium](/azure/aks/azure-cni-powered-by-cilium): Azure CNI Powered by Cilium combines the robust control plane of Azure CNI with the data plane of [Cilium](https://cilium.io/) to provide high-performance networking and security. 
- [Bring your own Container Network Interface (CNI) plugin](/azure/aks/use-byo-cni?tabs=azure-cli): Kubernetes does not provide a network interface system by default; this functionality is provided by [network plugins](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/). Azure Kubernetes Service provides several supported CNI plugins. Documentation for supported plugins can be found from the [networking concepts page](/azure/aks/concepts-network).

Currently, Windows containers only support the [Azure CNI]() plugin. Furthermore, customers have a variety of choices for network policies and ingress controllers.

In AKS you can use Kubernetes [Network Policies]() to segregate and secure intra-service communications by controlling which components can communicate with each other. By default, all pods in a Kubernetes cluster can send and receive traffic without limitations. To improve security, you can use [Azure Network Policies](/azure/aks/use-network-policies) or [Calico Network Policies](https://docs.tigera.io/calico/3.25/about/about-network-policy) to define rules that control the traffic flow between different microservices. To use Azure Network Policy Manager, you must use the [Azure CNI plug-in](https://github.com/Azure/azure-container-networking/blob/master/docs/cni.md). Calico Network Policy could be used with either this same Azure CNI plug-in or with the Kubenet CNI plug-in. Azure Network Policy Manager with Windows nodes is available on Windows Server 2022 only. For more information, see [Secure traffic between pods using network policies in Azure Kubernetes Service (AKS)](/azure/aks/use-network-policies). For more information on AKS networking, see [Networking in Azure Kubernetes Services (AKS)](/azure/aks/concepts-network).

In Kubernetes, an [ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) acts as a service proxy and intermediary between a service and the outside world, allowing external traffic to access the service. The service proxy typically provides various functionalities such as TLS termination, path-based request routing, load balancing, and security features like authentication and authorization. On the other hand, ingress controllers provide an additional layer of abstraction and control for routing external traffic to Kubernetes services based on HTTP/HTTPS rules, providing more fine-grained control over traffic flow and traffic management. Ingress controllers can also perform TLS termination and provide other security features. 

In Azure Kubernetes Service (AKS), there are multiple options for deploying, running, and operating an ingress controller. One option is to use the [Application Gateway Ingress Controller](/azure/application-gateway/ingress-controller-overview), which allows you to use Azure Application Gateway as the ingress controller for TLS termination, path-based routing, and [web access firewall](/azure/web-application-firewall/ag/ag-overview). Another option is to use the [NGINX ingress controller](/azure/aks/ingress-basic?tabs=azure-cli), which is an open-source, widely-used ingress controller that can be installed using Helm. Finally, [Traefik Ingress Controller](https://doc.traefik.io/traefik/providers/kubernetes-ingress/) is another popular option for ingress controller in Kubernetes. 

Each of these ingress controllers has its own strengths and weaknesses, and the choice of which one to use depends on the specific requirements of the application and the environment. It is important to ensure that you are using the latest release of Helm and have access to the appropriate Helm repository when installing an ingress controller. 