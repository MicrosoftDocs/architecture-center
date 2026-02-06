---
title: Choose a Kubernetes at the Edge Compute Option
description: Learn about trade-offs and considerations for various Kubernetes options available for extending compute on the edge.
author: prabhkaur1977
ms.author: prkau
ms.date: 06/07/2024
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
| **Azure Kubernetes Service (AKS) hybrid**                  | Low                  | Easy                      | Medium          | Yes            | AKS deployed on Azure Local or Windows Server 2019                                                                                   |

\*Other managed edge platforms, such as OpenShift and Tanzu, aren't in scope for this document.

\*\*These values are based on using *kubeadm*, for the sake of simplicity. Different options for running bare-metal Kubernetes at the edge alter the rating in these categories.

## Bare-metal Kubernetes

You can configure Kubernetes from the ground up by using tools like [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) on any underlying infrastructure.

The biggest constraints for bare-metal Kubernetes are around the specific needs and requirements of the organization. The opportunity to use any distribution, networking interface, and plugin means higher complexity and operational cost. But this option provides the most flexibility for customizing your cluster.

### Scenario

Often, *edge* locations have specific requirements for running Kubernetes clusters that aren't met with the other Azure solutions described in this document. This option is typically best if you can't use managed services because of unsupported existing infrastructure or if you want maximum control of your clusters.

- This option can be especially difficult if you're new to Kubernetes, which is common for organizations that want to run edge clusters. Options like [MicroK8s](https://microk8s.io/docs) or [k3s](https://k3s.io/) aim to flatten that learning curve.

- It's important to understand any underlying infrastructure and any integration that occurs up front. Then you can narrow down viable options and identify any gaps with the open-source tooling or plugins.

- You can enable clusters by using [Azure Arc](/azure/azure-arc/) as a simple way to manage your cluster from Azure alongside other resources. This approach also provides your cluster with other Azure capabilities, including [Azure Policy](/azure/governance/policy/), [Azure Monitor](/azure/azure-monitor/), [Microsoft Defender for Cloud](/azure/security-center/azure-defender), and other services.

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

- Support for two node clusters isn't available. Therefore, this option isn't a highly available solution.

### Considerations

Operational cost:

- With the support that comes with the device, operational cost is minimal and is scoped to workload management.

Ease of configuration:

- Preconfigured and well-documented Kubernetes cluster deployment simplifies the configuration required compared to bare-metal Kubernetes.

Flexibility:

- Configuration is already set, and Admin permissions aren't granted by default. Product group involvement might be required beyond basic configuration. And the underlying infrastructure must be an Azure Stack Edge Pro device. This option has low flexibility.

## AKS hybrid

AKS hybrid uses predefined settings and configurations to deploy one or more Kubernetes clusters. You can deploy these clusters by using Windows Admin Center or PowerShell modules on a multiple-node cluster that runs Windows Server.

### Scenario

This approach is ideal if you want a simplified and streamlined way to get a Microsoft-supported cluster on compatible devices, such as Azure Local or Windows Server. Operations and configuration complexity are reduced at the expense of flexibility when compared to the bare-metal Kubernetes option.

### Considerations

Operational cost:

- A Microsoft-supported cluster minimizes operational costs.

Ease of configuration:

- Preconfigured and well-documented Kubernetes cluster deployment simplifies the configuration required compared to bare-metal Kubernetes.

Flexibility:

- The cluster configuration itself is set, but Admin permissions are granted. The underlying infrastructure must either be Azure Local or Windows Server 2019. This option is more flexible than Kubernetes on Azure Stack Edge and less flexible than bare-metal Kubernetes.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

 - [Prabhjot Kaur](https://www.linkedin.com/in/kaur-profile/) | Principal Cloud Solution Architect
 
*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is IoT Edge](/azure/iot-edge/about-iot-edge)
- [Kubernetes on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-kubernetes-overview)
- [Use IoT Edge module to run a Kubernetes stateless application on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-iot-edge-module)
- [Deploy a Kubernetes stateless application via kubectl on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-kubernetes)
- [Use Kubernetes dashboard to monitor your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-monitor-kubernetes-dashboard)

## Related resources

- [Build a CI/CD pipeline for microservices on Kubernetes](../../microservices/ci-cd-kubernetes.yml)
