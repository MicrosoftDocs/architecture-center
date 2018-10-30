---
title: "Enterprise Cloud Adoption: Replication Options"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 10/11/2018
---

# Enterprise Cloud Adoption: Replication Options

Before any migration, you will want to ensure primary systems are safe and will continue to run without issues. Any downtime disrupts users or customers, and costs time and money. Migration is not as simple as turning off the virtual machines on-premises and copying them across to Azure. Migration tools must take into account asynchronous or synchronous replication to ensure live systems can be copied to Azure with no downtime. Most of all, systems must be kept in lock-step with on-premises counterparts. You might want to test migrated resources in isolated partitions in Azure, to ensure applications work as expected.

The content within the Enterprise Cloud Adoption (ECA) framework, assumes that Azure Migrate (or Azure Site Recovery) is the most appropriate tool for replicating assets to the cloud. However, there are other options available. This article discusses those options to help enable decision making.

## Azure Site Recovery

Azure Site Recovery orchestrates and manages disaster recovery for Azure VMs, on-premises VMs, and physical servers. You can also use Site Recovery to manage migration of machines on-premises and other cloud providers to Azure. Replicate on-premises machines to Azure, or Azure VMs to a secondary region. Then you fail the VM over from the primary site to the secondary, and complete the migration process. With Azure Site Recovery, you can achieve various migration scenarios:

* Migrate from on-premises to Azure: Migrate on-premises VMware VMs, Hyper-V VMs, and physical servers to Azure. To do this, complete almost the same steps as you would for full disaster recovery. Simply don't fail machines back from Azure to the on-premises site.
* Migrate between Azure regions: Migrate Azure VMs from one Azure region to another. After the migration is complete, configure disaster recovery for the Azure VMs now in the secondary region to which you migrated.
* Migrate from other cloud to Azure: You can migrate your compute instances provisioned on other cloud providers to Azure VMs. Site Recovery treats those instances as physical servers for migration purposes.


![Azure Site Recover (ASR)](../../_images/asr-replication-image.png)
*Figure 1. Azure Site Recovery (ASR) moving assets to Azure or other clouds*

Once you have assessed on-premises/cloud infrastructure for migration, Azure Site Recovery contributes to your migration strategy by replicating on-premises machines. With the following easy steps, you can set up migration of on-premises VMs, physical servers, and cloud VM instances to Azure:

* Verify prerequisites
* Prepare Azure resources
* Prepare on-premises VM or cloud instances for migration
* Deploy a configuration server
* Enable replication for VMs
* Test failover to make sure everything's working
* Run a one-time failover to Azure
* Know more: Azure Site Recovery

## Azure Database Migration Service

This service helps reduce the complexity of your cloud migration by using a single comprehensive service instead of multiple tools. Azure Database Migration Service is designed as a seamless, end-to-end solution for moving on-premises SQL Server databases to the cloud. The Azure Database Migration Service is a fully managed service designed to enable seamless migrations from multiple database sources to Azure Data platforms with minimal downtime. It integrates some of the functionality of existing tools and services, providing customers with a comprehensive, highly available solution. The service uses the Data Migration Assistant to generate assessment reports that provide recommendations to guide you through the changes required prior to performing a migration. It's up to you to perform any remediation required. When you are ready to begin the migration process, the Azure Database Migration Service performs all of the associated steps. You can fire and forget your migration projects with peace of mind, knowing that the process takes advantage of best practices as determined by Microsoft.

## CloudEndure

When you need a wider range of supported virtual machines to migrate to Azure, CloudEndure uses replication to migrate virtual machines with no impact to the original source machine (like ASR). CloudEndure is also a solid choice if you want to use an independent tool. CloudEndure enables migration of even the most complex workloads to Azure without downtime, disruption, or data loss. Through continuous, block-level replication, automated machine conversion, and application stack orchestration, CloudEndure simplifies the migration process and reduces the potential for human error. Whether you are migrating to or across Azure, CloudEndure Live Migration gives you the flexibility and security you need to succeed in today’s fast-paced digital ecosystem. CloudEndure’s Live Migration solution has been selected as a choice migration vendor in the newly launched Azure Migration Center.

## Next steps

During [staging activities](stage.md), you will use proven tools such as Azure Site Recovery to seamlessly rehost virtual machines, and Azure Database Migration Service to move databases to Azure. For your data, you can migrate to a VM running SQL, an Azure SQL Database managed instance, or modernize with the Azure CosmosDB globally distributed database service. If you want to upgrade on-premises, explore the latest version of Windows Server, with capabilities that can help you get cloud and DevOps ready.

Once replication is running, [staging activities](stage.md) can continue the migration effort.

> [!div class="nextstepaction"]
> Start [staging assets](stage.md) for migration.