---
title: AKS Day-2 - Patch and upgrade guidance
titleSuffix: Azure Architecture Center
description: Learn about day-2 patching and upgrading practices for Azure Kubernetes Service (AKS) worker nodes and Kubernetes (K8S) versions.
author: aionic
ms.date: 11/28/2023
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

# Azure Kubernetes Service patch and upgrade guidance

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes patching and upgrading strategies for AKS worker nodes and Kubernetes (K8S) versions. As a cluster operator, it's crucial to have a plan for keeping your clusters up to date and monitoring Kubernetes API changes and deprecations over time.

## Background and types of updates

There are three different types of updates for AKS, each building on one another.

|Component name|Frequency of upgrade|[Planned Maintenance Supported](/azure/aks/planned-maintenance)|Supported operation methods|Target|Documentation link|
|--|--|--|--|--|--|
|Security patches to the OS of the node image|[Nightly](/azure/aks/concepts-vulnerability-management#worker-nodes)|Yes |Automatic, Manual|Node|[AKS Upgrades](/azure/aks/upgrade)|
|Node image version upgrades|**Linux**: [Weekly](https://releases.aks.azure.com/)<br>**Windows**: [Monthly](https://releases.aks.azure.com/)|Yes|[Automatic](/azure/aks/auto-upgrade-node-os-image), Manual|Node pool|[AKS node image upgrade](/azure/aks/node-image-upgrade)|
|Kubernetes version (cluster) upgrades|[Quarterly](https://kubernetes.io/releases/)|Yes| [Automatic](/azure/aks/auto-upgrade-cluster), Manual|Cluster and Node pool|[Upgrade an AKS cluster](/azure/aks/upgrade-cluster?tabs=azure-cli)|

### Component details

- **Nightly security patches to the operating system (OS) of the node image *(Linux only)*:** For Linux nodes both [Ubuntu](https://ubuntu.com/server) and [Azure Linux](/azure/azure-linux/intro-azure-linux) check for, and apply security patches to the OS on each node nightly; however, if a patch requires a node to reboot that process must be managed.

- **Weekly updates to the node images:** AKS provides weekly updates to the node images, these updates include a rollup of the latest OS and AKS security patches, bug fixes and enhancements. These updates help to maintain the overall stability and security of the cluster. For more information, see [AKS release tracker](https://releases.aks.azure.com/).

- **Quarterly Kubernetes releases:** AKS follows a quarterly update schedule for [Kubernetes releases](https://kubernetes.io/releases/release/#the-release-cycle). These updates allow AKS users to take advantage of the latest Kubernetes features, enhancements, and include security patches and node image enhancements. For more information, see [Supported Kubernetes versions in Azure Kubernetes Service (AKS)](/azure/aks/supported-kubernetes-versions).

### Considerations before upgrades

#### Overall cluster impact

- In-place upgrades (both node and cluster) affect the performance of your Kubernetes environment while the upgrade is in progress.  This effect can be minimized through proper configuration of pod disruption budgets, node surge configuration, and proper planning.
- Utilizing a Blue/Green update strategy instead of in-place eliminates any impact to cluster performance, but brings extra cost and complexity.
- Regardless of your upgrade/patching strategy it's important to have a robust testing/validation process for your cluster.  Patch/Upgrade lower environments first, and perform a post maintenance validation where you check [cluster](azure/architecture/operator-guides/aks/aks-triage-cluster-health), [node](/azure/architecture/operator-guides/aks/aks-triage-node-health), [deployment](/azure/architecture/operator-guides/aks/aks-triage-deployment), and application health.

#### Cluster workload best practices

To ensure the smooth operation of your AKS cluster during maintenance events, follow these best practices:

- **Define Pod Disruption Budgets (PDBs).** Setting up [Pod Disruption Budgets](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) for your deployments is essential. PDBs enforce a minimum number of available application replicas, ensuring continuous functionality during [disruption events](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/). Pod Disruption Budgets help maintain the stability of your cluster during maintenance or node failures.
  - :warning: A misconfiguration of Pod Disruption Budgets could block the upgrade process as the Kubernetes API prevents the necessary cordon and drain that occurs with a rolling node image upgrade.  Alternatively, if too many pods are moved simultaneously an application outage could occur.
  - updates to prioritize requested application availability. Likewise, it can create an outage during an update because
- **Check available compute and network limits.**  Verify the available compute and network limits in your Azure subscription via the [quota page](/azure/quotas/view-quotas) in Azure portal, or by using the [az quota](/cli/azure/quota/usage?view=azure-cli-latest#az-quota-usage-list&preserve-view=true) command.  Check compute and network resources especially VM vCPUs for your nodes, number of virtual machines and virtual machine scale sets.  If you're nearing a limit place a quota increase request prior to upgrade processes.
- **Check available IP space in node subnets.** During update events extra nodes are created (surge) and pods are moved to these new nodes in your cluster.  It's important that you monitor the ip address space in your node subnets to ensure there's sufficient address space for these changes to occur.  Different Kubernetes [network configurations](azure/aks/concepts-network#azure-virtual-networks) have different ip requirements as a starting point consider the following.
  - During an upgrade, the number of node ip's increases in relation to your surge value (minimum surge value is 1)
  - Azure CNI based clusters assign individual pods ip addresses so it's important that there's sufficient ip space for pod movement
  - Your cluster continues to operate during upgrades, ensure that there's enough ip space left to allow node scaling (if enabled)
- **Set up multiple environments.** Establishing separate environments such as development, staging, and production is recommended best practice that allows testing and validation of changes prior to rolling them out to production.
- **Set higher surge upgrade values.** By default AKS has a surge value of 1 (meaning one extra node is created at a time as part of the upgrade process).  You can increase the speed of an AKS upgrade by increasing this value.  33% surge is the recommended maximum value  for workloads sensitive to disruptions.  For more information, see [customize node surge upgrade](/azure/aks/upgrade-cluster#customize-node-surge-upgrade).
- **Plan and schedule maintenance windows.** Upgrade processes might impact the overall performance of your Kubernetes cluster.  Ensure in-place upgrade processes are scheduled outside peak usage windows and monitor cluster performance to ensure adequate sizing, especially during update processes.
- **Check other dependencies in your cluster** Kubernetes operators often deploy other tooling to the Kubernetes cluster as part of operations,  e.g, Keda Scaler, Dapr, Services meshes etc.  As you plan your upgrade processes check releases notes for any components in use to ensure compatibility with your target version.

### Managing the weekly updates to node images and AKS

Microsoft provides patches and new images for image nodes weekly. An updated node image contains up-to-date OS security patches, kernel updates, Kubernetes security updates, updated versions of binaries like `kubelet`, and component version updates listed in the [release notes](https://github.com/Azure/AKS/releases).

The weekly update process can be managed automatically by using [GitHub Actions](/azure/aks/node-upgrade-github-actions) or [AKS planned maintenance](/azure/aks/auto-upgrade-node-image).
Timing for [AKS planned maintenance](/azure/aks/auto-upgrade-node-image) can be controlled by configuring a [maintenance window](/azure/aks/planned-maintenance). For more information, see [Use Planned Maintenance to schedule and control upgrades for your Azure Kubernetes Service (AKS) cluster](/azure/aks/planned-maintenance).

Alternatively, the weekly process can be managed manually via the Azure portal, Azure CLI  [az aks maintenance configuration](/azure/aks/maintenanceconfiguration?view=azure-cli-latest), or via PowerShell using the [Get-AzAksMaintenanceConfiguration](/powershell/module/az.aks/get-azaksmaintenanceconfiguration) cmdlet.

- :warning: When using AKS planned maintenance for node OS auto-upgrade, use a maintenance window of four hours or more to ensure proper functionality.

- :bulb: If you enable [node auto upgrade](/azure/aks/auto-upgrade-node-image), the nightly scan for security patches is disabled as the node upgrade process now manages it.

#### Manual node update process

You can use the [kubectl describe nodes](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) command to check the OS kernel version and the OS image version of the nodes in your cluster.

```kubectl
kubectl describe nodes <NodeName>
```

Example output (truncated):

```output
System Info:
  Machine ID:                 bb2e85e682ae475289f2e2ca4ed6c579
  System UUID:                6f80de9d-91ba-490c-8e14-9e68b7b82a76
  Boot ID:                    3aed0fd5-5d1d-4e43-b7d6-4e840c8ee3cf
  Kernel Version:             5.15.0-1041-azure
  OS Image:                   Ubuntu 22.04.2 LTS
  Operating System:           linux
  Architecture:               arm64
  Container Runtime Version:  containerd://1.7.1+azure-1
  Kubelet Version:            v1.26.6
  Kube-Proxy Version:         v1.26.6
```

Use the Azure CLI [az aks nodepool list](/cli/azure/aks/nodepool#az-aks-nodepool-list) command to check the current node image versions of the nodes in a cluster.

```azurecli
az aks nodepool list \
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --query "[].{Name:name,NodeImageVersion:nodeImageVersion}" --output table
```

Example output:

```output
Name       NodeImageVersion
---------  ---------------------------------------------
systempool  AKSUbuntu-2204gen2containerd-202307.12.0
usernodepool  AKSUbuntu-2204gen2arm64containerd-202307.12.0
```

Use [az aks nodepool get-upgrades](/cli/azure/aks#az-aks-get-upgrades) to find out the latest available node image version for a specific node pool.

```azurecli
az aks nodepool get-upgrades \
   --resource-group <ResourceGroupName> \
   --cluster-name <AKSClusterName> \
   --nodepool-name <NodePoolName> --output table
```

Example output:

```output
KubernetesVersion    LatestNodeImageVersion                         Name     OsType
-------------------  ---------------------------------------------  -------  --------
1.26.6               AKSUbuntu-2204gen2arm64containerd-202308.10.0  default  Linux
```

#### Windows vs. Linux nodes

You can use node image upgrades to streamline Windows and Linux node pool upgrades, but the processes differ slightly. Linux nodes receive security updates daily, but Windows nodes only receive security updates via the node update processes.

## Cluster upgrades

The Kubernetes community releases minor versions of Kubernetes approximately every three months. To keep you informed about new AKS versions and releases, the [AKS release notes page](https://github.com/Azure/AKS/releases) page is regularly updated. Additionally, you may subscribe to the [GitHub AKS RSS feed](https://github.com/Azure/AKS/releases.atom), which provides real-time updates about changes and enhancements.

Azure Kubernetes Service (AKS) follows an "N - 2" support policy, which means that full support is provided for the latest release (N) and up to two previous minor versions. Limited platform support is offered for the third prior minor version. For more information on the support policy, review the [AKS Support Policy(/azure/aks/support-policies).

To ensure that your AKS clusters remain supported, it's crucial to establish a continuous cluster upgrade process. This process involves testing new versions in lower environments and planning the upgrade to production before the new version becomes the default. This approach can maintain predictability in your upgrade process and minimize application disruption. For more information, see [Upgrade an Azure Kubernetes Service (AKS) cluster](/azure/aks/upgrade-cluster).

If your cluster requires a longer upgrade cycle, use the [Long Term Support (LTS) option](/azure/aks/supported-kubernetes-versions#long-term-support-lts) AKS versions. With the LTS option, Microsoft provides extended support for Kubernetes versions over two years, allowing for a more prolonged and controlled upgrade cycle. For more information, see [Supported Kubernetes versions in Azure Kubernetes Service (AKS)](/azure/aks/supported-kubernetes-versions).

### Before you upgrade

This article details baseline best practices to ensure stability during upgrades.  As a best practice you should always upgrade and test in lower environments to minimize the risk of disruption in production.  Cluster upgrades require extra testing as they involve API changes, which can impact Kubernetes deployments. The following resources can assist you in this process:

- **AKS Workbook for depreciated APIs** From the cluster overview page you can select "Diagnose and solve problems" and navigate to the [Create, Upgrade, Delete and Scale category, and select Kubernetes API deprecations](/azure/aks/upgrade-cluster#remove-usage-of-deprecated-apis-recommended).  This runs a workbook that checks for depreciated API versions in use in your cluster.

- **AKS release notes page**: The [AKS Release Notes](https://github.com/Azure/AKS/releases) page provides comprehensive information about new AKS versions and releases. It's crucial to review these notes to stay informed about the latest updates and changes.
- **Kubernetes release notes page**: The [Kubernetes release notes](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG) page offers detailed insights into the latest Kubernetes versions. Pay special attention to urgent upgrade notes, which highlight critical information that might impact your AKS cluster.
- **AKS components breaking changes by version**: The [AKS Components Breaking Changes by Version](/azure/aks/supported-kubernetes-versions#aks-components-breaking-changes-by-version) page provides a comprehensive overview of breaking changes in AKS components across different versions. By referring to this guide, you can proactively address any potential compatibility issues before the upgrade process.

In addition to these Microsoft resources, consider using open-source tools to optimize your cluster upgrade process. One such tool is Fairwinds' [pluto](https://github.com/FairwindsOps/pluto), which can scan your deployments and Helm charts for deprecated Kubernetes APIs. These tools help ensure your applications remain compatible with the latest Kubernetes versions.

### Upgrade process

To check when your cluster requires an upgrade, use [az aks get-upgrades](/cli/azure/aks?view=azure-cli-latest#az-aks-get-upgrades&preserve-view=true) to get a list of available target upgrade versions for your AKS control plane. Determine the target version for your control plane from the results.

```azurecli
az aks get-upgrades \
   --resource-group <ResourceGroupName> --name <AKSClusterName> --output table
```

Example output:

```output
MasterVersion  Upgrades
-------------  ---------------------------------
1.26.6         1.27.1, 1.27.3
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
systempool    1.26.6
usernodepool  1.26.6
```

#### Manually upgrading

To minimize disruptions and ensure a smooth upgrade for your AKS cluster follow this upgrade approach:

- **First upgrade the AKS control plane.** Begin by upgrading the AKS control plane. This involves upgrading the control plane components responsible for managing and orchestrating your cluster. Upgrading the control plane first helps ensure compatibility and stability before upgrading the individual node pools.
- **Then upgrade your system node pool.** After upgrading the control plane, upgrade the system node pool in your AKS cluster. Node pools consist of the virtual machine instances running your application workloads. Upgrading the node pools separately allows for a controlled and systematic upgrade of the underlying infrastructure supporting your applications.
- **Lastly upgrade user node pools.** After upgrading the system node pool, upgrade any user node pools in your AKS Cluster.

By following this approach, you can minimize disruptions during the upgrade process and maintain the availability of your applications.

1. Run the [az aks upgrade](/cli/azure/aks?view=azure-cli-latest#az-aks-upgrade&preserve-view=true) command with the `--control-plane-only` flag to upgrade only the cluster control plane, and not any of the cluster's node pools:

   ```azurecli
   az aks upgrade \
      --resource-group <ResourceGroupName> --name <AKSClusterName> \
      --control-plane-only \
      --kubernetes-version <KubernetesVersion>
   ```

2. Run [az aks nodepool upgrade](/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-upgrade&preserve-view=true) to upgrade node pools to the target version:
[During the node pool upgrade](/azure/aks/upgrade-cluster?tabs=azure-cli#upgrade-an-aks-cluster) AKS creates a surge node, [cordon and drain](/azure/aks/concepts-security#cordon-and-drain) pods from the node to be upgraded, reimage the node, and then uncordon it.  This process then repeats for any nodes remaining in the node pool.

   ```azurecli
   az aks nodepool upgrade \
      --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> --name <NodePoolName> \
      --no-wait --kubernetes-version <KubernetesVersion>
   ```

You can check the status of the upgrade process by running `kubectl get events`.
For troubleshooting cluster upgrade issues, see [Azure Kubernetes Service troubleshooting documentation](/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes).

## Enroll clusters in auto-upgrade release channels

AKS also offers an [automatic cluster upgrade solution](/azure/aks/auto-upgrade-cluster) to keep your cluster up to date. If you choose to use this solution, you should pair it with a [maintenance window](/azure/aks/planned-maintenance) to control upgrade timing. The upgrade window must be four hours or more.
When you enroll a cluster in a release channel, Microsoft automatically manages the version and upgrade cadence for the cluster and its node pools.

The cluster auto upgrade offers different release channel options. Below is a recommended environment and release channel configuration:

| Environment                     | Upgrade Channel    | Description                                                                                                                                                                                                                                            |
|---------------------------------|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Production                      | Stable             | For stability and version maturity, use the stable or regular channel for production workloads.                                                                                                                                                        |
| Staging, Testing, Development   | Same as production | To ensure your tests are indicative of the version your production will be upgraded to, use the same release channel as production.                                                                                                                    |
| Canary                          | Rapid              | To test the latest Kubernetes releases and to get ahead of the curve by testing new AKS features or APIs, use the rapid channel. You can improve your time to market when the version in rapid is promoted to the channel you're using for production. |
|                                 |                    |                                                                                                                                                                                                                                                        |

## Considerations

The following table describes the characteristics of various AKS upgrade and patching scenarios:

|Scenario|User initiated|K8S upgrade|OS kernel upgrade|Node image upgrade|
|--------|--------------|------------------|-----------------|------------------|
|Security patching | No  | No | Yes, following reboot | Yes  |
|Cluster create | Yes  | Maybe | Yes if an updated node image uses an updated kernel.|Yes, relative to an existing cluster if a new release is available.|
|Control plane K8S upgrade | Yes  | Yes | No  | No  |
|Node pool K8S upgrade | Yes  | Yes | Yes, if an updated node image uses an updated kernel.| Yes, if a new release is available.|
|Node pool scale up | Yes  | No | No  | No  |
|Node image upgrade | Yes  | No | Yes, if an updated node image uses an updated kernel.| Yes  |
|Cluster auto upgrade | No  | Yes | Yes, if an updated node image uses an updated kernel.  | Yes, if a new release is available.  |

- It's possible that an OS security patch applied as part of a node image upgrade installs a later version of the kernel than creating a new cluster.
- Node pool scale-up uses the model currently associated with the virtual machine scale set. The OS kernels upgrade when security patches are applied, and the nodes reboot.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Anthony Nevico](https://www.linkedin.com/in/anthonynevico/) | Principal Cloud Solution Architect

Other contributors:

- [Paolo Salvatori](http://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
- [Rishabh Saha](https://www.linkedin.com/in/rishabhsaha/) | Principal Solution Architect
- [Ali Yousefi](https://www.linkedin.com/in/iamaliyousefi/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS product documentation](/azure/aks/)
- [AKS Roadmap](https://aka.ms/aks/roadmap)
- [AKS landing zone accelerator](https://github.com/Azure/AKS-Landing-Zone-Accelerator)

## Related resources

- [Troubleshoot AKS Issues](/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)
- [AKS day-2 operations guide](./day-2-operations-guide.md)
- [AKS triage practices](./aks-triage-practices.md)
- [AKS construction set](https://github.com/Azure/Aks-Construction)
- [AKS baseline automation](https://github.com/Azure/aks-baseline-automation)
- [Defining Day-2 Operations](https://dzone.com/articles/defining-day-2-operations)
