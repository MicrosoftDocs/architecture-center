This reference architecture illustrates how to use Azure File Sync and Azure Files to extend file services hosting capabilities across cloud and on-premises file share resources.

## Architecture

![An Azure hybrid file services topology diagram.][Architecture diagram]

*Download a [Visio file][Visio diagram] of this architecture.*

### Workflow

The architecture consists of the following components:

- **[Azure storage account][Storage Account]**. A storage account that's used to host file shares.
- **[Azure Files][Azure Files]**. A serverless cloud file share that provides the cloud endpoint of a sync relationship by using Azure File Sync. Files in an Azure file share can be accessed directly with Server Message Block (SMB) or FileREST protocol.
- **Sync groups**. Logical groupings of Azure file shares and servers that run Windows Server. Sync groups are deployed into Storage Sync Service, which registers servers for use with Azure File Sync and contains the sync group relationships.
- **Azure File Sync agent**. This is installed on Windows Server machines to enable and configure sync with cloud endpoints.
- **Windows Servers**. On-premises or cloud-based Windows Server machines that host a file share that syncs with an Azure file share.
- **[Azure Active Directory][Azure Active Directory]**. The Azure Active Directory (Azure AD) tenant that's used for identity synchronization across Azure and on-premises environments.

### Components

- [Azure storage accounts](https://azure.microsoft.com/products/category/storage)
- [Azure Files](https://azure.microsoft.com/products/storage/files)
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory)

## Scenario details

Typical uses for this architecture include:

- Hosting file shares that need to be accessible from cloud and on-premises environments.
- Synchronizing data between multiple on-premises data stores with a single cloud-based source.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a requirement that overrides them.

### Azure Files usage and deployment

You store your files in the cloud in serverless Azure file shares. You can use them in two ways: by directly mounting them (SMB) or by caching them on-premises by using Azure File Sync. What you need to consider as you plan for your deployment depends on which of the two ways that you choose.

- Direct mount of an Azure file share. Because Azure Files provides SMB access, you can mount Azure file shares on-premises or in the cloud using the standard SMB client available in the Windows, macOS, and Linux operating systems. Azure file shares are serverless, so deploying them for production scenarios doesn't require managing a file server or network-attached storage (NAS) device. This means you don't have to apply software patches or swap out physical disks.
- Cache Azure file share on-premises with Azure File Sync. Azure File Sync makes it possible for you to centralize your organization's file shares in Azure Files, while keeping the flexibility, performance, and compatibility of an on-premises file server. Azure File Sync transforms an on-premises (or cloud) Windows Server into a quick cache of your Azure file share.

### Deploy the Storage Sync Service

Begin Azure File Sync deployment by deploying a Storage Sync Service resource into a resource group of your selected subscription. We recommend provisioning as few Storage Sync Service objects as possible. You'll create a trust relationship between your servers and this resource, and a server can only be registered to one Storage Sync Service. As a result, we recommend that you deploy as many Storage Sync Services as you need to separate groups of servers. Keep in mind that servers from different Storage Sync Services can't sync with each other.

### Registering Windows Server machines with the Azure File Sync agent

To enable the sync capability on Windows Server, you must install the Azure File Sync downloadable agent. The Azure File Sync agent provides two main components:

- `FileSyncSvc.exe`. The background Windows service that's responsible for monitoring changes on the server endpoints and for initiating sync sessions.
- `StorageSync.sys`. A file system filter that enables cloud tiering and faster disaster recovery.

You can download the agent from the [Azure File Sync Agent Download][Azure File Sync Agent Download] page at the Microsoft Download Center.

#### Operating system requirements

Azure File Sync is supported by the Windows Server versions that are listed in the following table.

|Version|Supported SKUs|Supported deployment options|
|---------|----------------|------------------------------|
|Windows Server 2019|Datacenter, Standard, and IoT|Full and Core|
|Windows Server 2016|Datacenter, Standard, and Storage Server|Full and Core|
|Windows Server 2012 R2|Datacenter, Standard, and Storage Server|Full and Core|

For more information, see [Windows file server considerations][Windows file server considerations].

### Configuring sync groups and cloud endpoints

A *sync group* defines the sync topology for a set of files. Endpoints within a sync group are kept in sync with each other. A sync group must contain one *cloud endpoint*, which represents an Azure file share, and one or more server endpoints. A *server endpoint* represents a path on a registered server. A server can have server endpoints in multiple sync groups. You can create as many sync groups as you need to appropriately describe your desired sync topology.

A *cloud endpoint* is a pointer to an Azure file share. All server endpoints will sync with a cloud endpoint, making the cloud endpoint the hub. The storage account for the Azure file share must be located in the same region as the Storage Sync Service. The entirety of the Azure file share is synced, with one exception: a special folder, comparable to the hidden **System Volume Information** folder on an NT file system (NTFS) volume, is provisioned. This directory is called **.SystemShareInformation**, and it contains important sync metadata that doesn't sync to other endpoints.

### Configuring server endpoints

A server endpoint represents a specific location on a registered server, such as a folder on a server volume. A server endpoint must be a path on a registered server (rather than a mounted share), and must use cloud tiering. The server endpoint path must be on a non-system volume. NAS isn't supported.

### Azure File Share to Windows file share relationships

You should deploy Azure file shares one-to-one with Windows file shares wherever possible. The server endpoint object gives you a great degree of flexibility on how you set up the sync topology on the server-side of the sync relationship. To simplify management, make the path of the server endpoint match the path of the Windows file share.

Use as few Storage Sync Services as possible. This simplifies management when you have sync groups that contain multiple server endpoints, because a Windows Server can only be registered to one Storage Sync Service at a time.

Pay attention to I/O operations per second (IOPS) limitations on a storage account when you deploy Azure file shares. The ideal is to map file shares one-to-one with storage accounts. It isn't always possible to do that because of various limits and restrictions from your organization and from Azure. When it's not possible to have only one file share deployed in a storage account, ensure that your most active file shares aren't in the same storage account.

### Topology recommendations: firewalls, edge networks, and proxy connectivity

Consider the following recommendations for solution topology.

#### Firewall and traffic filtering

Based on the policies of your organization or on unique regulatory requirements, you might need to restrict communication with Azure. Therefore, Azure File Sync provides several mechanisms for configuring networking. Based on your requirements, you can:

- Tunnel the sync and file upload and download traffic over your Azure ExpressRoute or Azure virtual private network (VPN).
- Make use of Azure Files and Azure networking features such as service endpoints and private endpoints.
- Configure Azure File Sync to support your proxy in your environment.
- Throttle network activity from Azure File Sync.

To learn more about Azure File Sync and networking, see [Azure File Sync networking considerations][Azure File Sync networking considerations].

#### Configuring proxy servers

Many organizations use a proxy server as an intermediary between resources inside their on-premises network and resources outside their network, such as in Azure. Proxy servers are useful for many applications, such as network isolation and security, and monitoring and logging. Azure File Sync can interoperate fully with a proxy server; however, you must manually configure the proxy endpoint settings for your environment with Azure File Sync. You do this by using the Azure File Sync server cmdlets in Azure PowerShell.

For more information on how to configure Azure File Sync with a proxy server, see [Azure File Sync proxy and firewall settings][Azure File Sync proxy and firewall settings].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- You should consider the type and performance of the storage account that you use to host Azure file shares. All storage resources that are deployed into a storage account share the limits that apply to that storage account. To find out more about determining the current limits for a storage account, see [Azure Files scalability and performance targets][Azure Files scalability and performance targets].
- There are two main types of storage accounts for Azure Files deployments:
  - General purpose version 2 (GPv2) storage accounts. GPv2 storage accounts allow you to deploy Azure file shares on standard, hard disk-based (HDD-based) hardware. In addition to storing Azure file shares, GPv2 storage accounts can store other storage resources such as blob containers, queues, and tables.
  - FileStorage storage accounts: FileStorage storage accounts make it possible for you to deploy Azure file shares on premium, solid-state disk-based (SSD-based) hardware. FileStorage accounts can only be used to store Azure file shares. You can't deploy other storage resources such as blob containers, queues, and tables in a FileStorage account.
- By default, standard file shares can span no more than 5 terabytes (TiB), although the share limit can be increased to 100 TiB. To do this, the large file share feature must be enabled at the storage-account level. Premium storage accounts (FileStorage storage accounts) don't have the large file share feature flag, because all premium file shares are already enabled for provisioning up to the full 100-TiB capacity. You can only enable large file shares on locally redundant or zone-redundant standard storage accounts. After you enable the large file share feature flag, you can't change the redundancy level to geo-redundant storage or geo-zone-redundant storage. To enable large file shares on an existing storage account, enable the **Large file share** option in the **Configuration** view of the associated storage account.
- You should ensure that Azure File Sync is supported in the regions where you deploy your solution. For more information, see [Azure file sync region availability][Azure file sync region availability].
- You should ensure that the services that are referenced in the **Architecture** section are supported in the region where you deploy the hybrid file services architecture.
- To protect the data in your Azure file shares against data loss or corruption, all Azure file shares store multiple copies of each file as it's written. Depending on the requirements of your workload, you can select more degrees of redundancy.
- *Previous Versions* is a Windows feature that enables you to use server-side Volume Shadow Copy Service (VSS) snapshots of a volume to present restorable versions of a file to an SMB client. VSS snapshots and Previous Versions work independently of Azure File Sync. However, cloud tiering must be set to a compatible mode. Many Azure File Sync server endpoints can exist on the same volume. You have to make the following PowerShell call per volume that has even one server endpoint, where you plan to or are using cloud tiering. For more information about Previous Versions and VSS, see [Self-service restore through Previous Versions and VSS (Volume Shadow Copy Service)][Self-service restore through Previous Versions and VSS (Volume Shadow Copy Service)].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Azure File Sync works with your standard Active Directory Domain Services (AD DS) identity without any special setup beyond setting up Azure File Sync. When you use Azure File Sync, file access typically goes through the Azure File Sync caching servers rather than through the Azure file share. Because the server endpoints are located on Windows Server machines, the only requirement for identity integration is to use domain-joined Windows file servers to register with the Storage Sync Service. Azure File Sync stores access control lists (ACLs) for the files in the Azure file share, and replicates them to all server endpoints.
- Even though changes that are made directly to the Azure file share take longer to sync to the server endpoints in the sync group, you might want to ensure that you can enforce your AD DS permissions on your file share directly in the cloud also. To do this, you must domain join your storage account to your on-premises AD DS domain, just as your Windows file servers are domain joined. To learn more about domain joining your storage account to a customer-owned AD DS instance, see [Overview of Azure Files identity-based authentication options for SMB access][Overview of Azure Files identity-based authentication options for SMB access].
- When you use Azure File Sync, there are three different layers of encryption to consider:
  - Encryption at rest for data that's stored in Windows Server. There are two strategies for encrypting data on Windows Server that work generally with Azure File Sync: encryption beneath the file system such that the file system and all of the data written to it is encrypted, and encryption within the file format itself. These methods can be used together if desired, because their purposes differ.
  - Encryption in transit between the Azure File Sync agent and Azure. Azure File Sync agent communicates with your Storage Sync Service and Azure file share by using the Azure File Sync REST protocol and the FileREST protocol, both of which always use HTTPS over port 443. Azure File Sync doesn't send unencrypted requests over HTTP.
  - Encryption at rest for data that's stored in the Azure file share. All data that's stored in Azure Files is encrypted at rest using Azure storage service encryption (SSE). Storage service encryption works much like BitLocker on Windows: data is encrypted beneath the file system level. Because data is encrypted beneath the file system of the Azure file share as the data is encoded to disk, you don't need access to the underlying key on the client to read or write to the Azure file share.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Consult the [Principles of cost optimization][Principles of cost optimization] page in the Azure Well-Architected Framework for cost optimization recommendations.
- The [Azure Storage Pricing][Azure Storage Overview pricing] page provides detailed pricing information based on account type, storage capacity, replication, and transactions.
- The [Data Transfers Pricing Details][Bandwidth Pricing Details] article provides detailed pricing information for data egress.
- You can use the [Azure Storage Pricing Calculator][Pricing calculator] to help estimate your costs.

### Operational Excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- The Azure File Sync agent is updated on a regular basis to add new functionality and to address issues. Microsoft recommends that you configure Microsoft Update to provide updates for the Azure File Sync agent as they become available. For more information, see [Azure File Sync agent update policy][Azure File Sync agent update policy].
- Azure Storage offers soft delete for file shares so that you can recover your data when it's mistakenly deleted by an application or by another storage account user. To learn more about soft delete, see [Enable soft delete on Azure file shares][Enable soft delete on Azure file shares].
- Cloud tiering is an optional feature of Azure File Sync that caches frequently accessed files locally on the server and tiers the others to Azure Files based on policy settings. When a file is tiered, the Azure File Sync file system filter (StorageSync.sys) replaces the file locally with a pointer to the file in Azure Files. A tiered file has both the **offline** attribute and the **FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS** attribute set in NTFS so that third-party applications can securely identify tiered files. For more information, see [Cloud Tiering Overview][Cloud Tiering Overview].

## Next steps

- [What is Azure File Sync?](/azure/storage/file-sync/file-sync-introduction)
- [How is Azure File Sync billed?](/azure/storage/files/understanding-billing?toc=/azure/storage/file-sync/toc.json#azure-file-sync)
- [How to plan for Azure File Sync Deployment?](/azure/storage/file-sync/file-sync-planning)
- [How to deploy Azure File Sync?](/azure/storage/file-sync/file-sync-deployment-guide)
- [Azure File Sync network consideration.](/azure/storage/file-sync/file-sync-networking-overview)
- [What is Cloud Tiering?](/azure/storage/file-sync/file-sync-cloud-tiering-overview)
- [What disaster recovery option are available in Azure File Sync?](/azure/storage/file-sync/file-sync-disaster-recovery-best-practices)
- [How to backup Azure File Sync?](/azure/storage/file-sync/file-sync-disaster-recovery-best-practices)

## Related resources

Related hybrid guidance:

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations)
- [Deploy a hybrid app with on-premises data that scales cross-cloud](deployments/solution-deployment-guide-cross-cloud-scaling-onprem-data.md)

Related architectures:

- [Azure enterprise cloud file share](azure-files-private.yml)
- [Azure Files accessed on-premises and secured by AD DS](../example-scenario/hybrid/azure-files-on-premises-authentication.yml)
- [Hybrid file share with disaster recovery for remote and local branch workers](../example-scenario/hybrid/hybrid-file-share-dr-remote-local-branch-workers.yml)
- [Run containers in a hybrid environment](hybrid-containers.yml)
- [Use Azure file shares in a hybrid environment](azure-file-share.yml)

[Architecture diagram]: ./images/hybrid-file-services.svg
[Visio diagram]: https://arch-center.azureedge.net/hybrid-file-services.vsdx
[Storage Account]: /azure/storage/common/storage-account-overview
[Azure Files]: /azure/storage/files/storage-files-planning
[Azure Active Directory]: /azure/active-directory/fundamentals/active-directory-whatis
[Azure File Sync proxy and firewall settings]: /azure/storage/files/storage-sync-files-firewall-and-proxy
[Windows file server considerations]: /azure/storage/files/storage-sync-files-planning#windows-file-server-considerations
[Azure File Sync Agent Download]: https://go.microsoft.com/fwlink/?linkid=858257
[Azure File Sync region availability]: /azure/storage/files/storage-sync-files-planning#azure-file-sync-region-availability
[Azure File Sync networking considerations]: /azure/storage/files/storage-sync-files-networking-overview
[Azure Files scalability and performance targets]: /azure/storage/files/storage-files-scale-targets
[Enable soft delete on Azure file shares]: /azure/storage/files/storage-files-enable-soft-delete?tabs=azure-portal
[Overview of Azure Files identity-based authentication options for SMB access]: /azure/storage/files/storage-files-active-directory-overview
[Azure File Sync agent update policy]: /azure/storage/files/storage-sync-files-planning#azure-file-sync-agent-update-policy
[Cloud Tiering Overview]: /azure/storage/files/storage-sync-cloud-tiering
[Self-service restore through Previous Versions and VSS (Volume Shadow Copy Service)]: /azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal#self-service-restore-through-previous-versions-and-vss-volume-shadow-copy-service
[Principles of cost optimization]: /azure/architecture/framework/cost/overview
[Azure Storage Overview pricing]: https://azure.microsoft.com/pricing/details/storage/
[Bandwidth Pricing Details]: https://azure.microsoft.com/pricing/details/data-transfers/
[Pricing calculator]: https://azure.microsoft.com/pricing/calculator/?scenario=data-management
