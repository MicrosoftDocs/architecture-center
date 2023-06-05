SAS analytics software provides a suite of services and tools for drawing insights from data and making intelligent decisions. SAS solutions provide analytics, artificial intelligence, business intelligence, customer intelligence, data management, and fraud and security intelligence.

If you're deploying [SAS Grid on Azure](../../guide/sas/sas-overview.yml), [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) is a [viable primary storage option](../../guide/sas/sas-overview.yml#azure-netapp-files-nfs). When you use the scalable services of Azure NetApp Files, you can scale the storage allocations up or down at any time without interruption to the services. You can also adjust the storage service level to the performance requirements dynamically.

SAS offers these primary platforms, which Microsoft has validated:

- SAS Grid 9.4
- SAS Viya

SAS Grid 9.4 has been validated on Linux.

This article provides general information for running SAS Grid 9.4 on Azure, using Azure NetApp Files for SASDATA storage. It also provides guidance on storage options for SASWORK. These guidelines are based on the assumption that you host your own SAS solution on Azure, in your own tenant. SAS doesn't provide hosting for SAS Grid on Azure.

## Architecture

:::image type="content" source="media/main-architecture.png" alt-text="Diagram that shows an architecture for running SAS Grid on Azure." lightbox="media/main-architecture.png" border="false":::
 
*Download a [PowerPoint file](https://arch-center.azureedge.net/sas-grid.pptx) of the architectures in this article.*

### Dataflow 

The compute tier uses SASDATA (and optionally SASWORK) volumes to share data across the grid. SASDATA is an NFS-connected volume on Azure NetApp Files.

- A compute node reads input data from SASDATA and writes results back to SASDATA.
- A subsequent part of the analytics job can be run by another node in the compute tier. It uses the same procedure to obtain and store the information that it needs to process.

### Potential use cases

A scalable SAS Grid deployment that uses Azure NetApp Files is applicable to these use cases:

- Financial analytics
- Fraud detection
- Tracking and protection of endangered species
- Science and medicine
- Analytics and AI

## Requirements for storage performance

For SAS 9.4 (SAS Grid or SAS Analytics Pro) deployments on Azure, Azure NetApp Files is a viable primary storage option for SAS Grid clusters of limited size. [SAS recommends 100 MiB/s throughput per physical core.](https://communities.sas.com/t5/Administration-and-Deployment/Best-Practices-for-Using-Microsoft-Azure-with-SAS/m-p/676833#M19680) Given that recommendation, SAS Grid clusters that use an Azure NetApp Files volume for SASDATA (persistent SAS data files) are scalable to 32 to 48 physical cores across two or more Azure virtual machines. SAS cluster sizes are based on the architectural constraint of a single SASDATA namespace per SAS cluster and the available single [Azure NetApp Files volume bandwidth](/azure/azure-netapp-files/azure-netapp-files-service-levels#throughput-limits). The core count guidance will be revisited as Azure infrastructure (compute, network, and per file system storage bandwidth) increases over time.

### Azure NetApp Files volume performance expectations

A single Azure NetApp Files volume can handle up to 4,500 MiB/s of reads and 1,500 MiB/s of writes. Given an Azure instance type with sufficient egress bandwidth, a single virtual machine can consume all the write bandwidth of a single Azure NetApp Files volume. However, only the largest single virtual machine can consume all the read bandwidth of a single volume.

SASDATA, the main shared workload of SAS 9.4, has an 80:20 read/write ratio. The important *per volume* numbers for an 80:20 workload with 64KiB read/write are: 

- 2,400 MiB/s of read throughput and 600 MiB/s of write throughput running concurrently (~3,000 MiB/s combined).

For more information, see [Azure NetApp Files performance benchmarks for Linux](/azure/azure-netapp-files/performance-benchmarks-linux).

> [!NOTE]
> Azure NetApp Files large volumes feature is now available. This feature provides higher per-volume throughput than regular Azure NetApp Files volumes do. This capability can be considered in case more performance is required for your SASDATA (or SASWORK) volumes. See [this documentation](/azure/azure-netapp-files/large-volumes-requirements-considerations#requirements-and-considerations) for details.

### Capacity recommendations

The [Azure NetApp Files performance calculator](https://cloud.netapp.com/azure-netapp-files/sizer) can provide guidance for sizing SASDATA volumes. 

It's important to choose an appropriate service level because:

- Volume bandwidth is based on volume capacity.
- Capacity cost is based on the service level. 
- Your choice of service level is based on capacity versus bandwidth needs. 
 
In the  calculator, select **advanced**, select a region, and enter the following values.

- Volume size: Desired capacity
- Throughput: Desired throughput, considering 100 MiB/s per core
- Read percentage: **80%**
- IOPS: **0**
- I/O size: **64KiB Sequential**

The output at the bottom of the screen provides recommended capacity requirements at each service level and the cost per month, based on the price for the selected region:

- **Throughput**. The bandwidth of the volume, based on the workload mix. For an 80% 64-KiB sequential read workload, 3,096 MiB/s is the expected maximum.
- **IOPS**. The number of IOPS the volume provides at the specified throughput.
- **Volume Size**. The amount of capacity needed by the volume at the given service levels to achieve the required throughput. Volume capacity (reported in GiBs) can be equal to or less than capacity pool size. This recommendation is based on the assumption that you're using automatic QoS capacity pool types. To further optimize capacity versus throughput distribution across volumes within a capacity pool, consider manual QoS capacity pool types.
- **Capacity Pool Size**. The pool size. A volume's capacity is carved from a capacity pool. Capacity pools are sized in 1-TiB increments.
- **Capacity Pool Cost (USD/month)**. The cost per month of the capacity pool at the given size and service level.
- **Volume Show Back (USD/month)**. The cost per month of the capacity for the volume at the specified capacity. Charges are based on the allocated capacity pool sizes. The volume show back indicates the volume amount.

> [!NOTE]
> The user experience is the same regardless of the service level, as long as sufficient bandwidth is provisioned.

Control costs as needed by using volume shaping in Azure NetApp Files. Two dynamic options are available to influence performance and cost:

- [Dynamically resize a volume and capacity pool](/azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes)
- [Dynamically change the service level of a volume](/azure/azure-netapp-files/dynamic-change-volume-service-level)

Learn more about the [Azure NetApp Files cost model](/azure/azure-netapp-files/azure-netapp-files-cost-model).

## Data protection

Azure NetApp Files uses [snapshots](/azure/azure-netapp-files/snapshots-introduction) to help you protect your data. Snapshots provide space-efficient, crash-consistent, near-instantaneous images of your Azure NetApp Files volumes. You can create snapshots manually at any time or schedule them by using a [snapshot policy](/azure/azure-netapp-files/snapshots-manage-policy) on the volume.

Use a snapshot policy to add automated data protection to your volumes. You can restore snaphots in place quickly by using [snapshot revert](/azure/azure-netapp-files/snapshots-revert-volume). Or you can [restore a snapshot to a new volume](/azure/azure-netapp-files/snapshots-restore-new-volume) for fast data recovery. You can also use [restore to new volume functionality](/azure/azure-netapp-files/snapshots-introduction#restoring-cloning-an-online-snapshot-to-a-new-volume) to provide test/dev environments with current data.

For extra levels of data protection, you can use data protection solutions that use [Azure NetApp Files backup](/azure/azure-netapp-files/backup-introduction) or partner backup software.

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines): SAS Grid requires high memory, storage, and I/O bandwidth, in an appropriate ratio with the number of cores. Azure offers predefined virtual machine (VM) sizes with lower vCPU counts that can help to balance the number of cores required with the amount of memory, storage, and I/O bandwidth.

  For more information, see [Constrained vCPU capable VM sizes](/azure/virtual-machines/constrained-vcpu). It's important to thoroughly understand what compute resources are available with *each* instance. To run SAS Grid on Azure with Azure NetApp Files, we recommended these instance types:

    - Standard_E64-16ds_v4 or Standard_E64-16ds_v5
    - Standard_E64-32ds_v4 or Standard_E64-32ds_v5 

  Be sure to review the [best practices for using SAS on Azure](https://communities.sas.com/t5/Administration-and-Deployment/Best-Practices-for-Using-Microsoft-Azure-with-SAS/td-p/676833), including the updates in the comments.

- [Azure NetApp Files](https://azure.microsoft.com/products/netapp): You can store SASDATA on an Azure NetApp Files volume, shared across the compute cluster. 

  You can optionally also use Azure NetApp Files NFS volumes for SASWORK.

  Azure NetApp Files is available in three performance [service levels](/azure/azure-netapp-files/azure-netapp-files-service-levels):
 
  - Standard
  - Premium
  - Ultra

  Your volume performance is mostly defined by the service level. The size of your volume is also a factor, because the obtainable throughput is [determined by the service level and the size of the volume](/azure/azure-netapp-files/azure-netapp-files-service-levels#throughput-limits).

## Storage options for SASDATA

Because Azure NetApp Files can provide high throughput and low-latency access to storage, it's a viable, and faster, alternative to Premium Disk. Network-attached storage isn't throttled at the VM level as it is with managed disks, so you get higher throughput to storage. 

To estimate the required tier for your SASDATA capacity, use the [Azure NetApp Files Performance Calculator](https://cloud.netapp.com/azure-netapp-files/sizer). (Be sure to select **advanced**.)

Because Azure NetApp Files NFS volumes are shared, they're a good candidate for hosting SASDATA, when used with the properly sized VM instance types and Red Hat Enterprise Linux (RHEL) distribution, discussed later in this article.

## Storage options for SASWORK 

The following table shows the most common storage options for deploying SASWORK on Azure. Depending on your size (capacity) and speed (bandwidth) requirements, you have three options: temporary storage, managed disk, and Azure NetApp Files. 

||	Temporary storage|	Managed disk|	Azure NetApp Files|
|-|-|-|-|
|Size	|Small	|Large|	Extra large|
|Speed	|Extra large	|Small|	Medium|

Take these considerations into account when choosing an option:

-	[Temporary storage](https://azure.microsoft.com/blog/virtual-machines-best-practices-single-vms-temporary-storage-and-uploaded-disks) (or *ephemeral storage*) provides the highest bandwidth, but it's available only in smaller sizes. (Size depends on the VM SKU.) Depending on the available and required capacities, this option might be best.
-	If the required SASWORK capacity exceeds the temporary storage size of the VM SKU that you've selected, consider using an Azure managed disk to host SASWORK. Keep in mind, however, that the throughput to a managed disk is limited by the VM architecture by design, and that it varies depending on the VM SKU. Therefore, this storage option is viable only for environments that have lower SASWORK performance requirements. 
-	For the highest SASWORK capacity requirements and an average performance requirement beyond what Azure managed disks can provide, consider Azure NetApp Files for SASWORK. It provides a large size together with fast throughput.

> [!IMPORTANT]
> In any scenario, keep in mind that SASWORK can't be shared between VM compute nodes, so you need to create separate SASWORK volumes for each compute node. Volumes need to be NFS-mounted on only one compute node.

In using the preceding table, to decide whether your needs are small, large, medium, or extra large, take into account the scale of the deployment, the number of VMs and cores, and the associated capacity and performance requirements. You need to make these assessments for each deployment.

The options in the table correspond to deployments described in the architectures that follow. In all scenarios, SASDATA is hosted on an Azure NetApp Files NFS volume and shared across the compute nodes. For some RHEL distributions, we recommend using the NFS [nconnect](/azure/azure-netapp-files/performance-linux-mount-options) option to create multiple network flows to the volume. For more information, see the [NFS mount options](#nfs-mount-options) section of this article.

## Temporary storage architecture

:::image type="content" source="media/temporary-storage.png" alt-text="Diagram that shows a temporary storage architecture." lightbox="media/temporary-storage.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/sas-grid.pptx) of the architectures in this article.* 

For smaller SASWORK capacity requirements, Azure VM temporary storage is a fast and cost-effective solution. In this architecture, each VM in the compute tier is equipped with some temporary storage. To determine the temporary storage sizes for the VMs you use, see the [Azure VM documentation](/azure/virtual-machines/sizes).

### Dataflow 

- A compute node reads input data from SASDATA and writes results back to SASDATA.
- A subsequent part of the analytics job can be run by another node in the compute tier. It uses the same procedure to obtain and store the information that it needs to process.
- The temporary work directory SASWORK isn't shared. It's stored in temporary storage on each compute node. 

## Managed disk architecture

:::image type="content" source="media/managed-disk.png" alt-text="Diagram that shows a managed disk architecture." lightbox="media/managed-disk.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/sas-grid.pptx) of the architectures in this article.* 

If your capacity requirements for SASWORK exceed the capacities available in temporary storage, Azure managed disks are a good alternative. Managed disks are available in various sizes and performance levels. For more information, see [Scalability and performance targets for VM disks](/azure/virtual-machines/disks-scalability-targets).

### Dataflow

-	A compute node reads input data from SASDATA and writes results back to SASDATA.
-	A subsequent part of the analytics job can be run by another node in the compute tier. It uses the same procedure to obtain and store the information that it needs to process.
-	The temporary work directory SASWORK isn't shared. It's stored on managed disks that are attached to each compute node. 

## Azure NetApp Files architecture

:::image type="content" source="media/azure-netapp-files.png" alt-text="Diagram that shows an Azure NetApp Files architecture." lightbox="media/azure-netapp-files.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/sas-grid.pptx) of the architectures in this article.*

For higher SASWORK capacity and/or medium performance requirements, consider using Azure NetApp Files. Azure NetApp Files provides volume capacities as high as 100 TiB. Each node in the compute tier should have its own SASWORK volume. The volumes shouldn't be shared. 

### Dataflow

-	A compute node reads input data from SASDATA and writes results back to SASDATA.
-	A subsequent part of the analytics job can be run by another node in the compute tier. It uses the same procedure to obtain and store the information that it needs to process.
-	The temporary work directory SASWORK isn't shared. It's stored on individual Azure NetApp Files volumes that are attached to each compute node. 

## Scale and configuration recommendations

- For the best and most consistent latency for data traffic between the instances in the SAS cluster, make sure all VMs are created in the same [proximity placement group](/azure/virtual-machines/co-location).
- Review the **General Tuning Guidance** section in [Best Practices for Using SAS on Azure](https://communities.sas.com/t5/Administration-and-Deployment/Best-Practices-for-Using-Microsoft-Azure-with-SAS/m-p/676833#M19680).
- For optimal network bandwidth, enable [Accelerated Networking](/azure/virtual-network/accelerated-networking-how-it-works).

## RHEL distributions and NFS settings

### RHEL distributions

RHEL is the recommended distribution for running SAS 9 on Linux. Each kernel supported by Red Hat has its own NFS bandwidth constraints.

For specifics about running SAS on Azure, see [Best Practices for Using SAS on Azure](https://communities.sas.com/t5/Administration-and-Deployment/Best-Practices-for-Using-Microsoft-Azure-with-SAS/m-p/676833#M19680). 

Azure Standard_E64-16ds_v4 and Standard_E64-32ds_v4 VMs, or their v5 equivalents, are recommended for SAS. Taking these recommendations into account, this section provides some guidelines for using SAS with Azure NetApp Files.

- If you use RHEL 7, Standard_E64-16ds_v4 or Standard_E64-16ds_v5 is the best choice, based on the 100-MiB/s per physical core target for SASDATA.
   - Standard_E64-16ds_v4: 90–100 MiB/s per core
   - Standard_E64-32ds_v4: 45-50 MiB/s per core

- If you use RHEL 8.2, either Standard_E64-16ds_v4 or Standard_E64-32ds_v4, or their v5 equivalents, are possible options. Standard_E64-16ds_v4 is preferable, given the 100-MiB/s per core target for SASDATA.
   - Standard_E64-16ds_v4: 150-160 MiB/s per core
   - Standard_E64-32ds_v4: 75-80 MiB/s per core

- If you use RHEL 8.3, both Standard_E64-16ds_v4 and Standard_E64-32ds_v4, or their v5 equivalents, are fully acceptable, given the per-core throughput target:
   - Validation indicates 3,200 MiB/s of reads.
   - These results are achieved with the NFS `nconnect` mount option.

Testing shows that a single RHEL 7 instance achieves no more than roughly 750-800 MiB/s of read throughput against a single Azure NetApp Files storage endpoint (that is, against a network socket). 1,500 MiB/s of writes are achievable against the same endpoint, if you use 64-KiB `rsize` and `wsize` NFS mount options. Some evidence suggests that the previously noted read throughput ceiling is an artifact of the 3.10 kernel. For more information, see [RHEL CVE-2019-11477](https://access.redhat.com/security/cve/cve-2019-11477).

Testing shows that a single RHEL 8.2 instance, with its 4.18 kernel, is free of the limitations noted in the 3.10 kernel. So 1,200-1,300 MiB/s of read traffic is achievable, if you use a 64-KiB `rsize` and `wsize` NFS mount option. For large sequential writes, you can expect the same 1500 MiB/s of achievable throughput that you'd get on RHEL 7.

With a single RHEL 8.3 instance, with the [nconnect mount option](https://access.redhat.com/solutions/4090971) (which is new in the RHEL 8.3 distribution), about 3,200 MiB/s read throughput is achievable from a single Azure NetApp Files volume. Don't expect more than 1,500 MiB/s of writes to an Azure NetApp Files single volume, even when you apply `nconnect`.  

### Kernel tunables

#### Slot table entries

NFSv3 doesn't have a mechanism to [negotiate concurrency](/azure/azure-netapp-files/performance-linux-concurrency-session-slots#nfsv3) between the client and the 
server. The client and the server each define their limits without awareness of the other. For the best performance, you should line up the maximum number of client-side `sunrpc` slot table entries with that supported without pushback on the server. When a client overwhelms the server network stack's ability to process a workload, the server responds by decreasing the window size for the connection, which isn't ideal for performance.

By default, modern Linux kernels define the per-connection `sunrpc` slot table entry size `sunrpc.max_tcp_slot_table_entries` to support 65,536 outstanding operations. These slot table entries define the limits of concurrency. Values this high are unnecessary because Azure NetApp Files defaults to 128 outstanding operations. 

We recommend that you to tune the client to the same number:

- Kernel tunables (via */etc/sysctl.conf*)
   - `sunrpc.tcp_max_slot_table_entries=128`

#### File system cache tunables

You also need to [understand the following factors](/azure/azure-netapp-files/performance-linux-filesystem-cache) about file system cache tunables:

- Flushing a dirty buffer leaves the data in a clean state, usable for future reads until memory pressure leads to eviction.
- There are three triggers for an asynchronous flush operation:
   - Time based: When a buffer reaches the age defined by the [vm.dirty_expire_centisecs](/azure/azure-netapp-files/performance-linux-filesystem-cache#vmdirty_expire_centisecs) or [vm.dirty_writeback_centisecs](/azure/azure-netapp-files/performance-linux-filesystem-cache#vmdirty_writeback_centisecs) tunable, it must be marked for cleaning (that is, flushing or writing to storage).
   - Memory pressure: For details, see [vm.dirty_ratio | vm.dirty_bytes](/azure/azure-netapp-files/performance-linux-filesystem-cache#vmdirty_ratio--vmdirty_bytes).
   - Close: When a file handle is closed, all dirty buffers are asynchronously flushed to storage.

These factors are controlled by four tunables. You can tune each tunable dynamically and persistently by using `tuned` or `sysctl` in the */etc/sysctl.conf* file. Tuning these variables improves performance for SAS Grid:

- Kernel tunables (via custom tuned profile)
   - `include = throughput-performance`
   - `vm.dirty_bytes = 31457280`
   - `vm.dirty_expire_centisecs = 100`
   - `vm.dirty_writeback_centisecs = 300`

### NFS mount options

We recommend the following NFS mount options for NFS shared file systems that are used for permanent **SASDATA** files:

RHEL 7 and 8.2

```
bg,rw,hard,rsize=65536,wsize=65536,vers=3,noatime,nodiratime,rdirplus,acdirmin=0,tcp,_netdev
```

RHEL 8.3
```
bg,rw,hard,rsize=65536,wsize=65536,vers=3,noatime,nodiratime,rdirplus,acdirmin=0,tcp,_netdev,nconnect=8
```

We recommend the following mount options for **SASWORK** volumes, where the respective volumes are used exclusively for SASWORK and not shared between nodes:

RHEL 7 and 8.2

```
bg,rw,hard,rsize=65536,wsize=65536,vers=3,noatime,nodiratime,rdirplus,acdirmin=0,tcp,_netdev,nocto
```

RHEL 8.3

```
bg,rw,hard,rsize=65536,wsize=65536,vers=3,noatime,nodiratime,rdirplus,acdirmin=0,tcp,_netdev,nocto,nconnect=8
```

For more information on the benefits and cost of the `nocto` mount option, see [Close-to-open consistency and cache attribute timers](/azure/azure-netapp-files/performance-linux-mount-options#close-to-open-consistency-and-cache-attribute-timers).

You should also review [Azure NetApp Files: A shared file system to use with SAS Grid on MS Azure](https://communities.sas.com/t5/Administration-and-Deployment/Azure-NetApp-Files-A-shared-file-system-to-use-with-SAS-Grid-on/m-p/579437), including all updates in the comments.

### NFS read-ahead settings

We recommend that you set the NFS read-ahead tunable for all RHEL distributions to 15,360 KiB. For more information, see [How to persistently set read-ahead for NFS mounts](/azure/azure-netapp-files/performance-linux-nfs-read-ahead#how-to-persistently-set-read-ahead-for-nfs-mounts).

### Alternatives

The storage solution in the preceding architectures is highly available, as specified by the [Azure NetApp Files service level agreement](https://azure.microsoft.com/support/legal/sla/netapp/v1_1). For extra protection and availability, you can replicate the storage volumes to another Azure region by using Azure NetApp Files [cross-region replication](/azure/azure-netapp-files/cross-region-replication-introduction). 

There are two key advantages to replicating the volumes via the storage solution: 

- There's no additional load on the application VMs.
- This solution eliminates the need to run VMs in the destination region during normal operation. 

The storage contents are replicated without the use of any compute infrastructure resources, and the destination region doesn't need to run the SAS software. The destination VMs don't need to be running to support this scenario.

The following architecture shows how the storage content on Azure NetApp Files is replicated to a second region, where the storage is populated with a replica of the production data. If there's a failover, the secondary region is brought online, and the VMs are started so production can resume in the second region. You need to reroute traffic to the second region by reconfiguring load balancers that aren't shown in the diagram.

:::image type="content" source="media/replication.png" alt-text="Diagram that shows an architecture with cross-region replication." lightbox="media/replication.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/sas-grid.pptx) of the architectures in this article.*

The typical RPO for this solution is less than 20 minutes when the cross-region replication update interval is set to 10 minutes. 

#### Dataflow 

-	A compute node reads input data from SASDATA and writes results back to SASDATA.
-	A subsequent part of the analytics job can be run by another node in the compute tier. It uses the same procedure to obtain and store the information that it needs to process.
-	The temporary work directory SASWORK isn't shared. It's stored on individual Azure NetApp Files volumes that are attached to each compute node. 
-	Azure NetApp Files cross-region replication asynchronously replicates the SASDATA volume, including all snapshots, to a DR region to facilitate failover if there's a regional disaster.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Azure NetApp Files provides a standard 99.99% availability [SLA](https://azure.microsoft.com/support/legal/sla/netapp/v1_1) for all tiers and all supported regions. Azure NetApp Files also supports provisioning volumes in [availability zones](/azure/azure-netapp-files/use-availability-zones) that you choose, and HA deployments across zones.

For improved RPO/RTO SLAs, integrated data protection with [snapshots and backup](/azure/azure-netapp-files/snapshots-introduction) is included with the service. [Cross-region replication](/azure/azure-netapp-files/snapshots-introduction#how-volumes-and-snapshots-are-replicated-cross-region-for-dr) provides the same benefits across Azure regions.	

### Security

Security provides assurance against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Azure NetApp Files provides a level of [security](/azure/azure-netapp-files/faq-security#can-the-network-traffic-between-the-azure-vm-and-the-storage-be-encrypted) because volumes are provisioned, and data traffic stays, within your virtual networks. There's no publicly addressable endpoint. All [data is encrypted at rest](/azure/azure-netapp-files/faq-security#can-the-storage-be-encrypted-at-rest) at all times. You can optionally encrypt data-in-transit. 

[Azure Policy](/azure/governance/policy/overview) can help you enforce organizational standards and assess compliance at scale. Azure NetApp Files supports Azure Policy via [custom and built-in policy definitions](/azure/azure-netapp-files/azure-policy-definitions). 

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

#### Performance

Depending on your requirements for throughput and capacity, keep the following considerations in mind:

-	The [performance considerations for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-performance-considerations).
- The required Azure NetApp Files capacity and service levels for SASDATA.
- The guidance in this article for choosing a storage type for SASWORK.

> [!NOTE]
> Azure NetApp Files large volumes feature is now available. This feature provides higher per-volume throughput than regular Azure NetApp Files volumes do. This capability can be considered in case more performance is required for your SASDATA (or SASWORK) volumes. See [this documentation](/azure/azure-netapp-files/large-volumes-requirements-considerations#requirements-and-considerations) for details.

#### Scalability

You can easily scale compute performance by adding VMs to the scale sets that run the three tiers of the SAS solution. 

You can dynamically scale storage of Azure NetApp Files volumes. If you use [automatic QoS](/azure/azure-netapp-files/azure-netapp-files-performance-considerations), performance is scaled at the same time. For more granular control of each volume, you can also control the performance of each volume separately by using [manual QoS](/azure/azure-netapp-files/azure-netapp-files-performance-considerations#manual-qos-volume-quota-and-throughput) for your capacity pools.

Azure NetApp Files volumes are available in three performance tiers: [Ultra, Premium, and Standard](/azure/azure-netapp-files/azure-netapp-files-service-levels#supported-service-levels). Choose the tier that best suits your performance requirements, taking into account that available performance bandwidth [scales with the size of a volume](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels#throughput-limits). You can change the service level of a volume at any time. For more information about the Azure NetApp Files cost model, see these [pricing examples](/azure/azure-netapp-files/azure-netapp-files-cost-model#pricing-examples).

You can use the [Azure NetApp Files Performance Calculator](https://cloud.netapp.com/azure-netapp-files/sizer) to get started. 

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

#### Cost model

Understanding the [cost model for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-cost-model) can help you manage your expenses.

Azure NetApp Files billing is based on provisioned storage capacity, which you allocate by creating capacity pools. Capacity pools are billed monthly based on a set cost per allocated GiB per hour.

If your capacity pool size requirements fluctuate (for example, because of variable capacity or performance needs), consider [dynamically resizing your volumes and capacity pools](/azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes) to balance cost with your capacity and performance needs.

If your capacity pool size requirements remain the same but performance requirements fluctuate, consider [dynamically changing the service level of a volume](/azure/azure-netapp-files/dynamic-change-volume-service-level). You can provision and deprovision capacity pools of different types throughout the month, providing just-in-time performance and reducing costs during periods when you don't need high performance.

#### Pricing

Based on your capacity and performance requirements, decide which Azure NetApp Files service level you need (Standard, Premium, or Ultra). Then use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator) to evaluate the costs for these components:

- SAS on Azure components
- Azure NetApp Files
- Managed disk (optionally)
- Virtual network
 
### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

SAS Grid on Azure provides flexibility and a fast deployment. Here are some benefits:

- Meet changing business demands with dynamic workload balancing
- Create a highly available SAS computing environment
- Get faster results from your existing IT infrastructure
- Grow computing resources incrementally and cost-effectively
- Manage all your analytical workloads
- Easily transition from a siloed server or multiple-PC environment to a SAS grid environment

## Deploy this scenario

It's best to deploy the workloads by using an infrastructure as code (IaC) process. SAS workloads can be sensitive to misconfigurations that often occur in manual deployments and reduce productivity.

To get a start with designing your SAS Grid on Azure solution, review [SAS on Azure Architecture](../../guide/sas/sas-overview.yml) and [Automating SAS Deployment on Azure by using GitHub Actions](https://github.com/grtn316/viya4-iac-azure). 

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Geert van Teylingen](https://www.linkedin.com/in/geertvanteylingen) | Group Product Manager
- [Arnt de Gier](https://www.linkedin.com/in/arntdegier) | Technical Marketing Engineer 

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Quickstart webinar on how to get started on Azure](https://www.sas.com/en_us/webinars/quickstarts-on-microsoft.html)
- [Azure NetApp Files: A shared file system to use with SAS Grid on Azure](https://communities.sas.com/t5/Administration-and-Deployment/Azure-NetApp-Files-A-shared-file-system-to-use-with-SAS-Grid-on/td-p/579437)
- [Azure NetApp Files Performance Calculator](https://cloud.netapp.com/azure-netapp-files/sizer)
- [Azure NetApp Files documentation](/azure/azure-netapp-files)
- [Training: Introduction to Azure NetApp Files](/training/modules/introduction-to-azure-netapp-files)

## Related resources

- [SAS on Azure, VM sizing recommendations](../../guide/sas/sas-overview.yml#vm-sizing-recommendations)
- [SAS on Azure, Azure NetApp Files](../../guide/sas/sas-overview.yml#azure-netapp-files-nfs) 
- [SAS on Azure, network and VM placement considerations](../../guide/sas/sas-overview.yml#network-and-vm-placement-considerations) 
- [SAS on Azure, security considerations](../../guide/sas/sas-overview.yml#security)
