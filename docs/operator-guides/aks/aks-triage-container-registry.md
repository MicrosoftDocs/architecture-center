---
title: AKS triage container registry connectivity
titleSuffix: Azure Architecture Center
description: Learn about verifying the connection to the container registry, as part of a triage step for Azure Kubernetes Service (AKS) clusters.
author: kevingbb
ms.author: kevinhar
ms.date: 10/16/2023
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

To ensure a successful deployment of containerized applications in your Azure Kubernetes Service (AKS) cluster, it is essential to verify the connectivity between the cluster and the container registry. This step guarantees that your worker nodes have the necessary permissions to pull the required container images from the registry.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

## Identifying Symptoms

When the `kubelet` running on an agent node starts creating the containers for a Pod, it might be possible for one or more container to end up in [Waiting](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-state-waiting) state because of `ImagePullBackOff`. The [ImagePullBackoff](https://kubernetes.io/docs/concepts/containers/images/#imagepullbackoff) error is a common error message in Kubernetes that indicates a failure to pull the required container image from a public or private registry. This error can be caused by various factors, including network connectivity problems, incorrect image name or tag, insufficient permissions, or missing credentials.

The `BackOff` component of the status signifies that Kubernetes will continue attempting to pull the image, with an increasing delay between each subsequent attempt. The delay gradually increases until it reaches a predetermined limit, which is typically set to 300 seconds (5 minutes) in Kubernetes.

It is crucial to double-check the registry and image name for accuracy. Additionally, ensure that your AKS cluster has the necessary permissions to pull images from the appropriate container registry.

## Azure Container Registry

When you attach an [Azure Container Registry (ACR)](/azure/container-registry/container-registry-intro) to an existing AKS cluster the [AcrPull](/azure/container-registry/container-registry-roles?tabs=azure-cli) role is automatically assigned over the registry to the managed identity associated with the agent pools in your AKS cluster. [The AKS to ACR integration](/azure/aks/cluster-container-registry-integration?tabs=azure-cli) assigns the AcrPull role to the Azure Active Directory (Azure AD) managed identity associated with the agent pool in your AKS cluster.

You can retrieve the kubelet managed identity of Kubernetes cluster and its current role assignments as follows.

```azurecli-interactive
# Get kubelet managed identity
ASSIGNEE=$(az aks show -g $RESOURCE_GROUP -n $NAME --query identityProfile.kubeletidentity.clientId -o tsv)
az role assignment list --assignee $ASSIGNEE --all -o table
```

You can assign the `AcrPull` role to the kubelet managed identity with the following command:

```azurecli-interactive
AZURE_CONTAINER_REGISTRY_ID=$(az acr show --name <acr-name> --query id --output tsv)
az role assignment create --assignee $ASSIGNEE --scope $AZURE_CONTAINER_REGISTRY_ID --role acrpull
```

## Troubleshoot Azure Container Registry Issues

If you encounter networking, login, or performance issues with an Azure Container Registry (ACR), you can follow these troubleshooting guides to address the problems effectively.

### Networking Issues

Troubleshoot problems related to accessing an Azure container registry in a virtual network or behind a firewall or proxy server. The following scenarios and solutions are covered:

- [Configuration of client firewall or proxy preventing access to the registry](/azure/container-registry/container-registry-troubleshoot-access#configure-client-firewall-access).
- [Registry's public network access rules preventing access](/azure/container-registry/container-registry-troubleshoot-access#configure-public-access-to-registry).
- [Configuration issues with virtual network or private endpoint preventing access](/azure/container-registry/container-registry-troubleshoot-access#configure-vnet-access).
- [Integration challenges when using Microsoft Defender for Cloud or specific Azure services with a registry having private endpoint, service endpoint, or public IP access rules](/azure/container-registry/container-registry-troubleshoot-access#configure-service-access).

### Login Issues

Resolve authentication and authorization problems when logging into an Azure container registry. The troubleshooting guide covers the following scenarios:

- [Improper Docker configuration in your environment](/azure/container-registry/container-registry-troubleshoot-login#check-docker-configuration).
- [Missing or incorrect registry name](/azure/container-registry/container-registry-troubleshoot-login#specify-correct-registry-name).
- [Invalid registry credentials](/azure/container-registry/container-registry-troubleshoot-login#confirm-credentials-to-access-registry).
- [Disabled public access or incorrect public network access rules](/azure/container-registry/container-registry-troubleshoot-access#configure-public-access-to-registry).
- [Troubleshoot registry login](/azure/container-registry/container-registry-troubleshoot-login).
- [Expired credentials](/azure/container-registry/container-registry-troubleshoot-login#check-that-credentials-arent-expired).

### Performance Issues

Resolve potential performance issues encountered with an Azure container registry using the following troubleshooting approaches:

- [Enable Artifact Cache](/azure/container-registry/tutorial-artifact-cache)
- [Check network connection speed impacting registry operations](/azure/container-registry/container-registry-troubleshoot-performance#check-expected-network-speed).
- [Inspect client hardware impacting image layer compression or extraction speed](/azure/container-registry/container-registry-troubleshoot-performance#check-client-hardware).
- [Review configured limits in the registry service tier or environment](/azure/container-registry/container-registry-troubleshoot-performance#review-configured-limits).
- [Configure geo-replicated registry for optimal performance with replicas in nearby regions](/azure/container-registry/container-registry-troubleshoot-performance#configure-geo-replicated-registry).
- [Optimize DNS configuration for pulling from a geographically distant registry replica](/azure/container-registry/container-registry-troubleshoot-performance#configure-dns-for-geo-replicated-registry).

By following these troubleshooting guides, you can effectively address networking, login, and performance-related issues with Azure Container Registry. This will enable seamless image retrieval for your AKS cluster and ensure smooth operation of your workloads.

## Third-Party Container Registry Integration

When you are using a third-party container registry, you will need to create the appropriate `ImagePullSecret` credentials for the registry. This enables your AKS cluster to securely access the container images. [Refer to the Azure documentation](/azure/container-registry/container-registry-auth-kubernetes#create-an-image-pull-secret) for detailed instructions on creating an image pull secret for your specific third-party container registry. By ensuring the correct permissions and credentials are set up, you can verify the connection to the container registry and allow your AKS cluster to successfully pull the required container images during deployments. This best practice ensures smooth and reliable execution of your containerized workloads in Kubernetes.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kevin Harris](https://www.linkedin.com/in/kevbhar) | Principal Solution Specialist
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related links

[Import container images to a container registry](/azure/container-registry/container-registry-import-images)

[AKS Roadmap](https://aka.ms/aks/roadmap)
