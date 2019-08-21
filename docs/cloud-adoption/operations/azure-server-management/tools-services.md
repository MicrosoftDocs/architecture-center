---
title: "Azure server management tools and services"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Azure server management tools and services
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: operate
---

# Azure server management tools and services

As is discussed in the [overview](/azure/architecture/cloud-adoption/operations/azure-server-management/) of this section, the Azure server management services suite covers these areas:

- [Migrate](#migrate)
- [Secure](#secure)
- [Protect](#protect)
- [Monitor](#monitor)
- [Configure](#configure)
- [Govern](#govern)

The following sections briefly describe these management areas and provide links to detailed content about the main Azure services that support them.

## Migrate

Migration services can help you migrate your workloads into Azure. To provide the best guidance, the Azure Migrate service starts by measuring on-premises server performance and assessing suitability for migration. After Azure Migrate completes the assessment, you can use [Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview) and [Azure Database Migration Service](/azure/dms/dms-overview) to migrate your on-premises machines to Azure.

## Secure

[Azure Security Center](/azure/security-center/security-center-intro) is a comprehensive security management application. By onboarding to Security Center, you can quickly get an assessment of the security and regulatory compliance status of your environment. For instructions on onboarding your servers to Azure Security Center, see [Configure Azure management services for a subscription](./onboard-at-scale.md#azure-security-center).

## Protect

To protect your data, you need to plan for backup, high availability, encryption, authorization, and related operational issues. These topics are covered extensively online, so here we'll focus on building a Business Continuity Disaster Recovery (BCDR) plan. We'll include references to documentation that describes in detail how to implement and deploy this type of plan.

When you build data protection strategies, you should first consider breaking down your workload applications into their different tiers, because each tier typically requires its own unique protection plan. To learn more about designing applications to be resilient, see [Designing resilient applications for Azure](https://docs.microsoft.com/azure/architecture/resiliency).

The most basic data protection is backup. To speed up the recovery process in case of server loss, you should back up not just data but also server configurations. Backup is an effective mechanism to handle accidental data deletion and ransomware attacks. [Azure Backup](https://docs.microsoft.com/azure/backup) can help you protect your data on Azure and on-premises servers running Windows or Linux. For details about this service's capabilities and how-to guides, see the [Azure Backup documentation](https://docs.microsoft.com/azure/backup/backup-overview).

Recovery via backup can take a long time. The industry standard is usually one day. If a workload requires business continuity for hardware failures or datacenter outage, consider using data replication. [Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview) provides continuous replication of your VMs, a solution that provides bare-minimum data loss. Site Recovery also supports several replication scenarios, like replication of Azure VMs between two Azure regions, between servers on-premises, and between on-premises and Azure. For more information, see the [complete Azure Site Recovery replication matrix](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview#what-can-i-replicate).

For your file server data, another service to consider is [Azure File Sync](https://docs.microsoft.com/azure/storage/files/storage-sync-files-planning). This service allows you to centralize your organization's file shares in Azure Files while preserving the flexibility, performance, and compatibility of an on-premises file server. To use this service, follow the instructions for deploying Azure File Sync.

## Monitor

[Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/overview) provides a view into various resources, like applications, containers, and virtual machines. It also collects data from several sources.

- Azure Monitor for VMs ([insights](https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-overview)) provides an in-depth view of virtual machine health, performance trends, and dependencies. The service monitors the health of the operating systems of your Azure virtual machines, virtual machine scale sets, and machines in your on-premises environment.
- Log Analytics ([logs](https://docs.microsoft.com/azure/azure-monitor/platform/data-collection#logs)) is a feature of Azure Monitor. Its role is central to the overall Azure management story. It serves as the data store for log analysis and for many other Azure services. It offers a rich query language and an analytics engine that provides insights into the operation of your applications and resources.
- [Azure Activity Log](https://docs.microsoft.com/azure/azure-monitor/platform/activity-logs-overview) is also a feature of Azure Monitor. It provides insight into subscription-level events that occur in Azure.

## Configure

Several services fit into this category. They can help you to automate operational tasks, manage server configurations, measure update compliance, schedule updates, and detect changes to your servers. These services are core to supporting ongoing operations.

- [Update Management](https://docs.microsoft.com/azure/automation/automation-update-management#viewing-update-assessments) automates the deployment of patches across your environment, including deployment to operating system instances running outside of Azure. It supports both Windows and Linux operating systems and tracks key OS vulnerabilities and nonconformance caused by missing patches.
- [Change Tracking and Inventory](https://docs.microsoft.com/azure/automation/change-tracking) provides insight into the software that's running in your environment and surfaces any changes that have occurred.
- [Azure Automation](https://docs.microsoft.com/azure/automation/automation-intro) enables you to run Python and PowerShell scripts or runbooks to automate tasks across your environment. When you use it with the [Hybrid Runbook Worker](https://docs.microsoft.com/azure/automation/automation-hybrid-runbook-worker), you can extend your runbooks to your on-premises resources as well.
- [Azure Automation State Configuration](https://docs.microsoft.com/azure/automation/automation-dsc-overview) enables you to push PowerShell Desired State Configuration (DSC) configurations directly from Azure. In turn, DSC allows you to monitor and preserve in-guest operating system and workload configurations.

## Govern

Adopting and moving to the cloud creates new management challenges and requires a different mindset as you shift from an operational management burden to monitoring and governance. The Cloud Adoption Framework for Azure starts with [governance](https://docs.microsoft.com/azure/architecture/cloud-adoption/governance/overview). It explains how to migrate to the cloud, what the journey will look like, and who should be involved.

The governance design for small-to-medium businesses often differs from governance design for large enterprises. To learn more about governance best practices for a small or medium-sized business, see [Small-to-medium enterprise governance guide](https://docs.microsoft.com/azure/architecture/cloud-adoption/governance/journeys/small-to-medium-enterprise/overview). To learn more about governance best practices for a large enterprise, see [Large enterprise governance guide](https://docs.microsoft.com/azure/architecture/cloud-adoption/governance/journeys/large-enterprise/overview).

## Billing information

To learn about pricing for Azure management services, go to these pages:

- [Azure Site Recovery](https://azure.microsoft.com/pricing/details/site-recovery)

- [Azure Backup](https://azure.microsoft.com/pricing/details/backup)

- [Azure Monitor](https://azure.microsoft.com/pricing/details/monitor)

- [Azure Security Center](https://azure.microsoft.com/pricing/details/security-center)

- [Azure Update Management service](https://azure.microsoft.com/pricing/details/automation)

- [Azure Change Tracking and Inventory services](https://azure.microsoft.com/pricing/details/automation)

- [Desired State Configuration](https://azure.microsoft.com/pricing/details/automation)

- [Azure Automation service](https://azure.microsoft.com/pricing/details/automation)

- [Azure Policy](https://azure.microsoft.com/pricing/details/azure-policy)

- [Azure File Sync service](https://azure.microsoft.com/pricing/details/storage/blobs)

> [!NOTE]
> The Azure Update Management solution is free, but there's a small cost related to data ingestion. As a rule of thumb, the first 5 GB per month of data ingestion is free. We generally observe that each machine uses about 25 MB per month. So about 200 machines per month are covered for free. For each additional server, multiply the number of additional servers by 25 MB per month. Multiply that by the cost of storage for the total amount of storage needed. [Storage costs are available here](https://azure.microsoft.com/pricing/details/storage/). Each additional server should have a nominal impact on cost.
