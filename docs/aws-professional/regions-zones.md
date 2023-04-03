---
title: Comparing AWS and Azure regions and zones
description: Review a comparison of the regions and zones between Azure and AWS. Explore availability sets, availability zones, and paired regions in Azure.
author: martinekuan
ms.date: 12/13/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: cloud-fundamentals
products:
  - azure
categories:
  - management-and-governance
---

# Regions and zones on Azure

Failures can vary in the scope of their impact. Some hardware failures, such as a failed disk, may affect a single host machine. A failed network switch could affect a whole server rack. Less common are failures that disrupt a whole datacenter, such as loss of power in a datacenter. Rarely, an entire region could become unavailable.

One of the main ways to make an application resilient is through redundancy. But you need to plan for this redundancy when you design the application. Also, the level of redundancy that you need depends on your business requirements&mdash;not every application needs redundancy across regions to guard against a regional outage. In general, a tradeoff exists between greater redundancy and reliability versus higher cost and complexity.

In Azure, a region is divided into two or more Availability Zones. An Availability Zone corresponds with a physically isolated datacenter in the geographic region. Azure has numerous features for providing application redundancy at every level of potential failure, including **availability sets**, **availability zones**, and **paired regions**.

:::image type="complex" source="../resiliency/images/redundancy.svg" alt-text="Diagram showing availability sets, availability zones, and paired regions.":::
   The diagram has three parts. The first part shows VMs in an availability set in a virtual network. The second part shows an availability zone with two availability sets in a virtual network. The third part shows regional pairs with resources in each region.
:::image-end:::

The following table summarizes each option.

| &nbsp; | Availability Set | Availability Zone | Paired region |
|--------|------------------|-------------------|---------------|
| Scope of failure | Rack | Datacenter | Region |
| Request routing | Load Balancer | Cross-zone Load Balancer | Traffic Manager |
| Network latency | Very low | Low | Mid to high |
| Virtual networking  | VNet | VNet | Cross-region VNet peering |

## Availability sets

To protect against localized hardware failures, such as a disk or network switch failing, deploy two or more VMs in an availability set. An availability set consists of two or more *fault domains* that share a common power source and network switch. VMs in an availability set are distributed across the fault domains, so if a hardware failure affects one fault domain, network traffic can still be routed to the VMs in the other fault domains. For more information about Availability Sets, see [Manage the availability of Windows virtual machines in Azure](/azure/virtual-machines/windows/manage-availability).

When VM instances are added to availability sets, they are also assigned an [update domain](/azure/virtual-machines/linux/manage-availability). An update domain is a group of VMs that are set for planned maintenance events at the same time. Distributing VMs across multiple update domains ensures that planned update and patching events affect only a subset of these VMs at any given time.

Availability sets should be organized by the instance's role in your application to ensure one instance in each role is operational. For example, in a three-tier web application, create separate availability sets for the front-end, application, and data tiers.

![Azure availability sets for each application role](./images/three-tier-example.png "Availability sets for each application role")

## Availability zones

An [Availability Zone](/azure/availability-zones/az-overview) is a physically separate zone within an Azure region. Each Availability Zone has a distinct power source, network, and cooling. Deploying VMs across availability zones helps to protect an application against datacenter-wide failures.

## Paired regions

To protect an application against a regional outage, you can deploy the application across multiple regions, using [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) to distribute internet traffic to the different regions. Each Azure region is paired with another region. Together, these form a [regional pair][paired-regions]. With the exception of Brazil South, regional pairs are located within the same geography in order to meet data residency requirements for tax and law enforcement jurisdiction purposes.

Unlike Availability Zones, which are physically separate datacenters but may be in relatively nearby geographic areas, paired regions are typically separated by at least 300 miles. This design ensures that large-scale disasters only affect one of the regions in the pair. Neighboring pairs can be set to sync database and storage service data, and are configured so that platform updates are rolled out to only one region in the pair at a time.

Azure [geo-redundant storage](/azure/storage/common/storage-redundancy-grs) is automatically backed up to the appropriate paired region. For all other resources, creating a fully redundant solution using paired regions means creating a full copy of your solution in both regions.

## See also

- [Regions for virtual machines in Azure](/azure/virtual-machines/linux/regions)

- [Availability options for virtual machines in Azure](/azure/virtual-machines/linux/availability)

- [High availability for Azure applications](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)

- [Failure and disaster recovery for Azure applications](/azure/architecture/framework/resiliency/backup-and-recovery)

- [Planned maintenance for Linux virtual machines in Azure](/azure/virtual-machines/linux/maintenance-and-updates)

[paired-regions]: /azure/best-practices-availability-paired-regions
