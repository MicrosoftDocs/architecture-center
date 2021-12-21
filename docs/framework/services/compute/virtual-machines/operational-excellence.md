---
title: Virtual Machines and operational excellence
description: Focuses on the Virtual Machine service used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to operational excellence.
author: v-stacywray
ms.date: 11/24/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - virtual-machines
categories:
  - compute
  - management-and-governance
---

# Virtual Machines and operational excellence

[Virtual Machines](/azure/virtual-machines/) is an on-demand, scalable computing resource that gives you the flexibility of virtualization without having to buy and maintain physical hardware to run it.

For more information about how virtual machines support operational excellence in your workload, reference [Backup and restore options for virtual machines](/azure/virtual-machines/backup-recovery).

The following sections cover design considerations and configuration recommendations specific to Virtual Machines and operational excellence.

## Design considerations

Microsoft provides the following [SLAs for virtual machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/):

- `95%` SLA for single instance virtual machines using Standard HDD-Managed Disks for OS and Data disks.
- `99.5%` SLA for single instance virtual machines using Standard SSD-Managed Disks for OS and Data disks.
- `99.9%` SLA for single instance virtual machines using Premium SSD or Ultra Disk for all OS and Data disks.
- `99.95%` SLA for all virtual machines that have two or more instances in the same Availability Set or Dedicated Host Group.
- `99.99%` SLA for all virtual machines that have two or more instances deployed across two or more Availability Zones in the same region.

## Checklist

**Have you configured Virtual Machines with operational excellence in mind?**
***
> [!div class="checklist"]
> - Azure Metadata Service Scheduled Events should be used to proactively respond to maintenance events, such as reboots, and limit disruption to virtual machines.
> - Establish virtual machine Resource Health alerts to notify key stakeholders when resource health events occur.
> - To ensure application scalability while navigating within disk sizing thresholds, it's highly recommended that applications be installed on data disks rather than on the OS disk.
> [Managed disks](/azure/virtual-machines/managed-disks-overview#benefits-of-managed-disks) should be used for all virtual machine OS and Data disks to ensure resiliency across underlying storage stamps within a data center.
> - Singleton workloads should use Premium managed disks to enhance resiliency and obtain a `99.9%` SLA as well as dedicated performance characteristics.
> - Non-Singleton workloads should consider two or more replica instances with managed disks (Standard or Premium) that are deployed within an [Availability Set](/azure/virtual-machines/manage-availability) to obtain a `99.95%` SLA or across [Availability Zones](/azure/availability-zones/az-overview#availability-zones) to obtain a `99.99%` SLA.
> - Where appropriate, virtual machines should be deployed across Availability Zones to maximize resilience within a specific Azure region.
> - Consider using [proximity placement groups](https://azure.microsoft.com/blog/introducing-proximity-placement-groups/) (PPGs) with Availability Zones (AZ) to have redundant in-zone VMs.
> - Enable diagnostic logging for all virtual machines to ensure you route health metrics, boot diagnostics, and infrastructure logs to Log Analytics or an alternative log aggregation technology.
> - [Azure Backup](/azure/backup/backup-azure-vms-introduction) should be used to back-up virtual machines in a Recovery Services Vault, to protect against accidental data loss.
> - Enable Soft Delete for the Recovery Services vault to protect against accidental or malicious deletion of backup data, ensuring the ability to recover.

## Configuration recommendations

Explore the following table of recommendations to optimize your Virtual Machine configuration for service reliability:

|Virtual Machine Recommendation|Description|
|------------------------------|-----------|
|Azure Metadata Service Scheduled Events should be used to proactively respond to maintenance events, such as reboots, and limit disruption to virtual machines.|Scheduled Events is an [Azure Metadata Service](/azure/virtual-machines/windows/scheduled-events) that gives your application time to prepare for virtual machine (VM) maintenance. It provides information about upcoming maintenance events (for example, reboot) so that your application can prepare for them and limit disruption.|
|Establish virtual machine Resource Health alerts to notify key stakeholders when resource health events occur.|An appropriate threshold for resource unavailability must be set to minimize signal to noise ratios so that transient faults don't generate an alert. For example, configuring a virtual machine alert with an unavailability threshold of one minute before an alert is triggered. Reference [Resource Health Alerts](/azure/service-health/resource-health-alert-arm-template-guide) for more information.|
|Where appropriate, virtual machines should be deployed across Availability Zones to maximize resilience within a specific Azure region.|Availability Zones offer unique physical locations within an Azure region, where each zone is made up of one or more datacenters equipped with independent power, cooling, and networking. Reference [Datacenter Fault Tolerance](/azure/virtual-machines/availability#use-availability-zones-to-protect-from-datacenter-level-failures) and [High availability and disaster recovery for IaaS apps](/azure/architecture/example-scenario/infrastructure/iaas-high-availability-disaster-recovery) for more information.|
|Consider using proximity placement groups (PPGs) with Availability Zones (AZ) to have redundant in-zone VMs.|It's not possible to create an Availability Set (AS) inside an Availability Zone (AZ) and it's also not possible to control the distribution of VMs within a single availability zone across different fault domains (FD), and update domains (UD). All VMs within a single availability zone might share a common power source and network switch, and can all be rebooted, or affected, by an outage or maintenance task at the same time. If you create VMs across different AZs, your VMs are effectively distributed across different FDs and UDs. If you want to achieve redundant in-zone VMs and cross-zone VMs, you should place the in-zone VMs in proximity placement groups within availability sets to ensure they won't all be rebooted at once. Go to [Combine ASs and AZs with PPGs](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios#combine-availability-sets-and-availability-zones-with-proximity-placement-groups) for detailed instructions.
|Enable diagnostic logging for all virtual machines to ensure you route health metrics, boot diagnostics, and infrastructure logs to Log Analytics or an alternative log aggregation technology.|Platform logs provide detailed diagnostic and auditing information for Azure resources, and the Azure platform they depend on. Reference [Overview of Azure platform logs](/azure/azure-monitor/essentials/platform-logs-overview) for more information.|
|Enable Soft Delete for the Recovery Services vault to protect against accidental or malicious deletion of backup data, ensuring the ability to recover.|With [Azure Backup Soft Delete](/azure/backup/backup-azure-security-feature-cloud), even if a malicious actor deletes a backup (or backup data is accidentally deleted), the backup data is kept for `14` more days, allowing the recovery of that backup item with no data loss. The extra `14` days of retention for backup data in the soft delete state don't incur any cost to you.|

## Supporting source artifacts

Use the following query to *identify standalone single instance VMs that aren't protected by a minimum SLA of at least `99.5%`*. The query will return all VM instances that aren't deployed within an Availability Set, across Availability Zones, and aren't using either Standard SSD or Premium SSD for both OS and Data disks. This query can be altered easily to identify all single instance VMs, including those using Premium Storage, which are protected by a minimum SLA of at least `99.5%`. Remove the trailing `where` condition:

```sql
Resources
| where
    type =~ 'Microsoft.Compute/virtualMachines'
        and isnull(properties.availabilitySet.id)
    or type =~ 'Microsoft.Compute/virtualMachineScaleSets'
        and sku.capacity <= 1
        or properties.platformFaultDomainCount <= 1
| where 
    tags != '{"Skip":""}'
| where 
    isnull(zones)
| where
    properties.storageProfile.osDisk.managedDisk.storageAccountType !in ('Premium_LRS'
    or properties.storageProfile.dataDisks.managedDisk.storageAccountType != 'Premium_LRS'
        and array_length(properties.storageProfile.dataDisks) != 0
```

The following query expands on the identification of standalone instances by *identifying any Availability Sets containing single instance VMs*, which are exposed to the same risks as standalone single instances outside of an Availability Set:

```sql
Resources
| where 
    type =~ 'Microsoft.Compute/availabilitySets'
| where 
    tags != '{"Skip":""}'
| where 
    array_length(properties.virtualMachines) <= 1
| where
    properties.platformFaultDomainCount <= 1
```

### Policy definitions

- Azure policy definition is to *audit standalone single instance VMs that aren't protected by an SLA*. It will flag an audit event for all Virtual Machine instances that aren't deployed within an Availability Set, across Availability Zones, and aren't using Premium Storage for both OS and Data disks. It also encompasses both Virtual Machine and Virtual Machine Scale Set resources.
- To identify resiliency risks to existing compute resources and support continuous compliance for new resources within a customer tenant, it's recommended you use Azure Policy and Azure Resource Graph to Audit the use of non-resilient deployment configurations.
- Azure policy definition is to audit Availability Sets containing single instance VMs that aren't protected by an SLA. It will flag an audit event for all Availability Sets that don't contain multiple instances.

## Next step

> [!div class="nextstepaction"]
> [Azure Cache for Redis and reliability](../../data/azure-cache-redis/reliability.md)
