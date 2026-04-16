---
title: Choose a Kubernetes at the Edge Compute Option
description: Learn about trade-offs and considerations for various Kubernetes options available for extending compute on the edge.
author: prabhkaur1977
ms.author: prkau
ms.date: 04/10/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-containers
---

# Choose a Kubernetes at the edge compute option

This document discusses the trade-offs for various options available for extending compute on the edge. The following considerations for each Kubernetes option are covered:

- **Operational cost.** The expected labor required to maintain and operate the Kubernetes clusters.

- **Ease of configuration.** The level of difficulty to configure and deploy a Kubernetes cluster.

- **Flexibility.** A measure of how adaptable the Kubernetes option is to integrate a customized configuration with existing infrastructure at the edge.

- **Mixed node.** Ability to run a Kubernetes cluster with both Linux and Windows nodes.

**Assumptions:**

- You're a cluster operator looking to understand different options for running Kubernetes at the edge and managing clusters in Azure.

- You have a good understanding of existing infrastructure and any other infrastructure requirements, including storage and networking requirements.

This article helps you identify which option best fits your scenario and the environment required.

## Kubernetes choices at a glance

|                                 | **Operational cost** | **Ease of configuration** | **Flexibility** | **Mixed node** | **Summary**                                                                                                                               |
|---------------------------------|----------------------|---------------------------|-----------------|----------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| **Bare-metal Kubernetes**       | High\*\*             | Difficult\*\*             | High\*\*        | Yes            | A ground-up configuration on any available infrastructure at location with the option to use Azure Arc for added Azure capabilities |
| **Kubernetes on Azure Stack Edge Pro** | Low                  | Easy                      | Low             | Linux only     | Kubernetes deployed on Azure Stack Edge appliance deployed at location                                                                   |
| **Azure Kubernetes Service (AKS) hybrid**                  | Low                  | Easy                      | Medium          | Yes            | AKS deployed on Azure Local                                                                                   |
| **AKS Edge Essentials**         | Low                  | Easy                      | Medium          | Yes            | Lightweight Kubernetes (K8s/K3s) on PC-class or "light" edge hardware with Azure Arc management |

\*Other managed edge platforms, such as OpenShift and Tanzu, aren't in scope for this document.

\*\*These values are based on using *kubeadm*, for the sake of simplicity. Different options for running bare-metal Kubernetes at the edge alter the rating in these categories.

## Bare-metal Kubernetes

You can configure Kubernetes from the ground up by using tools like [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) on any underlying infrastructure.

The biggest constraints for bare-metal Kubernetes are around the specific needs and requirements of the organization. The opportunity to use any distribution, networking interface, and plugin means higher complexity and operational cost. But this option provides the most flexibility for customizing your cluster.

### Scenario

Often, *edge* locations have specific requirements for running Kubernetes clusters that aren't met with the other Azure solutions described in this document. This option is typically best if you can't use managed services because of unsupported existing infrastructure or if you want maximum control of your clusters.

- This option can be especially difficult if you're new to Kubernetes, which is common for organizations that want to run edge clusters. Options like [MicroK8s](https://microk8s.io/docs) or [k3s](https://k3s.io/) aim to flatten that learning curve.

- It's important to understand any underlying infrastructure and any integration that occurs up front. Then you can narrow down viable options and identify any gaps with the open-source tooling or plugins.

- You can enable clusters by using [Azure Arc](/azure/azure-arc/) as a simple way to manage your cluster from Azure alongside other resources. This approach also provides your cluster with other Azure capabilities, including [Azure Policy](/azure/governance/policy/), [Azure Monitor](/azure/azure-monitor/), [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction), and other services.

- It's especially important to be mindful of continuous integration and continuous deployment (CI/CD) because cluster configuration isn't trivial. You must track and act on upstream changes of various plugins. Ensure that those changes don't affect the health of your cluster. It's important for you to have a strong CI/CD solution, strong testing, and monitoring in place.

### Tooling options

Cluster bootstrap:

- [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm): Kubernetes tool for creating ground-up Kubernetes clusters. Good for standard compute resources, such as Linux or Windows.

- [MicroK8s](https://microk8s.io/docs): Conformant Kubernetes distribution by Canonical that simplifies administration and configuration. It supports a low-operations approach.

- [k3s](https://k3s.io/): Certified Kubernetes distribution built for Internet of Things (IoT) and edge computing.

Storage:

- [Container Storage Interface (CSI) drivers](https://kubernetes-csi.github.io/docs/drivers.html): Many options are available to fit your requirements from cloud to local file shares.

Networking:

- See the [full list of available add-ons](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy). Some popular options include [Flannel](https://github.com/flannel-io/flannel#flannel), a simple overlay network, and [Calico](https://docs.projectcalico.org/), which provides a full networking stack.

### Considerations

Operational cost:

- Without the support that comes with managed services, it's up to the organization to maintain and operate the cluster as a whole, including storage, networking, upgrades, observability, and application management. It has a high operational cost.

Ease of configuration:

- You must evaluate the many open-source options at every stage of configuration, including networking, storage, and monitoring options, which can become complex. This approach requires more consideration for configuring a CI/CD for cluster configuration. Because of these concerns, configuration is more difficult.

Flexibility:

- With the ability to use any open-source tool or plugin without any provider restrictions, bare-metal Kubernetes is highly flexible.

## Kubernetes on Azure Stack Edge

Azure Stack Edge Pro devices deploy a Kubernetes cluster for you, including a primary virtual machine (VM) and a worker VM.

[Azure Stack Edge Pro](/azure/databox-online/) devices deliver Azure capabilities like compute, storage, networking, and hardware-accelerated machine learning to any edge location. Kubernetes clusters can be created after the compute role is enabled on any of the Pro-GPU, Pro-R, and Mini-R devices. Manage upgrades of the Kubernetes cluster by using standard updates available for the device.

### Scenario

This approach is ideal if you have existing (Linux) IoT workloads or you're upgrading your compute for machine learning at the edge. Use this option when you don't need more granular control over clusters.

- Admin permissions aren't granted by default. You can work with the product group to make certain exceptions, but it's difficult to have finer control of your cluster.

- Extra [cost](https://azure.microsoft.com/pricing/details/azure-stack/edge/) applies if you don't have an existing Azure Stack Edge device. Explore [Azure Stack Edge devices](https://azure.microsoft.com/products/azure-stack/edge/#devices), and see if any fit your compute requirements.

- [Calico](https://docs.projectcalico.org/), [MetalLB](https://metallb.org/), and [CoreDNS](https://coredns.io/) are installed for Kubernetes networking on the device.

- Only **Linux** workloads are supported.

- In addition to Kubernetes, Azure Stack Edge also comes with the IoT runtime, which means that workloads might also be deployed to your Azure Stack Edge clusters via Azure IoT Edge.

- Azure Stack Edge Pro GPU 2-node devices now support 2-node HA Kubernetes clusters (master failover).

### Considerations

Operational cost:

- With the support that comes with the device, operational cost is minimal and is scoped to workload management.

Ease of configuration:

- Preconfigured and well-documented Kubernetes cluster deployment simplifies the configuration required compared to bare-metal Kubernetes.

Flexibility:

- Configuration is already set, and Admin permissions aren't granted by default. Product group involvement might be required beyond basic configuration. And the underlying infrastructure must be an Azure Stack Edge Pro device. This option has low flexibility.

## AKS hybrid

AKS hybrid uses predefined settings and configurations to deploy one or more Kubernetes clusters. AKS on Azure Local (23H2+) now uses Azure CLI and Azure portal-based provisioning via Azure Arc.

### Scenario

This approach is ideal if you want a simplified and streamlined way to get a Microsoft-supported cluster on compatible devices, such as Azure Local or Windows Server. Operations and configuration complexity are reduced at the expense of flexibility when compared to the bare-metal Kubernetes option.

Azure Local also extends Azure governance into sovereign environments, enabling Kubernetes-based applications to run within Government, Defense, or regulated industry data boundaries while maintaining Azure-aligned policy and lifecycle control. For more information, see [Azure Local overview](/azure/azure-local/).

### Considerations

Operational cost:

- A Microsoft-supported cluster minimizes operational costs.

Ease of configuration:

- Preconfigured and well-documented Kubernetes cluster deployment simplifies the configuration required compared to bare-metal Kubernetes.

Flexibility:

- The cluster configuration itself is set, but Admin permissions are granted. The underlying infrastructure must either be Azure Local or Windows Server 2019. This option is more flexible than Kubernetes on Azure Stack Edge and less flexible than bare-metal Kubernetes.

## AKS Edge Essentials

[AKS Edge Essentials](/azure/aks/aksarc/aks-edge-overview) is an on-premises Kubernetes implementation of Azure Kubernetes Service (AKS) designed for lightweight, PC-class, or constrained edge hardware. It includes a Microsoft-supported Kubernetes platform with a small footprint and simple installation experience, making it well suited for IoT, retail, and industrial edge scenarios.

AKS Edge Essentials supports both a CNCF-conformant K8s distribution and a lightweight K3s distribution. Each machine in a cluster can run one Linux VM, one Windows VM, or both. Unlike AKS hybrid, AKS Edge Essentials uses static, predefined VM configurations and doesn't support dynamic VM creation or cluster lifecycle management, which keeps the resource overhead low.

### Scenario

This approach is ideal if you need to run Kubernetes on resource-constrained devices such as industrial PCs, point-of-sale terminals, or IoT gateways. Use this option when your hardware doesn't meet the requirements for server-class solutions like AKS hybrid.

- AKS Edge Essentials has minimal compute and memory requirements (4 GB RAM and 2 vCPUs), making it suitable for PC-class or "light" edge hardware.
- It supports both Linux and Windows containers running side-by-side with native Windows applications, enabling interoperability without introducing a separate Linux management plane.
- Clusters can be connected to [Azure Arc](/azure/azure-arc/) for centralized management from the Azure portal, including [Azure Policy](/azure/governance/policy/), [Azure Monitor](/azure/azure-monitor/), and [GitOps](https://learn.microsoft.com/azure/azure-arc/kubernetes/conceptual-gitops-flux2)-based application deployments.
- Installation and cluster creation are performed by using PowerShell cmdlets, supporting both single-machine and multi-machine cluster topologies.
- The Microsoft-managed Linux VM image is based on CBL-Mariner and receives monthly security updates. Kubernetes distribution updates are also managed by Microsoft.

### Considerations

Operational cost:

- Microsoft manages the Kubernetes distribution and VM images, which minimizes the operational burden. Cluster updates and security patches are delivered automatically.

Ease of configuration:

- PowerShell-based installation and preconfigured VM images simplify setup compared to bare-metal Kubernetes. The static configuration model reduces the complexity of cluster management.

Flexibility:

- The static VM allocation model limits dynamic scaling. Customization is possible but constrained compared to bare-metal Kubernetes. The underlying infrastructure must be a Windows 10/11 or Windows Server device. This option is more flexible than Kubernetes on Azure Stack Edge and comparable to AKS hybrid for most edge scenarios.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

 - [Prabhjot Kaur](https://www.linkedin.com/in/prabhkaur1/) | Senior Solution Engineer
 - [Avneesh Kaushik](http://www.linkedin.com/in/avneeshk/) | Principal Partner Solution Architect
 
*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is IoT Edge](/azure/iot-edge/about-iot-edge)
- [Kubernetes on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-kubernetes-overview)
- [Use IoT Edge module to run a Kubernetes stateless application on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-iot-edge-module)
- [Deploy a Kubernetes stateless application via kubectl on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-kubernetes)
- [Use Kubernetes dashboard to monitor your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-monitor-kubernetes-dashboard)

## Related resources

- [Build a CI/CD pipeline for microservices on Kubernetes](../../microservices/ci-cd-kubernetes.yml)
