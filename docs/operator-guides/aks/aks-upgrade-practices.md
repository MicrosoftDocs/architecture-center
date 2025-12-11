---
title: "AKS Day-2 Guide: Patch and Upgrade Guidance"
description: Learn about day-2 patching and upgrading practices for Azure Kubernetes Service (AKS) worker nodes and Kubernetes versions.
author: aionic
ms.author: anevico
ms.date: 02/06/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - devx-track-azurecli
  - arb-containers
---

# Azure Kubernetes Service patch and upgrade guidance

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes patching and upgrading strategies for AKS worker nodes and Kubernetes versions. As a cluster operator, you need to have a plan for keeping your clusters up to date and monitoring Kubernetes API changes and deprecations over time.

## Background and types of updates

There are three types of updates for AKS, and each one builds on the previous update:

|Update type|Frequency of upgrade|[Planned maintenance support](/azure/aks/planned-maintenance)|Supported operation methods|Target|Documentation |
|--|--|--|--|--|--|
|Node OS security patches |Nightly|Yes |Automatic (weekly), manual/unmanaged (nightly)|Node|[Automatically upgrade node images](/azure/aks/auto-upgrade-node-os-image)|
|Node image version upgrades|**Linux**: [Weekly](https://releases.aks.azure.com/)<br>**Windows**: [Monthly](https://releases.aks.azure.com/)|Yes|[Automatic](/azure/aks/auto-upgrade-node-os-image), manual|Node pool|[Upgrade AKS node images](/azure/aks/node-image-upgrade)|
|Kubernetes version (cluster) upgrades|[Quarterly](https://kubernetes.io/releases/)|Yes| [Automatic](/azure/aks/auto-upgrade-cluster), manual|Cluster and node pool|[Upgrade options for AKS clusters](/azure/aks/upgrade-cluster)|

### Update types

- **Node OS security patches (Linux only):** For Linux nodes, both [Canonical Ubuntu](https://ubuntu.com/server) and [Azure Linux](/azure/azure-linux/intro-azure-linux) make operating system security patches available once a day. Microsoft tests and bundles these patches in the weekly updates to node images.

- **Weekly updates to node images:** AKS provides weekly updates to node images. These updates include the latest OS and AKS security patches, bug fixes, and enhancements. Node updates don't change the Kubernetes version. Versions are formatted by date (for example, 202311.07.0) for Linux and by Windows Server OS build and date (for example, 20348.2113.231115) for Windows. For more information, see [AKS release status](https://releases.aks.azure.com/).

- **Quarterly Kubernetes releases:** AKS provides quarterly updates for [Kubernetes releases](https://kubernetes.io/releases/release/#the-release-cycle). These updates enable AKS users to use the latest Kubernetes features and enhancements, such as security patches and node image updates. For more information, see [Supported Kubernetes versions in AKS](/azure/aks/supported-kubernetes-versions).

### Pre-upgrade considerations

Before you upgrade your AKS worker nodes and Kubernetes versions, consider the following effects and best practices.

#### Overall cluster impact

- In-place upgrades for nodes and clusters affect the performance of your Kubernetes environment while they're in progress. You can minimize this effect through proper configuration of pod disruption budgets, node surge configuration, and proper planning.

- Blue-green update strategies don't affect cluster performance, but they increase cost and complexity.

- Regardless of your upgrade and patching strategy, you need to have a robust testing and validation process for your cluster. Patch and upgrade lower environments first, and perform a post-maintenance validation to check [cluster](/azure/architecture/operator-guides/aks/aks-triage-cluster-health), [node](/azure/architecture/operator-guides/aks/aks-triage-node-health), [deployment](/azure/architecture/operator-guides/aks/aks-triage-deployment), and application health.

#### AKS workload best practices

To ensure that your AKS cluster operates smoothly during maintenance, follow these best practices:

- **Define pod disruption budgets (PDBs).** Setting up [PBDs](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) for your deployments is essential. PDBs enforce a minimum number of available application replicas to ensure continuous functionality during [disruption events](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/). PDBs help maintain the stability of your cluster during maintenance or node failures.

   > [!WARNING]
   > Misconfigured PDBs can block the upgrade process because the Kubernetes API prevents the necessary cordon and drain that occurs with a rolling node-image upgrade. Additionally, if too many pods are moved simultaneously, an application outage can occur. Proper PDB configuration mitigates this risk.

- **Check available compute and network limits.**  Verify the available compute and network limits in your Azure subscription via the [quota page](/azure/quotas/view-quotas) in the Azure portal, or by using the [az quota](/cli/azure/quota/usage?view=azure-cli-latest#az-quota-usage-list&preserve-view=true) command. Check compute and network resources, especially virtual machine (VM) vCPUs for your nodes, and the number of VMs and virtual machine scale sets. If you're close to a limit, request a quota increase before you upgrade.

- **Check available IP address space in node subnets.** During updates, extra surge nodes are created in your cluster and pods are moved to these nodes. It's important that you monitor the IP address space in your node subnets to ensure that there's sufficient address space for these changes to occur. Different Kubernetes [network configurations](/azure/aks/concepts-network#azure-virtual-networks) have different IP address requirements. To start, review these considerations:

  - During an upgrade, the number of node IP addresses increases according to your surge value. The minimum surge value is 1.
  - Clusters that are based on Azure Container Network Interface assign IP addresses to individual pods, so there needs to be sufficient address space for pod movement.
  - Your cluster continues to operate during upgrades. Ensure that enough IP address space remains to allow node scaling.

- **Set up multiple environments.** Set up multiple Kubernetes environments, such as development, staging, and production environments. This separation enables you to fully test and validate changes before you move them to production. Validation is especially important when you move between multiple versions of AKS, such as from 1.28 to 1.31.

- **Plan and schedule maintenance windows.** Upgrade processes might affect the overall performance of your Kubernetes cluster. Schedule in-place upgrade processes outside of peak usage windows, and monitor cluster performance to ensure adequate sizing, especially during update processes.

- **Optimize clusters for undrainable node behavior.** By default, if a node fails to drain successfully, then patching on your cluster also fails. To address this problem, you should [configure node drain cordon](/azure/aks/upgrade-cluster#optimize-for-undrainable-node-behavior-preview). This process quarantines undrainable nodes and allows your cluster to upgrade successfully. Then you can manually remediate the nodes that failed to update by patching or deleting them.

- **Tune surge upgrade values.** By default, AKS has a surge value of 1, which means that one extra node is created at a time as part of the upgrade process. You can increase the speed of an AKS upgrade by increasing this value. The recommended maximum surge value for workloads that are sensitive to disruptions is 33%. For more information, see [Customize node surge upgrade](/azure/aks/upgrade-aks-cluster#customize-node-surge-upgrade).

- **Tune node drain time-out.** [Node drain time-out](/azure/aks/upgrade-aks-cluster#set-node-drain-timeout-value) specifies the maximum amount of time that a cluster waits while a workload attempts to reschedule pods on a node that's updating. The default value is 30 minutes. For workloads that struggle to reschedule pods, increasing this value can be helpful.

- **Tune node soak time-out.** By default, the [node soak configuration](/azure/aks/upgrade-aks-cluster#set-node-soak-time-value) proceeds to reimaging the next node after a node completes its update process. For certain legacy or sensitive workloads, it might be beneficial to add a delay before you continue to the next node. Add a delay by configuring a node soak time-out.

- **Check other dependencies in your cluster.** Kubernetes operators often deploy other tooling to the Kubernetes cluster as part of operations, like KEDA scalers, DAPR, and service meshes. When you plan your upgrade processes, check release notes for any components that you use to ensure compatibility with the target version.

- **Tune for AKS zonal configurations.** For zonal AKS clusters, the surge upgrade might temporarily result in an imbalanced distribution of workloads between zones. To prevent this scenario, set the surge value to a multiple of three, such as 33% surge.

### Manage weekly updates to node images

Microsoft creates a new node image for AKS nodes approximately once a week. A node image contains up-to-date OS security patches, OS kernel updates, Kubernetes security updates, updated versions of binaries like kubelet, and component version updates that are listed in the [release notes](https://github.com/Azure/AKS/releases).

When a node image is updated, a *cordon and drain* action is triggered on the target node pool's nodes:

1. A node with the updated image is added to the node pool. The surge value governs how many nodes are added at the same time.
1. Depending on the surge value, a batch of existing nodes is *cordoned* and *drained*. Cordoning ensures that the node doesn't schedule pods. Draining removes its pods and schedules them to other nodes.
1. After these nodes are fully drained, they're removed from the node pool. The updated nodes added by the surge replace them.
1. This process is repeated for each remaining batch of nodes that needs to be updated in the node pool.

A similar process occurs during a cluster upgrade.

#### Automatic node image upgrades

Generally, most clusters should use the `NodeImage` update channel. This channel provides an updated node image virtual hard disk (VHD) on a weekly basis and is updated according to your cluster's maintenance window.

The available channels are:

- `None`. No updates are automatically applied.

- `Unmanaged`. The OS applies Ubuntu and Azure Linux updates on a nightly basis. Reboots must be managed separately. AKS can't test or control the cadence of these updates.

- `SecurityPatch`. The OS deploys security patches that are AKS-tested, are fully managed, and use safe deployment practices. This patch doesn't contain any OS bug fixes. It only contains security updates.

- `NodeImage`. AKS updates the nodes with a newly patched VHD that contains security fixes and bug fixes on a weekly cadence. These updates are fully tested and deployed by using safe deployment practices. For real-time information about currently deployed node images, see [AKS node image updates](/azure/aks/release-tracker#aks-node-image-updates).

To understand the default cadences without an established maintenance window, see [Update ownership and schedule](/azure/aks/auto-upgrade-node-os-image#update-ownership-and-schedule).

If you choose the `Unmanaged` update channel, you need to manage the reboot process by using a tool like [kured](https://kured.dev/docs/). The `Unmanaged` channel doesn't come with AKS-provided safe deployment practices and doesn't work under maintenance windows.

If you choose the `SecurityPatch` update channel, you can apply updates as frequently as weekly. This patch level requires the VHDs to be stored in your resource group, which incurs a nominal charge. To control when `SecurityPatch` is applied, set an `aksManagedNodeOSUpgradeSchedule` cadence that works best for your workload. If you also need bug fixes that typically come with new node images (VHD), then you need to choose the `NodeImage` channel instead of `SecurityPatch`.

For more information, see [Use planned maintenance to schedule and control upgrades for your AKS cluster](/azure/aks/planned-maintenance). 

As a best practice, use the `NodeImage` update channel and configure an `aksManagedNodeOSUpgradeSchedule` maintenance window to a time when the cluster is outside of peak usage windows. For attributes that you can use to configure the cluster maintenance window, see [Create a maintenance window](/azure/aks/planned-maintenance/#create-a-maintenance-window). The key attributes are:

- `name`. Use `aksManagedNodeOSUpgradeSchedule` for node OS updates.

- `utcOffset`. Configure the time zone.

- `startTime`. Set the start time of the maintenance window.

- `dayofWeek`. Set the days of the week for the window. For example, `Saturday`.

- `schedule`. Set the frequency of the window. For `NodeImage` updates, we recommend `weekly`.

- `durationHours`. Set this attribute to at least four hours.

The following example sets a weekly maintenance window to 8:00 PM Eastern Time on Saturdays:

```azurecli
az aks maintenanceconfiguration add -g <ResourceGroupName> --cluster-name <AKSClusterName> --name aksManagedNodeOSUpgradeSchedule --utc-offset=-05:00 --start-time 20:00 --day-of-week Saturday --schedule-type weekly --duration 4
```

This configuration is ideally deployed as part of the infrastructure-as-code deployment of the cluster.

For more examples, see [Add a maintenance window configuration](/azure/aks/planned-maintenance#add-a-maintenance-window-configuration).

You can check for configured maintenance windows by using the Azure CLI:

```azurecli
az aks maintenanceconfiguration list -g <ResourceGroupName> --cluster-name <AKSClusterName>
```

You can also check the details of a specific maintenance window by using the CLI:

```azurecli
az aks maintenanceconfiguration show -g <ResourceGroupName> --cluster-name <AKSClusterName> --name aksManagedNodeOSUpgradeSchedule
```

If a cluster maintenance window isn't configured, node image updates occur biweekly. AKS maintenance occurs within the configured window as much as possible, but the time of maintenance isn't guaranteed.

> [!IMPORTANT]
> If you have a node pool with a large number of nodes that isn't configured with [node surge](/azure/aks/upgrade-aks-cluster#customize-node-surge-upgrade), the automatic upgrade event might not trigger. Node images in a node pool are only upgraded if the estimated total upgrade time is within 24 hours.
>
> In this situation, you can consider one of the following options:
> - Split nodes into different node pools if your vCPU quota is almost full and you can't increase the vCPU quota.
> - Configure node surge to decrease the estimated upgrade time if your vCPU quota is adequate.

To monitor the status of updates automatically, you can use the [AKS communication manager](/azure/aks/aks-communication-manager) to provide automatic alerts for planned maintenance activities. Alternatively, you can monitor directly via [Azure Monitor activity logs](/azure/azure-monitor/essentials/activity-log) or by reviewing the [resource logs](/azure/aks/monitor-aks-reference#resource-logs) on the cluster via `kubectl get events`.

Subscribe to [AKS events with Azure Event Grid](/azure/aks/quickstart-event-grid) to get AKS upgrade events. These events can alert you when a new version of Kubernetes is available and help you track node status changes during upgrade processes.

You can also manage the weekly update process by using [GitHub Actions](/azure/aks/node-upgrade-github-actions). This method provides more granular control of the update process.

#### Manual node update process

You can use the [kubectl describe nodes](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) command to determine the OS kernel version and the OS image version of the nodes in your cluster:

```kubectl
kubectl describe nodes <NodeName>
```

Example output (truncated):

```output
System Info:
  Machine ID:                 bb2e85e682ae475289f2e2ca4ed6c579
  System UUID:                6f80de9d-91ba-490c-8e14-9e68b7b82a76
  Boot ID:                    3aed0fd5-5d1d-4e43-b7d6-4e840c8ee3cf
  Kernel Version:             5.15.173.1-1.cm2
  OS Image:                   CBL-Mariner/Linux
  Operating System:           linux
  Architecture:               arm64
  Container Runtime Version:  containerd://1.6.26
  Kubelet Version:            v1.31.3
  Kube-Proxy Version:         v1.31.3
```

Use the Azure CLI [az aks nodepool list](/cli/azure/aks/nodepool#az-aks-nodepool-list) command to determine the node image versions of the nodes in a cluster:

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

Use the [az aks nodepool get-upgrades](/cli/azure/aks/nodepool#az-aks-nodepool-get-upgrades) command to determine the latest available node image version for a specific node pool:

```azurecli
az aks nodepool get-upgrades \
   --resource-group <ResourceGroupName> \
   --cluster-name <AKSClusterName> \
   --nodepool-name <NodePoolName> --output table
```

Example output:

```output
Name    NodeImageVersion
------  -------------------------------------
system  AKSAzureLinux-V2gen2-202501.12.0
user    AKSAzureLinux-V2gen2arm64-202501.12.0
```

## Cluster upgrades

The Kubernetes community releases minor versions of Kubernetes approximately every three months. To keep you informed about new AKS versions and releases, the [AKS release notes page](https://github.com/Azure/AKS/releases) is updated regularly. You can also subscribe to the [GitHub AKS RSS feed](https://github.com/Azure/AKS/releases.atom), which provides real-time updates about changes and enhancements.

AKS follows an *N - 2* support policy, which means that full support is provided for the latest release (*N*) and the two previous minor versions. Limited platform support is offered for the third prior minor version. For more information, see [Support policies for AKS](/azure/aks/support-policies).

To ensure that your AKS clusters remain supported, you need to establish a continuous cluster upgrade process. This process involves testing new versions in lower environments and planning the upgrade to production before the new version becomes the default. This approach helps maintain predictability in your upgrade process and minimizes disruptions to applications. For more information, see [Upgrade options for AKS clusters](/azure/aks/upgrade-cluster).

If your cluster requires a longer upgrade cycle, use AKS versions that support the [Long Term Support (LTS) option](/azure/aks/supported-kubernetes-versions#long-term-support-lts). If you enable the LTS option, Microsoft provides extended support for Kubernetes versions for two years, which enables a more prolonged and controlled upgrade cycle. For more information, see [Supported Kubernetes versions in AKS](/azure/aks/supported-kubernetes-versions).

A cluster upgrade includes a node upgrade and uses a cordon and drain process.

### Before you upgrade

As a best practice, you should always upgrade and test in lower environments to minimize the risk of disruption in production. Cluster upgrades require extra testing because they involve API changes, which can affect Kubernetes deployments. The following resources can assist you in the upgrade process.

- **AKS workbook for deprecated APIs:** From the cluster overview page in the Azure portal, select **Diagnose and solve problems**, go to the **Create, Upgrade, Delete and Scale** category, and then select **Kubernetes API deprecations**. This procedure runs a workbook that checks for deprecated API versions that your cluster still uses. For more information, see [Remove usage of deprecated APIs](/azure/aks/stop-cluster-upgrade-api-breaking-changes#remove-usage-of-deprecated-apis-recommended).

- [**AKS release notes page:**](https://github.com/Azure/AKS/releases) This page provides comprehensive information about new AKS versions and releases. Review these notes to stay informed about the latest updates and changes.

- [**Kubernetes release notes page:**](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG) This page provides detailed insights into the latest Kubernetes versions. Pay special attention to urgent upgrade notes. They highlight critical information that might affect your AKS cluster.

- [**AKS components breaking changes by version:**](/azure/aks/supported-kubernetes-versions#aks-components-breaking-changes-by-version) This table provides a comprehensive overview of breaking changes in AKS components, by version. By referring to this guide, you can proactively address any potential compatibility problems before the upgrade process.

In addition to these Microsoft resources, consider using open-source tools to optimize your cluster upgrade process. One such tool is Fairwinds [pluto](https://github.com/FairwindsOps/pluto), which can scan your deployments and Helm charts for deprecated Kubernetes APIs. These tools can help you ensure that your applications remain compatible with the latest Kubernetes versions.

### Upgrade process

To check when your cluster requires an upgrade, use the [az aks get-upgrades](/cli/azure/aks#az-aks-get-upgrades) command to get a list of available upgrade versions for your AKS cluster. Determine the target version for your cluster from the results.

Here's an example:

```azurecli
az aks get-upgrades \
   --resource-group <ResourceGroupName> --name <AKSClusterName> --output table
```

Example output:

```output
MasterVersion  Upgrades
-------------  ---------------------------------
1.30.7         1.31.1, 1.31.2, 1.31.3
```

Check the Kubernetes versions of the nodes in your node pools to find the pools that need to be upgraded:

```azurecli
az aks nodepool list \
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --query "[].{Name:name,k8version:orchestratorVersion}" --output table
```

Example output:

```output
Name          K8version
------------  ------------
systempool    1.30.7
usernodepool  1.30.7
```

#### Manual upgrades

To minimize disruptions and help ensure a smooth upgrade for your AKS cluster, take this upgrade approach:

1. **Upgrade the AKS control plane.** Upgrade the control plane components that are responsible for managing and orchestrating your cluster. Upgrade the control plane first to help ensure compatibility and stability before you upgrade the individual node pools.

1. **Upgrade your system node pool.** After you upgrade the control plane, upgrade the system node pool in your AKS cluster. Node pools consist of the VM instances that run your application workloads. Upgrading the node pools separately enables a controlled and systematic upgrade of the underlying infrastructure that supports your applications.

1. **Upgrade user node pools.** After you upgrade the system node pool, upgrade any user node pools in your AKS cluster.

By following this approach, you can minimize disruptions during the upgrade process and maintain the availability of your applications. Take the following steps:

1. Run the [az aks upgrade](/cli/azure/aks#az-aks-upgrade) command with the `--control-plane-only` flag to upgrade only the cluster control plane and not the cluster's node pools:

   ```azurecli
   az aks upgrade \
      --resource-group <ResourceGroupName> --name <AKSClusterName> \
      --control-plane-only \
      --kubernetes-version <KubernetesVersion>
   ```

1. Run the [az aks nodepool upgrade](/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-upgrade&preserve-view=true) command to upgrade node pools to the target version:

   ```azurecli
   az aks nodepool upgrade \
      --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> --name <NodePoolName> \
      --no-wait --kubernetes-version <KubernetesVersion>
   ```

   [During the node pool upgrade](/azure/aks/upgrade-cluster), AKS creates a surge node, cordons and drains pods in the node that's being upgraded, reimages the node, and then uncordons the pods. This process repeats for the other nodes in the node pool.

You can check the status of the upgrade process by running `kubectl get events`.
For information about troubleshooting cluster upgrade problems, see [AKS troubleshooting documentation](/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes).

## Enroll clusters in automatic-upgrade release channels

AKS also provides an [automatic cluster upgrade solution](/azure/aks/auto-upgrade-cluster) to keep your cluster up to date. If you use this solution, you should pair it with a [maintenance window](/azure/aks/planned-maintenance) to control the timing of upgrades. The upgrade window must be four hours or more.
When you enroll a cluster in a release channel, Microsoft automatically manages the version and upgrade cadence for the cluster and its node pools.

The cluster's automatic upgrade provides different release channel options. Here's a recommended environment and release channel configuration:

| Environment  | Upgrade channel    | Description     |
|-----|--------------------|------------|
| Production      | `stable`   | For stability and version maturity, use the stable or regular channel for production workloads.   |
| Staging, testing, development   | Same as production | To ensure that your tests are indicative of the version that you'll upgrade your production environment to, use the same release channel as production.       |
| Canary       | `rapid` | To test the latest Kubernetes releases and new AKS features or APIs, use the `rapid` channel. You can improve your time to market when the version in `rapid` is promoted to the channel that you use for production. |

## Considerations

The following table describes the characteristics of various AKS upgrade and patching scenarios.

|Scenario|User initiated|Kubernetes upgrade|OS kernel upgrade|Node image upgrade|
|--------|--------------|-----------|-----------------|------------------|
|Security patching | No  | No | Yes, after reboot | Yes  |
|Cluster creation | Yes  | Maybe | Yes, if an updated node image uses an updated kernel|Yes, relative to an existing cluster if a new release is available|
|Control plane Kubernetes upgrade | Yes  | Yes | No  | No  |
|Node pool Kubernetes upgrade | Yes  | Yes | Yes, if an updated node image uses an updated kernel| Yes, if a new release is available|
|Node pools scale-up | Yes  | No | No  | No  |
|Node image upgrade | Yes  | No | Yes, if an updated node image uses an updated kernel| Yes  |
|Cluster automatic upgrade | No  | Yes | Yes, if an updated node image uses an updated kernel | Yes, if a new release is available  |

- An OS security patch that's applied as part of a node image upgrade might install a later version of the kernel than the creation of a new cluster might install.

- Node pool scale-up uses the model that's currently associated with the virtual machine scale set. The OS kernels are upgraded when security patches are applied and the nodes restart.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Anthony Nevico](https://www.linkedin.com/in/anthonynevico/) | Principal Cloud Solution Architect

Other contributors:

- [Rishabh Saha](https://www.linkedin.com/in/rishabhsaha/) | Principal Solution Architect
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
- [Ali Yousefi](https://www.linkedin.com/in/iamaliyousefi/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS product documentation](/azure/aks/)
- [AKS release tracker](https://releases.aks.azure.com/webpage/index.html)
- [AKS roadmap](https://aka.ms/aks/roadmap)
- [Troubleshoot AKS problems](/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)
- [Optimize AKS upgrades](/azure/aks/upgrade-cluster#optimize-upgrades-to-improve-performance-and-minimize-disruptions)
- [Node OS upgrade FAQ](/azure/aks/auto-upgrade-node-os-image#node-os-auto-upgrades-faq)
- [Defining day-2 operations](https://dzone.com/articles/defining-day-2-operations)
- [A practical guide for zone-redundant AKS clusters](https://techcommunity.microsoft.com/blog/fasttrackforazureblog/a-practical-guide-to-zone-redundant-aks-clusters-and-storage/4036254)
- [Cloud Adoption Framework guidance for adopting AKS in an Azure landing zone](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator)

## Related resources

- [AKS day-2 operations guide](./day-2-operations-guide.md)
- [AKS triage practices](./aks-triage-practices.md)
