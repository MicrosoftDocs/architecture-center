This article describes how to architect and operate a highly available Kubernetes-based infrastructure by using Azure Kubernetes Service (AKS) Engine on Azure Stack Hub. The solution is based on a scenario that has a strict set of constraints. The application must run on-premises, and personal data must not reach public cloud services. Monitoring and other non-PII data can be sent to Azure and be processed there. External services like a public container registry can be accessed but might be filtered through a firewall or proxy server. 

*Helm and Let's Encrypt are trademarks of their respective companies. No endorsement is implied by the use of these marks.*

## Architecture 

:::image type="content" source="media/application-architecture.svg" alt-text="Diagram that shows an architecture for a high-availability Kubernetes infrastructure." lightbox="media/application-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/high-availability-kubernetes-diagrams.vsdx) of all diagrams in this article.*

### Workflow

The preceding diagram shows the architecture of the sample application running on Kubernetes on Azure Stack Hub. The app consists of these components:

1. A Kubernetes cluster, based on AKS Engine, on Azure Stack Hub.
1. [cert-manager](https://www.jetstack.io/cert-manager), which provides a suite of tools for certificate management in Kubernetes. It's used to automatically request certificates from Let's Encrypt.
1. A Kubernetes namespace that contains the application components for:
   1. the front end (ratings-web)
   1. the API (ratings-api)
   1. the database (ratings-mongodb)
1. An ingress controller that routes HTTP/HTTPS traffic to endpoints within the Kubernetes cluster.

The sample application is used to illustrate the application architecture. All components are examples. The architecture contains only a single application deployment. To achieve high availability, the deployment runs at least twice on two Azure Stack Hub instances. They can run either in a single location or in two or more sites:

:::image type="content" source="media/aks-azure-architecture.svg" alt-text="Diagram that shows the infrastructure architecture." lightbox="media/aks-azure-architecture.svg" border="false":::

Services like Azure Container Registry and Azure Monitor are hosted outside of Azure Stack Hub in Azure or on-premises. This hybrid design protects the solution against the outage of a single Azure Stack Hub instance.

### Components

- [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub) is an extension of Azure that can run workloads in an on-premises environment by providing Azure services in your datacenter.
- [AKS Engine](https://github.com/Azure/aks-engine) is the engine behind the managed Kubernetes service, AKS, that's available in Azure. On Azure Stack Hub, you can use AKS Engine to deploy, scale, and upgrade fully featured, self-managed Kubernetes clusters using Azure Stack Hub IaaS capabilities.
      
   To learn more about the differences between AKS Engine on Azure and AKS Engine on Azure Stack Hub, see [Known Issues and Limitations](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#known-issues-and-limitations).
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) provides the network infrastructure on each Azure Stack Hub instance for the virtual machines (VMs) that host the Kubernetes cluster infrastructure.
- [Azure Load Balancer](https://azure.microsoft.com/products/load-balancer) is used for the Kubernetes API endpoint and the Nginx Ingress Controller. The load balancer routes external (for example, internet) traffic to nodes and VMs that provide a specific service.
- [Container Registry](https://azure.microsoft.com/products/container-registry) is used to store private Docker images and Helm charts, which are deployed to the cluster. AKS Engine can authenticate with the container registry by using an Azure Active Directory (Azure AD) identity. Kubernetes doesn't require Container Registry. You can use other container registries, like Docker Hub.
- [Azure Repos](https://azure.microsoft.com/products/devops/repos) is a set of version control tools that you can use to manage your code. You can also use GitHub or other Git-based repositories.
- [Azure Pipelines](https://azure.microsoft.com/products/devops/pipelines) is part of Azure DevOps Services. It runs automated builds, tests, and deployments. You can also use third-party CI/CD solutions like Jenkins.
- [Azure Monitor](https://azure.microsoft.com/products/monitor) collects and stores metrics and logs, including platform metrics for the Azure services in the solution and application telemetry. Use this data to monitor the application, set up alerts and dashboards, and perform root cause analysis of failures. Azure Monitor integrates with Kubernetes to collect metrics from controllers, nodes, containers, container logs, and control plane node logs.
- [Azure Traffic Manager](https://azure.microsoft.com/products/traffic-manager) is a DNS-based traffic load balancer that you can use to distribute traffic optimally to services across different Azure regions or Azure Stack Hub deployments. Traffic Manager also provides high availability and responsiveness. The application endpoints must be accessible from the outside. Other on-premises solutions are also available.
- A Kubernetes ingress controller exposes HTTP(S) routes to services in a Kubernetes cluster. You can use [NGINX](https://www.nginx.com/products/nginx-ingress-controller) or any suitable ingress controller.
- [Helm](https://helm.sh) is a package manager for Kubernetes deployment. It provides a way to bundle different Kubernetes objects, like `Deployments`, `Services`, and `Secrets`, into a single "chart." You can publish, deploy, version, and update a chart object. You can use Container Registry as a repository to store packaged Helm charts.

## Scenario details

The sample application shown here is designed to use Kubernetes-native solutions rather than platform-native services whenever possible. This design avoids vendor lock-in. For example, the application uses a self-hosted MongoDB database back end instead of a PaaS service or external database service. For more information, see the [Introduction to Kubernetes on Azure](/training/paths/intro-to-kubernetes-on-azure) learning path.

### Potential use cases 

Many organizations are developing cloud-native solutions that take advantage of state-of-the-art services and technologies like Kubernetes. Although Azure provides datacenters in most regions of the world, sometimes business-critical applications must run in a specific location. Potential concerns include:

- Location sensitivity.
- Latency between the application and on-premises systems.
- Bandwidth conservation.
- Connectivity.
- Regulatory or statutory requirements.

Azure, in combination with Azure Stack Hub, addresses most of these concerns. This article provides a broad set of options, decisions, and considerations to help you successfully implement Kubernetes on Azure Stack Hub.

The scenario described here is common for organizations with critical workloads in highly restricted and regulated environments. It's applicable in domains like finance, defense, and government.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Design

This solution incorporates a few high-level recommendations that are explained in more detail in the next sections of this article:

- To avoid vendor lock-in, the application uses Kubernetes-native solutions.
- The application uses a microservices architecture.
- Azure Stack Hub doesn't need inbound internet connectivity. It allows outbound internet connectivity.

These recommended practices also apply to real-world workloads and scenarios.

### Reliability 

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Scalability helps provide consistent, reliable, and well-performing access to the application.

The sample scenario implements scalability in three layers of the application stack. Here's a high-level overview of the layers:

| Architecture level | Affects | How? |
| --- | --- | ---
| Application | Application | Horizontal scaling based on the number of pods / replicas / container instances.* |
| Cluster | Kubernetes cluster | Number of nodes (between 1 and 50), VM SKU sizes, and, via the AKS Engine manual `scale` command, node pools. (AKS Engine on Azure Stack Hub currently supports only a single node pool.)  |
| Infrastructure | Azure Stack Hub | Number of nodes, capacity, and scale units within an Azure Stack Hub deployment. |

\* *Via the Kubernetes HorizontalPodAutoscaler, which provides automated metric-based scaling, or vertical scaling by sizing the container instances (CPU or memory).*

#### Azure Stack Hub (infrastructure level)

Because Azure Stack Hub runs on physical hardware in a datacenter, the Azure Stack Hub infrastructure is the foundation of this implementation. When you choose your hub hardware, you need to choose the CPU, memory density, storage configuration, and number of servers. To learn more about Azure Stack Hub scalability, see these resources:

- [Capacity planning for Azure Stack Hub overview](/azure-stack/operator/azure-stack-capacity-planning-overview)
- [Add scale unit nodes in Azure Stack Hub](/azure-stack/operator/azure-stack-add-scale-node)

#### Kubernetes cluster (cluster level)

The Kubernetes cluster itself consists of and is built on top of Azure and Azure Stack Hub IaaS components, including compute, storage, and network resources. Kubernetes solutions are composed of control plane nodes and worker nodes, which are deployed as VMs in Azure and Azure Stack Hub.

- [Control plane nodes](/azure/aks/concepts-clusters-workloads#control-plane) provide the core Kubernetes services and orchestration of application workloads.
- [Worker nodes](/azure/aks/concepts-clusters-workloads#nodes-and-node-pools) run your application workloads.

When you choose VM sizes for your initial deployment, take the following into consideration:  

- **Cost.** When you plan your worker nodes, consider the overall cost per VM. For example, if your application workloads require limited resources, you should plan to deploy smaller VMs. Azure Stack Hub, like Azure, is normally billed on a consumption basis, so appropriately sizing the VMs for Kubernetes roles is crucial to optimizing consumption costs. 

- **Scalability.** You achieve scalability of the cluster by scaling in and out the number of control plane and worker nodes, or by adding node pools. (You can't currently add node pools on Azure Stack Hub.) You can scale the cluster based on performance data collected with Container insights (Azure Monitor and Log Analytics). 

    If your application needs more or fewer resources, you can scale the number of nodes out or in horizontally, between 1 and 50 nodes. If you need more than 50 nodes, you can create another cluster in a separate subscription. You can't scale up the actual VMs vertically to another VM size without redeploying the cluster.

    Implement scaling manually by using the AKS Engine helper VM that you used to deploy the Kubernetes cluster. For more information, see [Scaling Kubernetes clusters](https://github.com/Azure/aks-engine/blob/master/docs/topics/scale.md).

- **Quotas.** Consider the [quotas](/azure-stack/operator/azure-stack-quota-types) that you've configured when you plan an AKS deployment on Azure Stack Hub. Make sure each [subscription](/azure-stack/operator/service-plan-offer-subscription-overview) has the proper plans and quotas configured. The subscription will need to accommodate the amount of compute, storage, and other services required for your clusters as they scale out.

- **Application workloads.** See [clusters and workloads concepts](/azure/aks/concepts-clusters-workloads#nodes-and-node-pools) in the **Kubernetes core concepts for Azure Kubernetes Service** article. That article can help you scope your VM size based on your application's compute and memory needs.  

#### Application (application level)

On the application layer, the solution uses the Kubernetes [HorizontalPodAutoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale). HorizontalPodAutoscaler can increase or decrease the number of replicas (pods / container instances) in the deployment based on various metrics, like CPU utilization.

Another option is to scale container instances vertically. You can accomplish this type of scaling by changing the amount of CPU and memory that's requested and available for a specific deployment. For more information, see [Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers).

### Networking and connectivity

Networking and connectivity also affect the three layers discussed previously. The following table shows the layers and the services that they contain.

| Layer | Affects | What? |
| --- | --- | ---
| Application | Application | How the application can be accessed. Whether it's exposed to the internet. |
| Cluster | Kubernetes cluster | Kubernetes API, AKS Engine VM, pulling container images (egress), sending monitoring data and telemetry (egress). |
| Infrastructure | Azure Stack Hub | Accessibility of the Azure Stack Hub management endpoints, like the portal and Azure Resource Manager endpoints. |

#### Application

On the application layer, the most important consideration is whether the application is exposed to the internet and can be accessed from the internet. From a Kubernetes perspective, internet access requires exposing a deployment or pod by using a Kubernetes Service or an ingress controller.

> [!NOTE]
> We recommend that you use ingress controllers to expose Kubernetes Services because the number of front-end public IPs on Azure Stack Hub is limited to five. That also limits the number of Kubernetes Services of type `LoadBalancer` to five, which is too small for many deployments. For more information, see the [AKS Engine documentation](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#limited-number-of-frontend-public-ips).

An application can be exposed with a public IP via a load balancer or an ingress controller without being accessible via the internet. Azure Stack Hub can have a public IP address that's visible only on the local intranet. Not all public IPs are truly internet-facing.

Besides ingress traffic to the application, you also need to consider outbound, or egress, traffic. Here are a few use cases that require egress traffic:

- Pulling container images that are stored in Docker Hub or Container Registry
- Retrieving Helm charts
- Emitting Application Insights data or other monitoring data

Some enterprise environments might require the use of _transparent_ or _non-transparent_ proxy servers. These servers require specific configuration on various components of the cluster. The AKS Engine documentation contains details on how to accommodate network proxies. For more information, see [AKS Engine and proxy servers](https://github.com/Azure/aks-engine/blob/master/docs/topics/proxy-servers.md).

Finally, cross-cluster traffic must flow between Azure Stack Hub instances. The solution described here consists of individual Kubernetes clusters that run on individual Azure Stack Hub instances. Traffic between them, like the replication traffic between two databases, is considered external traffic. External traffic must be routed through either a site-to-site VPN or Azure Stack Hub public IP addresses:

:::image type="content" source="media/aks-cluster-traffic.svg" alt-text="Diagram that shows how traffic is routed." border="false":::

#### Cluster

The Kubernetes cluster doesn't necessarily need to be accessible via the internet. The relevant part is the Kubernetes API that's used to operate a cluster, for example, via `kubectl`. Everyone who operates the cluster or deploys applications and services on top of it must be able to access the Kubernetes API endpoint. This topic is covered in more detail from a DevOps perspective in the [Deployment (CI/CD)](#deployment-cicd) section of this article.

On the cluster level, there are also a few considerations for egress traffic:

- Node updates (for Ubuntu)
- Monitoring data (sent to Log Analytics)
- Other agents that require outbound traffic (specific to each deployer's environment)

Before you deploy your Kubernetes cluster by using AKS Engine, plan for the final networking design. It might be more efficient to deploy a cluster into an existing network instead of creating a dedicated virtual network. For example, you might use an existing site-to-site VPN connection that's already configured in your Azure Stack Hub environment.

#### Infrastructure

*Infrastructure* refers to accessing the Azure Stack Hub management endpoints. Endpoints include the tenant and admin portals, and the Resource Manager admin and tenant endpoints. These endpoints are required to operate Azure Stack Hub and its core services.

### Data and storage

Two instances of the application are deployed, on two individual Kubernetes clusters, across two Azure Stack Hub instances. For this design, you need to consider how to replicate and synchronize data between the instances.

Azure provides the built-in capability to replicate storage across multiple regions and zones within the cloud. Currently, there's no native way to replicate storage across two Azure Stack Hub instances. They form two independent clouds, and there's no overarching way to manage them as a set. When you plan for the resiliency of applications that run across Azure Stack Hub, consider this independence in your application design and deployments.

In most cases, storage replication isn't necessary for a resilient and highly available application deployed on AKS. But you should consider independent storage per Azure Stack Hub instance in your application design. If this design is a concern, consider storage attachment solutions offered by Microsoft partners. Storage attachments provide a storage replication solution across multiple Azure Stack Hub instances and Azure. For more information, see the [Partner solutions](#partner-solutions) section of this article.

This architecture takes these elements into consideration:

#### Configuration

This category includes the configuration of Azure Stack Hub, AKS Engine, and the Kubernetes cluster itself. You should automate the configuration as much as possible and store it as infrastructure-as-code in a Git-based version control system like Azure DevOps or GitHub. You can't easily synchronize these settings across multiple deployments. We recommend that you store and apply configuration from the outside, and use DevOps pipeline.

#### Application

You should store the application in a Git-based repository. If you do, whenever there's a new deployment, changes to the application, or disaster recovery, you can deploy the application easily by using Azure Pipelines.

#### Data

Data is the most important consideration in most application designs. Application data must stay in sync between the different instances of the application. You also need a backup and disaster recovery strategy for data in case there's an outage.

Here are some solutions for implementing a highly available database on Azure Stack Hub:

- [Deploy a SQL Server 2016 availability group to Azure and Azure Stack Hub](/azure/architecture/hybrid/deployments/solution-deployment-guide-sql-ha)
- [Deploy a highly available MongoDB solution to Azure and Azure Stack Hub](/azure/architecture/hybrid/deployments/solution-deployment-guide-mongodb-ha?toc=/hybrid/app-solutions)

If you're working with data across multiple locations, implementing a highly available and resilient solution is even more complex. Consider:

- Latency and network connectivity between Azure Stack Hub instances.
- The availability of identities for services and permissions. Each Azure Stack Hub instance integrates with an external directory. During deployment, you choose to use either Azure AD or Active Directory Federation Services (AD FS). So you have the option to use a single identity that can interact with multiple independent Azure Stack Hub instances.

### Business continuity and disaster recovery

Business continuity and disaster recovery (BCDR) is an important consideration for both Azure Stack Hub and Azure. The main difference is that, for Azure Stack Hub, the operator must manage the whole BCDR process. For Azure, parts of BCDR are automatically managed by Microsoft.

BCDR affects the same areas discussed in the previous section:

- Infrastructure and configuration
- Application availability
- Application data

These areas are the responsibility of the Azure Stack Hub operator. The details can vary, depending on the organization. Plan BCDR according to your available tools and processes.

#### Infrastructure and configuration

This section covers the physical and logical infrastructure and the configuration of Azure Stack Hub. It covers actions in the admin and tenant spaces.

The Azure Stack Hub operator (or administrator) is responsible for the maintenance of the Azure Stack Hub instances. This maintenance includes the network, storage, identity, and other elements that are outside the scope of this article. To learn more about the specifics of Azure Stack Hub operations, see these resources:

- [Recover data in Azure Stack Hub with the Infrastructure Backup Service](/azure-stack/operator/azure-stack-backup-infrastructure-backup)
- [Enable backup for Azure Stack Hub from the administrator portal](/azure-stack/operator/azure-stack-backup-enable-backup-console)
- [Recover from catastrophic data loss](/azure-stack/operator/azure-stack-backup-recover-data)
- [Infrastructure Backup Service best practices](/azure-stack/operator/azure-stack-backup-best-practices)

Azure Stack Hub is the platform and fabric on which Kubernetes applications are deployed. The application owner for the Kubernetes application is a user of Azure Stack Hub who has access to deploy the application infrastructure needed for the solution. The application infrastructure, in this case, is the Kubernetes cluster, deployed via AKS Engine, and the surrounding services. 

These components are deployed into Azure Stack Hub. The components are constrained by the Azure Stack Hub offer. Make sure the offer accepted by the Kubernetes application owner has sufficient capacity, expressed in Azure Stack Hub quotas, to deploy the entire solution. As recommended in the previous section, you should automate the application deployment by using infrastructure-as-code and deployment pipelines like Azure Pipelines.

For more information on Azure Stack Hub offers and quotas, see [Azure Stack Hub services, plans, offers, and subscriptions overview](/azure-stack/operator/service-plan-offer-subscription-overview).

It's important to securely save and store the AKS Engine configuration, including its outputs. These files contain confidential information that's used to access the Kubernetes cluster, so they must be protected from exposure to non-administrators.

#### Application availability

The application shouldn't rely on backups of a deployed instance. As a standard practice, redeploy the application completely, following infrastructure-as-code patterns. For example, redeploy by using Azure Pipelines. The BCDR procedure should involve the redeployment of the application to the same Kubernetes cluster or another one.

#### Application data

Application data is the critical component of BCDR. The previous sections describe techniques for replicating and synchronizing data between two or more instances of an application. Depending on the database infrastructure (like MySQL, MongoDB, or SQL Server) used to store the data, there are various database availability and backup techniques available.

To achieve integrity, we recommend that you use one of the following solutions:

- A native backup solution for the specific database.
- A backup solution that supports backup and recovery of the database type that's used by your application.

> [!IMPORTANT]
> Don't store your backup data on and your application data on the same Azure Stack Hub instance. A complete outage of the Azure Stack Hub instance would also compromise your backups.

### Availability 

Kubernetes on Azure Stack Hub, when deployed via AKS Engine, isn't a managed service. It's an automated deployment and configuration of a Kubernetes cluster that uses Azure infrastructure as a service (IaaS). So it provides the same availability as the underlying infrastructure.

Azure Stack Hub infrastructure is already resilient to failures, and it provides capabilities like availability sets to distribute components across multiple [fault and update domains](/azure-stack/user/azure-stack-vm-considerations#high-availability). But the underlying technology (failover clustering) still incurs some downtime for VMs on an affected physical server, if there's a hardware failure.

It's a good practice to deploy your production Kubernetes cluster, and also the workload, to two or more clusters. These clusters should be hosted in different locations or datacenters and use technologies like Traffic Manager to route users based on cluster response time or geography.

:::image type="content" source="media/aks-azure-traffic-manager.svg" alt-text="Diagram that shows how Traffic Manager is used to control traffic flows." border="false":::

Customers who have a single Kubernetes cluster typically connect to the service IP or DNS name of a given application. In a multi-cluster deployment, customers should connect to a Traffic Manager DNS name that points to the services/ingress on each Kubernetes cluster.

:::image type="content" source="media/aks-azure-traffic-manager-on-premises.svg" alt-text="Diagram that shows how to use Traffic Manager to route traffic to on-premises clusters." lightbox="media/aks-azure-traffic-manager-on-premises.svg" border="false":::

> [!NOTE]
> This architecture is also a [best practice for managed AKS clusters on Azure](/azure/aks/operator-best-practices-multi-region#plan-for-multiregion-deployment).

The Kubernetes cluster itself, deployed via AKS Engine, should consist of at least three control plane nodes and two worker nodes.

### Security 

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Security and identity are especially important when the solution spans independent Azure Stack Hub instances. Kubernetes and Azure, including Azure Stack Hub, have distinct mechanisms for role-based access control (RBAC):

- Azure RBAC controls access to Azure and Azure Stack Hub, including the ability to create new Azure resources. Permissions can be assigned to users, groups, or service principals. (A service principal is a security identity that's used by applications.)
- Kubernetes RBAC controls permissions to the Kubernetes API. For example, creating pods and listing pods are actions that can be granted or denied to a user via RBAC. To assign Kubernetes permissions to users, you create roles and role bindings.

#### Azure Stack Hub identity and RBAC

Azure Stack Hub provides two identity provider choices. The provider you use depends on the environment and whether you're running in a connected or disconnected environment:

- Azure AD can be used only in a connected environment.
- AD FS to a traditional Active Directory forest can be used in a connected or disconnected environment.

The identity provider manages users and groups, including authentication and authorization for accessing resources. Access can be granted to Azure Stack Hub resources like subscriptions, resource groups, and individual resources like VMs and load balancers. For consistency, consider using the same groups, either direct or nested, for all Azure Stack Hub instances. Here's an example configuration:

:::image type="content" source="media/azure-stack-azure-ad-nested-groups.svg" alt-text="Diagram that shows nested Azure AD groups with Azure Stack Hub." lightbox="media/azure-stack-azure-ad-nested-groups.svg" border="false":::

This example contains a dedicated group (using Azure AD or AD FS) for a specific purpose, for example, to provide Contributor permissions for the resource group that contains the Kubernetes cluster infrastructure on a specific Azure Stack Hub instance (here, "Seattle K8s Cluster Contributor"). These groups are then nested into an overall group that contains the subgroups for each Azure Stack Hub instance.

The example user now has Contributor permissions to both resource groups that contain the entire set of Kubernetes infrastructure resources. The user has access to resources on both Azure Stack Hub instances because the instances share the same identity provider.

> [!IMPORTANT]
> These permissions affect only Azure Stack Hub and some of the resources deployed on top of it. A user who has this level of access can do a lot of harm but can't access the Kubernetes IaaS VMs or the Kubernetes API without additional access to the Kubernetes deployment.

#### Kubernetes identity and RBAC

A Kubernetes cluster, by default, doesn't use the same identity provider as the underlying Azure Stack Hub instance. The VMs that host the Kubernetes cluster, control plane, and worker nodes use the SSH key that's specified when the cluster is deployed. This SSH key is required for connection to these nodes via SSH.

The Kubernetes API (accessed, for example, via `kubectl`) is also protected by service accounts, including a default cluster admin service account. The credentials for this service account are initially stored in the *.kube/config* file on your Kubernetes control plane nodes.

#### Secrets management and application credentials

You have several options for storing secrets like connection strings and database credentials, including:

- Azure Key Vault
- Kubernetes secrets
- Third-party solutions like HashiCorp Vault (running on Kubernetes)

Don't store secrets or credentials in plain text in your configuration files, application code, or scripts. And don't store them in a version control system. Instead, the deployment automation should retrieve the secrets as needed.

### Patch and upgrade

The patch and upgrade process in AKS is partially automated. Kubernetes version upgrades are triggered manually, and security updates are applied automatically. These updates can include OS security fixes or kernel updates. AKS doesn't automatically reboot Linux nodes to complete the update process. 

The patch and upgrade process for a Kubernetes cluster deployed via AKS Engine on Azure Stack Hub is unmanaged. It's the responsibility of the cluster operator. 

AKS Engine helps with the two most important tasks:

- [Upgrade to a newer Kubernetes and base OS image version](/azure-stack/user/azure-stack-kubernetes-aks-engine-upgrade#steps-to-upgrade-to-a-newer-kubernetes-version)
- [Upgrade the base OS image only](/azure-stack/user/azure-stack-kubernetes-aks-engine-upgrade#steps-to-only-upgrade-the-os-image)

Newer base OS images contain the latest OS security fixes and kernel updates. 

The [unattended upgrade](https://wiki.debian.org/UnattendedUpgrades) utility automatically installs security updates that are released before a new base OS image version is available in the Azure Stack Hub Marketplace. Unattended upgrade is enabled by default and installs security updates automatically, but it doesn't reboot the Kubernetes cluster nodes. You can automate the node reboot by using the open-source [Kubernetes Reboot Daemon (kured)](/azure/aks/node-updates-kured). The kured daemon watches for Linux nodes that require a reboot, and then automatically handles the rescheduling of running pods and the node reboot process.

### Deployment (CI/CD) 

Azure and Azure Stack Hub expose the same Resource Manager REST APIs. You address these APIs as you would in any other Azure cloud platform (Azure, Azure China 21Vianet, Azure Government). The various cloud platforms might use different API versions, and Azure Stack Hub provides only a subset of services. The management endpoint URI is also different for each cloud platform, and for each instance of Azure Stack Hub.

Aside from the subtle differences mentioned, Resource Manager REST APIs provide a consistent way to interact with both Azure and Azure Stack Hub. You can use the same set of tools here as you would with any other Azure cloud platform. You can use Azure DevOps, tools like Jenkins, or PowerShell to deploy and orchestrate services to Azure Stack Hub.

#### Considerations

One of the major differences for Azure Stack Hub deployments is the implementation of internet accessibility. Internet accessibility determines whether to select a Microsoft-hosted or a self-hosted build agent for your CI/CD jobs.

A self-hosted agent can run on top of Azure Stack Hub (as an IaaS VM) or in a network subnet that can access Azure Stack Hub. For more information about the differences, see [Azure Pipelines agents](/azure/devops/pipelines/agents/agents).

The following flow chart can help you decide whether you need a self-hosted or a Microsoft-hosted build agent:

:::image type="content" source="media/aks-flow-chart.svg" alt-text="Flow chart that can help you decide which type of build agent to use." lightbox="media/aks-flow-chart.svg" border="false":::

- Can the Azure Stack Hub management endpoints be accessed via the internet?
  - Yes: You can use Azure Pipelines with Microsoft-hosted agents to connect to Azure Stack Hub.
  - No: You need self-hosted agents that can connect to the Azure Stack Hub management endpoints.
- Can the Kubernetes cluster be accessed via the internet?
  - Yes: You can use Azure Pipelines with Microsoft-hosted agents to interact directly with the Kubernetes API endpoint.
  - No: You need self-hosted agents that can connect to the Kubernetes cluster API endpoint.

If the Azure Stack Hub management endpoints and Kubernetes API can be accessed via the internet, the deployment can use a Microsoft-hosted agent. This deployment results in the following application architecture:

:::image type="content" source="media/aks-azure-stack.svg" alt-text="Diagram that provides an overview of the architecture that can be accessed via the internet." lightbox="media/aks-azure-stack.svg" border="false":::

If the Resource Manager endpoints, Kubernetes API, or both can't be accessed directly via the internet, you can use a self-hosted build agent to run the pipeline steps. This design requires less connectivity. It can be deployed with only on-premises network connectivity to Resource Manager endpoints and the Kubernetes API:

:::image type="content" source="media/aks-self-hosted.svg" alt-text="Diagram that shows a self-hosted architecture." lightbox="media/aks-self-hosted.svg" border="false":::

> [!NOTE]
> In scenarios where Azure Stack Hub, Kubernetes, or both of them don't have internet-facing management endpoints, you can still use Azure DevOps for your deployments. You can use a self-hosted agent pool, which is an Azure DevOps agent that runs on-premises or on Azure Stack Hub itself. Or you can use a completely self-hosted Azure DevOps server on-premises. The self-hosted agent needs only outbound HTTPS (TCP 443) internet connectivity.

The solution can use a Kubernetes cluster, deployed and orchestrated with AKS Engine, on each Azure Stack Hub instance. It includes an application that consists of a front end, a middle tier, back-end services (for example, MongoDB), and an NGINX-based ingress controller. Instead of using a database that's hosted on the Kubernetes cluster, you can use external data stores. Database options include MySQL, SQL Server, or any kind of database that's hosted outside of Azure Stack Hub or in IaaS. These configurations are outside the scope of this article.

### Partner solutions

You can use Microsoft partner solutions to extend the capabilities of Azure Stack Hub. These solutions can be useful in deployments of applications that run on Kubernetes clusters.  

### Storage and data solutions

As noted earlier, unlike Azure, Azure Stack Hub doesn't currently have a native solution for replicating storage across multiple instances. In Azure Stack Hub, each instance is its own distinct cloud. You can, however, get solutions from Microsoft partners that enable storage replication across Azure Stack Hubs and Azure: 

- [Scality](https://www.scality.com) provides web-scale storage. Scality RING software-defined storage turns commodity x86 servers into an unlimited storage pool for any type of data, at petabyte scale.
- [Cloudian](https://www.cloudian.com) provides limitless scalable storage that consolidates massive data sets to a single environment.

## Next steps

- [Azure Stack Hub overview](/azure-stack/operator/azure-stack-overview)
- [Azure Repos overview](/azure/devops/repos/get-started/what-is-repos)
- [Azure Pipelines overview](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Cross-cloud scaling in Azure Stack Hub](/hybrid/app-solutions/pattern-cross-cloud-scale-onprem-data)  
- [Geo-distributed app patterns in Azure Stack Hub](/hybrid/app-solutions/pattern-geo-distributed) 
- [Training: Azure Stack Hub](/training/modules/azure-stack-hub)

## Related resources

- [Microservices architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/microservices/aks)
- [High availability Kubernetes cluster deployment guide](/azure/architecture/hybrid/deployments/solution-deployment-guide-highly-available-kubernetes)
