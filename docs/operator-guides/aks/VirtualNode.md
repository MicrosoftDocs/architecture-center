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

## General Issues & relative Guidance

<br/>

1. If you're deploying virtual nodes on AKS where Virtual Node isn't available, it's because
   * VNET SKUs aren't available for Azure Container Instances in the region, please verify region availability from [Region Availability](/azure/aks/virtual-nodes)

<br/>

2. Sometimes during the installation phase you can notice that Virtual Node is not available in AKS cluster even after enabling the virtual node option through portal or through Addons
   * ACI uses a separate subnet for deploying workloads & because the virtual nodes need a dedicated subnet to spin up ACI instances (as pods) , please verify if a second subnet was created & that shouldn't overlap with Cluster subnet range -   [Create virtual nodes using Azure CLI - Azure Kubernetes Service | Microsoft Docs](/azure/aks/virtual-nodes-cli)
   
   * Virtual Nodes utilize Azure CNI for getting IP's on demand from the subnet that is allocated to them, so a cluster identity used by the AKS cluster must have at least Network Contributor permissions on the subnet within your virtual network. If you wish to define a custom role instead of using the built-in Network Contributor role, the following permissions are required - [Prerequisites for Azure CNI](/azure/aks/configure-azure-cni#prerequisites)
        * Microsoft.Network/virtualNetworks/subnets/join/action
        * Microsoft.Network/virtualNetworks/subnets/read
    * To monitor Virtual nodes Pods, refer [Collect & analyze resource logs - Azure Container Instances | Microsoft Docs](/azure/container-instances/container-instances-log-analytics)

  
<br/>


3. There could be scenarios where the installation of Virtual node on Kubenet enabled AKS clusters can face some issues like below & then how can you fix that up

    **Error** 

    You might see error that look like these:

    ```output
    ACIConnectorRequiresAzureNetworking -  ACI Connector requires Azure network plugin
    ```
    **Solution**

    You must have a CNI enabled cluster & can't work on Kubenet at time of writing


    **Reference Link** : [Known limitations](/azure/aks/virtual-nodes#known-limitations)
* Container Insights can also help in providing further insights for the pods & containers workloads on Virtual Nodes query the Logs, For more information refer [Collect & analyze resource logs - Azure Container Instances | Microsoft Docs](/azure/azure-monitor/containers/container-insights-log-query)

        

<br/>

4. Scenarios where deployment gets completed however workload gets scheduled on the agent pool node rather than virtual node

     The below snippet can be used to schedule to virtual node

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

<br/>



## Next steps

Configure virtual nodes for your clusters:

* [Create virtual nodes using Azure CLI](/azure/aks/virtual-nodes-cli)
* [Create virtual nodes using the portal in Azure Kubernetes Services (AKS)](/azure/aks/virtual-nodes-portal)

Virtual nodes are often one component of a scaling solution in AKS. For more information on scaling solutions, see the following articles:

* [Understand Kubernetes horizontal pod autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler)
* [Understand Kubernetes cluster autoscaler](/azure/aks/concepts-scale#cluster-autoscaler)
* [Check out the Autoscale sample for Virtual Nodes](https://github.com/Azure-Samples/virtual-node-autoscale)
* [Read more about the Virtual Kubelet open source library](https://github.com/virtual-kubelet/virtual-kubelet)
