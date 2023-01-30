---
title: Choose a Kubernetes at the edge compute option
titleSuffix: Azure Architecture Center
description: Learn about trade-offs for various options available for extending compute on the edge.
author: martinekuan
ms.author: prkau
ms.date: 11/11/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories: containers
ms.category:
  - containers
products:
  - azure-kubernetes-service
---

# Choose a Kubernetes at the edge compute option

This document discusses the trade-offs for various options available for extending compute on the edge. The following considerations for each Kubernetes option are covered:

- **Operational cost.** The expected labor required to maintain and operate the Kubernetes clusters.

- **Ease of configuration.** The level of difficulty to configure and deploy a Kubernetes cluster.

- **Flexibility.** A measure of how adaptable the Kubernetes option is to integrate a customized configuration with existing infrastructure at the edge.

- **Mixed node.** Ability to run a Kubernetes cluster with both Linux and Windows nodes.

**Assumptions**

- You are a cluster operator looking to understand different options for running Kubernetes at the edge and managing clusters in Azure.

- You have a good understanding of existing infrastructure and any other infrastructure requirements, including storage and networking requirements.

After reading this document, you'll be in a better position to identify which option best fits your scenario and the environment required.

## Kubernetes choices at a glance

|                                 | **Operational cost** | **Ease of configuration** | **Flexibility** | **Mixed node** | **Summary**                                                                                                                               |
|---------------------------------|----------------------|---------------------------|-----------------|----------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| **Bare-metal Kubernetes**       | High\*\*             | Difficult\*\*             | High\*\*        | Yes            | A ground-up configuration on any available infrastructure at location with the option to use Azure Arc for added Azure capabilities. |
| **K8s on Azure Stack Edge Pro** | Low                  | Easy                      | Low             | Linux only     | Kubernetes deployed on Azure Stack Edge appliance deployed at location.                                                                   |
| **AKS hybrid**                  | Low                  | Easy                      | Medium          | Yes            | AKS deployed on Azure Stack HCI or Windows Server 2019.                                                                                   |

\*Other managed edge platforms (OpenShift, Tanzu, and so on) aren't in scope for this document.

\*\*These values are based on using *kubeadm*, for the sake of simplicity. Different options for running bare-metal Kubernetes at the edge would alter the rating in these categories.

## Bare-metal Kubernetes

Ground-up configuration of Kubernetes using tools like [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) on any underlying infrastructure.

The biggest constraints for bare-metal Kubernetes are around the specific needs and requirements of the organization. The opportunity to use any distribution, networking interface, and plugin means higher complexity and operational cost. But this offers the most flexible option for customizing your cluster.

### Scenario

Often, *edge* locations have specific requirements for running Kubernetes clusters that aren't met with the other Azure solutions described in this document. Meaning this option is typically best for those unable to use managed services due to unsupported existing infrastructure, or those who seek to have maximum control of their clusters.

- This option can be especially difficult for those who are new to Kubernetes. This isn't uncommon for organizations looking to run edge clusters. Options like [MicroK8s](https://microk8s.io/docs) or [k3s](https://k3s.io/) aim to flatten that learning curve.

- It's important to understand any underlying infrastructure and any integration that is expected to take place up front. This will help to narrow down viable options and to identify any gaps with the open-source tooling and/or plugins.

- Enabling clusters with [Azure Arc](/azure/azure-arc/) presents a simple way to manage your cluster from Azure alongside other resources. This also brings other Azure capabilities to your cluster, including [Azure Policy](/azure/governance/policy/), [Azure Monitor](/azure/azure-monitor/), [Microsoft Defender for Cloud](/azure/security-center/azure-defender), and other services.

- Because cluster configuration isn't trivial, it's especially important to be mindful of CI/CD. Tracking and acting on upstream changes of various plugins, and making sure those changes don't affect the health of your cluster, becomes a direct responsibility. It's important for you to have a strong CI/CD solution, strong testing, and monitoring in place.

### Tooling options

Cluster bootstrap:

- [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm): Kubernetes tool for creating ground-up Kubernetes clusters. Good for standard compute resources (Linux/Windows).

- [MicroK8s](https://microk8s.io/docs): Simplified administration and configuration ("*LowOps*"), conformant Kubernetes by Canonical.

- [k3s](https://k3s.io/): Certified Kubernetes distribution built for Internet of Things (IoT) and edge computing.

Storage:

- Explore available [CSI drivers](https://kubernetes-csi.github.io/docs/drivers.html): Many options are available to fit your requirements from cloud to local file shares.

Networking:

- A full list of available add-ons can be found here: [Networking add-ons](https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model). Some popular options include [Flannel](https://github.com/coreos/flannel#flannel), a simple overlay network, and [Calico](https://docs.projectcalico.org/), which provides a full networking stack.

### Considerations

Operational cost:

- Without the support that comes with managed services, it's up to the organization to maintain and operate the cluster as a whole (storage, networking, upgrades, observability, application management). The operational cost is considered high.

Ease of configuration:

- Evaluating the many open-source options at every stage of configuration whether its networking, storage, or monitoring options is inevitable and can become complex. Requires more consideration for configuring a CI/CD for cluster configuration. Because of these concerns, the ease of configuration is considered difficult.

Flexibility:

- With the ability to use any open-source tool or plugin without any provider restrictions, bare-metal Kubernetes is highly flexible.

## Kubernetes on Azure Stack Edge

Kubernetes cluster (a master VM and a worker VM) configured and deployed for you on your Azure Stack Edge Pro device.

[Azure Stack Edge Pro](/azure/databox-online/) devices deliver Azure capabilities like compute, storage, networking, and hardware-accelerated machine learning (ML) to any edge location. Kubernetes clusters can be created once the compute role is enabled on any of the Pro-GPU, Pro-R, and Mini-R devices. Managing upgrades of the Kubernetes cluster can be done using standard updates available for the device.

### Scenario

Ideal for those with existing (Linux) IoT workloads or upgrading their compute for ML at the edge. This is a good option when it isn't necessary to have more granular control over the clusters.

- Admin permissions aren't granted by default. Although you can work with the product group to make certain exceptions, this makes it difficult to have finer control of your cluster.

- There is an extra [cost](https://azure.microsoft.com/pricing/details/azure-stack/edge/) if there isn't already an Azure Stack Edge device. Explore [Azure Stack Edge devices](https://azure.microsoft.com/products/azure-stack/edge/#devices) and see if any fit your compute requirements.

- [Calico](https://docs.projectcalico.org/), [MetalLB](https://metallb.org/), and [CoreDNS](https://coredns.io/) are installed for Kubernetes networking on the device.

- Only **Linux** workloads are supported at this time.

- In addition to Kubernetes, Azure Stack Edge also comes with the IoT runtime, which means that workloads may also be deployed to your Azure Stack Edge clusters via IoT Edge.

- Support for two node clusters isn't currently available. This effectively means that this option is *not* a highly available (HA) solution.

### Considerations

Operational cost:

- With the support that comes with the device, operational cost is minimal and is scoped to workload management.

Ease of configuration:

- Pre-configured and well-documented Kubernetes cluster deployment simplifies the configuration required compared to bare-metal Kubernetes.

Flexibility:

- Configuration is already set, and Admin permissions aren't granted by default. Product group involvement may be required beyond basic configuration, and the underlying infrastructure must be an Azure Stack Edge Pro device, making this a less flexible option.

## AKS hybrid

AKS hybrid is a set of predefined settings and configurations that is used to deploy one or more Kubernetes clusters (with Windows Admin Center or PowerShell modules) on a multi-node cluster running either Windows Server or Azure Stack HCI 20H2 or later.

### Scenario

Ideal for those who want a simplified and streamlined way to get a Microsoft-supported cluster on compatible devices (Azure Stack HCI or Windows Server). Operations and configuration complexity are reduced at the expense of the flexibility when compared to the bare-metal Kubernetes option.

### Considerations

Operational cost:

- Microsoft-supported cluster minimizes operational costs.

Ease of configuration:

- Pre-configured and well-documented Kubernetes cluster deployment simplifies the configuration required compared to bare-metal Kubernetes.

Flexibility:

- Cluster configuration itself is set, but Admin permissions are granted. The underlying infrastructure must either be Azure Stack HCI or Windows Server.
    2019. This option is more flexible than Kubernetes on Azure Stack Edge and less flexible than bare-metal Kubernetes.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Prabhjot Kaur](https://www.linkedin.com/in/kaur-profile/) | Principal Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, see the following articles:

- [What is Azure IoT Edge](/azure/iot-edge/about-iot-edge)

- [Kubernetes on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-kubernetes-overview)

- [Use IoT Edge module to run a Kubernetes stateless application on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-iot-edge-module)

- [Deploy a Kubernetes stateless application via kubectl on your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-deploy-stateless-application-kubernetes)

- [Use Kubernetes dashboard to monitor your Azure Stack Edge Pro GPU device](/azure/databox-online/azure-stack-edge-gpu-monitor-kubernetes-dashboard)

## Related resources

- [AI at the edge with Azure Stack Hub](../../solution-ideas/articles/ai-at-the-edge.yml)

- [Building a CI/CD pipeline for microservices on Kubernetes](../../microservices/ci-cd-kubernetes.yml)
