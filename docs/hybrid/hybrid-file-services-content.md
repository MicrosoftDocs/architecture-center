

This reference architecture illustrates how to use Azure File Sync and Azure Files to extend file services hosting capabilities across cloud and on-premises file share resources.

![An Azure hybrid file services topology diagram.][Architecture diagram]

*Download a [Visio file][Visio diagram] of this architecture.*

Typical uses for this architecture include:

- Hosting file shares that need to be accessible from cloud and on-premises environments.
- Synchronizing data between multiple on-premises data stores with a single cloud-based source.

## Architecture

The architecture consists of the following components:

- **[Storage Account][Storage Account]**. An Azure Storage Account used to host Microsoft Azure file shares.
- **[Azure Files][Azure Files]**.  A serverless cloud file share that provides the cloud endpoint of a sync relationship with Azure File Sync. Files in an Azure file share can be accessed directly with Server Message Block (SMB) or the FileREST protocol.
- **Sync groups**. Logical groupings of Azure file shares and servers running Windows Server. Sync groups are deployed into Storage Sync Service, which registers servers for use with Azure File Sync and contain the sync group relationships.
- **Azure File Sync agent**. This is installed on Windows Server machines to enable and configure sync with cloud endpoints.
- **Windows Servers**. On-premises or cloud-based Windows Server machines that host a file share that syncs with an Azure file share.
- **[Azure Active Directory][Azure Active Directory]**. The Azure Active Directory (Azure AD) tenant used for identity synchronization across Azure and on-premises environments.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Azure Files usage and deployment

You store your files in the cloud in Azure file shares. You can use Azure file shares in two ways: by directly mounting these serverless Azure file shares (SMB) or by caching Azure file shares on-premises using Azure File Sync. The deployment option you choose changes what you need to consider as you plan for your deployment:

- Direct mount of an Azure file share. Because Azure Files provides SMB access, you can mount Azure file shares on-premises or in the cloud using the standard SMB client available in the Windows, macOS, and Linux operating systems. Azure file shares are serverless, so deploying for production scenarios doesn't require managing a file server or network-attached storage (NAS) device. This means you don't have to apply software patches or swap out physical disks.
- Cache Azure file share on-premises with Azure File Sync. Azure File Sync enables you to centralize your organization's file shares in Azure Files, while keeping the flexibility, performance, and compatibility of an on-premises file server. Azure File Sync transforms an on-premises (or cloud) Windows Server into a quick cache of your Azure file share.

### Deploy the Storage Sync Service

Begin Azure File Sync deployment by deploying a Storage Sync Service resource into a resource group of your selected subscription. We recommend provisioning as few Storage Sync Service objects as possible. You will create a trust relationship between your servers and this resource, and a server can only be registered to one Storage Sync Service. As a result, we recommend that you deploy as many Storage Sync Services as you need to separate groups of servers. Keep in mind that servers from different Storage Sync Services cannot sync with each other.

### Registering Windows Server machines with the Azure File Sync agent

To enable the sync capability on Windows Server, you must install the Azure File Sync downloadable agent. The Azure File Sync agent provides two main components:

- `FileSyncSvc.exe`. The background Windows service that is responsible for monitoring changes on the server endpoints and initiating sync sessions.
- `StorageSync.sys`. A file system filter that enables cloud tiering and faster disaster recovery.

You can download the agent from the [Azure File Sync Agent Download][Azure File Sync Agent Download] page at the Microsoft Download Center.

#### Operating system requirements

Azure File Sync is supported by the Windows Server versions in the following table.

|Version|Supported SKUs|Supported deployment options|
|---------|----------------|------------------------------|
|Windows Server 2019|Datacenter, Standard, and IoT|Full and Core|
|Windows Server 2016|Datacenter, Standard, and Storage Server|Full and Core|
|Windows Server 2012 R2|Datacenter, Standard, and Storage Server|Full and Core|

For more information, refer to [Windows file server considerations][Windows file server considerations].

### Configuring sync groups and cloud endpoints

A *sync group* defines the sync topology for a set of files. Endpoints within a sync group are kept in sync with each other. A sync group must contain one *cloud endpoint*, which represents an Azure file share, and one or more server endpoints. A *server endpoint* represents a path on a registered server. A server can have server endpoints in multiple sync groups. You can create as many sync groups as you need to appropriately describe your desired sync topology.

A *cloud endpoint* is a pointer to an Azure file share. All server endpoints will sync with a cloud endpoint, making the cloud endpoint the hub. The storage account for the Azure file share must be located in the same region as the Storage Sync Service. The entirety of the Azure file share will be synced, with one exception: a special folder—comparable to the hidden **System Volume Information** folder on an NT file system (NTFS) volume—will be provisioned. This directory is called **.SystemShareInformation**, and it contains important sync metadata that will not sync to other endpoints.

### Configuring server endpoints

A server endpoint represents a specific location on a registered server, such as a folder on a server volume. A server endpoint must be a path on a registered server (rather than a mounted share), and use cloud tiering. The server endpoint path must be on a non-system volume. NAS is not supported.

### Azure File Share to Windows file share relationships

You should deploy Azure file shares 1 to 1 with Windows file shares wherever possible. The server endpoint object gives you a great degree of flexibility on how you set up the sync topology on the server-side of the sync relationship. To simplify management, make the path of the server endpoint match the path of the Windows file share.

Use as few Storage Sync Services as possible. This will simplify management when you have sync groups that contain multiple server endpoints, because a Windows Server can only be registered to one Storage Sync Service at a time.

Paying attention to a storage account's I/O operations per second (IOPS) limitations when deploying Azure file shares. Ideally, you would map file shares 1 to 1 with storage accounts; however, this might not always be possible due to various limits and restrictions, both from your organization and from Azure. When it's not possible to have only one file share deployed in one storage account, ensure that your most active file shares don't get put in the same storage account together.

### Topology recommendations: firewalls, edge networks, and proxy connectivity

Consider the following recommendations for solution topology.

#### Firewall and traffic filtering

Based on your organization's policy or unique regulatory requirements, you might require more restrictive communication with Azure. Therefore, Azure File Sync provides several mechanisms for you to configure networking. Based on your requirements, you can:

- Tunnel sync and file upload/download traffic over your Azure ExpressRoute or Azure virtual private network (VPN).
- Make use of Azure Files and Azure networking features such as service endpoints and private endpoints.
- Configure Azure File Sync to support your proxy in your environment.
- Throttle network activity from Azure File Sync.

To learn more about Azure File Sync and networking, refer to [Azure File Sync networking considerations][Azure File Sync networking considerations].

#### Configuring proxy servers

Many organizations use a proxy server as an intermediary between resources inside their on-premises network and resources outside their network, such as in Azure. Proxy servers are useful for many applications, such as network isolation and security, and monitoring and logging. Azure File Sync can interoperate fully with a proxy server; however, you must manually configure the proxy endpoint settings for your environment with Azure File Sync. This must be done via Azure PowerShell using the Azure File Sync server cmdlets.

For more information on how to configure Azure File Sync with a proxy server, refer to [Azure File Sync proxy and firewall settings][Azure File Sync proxy and firewall settings].

## Scalability considerations

- You should consider the type and performance of the storage account being used to host Azure file shares. All storage resources that are deployed into a storage account share the limits that apply to that storage account. To find out more about determining the current limits for a storage account, refer to [Azure Files scalability and performance targets][Azure Files scalability and performance targets].
- There are two main types of storage accounts you will use for Azure Files deployments:
  - General purpose version 2 (GPv2) storage accounts. GPv2 storage accounts allow you to deploy Azure file shares on standard/hard disk-based (HDD-based) hardware. In addition to storing Azure file shares, GPv2 storage accounts can store other storage resources such as blob containers, queues, or tables.
  - FileStorage storage accounts: FileStorage storage accounts allow you to deploy Azure file shares on premium/solid-state disk-based (SSD-based) hardware. FileStorage accounts can only be used to store Azure file shares; you cannot deploy any other storage resources (such as blob containers, queues, and tables) in a FileStorage account.
- By default, standard file shares can span only up to 5 terabytes (TiB), although the share limit can be increased to 100 TiB. To do this, the large file share feature must be enabled at the storage-account level. Premium storage accounts (FileStorage storage accounts) don't have the large file share feature flag, because all premium file shares are already enabled for provisioning up to the full 100 TiB capacity. You can only enable large file shares on locally redundant or zone-redundant standard storage accounts. After you have enabled the large file share feature flag, you can't change the redundancy level to geo-redundant storage or geo-zone-redundant storage. To enable large file shares on an existing storage account, enable the **Large file share** option in the **Configuration** view of the associated storage account.

## Availability considerations

- You should ensure that Azure File Sync is supported in the regions to which you want to deploy your solution. For more information about this, refer to [Azure file sync region availability][Azure file sync region availability].
- You should ensure that services referenced in the **Architecture** section are supported in the region to which you hybrid file services architecture is deployed.
- To protect the data in your Azure file shares against data loss or corruption, all Azure file shares store multiple copies of each file as they are written. Depending on the requirements of your workload, you can select additional degrees of redundancy.
- *Previous Versions* is a Windows feature that enables you to utilize server-side Volume Shadow Copy Service (VSS) snapshots of a volume to present restorable versions of a file to an SMB client. VSS snapshots and Previous Versions work independently of Azure File Sync. However, cloud tiering must be set to a compatible mode. Many Azure File Sync server endpoints can exist on the same volume. You have to make the following PowerShell call per volume that has even one server endpoint, where you plan to or are using cloud tiering. For more information about Previous Versions and VSS, refer to [Self-service restore through Previous Versions and VSS (Volume Shadow Copy Service)][Self-service restore through Previous Versions and VSS (Volume Shadow Copy Service)].

## Manageability considerations

- The Azure File Sync agent is updated on a regular basis to add new functionality and address issues. We recommend you configure Microsoft Update to get updates for the Azure File Sync agent as soon as they're available. For more information, refer to [Azure File Sync agent update policy][Azure File Sync agent update policy].
- Azure Storage offers soft delete for file shares (preview) so that you can more easily recover your data when it's mistakenly deleted by an application or other storage account user. To learn more about soft delete, refer to [Enable soft delete on Azure file shares][Enable soft delete on Azure file shares].
- Cloud tiering is an optional feature of Azure File Sync in which frequently accessed files are cached locally on the server while all other files are tiered to Azure Files based on policy settings. When a file is tiered, the Azure File Sync file system filter (StorageSync.sys) replaces the file locally with a pointer to the file in Azure Files. A tiered file has both the **offline** attribute and the **FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS** attribute set in NTFS so that third-party applications can securely identify tiered files. For more information, refer to [Cloud Tiering Overview][Cloud Tiering Overview].

## Security considerations

- Azure File Sync works with your standard Active Directory Domain Services (AD DS)–based identity without any special setup beyond setting up Azure File Sync. When you use Azure File Sync, file access will typically go through the Azure File Sync caching servers rather than through the Azure file share. Because the server endpoints are located on Windows Server machines, the only requirement for identity integration is using domain-joined Windows file servers to register with the Storage Sync Service. Azure File Sync will store access control lists (ACLs) for the files in the Azure file share, and will replicate them to all server endpoints.
- Even though changes made directly to the Azure file share will take longer to sync to the server endpoints in the sync group, you might also want to ensure that you can enforce your AD DS permissions on your file share directly in the cloud as well. To do this, you must domain join your storage account to your on-premises AD DS domain, just as how your Windows file servers are domain joined. To learn more about domain joining your storage account to a customer-owned AD DS instance, refer to [Overview of Azure Files identity-based authentication options for SMB access][Overview of Azure Files identity-based authentication options for SMB access].
- When using Azure File Sync, there are three different layers of encryption to consider:
  - Encryption at rest for data stored in Windows Server. There are two strategies for encrypting data on Windows Server that work generally with Azure File Sync: encryption beneath the file system such that the file system and all of the data written to it is encrypted, and encryption within the file format itself. These methods are not mutually exclusive; they can be used together if desired since the purpose of encryption is different.
  - Encryption in transit between the Azure File Sync agent and Azure. Azure File Sync agent communicates with your Storage Sync Service and Azure file share using the Azure File Sync REST protocol and the FileREST protocol, both of which always use HTTPS over port 443. Azure File Sync does not send unencrypted requests over HTTP.
  - Encryption at rest for data stored in the Azure file share. All data stored in Azure Files is encrypted at rest using Azure storage service encryption (SSE). Storage service encryption works similarly to BitLocker on Windows: data is encrypted beneath the file system level. Because data is encrypted beneath the Azure file share's file system, as it's encoded to disk, you don't have to have access to the underlying key on the client to read or write to the Azure file share.

## Cost considerations

- Consult the [Principles of cost optimization][Principles of cost optimization] page in the Azure Well-Architected Framework for cost optimization recommendations.
- The [Azure Storage Pricing][Azure Storage Overview pricing] page provides detailed pricing information based on account type, storage capacity, replication, and transactions.
- The [Data Transfers Pricing Details][Bandwidth Pricing Details] provides detailed pricing information for data egress.
- You can use the [Azure Storage Pricing Calculator][Pricing calculator] to help estimate your costs.

[Architecture diagram]: ./images/hybrid-file-services.png
[Visio diagram]: https://arch-center.azureedge.net/hybrid-file-services.vsdx
[Storage Account]: /azure/storage/common/storage-account-overview
[Azure Files]: /azure/storage/files/storage-files-planning
[Azure Active Directory]: /azure/active-directory/fundamentals/active-directory-whatis
[Planning for an Azure File Sync deployment - Azure file sync region availability]: /azure/storage/files/storage-sync-files-planning#regional-availability
[Azure File Sync proxy and firewall settings]: /azure/storage/files/storage-sync-files-firewall-and-proxy
[Windows file server considerations]: /azure/storage/files/storage-sync-files-planning#windows-file-server-considerations
[Azure File Sync Agent Download]: https://go.microsoft.com/fwlink/?linkid=858257
[Azure File Sync region availability]: /azure/storage/files/storage-sync-files-planning#azure-file-sync-region-availability
[Azure File Sync networking considerations]: /azure/storage/files/storage-sync-files-networking-overview
[Azure Files scalability and performance targets]: /azure/storage/files/storage-files-scale-targets
[Planning for an Azure File Sync deployment - Windows file server considerations]: /azure/storage/files/storage-sync-files-planning#windows-file-server-considerations
[Enable soft delete on Azure file shares]: /azure/storage/files/storage-files-enable-soft-delete?tabs=azure-portal
[Overview of Azure Files identity-based authentication options for SMB access]: /azure/storage/files/storage-files-active-directory-overview
[Azure File Sync agent update policy]: /azure/storage/files/storage-sync-files-planning#azure-file-sync-agent-update-policy
[Cloud Tiering Overview]: /azure/storage/files/storage-sync-cloud-tiering
[Self-service restore through Previous Versions and VSS (Volume Shadow Copy Service)]: /azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal#self-service-restore-through-previous-versions-and-vss-volume-shadow-copy-service
[Principles of cost optimization]: /azure/architecture/framework/cost/overview
[Azure Storage Overview pricing]: https://azure.microsoft.com/pricing/details/storage/
[Bandwidth Pricing Details]: https://azure.microsoft.com/pricing/details/data-transfers/
[Pricing calculator]: https://azure.microsoft.com/pricing/calculator/?scenario=data-management

## Next steps

Learn more about the component technologies:

- [What is Azure File Sync?](/azure/storage/file-sync/file-sync-introduction)
- [How is Azure File Sync billed?](/azure/storage/files/understanding-billing?toc=/azure/storage/file-sync/toc.json#azure-file-sync)
- [How to plan for Azure File Sync Deployment?](/azure/storage/file-sync/file-sync-planning)
- [How to deploy Azure File Sync?](/azure/storage/file-sync/file-sync-deployment-guide)
- [Azure File Sync network consideration.](/azure/storage/file-sync/file-sync-networking-overview)
- [What is Cloud Tiering?](/azure/storage/file-sync/file-sync-cloud-tiering-overview)
- [What disaster recovery option are available in Azure File Sync?](/azure/storage/file-sync/file-sync-disaster-recovery-best-practices)
- [How to backup Azure File Sync?](/azure/storage/file-sync/file-sync-disaster-recovery-best-practices)
