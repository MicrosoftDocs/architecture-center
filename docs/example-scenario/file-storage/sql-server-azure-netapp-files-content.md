The most demanding SQL Server database workloads require very high I/O capacity. They also need low-latency access to storage. This document describes a high-bandwidth, low-latency solution for SQL Server workloads. It provides shared file access with the Server Message Block (SMB) protocol.

The solution uses SQL Server on Azure Virtual Machines. It also uses Azure NetApp Files. This shared file storage service provides various benefits:

- With block storage, virtual machines have imposed limits for disk operations. These limits affect I/O capacity and bandwidth. With Azure NetApp Files, only network bandwidth limits are relevant. And they only apply to data egress. In other words, VM-level disk I/O limits don't affect Azure NetApp Files. As a result, SQL Server with Azure NetApp Files can outperform SQL Server that's connected to disk storage, even when the former runs on much smaller VMs.
- Azure NetApp Files offers flexibility. Specifically, you can enlarge or shrink deployments on demand. In contrast, traditional on-premises configurations are sized for maximum workload requirements. Consequently, on-premises configurations are only most cost-effective at maximum utilization. With Azure NetApp Files, you can change the configuration continuously and optimize it for the current workload requirement.

## Potential use cases

This solution applies to many use cases:

- Running new SQL Server instances that require high availability and have high performance standards.
- Migrating highly performant, highly available SQL Server instances from on-premises infrastructure to Azure Virtual Machines.
- Deploying cost-effective, enterprise-scale SQL Server Always On Failover Cluster HA architectures by using Availability Sets and SMB shared storage.
- Deploying enterprise-scale disaster recovery architectures for hybrid or Azure systems by using SQL server Always On Availability Groups.
- Enhancing enterprise-scale SQL Server systems with fast cloning for use in test and development environments. This enhancement can benefit cases that require advanced data management capabilities to meet aggressive data protection SLAs.



## Architecture

:::image type="complex" source="./media/sql-server-azure-net-app-files-architecture.png" alt-text="Architecture diagram showing how information flows through a genomics analysis and reporting pipeline." border="false":::
   The diagram contains two boxes. The first, on the left, has the label Azure Data Factory for orchestration. The second box has the label Clinician views. The first box contains several smaller boxes that represent data or various Azure components. Arrows connect the boxes, and numbered labels on the arrows correspond with the numbered steps in the document text. Two arrows flow between the boxes, ending in the Clinician views box. One arrow points to a clinician icon. The other points to a Power BI icon.
:::image-end:::

The components in the solution function and interact in these ways:

- SQL Server runs on an Azure VM within the SQL subnet.
- In the ANF subnet, Azure NetApp Files stores the database and log files.
- SQL Server accesses database files by using version 3 of Server Message Block (SMB), a network file sharing protocol.
- Azure NetApp Files has the [SMB Continuous Availability shares option][SMB Continuous Availability (CA) shares (Preview)] turned on. This feature makes SMB Transparent Failover possible, so you can do non-disruptive maintenance on Azure NetApp Files.





### Components

The solution uses the following components:

- [Azure NetApp Files][Azure NetApp Files] makes it easy to migrate and run file-based applications with no code change. This shared file-storage service is a joint development from Microsoft and NetApp.
- [Azure Virtual Machines][Azure Virtual Machines] are on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. This solution uses Windows virtual machines.
- [SQL Server on Azure Virtual Machines][What is SQL Server on Azure Virtual Machines (Windows)] provides a way to migrate SQL Server workloads to the cloud with 100 percent code compatibility. As part of the Azure SQL family, SQL Server on Azure Virtual Machines offers the flexibility and hybrid connectivity of Azure. But this database solution also provides the performance, security, and analytics of SQL Server. You can continue to use your current SQL Server version. You can also access the latest SQL Server updates and releases, including SQL Server 2019. This solution uses Windows virtual machines.
- [Azure Virtual Network][Azure Virtual Network] is a networking service that manages virtual private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a datacenter. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of Azure's infrastructure.

## Key benefits

This image highlights the benefits of using SQL Server with Azure NetApp Files.

:::image type="complex" source="./media/sql-server-azure-net-app-files-key-values.png" alt-text="Architecture diagram showing how information flows through a genomics analysis and reporting pipeline." border="false":::
   The diagram contains two boxes. The first, on the left, has the label Azure Data Factory for orchestration. The second box has the label Clinician views. The first box contains several smaller boxes that represent data or various Azure components. Arrows connect the boxes, and numbered labels on the arrows correspond with the numbered steps in the document text. Two arrows flow between the boxes, ending in the Clinician views box. One arrow points to a clinician icon. The other points to a Power BI icon.
:::image-end:::

#### Simple and reliable service

As a simple-to-consume Azure native service, Azure NetApp Files runs within the Azure data center environment. You can provision, consume, and scale Azure NetApp Files just like other Azure storage options. Azure NetApp Files uses reliability features that the NetApp data management software ONTAP provides. With this software, you can quickly and reliably provision enterprise-grade SMB volumes for SQL Server and other workloads.

#### Highly performant systems

[Azure NetApp Files][What is Azure NetApp Files] uses a bare-metal fleet of all-flash storage. Besides shared and highly scalable storage, Azure NetApp Files provides latencies of less than 1 ms. These factors make this service very well suited for using the SMB protocol to run SQL Server workloads over networks. 

Azure DCs and the Azure SDN and ARM frameworks use high-performance, all-flash ONTAP enterprise systems. As a result, you get high-bandwidth, low-latency shared storage that's comparable to an on-premises solution. The performance of this architecture meets the requirements of the most demanding, business-critical enterprise workloads.

#### Enterprise-scale data management

This architecture can also handle workloads that require advanced data management features. ONTAP provides functionality in this area that's unmatched in the industry:

- Snapshots provide a way to create frequent database consistency points. You can use the [NetApp SQL Server Database Quiesce Tool][Real-time, high-level reference design] to take snapshots. They provide these benefits. 

  - They're storage efficient.
  - You can quickly create, replicate, restore, or clone them. As a result, they provide backup and recovery solutions that achieve aggressive recovery time objective (RTO) and recovery point objective (RPO) SLAs.
  - They don't impact volume performance. You only need limited additional capacity to create snapshots.
  - They provide scalability. You can create them frequently and retain many at a time.

- Space-efficient cloning enhances development and test environments.
- On-demand capacity and performance scaling makes efficient use of resources.

#### Hybrid disaster recovery

The combination of Always On Availability Groups (AOAG) and Azure NetApp Files provides disaster recovery (DR) for this architecture. The DR solutions are appropriate for cloud and hybrid systems. The plans work with data centers that are located on-premises and across multiple regions. As an alternative, [cross-region replication][Cross-region replication of Azure NetApp Files volumes] can also provide efficient disaster recovery across regions in Azure.

## Considerations

The following considerations align with the [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework] and apply to this solution:

### Availability considerations

The [service level agreement (SLA) for Azure NetApp Files][SLA for Azure NetApp Files] guarantees 99.99 percent availability.

When using SQL Server databases in Azure, implement a high availability and disaster recovery solution to avoid any downtime:

- Use an [Always On Failover Cluster (AOFC)][Windows Server Failover Cluster with SQL Server on Azure VMs] with two databases on two separate virtual machines.
- Put both virtual machines in the same virtual network. Then they can access each other over the private persistent IP address.
- Place the virtual machines in the same [availability set][Availability sets overview]. Then Azure can place them in separate fault domains and upgrade domains.
- For geo-redundancy:

  - Set up the two databases to replicate between two different regions.
  - Configure [Always On Application Groups (AOAG)][Always On availability group on SQL Server on Azure VMs].

:::image type="complex" source="./media/sql-server-azure-net-app-files-availability.png" alt-text="Architecture diagram showing how information flows through a genomics analysis and reporting pipeline." border="false":::

### Scalability considerations

Most Azure services are scalable by design:


### Security considerations

The technologies in this solution meet most companies' requirements for security.

## Deploy the solution

For general information on implementing this solution, see [Solution architectures using Azure NetApp Files][Solution architectures using Azure NetApp Files - SQL Server].

Also keep these specific points in mind:

- Consider the database size:

  - For small databases, you can deploy database and log files into a single volume. Such simplified configurations are easy to manage.
  - For large databases, it can be more efficient to configure multiple volumes. You can also use a [manual Quality of Service (QoS) capacity pool][Manual QoS volume quota and throughput]. This type of pool provides more granular control over performance requirements.

- Install SQL Server with SMB fileshare storage. SQL Server 2012 (11.x) and later versions support SMB file server as a storage option. Database engine user databases and system databases like Master, Model, MSDB, and TempDB provide that support. This consideration applies to SQL Server stand-alone and SQL Server failover cluster installations (FCI). For more information, see [Install SQL Server with SMB fileshare storage][Install SQL Server with SMB fileshare storage].

## Pricing

Cloud resources usually place limits on I/O operations. This constraint prevents sudden slowdowns due to resource exhaustion or unexpected outages. VMs have disk throughput limitations and network bandwidth limitations. The network limitations are typically higher than disk throughput limitations. Network bandwidth limitations apply to network-attached storage. But disk I/O limitations don't apply. As a result, network-attached storage can achieve better performance than disk I/O.

Because of these factors, smaller VMs can provide similar or better performance than larger ones with this architecture. Smaller VMs offer these advantages over larger ones:

- They're less costly.
- They carry a lower SQL Aerver license cost.
- The network-attached storage doesn't have an I/O cost component.

These savings outweigh any additional cost of using Azure NetApp Files instead of disk storage solutions. For example, consider an environment that uses SQL Server with this configuration:

- 50TiB storage
- 80.000 IOPs
- E64-32s_v3 VMs with 128GB RAM

Suppose Azure NetApp Files runs on E16-4/16s with 128GB RAM. The cost of Azure NetApp Files is then 40 percent of the cost of Ultra SSD and 46 percent of the cost of Premium SSD.

## Next steps

- For information on migrating SQL Server to Azure while retaining application and OS control, see [Migration overview: SQL Server to SQL Server on Azure VMs][Migration overview: SQL Server to SQL Server on Azure VMs].
- For information about SQL Server on Azure NetApp Files, see the [solutions architectures landing page][Solution architectures using Azure NetApp Files - SQL Server].

## Related resources

Fully deployable architectures that use Azure NetApp Files:

- [FSLogix for the enterprise][FSLogix for the enterprise]
- [Run SAP BW/4HANA with Linux virtual machines on Azure][Run SAP BW/4HANA with Linux virtual machines on Azure]
- [Run SAP NetWeaver in Windows on Azure][Run SAP NetWeaver in Windows on Azure]

[Always On availability group on SQL Server on Azure VMs]: https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/availability-group-overview
[Availability sets overview]: https://docs.microsoft.com/en-us/azure/virtual-machines/availability-set-overview
[Azure NetApp Files]: https://azure.microsoft.com/en-us/services/netapp/
[Azure Virtual Machines]: https://azure.microsoft.com/en-us/services/virtual-machines/#overview
[Azure Virtual Network]: https://azure.microsoft.com/en-us/services/virtual-network/
[Cross-region replication of Azure NetApp Files volumes]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-introduction
[FSLogix for the enterprise]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix
[Install SQL Server with SMB fileshare storage]: https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-smb-fileshare-as-a-storage-option?view=sql-server-2017
[Manual QoS volume quota and throughput]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-performance-considerations#manual-qos-volume-quota-and-throughput
[Migration overview: SQL Server to SQL Server on Azure VMs]: https://docs.microsoft.com/en-us/azure/azure-sql/migration-guides/virtual-machines/sql-server-to-sql-on-azure-vm-migration-overview
[Real-time, high-level reference design]: https://docs.netapp.com/us-en/netapp-solutions/ent-apps-db/sql-srv-anf_reference_design_real-time_high-level_design.html#backup-and-recovery
[Run SAP BW/4HANA with Linux virtual machines on Azure]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines
[Run SAP NetWeaver in Windows on Azure]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/sap/sap-netweaver
[SLA for Azure NetApp Files]: https://azure.microsoft.com/en-us/support/legal/sla/netapp/v1_1/
[SMB Continuous Availability (CA) shares (Preview)]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/whats-new#march-2021
[Solution architectures using Azure NetApp Files - SQL Server]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server
[What is Azure NetApp Files]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction
[What is SQL Server on Azure Virtual Machines (Windows)]: https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview
[Windows Server Failover Cluster with SQL Server on Azure VMs]: https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/hadr-windows-server-failover-cluster-overview
