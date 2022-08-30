---
title: Troubleshoot virtual node problems in AKS clusters
categories: Azure Architecture Center 
titleSuffix: Azure Architecture Center
description: Learn to troubleshoot common virtual node problems in AKS clusters.
author: shubhammicrosoft1
ms.author: shagnih
ms.date: 08/30/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---

# Troubleshoot virtual nodes in Azure Kubernetes Service (AKS) clusters

AKS [Virtual node](/azure/aks/virtual-nodes) related problems can occur in new installations, landing workloads on virtual nodes, or when workloads are scaling out to virtual notes. Always check the [AKS troubleshooting](/azure/aks/troubleshooting) guide to see whether your problem is described there. This article describes additional details and considerations and specific problems that might arise.  

## Unable to enable the virtual nodes add-on

There are various limitations defined in the [Known limitations](/azure/aks/virtual-nodes#known-limitations) for virtual nodes that might prevent the add-on from installing.  Below are some common ones.

### AKS cluster networking type mismatch

During the installation of the virtual nodes through [Azure CLI](/azure/aks/virtual-nodes-cli), you may see the below error:

```output
ACIConnectorRequiresAzureNetworking - ACI Connector requires Azure network plugin
```

Virtual Nodes cannot run on Kubenet enabled clusters.  To support virtual nodes in your cluster, you'll need to recreate your cluster using Azure CNI networking.

## Unable to provision virtual nodes

Sometimes problems exist with virtual nodes at runtime, not just install time of the add-on.  The add-on might show installed, but is not fully functional.

### Region availablity

Virtual node availability and SKU choices are based on the underlying Azure Container Instances that are used for virtual nodes. Errors will arise if you attempt to use the virtual node add-on in AKS while the cluster is not located in a region that supports the ACI requirements. If you plan on using virtual nodes, you must ensure your expected cluster deployment conforms to the virtual nodes [Region availability](/azure/aks/virtual-nodes#regional-availability) for virtual nodes.

### Networking

Virtual nodes uses a SKU of Azure Container Instances that requires subnet connectivity.  Virtual nodes use that dedicated subnet to launch ACI instances (as pods), Ensure that the ACI-delegated subnet was created and there are no overlaps with the cluster subnet range.

#### Azure RBAC

As with most operations in AKS that involve attaching nodes to subnets, virtual nodes are no expection.  The cluster's identity must have a base set of permissions over the subnet in which the ACI instances will be joined. This is often provided as the built-in Network Contributor role at the virtual network level, but sometimes permissions are instead handled at the subnet level. The subnet for which the ACI nodes will be joining need either the built-in Network Contributor role or a custom role defined consisting of the following permissions, which are the same for the [Prerequisites for Azure CNI](/azure/aks/configure-azure-cni#prerequisites).
        
  * `Microsoft.Network/virtualNetworks/subnets/join/action`
  * `Microsoft.Network/virtualNetworks/subnets/read`

## Workload placement

AKS uses placement rules to land workloads on suitable nodes in the cluster.  Sometimes workloads are not set up to tollerate being run on virtual nodes and those workloads end up on node pool nodes rather than virtual nodes.

### Check workload tolerations and node selectors

One reason that your workload might not be running on a virtual node is that the workload must be set to [tolerate the taint](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) that is automatically added to virtual nodes. Other reason could be that the [nodeSelector](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) is not configured with the virtual node's metadata.

The yaml snippet below contains the configuration for both the `tolerations` and a compliant `nodeSelector` designator.

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

See [Deploy a sample app](/azure/aks/virtual-nodes-cli#deploy-a-sample-app) for an expanded example.

## Monitoring

Monitoring the health of virtual nodes is a combination of the logs & metrics from underlying Azure Container Instances and also the host AKS cluster. Ensure you [collect & analyze resource logs](/azure/container-instances/container-instances-log-analytics) from Azure Container Instances and also [collect & analyze resource logs](/azure/azure-monitor/containers/container-insights-log-query) with Container Insights for the AKS cluster.

## Next steps

Read more about the [Kubernetes Virtual Kubelet for ACI](https://github.com/virtual-kubelet/azure-aci) from the open source project for additional documentation.

Virtual nodes are often one component of a scaling solution in AKS. For more information on scaling solutions, see the following articles:

* [Understand Kubernetes horizontal pod autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler)
* [Understand Kubernetes cluster autoscaler](/azure/aks/concepts-scale#cluster-autoscaler)
* [Check out the Autoscale sample for Virtual Nodes](https://github.com/Azure-Samples/virtual-node-autoscale)
