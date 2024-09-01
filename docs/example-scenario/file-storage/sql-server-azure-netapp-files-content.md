The most demanding SQL Server database workloads require very high I/O capacity. They also need low-latency access to storage. This document describes a high-bandwidth, low-latency solution for SQL Server workloads.

The solution provides shared file access with the Server Message Block (SMB) protocol. The architecture uses SQL Server on Azure Virtual Machines. It also uses Azure NetApp Files, a shared file-storage service. Azure NetApp Files provides benefits:

- Disk I/O limits on access rates that apply at the virtual machine (VM) level don't affect Azure NetApp Files. As a result, you can use smaller VMs than you would with disk storage without degrading performance. This approach significantly reduces costs.
- Azure NetApp Files offers flexibility. You can enlarge or reduce deployments on demand to make your configuration cost effective.

## Potential use cases

This solution has many uses:

- Running new SQL Server instances that require high availability (HA) and have high standards for performance.
- Migrating highly performant, highly available SQL Server instances from on-premises infrastructure to Azure Virtual Machines.
- Using availability sets and SMB shared storage to deploy cost-effective, enterprise-scale, highly available SQL Server Always On Failover Cluster Instances.
- Deploying enterprise-scale disaster recovery (DR) architectures for hybrid or Azure systems by using SQL Server Always On availability groups.
- Cloning enterprise-scale SQL Server systems for use in test and development environments. The solution is particularly suited for cases that require advanced data management capabilities. It can help these cases meet aggressive data protection service level agreements (SLAs).

## Architecture

:::image type="complex" source="./media/sql-server-azure-netapp-files-architecture.png" alt-text="Architecture diagram showing how SQL Server and Azure NetApp Files work in different subnets of the same virtual network and use S M B 3 to communicate." border="false":::
   A large rectangle labeled SQL resource group fills most of the diagram. Inside it, another rectangle is labeled SQL virtual network. It contains two smaller, side-by-side rectangles, one for the SQL subnet and one for the Azure NetApp Files subnet. The SQL subnet rectangle contains an icon for SQL Server on Azure Virtual Machines. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled S M B 3 connects the two subnet rectangles. A colored key indicates that SQL data in the database file system requires high performance. The database log files have a medium performance requirement.
:::image-end:::

*Download an [SVG][Main architecture diagram in .svg format] of this architecture.*

### Workflow

The components interact in these ways:

- This architecture uses SQL Server on Azure Virtual Machines. With this Azure service, SQL Server runs on Azure VMs within the SQL subnet.
- In the Azure NetApp Files subnet, Azure NetApp Files provides SMB 3 access to the database and log files.
- Azure NetApp Files has the [SMB continuous availability shares option][SMB Continuous Availability (CA) shares (Preview)] turned on. This feature makes SMB Transparent Failover possible, so you can observe service maintenance events on Azure NetApp Files non-disruptively for your SQL server deployment.

### Components

The solution uses the following components:

- [Azure NetApp Files][Azure NetApp Files] makes it easy to migrate and run file-based applications with no code changes. This shared file-storage service is a joint development from Microsoft and NetApp, a Microsoft partner.
- [Virtual Machines][Azure Virtual Machines] is an infrastructure-as-a-service (IaaS) offer. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. This solution uses Windows VMs.
- [SQL Server on Azure Virtual Machines][What is SQL Server on Azure Virtual Machines (Windows)] provides a way to migrate SQL Server workloads to the cloud with 100 percent code compatibility. As part of the Azure SQL family, this database solution runs SQL Server on VMs. SQL Server on Azure Virtual Machines offers the flexibility and hybrid connectivity of Azure. But this solution also provides the performance, security, and analytics of SQL Server. You can continue to use your current SQL Server version. You can also access the latest SQL Server updates and releases.
- [Azure Virtual Network][Azure Virtual Network] is a networking service that manages virtual private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a datacenter. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of the Azure infrastructure.

### Alternatives

This solution uses Always On availability groups for DR. As an alternative, [cross-region replication][Cross-region replication of Azure NetApp Files volumes] provides efficient DR across regions in Azure. Cross-region replication uses storage-based replication. It doesn't use VM resources. For more information, see [Create volume replication for Azure NetApp Files][Create volume replication for Azure NetApp Files].

## Scenario details

### Key benefits

This image shows the benefits of using SQL Server with Azure NetApp Files.

:::image type="complex" source="./media/sql-server-azure-netapp-files-key-values.png" alt-text="Architecture diagram listing features and benefits of Azure NetApp Files. The diagram also shows the different layers of a system that uses this service." border="false":::
   The diagram contains two sections. On the left, four boxes list features and advantages of Azure NetApp Files. The right contains boxes. One box is labeled Production, and one is labeled Testing and development at scale. Both contain database and V M icons. A third box is labeled Storage layer. It contains icons for database data and for Azure NetApp Files. A colored key indicates that database data and logs require high performance. Cloned database data and logs have a medium-high requirement. Copies of clones have a low requirement, as do all database binaries.
:::image-end:::

*Download an [SVG][Key benefits diagram in .svg format] of this architecture.*

#### Simple and reliable service

As a simple-to-consume Azure native service, Azure NetApp Files runs within the Azure datacenter environment. You can provision, consume, and scale Azure NetApp Files just like other Azure storage options. Azure NetApp Files uses reliability features that the NetApp data management software ONTAP provides. With this software, you can quickly and reliably provision enterprise-grade SMB volumes for SQL Server and other workloads.

#### Highly performant systems

[Azure NetApp Files][What is Azure NetApp Files] uses a bare-metal fleet of all-flash storage. Besides using shared and highly scalable storage, Azure NetApp Files provides latencies of less than 1 millisecond. These factors make this service well suited for using the SMB protocol to run SQL Server workloads over networks.

Azure DCsv2-series VMs have built-in high-performance, all-flash ONTAP enterprise systems. These systems are also integrated in the Azure software-defined networking (SDN) and Azure Resource Manager frameworks. As a result, you get high-bandwidth, low-latency shared storage that's comparable to an on-premises solution. The performance of this architecture meets the requirements of the most demanding, business-critical enterprise workloads.

Azure NetApp Files offers on-demand scalability. You can enlarge or reduce deployments to optimize each workload's configuration.

As [Pricing][Pricing section of this article] explains, using Azure NetApp Files instead of block storage reduces the SQL Server total cost of ownership (TCO).

#### Enterprise-scale data management

This solution can handle workloads that require advanced data management features. ONTAP provides functionality in this area that's unmatched in the industry:

- Space-efficient, instantaneous cloning enhances development and test environments.
- On-demand capacity and performance scaling makes efficient use of resources.
- Snapshots provide database consistency points. You can use the [NetApp SQL Server Database Quiesce Tool][Real-time, high-level reference design] to create application-consistent snapshots. They provide these benefits:

  - They're storage efficient. You only need limited capacity to create snapshots.
  - You can quickly create, replicate, restore, or clone them. As a result, they provide backup and recovery solutions that achieve aggressive recovery time objective (RTO) and recovery point objective (RPO) SLAs.
  - They don't affect volume performance.
  - They provide scalability. You can create them frequently and store many simultaneously.

#### Hybrid DR

The combination of Always On availability groups and Azure NetApp Files provides DR for this architecture. Those DR solutions are appropriate for cloud and hybrid systems. Their plans work across multiple regions and with on-premises datacenters.

## Considerations

The following considerations apply to this solution:

### Availability

For Azure NetApp Files:

- See [SLA for Azure NetApp Files][SLA for Azure NetApp Files] for this service's availability guarantee.
- You can [convert existing SMB volumes to use Continuous Availability][Convert existing SMB volumes to use Continuous Availability].

For SQL Server on Azure Virtual Machines, implement a solution for HA and DR to avoid downtime:

- Use an instance of [Always On Failover Cluster Instances][Windows Server Failover Cluster with SQL Server on Azure VMs] with two databases on two separate VMs.
- Put both VMs in the same virtual network. Then they can access each other over the private persistent IP address.
- Place the VMs in the same [availability set][Availability sets overview]. Then Azure can place them in separate fault domains and upgrade domains.
- For geo-redundancy:

  - Set up the two databases to replicate between two different regions.
  - Configure [Always On availability groups][Always On availability group on SQL Server on Azure VMs].

:::image type="complex" source="./media/sql-server-azure-netapp-files-availability.png" alt-text="Architecture diagram showing how SQL Server Always On Failover Cluster Instances protects data in a virtual network that includes Azure NetApp Files." border="false":::
   A large rectangle labeled SQL resource group fills most of the diagram. Inside it, another rectangle is labeled SQL virtual network. It contains two smaller rectangles, one for a SQL subnet and one for an Azure NetApp Files subnet. The SQL subnet rectangle contains icons for SQL Server on Azure Virtual Machines and SQL Server Always On Failover Cluster Instances. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled S M B 3 connects the two subnet rectangles. A colored key indicates that SQL data in the database file system requires high performance. The database log files have a medium performance requirement.
:::image-end:::

*Download an [SVG][Cluster architecture diagram in .svg format] of this architecture.*

### Scalability

- As [Highly performant systems][Highly performant systems section of this article] discusses, Azure NetApp Files provides built-in scalability.
- With SQL Server on Azure Virtual Machines, you can add or remove VMs when data and compute requirements change. You can also switch to a higher or lower memory-to-vCore ratio. For more information, see [VM size: Performance best practices for SQL Server on Azure VMs][VM size: Performance best practices for SQL Server on Azure VMs - Overview].

### Security

- Azure NetApp Files secures data in many ways. For information about inherent protection, encryption, policy rules, role-based access control features, and activity logs, see [Security FAQs][FAQs About Azure NetApp Files - Security FAQs].
- SQL Server on Azure Virtual Machines also protects data. For information about encryption, access control, vulnerability assessments, security alerts, and other features, see [Security considerations for SQL Server on Azure Virtual Machines][Security considerations for SQL Server on Azure Virtual Machines].

### Cost optimization

Using Azure NetApp Files instead of block storage can reduce costs:

- You can make the configuration cost-efficient. Traditional on-premises configurations are sized for maximum workload requirements. Consequently, these configurations are most cost-effective at maximum usage. In contrast, an Azure NetApp Files deployment is scalable. You can optimize the configuration for the current workload requirement to reduce expenses.

- You can use smaller VMs:

  - Azure NetApp Files provides low-latency storage access. With smaller VMs, you get the same performance that larger VMs deliver with ultra disk storage.
  - Cloud resources usually place limits on I/O operations. This practice prevents sudden slowdowns that resource exhaustion or unexpected outages can cause. As a result, VMs have disk throughput limitations and network bandwidth limitations. The network limitations are typically higher than disk throughput limitations. With network-attached storage, only network bandwidth limits are relevant, and they only apply to data egress. In other words, VM-level disk I/O limits don't affect Azure NetApp Files. Because of these factors, network-attached storage can achieve better performance than disk I/O. This fact is true even when Azure NetApp Files runs on smaller VMs.

  Smaller VMs offer these pricing advantages over larger ones:

  - They cost less.
  - They carry a lower SQL Server license cost.
  - The network-attached storage doesn't have an I/O cost component.

These factors make Azure NetApp Files less costly than disk storage solutions. For a detailed TCO analysis, see [Benefits of using Azure NetApp Files for SQL Server deployment][Benefits of using Azure NetApp Files for SQL Server deployment - Detailed cost analysis].

## Deploy this scenario

- For resources on deploying SQL Server on Azure NetApp Files, see [Solution architectures using Azure NetApp Files][Solution architectures using Azure NetApp Files - SQL Server].

- For information on how to deploy and access Azure NetApp Files volumes, see [Azure NetApp Files documentation][Azure NetApp Files documentation].

- Consider the database size:

  - For small databases, you can deploy database and log files into a single volume. Such simplified configurations are easy to manage.
  - For large databases, it can be more efficient to configure multiple volumes. You can also use a [manual Quality of Service (QoS) capacity pool][Manual QoS volume quota and throughput]. This type provides more granular control over performance requirements.

- Install SQL Server with SMB fileshare storage. SQL Server 2012 (11.x) and later versions support SMB file server as a storage option. Database engine user databases and system databases like Master, Model, MSDB, and TempDB provide that support. This point applies to SQL Server stand-alone and SQL Server failover cluster installations (FCI). For more information, see [Install SQL Server with SMB fileshare storage][Install SQL Server with SMB fileshare storage].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Deanna Garcia](https://www.linkedin.com/in/deanna-garcia-8540912) | Principal Program Manager

## Next steps

- For information about setting up a SQL Server VM, see [Quickstart: Create SQL Server 2017 on a Windows virtual machine in the Azure portal].
- To learn how to migrate SQL Server to Azure while retaining application and OS control, see [Migration overview: SQL Server to SQL Server on Azure VMs][Migration overview: SQL Server to SQL Server on Azure VMs].
- For information about SQL Server on Azure NetApp Files, see the [solutions architectures landing page][Solution architectures using Azure NetApp Files - SQL Server].

## Related resources

Fully deployable architectures that use Azure NetApp Files:

- [Run SAP BW/4HANA with Linux virtual machines on Azure][Run SAP BW/4HANA with Linux virtual machines on Azure]
- [Run SAP NetWeaver in Windows on Azure][Run SAP NetWeaver in Windows on Azure]

[Always On availability group on SQL Server on Azure VMs]: /azure/azure-sql/virtual-machines/windows/availability-group-overview
[Availability sets overview]: /azure/virtual-machines/availability-set-overview
[Azure NetApp Files]: https://azure.microsoft.com/services/netapp
[Azure NetApp Files documentation]: /azure/azure-netapp-files
[Azure Virtual Machines]: https://azure.microsoft.com/services/virtual-machines/#overview
[Azure Virtual Network]: https://azure.microsoft.com/services/virtual-network
[Benefits of using Azure NetApp Files for SQL Server deployment - Detailed cost analysis]: /azure/azure-netapp-files/solutions-benefits-azure-netapp-files-sql-server#detailed-cost-analysis
[Cluster architecture diagram in .svg format]: ./media/sql-server-azure-netapp-files-availability.svg
[Convert existing SMB volumes to use Continuous Availability]: /azure/azure-netapp-files/enable-continuous-availability-existing-smb
[Create volume replication for Azure NetApp Files]: /azure/azure-netapp-files/cross-region-replication-create-peering
[Cross-region replication of Azure NetApp Files volumes]: /azure/azure-netapp-files/cross-region-replication-introduction
[FAQs About Azure NetApp Files - Security FAQs]: /azure/azure-netapp-files/azure-netapp-files-faqs#security-faqs
[Highly performant systems section of this article]: #highly-performant-systems
[Install SQL Server with SMB fileshare storage]: /sql/database-engine/install-windows/install-sql-server-with-smb-fileshare-as-a-storage-option?view=sql-server-2017
[Key benefits diagram in .svg format]: ./media/sql-server-azure-netapp-files-key-values.svg
[Main architecture diagram in .svg format]: ./media/sql-server-azure-netapp-files-architecture.svg
[Manual QoS volume quota and throughput]: /azure/azure-netapp-files/azure-netapp-files-performance-considerations#manual-qos-volume-quota-and-throughput
[Migration overview: SQL Server to SQL Server on Azure VMs]: /azure/azure-sql/migration-guides/virtual-machines/sql-server-to-sql-on-azure-vm-migration-overview
[Pricing section of this article]: #cost-optimization
[Quickstart: Create SQL Server 2017 on a Windows virtual machine in the Azure portal]: /azure/azure-sql/virtual-machines/windows/sql-vm-create-portal-quickstart
[Real-time, high-level reference design]: https://docs.netapp.com/us-en/netapp-solutions/databases/sql-srv-anf_reference_design_real-time_high-level_design.html#backup-and-recovery
[Run SAP BW/4HANA with Linux virtual machines on Azure]: ../../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml
[Run SAP NetWeaver in Windows on Azure]: /azure/architecture/guide/sap/sap-netweaver
[Security considerations for SQL Server on Azure Virtual Machines]: /azure/azure-sql/virtual-machines/windows/security-considerations-best-practices
[SLA for Azure NetApp Files]: https://azure.microsoft.com/support/legal/sla/netapp/v1_1
[SMB Continuous Availability (CA) shares (Preview)]: /azure/azure-netapp-files/whats-new#march-2021
[Solution architectures using Azure NetApp Files - SQL Server]: /azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server
[VM size: Performance best practices for SQL Server on Azure VMs - Overview]: /azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-vm-size#overview
[What is Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-introduction
[What is SQL Server on Azure Virtual Machines (Windows)]: /azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview
[Windows Server Failover Cluster with SQL Server on Azure VMs]: /azure/azure-sql/virtual-machines/windows/hadr-windows-server-failover-cluster-overview