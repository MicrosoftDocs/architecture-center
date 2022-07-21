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
# Analysing Virtual Nodes Issues deployed to AKS Cluster

Applications deployed to a virtual node or configuration / availability of a Virtual Node service can face issues due to various reasons and in most cases Infrastructure deployment issues or config in Application deployment YAML can cause these issues. 

## Common Issues
1. Virtual Node not available in a certain region
   * If VNET SKUs are not available for Azure Container Instances in a region, then Virtual Node will not be available
2. Virtual Node  not showing up
   * Need a second subnet in the same VNET as the virtual nodes

3. Daemon loses connection with control plane
   * The easiest way to fix this is to trigger any nodepool activity, such as a scale up or scale down (one node is enough) or a nodepool upgrade (if available). This should bring your nodepool back to the ready state.

**Note** If you have autoscaling enabled and you try to do a scale up/down operation using the CLI, you need to deactivate the autoscaling first and then do the scale up/down. You can restart the autoscaling after the process is complete.

4. (ACIConnectorRequiresAzureNetworking) ACI Connector requires Azure network plugin

    * You must have a CNI enabled cluster & can't work on Kubenet at time of writing

5. Deployment completed however workload gets scheduled on the agentpool node rather than virtual node

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

Node-affinity can help in the management of the workload across these options. See [Provide dedicated nodes using taints and tolerations](/azure/aks/operator-best-practices-advanced-scheduler#provide-dedicated-nodes-using-taints-and-tolerations) for more details on how to use node-affinity.

Minimum Troubleshooting Investigation
1. 	Check Region Availability
    * Use virtual nodes - [Azure Kubernetes Service | Microsoft Docs](./azure/aks/virtual-nodes.md)
2. Check if a second subnet was created
    *	[Create virtual nodes using Azure CLI - Azure Kubernetes Service | Microsoft Docs](/azure/aks/virtual-nodes-cli.md)
3. Use Azure Monitor
    * [Monitoring Azure Container Instances - Azure Container Instances | Microsoft Docs](/azure/container-instances/monitor-azure-container-instances.md)
4. View Logging & Events
    * [Collect & analyze resource logs - Azure Container Instances | Microsoft Docs](/azure/container-instances/container-instances-log-analytics.md)


## Next steps

This article focused on scaling clusters using Virtual Nodes. For more information about cluster operations in AKS, see the following best practices:

* [Multi-tenancy and cluster isolation][/azure/aks/aks-best-practices-scheduler]
* [Basic Kubernetes scheduler features][/azure/aks/aks-best-practices-scheduler]
* [Authentication and authorization][/azure/aks/aks-best-practices-identity]

<!-- EXTERNAL LINKS -->
[k8s-taints-tolerations]: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
[k8s-node-selector]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
[k8s-affinity]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
[k8s-pod-affinity]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#always-co-located-in-the-same-node

<!-- INTERNAL LINKS -->
[resource-limits]: developer-best-practices-resource-management.md#define-pod-resource-requests-and-limits
[aks-best-practices-cluster-isolation]: /azure/aks/operator-best-practices-cluster-isolation.md
[aks-best-practices-advanced-scheduler]: /azure/aks/operator-best-practices-advanced-scheduler.md
[aks-best-practices-identity]: /azure/aks/operator-best-practices-identity.md
