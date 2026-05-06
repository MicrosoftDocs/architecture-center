This architecture shows how to include Azure file shares in your hybrid environment. Azure file shares are used as serverless file shares. By integrating them with Active Directory Domain Services (AD DS), you can control and limit access to AD DS users. Azure file shares then can replace traditional file servers.

## Architecture

![Azure file shares architecture diagram that shows how clients can access Azure file share directly over TCP port 445 (SMB 3.0) or by establishing VPN connection first.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Components

The architecture consists of the following components:

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an enterprise identity service that provides features to protect against cybersecurity threats. In this architecture, it serves as the cloud-based directory that stores synchronized objects from on-premises AD DS and authenticates users that access Azure file shares.
- [AD DS](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) is an on-premises identity and directory service. In this architecture, it authenticates domain-joined clients and integrates with Azure Files to enforce access controls by using Windows access control lists (ACLs). The AD DS directory synchronizes with Microsoft Entra ID to authenticate on-premises users.
- [Microsoft Entra Connect Sync](/entra/identity/hybrid/connect/how-to-connect-sync-whatis) is a synchronization service that runs on an on-premises server. In this architecture, it ensures identity consistency by syncing AD DS objects to Microsoft Entra ID.
- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a networking service that sends encrypted traffic between Azure and on-premises networks over the public internet. In this architecture, this optional component provides secure connectivity for accessing Azure file shares when Server Message Block (SMB) port 445 is blocked by internet service providers (ISPs) or firewalls.
- [Azure Files](/azure/well-architected/service-guides/azure-files) provides managed cloud-based file shares that can be accessed via SMB, Network File System (NFS), and HTTP protocols. In this architecture, it replaces traditional file servers by providing scalable, secure, and highly available storage integrated with AD DS authentication. File shares are deployed into Azure storage accounts.
- [Azure Recovery Services](/azure/backup/backup-azure-recovery-services-vault-overview) is a suite of services designed to support data protection, backup, and disaster recovery. In this architecture, an optional Recovery Services vault protects Azure file shares by enabling backup and recovery through incremental share snapshots.
- **Clients** are user computing devices, such as desktops, laptops, or mobile devices, that access resources within the network. In this architecture, clients refer to AD DS domain-joined computers for users. These clients access Azure file shares by using their existing credentials, which maintains a familiar experience while taking advantage of cloud-based storage.

## Potential use cases

Typical uses for this architecture include:

- **Replace or supplement on-premises file servers**. Azure Files can completely replace or supplement traditional on-premises file servers or network-attached storage devices. With Azure file shares and AD DS authentication, you can migrate data to Azure Files. This migration can take the advantage of high availability and scalability while minimizing client changes.
- **Lift and shift**. Azure Files supports "lift and shift" of applications that expect a file share to store application or user data to the cloud.
- **Backup and disaster recovery**. You can use Azure Files as storage for backups or for disaster recovery to improve business continuity. You can use Azure Files to back up your data from existing file servers while preserving configured Windows discretionary access control lists. Data that's stored on Azure file shares isn't affected by disasters that might affect on-premises locations.
- **Azure File Sync**. With Azure File Sync, Azure file shares can replicate to Windows Server, either on-premises or in the cloud. This replication improves performance and distributes caching of data to where it's being used.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Use general-purpose v2 (GPv2) or FileStorage storage accounts for Azure file shares

You can create an Azure file share in various storage accounts. Although general-purpose v1 (GPv1) and classic storage accounts can contain Azure file shares, most new features of Azure Files are available only in GPv2 and FileStorage storage accounts. While an Azure file share stores GPv2 storage accounts data on hard disk drive-based (HDD-based) hardware, it stores FileStorage storage accounts data on solid-state drive-based (SSD-based) hardware. For more information, see [Create an Azure file share][Create-file-share].

### Create Azure file shares in storage accounts that contain only Azure file shares

Storage accounts allow you to use different storage services in the same storage account. These storage services include Azure file shares, blob containers, and tables. All storage services in a single storage account share the same storage account limits. Mixing storage services in the same storage account make it more difficult to troubleshoot performance issues.

> [!NOTE]
> Deploy each Azure file share in its own separate storage account, if possible. If multiple Azure file shares are deployed into the same storage account, they all share the storage account limits.

### Use premium file shares for workloads that require high throughput

Premium file shares are deployed to FileStorage storage accounts and are stored on solid-state drive-based (SSD-based) hardware. This setup makes them suitable for storing and accessing data that requires consistent performance, high throughput, and low latency. (For example, these premium file shares work well with databases.) You can store other workloads that are less sensitive to performance variability on standard file shares. These workload types include general-purpose file shares and dev/test environments. For more information, see [How to create an Azure file share][Premium-Azure-file-share].

### Always require encryption when accessing SMB Azure file shares

Always use encryption in transit when accessing data in SMB Azure file shares. Encryption in transit is enabled by default. Azure Files only allows the connection if it's made with a protocol that uses encryption, such as SMB 3.0. Clients that don't support SMB 3.0 are unable to mount the Azure file share if encryption in transit is required.

### Use VPN if port that SMB uses (port 445) is blocked

Many internet service providers block **Transmission Control Protocol (TCP) port 445**, which is used to access Azure file shares. If unblocking **TCP port 445** isn't an option, you can access Azure file shares over an ExpressRoute or virtual private network (VPN) connection (site-to-site or point-to-site) to avoid traffic blocking. For more information, see [Configure a Point-to-Site (P2S) VPN on Windows for use with Azure Files][P2S-with-Azure-files] and [Configure a Site-to-Site VPN for use with Azure Files][S2S-with-Azure-files].

### Consider using Azure File Sync with Azure file shares

The Azure File Sync service allows you to cache Azure file shares on an on-premises Windows Server file server. When you enable cloud tiering, File Sync helps ensure a file server always has free available space, even as it makes more files available than a file server could store locally. If you have on-premises Windows Server file servers, consider integrating file servers with Azure file shares by using Azure File Sync. For more information, see [Planning for an Azure File Sync deployment][Planning-for-Azure-File-Sync].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Scalability

- Azure file share size is limited to 100 tebibytes (TiB). There's no minimum file share size and no limit on the number of Azure file shares.
- Maximum size of a file in a file share is 1 TiB, and there's no limit on the number of files in a file share.
- IOPS and throughput limits are per Azure storage account and are shared between Azure file shares in the same storage account.

For more information, see [Azure Files scalability and performance targets][Azure-Files-scalability-performance].

### Availability

> [!NOTE]
> An Azure storage account is the parent resource for Azure file shares. Azure file share has the level of redundancy that's provided by the storage account that contains the share.

- Azure file shares currently support the following data redundancy options:
  - **Locally redundant storage (LRS)**. Data is copied synchronously three times within a single physical location in the primary region. This practice protects against loss of data because of hardware faults, such as a bad disk drive.
  - **Zone-redundant storage (ZRS)**. Data is copied synchronously across three Azure availability zones in the primary region. Availability zones are unique physical locations within an Azure region. Each zone consists of one or more datacenters equipped with independent power, cooling, and networking.
  - **Geo-redundant storage (GRS)**. Data is copied synchronously three times within a single physical location in the primary region using LRS. Your data is then copied asynchronously to a single physical location in the secondary region. Geo-redundant storage provides six copies of your data spread between two Azure regions.
  - **Geo-zone-redundant storage (GZRS)**. Data is copied synchronously across three Azure availability zones in the primary region using ZRS. Your data is then copied asynchronously to a single physical location in the secondary region.
- Premium file shares can be stored in locally redundant storage (LRS) and zone redundant storage (ZRS) only. Standard file shares can be stored in LRS, ZRS, geo-redundant storage (GRS), and geo-zone-redundant storage (GZRS). For more information, see [Planning for an Azure Files deployment][Planning-for-Azure-Files] and [Azure Storage redundancy][Azure-Storage-redundancy].
- Azure Files is a cloud service, and as with all cloud services, you must have internet connectivity to access Azure file shares. A redundant internet connection solution is highly recommended to avoid disruptions.

### Manageability

- You can manage Azure file shares by using the same tools as any other Azure service. These tools include Azure portal, Azure Command-Line Interface, and Azure PowerShell.
- Azure file shares enforce standard Windows file permissions. You can configure directory or file-level permissions by mounting an Azure file share and configuring permissions using File Explorer, Windows **icacls.exe** command, or the **Set-Acl** Windows PowerShell cmdlet.
- You can use Azure file share snapshot for creating a point-in-time, read-only copy of the Azure file share data. You create a share snapshot at the file share level. You can then restore individual files in the Azure portal or in File Explorer, where you can also restore a whole share. You can have up to 200 snapshots per share, which enables you to restore files to different point-in time versions. If you delete a share, its snapshots are also deleted. Share snapshots are incremental. Only the data that has changed after your most recent share snapshot is saved. This practice minimizes the time required to create the share snapshot and saves on storage costs. Azure file share snapshots are also used when you protect Azure file shares with Azure Backup. For more information, see [Overview of share snapshots for Azure Files][Azure-Files-snapshots].
- You can prevent accidental deletion of Azure file shares by enabling soft delete for file shares. If you delete a file share when a soft delete is enabled, file share transitions to a soft deleted state instead of being permanently erased. You can configure the amount of time soft deleted data is recoverable before it's permanently deleted and restore the share anytime during this retention period. For more information, see [Enable soft delete on Azure file shares][Azure-Files-softdelete].

> [!NOTE]
> Azure Backup enables soft delete for all file shares in the storage account when you configure backup for the first Azure file share in the respective storage account.

> [!NOTE]
> Both standard and premium file shares are billed on used capacity when soft deleted, rather than provisioned capacity.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use AD DS authentication over SMB for accessing Azure file shares. This setup provides the same single sign-on (SSO) experience when accessing Azure file shares as accessing on-premises file shares. For more information, see [How it works][Azure-files-How-it-works] and feature [enablement steps][Azure-files-Enablement-steps]. Your client needs to be domain joined to AD DS, because the authentication is still done by the AD DS domain controller. Also, you need to assign both share level and file/directory level permissions to get access to the data. [Share level permission assignment][Azure-files-share-permissions] goes through Azure role-based access control (Azure RBAC) model. [File/directory level permission][Azure-files-file-level-permissions] is managed as Windows ACLs.

  > [!NOTE]
  > Access to Azure file shares is always authenticated. Azure file shares don't support anonymous access. Besides identity-based authentication over SMB, users can authenticate to Azure file share also by using storage access key and Shared Access Signature.

- All data that's stored on Azure file share is encrypted at rest using Azure storage service encryption (SSE). SSE works similarly to BitLocker Drive Encryption on Windows, where data is encrypted beneath the file system level. By default, data stored in Azure Files is encrypted with Microsoft-managed keys. With Microsoft-managed keys, Microsoft maintains the keys to encrypt/decrypt the data and manages rotating them regularly. You can also choose to manage your own keys, which gives you control over the rotation process.
- All Azure storage accounts have encryption in transit enabled by default. This setup means that all communication with Azure file shares is encrypted. Clients that don't support encryption can't connect to Azure file shares. If you disable encryption in transit, clients that run older operating systems, such as Windows Server 2008 R2 or older Linux, can also connect. In such instances, data isn't encrypted in transit from Azure file shares.
- By default, clients can connect to Azure file share from anywhere. To limit the networks from which clients can connect to Azure file shares, configure the Firewall, virtual networks, and private endpoint connections. For more information, see [Configure Azure Storage firewalls and virtual networks][Azure-Storage-firewalls] and [Configuring Azure Files network endpoints][Azure-Files-network-endpoints].

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Azure Files has two storage tiers and two pricing models:
  - **Standard storage**: Uses HDD-based storage. There's no minimum file share size, and you pay only for used storage space. Also, you pay for file operations, such as enumerating a directory or reading a file.
  - **Premium storage**: Uses SSD-based storage. The minimum size for a premium file share is 100 gibibytes, and you pay per provisioned storage space. When you use premium storage, all file operations are free.
- Extra costs are associated with file share snapshots and outbound data transfers. (When you transfer data from Azure file shares, inbound data transfer is free.) Data transfer costs depend on the amount of transferred data and the stock keeping unit (SKU) of your virtual network gateway, if you use one. For more information about costs, see [Azure Files Pricing][Azure-Files-Pricing] and [Azure Pricing calculator][Azure-Pricing-calculator]. The actual cost varies by Azure region and your individual contract. For more information about pricing, contact a Microsoft sales representative.

## Next steps

Learn more about the component technologies:

- [How to create an Azure file share](/azure/storage/files/storage-how-to-create-file-share) for instructions on getting started with an SMB share.
- [How to create an NFS share](/azure/storage/files/storage-files-how-to-create-nfs-shares) for instructions on getting started with an NFS mount share.

## Related resources

Explore related architectures:

- [Azure enterprise cloud file share](./azure-files-private.yml)
- [Hybrid file services](./hybrid-file-services.yml)

[architectural-diagram]: ./images/azure-file-share.svg
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-file-share.vsdx
[Create-file-share]: /azure/storage/files/storage-how-to-create-file-share
[Premium-azure-file-share]: /azure/storage/files/storage-how-to-create-premium-fileshare
[P2S-with-Azure-files]: /azure/storage/files/storage-files-configure-p2s-vpn-windows
[S2S-with-Azure-files]: /azure/storage/files/storage-files-configure-s2s-vpn
[Planning-for-Azure-File-Sync]: /azure/storage/files/storage-sync-files-planning
[Azure-Files-scalability-performance]: /azure/storage/files/storage-files-scale-targets
[Planning-for-Azure-Files]: /azure/storage/files/storage-files-planning
[Azure-Storage-redundancy]: /azure/storage/common/storage-redundancy
[Azure-files-How-it-works]: /azure/storage/files/storage-files-active-directory-overview#how-it-works
[Azure-files-Enablement-steps]: /azure/storage/files/storage-files-identity-ad-ds-enable
[Azure-files-share-permissions]: /azure/storage/files/storage-files-identity-ad-ds-assign-permissions
[Azure-files-file-level-permissions]: /azure/storage/files/storage-files-identity-ad-ds-configure-permissions
[Azure-Files-snapshots]: /azure/storage/files/storage-snapshots-files
[Azure-Files-softdelete]: /azure/storage/files/storage-files-enable-soft-delete
[Azure-Storage-firewalls]: /azure/storage/common/storage-network-security
[Azure-Files-network-endpoints]: /azure/storage/files/storage-files-networking-endpoints
[Azure-Files-Pricing]: https://azure.microsoft.com/pricing/details/storage/files/
[Azure-Pricing-calculator]: https://azure.microsoft.com/pricing/calculator/
