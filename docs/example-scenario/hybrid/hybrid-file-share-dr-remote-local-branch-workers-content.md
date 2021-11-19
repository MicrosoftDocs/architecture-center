This architecture is from an environmental engineering company that has over 2,500 employees in 80 branches worldwide. During the COVID-19 pandemic, many users of the company's systems had to work away from their offices. Meanwhile, the systems hit the limits of their on-premises file servers at various branches, and the company faced the complexities and costs of updating and maintaining the on-premises solutions. Also, there were other unpredictable outages at branches that stopped work for users at the affected branches, whether or not the users were remote.

The company turned to Azure Files, Azure File Sync, and Azure Virtual Desktop to address these issues and to reduce costs. Azure scalability solves the limits issues, and near-instant disaster recovery keeps users working during outages. The Azure solution is also less costly and easier to manage.

The key aspects of the solution are:

- Users who are on-premises at a branch use branch desktops for their work. Remote users can be almost anywhere and still have a desktop provided by Virtual Desktop.
- Azure file shares provide centralized file storage in the cloud for workload files and FSLogix profiles.
- At each branch, an on-premises Azure File Sync server endpoint provides a cache of the branch's cloud-based file share. On-premises users that connect to this endpoint get quick access to their data.
- For each branch, a cloud endpoint provides a cache of the branch's cloud-based file share that's local to the cloud-based desktops that are provided by Virtual Desktop. Cloud desktop users that connect to this endpoint get quick access to their data.
- The on-premises cache and the cloud cache back up one another and provide fast recovery from outages.

## Potential use cases

Typical situations for this architecture include:

- A global organization requires centralized files for business-critical work.
- Workloads require local caches because of heavy file access.
- A remote workforce needs access both inside and outside of branch offices.

## Architecture

:::image type="content" source="media/hybrid-file-share-dr-remote-local-branch-workers.png" alt-text="Azure architecture to provide desktops, both on-premises and cloud-based, for a company with many branches." lightbox="media/hybrid-file-share-dr-remote-local-branch-workers.png":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1874694-hybrid-file-share-dr-remote-local-branch-workers.vsdx) of this architecture.*

1. Each branch has its own file share for its own data. The data for a branch doesn't replicate elsewhere, but users do have access to the data of branches other than their own. To maximize performance, each branch has its own storage account for its file share, and the shares may reside in different regions.
1. A file share for a branch isn't accessed directly. Instead, Azure File Sync synchronizes the file share to caches at two server endpoints: one in Azure and one on-premises at the branch.
1. A single VM supports up to 30 different server endpoints, so a handful of VMs suffice to implement the cloud endpoints for all branches. The VMs are distributed among several Azure regions to enable global accessibility as needed. Each VM is placed in a region close to the users whose primary endpoints are provided by the VM.
1. Depending on the distribution of local to remote users for a branch, either all desktops mount the cloud-based server endpoint, or the on-premises server endpoint. Because only one endpoint is active, there are no cache coherency issues. This restriction could be removed when global file lock is available to coordinate changes.
   1. In Branch 1, the users access the on-premises endpoint.
   1. In Branch N, the users access the cloud endpoint.

   The endpoint that's not being accessed serves as backup to the one that is, providing quick recovery from an endpoint outage.

1. In addition to the shared file stores that support workloads, there's also a centralized file share that holds FSLogix profiles for Virtual Desktop.

### Components

- [Azure Files](https://azure.microsoft.com/services/storage/files) provides fully-managed file shares in the cloud. Azure File Sync is a feature of Azure Files that can provide caches of a file share on the cloud and on-premises on Windows Server.
- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) is a desktop and app virtualization service that runs on the cloud to provide desktops for remote users.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues).

### Alternatives

- For more details on Active Directory and network integration with Virtual Desktop, see [Azure Virtual Desktop for the enterprise](../../example-scenario/wvd/windows-virtual-desktop.yml).
- To see an example of direct access to file shares in a hybrid environment see [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services).

## Considerations

Consider the pillars of the  [Microsoft Azure Well-Architected Framework](../../framework/index.md) when you design your system:

### Availability

This solution provides highly available access to Azure file shares. A single VM can support up to 30 different sync groups. A single file share can be synced to up to 100 server endpoints. For disaster recovery, you need multiple server endpoints per cloud endpoint, so that if one server endpoint goes down you can switch to another.

Virtual Desktop host pools can span availability zones and have spare capacity in each zone for use in case of an outage elsewhere. For high availability, use zone-redundant storage with your FSLogix file share.

### Performance

This workload deploys a single file share per storage account to maximize performance of the file share. There's a storage account limit on input/output operations per second. For more information, see the [Azure Files scalability and performance targets](/azure/storage/files/storage-files-scale-targets).

### Scalability

This solution deploys a single file share per storage account. Azure has an upper limit on storage accounts per subscription, which limits the scalability of this solution. There are also upper limits on storage capacity for file shares, a consideration for both scalability and resiliency. For more information about limits, see [Azure Files scalability and performance targets](/azure/storage/files/storage-files-scale-targets).

### Security

- Azure file share solutions are highly secure, supporting identity-based authentication and access control. For more details, see [Overview of Azure Files identity-based authentication options for SMB access](/azure/storage/files/storage-files-active-directory-overview).
- You can also manage access through shared access signature (SAS) tokens or access control lists (ACLs) which are fully supported by Azure File Sync.
- Data in Storage accounts, which includes file shares, is automatically encrypted at rest. Encryption can't be disabled. Data in transit is encrypted by SMB3 channel encryption, which is enabled by default.

### Resiliency

Azure Files supports Azure Backup, and its use is highly recommended. This workload shows the value of Azure File Sync as a disaster recovery tool. However, for locally-redundant storage (LRS) and zone-redundant storage (ZRS) workloads, backup snapshots are stored locally. Therefore, for large shares—100 TB or greater—which don't support geo-redundant storage (GRS), there's limited resiliency for a disaster. Backup supports 200 snapshots of a file share.

### DevOps

Azure Files has a fully-integrated API that can be deployed through Bicep, Terraform, and Powershell, and therefore can be managed through Azure Devops and Azure Pipelines.

## Pricing

- This solution reduces on-premises maintenance and server costs. Servers provide caches, and redundancy is no longer required.
- Review a [pricing sample](https://azure.microsoft.com/pricing/calculator/?shared-estimate=2dcc42209bcd46e9aa66fa972de6441e) for an Azure File Sync workload by using the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Adjust the values to see how your requirements affect your costs.
- With Storage you can adjust the redundancy and quantity of data and the quantity of snapshot data. It also allows you to select the number of sync servers to use to support your files workload. The dominant cost is quantity of data stored.
- Virtual Desktop allows you to select pooled versus dedicated personal resources, and the VM type to support your workload. The cost increases with personal resources and also reflects the VM size you select.
- Bandwidth charges are for data sent out of the Azure environment, such as data sent to on-premises endpoints. Charges can also result from use of Windows Virtual Desktop and other Azure services.

## Next steps

- [What is Azure Files?](/azure/storage/files/storage-files-introduction)
- [What is Azure File Sync?](/azure/storage/file-sync/file-sync-introduction)
- [Azure Storage redundancy](/azure/storage/common/storage-redundancy)
- [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview)
- [What is FSLogix?](/fslogix/overview)
- [What is Azure Virtual Desktop?](/azure/virtual-desktop/overview)
- [Planning for an Azure File Sync deployment](/azure/storage/file-sync/file-sync-planning)

## Related resources

- [Azure Virtual Desktop for the enterprise](../../example-scenario/wvd/windows-virtual-desktop.yml)
- [Hybrid file services](../../hybrid/hybrid-file-services.yml)
- [FSLogix for the enterprise](../wvd/windows-virtual-desktop-fslogix.yml)
- [Azure enterprise cloud file share](../../hybrid/azure-files-private.yml)
- [Using Azure file shares in a hybrid environment](../../hybrid/azure-file-share.yml)
