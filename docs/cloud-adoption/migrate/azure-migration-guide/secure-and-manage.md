---
title: "Secure and Manage"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Secure and Manage
author: matticusau
ms.author: mlavery
ms.date: 04/04/2019
ms.topic: conceptual
ms.service: cloud-adoption-framework
ms.subservice: migrate
ms.custom: fasttrack-new, AQC
ms.localizationpriority: high
---

# Secure and manage

After migrating your environment to Azure, it's important to consider the security and methods used to manage the environment. Azure provides many features and capabilities to meet these needs in your solution.

# [Azure Monitor](#tab/monitor)

Azure Monitor maximizes the availability and performance of your applications by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing and proactively identifies issues affecting them and the resources they depend on.

## Use and configure Azure Monitor

1. Go to **Monitor** in the Azure portal.
2. Select **Metrics**, **Logs**, or **Service Health** for overviews.
3. Select any of the relevant insights.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/overview]" submitText="Go to Azure Monitor" :::

::: zone-end

::: zone target="docs"

## Read more

- [Azure Monitor overview](/azure/azure-monitor/overview).

::: zone-end

# [Azure Service Health](#tab/servicehealth)

Azure Service Health provides personalized guidance and support when issues in Azure services affect you. It can notify you, help you understand the impact of issues, and keep you updated as the issue resolves. It can also help you prepare for planned maintenance and changes that could affect the availability of your resources.

Azure Service Health includes:

- **Azure Status:** A global view of the health of Azure services.
- **Service Health:** A personalized view of the health of your Azure services.
- **Resource Health:** A deeper view of the health of the individual resources provisioned to you by your Azure services.

Combined, these experiences give you a comprehensive view of Azure health, at a level of detail relevant to you.

## Access Service Health

1. Go to **Monitor** in the Azure portal.
2. Select **Service Health**.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Health/AzureHealthBrowseBlade/serviceIssues]" submitText="Go to Service Health" :::

::: zone-end

::: zone target="docs"

## Read more

To learn more, see the [Azure Service Health documentation](/azure/service-health).

::: zone-end

# [Azure Advisor](#tab/advisor)

Azure Advisor is a personalized cloud consultant that helps you follow best practices to optimize your Azure deployments. It analyzes your resource configuration and usage telemetry. It then recommends solutions to help improve the performance, security, and high availability of your resources while looking for opportunities to reduce your overall Azure spend.

## Access Azure Advisor

1. Go to **Advisor** in the Azure portal, or search for the resource.
2. Select **High Availability**, **Security**, **Performance**, **Cost**

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Expert/AdvisorMenuBlade/overview]" submitText="Go to Azure Advisor" :::

::: zone-end

::: zone target="docs"

## Read more

[Overview](/azure/advisor/advisor-overview).

::: zone-end

# [Azure Security Center](#tab/security)

Azure Security Center is a unified infrastructure security management system that strengthens the security posture of your datacenters and provides advanced threat protection across your hybrid workloads in the cloud&mdash;whether they're in Azure or not&mdash;as well as on-premises.

## Access Azure Security Center

1. Go to **Security Center** in the Azure portal, or search for the resource.
2. Select **Recommendations**.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Security/SecurityMenuBlade/0]" submitText="Go to Security Center" :::

::: zone-end

::: zone target="docs"

## Read more

[Overview](/azure/security-center/security-center-intro)

::: zone-end

# [Azure Backup](#tab/backup)

Azure Backup is the Azure-based service you can use to backup (or protect) and restore your data in the Microsoft cloud. Azure Backup replaces your existing on-premises or offsite backup solution with a cloud-based solution that is reliable, secure, and cost-competitive.

## Enable backup for an Azure VM

1. In the Azure portal, select **Virtual machines**, and select the VM you want to replicate.
1. In **Operations**, select **Backup**.
1. Create or select an existing Recovery Services vault.
1. Select **Create (or edit) a new policy**.
1. Configure the schedule and retention period.
1. Select **OK**.
1. Select **Enable Backup**.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Compute%2FVirtualMachines]" submitText="Go to Virtual Machines" :::

::: zone-end

::: zone target="docs"

[Overview](/azure/backup/backup-introduction-to-azure-backup)

::: zone-end

# [Azure Site Recovery](#tab/siterecovery)

Earlier in this guide, we discussed how Azure Site Recovery can be used as part of the migration execution. But it also forms a critical component in your disaster recovery strategy after migration is complete.

The Azure Site Recovery service allows you to replicate virtual machines and workloads hosted in a primary Azure region to a copy hosted in a secondary region. When an outage occurs in your primary region, you can fail over to the copy running in the secondary region and continue to access your applications and services from there. After the outage in the primary copy of your virtual machine is running again, you can fail back to it.

## Replicate an Azure VM to another region with Site Recovery service

The following steps outline the process to use Site Recovery service to replicate an Azure VM to another region (Azure-to-Azure):

>
> [!TIP]
> Depending on your scenario, the exact steps may differ slightly.
>

## Enable replication for the Azure VM

1. In the Azure portal, select **Virtual machines**, and select the VM you want to replicate.
1. In **Operations**, select **Disaster recovery**.
1. In **Configure disaster recovery** > **Target region** select the target region to which you'll replicate.
1. For this Quickstart, accept the other default settings.
1. Select **Enable replication**. This starts a job to enable replication for the VM.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Compute%2FVirtualMachines]" submitText="Go to Virtual Machines" :::

::: zone-end

## Verify settings

After the replication job has finished, you can check the replication status, verify replication health, and test the deployment.

1. In the VM menu, select **Disaster recovery**.
2. Verify replication health, the recovery points that have been created, and source and target regions on the map.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Compute%2FVirtualMachines]" submitText="Go to Virtual Machines" :::

::: zone-end

::: zone target="docs"

## Learn more

- [Azure Site Recovery overview](/azure/site-recovery/site-recovery-overview)
- [Replicate an Azure VM to another region](/azure/site-recovery/azure-to-azure-quickstart)

::: zone-end
