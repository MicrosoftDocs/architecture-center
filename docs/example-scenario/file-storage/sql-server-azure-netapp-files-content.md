Azure NetApp Files is an Azure native, first-party, enterprise-class, high-performance file storage service.

This article describes how SQL Server can be migrated to Azure Virtual Machines while maintaining the enterprise performance required for online transaction processing (OLTP) applications. Rather than using Azure disk for the database locations, this article explains how the solution can be deployed more cost-effectively while maintaining the performance you're used to from your on-premises deployments.

## Architecture

:::image type="complex" source="./media/continuous-availability.png" alt-text="Architecture diagram displaying a SQL Server deployment with Azure NetApp Files." border="false":::
   A large rectangle representing an Azure region surrounds the whole diagram. Inside the region, there's another rectangle representing availability zone one. Availability zone one contains the Azure NetApp Files delegated subnet and the virtual machine (VM) subnet, the latter of which contains the SQL Server VM. The SQL Server VM connects to the Azure NetApp Files capacity pool that contains four volumes: SQL data 1, SQL data 2, SQL logs, and SQL backup.
:::image-end:::

### Workflow

Beginning SQL Server 2012 (11.x), system databases (Master, Model, MSDB, and TempDB), and Database Engine user databases can be installed with Server Message Block (SMB) file server as a storage option. This applies to both SQL Server stand-alone and SQL Server failover cluster installations (FCI). Learn [how to Install SQL Server with SMB fileshare storage](/sql/database-engine/install-windows/install-sql-server-with-smb-fileshare-as-a-storage-option?view=sql-server-2017) or [how to deploy SQL Server on Azure NetApp Files](/azure/azure-netapp-files/#sql-server).

SQL Server can be deployed in Azure on Azure virtual machines (VMs) making use of Azure NetApp Files to store the database and log files via SMB. It's highly recommended to enable Azure NetApp Files' [SMB continuous availability shares](/azure/azure-netapp-files/enable-continuous-availability-existing-smb) to ensure SMB transparent failover, which allows for nondisruptive maintenance on the Azure NetApp Files service. You can [enable](/azure/azure-netapp-files/enable-continuous-availability-existing-smb#steps) existing SMB volumes to use Continuous Availability.

You can also deploy a high availability workflow. 

:::image type="complex" source="./media/continuous-availability.png" alt-text="Architecture diagram displaying a SQL Server deployment with Azure NetApp Files." border="false":::
   A large rectangle representing an Azure region surrounds the whole diagram. Inside the region, there's another rectangle representing availability zone one. Availability zone one contains the Azure NetApp Files delegated subnet and the VM subnet, the latter of which contains the SQL Server VM. The SQL Server VM connects to the Azure NetApp Files capacity pool that contains four volumes: SQL data 1, SQL data 2, SQL logs, and SQL backup.
:::image-end:::

High availability and disaster recovery for SQL Server can be achieved on Azure using [Always On Failover Cluster (AOFC)](/azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server), with two databases on two separate VMs. Both VMs should be in the same virtual network to ensure they can access each other over the private persistent IP address. It's recommended to place the VMs in the same [availability set](/azure/virtual-machines/availability-set-overview) to allow Azure to place them into separate fault and upgrade domains. For geo-redundancy, set up the two databases to replicate between two different regions and configure [Always On Application Groups (AOAG)](https://www.youtube.com/watch?v=y3VQmzzeyvc).

### Components

* [Azure Windows-based VM](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) supported by desired SQL Server version
* [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction)
* [SnapCenter](https://learn.netapp.com/snapcenter/protect-scsql/reference_back_up_sql_server_database_or_instance_or_availability_group.html#how-snapcenter-backs-up-databases)

### Alternatives

Other Azure solutions exist for providing storage for SQL Server on Azure VMs. When considering your options, take into account the advantages that space-efficient snapshots bring and how these snapshots can be used for primary data protection of your SQL database and how these snapshots can be backed up to an Azure storage account using [SnapCenter](https://www.netapp.com/cyber-resilience/data-protection/snapcenter/) which comes at no extra charge when used with Azure NetApp Files. It completes a full data protection and availability strategy.

## Scenario details

The most demanding SQL Server database workloads require high I/O and low latency access to storage. Azure offers low latency, high bandwidth shared file access via SMB with Azure NetApp Files. Azure VMs impose limits on I/O and bandwidth operations on managed disk, while only network bandwidth limits are applied against Azure NetApp Files—and on egress only. In other words, no VM level storage I/O limits are applied to Azure NetApp Files.

Without these I/O limits, SQL Server running on smaller VMs connected to Azure NetApp Files can perform as well as or better than SQL Server running on much larger VMs using disk storage. And with the flexibility that Azure NetApp Files offers, deployments can be grown or shrunk on demand, unlike traditional on-premises configurations, which are sized for the maximum workload requirement and are most cost-effective only at maximum utilization. In Azure with Azure NetApp Files, the configuration can be adjusted continually to the momentary workload requirement.

Azure NetApp Files was designed to meet the core requirements of running high-performance workloads like databases in the cloud, and provides:
* Lower TCO savings compared to disk configurations
* Enterprise performance with low latency
* High availability
* Advanced data management

:::image type="complex" source="./media/value-proposition.png" alt-text="Diagram outlining the benefits of using SQL Server with Azure NetApp Files." border="false":::
	A diagram is split in two halves. The right half shows the architecture of SQL Server on Azure NetApp Files, showing the storage layer of Azure NetApp Files and separate layers for production (compute and database) and testing and development.
	The left half of the diagram outlines benefits of running SQL Server on Azure NetApp Files: it's simple to manage, high-performance, space and time-efficient, and offers hybrid & disaster recovery.
:::image-end:::

All components (database files, log) can be deployed into a single volume to start with. Such simplified configurations are easy to manage and are suitable for smaller database sizes with low transaction activity.

For larger and more demanding databases it's more efficient to configure multiple volumes and use a [manual Quality of Service (QoS) capacity pool](/azure/azure-netapp-files/azure-netapp-files-understand-storage-hierarchy#manual-qos-type), which allows for [more granular control over performance requirements](/azure/azure-sql/virtual-machines/windows/sql-vm-create-portal-quickstart).

* **Simple & reliable**
	Azure NetApp Files is built as a simple-to-consume first-party Azure storage service powered by ONTAP. This enables you to quickly and reliably provision enterprise-grade SMB volumes for SQL Server and NFS volumes for other enterprise application workloads.
* **Highly performant**
	Azure NetApp Files is powered by All-Flash ONTAP enterprise storage systems fully integrated with Azure SDN and ARM frameworks. You can enjoy on-premises-like high-IO/low-latency scalable shared storage for demanding workloads. Using SQL Server with Azure NetApp Files' low latency storage, smaller VM configurations achieve equal or better performance levels, often more cost-efficient than larger VMs using ultra disk storage. Find performance and TCO information here.
* **Enterprise data management**
	This service is targeting the most demanding, mission-critical applications and workloads with key requirements that typically require advanced data management capabilities. ONTAP’s capabilities in this space—time- and space-efficient snapshots and cloning, on-demand capacity and performance scaling, efficient replication—are unmatched in the industry. Azure NetApp Files offers the same capabilities as a first-party platform service in Azure.
* **Hybrid & disaster recovery**
	By combining Always On Availability Groups with Azure NetApp Files with either on-premises or across regions, you can easily build hybrid and disaster recovery solutions. Alternatively, you can leverage [cross-region replication](/azure/azure-netapp-files/cross-region-replication-introduction) for efficient disaster recovery across regions in Azure.

### Potential use cases

This solution applies to many use cases including but not limited to:
* Migrate existing SQL Server instances requiring high performance and high availability from on-premises to Azure on Azure VMs without rearchitecting.
* Deploy cost-effective, enterprise-scale SQL Server Always On Failover Cluster high availability architectures using Availability Sets and [Azure NetApp Files Continuous availability volume support](/azure/azure-netapp-files/enable-continuous-availability-existing-smb).
* Deploy enterprise-scale, hybrid or in-Azure disaster recovery architectures using SQL Server Always On Availability Groups.
* Enhance enterprise SQL Server environments which require advanced data management like fast cloning for test and development and aggressive data protection SLAs.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

* **High availability**

	The Azure NetApp Files service provides a high SLA of 99.99% and is designed to handle hardware failures effectively. The 99.99% SLA can be improved for the highest levels of availability by using cross-zone replication in combination with [Always On availability group](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server?view=sql-server-ver16).

### Security 

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

* **Role-based access, encryption at-rest and in-flight**
	You can rely on [secure data plane concepts](/azure/azure-netapp-files/data-plane-security) with configurable role-based permissions at the share and file level. Data is encrypted in transit and at rest.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

* **Lower VM size**

	Network-attached storage, limited by network bandwidth rather than disk I/O, can perform better than disk I/O. This is due to the ingrained constraint of cloud resources and the fact that VM SKUs generally have higher network limits than disk limits. This solution supports smaller VM sizes with better performance. Smaller VMs are less costly and carry lower SQL Service license costs, while network attached storage doesn't have an I/O cost factor. 

	Consider the following table, which compares total cost of a 50-TiB SQL Server configuration, where the requirement is 80,000 I/OPs, running on E64-32s_v3 VMs. This configuration is compared to 128 GB RAM on Ultra and Premium SSD to E16-4/16s with 128 GB RAM on Azure NetApp Files:

	:::image type="complex" source="./media/cost-comparison.png" alt-text="Table comparing ultra and premium solid-state drives costs with Azure NetApp Files. " border="false":::
   A four-column table shows a TCO comparison for a 50-TiB SQL Server deployment across an Ultra SSD, Premium SSD, and Azure NetApp Files. In the first row, the bandwidth cost of the Ultra SSD is $704. There's no cost for the Premium SSD or Azure NetApp Files. The next row shows I/O cost, which is $3,971 for the Ultra SSD. There's no cost for the Premium SSD or Azure NetApp Files. The next row shows capacity cost: $6,130 for Ultra SSD, $6,442 for Premium SSD, and $7,680 for Azure NetApp Files. The next row shows SQL Server license cost: $17,520 for Ultra SSD, $17,520 for Premium SSD, and $4,380 for Azure NetApp Files. The next row shows instance cost: $4,882 for Ultra SSD, $4,882 for Premium SSD, and $1,221 for Azure NetApp Files. The final row shows total cost: $33,207 for Ultra SSD, $28,844 for Premium SSD, and $13,281 for Azure NetApp Files.
	:::image-end:::
 
### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

* **Scalability** 
	Azure NetApp Files volumes can be expanded or contracted without interruption to the database. The flexibility supports both growth and cost reduction, without having to shutdown and restart the database.

## Deploy this scenario

Refer to the Azure Architecture Center for [SQL server on Azure NetApp Files architectures](/azure/architecture/browse/?terms=sql%20smb%20netapp) for details on how to deploy SQL server on Azure VMs with Azure NetApp Files.

See [Azure NetApp Files documentation](/azure/azure-netapp-files/azure-netapp-files-create-volumes-smb) for more information on how to deploy and access Azure NetApp Files volumes. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Arnt de Gier](https://www.linkedin.com/in/arntdegier) | Technical Marketing Engineer

## Next steps

With this knowledge in hand, your next step is to deploy your first [SQL database on Azure with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/sql-server-azure-netapp-files).

## Related resources

- [Benefits of using Azure NetApp Files for SQL Server deployment](/azure/azure-netapp-files/solutions-benefits-azure-netapp-files-sql-server)
- [Migration overview: SQL Server to SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/hadr-windows-server-failover-cluster-overview?view=azuresql)
- [Azure NetApp Files solution architectures: SQL Server](/azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server)

