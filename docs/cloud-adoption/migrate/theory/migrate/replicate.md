---
title: "Fusion: What role does replication and synchronization play in the migration process?"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: What role does replication play in the migration process?

On-prem DataCenters are generally filled with physical assets; servers, appliances, network devices, etc... However, each of those servers is only a physical shell. The real value comes from the binary running on the server. The applications and data are the purpose for the DataCenter those are the primary binary to migrate. Powering the apps and data are other digital assets, other binary sources; operating systems, network routes, files, security protocols, etc...

Replication is the workhorse of [Migration](overview.md). Replication is the process of copying a point-in-time version of various binaries. The binary snapshots are then copied to a new platform and deployed onto new hardware, in a process referred to as seeding. When executed properly, the seeded copy of the binary should behave identically to the original binary on the old hardware. 

However, that snapshot of the binary is immediately out of date & misaligned with the original source. To keep the new binary and the old binary aligned, a process referred to as synchronization continuously updates the copy stored in the new platform.

The process of promoting an asset to production severs most forms of migration focused synchronization, as it is no longer necessary for the copies to be identical.

Without the processes of replication, synchronization, and promotion, there is no migration.

## Required prerequisites to replication

Prior to replication, the **new platform** and hardware must be prepared to receive the binary copies. The section of [Fusion](../../overview.md) that discusses [Core Infrastructure](../../infrastructure/overview.md) outlines various discovery guides to help create a safe, robust, performant platform to receive the binary replicas.

The **source binaries** must also be prepared for replication and synchronization. The articles on assessment, architecture, and remediation each address the actions necessary to ensure that the source binary is ready for replication and synchronization.

A **tool chain** that aligns with the new platform and source binaries must be implemented to execute and manage the replication and synchronization processes. The article on [replication options](replicate-options.md), outlines various tools that could contribute to a migration to Azure. That article discusses the capabilities of Azure Migrate. For the sake of clear demonstrations, [Fusion](../../overview.md) content assumes Azure Migrate is the default tooling selection.

## Replication risks - Physics of replication

When planning for the replication of any binary source to a new destination, there are a few fundamental laws to consider heavily during planning and execution.

* **Speed of light:** When moving high volumes of data, fiber is still the fastest option. Unfortunately, those cables can only move data at two-thirds the speed of light. This means that there is no method for instantaneous or unlimited replication of data.
* **Speed of WAN pipeline:** More consequential than the speed of data movement is the uplink bandwidth, or amount of data per second that can be carried over a companies existing Wide Area Network (WAN), to the target data center.
* **Speed of WAN expansion:** If budgets allow, additional bandwidth can be added to a company's WAN solution. However, it can take weeks or months to procure, provision, and integrate additional fiber connections.
* **Speed of disks:** If data could move faster and there was no limit to the bandwidth between the source binary and the target destination, physics would still be a limiter. Data can only be replicated as quickly as it can be read from source disks. Reading every 1 or 0 from every spinning disk in a data center takes time.
* **Speed of human calculations:** Disks and light move faster than human decision processes. When a group of humans is required to collaborate and make decisions together, the results will come even slower. Replication can never overcome delays related to human intelligence.

Each of these laws of physics drive the following risks that commonly compromise migration plans.

1) **Replication Time:** Advanced replication tools can' overcome basic physics, *replication takes time and bandwidth*. Plans should include realistic timelines that reflect the amount of time it takes to replicate binaries. Total Available Migration Bandwidth is the amount of up-bound bandwidth, measured in Megabits/second (Mb/s) or Gigabits/second (Gb/s), that is not consumed by other higher priority business needs. Total Migration Storage is the total disk space, measured in Gigabytes (GB) or Terabytes (TB), required to store a snapshot of all assets to be migrated. An initial estimate of time can be calculated by dividing the Total Migration Storage by Total Available Migration Bandwidth. Note the conversion from Bits to Bytes. See #2 below for a more accurate calculation of time.

2) **Accumulative Impact of Disk Drift:** From the point of replication to the promotion of an asset to production, the source and destination binaries must remain synchronized. Drift in binaries consumes additional bandwidth, as all changes to the binary must be replicated on a recurring basis. During synchronization, all binary drift must be included in the calculation for Total Migration Storage. The longer it takes to promote an asset to production, to more accumulative drift will occur. The more assets being synchronized, the more bandwidth will be consumed. With each asset being held in a synchronization state, a bit more of the Total Available Migration Bandwidth is lost.

3) **Time to Business Change:** As mentioned in #2 above, synchronization time has a negative and accumulative impact on migration speed. Prioritization of the [migration backlog](../plan/migration-backlog.md) and advanced preparation for the [Business Change Plan](business-change-plan.md) are crucial to the speed of migration. The most impactful test of business and technical alignment during a migration effort, is the pace of promotion. The faster an asset can be promoted to production, the last impact disk drift will have on bandwidth and the more bandwidth/time that can be allocated to replication of the next workload or application.

## Next steps

Once the replication is complete, [Staging activities](stage.md) can begin.

> [!div class="nextstepaction"]
> [Staging assets](stage.md)