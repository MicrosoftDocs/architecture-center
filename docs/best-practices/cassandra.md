---
title: Run Apache Cassandra on Azure VMs
description: Examine performance considerations for running Apache Cassandra on Azure virtual machines. Use these recommendations as a baseline to test against your workload.
author: arsenvlad
ms.author: arsenv
categories: azure
ms.date: 03/31/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: best-practice
ms.custom:
  - fcp
  - cse
  - best-practice
azureCategories:
  - databases
products:
  - azure
  - azure-virtual-machines
---

<!-- cSpell:ignore arsenv arsenvlad DataStax mdadm -->

# Run Apache Cassandra on Azure VMs

This article describes performance considerations for running Apache Cassandra on Azure virtual machines.

These recommendations are based on the results of performance tests, which you can find on [GitHub][repo]. You should use these recommendations as a baseline and then test against your own workload.

## Azure Managed Instance for Apache Cassandra

If you're looking for a more automated service for running Apache Cassandra on Azure virtual machines, consider using [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/). This service automates the deployment, management (patching and node health), and scaling of nodes within an Apache Cassandra cluster. It also provides the capability for [hybrid clusters](/azure/managed-instance-apache-cassandra/configure-hybrid-cluster), so Apache Cassandra datacenters deployed in Azure can join an existing on-premises or third-party hosted Cassandra ring. The service is deployed by using [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview). The following recommendations were adopted during the development of this service.

## Azure VM sizes and disk types

Cassandra workloads on Azure commonly use either [Standard_DS14_v2][dsv2], [Standard_DS13_v2][dsv2], [Standard_D16s_v5][dsv5], or [Standard_E16s_v5][esv5] virtual machines. Cassandra workloads benefit from having more memory in the VM, so consider [memory optimized](/azure/virtual-machines/sizes-memory) virtual machine sizes, such as Standard_DS14_v2 or Standard_E16s_v5, or [local-storage optimized](/azure/virtual-machines/sizes-storage) sizes such as Standard_L16s_v3.

For durability, data and commit logs are commonly stored on a stripe set of two to four 1-TB [premium managed disks](/azure/virtual-machines/windows/disks-types#premium-ssd) (P30).

Cassandra nodes shouldn't be too data-dense. We recommend having at most 1 &ndash; 2 TB of data per VM and enough free space for compaction. To achieve the highest possible combined throughput and IOPS using premium managed disks, we recommend creating a stripe set from a few 1-TB disks, instead of using a single 2-TB or 4-TB disk. For example, on a DS14_v2 VM, four 1-TB disks have a maximum IOPS of 4 &times; 5000 = 20 K, versus 7.5 K for a single 4-TB disk.

Evaluate [Azure Ultra Disks](/azure/virtual-machines/linux/disks-enable-ultra-ssd) for Cassandra workloads that need smaller disk capacity. They can provide higher IOPS/throughput and lower latency on VM sizes like [Standard_E16s_v5][esv5] and [Standard_D16s_v5][dsv5].

For Cassandra workloads that don't need durable storage—that is, where data can be easily reconstructed from another storage medium—consider using [Standard_L16s_v3][lsv3] or [Standard_L16s_v2][lsv2] VMs. These VMs sizes have large and fast local *temporary* NVMe disks.

For more information, see [Comparing performance of Azure local/ephemeral vs attached/persistent disks](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-local-attached-disks.md) (GitHub).

## Accelerated Networking

Cassandra nodes make heavy use of the network to send and receive data from the client VM and to communicate between nodes for replication. For optimal performance, Cassandra VMs benefit from high-throughput and low-latency network.

We recommended enabling [Accelerated Networking](/azure/virtual-network/create-vm-accelerated-networking-cli) on the NIC of the Cassandra node and on VMs running client applications accessing Cassandra.

Accelerated networking requires a modern Linux distribution with the latest drivers, such as Cent OS 7.5+ or Ubuntu 16.x/18.x. For more information, see [Create a Linux virtual machine with Accelerated Networking](/azure/virtual-network/create-vm-accelerated-networking-cli#confirm-that-accelerated-networking-is-enabled).

## Azure VM data disk caching

Cassandra read workloads perform best when random-access disk latency is low. We recommend using Azure managed disks with [ReadOnly](/azure/virtual-machines/windows/premium-storage-performance#disk-caching) caching enabled. ReadOnly caching provides lower average latency, because the data is read from the cache on the host instead of going to the backend storage.

Read-heavy, random-read workloads like Cassandra benefit from the lower read latency even though cached mode has lower throughput limits than uncached mode. (For example, [DS14_v2](/azure/virtual-machines/dv2-dsv2-series-memory) virtual machines have a maximum cached throughput of 512 MB/s versus uncached of 768 MB/s.)

ReadOnly caching is particularly helpful for Cassandra time-series and other workloads where the working dataset fits in the host cache and data isn't constantly overwritten. For example, [DS14_v2](/azure/virtual-machines/dv2-dsv2-series-memory) provides a cache size of 512 GB, which could store up to 50% of the data from a Cassandra node with 1-2 TB data density.

There's no significant performance penalty from cache-misses when ReadOnly caching is enabled, so cached mode is recommended for all but the most write-heavy workloads.

For more information, see [Comparing Azure VM data disk caching configurations](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-azure-vm-data-disk-caching.md) (GitHub).

## Linux read-ahead

In most Linux distributions in the Azure Marketplace, the default block device read-ahead setting is 4096 KB. Cassandra's read IOs are usually random and relatively small. Therefore, having a large read-ahead wastes throughput by reading parts of files that aren't needed.

To minimize unnecessary lookahead, set the Linux block device read-ahead setting to 8 KB. (See [Recommended production settings](https://docs.datastax.com/en/dse/6.7/dse-admin/datastax_enterprise/config/configRecommendedSettings.html#OptimizeSSDs) in the DataStax documentation.)

Configure 8 KB read-ahead for all block devices in the stripe set and on the array device itself (for example, `/dev/md0`).

For more information, see [Comparing impact of disk read-ahead settings](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-read-ahead.md) (GitHub).

## Disk array mdadm chunk size

When running Cassandra on Azure, it's common to create an mdadm stripe set (that is, RAID 0) of multiple data disks to increase the overall disk throughput and IOPS closer to the VM limits. Optimal disk stripe size is an application-specific setting. For example, for SQL Server OLTP workloads, the recommendation is 64 KB. For data warehousing workloads, the recommendation is 256 KB.

Our tests found no significant difference between chunk sizes of 64k, 128k, and 256k for Cassandra read workloads. There seems to be a small, slightly noticeable, advantage to the 128k chunk size. Therefore, we recommend the following:

- If you're already using a chunk size of 64 K or 256 K, it doesn't make sense to rebuild the disk array to use 128-K size.

- For a new configuration, it makes senses to use 128 K from the beginning.

For more information, see [Measuring impact of mdadm chunk sizes on Cassandra performance](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-mdadm-chunk-sizes.md) (GitHub).

## Commit log filesystem

Cassandra writes perform best when commit logs are on disks with high throughput and low latency. In the default configuration, Cassandra 3.x flushes data from memory to the commit log file every ~10 seconds and doesn't touch the disk for every write. In this configuration, write performance is almost identical whether the commit log is on premium attached disks versus local/ephemeral disks.

Commit logs must be durable, so that a restarted node can reconstruct any data not yet in data files from the flushed commit logs. For better durability, store commit logs on premium managed disks and not on local storage, which can be lost if the VM is migrated to another host.

Based on our tests, Cassandra on CentOS 7.x may have *lower* write performance when commit logs are on the xfs versus ext4 filesystem. Turning on commit log compression brings xfs performance in line with ext4. Compressed xfs performs as well as compressed and non-compressed ext4 in our tests.

For more information, see [Observations on ext4 and xfs file systems and compressed commit logs](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-commitlogs-xfs-ext4.md) (GitHub).

## Measuring baseline VM performance

After deploying the VMs for the Cassandra ring, run a few synthetic tests to establish baseline network and disk performance. Use these tests to confirm that performance is in line with expectations, based on the [VM size](/azure/virtual-machines/linux/sizes).

Later, when you run the actual workload, knowing the performance baseline makes it easier to investigate potential bottlenecks. For example, knowing the baseline performance for network egress on the VM can help to rule out network as a bottleneck.

For more information about running performance tests, see [Validating baseline Azure VM Performance](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/baseline-vm-perf.md) (GitHub).

### Document size

Cassandra read and write performance depends on the document size. You can expect to see higher latency and lower operations/second when reading or writing with larger documents.

For more information, see [Comparing relative performance of various Cassandra document sizes](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-doc-sizes.md) (GitHub).

### Replication factor

Most Cassandra workloads use a replication factor (RF) of 3 when using attached premium disks and even 5 when using temporary/ephemeral local disks. The number of nodes in the Cassandra ring should be a multiple of the replication factor. For example, RF 3 implies a ring of 3, 6, 9, or 12 nodes, while RF 5 would have 5, 10, 15, or 20 nodes. When using RF greater than 1 and a consistency level of LOCAL_QUORUM, it's normal for read and write performance to be lower than the same workload running with RF 1.

For more information, see [Comparing relative performance of various replication factors](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-replication-factors.md) (GitHub).

### Linux page caching

When Cassandra's Java code reads data files, it uses regular file I/O and benefits from Linux page caching. After parts of the file are read one time, the read content is stored in the OS page cache. Subsequent read access to the same data is much faster.

For this reason, when executing read performance tests against the same data, the second and subsequent reads will appear to be much faster than the original read, which needed to access data on the remote data disk or from the host cache when ReadOnly is enabled. To get similar performance measurements on subsequent runs, clear the Linux page cache and restart the Cassandra service to clear its internal memory. When ReadOnly caching is enabled, the data might be in the host cache, and subsequent reads will be faster even after clearing the OS page cache and restarting the Cassandra service.

For more information, see [Observations on Cassandra usage of Linux page caching](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-linux-page-caching.md) (GitHub).

## Multi-datacenter replication

Cassandra natively supports the concept of multiple data centers, making it easy to configure one Cassandra ring across multiple [Azure regions](https://azure.microsoft.com/global-infrastructure/regions) or across [availability zones](/azure/availability-zones/az-overview) within one region.

For a multiregion deployment, use Azure Global VNet-peering to connect the virtual networks in the different regions. When VMs are deployed in the same region but in separate availability zones, the VMs can be in the same virtual network.

It's important to measure the baseline roundtrip latency between regions. Network latency between regions can be 10-100 times higher than latency within a region. Expect a lag between data appearing in the second region when using LOCAL_QUORUM write consistency, or significantly decreased performance of writes when using EACH_QUORUM.

When you run Apache Cassandra at scale, and specifically in a multi-DC environment, [node repair](https://cassandra.apache.org/doc/latest/cassandra/operating/repair.html) becomes challenging. Tools such as [Reaper](http://cassandra-reaper.io) can help to coordinate repairs at scale (for example, across all the nodes in a data center, one data center at a time, to limit the load on the whole cluster). However, node repair for large clusters isn't yet a fully solved problem and applies in all environments, whether on-premises or in the cloud.

When nodes are added to a secondary region, performance doesn't scale linearly, because some bandwidth and CPU/disk resources are spent on receiving and sending replication traffic across regions.

For more information, see [Measuring impact of multi-dc cross-region replication](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-multi-dc-azure-regions.md) (GitHub).

### Hinted-handoff configuration

In a multiregion Cassandra ring, write workloads with consistency level of LOCAL_QUORUM may lose data in the secondary region. By default, Cassandra hinted handoff is throttled to a relatively low maximum throughput and three-hour hint lifetime. For workloads with heavy writes, we recommended increasing the hinted handoff throttle and hint window time to ensure hints aren't dropped before they're replicated.

For more information, see [Observations on hinted handoff in cross-region replication](https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments/blob/master/docs/cassandra-hinted-handoff-cross-region.md) (GitHub).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author: 

 - [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer
 
 Other contributor:

 - [Theo van Kraay](https://www.linkedin.com/in/theo-van-kraay-3388b130/) | Senior Program Manager
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about these performance results, see [Cassandra on Azure VMs Performance Experiments][repo].

For information on general Cassandra settings, not specific to Azure, see:

- [DataStax Recommended Production Settings](https://docs.datastax.com/en/landing_page/doc/landing_page/recommendedSettings.html)

- [Apache Cassandra Hardware Choices](https://cassandra.apache.org/doc/latest/cassandra/operating/hardware.html)

- [Apache Cassandra Configuration File](https://cassandra.apache.org/doc/latest/cassandra/configuration/cass_yaml_file.html)

## Related resources

- [Linux N-tier application in Azure with Apache Cassandra](../reference-architectures/n-tier/n-tier-cassandra.yml)
- [N-tier architecture style](../guide/architecture-styles/n-tier.yml)
- [Data partitioning guidance](./data-partitioning.yml)


[dsv2]: /azure/virtual-machines/dv2-dsv2-series-memory
[dsv3]: /azure/virtual-machines/dv3-dsv3-series
[dsv5]: /azure/virtual-machines/dv5-dsv5-series
[esv5]: /azure/virtual-machines/ev5-esv5-series
[lsv2]: /azure/virtual-machines/lsv2-series
[lsv3]: /azure/virtual-machines/lsv3-series
[repo]: https://github.com/Azure-Samples/cassandra-on-azure-vms-performance-experiments
