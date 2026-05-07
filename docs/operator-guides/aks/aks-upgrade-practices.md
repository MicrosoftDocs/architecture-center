---
title: AKS Day-2 Guide - Patch and Upgrade Guidance
description: Learn about day-2 patching and upgrading practices for Azure Kubernetes Service (AKS) worker nodes and Kubernetes versions.
author: samcogan
ms.author: samcogan
ms.date: 03/04/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - devx-track-azurecli
  - arb-containers
---

# Patch and upgrade Azure Kubernetes Service worker nodes and Kubernetes versions

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes patching and upgrading strategies for AKS worker nodes and Kubernetes versions. As a cluster operator, you need to keep your clusters up to date and monitor Kubernetes API changes and deprecations over time.

## Background and types of updates

There are three types of updates for AKS, and each one builds on the previous update.

|Update type|Frequency of upgrade|[Planned maintenance support](/azure/aks/planned-maintenance)|Supported operation methods|Target|Documentation |
|--|--|--|--|--|--|
|Node OS security patches |Nightly|Yes |Automatic (weekly), manual/unmanaged (nightly)|Node|[Automatically upgrade node images](/azure/aks/auto-upgrade-node-os-image)|
|Node image version upgrades|**Linux**: [Weekly](https://releases.aks.azure.com/AzureLinux)<br><br>**Windows**: [Monthly](https://releases.aks.azure.com/Windows)|Yes|[Automatic](/azure/aks/auto-upgrade-node-os-image), manual|Node pool|[Upgrade AKS node images](/azure/aks/node-image-upgrade)|
|Kubernetes version (cluster) upgrades|[Quarterly](https://kubernetes.io/releases/)|Yes| [Automatic](/azure/aks/auto-upgrade-cluster), manual|Cluster and node pool|[Upgrade options for AKS clusters](/azure/aks/upgrade-cluster)|

### Update types

- **Node OS security patches (Linux only):** For Linux nodes, [Canonical Ubuntu](https://ubuntu.com/server) and [Azure Linux](/azure/azure-linux/intro-azure-linux) make OS security patches available once a day. Microsoft tests and bundles these patches in the weekly updates to node images.

- **Weekly updates to node images:** AKS provides weekly updates to node images. These updates include the latest OS and AKS security patches, bug fixes, and enhancements. Node updates don't change the Kubernetes version. Linux versions are formatted by date, for example, 202601.07.0. Windows versions are formatted by Windows Server OS build and date, for example, 20348.2113.260115. For more information, see [AKS release status](https://releases.aks.azure.com/).

- **Quarterly Kubernetes releases:** AKS provides quarterly updates for [Kubernetes releases](https://kubernetes.io/releases/release/#the-release-cycle). These updates give AKS users access to the latest Kubernetes features and enhancements, like security patches and node image updates. For more information, see [Supported Kubernetes versions in AKS](/azure/aks/supported-kubernetes-versions).

### Preupgrade considerations

Before you upgrade your AKS worker nodes and Kubernetes versions, consider the following effects and best practices.

#### Overall cluster impact

- In-place upgrades for nodes and clusters affect the performance of your Kubernetes environment while they're in progress. Minimize this effect through proper configuration of pod disruption budgets (PDBs), node surge configuration, and proper planning.

- Blue-green update strategies don't affect cluster performance, but they increase cost and complexity. For detailed blue‑green patterns at the cluster and node‑pool levels, including deployments that use Azure DNS, Azure Traffic Manager, and Azure Front Door, see [Blue-green deployment of AKS clusters](/azure/architecture/guide/aks/blue-green-deployment-for-aks).

Regardless of your [upgrade and patching strategy](/azure/aks/aks-production-upgrade-strategies), use a robust testing and validation process for your cluster. First, patch and upgrade lower environments, then perform a post-maintenance validation to check the health of [clusters](/azure/architecture/operator-guides/aks/aks-triage-cluster-health), [nodes](/azure/architecture/operator-guides/aks/aks-triage-node-health), the [deployment](/azure/architecture/operator-guides/aks/aks-triage-deployment), and the application.

#### AKS workload best practices

Follow these best practices to ensure that your AKS cluster operates smoothly during maintenance:

- **Define PDBs.** It's essential to set up [PDBs](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) for your deployments. PDBs enforce a minimum number of available application replicas to ensure continuous functionality during [disruption events](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/). PDBs help maintain the stability of your cluster during maintenance or node failures.

   > [!WARNING]
   > Misconfigured PDBs might block the upgrade process because the Kubernetes API prevents the necessary cordon and drain that occurs with a rolling node image upgrade. Additionally, an application outage can occur if too many pods are moved simultaneously. Proper PDB configuration mitigates this risk.

- **Turn on [deployment safeguards](/azure/aks/deployment-safeguards).** Deployment safeguards enforce Kubernetes best practices, including PDB validation, resource limits, health probes, and antiaffinity rules. Deployment safeguards use Azure Policy controls at deployment to help ensure workloads are properly configured before an upgrade begins.

- **Check available compute and network limits.**  Verify the available compute and network limits in your Azure subscription via the [quota page](/azure/quotas/view-quotas) in the Azure portal or by using the [az quota](/cli/azure/quota/usage?view=azure-cli-latest#az-quota-usage-list&preserve-view=true) command. Check compute and network resources, especially virtual machine (VM) virtual CPUs (vCPUs) for your nodes, and the number of VMs and virtual machine scale sets. If you're close to a limit, request a quota increase before you upgrade.

- **Check available IP address space in node subnets.** During updates, extra surge nodes are created in your cluster, and pods are moved to these nodes. Monitor the IP address space in your node subnets to ensure that there's sufficient IP address space for these changes to occur. Different Kubernetes [network configurations](/azure/aks/concepts-network#azure-virtual-networks) have different IP address requirements. To start, review the following considerations:

  - During an upgrade, the number of node IP addresses increases according to your surge value. The minimum surge value is 1.
  
  - Clusters that are based on Azure Container Networking Interface (CNI) assign IP addresses to individual pods. Ensure that there's enough IP address space for pod movement.
  
  - Your cluster continues to operate during upgrades. Ensure that there's enough IP address space for node scaling.

- **Set up multiple environments.** Set up multiple Kubernetes environments, like development, staging, and production environments. Use these environments to test and validate changes before you move them to production. Validation is especially important when you move between multiple versions of AKS, for example from 1.32 to 1.34.

- **Plan and schedule maintenance windows.** Upgrade processes might affect the overall performance of your Kubernetes cluster. Schedule in-place upgrade processes outside of peak usage windows by using [maintenance windows](/azure/aks/planned-maintenance), and monitor cluster performance to ensure adequate sizing, especially during update processes.

- **Optimize clusters for undrainable node behavior.** By default, if a node fails to drain successfully, then patching on your cluster also fails. [Configure node drain cordon](/azure/aks/upgrade-cluster#optimize-for-undrainable-node-behavior-preview) to address this problem. This process quarantines undrainable nodes so that your cluster can upgrade successfully, and so that you can manually remediate the nodes that failed to update by patching or deleting them. You can configure the --max-blocked-nodes parameter to specify how many nodes can fail to drain before the upgrade fails. For example, `az aks nodepool update --undrainable-node-behavior Cordon --max-blocked-nodes 2 --drain-timeout 30`.

- **Use force upgrade for emergency scenarios.** For emergency security patching, operators can use the `--enable-force-upgrade` flag with `--upgrade-override-until` to bypass PDB protections and validation checks. When force upgrade is turned on, it takes precedence over all other drain configurations, including undrainable node behavior settings.

  > [!IMPORTANT]
  > Use this option only for urgent common vulnerability and exposure (CVE) response scenarios. For more information, see [Force upgrade an AKS cluster](/azure/aks/upgrade-options#option-1-force-upgrade-bypass-pdb).

- **Tune surge upgrade values.** By default, AKS has a surge value of 1, which means that one extra node is created at a time as part of the upgrade process. Increase the speed of an AKS upgrade by increasing this value. The recommended maximum surge value for workloads that are sensitive to disruptions is 33%. For more information, see [Customize node surge upgrade](/azure/aks/upgrade-aks-node-pools-rolling#customize-node-surge).

- **Tune node drain timeout.** [Node drain timeout](/azure/aks/upgrade-aks-node-pools-rolling#set-node-drain-timeout-value) specifies the maximum amount of time that a cluster waits while a workload attempts to reschedule pods on a node that's updating. The default value is 30 minutes. If your workload has difficulty rescheduling pods, consider increasing this value.

- **Tune node soak timeout.** By default, the [node soak configuration](/azure/aks/upgrade-aks-node-pools-rolling#set-node-soak-time-value) proceeds to reimaging the next node after a node completes its update process. For certain legacy or sensitive workloads, it might help to add a delay before you continue to the next node. Add a delay by configuring a node soak timeout.

- **Check other dependencies in your cluster.** Kubernetes operators often deploy other tooling to the Kubernetes cluster as part of operations, like Kubernetes Event-driven Autoscaling (KEDA) scalers, Distributed Application Runtime (DAPR), and service meshes. When you plan your upgrade processes, check the release notes for any components that you use to ensure compatibility with the target version.

- **Tune for AKS zone-redundant configurations.** For zone-redundant AKS clusters, the surge upgrade might result in a temporarily imbalanced distribution of workloads between zones. Set the surge value to a multiple of 3, such as 33%, to prevent this imbalance.

### Manage weekly updates to node images

Microsoft creates a new node image for AKS nodes approximately once a week. A node image contains up-to-date OS security patches, OS kernel updates, Kubernetes security updates, updated versions of binaries like kubelet, and component version updates.

When a node image is updated, a cordon and drain action is triggered on the target node pool's nodes:

1. A node with the updated image is added to the node pool. The surge value governs how many nodes are added at the same time.

1. Depending on the surge value, a batch of existing nodes is cordoned and drained. Cordoning ensures that the node doesn't schedule pods. Draining removes its pods and schedules them to other nodes.

1. After these nodes are fully drained, they're removed from the node pool. The drained nodes are replaced by the updated nodes that are added by the surge.

AKS repeats this process for each remaining batch of nodes that requires an update in the node pool. A similar process occurs during a cluster upgrade.

#### Automatic node image upgrades

Most clusters should use the `NodeImage` update channel. This channel provides an updated node image virtual hard disk (VHD) each week. The node image is updated according to your cluster's maintenance window.

The available channels are:

- `None`. No updates are automatically applied.

- `Unmanaged`. The OS applies Ubuntu and Azure Linux updates on a nightly basis. Reboots must be managed separately. AKS can't test or control the cadence of these updates.

- `SecurityPatch`. The OS deploys AKS-tested, fully managed security patches by using safe deployment practices. This patch doesn't contain any OS bug fixes. The patch contains only security updates. The `SecurityPatch` channel typically applies CVE fixes within approximately five days and reimages nodes less frequently than `NodeImage` through live patching.

- `NodeImage`. AKS updates the nodes weekly with a newly patched VHD that contains security fixes and bug fixes. These updates are fully tested and deployed by using safe deployment practices. For real-time information about currently deployed node images, see [AKS node image updates](/azure/aks/release-tracker#aks-node-image-updates).

For more information about default cadences without an established maintenance window, see [Update ownership and schedule](/azure/aks/auto-upgrade-node-os-image#update-ownership-and-schedule).

- If you choose the `Unmanaged` update channel, you need to manage the reboot process by using a tool like [kured](https://kured.dev/docs/). The `Unmanaged` channel doesn't come with AKS-provided safe deployment practices and doesn't work with maintenance windows.

- If you choose the `SecurityPatch` update channel, you can apply updates as frequently as weekly. This patch level requires the VHDs to be stored in your resource group, which incurs a nominal charge. Set an `aksManagedNodeOSUpgradeSchedule` cadence that works best for your workload to control when `SecurityPatch` is applied. If you also need bug fixes that typically come with new node images (VHD), then you need to choose the `NodeImage` channel instead of `SecurityPatch`.

As a best practice, use the `NodeImage` update channel and configure an `aksManagedNodeOSUpgradeSchedule` maintenance window during off-peak cluster usage. For attributes to configure the cluster maintenance window, see [Create a maintenance window](/azure/aks/planned-maintenance/#create-a-maintenance-window). The key attributes are:

- `name`. Use `aksManagedNodeOSUpgradeSchedule` for node OS updates.

- `utcOffset`. Configure the time zone.

- `startTime`. Set the start time of the maintenance window.

- `dayofWeek`. Set the days of the week for the window, such as `Saturday`.

- `schedule`. Set the frequency of the window. For `NodeImage` updates, we recommend `weekly`.

- `durationHours`. Set this attribute to at least four hours.

The following example sets a weekly maintenance window to 8:00 PM Eastern Time on Saturdays.

```azurecli
az aks maintenanceconfiguration add -g <ResourceGroupName> --cluster-name <AKSClusterName> --name aksManagedNodeOSUpgradeSchedule --utc-offset=-05:00 --start-time 20:00 --day-of-week Saturday --schedule-type weekly --duration 4
```

Ideally, deploy this configuration as part of the infrastructure as code (IaC) deployment of the cluster.

For more examples, see [Add a maintenance window configuration](/azure/aks/planned-maintenance#add-a-maintenance-window-configuration).

Check for configured maintenance windows by using the Azure CLI.

```azurecli
az aks maintenanceconfiguration list -g <ResourceGroupName> --cluster-name <AKSClusterName>
```

Check the details of a specific maintenance window by using the CLI.

```azurecli
az aks maintenanceconfiguration show -g <ResourceGroupName> --cluster-name <AKSClusterName> --name aksManagedNodeOSUpgradeSchedule
```

If a cluster maintenance window isn't configured, node image updates occur biweekly. AKS maintenance occurs within the configured window as much as possible, but the time of maintenance isn't guaranteed.

> [!IMPORTANT]
> If you have a node pool with a large number of nodes and it isn't configured with [node surge](/azure/aks/upgrade-aks-node-pools-rolling#customize-node-surge), the automatic upgrade event might not trigger. Node images in a node pool are only upgraded if the estimated total upgrade time is within 24 hours.
>
> In this situation, consider one of the following options:
> - Split nodes into different node pools if your vCPU quota is almost full and you can't increase the vCPU quota.
> - Configure node surge to decrease the estimated upgrade time if your vCPU quota is adequate.

To monitor the status of updates automatically, use the [AKS communication manager](/azure/aks/aks-communication-manager) to provide automatic alerts for planned maintenance activities. Alternatively, monitor the status of updates via [Azure Monitor activity logs](/azure/azure-monitor/essentials/activity-log) or by reviewing the [resource logs](/azure/aks/monitor-aks-reference#resource-logs) on the cluster via `kubectl get events`.

Subscribe to [AKS upgrade events by using Azure Event Grid](/azure/aks/quickstart-event-grid) to get AKS upgrade events. These events can alert you when a new version of Kubernetes is available and help you track node status changes during upgrade processes.

You can also manage the weekly update process by using [GitHub Actions](/azure/aks/upgrade-github-actions). This method provides more granular control of the update process.

Other monitoring and observability tools for upgrade operations include:

- **AKS diagnostics.** Select **Diagnose and solve problems** in the Azure portal for specific diagnostics about create, read, update, and delete operation failures, upgrade problems, and node health.

- **Container Insights.** Set up custom log search alerts on the `KubeEvents` table for upgrade events from the `upgrader` source component.

- **Azure Advisor.** Advisor proactively recommends upgrades as clusters approach end of support and provides service upgrade and retirement recommendations.

- **The AKS release tracker.** Use the [AKS release tracker](https://releases.aks.azure.com/) to monitor version rollouts across Azure regions and track node image availability in real time.

#### Manual node update process

You can use the [kubectl describe nodes](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) command to determine the OS kernel version and the OS image version of the nodes in your cluster.

```kubectl
kubectl describe nodes <NodeName>
```

The following output shows node system information.

```output
System Info:
  Machine ID:                 bb2e85e682ae475289f2e2ca4ed6c579
  System UUID:                6f80de9d-91ba-490c-8e14-9e68b7b82a76
  Boot ID:                    3aed0fd5-5d1d-4e43-b7d6-4e840c8ee3cf
  Kernel Version:             6.6.87.1-1.azl3
  OS Image:                   Microsoft Azure Linux 3.0
  Operating System:           linux
  Architecture:               arm64
  Container Runtime Version:  containerd://1.7.27
  Kubelet Version:            v1.33.1
  Kube-Proxy Version:         v1.33.1
```

Use the Azure CLI [az aks nodepool list](/cli/azure/aks/nodepool#az-aks-nodepool-list) command to determine the node image versions of the nodes in a cluster.

```azurecli
az aks nodepool list \
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --query "[].{Name:name,NodeImageVersion:nodeImageVersion}" --output table
```

The following output shows node image versions.

```output
Name       NodeImageVersion
---------  ---------------------------------------------
systempool  AKSUbuntu-2404gen2containerd-202604.07.0
usernodepool  AKSUbuntu-2404gen2arm64containerd-202604.07.0
```

Use the [az aks nodepool get-upgrades](/cli/azure/aks/nodepool#az-aks-nodepool-get-upgrades) command to determine the latest available node image version for a specific node pool.

```azurecli
az aks nodepool get-upgrades \
   --resource-group <ResourceGroupName> \
   --cluster-name <AKSClusterName> \
   --nodepool-name <NodePoolName> --output table
```

The following output shows the latest available node image versions for the node pool.

```output
Name    NodeImageVersion
------  -------------------------------------
system  AKSAzureLinux-V3gen2-202604.07.0
user    AKSAzureLinux-V3gen2arm64-202604.07.0
```

## Cluster upgrades

The Kubernetes community releases minor versions of Kubernetes approximately every three months. The [AKS release notes page](https://github.com/Azure/AKS/releases) is updated regularly with information about new AKS versions and releases. You can also subscribe to the [GitHub AKS RSS feed](https://github.com/Azure/AKS/releases.atom), which provides real-time updates about changes and enhancements.

AKS follows an *N - 2* support policy, which means that full support is provided for the latest release (*N*) and the two previous minor versions. Limited platform support is offered for the third prior minor version. For more information, see [Support policies for AKS](/azure/aks/support-policies).

Establish a continuous cluster upgrade process to ensure that your AKS clusters remain supported. This process involves testing new versions in lower environments and planning the upgrade to production before the new version becomes the default. This approach helps maintain predictability in your upgrade process and minimizes disruptions to applications. For more information, see [Upgrade options for AKS clusters](/azure/aks/upgrade-options).

If your cluster requires a longer upgrade cycle, use AKS versions that support the [long-term support (LTS) option](/azure/aks/supported-kubernetes-versions#long-term-support-lts). Every supported AKS Kubernetes version from 1.27 onward is eligible for 24-month LTS through the Premium tier. LTS provides a more prolonged and controlled upgrade cycle. It supports major version upgrades every 24 months instead of the standard 12-month cycle. To turn on LTS, use `--tier premium --k8s-support-plan AKSLongTermSupport`.

> [!NOTE]
> During the LTS window, only the last two patch versions are supported, and some extension compatibility constraints might apply. If you use LTS, consider pairing it with the `patch` cluster automatic-upgrade channel.

For more information, see [Supported Kubernetes versions in AKS](/azure/aks/supported-kubernetes-versions).

A cluster upgrade includes a node upgrade and uses a cordon and drain process.

### Before you upgrade

As a best practice, upgrade and test in lower environments to minimize the risk of disruption in production. Cluster upgrades require extra testing because they involve API changes, which can affect Kubernetes deployments. The following resources can assist you in the upgrade process.

- **AKS workbook for deprecated APIs:** From the cluster overview page in the Azure portal, select **Diagnose and solve problems**, go to the **Create, Upgrade, Delete and Scale** category, and then select **Kubernetes API deprecations**. This procedure runs a workbook that checks for deprecated API versions that your cluster still uses. For more information, see [Remove usage of deprecated APIs](/azure/aks/stop-cluster-upgrade-api-breaking-changes#remove-usage-of-deprecated-apis-recommended).

- [**AKS release notes page:**](https://github.com/Azure/AKS/releases) This page provides comprehensive information about new AKS versions and releases. Review these notes to stay informed about the latest updates and changes.

- [**Kubernetes release notes page:**](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG) This page provides detailed insights into the latest Kubernetes versions. Pay special attention to urgent upgrade notes. They highlight critical information that might affect your AKS cluster.

- [**AKS components breaking changes by version:**](/azure/aks/supported-kubernetes-versions#aks-components-breaking-changes-by-version) This table provides a comprehensive overview of breaking changes in AKS components by version. Proactively address any potential compatibility problems before the upgrade process by referring to this guide.

In addition to these Microsoft resources, consider using open-source tools to optimize your cluster upgrade process. For example, [Fairwinds pluto](https://pluto.docs.fairwinds.com) scans your deployments and Helm charts for deprecated Kubernetes APIs. Such tools can help you ensure that your applications remain compatible with the latest Kubernetes versions.

### Upgrade process

To check for cluster upgrades, use the [az aks get-upgrades](/cli/azure/aks#az-aks-get-upgrades) command to get a list of available upgrade versions for your AKS cluster. Determine the target version for your cluster from the results.

The following command shows available upgrade versions.

```azurecli
az aks get-upgrades \
   --resource-group <ResourceGroupName> --name <AKSClusterName> --output table
```

The following output shows the available Kubernetes upgrade versions for the cluster.

```output
MasterVersion  Upgrades
-------------  ---------------------------------
1.32.4         1.33.1, 1.33.2, 1.33.3
```

To find pools that require an upgrade, check the Kubernetes versions of the nodes in your node pools.

```azurecli
az aks nodepool list \
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --query "[].{Name:name,k8version:orchestratorVersion}" --output table
```

The following output shows the Kubernetes versions for each node pool.

```output
Name          K8version
------------  ------------
systempool    1.32.4
usernodepool  1.32.4
```

#### Manual upgrades

To minimize disruptions and help ensure a smooth upgrade for your AKS cluster, take this upgrade approach:

1. **Upgrade the AKS control plane.** Upgrade the control plane components that are responsible for managing and orchestrating your cluster. Upgrade the control plane first to help ensure compatibility and stability before you upgrade the individual node pools.

1. **Upgrade your system node pool.** After you upgrade the control plane, upgrade the system node pool in your AKS cluster. Node pools consist of the VM instances that run your application workloads. Upgrade node pools separately to maintain control and apply changes to the underlying infrastructure that supports your applications.

1. **Upgrade user node pools.** After you upgrade the system node pool, upgrade user node pools in your AKS cluster.

Follow this approach to minimize disruptions during the upgrade process and maintain the availability of your applications. Take the following steps:

1. Run the [az aks upgrade](/cli/azure/aks#az-aks-upgrade) command with the `--control-plane-only` flag to upgrade only the cluster control plane and not the cluster's node pools.

   ```azurecli
   az aks upgrade \
      --resource-group <ResourceGroupName> --name <AKSClusterName> \
      --control-plane-only \
      --kubernetes-version <KubernetesVersion>
   ```

1. Run the [az aks nodepool upgrade](/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-upgrade&preserve-view=true) command to upgrade node pools to the target version.

   ```azurecli
   az aks nodepool upgrade \
      --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> --name <NodePoolName> \
      --no-wait --kubernetes-version <KubernetesVersion>
   ```

   [During the node pool upgrade](/azure/aks/upgrade-cluster), AKS creates a surge node, cordons and drains pods in the node that's being upgraded, reimages the node, and then uncordons the pods. This process repeats for the other nodes in the node pool.

Check the status of the upgrade process by running `kubectl get events`.
For more information about troubleshooting cluster upgrade problems, see [AKS troubleshooting documentation](/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes).

## Enroll clusters in automatic-upgrade release channels

AKS also provides an [automatic cluster upgrade solution](/azure/aks/auto-upgrade-cluster) to keep your cluster up to date. If you use this solution, pair it with a [maintenance window](/azure/aks/planned-maintenance) to control the timing of upgrades. The upgrade window must be four hours or more.

When you enroll a cluster in a release channel, Microsoft automatically manages the version and upgrade cadence for the cluster and its node pools.

The cluster's automatic upgrade provides different release channel options. The following table shows a recommended environment and release channel configuration.

| Environment  | Upgrade channel    | Description     |
|-----|--------------------|------------|
| Production      | `stable`   | For stability and version maturity, use the stable or regular channel for production workloads.   |
| Staging, testing, development   | Same as production | Use the same release channel as production to ensure that your tests are indicative of the version that you're upgrading your production environment to.       |
| Canary       | `rapid` | Use the `rapid` channel to test the latest Kubernetes releases and new AKS features or APIs. Improve your time to market when the version in `rapid` is promoted to the channel that you use for production. |

You can enforce automatic-upgrade channel and node OS automatic-upgrade channel configurations across your workload by using [built-in Azure Policy definitions for AKS](/azure/aks/policy-reference). These policies can require clusters to use a specific automatic-upgrade channel, enforce node OS automatic-upgrade channels like `SecurityPatch` or `NodeImage`, and require planned maintenance windows.

### AKS Automatic

[AKS Automatic](/azure/aks/intro-aks-automatic) is a fully managed AKS experience where Azure handles cluster setup, node management, scaling, and upgrades automatically. AKS Automatic enforces automatic upgrade by default via the `stable` cluster channel and `NodeImage` node OS channel, uses node automatic provisioning for dynamic node provisioning, and includes deployment safeguards. If your workload needs an operating model that automatically handles most of the manual upgrade guidance in this article, consider AKS Automatic as an alternative.

### Multi-cluster upgrades with Azure Kubernetes Fleet Manager

For workloads that manage multiple AKS clusters, [Azure Kubernetes Fleet Manager](/azure/kubernetes-fleet/overview) provides orchestrated upgrade management across your entire fleet. Fleet Manager provides:

- **Staged update runs.** Define update stages, such as development, staging, and production, with configurable wait periods between stages.

- **Update groups and strategies.** Create reusable update strategies that define the order and timing of upgrades across cluster groups.

- **Automatic-upgrade profiles.** Configure fleet-level automatic-upgrade profiles that apply consistent upgrade policies across all member clusters.

You can use Fleet Manager to coordinate Kubernetes version and node image upgrades across multiple AKS clusters. For more information, see [Orchestrate updates across multiple AKS clusters by using Fleet Manager](/azure/kubernetes-fleet/update-orchestration).

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

- [Sam Cogan](https://www.linkedin.com/in/samcogan82/) | Senior Cloud Solution Architect
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
- [Node OS automatic upgrades FAQ](/azure/aks/auto-upgrade-node-os-image#node-os-autoupgrades-faq)
- [Azure Kubernetes Fleet Manager update orchestration](/azure/kubernetes-fleet/update-orchestration)
- [AKS Automatic overview](/azure/aks/intro-aks-automatic)
- [AKS production upgrade strategies](/azure/aks/upgrade-cluster#production-upgrade-strategies)
- [Deployment Safeguards](/azure/aks/deployment-safeguards)
- [Define day-2 operations](https://dzone.com/articles/defining-day-2-operations)
- [A practical guide for zone-redundant AKS clusters](https://techcommunity.microsoft.com/blog/fasttrackforazureblog/a-practical-guide-to-zone-redundant-aks-clusters-and-storage/4036254)

## Related resources

- [AKS day-2 operations guide](./day-2-operations-guide.md)
- [AKS triage practices](./aks-triage-practices.md)
