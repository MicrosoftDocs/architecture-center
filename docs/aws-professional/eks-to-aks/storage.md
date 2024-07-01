---
title: Storage options for a Kubernetes cluster
description: Understand storage options for a Kubernetes cluster, and compare Amazon EKS and Azure Kubernetes Service (AKS) storage options.
author: paolosalvatori
ms.author: paolos
ms.date: 06/21/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - containers
  - storage
products:
  - azure-files
  - azure-kubernetes-service
  - azure-managed-disks
  - azure-netapp-files
  - azure-storage
---

# Storage options for a Kubernetes cluster

This article compares the storage capabilities of Amazon Elastic Kubernetes Service (Amazon EKS) and Azure Kubernetes Service (AKS) and describes the options to store workload data on AKS.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS storage options

In Amazon EKS, after Kubernetes version 1.11, the cluster has a default [StorageClass](/azure/aks/concepts-storage#storage-classes) called `gp2` for [persistent volume claims](/azure/aks/concepts-storage#persistent-volume-claims). Administrators can add drivers to define more storage classes, such as:

- Amazon EBS CSI driver as an Amazon EKS add-on
- Amazon EBS CSI self-managed add-on
- Amazon EFS CSI driver
- Amazon FSx for Lustre CSI driver
- Amazon FSx for NetApp ONTAP CSI driver

By adding drivers and storage classes, you can use storage services such as:

- Amazon Elastic Block Store (Amazon EBS), a block-level storage solution used with Amazon Elastic Compute Cloud (EC2) instances to store persistent data. This service is similar to Azure Disk Storage, which has several SKUs like Standard SSD, Premium SSD, or Ultra Disk, depending on needed performance.

- Amazon Elastic File System (Amazon EFS) , which provides network filesystem access to external file systems that can be shared across instances. The equivalent Azure solution is Azure Files and Azure Files Premium with both Server Message Block (SMB) 3.0 and NFS access.

- Lustre, an open-source file system commonly used in high-performance computing (HPC). In Azure, you can use Ultra Disks or Azure HPC Cache for workloads where speed matters, such as machine learning and HPC.

- NetApp ONTAP, fully managed ONTAP shared storage in Amazon Web Services (AWS). Azure NetApp Files is a similar file storage service in Azure built on NetApp technology.

## AKS storage options

Each AKS cluster includes the following [pre-created storage classes](/azure/aks/concepts-storage#storage-classes) by default:

- The default storage class, `managed-csi`, uses Disk Storage Standard SSD. Standard SSD is a cost-effective storage option optimized for workloads that need consistent performance at lower input-output operations per second (IOPS).
- The `managed-csi-premium` class uses Disk Storage Premium SSD managed disks.
- The `azurefile-csi` class uses Azure Files to provide concurrent shared access to the same storage volume, using SMB or NFS.
- The `azurefile-csi-premium` class uses Azure Files Premium for file shares with IOPS-intensive workloads. Azure Files Premium provides low latency and high throughput backed by SSD storage.

You can extend these options by adding other storage classes and integrating with other available storage solutions, such as:

- Ultra Disk Storage
- Azure NetApp Files
- HPC Cache
- NFS server
- Third-party storage solutions

### Azure Disk Storage

By default, an AKS cluster comes with pre-created `managed-csi` and `managed-csi-premium` storage classes that use [Disk Storage](https://azure.microsoft.com/services/storage/disks). Similar to Amazon EBS, these classes create a managed disk or block device that's attached to the node for pod access.

The Disk Storage storage classes allow both [static](/azure/aks/azure-disk-volume) and [dynamic](/azure/aks/azure-disks-dynamic-pv) volume provisioning. Reclaim policy ensures that the disk is deleted with the persistent volume. You can expand the disk by editing the persistent volume claim.

These storage classes use Azure managed disks with [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage). LRS means that the data has three synchronous copies within a single physical location in an Azure primary region. LRS is the least expensive replication option, but doesn't offer protection against a datacenter failure. To mitigate this risk, take regular backups or snapshots of Disk Storage data by using solutions like [Velero](https://github.com/vmware-tanzu/velero) or [Azure Backup](/azure/backup/backup-managed-disks) that can use built-in snapshot technologies.

Both storage classes are backed by managed disks, and both use solid-state disk (SSD) drives. It's important to understand the differences between Standard and Premium disks:

- Standard disks are priced based on size and storage transactions.
- Premium disks charge only by size, which can make them cheaper for workloads that require a high number of transactions.
- Premium SSDs provide a higher max throughput and IOPS, as [shown in this comparison](/azure/virtual-machines/disks-types).
- Premium storage is recommended for most production and development workloads.

If you use Azure managed disks as your primary storage class, consider the virtual machine (VM) SKU that you choose for your Kubernetes cluster. Azure VMs limit the number of disks that you can attach to them, and the limit varies with the VM size. Also, since Azure disks are mounted as `ReadWriteOnce`, they're available only to a single pod.

### Azure Premium SSD v2 disks

[Azure Premium SSD v2 disks](/azure/virtual-machines/disks-types#premium-ssd-v2) offer IO-intense enterprise workloads, a consistent submillisecond disk latency, and high IOPS and throughput. The performance (capacity, throughput, and IOPS) of Premium SSD v2 disks can be independently configured at any time, making it easier for more scenarios to be cost efficient while meeting performance needs. For more information on how to configure a new or existing AKS cluster to use Azure Premium SSD v2 disks, see [Use Azure Premium SSD v2 disks on Azure Kubernetes Service](/azure/aks/use-premium-v2-disks).

### Ultra Disk Storage

Ultra Disk Storage is an Azure managed disk tier that offers high throughput, high IOPS, and consistent low latency disk storage for Azure VMs. Ultra Disk Storage is intended for workloads that are data and transaction heavy. Like other Disk Storage SKUs, and Amazon EBS, Ultra Disk Storage mounts one pod at a time and doesn't provide concurrent access.

Use the flag `--enable-ultra-ssd` to [enable Ultra Disk Storage on your AKS cluster](/azure/aks/use-ultra-disks).

If you choose Ultra Disk Storage, be aware of its [limitations](/azure/virtual-machines/disks-enable-ultra-ssd#ga-scope-and-limitations), and make sure to select a compatible VM size. Ultra Disk Storage is available with locally redundant storage (LRS) replication.

### Bring your own keys (BYOK)

Azure encrypts all data in a managed disk at rest. By default, data is encrypted with Microsoft-managed keys. For more control over encryption keys, you can supply customer-managed keys to use for encryption at rest for both the OS and data disks for your AKS clusters. For more information, see [Bring your own keys (BYOK) with Azure managed disks in Azure Kubernetes Service (AKS)](/azure/aks/azure-disk-customer-managed-keys).

### Azure Files

Disk Storage can't provide concurrent access to a volume, but you can use [Azure Files](https://azure.microsoft.com/services/storage/files) to connect by using the SMB protocol, and then mount a shared volume that's backed by Azure Storage. This process provides a network-attached storage that's similar to Amazon EFS. As with Disk Storage, there are two options:

- Azure Files Standard storage is backed by regular hard disk drives (HDDs).
- Azure Files Premium storage backs the file share with high-performance SSD drives. The minimum file share size for Premium is 100 GB.

Azure Files has the following storage account replication options to protect your data in case of failure:

- **Standard_LRS**: Standard [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- **Standard_GRS**: Standard [geo-redundant storage (GRS)](/azure/storage/common/storage-redundancy#geo-redundant-storage)
- **Standard_ZRS**: Standard [zone-redundant storage (ZRS)](/azure/storage/common/storage-redundancy#zone-redundant-storage)
- **Standard_RAGRS**: Standard [read-access geo-redundant storage (RA-GRS)](/azure/storage/common/storage-redundancy#read-access-to-data-in-the-secondary-region)
- **Standard_RAGZRS**: Standard [read-access geo-zone-redundant storage(RA-GZRS)](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage)
- **Premium_LRS**: Premium [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- **Premium_ZRS**: Premium [zone-redundant storage (ZRS)](/azure/storage/common/storage-redundancy#zone-redundant-storage)

To optimize costs for Azure Files, purchase [Azure Files capacity reservations](/azure/storage/files/files-reserve-capacity).

### Azure Container Storage

[Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) is a cloud-based volume management, deployment, and orchestration service built natively for containers. It integrates with Kubernetes, allowing you to dynamically and automatically provision persistent volumes to store data for stateful applications running on Kubernetes clusters.

Azure Container Storage utilizes existing Azure Storage offerings for actual data storage and offers a volume orchestration and management solution purposely built for containers. Supported backing storage options include:

- [Azure Disks](/azure/virtual-machines/managed-disks-overview): Granular control of storage SKUs and configurations. They are suitable for tier 1 and general purpose databases.
- Ephemeral Disks: Utilizes local storage resources on AKS nodes (NVMe or temp SSD). Best suited for applications with no data durability requirement or with built-in data replication support. AKS discovers the available ephemeral storage on AKS nodes and acquires them for volume deployment.
- [Azure Elastic SAN](/azure/storage/elastic-san/elastic-san-introduction): Provision on-demand, fully managed resource. Suitable for general purpose databases, streaming and messaging services, CD/CI environments, and other tier 1/tier 2 workloads. Multiple clusters can access a single SAN concurrently, however persistent volumes can only be attached by one consumer at a time.

Until now, providing cloud storage for containers required using individual container storage interface (CSI) drivers to use storage services intended for IaaS-centric workloads and make them work for containers. This creates operational overhead and increases the risk of issues with application availability, scalability, performance, usability, and cost.

Azure Container Storage is derived from OpenEBS, an open-source solution that provides container storage capabilities for Kubernetes. By offering a managed volume orchestration solution via microservice-based storage controllers in a Kubernetes environment, Azure Container Storage enables true container-native storage.

Azure Container Storage is suitable in the following scenarios:

- **Accelerate VM-to-container initiatives:** Azure Container Storage surfaces the full spectrum of Azure block storage offerings that were previously only available for VMs and makes them available for containers. This includes ephemeral disk that provides extremely low latency for workloads like Cassandra, as well as Azure Elastic SAN that provides native iSCSI and shared provisioned targets.

- **Simplify volume management with Kubernetes:** By providing volume orchestration via the Kubernetes control plane, Azure Container Storage makes it easy to deploy and manage volumes within Kubernetes - without the need to move back and forth between different control planes.

- **Reduce total cost of ownership (TCO):** Improve cost efficiency by increasing the scale of persistent volumes supported per pod or node. Reduce the storage resources needed for provisioning by dynamically sharing storage resources. Note that scale up support for the storage pool itself isn't supported.

Azure Container Storage provides the following key benefits:

- **Rapid scale out of stateful pods:** Azure Container Storage mounts persistent volumes over network block storage protocols (NVMe-oF or iSCSI), offering fast attach and detach of persistent volumes. You can start small and deploy resources as needed while making sure your applications aren't starved or disrupted, either during initialization or in production. Application resiliency is improved with pod respawns across the cluster, requiring rapid movement of persistent volumes. Leveraging remote network protocols, Azure Container Storage tightly couples with the pod lifecycle to support highly resilient, high-scale stateful applications on AKS.

- **Improved performance for stateful workloads:** Azure Container Storage enables superior read performance and provides near-disk write performance by using NVMe-oF over RDMA. This allows customers to cost-effectively meet performance requirements for various container workloads including tier 1 I/O intensive, general purpose, throughput sensitive, and dev/test. Accelerate the attach/detach time of persistent volumes and minimize pod failover time.

- **Kubernetes-native volume orchestration:** Create storage pools and persistent volumes, capture snapshots, and manage the entire lifecycle of volumes using `kubectl` commands without switching between toolsets for different control plane operations.

### Azure NetApp Files

Like AWS NetApp ONTAP, Azure NetApp Files is an enterprise-class, high-performance, metered file storage service. Azure NetApp Files is fully managed in Azure using NetApp solutions. Like Azure Files, Azure NetApp Files lets multiple pods mount a volume. You can use [Astra Trident](https://docs.netapp.com/us-en/netapp-solutions/containers/rh-os-n_overview_trident.html), an open-source dynamic storage orchestrator for Kubernetes, to [configure your AKS cluster to use Azure NetApp Files](/azure/aks/azure-netapp-files).

Be aware of the [Resource limits for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-resource-limits). The minimum size of a capacity pool for Azure NetApp Files is 4 TiB. Azure NetApp Files charges by provisioned size rather than used capacity.

### Azure HPC Cache

[Azure HPC Cache](/azure/hpc-cache/hpc-cache-overview) speeds access to your data for HPC tasks, with all the scalability of cloud solutions. If you choose this storage solution, make sure to deploy your AKS cluster in a [region that supports Azure HPC cache](https://azure.microsoft.com/global-infrastructure/services/?products=hpc-cache&regions=all).

### NFS server

The best option for shared NFS access is to use Azure Files or Azure NetApp Files. You can also [create an NFS Server on an Azure VM](/azure/aks/azure-nfs-volume) that exports volumes.

Be aware that this option only supports static provisioning. You must provision the NFS shares manually on the server, and can't do so from AKS automatically.

This solution is based on infrastructure as a service (IaaS) rather than platform as a service (PaaS). You're responsible for managing the NFS server, including OS updates, high availability, backups, disaster recovery, and scalability.

## Ephemeral OS disk

By default, Azure automatically replicates the operating system disk for a virtual machine to Azure Storage to avoid data loss when the VM is relocated to another host. However, since containers aren't designed to have local state persisted, this behavior offers limited value while providing some drawbacks. These drawbacks include, but aren't limited to, slower node provisioning and higher read/write latency.

By contrast, ephemeral OS disks are stored only on the host machine, just like a temporary disk. With this configuration, you get lower read/write latency, together with faster node scaling and cluster upgrades.

> [!NOTE]
> When you don't explicitly request [Azure managed disks](/azure/virtual-machines/disks-types) for the OS, AKS defaults to ephemeral OS if possible for a given node pool configuration.

For more information, see:

- [Storage options for applications in Azure Kubernetes Service (AKS)](/azure/aks/concepts-storage#ephemeral-os-disk)
- [Ephemeral OS disks for Azure VMs](/azure/virtual-machines/ephemeral-os-disks). 

### Third-party solutions

Like Amazon EKS, AKS is a Kubernetes implementation, and you can integrate third-party Kubernetes storage solutions. Here are some examples of third-party storage solutions for Kubernetes:

- [Rook](https://rook.io/) turns distributed storage systems into self-managing storage services by automating storage administrator tasks. Rook delivers its services via a Kubernetes operator for each storage provider.
- [GlusterFS](https://www.gluster.org/) is a free and open-source scalable network filesystem that uses common off-the-shelf hardware to create large, distributed storage solutions for data-heavy and bandwidth-intensive tasks.
- [Ceph](https://www.ceph.com/en/) provides a reliable and scalable unified storage service with object, block, and file interfaces from a single cluster built from commodity hardware components.
- [MinIO](https://min.io/) multicloud object storage lets enterprises build AWS S3-compatible data infrastructure on any cloud, providing a consistent, portable interface to your data and applications.
- [Portworx](https://portworx.com/) is an end-to-end storage and data management solution for Kubernetes projects and container-based initiatives. Portworx offers container-granular storage, disaster recovery, data security, and multicloud migrations.
- [Quobyte](https://www.quobyte.com/) provides high-performance file and object storage you can deploy on any server or cloud to scale performance, manage large amounts of data, and simplify administration.
- [Ondat](https://docs.ondat.io/) delivers a consistent storage layer across any platform. You can run a database or any persistent workload in a Kubernetes environment without having to manage the storage layer.

## Kubernetes storage considerations

Consider the following factors when you choose a storage solution for Amazon EKS or AKS.

### Storage class access modes

In Kubernetes version 1.21 and newer, AKS and Amazon EKS storage classes use [Container Storage Interface (CSI) drivers](/azure/aks/csi-storage-drivers) only and by default.

Different services support storage classes that have different access modes.

| Service      | ReadWriteOnce | ReadOnlyMany | ReadWriteMany |
|--------------------|---------------|--------------|---------------|
| Azure Disks        |      X        |              |               |
| Azure Files         |      X        |      X       |       X       |
| Azure NetApp Files |      X        |       X      |       X       |
| NFS server         |      X        |       X      |       X       |
| Azure HPC Cache    |      X        |       X      |       X       |

### Dynamic vs static provisioning

[Dynamically provision volumes](/azure/aks/operator-best-practices-storage#dynamically-provision-volumes) to reduce the management overhead of statically creating persistent volumes. Set a correct reclaim policy to avoid having unused disks when you delete pods.

### Backup

Choose a tool to back up persistent data. The tool should match your storage type, such as snapshots, [Azure Backup](/azure/backup/backup-overview), [Velero](https://github.com/vmware-tanzu/velero) or [Kasten](https://www.kasten.io).

### Cost optimization

To optimize Azure Storage costs, use Azure Reservations. Make sure to [check which services support Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations#charges-covered-by-reservation). Also see [Cost management for a Kubernetes cluster](cost-management.yml).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal System Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Cloud Solution Architect

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer
- [Ed Price](https://www.linkedin.com/in/priceed) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.yml)
- [Kubernetes monitoring and logging](monitoring.yml)
- [Secure network access to Kubernetes](private-clusters.yml)
- [Cost management for Kubernetes](cost-management.yml)
- [Kubernetes node and node pool management](node-pools.yml)
- [Cluster governance](governance.md)

## Related resources

- [Azure Storage services](/learn/modules/azure-storage-fundamentals/)
- [Store data in Azure](/learn/paths/store-data-in-azure/)
- [Configure AKS storage](/learn/modules/configure-azure-kubernetes-service/5-kubernetes-storage)
- [Introduction to Azure NetApp Files](/learn/modules/introduction-to-azure-netapp-files/)
