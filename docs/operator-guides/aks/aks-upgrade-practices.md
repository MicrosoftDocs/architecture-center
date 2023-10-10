---
title: AKS Day-2 - Patch and upgrade guidance
titleSuffix: Azure Architecture Center
description: Learn about day-2 patching and upgrading practices for Azure Kubernetes Service (AKS) worker nodes and Kubernetes (K8S) versions.
author: aionic
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

# Azure Kubernetes Service patch and upgrade guidance

This section of the Azure Kubernetes Service (AKS) day-2 operations guide describes patching and upgrading practices for AKS worker nodes and Kubernetes (K8S) versions. As a cluster operator, it is crucial to have a strategy for keeping your clusters up to date and monitoring Kubernetes API changes and deprecations over time.

## Background and types of updates

There are four different forms of updates for Azure Kubernetes Service (AKS):

1. **Security patches to the operating system (OS) of the node image *(Linux only)*:** For Linux nodes, such as Ubuntu and Azure Linux, the OS checks for security patches on a nightly basis and applies security patches if available. However, if a patch requires a reboot, manual intervention is required to manage the reboot process. For more information, see [Security concepts for applications and clusters in Azure Kubernetes Service (AKS)](/azure/aks/concepts-security) and [Apply cluster upgrades and security patches with Azure Kubernetes Service](/training/modules/aks-cluster-upgrades-patches/).
1. **Weekly updates to the node images:** AKS provides weekly updates to the node images, ensuring that the latest security patches and bug fixes are incorporated. These updates help to maintain the overall stability and security of the cluster. For more information, see [AKS releases](https://github.com/Azure/AKS/releases).
1. **Weekly updates to the AKS release:** AKS releases are updated on a weekly basis to introduce new features, improvements, and bug fixes. These updates ensure that AKS users can benefit from the latest enhancements and bug resolutions. For more information, see [AKS releases](https://github.com/Azure/AKS/releases).
1. **Quarterly Kubernetes releases:** AKS follows a quarterly update schedule for [Kubernetes releases](https://kubernetes.io/releases/release/#the-release-cycle). These updates allow AKS users to take advantage of the latest Kubernetes features, enhancements, and bug fixes regularly. For more information, see [Supported Kubernetes versions in Azure Kubernetes Service (AKS)](/azure/aks/supported-kubernetes-versions).

For Linux nodes, both [Ubuntu](https://ubuntu.com/server) and [Azure Linux](/azure/azure-linux/intro-azure-linux), patches are scanned for and deployed nightly; however if a patch requires a reboot, this process isn't automatic and must be managed. For [Windows Nodes](/azure/aks/faq#windows-server-nodes) monthly patches are included in the node image builds, ensuring that the latest security updates are incorporated as part of the regular image provisioning process.

The following table summarizes the details of updating each component:

|Component name|Frequency of upgrade|[Planned Maintenance Supported](/azure/aks/planned-maintenance)|Supported operation methods|Documentation link|
|--|--|--|--|--|
|Security patches and hot fixes for node images|[As-necessary](/azure/aks/concepts-vulnerability-management#worker-nodes)|Yes (Preview)|Automatic, Manual|[AKS Upgrades](/azure/aks/upgrade)|
|Node image version upgrade|**Linux**: [weekly](https://releases.aks.azure.com/)<br>**Windows**: [monthly](https://releases.aks.azure.com/)|Yes|Automatic, Manual|[AKS node image upgrade](/azure/aks/node-image-upgrade)|
|Cluster Kubernetes version upgrade to supported patch version|[Approximately weekly](https://releases.aks.azure.com/)|Yes|Automatic, Manual|[Upgrade an AKS cluster](/azure/aks/upgrade-cluster?tabs=azure-cli)|
|Cluster Kubernetes version (minor) upgrade|[Roughly every three months](https://kubernetes.io/releases/)|Yes| Automatic, Manual|[Upgrade an AKS cluster](/azure/aks/upgrade-cluster?tabs=azure-cli)|

### Managing the reboot process for Linux nodes

By default Linux nodes receive nightly security patches; however, if these security patches require a reboot (for example, for a kernel patch) the reboot must be managed.  The reboot process can be accomplished automatically by using a solution like [Kured](/azure/aks/node-updates-kured) or manually by using the Azure portal or [Azure CLI](/cli/azure/aks/nodepool#az-aks-nodepool-upgrade).

Kured can be deployed via [helm chart](https://github.com/kubereboot/charts/tree/main/charts/kured). Key considerations for configuration in this helm chart include:

- Configure the date/times Kured is allowed to reboot nodes by applying
  - [`configuration.rebootDays`] to specify days when kured is allowed to reboot nodes
  - Setting [`configuration.startTime`], [`configuration.endTime`], and [`configuration.timeZone`] to configure times Kured is allowed to reboot nodes
- Setting a [`configuration.notifyUrl`] to enable webhook based alerting of rebooting activities
- Consider adjusting [`configuration.drainTimeout`] and [`configurtation.lockTtl`] to customize locking and unlocking behaviors
- Consider enabling the Prometheus provider [`configuration.prometheusUrl`], [`metrics.create`], [`metrics.namespace`]
- If running mixed Windows and Linux clusters configure [`nodeSelector`] to restrict the daemon set to Linux only nodes.

Descriptions of the various Kured configuration options can be found at [Kured Configuration](https://kured.dev/docs/configuration/).

### Managing the weekly updates to node images and AKS

Microsoft provides patches and new images for image nodes weekly.  An updated node image contains up-to-date OS security patches, kernel updates, Kubernetes security updates, updated versions of binaries like `kubelet`, and component version updates listed in the [release notes](https://github.com/Azure/AKS/releases).

The weekly update process can be managed automatically (recommended) by using [GitHub Actions](/azure/aks/node-upgrade-github-actions) or [AKS planned maintenance](/azure/aks/auto-upgrade-node-image). Timing for [AKS planned maintenance](/azure/aks/auto-upgrade-node-image) can be controlled by configuring a [maintenance window](/azure/aks/planned-maintenance). For more information, see [Use Planned Maintenance to schedule and control upgrades for your Azure Kubernetes Service (AKS) cluster](/azure/aks/planned-maintenance).

> [!NOTE]
> When using AKS planned maintenance for node OS auto-upgrade, use a maintenance window of four hours or more to ensure proper functionality.

Alternatively, the weekly process can be managed manually via the Azure portal, via Azure CLI using [az aks maintenance configuration](/azure/aks/maintenanceconfiguration?view=azure-cli-latest) commands, or via PowerShell using the [Get-AzAksMaintenanceConfiguration](/powershell/module/az.aks/get-azaksmaintenanceconfiguration) cmdlet.

#### Manual node update process

You can use the [kubectl describe nodes](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) command to check the OS kernel version and the OS image version of the nodes in your cluster:

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

Use the Azure CLI [az aks nodepool list](/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-list&preserve-view=true) command to check the current node image versions of the nodes in a cluster:

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

Use [az aks nodepool get-upgrades](/cli/azure/aks?view=azure-cli-latest#az-aks-get-upgrades&preserve-view=true) to find out the latest available node image version:

```azurecli
az aks nodepool get-upgrades \
   --resource-group <ResourceGroupName> \
   --cluster-name <AKSClusterName> \
   --nodepool-name <NodePoolName> --output table
```

Example output:

```output
KubernetesVersion    LatestNodeImageVersion                         Name     OsType    ResourceGroup
-------------------  ---------------------------------------------  -------  --------  ---------------
1.26.6               AKSUbuntu-2204gen2arm64containerd-202308.10.0  default  Linux     aks-demo
```

#### Windows vs. Linux nodes

You can use node image upgrades to streamline upgrades for both Windows and Linux node pools, but the processes differ slightly. Linux might receive daily security updates, but Windows Server nodes update by performing an AKS upgrade that deploys new nodes with the latest base Window Server image and patches. For more information, see [Patch and upgrade AKS worker nodes](/azure/architecture/operator-guides/aks/aks-upgrade-practices).

## Cluster upgrades

### Background

The Kubernetes community releases minor versions of Kubernetes approximately every three months. To keep you informed about new AKS versions and releases, the [AKS release notes page](https://github.com/Azure/AKS/releases) page is regularly updated. Additionally, you may subscribe to the [GitHub AKS RSS feed](https://github.com/Azure/AKS/releases.atom), which provides real-time updates about changes and enhancements.

Azure Kubernetes Service (AKS) follows a "N - 2" support policy, which means that full support is provided for the latest release (N) and up to two previous minor versions. Limited platform support is offered for the third previous minor version. For detailed information on the support policy, refer to the [AKS Support Policy(/azure/aks/support-policies).

To ensure that your AKS clusters remain supported, it's crucial to establish a continuous cluster upgrade process. This process involves testing new versions in lower environments and planning the upgrade to production before the new version becomes the default. By following this approach, you can maintain predictability in your upgrade process and minimize disruption to your applications. For more information, see [Upgrade an Azure Kubernetes Service (AKS) cluster](/azure/aks/upgrade-cluster).
For customers who require a longer upgrade cycle, Microsoft introduced a [Long Term Support (LTS) option](/azure/aks/supported-kubernetes-versions#long-term-support-lts) starting from AKS version 1.27. With the LTS option, Microsoft provides extended support for Kubernetes versions over a period of two years, allowing for a more prolonged and controlled upgrade cycle. For more information, see [Supported Kubernetes versions in Azure Kubernetes Service (AKS)](/azure/aks/supported-kubernetes-versions).

### Before you upgrade

Both cluster upgrades and node image upgrades require due diligence to ensure stability in production environments.  Cluster upgrades require additional testing as they often involve API changes which can impact Kubernetes deployments.

As part of your cluster upgrade process, it's essential to conduct a thorough review to ensure a smooth transition. The following resources can assist you in this process:

- **AKS Workbook for depreciated APIs** From the cluster overview page you can select "Diagnose and solve problems" and navigate to the [Create, Upgrade, Delete and Scale category, and select Kubernetes API deprecations](/azure/aks/upgrade-cluster?tabs=azure-cli#remove-usage-of-deprecated-apis-recommended).  This runs a workbook that checks for depreciated API versions in use in your cluster.

- **AKS release notes page**: The [AKS Release Notes](https://github.com/Azure/AKS/releases) page provides comprehensive information about new AKS versions and releases. It's crucial to review these notes to stay informed about the latest updates and changes.
- **Kubernetes release notes page**: The [Kubernetes release notes](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG) page offers detailed insights into the latest Kubernetes versions. Pay special attention to urgent upgrade notes, which highlight critical information that might impact your AKS cluster.
- **AKS components breaking changes by version**: The [AKS Components Breaking Changes by Version](/azure/aks/supported-kubernetes-versions#aks-components-breaking-changes-by-version) page provides a comprehensive overview of breaking changes in AKS components across different versions. By referring to this guide, you can proactively address any potential compatibility issues prior to or in conjunction with the upgrade process.

In addition to these Microsoft resources, consider using open-source tools to optimize your cluster upgrade process. One such tool is [Pluto](https://github.com/FairwindsOps/pluto), which can scan your deployments and Helm charts for deprecated Kubernetes APIs. These tools help ensure that your applications remain compatible with the latest Kubernetes versions.

### To minimize disruptions to workloads during an upgrade

To ensure the smooth operation of your AKS cluster during maintenance events and to optimize its performance, it's recommended to follow these best practices:

- **Define Pod Disruption Budgets (PDBs).** It's essential to set up [Pod Disruption Budgets](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) for your deployments. PDBs enforce a minimum number of available replicas for applications, ensuring their continuous functionality during [disruption events](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/). Pod Disruption Budgets help maintain the stability of your cluster during maintenance or node failures.
- **Check available compute and network limits.** Before performing any cluster upgrades or scaling operations, verify the available compute and network limits in your Azure subscription using the [az quota](/cli/azure/quota/usage?view=azure-cli-latest#az-quota-usage-list&preserve-view=true) command. This ensures that you don't encounter any capacity issues during these operations.
- **Check available IP space in node subnets.** It's important to monitor and ensure sufficient available IP address space in your node subnets. This prevents any IP address exhaustion issues when upgrading or scaling your cluster.
- **Set up multiple environments.** Establishing separate environments such as development, staging, and production is recommended. This allows you to test and validate changes in lower environments before rolling them out to the production environment.
- **Plan and schedule maintenance windows.**
- **Set higher surge upgrade values.** For production environments, it's recommended to use high [max surge](/azure/aks/upgrade-cluster#customize-node-surge-upgrade) upgrade values, up to 33%. These surge values help ensure that sufficient resources are provisioned during upgrade operations, minimizing any impact on application performance.

### Upgrade Process

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
usernp181     1.26.6
```

#### Manually upgrading

To minimize disruptions and ensure a smooth upgrade process for your AKS cluster, it's recommended to follow this upgrade approach:

- **Upgrade the AKS control plane first.** Begin by upgrading the AKS control plane. This involves upgrading the control plane components responsible for managing and orchestrating your cluster. Upgrading the control plane first helps ensure compatibility and stability before upgrading the individual node pools.
- **Then upgrade individual node pools.** After upgrading the control plane, proceed to upgrade the individual node pools in your AKS cluster. Node pools consist of the virtual machine instances running your application workloads. Upgrading the node pools separately allows for a controlled and systematic upgrade of the underlying infrastructure supporting your applications.

By following this approach, you can minimize disruptions during the upgrade process and maintain the availability of your applications.

1. Run the [az aks upgrade](/cli/azure/aks?view=azure-cli-latest#az-aks-upgrade&preserve-view=true) command with the `--control-plane-only` flag to upgrade only the cluster control plane, and not any of the cluster's node pools:

   ```azurecli
   az aks upgrade \
      --resource-group <ResourceGroupName> --name <AKSClusterName> \
      --control-plane-only --no-wait \
      --kubernetes-version <KubernetesVersion>
   ```

2. Run [az aks nodepool upgrade](/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-upgrade&preserve-view=true) to upgrade node pools to the target version:
[During the node pool upgrade](/azure/aks/upgrade-cluster?tabs=azure-cli#upgrade-an-aks-cluster) AKS creates a surge node, [cordon and drain](/azure/aks/concepts-security#cordon-and-drain) pods from the node to be upgraded, reimage the node, and then uncordon it.  This process then repeats for any nodes remaining in the node pool.

   ```azurecli
   az aks nodepool upgrade \
      --resource-group <ResourceGroupName> --cluster-name <AKSClusterName> --name <NodePoolName> \
      --no-wait --kubernetes-version <KubernetesVersion>
   ```

You can check the status of the upgrade process by running `kubectl get events`
For troubleshooting cluster upgrade issues, see [Azure Kubernetes Troubleshooting Documentation](/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)

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

Other contributors:

- [Paolo Salvatori](http://linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
- [Ali Yousefi](https://www.linkedin.com/in/iamaliyousefi/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS product documentation](/azure/aks/)
- [AKS Roadmap](https://aka.ms/aks/roadmap)
- [AKS Landing Zone Accelerator](https://github.com/Azure/AKS-Landing-Zone-Accelerator)

## Related resources

- [Troubleshoot AKS Issues](/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)
- [AKS day-2 operations guide](./day-2-operations-guide.md)
- [AKS Triage Practices](./aks-triage-practices.md)
- [AKS construction set](https://github.com/Azure/Aks-Construction)
- [AKS baseline automation](https://github.com/Azure/aks-baseline-automation)
- [Defining Day-2 Operations](https://dzone.com/articles/defining-day-2-operations)
