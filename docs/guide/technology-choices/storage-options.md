---
title: Choose an Azure storage service
description: Use this guide to decide which Azure storage service best suits your application.
author: claytonsiemens77
ms.author: pnp
ms.date: 10/11/2024
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: fcp
---

# Review your storage options

Storage capabilities are critical for supporting workloads and services that are hosted in the cloud. As you prepare for your cloud adoption, review this information to plan for your storage needs.

## Select storage tools and services to support your workloads

Azure Storage is the Azure platform's managed service for providing cloud storage. Azure Storage is composed of several core services and supporting features. Storage in Azure is highly available, secure, durable, scalable, and redundant. Use these scenarios and considerations to choose Azure services and architectures. For more information, see [Azure Storage documentation](/azure/storage/).

<!-- For each application or service you'll deploy to your landing zone environment, use the following decision tree as a starting point to help you determine your storage resources requirements:

![Azure storage decision tree](../../_images/ready/storage-decision-tree.png)
-->

### Key questions
Answer the following questions about your workloads to help make decisions about your storage needs:

- **Do your workloads require disk storage to support the deployment of infrastructure as a service (IaaS) virtual machines?** [Azure managed disks](/azure/virtual-machines/managed-disks-overview) provide virtual disk capabilities for IaaS virtual machines.
- **Will you need to provide downloadable images, documents, or other media as part of your workloads?** [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) hosts static files, which are then accessible for download over the internet. For more information, see [Static website hosting in Azure Storage](/azure/storage/blobs/storage-blob-static-website).
- **Will you need a location to store virtual machine logs, application logs, and analytics data?** Azure Monitor has [native storage for metrics, logs, and distributed traces](/azure/azure-monitor/data-platform).
  - Metrics in Azure Monitor are stored in a time-series database that's optimized for analyzing time-stamped data.
  - Trace data is stored with other application log data collected by Application Insights. 
  - Logs in Azure Monitor are stored in a Log Analytics workspace that's based on [Azure Data Explorer](/azure/data-explorer/), which provides a powerful analysis engine and [rich query language](/azure/kusto/query/).
- **Will you need to provide a location for backup, disaster recovery, or archiving workload-related data?** Blob Storage provides backup and disaster recovery capabilities. For more information, see [Backup and disaster recovery for Azure IaaS disks](/azure/virtual-machines/backup-and-disaster-recovery-for-azure-iaas-disks).

  You can also use Blob Storage to back up other resources, like on-premises or IaaS virtual machine-hosted SQL Server data. See [SQL Server Backup and Restore](/sql/relational-databases/backup-restore/sql-server-backup-and-restore-with-microsoft-azure-blob-storage-service).
- **Will you need to support big data analytics workloads?** [Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction) is built on Azure Blob Storage. Data Lake Storage Gen2 supports large-enterprise data lake functionality. It also can handle storing petabytes of information while sustaining hundreds of gigabits of throughput.
- **Will you need to provide cloud-native file shares?** Azure has services that provide cloud-hosted file shares:
  - [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) provides high-performance NFS and SMB shares, with advanced data management features such as snapshots and cloning, that are well suited to common enterprise workloads like SAP.
  - [Azure Files](/azure/storage/files/storage-files-introduction) provides file shares accessible over SMB 3.1.1, NFS 4.1, and HTTPS.
  - [Azure Managed Lustre](/azure/azure-managed-lustre/amlfs-overview) is a high-performance distributed parallel file system solution, ideal for HPC workloads that require high throughput and low latency.
- **Will you need to support high-performance computing (HPC) workloads?**
  - [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) provides high-performance NFS and SMB shares, with advanced data management features such as snapshots and cloning, that are well suited to HPC workloads.
  - [Azure Managed Lustre](/azure/azure-managed-lustre/amlfs-overview) is a high-performance distributed parallel file system solution, ideal for HPC workloads that require high throughput and low latency.
- **Will you need to perform large-scale archiving and syncing of your on-premises data?** [Azure Data Box](/azure/databox/) products are designed to help you move large amounts of data from your on-premises environment to the cloud.
  - [Azure Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview) is a virtual device that's on-premises. Data Box Gateway helps you manage large-scale data migration to the cloud.
  - [Azure Stack Edge](/azure/databox-online/) accelerates processing and the secure transfer of data to Azure. If you need to analyze, transform, or filter data before you move it to the cloud, use Azure Data Box.
- **Do you want to expand an existing on-premises file share to use cloud storage?** [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) lets you use the Azure Files service as an extension of file shares that are hosted on your on-premises Windows Server computers. The syncing service transforms Windows Server into a quick cache of your Azure file share. It allows your on-premises computers that access the share to use any protocol that's available on Windows Server.

## Common storage scenarios

Azure offers multiple products and services for different storage capabilities. The following table describes potential storage scenarios and the recommended Azure services.

### Block storage scenarios

<!-- docutune:ignore M-series -->

| Scenario | Suggested Azure services | Considerations for suggested services |
|---|---|---|
| I have bare-metal servers or virtual machines (Hyper-V or VMware) with direct attached storage running line-of-business applications. | [Azure Premium SSD](/azure/virtual-machines/disks-types#premium-ssd) | For production services, Premium SSD option provides consistent low-latency coupled with high input/output operations per second (IOPS) and throughput. |
| I have servers that will host web and mobile apps. | [Azure Standard SSD](/azure/virtual-machines/disks-types#standard-ssd) | Standard SSD IOPS and throughput might be sufficient at a lower cost than Premium SSD for CPU-bound web and application servers in production. |
| I have an enterprise SAN or all-flash array. | [Premium SSD or Azure Ultra Disk Storage](/azure/virtual-machines/disks-types) or [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | Ultra Disk Storage is NVMe-based and offers submillisecond latency with high IOPS and bandwidth. Ultra Disk Storage is scalable up to 64 TiB. The choice of Premium SSD or Ultra Disk Storage depends on peak latency, IOPS, and scalability requirements. |
| I have high-availability clustered servers, such as SQL Server FCI or Windows Server failover clustering. | [Azure Files](/azure/storage/files/storage-files-planning#storage-tiers) or [Premium SSD or Ultra Disk Storage](/azure/virtual-machines/disks-types) | Clustered workloads require multiple nodes to mount the same underlying shared storage for failover or high availability. Premium file shares offer shared storage that's mountable by using SMB. Shared block storage also can be configured on Premium SSD or Ultra Disk Storage by using partner solutions. See [SIOS DataKeeper Cluster Edition](https://azuremarketplace.microsoft.com/marketplace/apps/sios_datakeeper.sios-datakeeper-8?tab=Overview). |
| I have a relational database or data warehouse workload, such as SQL Server or Oracle. | [Premium SSD or Ultra Disk Storage](/azure/virtual-machines/disks-types) | The choice of Premium SSD or Ultra Disk Storage depends on peak latency, IOPS, and scalability requirements. Ultra Disk Storage also reduces complexity by removing the need for storage pool configuration for scalability. See [Mission critical performance](https://azure.microsoft.com/blog/mission-critical-performance-with-ultra-ssd-for-sql-server-on-azure-vm/). |
| I have a NoSQL cluster such as Cassandra or MongoDB. | [Premium SSD](/azure/virtual-machines/disks-types#premium-ssd) | Azure disk storage Premium SSD provides consistent low-latency coupled with high IOPS and throughput. |
| I have containers with persistent volumes that require block storage. | [Standard SSD, Premium SSD, or Ultra Disk Storage](/azure/virtual-machines/disks-types) or [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) | Block (ReadWriteOnce) volume driver options are available for both Azure Kubernetes Service and custom Kubernetes deployments. For a fully managed solution that works seamlessly with Azure Kubernetes Service, consider using [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction). |
| I have a data lake such as a Hadoop cluster for HDFS data. | [Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction) or [Standard SSD or Premium SSD](/azure/virtual-machines/disks-types) | The Data Lake Storage Gen2 feature of Blob Storage provides server-side HDFS compatibility and petabyte scale for parallel analytics. It also offers high availability and reliability. Software like Cloudera can use Premium SSD or Standard SSD on controller/worker nodes, if needed. |
| I have an SAP or SAP HANA deployment. | [Premium SSD or Ultra Disk Storage](/azure/virtual-machines/disks-types) | Ultra Disk Storage is optimized to offer submillisecond latency for tier-1 SAP workloads. Premium SSD, coupled with M-series virtual machines, offers a general-availability option. For the highest throughput at low latency, use [Azure NetApp Files](/azure/sap/workloads/hana-vm-operations-storage) for your SAP and SAP HANA deployment. |
| I have a disaster recovery site with strict RPO/RTO that syncs from my primary servers. | [Azure page blobs](/azure/storage/blobs/storage-blob-pageblob-overview) | Page blobs are used by replication software to enable low-cost replication to Azure without the need for compute virtual machines until failover occurs. For more information, see [Backup and disaster recovery for Azure IaaS disks](/azure/virtual-machines/backup-and-disaster-recovery-for-azure-iaas-disks). **Note:** Page blobs support a maximum of 8 TiB. |

### File and object storage scenarios

| Scenario | Suggested Azure services | Considerations for suggested services |
|---|---|---|
| I use Windows file server. | [Azure Files](/azure/storage/files/storage-files-introduction) with or without [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | With Azure File Sync, you can store rarely used data on Azure file shares while caching your most frequently used files on-premises. You can also keep files in sync across multiple servers. For larger deployments that have strict requirements for high throughput and low latency, consider using [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction). |
| I have an enterprise network attached storage such as NetApp or Dell-EMC Isilon. | [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) or [Azure Files (premium)](/azure/storage/files/storage-files-planning#storage-tiers) | If you have an on-premises deployment of NetApp, consider using Azure NetApp Files to migrate your deployment to Azure. If you're using or migrating to a Windows or Linux server, consider using Azure Files. For continued on-premises access, use Azure File Sync to sync SMB file shares with on-premises file shares by using a cloud-tiering mechanism. Cloud tiering uses your on-premises Windows server as a cache for frequently accessed files while keeping colder data in Azure file shares.|
| I have an SMB or NFS file share. | [Azure Files](/azure/storage/files/storage-files-introduction) or [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | The choice of premium or standard Azure Files tiers depends on IOPS, throughput, and your need for latency consistency. If you have an on-premises deployment of NetApp, consider using Azure NetApp Files. If you need to migrate your access control lists and timestamps to the cloud, Azure File Sync can bring these settings to your SMB Azure file shares. |
| I have an on-premises object storage system for petabytes of data, such as Dell-EMC ECS. | [Blob Storage](/azure/storage/blobs/storage-blobs-introduction) | Azure Blob Storage provides premium, hot, cool, and archive tiers to match your workload performance and cost needs. |
| I have a Distributed File System Replication deployment or another way of handling branch offices. | [Azure Files](/azure/storage/files/storage-files-introduction) or [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | Azure File Sync offers multisite sync for multiple servers and native Azure file shares. Move to a fixed storage footprint on-premises by using cloud tiering. |
| I have a tape library for backup and disaster recovery or long-term data retention. | [Blob Storage](/azure/storage/blobs/access-tiers-overview) | A Blob Storage archive tier has the lowest possible cost. It might require hours to copy the offline data to a cool, hot, or Premium tier to allow access. Cool tiers provide instantaneous access at low cost. |
| I have file or object storage configured to receive my backups. | [Blob Storage](/azure/storage/blobs/access-tiers-overview) or [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | To back up data for long-term retention with lowest-cost storage, move data to Blob Storage and use cool and archive tiers. To enable fast disaster recovery for file data on a server, sync shares to individual Azure file shares by using Azure File Sync. With Azure file share snapshots, you can restore earlier versions. Sync them back to connected servers or access them natively in the Azure file share. |
| I run data replication to a disaster recovery site. | [Azure Files](/azure/storage/files/storage-files-introduction), [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) or [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | Azure File Sync removes the need for a disaster recovery server and stores files in native Azure SMB shares. Fast disaster recovery rebuilds any data on a failed on-premises server quickly. You can even keep multiple server locations in sync or use cloud tiering to store only relevant data on-premises.<br/><br/>Azure NetApp Files provides a storage based feature called [Cross region replication](/azure/azure-netapp-files/cross-region-replication-introduction) which can be used to replicate data to other Azure regions which does not use any VM or application server resources, and is highly optimized to replicate only changed data blocks between updates.
| I manage data transfer in disconnected scenarios. | [Azure Stack Edge](/azure/databox-online/) or [Data Box Gateway](/azure/databox-online/) | Using Data Stack Edge or Data Box Gateway, you can copy data in disconnected scenarios. When the gateway is offline, it saves all files you copy in the cache, then uploads them when you're connected. |
| I manage an ongoing data pipeline to the cloud. | [Azure Stack Edge](/azure/databox-online/) or [Data Box Gateway](/azure/databox-online/) | Move data to the cloud from systems that are constantly generating data by having them copy that data to the storage gateway. |
| I have bursts of data that arrive at the same time. | [Azure Stack Edge](/azure/databox-online/) or [Data Box Gateway](/azure/databox-online/) | Manage large quantities of data that arrive at the same time. Some examples are when an autonomous car pulls into the garage or a gene sequencing machine finishes its analysis. Copy all that data to Data Box Gateway at fast local speeds. Then, let the gateway upload it as your network allows. |
| I have containers with persistent volumes that require file storage. | [Azure Files](/azure/storage/files/storage-files-introduction) | File (ReadWriteMany) volume driver options are available for both Azure Kubernetes Service and custom Kubernetes deployments. |
| I have an on-premises parallel file system for petabytes of data, such as Lustre, Gluster, or BeeGFS. | [Azure Managed Lustre](/azure/azure-managed-lustre/amlfs-overview) | Azure Managed Lustre provides a fully managed Lustre file system in Azure, with features like storage capacity up to 12.5 PiB upon request, low (~2ms) latency, and the ability to spin up new clusters in minutes. |

### Plan based on data workloads

| Scenario | Suggested Azure services | Considerations for suggested services |
|---|---|---|
| I want to develop a new cloud-native application that needs to persist unstructured data. | [Blob Storage](/azure/storage/blobs/storage-blobs-introduction) | |
| I need to migrate data from an on-premises NetApp instance to Azure. | [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | |
| I need to migrate data from on-premises Windows or Linux file server instances to Azure. | [Azure Files](/azure/storage/files/storage-files-introduction) | |
| I need to move file data to the cloud but continue to primarily access the data from on-premises. | [Azure Files](/azure/storage/files/storage-files-introduction) or [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | |
| I need to move an on-premises application that uses a local disk or iSCSI. | [Azure disk storage](/azure/virtual-machines/managed-disks-overview) | |
| I need to migrate a container-based application that has persistent volumes. | [Azure disk storage](/azure/virtual-machines/managed-disks-overview) or [Azure Files](/azure/storage/files/storage-files-introduction) | |
| I need to move file shares that aren't on Windows Server or NetApp to the cloud. | [Azure Files](/azure/storage/files/storage-files-introduction) or [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | Protocol supports regional availability performance requirements snapshot and clone capabilities price sensitivity. |
| I need fully managed, cloud-native block storage (ReadWriteOnce) for Azure Kubernetes Service (AKS) clusters. | [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) | |
| I need to transfer terabytes to petabytes of data from on-premises to Azure. | [Azure Stack Edge](/azure/databox-online/) | |
| I need to process data before transferring it to Azure. | [Azure Stack Edge](/azure/databox-online/) | |
| I need to support continuous data ingestion in an automated way by using local cache. | [Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview) | |

## Learn more about Azure storage services

After you identify the Azure tools that best match your requirements, use this documentation to learn more about these services:

| Service | Description |
|---|---|
| [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) | Blob Storage is an object storage solution for the cloud. Blob Storage is optimized for storing massive amounts of unstructured data. Unstructured data is data that doesn't adhere to a specific data model or definition, such as text or binary data. <br><br> Use Blob Storage for the following needs: <br/> - Serving images or documents directly to a browser. <br/> - Storing files for distributed access. <br/> - Streaming video and audio. <br/> - Writing to log files. <br/> - Storing data for backup and restore, disaster recovery, and archiving. <br/> - Storing data for analysis by an on-premises or Azure-hosted service. |
| [Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction) | Blob Storage supports Data Lake Storage Gen2, Microsoft's enterprise big data analytics solution for the cloud. Data Lake Storage Gen2 offers a hierarchical file system, with the advantages of Blob Storage. It also includes low-cost tiered storage, high availability, strong consistency, and disaster recovery capabilities. |
| [Azure disk storage](/azure/virtual-machines/managed-disks-overview) | Azure disk storage offers persistent, high-performance block storage to power Azure Virtual Machines. Azure disks are highly durable, secure, and offer the industry's only single-instance, service-level agreement (SLA) for virtual machines that use [Azure Premium SSD or Azure Ultra Disk Storage](/azure/virtual-machines/disks-types). Azure disks provide high availability with availability sets and availability zones for your Azure Virtual Machines fault domains. Azure manages disks as a top-level resource. Azure Resource Manager capabilities are provided, such as Azure role-based access control (Azure RBAC), policy, and tagging by default. |
| [Azure Files](/azure/storage/files/storage-files-introduction) | Azure Files provides fully managed, native SMB and NFS file shares, without the need to run a virtual machine. You can mount an Azure file share as a network drive to any Azure virtual machine or on-premises computer. |
| [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) | Use Azure File Sync to centralize your file shares in Azure Files. Azure File Sync offers the flexibility, performance, and compatibility of an on-premises file server. |
| [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | The Azure NetApp Files service is an enterprise-class, high-performance, metered file storage service. Azure NetApp Files supports any workload type and is highly available by default. You can select service and performance levels and set up snapshots through the service. |
| [Azure Container Storage](/azure/storage/container-storage/container-storage-introduction) | Azure Container Storage is a fully managed, cloud-based volume management, deployment, and orchestration service built natively for containers. It integrates with Kubernetes, allowing you to dynamically and automatically provision persistent volumes to store data for stateful applications running on Kubernetes clusters. |
| [Azure Managed Lustre](/azure/azure-managed-lustre/amlfs-overview) | A high-performance distributed parallel file system solution, ideal for HPC workloads that require high throughput and low latency. |
| [Azure Data Box](/azure/databox/) | Azure Data Box is a solution that allows for offline, bulk data transfer into and out of Azure using a physical storage appliance. It's used time, network availability, or cost are limiting factors the preclude network-based data transfer. |
| [Azure Stack Edge](/azure/databox-online/) | Azure Stack Edge is an on-premises network device that moves data into and out of Azure. Data Stack Edge has AI-enabled edge compute to pre-process data during upload. Data Box Gateway is a virtual version of the device but with the same data transfer capabilities. |
| [Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview) | Data Box Gateway is a storage solution that enables you to seamlessly send data to Azure. It's a virtual device based on a virtual machine provisioned in your virtualized environment or hypervisor. The virtual device is on-premises and you write data to it by using the NFS and SMB protocols. The device then transfers your data to Azure block blobs, page blobs, or to Azure Files. |

## Data redundancy and availability

Azure Storage has various redundancy options to help ensure durability and high availability based on your needs.

- Locally redundant storage
- Zone-redundant storage
- Geo-redundant storage (GRS)
- Read-access GRS (RA-GRS)\*
- Read-access GZRS (RA-GZRS)\*

\* Not available for Azure Files.

To learn more about these capabilities and how to decide on the best redundancy option for your use cases, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy) and [Azure Files redundancy](/azure/storage/files/files-redundancy).

SLAs for storage services provide financially backed guarantees. For more information, see [SLA for managed disks](https://azure.microsoft.com/support/legal/sla/managed-disks), [SLA for virtual machines](https://azure.microsoft.com/support/legal/sla/virtual-machines), and [SLA for storage accounts](https://azure.microsoft.com/support/legal/sla/storage).

For help with planning the right solution for Azure disks, see [Backup and disaster recovery for Azure disk storage](/azure/virtual-machines/backup-and-disaster-recovery-for-azure-iaas-disks).

## Security

To help protect your data in the cloud, Azure offers several best practices for data security and encryption:

- Secure the storage account by using Azure RBAC and Microsoft Entra ID.
- Secure data in transit between an application and Azure by using client-side encryption, HTTPS, or SMB 3.1.1.
- Set data to be encrypted when it's written to Azure Storage by using Azure Storage encryption.
- Grant delegated access to the data objects in Azure Storage by using shared access signatures.
- Use analytics to track the authentication method that someone is using when they access storage in Azure.

These security features apply to Azure Blob Storage (block and page) and to Azure Files. For more information, see [Security recommendations for Blob Storage](/azure/storage/blobs/security-recommendations).

Azure Storage provides encryption at rest and safeguards your data. Azure Storage encryption is enabled by default for managed disks, snapshots, and images in all the Azure regions. All new managed disks, snapshots, images, and new data written to existing managed disks are encrypted at rest using keys managed by Microsoft. For more information, see [Azure Storage encryption](/azure/storage/common/storage-service-encryption) and [Managed disks and storage service encryption](/azure/virtual-machines/faq-for-disks#managed-disks-and-storage-service-encryption).

Azure Disk Encryption lets you encrypt managed disks that are attached to IaaS virtual machines at rest and in transit. [Azure Key Vault](/azure/key-vault/) stores your keys. For Windows, encrypt the drives by using industry-standard [BitLocker](/windows/security/information-protection/bitlocker/bitlocker-overview) encryption technology. For Linux, encrypt the disks by using the [dm-crypt](https://wikipedia.org/wiki/Dm-crypt) subsystem. The encryption process integrates with Azure Key Vault so you can control and manage the disk encryption keys. For more information, see [Azure Disk Encryption for virtual machines and virtual machine scale sets](/azure/security/fundamentals/azure-disk-encryption-vms-vmss).

## Regional availability

You can use Azure to deliver scaled services to reach your customers and partners wherever they are. Checking the regional availability of a service beforehand can help you make the right decision for your workload and customer needs. To check availability, see [Managed disks available by region](https://azure.microsoft.com/global-infrastructure/services/?products=managed-disks) and [Azure Storage available by region](https://azure.microsoft.com/global-infrastructure/services/?products=storage).

Managed disks are available in all Azure regions that have Azure Premium SSD and Standard SSD offerings. Azure Ultra Disk Storage is offered in several availability zones. Verify the regional availability when you plan mission-critical, top-tier workloads that require Ultra Disk Storage.

Hot and cool Blob Storage, Data Lake Storage Gen2, and Azure Files are available in all Azure regions. Archival blob storage, premium file shares, and premium block Blob Storage are limited to certain regions.

To learn more about Azure global infrastructure, see [Azure geographies](https://azure.microsoft.com/global-infrastructure/geographies/). Consult [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=storage) for storage options available in each Azure region.

## Data residency and compliance requirements

Legal and contractual requirements that are related to data storage often apply to your workloads. These requirements depend on the location of your organization, the jurisdiction of the physical assets that host your data stores, and your business sector. Consider data classification, data location, and the respective responsibilities for data protection under the shared responsibility model. For more information, see [Enabling Data Residency and Data Protection in Microsoft Azure Regions](https://azure.microsoft.com/resources/achieving-compliant-data-residency-and-security-with-azure/).

Part of your compliance efforts might include controlling where your database resources are physically located. Azure regions are organized into groups called geographies. An Azure geography ensures that data residency, sovereignty, compliance, and resiliency requirements are honored within geographical and political boundaries. If your workloads are subject to data sovereignty or other compliance requirements, deploy your storage resources to regions that are in a compliant Azure geography. For more information, see [Azure geographies](https://azure.microsoft.com/global-infrastructure/geographies/).

## Next step

[Review your data options](./data-options.md)
