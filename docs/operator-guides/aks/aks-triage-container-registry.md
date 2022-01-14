---
title: AKS triage container registry connectivity
titleSuffix: Azure Architecture Center
description: Learn about verifying the connection to the container registry, as part of a triage step for Azure Kubernetes Service (AKS) clusters.
author: kevingbb
ms.author: pnp
ms.date: 10/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---

# Verify the connection to the container registry

Make sure that the worker nodes have the correct permission to pull the necessary container images from the container registry.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

A common symptom of this issue is receiving **ImagePullBackoff** errors when getting or describing a pod. Be sure that the registry and image name are correct. Also, the cluster has permissions to pull from the appropriate container registry.

If you are using Azure Container Registry (ACR), the cluster service principal or managed identity should be granted **AcrPull** permissions against the registry.

One way is to run this command using the managed identity of the AKS cluster node pool. This command gets a list of its permissions.

```bash
# Get Kubelet Identity (Nodepool MSI)
ASSIGNEE=$(az aks show -g $RESOURCE_GROUP -n $NAME --query identityProfile.kubeletidentity.clientId -o tsv)
az role assignment list --assignee $ASSIGNEE --all -o table

# Expected Output
...
e5615a90-1767-4a4f-83b6-cecfa0675970  AcrPull  /subscriptions/.../providers/Microsoft.ContainerRegistry/registries/akskhacr
...
```

If you're using another container registry, check the appropriate **ImagePullSecret** credentials for the registry.

## Related links

[Import container images to a container registry](/azure/container-registry/container-registry-import-images)

[AKS Roadmap](https://aka.ms/aks/roadmap)
