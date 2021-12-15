---
title: Reliability in a hybrid workload
description: Includes guidance and recommendations that apply to the Reliability pillar in a hybrid and multi-cloud workload.
author: v-aangie
ms.date: 02/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - e2e-hybrid
---

# Reliability in a hybrid workload

In the cloud, we acknowledge up front that failures will happen. Instead of trying to prevent failures altogether, the goal is to minimize the effects of a single failing component. While historically you may have purchased levels of redundant higher-end hardware to minimize the chance of an entire application platform failing, in the cloud, we acknowledge up front that failures will happen.

For hybrid scenarios, Azure offers an end-to-end backup and disaster recovery solution that's simple, secure, scalable, and cost-effective, and can be integrated with on-premises data protection solutions. In the case of service disruption or accidental deletion or corruption of data, recover your business services in a timely and orchestrated manner.

Many customers operate a second datacenter, however, Azure can help reduce the costs of deploying, monitoring, patching, and scaling on-premises disaster recovery infrastructure, without the need to manage backup resources or build a secondary datacenter.

Extend your current backup solution to Azure, or easily configure our application-aware replication and application-consistent backup that scales based on your business needs. The centralized management interface for Azure Backup and Azure Site Recovery makes it simple to define policies to natively protect, monitor, and manage enterprise workloads across hybrid and cloud. These include:

- Azure Virtual Machines
- SQL and SAP databases
- On-premises Windows servers
- VMware machines

> [!NOTE]
> By not having to build on-premises solutions or maintain a costly secondary datacenter, customers can reduce the cost of deploying, monitoring, patching, and scaling disaster recovery infrastructure by backing up their hybrid data and applications with Azure.

## Backup and Recovery

Together, Azure Backup and Azure Site Recovery use the underlying power and unlimited scale of the cloud to deliver high availability with minimal maintenance or monitoring overhead. These native capabilities are available through a pay-as-you-use model that bills only for the storage that is consumed.

Using Azure Site Recovery, users can set up and manage replication, failover, and failback from a single location in the Azure portal. The Azure hybrid services tool in Windows Admin Center can also be used as a centralized hub to easily discover all the available Azure services that bring value to on-premises or hybrid environments. Windows Admin Center streamlines setup and the process of replicating virtual machines on Hyper-V servers or clusters, making it easier to bolster the resiliency of environments with Azure Site Recovery's disaster recovery service.

Azure is committed to providing the best-in-class data protection to keep your applications running. Azure Backup protects backups of on-premises and cloud-resources from ransomware attacks by isolating backup data from source data, combined with multi-factor authentication and the ability to recover maliciously or accidentally deleted backup data. With Azure Site Recovery you can fail over VMs to the cloud or between cloud data centers and secure them with network security groups.

In the case of a disruption, accidental deletion, or corruption of data, customers can rest assured that they will be able to recover their business services and data in a timely and orchestrated manner. These native capabilities support low recovery-point objective (RPO) and recovery-time objective (RTO) targets for any mission-critical workload in your organization. Azure is here to help customers pivot towards a strengthened BCDR strategy.

## Availability Considerations

### For Azure Arc

In most cases, the location you select when you create the installation script should be the Azure region geographically closest to your machine's location. The rest of the data will be stored within the Azure geography containing the region you specify, which might also affect your choice of region if you have data residency requirements. If an outage affects the Azure region to which your machine is connected, the outage will not affect the Arc enabled server, but management operations using Azure might not be able to complete. For resilience in the event of a regional outage, if you have multiple locations which provide a geographically-redundant service, it's best to connect the machines in each location to a different Azure region.

Ensure that Azure Arc is supported in your regions by checking supported regions. Also, ensure that services referenced in the Architecture section are supported in the region to which Azure Arc is deployed.

### Azure Arc enabled data services

With Azure Arc enabled SQL Managed Instance, you can deploy individual databases in either a single or multiple pod pattern. For example, the developer or general-purpose pricing tier implements a single pod pattern, while a highly available business critical pricing tier implements a multiple pod pattern. A highly available Azure SQL managed instance uses Always On Availability Groups to replicate the data from one instance to another either synchronously or asynchronously.

With Azure Arc enabled SQL Managed Instance, planning for storage is also critical from the data resiliency standpoint. If there's a hardware failure, an incorrect choice might introduce the risk of total data loss. To avoid such risk, you should consider a range of factors affecting storage configuration [kubernetes-storage-class-factors](/azure/azure-arc/data/storage-configuration#factors-to-consider-when-choosing-your-storage-configuration) for both [data controller](/azure/azure-arc/data/storage-configuration#data-controller-storage-configuration) and [database instances](/azure/azure-arc/data/storage-configuration#database-instance-storage-configuration).

Azure Arc enabled SQL Managed Instance provides automatic local backups, regardless of the connectivity mode. In the Directly Connected mode, you also have the option of leveraging Azure Backup for off-site, long-term backup retention.

## Azure Stack HCI

### Site-level fault domains

Each physical site of an Azure Stack HCI stretched cluster represents distinct fault domains that provide additional resiliency. A fault domain is a set of hardware components that share a single point of failure. To be fault tolerant to a particular level, you need multiple fault domains at that level.

### Site awareness

Site awareness allows you to control placement of virtualized workloads by designating their preferred sites. Specifying the preferred site for a stretched cluster offers many benefits, including the ability to group workloads at the site level and to customize quorum voting options. By default, during a cold start, all virtual machines use the preferred site, although it is also possible to configure the preferred site at the cluster role or group level.

### Resiliency limits

Azure Stack HCI provides multiple levels of resiliency, but because of its hyper-converged architecture, that resiliency is subject to limits imposed not only by the [cluster quorum](/windows-server/storage/storage-spaces/understand-quorum#cluster-quorum-overview), but also by the [pool quorum](/windows-server/storage/storage-spaces/understand-quorum#pool-quorum-overview). You can eliminate this limit by implementing [cluster sets](/windows-server/storage/storage-spaces/cluster-sets) in which you combine multiple Azure Stack HCI clusters to create an HCI platform consisting of hundreds of nodes.

## Next steps

> [!div class="nextstepaction"]
> [Security](./hybrid-security.md)
