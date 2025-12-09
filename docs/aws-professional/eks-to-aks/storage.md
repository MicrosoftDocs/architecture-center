---
title: Storage Options for a Kubernetes Cluster
description: Understand storage options for a Kubernetes cluster, and compare Amazon EKS and Azure Kubernetes Service (AKS) storage options.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
ms.custom:
  - arb-containers
---

# Storage options for a Kubernetes cluster

This article compares the storage capabilities of Amazon Elastic Kubernetes Service (EKS) and Azure Kubernetes Service (AKS). It also describes storage options for workload data on AKS.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS storage options

Amazon EKS provides different types of storage volumes for applications that require data storage. You can use these volumes for temporary and long-lasting storage.

### Ephemeral volumes

For applications that require temporary local volumes but don't need to persist data after restarts, use ephemeral volumes. Kubernetes supports different types of ephemeral volumes, such as [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir), [ConfigMap](https://kubernetes.io/docs/concepts/storage/volumes/#configmap), [downwardAPI](https://kubernetes.io/docs/concepts/storage/volumes/#downwardapi), [secret](https://kubernetes.io/docs/concepts/storage/volumes/#secret), and [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath). To ensure cost efficiency and performance, choose the most appropriate host volume. In Amazon EKS, you can use [gp3](https://aws.amazon.com/ebs/volume-types/) as the host root volume, which costs less than gp2 volumes.

You can also use [Amazon EC2 instance stores](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html), which provide temporary block-level storage for EC2 instances. These volumes are physically attached to the hosts and only exist during the lifetime of the instance. To use local store volumes in Kubernetes, you must partition, configure, and format the disks by using Amazon EC2 user data.

### Persistent volumes

You typically use Kubernetes to run stateless applications, but sometimes you need persistent data storage. You can use [Kubernetes persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) to store data independently from pods so that the data can persist beyond the lifetime of a given pod. Amazon EKS supports different types of storage options for persistent volumes, including [Amazon EBS](https://aws.amazon.com/ebs/), [Amazon Elastic File System (EFS)](https://aws.amazon.com/efs/), [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/), and [Amazon FSx for NetApp ONTAP](https://aws.amazon.com/fsx/netapp-ontap/).

Use [Amazon EBS](https://aws.amazon.com/ebs/) volumes for block-level storage and for databases and throughput-intensive applications. Amazon EKS users can use the latest generation of block storage [gp3](https://aws.amazon.com/ebs/volume-types/#gp3) for a balance between price and performance. For higher-performance applications, you can use [io2 Block Express volumes](https://docs.aws.amazon.com/ebs/latest/userguide/provisioned-iops.html#io2-block-express).

[Amazon EFS](https://aws.amazon.com/efs/) is a serverless, elastic file system that you can share across multiple containers and nodes. It automatically grows and shrinks as files are added or removed, which eliminates the need for capacity planning. The [Amazon EFS Container Storage Interface (CSI) driver](https://github.com/kubernetes-sigs/aws-efs-csi-driver) integrates Amazon EFS with Kubernetes.

[Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/) provides high-performance parallel file storage. Use this type of storage for scenarios that require high-throughput and low-latency operations. You can link this file storage to an Amazon S3 data repository to store large datasets. Amazon FSx for NetApp ONTAP is a fully managed, shared storage solution that's built on NetApp's ONTAP file system.

To optimize storage configurations and manage backups and snapshots, use tools like [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/) and [Velero](https://velero.io/).

## AKS storage options

Applications that run in AKS might need to store and retrieve data. Some application workloads can use local, fast storage on unneeded, empty nodes. But other application workloads require storage that persists on more regular data volumes within the Azure platform. Multiple pods might need to:

- Share the same data volumes.
- Reattach data volumes if the pod is rescheduled on a different node.

The following sections introduce the storage options and core concepts that provide storage to your applications in AKS.

### Volume types

Kubernetes volumes represent more than just a traditional disk to store and retrieve information. You can also use Kubernetes volumes to inject data into a pod for its containers to use.

Common volume types in Kubernetes include [emptyDirs](#emptydirs), [secrets](#secrets), and [ConfigMaps](#configmaps).

#### EmptyDirs

For a pod that defines an emptyDir volume, the volume is created when the pod is assigned to a node. As the name suggests, the emptyDir volume is initially empty. All containers in the pod can read and write the same files in the emptyDir volume, although this volume can be mounted at the same or different paths in each container. When a pod is removed from a node for any reason, the data in the emptyDir is deleted permanently.

#### Secrets

A [secret](https://kubernetes.io/docs/concepts/configuration/secret/) is an object that holds a small amount of sensitive data, such as a password, token, or key. If you don't use a secret, this information is included in a pod specification or container image. A secret prevents the need to embed confidential data directly in your application code. You can create secrets independently of the pods that use them. This practice reduces the risk of exposing the secret and its data when you create, view, and edit pods. Kubernetes and the applications that run in your cluster can take extra precautions with secrets, such as preventing sensitive data from being written to nonvolatile storage. Secrets are similar to ConfigMaps, but they're specifically designed to store confidential data.

You can use secrets for the following purposes:

- [Set environment variables for a container](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data).
- [Provide credentials such as SSH keys or passwords to pods](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#provide-prod-test-creds).
- [Allow the kubelet to pull container images from private registries](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).

The Kubernetes control plane also uses secrets, such as [bootstrap token secrets](https://kubernetes.io/docs/concepts/configuration/secret/#bootstrap-token-secrets), to help automate node registration.

#### ConfigMaps

A [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) is a Kubernetes object that you use to store nonconfidential data in key-value pairs. [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a [volume](https://kubernetes.io/docs/concepts/storage/volumes/). You can use a ConfigMap to decouple environment-specific configurations from your [container images](https://kubernetes.io/docs/reference/glossary/?all=true#term-image), which makes your applications easily portable.

ConfigMaps don't provide secrecy or encryption. If you want to store confidential data, use a [secret](https://kubernetes.io/docs/concepts/configuration/secret/) rather than a ConfigMap, or use other partner tools to keep your data private.

You can use a ConfigMap to set configuration data separately from application code. For example, you might develop an application to run on your computer for development and to run in the cloud to handle real traffic. You can write the code to look in an environment variable named `DATABASE_HOST`. Locally, set that variable to `localhost`. In the cloud, set it to refer to a Kubernetes [service](https://kubernetes.io/docs/concepts/services-networking/service/) that exposes the database component to your cluster. This approach lets you fetch a container image that runs in the cloud and debug the same code locally if needed.

## Persistent volumes

Volumes that are defined and created as part of the pod lifecycle only exist until you delete the pod. Pods often expect their storage to remain if a pod is rescheduled on a different host during a maintenance event, especially in StatefulSets. A *persistent volume* is a storage resource that the Kubernetes API creates and manages. A persistent volume can exist beyond the lifetime of an individual pod. You can use the following Azure Storage tools to provide the persistent volume:

- [Azure disk storage](#azure-disk-storage)
- [Azure Files](#azure-files)
- [Azure NetApp Files](#azure-netapp-files)
- [Azure Blob Storage](#blob-storage)
- [Azure Container Storage](#azure-container-storage)

To decide between [Azure disk storage or Azure Files](/azure/aks/concepts-storage#volumes), consider whether your application needs concurrent data access or a specific performance tier.

:::image type="complex" source="./media/aks-storage-persistent-volume.png" border="false" lightbox="./media/aks-storage-persistent-volume.png" alt-text="Diagram of persistent volumes in an AKS cluster.":::
The diagram shows two scenarios: single node or pod access and multiple concurrent node or pod access. The single node or pod access scenario uses Azure managed disks (Standard or Premium storage). The multiple concurrent node or pod access scenario uses Azure Files (Standard storage). Both scenarios point to a persistent volume within the AKS cluster.
:::image-end:::

A cluster administrator can *statically* create a persistent volume, or the Kubernetes API server can *dynamically* create a volume. If a pod is scheduled and requests storage that's currently unavailable, Kubernetes can create the underlying Azure disk or file storage and attach it to the pod. Dynamic provisioning uses a *storage class* to identify what type of resource needs to be created.

> [!IMPORTANT]
> Windows and Linux pods can't share persistent volumes because the operating systems support different file systems.

If you want a fully managed solution for block-level access to data, consider using [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) instead of CSI drivers. Azure Container Storage integrates with Kubernetes to provide dynamic and automatic provisioning of persistent volumes. Azure Container Storage supports Azure disks, ephemeral disks, and Azure Elastic SAN (preview) as backing storage. These options provide flexibility and scalability for stateful applications that run on Kubernetes clusters.

## Storage classes

To specify different tiers of storage, such as premium or standard, you can create a storage class.

A storage class also defines a *reclaim policy*. When you delete a persistent volume, the reclaim policy controls the behavior of the underlying Azure Storage resource. The underlying resource can either be deleted or kept for use with a future pod.

Clusters that use [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) have an extra storage class called `acstor-<storage-pool-name>`. An internal storage class is also created.

For clusters that use [CSI drivers](/azure/aks/csi-storage-drivers), the following extra storage classes are created:

| Storage class            | Description                                                  |
| :----------------------- | :----------------------------------------------------------- |
| `managed-csi`            | Uses Azure Standard SSD with locally redundant storage (LRS) to create a managed disk. The reclaim policy ensures that the underlying Azure disk is deleted when the persistent volume that used it is deleted. The storage class also configures the persistent volumes to be expandable. You can edit the persistent volume claim to specify the new size. <br><br> For Kubernetes version 1.29 and later, this storage class uses Standard SSD with zone-redundant storage (ZRS) to create managed disks for AKS clusters that are deployed across multiple availability zones. |
| `managed-csi-premium`    | Uses Azure Premium SSD with LRS to create a managed disk. The reclaim policy ensures that the underlying Azure disk is deleted when the persistent volume that used it is deleted. This storage class allows persistent volumes to be expanded. <br><br> For Kubernetes version 1.29 and later, this storage class uses Premium SSD with ZRS to create managed disks for AKS clusters that are deployed across multiple availability zones. |
| `azurefile-csi`          | Uses Standard SSD storage to create an Azure file share. The reclaim policy ensures that the underlying Azure file share is deleted when the persistent volume that used it is deleted. |
| `azurefile-csi-premium`  | Uses Premium SSD storage to create an Azure file share. The reclaim policy ensures that the underlying Azure file share is deleted when the persistent volume that used it is deleted. |
| `azureblob-nfs-premium`  | Uses Premium SSD storage to create a Blob Storage container and connect via the Network File System (NFS) v3 protocol. The reclaim policy ensures that the underlying Blob Storage container is deleted when the persistent volume that used it is deleted. |
| `azureblob-fuse-premium` | Uses Premium SSD storage to create a Blob Storage container and connect via BlobFuse. The reclaim policy ensures that the underlying Blob Storage container is deleted when the persistent volume that used it is deleted. |

Unless you specify a storage class for a persistent volume, the default storage class is used. Ensure that volumes use the storage that you need when you request persistent volumes.

> [!IMPORTANT]
> For Kubernetes version 1.21 and later, AKS uses CSI drivers by default, and CSI migration is enabled. Existing in-tree persistent volumes continue to function, but for version 1.26 and later, AKS no longer supports volumes that are created by using the in-tree driver and storage that's provisioned for files and disks.

The `default` class is the same as the `managed-csi` class.

For Kubernetes version 1.29 and later, when you deploy AKS clusters across multiple availability zones, AKS uses ZRS to create managed disks within built-in storage classes. ZRS ensures synchronous replication of your Azure managed disks across multiple Azure availability zones in your chosen region. This redundancy strategy enhances the resilience of your applications and helps safeguard your data against datacenter failures.

However, ZRS costs more than LRS. If cost optimization is a priority, you can create a new storage class that has the `skuname` parameter set to LRS. You can then use the new storage class in your persistent volume claim.

You can create a storage class for other needs by using `kubectl`. The following example uses premium managed disks and specifies that the underlying Azure disk should be *retained* when you delete the pod:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-premium-retain
provisioner: disk.csi.azure.com
parameters:
  skuName: Premium_ZRS
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

AKS reconciles the default storage classes and overwrites any changes that you make to those storage classes.

For more information, see [StorageClass in Kubernetes](https://kubernetes.io/docs/concepts/storage/storage-classes/).

## Persistent volume claims

A persistent volume claim requests storage of a particular storage class, access mode, and size. The Kubernetes API server can dynamically provision the underlying Azure Storage resource if no existing resource can fulfill the claim based on the defined storage class.

The pod definition includes the volume mount after the volume connects to the pod.

:::image type="complex" source="./media/aks-storage-persistent-volume-claim.png" border="false" lightbox="./media/aks-storage-persistent-volume-claim.png" alt-text="Diagram of persistent volume claims in an AKS cluster.":::
The left side has two sections: single node or pod access and multiple concurrent node or pod access. The single node or pod access uses Azure managed disks (Standard or Premium storage). An arrow points from single node or pod access to a persistent volume in the AKS cluster that's on the right side. The multiple concurrent nodes or pods access uses Azure Files (Standard storage). An arrow points from multiple concurrent node or pod access to the same persistent volume in the AKS cluster on the right side. Inside the AKS cluster, a persistent volume connects to a persistent volume claim, which links to a storage class. The persistent volume claim points to nodes and pods.
:::image-end:::

After an available storage resource is assigned to the pod that requests storage, the persistent volume is *bound* to a persistent volume claim. Each persistent volume is associated with one persistent volume claim to ensure dedicated storage.

The following example YAML manifest shows a persistent volume claim that uses the `managed-premium` storage class and requests an Azure disk that's `5Gi` in size:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: azure-managed-disk
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: managed-premium-retain
  resources:
    requests:
      storage: 5Gi
```

When you create a pod definition, you also specify:

- The persistent volume claim to request the desired storage.
- The volume mount for your applications to read and write data.

The following example YAML manifest shows how the previous persistent volume claim can mount a volume at `/mnt/azure`:

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: nginx
spec:
  containers:
    - name: myfrontend
      image: mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
      volumeMounts:
      - mountPath: "/mnt/azure"
        name: volume
  volumes:
    - name: volume
      persistentVolumeClaim:
        claimName: azure-managed-disk
```

To mount a volume in a Windows container, specify the drive letter and path:

```yaml
...      
      volumeMounts:
      - mountPath: "d:"
        name: volume
      - mountPath: "c:\k"
        name: k-dir
...
```

## Ephemeral OS disk

By default, Azure automatically replicates the operating system disk for a virtual machine (VM) to Azure Storage to avoid data loss when the VM is relocated to another host. However, containers aren't designed to have local state persisted, so this behavior provides limited value and drawbacks. These drawbacks include slower node provisioning and higher read and write latency.

In contrast, ephemeral OS disks are stored only on the host machine, like a temporary disk. This configuration provides lower read and write latency and faster node scaling and cluster upgrades.

If you don't request [Azure managed disks](/azure/virtual-machines/managed-disks-overview) for the OS, AKS defaults to ephemeral OS disks if possible for a given node pool configuration.

For size requirements and recommendations, see [Ephemeral OS disks for Azure VMs](/azure/virtual-machines/ephemeral-os-disks). Consider the following sizing considerations:

- If you use the AKS default VM size [Standard_DS2_v2](/azure/virtual-machines/sizes/general-purpose/dsv2-series) SKU with the default OS disk size of 100 GiB, the default VM size supports ephemeral OS disks but only has a cache size of 86 GiB. This configuration defaults to managed disks if you don't specify it. If you request an ephemeral OS disk, you receive a validation error.

- If you request the same Standard_DS2_v2 SKU with a 60-GiB OS disk, this configuration defaults to ephemeral OS disks. The requested size of 60 GiB is smaller than the maximum cache size of 86 GiB.
- If you select the [Standard_D8s_v3](/azure/virtual-machines/sizes/general-purpose/dsv3-series) SKU with a 100-GB OS disk, this VM size supports ephemeral OS disks and has a cache size of 200 GiB. If you don't specify the OS disk type, the node pool receives ephemeral OS disks by default.

The latest generation of VM series doesn't have a dedicated cache and only has temporary storage. 

- If you select the [Standard_E2bds_v5](/azure/virtual-machines/ebdsv5-ebsv5-series#ebdsv5-series) VM size with the default OS disk size of 100 GiB, the VM supports ephemeral OS disks but only has 75 GB of temporary storage. This configuration defaults to managed OS disks if you don't specify it. If you request an ephemeral OS disk, you receive a validation error.

- If you request the same Standard_E2bds_v5 VM size with a 60-GiB OS disk, this configuration defaults to ephemeral OS disks. The requested size of 60 GiB is smaller than the maximum temporary storage of 75 GiB.

- If you select the Standard_E4bds_v5 SKU with a 100-GiB OS disk, this VM size supports ephemeral OS disks and has 150 GiB of temporary storage. If you don't specify the OS disk type, Azure provisions an ephemeral OS disk to the node pool.

### Customer-managed keys

You can manage encryption for your ephemeral OS disk by using your own keys on an AKS cluster. For more information, see [Bring your own keys with Azure managed disks in AKS](/azure/aks/azure-disk-customer-managed-keys).

## Volumes

Kubernetes typically treats individual pods as ephemeral, disposable resources. Applications have different approaches for using and persisting data. A *volume* represents a way to store, retrieve, and persist data across pods and through the application lifecycle.

Traditional volumes are created as Kubernetes resources that are backed by Azure Storage. You can manually create data volumes to be assigned to pods directly or have Kubernetes automatically create them. Data volumes can use [Azure disk storage](/azure/virtual-machines/disks-types), [Azure Files](/azure/storage/files/storage-files-planning), [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-service-levels), or [Blob Storage](/azure/storage/common/storage-account-overview).

> [!NOTE]
> Depending on your VM SKU, the Azure disk CSI driver might have a volume limit for each node. For some high-performance VMs, such as 16 cores, the limit is 64 volumes per node. To identify the limit per VM SKU, review the **Max data disks** column for each VM SKU. For a list of VM SKUs and their corresponding capacity limits, see [General purpose VM sizes](/azure/virtual-machines/sizes-general).

To decide between Azure Files and Azure NetApp Files, see [Azure Files and Azure NetApp Files comparison](/azure/storage/files/storage-files-netapp-comparison).

### Azure disk storage

By default, an AKS cluster comes with precreated `managed-csi` and `managed-csi-premium` storage classes that use [Azure disk storage](https://azure.microsoft.com/services/storage/disks). Similar to Amazon EBS, these classes create a managed disk or block device that's attached to the node for pod access.

The disk classes allow both [static](/azure/aks/azure-csi-disk-storage-provision#statically-provision-a-volume) and [dynamic](/azure/aks/azure-csi-disk-storage-provision#dynamically-provision-a-volume) volume provisioning. The reclaim policy ensures that the disk is deleted with the persistent volume. To expand the disk, edit the persistent volume claim.

These storage classes use Azure managed disks with [LRS](/azure/storage/common/storage-redundancy#locally-redundant-storage). Data in LRS has three synchronous copies within a single physical location in an Azure primary region. LRS is the least expensive replication option but doesn't provide protection against a datacenter failure. You can define custom storage classes that use ZRS managed disks.

ZRS synchronously replicates your Azure managed disk across three Azure availability zones in your region. Each availability zone is a separate physical location that has independent power, cooling, and networking. ZRS disks provide at least 99.9999999999% of durability over a given year. A ZRS managed disk can be attached by a VM in a different [availability zone](/azure/availability-zones/az-overview). ZRS disks aren't available in all Azure regions. For more information, see [ZRS options for Azure disks to improve availability](https://youtu.be/RSHmhmdHXcY).

To mitigate the risk of data loss, use [AKS backup](/azure/backup/azure-kubernetes-service-backup-overview) to take regular backups or snapshots of disk storage data. Or you can use partner solutions, like [Velero](https://github.com/vmware-tanzu/velero) or [Azure Backup](/azure/backup/backup-managed-disks), that have built-in snapshot technology.

You can use [Azure disk storage](/azure/aks/azure-disk-csi) to create a Kubernetes *DataDisk* resource. You can use the following disks types:

- [Premium SSD](/azure/aks/azure-disk-csi) (recommended for most workloads)
- [Premium SSD v2](/azure/aks/use-premium-v2-disks)
- [Azure Ultra Disk Storage](/azure/aks/use-ultra-disks)
- [Standard SSD](/azure/aks/azure-disk-csi)

> [!TIP]
> For most production and development workloads, use Premium SSD.

An Azure disk is mounted as *ReadWriteOnce*, so it's only available to a single node. For storage volumes that pods on multiple nodes can access simultaneously, use Azure Files.

#### Premium SSD v2 disks

[Premium SSD v2 disks](/azure/virtual-machines/disks-types#premium-ssd-v2) are designed for input/output(I/O)-intense enterprise workloads. They provide consistent submillisecond disk latency, high input/output operations per second (IOPS), and high throughput. You can independently configure the performance (capacity, IOPS, and throughput) of Premium SSD v2 disks on demand. So you easily improve cost efficiency while meeting performance needs. For more information about how to configure a new or existing AKS cluster to use Azure Premium SSD v2 disks, see [Use Premium SSD v2 disks on AKS](/azure/aks/use-premium-v2-disks).

#### Ultra Disk Storage

Ultra Disk Storage is an Azure managed disk tier that provides high throughput, high IOPS, and consistent low-latency disk storage for Azure VMs. Use Ultra Disk Storage for data-intensive and transaction-heavy workloads. Like other disk storage SKUs and Amazon EBS, Ultra Disk Storage mounts one pod at a time and doesn't provide concurrent access.

To [enable Ultra Disk Storage on your AKS cluster](/azure/aks/use-ultra-disks), use the flag `--enable-ultra-ssd`.

Be aware of Ultra Disk Storage [limitations](/azure/virtual-machines/disks-enable-ultra-ssd#ga-scope-and-limitations), and select a compatible VM size. Ultra Disk Storage has LRS replication.

#### Bring your own keys (BYOK)

Azure encrypts all data in a managed disk at rest, including the OS and data disks of an AKS cluster. By default, data is encrypted with Microsoft-managed keys. For more control over encryption keys, you can supply customer-managed keys to provide encryption at rest for both the OS and data disks in AKS clusters. For more information, see [BYOK with Azure managed disks in AKS](/azure/aks/azure-disk-customer-managed-keys) and [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

### Azure Files

Disk storage can't provide concurrent access to a volume, but you can use [Azure Files](https://azure.microsoft.com/services/storage/files) to mount a Server Message Block (SMB) version 3.1.1 share or NFS version 4.1 share that's backed by Azure Storage. This process provides network-attached storage that's similar to Amazon EFS. Azure Files has two storage options:

- Azure Files Standard storage backs the file share with regular hard disk drives (HDDs).

- Azure Files Premium storage backs the file share with high-performance solid-state drives (SSDs). The minimum file share size for Premium is 100 GB.

Azure Files has the following storage account replication options to protect your data if failure occurs:

- **Standard_LRS**: Standard [LRS](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- **Standard_GRS**: Standard [geo-redundant storage (GRS)](/azure/storage/common/storage-redundancy#geo-redundant-storage)
- **Standard_ZRS**: Standard [ZRS](/azure/storage/common/storage-redundancy#zone-redundant-storage)
- **Standard_RAGRS**: Standard [read-access GRS (RA-GRS)](/azure/storage/common/storage-redundancy#read-access-to-data-in-the-secondary-region)
- **Standard_RAGZRS**: Standard [read-access geo-zone-redundant storage (RA-GZRS)](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage)
- **Premium_LRS**: Premium [LRS](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- **Premium_ZRS**: Premium [ZRS](/azure/storage/common/storage-redundancy#zone-redundant-storage)

To optimize costs for Azure Files, purchase [Azure Files capacity reservations](/azure/storage/files/files-reserve-capacity).

### Azure NetApp Files

[Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) is an enterprise-class, high-performance, metered file storage service that runs on Azure and supports volumes by using [NFS](/azure/aks/azure-netapp-files-nfs) (NFSv3 or NFSv4.1), [SMB](/azure/aks/azure-netapp-files-smb), and [dual protocol](/azure/aks/azure-netapp-files-dual-protocol) (NFSv3 and SMB or NFSv4.1 and SMB) volumes. Kubernetes users have two options for using Azure NetApp Files volumes for Kubernetes workloads:

- **Create Azure NetApp Files volumes statically.** Create volumes outside of AKS via the Azure CLI or the Azure portal. After creation, these volumes are exposed to Kubernetes by creating a `PersistentVolume`. Statically created Azure NetApp Files volumes have many limitations. For example, they can't be expanded and they need to be overprovisioned. We don't recommend statically created volumes for most use cases.

- **Create Azure NetApp Files volumes dynamically** through Kubernetes. This is the **preferred** method to create multiple volumes directly through Kubernetes by using [Astra Trident](https://docs.netapp.com/us-en/trident/index.html). Astra Trident is a CSI-compliant dynamic storage orchestrator that helps provision volumes natively through Kubernetes.

For more information, see [Configure Azure NetApp Files for AKS](/azure/aks/azure-netapp-files).

### Blob Storage

The [Blob Storage CSI driver](/azure/aks/azure-blob-csi) is a [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md)-compliant driver that AKS uses to manage the lifecycle of Blob Storage. The CSI is a standard for exposing arbitrary block and file storage systems to containerized workloads on Kubernetes.

Adopt and use the CSI so that AKS can write, deploy, and iterate plug-ins. The plug-ins expose new storage systems or improve existing storage systems in Kubernetes. CSI drivers in AKS eliminate the need to modify the core Kubernetes code and wait for its release cycles.

When you mount Blob Storage as a file system into a container or pod, you can use it with applications that handle large amounts of unstructured data, such as:

- Log file data.
- Images, documents, and streaming video or audio.
- Disaster recovery data.

Applications can access the data on the object storage via [Blobfuse2](https://github.com/Azure/azure-storage-fuse) or the [NFS 3.0 protocol](https://wikipedia.org/wiki/Network_File_System). Before the introduction of the Blob Storage CSI driver, the only option was to manually install an unsupported driver to access Blob Storage from your application that runs on AKS. A Blob Storage CSI driver that's enabled on AKS has two built-in storage classes: [azureblob-fuse-premium](/azure/aks/azure-blob-csi) and [azureblob-nfs-premium](/azure/aks/azure-blob-csi).

To create an AKS cluster that has CSI drivers support, see [CSI drivers on AKS](/azure/aks/csi-storage-drivers). For more information, see [Compare access to Azure Files, Blob Storage, and Azure NetApp Files with NFS](/azure/storage/common/nfs-comparison).

### Azure HPC Cache

[HPC Cache](/azure/hpc-cache/hpc-cache-overview) accelerates access to your data for high-perforance computing tasks and provides the scalability of cloud solutions. If you choose this storage solution, make sure to deploy your AKS cluster in a [region that supports HPC Cache](https://azure.microsoft.com/global-infrastructure/services/).

### NFS server

For shared NFS access, you should use Azure Files or Azure NetApp Files. You can also [create an NFS server on an Azure VM](/azure/aks/azure-nfs-volume) that exports volumes.

This option only supports static provisioning. You must provision the NFS shares manually on the server. You can't provision NFS shares automatically on AKS.

This solution is based on infrastructure as a service (IaaS) rather than platform as a service (PaaS). You manage the NFS server, including OS updates, high availability, backups, disaster recovery, and scalability.

### Azure Container Storage

[Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) is a cloud-based volume management, deployment, and orchestration service that's built natively for containers. It integrates with Kubernetes so that you can dynamically and automatically provision persistent volumes to store data for stateful applications that run on Kubernetes clusters.

Azure Container Storage uses existing Azure Storage offerings for actual data storage and provides a volume orchestration and management solution that's purposely built for containers. Azure Container Storage supports the following backing storage:

- **[Azure disks](/azure/virtual-machines/managed-disks-overview):** Provide granular control of storage SKUs and configurations. Azure disks suit tier-1 and general purpose databases.

- **Ephemeral disks:** Use local storage resources on AKS nodes (NVMe or temp SSD). Ephemeral disks suit applications that don't have data durability requirements or that have built-in data replication support. AKS discovers the available ephemeral storage on AKS nodes and acquires them for volume deployment.
- **[Elastic SAN](/azure/storage/elastic-san/elastic-san-introduction):** Provision on-demand, fully managed resources. Elastic SAN suits general purpose databases, streaming and messaging services, continuous integration and continuous delivery environments, and other tier-1 or tier-2 workloads. Multiple clusters can access a single storage area network (SAN) concurrently. However persistent volumes can only be attached by one consumer at a time.

Previously, to provide cloud storage for containers, you needed individual CSI drivers to adapt storage services intended for IaaS-centric workloads. This method created operational overhead and increased the risk of problems related to application availability, scalability, performance, usability, and cost.

Azure Container Storage is derived from OpenEBS, an open-source solution that provides container storage capabilities for Kubernetes. Azure Container Storage provides a managed volume orchestration solution via microservice-based storage controllers in a Kubernetes environment. This feature enables true container-native storage.

Azure Container Storage suits the following scenarios:

- **Accelerate VM-to-container initiatives:** Azure Container Storage surfaces the full spectrum of Azure block storage offerings that were previously only available for VMs and makes them available for containers. This storage includes ephemeral disk storage, which provides extremely low latency for workloads like Cassandra. It also includes Elastic SAN, which provides native iSCSI and shared provisioned targets.

- **Simplify volume management with Kubernetes:** Azure Container Storage provides volume orchestration via the Kubernetes control plane. This feature simplifies the deployment and management of volumes within Kubernetes, without the need to switch between different control planes.

- **Reduce the total cost of ownership:** To improve cost efficiency, increase the scale of persistent volumes that are supported for each pod or node. To reduce the storage resources needed for provisioning, dynamically share storage resources. Scale-up support for the storage pool itself isn't included.

Azure Container Storage provides the following key benefits:

- **Scale out stateful pods rapidly:** Azure Container Storage mounts persistent volumes via network block storage protocols, such as NVMe-oF or iSCSI. This capability ensures fast attachment and detachment of persistent volumes. You can start small and deploy resources as needed to ensure that your applications aren't starved or disrupted during initialization or in production. When a pod respawns across the cluster, the associated persistent volume must be rapidly moved to the new pod to maintain application resiliency. By using remote network protocols, Azure Container Storage tightly couples with the pod lifecycle to support highly resilient, high-scale stateful applications on AKS.

- **Improve performance for stateful workloads:** Azure Container Storage enables superior read performance and provides near-disk write performance by using NVMe-oF over RDMA. This capability allows you to cost-effectively meet performance requirements for various container workloads, including tier-1 I/O-intensive, general-purpose, throughput-sensitive, and dev/test workloads. Accelerate the attach and detach time of persistent volumes and minimize pod failover time.

- **Orchestrate Kubernetes-native volumes:** Create storage pools and persistent volumes, capture snapshots, and manage the entire lifecycle of volumes by using `kubectl` commands without switching between toolsets for different control plane operations.

### Partner solutions

Like Amazon EKS, AKS is a Kubernetes implementation, and you can integrate partner Kubernetes storage solutions. Here are some examples of partner storage solutions for Kubernetes:

- [Rook](https://rook.io/) turns distributed storage systems into self-managing storage services by automating Azure Storage administrator tasks. Rook delivers its services via a Kubernetes operator for each storage provider.

- [GlusterFS](https://www.gluster.org/) is a free and open-source scalable network filesystem that uses common off-the-shelf hardware to create large, distributed storage solutions for data-heavy and bandwidth-intensive tasks.
- [Ceph](https://www.ceph.com/en/) provides a reliable and scalable unified storage service that has object, block, and file interfaces from a single cluster that's built from commodity hardware components.
- [MinIO](https://min.io/) multicloud object storage lets enterprises build AWS S3-compatible data infrastructure on any cloud. It provides a consistent, portable interface to your data and applications.
- [Portworx](https://portworx.com/) is an end-to-end storage and data management solution for Kubernetes projects and container-based initiatives. Portworx provides container-granular storage, disaster recovery, data security, and multicloud migrations.
- [Quobyte](https://www.quobyte.com/) provides high-performance file and object storage that you can deploy on any server or cloud to scale performance, manage large amounts of data, and simplify administration.
- Ondat delivers a consistent storage layer across any platform. You can run a database or any persistent workload in a Kubernetes environment without having to manage the storage layer.

## Kubernetes storage considerations

Consider the following factors when you choose a storage solution for Amazon EKS or AKS.

### Storage class access modes

In Kubernetes version 1.21 and later, by default AKS and Amazon EKS storage classes use [CSI drivers](/azure/aks/csi-storage-drivers) only.

Different services support storage classes that have different access modes.

| Service      | ReadWriteOnce | ReadOnlyMany | ReadWriteMany |
|--------------------|---------------|--------------|---------------|
| Azure disk storage        |      X        |              |               |
| Azure Files         |      X        |      X       |       X       |
| Azure NetApp Files |      X        |       X      |       X       |
| NFS server         |      X        |       X      |       X       |
| HPC Cache    |      X        |       X      |       X       |

### Dynamic vs. static provisioning

[Dynamically provision volumes](/azure/aks/operator-best-practices-storage#dynamically-provision-volumes) to reduce the management overhead of statically creating persistent volumes. Set an appropriate reclaim policy to eliminate unused disks when you delete pods.

### Backup

Choose a tool to back up persistent data. The tool should match your storage type, such as snapshots, [Azure Backup](/azure/backup/backup-overview), [Velero](https://github.com/vmware-tanzu/velero) or [Kasten](https://www.kasten.io).

### Cost optimization

To optimize Azure Storage costs, use Azure reservations if the [service supports them](/azure/cost-management-billing/reservations/save-compute-costs-reservations#charges-covered-by-reservation). For more information, see [Cost management for a Kubernetes cluster](cost-management.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal System Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Cloud Solution Architect

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Training: Azure Storage services](/training/modules/describe-azure-storage-services/)
- [Training: Store data in Azure](/training/paths/store-data-in-azure/)
- [Training: Introduction to Kubernetes](/training/modules/intro-to-kubernetes/)
- [Training: Introduction to Azure NetApp Files](/training/modules/introduction-to-azure-netapp-files/)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
