---
title: Azure Kubernetes Service (AKS) operations triage
titleSuffix: Azure Architecture Center
description: AKS operations to triage issues.
author: kevingbb
ms.date: 10/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice:
---


# Azure Kubernetes Services (AKS) Day 2 Operations Guide

After releasing your Azure Kubernetes Service-hosted application, prepare for _day-2 operations_. The term refers to the ongoing maintainence of the deployed assets and rollout of upgrades. The operations can help you:
- Keep up to date with your service-level agreement (SLA) or Service-level objective (SLO) requirements.
- Troubleshoot customer support requests.
- Stay current with the latest platform features and security updates.
- Plan for future growth. 

## Prerequisites
The best practices for day-2 operations assume that you've deployed the [Azure Kubernetes Service (AKS) Baseline](../../reference-architectures/containers/aks/secure-baseline-aks.yml) architecture as an example of a production cluster. 

## Triage practices

It's often challenging to do root-cause analysis given the different aspects of an AKS cluster. When triaging issues, consider a top-down approach on the cluster hierarchy. Start at the cluster level and drill down if necessary.

![AKS cluster components](./images/kube-components.svg)

In this series, we'll walk you through the thought process of this approach. The articles show examples using a set of tools and dashboards, and how they can highlight some symptoms. 

Common causes addressed in this series include:
- Network and connectivity problems caused by improper configuration.
- Control plane to node communication is broken.
- Kubelet pressures caused by insufficient compute, memory, or storage resources.
- DNS resolution issues.
- Node health is running out of disk IOPS. 
- Admission control pipeline is blocking a large number of requests to the API server.
- The cluster doesn't have permissions to pull from the appropriate container registry.

It’s not intended to resolve specific issues. For information about troubleshooting specific issues,  [AKS Common Issues](/azure/aks/troubleshooting). 

## In this series

|Step|Description|
|---|---|
|[1- Check the AKS cluster health](aks-triage-cluster-health.md)|Start by checking the cluster the health of the overall cluster and networking.|
|[2- Examine the node and pod health](aks-triage-node-health.md) |Check the health of the AKS worker nodes. |
|[3- Check the workload deployments](aks-triage-deployment.md)|Check to see that all deployments and daemonSets are running.|
|[4- Validate the admission controllers](aks-triage-controllers.md)|Check whether the admission controllers are working as expected.|
|[5- Verify the connection to the container registry](aks-triage-container-registry.md)|Verify the connection to the container registry.|


## Related links
[Day-2 operations](https://dzone.com/articles/defining-day-2-operations)

[AKS periscope](https://github.com/Azure/aks-periscope)

[AKS roadmap](https://aka.ms/aks/roadmap)

[AKS documentation](/azure/aks)
