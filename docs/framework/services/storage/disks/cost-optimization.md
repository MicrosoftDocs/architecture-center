---
title: Disks and cost optimization
description: Focuses on the Disks service used in the Storage solution to provide best-practice, configuration recommendations, and design considerations related to Cost optimization.
author: v-stacywray
ms.date: 12/01/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - storage-disks
categories:
  - storage
  - management-and-governance
---

# Disks and cost optimization

[Azure managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes that are managed by Azure and used with Azure Virtual Machines. Managed disks are like a physical disk in an on-premises server, but these disks are virtualized.

Available disk types include:

- Ultra disks
- Premium solid-state drives (SSD)
- Standard SSDs
- Standard hard disk drives (HDD)

For more information about the different types of disks, reference [Azure managed disk types](/azure/virtual-machines/disks-types).

To understand how Azure managed disks are cost-effective solutions for your workload, reference the following articles:

- [Overview of Azure Disk Backup](/azure/backup/disk-backup-overview)
- [Understand how your reservation discount is applied to Azure disk storage](/azure/cost-management-billing/reservations/understand-disk-reservations?context=/azure/virtual-machines/context/context)
- [Reduce costs with Azure Disks Reservation](/azure/virtual-machines/disks-reserved-capacity)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure managed disks and cost optimization.

## Design considerations

Azure Disks include the following design considerations:

- Use a shared disk for workload, such as SQL server failover cluster instance (FCI), file server for general use (IW workload), and SAP ASCS/SCS.
- Consider selective disk backup and restore for Azure VMs.

|Considerations|Description|
|--------------|-----------|
|Use a shared disk for workload, such as SQL server failover cluster instance (FCI), file server for general use (IW workload), and SAP ASCS/SCS.|You can use shared disks to enable cost-effective clustering instead of setting up your own shared disks through S2D (Storage Spaces Direct). Sample workloads that would benefit from shared disks include: <br>- SQL Server Failover Cluster Instances (FCI) <br>- Scale-out File Server (SoFS) <br>- File Server for General Use (IW workload) <br>- SAP ASCS/SCS

## Checklist

**Have you configured your Azure managed disk with cost optimization in mind?**

> [!div class="checklist"]
> - Configure data and log files on different disks for database workloads.
> - Use bursting for P20 and lower disks for workloads, such as batch jobs, workloads, which handle traffic spikes, and to improve OS boot time.
> - Consider using Premium disks (P30 and greater).

## Configuration recommendations

Consider the following recommendations to optimize costs when configuring your Azure managed disk:

|Recommendation|Description|
|--------------|-----------|
|Configure data and log files on different disks for database workloads.|You can optimize IaaS DB workload performance by configuring system, data, and log files to be on different disk SKUs (leveraging Premium Disks for data and Ultra Disks for logs satisfies most production scenarios). Ultra Disk cost and performance can be optimized by taking advantage of configuring capacity, IOPS, and throughput independently. Also, you can dynamically configure these attributes. Example workloads include:<br> - SQL on IaaS <br> - Cassandra DB <br> - Maria DB <br> - MySql and <br> - Mongo DB on IaaS|
|Use bursting for P20 and lower disks for workloads, such as batch jobs, workloads, which handle traffic spikes, and to improve OS boot time.|Azure Disks offer various SKUs and sizes to satisfy different workload requirements. Some of the more recent features could help further optimize cost performance of existing disk use cases. You can use disk bursting for Premium (disks P20 and lower). Example scenarios that could benefit from this feature include: <br> - Improving OS boot time <br> - Handling batch jobs <br> - Handling traffic spikes|
|Consider using Premium disks (P30 and greater).|Premium Disks (P30 and greater) can be reserved (one or three years) at a discounted price.|

## Next step

> [!div class="nextstepaction"]
> [Event Grid and reliability](../../messaging/event-grid/reliability.md)
