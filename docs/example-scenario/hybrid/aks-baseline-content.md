This article describes a baseline architecture for Microsoft Azure Kubernetes Service (AKS) on Azure Local and also discusses AKS on bare metal, an alternative deployment option that runs directly on physical hardware without a hypervisor layer. Both options are part of [AKS Hybrid and Edge](/azure/aks/aksarc/aks-overview), the Microsoft *AKS everywhere* strategy that extends the AKS engine, APIs, and operational model to infrastructure you own or operate.

The article covers design and implementation considerations for both options. It includes recommendations for cluster networking, security, identity, management, and monitoring based on your organization's business requirements.

AKS on Azure Local requires Azure Local version 23H2 or later. For more information about the latest version, see [What's new in AKS Hybrid and Edge on Azure Local](/azure/aks/aksarc/aks-whats-new-local).

[AKS on bare metal](/azure/aks/aksarc/aks-bare-metal-overview) is currently in preview. For legal terms that apply to Azure preview features, see the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

> [!NOTE]
> This article's guidance doesn't cover [AKS on Windows Server](/azure/aks/aksarc/overview), which uses a different management model.

## Architecture

:::image type="complex" border="false" source="media/aks-azure-local-baseline-v9.svg" alt-text="Diagram that shows a baseline architecture for Azure Kubernetes Service on Azure Local." lightbox="media/aks-azure-local-baseline-v9.svg":::
   The image includes a customer-hosted section and an Azure section. The customer-hosted section includes three key subsections: Azure Arc resource bridge, Kubernetes cluster, and Azure Local instance. The resource bridge section includes the management cluster containing Hyper-V VMs system services, which has containers. The Kubernetes cluster section includes two subsections: the control plane and the worker nodes. The control plane section includes Hyper-V VM system services sections that have containers. A user outside the cluster connects to an API server in the control plane via a load balancer. Dotted lines connect the load balancer and the API server to the Hyper-V sections. The worker nodes section includes Hyper-V VMs and a user application with containers. The Azure Local instance section includes four physical nodes. The Azure section contains icons for Azure Arc, Azure Automation accounts, Azure Monitor, Azure Blob Storage, Azure Policy, and Defender for Cloud.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-azure-local-baseline-v9.vsdx) of this architecture.*

### Components

This architecture includes the following components that are installed on the edge or on-premises and on Azure.

#### Edge or on-premises components

The following components are installed on the edge or on-premises:

- [Azure Local][] is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Linux and Windows workloads and their storage in a hybrid on-premises environment. An Azure Local instance consists of a cluster that can range from 1 to 16 nodes. In this architecture, Azure Local provides the physical infrastructure to run AKS clusters, which enables local compute and storage with Azure integration.

- [Azure Arc resource bridge][] is a prepackaged highly available virtual machine (VM) that runs on Azure Local. In this architecture, it deploys and manages multiple AKS clusters on Azure Local, and serves as the control plane for hybrid Kubernetes operations.

- [AKS Hybrid and Edge][] is an on-premises AKS implementation that automates running containerized applications at scale. In this architecture, each AKS on Azure Local cluster includes highly available control plane nodes and worker nodes. Containerized applications run on the worker nodes in the AKS cluster. You can deploy up to 32 AKS clusters to support application isolation. An AKS cluster consists of the following components:

  - **The control plane** runs on Azure Linux and includes API server components that interact with the Kubernetes API. The control plane uses etcd, a distributed key-value store, to store all the cluster configuration and data.

  - **The worker nodes** run on either Azure Linux or Windows Server and host containerized applications in pods. A pod represents a single application instance and usually maps one-to-one with a container, although some pods include multiple containers. A deployment consists of one or more identical pods. You can logically group pods and deployments into namespaces to define management access.

#### Azure components

The following components are installed on Azure:

  - [Azure Arc][] is a cloud-based service that extends the Azure Resource Manager-based management model to non-Azure resources, including non-Azure VMs, Kubernetes clusters, and containerized databases. In this architecture, Azure Arc enables centralized governance, monitoring, and policy enforcement for AKS clusters that run on Azure Local.

  - [Azure Automation][] is a cloud-based automation and configuration service. In this architecture, Automation supports consistent management of AKS clusters and workloads across hybrid environments through automated workflows.

  - [Azure Monitor][] is a comprehensive cloud-based service that collects, analyzes, and acts on telemetry from your cloud and on-premises environments to help maximize application and service availability and performance. In this architecture, Azure Monitor monitors the health and performance of AKS clusters and container workloads that run on Azure Local.

  - [Azure Policy][] is a cloud-based service that helps enforce organizational standards and assess compliance at scale by evaluating the properties of Azure resources, including resources enabled by Azure Arc, against business rules. In this architecture, [Azure Policy for Kubernetes][] applies policies to AKS clusters and Kubernetes workloads to ensure consistent configuration and security practices.

  - [Microsoft Defender for Cloud][] is a unified infrastructure security management system that strengthens the security posture of your datacenters and provides advanced threat protection across your hybrid workloads in the cloud and on-premises. In this architecture, Defender for Cloud protects AKS clusters and workloads on Azure Local by monitoring for threats and enforcing security best practices.

### Alternative

[AKS on bare metal][] runs a Kubernetes cluster directly on physical hardware, without the hypervisor and virtual machine layer that the Azure Local architecture uses. Consider this option when a workload needs the full compute capacity of the host, or when a location doesn't justify the footprint of a full Azure Local instance.

AKS on bare metal introduces different architectural tradeoffs than AKS running on Azure Local, including:

- **Availability model.** Unlike Azure Local, which uses failover clustering and live migration for high availability, AKS on bare metal relies on application-level or multicluster availability.

- **Storage model.** AKS on bare metal doesn't include the shared Storage Spaces Direct storage layer that's available in Azure Local. Persistent volumes use host-local storage and are tied to the node that stores the data. To support workload mobility across nodes, use a distributed storage solution, for example a Container Storage Interface (CSI) driver, that provides shared or replicated storage.

- **Compute efficiency.** Because no compute capacity is reserved for a hypervisor or management VMs, all compute on the host is available to the Kubernetes cluster and its workloads.

- **Governance and security.** The cluster connects to Azure Arc, so has the same Azure Policy, Azure Monitor, and Azure role-based access control (Azure RBAC) integration as the Azure Local architecture. Apply the Kubernetes-level security recommendations listed in [Considerations](#considerations). Storage-specific guidance such as BitLocker encryption for Storage Spaces Direct volumes doesn't apply, because AKS on bare metal doesn't have that storage layer. Reassess host-level disk encryption and storage controls separately for your bare-metal host.

> [!NOTE]
> AKS on bare metal is in preview and currently supports only single-node clusters. We don't recommend using this preview for production workloads. Support is best effort and doesn't guarantee any service-level agreement (SLA). Weigh these constraints against your reliability requirements before choosing this option instead of AKS on Azure Local. For current scope, supported regions, and other preview details, see [AKS on bare metal][] and [AKS on bare metal preview limitations][].

## Scenario details

This architecture has the following requirements:

### Hardware requirements

Use Azure Local-certified hardware, which provides Secure Boot, United Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) settings out of the box. Compute requirements depend on the application and the total number of control plane nodes and worker nodes in all AKS clusters that run on Azure Local. Use multiple physical nodes for Azure Local deployments to achieve high availability. All servers must have the same manufacturer and model and use 64-bit Intel Nehalem-grade, AMD EPYC-grade, or later compatible processors that support second-level address translation.

### Network requirements

Kubernetes provides an abstraction layer to networking by connecting the Kubernetes nodes to the virtual overlay network. Kubernetes also provides inbound and outbound connectivity for pods through the *kube-proxy* component.

This architecture uses a virtual overlay network that allocates IP addresses by using static IP address networking. This implementation uses [Calico][] as the container network interface provider. Static IP address networking requires predefined address pools for all the objects in the deployment, which adds extra benefits and guarantees that the workload and application are always reachable. A separate IP address pool is used to allocate IP addresses to Kubernetes services.

The network specifications are defined as [logical networks][] in Azure Local. Before you create the logical networks in Azure Local, see [AKS Hybrid and Edge network requirements][] and [IP address planning requirements][].

### Storage requirements

Use the same drive type, size, and model for every server in the cluster. Azure Local works with direct-attached serial ATA (SATA), serial attached SCSI (SAS), NVM Express (NVMe), or persistent memory drives that are physically attached to one server each. For cluster volumes, HCI uses software-defined storage technology like Storage Spaces Direct to combine the physical drives in the storage pool for fault tolerance, scalability, and performance. Applications that run in AKS on Azure Local often expect the following storage options to be available:

- **Volumes** represent a way to store, retrieve, and persist data across pods and through the application lifecycle.

- **Persistent volumes** are storage resources that the Kubernetes API creates and manages. They can exist beyond the lifetime of an individual pod.

To optimize cost and performance, consider defining storage classes for different tiers and locations. Storage classes support dynamic provisioning of persistent volumes and define the *reclaimPolicy*, which specifies how the underlying storage resource should manage persistent volumes when the pod is deleted.

### AKS on Azure Local creation and management

Create and manage AKS on Azure Local like any other Azure resource that you manage. You can use the [Azure portal](/azure/aks-hybrid-edge/local/aks-create-clusters-portal), [Azure CLI](/azure/aks-hybrid-edge/local/aks-create-clusters-cli), [Azure Resource Manager templates (ARM templates)](/azure/aks-hybrid-edge/local/resource-manager-quickstart), or [Bicep](/azure/aks-hybrid-edge/local/create-clusters-bicep).

The [Azure Arc-enabled Kubernetes service][] provides Resource Manager representation of AKS on an Azure Local instance. When you create an AKS on Azure Local cluster, Azure Arc agents automatically deploy in a Kubernetes namespace to collect logs and metrics and gather cluster metadata, Kubernetes version, and node count.

### Potential use cases

- Implement highly available, container-based workloads in an on-premises Kubernetes implementation of AKS.

- Automate running containerized applications at scale.

- Lower total cost of ownership (TCO) by using Microsoft-certified solutions, cloud-based automation, centralized management, and centralized monitoring.

## Recommended services and extensions

The following recommendations apply to most scenarios. Follow the recommendations unless you have a specific requirement that overrides them. Deploy the following Azure services in the same Azure region as the AKS cluster.

- [Use the MetalLB extension][] to deploy a MetalLB load balancer on the AKS cluster for level 2 (L2) load balancing.

- [Enable container insights and logging on the AKS cluster][] to monitor the performance of container workloads that run on Linux and Windows node pools. Azure Monitor container insights collect memory and processor metrics from controllers, nodes, and containers via the cluster's Kubernetes Metrics API. By using container insights, you can identify memory and processor usage, detect overall Kubernetes cluster performance, understand cluster behavior, and configure alerts for proactive monitoring.

- [Use available automation capabilities][] for end-to-end management. AKS provides a wide range of automation features, including OS updates and full-stack updates such as firmware and drivers from Azure Local vendors and partners. You can run Windows PowerShell locally from an Azure Local machine or remotely from a management computer. Integration with Automation and Azure Arc supports various automation scenarios for [virtualized][] and [containerized][] workloads.

- [Apply governance with Azure Policy][] to enforce resource controls at scale. Azure Policy extends Gatekeeper v3, which is an admission controller webhook for Open Policy Agent, to centrally enforce safeguards on AKS components such as pods, containers, and namespaces.

- [Deploy applications consistently at scale using Flux v2 configurations and Azure Policy][] to achieve scalable, policy-driven deployments. You can select a built-in policy definition and create policy assignments that have specific parameters for Flux setup. To support separation of concerns, create multiple assignments by using different Flux configurations that point to separate sources, such as one Git repository for cluster administrators and another repository for application teams.
  
## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Implement three to five control plane nodes and multiple worker nodes in the Kubernetes cluster to meet the minimum availability requirements for applications.

- Review requirements for failover clustering. AKS deployments use failover clustering and live migration for high availability and fault tolerance. Live migration is a Hyper-V feature that lets you transparently move running VMs from one Hyper-V host to another host without perceived downtime.

- Configure deployments to use Kubernetes features, such as deployments, affinity mapping, and *ReplicaSets*, to ensure that the pods are resilient in disruption scenarios.

- Limit usage of public container images and pull only from container registries for which you control the SLA, such as Azure Container Registry.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Focus on the entire stack by securing both the host and its containers.

#### Infrastructure security

- Use Azure Local certified hardware that provides Secure Boot, UEFI, and TPM settings out of the box. These technologies, combined with [virtualization-based security][], help protect security-sensitive workloads. For more information about validated solutions, see [Azure Local solutions][].

  - Secure Boot ensures that a server boots only software that the original equipment manufacturer trusts.

  - UEFI controls the server booting process.

  - TPM stores cryptographic keys and isolates all hardware-based, security-related functions.

  - BitLocker Drive Encryption encrypts Storage Spaces Direct volumes at rest.

- Use Defender for Cloud to manage security settings for servers and clusters and provide threat protection for your Azure Arc-enabled Kubernetes clusters. The [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) extension collects data from cluster nodes and sends it to the Defender for Containers cloud back end for analysis.

- Use [Azure RBAC][] for role assignments and to manage access to the AKS cluster.

- Use [workload identity][] for securing and managing identities to access Azure resources from workload pods.

- Use the included etcd secrets encryption that uses a key management service (KMS) plugin. All AKS clusters have a built-in KMS plugin enabled by default. This plugin generates the encryption key and automatically rotates it every 30 days.

#### Application security

- Use the [Azure Key Vault Secrets provider extension][] on your AKS on Azure Local instance to further protect the secrets that various applications use by storing them in Key Vault.

- Use [Azure Policy for Kubernetes][] to enforce cluster security policies such as no privileged pods.

- Use a Container Registry instance that contains vulnerability scanning in its container repo.

#### Container security

- Harden the host and daemon environment by removing unnecessary services.

- Keep secrets out of the images and mount them only through the container orchestration engine.

- Secure the images in a Container Registry instance that supports vulnerability scanning and [Azure RBAC][].

- [Isolate containers][] and avoid running containers in privileged mode to prevent attackers from escalating privileges if a container is compromised.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- **Explore costs for the Azure-hosted services in this architecture,** such as Azure Monitor, Container Registry, Defender for Cloud, and Automation, by using the [sample cost estimate][pricing calculator]. The Well-Architected Framework [Cost Optimization] section describes other best practices. AKS is available at no extra charge when you use it on Azure Local.

- **Estimate Azure Local host costs separately.** Azure Local charges a per-physical-core monthly service fee based on your deployment type. You pay for each physical core per month for hyperconverged deployments with no external storage (L1), which is the option this architecture uses. For current rates and other deployment types, see [Azure Local pricing details](https://azure.microsoft.com/pricing/details/azure-local/).

> [!NOTE]
> Azure Local isn't currently represented in the Azure pricing calculator. AKS on bare metal preview uses zero-rated billing meters, so there's no charge for the AKS cluster resources during the preview period. Standard Azure charges still apply for the underlying Azure Arc-enabled machine and any Azure services, such as Azure Monitor and Azure Policy. For more information, see [AKS on bare metal preview limitations][].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Infrastructure as Code (IaC):** Use ARM templates, Bicep, or Terraform to automate cluster deployment at scale. Use the Azure portal to explore available and supported options for cluster creation, and export your selections as a template. Review [Azure verified modules][] for a scalable deployment option. For more information, see the [hybrid container service module][] on GitHub.

- **Azure Arc:** Integrate with [Azure Arc][] or Azure services such as Azure Monitor and Log Analytics that provide extra management, maintenance, and resiliency capabilities.

- **GitOps:** Instead of manually configuring Kubernetes components, check configurations into a source repository and then use automated tooling to apply them to Kubernetes clusters. This process is called *GitOps*. Common GitOps solutions for Kubernetes include Flux and Argo CD. In this architecture, we recommend that you use the Microsoft-provided GitOps extension based on Flux.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Use Azure Local-certified hardware for improved application uptime and performance, simplified management and operations, and lower TCO.

- Understand the limits of AKS on Azure Local. Microsoft supports AKS on Azure Local deployments that have a maximum of 16 physical servers per Azure Local cluster, up to 32 AKS clusters per Azure Local instance, and up to 200 total nodes in a single AKS cluster. For more information, see [Scale requirements for AKS on Azure Local][].

- Determine AKS on Azure Local requirements based on the number of control plane nodes, worker nodes, and AKS clusters. To properly size the hardware, anticipate the number of pods, containers, and worker nodes required for each AKS cluster. Reserve at least 15 percent of Azure Local capacity to accommodate both planned and unplanned failures.

- Use computing resources in a way that meets system requirements while maintaining efficiency as demand changes and technologies evolve. As a general rule, if a node goes offline, whether because of maintenance or an unexpected failure, the remaining nodes should have enough capacity to handle the increased load.

- Review AKS node placement logic. AKS on Azure Local distributes the worker nodes for each node pool in an AKS cluster by using Azure Local placement logic through [availability sets][].

- Plan IP address reservations to configure AKS clusters and Kubernetes services.

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

Other contributor:

- [Walter Oliver](https://www.linkedin.com/in/walterov) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS enabled by Azure Arc](/azure/aks/aksarc/aks-overview)
- [AKS on bare metal overview (preview)](/azure/aks/aksarc/aks-bare-metal-overview)

  [Apply governance with Azure Policy]: /azure/governance/policy/overview
  [Azure Arc resource bridge]: /azure/azure-arc/resource-bridge/overview
  [availability sets]: /azure/aks-hybrid-edge/local/hyperconverged/availability-sets
  [Azure Arc]: /azure/azure-arc/overview
  [Azure Arc-enabled Kubernetes Service]: /azure/azure-arc/kubernetes/
  [Azure Automation]: /azure/automation/overview
  [Azure Key Vault Secrets provider extension]: /azure/azure-arc/kubernetes/tutorial-akv-secrets-provider
  [AKS Hybrid and Edge]: /azure/aks-hybrid-edge/aks-overview
  [AKS Hybrid and Edge network requirements]: /azure/aks-hybrid-edge/local/hyperconverged/network-system-requirements
  [AKS on bare metal]: /azure/aks-hybrid-edge/bare-metal/aks-bare-metal-overview
  [AKS on bare metal preview limitations]: /azure/aks-hybrid-edge/bare-metal/aks-bare-metal-preview-limitations
  [Azure Local solutions]: https://azure.microsoft.com/products/local
  [Azure Local]: /azure/well-architected/service-guides/azure-local
  [Azure Monitor]: /azure/azure-monitor/fundamentals/overview
  [Azure Policy]: /azure/governance/policy/overview
  [Azure Policy for Kubernetes]: /azure/governance/policy/concepts/policy-for-kubernetes
  [Azure RBAC]: /azure/role-based-access-control/
  [Azure role-based access control (Azure RBAC)]: /azure/aks-hybrid-edge/local/hyperconverged/azure-rbac-local
  [Azure verified modules]: /community/content/azure-verified-modules
  [Calico]: /azure/aks-hybrid-edge/windows-server/concepts-security
  [containerized]: /azure/azure-arc/kubernetes/tutorial-use-gitops-flux2
  [Cost Optimization]: /azure/well-architected/cost-optimization/principles
  [Defender for Cloud]: /azure/defender-for-cloud/defender-for-cloud-introduction
  [Deploy applications consistently at scale using Flux v2 configurations and Azure Policy]: /azure/azure-arc/kubernetes/use-azure-policy-flux-2
  [Enable container insights and logging on the AKS cluster]: /azure/azure-monitor/containers/kubernetes-monitoring-enable#enable-container-insights-and-logging-on-an-aks-cluster
  [hybrid container service module]: https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/hybrid-container-service/provisioned-cluster-instance
  [IP address planning requirements]: /azure/aks-hybrid-edge/local/hyperconverged/aks-hci-ip-address-planning
  [Isolate containers]: /azure/aks-hybrid-edge/windows-server/container-security#practice-isolation
  [logical networks]: /azure/azure-local/manage/create-logical-networks
  [Microsoft Defender for Cloud]: /azure/defender-for-cloud/defender-for-cloud-introduction
  [pricing calculator]: https://azure.com/e/7129723b569d4ca7ad092354629af35f
  [Scale requirements for AKS on Azure Local]: /azure/aks-hybrid-edge/local/hyperconverged/scale-requirements
  [Use available automation capabilities]: /azure/automation/automation-hybrid-runbook-worker
  [Use the MetalLB extension]: /azure/aks-hybrid-edge/local/hyperconverged/load-balancer-overview
  [virtualization-based security]: /windows-hardware/design/device-experiences/oem-vbs
  [virtualized]: /azure/azure-arc/servers/manage-vm-extensions
  [workload identity]: /azure/aks-hybrid-edge/local/hyperconverged/workload-identity

## Related resources

- [Deploy apps with AKS Hybrid and Edge using GitOps](aks-hybrid-azure-local.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml)
