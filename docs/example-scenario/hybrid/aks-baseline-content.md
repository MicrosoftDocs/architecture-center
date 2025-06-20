This scenario illustrates how to design and implement a baseline architecture for Microsoft Azure Kubernetes Service (AKS) running on Azure Local.

This article includes recommendations for networking, security, identity, management, and monitoring of the cluster based on an organization's business requirements.

> [!IMPORTANT]
> The information in this article applies to [AKS on Azure Local and AKS on Windows Server](/azure/aks/aksarc/overview). The most recent version of AKS runs on the Azure Stack HCI, version 23H2 operating system. For more information about the latest version, see the [AKS on Azure Local documentation](/azure/aks/hybrid/aks-whats-new-23h2).

## Architecture

The following image shows the baseline architecture for Azure Kubernetes Service on Azure Local:

:::image type="complex" border="false" source="media/aks-azure-local-baseline-v9.svg" alt-text="Diagram that shows a baseline architecture for Azure Kubernetes Service on Azure Local." lightbox="media/aks-azure-local-baseline-v9.svg":::
   The image includes a customer-hosted section and an Azure section. The customer-hosted section includes three key subsections: Arc Resources Bridge (ARB), Kubernetes cluster, and Azure Local instance. The ARB section includes the Management cluster that contains the Hyper-V virtual machines system service. The Kubernetes cluster section includes two key subsections: the Control plane and the Workers nodes. The Control plane section includes Hyper-V virtual machine system services sections that have containers. Dotted lines connect Microsoft Defender for Cloud and API server to the Hyper-V sections. The Worker nodes section includes Hyper-V VMs, containers, and user applications. The Azure Local instance section includes four physical nodes. The Azure section contains icons that represent Azure Arc, Azure Automation Services, Azure Monitor, Azure Blob Storage, Azure Policy, and Microsoft Defender for Cloud.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-azure-local-baseline-v9.vsdx) of this architecture.*

The architecture diagram above depicts the following components:

- The components installed on the edge or on-premises are:

  - One [Azure Local][] instance. A hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Linux and Windows workloads and their storage in a hybrid on-premises environment. An Azure Local instance is implemented as a 1-16 node cluster.

  - [Arc Resource Bridge][]. Arc Resource Bridge is a highly available virtual machine (VM) running on Azure Local. Arc Resource Bridge is responsible for deploying and managing multiple AKS clusters.

  - [Azure Kubernetes Service (AKS) on Azure Local][]. An on-premises implementation of AKS, which automates running containerized applications at scale. An AKS on Azure Local cluster has highly available control plane nodes and worker nodes. Containerized applications run on the worker nodes in an AKS cluster. To achieve application isolation, you can deploy up to 32 AKS clusters. The AKS cluster consists of the following components:

    - **Control plane.** Runs on Azure Linux operating system and contains API server components for interaction with Kubernetes API and a distributed key-value store, etcd, for storing all the configuration and data of the cluster.

    - **Worker nodes.** Run on Azure Linux operating system or Windows Server operating system that hosts containerized applications in pods. Pods represent a single instance of your application, that usually has a 1:1 mapping with a container, but certain pods can contain multiple containers. Deployments represent one or more identical pods. Pods and deployments are logically grouped into a namespace that controls access to management of the resources.

- The components installed on Azure are:

  - [Azure Arc][]. A cloud-based service that extends the Azure Resource Manager–based management model to non-Azure resources including non-Azure virtual machines (VMs), Kubernetes clusters, and containerized databases.

  - [Azure Automation][]. Delivers a cloud-based automation and configuration service that supports consistent management across your Azure and non-Azure environments.

  - [Azure Monitor][]. A cloud-based service that maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments.

  - [Azure Policy][]. A cloud-based service that helps enforce organizational standards and assess compliance at-scale by evaluating Azure (including Arc-enabled) resources to the properties of those resources to business rules. These standards also include [Azure Policy for Kubernetes][], which applies policies to the workloads running inside the cluster.

  - [Microsoft Defender for Cloud][]. A unified infrastructure security management system that strengthens the security posture of your data centers and provides advanced threat protection across your hybrid workloads in the cloud and on-premises.

## Scenario details

### Potential use cases

- Implement highly available, container-based workloads in an on-premises Kubernetes implementation of AKS.

- Automate running containerized applications at scale.

- Lower total cost of ownership (TCO) through Microsoft-certified solutions, cloud-based automation, centralized management, and centralized monitoring.

### Certified hardware

Use Azure Local-certified hardware, which provides Secure Boot, United Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) settings out of the box. Compute requirements depend on the application and the total number of control plane nodes and worker nodes in all AKS clusters that run on Azure Local. Use multiple physical nodes for deployment of Azure Local to achieve high availability. All servers are required to be of the same manufacturer and model, using 64-bit Intel Nehalem grade, AMD EPYC grade, or later compatible processors with second-level address translation (SLAT).

### Network requirements

Kubernetes provides an abstraction layer to networking by connecting the Kubernetes nodes to the virtual overlay network. It also provides inbound and outbound connectivity for pods through the *kube-proxy* component.

The architecture uses a virtual overlay network that allocates IP addresses by using static IP networking. Project Calico is used as the CNI provider in this architecture. Static IP networking requires pre-defined address pool for all the objects in the deployment. It adds extra benefit and guarantees that the workload and application are always reachable. A seperate IP pool is used for allocating IP addresses to Kubernetes services.

The network specification are defined as [Logical Networks][] in Azure Local, see [network requirements][] and [IP address planning][] before creating the logical networks in Azure Local.

### Storage requirements

For every server in the cluster, use the same types of drives that are the same size and model. Azure Local works with direct-attached Serial Advanced Technology Attachment (SATA), Serial Attached SCSI (SAS), Non-Volatile Memory Express (NVMe), or persistent memory drives that are physically attached to one server each. For cluster volumes, HCI uses software-defined storage technology (Storage Spaces Direct) to combine the physical drives in the storage pool for fault tolerance, scalability, and performance. Applications that run in AKS on Azure Local often expect the following storage options to be available to them:

- **Volumes.** Represent a way to store, retrieve, and persist data across pods and through the application lifecycle.

- **Persistent Volumes.** A storage resource that's created and managed by Kubernetes API and can exist beyond the lifetime of an individual pod.

Consider defining storage classes for different tiers and locations to optimize cost and performance. The storage classes support dynamic provisioning of persistent volumes and define the *reclaimPolicy* to specify the action of the underlying storage resource for managing persistent volumes when the pod is deleted.

### Create and manage AKS on Azure Local

You should create and manage AKS on Azure Local like any other Azure resource you manage. You can use the [Azure portal](/azure/aks/aksarc/aks-create-clusters-portal), [Azure CLI](/azure/aks/aksarc/aks-create-clusters-cli), [ARM templates](/azure/aks/aksarc/resource-manager-quickstart), or [Bicep](/azure/aks/aksarc/create-clusters-bicep).

The [Azure Arc–enabled Kubernetes Service][] provides Azure Resource Manager representation of AKS on Azure Local instance. When you create an AKS on Azure Local cluster, Azure Arc agents are automatically deployed in a Kubernetes namespace to collect logs and metrics, gather cluster metadata, Kubernetes version, and node count.

## Recommended services and extensions

The following recommendations apply for most scenarios. Follow the recommendations unless you have a specific requirement that overrides them. The below Azure services must be deployed in the same Azure region as the AKS cluster. 

- Use the [MetalLB extension][]. Deploys a MetalLB load balancer on the AKS cluster to perform L2 load balancing.

- [Azure Monitor Container Insights.][] Monitors the performance of container workloads that are running on both Linux and Windows node pools. It collects memory and processor metrics, from controllers, nodes, and containers through the Metric API. With container insights, you can identify memory and processor utilization, detect overall Kubernetes cluster performance, understand the behavior of the Kubernetes cluster, and configure alerts for proactive monitoring.

- Use available [Automation capabilities][]. AKS provides a wide range of automation capabilities, with OS updates combined with full-stack updates including firmware and drivers provided by Azure Local vendors and partners. You can run Windows PowerShell locally from one of the Azure Local machines or remotely from a management computer. Integration with [Azure Automation][] and Azure Arc facilitates a wide range of automation scenarios for [virtualized][] and [containerized][] workloads.

- Provide cluster resource governance through [Azure Policy][]. Azure Policy extends Gatekeeper v3, an admission controller webhook for Open Policy Agent (OPA), to apply at-scale enforcements and safeguards on your AKS cluster components in a centralized, consistent manner. Cluster components include pods, containers, and namespaces.

- Deploy applications consistently at scale using [Flux v2 configurations and Azure Policy for Kubernetes][]. You can use Azure Policy to apply Flux v2 configurations at-scale across AKS clusters by selecting a built-in policy definition and creating a policy assignment. When assigning the configuration deployment policy, you specify parameters for the Flux setup to be applied within the defined scope. To support separation of concerns, you can create multiple policy assignments with different Flux configurations pointing to separate sources—for instance, one Git repository for cluster admins and another for application teams.
  
## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Implement 3-5 nodes for control plane, and multiple worker nodes in the Kubernetes cluster to meet the minimum level of availability for applications.

- Review requirements for failover clustering. AKS deployments use failover clustering and live migration for high availability and fault tolerance. Live migration is a Hyper-V feature that allows you to transparently move running virtual machines from one Hyper-V host to another without perceived downtime.

- Configure deployments to use Kubernetes features, such as Deployments, Affinity Mapping, and ReplicaSets, to ensure that the pods are resilient in disruption scenarios.

- Limit usage of public container images and only pull from container registries for which you have control over the SLA, such as ACR.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Focus on the entire stack by securing both the host and its containers.

#### Infrastructure security

- Use Azure Local certified hardware which provides Secure Boot, UEFI, and TPM settings out of the box. These technologies, combined with [virtualization-based security (VBS)][], help protect security-sensitive workloads. Visit [Azure Local solutions][] for validated solutions.

- Use Secure Boot to ensure that the server only boots software that's trusted by an Original Equipment Manufacturer.

- Use UEFI to control the booting process of the server.

- Use TPM to store cryptographic keys and to isolate all hardware-based, security-related functions.

- Use BitLocker Drive Encryption to encrypt Storage Spaces Direct volumes at rest.

- Use [Microsoft Defender for Cloud][], to manage security settings for servers and clusters. It provides threat protection for your Arc–enabled Kubernetes clusters. The Microsoft Defender for Cloud extension collects data from nodes in the cluster and sends it to the Azure Defender for Kubernetes backend in the cloud for further analysis.
 
- Use [Azure RBAC][]. Use for role assignment and to manage access to the AKS cluster.

- Use [Workload identity][] for securing and managing identities to access Azure resources from workload pods.

- AKS comes with encryption of etcd secrets using a Key Management Service (KMS) plugin. All AKS clusters have a built-in KMS plugin enabled by default. This plugin generates the Key Encryption Key (KEK) and automatically rotates it every 30 days.

#### Application security

- Use [Azure Key Vault Secrets provider extension][] on your AKS on Azure Local to further protect your secrets that are used by different applications, by storing them in Azure Key Vault service.

- Use [Azure Policy for Kubernetes][] to enforce cluster security policies, for example no privileged pods.

- Use an Azure Container Registry that contains vulnerability scanning in its container repo.

#### Container security

- Harden the host and daemon environment by removing unnecessary services.

- Keep secrets out of the images and mount them only through the container orchestration engine.

- Secure the images in an Azure Container Registry that supports vulnerability scanning and RBAC.

- [Use isolation of containers][], and avoid running containers in privileged mode to prevent attackers to escalate the privileges if the container is compromised.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Use the [Azure pricing calculator][] to estimate costs for the Azure services like Azure Monitor Container Insights used in the architecture. The [cost optimization][] section in [Microsoft Azure Well-Architected Framework][cost optimization] describes other best practices. AKS is available at no extra charge when you use it on Azure Local. For more information, see [Azure Local pricing details](https://azure.microsoft.com/pricing/details/azure-local/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Infrastructure as a Code**. Use ARM templates/Bicep or Terraform to automate cluster deployment at scale. Use Azure portal experience to explore available/supported options for the cluster creation and export your choices as a template. Review [Azure verified modules][] for scale deployment option. The module for AKS on Azure Local is [hybrid-container-service github][].

- [Azure Arc][]. Integrate with Azure Arc or a range of Azure services that provide additional management, maintenance, and resiliency capabilities (for example, Azure Monitor and Log analytics).

- **GitOps.** Instead of manually configuring Kubernetes components, use automated tooling to apply configurations to a Kubernetes cluster, as these configurations are checked into a source repository. This process is often referred to as GitOps, and popular GitOps solutions for Kubernetes include Flux and Argo CD. In this architecture, we recommend using the Microsoft-provided GitOps extension, which is based on Flux.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Use Azure Local-certified hardware for improved application uptime and performance, simplified management and operations, and lower total cost of ownership.

- Understand the AKS on Azure Local limits. Microsoft supports AKS on Azure Local deployments with a maximum of 16 physical servers per cluster, 32 Kubernetes Clusters, and 200 VMs.

- Scaling AKS on Azure Local depends on the number of control plane nodes, worker nodes and AKS clusters. To properly dimension the hardware, you need to anticipate the number of pods, containers, and worker nodes in an AKS cluster. You should ensure that at least 15% of Azure Local capacity is reserved for both planned and unplanned failure. For performance efficiency use computing resources efficiently to meet system requirements, and to maintain that efficiency as demand changes and technologies evolve. The general rule is that if one node goes offline during maintenance, or during unplanned failure, the remaining nodes can have enough capacity to manage the increased load.

- Review AKS node placement logic. AKS on Azure Local distributes the worker nodes for each node pool in an AKS cluster using Azure Local placement logic, the [Availability sets][].

- Plan IP address reservations to configure AKS clusters and Kubernetes Services.

- Implement network performance optimization for traffic bandwidth allocation.

- Use graphics processing unit (GPU) acceleration for extensive workloads.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paramesh Babu](https://www.linkedin.com/in/parameshbabu/) | Principal Program Manager
- [Lisa DenBeste](https://www.linkedin.com/in/lisa-denbeste) | Project Management Program Manager
- Kenny Harder | Project Manager
- [Mike Kostersitz](https://www.linkedin.com/in/mikekostersitz) | Principal Program Manager Lead
- [Meg Olsen](https://www.linkedin.com/in/megolsenpm) | Principal
- [Nate Waters](https://www.linkedin.com/in/nate-waters) | Product Marketing Manager

Other contributors:

- [Walter Oliver](https://www.linkedin.com/in/walterov) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS, enabled by Arc Overview](/azure/aks/aksarc/aks-overview)

  [AKS on Azure Local, version 23H2 (latest version)]: /azure/aks/aksarc/aks-whats-new-23h2
  [An Azure subscription]: https://azure.microsoft.com
  [Arc Resource Bridge]: /azure/azure-arc/resource-bridge/overview
  [Azure Arc–enabled Kubernetes Service]: /azure/azure-arc/kubernetes/
  [Azure Arc]: https://azure.microsoft.com/services/azure-arc/
  [Automation capabilities]: /azure/automation/automation-hybrid-runbook-worker
  [Availability Sets]: /azure/aks/aksarc/availability-sets
  [Azure Automation]: /azure/automation/overview
  [Azure Blob Storage]: /azure/aks/aksarc/backup-workload-cluster
  [Azure Key Vault Secrets provider extension]: /azure/azure-arc/kubernetes/tutorial-akv-secrets-provider
  [Azure Kubernetes Service (AKS) on Azure Local]: /azure/aks/aksarc/aks-overview
  [Azure Local solutions]: https://azure.microsoft.com/overview/azure-stack/hci
  [Azure Local, version 23H2]: /azure/azure-local/whats-new
  [Azure Local]: https://azure.microsoft.com/en-us/products/local/
  [Azure Monitor Container Insights.]: /azure/azure-monitor/containers/container-insights-overview
  [Azure Monitor]: https://azure.microsoft.com/services/monitor/
  [Azure Policy for Kubernetes]: /azure/governance/policy/concepts/policy-for-kubernetes
  [Azure Policy]: /azure/governance/policy/overview
  [Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
  [Azure RBAC]: /azure/aks/aksarc/azure-rbac-23h2
  [Azure role-based access control (Azure RBAC)]: /azure/role-based-access-control/
  [Azure verified modules]: /community/content/azure-verified-modules
  [Calico network policies]: /azure/aks/aksarc/calico-networking-policy
  [containerized]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
  [cost optimization]: /azure/architecture/framework/cost/overview
  [Custom Location]: /azure/azure-arc/kubernetes/conceptual-custom-locations
  [Flux v2 configurations and Azure Policy for Kubernetes]: /azure/azure-arc/kubernetes/use-azure-policy-flux-2
  [ip address planning]: /azure/aks/aksarc/aks-hci-ip-address-planning
  [Logical Networks]: /azure/azure-local/manage/create-logical-networks
  [MetalLB extension]: /azure/aks/aksarc/load-balancer-overview
  [Microsoft Defender for Cloud]: /azure/defender-for-cloud/defender-for-cloud-introduction
  [Microsoft Defender for Cloud]: https://azure.microsoft.com/services/defender-for-cloud/
  [network requirements]: /azure/aks/aksarc/aks-hci-network-system-requirements
  [SSH Access Restrictions]: /azure/aks/aksarc/restrict-ssh-access
  [hybrid-container-service github]: https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/hybrid-container-service/provisioned-cluster-instance
  [Use isolation of containers]: /azure/aks/aksarc/container-security#practice-isolation
  [virtualization-based security (VBS)]: /windows-hardware/design/device-experiences/oem-vbs
  [virtualized]: /azure/azure-arc/servers/manage-vm-extensions
  [Workload identity]: /azure/aks/aksarc/workload-identity

## Related resources

- [Deploy apps with AKS Arc on Azure Local](aks-hybrid-azure-local.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml)
