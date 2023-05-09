The most demanding Oracle Database workloads require very high I/O capacity. They also need low-latency access to storage. This document describes a high-bandwidth, low-latency solution for Oracle Database workloads.

The solution provides shared file access with the network file system (NFS) protocol. The architecture uses Azure NetApp Files, a shared file-storage service. Azure NetApp Files offers benefits:

* Disk I/O limits on access rates that apply at the virtual machine (VM) level don't affect Azure NetApp Files. As a result, you can use smaller VMs than you would with disk storage without degrading performance. This approach significantly reduces costs.
* Azure NetApp Files offers flexibility. You can enlarge or reduce deployments on demand to make your configuration cost effective.

## Potential use cases

This solution has many uses:

- Running new Oracle Database instances that require high availability (HA) and have high standards for performance.
- Migrating highly performant, highly available Oracle Database instances from on-premises infrastructure to Azure Virtual Machines.
- Cloning enterprise-scale Oracle Database systems for use in test and development environments. The solution is particularly suited for cases that require advanced data management capabilities. It can help these cases meet aggressive data protection service level agreements (SLAs).
- Migrating Oracle Exadata systems to Azure.
- Implementing Oracle Pacemaker clusters that use NFS shared storage.
- Deploying SAP AnyDB, or Oracle 19c.

## Architecture

:::image type="complex" source="./media/oracle-azure-netapp-files-architecture.png" alt-text="Architecture diagram showing how Oracle Database and Azure NetApp Files work in different subnets of the same virtual network and use d N F S to communicate." border="false":::
   A large rectangle labeled Oracle resource group fills most of the diagram. Inside it, another rectangle is labeled Oracle virtual network. It contains two smaller, side-by-side rectangles, one for the Oracle subnet and one for the Azure NetApp Files subnet. The Oracle subnet rectangle contains an icon for Oracle Database on a Linux V M. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled d N F S connects the two subnet rectangles. A colored key indicates that data in the database requires high performance.
:::image-end:::

*Download an [SVG][Main architecture diagram in .svg format] of this architecture.*

The components interact in these ways:

- Oracle Database runs on Azure VMs within the Oracle subnet.
- In the Azure NetApp Files subnet, Azure NetApp Files provides NFS access to the data and log files.
- The connection protocol [Oracle Direct NFS (dNFS)][Benefits of using Azure NetApp Files with Oracle Database] improves performance and throughput.

### Components

The solution uses the following components:

- [Azure NetApp Files][Azure NetApp Files] makes it easy to migrate and run file-based applications with no code changes. This shared file-storage service is a joint development from Microsoft and NetApp, a Microsoft partner.
- [Virtual Machines][Azure Virtual Machines] is an infrastructure-as-a-service (IaaS) offer. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. This solution uses [Linux VMs with Oracle Database software][Oracle VM images and their deployment on Microsoft Azure].
- [Azure Virtual Network][Azure Virtual Network] is a networking service that manages virtual private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a datacenter. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of the Azure infrastructure.
- [Oracle Database][Oracle Database] is a multi-model database management system. It supports various data types and workloads.
- The [dNFS][About Direct NFS Client Mounts to NFS Storage Devices] client optimizes I/O paths between Oracle and NFS servers. As a result, it provides better performance than traditional NFS clients.

### Alternatives

This solution uses Oracle Data Guard (ODG) for disaster recovery (DR), and snapshots for local replication. A few options exist, as the following sections explain.

#### Cross-region replication

[Cross-region replication][Cross-region replication of Azure NetApp Files volumes] provides efficient DR across regions in Azure. Cross-region replication uses storage-based replication. It doesn't use VM resources. For more information, see [Create volume replication for Azure NetApp Files][Create volume replication for Azure NetApp Files].

#### Availability sets and availability zones

ODG on Azure Virtual Machines functions like ODG in on-premises systems. But this product relies on its underlying architecture. If you run ODG on Azure VMs, consider also using one of these options to increase redundancy and availability:

- Place the Oracle VMs in the same availability set. This approach provides protection during these events:

  - Outages that equipment failures cause within a datacenter. VMs within an availability set don't share resources.
  - Updates. VMs within an availability set undergo updates at different times.

- Place the Oracle VMs in different availability zones. This approach provides protection against the failure of an entire datacenter. Each zone represents a set of datacenters within a region. If you place resources in different availability zones, datacenter-level outages can't take all your VMs offline.

You can only choose one of these options. An Azure VM can't participate in availability sets and zones at the same time. Each option has advantages:

- Availability zones provide better availability than availability sets. See [SLA for Virtual Machines][SLA for Virtual Machines] for a comparison.
- You can place VMs that are in the same availability set in a [proximity placement group][Proximity placement groups]. This configuration minimizes the network latency between the VMs by guaranteeing that they're close to each other. In contrast, VMs that you place in different availability zones have greater network latency between them. It then takes longer to synchronize data between the primary and secondary replicas. As a result, the primary replica may experience delays. There's also an increased chance of data loss during unplanned failovers.

After you choose a solution, test it under load. Ensure that it meets SLAs for performance and availability.

## Key benefits

This image shows the benefits of using Azure NetApp Files with Oracle Database.

:::image type="complex" source="./media/oracle-azure-netapp-files-key-values.png" alt-text="Architecture diagram listing features and benefits of Azure NetApp Files. The diagram also shows the different layers of a system that uses this service." border="false":::
   The diagram contains two sections. On the left, four boxes list features and advantages of Azure NetApp Files. The right section also contains boxes. One box is labeled Production, and one is labeled Testing and development at scale. Both contain database and V M icons. A third box is labeled Storage layer. It contains icons for database data and for Azure NetApp Files. A colored key indicates that database data and logs require high performance. Cloned database data and logs have a medium-high requirement. Copies of clones have a low requirement.
:::image-end:::

*Download an [SVG][Key benefits diagram in .svg format] of this architecture.*

### Simple and reliable service

As a simple-to-consume Azure native service, Azure NetApp Files runs within the Azure datacenter environment. You can provision, consume, and scale Azure NetApp Files just like other Azure storage options. Azure NetApp Files uses reliability features that the NetApp data management software ONTAP provides. With this software, you can quickly and reliably provision enterprise-grade NFS volumes for Oracle Database and other enterprise application workloads.

### Highly performant systems

[Azure NetApp Files][What is Azure NetApp Files] uses a bare-metal fleet of all-flash storage. Besides using shared and highly scalable storage, Azure NetApp Files provides latencies of less than 1 millisecond. These factors make this service well suited for using the NFS protocol to run Oracle Database workloads over networks.

Azure DCsv2-series VMs have built-in high-performance, all-flash ONTAP enterprise systems. These systems are also integrated in the Azure software-defined networking (SDN) and Azure Resource Manager frameworks. As a result, you get high-bandwidth, low-latency shared storage that's comparable to an on-premises solution. The performance of this architecture meets the requirements of the most demanding, business-critical enterprise workloads. For more information on the performance benefits of Azure NetApp Files, see [Benefits of using Azure NetApp Files with Oracle Database][Benefits of using Azure NetApp Files with Oracle Database].

Azure NetApp Files offers on-demand scalability. You can enlarge or reduce deployments to optimize each workload's configuration.

### Enterprise-scale data management

This solution can handle workloads that require advanced data management features. ONTAP provides functionality in this area that's unmatched in the industry:

- Space-efficient, instantaneous cloning enhances development and test environments.
- On-demand capacity and performance scaling makes efficient use of resources.
- Snapshots provide database consistency points and offer these benefits:

  - They're storage efficient. You only need limited capacity to create snapshots.
  - You can quickly create, replicate, restore, or clone them. As a result, they provide backup and recovery solutions that achieve aggressive recovery time objective (RTO) and recovery point objective (RPO) SLAs.
  - They don't affect volume performance.
  - They provide scalability. You can create them frequently and store many simultaneously.

### Hybrid DR

The combination of ODG and Azure NetApp Files provides DR for this architecture. Those DR solutions are appropriate for cloud and hybrid systems. Their plans work across multiple regions and with on-premises datacenters.

## Considerations

The following considerations apply to this solution:

### Availability

For Azure NetApp Files:

- See [SLA for Azure NetApp Files][SLA for Azure NetApp Files] for this service's availability guarantee.
- As [Enterprise-scale data management][Enterprise-scale data management section of this article] discusses, you can use snapshots in backup and recovery solutions. Use Oracle hot backup mode and Azure NetApp Files APIs to orchestrate database-consistent snapshots.

When you use Oracle Database in Azure, implement a solution for HA and DR to avoid downtime:

- Use [ODG][Implement Oracle Data Guard on an Azure Linux virtual machine].
- Run the database on one virtual machine.
- Deploy a secondary VM, but only install the binaries on it.
- Put both VMs in the same virtual network. Then they can access each other over the private persistent IP address.

:::image type="complex" source="./media/oracle-azure-netapp-files-availability.png" alt-text="Architecture diagram showing how Oracle Data Guard protects data in a virtual network that includes Azure NetApp Files and Oracle Database." border="false":::
   A large rectangle labeled Oracle resource group fills most of the diagram. Inside it, another rectangle is labeled Oracle virtual network. It contains two smaller rectangles, one for the Oracle subnet and one for the Azure NetApp Files subnet. The Oracle subnet rectangle contains icons for Oracle Database and virtual machines. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled d N F S connects the two subnet rectangles. A colored key indicates that log data in the database file system requires high performance. The data files have a medium-to-high performance requirement.
:::image-end:::

*Download an [SVG][Data Guard architecture diagram in .svg format] of this architecture.*

### Scalability

As [Highly performant systems][Highly performant systems section of this article] discusses, Azure NetApp Files provides built-in scalability.

### Security

Azure NetApp Files secures data in many ways. For information about inherent protection, encryption, policy rules, role-based access control features, and activity logs, see [Security FAQs][FAQs About Azure NetApp Files - Security FAQs].

## Cost optimization

Using Azure NetApp Files instead of block storage can reduce costs:

- You can make the configuration cost-efficient. Traditional on-premises configurations are sized for maximum workload requirements. Consequently, these configurations are most cost-effective at maximum usage. In contrast, an Azure NetApp Files deployment is scalable. You can optimize the configuration for the current workload requirement to reduce expenses.

- You can use smaller VMs:

  - Azure NetApp Files provides low-latency storage access. With smaller VMs, you get the same performance that larger VMs deliver with ultra disk storage.
  - Cloud resources usually place limits on I/O operations. This practice prevents sudden slowdowns that resource exhaustion or unexpected outages can cause. As a result, VMs have disk throughput limitations and network bandwidth limitations. The network limitations are typically higher than disk throughput limitations. With network-attached storage, only network bandwidth limits are relevant, and they only apply to data egress. In other words, VM-level disk I/O limits don't affect Azure NetApp Files. Because of these factors, network-attached storage can achieve better performance than disk I/O. This fact is true even when Azure NetApp Files runs on smaller VMs.

  Smaller VMs offer these pricing advantages over larger ones:

  - They cost less.
  - They carry a lower Oracle Database license cost, especially when you use smaller, constrained-code SKUs.
  - The network-attached storage doesn't have an I/O cost component.

These factors make Azure NetApp Files less costly than disk storage solutions.

## Deploy this scenario

- For resources on deploying Oracle Database on Azure VMs with Azure NetApp Files, see [Solution architectures using Azure NetApp Files][Solution architectures using Azure NetApp Files - Oracle].

- For information on how to deploy and access Azure NetApp Files volumes, see [Azure NetApp Files documentation][Azure NetApp Files documentation].

- Consider the database size:

  - For small databases, you can deploy all components, such as data files, the redo log, the archive log, and control files, into a single volume. Such simplified configurations are easy to manage.
  - For large databases, it's more efficient to configure multiple volumes. You can use [automatic or manual Quality of Service (QoS) volumes][Performance considerations for Azure NetApp Files]. These volume types provide more granular control over performance requirements.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Deanna Garcia](https://www.linkedin.com/in/deanna-garcia-8540912) | Principal Program Manager

## Next steps

- [Oracle database performance on Azure NetApp Files single volumes][Oracle database performance on Azure NetApp Files single volumes]
- [Linux NFS mount options best practices for Azure NetApp Files][Linux NFS mount options best practices for Azure NetApp Files]
- [Azure NetApp Files performance benchmarks for Linux][Azure NetApp Files performance benchmarks for Linux]
- [Capacity management FAQs][Capacity management FAQs]

## Related resources

Fully deployable architectures that use Azure NetApp Files:

- [Run SAP BW/4HANA with Linux virtual machines on Azure][Run SAP BW/4HANA with Linux virtual machines on Azure]
- [Run SAP NetWeaver in Windows on Azure][Run SAP NetWeaver in Windows on Azure]

[About Direct NFS Client Mounts to NFS Storage Devices]: https://docs.oracle.com/en/database/oracle/oracle-database/19/ssdbi/about-direct-nfs-client-mounts-to-nfs-storage-devices.html
[Azure NetApp Files]: https://azure.microsoft.com/services/netapp
[Azure NetApp Files documentation]: /azure/azure-netapp-files
[Azure NetApp Files performance benchmarks for Linux]: /azure/azure-netapp-files/performance-benchmarks-linux
[Azure Virtual Machines]: https://azure.microsoft.com/services/virtual-machines/#overview
[Azure Virtual Network]: https://azure.microsoft.com/services/virtual-network
[Benefits of using Azure NetApp Files with Oracle Database]: /azure/azure-netapp-files/solutions-benefits-azure-netapp-files-oracle-database
[Data Guard architecture diagram in .svg format]: ./media/oracle-azure-netapp-files-availability.svg
[Capacity management FAQs]: /azure/azure-netapp-files/azure-netapp-files-faqs#capacity-management-faqs
[Create volume replication for Azure NetApp Files]: /azure/azure-netapp-files/cross-region-replication-create-peering
[Cross-region replication of Azure NetApp Files volumes]: /azure/azure-netapp-files/cross-region-replication-introduction
[Enterprise-scale data management section of this article]: #enterprise-scale-data-management
[FAQs About Azure NetApp Files - Security FAQs]: /azure/azure-netapp-files/azure-netapp-files-faqs#security-faqs
[Highly performant systems section of this article]: #highly-performant-systems
[Implement Oracle Data Guard on an Azure Linux virtual machine]: /azure/virtual-machines/workloads/oracle/configure-oracle-dataguard
[Key benefits diagram in .svg format]: ./media/oracle-azure-netapp-files-key-values.svg
[Linux NFS mount options best practices for Azure NetApp Files]: /azure/azure-netapp-files/performance-linux-mount-options
[Main architecture diagram in .svg format]: ./media/oracle-azure-netapp-files-architecture.svg
[Oracle Database]: https://www.oracle.com/database/
[Oracle database performance on Azure NetApp Files single volumes]: /azure/azure-netapp-files/performance-oracle-single-volumes
[Oracle VM images and their deployment on Microsoft Azure]: /azure/virtual-machines/workloads/oracle/oracle-vm-solutions
[Performance considerations for Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-performance-considerations
[Proximity placement groups]: /azure/virtual-machines/co-location
[Run SAP BW/4HANA with Linux virtual machines on Azure]: ../../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml
[Run SAP NetWeaver in Windows on Azure]: /azure/architecture/guide/sap/sap-netweaver
[SLA for Azure NetApp Files]: https://azure.microsoft.com/support/legal/sla/netapp/v1_1
[SLA for Virtual Machines]: https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/
[Solution architectures using Azure NetApp Files - Oracle]: /azure/azure-netapp-files/azure-netapp-files-solution-architectures#oracle
[What is Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-introduction