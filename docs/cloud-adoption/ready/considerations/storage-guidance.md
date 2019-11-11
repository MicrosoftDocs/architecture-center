---
title: Azure readiness storage design guidance
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Azure readiness storage design guidance
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/15/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: ready
---

# Storage design decisions

Storage capabilities are critical for supporting workloads and services that are hosted in the cloud. As part of your cloud adoption readiness preparations, review this article to help you plan for and address your storage needs.

## Select storage tools and services to support your workloads

[Azure Storage](/azure/storage) is the Azure platform's managed service for providing cloud storage. Azure Storage is composed of several core services and supporting features. Storage in Azure is highly available, secure, durable, scalable, and redundant. Review the scenarios and considerations described here to choose the relevant Azure services and the correct architectures to fit your organization's workload, governance, and data storage requirements.

<!-- For each application or service you'll deploy to your landing zone environment, use the following decision tree as a starting point to help you determine your storage resources requirements:

![Azure storage decision tree](../../_images/ready/storage-decision-tree.png)
-->

### Key questions

Answer the following questions about your workloads to help you make decisions based on the Azure storage decision tree:

- **Do your workloads require disk storage to support the deployment of infrastructure as a service (IaaS) virtual machines?** [Azure Disk Storage](/azure/virtual-machines/windows/managed-disks-overview) provides virtual disk capabilities for IaaS virtual machines.
- **Will you need to provide downloadable images, documents, or other media as part of your workloads?** [Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction) provides the ability to [host static files](/azure/storage/blobs/storage-blob-static-website), which are then accessible for download over the internet. You can make assets that are hosted in Blob storage public, or you can [limit assets to authorized users](/azure/storage/common/storage-auth) via Azure Active Directory (Azure AD), shared keys, or shared access signatures.
- **Will you need a location to store virtual machine logs, application logs, and analytics data?** You can use Azure Blob storage to [store Azure Monitor log data](/azure/storage/common/storage-analytics).
- **Will you need to provide a location for backup, disaster recovery, or archiving workload-related data?** Azure Disk Storage uses Azure Blob storage to provide [backup and disaster recovery capabilities](/azure/virtual-machines/windows/backup-and-disaster-recovery-for-azure-iaas-disks). You can also use Blob storage as a location to back up other resources, like on-premises or IaaS VM-hosted [SQL Server data](https://docs.microsoft.com/sql/relational-databases/backup-restore/sql-server-backup-and-restore-with-microsoft-azure-blob-storage-service?view=sql-server-2017).
- **Will you need to support big data analytics workloads?** [Azure Data Lake Storage Gen 2](/azure/storage/blobs/data-lake-storage-introduction) is built on top of Azure Blob storage. Data Lake Storage Gen 2 can support large-enterprise data lake functionality. It also can handle storing petabytes of information while sustaining hundreds of gigabits of throughput.
- **Will you need to provide cloud-native file shares?** Azure has two primary services that provide cloud-hosted file shares: Azure NetApp Files and Azure Files. [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) provides high-performance NFS shares that are well suited to common enterprise workloads like SAP. [Azure Files](/azure/storage/files/storage-files-introduction) provides file shares accessible over SMB 3.0 and HTTPS.
- **Will you need to support hybrid cloud storage for on-premises high-performance computing (HPC) workloads?** [Avere vFXT for Azure](/azure/avere-vfxt/avere-vfxt-overview) is a hybrid caching solution that you can use to expand your on-premises storage capabilities by using cloud-based storage. Avere vFXT for Azure is optimized for read-heavy HPC workloads that involve compute farms of 1,000 to 40,000 CPU cores. Avere vFXT for Azure can integrate with on-premises hardware network attached storage (NAS), Azure Blob storage, or both.
- **Will you need to perform large-scale archiving and syncing of your on-premises data to the cloud?** [Azure Data Box](/azure/databox-family/) products are designed to help you move large amounts of data from your on-premises environment to the cloud. [Azure Data Box Gateway](/azure/databox-online/data-box-gateway-overview) is a virtual device that resides on-premises. Data Box Gateway helps you manage large-scale data migration to the cloud. If you need to analyze, transform, or filter data before you move it to the cloud, you can use [Azure Data Box Edge](/azure/databox-online/data-box-edge-overview), an AI-enabled physical edge computing device that's deployed to your on-premises environment. Data Box Edge accelerates processing and the secure transfer of data to Azure.
- **Do you want to expand an existing on-premises file share to use cloud storage?** [Azure File Sync](/azure/storage/files/storage-sync-files-deployment-guide) lets you use the Azure Files service as an extension of file shares that are hosted on your on-premises Windows Server machines. The syncing service transforms Windows Server into a quick cache of your Azure file share. It allows your on-premises machines that access the share to use any protocol that's available on Windows Server.

## Common storage scenarios

Azure offers multiple products and services for different storage capabilities. In addition to the storage requirements decision tree shown earlier in this article, the following table describes a series of potential storage scenarios and the recommended Azure services to address the scenario's requirements:

### Block storage scenarios

<!-- markdownlint-disable MD033 -->

| **Scenario** | **Suggested Azure services** | **Considerations for suggested services** |
|---|---|---|
| I have bare-metal servers or VMs (Hyper-V or VMware) with direct attached storage running LOB applications. | [Azure Disk Storage (Premium SSD)](/azure/virtual-machines/windows/disks-types#premium-ssd) | For production services, the Premium SSD option provides consistent low-latency coupled with high IOPS and throughput. |
| I have servers that will host web and mobile apps. | [Azure Disk Storage (Standard SSD)](/azure/virtual-machines/windows/disks-types#standard-ssd) | Standard SSD IOPS and throughput might be sufficient (at a lower cost than Premium SSD) for CPU-bound web and app servers in production. |
| I have an enterprise SAN or all-flash array (AFA). | [Azure Disk Storage (Premium or Ultra SSD)](/azure/virtual-machines/windows/disks-types) <br/><br/> [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | Ultra SSD is NVMe-based and offers submillisecond latency with high IOPS and bandwidth. Ultra SSD is scalable up to 64 TiB. The choice of Premium SSD and Ultra SSD depends on peak latency, IOPS, and scalability requirements. |
| I have high-availability (HA) clustered servers (such as SQL Server FCI or Windows Server failover clustering). | [Azure Files (Premium)](/azure/storage/files/storage-files-planning#file-share-performance-tiers)<br/> [Azure Disk Storage (Premium or Ultra SSD)](/azure/virtual-machines/windows/disks-types) | Clustered workloads require multiple nodes to mount the same underlying shared storage for failover or HA. Premium file shares offer shared storage that's mountable via SMB. Shared block storage also can be configured on Premium SSD or Ultra SSD by using [partner solutions](https://azuremarketplace.microsoft.com/marketplace/apps/sios_datakeeper.sios-datakeeper-8?tab=Overview). |
| I have a relational database or data warehouse workload (such as SQL Server or Oracle). | [Azure Disk Storage Premium or Ultra SSD)](/azure/virtual-machines/windows/disks-types) | The choice of Premium SSD versus Ultra SSD depends on peak latency, IOPS, and scalability requirements. Ultra SSD also reduces complexity by removing the need for storage pool configuration for scalability (see [details](https://azure.microsoft.com/blog/mission-critical-performance-with-ultra-ssd-for-sql-server-on-azure-vm)). |
| I have a NoSQL cluster (such as Cassandra or MongoDB). | [Azure Disk Storage (Premium SSD)](/azure/virtual-machines/windows/disks-types#premium-ssd) | Azure Disk Storage Premium SSD offering provides consistent low-latency coupled with high IOPS and throughput. |
| I am running containers with persistent volumes. | [Azure Files (Standard or Premium)](/azure/storage/files/storage-files-planning) <br/><br/> [Azure Disk Storage (Standard, Premium, or Ultra SSD)](/azure/virtual-machines/windows/disks-types) | File (RWX) and block (RWO) volumes driver options are available for both Azure Kubernetes Service (AKS) and custom Kubernetes deployments. Persistent volumes can map to either an Azure Disk Storage disk or a managed Azure Files share. Choose premium versus standard options bases on workload requirements for persistent volumes. |
| I have a data lake (such as a Hadoop cluster for HDFS data). | [Azure Data Lake Storage Gen 2](/azure/storage/blobs/data-lake-storage-introduction) <br/><br/> [Azure Disk Storage (Standard or Premium SSD)](/azure/virtual-machines/windows/disks-types) | The Data Lake Storage Gen 2 feature of Azure Blob storage provides server-side HDFS compatibility and petabyte scale for parallel analytics. It also offers HA and reliability. Software like Cloudera can use Premium or Standard SSD on master/worker nodes, if needed. |
| I have an SAP or SAP HANA deployment. | [Azure Disk Storage (Premium or Ultra SSD)](/azure/virtual-machines/windows/disks-types) | Ultra SSD is optimized to offer submillisecond latency for tier-1 SAP workloads. Ultra SSD is now in preview. Premium SSD coupled with M-Series offers a general availability (GA) option. |
| I have a disaster recovery site with strict RPO/RTO that syncs from my primary servers. | [Azure page blobs](/azure/storage/blobs/storage-blob-pageblob-overview) | Azure page blobs are used by replication software to enable low-cost replication to Azure without the need for compute VMs until failover occurs. For more information, see the [Azure Disk Storage documentation](/azure/virtual-machines/windows/backup-and-disaster-recovery-for-azure-iaas-disks). **Note**: Page blobs support a maximum of 8 TB. |

### File and object storage scenarios

| **Scenario** | **Suggested Azure services** | **Considerations for suggested services** |
|---|---|---|
| I use Windows File Server. | [Azure Files](/azure/storage/files/storage-files-planning) <br/><br/> [Azure File Sync](/azure/storage/files/storage-sync-files-planning) | With Azure File Sync, you can store rarely used data on cloud-based Azure file shares while caching your most frequently used files on-premises for fast, local access. You can also use multisite sync to keep files in sync across multiple servers. If you plan to migrate your workloads to a cloud-only deployment, Azure Files might be sufficient. |
| I have an enterprise NAS (such as NetApp Filers or Dell-EMC Isilon). | [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) <br/><br/> [Azure Files (Premium)](/azure/storage/files/storage-files-planning#file-share-performance-tiers) | If you have an on-premises deployment of NetApp, consider using Azure NetApp Files to migrate your deployment to Azure. If you use or will migrate to Windows Server or a Linux server, or you have basic functionality needs from a file share, consider using Azure Files. For continued on-premises access, use Azure File Sync to sync Azure file shares with on-premises file shares by using a cloud tiering mechanism. |
| I have a file share (SMB or NFS). | [Azure Files (Standard or Premium)](/azure/storage/files/storage-files-planning) <br/><br/> [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | The choice of Premium versus Standard Azure Files tiers depends on IOPS, throughput, and your need for latency consistency. If you have an on-premises deployment of NetApp, consider using Azure NetApp Files. If you need to migrate your access control lists (ACLs) and timestamps to the cloud, Azure File Sync can bring all these settings to your Azure file shares as a convenient migration path. |
| I have an on-premises object storage system for petabytes of data (such as Dell-EMC ECS). | [Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction) |  Azure Blob storage provides premium, hot, cool, and archive tiers to match your workload performance and cost needs. |
| I have a DFSR deployment or another way of handling branch offices. | [Azure Files](/azure/storage/files/storage-files-planning) <br/><br/> [Azure File Sync](/azure/storage/files/storage-sync-files-planning) | Azure File Sync offers multisite sync to keep files in sync across multiple servers and native Azure file shares in the cloud. Move to a fixed storage footprint on-premises by using cloud tiering. Cloud tiering transforms your server into a cache for the relevant files while scaling cold data in Azure file shares. |
| I have a tape library (on-premises or off-site) for backup/disaster recovery or long-term data retention. | [Azure Blob storage (cool or archive tiers)](/azure/storage/blobs/storage-blob-storage-tiers) | An Azure Blob storage archive tier will have the lowest possible cost, but it might require hours to copy the offline data to a cool, hot, or premium tier of storage to allow access. Cool tiers provide instantaneous access at low cost. |
| I have file or object storage configured to receive my backups. | [Azure Blob storage (cool or archive tiers)](/azure/storage/blobs/storage-blob-storage-tiers) <br/>[Azure File Sync](/azure/storage/files/storage-sync-files-planning) | To back up data for long-term retention with lowest-cost storage, move data to Azure Blob storage and use cool and archive tiers. To enable fast disaster recovery for file data on a server (on-premises or on an Azure VM), sync shares to individual Azure file shares by using Azure File Sync. With Azure file share snapshots, you can restore earlier versions and sync them back to connected servers or access them natively in the Azure file share. |
| I run data replication to a disaster recovery site. | [Azure Files](/azure/storage/files/storage-files-planning) <br/><br/> [Azure File Sync](/azure/storage/files/storage-sync-files-planning) | Azure File Sync removes the need for a disaster recovery server and stores files in native Azure SMB shares. Fast disaster recovery rebuilds any data on a failed on-premises server quickly. You can even keep multiple server locations in sync or use cloud tiering to store only relevant data on-premises. |
| I manage data transfer in disconnected scenarios. | [Azure Data Box Edge or Azure Data Box Gateway](/azure/databox-online) | Using Data Box Edge or Data Box Gateway, you can copy data in disconnected scenarios. When the gateway is offline, it saves all files you copy in the cache, then uploads them when you’re connected. |
| I manage an ongoing data pipeline to the cloud. | [Azure Data Box Edge or Azure Data Box Gateway](/azure/databox-online) | Move data to the cloud from systems that are constantly generating data just by having them copy that data straight to the storage gateway. If they need to access that data later, it’s right there where they put it. |
| I have bursts of quantities of data that shows up all at once. | [Azure Data Box Edge or Azure Data Box Gateway](/azure/databox-online) | Manage large quantities of data that show up all at once, like when an autonomous car pulls back into the garage, or a gene sequencing machine finishes its analysis. Copy all that data to Data Box Gateway at fast local speeds, and then let the gateway upload it as your network allows.

### Plan based on data workloads

| **Scenario** | **Suggested Azure Services** | **Considerations for suggested services** |
|---|---|---|
| I want to develop a new cloud-native application that needs to persist unstructured data. | [Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction) | |
| I need to migrate data from an on-premises NetApp instance to Azure. | [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | |
| I need to migrate data from on-premises Windows File Server instances to Azure. | [Azure Files](/azure/storage/files/storage-files-planning) | |
| I need to move file data to the cloud but continue to primarily access the data from on-premises. | [Azure Files](/azure/storage/files/storage-files-planning) <br/><br/> [Azure File Sync](/azure/storage/files/storage-sync-files-planning) | |
| I need to support "burst compute" - NFS/SMB read-heavy, file-based workloads with data assets that reside on-premises while computation runs in the cloud. | [Avere vFXT for Azure](/azure/avere-vfxt/avere-vfxt-overview) | IaaS scale-out NFS/SMB file caching |
| I need to move an on-premises application that uses a local disk or iSCSI. | [Azure Disk Storage](/azure/virtual-machines/windows/managed-disks-overview) | |
| I need to migrate a container-based application that has persistent volumes. | [Azure Disk Storage](/azure/virtual-machines/windows/managed-disks-overview) <br/><br/> [Azure Files](/azure/storage/files/storage-files-planning) | |
| I need to move file shares that aren't Windows Server or NetApp to the cloud. | [Azure Files](/azure/storage/files/storage-files-planning) <br/><br/> [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | Protocol Support Regional Availability Performance Requirements Snapshot and Clone Capabilities Price Sensitivity |
| I need to transfer terabytes to petabytes of data from on-premises to Azure. | [Azure Data Box Edge](/azure/databox-online/data-box-edge-overview) | |
| I need to process data before transferring it to Azure. | [Azure Data Box Edge](/azure/databox-online/data-box-edge-overview) | |
| I need to support continuous data ingestion in an automated way by using local cache. | [Azure Data Box Gateway](/azure/databox-online/data-box-gateway-overview) | |

## Learn more about Azure storage services

After you identify the Azure tools that best match your requirements, use the detailed documentation linked in the following table to familiarize yourself with these services:

| **Service** | **Description** |
|---|---|
| [Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction) | Azure Blob storage is Microsoft's object storage solution for the cloud. Blob storage is optimized for storing massive amounts of unstructured data. Unstructured data is data that doesn't adhere to a specific data model or definition, such as text or binary data.<br/><br/>Blob storage is designed for:<ul><li>Serving images or documents directly to a browser.</li><li>Storing files for distributed access.</li><li>Streaming video and audio.</li><li>Writing to log files.</li><li>Storing data for backup and restore, disaster recovery, and archiving.</li><li>Storing data for analysis by an on-premises or Azure-hosted service.</li></ul> |
| [Azure Data Lake Storage Gen 2](/azure/storage/blobs/data-lake-storage-introduction) | Blob storage supports Azure Data Lake Storage Gen2, Microsoft's enterprise big data analytics solution for the cloud. Azure Data Lake Storage Gen2 offers a hierarchical file system as well as the advantages of Blob storage, including low-cost, tiered storage; high availability; strong consistency; and disaster recovery capabilities. |
| [Azure Disk Storage](/azure/virtual-machines/windows/managed-disks-overview) | Azure Disk Storage offers persistent, high-performance block storage to power Azure virtual machines. Azure disks are highly durable, secure, and offer the industry’s only single-instance SLA for VMs that use premium or ultra SSDs ([learn more about disk types](/azure/virtual-machines/windows/disks-types)). Azure disks provide high availability with Availability Sets and Availability Zones that map to your Azure virtual machines fault domains. In addition, Azure disks are managed as a top-level resource in Azure. Azure Resource Manager capabilities like role-based access control (RBAC), policy, and tagging by default are provided. |
| [Azure Files](/azure/storage/files/storage-files-planning) | Azure Files provides fully managed, native SMB file shares as a service, without the need to run a VM. You can mount an Azure Files share as a network drive to any Azure VM or on-premises machine. |
| [Azure File Sync](/azure/storage/files/storage-sync-files-planning) | Azure File Sync can be used to centralize your organization's file shares in Azure Files, while keeping the flexibility, performance, and compatibility of an on-premises file server. Azure File Sync transforms Windows Server into a quick cache of your Azure file share. |
| [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) | The Azure NetApp Files service is an enterprise-class, high-performance, metered file storage service. Azure NetApp Files supports any workload type and is highly available by default. You can select service and performance levels and set up snapshots through the service. |
| [Azure Data Box Edge](/azure/databox-online/data-box-edge-overview) | Azure Data Box Edge is an on-premises network device that moves data into and out of Azure. Data Box Edge has AI-enabled edge compute to preprocess data during upload. Data Box Gateway is a virtual version of the device but with the same data transfer capabilities. |
| [Azure Data Box Gateway](/azure/databox-online/data-box-gateway-overview) | Azure Data Box Gateway is a storage solution that enables you to seamlessly send data to Azure. Data Box Gateway is a virtual device based on a virtual machine provisioned in your virtualized environment or hypervisor. The virtual device resides on-premises and you write data to it by using the NFS and SMB protocols. The device then transfers your data to Azure block blobs or Azure page blobs, or to Azure Files. |
| [Avere vFXT for Azure](/azure/avere-vfxt/avere-vfxt-overview) | Avere vFXT for Azure is a filesystem caching solution for data-intensive high-performance computing (HPC) tasks. Take advantage of cloud computing's scalability to make your data accessible when and where it's needed&mdash;even for data that’s stored in your own on-premises hardware. |

## Data redundancy and availability

Azure Storage has various redundancy options to help ensure durability and high availability based on customer needs: locally redundant storage (LRS), zone-redundant storage (ZRS), geo-redundant storage (GRS), and read-access geo-redundant storage (RA-GRS).

See [Azure Storage redundancy](/azure/storage/common/storage-redundancy) to learn more about these capabilities and how you can decide on the best redundancy option for your use cases. Also, service level agreements (SLAs) for storage services provide guarantees that are financially backed. For more information, see [SLA for managed disks](https://azure.microsoft.com/support/legal/sla/managed-disks/v1_0), [SLA for virtual machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_8), and [SLA for storage accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_4).

For help with planning the right solution for Azure disks, see [Backup and disaster recovery for Azure Disk Storage](/azure/virtual-machines/windows/backup-and-disaster-recovery-for-azure-iaas-disks).

## Security

To help you protect your data in the cloud, Azure Storage offers several best practices for data security and encryption for data at rest and in transit. You can:

- Secure the storage account by using RBAC and Azure AD.
- Secure data in transit between an application and Azure by using client-side encryption, HTTPS, or SMB 3.0.
- Set data to be automatically encrypted when it's written to Azure Storage by using storage service encryption.
- Grant delegated access to the data objects in Azure Storage by using shared access signatures.
- Use analytics to track the authentication method that someone is using when they access storage in Azure.

These security features apply to Azure Blob storage (block and page) and to Azure Files. Get detailed storage security guidance in the [Azure Storage security guide](/azure/storage/common/storage-security-guide).

[Storage service encryption](/azure/storage/storage-service-encryption) provides encryption at rest and safeguards your data to meet your organization's security and compliance commitments. Storage service encryption is enabled by default for all managed disks, snapshots, and images in all the Azure regions. Starting June 10, 2017, all new managed disks, snapshots, images, and new data written to existing managed disks are automatically encrypted at rest with keys managed by Microsoft. Visit the [FAQ for managed disks](/azure/virtual-machines/windows/faq-for-disks#managed-disks-and-storage-service-encryption) for more details.

Azure Disk Encryption allows you to encrypt managed disks that are attached to IaaS VMs as OS and data disks at rest and in transit by using your keys stored in [Azure Key Vault](https://azure.microsoft.com/documentation/services/key-vault). For Windows, the drives are encrypted by using industry-standard [BitLocker](/windows/security/information-protection/bitlocker/bitlocker-overview) encryption technology. For Linux, the disks are encrypted by using the [dm-crypt](https://wikipedia.org/wiki/Dm-crypt) subsystem. The encryption process is integrated with Azure Key Vault to allow you to control and manage the disk encryption keys. For more information, see [Azure Disk Encryption for Windows and Linux IaaS VMs](/azure/security/azure-security-disk-encryption-overview).

## Regional availability

You can use Azure to deliver services at the scale that you need to reach your customers and partners *wherever they are*. The [managed disks](https://azure.microsoft.com/global-infrastructure/services/?products=managed-disks) and [Azure Storage](https://azure.microsoft.com/global-infrastructure/services/?products=storage) regional availability pages show the regions where these services are available. Checking the regional availability of a service beforehand can help you make the right decision for your workload and customer needs.

Managed disks are available in all Azure regions that have Premium SSD and Standard SSD offerings. Although Ultra SSD currently is in public preview, it's offered in only one availability zone, the East US 2 region. Verify the regional availability when you plan mission-critical, top-tier workloads that require Ultra SSD.

Hot and cool blob storage, Data Lake Storage Gen2, and Azure Files storage are available in all Azure regions. Archival bob storage, premium file shares, and premium block blob storage are limited to certain regions. We recommend that you refer to the regions page to check the latest status of regional availability.

To learn more about Azure global infrastructure, see the [Azure regions page](https://azure.microsoft.com/global-infrastructure/regions). You can also consult the [products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=storage) page for specific details about what's available in each Azure region.

## Data residency and compliance requirements

Legal and contractual requirements that are related to data storage often will apply to your workloads. These requirements might vary based on the location of your organization, the jurisdiction of the physical assets that host your data stores, and your applicable business sector. Components of data obligations to consider include data classification, data location, and the respective responsibilities for data protection under the shared responsibility model. For help with understanding these requirements, see the white paper [Achieving Compliant Data Residency and Security with Azure](https://azure.microsoft.com/resources/achieving-compliant-data-residency-and-security-with-azure).

Part of your compliance efforts might include controlling where your database resources are physically located. Azure regions are organized into groups called geographies. An [Azure geography](https://azure.microsoft.com/global-infrastructure/geographies) ensures that data residency, sovereignty, compliance, and resiliency requirements are honored within geographical and political boundaries. If your workloads are subject to data sovereignty or other compliance requirements, you must deploy your storage resources to regions that are in a compliant Azure geography.
