---
title: Scalable Windows Virtual Machine Patch Management
description: Implement a patch management strategy for your workload's Windows virtual machines.
author: tedmanlee
ms.author: tel
ms.date: 07/09/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Scalable Windows virtual machine patch management

This article describes the recommended approach to operationalize operating system updates on Windows virtual machines (VMs) within your workload. This process delivers a consistent, scalable, and governed patch management solution across the fleet of Windows VMs in your workload. The approach allows you to validate updates in preproduction environments before promoting them to production.

Effective patch management extends beyond installing updates. A patch management strategy also requires consistent governance to ensure that virtual machines are onboarded to the patch management solution, configured according to workload standards, and continuously monitored for compliance.

> [!NOTE]
> This article focuses on Azure Virtual Machines. While Azure Update Manager also supports Arc-enabled servers, hybrid scenarios have additional considerations and aren't covered here.
> - For Virtual Machine Scale Sets, see [Azure Virtual Machine Scale Set automatic OS image upgrades](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-automatic-upgrade).

## Use Azure Update Manager

The recommended approach for managing Windows OS updates on Azure Windows Virtual Machines is to use Azure Update Manager. This service provides centralized scheduling, compliance reporting, and the ability to perform staged OS update deployments for your VMs. Azure Update Manager works through a sidecar Azure VM extension installed on each VM in your workload. Update Manager doesn't host or distribute patches itself. It's responsible for controlling and activating the native [Windows Update Agent (WUA)](/windows/win32/wua_sdk/portal-client) on each VM.

Azure Update Manager provides your workload team a central view of the patch status of virtual machines within your environment. You can set your patching targets and cadences, and support on-demand patch rollout.

> [!TIP]
> Azure Update Manager installs Windows updates by using the Windows Update Agent API. Because these updates bypass the Windows Update orchestrator workflow used by the Windows Settings app, they might not appear in *Settings* > *Windows Update* > *Update history*. This behavior is expected. To verify update installation, review the **WindowsUpdateClient** events in Windows Event Viewer.

## Azure resource organization

Azure Update Manager itself isn't an Azure resource. You don't deploy it into your workload's subscriptions. It's available in the Azure portal, and the user experience in the portal is RBAC-based and subscription agnostic. However, you maintain the maintenance configurations, what OS patches and when, and their association to your workload's VMs as Azure resources.

Each maintenance configuration can have a single schedule and can target any number of resources through associations. Maintenance configurations are regional resources. Use a single maintenance configuration and associations to include only virtual machines within the same region and same subscription. This approach means you have separate maintenance configuration resources for all environments, and potentially multiple per environment if your workload is multiregion or has different update schedules for different parts of your workload.

Maintain your maintenance configuration resources as part of your workload's IaC for that environment. This approach allows you to perform change control processes, safe deployment practices, and gives you a disaster recovery option.

## Virtual machine requirements

The Windows virtual machines must be a [supported custom or Azure Marketplace image](/azure/update-manager/support-matrix-updates). No matter the source, you need to configure the OS to support updates. The recommended way is through your virtual machine's IaC, which configures the required OS settings. Specifically, ensure your VMs have at least the following settings:

```bicep
windowsConfiguration: {
  provisionVMAgent: true
  enableAutomaticUpdates: true

  patchSettings: {
    patchMode: 'AutomaticByPlatform'  // Disables automatic updates in the OS; now platform triggers updates
    assessmentMode: 'AutomaticByPlatform' // Scans for missing updates every 24 hours

    automaticByPlatformSettings: {
      bypassPlatformSafetyChecksOnUserSchedule: true  // Allows Azure Update Management to honor defined schedules
      rebootSetting: 'IfRequired'  // Or 'Never' if required in your workload
    }
  }
}
```

The *Windows Guest Agent* installs a sidecar extension called [`Microsoft.CPlat.Core.WindowsPatchExtension`](/azure/update-manager/troubleshoot?tabs=azure-machines#windows-vm). This privileged extension runs on your VMs to get its schedule and update configuration. It also invokes the native Windows OS update APIs to perform the updates. You don't define this extension as part of your VM IaC. Update Manager automatically installs it and maintains its lifecycle.

The `WindowsPatchExtension` extension doesn't override the update source settings on the machine. This behavior means you're still responsible for configuring the update source for your VMs:

- the Windows Update repository (Windows OS + select drivers)
- the [Microsoft Update](/windows/win32/wua_sdk/opt-in-to-microsoft-update) repository (Windows OS + select drivers + select Microsoft products)
- if your organization still requires workloads to use one, a [Windows Server Update Services (WSUS)](/windows-server/administration/windows-server-update-services/get-started/windows-server-update-services-wsus) server *(now [deprecated](/windows-server/get-started/removed-deprecated-features-windows-server))*

For details on supported sources, see [Supported update sources, types, Microsoft application updates, and non-Microsoft updates](/azure/update-manager/support-matrix).

Enable automatic assessments so your [compliance reporting](#compliance-reporting) reflects current data. This feature lets you see where each VM stands against your patch baseline and spot newly disclosed exposures before the next scheduled run. Assessment covers only running VMs; stopped or deallocated VMs aren't scanned.

> [!IMPORTANT]
> Because Azure Update Manager directly invokes native Windows OS capability, it's important that OS settings remain properly configured to support patching.
>
> - Ensure Group Policy, Microsoft Intune, or other configuration management tools don't override the OS settings required for Azure Update Manager to function correctly on your virtual machines. For specific configuration values, see [Configure Windows Update Settings in Azure Update Manager](/azure/update-manager/configure-wu-agent).
> - OS level firewalls must not block update traffic.

### Policy enforcement

Your workload should also use Azure Policy to enforce that your VMs stay properly configured for Azure Update Manager. Apply the [built-in Azure Update Manager policies](/azure/governance/policy/samples/built-in-policies#azure-update-manager) as a configuration drift prevention mechanism. The built-in policies support DINE (DeployIfNotExists) and modify enforcement to automatically remediate noncompliant VMs.

For a policy-driven approach to patch management, see [Enable periodic assessment and scheduled patching on Azure VMs by using a policy](/azure/update-manager/tutorial-assessment-deployment-using-policy). Use this approach if your workload isn't using IaC to deploy and configure your VMs.

## Networking requirements

For Azure VMs with direct outbound internet access, Windows Update usually works without additional network allow-listing, provided the guest OS update source, DNS, proxy, TLS inspection, and local policy settings allow Windows Update/Microsoft Update traffic. Most workloads, however, operate in locked-down virtual networks with restricted outbound access. In these cases, you must permit traffic to Microsoft Update endpoints throughout all NSGs and firewalls you egress through.

### Network security groups (NSG)

Default update sources, including Windows Updates, are DNS based and don't publish stable static IP lists. For internet-hosted update sources, this condition means that your NSG attached to the virtual machine's NIC or its subnet must support internet egress traffic to TCP:443 and TCP:80. You should further restrict access from within your egress firewall. If your updates come from a static IP address range (such as an on-premises source), you should explicitly define that outbound destination in your NSGs.

### Egress firewall

Your egress firewall must allow traffic to the FQDNs used by your update source. If you're using Azure Firewall and a Microsoft-provided update source, use the [WindowsUpdate FQDN tag](/azure/firewall/fqdn-tags#current-fqdn-tags) to allow outbound access to Windows Update endpoints. For other egress firewalls in your network path, see [configure firewalls](/intune/configmgr/sum/plan-design/plan-for-software-updates#BKMK_ConfigureFirewalls). You should only allow this traffic originating from your Windows VMs and not unrelated subnets within your workload.

## Associate VMs with a maintenance configuration

While you can create static associations between a maintenance configuration and your VMs, use dynamic scoping instead. Dynamic scopes determine which VMs are associated with the maintenance configuration based on attributes such as resource group, location, and tags. The maintenance configuration, not the dynamic scope, defines which updates are installed and when. Dynamic scoping onboards matching new VMs without requiring you to manage per-VM configuration association resources.

When using dynamic scoping rules, follow these recommendations:

- Manage the dynamic scoping rules as IaC as part of your workload.
- Only include VMs from your environment to avoid cross-environment dependencies, duplicating configuration and dynamic scoping rules across environments as needed.
- Use tags as the primary driver and enforce their usage through Azure Policy.

## Design a staged patching schedule

A typical patching schedule for a workload uses staged deployment schedules. After Microsoft's monthly update release, first apply updates to development and test virtual machines. After validation, promote the same classification of updates to preproduction and then production in separate maintenance windows.

Create maintenance configurations to define the recurrence, maintenance window, update classifications, and reboot behavior. Then create your dynamic scoping association to target VMs within your workload to perform your routine patching schedule.

A *patch Tuesday* aligned schedule typically allows a few days for validation before production deployment. Since Microsoft's monthly security updates are generally released on the second Tuesday of each month, a suggested approach could be as follows. The target VMs are managed through a dynamic scoping rule using tags in this example.

| Environment | Schedule | VM resource tag | Updates | Reboot |
| :---------- | :------- | :-------------- | :------ | :----: |
| Development | Second Tuesday<br>2200-0000 | `PatchGroup`=`Backend` or `PatchGroup`=`Frontend` | Critical + Security | If required |
| Test | Second Wednesday<br>2200-0000 | `PatchGroup`=`Backend` or `PatchGroup`=`Frontend` | Critical + Security | If required |
| Production Backend (Wave 1) | Second Saturday<br>2200-0100 | `PatchGroup`=`Backend` | Critical + Security | If required |
| Production Frontend (Wave 2) | Following Sunday<br>2200-0100 | `PatchGroup`=`Frontend` | Critical + Security | If required |

### Handle update concurrency

A maintenance configuration starts updates on all associated VMs at the same time. Azure serializes reboots by update domain only for VMs in a common availability set. The *Backend* and *Frontend* waves in this example separate the schedule by tier, not by redundant capacity, so every instance in a tier could reboot together and drop that tier below its required capacity.

Within each production tier, split patching into capacity preserving waves that align to your availability zones, update domains, or workload-defined instance groups. Use a distinct tag value and maintenance configuration per wave.

### Consider rollout consistency

Update Manager performs a fresh assessment at each run. This means classification-based schedules can select different KBs in later waves. If each wave *must* install the exact validated update set, configure explicit KB inclusions instead of relying only on classifications.

This can be automated by using the Update Manager REST API to query the assessment results from the first wave and then update the maintenance configuration for subsequent waves.

The tradeoff you make to achieve complete wave consistency is significant orchestration complexity. If your workload can tolerate the risk of a later wave installing a different KB than the first wave, use the classification-based schedule.

### Reduce reboots with hotpatching

Reboots are often the most disruptive part of a patching schedule. They drive the maintenance window sizes and reboot behavior in the preceding table. On supported images, [hotpatching](/windows-server/get-started/hotpatch) installs Windows security updates by patching the in-memory code of running processes, so most months apply without a restart. Hotpatch is an extension of Windows Update, so Azure Update Manager installs hotpatches through the same maintenance configurations and dynamic scoping you use for your other VMs.

If your workload is sensitive to restarts, adopt an OS SKU and design that supports hotpatching:

- Hotpatch is available only on [specific Windows images](/windows-server/get-started/hotpatch#supported-platforms). You can't enable hotpatch on an arbitrary custom image.

- Only Windows security updates are hotpatched. Nonsecurity updates, .NET updates, and driver or firmware updates still require a reboot in the months when they're released. Quarterly hotpatch baselines and any unplanned baseline that Microsoft issues for a zero-day fix also require a reboot. Keep a maintenance window that can absorb a restart.

### Handle "before" and "after" concerns

 Azure Update Manager assesses and installs operating system updates, but a successful patching process might include activities before and after the maintenance window to gracefully handle required reboots or application-specific concerns. Update Manager provides [pre- and post-events](/azure/update-manager/pre-post-scripts-overview) that you use in your workload's automation. You add event handlers to your workload's architecture, such as an Azure Function, that respond to Azure Event Grid notifications before and after the scheduled patching run.

Use Update Manager's pre-patching activities to perform tasks such as:

- Start a stopped or deallocated VM. Stopped or deallocated VMs are not able to be patched and are skipped.
- Verify that backup recovery points are available.
- Validate virtual machine and application health.
- Temporarily suppress monitoring alerts to prevent false positives during the maintenance window.

After updates are installed, use post-patching activities to perform tasks such as:

- Restore monitoring.
- Perform application and service health checks.
- Post a notice to a Microsoft Teams channel.

Treat Azure Event Grid and your event handler compute as workload resources. Deploy them with IaC and isolate them between environments.

### Prepare for on-demand updates

Azure Update Manager supports on-demand patch installation outside of any scheduled maintenance window. This feature is useful for applying emergency patches, critical out-of-cycle fixes, or validating patch behavior on a single VM before a wider scheduled rollout. You can trigger on-demand updates directly from the Azure portal or the [Update Manager REST API](/azure/update-manager/manage-vms-programmatically) against one or more VMs simultaneously. As a workload team, establish guidelines for when to perform an out-of-band update and how that process is orchestrated across your workload.

### Roll back updates

Azure Update Manager doesn't provide OS patch rollback. After you apply patches, there's no built-in mechanism to uninstall them through Update Manager directly.

If your workload needs to support a "last known good" state, take a snapshot or recovery point before a maintenance run. Automate snapshot creation to run before each patching window to ensure a recovery point always exists before patches are applied. Alternatively, redeploy the VM without the patch, exclude the problematic KB patch from the deployment, and reapply the updates.

> [!IMPORTANT]
> Plan your recovery strategy before enabling scheduled patching in production.

## Compliance reporting

Update Manager pushes both assessment and patch installation results to Azure Resource Graph, which stores pending updates for 7 days and installation results for 30 days. Azure Update Manager includes built-in compliance reporting and management views that provide visibility into update status across your environment. These dashboards enable administrators to monitor patch compliance, identify machines requiring attention, and track update deployment progress from a central location.

The predefined workbooks surface key information across your workload:

- an overall summary of machine status and configuration
- a breakdown of pending updates by severity and classification
- a summary of schedules, maintenance configurations, and the machines attached to each schedule
- a historical view of past installation runs including success rates and any failures

Many organizations require their application teams to also provide compliance reporting. Ideally, your organization already uses Azure Update Manager for that tracking, because the Azure Update Manager portal experience and workbooks can operate across subscription boundaries, and you don't need to provide any custom patch status reporting in your workload.

If you or your organization needs custom reporting beyond the predefined views, workbooks are customizable. Include customized workbooks in your workload's IaC files to apply a change control process and provide a disaster recovery option. An alternative is to provide the required compliance reporting data through [Azure Resource Graph queries](/azure/update-manager/sample-query-logs).

If your workload must retain patch history longer than what Azure Resource Graph provides, build a process to export the data to a store that you control.

## Alternative approach

If you decide not to adopt the scheduled, staged Azure Update Manager approach for your workload, evaluate [automatic VM guest patching](/azure/virtual-machines/automatic-vm-guest-patching) before you design anything custom. With this option, Azure orchestrates patching for you. However, you give up the following if you choose it:

- **Staged rollout.** Updates aren't promoted through development, test, and production waves, so you lose validation gates.

- **Maintenance window control.** Azure decides when patching runs during off-peak hours in each VM's time zone.

- **Update classification control.** Only Critical and Security updates are applied. Other classifications aren't installed automatically.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Tedman Lee](https://www.linkedin.com/in/tedmanlee/) | Senior Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learn how Update Manager works](/azure/update-manager/workflow-update-manager)
- [Maintenance Configurations service limits](/azure/virtual-machines/maintenance-configurations#service-limits): Review the limits on schedules, resource associations, and dynamic scopes.
- [Schedule execution order with pre and post events](/azure/update-manager/pre-post-scripts-overview#schedule-execution-order-with-pre-and-post-events): Understand the timing windows and cancellation behavior for pre and post events so that you allow enough lead time around each maintenance window.
