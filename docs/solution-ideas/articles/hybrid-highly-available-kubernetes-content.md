[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to architect and operate a highly available Kubernetes-based infrastructure using Azure Kubernetes Service (AKS) Engine on Azure Stack Hub. This scenario is common for organizations with critical workloads in highly restricted and regulated environments. Organizations in domains such as finance, defense, and government.

## Potential use cases

Many organizations are developing cloud-native solutions that leverage state-of-the-art services and technologies like Kubernetes. Although Azure provides datacenters in most regions of the world, sometimes there are edge use-cases and scenarios where business critical applications must run in a specific location. Considerations include:

- Location sensitivity
- Latency between the application and on-premises systems
- Bandwidth conservation
- Connectivity
- Regulatory or statutory requirements

Azure, in combination with Azure Stack Hub, addresses most of these concerns. A broad set of options, decisions, and considerations for a successful implementation of Kubernetes running on Azure Stack Hub is described below.

This solution that we have to deal with a strict set of constraints. The application must run on-premises and all personal data must not reach public cloud services. Monitoring and other non-PII data can be sent to Azure and be processed there. External services like a public Container Registry or others can be accessed but might be filtered through a firewall or proxy server.

The sample application shown here (based on Azure Kubernetes Service Workshop) is designed to use Kubernetes-native solutions whenever possible. This design avoids vendor lock-in, instead of using platform-native services. As an example, the application uses a self-hosted MongoDB database backend instead of a PaaS service or external database service.

## Architecture

The architecture contains only a single application deployment. To achieve high availability (HA), we'll run the deployment at least twice on two different Azure Stack Hub instances - they can run either in the same location or in two (or more) different sites.
Services like Azure Container Registry, Azure Monitor, and others, are hosted outside Azure Stack Hub in Azure or on-premises. This hybrid design protects the solution against outage of a single Azure Stack Hub instance.

![Architecture diagram](../media/hybrid-highly-available-kubernetes.png)  
_Download an [Visio](https://arch-center.azureedge.net/hybrid-highly-available-kubernetes.vsdx) of this architecture._

### Data flow

1. The client request the application
1. Azure Traffic Manager send the request to some available backend
1. Some Kubernetes backend running on Azure Stack Hub takes the request and generates the response
1. The Kubernetes clusters send information to Azure Monitor as a single pane of glass
1. Azure Pipelines automatically builds and tests code projects and then deploy it.

### Components

- [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub/) is an extension of Azure that can run workloads in an on-premises environment by providing Azure services in your datacenter.
- [Azure Kubernetes Service Engine (AKS Engine)](https://github.com/Azure/aks-engine) is the engine behind the managed Kubernetes service offering, Azure Kubernetes Service (AKS), that is available in Azure today. For Azure Stack Hub, AKS Engine allows us to deploy, scale, and upgrade fully featured, self-managed Kubernetes clusters using Azure Stack Hub's IaaS capabilities.
  Go to [Known Issues and Limitations](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#known-issues-and-limitations) to learn more about the differences between AKS Engine on Azure and AKS Engine on Azure Stack Hub.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) (VNet) is used to provide the network infrastructure on each Azure Stack Hub for the Virtual Machines (VMs) hosting the Kubernetes cluster infrastructure.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer/) is used for the Kubernetes API Endpoint and the Nginx Ingress Controller. The load balancer routes external (for example, Internet) traffic to nodes and VMs offering a specific service.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) (ACR) is used to store private Docker images and Helm charts, which are deployed to the cluster. AKS Engine can authenticate with the Container Registry using an Azure AD identity. Kubernetes doesn't require ACR. You can use other container registries, such as Docker Hub.
- [Azure Repos](https://azure.microsoft.com/services/devops/repos/) is a set of version control tools that you can use to manage your code. You can also use GitHub or other git-based repositories.
- [Azure Pipelines](hhttps://azure.microsoft.com/services/devops/pipelines/) is part of Azure DevOps Services and runs automated builds, tests, and deployments. You can also use third-party CI/CD solutions such as Jenkins.
- [Azure Monitor](https://azure.microsoft.com/services/monitor/) collects and stores metrics and logs, including platform metrics for the Azure services in the solution and application telemetry. Use this data to monitor the application, set up alerts and dashboards, and perform root cause analysis of failures. Azure Monitor integrates with Kubernetes to collect metrics from controllers, nodes, and containers, as well as container logs and master node logs.
- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) is a DNS-based traffic load balancer that enables you to distribute traffic optimally to services across different Azure regions or Azure Stack Hub deployments. Traffic Manager also provides high availability and responsiveness. The application endpoints must be accessible from the outside. There are other on-premises solutions available as well.

### Alternatives

For web applications, you can use [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/front-door-overview). It works at Layer 7 (HTTP/HTTPS layer) using anycast protocol with split TCP and Microsoft's global network to improve global connectivity. Based on your routing method you can ensure that Front Door will route your client requests to the fastest and most available application backend.

It could be possible to use [GitHub](https://github.com/) as git repository and [GitHub Actions](https://github.com/features/actions) as build process and automatic deployment.

## Considerations

### Reliability

Business continuity and disaster recovery (BCDR) is an important topic in both Azure Stack Hub and Azure. The main difference is that in Azure Stack Hub, the operator must manage the whole BCDR process. In Azure, parts of BCDR are automatically managed by Microsoft.

#### Application

The application shouldn't rely on backups of a deployed instance. As a standard practice, redeploy the application completely following Infrastructure-as-Code patterns. For example, redeploy using Azure DevOps Azure Pipelines. The BCDR procedure should involve the redeployment of the application to the same or another Kubernetes cluster.
Application data is the critical part to minimize data loss. In the previous section, techniques to replicate and synchronize data between two (or more) instances of the application were described. Depending on the database infrastructure (MySQL, MongoDB, MSSQL or others) used to store the data, there will be different database availability and backup techniques available to choose from.

The recommended ways to achieve integrity are to use either:

- A native backup solution for the specific database.
- A backup solution that officially supports backup and recovery of the database type used by your application.

#### Cluster

Considerations when working with data across multiple locations is an even more complex consideration for a highly available and resilient solution. Consider:

- Latency and network connectivity between Azure Stack Hubs.
- Availability of identities for services and permissions. Each Azure Stack Hub instance integrates with an external directory. During deployment, you choose to use either Azure Active Directory (Azure AD) or Active Directory Federation Services (ADFS). As such, there's potential to use a single identity that can interact with multiple independent Azure Stack Hub instances.

#### Azure Stack Hub

This section covers the physical and logical infrastructure and the configuration of Azure Stack Hub. It covers actions in the admin and the tenant spaces.

The Azure Stack Hub operator (or administrator) is responsible for maintenance of the Azure Stack Hub instances. Including components such as the network, storage, identity, and other topics that are outside the scope of this article. To learn more about the specifics of Azure Stack Hub operations, see the following resources:

- [Recover data in Azure Stack Hub with the Infrastructure Backup Service](https://docs.microsoft.com/azure-stack/operator/azure-stack-backup-infrastructure-backup)
- [Enable backup for Azure Stack Hub from the administrator portal](https://docs.microsoft.com/azure-stack/operator/azure-stack-backup-enable-backup-console)
- [Recover from catastrophic data loss](https://docs.microsoft.com/azure-stack/operator/azure-stack-backup-recover-data)
- [Infrastructure Backup Service best practices](https://docs.microsoft.com/azure-stack/operator/azure-stack-backup-best-practices)

### Security

#### Application

For the application layer, the most important consideration is whether the application is exposed and accessible from the Internet. From a Kubernetes perspective, Internet accessibility means exposing a deployment or pod using a Kubernetes Service or an Ingress Controller
Exposing an application using a public IP via a Load Balancer or an Ingress Controller doesn't necessarily mean that the application is now accessible via the Internet. It's possible for Azure Stack Hub to have a public IP address that is only visible on the local intranet - not all public IPs are truly Internet-facing.

Another topic that must be considered for a successful Kubernetes deployment is outbound/egress traffic. Here are a few use cases that require egress traffic:

- Pulling Container Images stored on DockerHub or Azure Container Registry
- Retrieving Helm Charts
- Emitting Application Insights data (or other monitoring data)

Some enterprise environments might require the use of transparent or non-transparent proxy servers. These servers require specific configuration on various components of our cluster. The AKS Engine documentation contains various details on how to accommodate network proxies. For more details, see [AKS Engine and proxy](https://github.com/Azure/aks-engine/blob/master/docs/topics/proxy-servers.md) servers.

Lastly, cross-cluster traffic must flow between Azure Stack Hub instances. The sample deployment consists of individual Kubernetes clusters running on individual Azure Stack Hub instances. Traffic between them, such as the replication traffic between two databases, is "external traffic". External traffic must be routed through either a Site-to-Site VPN or Azure Stack Hub Public IP addresses to connect Kubernetes on two Azure Stack Hub instances.

#### Cluster

The Kubernetes cluster doesn't necessarily need to be accessible via the Internet. The relevant part is the Kubernetes API used to operate a cluster, for example, using kubectl. The Kubernetes API endpoint must be accessible to everyone who operates the cluster or deploys applications and services on top of it.

On the cluster level, there are also a few considerations around egress-traffic:

- Node updates (for Ubuntu)
- Monitoring data (sent to Azure LogAnalytics)
- Other agents requiring outbound traffic (specific to each deployer's environment)

#### Azure Stack Hub

Security considerations and compliance regulations are among the main drivers for using hybrid clouds. Azure Stack Hub is designed for these scenarios.

Two security posture layers coexist in Azure Stack Hub. The first layer is the Azure Stack Hub infrastructure, which includes the hardware components up to the Azure Resource Manager. The first layer includes the administrator and the user portals. The second layer consists of the workloads created, deployed, and managed by tenants. The second layer includes items like virtual machines and App Services web sites. See [Azure Stack Hub infrastructure security controls](https://docs.microsoft.com/azure-stack/operator/azure-stack-security-foundations)

### Operational excellence

#### Application

The application should be stored in a Git-based repository. Whenever there's a new deployment, changes to the application, or disaster recovery, it can be easily deployed using Azure Pipelines.

#### Cluster

Configuration includes the configuration of Azure Stack Hub, AKS Engine, and the Kubernetes cluster itself. The configuration should be automated as much as possible, and stored as Infrastructure-as-Code in a Git-based version control system like Azure DevOps or GitHub. These settings cannot easily be synchronized across multiple deployments. Therefore we recommend storing and applying configuration from the outside, and using DevOps pipeline.

#### Azure Stack Hub

Kubernetes on Azure Stack Hub deployed via AKS Engine isn't a managed service. It's an automated deployment and configuration of a Kubernetes cluster using Azure Infrastructure-as-a-Service (IaaS). As such, it provides the same availability as the underlying infrastructure.

Azure Stack Hub infrastructure is already resilient to failures, and provides capabilities like Availability Sets to distribute components across multiple [fault and update domains](https://docs.microsoft.com/azure-stack/user/azure-stack-vm-considerations#high-availability). But the underlying technology (failover clustering) still incurs some downtime for VMs on an impacted physical server, if there's a hardware failure.

It's a good practice to deploy your production Kubernetes cluster as well as the workload to two (or more) clusters. These clusters should be hosted in different locations or datacenters, and use technologies like Azure Traffic Manager to route users based on cluster response time or based on geography.

### Performance efficiency

Scalability is important to provide users consistent, reliable, and well-performing access to the application.

The sample scenario covers scalability on multiple layers of the application stack. Here's a high-level overview of the different layers.

#### Application

Horizontal scaling based on the number of Pods/Replicas/Container Instances. Using Kubernetes' Horizontal Pod Autoscaler (HPA); automated metric-based scaling or vertical scaling by sizing the container instances (cpu/memory).

On the application layer, we use Kubernetes [Horizontal Pod Autoscaler (HPA)](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/). HPA can increase or decrease the number of Replicas (Pod/Container Instances) in our deployment based on different metrics (like CPU utilization).

Another option is to scale container instances vertically. This can be accomplished by changing the amount of CPU and Memory requested and available for a specific deployment. See [Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) on kubernetes.io to learn more.

#### Kubernetes cluster

Number of Nodes (between 1 and 50), VM-SKU-sizes, and Node Pools (AKS Engine on Azure Stack Hub currently supports only a single node pool); using AKS Engine's scale command (manual)

The Kubernetes cluster itself consists of, and is built on top of Azure (Stack) IaaS components including compute, storage, and network resources. Kubernetes solutions involve master and worker nodes, which are deployed as VMs in Azure (and Azure Stack Hub).

- [Control plane nodes](https://docs.microsoft.com/azure/aks/concepts-clusters-workloads#control-plane) (master) provide the core Kubernetes services and orchestration of application workloads.
- [Worker nodes](https://docs.microsoft.com/azure/aks/concepts-clusters-workloads#nodes-and-node-pools) (worker) run your application workloads.

#### Azure Stack Hub

Number of nodes, capacity, and scale units within an Azure Stack Hub deployment. The Azure Stack Hub infrastructure is the foundation of this implementation, because Azure Stack Hub runs on physical hardware in a datacenter. When selecting your Hub hardware, you need to make choices for CPU, memory density, storage configuration, and number of servers. To learn more about Azure Stack Hub's scalability, check out the following resources:

- [Capacity planning for Azure Stack Hub overview](https://docs.microsoft.com/azure-stack/operator/azure-stack-capacity-planning-overview)
- [Add additional scale unit nodes in Azure Stack Hub](https://docs.microsoft.com/azure-stack/operator/azure-stack-add-scale-node)

## Next Steps

To learn more about concepts introduced in this article:

- Cross-cloud scaling and Geo-distributed app solution ideas in Azure Stack Hub.
- [Microservices architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices).

When you're ready to test the solution example, continue with the [High availability Kubernetes cluster deployment guide](/azure/architecture/hybrid/deployments/solution-deployment-guide-highly-available-kubernetes). The deployment guide provides step-by-step instructions for deploying and testing its components.

## Related resources

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../../reference-architectures/containers/aks/secure-baseline-aks.yml)
- [AKS baseline for multiregion clusters](../../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)
- [GitOps for Azure Kubernetes Service](../../example-scenario/gitops-aks/gitops-blueprint-aks.yml)
- [CI/CD pipeline for container-based workloads](../../example-scenario/apps/devops-with-aks.yml)
