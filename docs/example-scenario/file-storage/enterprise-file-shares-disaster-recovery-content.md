This architecture provides file shares that fail over automatically to a backup region in case of failure. The failover is transparent to the clients and applications that access the shares. The shares can be used for applications and virtual desktops that must be resilient to disruption, whether planned or unplanned.

Azure NetApp Files provides the file shares. Its cross-region replication capability replicates the shares from the primary region to the secondary. Distributed File System (DFS) Namespaces in Windows Server can group shared folders on different servers into one or more logically structured namespaces.

## Potential use cases

This architecture applies to businesses that want to provide file shares for clients or applications that must be resilient to unplanned outages or service maintenance events. Some examples are:

- Service Message Block (SMB) protocol file shares for desktop environments.
- SMB file shares for applications.

## Architecture

:::image type="content" source="media/enterprise-file-shares-disaster-recovery.png" alt-text="Architecture for file shares with automatic failover." lightbox="media/enterprise-file-shares-disaster-recovery.png" border="false" :::

*Download a [Visio file](https://arch-center.azureedge.net/US-1888816-enterprise-file-shares-disaster-recovery.vsdx) of this architecture.*

- There are two Azure regions, a primary and a secondary.
- The Azure subscription includes a virtual network and an Azure NetApp Files account for each region.
- The  cross-region replication feature of Azure NetApp Files replicates the files and folders from the primary region to the secondary region. This technique doesn't need virtual machines.
- DFS Namespaces manages access to the file shares, a feature of Windows Server. You can think of it as Domain Name Server (DNS) for file shares.
- The Windows servers and Active Directory Domain servers can be hosted on Azure or on-premises.

### Components

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) provides enterprise-grade Azure file shares that are powered by NetApp. Azure NetApp Files makes it easy for enterprises to migrate and run complex file-based applications with no code changes. It also provides a way to replicate data asynchronously from an Azure NetApp Files volume in one region to an Azure NetApp Files volume in another region. This capability provides data protection during region-wide outages or disasters. For more information, see [Cross-region replication of Azure NetApp Files volumes](/azure/azure-netapp-files/cross-region-replication-introduction).
- DFS Namespaces is a role service in Windows Server that can group shared folders that are located on different servers into one or more logically structured namespaces. For more information, see [DFS Namespaces overview](/windows-server/storage/dfs-namespaces/dfs-overview).

### Alternatives

- Instead of Azure NetApp Files, you can use a Windows Server Scale-Out File Server cluster with custom replication of the file shares across regions. For more information, see [Scale-Out File Server for application data overview](/windows-server/failover-clustering/sofs-overview).
- Instead of Azure NetApp Files cross-region replication, you can use Azure File Sync to transform Windows Server into a quick cache of your Azure file shares. This might be appropriate for smaller file shares. For more information, see [Deploy Azure File Sync](/azure/storage/file-sync/file-sync-deployment-guide).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Replicating to a second region increases availability by protecting against regional service interruptions.

- This solution has more recovery options than a single-region deployment due to having failover capabilities.
- The secondary volume is read-only. It can be verified at any given time, increasing reliability.
- You can run a disaster recovery test in isolation without interfering with the production deployment. The test uses the space-efficient volume clone feature to get a read/write copy of a volume in seconds.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of the solution depends on the size of the volume that's replicated, the rate of change, and the destination tier of the Azure NetApp Files capacity pool. For more information, see [Azure NetApp Files pricing](https://azure.microsoft.com/pricing/details/netapp) or use the Azure [Pricing calculator](https://azure.microsoft.com/pricing/calculator).

See [Cost model for cross-region replication](/azure/azure-netapp-files/cross-region-replication-introduction#cost-model-for-cross-region-replication) for more examples.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Azure NetApp Files comes with three performance tiers: Standard, Premium, and Ultra. Cross-region replication can replicate between different tiers. When the primary region uses the Premium or Ultra tier, you can replicate to a lower tier, for example Standard. In case of a failover, you can then upgrade the tier of the secondary as required.
- The replication of the data is performed at the incremental block level—only changed data blocks are transferred—which minimizes data transfer.

This solution can be used for file shares ranging from 4 tebibytes (TiB) to a total volume of 12.5 pebibytes (PiB) on a single Azure NetApp Files account.

### Deploy this scenario

To deploy on Azure, perform the following configuration tasks in the Windows Server DFS namespace:

1. Deploy the primary Azure NetApp Files account.
1. Create an SMB volume on the primary.
1. Deploy the secondary Azure NetApp Files account.
1. Replicate the volume to the secondary Azure NetApp Files account.
1. Configure DFS Namespaces to point to the primary volume.

In case of a failover:

1. Fail over the volumes of Azure NetApp Files.
1. Change the targets in DFS Namespaces.

These tasks can be and should be automated.

See [Disaster Recovery for Enterprise File Shares](https://techcommunity.microsoft.com/t5/azure-architecture-blog/disaster-recovery-for-enterprise-file-shares/ba-p/2808757) for a step-by-step deployment guide.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Max Melcher](https://de.linkedin.com/in/maxmelcher) | Cloud Solution Architect

## Next steps

- [Register for NetApp Resource Provider](/azure/azure-netapp-files/azure-netapp-files-register)
- [Create a NetApp account](/azure/azure-netapp-files/azure-netapp-files-create-netapp-account)
- [Quickstart: Set up Azure NetApp Files and create an NFS volume](/azure/azure-netapp-files/azure-netapp-files-quickstart-set-up-account-create-volumes?tabs=azure-portal)
- [Disaster Recovery for Enterprise File Shares](https://techcommunity.microsoft.com/t5/azure-architecture-blog/disaster-recovery-for-enterprise-file-shares/ba-p/2808757)

## Related resources

- [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services)
