---
title: "Fusion: What tools can help better manage asset configuration in Azure?"
description: Explanation of the tools that can facilitate improved asset configuration in Azure
author: BrianBlanchard
ms.date: 12/11/2018
---

# Fusion: What tools can help better manage asset configuration in Azure?

In the [Intro to Cloud Governance](../overview.md), [Configuration Management](overview.md) is one of the five disciplines to Cloud Governance. This discipline focuses on ways of establishing policies to govern asset configuration or deployment. Within the five disciplines of Cloud Governance, configuration governance includes deployment, configuration alignment, and HA/DR strategies. This could be through manual activities or fully automated DevOps activities. In either case, the policies would remain largely the same.

Unlike the cloud-agnostic position throughout Fusion, this article is Azure specific. The following is a list of Azure native tools that can help mature the policies and processes that support this governance discipline.

|  |Azure Portal  |ARM Templates  |Azure Policy  | Azure DevOps | Azure Backup | Azure Site Recovery |
|---------|---------|---------|---------|---------|
|Manual deployment (single asset)     | Yes         | Yes         | No         | Not efficiently | No | Yes |
|Manual deployment (full environment)     | Not efficiently | Yes         | No         | Not efficiently | No | Yes |
|Automated deployment (full environment)     | No         | Yes         | No         | Yes         | No | Yes |
|Update configuration of a single asset     | Yes         | Yes         | Not efficiently         | Not efficiently | No | Yes - during replication |
|Update configuration of a full environment     | Not efficiently | Yes         | Yes         | Yes         | No | Yes - during replication |
|Manage configuration drift     | Not efficiently | Not efficiently | Yes         | Yes         | No | Yes - during replication |
|Create an automated pipeline to deploy code and configure assets (DevOps)     | No | No | No | Yes | No | No |
|Recover data during an outage or SLA violation     | No | No | No | Yes | Yes | Yes |
|Recover applications and data during an outage or SLA violation     | No | No | No | Yes | No | Yes |

Aside from the Azure native tools mentioned above, it is extremely common for customers to leverage 3rd party tools for facilitating configuration management and devops deployments.
