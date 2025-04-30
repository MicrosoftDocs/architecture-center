Azure NetApp Files is an Azure native, first-party, enterprise-class, high-performance file storage service. 

This article describes how SQL Server can be migrated to Azure virtual machines while maintaining the enterprise performance required for OLTP applications. Rather than using Azure disk for the database locations, this article explains how the solution can be deployed more cost-effectively while maintaining the performance you are used to from your on-premises deployments. 

## SQL Server on Azure virtual machines with Azure NetApp Files key value proposition  

The most demanding SQL Server database workloads require very high I/O, low latency access to storage. Azure offers very low latency, high bandwidth shared file access via SMB with [Azure NetApp Files](/azure/azure-sql/virtual-machines/windows/availability-group-overview). Azure VMs impose limits on I/O and bandwidth operations on managed disk, while only network bandwidth limits are applied against Azure NetApp Files on egress only. In other words, no VM-level storage I/O limits are applied to Azure NetApp Files.

Without these I/O limits, SQL Server running on smaller virtual machines connected to Azure NetApp Files can perform as well as or oftentimes better than SQL Server running on much larger VMs using disk storage. And with the flexibility that Azure NetApp Files offers, deployments can be grown or shrunk on demand, unlike traditional on-premises configurations which are sized for the maximum workload requirement and are most cost-effective only at maximum utilization. In Azure with Azure NetApp Files, the configuration can be adjusted continually to the momentary workload requirement.

[Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) is designed to meet the core requirements of running high-performance workloads like databases in the cloud. Azure NetApp Files provides:

- Total cost of ownership (TCO) savings compared to disk configurations
- Enterprise performance with low latency

    Enterprise class, very low latency (<1ms), shared and highly scalable storage, very well suited for running your SQL Server workloads over the network using the SMB protocol 
- High availability

    [Standard SLA 99.99%](https://azure.microsoft.com/support/legal/sla/netapp/) 
- Advanced data management

    - Fast and efficient primary data protection and recovery using application-consistent snapshots (with AzAcSnap or SnapCenter), to achieve the most aggressive RTO and RPO SLAs.  

    - Integrated backup as an extension to snapshots for longer term retention and safe-keeping on alternate media. 

    - Time-efficient clones to enhance Dev/Test environments. 

The result is an ideal database storage technology that is provisioned, consumed, and scaled just like other Azure storage options. See [Azure NetApp Files documentation](/azure/azure-netapp-files/azure-netapp-files-create-volumes-smb) for more information on how to deploy and access Azure NetApp Files volumes.  

## SQL Server with Azure NetApp Files key value proposition

<!-- replace long description -->
:::image type="complex" source="./media/value-proposition.png" alt-text="Diagram outlining the benefits of using SQL Server with Azure NetApp Files." border="false":::
   A large rectangle labeled SQL resource group fills most of the diagram. Inside it, another rectangle is labeled SQL virtual network. It contains two smaller, side-by-side rectangles, one for the SQL subnet and one for the Azure NetApp Files subnet. The SQL subnet rectangle contains an icon for SQL Server on Azure Virtual Machines. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled S M B 3 connects the two subnet rectangles. A colored key indicates that SQL data in the database file system requires high performance. The database log files have a medium performance requirement.
:::image-end:::

All components (database files, log) can be deployed into a single volume to start with. Such simplified configurations are easy to manage and are suitable for smaller databases sizes with low transaction activity. 

For larger and more demanding databases, it's more efficient to configure multiple volumes and use a [manual Quality of Service (QoS) capacity pool](/azure/azure-netapp-files/azure-netapp-files-understand-storage-hierarchy#manual-qos-type), as this allows for more [granular control over performance requirements](/azure/azure-sql/virtual-machines/windows/sql-vm-create-portal-quickstart).

### Key benefits of SQL Server with Azure NetApp Files 

* **Simple & reliable** 

    Azure NetApp Files is built as a simple-to-consume 1P Azure storage service powered by ONTAP®. This enables customers to quickly and reliably provision enterprise-grade SMB volumes for their SQL Server and NFS volumes for other enterprise application workloads. 

* **Highly performant**

    Azure NetApp Files is powered by All-Flash ONTAP enterprise storage systems fully integrated with Azure SDN and ARM frameworks. Customers can enjoy on-premises-like high-I/O and low-latency scalable shared storage for demanding workloads. Using SQL Server with Azure NetApp Files' low latency storage, smaller VM configurations achieve equal or better performance levels, often more cost-efficient than larger VMs using ultra disk storage. Find performance and TCO information here. 

* **Enterprise data management**

    Azure NetApp Files targets the most demanding, mission-critical applications and workloads with key requirements that typically require advanced data management capabilities. ONTAP’s capabilities in this space are unmatched, offering time- and space-efficient snapshots and cloning, on-demand capacity and performance scaling, and efficient replication. Azure NetApp Files offers the same capabilities as a first-party platform service in Azure.

* **Hybrid disaster recovery**

  Many customers are deep into their journeys into the cloud or are maintaining a hybrid operating model for the foreseeable future. By combining Always On Availability Groups (AOAG) with Azure NetApp Files with either on-premises or across regions, you can easily build hybrid and disaster recovery solutions. Alternatively you can leverage [cross-region replication](/azure/azure-netapp-files/cross-region-replication-introduction) for efficient disaster recovery across regions in Azure. 

## Potential use cases 

This solution applies to many use cases including but not limited to: 

- Migrate existing SQL Server instances requiring high performance and high availability from on-premises to Azure on Azure Virtual Machines (VMs) without re-architecting 
- Deploy cost-effective, enterprise-scale SQL Server Always On Failover Cluster high-availability (HA) architectures using Availability Sets and [Azure NetApp Files Continuous availability volume support](/azure/azure-netapp-files/enable-continuous-availability-existing-smb).
- Deploy enterprise-scale, hybrid, or in-Azure disaster recovery architectures using SQL Server Always On Availability Groups.
- Enhance enterprise SQL Server environments which require advanced data management like fast cloning for test and development and aggressive data protection SLAs. 

## Architecture 

SQL Server can be deployed in Azure on Azure VMs making use of Azure NetApp Files to store the database and log files via SMB. It's highly recommended to enable Azure NetApp Files' [SMB continuous availability shares](/azure/azure-netapp-files/enable-continuous-availability-existing-smb) to ensure SMB transparent failover, which allows for nondisruptive maintenance on the Azure NetApp Files service. You can [enable](/azure/azure-netapp-files/enable-continuous-availability-existing-smb#steps) existing SMB volumes to use Continuous Availability.  

<!-- replace long description -->
:::image type="complex" source="./media/continuous-availability.png" alt-text="Architecture diagram displaying a SQL Server deployment with Azure NetApp Files." border="false":::
   A large rectangle labeled SQL resource group fills most of the diagram. Inside it, another rectangle is labeled SQL virtual network. It contains two smaller, side-by-side rectangles, one for the SQL subnet and one for the Azure NetApp Files subnet. The SQL subnet rectangle contains an icon for SQL Server on Azure Virtual Machines. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled S M B 3 connects the two subnet rectangles. A colored key indicates that SQL data in the database file system requires high performance. The database log files have a medium performance requirement.
:::image-end:::

## High availability and disaster recovery considerations 

When using SQL Server databases in Azure, you are responsible for implementing a high availability and disaster recovery solution to avoid any downtime. 

<!-- replace long description -->
:::image type="complex" source="./media/high-availability.png" alt-text="Architecture diagram displaying a SQL Server deployment with Azure NetApp Files." border="false":::
   A large rectangle labeled SQL resource group fills most of the diagram. Inside it, another rectangle is labeled SQL virtual network. It contains two smaller, side-by-side rectangles, one for the SQL subnet and one for the Azure NetApp Files subnet. The SQL subnet rectangle contains an icon for SQL Server on Azure Virtual Machines. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled S M B 3 connects the two subnet rectangles. A colored key indicates that SQL data in the database file system requires high performance. The database log files have a medium performance requirement.
:::image-end:::

High availability and disaster recovery for SQL Server can be achieved on Azure using [Always On Failover Cluster (AOFC)](/azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server), with two databases on two separate virtual machines. Both VMs should be in the same virtual network to ensure they can access each other over the private persistent IP address. It's recommended to place the virtual machines in the same [availability set](/azure/virtual-machines/availability-set-overview) to allow Azure to place them into separate fault and upgrade domains. For geo-redundancy, set up the two databases to replicate between two different regions and configure [Always On Application Groups (AOAG)](https://www.youtube.com/watch?v=y3VQmzzeyvc).

Install SQL Server with SMB fileshare storage 

Starting with SQL Server 2012 (11.x), system databases (Master, Model, MSDB, and TempDB), and Database Engine user databases can be installed with Server Message Block (SMB) file server as a storage option. This applies to both SQL Server stand-alone and SQL Server failover cluster installations (FCI). [Learn how to nstall SQL Server with SMB fileshare storage](/sql/database-engine/install-windows/install-sql-server-with-smb-fileshare-as-a-storage-option?view=sql-server-2017).

<!-- link doesn't work -->
More detailed information on how to deploy SQL Server on Azure NetApp Files can be found [here.]()


Data Protection 

Azure NetApp Files includes the capability to create space-efficient and fast snapshots. Azure NetApp Files snapshots bring the following benefits: 

- Snapshots are ***storage efficient.***
- Snapshots are ***quick to create, replicate, restore from and clone.***
- Snapshots have no impact on ***volume performance***.
- Snapshots ***provide scalability because*** they can be created frequently, and many can be retained.

<!-- rewrite -->
For SQL Server, you can use snapshots to create frequent database consistency points using these snapshots at limited additional capacity which can be restored and cloned very quickly. This solution improves data protection SLAs and test/development currency.  

To create application consistent database snapshots, you can use [SnapCenter](https://docs.netapp.com/us-en/snapcenter/protect-scsql/reference_back_up_sql_server_database_or_instance_or_availability_group.html).  

## Components 

- [Azure Windows-based VM](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) supported by desired SQL Server version 
- [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction)
- [SnapCenter](https://docs.netapp.com/us-en/snapcenter/protect-scsql/reference_back_up_sql_server_database_or_instance_or_availability_group.html)

## Alternatives 

<!-- rewrite -->
Other Azure solutions exist for providing storage for SQL Server on Azure VMs. When considering your options, consider the advantages that space-efficient snapshots bring and how these snapshots can be used for primary data protection of your SQL database and how these snapshots can be backed up to an Azure storage account using [SnapCenter](https://www.netapp.com/cyber-resilience/data-protection/snapcenter/), which comes at no extra charge when used with Azure NetApp Files. It completes a full data protection and availability strategy. 

## Considerations (pillars)  

<!-- rewrite to architecture pillars -->

- Scalability considerations 
    Azure NetApp Files volumes can be expanded or shrunk without interruption to the database, which allows for flexibility for both growth and cost reduction where applicable, without having to shutdown and restart the database.
- Availability considerations 
    Azure NetApp Files has a high SLA (99.99%) which can be improved for the highest levels of availability by using cross-zone replication in combination with [Always On availability group](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server?view=sql-server-ver16).
- Security considerations 
    You can rely on [secure data plane concepts](/azure/azure-netapp-files/data-plane-security) with configurable role based permissions at the share and file level. Data is encrypted in transit and at rest 
- Resiliency considerations 
    The Azure NetApp Files service provides a [high SLA of 99.99%](https://azure.microsoft.com/support/legal/sla/netapp/) and is designed to handle hardware failures effectively.  

## Deploy the solution or see it in action

Consult the Azure Architecture Center for [SQL server on Azure NetApp Files architectures](/azure/architecture/browse/?terms=sql%20smb%20netapp) for details on how to deploy SQL server on Azure VMs with Azure NetApp Files. 

## Pricing 

Cloud resources are generally IO constrained by design to prevent slowdowns from resource exhaustion or outages. VM SKUs have limits on disk IOPs/throughput and network bandwidth, with network limits usually higher than disk limits. Network-attached storage, limited by network bandwidth rather than disk IO, can perform better than disk IO.  

These factors combined allow for the use of smaller sized VMs at similar or better performance characteristics.  

Smaller VM sizes: 

- are less costly 
- carry lower SQL Server license cost 
- network attached storage does not have an IO cost component 

These factors far outweigh any cost delta of using Azure NetApp Files compared to disk storage solutions.  

For example, the following table compares total cost of a 50TiB SQL Server configuration, where the requirement is 80.000 IOPs, running on E64-32s_v3 VMs with 128GB RAM on Ultra and Premium SSD to E16-4/16s with 128GB RAM on Azure NetApp Files: 

<!-- replace long text -->
:::image type="complex" source="./media/cost-comparison.png" alt-text="Table comparing ultra and premium solid-state drives costs with Azure NetApp Files. " border="false":::
   A large rectangle labeled SQL resource group fills most of the diagram. Inside it, another rectangle is labeled SQL virtual network. It contains two smaller, side-by-side rectangles, one for the SQL subnet and one for the Azure NetApp Files subnet. The SQL subnet rectangle contains an icon for SQL Server on Azure Virtual Machines. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled S M B 3 connects the two subnet rectangles. A colored key indicates that SQL data in the database file system requires high performance. The database log files have a medium performance requirement.
:::image-end:::
 
For a more detailed analysis of TCO, see [Solutions and benefits of Azure NetApp Files with SQL Server](
/azure/azure-netapp-files/solutions-benefits-azure-netapp-files-sql-server).

## Next steps 

With this knowledge in hand, your next step is to deploy your first [SQL database on Azure with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/sql-server-azure-netapp-files).

## Related resources 

- [Migration overview: SQL Server to SQL Server on Azure VMs](h/azure/azure-sql/virtual-machines/windows/hadr-windows-server-failover-cluster-overview?view=azuresql)
- [Azure NetApp Files solution architectures](/azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server)