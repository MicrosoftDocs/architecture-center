---
title: "Azure server management tools and services"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Azure server management tools and services
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Azure server management tools and services

As discussed in the [overview](/azure/architecture/cloud-adoption/operations/azure-server-management/) of this guidance, the Azure server management services suite covers the following areas:

- [Migrate](#migrate)
- [Secure](#secure)
- [Protect](#protect)
- [Monitor](#monitor)
- [Configure](#configure)
- [Govern](#governance)

The following sections briefly describe these different management areas and provide links to detailed content about the main Azure services that support them.

## Migrate

Migration services can help you migrate your workloads into Azure. In order to provide the best guidance, it starts with measuring on-premises server performance, and assesses migration suitability. Once the Azure Migrate service has completed the assessment, you can use [Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview) and [Azure Database Migration Service](/azure/dms/dms-overview) to migrate your on-premises machines to Azure.

## Secure

[Azure Security Center](/azure/security-center/security-center-intro) is a comprehensive security management application. By onboarding to Security Center, you can quickly get an assessment on the security and regulatory compliance status of your environment. Instructions for onboarding Azure Security Center to your servers is included in the article [Configure Azure management services for a subscription](./onboard-at-scale.md#azure-security-center) .

## Protect

Data protection requires planning around backup, high availability, encryption, authorization, and related operational issues. This topic has extensive existing coverage online, so this guidance will focus on building a Business Continuity Disaster Recovery (BCDR) plan. This section includes references to existing online documentation that describes in detail how to implement and deploy this type of plan.

When building data protection strategies, you should first consider breaking down your workload applications into their different tiers, since each tier typically requires its own unique protection plan. To learn more about designing applications to be resilient, see [Designing resilient applications for Azure](https://docs.microsoft.com/azure/architecture/resiliency).

The most basic data protection is backup. You should back up not only data but also server configurations to speed up the recovery process in case of server loss. Backup is an effective mechanism to handle accidental data deletion and ransomware attacks. [Azure Backup](https://docs.microsoft.com/azure/backup) can protect data on Azure and on-premises servers running Windows or Linux. You can see the details of this service's capabilities and how-to guides in the [Azure Backup documentation](https://docs.microsoft.com/azure/backup/backup-overview).

Recovery using backup can take a long time, and the industry standard is usually one day. If the workload requires business continuity for hardware failures or datacenter outage, you should consider using data replication. [Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview) provides continuous replication of your VMs&mdash;a solution that provides bare-minimum data loss. Site Recovery also supports a variety of replication scenarios, such as replication of Azure VMs between two Azure regions, between servers on-premises or between on-premises and Azure. To find more information, see the [complete Azure Site Recovery replication matrix](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview#what-can-i-replicate).

When it comes to your file server data, another service to consider is [Azure File Sync](https://docs.microsoft.com/azure/storage/files/storage-sync-files-planning). This service provides you with the ability to centralize your organization's file shares in Azure Files, while preserving the flexibility, performance, and compatibility of an on-premises file server. You can follow the instructions to deploy Azure File Sync to use this service.

## Monitor

[Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/overview) covers a variety of resources such as applications, containers, and virtual machines. It also collects data from several sources.

- Azure Monitor for VMs ([Insights](https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-overview)) provides an in-depth view of virtual machine health, performance trends, and dependencies. The service monitors the health of the operating system of your Azure virtual machines, virtual machine scale sets, and machines in your on-premises environment.
- Log Analytics ([Logs](https://docs.microsoft.com/azure/azure-monitor/platform/data-collection#logs)) is part of Azure Monitor and its role is central to the overall Azure management story. It serves as the data store for Log Analytics and numerous other Azure services. It offers a rich query language and analytics engine that provides insights into the operation of your applications and resources.
- [Azure Activity Log](https://docs.microsoft.com/azure/azure-monitor/platform/activity-logs-overview) is also part of Azure Monitor. It provides insight into subscription-level events that occur in Azure.

## Configure

Several services fit this category, and they can help you to automate operational tasks, manage server configurations, measure update compliance, schedule updates, and detect changes to your servers. These services are core to supporting ongoing operations.

- [Update Management](https://docs.microsoft.com/azure/automation/automation-update-management#viewing-update-assessments) automates the deployment of patches across your environment including instances running outside of Azure. It supports both Windows and Linux operating systems and tracks key OS vulnerabilities and nonconformance resulting from missing patches.
- [Change Tracking and Inventory](https://docs.microsoft.com/azure/automation/change-tracking) provides insight into the software that is running in your environment and surfaces any changes that have occurred.
- [Azure Automation](https://docs.microsoft.com/azure/automation/automation-intro) provides the ability to run Python and PowerShell scripts or runbooks to automate tasks across your environment. With the [Hybrid Runbook Worker](https://docs.microsoft.com/azure/automation/automation-hybrid-runbook-worker), it allows you to extend your runbooks to your on-premises resources as well.
- [Azure Automation State Configuration](https://docs.microsoft.com/azure/automation/automation-dsc-overview) provides the ability to push PowerShell Desired State Configurations (DSC) directly from Azure. In turn, DSC provides the ability to monitor and preserve in-guest operating system and workload configurations.

## Governance

Adopting and moving to the cloud creates new management challenges and requires a different mindset shifting from an operational management burden to monitoring and governance. The Cloud Adoption Framework starts with [governance](https://docs.microsoft.com/azure/architecture/cloud-adoption/governance/overview) and explains what, how, and who should be involved in the journey to the cloud.

The governance design for small-to-medium businesses often differs from governance design for large enterprises. To learn more about governance best practices for a small- or medium-sized business, see [Small-to-medium enterprise governance guide](https://docs.microsoft.com/azure/architecture/cloud-adoption/governance/journeys/small-to-medium-enterprise/overview). To learn more about the governance best practices for a large enterprise, see [Large enterprise governance guide](https://docs.microsoft.com/azure/architecture/cloud-adoption/governance/journeys/large-enterprise/overview).

## Billing information

Official pricing for Azure management services is listed below:

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
> While the Azure Update Management solution is free, there is a small cost related to data ingestion. As a rule of thumb, the first 5 GB (per month) of data ingestion is free. We generally observe that each machine uses about 25 MB per month, which covers about 200 machines for free per month. Additional server will cost about 10 cents each.
