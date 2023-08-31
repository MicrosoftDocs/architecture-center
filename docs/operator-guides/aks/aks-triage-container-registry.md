---
title: AKS triage container registry connectivity
titleSuffix: Azure Architecture Center
description: Learn about verifying the connection to the container registry, as part of a triage step for Azure Kubernetes Service (AKS) clusters.
author: kevingbb
ms.author: architectures
ms.date: 07/28/2022
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

# Verify the connection to the container registry

Make sure that the worker nodes have the right permission to pull the necessary container images from the container registry.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

A common symptom of this issue is receiving **ImagePullBackoff** errors when getting or describing a pod. Be sure that the registry and image name are correct. Also, ensure that the cluster has permissions to pull from the appropriate container registry.

If you are using Azure Container Registry (ACR), the cluster service principal or managed identity should be granted **AcrPull** permissions against the registry.

Attaching a registry to an existing kubernetes cluster automatically assigns AcrPull permissions to the registry. [The AKS to ACR integration](/aks/cluster-container-registry-integration?tabs=azure-cli) assigns the AcrPull role to the Azure Active Directory (Azure AD) managed identity associated with the agent pool in your AKS cluster.

You can retrieve the managed identity of Kubernetes cluster and it's current role assignments as follows.

```azurecli
# Get Kubelet Identity (Nodepool MSI)
ASSIGNEE=$(az aks show -g $RESOURCE_GROUP -n $NAME --query identityProfile.kubeletidentity.clientId -o tsv)
az role assignment list --assignee $ASSIGNEE --all -o table
```

You can create the acrPull role assignment as follows: 

```
az role assignment create --assignee $ASSIGNEE --scope $AZURE_CONTAINER_REGISTRY_ID --role acrpull
```

If you're using a third party container registry, [create the appropriate **ImagePullSecret** credentials](/container-registry/container-registry-auth-kubernetes#create-an-image-pull-secret) for the registry.

## Related links

[Import container images to a container registry](/azure/container-registry/container-registry-import-images)

[AKS Roadmap](https://aka.ms/aks/roadmap)
