---
title: Common Issues for Virtual Nodes
categories: Azure Architecture Center 
titleSuffix: Azure Architecture Center
description: Learn to know overall Common Issues in Virtual Nodes deployed for AKS, as part of a triage step for AKS clusters.
author: shubhammicrosoft1
ms.author: shagnih
ms.date: 07/19/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---
# Analyzing Virtual Nodes Issues deployed to AKS Cluster

Installation of Virtual Nodes or workload deployment on them can have some challenges & therefore this document is created for Administrators to know the most common issues & how the relative guidance is helpful


## Unable to Provision Virtual Node in a Region
### Resolution: Look for other possible locations where VNET SKUs are available for Azure container Instances

If you're trying to deploy Virtual Node in a region that does not have VNET SKUs for Azure Container Instances,  it's recommended to verify region availability from [Region Availability](/azure/aks/virtual-nodes) & then selecting appropriate region


## Virtual Node not available even after enabling the option
### Resolution: Provision of Separate Subnet & Network Contributor Role on subnet within virtual network

Sometimes during the installation phase you can notice that Virtual Node is not available in AKS cluster even after enabling the virtual node option through portal or through Addons
   * ACI uses a separate subnet for deploying workloads & because the virtual nodes need a dedicated subnet to spin up ACI instances (as pods) , please verify if a second subnet was created & that shouldn't overlap with Cluster subnet range -  [Create virtual nodes using Azure CLI - Azure Kubernetes Service | Microsoft Docs](/azure/aks/virtual-nodes-cli)
   
   * Virtual Nodes utilize Azure CNI for getting IPs on demand from the subnet that is allocated to them, so a cluster identity used by the AKS cluster must have at least Network Contributor permissions on the subnet within your virtual network. If you wish to define a custom role instead of using the built-in Network Contributor role, the following permissions are required - [Prerequisites for Azure CNI](/azure/aks/configure-azure-cni#prerequisites)
        * Microsoft.Network/virtualNetworks/subnets/join/action
        * Microsoft.Network/virtualNetworks/subnets/read

* For more detailed logs & monitoring Virtual nodes Pods, refer [Collect & analyze resource logs - Azure Container Instances | Microsoft Docs](/azure/container-instances/container-instances-log-analytics)

## Installation Error: Unable to Deploy ACI on a Kubenet enabled cluster
### Resolution: You must have a CNI enabled cluster & can't work on Kubenet at time of writing

During the installation of the Virtual nodes through [Azure CLI](/azure/aks/virtual-nodes-cli) , you can see the below error 

```output
ACIConnectorRequiresAzureNetworking -  ACI Connector requires Azure network plugin
```
Virtual Nodes cannot run on Kubenet enabled clusters.

* Please refer this link for [Known limitations](/azure/aks/virtual-nodes#known-limitations)

* Container Insights can also help in providing further insights for the pods & containers workloads on Virtual Nodes query the Logs, For more information refer [Collect & analyze resource logs - Azure Container Instances | Microsoft Docs](/azure/azure-monitor/containers/container-insights-log-query)

        
## Workload being scheduled on an agent pools' node rather than a virtual node.

### Resolution: Check workload tolerations and node selector

One reason that your workload might not be running on a virtual node is that the workload must be set to tolerate the taint that is automatically added to virtual nodes. 
Other reason could be that the nodeSelector is not configured with the virtual node's metadata

The yaml snippet below contains the configuration for both the tolerations and a compliant nodeSelector designator.

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

**Reference Link**: [Tolerations & NodeSelector](/azure/aks/virtual-nodes-cli#deploy-a-sample-app)

## Next steps

Configure virtual nodes for your clusters:

* [Create virtual nodes using Azure CLI](/azure/aks/virtual-nodes-cli)
* [Create virtual nodes using the portal in Azure Kubernetes Services (AKS)](/azure/aks/virtual-nodes-portal)

Virtual nodes are often one component of a scaling solution in AKS. For more information on scaling solutions, see the following articles:

* [Understand Kubernetes horizontal pod autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler)
* [Understand Kubernetes cluster autoscaler](/azure/aks/concepts-scale#cluster-autoscaler)
* [Check out the Autoscale sample for Virtual Nodes](https://github.com/Azure-Samples/virtual-node-autoscale)
* [Read more about the Virtual Kubelet open source library](https://github.com/virtual-kubelet/virtual-kubelet)
