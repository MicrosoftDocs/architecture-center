---
title: Extend on-premises data solutions to the cloud
description: Learn about using hybrid cloud environments that span cloud and on-premises datacenters for migrating to the cloud or extending on-premises infrastructures.
author: martinekuan
ms.author: architectures
categories: azure
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
  - analytics
  - compute
  - databases
  - storage
  - web
products:
  - azure-stack
ms.custom:
  - guide
  - e2e-hybrid
---

# Extend on-premises data solutions to the cloud

When organizations move workloads and data to the cloud, their on-premises datacenters often continue to play an important role. The term *hybrid cloud* refers to a combination of public cloud and on-premises datacenters, to create an integrated IT environment that spans both. Some organizations use a hybrid cloud as a path to migrate their entire datacenter to the cloud over time. Other organizations use cloud services to extend their existing on-premises infrastructure.

This article describes some considerations and best practices for managing data in a hybrid cloud solution.

## When to use a hybrid solution

Consider using a hybrid solution in the following scenarios:

- As a transition strategy during a long-term migration to a fully cloud-native solution
- When regulations or policies don't permit moving specific data or workloads to the cloud
- For disaster recovery and fault tolerance, by replicating data and services between on-premises and cloud environments
- To reduce latency between your on-premises datacenter and remote locations, by hosting part of your architecture in Azure

## Challenges

- Creating a consistent environment in terms of security, management, and development, and avoiding duplication of work

- Creating a reliable, low-latency, and secure data connection between your on-premises and cloud environments

- Replicating your data and modifying applications and tools to use the correct data stores within each environment

- Securing and encrypting data that's hosted in the cloud but accessed from on-premises systems, or vice versa

## On-premises data stores

On-premises data stores include databases and files. There can be several reasons to keep these data stores local. There might be regulations or policies that don't permit moving specific data or workloads to the cloud. Data sovereignty, privacy, or security concerns might favor on-premises placement. During a migration, you might want to keep some data local to an application that hasn't been migrated yet.

Considerations in placing application data in a public cloud include:

- **Cost**. The cost of storage in Azure can be significantly lower than the cost of maintaining storage with similar characteristics in an on-premises datacenter. Many companies have existing investments in high-end SANs, so these cost advantages might not reach full fruition until existing hardware ages out.

- **Elastic scale**. Planning and managing data capacity growth in an on-premises environment can be challenging, particularly when data growth is difficult to predict. These applications can take advantage of the capacity-on-demand and virtually unlimited storage available in the cloud. This consideration is less relevant for applications that consist of relatively static-sized datasets.

- **Disaster recovery**. Data stored in Azure can be automatically replicated within an Azure region and across geographic regions. In hybrid environments, these same technologies can be used to replicate between on-premises and cloud-based data stores.

## Extending data stores to the cloud

There are several options for extending on-premises data stores to the cloud. One option is to have on-premises and cloud replicas. This approach can help achieve a high level of fault tolerance, but might require making changes to applications to connect to the appropriate data store in the event of a failover.

Another option is to move a portion of the data to cloud storage, while keeping the more current or more highly accessed data on-premises. This method can provide a more cost-effective option for long-term storage, and also improve data access response times by reducing your operational data set.

A third option is to keep all data on-premises, but use cloud computing to host applications. With this option, you host your application in the cloud and connect it to your on-premises data store over a secure connection.

## Azure Stack

For a complete hybrid cloud solution, consider using [Azure Stack](/azure/azure-stack). Azure Stack is a hybrid cloud platform that lets you provide Azure services from your datacenter. This solution helps maintain consistency between on-premises and Azure systems, by using identical tools and requiring no code changes.

Azure and Azure Stack are appropriate in the following use cases:

- **Edge and disconnected solutions**. Address latency and connectivity requirements by processing data locally in Azure Stack and then aggregating in Azure for further analytics, with common application logic across both.

- **Cloud applications that meet varied regulations**. Develop and deploy applications in Azure, with the flexibility to deploy the same applications on-premises on Azure Stack to meet regulatory or policy requirements.

- **Cloud application model on-premises**. Use Azure to update and extend existing applications or build new ones. Use consistent DevOps processes across Azure in the cloud and Azure Stack on-premises.

## SQL Server data stores

If you run SQL Server on-premises, you can use Azure Blob Storage for backup and restore services. For more information, see [SQL Server Backup and Restore with Microsoft Azure Blob Storage Service](/sql/relational-databases/backup-restore/sql-server-backup-and-restore-with-microsoft-azure-blob-storage-service). This capability gives you limitless offsite storage, and the ability to share the same backups between SQL Server running on-premises and SQL Server running in a virtual machine (VM) in Azure.

[Azure SQL Database](/azure/sql-database) is a managed relational database-as-a service. Because SQL Database uses the Microsoft SQL Server engine, applications can access data in the same way with both technologies. SQL Database can also be combined with SQL Server in useful ways. For example, the [SQL Server Stretch Database](/sql/sql-server/stretch-database/stretch-database) feature lets an application access what looks like a single table in a SQL Server database while some or all rows of that table might be stored in SQL Database. This technology automatically moves data that's not accessed for a defined period of time to the cloud. Applications that read this data are unaware that any data has been moved to the cloud.

Maintaining data stores on-premises and in the cloud can be challenging when you desire to keep the data synchronized. You can address this challenge with [SQL Data Sync](/azure/sql-database/sql-database-sync-data), a service built on SQL Database that lets you synchronize the data you select, bi-directionally across multiple Azure SQL databases and SQL Server instances. While Data Sync makes it easy to keep your data up to date across these various data stores, it shouldn't be used for disaster recovery or for migrating from on-premises SQL Server to SQL Database.

For disaster recovery and business continuity, you can use [AlwaysOn Availability Groups](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server) to replicate data across two or more instances of SQL Server, some of which can be running on Azure VMs in another geographic region.

## Network shares and file-based data stores

In a hybrid cloud architecture, it's common for an organization to keep newer files on-premises while archiving older files to the cloud. This practice is sometimes called file tiering. It provides seamless access to both on-premises and cloud-hosted files. This approach helps to minimize network bandwidth usage and access times for newer files, which are likely to be accessed the most often. At the same time, you get the benefits of cloud-based storage for archived data.

Organizations might also wish to move their network shares entirely to the cloud, for example, if the applications that access them are also located in the cloud. This procedure can be done using [data orchestration](../technology-choices/pipeline-orchestration-data-movement.md) tools.

[Azure StorSimple](/azure/storsimple) offers the most complete integrated storage solution for managing storage tasks between your on-premises devices and Azure cloud storage. StorSimple is an efficient, cost-effective, and easily manageable storage area network (SAN) solution that eliminates many of the issues and expenses associated with enterprise storage and data protection. It uses the proprietary StorSimple 8000 series device, integrates with cloud services, and provides a set of integrated management tools.

Another way to use on-premises network shares alongside cloud-based file storage is with [Azure Files](/azure/storage/files/storage-files-introduction). Azure Files offers fully managed file shares that you can access with the standard [Server Message Block](/windows/win32/fileio/microsoft-smb-protocol-and-cifs-protocol-overview?f=255&MSPPError=-2147217396) (SMB) protocol (sometimes referred to as CIFS). You can mount Azure Files as a file share on your local computer, or use them with existing applications that access local or network share files.

To synchronize file shares in Azure Files with your on-premises Windows Servers, use [Azure File Sync](/azure/storage/files/storage-sync-files-planning). One major benefit of Azure File Sync is the ability to tier files between your on-premises file server and Azure Files. This capability lets you keep only the newest and most recently accessed files locally.

For more information, see [Deciding when to use Azure Blob storage, Azure Files, or Azure Disks](/azure/storage/common/storage-decide-blobs-files-disks).

## Hybrid networking

This article focuses on hybrid data solutions, but another consideration is how to extend your on-premises network to Azure. For more information about this aspect of hybrid solutions, see the following resources:

- [Choose a solution for connecting an on-premises network to Azure](../../reference-architectures/hybrid-networking/index.yml)
- [Hybrid network reference architectures](../../reference-architectures/hybrid-networking/index.yml)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [Hybrid architecture design](/azure/architecture/hybrid/hybrid-start-here)
- [Azure Stack Hub overview](/azure-stack/operator/azure-stack-overview)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Azure Files?](/azure/storage/files/storage-files-introduction)
- [Introduction to Azure hybrid cloud services](/training/modules/intro-to-azure-hybrid-services)

## Related resources

- [Hybrid file services](../../hybrid/hybrid-file-services.yml)
- [Move archive data from mainframe systems to Azure](../../example-scenario/mainframe/move-archive-data-mainframes.yml)
- [Tiered data for analytics](../../example-scenario/hybrid/hybrid-tiered-data-analytics.yml)
- [Use Azure file shares in a hybrid environment](../../hybrid/azure-file-share.yml)
