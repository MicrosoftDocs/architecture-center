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