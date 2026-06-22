---
title: Choose a Kubernetes at the Edge Compute Option
description: Learn about trade-offs and considerations for various Kubernetes options available for extending compute on the edge.
author: prabhkaur1977
ms.author: prkau
ms.date: 04/28/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-containers
---

# Choose a Kubernetes at the edge compute option

This article compares the key trade-offs across Kubernetes options for extending compute to the edge. Use this comparison to choose the solution that best fits your environment and requirements. The article covers the following considerations for each Kubernetes option.

- **Operational cost:** The expected labor required to maintain and operate the Kubernetes clusters.

- **Ease of configuration:** The level of difficulty involved in configuring and deploying a Kubernetes cluster.

- **Flexibility:** How well the Kubernetes option supports custom configurations and integrates with existing edge infrastructure.

- **Mixed node:** The ability to run a Kubernetes cluster that includes both Linux and Windows nodes.

This article makes the following assumptions.

- You're a cluster operator who wants to evaluate Kubernetes options for edge deployments and manage those clusters in Azure.

- You're familiar with your existing infrastructure and its requirements, including storage and networking.

This article helps you identify which option best fits your scenario and the environment required.

## Kubernetes choices at a glance

|                                 | **Operational cost** | **Ease of configuration** | **Flexibility** | **Mixed node** | **Summary** |
|---------------------------------|----------------------|---------------------------|-----------------|---------------|-------------|
| **Bare-metal Kubernetes**       | High\*               | Difficult\*               | High\*          | Yes            | A ground-up Kubernetes deployment on any infrastructure at a location, with optional Azure Arc integration for added capabilities |
| **Kubernetes on Azure Stack Edge Pro** | Low           | Easy                      | Low             | Linux only     | Kubernetes deployed on an Azure Stack Edge appliance deployed at a location |
| **Azure Kubernetes Service (AKS) hybrid** | Low        | Easy                      | Medium          | Yes            | AKS deployed on Azure Local |
| **AKS Edge Essentials**         | Low                  | Easy                      | Medium          | Yes            | Lightweight Kubernetes on PC-class or *light* edge hardware with Azure Arc management |

\*For the sake of simplicity, these values are based on using *kubeadm*. Different options for running bare-metal Kubernetes at the edge affect the values in these categories.

## Bare-metal Kubernetes

Bare-metal Kubernetes refers to the deployment of a Kubernetes cluster directly on physical servers. This approach bypasses the need for virtualization.

You can configure Kubernetes from the ground up by using tools like [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) on any underlying infrastructure.

The biggest constraints on a bare-metal Kubernetes deployment occur because of your organization's infrastructure requirements. The freedom to choose any distribution, networking interface, and plugin introduces greater complexity and higher operational cost. However, this option provides the most flexibility for customizing your cluster.

### Scenario

Edge locations frequently have specific requirements that the other Azure solutions in this article can't meet. A bare-metal Kubernetes deployment is best if you can't use managed services because of unsupported existing infrastructure or if you want maximum control of your clusters.

- This option can be difficult, especially if you're new to Kubernetes. Lightweight Kubernetes options like [MicroK8s](https://canonical.com/microk8s/docs) and [K3s](https://k3s.io) aim to flatten that learning curve.

- Before you start, thoroughly assess your existing infrastructure and integration points. This upfront evaluation helps you narrow viable options and identify any gaps in open-source tooling or plugin support early in the process.

- You can connect your clusters to [Azure Arc](/azure/azure-arc/) to manage them from Azure alongside your other resources. Azure Arc also unlocks extra Azure capabilities for your cluster, such as [Azure Policy](/azure/governance/policy/), [Azure Monitor](/azure/azure-monitor/), and [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction).

- Cluster configuration is complex and nontrivial, so a robust continuous integration and continuous deployment (CI/CD) strategy is essential. You need to monitor upstream plugin changes, validate that those changes don't affect the health of your cluster, and maintain strong testing throughout the cluster lifecycle.

### Tooling options

**Cluster bootstrap tools:**

- [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm): A Kubernetes tool for creating ground-up Kubernetes clusters. Good for standard compute resources, such as Linux or Windows.

- [MicroK8s](https://canonical.com/microk8s/docs): A conformant Kubernetes distribution that simplifies administration and configuration. It supports a low-operations approach.

- [K3s](https://k3s.io): A certified Kubernetes distribution built for Internet of Things (IoT) and edge computing.

**Storage tools:**

- [Container Storage Interface (CSI) drivers](https://kubernetes-csi.github.io/docs/drivers.html): A wide range of drivers is available to support storage back ends, from cloud-based services to local file shares.

**Networking tools:**

- See the [full list of available add-ons](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy). Some popular options include [Flannel](https://github.com/flannel-io/flannel#flannel), which is a simple overlay network, and [Calico](https://docs.tigera.io), which provides a full networking stack.

### Considerations

**Operational cost:**

- Without a managed service to support the cluster, your organization is fully responsible for storage, networking, upgrades, observability, and application management. This responsibility results in a high operational cost.

**Ease of configuration:**

- Evaluating and selecting open-source options for networking, storage, and monitoring at every configuration stage adds significant complexity. CI/CD for cluster configuration also requires careful planning, which makes bare-metal Kubernetes considerably more difficult to configure than managed alternatives.

**Flexibility:**

- Bare-metal Kubernetes imposes no provider restrictions, so you have unrestricted choice of open-source tools and plugins.

## Kubernetes on Azure Stack Edge Pro

[Azure Stack Edge Pro](/azure/databox-online/) devices automatically deploy a Kubernetes cluster, including a primary virtual machine (VM) and a worker VM.

These devices bring Azure capabilities, such as compute, storage, networking, and hardware-accelerated machine learning, to any edge location. You can create Kubernetes clusters after the compute role is enabled on any of the Pro-GPU, Pro-R, and Mini-R devices. Manage upgrades of the Kubernetes cluster by using standard updates available for the device.

### Scenario

This approach is ideal if you have existing Linux IoT workloads or you're upgrading your compute for machine learning at the edge. Use this option when you don't need more granular control over clusters.

- Admin permissions aren't granted by default. You can work with the product group to make certain exceptions, but it's difficult to have more fine-grained control of your cluster.

- Extra [cost](https://azure.microsoft.com/pricing/details/azure-stack/edge/) applies if you don't have an existing Azure Stack Edge device. Explore [Azure Stack Edge devices](https://azure.microsoft.com/products/azure-stack/edge/#devices) and see if any fit your compute requirements.

- [Calico](https://docs.tigera.io), [MetalLB](https://metallb.org), and [CoreDNS](https://coredns.io) are installed for Kubernetes networking on the device.

- Only Linux workloads are supported.

- In addition to Kubernetes, Azure Stack Edge comes with the IoT runtime. Workloads can be deployed to your Azure Stack Edge clusters via Azure IoT Edge.

- Azure Stack Edge Pro GPU 2-node devices can support 2-node highly available (HA) Kubernetes clusters (master failover).

### Considerations

**Operational cost:**

- The device's built-in support handles cluster operations, which keeps operational cost low and limits your team's focus to workload management.

**Ease of configuration:**

- The Kubernetes cluster deployment comes preconfigured and is backed by thorough documentation. These resources simplify the complexity of the configuration process compared to bare-metal Kubernetes.

**Flexibility:**

- The cluster configuration is already set, and admin permissions aren't granted by default. Any customization beyond basic settings might require product group involvement. Because the underlying infrastructure must be an Azure Stack Edge Pro device, this option has low flexibility.

## AKS hybrid

AKS hybrid uses predefined settings and configurations to deploy one or more Kubernetes clusters. AKS on Azure Local (version 23H2+) uses the Azure CLI and the Azure portal for provisioning through Azure Arc.

### Scenario

This approach is ideal if you want a simplified and streamlined way to get a Microsoft-supported cluster on compatible devices, such as Azure Local. AKS hybrid reduces operations and configuration complexity at the expense of flexibility when compared to the bare-metal Kubernetes option.

Azure Local also extends Azure governance into sovereign environments. Kubernetes-based workloads can operate within Government, Defense, or regulated industry data boundaries while still benefiting from Azure-aligned policy and lifecycle management. For more information, see [Azure Local overview](/azure/azure-local/).

### Considerations

**Operational cost:**

- A Microsoft-supported cluster minimizes operational costs.

**Ease of configuration:**

- The Kubernetes cluster deployment comes preconfigured and is backed by thorough documentation, which simplifies the configuration required compared to bare-metal Kubernetes.

**Flexibility:**

- The cluster configuration is set, but you get admin permissions. The underlying infrastructure must be Azure Local (23H2 or later). This option is more flexible than Kubernetes on Azure Stack Edge and less flexible than bare-metal Kubernetes.

## AKS Edge Essentials

[AKS Edge Essentials](/azure/aks/aksarc/aks-edge-overview) is an on-premises Kubernetes implementation of AKS designed for lightweight, PC-class, or constrained edge hardware. It includes a Microsoft-supported Kubernetes platform that has a small footprint and simple installation experience. This design makes it well suited for IoT, retail, and industrial edge scenarios.

AKS Edge Essentials supports both a Cloud Native Computing Foundation (CNCF)-conformant Kubernetes distribution and a lightweight K3s distribution. Each machine in a cluster can run one Linux VM, one Windows VM, or both. Unlike AKS hybrid, AKS Edge Essentials uses static, predefined VM configurations and doesn't support dynamic VM creation or cluster lifecycle management, which keeps the resource overhead low.

### Scenario

This approach is ideal if you need to run Kubernetes on resource-constrained devices, such as industrial PCs, point-of-sale terminals, or IoT gateways. Use this option when your hardware doesn't meet the requirements for server-class solutions like AKS hybrid.

- AKS Edge Essentials has minimal compute and memory requirements (4 GB RAM and 2 vCPUs), which makes it suitable for PC-class or *light* edge hardware.

- It supports both Linux and Windows containers that run side-by-side with native Windows applications, which provides cross-OS interoperability without introducing a separate Linux management plane.

- You can connect clusters to [Azure Arc](/azure/azure-arc/) for centralized management from the Azure portal, including [Azure Policy](/azure/governance/policy/), [Azure Monitor](/azure/azure-monitor/), and [GitOps](/azure/azure-arc/kubernetes/conceptual-gitops-flux2)-based application deployments.

- PowerShell cmdlets handle both installation and cluster creation, with support for single-machine and multiple-machine topologies.

- The Microsoft-managed Linux VM image is based on [Azure Linux](/azure/azure-linux/azure-linux-aks-overview) and receives monthly security updates. Microsoft also manages Kubernetes distribution updates.

### Considerations

**Operational cost:**

- Microsoft manages the Kubernetes distribution and VM images, which reduces the operational burden. Cluster updates and security patches are delivered automatically.

**Ease of configuration:**

- PowerShell-based installation and preconfigured VM images simplify setup compared to bare-metal Kubernetes deployments. The static configuration model reduces the complexity of cluster management.

**Flexibility:**

- The static VM allocation model limits dynamic scaling. Customization is possible but constrained compared to bare-metal Kubernetes deployments. The underlying infrastructure must be a Windows 10, Windows 11, or Windows Server device. This option is more flexible than Kubernetes on Azure Stack Edge and comparable to AKS hybrid for most edge scenarios.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Prabhjot Kaur](https://www.linkedin.com/in/prabhkaur1/) | Senior Solution Engineer
- [Avneesh Kaushik](https://www.linkedin.com/in/avneeshk/) | Principal Partner Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is IoT Edge](/azure/iot-edge/about-iot-edge)
- [Kubernetes on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-kubernetes-overview)
- [Use IoT Edge module to run a Kubernetes stateless application on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-iot-edge-module)
- [Deploy a Kubernetes stateless application via kubectl on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-kubernetes)
- [Use Kubernetes dashboard to monitor your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-monitor-kubernetes-dashboard)

## Related resource

- [Build a CI/CD pipeline for microservices on Kubernetes](../../microservices/ci-cd-kubernetes.yml)
