---
title: Storage options for a Kubernetes cluster
description: Understand storage options for a Kubernetes cluster, and compare Amazon EKS and Azure Kubernetes Service (AKS) storage options.
author:  lanicolas
ms.author: lanicola
ms.date: 12/30/2022
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

- Amazon Elastic File System (Amazon EFS) , which provides Network File System (NFS) access to external file systems that can be shared across instances. The equivalent Azure solution is Azure Files and Azure Files Premium with both Server Message Block (SMB) 3.0 and NFS access.

- Lustre, an open-source file system commonly used in high performance computing (HPC). In Azure, you can use Ultra Disks or Azure HPC Cache for workloads where speed matters, such as machine learning and HPC.

- NetApp ONTAP, fully managed ONTAP shared storage in Amazon Web Services (AWS). Azure NetApp Files is a similar Azure file storage service built on NetApp technology.

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

### Ultra Disk Storage

Ultra Disk Storage is an Azure managed disk tier that offers high throughput, high IOPS, and consistent low latency disk storage for Azure VMs. Ultra Disk Storage is intended for workloads that are data and transaction heavy. Like other Disk Storage SKUs, and Amazon EBS, Ultra Disk Storage mounts one pod at a time and doesn't provide concurrent access.

Use the flag `--enable-ultra-ssd` to [enable Ultra Disk Storage on your AKS cluster](/azure/aks/use-ultra-disks).

If you choose Ultra Disk Storage, be aware of its [limitations](/azure/virtual-machines/disks-enable-ultra-ssd#ga-scope-and-limitations), and make sure to select a compatible VM size. Ultra Disk Storage is available with locally redundant storage (LRS) replication.

### Azure Files

Disk Storage can't provide concurrent access to a volume, but you can use [Azure Files](https://azure.microsoft.com/services/storage/files) to connect by using the SMB protocol, and then mount a shared volume that's backed by Azure Storage. This process provides a network attached storage that's similar to Amazon EFS. As with Disk Storage, there are two options:

- Azure Files Standard storage is backed by regular hard disk drives (HDDs).
- Azure Files Premium storage backs the file share with high-performance SSD drives. The minimum file share size for Premium is 100 GB.

Azure Files has the following storage account replication options to protect your data in case of failure:

- Standard_LRS with [LRS](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- Standard_GRS with [geo-redundant storage (GRS)](/azure/storage/common/storage-redundancy#geo-redundant-storage)
- Standard_ZRS with [zone-redundant storage (ZRS)](/azure/storage/common/storage-redundancy#zone-redundant-storage)
- Standard_RAGRS with [read-access geo-redundant storage (RA-GRS)](/azure/storage/common/storage-redundancy#read-access-to-data-in-the-secondary-region)
- Premium_LRS premium LRS
- Premium_ZRS premium ZRS

To optimize costs for Azure Files, purchase [Azure Files capacity reservations](/azure/storage/files/files-reserve-capacity).

### Azure NetApp Files

Like AWS NetApp ONTAP, Azure NetApp Files is an enterprise-class, high-performance, metered file storage service. Azure NetApp Files is fully managed in Azure using NetApp solutions. Like Azure Files, Azure NetApp Files lets multiple pods mount a volume. You can use [Astra Trident](https://docs.netapp.com/us-en/netapp-solutions/containers/rh-os-n_overview_trident.html), an open-source dynamic storage orchestrator for Kubernetes, to [configure your AKS cluster to use Azure NetApp Files](/azure/aks/azure-netapp-files).

Be aware of the [Resource limits for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-resource-limits). The minimum size of a capacity pool for Azure NetApp Files is 4 TiB. Azure NetApp Files charges by provisioned size rather than used capacity.

### Azure HPC Cache

[Azure HPC Cache](/azure/hpc-cache/hpc-cache-overview) speeds access to your data for HPC tasks, with all the scalability of cloud solutions. If you choose this storage solution, make sure to deploy your AKS cluster in a [region that supports Azure HPC cache](https://azure.microsoft.com/global-infrastructure/services/?products=hpc-cache&regions=all).

### NFS server

The best option for shared NFS access is to use Azure Files or Azure NetApp Files. You can also [create an NFS Server on an Azure VM](/azure/aks/azure-nfs-volume) that exports volumes.

Be aware that this option only supports static provisioning. You must provision the NFS shares manually on the server, and can't do so from AKS automatically.

This solution is based on infrastructure as a service (IaaS) rather than platform as a service (PaaS). You're responsible for managing the NFS server, including OS updates, high availability, backups, disaster recovery, and scalability.

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

- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Software Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal System Engineer

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
