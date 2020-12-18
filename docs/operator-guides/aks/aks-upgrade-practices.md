---
title: Azure Kubernetes Service (AKS) Operations Guide - AKS Patching and Upgrading
titleSuffix: Azure Architecture Center
description: A collection of AKS operations guide topics. AKS Patching and Upgrading.
author: rishabhsaha
ms.date: 11/16/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Guidance for Patching and Upgrading Clusters

This section will talk about AKS patching and upgrading practices, and who is responsible for what (shared responsibility). This includes the worker nodes along with Kubernetes versions.

## Considerations
 | Scenario                  | Customer Initiated? | K8S Upgraded? | OS Kernel Upgraded?    | Node Image Upgraded? | Available Today?  | Notes                                                                                                                                                                                              |
|---------------------------|---------------------|---------------|------------------------|----------------------|--------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Security patching         | No                  | No            | Yes, following reboot  | No                   | Yes                      | https://help.ubuntu.com/community/AutomaticSecurityUpdates                                                                                                                                                                                                                                                                                                                                     
| Cluster create            | Yes                 | Maybe         | Maybe                  | Maybe                | Yes                      | The node image will be upgraded relative to an existing cluster if a new release is available.                                                                                                     |
|                           |                     |               |                        |                      |                          | The OS kernel will be upgraded if an updated node image is released and it uses an updated kernel.                                                                                                 |
| Control plane k8s upgrade | Yes                 | Yes           | No                     | No                   | Yes                      | Upgrading the k8s version on the control plane only does not upgrade the OS kernel or node image.                                                                                                  |
| Node pool k8s upgrade     | Yes                 | Yes           | Maybe                  | Maybe                | Yes                      | The node image will be upgraded if a new release is available.                                                                                                                                     |
|                           |                     |               |                        |                      |                          | The OS kernel will be upgraded if an updated node image is released and it uses an updated kernel.                                                                                                 |
| Node pool scale up        | Yes                 | No            | No                     | No                   | Yes                      | Node scale up uses the model associated with the VMSS when it was created.  The OS kernel will get upgraded once security patches are applied and the node is rebooted.                                |
| Node image upgrade        | Yes                 | No            | Maybe                  | Yes                  | Yes                       | The OS kernel will be upgraded if an updated node image is released and it uses an updated kernel.  The agent pool get upgrade profile API can be used to determine the latest node image version.                                                                                                                                                                                                                                                          
| Node image auto upgrade   | No                  | No            | Maybe                  | Yes                  | No                       | The OS kernel will be upgraded if an updated node image is released and it uses an updated kernel.                                                                                                 |
|                           |                     |               |                        |                      |                          | Planned - https://github.com/Azure/AKS/issues/1486                                                                                                                                                 |
| Cluster auto upgrade      | No                  | Yes           | No                     | No                   | Yes                       | In Preview - https://docs.microsoft.com/azure/aks/upgrade-cluster#set-auto-upgrade-channel-preview                                                                                                                                              |

## Node Image Upgrades

 * An updated node image will contain up-to-date OS security patches, kernel updates, k8 security updates, newer versions of binaries (kubelet,cni, containerd etc.), and updated versions of components listed in the [release notes](https://github.com/Azure/AKS/releases). 
 * These updates have all relevant and validated security updates, feature updates or both.
* It’s possible that a OS security patch applied as part of the node image upgrade will install a later version of the kernel than would be seen if a new cluster is created.
 * Using the node image upgrade method will ensure you only get tested kernels and components which are compatible with those kernels.
 * Linux might receive daily security updates while the process to keep Windows Server nodes up-to-date is a little different. Windows Server nodes don't receive daily updates. Instead, you perform an AKS upgrade that deploys new nodes with the latest base Window Server image and patches.
 * Using the node image upgrade process allows you to better streamline upgrades for both windows and linux nodepools. 
 * Consider checking and applying node image upgrades bi-weekly and automating the process.
 * Use “kubectl describe node …” to check the OS kernel version and the OS image version.

    ![k_describe_node](images/os_kernel_image_version.png)

* GET latest available Node Image version
    * ```
       az aks nodepool get-upgrades --nodepool-name nodepoolname -g cluster-resource-group --cluster-name aks-cluster-name -o table
      ```
    * ![latest_nodimage_version](images/latest_node_image_version.png)
* Check the current NodeImage versions of the nodepool(s) in your cluster
    * ```
      az aks nodepool list --query "[].{Name:name,NodeImageVersion:nodeImageVersion}" -g rg-cluster --cluster-name aks-cluster-name -o table
    
    * ![nodimage_version_cli](images/nodeimage_versions_cli.png)
* Upgrade node pools to the latest node image version
    * [Upgrade all nodes in node pools](https://docs.microsoft.com/azure/aks/node-image-upgrade#upgrade-all-nodes-in-all-node-pools)
    * [Upgrade a specific node pool](https://docs.microsoft.com/azure/aks/node-image-upgrade#upgrade-a-specific-node-pool)
    * [Upgrade node pool using GitHub Actions](https://docs.microsoft.com/azure/aks/node-upgrade-github-actions)
* Consider automating the node image upgrade process. See [Node Upgrade GitHub Actions](https://docs.microsoft.com/azure/aks/node-upgrade-github-actions)



## Create continuous cluster upgrade process
The Kubernetes community releases minor versions roughly every three months. The supported window of Kubernetes versions on AKS is known as "N-2": (N (Latest release) - 2 (minor versions)). In order to make sure your AKS clusters don't go out of support it's important to establish a continuous cluster upgrade process.

Information about new AKS versions and releases is published to the [AKS GitHub release notes page](https://github.com/Azure/AKS/releases). You can also subscribe to the [GitHub RSS Feed](https://github.com/Azure/AKS/releases.atom). The release notes page has information about the latest AKS features, behavioral changes, Bug fixes, and Component Updates.

To proactively receive updates about AKS upgrades, we recommend using the following methods:

* Check when an upgrade is required for your cluster
    * Get list of available target upgrade versions for your AKS Control Plane Upgrades and determine the target version for the control plane from the results.
        * ```
          az aks get-upgrades \
          --resource-group myResourceGroup \
          --name myAKSCluster --output table 
          ```
        * ![available_controlplane_upgrade_versions](images/available_cp_upgrade_versions.png)
    
    * Then check the kubernetes versions of the nodes in your node pools and determine the cluster's node pools that need to be upgraded.
        * ```
          az aks nodepool list \  
          --query "[].{Name:name,k8version:orchestratorVersion}" \  
          -g rg-cluster --cluster-name aks-cluster-name -o table
          ```
        * ![nodepoool_version](images/nodepool_versions.png)


* Once a new version becomes available, you should ideally plan an upgrade across all environments before the version becomes the default. This approach provides more control and predictability when needed, and plan upgrades with minimal disruption to existing workloads.
* You can upgrade the control plane first and then the individual nodepools.
* Upgrade the AKS  control plane to the target version
   * Issuing the az aks upgrade command with the --control-plane-only flag upgrades only the cluster control plane. 
   * None of the associated node pools in the cluster are changed.
   * [Validation rules for cluster upgrades](https://docs.microsoft.com/azure/aks/use-multiple-node-pools#validation-rules-for-upgrades)
   * ```
        az aks upgrade \
        --resource-group myResourceGroup \  
        --name myAKSCluster \ 
        --control-plane-only \  
        --kubernetes-version KUBERNETES_VERSION \  
        --no-wait
     ```
* Upgrade the node pools to the target version
    ```
    az aks nodepool upgrade \
    --resource-group myResourceGroup \
    --cluster-name myAKSCluster \
    --name mynodepool \
    --kubernetes-version KUBERNETES_VERSION \
    --no-wait
    ```

## Minimize disruption to existing workloads during an upgrade
* Set up multiple environments
* Plan and schedule maintenance windows.
* [Plan your tolerance for disruption.](https://docs.microsoft.com/azure/aks/operator-best-practices-scheduler#plan-for-availability-using-pod-disruption-budgets)
* [Use surge upgrades to control nodepool upgrades.](https://docs.microsoft.com/azure/aks/upgrade-cluster#customize-node-surge-upgrade)

## Next Steps

[AKS Roadmap](https://aka.ms/aks/roadmap)  
[AKS Product Documentation](/azure/aks)