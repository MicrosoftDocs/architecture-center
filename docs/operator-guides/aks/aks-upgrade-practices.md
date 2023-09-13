---
title: AKS Day-2 - Patch and upgrade guidance
titleSuffix: Azure Architecture Center
description: Learn about day-2 patching and upgrading practices for Azure Kubernetes Service (AKS) worker nodes and Kubernetes (K8S) versions.
author: anevico
ms.date: 08/28/2023
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

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes patching and upgrading practices for AKS worker nodes and Kubernetes (K8S) versions.  As a cluster operator is crucial to have a strategy for keeping your clusters up to date, and monitoring Kubernetes API changes and depreciations over time.

## Background and Types of Updates

AKS Updates come in four forms:

1. Security patches to the OS of the node image (Linux only)
2. Weekly Updates to the [Node images](https://github.com/Azure/AKS/releases)
3. Weekly Updates to the [AKS release](https://github.com/Azure/AKS/releases)
4. Trimesterly [Kubernetes releases](https://kubernetes.io/releases/release/#the-release-cycle)

For Linux Nodes both [Ubuntu](https://ubuntu.com/server) and [Azure Linux](https://learn.microsoft.com/en-us/azure/azure-linux/intro-azure-linux), patches are scanned for and deployed nightly; however if a patch requires a reboot, this process is not automatic and must be managed. For Windows Nodes monthly patches are included in the node image builds.

The following table summarizes the details of updating each component:

|Component name|Frequency of upgrade|[Planned Maintenance Supported](https://learn.microsoft.com/en-us/azure/aks/planned-maintenance)|Supported operation methods|Documentation link|
|--|--|--|--|--|
|Security patches and hot fixes for node images|[As-necessary](https://learn.microsoft.com/en-us/azure/aks/concepts-vulnerability-management#worker-nodes)|Yes (Preview)|Automatic, Manual|[AKS Upgrades](https://learn.microsoft.com/en-us/azure/aks/upgrade)|
|Node image version upgrade|**Linux**: [weekly](https://releases.aks.azure.com/)<br>**Windows**: [monthly](https://releases.aks.azure.com/)|Yes|Automatic, Manual|[AKS node image upgrade](https://learn.microsoft.com/en-us/azure/aks/node-image-upgrade)|
|Cluster Kubernetes version upgrade to supported patch version|[Approximately weekly](https://releases.aks.azure.com/)|Yes|Automatic, Manual|[Upgrade an AKS cluster](https://learn.microsoft.com/en-us/azure/aks/upgrade-cluster?tabs=azure-cli)|
|Cluster Kubernetes version (minor) upgrade|[Roughly every three months](https://kubernetes.io/releases/)|Yes| Automatic, Manual|[Upgrade an AKS cluster](https://learn.microsoft.com/en-us/azure/aks/upgrade-cluster?tabs=azure-cli)|

### Managing the reboot process for Linux nodes

By default Linux nodes receive nightly security patches; however, if these security patches require a reboot (e.g., for a kernel patch) the reboot must be managed.  This can be accomplished automatically (recommended) by leveraging a solution like [Kured](https://learn.microsoft.com/en-us/azure/aks/node-updates-kured) or manually leveraging the Azure portal or [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-upgrade).

Kured can be deployed via [helm chart](https://github.com/kubereboot/charts/tree/main/charts/kured). Key considerations for configuration in this helm chart include:

- Configure the date/times Kured is allowed to reboot nodes by leveraging
  - [`configuration.rebootDays`] to specify days when kured is allowed to reboot nodes
  - Setting [`configuration.startTime`], [`configuration.endTime`], and [`configuration.timeZone`] to configure times Kured is allowed to reboot nodes
- Setting a [`configuration.notifyUrl`] to enable webhook based alerting of rebooting activities
- Consider adjusting [`configuration.drainTimeout`] and [`configurtation.lockTtl`] to customize locking and unlocking behaviors
- Consider enabling the Prometheus provider [`configuration.prometheusUrl`], [`metrics.create`], [`metrics.namespace`]
- If running mixed Windows and Linux clusters configure [`nodeSelector`] to restrict the daemonset to Linux only nodes.

Descriptions of the various Kured configuration options can be found [here](https://kured.dev/docs/configuration/)

### Managing the weekly updates to Node Images and AKS

Microsoft provides patches and new images for image nodes weekly.  An updated node image contains up-to-date OS security patches, kernel updates, Kubernetes security updates, updated versions of binaries like `kubelet`, and component version updates listed in the [release notes](https://github.com/Azure/AKS/releases).

The weekly update process can be managed automatically (recommended) by leveraging [GitHub Actions](https://learn.microsoft.com/en-us/azure/aks/node-upgrade-github-actions) or [AKS planned maintenance](https://learn.microsoft.com/en-us/azure/aks/auto-upgrade-node-image).  Timing for [AKS planned maintenance](https://learn.microsoft.com/en-us/azure/aks/auto-upgrade-node-image) can be controlled by configurated a [maintenance window](https://learn.microsoft.com/en-us/azure/aks/planned-maintenance) **(please note the maintenance window must be at least four hours long)**.

Alternatively the weekly process can be managed manually through the portal or command line.

#### Manual Node Update Process

You can leverage the [kubectl describe nodes](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) command to check the OS kernel version and the OS image version of the nodes in your cluster:

```kubectl
kubectl describe nodes <NodeName>
```

Sample output (truncated):

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

Use the Azure CLI [az aks nodepool list](https://learn.microsoft.com/en-us/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-list) command to check the current node image versions of the nodes in a cluster:

```azurecli
az aks nodepool list \
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --query "[].{Name:name,NodeImageVersion:nodeImageVersion}" --output table
```

Example output:

```output
Name       NodeImageVersion
---------  ---------------------------------------------
agentpool  AKSUbuntu-2204gen2containerd-202307.12.0
user       AKSUbuntu-2204gen2arm64containerd-202307.12.0
```

Use [az aks nodepool get-upgrades](https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-get-upgrades) to find out the latest available node image version:

```azurecli
az aks nodepool get-upgrades \
   --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> \
   --nodepool-name <NodePoolName> --output table
```

Sample output:

```output
KubernetesVersion    LatestNodeImageVersion                         Name     OsType    ResourceGroup
-------------------  ---------------------------------------------  -------  --------  ---------------
1.26.6               AKSUbuntu-2204gen2arm64containerd-202308.10.0  default  Linux     aks-demo
```

#### Windows vs. Linux Notes

Windows and Linux nodes have a different patching process.  By default, Linux nodes receive updates nightly, while Windows nodes receive patches through updates to the node image monthly after [patch Tuesday](https://msrc.microsoft.com/update-guide/).

To upgrade node pools to the latest node image version:

- [Upgrade AKS node images](https://learn.microsoft.com/en-us/azure/aks/node-image-upgrade)

## Cluster upgrades

### Background

The Kubernetes community releases minor K8S versions roughly every three months. The [AKS release notes page](https://github.com/Azure/AKS/releases) publishes information about new AKS versions and release, and you can also subscribe to the [GitHub AKS RSS feed](https://github.com/Azure/AKS/releases.atom) to help track changes.

AKS provides full support for "N - 2": (N (latest release) - 2 (minor versions)). and limited Platform support for "N - 3" details avaiable at [AKS Support Policy](https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#platform-support-policy).  It's important to establish a continuous cluster upgrade process to ensure that your AKS clusters don't go out of support.  As new version become available you should plan to test in a lower environments, and then upgrade production by the time the new version becomes the default.  This allows for predictability in your upgrade process and helps minimize the number of changes in your applications.  For customers requiring a longer upgrade cycle, starting with AKS 1.27 Microsoft offers a [Long Term Support option](https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#long-term-support-lts) providing support for Kubernetes version over a period of two years.

### Before you upgrade

As part of your cluster upgrade process you should review the [AKS Release Notes Page](https://github.com/Azure/AKS/releases), [Kubernetes release notes page](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG) (especially urgent upgrade notes), and [AKS Components Breaking Changes by Version](https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#aks-components-breaking-changes-by-version). You can also leverage open-source tools like [Pluto](https://github.com/FairwindsOps/pluto) to help scan your deployments/helm charts for depreciated K8s APIs.

### To minimize disruptions to workloads during an upgrade

- Ensure your deployments have a [pod disruption budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) defined PDBs ensure that there are a minimum number of replicas available for application to ensure functionality during a [disruption event](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- Check for avaiable computer and network limits in your subscription [az quota](https://learn.microsoft.com/en-us/cli/azure/quota/usage?view=azure-cli-latest#az-quota-usage-list)
- Check for available ip space in your node subnets
- Set up multiple environments.
- Plan and schedule maintenance windows.
- Leverage a higher surge upgrade value (reccomended up to 33% for production enviroments)[Custom Node Surge Values](https://learn.microsoft.com/en-us/azure/aks/upgrade-cluster?tabs=azure-cli#customize-node-surge-upgrade)

### Upgrade Process

To check when your cluster requires an upgrade, use [az aks get-upgrades](https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-get-upgrades) to get a list of available target upgrade versions for your AKS control plane. Determine the target version for your control plane from the results.

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
usernp181     1.26.6
```

#### Manually Upgrading

To minimize disruptions during an upgrade it's reccomended to first upgrade the AKS control plane first, and then upgrade the individual node pools.

1. Run the [az aks upgrade](https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-upgrade) command with the `--control-plane-only` flag to upgrade only the cluster control plane, and not any of the associated node pools:

   ```azurecli
   az aks upgrade \
      --resource-group <ResourceGroupName> --name <AKSClusterName> \
      --control-plane-only --no-wait \
      --kubernetes-version <KubernetesVersion>
   ```

2. Run [az aks nodepool upgrade](https://learn.microsoft.com/en-us/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-upgrade) to upgrade node pools to the target version:
[During the node pool upgrade](https://learn.microsoft.com/en-us/azure/aks/upgrade-cluster?tabs=azure-cli#upgrade-an-aks-cluster) AKS will create a surge node, [cordon and drain](https://learn.microsoft.com/en-us/azure/aks/concepts-security#cordon-and-drain) pods from the node to be upgraded, reimage the node, and then uncordon it.  This process then repeats for any nodes remaining in the node pool.

   ```azurecli
   az aks nodepool upgrade \
      --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> --name <NodePoolName> \
      --no-wait --kubernetes-version <KubernetesVersion>
   ```

You can check the status of the upgrade process by running `kubectl get events`
For troubleshooting cluster upgrade issues, see [Azure Kubernetes Troubleshooting Documentation](https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)

## Enroll clusters in auto-upgrade release channels

AKS also offers an [automatic cluster upgrade solution](https://learn.microsoft.com/en-us/azure/aks/auto-upgrade-cluster) to keep your cluster up to date.  If you chose to leverage this solution, you should pair it with a [maintaineince window](https://learn.microsoft.com/en-us/azure/aks/planned-maintenance) to control upgrade timing.  **Note upgrade window must be four hours or more**
When you enroll a cluster in a release channel, Microsoft automatically manages the version and upgrade cadence for the cluster and its node pools.

The cluster auto upgrade offers different release channel options. Below is a recommended enviroment and release channel configuration:


| Environment                     | Upgrade Channel    | Description                                                                                                                                                                                                                                            |
|---------------------------------|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Production                      | Stable             | For stability and version maturity, use the stable or regular channel for production workloads.                                                                                                                                                        |
| Staging, Testing, Development   | Same as production | To ensure your tests are indicative of the version your production will be upgraded to, use the same release channel as production.                                                                                                                    |
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


- It's possible that an OS security patch applied as part of a node image upgrade will install a later version of the kernel than creating a new cluster.
- Node pool scale up uses the model that is currently associated with the virtual machine scale set. The OS kernels upgrade when security patches are applied and the nodes reboot.
- Node pool scale-up uses the model that is associated with the virtual machine scale set at creation. The OS kernels upgrade when the security patches are applied and the nodes reboot.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Anthony Nevico](https://www.linkedin.com/in/anthonynevico/) | Principal Cloud Solution Architect

Reviewer:

 - [Ali Yousefi](https://www.linkedin.com/in/iamaliyousefi/) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS product documentation](https://learn.microsoft.com/en-us/azure/aks/)
- [AKS Roadmap](https://aka.ms/aks/roadmap)
- [AKS Landing Zone Accelerator](https://github.com/Azure/AKS-Landing-Zone-Accelerator)

## Related resources

- [Troubleshoot AKS Issues](https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)
- [AKS day-2 operations guide](https://learn.microsoft.com/en-us/azure/architecture/operator-guides/aks/day-2-operations-guide)
- [AKS Triage Practices](https://learn.microsoft.com/en-us/azure/architecture/operator-guides/aks/aks-triage-practices)
- [AKS Construction Set](https://github.com/Azure/Aks-Construction)
- [AKS Baseline Automation](https://github.com/Azure/aks-baseline-automation)
