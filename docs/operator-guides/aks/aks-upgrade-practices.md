---
title: AKS Day-2 - Patch and upgrade guidance
titleSuffix: Azure Architecture Center
description: Learn about day-2 patching and upgrading practices for Azure Kubernetes Service (AKS) worker nodes and Kubernetes (K8S) versions.
author: rishabhsaha
ms.date: 09/16/2022
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
azureCategories: compute
categories: compute
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
  - devx-track-azurecli
---

# Patch and upgrade AKS worker nodes

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes patching and upgrading practices for AKS worker nodes and Kubernetes (K8S) versions.

## Node image upgrades

Microsoft provides patches and new images for image nodes weekly. For AKS Linux nodes, we have two mechanisms to patch the nodes: unattended updates and node image upgrade. **Unattended updates** are automatic, but they don’t account for kernel level patches. You're required to use something like KURED or node image upgrade to reboot the node and complete the cycle. For node image upgrade, we create a patched node every week for customers to use, which would require applying that patched virtual hard disk (VHD). Auto-upgrade with the node image update SKU can automate the process. 

AKS supports upgrading node images by using [az aks nodepool upgrade](/cli/azure/aks/nodepool#az-aks-nodepool-upgrade), so you can keep up with the newest OS and runtime updates. To keep your agent node OS and runtime components patched, consider checking and applying node image upgrades every two weeks, or automating the node image upgrade process. For more information about automating node image upgrades, see [Node upgrade GitHub Actions](/azure/aks/node-upgrade-github-actions).

An updated node image contains up-to-date OS security patches, kernel updates, Kubernetes security updates, newer versions of binaries like `kubelet`, and component version updates listed in the [release notes](https://github.com/Azure/AKS/releases). Node image updates have all relevant and validated security updates and feature updates. Using the node image upgrade method ensures you get only tested kernels and components that are compatible with those kernels.

You can use node image upgrades to streamline upgrades for both Windows and Linux node pools, but the processes differ slightly. Linux might receive daily security updates, but Windows Server nodes update by performing an AKS upgrade that deploys new nodes with the latest base Window Server image and patches.

Use [kubectl describe nodes](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) to check the OS kernel version and the OS image version of the nodes in your cluster:

```kubectl
kubectl describe nodes <NodeName>
```

Example output:

```output
System Info:
  Machine ID:                 12345678-1234-1234-1234-0123456789ab
  System UUID:                abcdefga-abcd-abcd-abcd-abcdefg01234
  Boot ID:                    abcd0123-ab01-01ab-ab01-abcd01234567
  Kernel Version:             4.15.0-1096-azure
  OS Image:                   Ubuntu 16.04.7 LTS
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  docker://19.3.12
  Kubelet Version:            v1.17.9
  Kube-Proxy Version:         v1.17.9
```

Use the Azure CLI [az aks nodepool list](/cli/azure/aks/nodepool#az-aks-nodepool-list) command to check the current node image versions of the nodes in a cluster:

```azurecli
az aks nodepool list \
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --query "[].{Name:name,NodeImageVersion:nodeImageVersion}" --output table
```

Example output:

```output
Name          NodeImageVersion
------------  -------------------------
systempool    AKSUbuntu-1604-2020.09.30
usernodepool  AKSUbuntu-1604-2020.09.30
usernp179     AKSUbuntu-1604-2020.10.28
```

Use [az aks nodepool get-upgrades](/cli/azure/aks/nodepool#az-aks-nodepool-get-upgrades) to find out the latest available node image version:

```azurecli
az aks nodepool get-upgrades \
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --nodepool-name <NodePoolName> --output table
```

Example output:

```output
KubernetesVersion  LatestNodeImageVersion     Name     OsType
-----------------  -------------------------  -------  ------
1.16.13            AKSUbuntu-1604-2020.11.11  default  Linux
```

To upgrade node pools to the latest node image version:

- [Upgrade all nodes in node pools](/azure/aks/node-image-upgrade#upgrade-all-nodes-in-all-node-pools).
- [Upgrade a specific node pool](/azure/aks/node-image-upgrade#upgrade-a-specific-node-pool).
- [Automate node pool upgrades using GitHub Actions](/azure/aks/node-upgrade-github-actions).
- [Automate node pool upgrades using auto-upgrade channels](/azure/aks/upgrade-cluster#set-auto-upgrade-channel).

## Cluster upgrades

The Kubernetes community releases minor K8S versions roughly every three months. The [AKS GitHub release notes page](https://github.com/Azure/AKS/releases) publishes information about new AKS versions and releases, the latest AKS features, behavioral changes, bug fixes, and component updates. You can also subscribe to the [GitHub AKS RSS feed](https://github.com/Azure/AKS/releases.atom).

The window of supported K8S versions on AKS is called "N - 2": (N (latest release) - 2 (minor versions)). It's important to establish a continuous cluster upgrade process to ensure that your AKS clusters don't go out of support. Once a new version becomes available, ideally you should plan an upgrade across all environments before the version becomes the default. This approach provides more control and predictability, and lets you plan upgrades with minimal disruption to existing workloads.

To minimize disruption to existing workloads during an upgrade:

- Set up multiple environments.
- Plan and schedule maintenance windows.
- [Plan your tolerance for disruption](/azure/aks/operator-best-practices-scheduler#plan-for-availability-using-pod-disruption-budgets).
- [Use surge upgrades to control node pool upgrades](/azure/aks/upgrade-cluster#customize-node-surge-upgrade).

To check when your cluster requires an upgrade, use [az aks get-upgrades](/cli/azure/aks#az-aks-get-upgrades) to get a list of available target upgrade versions for your AKS control plane. Determine the target version for your control plane from the results.

```azurecli
az aks get-upgrades \
   --resource-group <ResourceGroupName> --name <AKSClusterName> --output table
```

Example output:

```output
MasterVersion  Upgrades
-------------  ---------------------------------
1.21.14         1.22.6, 1.22.11
```

Check the Kubernetes versions of the nodes in your node pools to determine the node pools that need to be upgraded.

```azurecli
az aks nodepool list \  
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --query "[].{Name:name,k8version:orchestratorVersion}" --output table
```

Example output:

```output
Name          K8version
------------  ------------
systempool    1.21.14
usernodepool  1.21.14
usernp179     1.21.14
```

You can upgrade the control plane first, and then upgrade the individual node pools.

1. Run the [az aks upgrade](/cli/azure/aks#az-aks-upgrade) command with the `--control-plane-only` flag to upgrade only the cluster control plane, and not any of the associated node pools:

   ```azurecli
   az aks upgrade \
      --resource-group <ResourceGroupName> --name <AKSClusterName> \
      --control-plane-only --no-wait \
      --kubernetes-version <KubernetesVersion>
   ```

1. Run [az aks nodepool upgrade](/cli/azure/aks/nodepool#az-aks-nodepool-upgrade) to upgrade node pools to the target version:

   ```azurecli
   az aks nodepool upgrade \
      --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> --name <NodePoolName> \
      --no-wait --kubernetes-version <KubernetesVersion>
   ```

For information about validation rules for cluster upgrades, see [Validation rules for upgrades](/azure/aks/use-multiple-node-pools#validation-rules-for-upgrades).

## Enroll clusters in auto-upgrade release channels

Kubernetes often releases updates, to deliver security updates, fix known issues, and introduce new features. AKS release channels offer you the ability to balance between stability and the feature set of the version deployed in the cluster. When you enroll a new cluster in a release channel, Microsoft automatically manages the version and upgrade cadence for the cluster and its node pools.

To keep clusters up-to-date with the latest AKS and Kubernetes updates, here are some recommended environments and the respective release channels the clusters should be enrolled in:

| Environment                     | Upgrade Channel    | Description                                                                                                                                                                                                                                            |
|---------------------------------|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Production                      | Stable             | For stability and version maturity, use the stable or regular channel for production workloads.                                                                                                                                                        |
| Staging, Testing, Development | Same as production | To ensure your tests are indicative of the version your production will be upgraded to, use the same release channel as production.                                                                                                                    |
| Canary                          | Rapid              | To test the latest Kubernetes releases and to get ahead of the curve by testing new AKS features or APIs, use the rapid channel. You can improve your time to market when the version in rapid is promoted to the channel you're using for production. |
|                                 |                    |                                                                                                                                                                                                                                                        |

## Considerations

The following table describes characteristics of various AKS upgrade and patching scenarios:

|Scenario|User initiated|K8S upgrade|OS kernel upgrade|Node image upgrade|
|--------|--------------|------------------|-----------------|------------------|
|Security patching | No  | No | Yes, following reboot | Yes  |
|Cluster create | Yes  | Maybe | Yes, if an updated node image uses an updated kernel.|Yes, relative to an existing cluster if a new release is available.|
|Control plane K8S upgrade | Yes  | Yes | No  | No  |
|Node pool K8S upgrade | Yes  | Yes | Yes, if an updated node image uses an updated kernel.| Yes, if a new release is available.|
|Node pool scale up | Yes  | No | No  | No  |
|Node image upgrade | Yes  | No | Yes, if an updated node image uses an updated kernel.| Yes  |
|Cluster auto upgrade | No  | Yes | Yes, if an updated node image uses an updated kernel.  | Yes, if a new release is available.  |

- For more information about Linux Automatic Security Updates, see [AutomaticSecurityUpdates](https://help.ubuntu.com/community/AutomaticSecurityUpdates).
- It's possible that an OS security patch applied as part of a node image upgrade will install a later version of the kernel than creating a new cluster.
- You can use the [Agent Pools - Get Upgrade Profile](/rest/api/aks/agentpools/getupgradeprofile) API to determine the latest node image version.
- Node pool scale up uses the model that is currently associated with the virtual machine scale set. OS kernels upgrade when security patches are applied and the nodes reboot.
- For more information on Cluster auto upgrade, see [Automatically upgrade an Azure Kubernetes Service (AKS) cluster](/azure/aks/auto-upgrade-cluster).
- For more information on Node image auto upgrade, see [Azure Kubernetes Service (AKS) node image upgrade](/azure/aks/node-image-upgrade).
- Node pool scale-up uses the model that's associated with the virtual machine scale set at creation. The OS kernels upgrade when the security patches are applied and the nodes reboot.
- Set your cluster to auto upgrade. For more information, see [Set auto-upgrade channel](/azure/aks/upgrade-cluster#set-auto-upgrade-channel).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

[Rishabh Saha](https://www.linkedin.com/in/rishabhsaha/) | Principal Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS product documentation](/azure/aks)
- [AKS Roadmap](https://aka.ms/aks/roadmap)
- [Defining Day-2 Operations](https://dzone.com/articles/defining-day-2-operations)

## Related resources

- [AKS day-2 operations guide](day-2-operations-guide.md)
- [AKS triage practices](aks-triage-practices.md)
- [AKS common issues](/azure/aks/troubleshooting?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
