Consider a situation in which Azure Stack Hub hosts virtual machines (VMs) that run user workloads. There's a need to back up and restore the files and applications of the workloads. This reference architecture article describes an approach that delivers an optimized solution for backup and restore activities.

## Architecture

[ ![Diagram illustrating backup of Azure Stack Hub files and applications that are hosted on Azure VMs that run such workloads as SQL Server, SharePoint Server, Exchange Server, File Server, and Active Directory Domain Services domain controllers. The backup relies on Azure Backup Server that run on a Windows Server VM, with a geo-replicated Azure Recovery Services vault providing long-term storage. Initial backups can be performed by using Azure Import/Export service. Optionally, Azure ExpressRoute can provide high-bandwidth connectivity to Azure.](./images/azure-stack-backup.svg)](./images/azure-stack-backup.svg#lightbox)

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Workflow

The cloud components include the following services:

- An Azure subscription that hosts all cloud resources that are included in this solution.
- An Azure Active Directory (Azure AD) tenant that's associated with the Azure subscription. It provides authentication of Azure AD security principals to authorize access to Azure resources.
- An Azure Recovery Services vault in the Azure region that's closest to the on-premises datacenter that hosts the Azure Stack Hub deployment.

Depending on the criteria presented in this article, cloud components can also include the following services:

- An Azure ExpressRoute circuit that connects the on-premises datacenter and the Azure region that hosts the Azure Recovery Services vault. The circuit is configured to have Microsoft peering in order to accommodate larger backup sizes.
- The Azure Import/Export service, for enabling MABS offline backups to Azure.

  > [!NOTE]
  > As of 08/20, the MABS offline backup to Azure that uses Azure Data Box is in preview.

Depending on the use of the Azure Import/Export service for MABS offline backup to Azure, the solution might also have an Azure Storage account in the same Azure region as the Recovery Services vault.

The on-premises components include the following services:

- An Azure Stack Hub–integrated system in the connected deployment model that runs the current update (2002 as of August 2020), and located within the customer's on-premises datacenter.
- A Windows Server 2016 or Windows Server 2019 VM that's hosted by the Azure Stack Hub–integrated system and that runs MABS v3 Update Release (UR) 1.
- Azure Stack Hub VMs with the MABS protection agent, which manages backups to and restores from the MABS Azure Stack Hub VM. The MABS protection agent tracks changes to protected workloads, and transfers the changes to the MABS data store. The protection agent also identifies data on its local computer that can be protected and plays a role in the recovery process.
- A Microsoft Azure Recovery Services (MARS) agent that's installed on the server that runs MABS. The agent integrates MABS and Azure Recovery Services vault.

   > [!NOTE]
  > A MARS agent is also referred to as an *Azure Backup agent*.

### Components

- [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub)
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory)
- [Azure storage account](https://azure.microsoft.com/products/category/storage)
- [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute)

### Alternatives

The recommended solution that's described in this article isn't the only way to provide backup and restore functionality to user workloads that run on Azure Stack Hub. Customers have other options, including:

- Local backup and restore by using the **Windows Server Backup** feature that's included in the Windows Server operating system. Users can then copy local backups to longer-term storage. This approach supports application-consistent backups by relying on Windows VSS providers, but increases local disk space usage and backup maintenance overhead.
- Backup and restore by using Azure Backup with the locally installed MARS agent. This approach minimizes the use of local disk space and automates the process of uploading backups to cloud-based storage. However, it doesn't support application-consistent backups.
- Backup and restore by using a backup solution that's installed in the same datacenter but outside of Azure Stack Hub. This approach facilitates scenarios that involve an Azure Stack Hub disconnected deployment model.
- Azure Stack Hub–level backup and restore by using disk snapshots. This approach requires that the VM that's being backed up is stopped, which is typically not a viable option for business-critical workloads, but can be acceptable in some scenarios.

## Scenario details

Backup and restore are essential components of any comprehensive business continuity and disaster recovery strategy. Designing and implementing a consistent and reliable backup approach in a hybrid environment is challenging, but can be considerably simplified by integrating with Microsoft Azure services. This applies not only to the workloads that run on traditional on-premises infrastructure, but also to those hosted by third-party public and private cloud providers. However, the benefits of integration with Azure cloud services are evident when the hybrid environments incorporate Azure Stack portfolio offerings, including the Azure Stack Hub.

While one of the primary strengths of Azure Stack Hub is that it supports the platform-as-a-service (PaaS) model, it also helps customers to modernize their existing infrastructure-as-a-service (IaaS) workloads. Such workloads can include file shares, Microsoft SQL Server databases, Microsoft SharePoint farms, and Microsoft Exchange Server clusters. Migrating them to VMs that run on hyperconverged, highly resilient clusters that have administrative and programming models that are consistent with Microsoft Azure results in minimized management and maintenance overhead.

For implementing backup of files and applications that run on Azure Stack Hub VMs, Microsoft recommends a hybrid approach that relies on a combination of cloud and on-premises components to deliver a scalable, performant, resilient, secure, straightforward to manage, and cost-efficient backup solution. The central component of this solution is Microsoft Azure Backup Server (MABS) v3, which is part of the Azure Backup offering. MABS relies on Azure Stack Hub infrastructure for compute, network, and short-term storage resources, and it uses Azure-based storage to serve as the long-term backup store. This approach minimizes or eliminates the need to maintain physical backup media such as tapes.

> [!NOTE]
> MABS is based on Microsoft System Center Data Protection Manager (DPM) and provides similar functionality with just a few differences. However, DPM is not supported for use with Azure Stack Hub.

### Core functionality

The proposed solution supports the following functionality on Azure Stack Hub VMs that run Windows Server 2019, 2016, 2012 R2, 2012, 2008 R2 SP1 (64-bit with Windows Management Framework 4.0), 2008 SP2 (64-bit with Windows Management Framework 4.0), and Windows 10 (64-bit):

- Backup and restore of New Technology File System (NTFS) and Resilient File System (ReFS) volumes, shares, folders, files, and system state.
- Backup and restore of SQL Server 2019, 2017, 2016 (with required service packs (SPs)), and 2014 (with required SPs) instances and their databases.
- Backup and restore of Exchange Server 2019 and Exchange Server 2016 servers and databases, including standalone servers and databases in a database availability group (DAG).
- Restore of individual mailboxes and mailbox databases in a DAG.
- Backup and restore of SharePoint 2019 and SharePoint 2016 (with the latest SPs) farms and front-end web server content.
- Restore of SharePoint 2019 and SharePoint 2016 databases, web applications, files, list items, and search components.

   > [!NOTE]
  > To deploy Windows 10 client operating systems on Azure Stack Hub, you must have Windows per-user licensing or have purchased it through a Qualified Multitenant Hoster (QMTH).

MABS implements the disk-to-disk-to-cloud (D2D2C) backup scheme, with the primary backup stored locally on the server that hosts the MABS installation. Local backups are then copied to an Azure Site Recovery vault. The local disk functions as short-term storage, while the vault provides long-term storage.

  > [!NOTE]
  > Unlike DPM, MABS doesn't support tape backups.

The backup process consists of the following four stages:

1. You install the MABS protection agent on a computer that you want to protect, and add it to a protection group.
1. You set up protection for the computer or its app, including backup to MABS local disks for short-term storage and to Azure for long-term storage. As part of the setup, you specify the backup schedule for both types of backups.
1. The protected workload backs up to the local MABS disks according to the schedule that you specified.
1. The local backup that's stored on MABS disks is backed up to the Azure Recovery Services vault by the MARS agent that runs on the MABS server.

### Prerequisites

Implementing the recommended solution depends on meeting the following prerequisites:

- Access to an Azure subscription, with permissions that are sufficient to provision an Azure Recovery Services vault in the Azure region that's closest to an on-premises datacenter that hosts the Azure Stack Hub deployment.
- An Active Directory Domain Services (AD DS) domain that's accessible from an Azure Stack Hub VM that will host a MABS instance.
- An Azure Stack Hub-hosted VM that will run a MABS instance, satisfying the prerequisites that are listed in [Install Azure Backup Server on Azure Stack][azure-backup-azure-stack] and with outbound connectivity to URLs that are listed in [DPM/MABS networking support][azure-backup-dpmmabs-support].

  > [!NOTE]
  > Additional disk space and performance considerations for MABS are described in more detail later in this article.

  > [!NOTE]
  > To validate whether the VM that hosts MABS has connectivity to the Azure Backup service, you can use the **Get-DPMCloudConnection** cmdlet (included in the Azure Backup Server PowerShell module).

  > [!NOTE]
  > MABS also requires a local instance of SQL Server. For details regarding SQL Server requirements, see [Install and upgrade Azure Backup Server][azure-backup-server].

### Data types

From the perspective of MABS, there are two data types to consider:

- *File data* is data that typically resides on file servers (such as Microsoft Office files, text files, or media files), and that needs to be protected as flat files.
- *Application data* is data that exists on application servers (such as Exchange storage groups, SQL Server databases, or SharePoint farms) and that requires MABS to be aware of the corresponding application requirements.

> [!NOTE]
> As an alternative to file data backup with MABS, it's possible to install the MABS agent directly on an Azure Stack Hub VM and back up its local file system directly to an Azure Recovery Services vault. However, unlike MABS, this approach does not provide centralized management and always relies on cloud-based storage for backups and restores.

### Backup types

Whether you're protecting file data or application data, protection begins with creating a replica of the data source in the local storage of a MABS instance. The replica is synchronized or updated at regular intervals according to the settings that you configure. The method that MABS uses to synchronize the replica depends on the type of data that's being protected. If a replica is identified as being inconsistent, MABS performs a consistency check, which is a block-by-block verification of the replica against the data source.

For a file volume or share on a server, after the initial full backup, the MABS protection agent uses a volume filter and change journal to determine which files have changed. It then performs a checksum procedure for those files to synchronize only the changed blocks. During synchronization, these changes are transferred to MABS and then applied to the replica, thereby synchronizing the replica with the data source.

If a replica becomes inconsistent with its data source, MABS generates an alert that specifies which computer and which data sources are affected. To resolve the issue, you can repair the replica by initiating a synchronization with consistency check on the replica. During a consistency check, MABS performs a block-by-block verification and repairs the replica to return it to consistency with the data source. You can schedule a daily consistency check for protection groups or initiate a consistency check manually.

At regular intervals that you can configure, MABS creates a recovery point for the protected data source. A *recovery point* is a version of the data that can be recovered.

For application data, after the replica is created by MABS, changes to volume blocks that belong to application files are tracked by the volume filter. How changes are transferred to the MABS server depends on the application and the type of synchronization. The operation that's labeled *synchronization* in MABS Administrator Console is analogous to an incremental backup, and it creates a transactionally consistent and accurate reflection of the application data when combined with the replica.

During the type of synchronization that's labeled *express full backup* in MABS Administrator Console, a full Volume Shadow Copy Service (VSS) snapshot is created, but only the changed blocks are transferred to the MABS server.

Each express full backup creates a recovery point for application data. If the application supports incremental backups, each synchronization also creates a recovery point. The synchronization process is application-dependent:

- For Exchange data, synchronization transfers an incremental VSS snapshot by using the Exchange VSS writer. Recovery points are created for each synchronization and for each express full backup.
- SQL Server databases that are log-shipped, that are in read-only mode, or that use the simple recovery model, don't support incremental backup. Recovery points are created for each express full backup only. For all other SQL Server databases, synchronization transfers a transaction log backup, with recovery points that are created for each incremental synchronization and express full backup. The transaction log is a serial record of all transactions that have been performed against the database since the transaction log was last backed up.
- SharePoint servers don't support incremental backup. Recovery points are created for each express full backup only.

Incremental synchronizations require less time than it takes to do an express full backup. However, the time that's required to recover data increases as the number of synchronizations increases. This is because MABS must restore the last full backup and then restore and apply all the incremental synchronizations up to the point in time that's specified for recovery.

To enable faster recovery time, MABS regularly performs an express full backup, which updates the replica to include the changed blocks. During the express full backup, MABS takes a snapshot of the replica before it updates the replica by using the changed blocks. To enable more frequent RPOs and to reduce the data loss window, MABS also performs incremental synchronizations in the time between two express full backups.

As with file data protection, if a replica becomes inconsistent with its data source, MABS generates an alert that specifies which server and which data sources are affected. To resolve the inconsistency, you can repair the replica by initiating a synchronization with consistency check on the replica. During a consistency check, MABS performs a block-by-block verification of the replica and repairs it to bring it back into consistency with the data sources. You can schedule a daily consistency check for protection groups or initiate a consistency check manually.

### Protection policies

A computer or its workload becomes protected when you install the MABS protection agent software on the computer and add the data of the computer or its workload to a protection group. Protection groups are used to configure and manage the protection of data sources on computers. A *protection group* is a collection of data sources that share the same protection configuration. The *protection configuration* is the collection of settings that are common to a protection group, such as the protection group name, protection policy, storage allocations, and replica creation method.

MABS stores a separate replica of each protection group member in the storage pool. A protection group member can contain such data sources as:

- A volume, share, or folder on a file server or server cluster.
- A storage group of an Exchange server or server cluster.
- A database of an instance of SQL Server or server cluster.

For each protection group, you configure a protection policy that's based on your recovery goals for that protection group. *Recovery goals* represent data protection requirements that correspond to the RTOs and RPOs of your organization. Within MABS, they're defined based on a combination of the following parameters:

- Short-term retention range. This determines how long you want to retain backed up data on the local MABS storage.
- Synchronization and recovery point frequencies. This corresponds directly to data loss tolerance, which in turn reflects the RPOs of your organization. It also determines how often MABS should synchronize its local replicas with protected data sources by collecting their data changes. You can set the synchronization frequency to any interval between 15 minutes and 24 hours. You can also select to synchronize just before a recovery point is created rather than on a specified time schedule.
- Short-term recovery point schedule. This establishes how many recovery points should be created in the local storage for the protection group. For file protection, you select the days and times for which you want recovery points created. For data protection of applications that support incremental backups, the synchronization frequency determines the recovery point schedule.
- Express full backup schedule. This is the recovery point schedule for data protection of applications that don't support incremental backups and do support express full backups.
- Online backup schedule. This determines the frequency of creating a copy of local backups in the Azure Recovery Services vault that's associated with the local MABS instance. You can schedule on a daily, weekly, monthly, or yearly basis, with maximum allowed frequency of two backups per day. MABS automatically creates a recovery point for online backups by using the most recent local replica, without transferring new data from the protected data source.

  > [!NOTE]
  > A Recovery Services vault supports as many as 9,999 recovery points.

- Online retention policy. This specifies the time period during which daily, weekly, monthly, and yearly backups are retained in the Azure Site Recovery vault that's associated with the local MABS instance.

  > [!NOTE]
  > To protect the latest content of the data source online, create a new recovery point on the local disk before creating an online recovery point.

  > [!NOTE]
  > By default, Azure Recovery Services vault is *geo-redundant*, meaning that any backup that's copied to its storage is automatically replicated to an Azure region that's part of a pre-defined region pair. You can change the replication settings to locally redundant if that's sufficient for your resiliency needs and if you need to minimize storage costs. However, you should consider keeping the default setting. This option can't be changed if the vault contains any protected items.

  > [!NOTE]
  > For the listing of Azure region pairs, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions][azure-paired-regions].

### Testing restores

In addition to an optimally designed and implemented backup strategy, it's equally important to define, document, and test the restore process for each type of protected workload. While MABS provides built-in consistency checks that automatically verify the integrity of data backups, the testing of restores should be part of routine operating procedures. The testing validates a restore by examining the state of restored workloads. The testing results should be available to workload owners.

In general, the testing of restores tends to be challenging because it requires an environment that closely resembles the one that hosts the protected workloads. Azure Stack Hub, with its built-in DevOps and infrastructure as code capabilities, greatly simplifies addressing this challenge.

### Roles and responsibilities

Planning for and implementing backup and restore of Azure Stack Hub–based workloads typically involves interaction among many stakeholders:

- Azure Stack Hub operators. Azure Stack Hub operators manage Azure Stack Hub infrastructure, ensuring that there are sufficient compute, storage, and network resources for implementing a comprehensive backup and restore solution, and making these resources available to tenants. They also collaborate with application and data owners to help determine the optimal approach to deploying their workloads to Azure Stack Hub.
- Azure administrators. Azure administrators manage the Azure resources that are needed to implement hybrid backup solutions.
- Azure AD administrators. Azure AD administrators manage Azure AD resources, including user and group objects that are used to provision, configure, and manage Azure resources.
- Azure Stack Hub tenant IT staff. These stakeholders design, implement, and manage MABS, including the MABS backups and restores.
- Azure Stack Hub users. These users provide RPO and RTO requirements and submit requests to back up and restore data and applications.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Azure Stack Hub helps increase workload availability because of the resiliency that's inherent to its infrastructure. You can further increase availability by designing and implementing solutions that extend the scope of workload protection. This is the added value that MABS provides. In the context of MABS that runs on Azure Stack Hub, there are two aspects of availability that need to be explored in more detail:

- The availability of MABS and its data stores
- The availability of the point-in-time restore capability of MABS-protected workloads

You need to consider both of these when you develop a backup strategy that's driven by recovery point objectives (RPOs) and recovery time objectives (RTOs). RTO and RPO represent continuity requirements that are stipulated by business functions within an organization. RPO designates a time period that represents the maximum acceptable data loss due to an incident that makes the data unavailable for a time. RTO designates the maximum acceptable duration of time it can take to reinstate access to business functions after an incident that makes the functions unavailable.

> [!NOTE]
> To address the RTO requirements for Azure Stack Hub workloads, you should account for recovery of the Azure Stack infrastructure, user VMs, applications, and user data. In this article we consider only the last two of these, applications and user data, although we also present considerations regarding availability of the Modern Backup Storage (MBS) functionality.

The availability of MABS and its data stores is contingent on the availability of the VM that hosts the MABS installation and its local and cloud-based storage. Azure Stack Hub VMs are highly available by design. If there's a MABS failure, you have the ability to restore Azure Backup–protected items from any other Azure Stack Hub VM that hosts MABS. Note, however, that for a server that hosts MABS to recover backups that were done by using MABS that runs on another server, both servers must be registered with the same Azure Site Recovery vault.

> [!NOTE]
> In general, you can deploy another instance of MABS and configure it to back up the primary MABS deployment. This is similar to the primary-to-secondary protection, chaining, and cyclic protection configurations that are available when you use DPM. However, this approach is not supported for MABS and it doesn't yield meaningful availability advantages in the scenario that's described in this article.

The point-in-time restore capability of MABS-protected workloads is dependent to a large extent on the type of data, its backups, and its protection policies. To understand these dependencies, it's necessary to explore these concepts in more detail.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Managing user data and applications in hybrid scenarios warrants additional security considerations. These considerations can be grouped into the following categories:

- Backup encryption
- Azure Recovery Services vault protection

MABS and Azure Backup enforce the encryption of backups at rest and in transit:

- Encryption at rest. During the installation of MABS, the user provides a passphrase. This passphrase is then used to encrypt all backups before they're uploaded to an Azure Recovery Services vault. Decryption takes place only after backups are downloaded from that vault. The passphrase is available only to the user who created it and to the locally installed MARS agent. It's critical to ensure that the passphrase is stored in a secure location, because it serves as the authorization mechanism when performing cloud-based restores on a MABS server other than the one where the backups took place.
- Encryption in transit. MABS v3 relies on Transport Layer Security (TLS) protocol version 1.2 to protect its connections to Azure.

Azure Recovery Services vault offers mechanisms that further protect online backups, including:

- Azure role-based access control (Azure RBAC). Azure RBAC allows for delegating and segregating responsibilities according to the principle of least privilege. There are three Azure Backup-related built-in roles that restrict access to backup management operations:
  - Backup Contributor. Provides access to create and manage backups, except for deleting Recovery Services vault and delegating access to others.
  - Backup Operator. Provides access that's equivalent to that of the Backup Contributor, except for removing backups and managing backup policies.
  - Backup Reader. Provides access to monitor backup management operations.
- Azure Resource Locks. You can create and assign read-only and delete locks to an Azure Site Recovery vault to mitigate the risk of the vault being accidentally or maliciously changed or deleted.
- Soft delete. Soft delete helps protect vault and backup data from accidental or malicious deletions. With soft delete, if a user deletes a backup item, the corresponding data is retained for 14 days, allowing for its recovery with no data loss during that period. The 14-day retention of backup data in the soft delete state doesn't incur any cost. Soft delete is enabled by default.
- Protection of security-sensitive operations. The Azure Recovery Services vault automatically implements another layer of authentication whenever a security-sensitive operation, such as changing a passphrase, is attempted. This extra validation helps ensure that only authorized users do these operations.
- Suspicious activity monitoring and alerts. Azure Backup provides built-in monitoring and alerting of security-sensitive events that are related to Azure Backup operations. Backup reports facilitate usage tracking, auditing of backups and restores, and identifying key backup trends.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

When considering the cost of the backup solution that's described in this article, remember to account for both on-premises and cloud-based components. The pricing of on-premises components is determined by the Azure Stack Hub pricing model. As with Azure, Azure Stack Hub offers a pay-as-you-use arrangement that's available through enterprise agreements and the Cloud Solution Provider program. This arrangement includes a monthly price per Windows Server VM. If you can use existing Windows Server licenses, you can significantly reduce that cost down to the base VM pricing. MABS relies on SQL Server as its data store, but there's no licensing cost associated with running that SQL Server instance if it's only used for MABS.

There are Azure-related charges for use of the following resources:

- Azure Backup. Pricing for Azure Backup is largely determined by the number of protected workloads and the size of data backups (before compression and encryption) for each. The cost is also affected by the choice between locally redundant storage (LRS) and geo-redundant storage (GRS) for the replication of the Azure Recovery Services vault content. For details, see [Azure Backup pricing][azure-backup-pricing].
- Azure ExpressRoute. Azure ExpressRoute pricing is based on one of two models:
  - Unlimited data. This is a monthly fee with all inbound and outbound data transfers included.
  - Metered data. This is a monthly fee with all inbound data transfers free of charge and outbound data transfers charged per gigabyte.
- Azure Import/Export. The cost for Azure Import/Export includes a flat, per-device fee for device handling.
- Azure Storage. When you use Azure Import/Export, standard Azure Storage rates and transaction fees apply.

Without ExpressRoute, you might have to account for increased bandwidth usage of your internet connections for backups and restores. The cost will vary depending on many factors, including geographical area, current bandwidth usage, and the internet service provider.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### Manageability

One of the primary factors that affects that affects your backup and restore strategy is the configuration of protection groups and the criteria you use to decide which protected workloads should belong to the same protected groups. As described earlier in this article, a protection group is a collection of data sources such as volumes, shares, or application data stores that have common backup and restore settings. When defining a protection group, you need to specify:

- Data sources, such as servers and workloads that you want to protect.
- Back-up storage, including short-term and long-term protection settings.
- Recovery points, which are points in time from which backed up data can be recovered.
- Allocated disk space, which is the amount of disk space from the storage pool that's allocated for backups.
- Initial replication, which is the method used for the initial backup of data sources. The method can be an online transfer (over a network) or an offline transfer (such as via the Azure Import/Export service).
- The consistency checking method, which is the method of verifying the integrity of data backups.

The following methods are often used to decide which protected workloads should belong to the same protected groups:

- By computer. This method combines all data sources for a computer into the same protection group.
- By workload. This method separates files and each application data type into different protection groups. However, recovering a server hosting multiple workloads might require multiple restores from different protection groups.
- By RPO and RTO. This method groups data sources with similar RPOs. You control the RPO by setting the synchronization frequency for the protection group, which determines the amount of potential data loss (measured in time) during unexpected outages. In the scenario that's described in this article, you control the RTO by setting the retention period within the short-term storage. This determines the period during which backups can be restored from the local short-term storage, rather than from the cloud-based long-term storage. Backing up from the local short-term storage results in a faster restore.
- By data characteristics. This method accounts for the frequency of data changes, data growth rate, or its storage requirements as the criteria for groupings.

When naming protection groups, use unique, meaningful names. A name can be any combination of alphanumeric characters and spaces up to 64 characters in length.

When you create a protection group, you choose a method for creating the initial replica. The initial replication copies all the data that's selected for protection to the server that hosts MABS, and then copies it to the Azure Site Recovery vault. Both copies are checked for consistency. MABS can create replicas automatically over the network, but you can create replicas manually by backing up, transferring, and restoring data offline.

For information about choosing the replica creation method, see [Initial replication over the network][system-center-initial-replication]. The article has a table that provides estimates of how long MABS takes to create a replica automatically over the network for various protected data sizes and network speeds.

The offline-seeding process supports use of the Azure Import/Export service, which can transfer data to an Azure Storage account by using SATA disks. This capability can be used when online backup is too slow because of the amount of backup data or the speed of the network connection to Azure.

The offline-seeding workflow has the following steps:

1. You copy the initial backup data to one or more SATA disks by using the AzureOfflineBackupDiskPrep tool.
1. The tool automatically generates an Azure Import job and an Azure AD app in the subscription that hosts the target Azure Storage account and Azure Recovery Services vault. The app provides Azure Backup with secure and scoped access to the Azure Import Service, as required by the offline seeding process.
1. You ship the disks to the Azure datacenter that hosts the target Azure Storage account.
1. The Azure datacenter staff copies data from the disks to the Azure Storage account.
1. The workflow triggers a copy from the Azure Storage account to the Azure Recovery Services vault.

#### DevOps

Although backup and restore are considered to be part of IT operations, there are some DevOps-specific considerations that are worth incorporating into a comprehensive backup strategy. Azure Stack Hub facilitates automated deployment of various workloads, including VM-based applications and services. You can use this capability to streamline MABS deployment to Azure Stack Hub VMs, which simplifies the initial setup in multitenant scenarios. By combining Azure Resource Manager templates, VM extensions, and the DPM PowerShell module, it's possible to automate the configuration of MABS, including the setup of its protection groups, retention settings, and backup schedules. In the spirit of the best practices of DevOps, you should store templates and scripts in a source control facility, and configure their deployment by using pipelines. These practices help to minimize the recovery time in cases where the infrastructure that's needed to restore file and application data has to be recreated.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

When you plan to deploy MABS on Azure Stack Hub, you need to consider the amount of processing, storage, and network resources that are allocated to the VMs that host the deployment. Microsoft recommends allocating a 2.33 gigahertz (GHz) quad-core CPU to satisfy MABS processing needs, and about 10 GB of disk space to accommodate the installation binaries. Other storage requirements can be categorized as follows:

- Disk space for backups. The general recommendation for backup disk space is to allocate a storage pool of disk space that's equivalent to about 1.5 times the size of all data that's to be backed up. After the disks are attached to the VM, MABS manages volume and disk space management. The number of disks that you can attach to a VM depends on its size.

  > [!NOTE]
  > You should not store backups locally for more than five days. Backups older than five days should be offloaded to the Azure Site Recovery vault.

- Disk space for MARS agent cache location. Consider using drive **C** on the VM that hosts the MABS installation.
- Disk space for local staging area during restores. Consider using the temporary drive **D** on the VM that hosts the MABS installation.

To provision storage for the VM that hosts the MABS installation, use managed disks in the Premium performance tier. The expected performance characteristics are 2,300 I/O operations per second (IOPS) and 145 MB/s per disk. Unlike Azure, there are no performance guarantees for Azure Stack Hub.

To obtain a more accurate estimate of the storage that's required to accommodate Azure Stack Hub–based workload backups, consider using the Azure Stack VM Size Calculator for MABS, which is available from [Microsoft Downloads][azure-stack-vm-size-calculator]. The calculator is implemented as a Microsoft Excel workbook that has macros that derive optimum Azure Stack Hub sizing information that's based on a number of parameters that you provide. These parameters include:

- Source details that include a list of the VMs to be protected, including for each:
  - The size of the protected data
  - The workload type (Windows Server, SharePoint, or SQL Server)
- Data retention range, in days

Each workload type is, by default, associated with a predefined daily rate of changes (or *churn*). You can adjust these values if they don't reflect the usage patterns in your environment.

The Azure Stack VM Size Calculator for MABS uses the information that you specify to provide:

- An estimated size of the Azure Stack Hub VM that hosts the installation of MABS.
- An estimated amount of MABS disk space that's needed to host backed up data.
- A total number of disks at 1 terabyte (TB) each.
- The IOPS rate that's available for MABS usage.
- An estimated time to complete the initial backup. The estimate is based on the total size of the protected data and on the IOPS available for MABS usage.
- An estimated time to complete daily backups. The estimate is based on the total size of daily churn and on the IOPS available for MABS usage.

> [!NOTE]
> Azure Stack VM Size Calculator for MABS was released in April 2018, which means that it doesn't take into account optimizations incorporated into MABS v3 (including those included in UR1). However, it does include enhancements that are specific to MBS, which was introduced in MABS v2 released in June 2017.

If you create a protection group by using the MABS graphical interface, whenever you add a data source to a protection group, MABS calculates the local disk space allocation that's based on the short-term recovery goals that you specify. You can then decide how much space to allocate in the storage pool for replicas and recovery points for each data source in the group. You need to ensure that there's sufficient space on the local disks of the protected servers for the change journal. MABS provides default space allocations for the members of the protection group. For details regarding the default space allocations for different MABS components, see [Deploy protection groups documentation][system-center-protection-groups].

Consider using the default space allocations unless you know that they don't meet your needs. Overriding the default allocations can result in allocation of too little or too much space. Allocation of too little space for the recovery points can prevent MABS from storing enough recovery points to meet your retention range objectives. Allocation of too much space wastes disk capacity. After creating a protection group, if you allocated too little space for a data source, you can increase the allocations for the replica and recovery point volumes for each data source. If you allocated too much space for the protection group, you can remove the data source from the protection group and delete the replica. Then add the data source to the protection group with smaller allocations.

After deployment, if you need to adjust the estimated sizing of the Azure Stack Hub VMs that host MABS in order to accommodate changes in processing or storage requirements, you have three options:

- Implement vertical scaling. This requires that you modify the amount and type of processor, memory, and disk resources of the Azure Stack Hub VMs that host MABS.
- Implement horizontal scaling. This requires provisioning or deprovisioning the Azure Stack Hub VMs that have MABS installed to match the processing demands of the protected workloads.
- Modify protection policies. This requires changing the parameters of the protection policies, including retention range, recovery point schedule, and express full backup schedule.

> [!NOTE]
> MABS is subject to limits in regard to the number of recovery points, express full backups, and incremental backups. For details regarding these limits, see [Recovery process][system-center-recovery-process].

If you opt to automatically grow volumes, then MABS accounts for the increased backup volume as the production data grows. Otherwise, MABS limits the backup storage to the size of data sources in the protection group.

There are two main options to adjust available bandwidth:

- Increase the VM size. For Azure Stack Hub VMs, the size determines maximum network bandwidth. However, there are no bandwidth guarantees. Instead, VMs can use the amount of available bandwidth up to the limit determined by their size.
- Increase the throughput of uplink switches. Azure Stack Hub systems support a range of hardware switches that offer several choices of uplink speeds. Each Azure Stack Hub cluster node has two uplinks to the top-of-rack switches for fault tolerance. The system allocates half of the uplink capacity for critical infrastructure, and the remainder is shared capacity for Azure Stack services and all user traffic. Systems that are deployed with faster speeds have more bandwidth available for backup traffic.

Although it's possible to segregate network traffic by attaching a second network adapter to a server, all Azure Stack Hub VM traffic to the internet shares the same uplink. A second virtual network adapter doesn't segregate traffic at the physical transport level.

To accommodate larger backup sizes, you can consider using Azure ExpressRoute with Microsoft peering to connect between Azure Stack Hub virtual networks and Azure Recovery Services vault. Azure ExpressRoute extends on-premises networks into the Microsoft cloud over a private connection that's supplied by a connectivity provider. You can purchase ExpressRoute circuits for a wide range of bandwidths, from 50 Mbps to 10 Gbps.

> [!NOTE]
> For details about implementing Azure ExpressRoute in Azure Stack Hub scenarios, see [Connect Azure Stack Hub to Azure using Azure ExpressRoute][azure-stack-hub-expressroute].

> [!NOTE]
> MABS v3 uses enhancements that are built into MBS, and optimizes network and storage usage by transferring only changed data during consistency checks.

## Summary

Azure Stack Hub is a unique offering that differs in many aspects from other virtualization platforms. As such, it warrants special consideration in regard to business continuity strategies for workloads that run on its VMs. Using Azure services simplifies the design and implementation strategy. In this article, we explored using MABS for backing up file and application data on Azure Stack Hub VMs in the connected deployment model. This approach allows customers to benefit from the resiliency and manageability of Azure Stack Hub, and from the hyperscale and global presence of the Azure cloud.

The backup solution that's described here focuses exclusively on file and application data on Azure Stack Hub VMs. This is just a part of an overall business continuity strategy that should account for various other scenarios that affect workload availability. Some examples are: localized hardware and software failures, system outages, catastrophic events, and large-scale disasters.

## Next steps

- [How-to guides - Backup Storage Accounts on Azure Stack](/azure-stack/user/azure-stack-network-howto-backup-storage)
- [How-to guides - Backup of VMs on Azure Stack Hub using Commvault](/azure-stack/user/azure-stack-network-howto-backup-commvault)
- [Backup Cloud and On-Premises workloads to Cloud](/azure/backup/guidance-best-practices)
- [Install Azure Backup Server](/azure/backup/backup-mabs-install-azure-stack)
- [Backup files and applications on Azure Stack](/azure/backup/backup-mabs-files-applications-azure-stack)
- [Backup a SharePoint farm on Azure Stack](/azure/backup/backup-mabs-sharepoint-azure-stack)
- [Backup a SQL Server in Azure Stack](/azure/backup/backup-mabs-sql-azure-stack)

## Related resources

Related hybrid guidance:

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations)
- [Deploy a hybrid app with on-premises data that scales cross-cloud](deployments/solution-deployment-guide-cross-cloud-scaling-onprem-data.md)

Related architectures:

- [Disaster Recovery for Azure Stack Hub VMs](azure-stack-vm-disaster-recovery.yml)
- [Backup on premises applications and data to the cloud](../solution-ideas/articles/backup-archive-on-premises-applications.yml)

[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-stack-backup.vsdx
[azure-backup-azure-stack]: /azure/backup/backup-mabs-install-azure-stack
[azure-backup-dpmmabs-support]: /azure/backup/backup-support-matrix-mabs-dpm#dpmmabs-networking-support
[azure-backup-pricing]: /azure/backup/azure-backup-pricing
[azure-backup-server]: /azure/backup/backup-azure-microsoft-azure-backup
[azure-paired-regions]: /azure/best-practices-availability-paired-regions
[azure-stack-vm-size-calculator]: https://www.microsoft.com/download/details.aspx?id=56832
[azure-stack-hub-expressroute]: /azure-stack/operator/azure-stack-connect-expressroute
[system-center-initial-replication]: /system-center/dpm/create-dpm-protection-groups?view=sc-dpm-2019#initial-replication-over-the-network
[system-center-protection-groups]: /system-center/dpm/create-dpm-protection-groups?view=sc-dpm-2019#figure-out-how-much-storage-space-you-need
[system-center-recovery-process]: /system-center/dpm/how-dpm-protects-data?view=sc-dpm-2019#recovery-process
