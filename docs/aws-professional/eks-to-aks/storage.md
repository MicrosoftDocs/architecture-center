---
title: Storage options for a Kubernetes cluster
description: Understand storage options for a Kubernetes cluster, and compare Amazon EKS and Azure Kubernetes Service (AKS) storage options.
author: paolosalvatori
ms.author: paolos
ms.date: 01/28/2025
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
ms.custom:
  - arb-containers
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

When running applications that require data storage, Amazon EKS offers different types of volumes for both temporary and long-lasting storage.

### Ephemeral Volumes

For applications that require temporary local volumes but don't need to persist data after restarts, ephemeral volumes can be used. Kubernetes supports different types of ephemeral volumes, such as [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir), [configMap](https://kubernetes.io/docs/concepts/storage/volumes/#configmap), [downwardAPI](https://kubernetes.io/docs/concepts/storage/volumes/#downwardapi), [secret](https://kubernetes.io/docs/concepts/storage/volumes/#secret), and [hostpath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath). To ensure cost efficiency and performance, it's important to choose the most appropriate host volume. In Amazon EKS, you can use [gp3](https://aws.amazon.com/ebs/volume-types/#gp3) as the host root volume, which offers lower prices compared to gp2 volumes.

Another option for ephemeral volumes is [Amazon EC2 instance stores](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html), which provide temporary block-level storage for EC2 instances. These volumes are physically attached to the hosts and only exist during the lifetime of the instance. Using local store volumes in Kubernetes requires partitioning, configuring, and formatting the disks using Amazon EC2 user-data.

### Persistent Volumes

While Kubernetes is typically associated with running stateless applications, there are cases where persistent data storage is required. [Kubernetes Persistent Volumes (PVs)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) can be used to store data independently from pods, allowing data to persist beyond the lifetime of a given pod. Amazon EKS supports different types of storage options for PVs, including [Amazon EBS](https://aws.amazon.com/ebs/), [Amazon EFS](https://aws.amazon.com/efs/), [Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/), and [Amazon FSx for NetApp ONTAP](https://aws.amazon.com/fsx/netapp-ontap/).

[Amazon EBS](https://aws.amazon.com/ebs/) volumes are suitable for block-level storage and are well-suited for databases and throughput-intensive applications. Amazon EKS users can use the latest generation of block storage [gp3](https://aws.amazon.com/ebs/volume-types/#gp3) for a balance between price and performance. For higher-performance applications, [io2 block express](https://aws.amazon.com/ebs/volume-types/#io2) volumes can be used.

[Amazon EFS](https://aws.amazon.com/efs/) is a serverless, elastic file system that can be shared across multiple containers and nodes. It automatically grows and shrinks as files are added or removed, eliminating the need for capacity planning. The [Amazon Elastic File System Container Storage Interface (CSI) Driver](https://github.com/kubernetes-sigs/aws-efs-csi-driver) is used to integrate Amazon EFS with Kubernetes.

[Amazon FSx for Lustre](https://aws.amazon.com/fsx/lustre/) provides high-performance parallel file storage, ideal for scenarios requiring high throughput and low-latency operations. It can be linked to an Amazon S3 data repository to store large datasets. Amazon FSx for NetApp ONTAP is a fully managed shared storage solution built on NetApp's ONTAP file system.

Amazon EKS users can utilize tools like [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/) and [Velero](https://velero.io/) to optimize storage configurations and manage backups and snapshots.

## AKS storage options

Applications running in Azure Kubernetes Service (AKS) might need to store and retrieve data. While some application workloads can use local, fast storage on unneeded, emptied nodes, others require storage that persists on more regular data volumes within the Azure platform. Multiple pods might need to:

- Share the same data volumes.
- Reattach data volumes if the pod is rescheduled on a different node.

This article introduces the storage options and core concepts that provide storage to your applications in AKS.

### Volume types

Kubernetes volumes represent more than just a traditional disk for storing and retrieving information. Kubernetes volumes can also be used as a way to inject data into a pod for use by its containers.

Common volume types in Kubernetes include [EmptyDirs](#emptydirs), [Secret](#secrets), and [ConfigMaps](#configmaps).

#### EmptyDirs

For a Pod that defines an `emptyDir` volume, the volume is created when the Pod is assigned to a node. As the name suggests, the `emptyDir` volume is initially empty. All containers in the Pod can read and write the same files in the `emptyDir` volume, although this volume can be mounted at the same or different paths in each container. When a Pod is removed from a node for any reason, the data in the `emptyDir` is deleted permanently.

#### Secrets

A [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) is an object that holds a small amount of sensitive data, such as a password, token, or key. This information would otherwise be included in a Pod specification or container image. By using a Secret, you avoid embedding confidential data directly in your application code. Since Secrets can be created independently of the Pods that use them, there is a reduced risk of exposing the Secret (and its data) during the processes of creating, viewing, and editing Pods. Kubernetes, along with the applications running in your cluster, can also take extra precautions with Secrets, such as preventing sensitive data from being written to nonvolatile storage. While Secrets are similar to ConfigMaps, they are specifically designed to store confidential data.

You can use Secrets for the following purposes:

- [Set environment variables for a container](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data).
- [Provide credentials such as SSH keys or passwords to Pods](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#provide-prod-test-creds).
- [Allow the kubelet to pull container images from private registries](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).

The Kubernetes control plane also uses Secrets, such as [bootstrap token Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#bootstrap-token-secrets), which are a mechanism to help automate node registration.

#### ConfigMaps

A [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) is a Kubernetes object used to store non-confidential data in key-value pairs. [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a [volume](https://kubernetes.io/docs/concepts/storage/volumes/). A ConfigMap allows you to decouple environment-specific configuration from your [container images](https://kubernetes.io/docs/reference/glossary/?all=true#term-image), so that your applications are easily portable.

ConfigMap does not provide secrecy or encryption. If the data you want to store are confidential, use a [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) rather than a ConfigMap, or use additional (third party) tools to keep your data private.

You can use a ConfigMap for setting configuration data separately from application code. For example, imagine that you are developing an application that you can run on your own computer (for development) and in the cloud (to handle real traffic). You write the code to look in an environment variable named `DATABASE_HOST`. Locally, you set that variable to `localhost`. In the cloud, you set it to refer to a Kubernetes [Service](https://kubernetes.io/docs/concepts/services-networking/service/) that exposes the database component to your cluster. This lets you fetch a container image running in the cloud and debug the exact same code locally if needed.

## Persistent volumes

Volumes defined and created as part of the pod lifecycle only exist until you delete the pod. Pods often expect their storage to remain if a pod is rescheduled on a different host during a maintenance event, especially in StatefulSets. A *persistent volume* (PV) is a storage resource created and managed by the Kubernetes API that can exist beyond the lifetime of an individual pod. You can use the following Azure Storage services to provide the persistent volume:

- [Azure Disk](#azure-disk)
- [Azure Files](#azure-files)
- [Azure NetApp Files](#azure-netapp-files)
- [Azure Blob Storage](#azure-blob-storage)
- [Azure Container Storage](#azure-container-storage)

As noted in the [Volumes](/azure/aks/concepts-storage#volumes) section, the choice of Azure Disks or Azure Files is often determined by the need for concurrent access to the data or the performance tier.

![Diagram of persistent volumes in an Azure Kubernetes Services (AKS) cluster.](/azure/aks/media/concepts-storage/aks-storage-persistent-volume.png)

A cluster administrator can *statically* create a persistent volume, or a volume can be created *dynamically* by the Kubernetes API server. If a pod is scheduled and requests storage that is currently unavailable, Kubernetes can create the underlying Azure Disk or File storage and attach it to the pod. Dynamic provisioning uses a *storage class* to identify what type of resource needs to be created.

> [!IMPORTANT]
> Persistent volumes can't be shared by Windows and Linux pods due to differences in file system support between the two operating systems.

If you want a fully managed solution for block-level access to data, consider using [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) instead of CSI drivers. Azure Container Storage integrates with Kubernetes, allowing dynamic and automatic provisioning of persistent volumes. Azure Container Storage supports Azure Disks, Ephemeral Disks, and Azure Elastic SAN (preview) as backing storage, offering flexibility and scalability for stateful applications running on Kubernetes clusters.

## Storage classes

To specify different tiers of storage, such as premium or standard, you can create a *storage class*.

A storage class also defines a *reclaim policy*. When you delete the persistent volume, the reclaim policy controls the behavior of the underlying Azure Storage resource. The underlying resource can either be deleted or kept for use with a future pod.

For clusters using [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction), you'll see an additional storage class called `acstor-<storage-pool-name>`. An internal storage class is also created.

For clusters using [Container Storage Interface (CSI) drivers](/azure/aks/csi-storage-drivers), the following extra storage classes are created:

| Storage class            | Description                                                  |
| :----------------------- | :----------------------------------------------------------- |
| `managed-csi`            | Uses Azure Standard SSD locally redundant storage (LRS) to create a managed disk. The reclaim policy ensures that the underlying Azure Disk is deleted when the persistent volume that used it is deleted. The storage class also configures the persistent volumes to be expandable. You can edit the persistent volume claim to specify the new size. Effective starting with Kubernetes version 1.29, in Azure Kubernetes Service (AKS) clusters deployed across multiple availability zones, this storage class utilizes Azure Standard SSD zone-redundant storage (ZRS) to create managed disks. |
| `managed-csi-premium`    | Uses Azure Premium locally redundant storage (LRS) to create a managed disk. The reclaim policy again ensures that the underlying Azure Disk is deleted when the persistent volume that used it is deleted. Similarly, this storage class allows for persistent volumes to be expanded. Effective starting with Kubernetes version 1.29, in Azure Kubernetes Service (AKS) clusters deployed across multiple availability zones, this storage class utilizes Azure Premium zone-redundant storage (ZRS) to create managed disks. |
| `azurefile-csi`          | Uses Azure Standard storage to create an Azure file share. The reclaim policy ensures that the underlying Azure file share is deleted when the persistent volume that used it is deleted. |
| `azurefile-csi-premium`  | Uses Azure Premium storage to create an Azure file share. The reclaim policy ensures that the underlying Azure file share is deleted when the persistent volume that used it is deleted. |
| `azureblob-nfs-premium`  | Uses Azure Premium storage to create an Azure Blob storage container and connect using the NFS v3 protocol. The reclaim policy ensures that the underlying Azure Blob storage container is deleted when the persistent volume that used it is deleted. |
| `azureblob-fuse-premium` | Uses Azure Premium storage to create an Azure Blob storage container and connect using BlobFuse. The reclaim policy ensures that the underlying Azure Blob storage container is deleted when the persistent volume that used it is deleted. |

Unless you specify a storage class for a persistent volume, the default storage class is used. Ensure volumes use the appropriate storage you need when requesting persistent volumes.

**Important**: Starting with Kubernetes version 1.21, AKS uses CSI drivers by default, and CSI migration is enabled. While existing in-tree persistent volumes continue to function, starting with version 1.26, AKS will no longer support volumes created using in-tree driver and storage provisioned for files and disk.

The `default` class will be the same as `managed-csi`.

Effective starting with Kubernetes version 1.29, when you deploy Azure Kubernetes Service (AKS) clusters across multiple availability zones, AKS now utilizes zone-redundant storage (ZRS) to create managed disks within built-in storage classes. ZRS ensures synchronous replication of your Azure managed disks across multiple Azure availability zones in your chosen region. This redundancy strategy enhances the resilience of your applications and safeguards your data against datacenter failures.

However, it's important to note that zone-redundant storage (ZRS) comes at a higher cost compared to locally redundant storage (LRS). If cost optimization is a priority, you can create a new storage class with the `skuname` parameter set to LRS. You can then use the new storage class in your Persistent Volume Claim (PVC).

You can create a storage class for other needs using `kubectl`. The following example uses premium managed disks and specifies that the underlying Azure Disk should be *retained* when you delete the pod:

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

Be aware that AKS reconciles the default storage classes and will overwrite any changes you make to those storage classes.

For more information about storage classes, see [StorageClass in Kubernetes](https://kubernetes.io/docs/concepts/storage/storage-classes/).

## Persistent volume claims

A persistent volume claim (PVC) requests storage of a particular storage class, access mode, and size. The Kubernetes API server can dynamically provision the underlying Azure Storage resource if no existing resource can fulfill the claim based on the defined storage class.

The pod definition includes the volume mount once the volume has been connected to the pod.

![Diagram of persistent volume claims in an Azure Kubernetes Services (AKS) cluster.](/azure/aks/media/concepts-storage/aks-storage-persistent-volume-claim.png)

Once an available storage resource has been assigned to the pod requesting storage, the persistent volume is *bound* to a persistent volume claim. Persistent volumes are mapped to claims in a 1:1 mapping.

The following example YAML manifest shows a persistent volume claim that uses the *managed-premium* storage class and requests an Azure Disk that is *5Gi* in size:

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
- The *volume mount* for your applications to read and write data.

The following example YAML manifest shows how the previous persistent volume claim can be used to mount a volume at */mnt/azure*:

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

For mounting a volume in a Windows container, specify the drive letter and path. For example:

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

By default, Azure automatically replicates the operating system disk for a virtual machine to Azure Storage to avoid data loss when the VM is relocated to another host. However, since containers aren't designed to have local state persisted, this behavior offers limited value while providing some drawbacks. These drawbacks include, but aren't limited to, slower node provisioning and higher read/write latency.

By contrast, ephemeral OS disks are stored only on the host machine, just like a temporary disk. With this configuration, you get lower read/write latency, together with faster node scaling and cluster upgrades.

When you don't explicitly request [Azure managed disks](/azure/virtual-machines/managed-disks-overview) for the OS, AKS defaults to ephemeral OS if possible for a given node pool configuration.

Size requirements and recommendations for ephemeral OS disks are available in the [Azure VM documentation](/azure/virtual-machines/ephemeral-os-disks). The following are some general sizing considerations:

- If you chose to use the AKS default VM size [Standard_DS2_v2](/azure/virtual-machines/dv2-dsv2-series#dsv2-series) SKU with the default OS disk size of 100 GiB, the default VM size supports ephemeral OS, but only has 86 GiB of cache size. This configuration would default to managed disks if you don't explicitly specify it. If you do request an ephemeral OS, you receive a validation error.
- If you request the same [Standard_DS2_v2](/azure/virtual-machines/dv2-dsv2-series#dsv2-series) SKU with a 60-GiB OS disk, this configuration would default to ephemeral OS. The requested size of 60 GiB is smaller than the maximum cache size of 86 GiB.
- If you select the [Standard_D8s_v3](/azure/virtual-machines/dv3-dsv3-series#dsv3-series) SKU with 100-GB OS disk, this VM size supports ephemeral OS and has 200 GiB of cache space. If you don't specify the OS disk type, the node pool would receive ephemeral OS by default.

The latest generation of VM series doesn't have a dedicated cache, but only temporary storage. For example, if you selected the [Standard_E2bds_v5](/azure/virtual-machines/ebdsv5-ebsv5-series#ebdsv5-series) VM size with the default OS disk size of 100 GiB, it supports ephemeral OS disks, but only has 75 GB of temporary storage. This configuration would default to managed OS disks if you don't explicitly specify it. If you do request an ephemeral OS disk, you receive a validation error.

- If you request the same [Standard_E2bds_v5](/azure/virtual-machines/ebdsv5-ebsv5-series#ebdsv5-series) VM size with a 60-GiB OS disk, this configuration defaults to ephemeral OS disks. The requested size of 60 GiB is smaller than the maximum temporary storage of 75 GiB.
- If you select [Standard_E4bds_v5](/azure/virtual-machines/ebdsv5-ebsv5-series#ebdsv5-series) SKU with 100-GiB OS disk, this VM size supports ephemeral OS and has 150 GiB of temporary storage. If you don't specify the OS disk type, by default Azure provisions an ephemeral OS disk to the node pool.

### Customer-managed keys

You can manage encryption for your ephemeral OS disk with your own keys on an AKS cluster. For more information, see [Use Customer Managed key with Azure disk on AKS](/azure/aks/azure-disk-customer-managed-keys).

## Volumes

Kubernetes typically treats individual pods as ephemeral, disposable resources. Applications have different approaches available to them for using and persisting data. A *volume* represents a way to store, retrieve, and persist data across pods and through the application lifecycle.

Traditional volumes are created as Kubernetes resources backed by Azure Storage. You can manually create data volumes to be assigned to pods directly or have Kubernetes automatically create them. Data volumes can use: [Azure Disk](/azure/virtual-machines/disks-types), [Azure Files](/azure/storage/files/storage-files-planning), [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-service-levels), or [Azure Blobs](/azure/storage/common/storage-account-overview).

> [!NOTE]
> Depending on the VM SKU you're using, the Azure Disk CSI driver might have a per-node volume limit. For some high-performance VMs (for example, 16 cores), the limit is 64 volumes per node. To identify the limit per VM SKU, review the **Max data disks** column for each VM SKU offered. For a list of VM SKUs offered and their corresponding detailed capacity limits, see [General purpose virtual machine sizes](/azure/virtual-machines/sizes-general).

To help determine the best fit for your workload between Azure Files and Azure NetApp Files, review the information provided in the article [Azure Files and Azure NetApp Files comparison](/azure/storage/files/storage-files-netapp-comparison).

### Azure Disk

By default, an AKS cluster comes with pre-created `managed-csi` and `managed-csi-premium` storage classes that use [Disk Storage](https://azure.microsoft.com/services/storage/disks). Similar to Amazon EBS, these classes create a managed disk or block device that's attached to the node for pod access.

The Disk classes allow both [static](/azure/aks/azure-disk-volume) and [dynamic](/azure/aks/azure-disks-dynamic-pv) volume provisioning. Reclaim policy ensures that the disk is deleted with the persistent volume. You can expand the disk by editing the persistent volume claim.

These storage classes use Azure managed disks with [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage). LRS means that the data has three synchronous copies within a single physical location in an Azure primary region. LRS is the least expensive replication option, but doesn't offer protection against a datacenter failure. You can define custom storage classes that use Zone-redundant storage (ZRS) managed disks.  Zone-redundant storage (ZRS) synchronously replicates your Azure managed disk across three Azure availability zones in the region you select. Each availability zone is a separate physical location with independent power, cooling, and networking. ZRS disks provide at least 99.9999999999% (12 9's) of durability over a given year. A ZRS managed disk can be attached by a virtual machine in a different [availability zone](/azure/availability-zones/az-overview). ZRS disks are currently not available an all the Azure regions. For more information on ZRS disks, see [Zone Redundant Storage (ZRS) option for Azure Disks for high availability](https://youtu.be/RSHmhmdHXcY). In addition, to mitigate the risk of data loss, you can take regular backups or snapshots of Disk Storage data by using [Azure Kubernetes Service Backup](/azure/backup/azure-kubernetes-service-backup-overview) or third party solutions like [Velero](https://github.com/vmware-tanzu/velero) or [Azure Backup](/azure/backup/backup-managed-disks) that can use built-in snapshot technologies.

You can use [Azure Disk](/azure/aks/azure-disk-csi) to create a Kubernetes *DataDisk* resource. Disks types include:

- [Premium SSDs](/azure/aks/azure-disk-csi) (recommended for most workloads)
- [Premium SSD v2](/azure/aks/use-premium-v2-disks)
- [Ultra disks](/azure/aks/use-ultra-disks)
- [Standard SSDs](/azure/aks/azure-disk-csi)
- Standard HDDs

> [!TIP]
> For most production and development workloads, use Premium SSDs.

Because an Azure Disk is mounted as *ReadWriteOnce*, it's only available to a single node. For storage volumes accessible by pods on multiple nodes simultaneously, use Azure Files.

#### Azure Premium SSD v2 disks

[Azure Premium SSD v2 disks](/azure/virtual-machines/disks-types#premium-ssd-v2) offer IO-intense enterprise workloads, a consistent submillisecond disk latency, and high IOPS and throughput. The performance (capacity, throughput, and IOPS) of Premium SSD v2 disks can be independently configured at any time, making it easier for more scenarios to be cost efficient while meeting performance needs. For more information on how to configure a new or existing AKS cluster to use Azure Premium SSD v2 disks, see [Use Azure Premium SSD v2 disks on Azure Kubernetes Service](/azure/aks/use-premium-v2-disks).

#### Ultra Disk Storage

Ultra Disk Storage is an Azure managed disk tier that offers high throughput, high IOPS, and consistent low latency disk storage for Azure VMs. Ultra Disk Storage is intended for workloads that are data and transaction heavy. Like other Disk Storage SKUs, and Amazon EBS, Ultra Disk Storage mounts one pod at a time and doesn't provide concurrent access.

Use the flag `--enable-ultra-ssd` to [enable Ultra Disk Storage on your AKS cluster](/azure/aks/use-ultra-disks).

If you choose Ultra Disk Storage, be aware of its [limitations](/azure/virtual-machines/disks-enable-ultra-ssd#ga-scope-and-limitations), and make sure to select a compatible VM size. Ultra Disk Storage is available with locally redundant storage (LRS) replication.

#### Bring your own keys (BYOK)

Azure encrypts all data in a managed disk at rest. By default, data is encrypted with Microsoft-managed keys. For more control over encryption keys, you can supply customer-managed keys to use for encryption at rest for both the OS and data disks for your AKS clusters. For more information, see [Bring your own keys (BYOK) with Azure managed disks in Azure Kubernetes Service (AKS)](/azure/aks/azure-disk-customer-managed-keys).

### Azure Files

Disk Storage can't provide concurrent access to a volume, but you can use [Azure Files](https://azure.microsoft.com/services/storage/files) to mount a Server Message Block (SMB) version 3.1.1 share or Network File System (NFS) version 4.1 share backed by Azure Storage. This process provides a network-attached storage that's similar to Amazon EFS. As with Disk Storage, there are two options:

- Azure Files Standard storage is backed by regular hard disk drives (HDDs).
- Azure Files Premium storage backs the file share with high-performance SSD drives. The minimum file share size for Premium is 100 GB.

Azure Files has the following storage account replication options to protect your data in case of failure:

- **Standard_LRS**: Standard [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- **Standard_GRS**: Standard [geo-redundant storage (GRS)](/azure/storage/common/storage-redundancy#geo-redundant-storage)
- **Standard_ZRS**: Standard [zone-redundant storage (ZRS)](/azure/storage/common/storage-redundancy#zone-redundant-storage)
- **Standard_RAGRS**: Standard [read-access geo-redundant storage (RA-GRS)](/azure/storage/common/storage-redundancy#read-access-to-data-in-the-secondary-region)
- **Standard_RAGZRS**: Standard [read-access geo-zone-redundant storage (RA-GZRS)](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage)
- **Premium_LRS**: Premium [locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage)
- **Premium_ZRS**: Premium [zone-redundant storage (ZRS)](/azure/storage/common/storage-redundancy#zone-redundant-storage)

To optimize costs for Azure Files, purchase [Azure Files capacity reservations](/azure/storage/files/files-reserve-capacity).

### Azure NetApp Files

[Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) is an enterprise-class, high-performance, metered file storage service running on Azure and supports volumes using [NFS](/azure/aks/azure-netapp-files-nfs) (NFSv3 or NFSv4.1), [SMB](/azure/aks/azure-netapp-files-smb), and [dual-protocol](/azure/aks/azure-netapp-files-dual-protocol) (NFSv3 and SMB, or NFSv4.1 and SMB). Kubernetes users have two options for using Azure NetApp Files volumes for Kubernetes workloads:

- Create Azure NetApp Files volumes **statically**. In this scenario, the creation of volumes is external to AKS. Volumes are created using the Azure CLI or from the Azure portal, and are then exposed to Kubernetes by the creation of a `PersistentVolume`. Statically created Azure NetApp Files volumes have many limitations (for example, inability to be expanded, needing to be over-provisioned, and so on). Statically created volumes aren't recommended for most use cases.
- Create Azure NetApp Files volumes **dynamically**, orchestrating through Kubernetes. This method is the **preferred** way to create multiple volumes directly through Kubernetes, and is achieved using [Astra Trident](https://docs.netapp.com/us-en/trident/index.html). Astra Trident is a CSI-compliant dynamic storage orchestrator that helps provision volumes natively through Kubernetes.

For more information, see [Configure Azure NetApp Files for Azure Kubernetes Service](/azure/aks/azure-netapp-files).

### Azure Blob storage

The [Azure Blob storage Container Storage Interface (CSI) driver](/azure/aks/azure-blob-csi) is a [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md)-compliant driver used by Azure Kubernetes Service (AKS) to manage the lifecycle of Azure Blob storage. The CSI is a standard for exposing arbitrary block and file storage systems to containerized workloads on Kubernetes.

By adopting and using CSI, AKS now can write, deploy, and iterate plug-ins to expose new or improve existing storage systems in Kubernetes. Using CSI drivers in AKS avoids having to touch the core Kubernetes code and wait for its release cycles.

When you mount Azure Blob storage as a file system into a container or pod, it enables you to use blob storage with a number of applications that work massive amounts of unstructured data. For example:

- Log file data
- Images, documents, and streaming video or audio
- Disaster recovery data

The data on the object storage can be accessed by applications using [BlobFuse](https://github.com/Azure/azure-storage-fuse/blob/master/README.md) or [Network File System (NFS) 3.0 protocol](https://en.wikipedia.org/wiki/Network_File_System). Before the introduction of the Azure Blob storage CSI driver, the only option was to manually install an unsupported driver to access Blob storage from your application running on AKS. When the Azure Blob storage CSI driver is enabled on AKS, there are two built-in storage classes: *[azureblob-fuse-premium](/azure/aks/azure-blob-csi)* and *[azureblob-nfs-premium](/azure/aks/azure-blob-csi)*.

To create an AKS cluster with CSI drivers support, see [CSI drivers on AKS](/azure/aks/csi-storage-drivers). To learn more about the differences in access between each of the Azure storage types using the NFS protocol, see [Compare access to Azure Files, Blob Storage, and Azure NetApp Files with NFS](/azure/storage/common/nfs-comparison).

### Azure HPC Cache

[Azure HPC Cache](/azure/hpc-cache/hpc-cache-overview) speeds access to your data for HPC tasks, with all the scalability of cloud solutions. If you choose this storage solution, make sure to deploy your AKS cluster in a [region that supports Azure HPC cache](https://azure.microsoft.com/global-infrastructure/services/?products=hpc-cache&regions=all).

### NFS server

The best option for shared NFS access is to use Azure Files or Azure NetApp Files. You can also [create an NFS Server on an Azure VM](/azure/aks/azure-nfs-volume) that exports volumes.

Be aware that this option only supports static provisioning. You must provision the NFS shares manually on the server, and can't do so from AKS automatically.

This solution is based on infrastructure as a service (IaaS) rather than platform as a service (PaaS). You're responsible for managing the NFS server, including OS updates, high availability, backups, disaster recovery, and scalability.

### Bring your own keys (BYOK) with Azure disks

Azure Storage encrypts all data in a storage account at rest, including the OS and data disks of an AKS cluster. By default, data is encrypted with Microsoft-managed keys. For more control over encryption keys, you can supply customer-managed keys to use for encryption at rest of the OS and data disks of your AKS clusters. For more information, see:

- [BYOK with Azure disks in AKS](/azure/aks/azure-disk-customer-managed-keys).
- [Server-side encryption of Azure Disk Storage](/azure/virtual-machines/disk-encryption).

### Azure Container Storage

[Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) is a cloud-based volume management, deployment, and orchestration service built natively for containers. It integrates with Kubernetes, allowing you to dynamically and automatically provision persistent volumes to store data for stateful applications running on Kubernetes clusters.

Azure Container Storage utilizes existing Azure Storage offerings for actual data storage and offers a volume orchestration and management solution purposely built for containers. Supported backing storage options include:

- [Azure Disks](/azure/virtual-machines/managed-disks-overview): Granular control of storage SKUs and configurations. They are suitable for tier 1 and general purpose databases.
- Ephemeral Disks: Utilizes local storage resources on AKS nodes (NVMe or temp SSD). Best suited for applications with no data durability requirement or with built-in data replication support. AKS discovers the available ephemeral storage on AKS nodes and acquires them for volume deployment.
- [Azure Elastic SAN](/azure/storage/elastic-san/elastic-san-introduction): Provision on-demand, fully managed resource. Suitable for general purpose databases, streaming and messaging services, CD/CI environments, and other tier 1/tier 2 workloads. Multiple clusters can access a single SAN concurrently, however persistent volumes can only be attached by one consumer at a time.

Until now, providing cloud storage for containers required using individual container storage interface (CSI) drivers to use storage services intended for infrastructure as a service (IaaS)-centric workloads and make them work for containers. This creates operational overhead and increases the risk of issues with application availability, scalability, performance, usability, and cost.

Azure Container Storage is derived from OpenEBS, an open-source solution that provides container storage capabilities for Kubernetes. By offering a managed volume orchestration solution via microservice-based storage controllers in a Kubernetes environment, Azure Container Storage enables true container-native storage.

Azure Container Storage is suitable in the following scenarios:

- **Accelerate VM-to-container initiatives:** Azure Container Storage surfaces the full spectrum of Azure block storage offerings that were previously only available for VMs and makes them available for containers. This includes ephemeral disk that provides extremely low latency for workloads like Cassandra, as well as Azure Elastic SAN that provides native iSCSI and shared provisioned targets.

- **Simplify volume management with Kubernetes:** By providing volume orchestration via the Kubernetes control plane, Azure Container Storage makes it easy to deploy and manage volumes within Kubernetes - without the need to move back and forth between different control planes.

- **Reduce total cost of ownership (TCO):** Improve cost efficiency by increasing the scale of persistent volumes supported per pod or node. Reduce the storage resources needed for provisioning by dynamically sharing storage resources. Note that scale up support for the storage pool itself isn't supported.

Azure Container Storage provides the following key benefits:

- **Rapid scale out of stateful pods:** Azure Container Storage mounts persistent volumes over network block storage protocols (NVMe-oF or iSCSI), offering fast attach and detach of persistent volumes. You can start small and deploy resources as needed while making sure your applications aren't starved or disrupted, either during initialization or in production. Application resiliency is improved with pod respawns across the cluster, requiring rapid movement of persistent volumes. Using remote network protocols, Azure Container Storage tightly couples with the pod lifecycle to support highly resilient, high-scale stateful applications on AKS.

- **Improved performance for stateful workloads:** Azure Container Storage enables superior read performance and provides near-disk write performance by using NVMe-oF over RDMA. This allows customers to cost-effectively meet performance requirements for various container workloads including tier 1 I/O intensive, general purpose, throughput sensitive, and dev/test. Accelerate the attach/detach time of persistent volumes and minimize pod failover time.

- **Kubernetes-native volume orchestration:** Create storage pools and persistent volumes, capture snapshots, and manage the entire lifecycle of volumes using `kubectl` commands without switching between toolsets for different control plane operations.

### Third-party solutions

Like Amazon EKS, AKS is a Kubernetes implementation, and you can integrate third-party Kubernetes storage solutions. Here are some examples of third-party storage solutions for Kubernetes:

- [Rook](https://rook.io/) turns distributed storage systems into self-managing storage services by automating Storage administrator tasks. Rook delivers its services via a Kubernetes operator for each storage provider.
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

To optimize Azure Storage costs, use Azure reservations. Make sure to [check which services support Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations#charges-covered-by-reservation). Also see [Cost management for a Kubernetes cluster](cost-management.yml).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal System Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Cloud Solution Architect

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
