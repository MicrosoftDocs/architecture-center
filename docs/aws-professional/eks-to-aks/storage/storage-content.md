The following article will guide you on the different options to store and retrieve workload data on an Azure Kubernetes Service.

## EKS Architecture

In EKS, after Kubernetes version 1.11 the cluster will have a default storage class for your persistent volume claims. The default storage class is **gp2**, however as an administrator you could define additional Storage Classes to use other storage services in AWS such as:

- Amazon EBS CSI driver as an Amazon EKS add-on.
- Amazon EBS CSI self-managed add-on.
- Amazon EFS CSI driver
- Amazon FSx for Lustre CSI driver
- Amazon FSx for NetApp ONTAP CSI driver

By adding these drivers and Storage Classes you can use other storage services such as:

- Elastic Block Storage: block-level storage solution used with EC2 instances to store persistent data. In Azure this can be achieved with Azure Disks having several SKUs like Standard SSD, Premium or Ultra Disks depending on the performance that is required.
- Elastic File System: to provide NFS access to external file systems that can be shared across instances. An equivalent solution in Azure would be Azure Files and Azure Files Premium with both SMB and NFS access.
- Lustre: Lustre is an open/source file system commonly used in HPC. In Azure you could use Azure Ultra Disks or Azure HPC Cache for workloads where speed matters, such as machine learning, high performance computing (HPC), etc.
- NetApp ONTAP: use a fully managed ONTAP shared storage in AWS. Similarly Azure NetApp Files is a Microsoft Azure file storage service built on NetApp technology.

The next section explores in more details Azure Storage services available in AKS.

## Storage options in Azure Kubernetes Service

Each AKS cluster includes by default [four pre-created Storage Classes](/azure/aks/concepts-storage#storage-classes):

- Azure Disks Standard SSD: the default storage class. Standard SSD Disks are a cost-effective storage option optimized for workloads that need consistent performance at lower IOPS levels.
- Azure Disks Premium: the managed-premium storage class provisions a premium Azure disk.
- Azure Files: provides concurrent shared access to the same storage volume using SMB or NFS.
- Azure Files Premium: Azure Files for file shares with highly I/O intensive workloads, low latency and high throughput, backed by SSD storage.

You could extend these options by adding other Storage Classes and integrating with other available storage solutions such as:

- Azure NetApp Files
- Azure Ultra Disks
- NFS Server
- Azure HPC Cache
- Third Party storage solutions

### Azure Managed Disks

As mentioned by default an AKS cluster will come with pre-created storage classes to use Azure Disks, specifically:

- managed-csi
- managed-csi-premium

Similarly to Amazon EBS, both of these classes will create a managed disk or block device that will be attached to the node for the pod's access. The reclaim policy ensures that the disk will be deleted with the persistent volume, the disks can be expanded by editing the persistent volume claim.

These Storage Classes use Azure Managed Disks with [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage) this means that your data will have 3 synchronous copies within a single physical location in an Azure primary region. LRS is the least expensive replication option however it does not offer protection against an entire datacenter failure. To mitigate this risk take regular backups or snapshots of that data stored on Azure Disks, either using solutions like [Velero](https://github.com/heptio/velero) or [Azure Backup](/azure/backup/backup-managed-disks) that can use built-in snapshot technologies.

As both Storage Classes are backed by Azure Managed Disks and both use SSD drives, it is important to also understand the differences between Premium and Standard storage:

- Standard disks are priced based on its size and storage transactions
- Premium disks are charged only on size, this can make them cheaper with workloads that require a high number of transactions
- Premium SSDs provide a higher max throughput and IOPS as [shown in this comparison](/azure/virtual-machines/disks-types)
- For most production and development workloads, it is recommended to use Premium storage.

When using Azure Managed Disks as your primary Storage Class, be mindful of the VM SKU that you choose for your Kubernetes cluster as Azure VMs have a limit on the number of disks that can be attached to them, and this varies with the VM size. Also, since Azure Disks are mounted as **ReadWriteOnce**, they're only available to a single pod.

Azure Disks Storage Class allows both [static](/azure/aks/azure-disk-volume) and [dynamic](/azure/aks/azure-disks-dynamic-pv) volume provisioning.

### Azure Files

When your workloads require concurrent access to a volume, Azure Disks cannot meet this requirement, however you can use Azure Files to connect using the Server Message Block 3.0 (SMB) protocol and mount a shared volume that is backed by an Azure Storage Account, this service provides a network attached storage similarly to Amazon EFS. As with Azure Disks there are two options:

- Azure Premium storage: where the file share is backed by high-performance SSDs drives. Be aware that the minimum size file share for premium is 100 GB.
- Azure Standard storage: that is backed by regular HDDs.

With Azure Files there are also a lot more replication options for you Storage Account, that will keep you covered in the unlikely case of a failure:

- Standard_LRS: standard SKU with [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- Standard_GRS: standard SKU with [geo-redundant storage (GRS)](/azure/storage/common/storage-redundancy#geo-redundant-storage)
- Standard_ZRS: standard SKU with [zone redundant storage (ZRS)](/azure/storage/common/storage-redundancy#zone-redundant-storage)
- Standard_RAGRS: standard SKU with [read-access geo-redundant storage (RA-GRS)](/azure/storage/common/storage-redundancy#read-access-to-data-in-the-secondary-region)
- Premium_LRS: premium SKU with SKU with locally redundant storage (LRS) [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- Premium_ZRS - premium zone redundant storage (ZRS)

To optimize costs on Azure Files usage use [Azure Reservations](/azure/storage/files/files-reserve-capacity).

### Azure NetApp Files (ANF)

Similarly to AWS NetApp ONTAP, the Azure NetApp Files service is an enterprise-class, high-performance, metered file storage service that is fully managed in Azure using NetApp solutions. You could [configure your AKS cluster to use Azure NetApp Files](/azure/aks/azure-netapp-files) as your storage provider using the Astra Trident. Just like Azure Files, ANF provides the ability for multiple pods to mount a volume.

When choosing Azure NetApp files be aware that the minimum size of a capacity pool is 4TiB and you will be charged on the provisioned size rather than the used capacity.

### Azure Ultra Disks

Azure Ultra Disks are another SKU or tier for Azure Managed Disks, they offer high throughput, high IOPS, and consistent low latency disk storage for Azure Virtual Machines, they are intended for data and transaction heavy workloads. Just like any other SKU of Azure Disks, they will be mounted by one pod at a time as it does not provide concurrent access and would be similar to Amazon EBS.

When choosing Azure Ultra Disks, be mindful of its [limitations](/azure/virtual-machines/disks-enable-ultra-ssd?tabs=azure-portal) and make sure you choose a VM size that is compatible with Ultra Disks. Ultra Disks are available with LRS replication.

To [enable Ultra Disk on you AKS cluster](/azure/aks/use-ultra-disks) make sure to use the flag _--enable-ultra-ssd_.

### NFS server

For shared NFS access the preferred option would be to use Azure Files or ANF, however there is also the possibility to create an [NFS Server on an Azure VM](/azure/aks/azure-nfs-volume) that exports volumes. If you choose this option, be aware that:

- Only supports static provisioning, meaning you have to provision the NFS shares manually on the server and cannot be done from AKS automatically.
- You are responsible for the management of the NFS server: OS updates, high availability, backups, disaster recovery and scalability as it is based on IaaS rather than a PaaS service.

### Azure HPC Cache

[Azure HPC Cache](/azure/hpc-cache/hpc-cache-overview) speeds access to your data for high-performance computing (HPC) tasks, it also brings all the scalability of cloud solutions. When choosing this storage solution, make sure to deploy your AKS cluster in a [region that supports Azure HPC cache](https://azure.microsoft.com/global-infrastructure/services/?products=hpc-cache&regions=all).

### Third Party Solutions

Like in EKS, AKS is just Kubernetes and allows you to integrate your own third-party storage solution deployed on Azure infrastructure, here are some examples:

- [Rook](https://rook.io/) turns distributed storage systems into self-managing, self-scaling, self-healing storage services. It automates the tasks of a storage administrator: deployment, bootstrapping, configuration, provisioning, scaling, upgrading, migration, disaster recovery, monitoring, and resource management. Rook uses the power of the Kubernetes platform to deliver its services via a Kubernetes Operator for each storage provider.
- [GlusterFS](https://www.gluster.org/) is a free and open-source scalable network filesystem. Gluster is a scalable network filesystem. Using common off-the-shelf hardware, you can create large, distributed storage solutions for media streaming, data analysis, and other data- and bandwidth-intensive tasks. Gluster is free.
- [Ceph](https://www.ceph.com/en/) is a reliable and scalable storage designed for any organization. You can use Ceph to transform your storage infrastructure that integrates with Kubernetes. Ceph provides a unified storage service with object, block, and file interfaces from a single cluster built from commodity hardware components.
- [MinIO](https://min.io/) is a multi-cloud object storage allows enterprises to build AWS S3 compatible data infrastructure on any cloud. The result is a consistent, portable interface to your data and applications - meaning you can run anywhere, from the edge to the public cloud without changing a line of code.
- [Portworx](https://portworx.com/) is an end-to-end storage and data management solution for all your Kubernetes projects, including container-based CaaS, DBaaS, SaaS, and Disaster Recovery initiatives. Apps will benefit from container-granular storage, disaster recovery, data security, multi-cloud migrations and more.
- [Quobyte](https://www.quobyte.com/) provides a high-performance file and object storage you have the freedom to deploy anywhere - any server, any cloud - scale performance and manage large amounts of data while simplifying administration.
- [Ondat](https://www.ondat.io/) allows you to run a database or any persistent workload in a Kubernetes environment without having to worry about managing the storage layer. Ondat gives you the ability to deliver a consistent storage layer across any platform

## Access Modes

As described in the previous sections, different Storage Classes support different access modes to support all workloads.

| Storage Class      | ReadWriteOnce | ReadOnlyMany | ReadWriteMany |
|--------------------|---------------|--------------|---------------|
| Azure Disks        |      X        |              |               |
| Azure File         |      X        |      X       |       X       |
| Azure NetApp Files |      X        |       X      |       X       |
| NFS Server         |      X        |       X      |       X       |
| Azure HPC Cache    |      X        |       X      |       X       |

## CSI Storage Drivers

In Kubernetes version 1.21 and newer, AKS uses CSI drivers only and by default for Storage Classes like Azure Disks and Files.

## Dynamic vs Static provisioning

It is recommended to choose to [dynamically provision volumes](/azure/aks/operator-best-practices-storage#dynamically-provision-volumes) to reduce the management overhead that statically creating persistent volumes requires. It is also recommended to set a correct reclaim policy to avoid having unused disks once pods are deleted.

## Backup

Choose a tool to backup persistent data, the tool should match the storage type you've chosen such as snapshots, [Azure Backup](/azure/backup/backup-overview), [Velero](https://github.com/heptio/velero) or [Kasten](https://www.kasten.io/).

## Cost Optimizations

To optimize costs on Azure Storage use Azure Reservations, make sure to check the list of services that support [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations#charges-covered-by-reservation) the [cost optimization article](../cost-management/cost-management.yml) for AKS deployments.

## Considerations

- [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-resource-limits)
- [Ultra Disks](/azure/virtual-machines/disks-enable-ultra-ssd?tabs=azure-portal#ga-scope-and-limitations)
- [CSI Storage Drivers](/azure/aks/csi-storage-drivers)

## Next Steps

- [Cost Management for a Kubernetes Cluster](./cost-management/cost-management.yml)

The following references provide additional information and documentation Azure Storage:
 
- [Azure Storage Services](/learn/modules/azure-storage-fundamentals/)
- [Store data in Azure](/learn/paths/store-data-in-azure/)
- [Configure AKS Storage](/learn/modules/configure-azure-kubernetes-service/5-kubernetes-storage)
- [Introduction to Azure NetApp Files](/learn/modules/introduction-to-azure-netapp-files/)