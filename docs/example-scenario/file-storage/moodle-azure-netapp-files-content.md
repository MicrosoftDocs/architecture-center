In a single region, this solution provides highly available access to the Moodle app and other components. For detailed information on availability, see [Availability][Availability section of this article], later in this article. You can also use two regions to implement this solution. With two regions, the solution provides disaster recovery. To protect against an unlikely Azure region failure, you replicate the data volumes to the second region. Only the Azure NetApp Files volumes need to be present in that region.

*Apache® is either a registered trademark or trademark of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of this mark.*

## Architecture

### Single-region highly available setup

:::image type="content" source="./media/moodle-azure-netapp-files-single-region-architecture.png" alt-text="Architecture diagram showing how students access Moodle. Other components include Azure NetApp Files, Azure Cache for Redis, and Azure Database for MySQL." border="false":::

*Download a [PowerPoint file][PowerPoint version of architecture diagram] of this architecture.*

1. Students access Moodle application data through [Azure Application Gateway](/azure/application-gateway/overview).
1. Moodle is written in PHP. Moodle runs in a [virtual machine scale set][What are virtual machine scale sets?] on a web server such as Apache HTTP Server or NGINX.
1. [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) makes the content data available to Moodle.
1. The solution uses [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) for user session caching, locking, and key awareness.
1. An [Azure Database for MySQL](/azure/mysql/overview) database stores the learning content, student progress data, and internal data.
1. Learning content enters the system through a secure virtual private network (VPN) gateway directly from the customer datacenter.

### Dual-region disaster recovery setup

:::image type="content" source="./media/moodle-azure-netapp-files-multiple-regions-architecture.png" alt-text="Architecture diagram showing how students access dual-region Moodle, and how cross-region replication copies data volumes from one region to another." border="false":::

*Download a [PowerPoint file][PowerPoint version of architecture diagram] of this architecture.*

1. [Cross-region replication][Cross-region replication of Azure NetApp Files volumes] provides replication for the Azure NetApp Files volumes. This storage-based replication engine is built into Azure NetApp Files.
1. When you use cross-region replication, you don't have to turn on some components during normal operation. So those components don't incur any cost. When a failover occurs, you can start those components and use them with the replicated data volumes.
1. After you recover the primary region, the replication direction reverses. The primary region is updated with any changes that were applied during the failover. You can then fail the service back.
1. [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) directs users to the region that's currently active.

### Components

- [Moodle][Moodle] is a free, open-source learning management system.

- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql) is a fully managed relational database service that's based on the community edition of the open-source MySQL database engine.

- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed, in-memory data store that's based on the open-source software Redis.

- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets) provides a way to manage a group of load-balanced virtual machines (VMs). The number of VMs in a set automatically increases or decreases in response to demand or a defined schedule.

- [Azure NetApp Files](https://azure.microsoft.com/services/netapp) makes it easy to migrate and run file-based applications with no code changes. This shared file-storage service is a joint development from Microsoft and NetApp, a Microsoft partner.

- [Cross-region replication][Cross-region replication of Azure NetApp Files volumes] provides a way to replicate data asynchronously from an Azure NetApp Files volume in one region to another Azure NetApp Files volume in another region. This capability provides data protection during region-wide outages or disasters.

- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway) is a load balancer that manages traffic to web applications.

- [Traffic Manager](https://azure.microsoft.com/services/traffic-manager) is a load balancer that distributes traffic to applications across global Azure regions. Traffic Manager also provides public endpoints with high availability and quick responsiveness.

### Alternatives

To deploy Moodle, you can use any NFS-based shared file service that meets requirements for very low latency, high IOPS, and high throughput. These conditions are especially important for high numbers of concurrent users. You can use an NFS service that's built on top of a set of Linux VMs. But this approach presents manageability, scalability, and performance challenges. In contrast, Azure NetApp Files offers a competitive, low-latency solution that delivers excellent performance and secure access to NFS shared storage.

## Scenario details

Moodle is one of the most popular and widely adopted free, open-source learning management systems. With more than 30 percent of the global market share, Moodle has more than 180,000 customers worldwide. By providing a high-bandwidth, low-latency solution for workloads, Azure NetApp Files meets Moodle's performance requirements. This solution is also flexible. Deployments can grow or shrink on demand to make your configuration cost effective.

Since the emergence of COVID-19, Moodle has seen a surge in growth. The company is now the market leader in learning management systems. This growth has forced Moodle to explore options for quickly expanding its business and enabling customers to quickly and efficiently deploy Moodle instances in the cloud. Moodle architecture relies on the Network File System (NFS) 3.0 protocol (NFSv3) for content storage.

Moodle strives to meet the demands of home workers and to provide the best possible user experience. As a result, Moodle requires:

- Consistent high-throughput, low-latency access to shared storage.
- A way to scale up the solution to accommodate an increasing number of concurrent users. Customers prefer autoscaling configurations.

This article outlines a solution that meets Moodle's needs. At the core of the solution is Azure NetApp Files, a first-party storage service. You can use this service to migrate and run the most demanding enterprise-scale file workloads in the cloud:

- Native Server Message Block (SMB) version 3, NFSv3, and NFSv4.1 file shares
- Database workloads
- Data warehouse workloads
- High-performance computing applications

### Potential use cases

This solution applies to Moodle deployments. Organizations that use Moodle span many industries, including education, business, IT, and finance.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Keep the following points in mind when you implement this solution.

### Scalability

This solution scales up or down as needed:

- Virtual Machine Scale Sets provides automatic scaling of resources. For more information, see [Overview of autoscale with Azure Virtual Machine Scale Sets][Overview of autoscale with Azure virtual machine scale sets].
- You can easily and non-intrusively scale the Azure NetApp Files capacity pools and volumes up and down to meet demand. For more information, see [Resize a capacity pool or a volume][Resize a capacity pool or a volume].
- You can adjust the Azure NetApp Files volume service level, which can be either Standard, Premium, or Ultra. The level that you select affects the throughput limit of volumes with automatic quality of service (QoS). For more information, see [Performance considerations for Azure NetApp Files][Performance considerations for Azure NetApp Files].

### Availability

For the Azure NetApp Files availability guarantee, see [SLA for Azure NetApp Files][SLA for Azure NetApp Files].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For all deployment options, you need to provide a valid Secure Shell (SSH) protocol 2 (SSH-2) RSA public–private key pair. The length should be at least 2048 bits. Azure doesn't support other key formats such as ED25519 and ECDSA. For information about Azure NetApp Files security, see [Security FAQs for Azure NetApp Files][Security FAQs for Azure NetApp Files].

### Resiliency

Azure NetApp Files is built on a bare-metal fleet of redundant, solid-state hardware. The service operates without interruption, even during maintenance operations. For more information about resiliency, see [Fault Tolerance, High Availability, and Resiliency in Azure NetApp Files][Fault Tolerance, High Availability, and Resiliency in Azure NetApp Files].

### Disaster recovery

As [Architecture][Architecture section of this article] explains earlier in this article, you can make the solution more resilient. You can provide disaster recovery by adding a secondary region and using Azure NetApp Files cross-region replication. This functionality efficiently replicates the NFS volumes to a secondary passive region. During the unlikely event of a complete region failure, the application runs in that secondary region.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Consider a medium-sized to large-sized Moodle deployment of approximately 5,000 users with a 10 percent concurrency ratio. The recommended throughput for this case is about 500 MBps. You can build this type of system on a Linux-based Standard_D32s_v4 VM that uses 8 TB of P60 managed disk.

Azure NetApp Files offers a more cost-effective solution. It achieves the recommended throughput of 500 MBps but uses only 4 TB of Ultra service-level capacity. The Premium and Standard service levels are also often sufficient, further improving the cost effectiveness. Even when the scale of the application is larger and the application requires more Azure NetApp Files capacity, these service levels can likely deliver the recommended throughput.

Use the [Azure pricing calculator][Pricing calculator] to estimate the cost of the Azure resources that your implementation requires. For more information on Azure NetApp Files cost modeling, see [Cost model for Azure NetApp Files][Cost model for Azure NetApp Files].

For a calculator that computes the Azure NetApp Files performance and total cost of ownership (TCO), see [Azure NetApp Files Performance Calculator][Azure NetApp Files Performance Calculator]. Use this calculator to find the optimal balance between capacity, performance, and cost.

## Deploy this scenario

For a deployment guide for Moodle on Azure NetApp Files, see [Azure NetApp Files for NFS storage with Moodle][Azure NetApp Files for NFS storage with Moodle].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Arnt de Gier](https://www.linkedin.com/in/arntdegier) | Technical Marketing Engineer

## Next steps

- [The MoodleCloud model, a typical starting model][MoodleCloud]
- [Directions for scaling up or deploying Moodle quickly and efficiently in Azure][Deploy and Manage a Scalable Moodle Cluster on Azure]
- [Solution architectures using Azure NetApp Files][Solution architectures using Azure NetApp Files]
- [Redis cache store][Redis cache store]
- [Azure NetApp Files for NFS storage with Moodle][Azure NetApp Files for NFS storage with Moodle]
- [Public preview: Automatic scaling with Azure Virtual Machine Scale Sets flexible orchestration mode][Public preview: Automatic scaling with Azure Virtual Machine Scale Sets flexible orchestration mode]

Product documentation:

- [What are Azure Virtual Machine Scale Sets?][What are virtual machine scale sets?]
- [What is Azure Database for MySQL?](/azure/mysql/overview)
- [What is Azure Cache for Redis?](/azure/azure-cache-for-redis/cache-overview)
- [What are Azure Virtual Machine Scale Sets?](/azure/virtual-machine-scale-sets/overview)
- [What is Azure NetApp Files?](/azure/azure-netapp-files/azure-netapp-files-introduction)
- [What is Azure Application Gateway?](/azure/application-gateway/overview)
- [What is Azure Traffic Manager?](/azure/traffic-manager/traffic-manager-overview)

## Related resources

- [SQL Server on Azure Virtual Machines with Azure NetApp Files][SQL Server on Azure Virtual Machines with Azure NetApp Files]
- [Oracle Database with Azure NetApp Files][Oracle Database with Azure NetApp Files]
- [Run SAP NetWeaver in Windows on Azure][Run SAP NetWeaver in Windows on Azure]
- [SAS on Azure architecture][SAS on Azure architecture]

[Architecture section of this article]: #architecture
[Availability section of this article]: #availability
[Azure NetApp Files for NFS storage with Moodle]: https://techcommunity.microsoft.com/t5/azure-architecture-blog/azure-netapp-files-for-nfs-storage-with-moodle/ba-p/2300630
[Azure NetApp Files Performance Calculator]: https://bluexp.netapp.com/azure-netapp-files/sizer
[Azure Redis Cache]: /rest/api/redis
[Cost model for Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-cost-model
[Cross-region replication of Azure NetApp Files volumes]: /azure/azure-netapp-files/cross-region-replication-introduction
[Deploy and Manage a Scalable Moodle Cluster on Azure]: https://github.com/Azure/Moodle
[Fault Tolerance, High Availability, and Resiliency in Azure NetApp Files]: https://anfcommunity.com/2020/11/05/fault-tolerance-high-availability-and-resiliency-in-azure-netapp-files/
[Moodle]: https://moodle.com/moodlecloud
[MoodleCloud]: https://moodle.com/moodlecloud
[Oracle Database with Azure NetApp Files]: ./oracle-azure-netapp-files.yml
[Overview of autoscale with Azure virtual machine scale sets]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview
[Performance considerations for Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-performance-considerations
[PowerPoint version of architecture diagram]: https://arch-center.azureedge.net/US-1881446-moodle-azure-netapp-files-architecture.pptx
[Pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Public preview: Automatic scaling with Azure Virtual Machine Scale Sets flexible orchestration mode]: https://azure.microsoft.com/updates/automatic-scaling-for-vms-with-azure-virtual-machine-scale-sets-flexible-orchestration-mode/
[Redis cache store]: https://docs.moodle.org/311/en/Redis_cache_store
[Resize a capacity pool or a volume]: /azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes
[Run SAP NetWeaver in Windows on Azure]: /azure/architecture/guide/sap/sap-netweaver
[SAS on Azure architecture]: ../../guide/sas/sas-overview.yml
[Security FAQs for Azure NetApp Files]: /azure/azure-netapp-files/faq-security
[Server concepts in Azure Database for MySQL]: /azure/mysql/concepts-servers
[SLA for Azure NetApp Files]: https://azure.microsoft.com/support/legal/sla/netapp/v1_1
[Solution architectures using Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-solution-architectures
[SQL Server on Azure Virtual Machines with Azure NetApp Files]: ./sql-server-azure-netapp-files.yml
[Virtual Machine Scale Sets]: /rest/api/compute/virtual-machine-scale-sets
[What are virtual machine scale sets?]: /azure/virtual-machine-scale-sets/overview
[What is Azure Application Gateway?]: /azure/application-gateway/overview
[What is Traffic Manager?]: /azure/traffic-manager/traffic-manager-overview
