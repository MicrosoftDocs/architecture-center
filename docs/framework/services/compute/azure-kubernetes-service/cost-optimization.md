---
title: Azure Kubernetes Service (AKS) and cost optimization
description: Focuses on the Azure Kubernetes Service (AKS) used in the Compute solution to provide best-practice and configuration recommendations related to service cost.
author: v-stacywray
ms.date: 11/10/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-kubernetes-service
categories:
  - compute
  - management-and-governance
---

# Azure Kubernetes Service (AKS) and cost optimization

[Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance.

To explore how AKS can bolster cost optimization of your application workload, reference architecture guidance and best practices on the [AKS Solution architectures](/azure/architecture/reference-architectures/containers/aks-start-here) page.

The following sections include configuration checklists and recommended configuration options specific to AKS.

## Checklists

**Have you configured Azure Kubernetes Service (AKS) with cost optimization in mind?**
***

> [!div class="checklist"]
> - Use the [Start and Stop feature](/azure/aks/start-stop-cluster?tabs=azure-cli) in Azure Kubernetes Services (AKS).
> - Enforce resource quotas at the namespace level.

### Scalability checklist

> [!div class="checklist"]
> - Assign pod requests and limits on AKS cluster.
> - Define pod distribution budgets (PDB) for workloads.
> - Enable [cluster autoscaler](/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.
> - Consider using [Azure Spot VMs](/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions.
> - Use the [Horizontal pod autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler) to adjust the number of pods in a deployment depending on CPU utilization or other select metrics.
> - Separate workloads into different node pools and consider scaling user node pools to zero.

## AKS configuration recommendation

Explore the following recommendation to optimize your AKS configuration for service cost:

|AKS Recommendation|Description|
|------------------|-----------|
|Use the [Start and Stop feature](/azure/aks/start-stop-cluster?tabs=azure-cli) in Azure Kubernetes Services (AKS).|The AKS Stop and Start cluster feature allows AKS customers to completely pause an AKS cluster, saving time and cost. The stop and start feature keeps cluster configurations in place and customers can pick up where they left off without reconfiguring the clusters.|
|Enforce resource quotas at the namespace level.|Resource quotas provide a way to reserve and limit resources across a development team or project. These quotas are defined on a namespace and can be used to set quotas on Compute resources, Storage resources, and Object counts. When you define resource quotas, all pods created in the namespace must provide limits or requests in their pod specifications. If they don't provide these values, you can reject the deployment.|

### Scalability recommendations

The following table reflects scalability recommendations and descriptions related to the overall AKS configuration recommendations:

|Scalability Recommendations|Description|
|---------------------------|-----------|
|Assign pod requests and limits on AKS cluster.|In your pod specifications, it's best practice to define requests and limits for CPU and memory consumption. If you don't include these values, the Kubernetes scheduler can't take into account the resources your applications require to aid in scheduling decisions. Set pod requests and limits on all pods in your YAML manifests. If the AKS cluster uses resource quotas, your deployment may be rejected if you don't define these values.|
|Define pod distribution budgets (PDB) for workloads.|To maintain the availability of applications, define PDBs to make sure that a minimum number of pods are available in the cluster.|
|Enable [cluster autoscaler](/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.|The ability to automatically scale up or down the number of nodes in your AKS cluster lets you run an efficient, cost-effective cluster.|
|Consider using [Azure Spot VMs](/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions.|For example, workloads such as batch processing jobs, development, and testing environments, and large compute workloads may be good candidates for you to schedule on a spot node pool. Using spot VMs for nodes with your AKS cluster allows you to take advantage of unused capacity in Azure at a significant cost savings.|
|Separate workloads into different node pools and consider scaling user node pools to zero.|Unlike System node pools that always require running nodes, user node pools allow you to scale to `0`.|

## Next step

> [!div class="nextstepaction"]
> [AKS and operational excellence](./operational-excellence.md)