---
title: "Fusion: What tools can help better manage asset configuration in Azure?"
description: Explanation of the tools that can facilitate improved asset configuration in Azure
author: BrianBlanchard
ms.date: 2/1/2019
---

<!-- markdownlint-disable MD026 -->

# What tools can help better manage asset configuration in Azure?

[Deployment Acceleration]](overview.md) is one of the [Five Disciplines of Cloud Governance](../governance-disciplines.md). This discipline focuses on ways of establishing policies to govern asset configuration or deployment. Within the five disciplines of Cloud Governance, configuration governance includes deployment, configuration alignment, and HA/DR strategies. This could be through manual activities or fully automated DevOps activities. In either case, the policies would remain largely the same.

Cloud custodians, cloud guardians, and cloud architects with an interest in governance are each likely to invest a lot of time in the Deployment Acceleration discipline, which codifies policies and requirementsacross multiple cloud adoption efforts. The tools in this toolchain are important to the Cloud Governance team and should be a high priority on the learning path for the team.

The following is a list of Azure tools that can help mature the policies and processes that support this governance discipline.

|  |Azure Policy  |Azure Management Groups  |Azure Resource Manager Templates  |Azure Blueprints  | Azure Resource Graph | Azure Cost Management |
|---------|---------|---------|---------|---------|---------|---------|
|Implement Corporate Policies     |Yes |No  |No  |No | No |No |
|Apply Policies across subscriptions     |Required |Yes  |No  |No | No |No |
|Deploy defined resources     |No |No  |Yes  |No | No |No |
|Create fully compliant environments      |Required |Required  |Required  |Yes | No |No |
|Audit Policies      |Yes |No  |No  |No | No |No |
|Query Azure resources      |No |No  |No  |No |Yes |No |
|Report on cost of resources      |No |No  |No  |No |No |Yes |

The following are additional tools that may be required to accomplish specific Deployment Acceleration objectives. Of times these tools are used outside of the governance team, but are still considered an aspect of Deployment Acceleration as a discipline.

|  |Azure Portal  |Azure Resource Manager Templates  |Azure Policy  | Azure DevOps | Azure Backup | Azure Site Recovery |
|---------|---------|---------|---------|---------|---------|---------|
|Manual deployment (single asset)     | Yes | Yes  | No  | Not efficiently | No | Yes |
|Manual deployment (full environment)     | Not efficiently | Yes | No  | Not efficiently | No | Yes |
|Automated deployment (full environment)     | No  | Yes  | No  | Yes  | No | Yes |
|Update configuration of a single asset     | Yes | Yes | Not efficiently | Not efficiently | No | Yes - during replication |
|Update configuration of a full environment     | Not efficiently | Yes | Yes | Yes  | No | Yes - during replication |
|Manage configuration drift     | Not efficiently | Not efficiently | Yes  | Yes  | No | Yes - during replication |
|Create an automated pipeline to deploy code and configure assets (DevOps)     | No | No | No | Yes | No | No |
|Recover data during an outage or SLA violation     | No | No | No | Yes | Yes | Yes |
|Recover applications and data during an outage or SLA violation     | No | No | No | Yes | No | Yes |

Aside from the Azure native tools mentioned above, it is very common for customers to use third-party tools to facilitate Deployment Acceleration and DevOps deployments.
