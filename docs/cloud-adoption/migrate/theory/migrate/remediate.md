---
title: "Fusion: Remediating assets prior to migration"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: Remediating assets prior to migration
  
During the [Assess activities](assess.md) of [Migration Execution](overview.md), a number of potential incompatibilities may have been identified. Remediate is a checkpoint in the migration process to ensure those incompatibilities wisely. This article will discuss a few common remediation tasks for reference. This article will also establish a skeleton process for deciding if remediation is a wise investment.

## Common Remediation Tasks

In any corporate environment technical debt exists, some of this is healthy and expected. Architecture decisions that were well suited for an on-prem environment, may not be entirely suitable in a cloud platform. In either case, common remediation tasks may be required to prepare assets for migration. The following are a few examples:

* Minor host upgrades: Occasionally, an outdated host will need to be upgraded prior to replication.
* Minor Guest OS upgrades: It is more likely that an OS will need patching or upgrading prior to replication.
* SLA modifications: Backup and recovery change significantly in a cloud platform. It is likely that assets will need minor modifications to their backup processes to ensure continued function in the cloud.
* PaaS (Platform as a Service) migration: In some cases, a PaaS deployment of a data structure or application may be required to accelerate deployment. Minor modifications may be required to prepare the solution for PaaS deployment.
* PaaS code changes: It is not uncommon for custom applications to require minor code modifications to PaaS ready. Examples could include methods that right to local disk, use of In-Memory session state, etc...
* Application configuration changes: The migrated application may require changes to variables, such as, network paths to dependent assets, service account changes, or updates to dependent IP addresses.
* Minor changes to network paths: Routing patterns may need to be modified to properly route user traffic to the new assets. Note: This is not production routing to the new assets, but configuration to allow for proper routing to the assets in general.

## Large Scale Remediation Tasks

When a DataCenter is properly maintained, patched, and updated, there is likely to be little need for remediation. Remediation rich environments tend to be common amongst large enterprises, organizations that have been through large IT downsizing, some legacy managed service environments, &/or acquisition rich environments. In each of these types of environments remediation may consume a large portion of the migration effort. When the following remediation tasks frequently appear and are impacting migration speed/consistency, it may be wise to break remediation out into a parallel effort/team (similar to how Cloud Adoption and Cloud Governance run in parallel).

* Frequent Host upgrades: When large numbers of Hosts must be upgraded to complete the migration of an application, the migration team is likely to suffer from delays. It may be wise to break out impacted applications & address the remediations prior to including impacted applications in any planned releases.
* Frequent Guest OS upgrades: Large enterprises commonly have a number of servers running on out-dated versions of linux or windows. Aside from the apparent security risks of operating an outdated OS, there are also incompatibility issues that prevent impacted applications from being migrated. When a large number of VMs require OS remediation, it may be wise to break out these efforts into a parallel iteration.
* Major code changes: Older custom applications may require significantly more modifications to prepare them for PaaS deployment. When this is the case, it may be wise to remove them from the migration backlog entirely, managing them in a wholly separate program.

## Decision framework

Remediation is time-consuming and can be costly. Completing a Windows Server 2003 upgrade across 5,000+ VM pool of assets can delay the migration of applications by months. When such Large Scale Remediation is required the following questions can help guide decisions:

* Have all applications impacted by the remediation been identified and notated in the Migration Backlog?
* Of the applications that are not impacted, will a migration produce a similar ROI (Return on Investment)?
* Can the impacted assets be remediated in alignment with the original migration timeline? What impact would timeline changes have on ROI (Return on Investment)?
* Is it economically feasible to remediate the assets in parallel to migration effort?
* Is there sufficient bandwidth on staff to remediate and migrate? Should a partner be engaged to execute one or both tasks?

If these questions don't produce favorable answers, a few alternative approaches may be worth considering:

* Containerization: Some assets can be hosted in a containerized environment without remediation. This could produce less than favorable performance (& doesn't resolve security or compliance issues)
* Automation: Depending on the application and remediation requirements, it may be more profitable to script the deployment to new assets using a DevOps approach
* Rebuild: When remediation costs are very high and business value is equally high, an application may be a good fit as a candidate for rebuilding or re-architecting the solution.

## Next steps

Once remediation is complete, [Replication activities](replicate.md) are ready.

> [!div class="nextstepaction"]
> [Replicate assets](replicate.md)