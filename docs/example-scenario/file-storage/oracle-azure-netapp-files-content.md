The most demanding Oracle Database workloads require very high I/O capacity. They also need low-latency access to storage. This document describes a high-bandwidth, low-latency solution for Oracle Database workloads. It provides shared file access with the network file system (NFS) protocol.

The solution uses Azure NetApp Files, a shared file storage service. Azure NetApp Files provides various benefits:

- Disk I/O limits that apply at the virtual machine (VM) level don't affect Azure NetApp Files. So you can use smaller VMs than you would with disk storage, without degrading performance. As [Pricing][Pricing section of this article] explains later in this article, this approach significantly reduces costs.
- Azure NetApp Files offers flexibility. As [Highly performant systems][Highly performant systems section of this article] discusses later, you can enlarge or reduce deployments on demand to make your configuration cost effective.

## Potential use cases

This solution applies to many use cases:

- Running new Oracle Database instances that require high availability (HA) and have high performance standards.
- Migrating highly performant, highly available Oracle Database instances from on-premises infrastructure to Azure Virtual Machines.
- Enhancing enterprise-scale Oracle Database systems with fast cloning for use in test and development environments. This enhancement can benefit cases that require advanced data management capabilities to meet aggressive data protection service level agreements (SLAs).
- Migrating Exadata systems to Azure.
- Implementing Oracle Pacemaker clusters that use NFS shared storage.
- Deploying SAP AnyDB, or Oracle 19c.

## Architecture

:::image type="complex" source="./media/oracle-azure-netapp-files-architecture.png" alt-text="Architecture diagram showing how Oracle Database and Azure NetApp Files work in different subnets of the same virtual network and use d N F S to communicate." border="false":::
   A large rectangle labeled Oracle resource group fills most of the diagram. Inside it is another rectangle labeled Oracle virtual network. It contains two smaller rectangles, one for the Oracle subnet and one for the Azure NetApp Files subnet. The Oracle subnet rectangle contains an icon for Oracle Database. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled d N F S connects the two subnet rectangles. A colored key indicates that data in the database has a high performance requirement.
:::image-end:::

*Download an [SVG][Main architecture diagram in .svg format] of this architecture.*

The components function and interact in these ways:

- Oracle Database runs on Azure VMs within the Oracle subnet.
- In the Azure NetApp Files subnet, Azure NetApp Files stores the data and log files.
- Oracle Database uses NFS to store and access database files.
- The optimized NFS client [Oracle Direct NFS (dNFS)][Benefits of using Azure NetApp Files with Oracle Database] increases network bandwidth and improves performance.

### Components

The solution uses the following components:

- [Azure NetApp Files][Azure NetApp Files] makes it easy to migrate and run file-based applications with no code change. This shared file-storage service is a joint development from Microsoft and NetApp.
- [Virtual Machines][Azure Virtual Machines] is the infrastructure as a service (IaaS) offer that deploys on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. This solution uses [Linux VMs with Oracle Database software][Oracle VM images and their deployment on Microsoft Azure].
- [Oracle Database][Oracle Database] is a multi-model database management system. It supports all data types and workloads.
- [Azure Virtual Network][Azure Virtual Network] is a networking service that manages virtual private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a datacenter. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of Azure's infrastructure.

## Key benefits

This image shows the benefits of using Azure NetApp Files with Oracle Database.

:::image type="complex" source="./media/oracle-azure-netapp-files-key-values.png" alt-text="Architecture diagram listing features and benefits of Azure NetApp Files. The diagram also shows the different layers of a system that uses this service." border="false":::
   The diagram contains two sections. On the left, four boxes list features and advantages of Azure NetApp Files. The right section also contains boxes. One box is labeled Production, and one is labeled Testing and development at scale. Both contain database and V M icons. A third box is labeled Storage layer. It contains icons for database data and for Azure NetApp Files. A colored key indicates that database data and logs have a high performance requirement. Cloned database data and logs have a medium-high requirement. Copies of clones have a low requirement.
:::image-end:::

*Download an [SVG][Key benefits diagram in .svg format] of this architecture.*

#### Simple and reliable service

As a simple-to-consume Azure native service, Azure NetApp Files runs within the Azure data center environment. You can provision, consume, and scale Azure NetApp Files just like other Azure storage options. Azure NetApp Files uses reliability features that the NetApp data management software ONTAP provides. With this software, you can quickly and reliably provision enterprise-grade NFS volumes for Oracle Database and other enterprise application workloads.

#### Highly performant systems

[Azure NetApp Files][What is Azure NetApp Files] uses a bare-metal fleet of all-flash storage. Besides shared and highly scalable storage, Azure NetApp Files provides latencies of less than 1 millisecond. These factors make this service very well suited for using the NFS protocol to run Oracle Database workloads over networks.

Azure DCsv2-series VMs have built-in high-performance, all-flash ONTAP enterprise systems. These systems are also integrated in the Azure software-defined networking (SDN) and Azure Resource Manager frameworks. As a result, you get high-bandwidth, low-latency shared storage that's comparable to an on-premises solution. The performance of this architecture meets the requirements of the most demanding, business-critical enterprise workloads.

With Azure NetApp Files, you can enlarge or shrink deployments on demand. In contrast, traditional on-premises configurations are sized for maximum workload requirements. Consequently, on-premises configurations are only most cost-effective at maximum utilization. With the scalability of Azure NetApp Files, you can change the configuration continuously and optimize it for the current workload requirement.

As [Pricing][Pricing section of this article] explains, using Azure NetApp Files instead of a block storage solution reduces the SQL Server total cost of ownership (TCO).

#### Enterprise-scale data management

This solution can handle workloads that require advanced data management features. ONTAP provides functionality in this area that's unmatched in the industry:

- Space-efficient cloning enhances development and test environments.
- On-demand capacity and performance scaling makes efficient use of resources.
- Snapshots create frequent database consistency points and provide these benefits:

  - They're storage efficient. You only need limited additional capacity to create snapshots.
  - You can quickly create, replicate, restore, or clone them. As a result, they provide backup and recovery solutions that achieve aggressive recovery time objective (RTO) and recovery point objective (RPO) SLAs.
  - They don't impact volume performance.
  - They provide scalability. You can create them frequently and retain many at a time.

#### Hybrid DR

The combination of Oracle Data Guard (ODG) and Azure NetApp Files provides DR for this architecture. Those DR solutions are appropriate for cloud and hybrid systems. Their plans work across multiple regions and with on-premises data centers. As an alternative, [cross-region replication][Cross-region replication of Azure NetApp Files volumes] can also provide efficient DR across regions in Azure.

## Considerations

The following considerations apply to this solution:

### Availability considerations

For Azure NetApp Files: Check that these points are still relevant for Oracle

- The [SLA for this service][SLA for Azure NetApp Files] guarantees 99.99 percent availability.
- You can [convert existing SMB volumes to use Continuous Availability][Convert existing SMB volumes to use Continuous Availability].

Somehow work in these points:

- Use Oracle hot backup mode and ANF APIs to orchestrate database consistent snapshots for fast backup and recovery.
- Besides backup/restore, the database contents can be replicated to a different region by using Cross Region Replication (CRR), which utilizes storage-based replication, and does not take any VM resources. Using CRR customers can ensure their data is available in a different Azure region to protect them against service interruptions. But check for redundancy with Hybrid DR section.
[CRR]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-create-peering

When you use Oracle Database in Azure, implement an HA and DR solution to avoid downtime:

- Use [ODG][Implement Oracle Data Guard on an Azure Linux virtual machine].
- Run the database on one virtual machine.
- Deploy a secondary VM, but only install the binaries on it.
- Put both VMs in the same virtual network. Then they can access each other over the private persistent IP address.

ODG on Azure Virtual Machines functions like ODG in on-premises systems. But this product relies on its underlying architecture. To increase redundancy and availability when running ODG on Azure VMs, use one of these options:

- Place the Oracle VMs in the same availability set. This approach provides protection during these events:

  - Outages within a data center that equipment failures cause. VMs within an availability set don't share resources.
  - Updates. VMs within an availability set undergo updates at different times.

- Place the Oracle VMs in different availability zones. This approach provides protection against the failure of an entire datacenter. Each zone represents a set of datacenters within a region. If you place resources in different availability zones, datacenter-level outages can't take all your VMs offline.

You can only choose one of these options. An Azure VM cannot participate in availability sets and zones. Each option has advantages:

- Availability zones provide better availability than availability sets. Zones guarantee 99.99 percent availability. Sets guarantee 99.95 percent.
- You can place VMs that are in the same availability set in a [proximity placement group][Proximity placement groups]. This configuration minimizes the network latency between the VMs by guaranteeing that they're close to each other. In contrast, VMs that you place in different availability zones have greater network latency between them. It then takes longer to synchronize data between the primary and secondary replicas. As a result, the primary replica may experience delays. There's also an increased chance of data loss during unplanned failovers.

Test the solution that you choose under load. Ensure that it meets SLAs for performance and availability.

:::image type="complex" source="./media/oracle-azure-netapp-files-availability.png" alt-text="Architecture diagram showing how Oracle Data Guard protects data in a virtual network that includes Azure NetApp Files and Oracle Database." border="false":::
   A large rectangle labeled Oracle resource group fills most of the diagram. Inside it is another rectangle labeled Oracle virtual network. It contains two smaller rectangles, one for the Oracle subnet and one for the Azure NetApp Files subnet. The Oracle subnet rectangle contains icons for Oracle Database and virtual machines. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled d N F S connects the two subnet rectangles. A colored key indicates that log data in the database file system has a high performance requirement. The data files have a medium-to-high performance requirement.
:::image-end:::

*Download an [SVG][Data Guard architecture diagram in .svg format] of this architecture.*

### Scalability considerations

- As [Highly performant systems][Highly performant systems section of this article] discusses, Azure NetApp Files provides built-in scalability.
- With SQL Server on Azure Virtual Machines, you can add or remove VMs when data and compute requirements change. You can also switch to a higher or lower memory-to-vCore ratio. For more information, see [VM size: Performance best practices for SQL Server on Azure VMs][VM size: Performance best practices for SQL Server on Azure VMs - Overview].

### Security considerations

- Azure NetApp Files secures data in many ways. For information about inherent protection, encryption, policy rules, role-based access control features, and activity logs, see [Security FAQs][FAQs About Azure NetApp Files - Security FAQs].
- SQL Server on Azure Virtual Machines also protects data. For information about encryption, access control, vulnerability assessments, security alerts, and other features, see [Security considerations for SQL Server on Azure Virtual Machines][Security considerations for SQL Server on Azure Virtual Machines].

## Deploy the solution

For resources on deploying SQL Server on Azure NetApp Files, see [Solution architectures using Azure NetApp Files][Solution architectures using Azure NetApp Files - SQL Server].

For information on how to deploy and access Azure NetApp Files volumes, see [Azure NetApp Files documentation][Azure NetApp Files documentation].

Also keep these points in mind:

- Consider the database size:

  - For small databases, you can deploy database and log files into a single volume. Such simplified configurations are easy to manage.
  - For large databases, it can be more efficient to configure multiple volumes. You can also use a [manual Quality of Service (QoS) capacity pool][Manual QoS volume quota and throughput]. This type of pool provides more granular control over performance requirements.

- Install SQL Server with SMB fileshare storage. SQL Server 2012 (11.x) and later versions support SMB file server as a storage option. Database engine user databases and system databases like Master, Model, MSDB, and TempDB provide that support. This point applies to SQL Server stand-alone and SQL Server failover cluster installations (FCI). For more information, see [Install SQL Server with SMB fileshare storage][Install SQL Server with SMB fileshare storage].

## Pricing

Cloud resources usually place limits on I/O operations. This practice prevents sudden slowdowns due to resource exhaustion or unexpected outages. As a result, VMs have disk throughput limitations and network bandwidth limitations. The network limitations are typically higher than disk throughput limitations.

With network-attached storage, only network bandwidth limits are relevant, and they only apply to data egress. In other words, VM-level disk I/O limits don't affect Azure NetApp Files. Because of these factors, network-attached storage can achieve better performance than disk I/O. This fact holds up even when Azure NetApp Files runs on smaller VMs.

Smaller VMs offer these pricing advantages over larger ones:

- They're less costly.
- They carry a lower SQL Server license cost.
- The network-attached storage doesn't have an I/O cost component.

These savings outweigh any pricing differences between Azure NetApp Files and disk storage solutions. For a detailed TCO analysis, see [Benefits of using Azure NetApp Files for SQL Server deployment][Benefits of using Azure NetApp Files for SQL Server deployment - Detailed cost analysis].

## Next steps

- For information about setting up a SQL Server VM, see [Quickstart: Create SQL Server 2017 on a Windows virtual machine in the Azure portal].
- To learn how to migrate SQL Server to Azure while retaining application and OS control, see [Migration overview: SQL Server to SQL Server on Azure VMs][Migration overview: SQL Server to SQL Server on Azure VMs].
- For information about SQL Server on Azure NetApp Files, see the [solutions architectures landing page][Solution architectures using Azure NetApp Files - SQL Server].

## Related resources

Fully deployable architectures that use Azure NetApp Files:

- [FSLogix for the enterprise][FSLogix for the enterprise]
- [Run SAP BW/4HANA with Linux virtual machines on Azure][Run SAP BW/4HANA with Linux virtual machines on Azure]
- [Run SAP NetWeaver in Windows on Azure][Run SAP NetWeaver in Windows on Azure]

[Always On availability group on SQL Server on Azure VMs]: /azure/azure-sql/virtual-machines/windows/availability-group-overview
[Availability sets overview]: /azure/virtual-machines/availability-set-overview
[Azure NetApp Files]: https://azure.microsoft.com/services/netapp
[Azure NetApp Files documentation]: /azure/azure-netapp-files
[Azure Virtual Machines]: https://azure.microsoft.com/services/virtual-machines/#overview
[Azure Virtual Network]: https://azure.microsoft.com/services/virtual-network
[Benefits of using Azure NetApp Files for SQL Server deployment - Detailed cost analysis]: /azure/azure-netapp-files/solutions-benefits-azure-netapp-files-sql-server#detailed-cost-analysis
[Benefits of using Azure NetApp Files with Oracle Database]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/solutions-benefits-azure-netapp-files-oracle-database
[Data Guard architecture diagram in .svg format]: ./media/oracle-azure-netapp-files-availability.svg
[Convert existing SMB volumes to use Continuous Availability]: /azure/azure-netapp-files/convert-smb-continuous-availability
[Cross-region replication of Azure NetApp Files volumes]: /azure/azure-netapp-files/cross-region-replication-introduction
[FAQs About Azure NetApp Files - Security FAQs]: /azure/azure-netapp-files/azure-netapp-files-faqs#security-faqs
[FSLogix for the enterprise]: ../wvd/windows-virtual-desktop-fslogix.yml
[Highly performant systems section of this article]: #highly-performant-systems
[Implement Oracle Data Guard on an Azure Linux virtual machine]: https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/configure-oracle-dataguard
[Install SQL Server with SMB fileshare storage]: /sql/database-engine/install-windows/install-sql-server-with-smb-fileshare-as-a-storage-option?view=sql-server-2017
[Key benefits diagram in .svg format]: ./media/oracle-azure-netapp-files-key-values.svg
[Main architecture diagram in .svg format]: ./media/oracle-azure-netapp-files-architecture.svg
[Manual QoS volume quota and throughput]: /azure/azure-netapp-files/azure-netapp-files-performance-considerations#manual-qos-volume-quota-and-throughput
[Migration overview: SQL Server to SQL Server on Azure VMs]: /azure/azure-sql/migration-guides/virtual-machines/sql-server-to-sql-on-azure-vm-migration-overview
[Oracle Database]: https://www.oracle.com/database/
[Oracle VM images and their deployment on Microsoft Azure]: https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-vm-solutions
[Pricing section of this article]: #pricing
[Proximity placement groups]: https://docs.microsoft.com/en-us/azure/virtual-machines/co-location
[Quickstart: Create SQL Server 2017 on a Windows virtual machine in the Azure portal]: /azure/azure-sql/virtual-machines/windows/sql-vm-create-portal-quickstart
[Real-time, high-level reference design]: https://docs.netapp.com/us-en/netapp-solutions/ent-apps-db/sql-srv-anf_reference_design_real-time_high-level_design.html#backup-and-recovery
[Run SAP BW/4HANA with Linux virtual machines on Azure]: ../../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml
[Run SAP NetWeaver in Windows on Azure]: ../../reference-architectures/sap/sap-netweaver.yml
[Security considerations for SQL Server on Azure Virtual Machines]: /azure/azure-sql/virtual-machines/windows/security-considerations-best-practices
[SLA for Azure NetApp Files]: https://azure.microsoft.com/support/legal/sla/netapp/v1_1
[SMB Continuous Availability (CA) shares (Preview)]: /azure/azure-netapp-files/whats-new#march-2021
[Solution architectures using Azure NetApp Files - SQL Server]: /azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server
[VM size: Performance best practices for SQL Server on Azure VMs - Overview]: /azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-vm-size#overview
[What is Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-introduction
[What is SQL Server on Azure Virtual Machines (Windows)]: /azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview
[Windows Server Failover Cluster with SQL Server on Azure VMs]: /azure/azure-sql/virtual-machines/windows/hadr-windows-server-failover-cluster-overview
