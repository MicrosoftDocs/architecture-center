---
title: "Deployment Acceleration tools in Azure"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Deployment Acceleration tools in Azure
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

# Deployment Acceleration tools in Azure

[Deployment Acceleration](index.md) is one of the [Five Disciplines of Cloud Governance](../governance-disciplines.md). This discipline focuses on ways of establishing policies to govern asset configuration or deployment. Within the Five Disciplines of Cloud Governance, the Deployment Acceleration discipline involves deployment and configuration alignment. This could be through manual activities or fully automated DevOps activities. In either case, the policies involved would remain largely the same.

Cloud custodians, cloud guardians, and cloud architects with an interest in governance are each likely to invest a lot of time in the Deployment Acceleration discipline, which codifies policies and requirements across multiple cloud adoption efforts. The tools in this toolchain are important to the cloud governance team and should be a high priority on the learning path for the team.

The following is a list of Azure tools that can help mature the policies and processes that support this governance discipline.

|  | [Azure Policy](/azure/governance/policy/overview) | [Azure Management Groups](/azure/governance/management-groups) | [Azure Resource Manager](/azure/azure-resource-manager/resource-group-overview) | [Azure Blueprints](/azure/governance/blueprints/overview) | [Azure Resource Graph](/azure/governance/resource-graph/overview) | [Azure Cost Management](/azure/cost-management) |
|---------|---------|---------|---------|---------|---------|---------|
|Implement corporate policies     |Yes |No  |No  |No | No |No |
|Apply policies across subscriptions     |Required |Yes  |No  |No | No |No |
|Deploy defined resources     |No |No  |Yes  |No | No |No |
|Create fully compliant environments      |Required |Required  |Required  |Yes | No |No |
|Audit policies      |Yes |No  |No  |No | No |No |
|Query Azure resources      |No |No  |No  |No |Yes |No |
|Report on cost of resources      |No |No  |No  |No |No |Yes |

The following are additional tools that may be required to accomplish specific Deployment Acceleration objectives. Often these tools are used outside of the governance team, but are still considered an aspect of Deployment Acceleration as a discipline.

|  | [Azure portal](https://azure.microsoft.com/features/azure-portal)  | [Azure Resource Manager](/azure/azure-resource-manager/resource-group-overview)  | [Azure Policy](/azure/governance/policy/overview) | [Azure DevOps](/azure/devops/index) | [Azure Backup](/azure/backup/backup-introduction-to-azure-backup) | [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) |
|---------|---------|---------|---------|---------|---------|---------|
|Manual deployment (single asset)     | Yes | Yes  | No  | Not efficiently | No | Yes |
|Manual deployment (full environment)     | Not efficiently | Yes | No  | Not efficiently | No | Yes |
|Automated deployment (full environment)     | No  | Yes  | No  | Yes  | No | Yes |
|Update configuration of a single asset     | Yes | Yes | Not efficiently | Not efficiently | No | Yes - during replication |
|Update configuration of a full environment     | Not efficiently | Yes | Yes | Yes  | No | Yes - during replication |
|Manage configuration drift     | Not efficiently | Not efficiently | Yes  | Yes  | No | Yes - during replication |
|Create an automated pipeline to deploy code and configure assets (DevOps)     | No | No | No | Yes | No | No |

Aside from the Azure native tools mentioned above, it is common for customers to use third-party tools to facilitate Deployment Acceleration and DevOps deployments.
