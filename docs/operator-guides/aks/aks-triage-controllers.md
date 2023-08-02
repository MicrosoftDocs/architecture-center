---
title: AKS triage - admission controllers
titleSuffix: Azure Architecture Center
description: Learn to validate that the admission controllers are working as expected, as part of a triage step for Azure Kubernetes Service (AKS) clusters.
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

# Validate the admission controllers are working as expected

Check whether the admission controllers are working as expected.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

Issues because of admission controllers are an edge case but they should be considered. Here are some examples:

- Mutating and validating webhooks. Be careful when you add mutating and validating webhooks in your cluster. Make sure that they're highly available so that an unhealthy node doesn't cause API server requests to be blocked. AKS Policy, built around OPA Gatekeeper, is an example of this type of webhook. Kyverno is an example of another policy engine that uses such webhooks. If there are problems in the admission control pipeline, it can block a large number of requests to the API server.

- Service meshes. They use admission controllers to automatically inject sidecars for example.

**Tools**
`kubectl`

These commands check if AKS Policy is running in your cluster and how to validate that all of the admission controllers are functioning as expected.

```bash
# Check AKS Policy pods are running.
kubectl get po -n gatekeeper-system

# Sample Output
...
NAME                                     READY   STATUS    RESTARTS   AGE
gatekeeper-audit-65844778cb-rkflg        1/1     Running   0          163m
gatekeeper-controller-78797d4687-4pf6w   1/1     Running   0          163m
gatekeeper-controller-78797d4687-splzh   1/1     Running   0          163m
...
```

If this command doesn't run as expected, it could indicate that an admission controller, API service, or CRD isn't functioning correctly.

```bash
# Check that all API Resources are working correctly.
kubectl api-resources

# Sample Output
...
NAME                                     SHORTNAMES    APIGROUP                       NAMESPACED   KIND
bindings                                                                              true         Binding
componentstatuses                        cs                                           false        ComponentStatus
configmaps                               cm                                           true         ConfigMap
...
```

## Next steps

> [!div class="nextstepaction"]
> [Verify the connection to the container registry](aks-triage-container-registry.md)
