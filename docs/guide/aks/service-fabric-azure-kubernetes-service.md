---
title: Migrate your workload from Service Fabric to AKS
description: Compare AKS to Service Fabric and learn best practices for transitioning from Service Fabric to AKS. 
author: allyford
ms.author: allyford
ms.date: 04/14/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-service-fabric
  - azure-monitor
categories:
  - containers
  - migration
---

# Migrate your workload from Service Fabric to AKS

Many organizations have moved to containerized apps as part of a push towards adopting modern app development, maintenance best practices, and cloud-native architectures. As technologies continue to evolve, organizations are evaluating the many containerized app platforms that are available in the public cloud.

There's no one-size-fits-all solution for apps, but organizations often find that [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/products/kubernetes-service) meets the requirements for many of their containerized applications. AKS is a hosted Kubernetes service that simplifies application deployments via Kubernetes by managing the control plane to provide core services for your application workloads. Many organizations are using AKS as their primary infrastructure platform and are transitioning workloads hosted on other platforms to AKS.

This article describes how to migrate containerized apps from [Azure Service Fabric](/azure/service-fabric/service-fabric-azure-clusters-overview) to AKS. The article assumes that you're familiar with Service Fabric but are interested in learning how its features and functionality compare to those of AKS. The article also provides best practices for you to consider during migration.

## Comparing AKS to Service Fabric

To start, review this [article that compares the two platforms](../technology-choices/compute-decision-tree.yml) alongside other Azure compute services. This section highlights notable similarities and differences that are relevant to migration. 

Both Service Fabric and AKS are container orchestrators. Service Fabric provides support for several programming models, whereas AKS supports only containers.

- **Programming models:** Service Fabric supports multiple ways to write and manage your services, including Linux and Windows containers, Reliable Services, Reliable Actors, ASP.NET Core, and guest executables.  
- **Containers on AKS:** AKS only supports containerization with Windows and Linux containers running on the container runtime [containerd](/azure/aks/cluster-configuration#container-runtime-configuration), which is managed automatically.

Both Service Fabric and AKS offer integrations with other Azure services, including Azure Pipelines, Azure Monitor, Azure Key Vault, and Azure Active Directory (Azure AD).

## Key differences

When you deploy a traditional Service Fabric [cluster](/azure/service-fabric/service-fabric-azure-clusters-overview), as opposed  to a managed cluster, you need to explicitly define a cluster resource together with a number of supporting resources in your ARM templates or Bicep modules. These resources include a virtual machine scale set for each cluster node type, network security groups, and load balancers. It's your responsibility to make sure that these resources are correctly configured. The encapsulation model for Service Fabric [managed clusters](/azure/service-fabric/overview-managed-cluster) consists of a single managed cluster resource. All underlying resources for the cluster are abstracted away and managed by Azure.  

[AKS](/azure/aks/intro-kubernetes) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. Because AKS is a hosted Kubernetes service, Azure handles critical tasks like infrastructure health monitoring and maintenance. Kubernetes masters are managed by Azure, so you only manage and maintain the agent nodes.

To move your workload from Service Fabric to AKS, you need to understand the differences in the underlying infrastructure so you can confidently migrate your containerized applications. The following table compares the capabilities and features of the two hosting platforms.


|Capability or component|Service Fabric|AKS| 
|-|-|-|
|Non-containerized applications |Yes| No| 
|Linux and Windows containers |Yes|Yes| 
|Azure-managed control plane|No|Yes|
|Support for both stateless and stateful workloads|Yes|Yes|
|Worker node placement|Virtual Machine Scale Sets, customer configured|Virtual Machine Scale Sets, Azure managed |
|Configuration manifest |XML|YAML| 
|Azure Monitor integration |Yes|Yes|
|Native support for Reliable Services and Reliable Actor pattern|Yes|No|
|WCF-based communication stack for Reliable Services|Yes|No|
|Persistent storage|Azure Files volume driver|Support for various storage systems, like managed disks, Azure Files, and Azure Blob Storage via CSI Storage classes, persistent volume, and persistent volume claims |
|Networking modes|Azure Virtual Network integration|Support for multiple network plug-ins (Azure CNI, kubenet, BYOCNI), network policies (Azure, Calico), and ingress controllers (Application Gateway Ingress Controller, NGINX, and more)|
|Ingress controllers |A [reverse proxy](/azure/service-fabric/service-fabric-reverseproxy) that's built in to Service Fabric. It helps microservices that run in a Service Fabric cluster discover and communicate with other services that have HTTP endpoints. You can also use [Traefik](https://doc.traefik.io/traefik/v1.7/configuration/backends/servicefabric/) on Service Fabric.  |BYO ingress controllers (open source and commercial) that use platform-managed public or internal load balancers, like [NGINX ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/#azure) and [Application Gateway Ingress Controller](/azure/application-gateway/ingress-controller-overview) |

> [!Note]
> If you use Windows containers on Service Fabric, we recommend that you also use them on AKS. Doing so will make your migration easier.

## Example architecture

AKS and Azure provide flexibility to configure your environment to fit your business needs. AKS is well integrated with other Azure services. Following is an example architecture, the [AKS baseline architecture](../../reference-architectures/containers/aks/baseline-aks.yml).

:::image type="content" source="media/example-aks-baseline-architecture.png" alt-text="Diagram that shows a baseline AKS architecture." border="false":::

As a starting point, we recommend that you familiarize yourself with some key Kubernetes concepts and then review some example architectures:

- [Kubernetes basics for AKS](/azure/aks/concepts-clusters-workloads) 
- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)

> [!Note]
> When you migrate a workload from Service Fabric to AKS, you can replace [Service Fabric Reliable Actors](/azure/service-fabric/service-fabric-reliable-actors-platform) with the Dapr [actors](https://docs.dapr.io/developing-applications/building-blocks/actors/actors-overview/) building block. You can replace [Service Fabric Reliable Collections](/azure/service-fabric/service-fabric-reliable-services-reliable-collections) with the Dapr [state management](https://docs.dapr.io/developing-applications/building-blocks/state-management/state-management-overview/) building block. 
>
> The [Distributed Application Runtime (Dapr)](https://dapr.io/) provides APIs that simplify microservice connectivity. For more information, see [Introduction to the Distributed Application Runtime](https://docs.dapr.io/concepts/overview/).

## Application and service manifest

Service Fabric and AKS have different application and service manifest file types and constructs. Service Fabric uses XML files for application and service definition. AKS uses the Kubernetes YAML file manifest to define Kubernetes objects. There are no tools that are specifically intended to migrate a Service Fabric XML file to a Kubernetes YAML file. You can, however, learn about how YAML files work on Kubernetes by reviewing the following resources.

- Kubernetes documentation: [Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/). 
- AKS documentation for Windows nodes/applications: [Create a Windows Server container on an AKS cluster by using Azure CLI](/azure/aks/learn/quick-windows-container-deploy-cli).

You can use [Helm](https://helm.sh/) to define parameterized YAML manifests and create generic templates by replacing static, hardcoded values with placeholders that can be replaced with custom values that are supplied at deployment time. The resulting templates that contain the custom values are rendered as valid manifests for Kubernetes.

[Kustomize](https://kustomize.io/) introduces a template-free way to customize application configuration that simplifies the use of off-the-shelf applications. You can use Kustomize together with Helm or as an alternative to Helm.  

For more information about Helm and Kustomize, see these resources:

- [Helm documentation](https://helm.sh/docs/)
- [Artifact Hub](https://artifacthub.io/)
- [Kustomize documentation](https://kubectl.docs.kubernetes.io/references/kustomize/)  
- [Overview of a kustomization file](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)
- [Declarative Management of Kubernetes Objects Using Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)

## Networking

AKS provides two options for the underlying network: 
- You can create a new Azure virtual network and place the AKS cluster in it. 
- You can let the AKS resource provider create a new Azure virtual network for you in the node resource group that contains all the Azure resources used by a cluster.

If you choose the second option, Azure manages the virtual network. 

Service Fabric doesn't provide a choice of network plug-ins. If you use AKS, you need to choose one:

- [kubenet](/azure/aks/configure-kubenet). If you use kubenet, nodes get an IP address from the Azure virtual network subnet. Pods receive an IP address from an address space that's logically different from that of the Azure virtual network subnet of the nodes. Network address translation (NAT) is then configured so that the pods can reach resources on the Azure virtual network. The source IP address of the traffic is translated via NAT to the node's primary IP address. This approach significantly reduces the number of IP addresses that you need to reserve in your network space for pods to use. 
- [Azure CNI](/azure/aks/configure-azure-cni). If you use [Azure Container Networking Interface (CNI)](https://github.com/Azure/azure-container-networking/blob/master/docs/cni.md), every pod gets an IP address from the subnet and can be accessed directly. These IP addresses must be unique across your network space, and must be planned in advance. Each node has a configuration parameter for the maximum number of pods that it supports. You then reserve the equivalent number of IP addresses for each node. This approach requires more planning and often leads to IP address exhaustion or the need to rebuild clusters in a larger subnet as your application demands grow. You can configure the maximum pods deployable to a node when you create the cluster or when you create new node pools.
- [Azure CNI Overlay networking](/azure/aks/azure-cni-overlay). If you use Azure CNI Overlay, the cluster nodes are deployed into an Azure Virtual Network subnet. Pods are assigned IP addresses from a private CIDR that are logically different from the address of the virtual network that hosts the nodes. Pod and node traffic within the cluster uses an overlay network. NAT (using the node's IP address) is used to reach resources outside the cluster. This solution saves a significant number of virtual network IP addresses and enables you to seamlessly scale your cluster to very large sizes. An added advantage is that you can reuse the private CIDR in different AKS clusters, which extends the IP space that's available for containerized applications in AKS. 
- [Azure CNI Powered by Cilium](/azure/aks/azure-cni-powered-by-cilium). Azure CNI Powered by Cilium combines the robust control plane of Azure CNI with the data plane of [Cilium](https://cilium.io/) to provide high-performance networking and enhanced security. 
- [Bring your own CNI plug-in](/azure/aks/use-byo-cni). Kubernetes doesn't provide a network interface system by default. This functionality is provided by [network plug-ins](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/). AKS provides several supported CNI plug-ins. For information about supported plug-ins, see [Network concepts for applications in AKS](/azure/aks/concepts-network).

Windows containers currently support only the [Azure CNI](/azure/aks/configure-azure-cni) plug-in. A variety of choices for network policies and ingress controllers are available.

In AKS, you can use Kubernetes [network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) to segregate and help secure intra-service communications by controlling which components can communicate with each other. By default, all pods in a Kubernetes cluster can send and receive traffic without limitations. To improve security, you can use [Azure network policies](/azure/aks/use-network-policies) or [Calico network policies](https://docs.tigera.io/calico/3.25/about/about-network-policy) to define rules that control the traffic flow between microservices. 

If you want to use Azure Network Policy Manager, you must use the [Azure CNI plug-in](https://github.com/Azure/azure-container-networking/blob/master/docs/cni.md). You can use Calico network policies with either the Azure CNI plug-in or the kubenet CNI plug-in. The use of Azure Network Policy Manager for Windows nodes is supported only on Windows Server 2022. For more information, see [Secure traffic between pods using network policies in AKS](/azure/aks/use-network-policies). For more information about AKS networking, see [Networking in AKS](/azure/aks/concepts-network).

In Kubernetes, an [ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) acts as a service proxy and intermediary between a service and the outside world, allowing external traffic to access the service. The service proxy typically provides various functionalities like TLS termination, path-based request routing, load balancing, and security features like authentication and authorization. Ingress controllers also provide another layer of abstraction and control for routing external traffic to Kubernetes services based on HTTP/HTTPS rules, which provides more fine-grained control over traffic flow and traffic management.

In AKS, there are multiple options for deploying, running, and operating an ingress controller. One option is the [Application Gateway Ingress Controller](/azure/application-gateway/ingress-controller-overview), which enables you to use Azure Application Gateway as the ingress controller for TLS termination, path-based routing, and as a [web access firewall](/azure/web-application-firewall/ag/ag-overview). Another option is the [NGINX ingress controller](/azure/aks/ingress-basic?tabs=azure-cli), which is a widely used open-source ingress controller that you can install by using Helm. Finally, [Traefik ingress controller](https://doc.traefik.io/traefik/providers/kubernetes-ingress/) is another popular ingress controller for Kubernetes. 

Each of these ingress controllers has strengths and weaknesses. To decide which one to use, take into account the requirements of the application and the environment. Be sure that you're using the latest release of Helm and have access to the appropriate Helm repository when you install an ingress controller.

## Persistent storage

Both Service Fabric and AKS have mechanisms to provide persistent storage to containerized applications. In Service Fabric, the Azure Files volume driver, a Docker volume plug-in, provides Azure Files volumes for Linux and Windows containers. It's packaged as a Service Fabric application that you can deploy to a Service Fabric cluster to provide volumes for other Service Fabric containerized applications within the cluster. For more information, see [Azure Files volume driver for Service Fabric](/azure/service-fabric/service-fabric-containers-volume-logging-drivers).

Applications running in AKS might need to store and retrieve data from a persistent file storage system. AKS integrates with Azure storage services like [Azure managed disks](/azure/virtual-machines/managed-disks-overview), [Azure Files](/azure/storage/files/storage-files-introduction), and [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction). It also integrates with third-party storage systems like [Rook](https://rook.io/) and [GlusterFS](https://www.gluster.org/) via Container Storage Interface (CSI) drivers. 

[CSI](https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/) is a standard for exposing block and file storage systems to containerized workloads on Kubernetes. Third-party storage providers that use CSI can write, deploy, and update plug-ins to expose new storage systems in Kubernetes, or to improve existing ones, without needing to change the core Kubernetes code and wait for its release cycles.

The CSI storage driver support on AKS enables you to natively use these Azure storage services:

- [Azure Disks](/azure/aks/azure-disk-csi). You can use Azure Disks to create a Kubernetes DataDisk resource. Disks can use Azure premium storage, backed by high-performance SSDs, or Azure standard storage, backed by Standard HDDs or SSDs. For most production and development workloads, use premium storage. Azure Disks are mounted as ReadWriteOnce and are available to only one node in AKS. For storage volumes that can be accessed by multiple pods simultaneously, use Azure Files. Service Fabric supports creating a cluster or a node type that uses managed disks, but not applications that dynamically create attached managed disks via a declarative approach. For more information, see [Deploy a Service Fabric cluster node type with managed data disks](/azure/service-fabric/service-fabric-managed-disk).  
- [Azure Files](/azure/aks/azure-files-csi). You can use Azure Files to mount an SMB 3.0 or 3.1 share backed by an Azure storage account to pods. With Azure Files, you can share data across multiple nodes and pods. Azure Files can use Azure standard storage backed by Standard HDDs or Azure premium storage backed by high-performance SSDs. Service Fabric provides an Azure Files volume driver as a [Docker volume plug-in](https://docs.docker.com/engine/extend/plugins_volume/) that provides [Azure Files](/azure/storage/files/storage-files-introduction) volumes for Docker containers. It's packaged as a Service Fabric application that can be deployed to a Service Fabric cluster to provide volumes for other Service Fabric container applications within the cluster. Service Fabric provides one version of the driver for Windows clusters and one for Linux clusters.
- [Azure Blob Storage](/azure/aks/azure-blob-csi). You can use Blob Storage to mount blob storage (or object storage) as a file system into a container or pod. Blob storage enables an AKS cluster to support applications that work with large unstructured datasets, like log file data, images or documents, and HPC. If you ingest data into [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction), you can directly mount the storage and use it in AKS without configuring another interim file system. Service Fabric doesn't support any mechanism for mounting blob storage in declarative mode.

For more information about storage options, see [Storage in AKS](/azure/aks/concepts-storage).

## Application and cluster monitoring

Both Service Fabric and AKS provide native integration with [Azure Monitor](/azure/azure-monitor/overview) and its services, like [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview). Monitoring and diagnostics are critical to developing, testing, and deploying workloads in any cloud environment. Monitoring includes infrastructure and application monitoring. For example, you can track how your applications are used, the actions taken by the Service Fabric platform, your resource utilization via performance counters, and the overall health of your cluster. You can use this information to diagnose and correct problems and prevent them from occurring in the future. For more information, see [Monitoring and diagnostics for Service Fabric](/azure/service-fabric/service-fabric-diagnostics-overview). When you host and operate containerized applications in a Service Fabric cluster, you need to set up the [container monitoring solution](/azure/service-fabric/service-fabric-diagnostics-oms-containers) to view container events and logs.  

AKS, on the other hand, has built-in integration with Azure Monitor and [Container Insights](/azure/azure-monitor/containers/container-insights-overview), which is designed to monitor the performance of containerized workloads deployed to the cloud. Container Insights provides performance visibility by collecting memory and processor metrics from controllers, nodes, and containers that are available in Kubernetes through the Metrics API. After you enable monitoring from Kubernetes clusters, metrics and container logs are automatically collected via a containerized version of the Log Analytics agent for Linux. Metrics are sent to the [metrics database in Azure Monitor](/azure/azure-monitor/essentials/data-platform-metrics). Log data is sent to your [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview). This enables you to get monitor and telemetry data for both the AKS cluster and the containerized applications that run on top of it. For more information, see [Monitor AKS with Azure Monitor](/azure/aks/monitor-aks).

As an alternative or companion solution to [Container Insights](/azure/azure-monitor/containers/container-insights-overview), you can configure your AKS cluster to collect metrics in [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview). This configuration enables you to collect and analyze metrics at scale by using a Prometheus-compatible monitoring solution, which is based on the [Prometheus](https://aka.ms/azureprometheus-promio) project. This fully managed service enables you to use the [Prometheus query language (PromQL)](https://aka.ms/azureprometheus-promio-promql) to analyze the performance of monitored infrastructure and workloads, and get alerts, without needing to operate the underlying infrastructure.

Azure Monitor managed service for Prometheus is a component of [Azure Monitor Metrics](/azure/azure-monitor/essentials/data-platform-metrics). It provides more flexibility in the types of metric data that you can collect and analyze by using Azure Monitor. Prometheus metrics share some features with platform and custom metrics, but they have some additional features to better support open-source tools like [PromQL](https://aka.ms/azureprometheus-promio-promql) and [Grafana](/azure/managed-grafana/overview).

You can configure Azure Monitor managed service for Prometheus as a data source for both [Azure Managed Grafana](/azure/managed-grafana/overview) and [self-hosted Grafana](https://grafana.com/), which can run on an Azure virtual machine. For more information, see [Use Azure Monitor managed service for Prometheus as data source for Grafana using managed system identity](/azure/azure-monitor/essentials/prometheus-grafana).

## Add-ons for AKS

When you migrate from Service Fabric to AKS, you should consider using add-ons and extensions. AKS provides additional supported functionality for your clusters via add-ons and extensions like [Kubernetes Event-driven Autoscaling (KEDA)](/azure/aks/keda-about) and [GitOps Flux v2](/azure/azure-arc/kubernetes/conceptual-gitops-flux2). Many more integrations provided by open-source projects and third parties are commonly used with AKS. These open-source and third-party integrations aren't covered by the AKS support policy. For more information, see [Add-ons, extensions, and other integrations with AKS](/azure/aks/integrations).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

- [Ally Ford](https://www.linkedin.com/in/allison-ford-pm/) | Product Manager II 
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer 
- [Brandon Smith](https://www.linkedin.com/in/brandonsmith68/) | Program Manager II 

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Senior Program Manager 
- [Moumita Dey Verma](https://www.linkedin.com/in/moumita-dey-verma-8b61692a/) | Senior Cloud Solutions Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps  

- AKS news: [AKS release notes](https://github.com/Azure/AKS/releases), the [AKS Roadmap](https://github.com/Azure/AKS/projects/1), and [Azure updates](https://azure.microsoft.com/updates/). 
- [Using Windows containers to containerize existing applications](/virtualization/windowscontainers/quick-start/lift-shift-to-containers)
- [Frequently asked questions about AKS](/azure/aks/faq)

## Related articles

- [Example migration from Service Fabric to AKS](migrate-app-service-fabric-azure-kubernetes-service.md)
- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- [Azure Kubernetes Service (AKS) architecture design](../../reference-architectures/containers/aks-start-here.md)
