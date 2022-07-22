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

Applications that are deployed on virtual nodes can face issues due to some reasons as mentioned below , which can be due to YAML definitions or related Configurations

## Common Issues
1. Virtual Node not available in a certain region
   * If VNET SKUs aren't available for Azure Container Instances in a region, then Virtual Node won't be available
2. Virtual Node  not showing up
   * Need a second subnet in the same VNET, as the virtual nodes need a dedicated subnet to spin up ACI instances as pods

3. Error: _ACIConnectorRequiresAzureNetworking_ -  ACI Connector requires Azure network plugin

    * You must have a CNI enabled cluster & can't work on Kubenet at time of writing

4. Deployment completed however workload gets scheduled on the agent pool node rather than virtual node

    * The below snippet can be used to schedule to virtual node

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

Node-affinity can help in the management of the workload across these options. For more information see [Provide dedicated nodes using taints and tolerations](/azure/aks/operator-best-practices-advanced-scheduler#provide-dedicated-nodes-using-taints-and-tolerations) for more details on how to use node-affinity.

Minimum Troubleshooting Investigation
1. 	Check Region Availability
    * Use virtual nodes - [Azure Kubernetes Service | Microsoft Docs](/azure/aks/virtual-nodes)
2. Check if a second subnet was created
    *	[Create virtual nodes using Azure CLI - Azure Kubernetes Service | Microsoft Docs](/azure/aks/virtual-nodes-cli)
3. Use Azure Monitor
    * [Monitoring Azure Container Instances - Azure Container Instances | Microsoft Docs](/azure/container-instances/monitor-azure-container-instances)
    
    
4. View Logging & Events
    * [Collect & analyze resource logs - Azure Container Instances | Microsoft Docs](/azure/container-instances/container-instances-log-analytics)
        * Logs & Events can be viewed through Log-Analytics , Examples below
    
          For Logs 

            ```kusto
            ContainerInstanceLog_CL | where (TimeGenerated > ago(1h))
            ```
          For Events 

            ```kusto
            ContainerEvent_CL | where (TimeGenerated > ago(1h))
            ```
