---
title: "Remediating assets prior to migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Remediating incompatible assets prior to migration
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Remediate assets prior to migration

During the assessment process of migration, the team seeks to identify any configurations that would make an asset incompatible with the chosen cloud provider. *Remediate* is a checkpoint in the migration process to ensure that those incompatibilities have been resolved. This article discusses a few common remediation tasks for reference. It also establishes a skeleton process for deciding whether remediation is a wise investment.

## Common remediation tasks

In any corporate environment, technical debt exists. Some of this is healthy and expected. Architecture decisions that were well suited for an on-premises environment may not be entirely suitable in a cloud platform. In either case, common remediation tasks may be required to prepare assets for migration. The following are a few examples:

- **Minor host upgrades.** Occasionally, an outdated host needs to be upgraded prior to replication.
- **Minor guest OS upgrades.** It is more likely that an OS will need patching or upgrading prior to replication.
- **SLA modifications.** Backup and recovery change significantly in a cloud platform. It is likely that assets will need minor modifications to their backup processes to ensure continued function in the cloud.
- **PaaS migration.** In some cases, a PaaS deployment of a data structure or application may be required to accelerate deployment. Minor modifications may be required to prepare the solution for PaaS deployment.
- **PaaS code changes.** It is not uncommon for custom applications to require minor code modifications to be PaaS ready. Examples could include methods that write to local disk or use of in-memory session state, among others.
- **Application configuration changes.** Migrated applications may require changes to variables, such as network paths to dependent assets, service account changes, or updates to dependent IP addresses.
- **Minor changes to network paths.** Routing patterns may need to be modified to properly route user traffic to the new assets.
    > [!NOTE]
    > This is not production routing to the new assets but is configuration to allow for proper routing to the assets in general.

## Large-scale remediation tasks

When a datacenter is properly maintained, patched, and updated, there is likely to be little need for remediation. Remediation-rich environments tend to be common among large enterprises, organizations that have been through large IT downsizing, some legacy managed service environments, and acquisition-rich environments. In each of these types of environments, remediation may consume a large portion of the migration effort. When the following remediation tasks frequently appear and are negatively affecting migration speed or consistency, it may be wise to break out remediation into a parallel effort and team (similar to how cloud adoption and cloud governance run in parallel).

- **Frequent host upgrades.** When large numbers of hosts must be upgraded to complete the migration of a workload, the migration team is likely to suffer from delays. It may be wise to break out affected applications and address the remediations prior to including affected applications in any planned releases.
- **Frequent guest OS upgrade.** Large enterprises commonly have servers running on outdated versions of Linux or Windows. Aside from the apparent security risks of operating an outdated OS, there are also incompatibility issues that prevent affected workloads from being migrated. When a large number of VMs require OS remediation, it may be wise to break out these efforts into a parallel iteration.
- **Major code changes.** Older custom applications may require significantly more modifications to prepare them for PaaS deployment. When this is the case, it may be wise to remove them from the migration backlog entirely, managing them in a wholly separate program.

## Decision framework

While remediation for smaller workloads can be straightforward, which is one of the reasons it's recommended you choose smaller workload for your initial migration. However, as your migration efforts mature and you begin to tackle larger workloads, remediation can be a time consuming and costly process. For example, remediation efforts for a Windows Server 2003 migration involving a 5,000+ VM pool of assets can delay a migration by months. When such large-scale remediation is required, the following questions can help guide decisions:

- Have all workloads affected by the remediation been identified and notated in the migration backlog?
- For workloads that are not affected, will a migration produce a similar return on investment (ROI)?
- Can the affected assets be remediated in alignment with the original migration timeline? What impact would timeline changes have on ROI?
- Is it economically feasible to remediate the assets in parallel with migration efforts?
- Is there sufficient bandwidth on staff to remediate and migrate? Should a partner be engaged to execute one or both tasks?

If these questions don't yield favorable answers, a few alternative approaches that move beyond a basic IaaS rehosting strategy may be worth considering:

- **Containerization.** Some assets can be hosted in a containerized environment without remediation. This could produce less-than-favorable performance and doesn't resolve security or compliance issues.
- **Automation.** Depending on the workload and remediation requirements, it may be more profitable to script the deployment to new assets using a DevOps approach.
- **Rebuild.** When remediation costs are very high and business value is equally high, a workload may be a good fit as a candidate for rebuilding or rearchitecting.

## Next steps

After remediation is complete, [replication activities](./replicate.md) are ready.

> [!div class="nextstepaction"]
> [Replicate assets](./replicate.md)
