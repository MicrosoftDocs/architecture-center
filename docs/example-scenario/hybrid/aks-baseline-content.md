This scenario illustrates how to design and implement a baseline architecture for Microsoft Azure Kubernetes Service (AKS) running on Azure Stack HCI (AKS hybrid).

This article includes recommendations for networking, security, identity, management, and monitoring of the cluster based on an organization's business requirements. It's part of an architectural baseline guidance set of two articles. See the [recommendations for network design here](aks-network.yml).

## Architecture

The following image shows the baseline architecture for Azure Kubernetes Service on Azure Stack HCI or Windows Server 2019/2022 datacenter failover cluster:

:::image type="content" source="media/aks-azure-stack-hci-baseline-v8.svg" alt-text="Conceptual image of Baseline architecture for Azure Kubernetes Service on Azure Stack HCI." lightbox="media/aks-azure-stack-hci-baseline-v8.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/aks-azurestackhci-baseline-v8.vsdx) of this architecture.*

The architecture consists of the following components and capabilities:

- [Azure Stack HCI (20H2)][]. A hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. An Azure Stack HCI cluster is implemented as a 2-8 node cluster.
- [Azure Kubernetes Service on Azure Stack HCI (AKS hybrid)][]. An on-premises implementation of AKS, which automates running containerized applications at scale.
- [Azure Arc][]. A cloud-based service that extends the Azure Resource Manager–based management model to non-Azure resources including non-Azure virtual machines (VMs), Kubernetes clusters, and containerized databases.
- [Azure Policy](/azure/governance/policy/overview). A cloud-based service that helps enforce organizational standards and assess compliance at-scale by evaluating Azure (including Arc-enabled) resources to the properties of those resources to business rules. These standards also include [Azure Policy for Kubernetes][], which applies policies to the workloads running inside the cluster.
- [Azure Monitor][]. A cloud-based service that maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments.
- [Microsoft Defender for Cloud][]. A unified infrastructure security management system that strengthens the security posture of your data centers and provides advanced threat protection across your hybrid workloads in the cloud and on-premises.
- **Azure Automation.** Delivers a cloud-based automation and configuration service that supports consistent management across your Azure and non-Azure environments.
- [Velero][]. An open-source tool that supports on-demand backup and scheduled backup and restores all objects in the Kubernetes cluster.
- [Azure Blob Storage][]. Massively scalable and secure object storage for cloud-native workloads, archives, data lakes, high-performance computing, and machine learning.

## Components

- [Azure Stack HCI (20H2)][1]
- [Azure Kubernetes Service on Azure Stack HCI (AKS hybrid)][]
- [Windows Admin Center][]
- [An Azure subscription][]
- [Azure Arc][]
- [Azure role-based access control (Azure RBAC)][])
- [Azure Monitor][]
- [Microsoft Defender for Cloud][]

## Scenario details

### Potential use cases

- Implement highly available, container-based workloads in an on-premises Kubernetes implementation of AKS.
- Automate running containerized applications at scale.
- Lower total cost of ownership (TCO) through Microsoft-certified solutions, cloud-based automation, centralized management, and centralized monitoring.

### Certified hardware

Use Azure Stack HCI-certified hardware, which provides Secure Boot, United Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) settings out of the box. Compute requirements depend on the application and the number of worker nodes that run in AKS on the Azure Stack HCI cluster. Use multiple physical nodes for deployment of Azure Stack HCI or at least a two node Windows Server Datacenter failover cluster to achieve high availability. It's required that all servers have the same manufacturer and model, using 64-bit Intel Nehalem grade, AMD EPYC grade, or later compatible processors with second-level address translation (SLAT).

### Cluster deployment strategies

AKS simplifies on-premises Kubernetes deployment by providing wizards or PowerShell cmdlets you can use to set up Kubernetes and essential Azure Stack HCI add-ons. An Azure Kubernetes Service cluster has the following components on Azure Stack HCI:

- **Management cluster.** Deploy the management cluster on a highly available virtual machine (VM) that's running either on Azure Stack HCI or a Windows Server 2019/2022 Datacenter failover cluster. The management cluster is responsible for deploying and managing multiple workload clusters and it includes the following components:
  - **API Server.** Interacts with the management tools.
  - **Load balancer.** Manages load-balancing rules for the API server of the management cluster.
- **Workload clusters.** Implement highly available control plane components and worker node components. Containerized applications run on a workload cluster. To achieve application isolation, you can deploy up to eight workload clusters. The workload cluster consists of the following components:
  - **Control plane.** Runs on a Linux distribution and contains API server components for interaction with Kubernetes API and a distributed key-value store, etcd, for storing all the configuration and data of the cluster.
  - **Load balancer.** Runs on a Linux VM and provides load-balanced services for the workload cluster.
  - **Worker nodes.** Run on a Windows or Linux operating system that hosts containerized applications.
  - **Kubernetes resources.** Pods represent a single instance of your application, that usually have a 1:1 mapping with a container, but certain pods can contain multiple containers. Deployments represent one or more identical pods. Pods and deployments are logically grouped into a namespace that controls access to management of the resources.

### Network requirements

Kubernetes provides an abstraction layer to virtual networking by connecting the Kubernetes nodes to the virtual network. It also provides inbound and outbound connectivity for pods through the *kube-proxy* component. The Azure Stack HCI platform provides further simplification of the deployment by configuring the *HAProxy* load balancer VM.

> [!NOTE]
> For information about how to design and implement network concepts for deploying AKS nodes on Azure Stack HCI and Windows Server clusters, see the second article in this series, [Network architecture](aks-network.yml).

The architecture uses a virtual network that allocates IP addresses by using one of the following networking options:

- **Static IP networking.** Uses a static, defined address pool for all the objects in the deployment. It adds extra benefit and guarantees that the workload and application are always reachable. This is the recommended method.
- **DHCP networking.** Allocates dynamic IP addresses to the Kubernetes nodes, underlying VMs, and load balancers using a Dynamic Host Configuration Protocol (DHCP) server.

A virtual IP pool is a range of reserved IP addresses used for allocating IP addresses to the Kubernetes cluster API server and for Kubernetes services.

Use Project Calico for Kubernetes to get other network features, such as network policy and flow control.

### Storage requirements

For every server in the cluster, use the same types of drives that are the same size and model. Azure Stack HCI works with direct-attached Serial Advanced Technology Attachment (SATA), Serial Attached SCSI (SAS), Non-Volatile Memory Express (NVMe), or persistent memory drives that are physically attached to one server each. For cluster volumes, HCI uses software-defined storage technology (Storage Spaces Direct) to combine the physical drives in the storage pool for fault tolerance, scalability, and performance. Applications that run in Kubernetes on Azure Stack HCI often expect the following storage options to be available to them:

- **Volumes.** Represent a way to store, retrieve, and persist data across pods and through the application lifecycle.
- **Persistent Volumes.** A storage resource that's created and managed by Kubernetes API and can exist beyond the lifetime of an individual pod.

Consider defining storage classes for different tiers and locations to optimize cost and performance. The storage classes support dynamic provisioning of persistent volumes and define the *reclaimPolicy* to specify the action of the underlying storage resource for managing persistent volumes when the pod is deleted.

### Manage AKS on Azure Stack HCI

You can manage AKS on Azure Stack HCI using the following management options:

- **Windows Admin Center**. Offers an intuitive UI for the Kubernetes operator to manage the lifecycle of Azure Kubernetes Service clusters on Azure Stack HCI.
- **PowerShell**. Makes it easy to download, configure, and deploy AKS on Azure Stack HCI. The PowerShell module also supports deploying, configuring other workload clusters, and reconfiguring existing ones.

### Active Directory requirements

Integrate AKS on Azure Stack HCI or Windows Server Datacenter failover cluster with an Active Directory Domain Services (AD DS) environment for optimal management. When possible, use separate organizational units for the servers and services of AKS on Azure Stack HCI to provide more granular control access and permissions. Active Directory integration with Azure Kubernetes Service on Azure Stack HCI allows a user on a Windows domain-joined machine to connect to the API server (with kubectl) using their single sign-on (SSO) credentials.

## Recommendations

The following recommendations apply for most scenarios. Follow the recommendations unless you have a specific requirement that overrides them.

### Integrate AKS hybrid deployments with Azure Arc

To minimize the TCO, integrate AKS hybrid deployments with Azure Arc. Consider using the following Azure services:

- [Azure Monitor Container Insights.][] Monitors the performance of container workloads that are running on both Linux and Windows clusters. It collects memory and processor metrics, from controllers, nodes, and containers through the Metric API. With container insights, you can identify memory and processor utilization, detect overall pod's performance, understand the behavior of the cluster, and configure alerts for proactive monitoring.
- [Automation capabilities](/azure/automation/automation-hybrid-runbook-worker). AKS hybrid provides a wide range of automation capabilities, with OS updates combined with full-stack updates including firmware and drivers provided by Azure Stack HCI vendors and partners. You can run Windows PowerShell locally from one of the Azure Stack HCI servers or remotely from a management computer. Integration with [Azure Automation][] and Azure Arc facilitates a wide range of automation scenarios for [virtualized][] and [containerized][] workloads.
- [Velero and Azure Blob Storage][]. Velero is an open-source tool that supports on-demand backup, scheduled backup, and restoration of all objects in the Kubernetes cluster for any resources defined and stored in an etcd database as a Kubernetes Custom Resource Definition (CRD). It provides backup of Kubernetes resources and volumes for an entire cluster or part of a cluster by using namespaces or label selectors. Store the backup set created with the Velero tool in an Azure storage account in a blob container.
- [Azure Arc–enabled Kubernetes Service][]. Provides Azure Resource Manager representation of AKS on Azure Stack HCI cluster. Deploy Azure Arc–enabled agents in a Kubernetes namespace, to collect logs and metrics, to gather cluster metadata, cluster version, and node count and ensure that agents are exhibiting optimal performance.
- [Azure Policy](/azure/governance/policy/overview). Deploy and enforce built-in security policies on AKS cluster using Azure Policy. You can also use custom policy definition to enforce GitOps, which is the practice of declaring the desired state of Kubernetes configuration (deployments, namespaces, and so on) in a Git repository.
- [Azure Policy for Kubernetes][]. Manage internal cluster policies implemented by Gatekeeper, deploys policy definition into the cluster as constraint template and report on the compliance state of your Kubernetes clusters from one place.
- [Azure RBAC][]. Use for role assignment and to manage access to Azure Arc–enabled Kubernetes.

## Considerations

These considerations implement the pillars of the Azure *Well-Architected Framework*, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

- Implement a highly available VM for the Management Cluster, and multiple hosts in Kubernetes Cluster to meet the minimum level of availability for workloads.
- Backup and restore workload clusters using Velero and Azure Blob Storage. Define availability and recovery targets to meet business requirements.
- AKS hybrid deployments use failover clustering and live migration for high availability and fault tolerance. Live migration is a Hyper-V feature that allows you to transparently move running virtual machines from one Hyper-V host to another without perceived downtime.
- Configure deployments to use Kubernetes features, such as Deployments, Affinity Mapping, and ReplicaSets, to ensure that the pods are resilient in disruption scenarios.
- You should ensure that services referenced in the [Architecture section](#architecture) are supported in the region to which Azure Arc is deployed.
- Consider limiting usage of public container images, and only pull from container registries for which you have control over the SLA, such as ACR.

### Security

Focus on the entire stack by securing the host and containers.

#### Infrastructure security

- Use Azure Stack HCI certified hardware which provides Secure Boot, UEFI, and TPM settings out of the box. These technologies, combined with [virtualization-based security (VBS)][], help protect security-sensitive workloads. Visit [Azure Stack HCI solutions][] for validated solutions.
- Use Secure Boot to ensure that the server only boots software that's trusted by an Original Equipment Manufacturer.
- Use UEFI to control the booting process of the server.
- Use TPM to store cryptographic keys and to isolate all hardware-based, security-related functions.
- BitLocker Drive Encryption allows you to encrypt Storage Spaces Direct volumes at rest.
- Configure [Calico network policies][] to define network isolation rules between containers.
- For increased security requirements, consider deploying a workload cluster on a dedicated Windows server.
- Use [Microsoft Defender for Cloud][2], available through Windows Admin Center, to centrally manage security settings for servers and clusters. It provides threat protection for your Arc–enabled Kubernetes clusters. The Microsoft Defender for Cloud extension collects data from nodes in the cluster and sends it to the Azure Defender for Kubernetes backend in the cloud for further analysis.
- Secure communication with certificates.
- Rotate encryption keys of the Kubernetes secret store (etcd) using the Key Management Server (KMS) plug-in.

#### Application security

- Use [Azure Key Vault Secrets provider extension][] on your AKS on Azure Stack HCI to further protect your secrets that are used by different applications, by storing them in Azure Key Vault service.
- Use [Open Service Mesh AKS add-on][] to secure service-to-service communication by enabling mutual TLS (mTLS). You can also use this add-on for defining and executing fine-grained access control policies for services.
- Use [Azure Policy for Kubernetes][] to enforce cluster security policies, such as no privileged pods.
- Use an Azure Container Registry that contains vulnerability scanning in its container repo.
- Use group-managed security accounts for Windows workloads with a non-domain joined host. (Only applicable for Windows Server.)

#### Container security

- Harden the host and daemon environment by removing unnecessary services.
- Keep secrets out of the images and mount them only through the container orchestration engine.
- Secure the images in an Azure Container Registry that supports vulnerability scanning and RBAC.
- [Use isolation of containers][], and avoid running containers in privileged mode to prevent attackers to escalate the privileges if the container is compromised.

### Cost optimization

- Use the [Azure pricing calculator][] to estimate costs for the services used in the architecture. The [cost optimization][] section in [Microsoft Azure Well-Architected Framework][cost optimization] describes other best practices. For more information, see [Pricing details](/azure/aks/hybrid/pricing).
- Consider implementing hyper-threading on your physical computer, to optimize the cost, because the AKS billing unit is a virtual core.

### Operational excellence

- **Create Cluster Wizard**. Experience a simplified provisioning and management experience with Windows Admin Center. The [Create Cluster wizard in Windows Admin Center][] provides a wizard-driven interface that guides you through creating an Azure Stack HCI cluster. The Create Cluster Wizard is a tradeoff for ease vs creating deploy scripts that you can source control for auditing and repeatability across multiple deployments. Similarly, [Windows Admin Center simplifies the process of managing Azure Stack HCI VMs][].
- [Azure Arc][]. Integrate with Azure Arc or a range of Azure services that provide additional management, maintenance, and resiliency capabilities (for example, Azure Monitor and Log analytics).
- **GitOps.** Instead of manually configuring Kubernetes components, use automated tooling to apply configurations to a Kubernetes cluster, as these configurations are checked into a source repository. This process is often referred to as GitOps, and popular GitOps solutions for Kubernetes include Flux and Argo CD. In this architecture, we recommend using the Microsoft-provided GitOps extension, which is based on Flux.
- **Azure Arc–enabled [Open Service Mesh (OSM)][].** A lightweight, extensible, cloud-native service mesh that allows users to uniformly manage, help secure, and get out-of-the-box observability features for highly dynamic microservice environments.

### Performance efficiency

- Use Azure Stack HCI-certified hardware for improved application uptime and performance, simplified management and operations, and lower total cost of ownership.
- Understand the AKS on Azure Stack HCI limits. Microsoft supports AKS on Azure Stack deployments with a maximum of eight physical servers per cluster, eight Kubernetes Clusters, and 200 VMs.
- Scaling AKS on Azure Stack HCI depends on the number of worker nodes and target clusters. To properly dimension the hardware for the worker nodes, you need to anticipate the number of pods, containers, and worker nodes in a target cluster. You should ensure that at least 15% of Azure Stack HCI capacity is reserved for both planned and unplanned failure. For performance efficiency use computing resources efficiently to meet system requirements, and to maintain that efficiency as demand changes and technologies evolve. The general rule is that if one node goes offline during maintenance, or during unplanned failure, the remaining nodes can have enough capacity to manage the increased load.
- Consider increasing the size of the load balancer VM if you're running many Kubernetes services in each target cluster.
- AKS on Azure Stack HCI distributes the worker nodes for each node pool in a target cluster using Azure Stack HCI placement logic.
- Plan IP address reservations to configure AKS hosts, workload clusters, Cluster API servers, Kubernetes Services, and Application services. Microsoft recommends reserving a minimum of 256 IP addresses for AKS deployment on Azure Stack HCI.
- Consider implementing an ingress controller that works at Layer 7 and uses more intelligent rules to distribute application traffic.
- Implement network performance optimization for traffic bandwidth allocation.
- Use graphics processing unit (GPU) acceleration for extensive workloads.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal authors:**

- [Lisa DenBeste](https://www.linkedin.com/in/lisa-denbeste) | Project Management Program Manager
- [Kenny Harder](https://www.linkedin.com/in/kenny-harder-03b14a64) | Project Manager
- [Mike Kostersitz](https://www.linkedin.com/in/mikekostersitz) | Principal Program Manager Lead
- [Meg Olsen](https://www.linkedin.com/in/megolsenpm) | Principal
- [Nate Waters](https://www.linkedin.com/in/nate-waters) | Product Marketing Manager

**Other contributors:**

- [Walter Oliver](https://www.linkedin.com/in/walterov) | Senior Program Manager

## Next steps

- [AKS overview](/azure/aks/hybrid/aks-hybrid-options-overview)

  [Azure Stack HCI (20H2)]: /azure-stack/hci/overview
  [1]: https://azure.microsoft.com/products/azure-stack/hci/
  [Azure Kubernetes Service on Azure Stack HCI (AKS hybrid)]: /azure/aks/hybrid/aks-hybrid-options-overview
  [Windows Admin Center]: /windows-server/manage/windows-admin-center/overview
  [An Azure subscription]: https://azure.microsoft.com
  [Azure Arc]: https://azure.microsoft.com/services/azure-arc/
  [Azure role-based access control (Azure RBAC)]: /azure/role-based-access-control/
  [Azure Monitor]: https://azure.microsoft.com/services/monitor/
  [Microsoft Defender for Cloud]: https://azure.microsoft.com/services/defender-for-cloud/
  [Azure Monitor Container Insights.]: /azure/azure-monitor/containers/container-insights-overview
  [Azure Automation]: /azure/automation/automation-hybrid-runbook-worker
  [virtualized]: /azure/azure-arc/servers/manage-vm-extensions
  [containerized]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
  [Velero]: /azure/aks/hybrid/backup-workload-cluster
  [Azure Blob Storage]: /azure/aks/hybrid/backup-workload-cluster
  [Velero and Azure Blob Storage]: /azure/aks/hybrid/backup-workload-cluster
  [Azure Arc–enabled Kubernetes Service]: /azure/azure-arc/kubernetes/
  [Azure Policy for Kubernetes]: /azure/governance/policy/concepts/policy-for-kubernetes
  [Azure RBAC]: /azure/azure-arc/kubernetes/conceptual-azure-rbac
  [Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
  [cost optimization]: /azure/architecture/framework/cost/overview
  [Create Cluster Wizard in Windows Admin Center]: /azure-stack/hci/deploy/create-cluster
  [Windows Admin Center simplifies the process of managing Azure Stack HCI VMs]: /azure-stack/hci/manage/vm
  [Open Service Mesh (OSM)]: https://docs.openservicemesh.io/
  [virtualization-based security (VBS)]: /windows-hardware/design/device-experiences/oem-vbs
  [Azure Stack HCI solutions]: https://azure.microsoft.com/overview/azure-stack/hci
  [Calico network policies]: /azure/aks/hybrid/calico-networking-policy
  [2]: /azure/defender-for-cloud/defender-for-cloud-introduction
  [Azure Key Vault Secrets provider extension]: /azure/azure-arc/kubernetes/tutorial-akv-secrets-provider
  [Open Service Mesh AKS add-on]: /azure/aks/open-service-mesh-about
  [Use isolation of containers]: /azure/aks/hybrid/container-security#practice-isolation

## Related resources

- [Network architecture for AKS on Azure Stack HCI](aks-network.yml)
