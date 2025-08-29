---
title: Resiliency checklist for services
description: Resiliency is the ability to recover from failures and continue to function. Use this checklist to review the resiliency considerations for Azure services.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2023
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom:
  - resiliency
  - checklist
  - arb-web
---

<!-- cSpell:ignore BACPAC DTUs nonbootable VHDs -->

# Resiliency checklist for specific Azure services

Resiliency is the ability of a system to recover from failures and continue to function. Every technology has its own particular failure modes, which you must consider when designing and implementing your application. Use this checklist to review the resiliency considerations for specific Azure services. For more information about designing resilient applications, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

> [!IMPORTANT]
> Per service reliability product documentation is found in the [Reliability guides by service](/azure/reliability/overview-reliability-guidance). For prescriptive reliability considerations and recommendations when designing or evaluating a workload, see the Reliability section for your service in its [Azure Well-Architected Framework service guides](/azure/well-architected/service-guides/).
>
> The recommendations on this page are being migrated to these locations.

## Azure Synapse Analytics

**Do not disable geo-backup.** By default, Azure Synapse Analytics takes a full backup of your data in Dedicated SQL Pool every 24 hours for disaster recovery. It is not recommended to turn this feature off. For more information, see [Geo-backups](/azure/sql-data-warehouse/backup-and-restore#geo-backups-and-disaster-recovery).

## SQL Server running in a VM

**Back up the database**. If you are already using [Azure Backup](/azure/backup) to back up your VMs, consider using [Azure Backup for SQL Server workloads using DPM](/azure/backup/backup-azure-backup-sql). With this approach, there is one Backup administrator role for the organization and a unified recovery procedure for VMs and SQL Server. Otherwise, use [SQL Server Managed Backup to Microsoft Azure](/sql/relational-databases/backup-restore/sql-server-managed-backup-to-microsoft-azure?view=sql-server-ver15&preserve-view=true).

## Traffic Manager

**Perform manual failback.** After a Traffic Manager failover, perform manual failback, rather than automatically failing back. Before failing back, verify that all application subsystems are healthy. Otherwise, you can create a situation where the application flips back and forth between datacenters.

**Create a health probe endpoint.** Create a custom endpoint that reports on the overall health of the application. This enables Traffic Manager to fail over if any critical path fails, not just the front end. The endpoint should return an HTTP error code if any critical dependency is unhealthy or unreachable. Don't report errors for non-critical services, however. Otherwise, the health probe might trigger failover when it's not needed, creating false positives. For more information, see [Traffic Manager endpoint monitoring and failover](/azure/traffic-manager/traffic-manager-monitoring).

## Virtual Machines

**Avoid running a production workload on a single VM.** A single VM deployment is not resilient to planned or unplanned maintenance. Instead, put multiple VMs in an availability set or [virtual machine scale set](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview), with a load balancer in front.

**Specify an availability set when you provision the VM.** Currently, there is no way to add a VM to an availability set after the VM is provisioned. When you add a new VM to an existing availability set, make sure to create a NIC for the VM, and add the NIC to the back-end address pool on the load balancer. Otherwise, the load balancer won't route network traffic to that VM.

**Put each application tier into a separate Availability Set.** In an N-tier application, don't put VMs from different tiers into the same availability set. VMs in an availability set are placed across fault domains (FDs) and update domains (UD). However, to get the redundancy benefit of FDs and UDs, every VM in the availability set must be able to handle the same client requests.

**Replicate VMs using Azure Site Recovery.** When you replicate Azure VMs using [Site Recovery][site-recovery], all the VM disks are continuously replicated to the target region asynchronously. The recovery points are created every few minutes. This gives you a Recovery Point Objective (RPO) in the order of minutes. You can conduct disaster recovery drills as many times as you want, without affecting the production application or the ongoing replication. For more information, see [Run a disaster recovery drill to Azure][site-recovery-test].

**Choose the right VM size based on performance requirements.** When moving an existing workload to Azure, start with the VM size that's the closest match to your on-premises servers. Then measure the performance of your actual workload with respect to CPU, memory, and disk IOPS, and adjust the size if needed. This helps to ensure the application behaves as expected in a cloud environment. Also, if you need multiple NICs, be aware of the NIC limit for each size.

**Use managed disks for VHDs.** [Managed disks][managed-disks] provide better reliability for VMs in an availability set, because the disks are sufficiently isolated from each other to avoid single points of failure. Also, managed disks aren't subject to the IOPS limits of VHDs created in a storage account. For more information, see [Manage the availability of Windows virtual machines in Azure][vm-manage-availability].

**Install applications on a data disk, not the OS disk.** Otherwise, you may reach the disk size limit.

**Use Azure Backup to back up VMs.** Backups protect against accidental data loss. For more information, see [Protect Azure VMs with a Recovery Services vault](/azure/backup/backup-azure-vms-first-look-arm).

**Enable diagnostic logs.** Include basic health metrics, infrastructure logs, and [boot diagnostics][boot-diagnostics]. Boot diagnostics can help you diagnose a boot failure if your VM gets into a nonbootable state. For more information, see [Overview of Azure Diagnostic Logs][diagnostics-logs].

**Configure Azure Monitor.**  Collect and analyze monitoring data from Azure Virtual Machines including the guest operating system and the workloads that run in it, see [Azure Monitor](/azure/azure-monitor/insights/monitor-vm-azure) and [Quickstart: Azure Monitor](/azure/azure-monitor/learn/quick-monitor-azure-vm).

## Virtual Network

**To allow or block public IP addresses, add a network security group to the subnet.** Block access from malicious users, or allow access only from users who have privilege to access the application.

**Create a custom health probe.** Load Balancer Health Probes can test either HTTP or TCP. If a VM runs an HTTP server, the HTTP probe is a better indicator of health status than a TCP probe. For an HTTP probe, use a custom endpoint that reports the overall health of the application, including all critical dependencies. For more information, see [Azure Load Balancer overview](/azure/load-balancer/load-balancer-overview).

**Don't block the health probe.** The Load Balancer Health probe is sent from a known IP address, 168.63.129.16. Don't block traffic to or from this IP in any firewall policies or network security group rules. Blocking the health probe would cause the load balancer to remove the VM from rotation.

**Enable Load Balancer logging.** The logs show how many VMs on the back-end are not receiving network traffic due to failed probe responses. For more information, see [Log analytics for Azure Load Balancer](/azure/load-balancer/load-balancer-monitor-log).

<!-- links -->
[boot-diagnostics]: https://azure.microsoft.com/blog/boot-diagnostics-for-virtual-machines-v2
[diagnostics-logs]: /azure/monitoring-and-diagnostics/monitoring-overview-of-diagnostic-logs
[managed-disks]: /azure/storage/storage-managed-disks-overview
[search-optimization]: /azure/search/search-reliability
[site-recovery]: /azure/site-recovery
[site-recovery-test]: /azure/site-recovery/site-recovery-test-failover-to-azure
[sql-restore]: /azure/sql-database/sql-database-recovery-using-backups
[vm-manage-availability]: /azure/virtual-machines/windows/manage-availability#use-managed-disks-for-vms-in-an-availability-set
