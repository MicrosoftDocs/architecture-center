---
title: Kubernetes Service (AKS) operations triage
titleSuffix: Azure Architecture Center
description: Examine a short overview of triage practices for Azure Kubernetes Service (AKS) operations. View links to get more details about different triage practices.
author: kevingbb
ms.date: 10/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---

# Triage practices

It's often challenging to do root-cause analysis given the different aspects of an AKS cluster. When triaging issues, consider a top-down approach on the cluster hierarchy. Start at the cluster level and drill down if necessary.

![AKS cluster components](./images/kube-components.svg)

In the triage practices series, we'll walk you through the thought process of this approach. The articles show examples using a set of tools and dashboards, and how they can highlight some symptoms.

Common causes addressed in this series include:

- Network and connectivity problems caused by improper configuration.
- Control plane to node communication is broken.
- Kubelet pressures caused by insufficient compute, memory, or storage resources.
- DNS resolution issues.
- Node health is running out of disk IOPS.
- Admission control pipeline is blocking a large number of requests to the API server.
- The cluster doesn't have permissions to pull from the appropriate container registry.

This series isn't intended to resolve specific issues. For information about troubleshooting specific issues, see [AKS Common Issues](/azure/aks/troubleshooting).

## In the triage practices series

|Step|Description|
|---|---|
|[1- Check the AKS cluster health](aks-triage-cluster-health.md)|Start by checking the cluster the health of the overall cluster and networking.|
|[2- Examine the node and pod health](aks-triage-node-health.md) |Check the health of the AKS worker nodes. |
|[3- Check the workload deployments](aks-triage-deployment.md)|Check to see that all deployments and daemonSets are running.|
|[4- Validate the admission controllers](aks-triage-controllers.md)|Check whether the admission controllers are working as expected.|
|[5- Verify the connection to the container registry](aks-triage-container-registry.md)|Verify the connection to the container registry.|

## Related links

- [Day-2 operations](https://dzone.com/articles/defining-day-2-operations)
- [AKS periscope](https://github.com/Azure/aks-periscope)
- [AKS roadmap](https://aka.ms/aks/roadmap)
- [AKS documentation](/azure/aks)
