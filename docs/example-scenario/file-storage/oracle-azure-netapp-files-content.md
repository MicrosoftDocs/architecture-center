The most demanding Oracle Database workloads require substantial I/O capacity. They also need low-latency access to storage. This document describes a scalable, high-bandwidth, low-latency solution for running Oracle Database workloads on Azure virtual machines (VMs) with shared file access via the network file system (NFS) protocol. The architecture uses Azure NetApp Files, a first-party Azure shared file-storage service.

## Benefits 

Azure NetApp Files offers the following benefits:

- Flexibility: You can enlarge or reduce capacity and throughput on demand to align your configuration to the actual business needs without interruption to the service.
- Scalability: Use multiple storage volumes and add volumes on the fly to expand both capacity and throughput as needed
- Availability: Volumes are built on highly available fault-tolerant bare-metal fleet powered by ONTAP with built-in replication capabilities for business continuity and disaster recovery.
- Consolidation: Run multiple smaller database instances on an Azure VM while maintaining isolation of the database and log files over multiple storage volumes.
- Data protection: Space-efficient snapshot copies provide application-consistent point in time copies of live databases, and snapshot copies can be backed up by Azure NetApp Files backup or third-party solutions as desired.
- Cloning: Snapshots can be cloned to provide current data copies to test and development.
- Storage throughput: Networked storage is subjected to higher throughput limits than managed disk. As a result, you can use smaller VM SKUs than you would with managed disk storage without degrading performance. This approach could significantly reduce costs.

## Potential use cases

This solution has many uses:

- Running new Oracle Database instances that require high availability (HA) and have high standards for performance.
- Migrating highly performant, highly available Oracle Database instances from on-premises to Azure Virtual Machines.
- Migrating Oracle Exadata systems to Azure.
- Consolidating multiple small Oracle instances onto a single Azure VM with one or more storage volumes for individual isolation and management.
- Cloning enterprise-scale Oracle Database systems for use in test and development environments. The solution is particularly suited for cases that require advanced data management capabilities. It can help meet aggressive data protection service level agreements (SLAs) by utilizing fast and space-efficient snapshots.
- Implementing Oracle Pacemaker clusters that use NFS shared storage.
- Deploying SAP AnyDB, or Oracle 19c.

## Architecture

You can run a small-to-medium sized Oracle database on an Azure VM with one or more storage volumes for storing the database files, redo logs, and optionally a backup volume.

:::image type="complex" source="./media/capacity-pool-architecture.png" alt-text="Diagram depicting Oracle VMs deployed on Azure NetApp Files." lightbox="./media/capacity-pool-architecture.png" border="false":::
    A diagram of an Azure NetApp Files deployment. A rectangle with a dashed blue line surrounds all contents in the image, denoting 'Availability zone one' inside of an Azure region. Inside the dashed rectangle are two smaller, stacked rectangles with dotted blue lines. The top rectangle denotes a virtual machine (VM) subnet with an Oracle VM. A line connects the Oracle VM to a diagram of an Azure NetApp Files delegated subnet. The Azure NetApp Files delegated subnet has a yellow rectangle describing a capacity pool, which contains a smaller blue rectangle for the Oracle application volume group, inside of which are the individual volumes connected to the Oracle VM.
:::image-end:::

Deploy multiple data volumes for consolidating multiple smaller Oracle instances onto a single Azure VM.

:::image type="complex" source="./media/small-oracle-deployment.png" alt-text="Diagram of consolidated Oracle databases on an Azure VM." lightbox="./media/small-oracle-deployment.png"  border="false":::
    A diagram of an Azure NetApp Files deployment. A rectangle with a dashed blue line surrounds all contents in the image, denoting 'Availability zone one' inside of an Azure region. Inside the dashed rectangle are two smaller, stacked rectangles with dotted blue lines. The top rectangle denotes a virtual machine (VM) subnet with an Oracle VM. A line connects the Oracle VM to a diagram of an Azure NetApp Files delegated subnet. The Azure NetApp Files delegated subnet has a yellow rectangle describing a capacity pool, which contains a smaller blue rectangle for the Oracle application volume group, inside of which are the individual volumes connected to the Oracle VM. The different data and log volumes are represented inside of the application volume group.
:::image-end:::

### Preparing the Azure NetApp Files service

Create an Azure NetApp Files capacity pool of the desired capacity and service level. Check the [Quickstart for setting up Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-quickstart-set-up-account-create-volumes).

If you're migrating existing Oracle databases from on-premises to Azure, you can utilize AWR reports to obtain current throughput statistics which you need for sizing the Azure NetApp Files capacity pool and volumes. Recommendations for pool and volumes sizing can be obtained by processing [AWR reports through the Atroposs service](https://app.atroposs.com/#/awr-module). For more information about how to use the service, contact your Oracle on Azure specialist.

Available throughput for the volumes in a capacity pool is defined by the size and [service level (Standard, Premium, or Ultra)](/azure/azure-netapp-files/azure-netapp-files-service-levels) of the selected capacity pool. Auto QoS capacity pools assign throughput to volumes directly related to the volume size. You can also assign throughput to volumes independently of their size, for which you can configure your capacity pool to use [manual QoS](/azure/azure-netapp-files/manage-manual-qos-capacity-pool).

### Data protection

To protect against unlikely zonal failures make use of Oracle Data Guard to replicate database files and redo logs to an alternate zone in the region.

:::image type="complex" source="./media/oracle-replication-diagram.png" alt-text="Diagram of replicated Oracle workload." lightbox="./media/oracle-replication-diagram.png" border="false":::
    Two rectangles with dashed blue lines delineate a set of virtual machines (VMs); each rectangle denotes a different availability zone in the same Azure region. Within each availability zone, there is a virtual machine subnet hosting an Oracle VM. The Oracle VMs have delegated subnets for Azure NetApp Files that host a manual quality of service capacity pool, denoted by a solid color yellow rectangle stretching between the delegated subnet in each availability zone. The capacity pools house the different Oracle volume deployments.
:::image-end:::

### Scalability

By using multiple storage volumes for database files, you can achieve additional scalability and flexibility. You can scale up to eight volumes for database files by using [application volume group for Oracle](/azure/azure-netapp-files/application-volume-group-oracle-introduction) to deploy the volumes. This approach helps place volumes in optimal locations within the Azure infrastructure for low-latency access by the VMs.

:::image type="complex" source="./media/application-volume-group-deployment.png" alt-text="Diagram of application volume group for Oracle deployment." lightbox="./media/application-volume-group-deployment.png" border="false":::
  Two rectangles with dashed blue lines delineate a set of virtual machines (VMs); each rectangle denotes a different availability zone in the same Azure region. Within each availability zone, there is a virtual machine subnet hosting an Oracle VM. The Oracle VMs have delegated subnets for Azure NetApp Files that host a manual quality of service capacity pool, denoted by a solid color yellow rectangle stretching between the delegated subnet in each availability zone. The capacity pools house the different Oracle volume deployments.
:::image-end:::

### Components

The solution uses the following components:

- [Azure NetApp Files][Azure NetApp Files] is a first-party Azure file storage system that enables migrating and running file-based applications in Azure without code changes. It's developed by Microsoft and NetApp, a Microsoft partner.
- [Virtual Machines][Azure Virtual Machines] is an infrastructure-as-a-service (IaaS) offer. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. This solution uses [Linux VMs with Oracle Database software][Oracle VM images and their deployment on Microsoft Azure].
- [Azure Virtual Network][Azure Virtual Network] is a networking service that manages virtual private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a datacenter. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of the Azure infrastructure.
- [Oracle Database][Oracle Database] is a multi-model database management system. It supports various data types and workloads.
  - The [dNFS][About Direct NFS Client Mounts to NFS Storage Devices] client optimizes I/O paths between Oracle and NFS servers. As a result, it provides better performance than traditional NFS clients.

### Alternatives

This solution uses Oracle Data Guard (ODG) for disaster recovery (DR), and snapshots for local replication. A few options exist, as the following sections explain.

#### Cross-region replication

[Cross-region replication][Cross-region replication of Azure NetApp Files volumes] provides efficient DR across regions in Azure. Cross-region replication uses storage-based replication. It doesn't use VM resources. For more information, see [Create volume replication for Azure NetApp Files][Create volume replication for Azure NetApp Files].

#### Cross-zone replication

Cross-zone replication provides efficient HA across zones in Azure. Cross-zone replication uses the same highly efficient block-based replication with a minimum update interval of 10 minutes. This can be used to replicate the database files, while the redo log is replicated with Oracle Data Guard. For more information, see [Cross-zone replication of Azure NetApp Files volumes](/azure/azure-netapp-files/cross-zone-replication-introduction).

#### Availability sets and availability zones

ODG on Azure Virtual Machines functions like ODG in on-premises systems. But this product relies on its underlying architecture. If you run ODG on Azure VMs, consider also using one of these options to increase redundancy and availability:

- Place the Oracle VMs in the same availability set. This approach provides protection during these events:

  - Outages that equipment failures cause within a datacenter. VMs within an availability set don't share resources.
  - Updates. VMs within an availability set undergo updates at different times.

- Place the Oracle VMs in different availability zones. This approach provides protection against the failure of an entire datacenter. Each zone represents a set of datacenters within a region. If you place resources in different availability zones, datacenter-level outages can't take all your VMs offline.

You can only choose one of these options. An Azure VM can't participate in availability sets and zones at the same time. Each option has advantages:

- Availability zones provide better availability than availability sets. See [SLA for Virtual Machines][SLA for Virtual Machines] for a comparison.
- You can place VMs that are in the same availability set in a [proximity placement group][Proximity placement groups]. This configuration minimizes the network latency between the VMs by guaranteeing that they're close to each other. In contrast, VMs that you place in different availability zones have greater network latency between them. It then takes longer to synchronize data between the primary and secondary replicas. As a result, the primary replica might experience delays. There's also an increased chance of data loss during unplanned failovers.

After you choose a solution, test it under load. Ensure that it meets SLAs for performance and availability.

## Key benefits

This image shows the benefits of using Azure NetApp Files with Oracle Database.

:::image type="complex" source="./media/oracle-azure-netapp-files-key-values.png" alt-text="Architecture diagram listing features and benefits of Azure NetApp Files. The diagram also shows the different layers of a system that uses this service." lightbox="./media/oracle-azure-netapp-files-key-values.png" border="false":::
   The diagram contains two sections. On the left, four boxes list features and advantages of Azure NetApp Files. The right section also contains boxes. One box is labeled Production, and one is labeled Testing and development at scale. Both contain database and V M icons. A third box is labeled Storage layer. It contains icons for database data and for Azure NetApp Files. A colored key indicates that database data and logs require high performance. Cloned database data and logs have a medium-high requirement. Copies of clones have a low requirement.
:::image-end:::

### Hosted service

As an Azure native service, Azure NetApp Files runs within the Azure datacenter environment. You can provision, consume, and scale Azure NetApp Files just like other Azure storage options. Azure NetApp Files uses reliability features that the NetApp data management software ONTAP provides. With this software, you can provision enterprise-grade NFS volumes for Oracle Database and other enterprise application workloads.

### Low-latency performance

[Azure NetApp Files][What is Azure NetApp Files] uses a bare-metal fleet of all-flash storage. Besides using shared and highly scalable storage, Azure NetApp Files provides latencies of less than 1 millisecond. These factors make this service well-suited for using the NFS protocol to run Oracle Database workloads over networks.

The Azure DCsv2-series VMs can use high-performance, all-flash NetApp storage systems. These systems are also integrated into the Azure software-defined networking (SDN) and Azure Resource Manager frameworks. As a result, you get high-bandwidth, low-latency shared storage that's comparable to an on-premises solution. The performance of this architecture meets the requirements of the most demanding, business-critical enterprise workloads. For more information on the performance benefits of Azure NetApp Files, see [Benefits of using Azure NetApp Files with Oracle Database][Benefits of using Azure NetApp Files with Oracle Database].

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

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

For Azure NetApp Files:

- See [SLA for Azure NetApp Files][SLA for Azure NetApp Files] for this service's availability guarantee.
- As [Enterprise-scale data management][Enterprise-scale data management section of this article] discusses, you can use snapshots in backup and recovery solutions. Use Oracle hot backup mode and Azure NetApp Files APIs to orchestrate database-consistent snapshots.

When you use Oracle Database in Azure, implement a solution for HA and DR to avoid downtime:

- Use [ODG][Implement Oracle Data Guard on an Azure Linux virtual machine].
- Run the database on one virtual machine.
- Deploy a secondary VM, but only install the binaries on it.
- Put both VMs in the same virtual network. Then they can access each other over the private persistent IP address.

:::image type="complex" source="./media/oracle-azure-netapp-files-availability.png" alt-text="Architecture diagram showing how Oracle Data Guard protects data in a virtual network that includes Azure NetApp Files and Oracle Database." lightbox="./media/oracle-azure-netapp-files-availability.png" border="false":::
   A large rectangle labeled Oracle resource group fills most of the diagram. Inside it, another rectangle is labeled Oracle virtual network. It contains two smaller rectangles, one for the Oracle subnet and one for the Azure NetApp Files subnet. The Oracle subnet rectangle contains icons for Oracle Database and virtual machines. The Azure NetApp Files subnet rectangle contains icons for Azure NetApp Files and database files. An arrow labeled d N F S connects the two subnet rectangles. A colored key indicates that log data in the database file system requires high performance. The data files have a medium-to-high performance requirement.
:::image-end:::

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Azure NetApp Files secures data in many ways. For information about inherent protection, encryption, policy rules, role-based access control features, and activity logs, see [Security FAQs][FAQs About Azure NetApp Files - Security FAQs].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

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

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

As the [Low-latency performance][Low-latency performance section of this article] section discusses, Azure NetApp Files provides built-in scalability.

## Deploy this scenario

- For resources on deploying Oracle Database on Azure VMs with Azure NetApp Files, see [Solution architectures using Azure NetApp Files][Solution architectures using Azure NetApp Files - Oracle].

- For information on how to deploy and access Azure NetApp Files volumes, see [Azure NetApp Files documentation][Azure NetApp Files documentation].

- Consider the database size:

  - For small databases, you can deploy all components, such as data files, the redo log, the archive log, and control files, into a single volume. Such simplified configurations are easy to manage.
  - For large databases, it's more efficient to configure multiple volumes. You can use [automatic or manual Quality of Service (QoS) volumes][Performance considerations for Azure NetApp Files]. These volume types provide more granular control over performance requirements.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Deanna Garcia](https://www.linkedin.com/in/deanna-garcia-8540912) | Principal Program Manager
- [Arnt de Gier](https://www.linkedin.com/in/arntdegier/) | Technical Marketing Engineer for Azure NetApp Files

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
[Azure NetApp Files]: /azure/well-architected/service-guides/azure-netapp-files
[Azure NetApp Files documentation]: /azure/azure-netapp-files
[Azure NetApp Files performance benchmarks for Linux]: /azure/azure-netapp-files/performance-benchmarks-linux
[Azure Virtual Machines]: /azure/well-architected/service-guides/virtual-machines
[Azure Virtual Network]: /azure/well-architected/service-guides/virtual-network
[Benefits of using Azure NetApp Files with Oracle Database]: /azure/azure-netapp-files/solutions-benefits-azure-netapp-files-oracle-database
[Capacity management FAQs]: /azure/azure-netapp-files/azure-netapp-files-faqs#capacity-management-faqs
[Create volume replication for Azure NetApp Files]: /azure/azure-netapp-files/cross-region-replication-create-peering
[Cross-region replication of Azure NetApp Files volumes]: /azure/azure-netapp-files/cross-region-replication-introduction
[Enterprise-scale data management section of this article]: #enterprise-scale-data-management
[FAQs About Azure NetApp Files - Security FAQs]: /azure/azure-netapp-files/azure-netapp-files-faqs#security-faqs
[Low-latency performance section of this article]: #low-latency-performance
[Implement Oracle Data Guard on an Azure Linux virtual machine]: /azure/virtual-machines/workloads/oracle/configure-oracle-dataguard
[Linux NFS mount options best practices for Azure NetApp Files]: /azure/azure-netapp-files/performance-linux-mount-options
[Oracle Database]: /azure/well-architected/oracle-iaas/get-started
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
