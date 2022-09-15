---
title: Troubleshoot virtual node problems in AKS clusters
titleSuffix: Azure Architecture Center
description: Learn how to troubleshoot common virtual node problems in Azure Kubernetes Service (AKS) clusters.
author: shubhammicrosoft1
ms.author: shagnih
ms.date: 09/07/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-container-instances
ms.custom:
  - e2e-aks
categories: Azure Architecture Center 
---

# Troubleshoot virtual nodes in Azure Kubernetes Service (AKS) clusters

Problems related to [AKS virtual nodes](/azure/aks/virtual-nodes) can arise from new installations, from landing workloads on virtual nodes, or when workloads scale out to virtual nodes. If you suspect a problem, first check [AKS troubleshooting](/azure/aks/troubleshooting), which describes common problems and solutions.

This article describes other considerations and specific problems that might occur.  

## Virtual nodes add-on installation problems

There are [various known limitations](/azure/aks/virtual-nodes#known-limitations) for virtual nodes that might prevent the add-on from installing. Some common limitations are listed in the following sections.

### AKS cluster networking type mismatch

During the installation of virtual nodes through the [Azure CLI](/azure/aks/virtual-nodes-cli), you might see the following error:

```output
ACIConnectorRequiresAzureNetworking - ACI Connector requires Azure network plugin
```

Virtual nodes can't run on *kubenet*-enabled clusters. To support virtual nodes in your cluster, re-create your cluster using [Azure CNI](/azure/aks/configure-azure-cni) networking.

## Virtual nodes provisioning problems

Problems sometimes exist with virtual nodes at runtime, not just when the add-on is installed. The add-on might appear to be installed, but isn't fully functional.

### Region availability

Virtual node availability and SKU choices are based on the underlying Azure Container Instances that are used for virtual nodes. A SKU represents the virtual machine (VM) size series and type.

Errors arise if you attempt to use the virtual node add-on in AKS while the cluster isn't located in a region that supports Container Instances. If you plan on using virtual nodes, ensure your expected cluster deployment conforms to the [region availability](/azure/aks/virtual-nodes#regional-availability) for virtual nodes.

### Networking

Virtual nodes use a SKU that requires subnet connectivity. Virtual nodes use that dedicated subnet to launch Container Instances as pods. Ensure the subnet that's delegated to Container Instances exists and there are no overlaps with the cluster's subnet range.

#### Azure role-based access control

As with most operations in AKS that involve attaching nodes to subnets, virtual nodes are no exception. The cluster's identity must have a base set of permissions over the subnet in which the Azure Container Instances are joined. These rights are often provided as the built-in Network Contributor role at the virtual network level, but sometimes permissions are instead handled at the subnet level. The subnet that the Container Instances nodes are joining needs either the built-in Network Contributor role assigned or a custom role defined consisting of the following permissions.
        
  * `Microsoft.Network/virtualNetworks/subnets/join/action`
  * `Microsoft.Network/virtualNetworks/subnets/read`

These permissions are the same for the [Azure Container Networking Interface prerequisites](/azure/aks/configure-azure-cni#prerequisites).

## Workload placement

AKS uses placement rules to land workloads on suitable nodes in the cluster. Sometimes workloads aren't set up to tolerate being run on virtual nodes and those workloads end up on node pool nodes rather than virtual nodes.

### Check workload tolerations and node selectors

One reason that your workload might not run on a virtual node is that the workload must be set to [tolerate the taint](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) that's automatically added to virtual nodes. Another reason could be that the [nodeSelector](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) isn't configured with the virtual node's metadata.

The following yaml snippet contains the configuration for both the `tolerations` and a compliant `nodeSelector` designator.

```yaml
nodeSelector:
  kubernetes.io/role: agent
  beta.kubernetes.io/os: linux
  type: virtual-kubelet
tolerations:
- key: virtual-kubelet.io/provider
  operator: Exists
- key: azure.com/aci
  effect: NoSchedule
```

For an expanded example, see [Deploy a sample app](/azure/aks/virtual-nodes-cli#deploy-a-sample-app).

## Monitoring

Monitoring the health of virtual nodes uses a combination of the logs and metrics from underlying Container Instances and also the host AKS cluster. Ensure that you [collect and analyze resource logs](/azure/container-instances/container-instances-log-analytics) from Container Instances and also [collect and analyze resource logs](/azure/azure-monitor/containers/container-insights-log-query) with container insights for the AKS cluster.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Shubham Agnihotri](https://www.linkedin.com/in/shubham-agnihotri8/) | Senior Consultant GD

## Next steps

* [Azure Kubernetes Service application and cluster scalability](/learn/paths/aks-cluster-scalability/)
* [Azure Kubernetes Service cluster architecture and operations](/learn/paths/aks-cluster-architecture/)
* [Kubernetes Virtual Kubelet for Azure Container Instances on GitHub](https://github.com/virtual-kubelet/azure-aci)

Virtual nodes are often one component of a scaling solution in AKS. For more information on scaling solutions, see the following articles:

* [Kubernetes horizontal pod autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler)
* [Kubernetes cluster autoscaler](/azure/aks/concepts-scale#cluster-autoscaler)
* [Autoscale sample for virtual nodes on GitHub](https://github.com/Azure-Samples/virtual-node-autoscale)

## Related resources

* [Baseline architecture for an Azure Kubernetes Service cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
* [Azure Kubernetes Services day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)
