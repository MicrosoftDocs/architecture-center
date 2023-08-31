---
title: AKS triage - workload deployments
titleSuffix: Azure Architecture Center
description: Check whether workload deployments and daemonSets are running as part of triage practices in an Azure Kubernetes Service (AKS) cluster.
author: kevingbb
ms.date: 10/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories: compute
categories: compute
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---

# Check the workload deployments

Check to see that all deployments and daemonSets are running. Please validate if the **Ready** and the **Available** matches the expected count.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

**Tools:**

- **Azure Portal**. In Azure portal, navigate to the AKS cluster resource. Select **Workloads** from the **Kubernetes Resources** menu.
![AKS - Workloads](images/aks-triage-workloads.png)

- **Kubectl**. Kubectl commands could be used to check the pod / replicaset / daemonset / deployment status.

1. Get deployments in all namespaces 
   ```bash
   kubectl get deploy -A
   ```
2. Get pods in all namespaces
   ```bash
   kubectl get po -A
   ```
3. Get daemonsets in all namespaces
   ```bash
   kubectl get daemonsets -A
   ```
4. If any of the pods or daemonsets are not starting, view the kubernetes events
   ```bash
   kubectl get events
   ```
   or check the events for a specific namespace.
   ```bash
   kubectl get events -n kube-system
   ```
   You can also describe a pod to view the events specific to the pod.
   
   ```bash
   kubectl describe pod <pod-name> -n <namespace>
   ```

- **Prometheus and Grafana Dashboard**. Deployment Status Dashboard. This image is from Grafana Community Chart 10856.
![Prometheus and Grafana Dashboard - Deployment Status](images/deployment-conditions.png)

## Next steps

> [!div class="nextstepaction"]
> [Validate the admission controllers](aks-triage-controllers.md)
