---
title: Azure Kubernetes Service (AKS) and performance efficiency
description: Focuses on the Azure Kubernetes Service (AKS) used in the Compute solution to provide best-practice and configuration recommendations related to performance efficiency.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-kubernetes-service
categories:
  - compute
  - management-and-governance
---

# Azure Kubernetes Service (AKS) and performance efficiency

[Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance.

To explore how AKS can bolster the performance efficiency of your application workload, reference architecture guidance and best practices on the [AKS Solution architectures](/azure/architecture/reference-architectures/containers/aks-start-here) page.

The following sections include a scalability checklist and recommended configuration options specific to AKS.

## Scalability checklist

**Have you configured Azure Kubernetes Service (AKS) with performance efficiency in mind?**
***

> [!div class="checklist"]
> - Enable [cluster autoscaler](/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.
> - Consider using [Azure Spot VMs](/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions.
> - Use the [Horizontal pod autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler) to adjust the number of pods in a deployment depending on CPU utilization or other select metrics.
> - Separate workloads into different node pools and consider scaling user node pools to zero.

## Scalability recommendations

The following table reflects scalability recommendations and descriptions related to AKS configuration:

|Scalability Recommendations|Description|
|---------------------------|-----------|
|Enable [cluster autoscaler](/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.|The ability to automatically scale up or down the number of nodes in your AKS cluster lets you run an efficient, cost-effective cluster.|
|Consider using [Azure Spot VMs](/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions.|For example, workloads such as batch processing jobs, development, testing environments, and large compute workloads may be good candidates for you to schedule on a spot node pool. Using spot VMs for nodes with your AKS cluster allows you to take advantage of unused capacity in Azure at a significant cost savings.|
|Separate workloads into different node pools and consider scaling user node pools to zero.|Unlike System node pools that always require running nodes, user node pools allow you to scale to `0`.|

## Next step

> [!div class="nextstepaction"]
> [Azure Functions and security](../functions/security.md)
