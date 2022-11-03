Deploy SAS Grid 9.4 on Azure NetApp Files

SAS is a vendor of software solutions for analytics, artificial intelligence, business intelligence, customer intelligence, data management, and fraud and security intelligence.

When considering deploying [SAS Grid in the Azure Cloud], [Azure NetApp Files] has proven to be a [viable primary storage option for SAS Grid]. SAS cluster sizes are predicated upon the architectural constraint of a single SASDATA namespace per SAS cluster and the available single [Azure NetApp Files volume bandwidth]. By using the scalable services of Azure NetApp Files, the storage allocations can be scaled up or down at any time without interruption to the services, and the storage service level can be adjusted to the performance requirements dynamically as well.

## Architecture

SAS analytics software provides a suite of services and tools for drawing insights from data and making intelligent decisions. SAS platforms fully support its solutions for areas such as data management, fraud detection, risk analysis, and visualization. SAS offers these primary platforms, which Microsoft has validated:

- SAS Grid 9.4
- SAS Viya

The following SAS Grid architecture has been validated:

- SAS Grid 9.4 on Linux

This guide provides general information for running SAS Grid 9.4 on Azure, using Azure NetApp Files for SASDATA storage. You will also find guidance on storage options for SASWORK. These guidelines assume that you host your own SAS solution on Azure in your own tenant. SAS doesn't host SAS Grid for you on Azure.

diagram 

link 

### Dataflow 

**The compute tier leverages SASDATA (and optionally SASWORK) volumes to share data across the grid.** SASDATA is an NFS connected volume on the Azure NetApp Files service.

1.	A compute node reads input data from SASDATA and writes its results back to the same.
2.	A subsequent part of the analytics job can be executed by another node in the compute tier and will use the same process to obtain and store the information it needs to process.

### Potential use cases

Use SAS Grid scalable deployment in Azure on Azure NetApp Files to perform e.g.:

- Financial analytics
- Fraud detection
- Tracking and protection of endangered species
- Acceleration of science and medicine
- Analytics and AI

## Requirements for storage performance

When considering deploying SAS 9.4 (SAS Grid or SAS Analytics Pro) in the Microsoft Azure Cloud, Azure NetApp Files is a viable primary storage option for SAS Grid clusters of limited size. Given the [SAS recommendation of 100MiB/s throughput per physical core], SAS Grid clusters using an Azure NetApp Files volume for SASDATA (persistent SAS data files) are scalable to 32-48 physical cores across two or more Microsoft Azure machine instances. Cluster sizes are predicated upon the architectural constraint of a single SASDATA namespace per SAS cluster and the available single Azure NetApp Files volume bandwidth. The core count guidance will be revisited continuously as Azure infrastructure (compute, network and per file system storage bandwidth) increases over time.

### Azure NetApp Files volume performance expectations

It has been tested and [documented] that a single Azure NetApp Files volume can deliver up to 4,500MiB/s of reads and 1,500MiB/s of writes.  Given an Azure instance type with sufficient egress bandwidth, a single virtual machine can consume all the write bandwidth of a single Azure NetApp Files volume. However, only the largest single virtual machine can consume all the read bandwidth of a single volume.

The main shared workload of SAS 9.4 – SASDATA – has an 80:20 read:write ratio and as such the important *per volume* numbers to know are:

- 80:20 workload with 64K Read/Write: 2,400MiB/s of read throughput and 600MiB/s of write throughput running concurrently (~3,000MiB/s combined)

The throughput numbers quoted above can be seen in the aforementioned [documentation] under NFS scale out workloads – 80:20 (column 3).

### Capacity Recommendations

Please see the following Azure NetApp Files performance calculator for guidance when sizing SASDATA volumes. As volume bandwidth is based upon volume capacity, and as capacity cost is based upon which service level is selected, and as service level selection is based upon capacity versus bandwidth needs, determining which service level to use is important.  Using this [calculator] (select advanced), enter data as follows:

-	Volume Size: <Desired Capacity>
-	I/O Size: 64KiB Sequential
-	Read Percentage: 80%
-	Throughput: <Desired Throughput considering 100MiB/s per core>
-	IOPS: **0**

The readout at the bottom of the screen advises capacity requirements at each service level and the cost per month thereof, based on list price for the selected region:

- Throughput: This is the bandwidth of the volume based on the workload mixture. For an 80% 64KiB sequential read workload, 3096MiB/s is the anticipated maximum.
- IOPS: This is the number of IOPS the volume will deliver at the above throughput target.
- Capacity Pool Size: a volume’s capacity is carved from a capacity pool.  Capacity pools are sized in 1TiB increments.
- Volume Size: This is the amount of capacity needed by the volume at the given service levels to achieve the required throughput.  Volume capacity (reported in GiBs) may be equal to or less than capacity pool size. This recommendation assumes auto QoS capacity pool types are being used. To further optimize capacity versus throughput distribution across volumes within a capacity pool optionally manual QoS type capacity pool types can be considered.
- Capacity Pool Cost (USD/Month): This is the cost per month of the capacity pool at the given size and service level.
- Volume Show Back (USD/Month): This is the cost per month of the capacity for the volume at the specified capacity.  Charges are based on the allocated capacity pool sizes; the volume show back indicates the volume part thereof.

(i) Note 

The user experience will be the same regardless of which service level is selected, as long as sufficient bandwidth is provisioned.

Control costs using the concept of volume shaping with Azure NetApp Files, as you see fit. Two dynamic options are available to customers to influence performance and cost.
 
- [Dynamically resize a volume and capacity pool]()
- [Dynamically change the service level of a volume]()

Learn more about [Azure NetApp Files cost modeling]().

## Data Protection

Azure NetApp Files has a built-in data protection capability using [snapshots]. Snapshots provide space efficient, crash consistent near-instantaneous images of your Azure NetApp Files volume(s), and can be created manually at any time, or scheduled by using a [snapshot policy] on the volume.

Use a [snapshot policy] to add automated data protection to the volume(s). Snapshots can be restored in-place really quickly using [snapshot revert], or [restored to a new volume] for fast and easy data recovery. The [restore to new volume functionality] can also be used to provide test/dev environments with current data quickly and efficiently.

External data protection solutions using [Azure NetApp Files backup] or third party backup software may be selected to create additional levels of data protection.

### Components

Azure constrained vCPU instance types

[Azure Virtual Machines]: SAS Grid requires high memory, storage, and I/O bandwidth, in an appropriate ratio with the number of cores. Azure offers pre-defined VM sizes with lower vCPU count which can help to balance the number of cores required with the amount of memory, storage, and I/O bandwidth.

Read the following document to understand the [constrained vCPU instance types] available in Azure. Read the description carefully to thoroughly understand what compute resources are available with **each** instance. To run SAS Grid on Azure using Azure NetApp Files, these are the recommended instance types:

- E64-16ds_v4 - or v5 equivalent
- E64-32ds_v4 - or v5 equivalent

Make sure to review [Best Practices] for using SAS on Azure, including all updates in the comments.

Azure NetApp Files 

[Azure NetApp Files]: A viable option is to store SASDATA on an Azure NetApp Files volume, shared across the compute cluster. 

The use of Azure NetApp Files NFS volumes for SASWORK is optional. 

Azure NetApp Files comes in three performance [service levels]:
 
- standard
- premium
- ultra

Your volume performance is defined primarily by the selected service level, but also by the size of your deployed volume, since the obtainable throughput is a [function of the service level times the size of the volume]().

The following chapter describes the various Azure NetApp Files storage options for running SAS Grid in Azure.

Storage options for SASDATA

Due to the ability of Azure NetApp Files to deliver high throughput and low latency access to storage, it is a viable and even faster alternative to premium disk. Network attached storage is not throttled at the VM level like managed disk is, which results in much higher throughput to the storage. 

In order to estimate the required tier for your SASDATA capacity a performance sizing calculator is available [here] (make sure to select advanced).

image 

Storage options for SASWORK 

Depending on the SAS Grid deployment scale there are a few storage options to consider for storing SASWORK data. The following table shows the three most common storage options for deploying SASWORK in Azure. Depending on the size (capacity) and speed (bandwidth) requirements select one of the three options:

image 

To make the right decision, the following aspects need to be considered:

1.	[Temporary storage] (or “Ephemeral storage”) provides the greatest bandwidth, but comes in smaller sizes only, where size is depending on VM SKU. Depending on available and required capacities this may be the best option, or otherwise the following alternatives can be considered.
2.	Alternatively, if the required SASWORK capacity exceeds the Temporary storage size of the selected VM SKU, the next option would be to look at Azure Managed Disk to host SASWORK. However, it is important to realize that the throughput to Managed Disk is limited by the VM architecture by design and varies per VM SKU. This means this storage option is only viable for environments with lower SASWORK performance requirements. 
3.	Lastly, for the largest SASWORK capacity requirements and an average performance need beyond what Azure Managed Disk can provide, Azure NetApp Files can be considered for SASWORK since it provides large size combined with fast throughput.

(!) Important

In either scenario it is very important to realize SASWORK cannot, and shall not, be shared between VM compute nodes, and therefore separate SASWORK volumes will have to be created for each compute node, and NFS-mounted uniquely on that particular compute node ONLY.

The definition of S, M, L and XL in the table above will depend on the actual scale of the deployment, the number of selected VM SKUs and cores, and the associated capacity and performance requirements. This needs to be carefully assessed for each deployment.

The options in the table above translate into a deployment as per the below architectures. In all scenarios SASDATA is hosted on an Azure NetApp Files NFS volume and shared across the compute nodes. The use of the NFS [nconnect] option to create multiple network flows to the volume is recommended depending on the selected RHEL distribution. More about this later in this document.

image 

For smaller capacity requirements of SASWORK Azure VM Temporary storage is a fast and cost-effective solution. In this architecture each VM in the compute tier is equipped with a certain amount of Temporary storage. Please refer to the [Azure VM documentation] pages to understand the Temporary storage sizes for your selected SKU types.

### Dataflow 

1.	A compute node reads input data from SASDATA and writes its results back to the same.
2.	A subsequent part of the analytics job can be executed by another node in the compute tier and will use the same process to obtain and store the information it needs to process.
3.	The temporary work directory SASWORK is not shared and is stored on temporary storage on each compute node. 

image 

Where capacity requirements for SASWORK exceed the available Temporary storage capacities, Azure Managed Disk is a good alternative. Managed Disks are available in various sizes and performance levels. Details about Managed Disk are provided [here].

### Dataflow

1.	A compute node reads input data from SASDATA and writes its results back to the same.
2.	A subsequent part of the analytics job can be executed by another node in the compute tier and will use the same process to obtain and store the information it needs to process.
3.	The temporary work directory SASWORK is not shared and is stored on Azure Managed Disk attached to each compute node. 

image 

For the larger SASWORK capacity and/or ‘medium’ performance requirements consider using Azure NetApp Files. Azure NetApp Files provides volume capacities up to 100TiB in size. Each node in the compute tier will need to have its own SASWORK volume which should not be shared. 

### Dataflow

1.	A compute node reads input data from SASDATA and writes its results back to the same.
2.	A subsequent part of the analytics job can be executed by another node in the compute tier and will use the same process to obtain and store the information it needs to process.
3.	The temporary work directory SASWORK is not shared and is stored on individual Azure NetApp Files volumes attached to each compute node. 

Scale and configuration recommendations

For the best and most consistent latency experience of the data traffic between the instances in the SAS cluster, make sure all VMs are created in the same [proximity placement group].

Review the General Tuning Guidance section in the [Best Practices for Using SAS on Azure].

For optimal network bandwidth [Accelerated Networking] should be enabled.

RHEL distributions and NFS settings

RHEL distributions

Red Hat Enterprise Linux, (RHEL) is the distribution of choice for SAS customers when running SAS 9 on Linux.  Each of the kernels supported by Red Hat have their own unique bandwidth constraints in and of themselves when using NFS.

For specifics for running SAS on Microsoft Azure the [Best Practices for Using MS Azure with SAS paper] is a must-read. 

Azure instances E64-16ds_v4 and E64-32ds_v4 - or v5 equivalents - are recommended for SAS. Based on this, the following Azure NetApp Files relevant performance guidance is provided at a high level:

SAS on Azure NetApp Files sizing guidance:

- If using RHEL7, the E64-16ds_v4 - or v5 equivalent - is the best choice based upon the 100MiB/s per physical core target for SASDATA, e.g.:
   - E64-16ds_v4 – 90 –100MiB/s per core
   - E64-32ds_v4 – 45-50MiB/s per core

- If using RHEL8.2, using either the E64-16ds_v4 or E64-32ds_v4 - or v5 equivalents - are viable though the former is preferrable given the 100MiB/s per core target for SASDATA, e.g.:
   - E64-16ds_v4 – 150-160 MiB/s per core
   - E64-32ds_v4 – 75-80 MiB/s per core

- If using RHEL8.3, both the E64-16ds_v4 and the E64-32ds_v4 - or v5 equivalents - are fully acceptable given the per core throughput target, e.g.:
   - Validation indicates 3200MiB/s of Reads
   - These results are achieved by applying the NFS nconnect mount option

Testing has shown that a single RHEL 7 instance is expected to achieve no more than roughly 750-800MiB/s of read throughput against a single Azure NetApp Files storage endpoint (i.e., against a network socket) while 1500MiB/s of writes are achievable against the same, using a 64KiB rsize and wsize NFS mount options. There is evidence that the aforementioned read throughput ceiling is an artifact of the 3.10 kernel. Refer to [RHEL CVE-2019-11477] for detail.

Testing has shown that a single RHEL 8.2 instance with its 4.18 kernel is free of the limitations found in the 3.10 kernel above, as such 1200-1300MiB/s of read traffic, using a 64KiB rsize and wsize NFS mount option, is achievable. Expect the same 1500MiB/s of achievable throughput as seen in RHEL7 for large sequential writes.

It is understood that with a single RHEL 8.3 instance with the [nconnect mount option] (new to the RHEL8.3 distribution), somewhere around 3,200MiB/s read throughput is achievable from a single Azure NetApp Files volume.  Expect no more than 1,500MiB/s of writes to an Azure NetApp Files single volume, even when applying nconnect.  

Kernel tunables

Slot table entries

NFSv3 does not have a mechanism to [negotiate concurrency] between the client and the 
server. The client and the server each define their limits without consulting the other. For the best performance, you should line up the maximum number of client-side sunrpc slot table entries with that supported without pushback on the server. When a client overwhelms the server network stack’s ability to process a workload, the server responds by decreasing the window size for the connection, which is not an ideal performance scenario.

By default, modern Linux kernels define the per-connection sunrpc slot table entry size sunrpc.max_tcp_slot_table_entries as supporting 65,536 outstanding operations. These slot table entries define the limits of concurrency. Values this high are unnecessary, as Azure NetApp Files defaults to 128 outstanding operations. 

Therefore, it is recommended to tune the client to the same number:

- Kernel Tunables (via /etc/sysctl.conf)
   - sunrpc.tcp_max_slot_table_entries=128

Filesystem cache tunables

You also need to [understand the following factors] about filesystem cache tunables:

- Flushing a dirty buffer leaves the data in a clean state, usable for future reads until memory pressure leads to eviction.
- There are three triggers for an asynchronous flush operation:
   - Time based: When a buffer reaches the age defined by these [vm.dirty_expire_centisecs] | [vm.dirty_writeback_centisecs] tunables, it must be marked for cleaning (that is, flushing, or writing to storage).
   - Memory pressure: See [vm.dirty_ratio] | [vm.dirty_bytes] for details.
   - Close: When a file handle is closed, all dirty buffers are asynchronously flushed to storage.

These factors are controlled by four tunables. Each tunable can be tuned dynamically and persistently using tuned or `sysctl` in the `/etc/sysctl.conf` file. Tuning these variables improves performance for SAS Grid:

- Kernel Tunables (via custom tuned profile)
   - include = throughput-performance
   - vm.dirty_bytes = 31457280
   - vm.dirty_expire_centisecs = 100
   - vm.dirty_writeback_centisecs = 300

NFS Mount Options

The following NFS mount options are recommended for NFS shared file systems being used for permanent **SASDATA** files:

RHEL 7 and 8.2

```
bg,rw,hard,rsize=65536,wsize=65536,vers=3,noatime,nodiratime,rdirplus,acdirmin=0,tcp,_netdev
```

RHEL 8.3
```
bg,rw,hard,rsize=65536,wsize=65536,vers=3,noatime,nodiratime,rdirplus,acdirmin=0,tcp,_netdev,nconnect=8
```

Mount options for **SASWORK** volumes where the respective volumes are used for SASWORK exclusively and not shared between nodes:

RHEL 7 and 8.2

```
bg,rw,hard,rsize=65536,wsize=65536,vers=3,noatime,nodiratime,rdirplus,acdirmin=0,tcp,_netdev,nocto
```

RHEL 8.3

```
bg,rw,hard,rsize=65536,wsize=65536,vers=3,noatime,nodiratime,rdirplus,acdirmin=0,tcp,_netdev,nocto,nconnect=8
```
For more information on the benefits and cost of the **nocto** mount option, refer to [Close-to-open consistency and cache attribute timers].

Please review [Azure NetApp Files: A shared file system to use with SAS Grid on MS Azure], *including all updates in the comments*.

NFS readahead settings

It is recommended to set the NFS Readahead tunable for all RHEL distributions to 15,360 KiB per [these instructions].

Alternatives

The storage solution in the architecture above is highly available as specified by the [service level agreement], but for additional protection and availability the storage volumes can be replicated to another Azure region using Azure NetApp Files [cross region replication](). The key advantages to having the storage solution replicate the volumes is that there is no additional load on the application VMs and it eliminates the need to run virtual machines in the destination region during normal operation. The storage contents are replicated without using any compute infrastructure resources and as a bonus the destination region does not need to run the SAS software. The destination VMs do not need to be running to support this scenario.

The following architecture shows how the storage contents on Azure NetApp Files is replicated to a second region, where the storage is populated with a replica of the production data. In case of a failover the secondary region is brought online, and the virtual machines are started so production can resume at the second region. Traffic needs to be re-routed to the second region by reconfiguring load-balancers that are not depicted in this diagram.

image 

The typical RPO for this solution is less than 20 minutes when the cross-region replication update interval is set to 10 minutes. 

1.	A compute node reads input data from SASDATA and writes its results back to the same.
2.	A subsequent part of the analytics job can be executed by another node in the compute tier and will use the same process to obtain and store the information it needs to process.
3.	The temporary work directory SASWORK is not shared and is stored on individual Azure NetApp Files volumes attached to each compute node. 
4.	Azure NetApp Files cross-region replication is used to asynchronously replicate the SASDATA volume, including all snapshots, to the DR region of choice to facilitate failover in case of regional disaster.

Considerations

The [Azure Well-Architected Framework] is a set of guiding tenets that can be used to improve the quality of a workload. The framework consists of five pillars of architectural excellence:

- Reliability
- Security
- Performance Efficiency
- Cost Optimization
- Operational Excellence

The following sections describe how Azure NetApp Files helps comply with these framework pillars.

Reliability

Azure NetApp Files comes with a standard [99.99% availability SLA], for all tiers and all supported regions. Azure NetApp Files also supports [Availability Zone volume placement], enabling provisioning volumes in the Availability Zone of choice, as well as HA deployments across zones. 

Integrated data protection with [snapshots and backup] is included with the service for improved RPO/RTO SLAs, while [cross-region replication] helps achieving the same across Azure regions.	

Security

Azure NetApp Files is [inherently secure], as volume are provisioned – and data traffic stays –  within the confined customer VNets, and as such does not provide a publicly addressable endpoint. It is not available for consumption via the public Internet. All [data is encrypted at rest] at all times, and optionally data-in-transit can be encrypted. 

[Azure Policy] helps to enforce organizational standards and to assess compliance at-scale. Azure NetApp Files supports Azure Policy via [custom and built-in policy definitions]. 

Performance Efficiency

Performance

Depending on the requirements for throughput and capacity, consider the following:
1.	The performance characteristics of Azure NetApp Files volumes as explained in the [performance considerations for Azure NetApp Files].
2.	Required Azure NetApp Files capacity and service levels for SASDATA
3.	Using the guidance in this document to select your storage type for SASWORK

Scalability

The compute performance is easily scaled by adding more virtual machines into the scale sets that run the three tiers of the SAS solution. 

Storage is scaled by seamlessly increasing or decreasing the capacity of the Azure NetApp Files volumes, while performance is scaled at the same time, when [auto QoS] is selected. For more granular control of each volume’s performance, you can also control the performance of each volume separately by choosing [manual QoS] for your capacity pools. 

Azure NetApp Files volumes come in three performance tiers, [ultra, premium and standard]. Choose the tier that best suits your performance requirements taking into account that available performance bandwidth scales with the size of a volume, as explained [here]. You can change the service level of a volume at any time if a previously made selection proves to be inadequately oversized or undersized. Please refer to the Azure NetApp Files [cost model pricing examples].

You can use the [Azure NetApp Files Performance Calculator] to get you started. 

Cost Optimization

Cost modelling

Understanding the [cost model for Azure NetApp Files] helps you manage your expenses from the service.

Azure NetApp Files is billed on provisioned storage capacity, which is allocated by creating capacity pools. Capacity pools are billed monthly based on a set cost per allocated GiB per hour. Capacity pool allocation is measured hourly.

If your capacity pool size requirements fluctuate (for example, because of variable capacity or performance needs), consider [dynamically resizing your volumes and capacity pools] to balance cost with capacity and performance needs.

If your capacity pool size requirements remain the same but performance requirements fluctuate, consider [dynamically changing the service level of a volume]. You can provision and deprovision capacity pools of different types throughout the month, providing just-in-time performance, and lowering costs during periods where performance is not needed.

Pricing

Using the required capacity and performance requirements, decide which service level of Azure NetApp Files you need (standard, premium, ultra). Then use the [Azure Pricing calculator] to evaluate the costs involved for the following components:

- Required SAS on Azure components
- Azure NetApp Files
- Managed Disk (optionally)
- Virtual Network
 
Operational excellence

Bringing SAS Grid to the Azure Cloud brings unprecedented speed of deployment and flexibility. Benefits include:

- Meet changing business demands with dynamic workload balancing
- Create a highly available SAS computing environment
- Get faster results from your existing IT infrastructure
- Grow computing resources incrementally and cost-effectively
- Manage all your analytical workloads
- Easily transition from a siloed server or multiple PC environment to a SAS grid environment

Deploy the solution

It's best to deploy workloads using an infrastructure as code (IaC) process. SAS workloads can be sensitive to misconfigurations that often occur in manual deployments and reduce productivity.

To start designing your SAS Grid on Azure solution review the [SAS on Azure Architecture section] and [Automating SAS Deployment on Azure using GitHub Actions | GitHub]. 

## Next steps

Get started with SAS Grid on Azure by viewing this [quickstart webinar on how to get started on Microsoft Azure].

## Related resources

SAS on Azure architecture – VM Sizing recommendations | Microsoft Docs 
SAS on Azure architecture – SAS on Azure NetApp Files | Microsoft Docs
SAS on Azure architecture – Network and VM Placement considerations | Microsoft Docs
Azure NetApp Files: A shared file system to use with SAS Grid on MS Azure | SAS Support Communities
Azure NetApp Files Performance Calculator
Security considerations

