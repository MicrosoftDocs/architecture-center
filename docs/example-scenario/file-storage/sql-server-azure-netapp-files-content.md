The most demanding SQL Server database workloads require very high I/O capacity. They also need low-latency access to storage. This document describes a high-bandwidth, low-latency solution for SQL Server workloads. It provides shared file access with the Server Message Block (SMB) protocol.

The solution uses SQL Server on Azure Virtual Machines. It also uses Azure NetApp Files. This shared file storage service provides various benefits:

- With block storage, virtual machines have imposed limits for disk operations. These limits affect I/O capacity and bandwidth. With Azure NetApp Files, only network bandwidth limits are relevant. And they only apply to data egress. In other words, VM-level disk I/O limits don't affect Azure NetApp Files. As a result, SQL Server with Azure NetApp Files can outperform SQL Server that's connected to disk storage, even when the former runs on much smaller VMs.
- Azure NetApp Files offers flexibility. Specifically, you can enlarge or shrink deployments on demand. In contrast, traditional on-premises configurations are sized for maximum workload requirements. Consequently, on-premises configurations are only most cost-effective at maximum utilization. With Azure NetApp Files, you can change the configuration continuously and optimize it for the current workload requirement.

## Potential use cases

This solution applies to many areas:



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

Intro sentence

### Azure NetApp Files key value proposition

[Azure NetApp Files][What is Azure NetApp Files] meets the core requirements of running high-performance workloads like databases in the cloud. This service uses a bare metal fleet of all-flash storage. It provides various benefits:

- Enterprise-class performance. Azure NetApp Files offers shared and highly scalable storage along with very low latencies of less than 1 ms. This combination makes the service very well suited for using the SMB protocol to run SQL Server workloads over the network.
- High availability. The [service level agreement (SLA) for Azure NetApp Files][SLA for Azure NetApp Files] guarantees 99.99 percent availability.
- Advanced data management. Snapshots provide fast and efficient backup and recovery solutions that achieve aggressive recovery time objective (RTO) and recovery point objective (RPO) SLAs. Space-efficient clones enhance development and test environments.

 As an Azure native service, Azure NetApp Files runs within the Azure data center environment. As a result, you can provision, consume, and scale Azure NetApp Files just like other Azure storage options.

### SQL Server on Azure NetApp Files key value proposition

Maybe add intro sentence to lead in to image.

:::image type="complex" source="./media/sql-server-azure-net-app-files-key-values.png" alt-text="Architecture diagram showing how information flows through a genomics analysis and reporting pipeline." border="false":::
   The diagram contains two boxes. The first, on the left, has the label Azure Data Factory for orchestration. The second box has the label Clinician views. The first box contains several smaller boxes that represent data or various Azure components. Arrows connect the boxes, and numbered labels on the arrows correspond with the numbered steps in the document text. Two arrows flow between the boxes, ending in the Clinician views box. One arrow points to a clinician icon. The other points to a Power BI icon.
:::image-end:::

- For small databases, you can deploy database and log files into a single volume. Such simplified configurations are easy to manage.
- For larger databases, it can be more efficient to configure multiple volumes. You can also use a [manual Quality of Service (QoS) capacity pool][Manual QoS volume quota and throughput] for more granular control over performance requirements.

### Key benefits of SQL Server with Azure NetApp Files

- Simple and reliable service. Azure NetApp Files is a simple-to-consume Azure native platform service. It uses reliability features that the NetApp data management software ONTAP provides. With this software, you can quickly and reliably provision enterprise-grade SMB volumes for SQL Server and other workloads.


## Considerations

The following considerations align with the [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework] and apply to this solution:

### Availability considerations

The service level agreements (SLAs) of most Azure components guarantee availability:


### Scalability considerations

Most Azure services are scalable by design:


### Security considerations

The technologies in this solution meet most companies' requirements for security.

## Deploy the solution

For information on implementing this solution, see [Solution architectures using Azure NetApp Files][Solution architectures using Azure NetApp Files - SQL Server].

## Pricing

With most Azure services, you can reduce costs by only paying for what you use:

- With [Data Factory, your activity run volume determines the cost][Data Factory pricing].
- [Azure Databricks offers many tiers, workloads, and pricing plans][Azure Databricks general pricing information] to help you minimize costs.
- [Blob Storage costs depend on data redundancy options and volume][Azure Storage costs].
- With [Data Lake Storage, pricing depends on many factors: your namespace type, storage capacity, and choice of tier][Data Lake Storage pricing].
- For [Microsoft Genomics, the charge depends on the number of gigabases that each workflow processes][Microsoft Genomics - pricing].

## Next steps


## Related resources

Fully deployable architectures:

[Azure NetApp Files]: https://azure.microsoft.com/en-us/services/netapp/
[Azure Virtual Machines]: https://azure.microsoft.com/en-us/services/virtual-machines/#overview
[Azure Virtual Network]: https://azure.microsoft.com/en-us/services/virtual-network/
[Manual QoS volume quota and throughput]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-performance-considerations#manual-qos-volume-quota-and-throughput
[SLA for Azure NetApp Files]: https://azure.microsoft.com/en-us/support/legal/sla/netapp/v1_1/
[SMB Continuous Availability (CA) shares (Preview)]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/whats-new#march-2021
[Solution architectures using Azure NetApp Files - SQL Server]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server
[What is Azure NetApp Files]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction
[What is SQL Server on Azure Virtual Machines (Windows)]: https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview