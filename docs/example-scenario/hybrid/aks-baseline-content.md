This scenario illustrates how to design and implement a baseline architecture for Microsoft Azure Kubernetes Service (AKS) that runs on Azure Local.

This article includes recommendations for networking, security, identity, management, and monitoring of the cluster based on an organization's business requirements.

> [!IMPORTANT]
> The information in this article applies to AKS on Azure Local and [AKS on Windows Server](/azure/aks/aksarc/overview). The most recent version of AKS runs on the Azure Stack HCI, version 23H2 operating system. For more information about the latest version, see [AKS on Azure Local](/azure/aks/aksarc/aks-whats-new-local).

## Architecture

:::image type="complex" border="false" source="media/aks-azure-local-baseline-v9.svg" alt-text="Diagram that shows a baseline architecture for Azure Kubernetes Service on Azure Local." lightbox="media/aks-azure-local-baseline-v9.svg":::
   The image includes a customer-hosted section and an Azure section. The customer-hosted section includes three key subsections: Azure Arc resource bridge, Kubernetes cluster, and Azure Local instance. The resource bridge section includes the management cluster that contains the Hyper-V virtual machines system service. The Kubernetes cluster section includes two key subsections: the control plane and the worker nodes. The control plane section includes Hyper-V virtual machine system services sections that have containers. Dotted lines connect Microsoft Defender for Cloud and API server to the Hyper-V sections. The worker nodes section includes Hyper-V VMs, containers, and user applications. The Azure Local instance section includes four physical nodes. The Azure section contains icons that represent Azure Arc, Azure Automation services, Azure Monitor, Azure Blob Storage, Azure Policy, and Defender for Cloud.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-azure-local-baseline-v9.vsdx) of this architecture.*

### Components

- The following components are installed on the edge or on-premises:

  - [Azure Local][] is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Linux and Windows workloads and their storage in a hybrid on-premises environment. An Azure Local instance consists of a cluster that can range from 1 to 16 nodes. In this architecture, Azure Local provides the physical infrastructure to run AKS clusters, which enables local compute and storage with Azure integration.

  - [Azure Arc resource bridge][] is a highly available virtual machine (VM) that runs on Azure Local. In this architecture, it deploys and manages multiple AKS clusters on Azure Local. It serves as the control plane for hybrid Kubernetes operations.

  - [AKS on Azure Local][] is an on-premises implementation of AKS that automates running containerized applications at scale. In this architecture, each AKS on Azure Local cluster includes highly available control plane nodes and worker nodes. Containerized applications run on the worker nodes in the AKS cluster. To achieve application isolation, you can deploy up to 32 AKS clusters. The AKS cluster consists of the following components:

    - **The control plane** runs on Azure Linux and includes API server components that interact with the Kubernetes API. It also uses etcd, which is a distributed key-value store, to store all the cluster's configuration and data.

    - **The worker nodes** run on either the Azure Linux operating system or the Windows Server operating system. They host containerized applications in pods. Pods represent a single instance of your application and usually map one-to-one with a container. However, some pods include multiple containers. Deployments consist of one or more identical pods. Pods and deployments are logically grouped into a namespace, which defines access to the management of these resources.

- The following components are installed on Azure:

  - [Azure Arc][] is a cloud-based service that extends the Azure Resource Manager-based management model to non-Azure resources, including non-Azure VMs, Kubernetes clusters, and containerized databases. In this architecture, it enables centralized governance, monitoring, and policy enforcement for AKS clusters that run on Azure Local.

  - [Azure Automation][] is a cloud-based automation and configuration service. In this architecture, it supports consistent management of AKS clusters and workloads across hybrid environments through automated workflows.

  - [Azure Monitor][] is a cloud-based service that maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. In this architecture, it monitors the health and performance of AKS clusters and container workloads that run on Azure Local.

  - [Azure Policy][] is a cloud-based service that helps enforce organizational standards and assess compliance at scale by evaluating Azure, including resources enabled by Azure Arc, to the properties of those resources to business rules. In this architecture, [Azure Policy for Kubernetes][] applies policies to AKS clusters and Kubernetes workloads to ensure consistent configuration and security practices.

  - [Defender for Cloud][] is a unified infrastructure security management system that strengthens the security posture of your datacenters and provides advanced threat protection across your hybrid workloads in the cloud and on-premises. In this architecture, Defender for Cloud protects AKS clusters and workloads on Azure Local by monitoring for threats and enforcing security best practices.

## Scenario details

### Potential use cases

- Implement highly available, container-based workloads in an on-premises Kubernetes implementation of AKS.

- Automate running containerized applications at scale.

- Lower total cost of ownership (TCO) by using Microsoft-certified solutions, cloud-based automation, centralized management, and centralized monitoring.

### Certified hardware

Use Azure Local-certified hardware, which provides Secure Boot, United Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) settings out of the box. Compute requirements depend on the application and the total number of control plane nodes and worker nodes in all AKS clusters that run on Azure Local. Use multiple physical nodes for deployment of Azure Local to achieve high availability. All servers must be of the same manufacturer and model and use 64-bit Intel Nehalem-grade, AMD EPYC-grade, or later compatible processors that support second-level address translation.

### Network requirements

Kubernetes provides an abstraction layer to networking by connecting the Kubernetes nodes to the virtual overlay network. It also provides inbound and outbound connectivity for pods through the *kube-proxy* component.

This architecture uses a virtual overlay network that allocates IP addresses by using static IP address networking. This architecture uses [Calico][] as the container network interface provider. Static IP address networking requires predefined address pools for all the objects in the deployment. It adds extra benefits and guarantees that the workload and application are always reachable. A separate IP address pool is used to allocate IP addresses to Kubernetes services.

The network specifications are defined as [logical networks][] in Azure Local. Before you create the logical networks in Azure Local, see [network requirements][] and [IP address planning][].

### Storage requirements

For every server in the cluster, use the same types of drives that are the same size and model. Azure Local works with direct-attached serial advanced technology attachment, serial attached small computer system interface, nonvolatile memory express, or persistent memory drives that are physically attached to one server each. For cluster volumes, HCI uses software-defined storage technology like Storage Spaces Direct to combine the physical drives in the storage pool for fault tolerance, scalability, and performance. Applications that run in AKS on Azure Local often expect the following storage options to be available:

- **Volumes** represent a way to store, retrieve, and persist data across pods and through the application life cycle.

- **Persistent volumes** are a storage resource that the Kubernetes API creates and manages. They can exist beyond the lifetime of an individual pod.

Consider defining storage classes for different tiers and locations to optimize cost and performance. The storage classes support dynamic provisioning of persistent volumes and define the *reclaimPolicy* to specify the action of the underlying storage resource for managing persistent volumes when the pod is deleted.

### Create and manage AKS on Azure Local

You should create and manage AKS on Azure Local like any other Azure resource that you manage. You can use the [Azure portal](/azure/aks/aksarc/aks-create-clusters-portal), [Azure CLI](/azure/aks/aksarc/aks-create-clusters-cli), [Azure Resource Manager templates (ARM templates)](/azure/aks/aksarc/resource-manager-quickstart), or [Bicep](/azure/aks/aksarc/create-clusters-bicep).

The [Azure Arc-enabled Kubernetes service][] provides Resource Manager representation of AKS on an Azure Local instance. When you create an AKS on Azure Local cluster, Azure Arc agents are automatically deployed in a Kubernetes namespace to collect logs and metrics and gather cluster metadata, Kubernetes version, and node count.

## Recommended services and extensions

The following recommendations apply for most scenarios. Follow the recommendations unless you have a specific requirement that overrides them. The following Azure services must be deployed in the same Azure region as the AKS cluster:

- **Use the [MetalLB extension][]** to deploy a MetalLB load balancer on the AKS cluster for L2 load balancing.

- **Enable [Azure Monitor Container Insights][]** to monitor the performance of container workloads that run on both Linux and Windows node pools. It collects memory and processor metrics from controllers, nodes, and containers via the Metric API. By using Container Insights, you can identify memory and processor usage, detect overall Kubernetes cluster performance, understand cluster behavior, and configure alerts for proactive monitoring.

- **Use available [Automation capabilities][]** for end-to-end management. AKS provides a wide range of automation features, including OS updates and full-stack updates such as firmware and drivers from Azure Local vendors and partners. You can run Windows PowerShell locally from one of the Azure Local machines or remotely from a management computer. Integration with [Azure Automation][] and Azure Arc supports various automation scenarios for [virtualized][] and [containerized][] workloads.

- **Apply governance with [Azure Policy][]** to enforce resource controls at scale. Azure Policy extends Gatekeeper v3, which is an admission controller webhook for Open Policy Agent, to centrally enforce safeguards on AKS components such as pods, containers, and namespaces.

- **Deploy applications consistently by using [Flux v2 configurations and Azure Policy for Kubernetes][]** to achieve scalable, policy-driven deployments. You can select a built-in policy definition and create policy assignments that have specific parameters for Flux setup. To support separation of concerns, create multiple assignments that have different Flux configurations that point to separate sources, such as one Git repository for cluster administrators and another repository for application teams.
  
## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Implement three to five control plane nodes and multiple worker nodes in the Kubernetes cluster to meet the minimum availability requirements for applications.

- Review requirements for failover clustering. AKS deployments use failover clustering and live migration for high availability and fault tolerance. Live migration is a Hyper-V feature that allows you to transparently move running VMs from one Hyper-V host to another host without perceived downtime.

- Configure deployments to use Kubernetes features, such as deployments, affinity mapping, and ReplicaSets, to ensure that the pods are resilient in disruption scenarios.

- Limit usage of public container images and only pull from container registries for which you have control over the service-level agreement, such as Azure Container Registry.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Focus on the entire stack by securing both the host and its containers.

#### Infrastructure security

- Use Azure Local certified hardware that provides Secure Boot, UEFI, and TPM settings out of the box. These technologies, combined with [virtualization-based security][], help protect security-sensitive workloads. For more information about validated solutions, see [Azure Local solutions][].

- Use Secure Boot to ensure that the server only boots software that an original equipment manufacturer trusts.

- Use UEFI to control the booting process of the server.

- Use TPM to store cryptographic keys and to isolate all hardware-based, security-related functions.

- Use BitLocker Drive Encryption to encrypt Storage Spaces Direct volumes at rest.

- Use Defender for Cloud to manage security settings for servers and clusters. It provides threat protection for your Azure Arc-enabled Kubernetes clusters. The Defender for Cloud extension collects data from nodes in the cluster and sends it to the Azure Defender for Kubernetes back end in the cloud for further analysis.

- Use [Azure role-based access control (Azure RBAC)][] for role assignments and to manage access to the AKS cluster.

- Use [workload identity][] for securing and managing identities to access Azure resources from workload pods.

- AKS comes with encryption of etcd secrets by using a key management service (KMS) plugin. All AKS clusters have a built-in KMS plugin enabled by default. This plugin generates the encryption key and automatically rotates it every 30 days.

#### Application security

- Use [Azure Key Vault Secrets provider extension][] on your AKS on Azure Local instance to further protect your secrets that different applications use by storing them in Key Vault.

- Use [Azure Policy for Kubernetes][] to enforce cluster security policies such as no privileged pods.

- Use a Container Registry instance that contains vulnerability scanning in its container repo.

#### Container security

- Harden the host and daemon environment by removing unnecessary services.

- Keep secrets out of the images and mount them only through the container orchestration engine.

- Secure the images in a Container Registry instance that supports vulnerability scanning and [Azure RBAC][].

- [Use isolation of containers][] and avoid running containers in privileged mode to prevent attackers from escalating privileges if a container is compromised.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Use the [Azure pricing calculator][] to estimate costs for Azure services like Azure Monitor Container Insights used in the architecture. The cost optimization section in [Well-Architected Framework][cost optimization] describes other best practices. AKS is available at no extra charge when you use it on Azure Local. For more information, see [Azure Local pricing details](https://azure.microsoft.com/pricing/details/azure-local/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Infrastructure as code:** Use ARM templates, Bicep, or Terraform to automate cluster deployment at scale. Use the Azure portal to explore available and supported options for cluster creation, and export your selections as a template. Review [Azure verified modules][] for a scalable deployment option. For more information, see the [hybrid container service module][] on GitHub.

- **[Azure Arc][]:** Integrate with Azure Arc or Azure services, such as Azure Monitor and Log Analytics, that provide extra management, maintenance, and resiliency capabilities.

- **GitOps:** Instead of manually configuring Kubernetes components, use automated tooling to apply configurations to a Kubernetes cluster because these configurations are checked into a source repository. This process is often known as *GitOps*. Common GitOps solutions for Kubernetes include Flux and Argo CD. In this architecture, we recommend that you use the Microsoft-provided GitOps extension, which is based on Flux.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Use Azure Local-certified hardware for improved application uptime and performance, simplified management and operations, and lower TCO.

- Understand the limits of AKS on Azure Local. Microsoft supports AKS on Azure Local deployments that have a maximum of 16 physical servers per cluster, 32 Kubernetes clusters, and 200 VMs.

- Determine AKS on Azure Local requirements based on the number of control plane nodes, worker nodes, and AKS clusters. To properly size the hardware, anticipate the number of pods, containers, and worker nodes required for each AKS cluster. Reserve at least 15% of Azure Local capacity to accommodate both planned and unplanned failures.

  For performance efficiency, use computing resources in a way that meets system requirements while maintaining that efficiency as demand changes and technologies evolve. As a general rule, if a node goes offline, whether because of maintenance or an unexpected failure, the remaining nodes should have enough capacity to handle the increased load.

- Review AKS node placement logic. AKS on Azure Local distributes the worker nodes for each node pool in an AKS cluster by using Azure Local placement logic through [availability sets][].

- Plan IP address reservations to configure AKS clusters and Kubernetes services.

- Implement network performance optimization for traffic bandwidth allocation.

- Use graphics processing unit acceleration for extensive workloads.

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

## Next step

- [AKS enabled by Azure Arc](/azure/aks/aksarc/aks-overview)

  [Azure Arc resource bridge]: /azure/azure-arc/resource-bridge/overview
  [Automation capabilities]: /azure/automation/automation-hybrid-runbook-worker
  [availability Sets]: /azure/aks/aksarc/availability-sets
  [Azure Arc]: /azure/azure-arc/overview
  [Azure Arc-enabled Kubernetes Service]: /azure/azure-arc/kubernetes/
  [Azure Automation]: /azure/automation/overview
  [Azure Key Vault Secrets provider extension]: /azure/azure-arc/kubernetes/tutorial-akv-secrets-provider
  [AKS on Azure Local]: /azure/aks/aksarc/aks-overview
  [Azure Local solutions]: https://azure.microsoft.com/products/local
  [Azure Local]: /azure/well-architected/service-guides/azure-local
  [Azure Monitor Container Insights]: /azure/azure-monitor/containers/container-insights-overview
  [Azure Monitor]: /azure/azure-monitor/fundamentals/overview
  [Azure Policy for Kubernetes]: /azure/governance/policy/concepts/policy-for-kubernetes
  [Azure Policy]: /azure/governance/policy/overview
  [Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
  [Azure RBAC]: /azure/role-based-access-control/
  [Azure role-based access control (Azure RBAC)]: /azure/aks/aksarc/azure-rbac-23h2
  [Azure verified modules]: /community/content/azure-verified-modules
  [containerized]: /azure/azure-arc/kubernetes/tutorial-use-gitops-flux2
  [cost optimization]: /azure/well-architected/cost-optimization/principles
  [Flux v2 configurations and Azure Policy for Kubernetes]: /azure/azure-arc/kubernetes/use-azure-policy-flux-2
  [hybrid container service module]: https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/hybrid-container-service/provisioned-cluster-instance
  [IP address planning]: /azure/aks/aksarc/aks-hci-ip-address-planning
  [logical networks]: /azure/azure-local/manage/create-logical-networks
  [Defender for Cloud]: /azure/defender-for-cloud/defender-for-cloud-introduction
  [MetalLB extension]: /azure/aks/aksarc/load-balancer-overview
  [network requirements]: /azure/aks/aksarc/aks-hci-network-system-requirements
  [Calico]: /azure/aks/aksarc/concepts-security
  [Use isolation of containers]: /azure/aks/aksarc/container-security#practice-isolation
  [virtualization-based security]: /windows-hardware/design/device-experiences/oem-vbs
  [virtualized]: /azure/azure-arc/servers/manage-vm-extensions
  [workload identity]: /azure/aks/aksarc/workload-identity

## Related resources

- [Deploy apps with AKS enabled by Azure Arc on Azure Local](aks-hybrid-azure-local.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml)
