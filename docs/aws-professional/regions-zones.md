---
title: Comparing AWS and Azure Regions and Zones
description: Review a comparison of Azure and AWS regions and zones. Explore Virtual Machine Scale Sets, availability zones, and multi-region options in Azure.
author: WernerRall147
ms.author: weral
ms.date: 10/05/2026
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
ms.collection: 
 - migration
 - aws-to-azure
---

# Regions and zones on Azure and AWS

This article compares concepts related to regions and zones on Azure and Amazon Web Services (AWS).

Failures can vary in the scope of their impact. Some hardware failures, such as a failed disk, might affect a single host machine. A failed network switch could affect a whole server rack. Less common are failures that disrupt a whole datacenter, such as loss of power in a datacenter. Rarely, an entire region could become unavailable.

One of the main ways to make an application resilient is through redundancy. But you need to plan for this redundancy when you design the application. Also, the level of redundancy that you need depends on your business requirements. Not every application needs redundancy across regions to guard against a regional outage. In general, a tradeoff exists between greater redundancy and reliability versus higher cost and complexity.

Many Azure regions provide *availability zones*, which are separated groups of datacenters within a region. Azure provides features for application redundancy at every level of potential failure, including **Virtual Machine Scale Sets**, **availability zones**, and **multi-region deployments**.

:::image type="complex" source="./images/redundancy.svg" lightbox="./images/redundancy.svg" alt-text="Diagram showing rack-level, datacenter-level, and region-level redundancy on Azure.":::
   The diagram shows three panels, each corresponding to a redundancy scope. The left panel, rack-level redundancy for a virtual machine scale set, shows a load balancer above two boxes, fault domain 1 and fault domain 2. Each box contains three virtual machines. The middle panel, datacenter-level redundancy across availability zones, shows a zone-redundant load balancer above three boxes labeled zone 1, zone 2, and zone 3. Each box contains one virtual machine. The right panel, region-level redundancy for a multi-region deployment, shows Traffic Manager above two boxes, region A (primary) and region B (secondary). Each box contains an app tier virtual machine and a data tier virtual machine. In every panel, lines connect the top routing component to each box below it. A dashed replication and failover path runs vertically between the two regions in the right panel.
:::image-end:::

## How Azure and AWS terms compare

As the following table shows, most region and zone concepts map directly between the two platforms, but a few don't.

| Concept | AWS | Azure |
| --- | --- | --- |
| Geographic deployment boundary | Region | Region |
| Isolated datacenter group within a region | Availability Zone | Availability zone |
| Zone identifier that's consistent across accounts | AZ ID, such as `use1-az1` | Physical zone, which each subscription maps to its own logical zone number |
| Rack-level fault isolation without zones | Spread placement group | [Virtual machine scale set](/azure/virtual-machine-scale-sets/overview) fault domains |
| Low-latency colocation | Cluster placement group | [Proximity placement group](/azure/virtual-machines/co-location) |
| Edge locations near population centers | Local Zones | [Azure Extended Zones](/azure/extended-zones/overview) |
| Predefined region relationship for platform replication | No equivalent | Region pair |

Two differences matter most when you move a design from AWS to Azure:

- **Zone numbers aren't portable across subscriptions.** Azure maps physical zones to logical zone numbers separately for each subscription, so zone 1 in one subscription might not be the same datacenter group as zone 1 in another. This concept parallels AWS AZ IDs, which exist because AWS Availability Zone names are also account-specific. To resolve the mapping, see [Physical and logical availability zones](/azure/reliability/availability-zones-overview#physical-and-logical-availability-zones).
- **Region pairs have no AWS equivalent.** A region pair is a predefined relationship that a small number of Azure services use for geo-replication. It isn't a disaster recovery solution on its own, and many Azure regions have no pair. For more information, see [Multi-region deployment and paired regions](#multi-region-deployment-and-paired-regions).

The following table summarizes each redundancy option.

| &nbsp; | Virtual Machine Scale Sets | Availability zone | Multi-region |
| --- | --- | --- | --- |
| Scope of failure | Rack | Datacenter or zone | Region |
| Request routing | Load balancer | Zone-redundant load balancer | Azure Front Door or Azure Traffic Manager |
| Network latency | Very low | Low | Medium to high |
| Virtual networking | Virtual network | Virtual network | Cross-region virtual network peering |

## Virtual Machine Scale Sets

To protect against localized hardware failures, such as a disk or network switch failure, deploy your VMs in a [Virtual machine scale set in Flexible orchestration mode](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes). Flexible orchestration distributes VM instances across multiple *fault domains*, which are groups of hardware that share a common power source and network switch. This distribution is the closest Azure equivalent to an AWS spread placement group. If a hardware failure affects one fault domain, a load balancer in front of the scale set continues to route traffic to the instances in the other fault domains. Flexible orchestration provides high availability with the widest range of VM features, and you can spread instances across availability zones to also protect against datacenter-wide failures.

Scale sets coordinate platform maintenance so that planned update and patching events affect only a subset of instances at any given time. You can also [enable automatic instance repairs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-automatic-instance-repairs) so the scale set replaces an unhealthy instance and maintains availability.

Organize scale sets by the instance's role in your application, and deploy at least two instances per role across separate fault domains. For example, in a three-tier web application, create separate scale sets for the front-end, application, and data tiers, each with enough instances spread across fault domains so that a single hardware failure doesn't make the entire tier unavailable.

[Availability sets](/azure/virtual-machines/availability-set-overview) are the earlier way to group VMs across fault domains, and they're still supported. Two or more VMs in an availability set meet the 99.95% VM service-level agreement, and the availability set itself carries no charge. But you can't combine an availability set with availability zones for the same VMs, and availability sets stay exposed to shared infrastructure failures, such as a datacenter-level network outage. Use them only for existing deployments, for regions that don't offer availability zones, or for workloads that need the lower VM-to-VM latency that comes from closer physical proximity.

## Availability zones

An [availability zone](/azure/reliability/availability-zones-overview) is a logical grouping of one or more physically separate datacenters within an Azure region. Each zone has independent power, cooling, and networking. Zones are typically separated by several kilometers, and are usually located within 100 kilometers of each other, which keeps latency low while reducing the chance that one local outage or weather event affects multiple zones.

This model differs from AWS Availability Zones in one way that affects design: an Azure availability zone can contain more than one datacenter, so don't equate a zone with a single building.

Azure services support zones in two ways, and the distinction determines who handles failover:

- **Zone-redundant resources**: The service replicates or distributes these resources across multiple zones. Microsoft spreads the requests, replicates the data, and handles failover automatically if a zone fails.
- **Zonal resources**: You deploy these resources into a single zone that you choose. A zonal deployment isolates the resource from faults in other zones, but the resource isn't resilient to an outage of its own zone. To achieve resilience, deploy separate resources into multiple zones and handle failover yourself.

If you don't configure a resource to use zones, Azure treats it as a *nonzonal* or regional deployment and might place it in any zone in the region. A zone outage can then make the resource unavailable.

Azure maps physical zones to logical zone numbers per subscription, so zone 1 in one subscription might not be the same physical zone as zone 1 in another. Account for this mapping when you deploy resources to specific zones across subscriptions, in the same way that you'd use AWS AZ IDs rather than AZ names.

Not all Azure regions support availability zones. For more information, see [Azure regions list](/azure/reliability/regions-list).

## Multi-region deployment and paired regions

To protect an application against a regional outage, deploy it across multiple regions and distribute traffic with [Azure Front Door](https://azure.microsoft.com/products/frontdoor) or [Traffic Manager](https://azure.microsoft.com/products/traffic-manager).

Azure associates some regions with a second region to form a [region pair][paired-regions]. A small number of Azure services use region pairs for geo-replication and geo-redundancy. Region pairs provide a recovery sequence, in which one region in each pair is prioritized during a geography-wide outage, and sequential updating, in which Azure staggers planned platform updates across the two regions.

Many Azure regions have no pair. Those regions use availability zones as their primary means of redundancy, and many Azure services support geo-redundancy regardless of whether the regions are paired. You can build a highly resilient solution with paired regions, nonpaired regions, or a combination of the two.

To meet data residency requirements, almost all paired regions are located within the same geography, but there are exceptions. Some pairs are asymmetrical, which means the relationship isn't bidirectional. For example, Brazil South is paired with South Central US, which is outside the Brazil geography, and South Central US isn't paired with Brazil South. For more information, see [Azure region pairs and nonpaired regions][paired-regions].

> [!IMPORTANT]
> Deploying to a region in a pair doesn't by itself make your resources more resilient, and it doesn't provide automatic high availability, disaster recovery, or failover. Plan your own high availability and disaster recovery, regardless of whether you use paired regions. Microsoft-managed failover, such as failover of a geo-redundant storage account, happens only in catastrophic situations after repeated recovery attempts fail.

You aren't restricted to your region's pair. You can host resources in any region that meets your business needs. If your primary region isn't paired, or if another location better serves your requirements, choose a secondary region based on service availability, data residency, latency, and disaster recovery objectives.

Azure [geo-redundant storage (GRS)](/azure/storage/common/storage-redundancy) replicates to the paired region automatically. For a fully redundant multi-region solution for other resources, you need to deploy a full copy of your solution in each region.

## Related resources

- [Regions for virtual machines in Azure](/azure/virtual-machines/regions)
- [Availability options for virtual machines in Azure](/azure/virtual-machines/availability)
- [High availability for Azure applications](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)
- [Disaster recovery for Azure applications](/azure/well-architected/reliability/disaster-recovery)
- [Planned maintenance for virtual machines in Azure](/azure/virtual-machines/maintenance-and-updates)
- [Reliability guides by service](/azure/reliability/overview-reliability-guidance)

[paired-regions]: /azure/reliability/regions-paired
