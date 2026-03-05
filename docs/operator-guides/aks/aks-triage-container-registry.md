---
title: AKS triage—Container registry connectivity
description: Learn about verifying the connection to a container registry. This step is part of the triage practice for Azure Kubernetes Service (AKS) clusters.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
---

# Verify the connection to the container registry

*This article is part of a series. Start with the [overview](aks-triage-practices.md).*

To successfully deploy containerized applications in your Azure Kubernetes Service (AKS) cluster, it's essential to verify the connectivity between the cluster and the container registry. This step guarantees that your worker nodes have the necessary permissions to pull the required container images from the registry.

## Identify symptoms

When the kubelet that runs on an agent node creates the containers for a pod, one or more container might end up in the [waiting state](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-state-waiting) because of the `ImagePullBackOff` error. [ImagePullBackoff](https://kubernetes.io/docs/concepts/containers/images/#imagepullbackoff) is a common error message in Kubernetes that indicates a failure to pull the required container image from a public or private registry. Various factors can cause this error, including network connectivity problems, an incorrect image name or tag, insufficient permissions, or missing credentials.

The `BackOff` part of the status signifies that Kubernetes continuously attempts to pull the image with an increasing delay between each subsequent attempt. The delay gradually increases until it reaches a predetermined limit, which is typically set to 300 seconds (5 minutes) in Kubernetes.

It's important to double-check the registry and image name for accuracy. Additionally, ensure that your AKS cluster has the necessary permissions to pull images from the appropriate container registry.

## Role assignments

When you attach a [container registry](/azure/container-registry/container-registry-intro) to an existing AKS cluster, the [AcrPull role](/azure/container-registry/container-registry-roles) is automatically assigned over the registry to the Microsoft Entra managed identity that's associated with the agent pools in your AKS cluster. For more information, see [Authenticate with Container Registry from AKS](/azure/aks/cluster-container-registry-integration).

Run the following command to retrieve the kubelet managed identity of a Kubernetes cluster and its current role assignments:

```azurecli-interactive
# Get the kubelet managed identity.
ASSIGNEE=$(az aks show -g $RESOURCE_GROUP -n $NAME --query identityProfile.kubeletidentity.clientId -o tsv)
az role assignment list --assignee $ASSIGNEE --all -o table
```

Run the following command to assign the `AcrPull` role to the kubelet managed identity:

```azurecli-interactive
AZURE_CONTAINER_REGISTRY_ID=$(az acr show --name <container-registry-name> --query id --output tsv)
az role assignment create --assignee $ASSIGNEE --scope $AZURE_CONTAINER_REGISTRY_ID --role acrpull
```

## Troubleshoot Container Registry problems

The following sections provide guides that you can refer to if you encounter networking, sign-in, or performance problems with an Azure Container Registry.

### Troubleshoot networking problems

If you encounter problems that are related to accessing an Azure Container Registry in a virtual network or behind a firewall or proxy server, consider the following solutions:

- [Configure client firewall access](/azure/container-registry/container-registry-troubleshoot-access#configure-client-firewall-access).
- [Configure public access to the registry](/azure/container-registry/container-registry-troubleshoot-access#configure-public-access-to-registry).
- [Configure virtual network access](/azure/container-registry/container-registry-troubleshoot-access#configure-vnet-access).
- [Configure access for services](/azure/container-registry/container-registry-troubleshoot-access#configure-service-access).

### Troubleshoot sign-in problems

If you encounter authentication and authorization problems when you sign in to an Azure Container Registry, consider the following solutions:

- [Check the Docker configuration in your environment](/azure/container-registry/container-registry-troubleshoot-login#check-docker-configuration).
- [Specify the correct registry name](/azure/container-registry/container-registry-troubleshoot-login#specify-correct-registry-name).
- [Verify the credentials to access the registry](/azure/container-registry/container-registry-troubleshoot-login#confirm-credentials-to-access-registry).
- [Configure the public access to the registry](/azure/container-registry/container-registry-troubleshoot-access#configure-public-access-to-registry).
- [Troubleshoot registry sign-in problems](/azure/container-registry/container-registry-troubleshoot-login).
- [Check that credentials aren't expired](/azure/container-registry/container-registry-troubleshoot-login#check-that-credentials-arent-expired).

### Troubleshoot performance problems

If you encounter performance issues with an Azure Container Registry, consider the following solutions:

- [Enable the artifact cache](/azure/container-registry/tutorial-artifact-cache).
- [Check the network connection speed](/azure/container-registry/container-registry-troubleshoot-performance#check-expected-network-speed).
- [Inspect client hardware that might affect image layer compression or extraction speed](/azure/container-registry/container-registry-troubleshoot-performance#check-client-hardware).
- [Review configured limits in the registry service tier or environment](/azure/container-registry/container-registry-troubleshoot-performance#review-configured-limits).
- [Configure the geo-replicated registry for optimal performance with replicas in nearby regions](/azure/container-registry/container-registry-troubleshoot-performance#configure-geo-replicated-registry).
- [Optimize DNS configuration for pulling from a geographically distant registry replica](/azure/container-registry/container-registry-troubleshoot-performance#configure-dns-for-geo-replicated-registry).

These guides can help you achieve reliable image retrieval for your AKS cluster and support stable operation of your workloads.

## Integrate a third-party container registry

When you use a third-party container registry, you need to create the appropriate `ImagePullSecret` credentials for the registry so your AKS cluster can securely access the container images. For more information, see [Create an image pull secret](/azure/container-registry/container-registry-auth-kubernetes#create-an-image-pull-secret). Ensure that you set up the correct permissions and credentials so you can verify the connection to the container registry and enable your AKS cluster to successfully pull the required container images during deployments. This best practice helps ensure smooth and reliable execution of your containerized workloads in Kubernetes.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Import container images to a container registry](/azure/container-registry/container-registry-import-images)
- [AKS roadmap](https://aka.ms/aks/roadmap)
  
