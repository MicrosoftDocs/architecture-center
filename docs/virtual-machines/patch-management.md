---
title: Scalable Windows Virtual Machine Patch Management
description: Learn about the recommended approach for operationalizing operating system updates on Windows virtual machines in your workload.
author: tedmanlee
ms.author: tel
ms.date: 08/10/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Scalable Windows virtual machine patch management

This article describes the recommended approach for operationalizing operating system updates on Windows virtual machines (VMs) in your workload. The recommended process provides a consistent, scalable, and governed patch management solution for the Windows VMs in your workload. It allows you to validate updates in preproduction environments before promoting them to production.

Effective patch management extends beyond installing updates. A patch management strategy also requires consistent governance to ensure that VMs are onboarded to the patch management solution, configured according to workload standards, and continuously monitored for compliance.

> [!NOTE]
> This article focuses on Azure Virtual Machines. Although Azure Update Manager also supports Azure Arc-enabled servers, hybrid scenarios involve additional considerations and aren't covered here.
>
> For information about Virtual Machine Scale Sets, see [Azure Virtual Machine Scale Set automatic OS image upgrades](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-automatic-upgrade).

## Azure Update Manager

The recommended approach for managing Windows OS updates on Azure Windows VMs is to use Update Manager. This service provides centralized scheduling and compliance reporting, and the ability to perform staged OS update deployments for your VMs. Update Manager works through a sidecar Azure VM extension that's installed on each VM in your workload. Update Manager doesn't host or distribute patches itself. It controls and activates the native [Windows Update Agent (WUA)](/windows/win32/wua_sdk/portal-client) on each VM.

Update Manager gives your workload team a central view of the patch status of VMs in your environment. You can set your patching targets and cadences, and enable on-demand patch rollout.

> [!TIP]
> Update Manager installs Windows updates by using the WUA API. Because these updates bypass the Windows Update orchestrator workflow that's used by Windows Settings, they might not appear in **Settings** > **Windows Update** > **Update history**. This behavior is expected. To verify update installation, review the **WindowsUpdateClient** events in Windows Event Viewer.

## Azure resource organization

Update Manager isn't an Azure resource. You don't deploy it into your workload's subscriptions. It's available in the Azure portal, and the experience in the portal is RBAC-based and subscription-agnostic. You maintain the maintenance configurations, what OS patches apply, when it patches, and the configurations' association to your workload's VMs as Azure resources.

Each maintenance configuration can have a single schedule and can target any number of resources via associations. Maintenance configurations are regional resources. Use a single maintenance configuration and set of associations to include only VMs within the same region and subscription. If you take this approach, you have separate maintenance configuration resources for all environments, and potentially more than one resource per environment if your workload is multiregion or has different update schedules for different parts of the workload.

Maintain your maintenance configuration resources as part of your workload's IaC for that environment. This approach allows you to perform change control processes and safe deployment practices, and gives you a disaster recovery option.

## VM requirements

The Windows VMs must use a [supported custom or Azure Marketplace image](/azure/update-manager/support-matrix-updates). Regardless of the source, you need to configure the OS to support updates. The recommended method is through your VM's IaC, which configures the required OS settings. Specifically, ensure your VMs have at least the following settings:

```bicep
windowsConfiguration: {
  provisionVMAgent: true
  enableAutomaticUpdates: true

  patchSettings: {
    patchMode: 'AutomaticByPlatform'  // Turns off automatic updates in the OS; now platform triggers updates
    assessmentMode: 'AutomaticByPlatform' // Scans for missing updates every 24 hours

    automaticByPlatformSettings: {
      bypassPlatformSafetyChecksOnUserSchedule: true  // Allows Azure Update Management to honor defined schedules
      rebootSetting: 'IfRequired'  // Or 'Never' if required in your workload
    }
  }
}
```

The *Windows Guest Agent* installs a sidecar extension called [`Microsoft.CPlat.Core.WindowsPatchExtension`](/azure/update-manager/troubleshoot?tabs=azure-machines#windows-vm). This privileged extension runs on your VMs to get its schedule and update configuration. It also invokes the native Windows OS update APIs to perform the updates. You don't define this extension as part of your VM IaC. Update Manager automatically installs it and maintains its lifecycle.

The `WindowsPatchExtension` extension doesn't override the update source settings on the machine. You're still responsible for configuring the update source for your VMs:

- The Windows Update repository (Windows OS and specific drivers)
- The [Microsoft Update](/windows/win32/wua_sdk/opt-in-to-microsoft-update) repository (Windows OS, specific drivers, and specific Microsoft products)
- If your organization still requires workloads to use one, a [Windows Server Update Services (WSUS)](/windows-server/administration/windows-server-update-services/get-started/windows-server-update-services-wsus) server (now [deprecated](/windows-server/get-started/removed-deprecated-features-windows-server))

For details on supported sources, see [Supported update sources, types, Microsoft application updates, and non-Microsoft updates](/azure/update-manager/support-matrix).

Enable automatic assessments so your [compliance reporting](#compliance-reporting) reflects current data. This feature shows the status of each VM with regard to your patch baseline and highlights newly disclosed exposures before the next scheduled run. Assessment covers only running VMs. Stopped or deallocated VMs aren't scanned.

> [!IMPORTANT]
> Because Update Manager directly invokes native Windows OS capability, it's important that OS settings remain properly configured to support patching.
>
> - Ensure that Group Policy, Microsoft Intune, or other configuration management tools don't override the OS settings required for Update Manager to function correctly on your VMs. For specific configuration values, see [Configure Windows Update Settings in Azure Update Manager](/azure/update-manager/configure-wu-agent).
> - OS-level firewalls must not block update traffic.

### Policy enforcement

Your workload should also use Azure Policy to enforce that your VMs stay properly configured for Update Manager. Apply the [built-in Azure Update Manager policies](/azure/governance/policy/samples/built-in-policies#azure-update-manager) to prevent configuration drift. The built-in policies support DINE (`deployIfNotExists`) and modify enforcement to automatically remediate noncompliant VMs.

For a policy-driven approach to patch management, see [Enable periodic assessment and scheduled patching on Azure VMs by using a policy](/azure/update-manager/tutorial-assessment-deployment-using-policy). Use this approach if your workload isn't using IaC to deploy and configure your VMs.

## Networking requirements

For Azure VMs with direct outbound internet access, Windows Update usually works without additional network allow-listing, provided the guest OS update source, DNS, proxy, TLS inspection, and local policy settings allow Windows Update/Microsoft Update traffic. Most workloads, however, operate in locked-down virtual networks with restricted outbound access. In these cases, you must permit traffic to Microsoft Update endpoints throughout all network security groups and firewalls you egress through.

### Network security groups

Default update sources, including Windows Update, are DNS based and don't publish stable static IP lists. Therefore, for internet-hosted update sources, a network security group attached to the VM's NIC or its subnet must support internet egress traffic to TCP:443 and TCP:80. You should further restrict access from within your egress firewall. If your updates come from a static IP address range (such as an on-premises source), you should explicitly define that outbound destination in your network security group.

### Egress firewall

Your egress firewall must allow traffic to the FQDNs used by your update source. If you use Azure Firewall and a Microsoft-provided update source, use the [WindowsUpdate FQDN tag](/azure/firewall/fqdn-tags#current-fqdn-tags) to allow outbound access to Windows Update endpoints. For information about configuring other egress firewalls in your network path, see [Configure firewalls](/intune/configmgr/sum/plan-design/plan-for-software-updates#BKMK_ConfigureFirewalls). You should allow this traffic only when it originates from your Windows VMs, not from unrelated subnets in your workload.

## Associate VMs with a maintenance configuration

Although you can create static associations between a maintenance configuration and your VMs, use dynamic scoping instead. Dynamic scopes determine which VMs are associated with the maintenance configuration based on attributes such as resource group, location, and tags. The maintenance configuration, not the dynamic scope, defines which updates are installed and when they're installed. Dynamic scoping onboards matching new VMs without requiring you to manage per-VM configuration association resources.

When you use dynamic scoping rules, follow these recommendations:

- Manage the dynamic scoping rules in IaC as part of your workload.
- To avoid cross-environment dependencies, only include VMs from your environment, duplicating configuration and dynamic scoping rules across environments as needed.
- Use tags as the primary mechanism for association and enforce their usage by using Azure Policy.

## Design a staged patching schedule

A typical patching schedule for a workload uses staged deployment schedules. After the monthly Microsoft update release, first apply updates to development and test VMs. After you validate these updates, promote the same classification of updates to preproduction and then production in separate maintenance windows.

Create maintenance configurations to define the recurrence, maintenance window, update classifications, and reboot behavior. Then create your dynamic scoping association to target VMs in your workload to perform your routine patching schedule.

A *patch Tuesday*-aligned schedule typically allows a few days for validation before production deployment. Because Microsoft monthly security updates are generally released on the second Tuesday of each month, a suggested approach might be as follows. In this example, the target VMs are managed through a dynamic scoping rule that uses tags.

| Environment | Schedule | VM resource tag | Updates | Reboot |
| :---------- | :------- | :-------------- | :------ | :----: |
| Development | Second Tuesday<br>2200-0000 | `PatchGroup`=`Backend` or `PatchGroup`=`Frontend` | Critical + Security | If required |
| Test | Second Wednesday<br>2200-0000 | `PatchGroup`=`Backend` or `PatchGroup`=`Frontend` | Critical + Security | If required |
| Production Backend (Wave 1) | Second Saturday<br>2200-0100 | `PatchGroup`=`Backend` | Critical + Security | If required |
| Production Frontend (Wave 2) | Following Sunday<br>2200-0100 | `PatchGroup`=`Frontend` | Critical + Security | If required |

### Handle update concurrency

A maintenance configuration starts updates on all associated VMs at the same time. Azure serializes reboots by update domain only for VMs in a common availability set. The *Backend* and *Frontend* waves in this example separate the schedule by tier, not by redundant capacity, so every instance in a tier could reboot together and drop that tier below its required capacity.

Within each production tier, split patching into capacity-preserving waves that align to your availability zones, update domains, or workload-defined instance groups. Use a distinct tag value and maintenance configuration per wave.

### Consider rollout consistency

Update Manager performs a fresh assessment at each run. Classification-based schedules can therefore select update packages associated with a different Knowledge Base (KB) article in later waves. If each wave *must* install the exact validated update set, configure explicit KB inclusions instead of relying only on classifications.

You can automate this configuration by using the Update Manager REST API to query the assessment results from the first wave and then update the maintenance configuration for subsequent waves.

The tradeoff you make to achieve complete wave consistency is significant orchestration complexity. If your workload can tolerate the risk of a later wave installing a different update package than the first wave, use the classification-based schedule.

### Reduce reboots with hotpatching

Reboots are often the most disruptive part of a patching schedule. They determine the maintenance window sizes and reboot behavior in the preceding table. On supported images, [hotpatching](/windows-server/get-started/hotpatch) installs Windows security updates by patching the in-memory code of running processes, so updates for most months apply without a restart. Hotpatch is an extension of Windows Update, so Update Manager installs hotpatches by using the same maintenance configurations and dynamic scoping that you use for your other VMs.

If your workload is sensitive to restarts, adopt an OS SKU and design that supports hotpatching:

- Hotpatch is available only on [specific Windows images](/windows-server/get-started/hotpatch#supported-platforms). You can't enable hotpatch on an arbitrary custom image.
- Only Windows security updates are hotpatched. Nonsecurity updates, .NET updates, and driver or firmware updates still require a reboot in the months when they're released. Quarterly hotpatch baselines and any unplanned baseline that Microsoft issues for a zero-day fix also require a reboot. Keep a maintenance window that can absorb a restart.

### Handle "before" and "after" concerns

Update Manager assesses and installs operating system updates, but a successful patching process might include activities before and after the maintenance window to gracefully handle required reboots or application-specific concerns. Update Manager provides [pre-events and post-events](/azure/update-manager/pre-post-scripts-overview) that you can use in your workload's automation. You add an event handler, like an Azure function, to your workload's architecture. The event handler responds to Azure Event Grid notifications before and after the scheduled patching run.

Use Update Manager pre-patching activities to perform tasks like these:

- Start a stopped or deallocated VM. Stopped or deallocated VMs can't be patched and are skipped.
- Verify that backup recovery points are available.
- Validate VM and application health.
- Temporarily suppress monitoring alerts to prevent false positives during the maintenance window.

After updates are installed, use post-patching activities to perform tasks like these:

- Restore monitoring.
- Perform application and service health checks.
- Post a notice to a Microsoft Teams channel.

Treat Event Grid and your event handler compute as workload resources. Deploy them with IaC and isolate them between environments.

### Prepare for on-demand updates

Update Manager supports on-demand patch installation outside of any scheduled maintenance window. This feature is useful for applying emergency patches or critical out-of-cycle fixes, or for validating patch behavior on a single VM before a wider scheduled rollout. You can trigger on-demand updates directly from the Azure portal or the [Update Manager REST API](/azure/update-manager/manage-vms-programmatically) against one or more VMs simultaneously. The workload team should establish guidelines for when to perform an out-of-band update and how that process is orchestrated across your workload.

### Roll back updates

Update Manager doesn't provide OS patch rollback. After you apply patches, there's no built-in mechanism to uninstall them directly through Update Manager.

If your workload needs to support a "last known good" state, create a snapshot or recovery point before a maintenance run. Automate snapshot creation to run before each patching window to ensure a recovery point always exists before patches are applied. Alternatively, redeploy the VM without the patch, exclude the problematic KB patch from the deployment, and reapply the updates.

> [!IMPORTANT]
> Plan your recovery strategy before you enable scheduled patching in production.

## Compliance reporting

Update Manager pushes both assessment and patch installation results to Azure Resource Graph, which stores pending updates for 7 days and installation results for 30 days. Update Manager includes built-in compliance reporting and management views that provide visibility into update status across your environment. These dashboards enable administrators to monitor patch compliance, identify machines that require attention, and track update deployment progress from a central location.

The predefined workbooks surface key information across your workload:

- An overall summary of machine status and configuration
- A breakdown of pending updates by severity and classification
- A summary of schedules, maintenance configurations, and the machines attached to each schedule
- A historical view of past installation runs, including success rates and any failures

Many organizations require their application teams to provide compliance reporting. Ideally, your organization already uses Update Manager for that tracking, because the Update Manager portal experience and workbooks can operate across subscription boundaries, and you don't need to provide any custom patch status reporting in your workload.

If you or your organization needs custom reporting beyond the predefined views, you can customize workbooks. Include customized workbooks in your workload's IaC files to apply a change control process and provide a disaster recovery option. An alternative is to provide the required compliance reporting data through [Resource Graph queries](/azure/update-manager/sample-query-logs).

If your workload must retain patch history for a longer time than Resource Graph retains it, build a process to export the data to a store that you control.

## Alternative approach

If you decide not to adopt the scheduled, staged Update Manager approach for your workload, evaluate [automatic VM guest patching](/azure/virtual-machines/automatic-vm-guest-patching) before you design a custom solution. If you use this option, Azure orchestrates patching for you. However, you give up the following benefits if you use this approach:

- **Staged rollout.** Updates aren't promoted through development, test, and production waves, so you lose validation gates.
- **Maintenance window control.** Azure determines when patching runs during off-peak hours in each VM's time zone.
- **Update classification control.** Only Critical and Security updates are applied. Other updates aren't installed automatically.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Tedman Lee](https://www.linkedin.com/in/tedmanlee/) | Senior Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learn how Update Manager works](/azure/update-manager/workflow-update-manager).
- [Maintenance Configurations service limits](/azure/virtual-machines/maintenance-configurations#service-limits): Review the limits on schedules, resource associations, and dynamic scopes.
- [Schedule execution order with pre and post events](/azure/update-manager/pre-post-scripts-overview#schedule-execution-order-with-pre-and-post-events): Understand the timing windows and cancellation behavior for pre-events and post-events so that you allow enough lead time around each maintenance window.
