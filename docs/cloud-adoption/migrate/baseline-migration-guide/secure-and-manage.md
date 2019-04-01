---
title: "CAF: Secure and Manage"
description: Secure and Manage
author: matticusau
ms.author: mlavery
ms.date: 4/14/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack-new"
---

# Secure and Manage

After migrating your environment to Azure, it is important to consider the security and methods used to manage the environment. Azure provides many features and capabilities to allow you to easily include this within your solution.

# [Azure Monitor](#tab/monitor)

Azure Monitor maximizes the availability and performance of your applications by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing and proactively identifies issues affecting them and the resources they depend on.

::: zone target="docs"

## Link to options in docs view

- [Overview](https://docs.microsoft.com/en-us/azure/azure-monitor/overview).

::: zone-end

::: zone target="chromeless"

## Actions

1. Go to **Monitor**
2. Select **Metrics**, **Logs**, or **Service Health** for overviews.
3. Select any of the relevant Insights.

::: form action="OpenBlade[#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/overview]" submitText="Go to Azure monitor" :::

::: zone-end

# [Azure Service Health](#tab/servicehealth)

Azure Service Health is a suite of experiences that provide personalized guidance and support when issues in Azure services affect you. It can notify you, help you understand the impact of issues, and keep you updated as the issue resolves. It can also help you prepare for planned maintenance and changes that could affect the availability of your resources.

Azure Service Health is composed of:

* Azure status - A global view of the health of Azure services
* Service Health - A personalized view of the health of your Azure services
* Resource Health - A deeper view of the health of the individual resources provisioned to you by your Azure services
* Together, these experiences provide you with a comprehensive view into the health of Azure, at the granularity that is most relevant to you.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Health/AzureHealthBrowseBlade/serviceIssues]" submitText="Go to Service Health" :::

::: zone-end

::: zone target="docs"

[Overview](https://docs.microsoft.com/en-us/azure/service-health/).
::: zone-end

# [Azure Advisor](#tab/advisor)

Azure Advisor is a personalized cloud consultant that helps you follow best practices to optimize your Azure deployments. It analyzes your resource configuration and usage telemetry. It then recommends solutions to help improve the performance, security, and high availability of your resources while looking for opportunities to reduce your overall Azure spend.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Expert/AdvisorMenuBlade/overview]" submitText="Go to Azure Advisor" :::

::: zone-end

::: zone target="docs"

[Overview](https://docs.microsoft.com/en-us/azure/advisor/advisor-overview).

::: zone-end

# [Azure Security Center](#tab/security)

text

# [Azure Backup](#tab/backup)

text

# [Azure Site Recovery](#tab/siterecovery)

Earlier in this guide we discussed how Azure Site Recovery service can be used as part of the migration execution, however it also forms a critical component in your disaster recovery strategy.

The Azure Site Recovery service helps ensure business continuity by keeping business apps and workloads running during outages. Site Recovery replicates workloads running on physical and virtual machines (VMs) from a primary site to a secondary location. When an outage occurs at your primary site, you fail over to secondary location, and access apps from there. After the primary location is running again, you can fail back to it.

Site Recovery can manage replication for:

- Azure VMs replicating between Azure regions.
- On-premises VMs, Azure Stack VMs and physical servers.

## Replicate an Azure VM to another region with Site Recovery service

The following steps outline the process to use Site Recovery service to replicate an Azure VM to another region (azure-to-azure):

[!TIP]
Depending on your scenario, the exact steps may differ slightly.

## Enable replication for the Azure VM

1. In the Azure portal, click **Virtual machines**, and select the VM you want to replicate.
1. In **Operations**, click **Disaster recovery**.
1. In **Configure disaster recovery** > **Target region** select the target region to which you'll replicate.
1. For this Quickstart, accept the other default settings.
1. Click **Enable replication**. This starts a job to enable replication for the VM.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Compute%2FVirtualMachines]" submitText="Go to Virtual Machines" :::

::: zone-end

## Verify settings

After the replication job has finished, you can check the replication status, modify replication settings, and test the deployment.

1. In the VM menu, click **Disaster recovery**.
2. You can verify replication health, the recovery points that have been created, and source, target regions on the map.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/HubsExtension/Resources/resourceType/Microsoft.Compute%2FVirtualMachines]" submitText="Go to Virtual Machines" :::

::: zone-end

::: zone target="docs"

## Learn more

- [Azure Site Recovery overview](https://docs.microsoft.com/en-gb/azure/site-recovery/site-recovery-overview)
- [Replicate an Azure VM to another region](https://docs.microsoft.com/en-gb/azure/site-recovery/azure-to-azure-quickstart)

::: zone-end
