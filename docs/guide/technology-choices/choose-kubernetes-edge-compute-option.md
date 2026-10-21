---
title: Choose a Kubernetes at the Edge Compute Option
description: Learn about trade-offs and considerations for various Kubernetes options for extending compute on the edge.
author: prabhkaur1977
ms.author: prkau
ms.date: 10/12/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
ms.custom: arb-containers
---

# Choose a Kubernetes at the edge compute option

This article compares the key trade-offs among Kubernetes options for extending compute to the edge. Use this comparison to choose the solution that best fits your environment and requirements. The article covers the following considerations for each Kubernetes option.

- **Operational cost:** The expected labor required to maintain and operate the Kubernetes clusters.

- **Ease of configuration:** The level of difficulty involved in configuring and deploying a Kubernetes cluster.

- **Flexibility:** How well the Kubernetes option supports custom configurations and integrates with existing edge infrastructure.

- **Mixed node:** The ability to run a Kubernetes cluster that includes both Linux and Windows nodes.

This article is intended for the following audience:

- You're a cluster operator who wants to evaluate Kubernetes options for edge deployments and manage those clusters in Azure.

- You're familiar with your existing infrastructure and its requirements, including storage and networking.

This article helps you identify which option best fits your scenario and the environment required.

## Kubernetes choices at a glance

| **Kubernetes option**           | **Operational cost** | **Ease of configuration** | **Flexibility** | **Mixed node** | **Summary** |
|---------------------------------|----------------------|---------------------------|-----------------|---------------|-------------|
| **Azure Kubernetes Service (AKS) on bare metal** (preview) | Low to medium | Easy to medium            | Medium          | No (single-node only in the preview) | Azure-managed Kubernetes directly on supported Azure Linux or Ubuntu hosts, without a hypervisor. |
| **Self-managed bare-metal Kubernetes** | High\*        | Difficult\*               | High\*          | Yes            | A ground-up Kubernetes deployment on any infrastructure, with optional Azure Arc integration for added capabilities. |
| **Kubernetes on Azure Stack Edge Pro** | Low           | Easy                      | Low             | Linux only     | Appliance-based Kubernetes. New devices are restricted to validated partner workloads or large-scale deployments of at least 100 nodes. |
| **AKS hybrid** | Low        | Easy                      | Medium          | Yes            | AKS deployed on Azure Local. |
| **AKS Edge Essentials**         | Low                  | Easy                      | Medium          | Linux workers generally available; Windows workers in prerelease| Kubernetes in fixed-size VMs on supported Windows devices, with optional Azure Arc management. |

\* For the sake of simplicity, these values assume the use of *kubeadm*. Different options for running self-managed bare-metal Kubernetes at the edge affect the values in these categories.

## Choose between these options

- Choose [AKS on bare metal](#aks-on-bare-metal) when workloads must run locally without a virtualization layer and your team wants Azure-managed Kubernetes. Check whether the single-node topology meets your availability requirements.

- Choose [Azure Kubernetes Service Edge Essentials](#aks-edge-essentials) when existing Windows devices must run Linux containers alongside native Windows applications and a fixed allocation of compute resources suits the workload.

- Choose [AKS hybrid on Azure Local](#aks-hybrid) for server-class infrastructure. For regulated workloads, assess connectivity, data residency, and management requirements separately. An on-premises deployment alone doesn't establish compliance.

- Choose [Kubernetes on Azure Stack Edge Pro](#kubernetes-on-azure-stack-edge-pro) for appliance-based Linux workloads when you already have suitable devices or meet the [device procurement criteria](/azure/databox-online/azure-stack-edge-gpu-overview#device-availability-for-customers).

- Choose [self-managed bare-metal Kubernetes](#self-managed-bare-metal-kubernetes) when you need more control over the distribution, networking, or storage than managed options provide, and your team can own cluster operations.

## AKS on bare metal

[AKS on bare metal](/azure/aks-hybrid-edge/bare-metal/aks-bare-metal-overview) runs the Kubernetes control plane and workloads directly on the host, without a hypervisor. It reduces the Kubernetes administration your team owns, but hardware capacity, site networking, and recovery planning remain part of your responsibility.

### When to select AKS on bare metal

Consider this option for edge sites where space or power limits make server-class infrastructure impractical. It also suits existing supported Ubuntu hardware when your team can retain responsibility for the host operating system.

The current single-node topology has no node-level failover. Use another option if the workload must remain available during a host failure.

### Operational cost of AKS on bare metal

- AKS manages the Kubernetes layer. Azure Linux hosts align with the Azure Local platform lifecycle, but your team must maintain and patch the operating system on Ubuntu hosts. In both cases, account for hardware replacement and on-site support. For information about the division of responsibilities, see [Compare Azure Linux and Ubuntu](/azure/aks-hybrid-edge/bare-metal/aks-bare-metal-compare-azure-linux-ubuntu).

- Reserve host capacity for the control plane as well as applications. Removing the hypervisor doesn't remove Kubernetes overhead.

### Configuring AKS on bare metal

- Azure Linux requires validated Azure Local small-form-factor hardware and supports deployment through the Azure portal, Azure Resource Manager templates (ARM templates), or Bicep. Ubuntu supports customer-provided hardware that meets the requirements and uses Azure CLI for deployment.

- Plan outbound access to Azure management, identity, and container registry endpoints. Treat connectivity loss as an operational constraint, not as a fully disconnected deployment model. For more information, see the [Azure Linux requirements](/azure/aks-hybrid-edge/bare-metal/aks-bare-metal-system-requirements) or [Ubuntu requirements](/azure/aks-hybrid-edge/bare-metal/aks-bare-metal-ubuntu-system-requirements).

### Limitations of AKS on bare metal

- Current deployments are limited to East US, single-node clusters, Cilium networking, and patch-version upgrades. These constraints affect regional requirements, availability, and upgrade planning.

- Kubernetes services of type `LoadBalancer` aren't supported. Validate application access by using a supported approach, such as `NodePort`, and ensure that the approach meets the site's networking and security requirements. For more information, see [Deploy an application on AKS on bare metal](/azure/aks-hybrid-edge/bare-metal/aks-bare-metal-deploy-application).

- Azure Local small-form-factor hosts support temporary loss of Azure connectivity for up to 45 days, not air-gapped operation. Azure-dependent management and updates aren't available during outages. Test application behavior when external dependencies can't be reached. The host connectivity allowance isn't an application availability guarantee. For more information, see [Connectivity modes for Azure Local small-form-factor deployments](/azure/azure-local/small-form-factor/connectivity-modes).

> [!NOTE]
> AKS on bare metal is in preview and isn't recommended for production workloads. Support is best effort, and the transition to general availability might require cluster re-creation. Review the [current scope and limitations](/azure/aks-hybrid-edge/bare-metal/aks-bare-metal-preview-limitations) before deployment. For legal terms, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Self-managed bare-metal Kubernetes

*Self-managed bare-metal Kubernetes* refers to the deployment of a Kubernetes cluster directly on physical servers. This approach bypasses the need for virtualization.

You can configure Kubernetes from the ground up by using tools like [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) on any underlying infrastructure.

Your organization's infrastructure requirements create the biggest constraints on a self-managed bare-metal Kubernetes deployment. The freedom to choose any distribution, networking interface, and plugin introduces greater complexity and higher operational cost. However, this option provides the most flexibility for customizing your cluster.

### When to select self-managed bare-metal Kubernetes

Edge locations frequently have specific requirements that the other Azure solutions in this article can't meet. A self-managed bare-metal Kubernetes deployment is best if you can't use managed services because of unsupported existing infrastructure or if you want maximum control of your clusters.

This option can be difficult, especially if you're new to Kubernetes. Lightweight Kubernetes options like [MicroK8s](https://canonical.com/microk8s/docs) and [K3s](https://k3s.io) can help reduce the learning curve.

Before you start, thoroughly assess your existing infrastructure and integration points. This upfront evaluation helps you narrow viable options and identify any gaps in open-source tooling or plugin support early in the process.

You can connect your clusters to [Azure Arc](/azure/azure-arc/) to manage them from Azure alongside your other resources. Azure Arc also unlocks extra Azure capabilities for your cluster, such as [Azure Policy](/azure/governance/policy/), [Azure Monitor](/azure/azure-monitor/), and [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction).

Cluster configuration is complex, so a robust continuous integration and continuous deployment (CI/CD) strategy is essential. You need to monitor upstream plugin changes, validate that those changes don't affect the health of your cluster, and maintain strong testing throughout the cluster lifecycle.

### Tooling options

- [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm): A Kubernetes tool for creating Kubernetes clusters from scratch. It's suitable for standard compute resources, such as Linux or Windows.

- [MicroK8s](https://canonical.com/microk8s/docs): A conformant Kubernetes distribution that simplifies administration and configuration. It supports a low-operations approach.

- [K3s](https://k3s.io): A certified Kubernetes distribution built for Internet of Things (IoT) and edge computing.

- [Container Storage Interface (CSI) drivers](https://kubernetes-csi.github.io/docs/drivers.html): A wide range of drivers to support storage back ends, from cloud-based services to local file shares.

- See the [full list of available network add-ons](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy). Some popular options include [Flannel](https://github.com/flannel-io/flannel#flannel), which is a simple overlay network, and [Calico](https://docs.tigera.io), which provides a full networking stack.

### Operational cost of self-managed bare-metal Kubernetes

Without a managed service to support the cluster, your organization is fully responsible for storage, networking, upgrades, observability, and application management. This responsibility results in a high operational cost.

### Configuring self-managed bare-metal Kubernetes

Evaluating and selecting open-source options for networking, storage, and monitoring at every configuration stage adds significant complexity. CI/CD for cluster configuration also requires careful planning, which makes self-managed bare-metal Kubernetes considerably more difficult to configure than managed alternatives.

### Flexibility of self-managed bare-metal Kubernetes

Self-managed bare-metal Kubernetes imposes no provider restrictions, so you have unrestricted choice of open-source tools and plugins.

## Kubernetes on Azure Stack Edge Pro

[Azure Stack Edge Pro](/azure/databox-online/) devices automatically deploy a Kubernetes cluster, including a primary virtual machine (VM) and a worker VM.

These devices bring Azure capabilities, such as compute, storage, networking, and hardware-accelerated machine learning, to any edge location. You can create Kubernetes clusters after the compute role is enabled on any of the Pro-GPU, Pro-R, and Mini-R devices. Manage upgrades of the Kubernetes cluster by using standard updates available for the device.

### When to select Kubernetes on Azure Stack Edge Pro

Consider this option when existing Azure Stack Edge Pro devices meet your Linux workload requirements and an appliance-managed Kubernetes configuration provides enough control.

Confirm [device availability](/azure/databox-online/azure-stack-edge-gpu-overview#device-availability-for-customers) before selecting the platform. Procurement is restricted to validated partner workloads or large-scale deployments. The hardware-as-a-service offering specifies a minimum of 100 nodes for large-scale deployments. If you don't qualify, evaluate Azure Local or suitable infrastructure managed through Azure Arc.

- [Calico](https://docs.tigera.io), [MetalLB](https://metallb.io), and [CoreDNS](https://coredns.io) are installed for Kubernetes networking on the device.

- Azure Stack Edge comes with the IoT runtime in addition to Kubernetes. Workloads can be deployed to your Azure Stack Edge clusters via Azure IoT Edge.

- Azure Stack Edge Pro GPU 2-node devices can support 2-node highly available (HA) Kubernetes clusters (master failover).

### Operational cost of Kubernetes on Azure Stack Edge Pro

The device's built-in support handles cluster operations, which keeps operational costs low and enables your team to focus on workload management.

Include the [device subscription and shipping costs](https://azure.microsoft.com/pricing/details/azure-stack/edge/) in your assessment.

### Configuring Kubernetes on Azure Stack Edge Pro

The Kubernetes cluster deployment comes preconfigured, which provides an easier configuration process than self-managed bare-metal Kubernetes.

### Limitations of Kubernetes on Azure Stack Edge Pro

- The cluster configuration is already set. Any customization beyond basic settings might require Microsoft product team involvement. Because the underlying infrastructure must be an Azure Stack Edge Pro device, this option has low flexibility.

- Admin permissions aren't granted by default. You can work with the Microsoft product team to request certain exceptions, but it's difficult to have more fine-grained control of your cluster.

- Only Linux workloads are supported.

## AKS hybrid

AKS hybrid uses predefined settings and configurations to deploy one or more Kubernetes clusters. AKS on Azure Local (version 23H2 or later) uses the Azure CLI and the Azure portal for provisioning through Azure Arc.

### When to select AKS hybrid

This approach is ideal if you want a simplified way to get a Microsoft-supported cluster on compatible infrastructure, such as Azure Local. AKS hybrid reduces operations and configuration complexity at the expense of flexibility, as compared to the self-managed bare-metal Kubernetes option.

For regulated workloads, assess connectivity, data residency, and management requirements separately. An on-premises deployment alone doesn't establish compliance. For platform capabilities, see [Azure Local overview](/azure/azure-local/overview).

### Operational cost of AKS hybrid

AKS is included with Azure Local at no extra cost. Include the cost of Azure Local infrastructure and your team's workload operations in the cost assessment.

### Configuring AKS hybrid

The Kubernetes cluster deployment comes preconfigured and is backed by documentation, which makes this option easier to configure than self-managed bare-metal Kubernetes.

### Limitations of AKS hybrid

The cluster configuration is set, but you get admin permissions. The underlying infrastructure must be Azure Local (23H2 or later). This option is more flexible than Kubernetes on Azure Stack Edge and less flexible than self-managed bare-metal Kubernetes.

## AKS Edge Essentials

[AKS Edge Essentials](/azure/aks-hybrid-edge/edge-essentials/aks-edge-overview) runs Kubernetes on VMs on supported Windows devices. Consider it when Linux containers need to share a device with existing Windows applications rather than requiring separate hardware.

### Scenario

Use this option for PC-class edge devices with predictable resource requirements. Size the device for both the existing Windows applications and the Kubernetes VM, including any Azure Arc agents and extensions.

### Operational cost of AKS Edge Essentials

Microsoft supplies the Kubernetes distribution and node images. Your team needs to maintain the Windows host, plan updates, and validate application compatibility.

### Configuring AKS Edge Essentials

PowerShell tooling and predefined VM configurations reduce installation work. Use the [requirements for your intended deployment](/azure/aks-hybrid-edge/edge-essentials/aks-edge-system-requirements): an Azure Arc-connected cluster needs more capacity than a local-only cluster.

### Limitations of AKS Edge Essentials

- Fixed VM resource allocations limit dynamic scaling. Choose a server-class alternative when workload requirements exceed the device's capacity.

- Generally available functionality supports Linux worker nodes. Windows worker nodes and full Kubernetes deployment across multiple machines are prerelease features. Native Windows applications running beside Linux containers don't require Windows Kubernetes worker nodes. For more information, see the [GA feature support matrix](/azure/aks-hybrid-edge/edge-essentials/aks-edge-system-requirements#ga-feature-support-matrix).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Prabhjot Kaur](https://www.linkedin.com/in/prabhkaur1/) | Senior Cloud Solution Architect
- [Avneesh Kaushik](https://www.linkedin.com/in/avneeshk/) | Principal Partner Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is IoT Edge?](/azure/iot-edge/about-iot-edge)
- [Kubernetes on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-kubernetes-overview)
- [Use IoT Edge module to run a Kubernetes stateless application on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-iot-edge-module)
- [Deploy a Kubernetes stateless application via kubectl on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-kubernetes)
- [Use Kubernetes dashboard to monitor your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-monitor-kubernetes-dashboard)
- [Compare Azure Linux and Ubuntu for AKS on bare metal](/azure/aks-hybrid-edge/bare-metal/aks-bare-metal-compare-azure-linux-ubuntu)
- [AKS on bare metal scope and limitations](/azure/aks-hybrid-edge/bare-metal/aks-bare-metal-preview-limitations)
- [AKS Edge Essentials system requirements](/azure/aks-hybrid-edge/edge-essentials/aks-edge-system-requirements)

## Related resources

- [Build a CI/CD pipeline for microservices on Kubernetes](../../microservices/ci-cd-kubernetes.md)
