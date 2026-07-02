---
title: AKS Triage—Container Registry Connectivity
description: Learn how to verify the connection to a container registry. This step is part of the triage practice for Azure Kubernetes Service (AKS) clusters.
author: samcogan
ms.author: samcogan
ms.date: 04/28/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
---

# Verify the connection to the container registry

*This article is part of a series. Start with the [overview](aks-triage-practices.md).*

To successfully deploy containerized applications in your Azure Kubernetes Service (AKS) cluster, verify the connectivity between the cluster and the container registry. This step ensures that your worker nodes have the necessary permissions to pull the required container images from the registry.

## Identify symptoms

When the kubelet that runs on an agent node creates the containers for a pod, one or more containers might end up in the [waiting state](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-state-waiting) because of an `ImagePullBackOff` or `ErrImagePull` error.

- [ImagePullBackOff](https://kubernetes.io/docs/concepts/containers/images/#imagepullbackoff) is an error message in Kubernetes that indicates a failure to pull the required container image from a public or private registry. The `BackOff` part of the status signifies that Kubernetes continuously attempts to pull the image, with an increasing delay between each attempt. The delay gradually increases until it reaches a predetermined limit, which is typically set to 300 seconds in Kubernetes.

- `ErrImagePull` often precedes `ImagePullBackOff` and indicates that the initial pull attempt failed.

Various factors can cause these errors, including network connectivity problems, an incorrect image name or tag, insufficient permissions, or missing credentials. Verify the registry URL, image name, and tag, and confirm that the cluster identity has the necessary permissions to pull from the registry.

## Role assignments

When you attach a [container registry](/azure/container-registry/container-registry-intro) to an existing AKS cluster, the [AcrPull role](/azure/container-registry/container-registry-rbac-built-in-roles-overview) is automatically assigned to the Microsoft Entra managed identity that's associated with the agent pools in your cluster. For more information, see [Authenticate with Container Registry from AKS](/azure/aks/cluster-container-registry-integration).

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

### ABAC-enabled registries

If your Container Registry uses Azure attribute-based access control (ABAC) repository permissions, it doesn't honor the classic `AcrPull` role. ABAC-enabled registries also don't support the `az aks create --attach-acr` and `az aks update --attach-acr` integrations. Instead, you must manually assign the `Container Registry Repository Reader` role to the kubelet managed identity. For more information, see [Azure ABAC repository permissions](/azure/container-registry/container-registry-rbac-abac-repository-permissions).

If you recently migrated your registry to ABAC-enabled mode and image pulls fail, verify that the kubelet identity is assigned an ABAC-compatible role.

### Validate connectivity

To check if your AKS cluster can reach the container registry, run the following command:

```azurecli-interactive
az aks check-acr --name $NAME --resource-group $RESOURCE_GROUP --acr <container-registry-name>.azurecr.io
```

This command checks Domain Name System (DNS) resolution, network routing, and authentication between the AKS cluster and the registry. Use it as a first diagnostic step when you suspect connectivity or permission problems.

## Troubleshoot Container Registry problems

Use the following guidance to diagnose networking, sign-in, and performance problems.

### Troubleshoot networking problems

If you encounter problems accessing Container Registry because of virtual network restrictions, firewall rules, or proxy server configurations, consider the following solutions:

- [Configure client firewall access](/azure/container-registry/container-registry-troubleshoot-access#configure-client-firewall-access)
- [Configure public access to the registry](/azure/container-registry/container-registry-troubleshoot-access#configure-public-access-to-registry)
- [Configure virtual network access](/azure/container-registry/container-registry-troubleshoot-access#configure-vnet-access)
- [Configure service access](/azure/container-registry/container-registry-troubleshoot-access#configure-service-access)

### Troubleshoot sign-in problems

If you encounter authentication and authorization problems when you sign in to Container Registry, consider the following solutions:

- [Check the Docker configuration in your environment](/azure/container-registry/container-registry-troubleshoot-login-authn-authz#check-docker-configuration)
- [Specify the correct registry name](/azure/container-registry/container-registry-troubleshoot-login-authn-authz#specify-correct-registry-name)
- [Confirm the credentials to access the registry](/azure/container-registry/container-registry-troubleshoot-login-authn-authz#confirm-credentials-to-access-registry)
- [Configure public access to the registry](/azure/container-registry/container-registry-troubleshoot-access#configure-public-access-to-registry)
- [Troubleshoot registry sign-in problems](/azure/container-registry/container-registry-troubleshoot-login-authn-authz)
- [Check that credentials aren't expired](/azure/container-registry/container-registry-troubleshoot-login-authn-authz#check-that-credentials-arent-expired)

### Troubleshoot performance problems

If you encounter performance problems with a container registry, consider the following solutions:

- [Optimize image pulls with artifact cache](/azure/container-registry/artifact-cache-overview)
- [Check the network connection speed](/azure/container-registry/container-registry-troubleshoot-performance#check-expected-network-speed)
- [Inspect client hardware that might affect image layer compression or extraction speed](/azure/container-registry/container-registry-troubleshoot-performance#check-client-hardware)
- [Review configured limits in the registry service tier or environment](/azure/container-registry/container-registry-troubleshoot-performance#review-configured-limits)
- [Configure the geo-replicated registry for optimal performance with replicas in nearby regions](/azure/container-registry/container-registry-troubleshoot-performance#configure-geo-replicated-registry)
- [Optimize DNS configuration for pulling from a geographically distant registry replica](/azure/container-registry/container-registry-troubleshoot-performance#configure-dns-for-geo-replicated-registry)

If pull latency increases suddenly on a geo-replicated registry without any AKS configuration changes, check [Azure Resource Health](/azure/service-health/resource-health-overview) for the registry. When a regional replica degrades, Container Registry failover automatically reroutes traffic from that replica to a healthy replica through the global endpoint (`<registry>.azurecr.io`). The global endpoint can route AKS nodes to a replica in a more distant region. Pull latency returns to baseline after the local replica recovers.

## Integrate a non-Microsoft container registry

When you use a non-Microsoft container registry, you need to create the appropriate `ImagePullSecret` credentials for the registry so your AKS cluster can securely access the container images. For more information, see [Create an image pull secret](/azure/container-registry/container-registry-auth-kubernetes#create-an-image-pull-secret).

Ensure that you set up the correct permissions and credentials so that you can verify the connection to the container registry and your AKS cluster can successfully pull the required container images during deployments.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

Other contributor:

- [Sam Cogan](https://www.linkedin.com/in/samcogan82/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Import container images to a container registry](/azure/container-registry/container-registry-import-images)
- [AKS roadmap](https://github.com/orgs/Azure/projects/685)
 