Moodle is one of the most popular and widely adopted free, open-source learning management systems. With more than 30 percent of the global market share, Moodle has more than 180,000 customers worldwide.

Since the emergence of COVID-19, Moodle has seen a surge in growth. The company is now the market leader in learning management systems. This growth has forced Moodle to explore options for quickly expanding its business and enabling customers to quickly and efficiently deploy Moodle instances in the cloud. Moodle architecture relies on the Network File System (NFS) 3.0 protocol (NFSv3) for content storage.

Moodle has the following requirements:

- High-throughput, low-latency access to storage.
- A way to scale up the solution to accommodate an increasing number of concurrent users. Autoscaling is preferred.

This article outlines a solution that meets Moodle's needs. At the core of the solution is Azure NetApp Files, a first-party Azure file storage service. You can use this service to migrate and run the most demanding enterprise-scale file workloads in the cloud:

- Native Server Message Block (SMB) version 3, NFSv3, and NFSv4.1 file shares
- Database workloads
- Data warehouse workloads
- High-performance computing applications

By providing a high-bandwidth, low-latency solution for workloads, Azure NetApp Files meets Moodle's performance requirements. This solution is also flexible. Deployments can grow or shrink on demand to make your configuration cost effective.

Another benefit of the solution is its resiliency. You can deploy Moodle on a virtual machine scale set, and you can use Azure NetApp Files to store the learning data files that users access. This configuration provides:

- High availability in a single Azure region.
- Disaster recovery between two Azure regions.

Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

## Potential use cases

This solution applies to Moodle customers. Organizations that use Moodle span many industries including education, business, IT, and finance.

## Architecture

Single-region highly available setup

:::image type="content" source="./media/virtual-machine-compliance-golden-image-publishing-architecture.svg" alt-text="Architecture diagram showing how the solution manages Azure Marketplace images. Illustrated steps include customization, tracking, testing, and publishing." border="false":::

*Download a [Visio file][Visio version of golden image publishing process architecture diagram] of this architecture.*

1. Students access Moodle application data through an Azure Application Gateway.
1. Moodle is written in PHP. Moodle runs in a virtual machine scale set on a web server such as Apache HTTP Server or nginx.
1. Azure NetApp Files makes the content data available to Moodle.
1. The solution uses Azure Cache for Redis for user session caching, locking, and key awareness.
1. A MySQL database stores the learning content, student progress data, and internal data.
1. Learning content enters the system through a secure VPN gateway directly from the customer datacenter.

This single-region setup provides highly available access to the Moodle app and other components with 99.99 percent uptime. If you need a greater uptime percentage, and if you'd like protection against an unlikely Azure region failure, you can replicate the data volumes to a second region. Only the Azure NetApp Files volumes need to be present in that region.

Disaster recovery dual-region setup

:::image type="content" source="./media/virtual-machine-compliance-track-compliance-architecture.svg" alt-text="Architecture diagram showing how the solution manages compliance by assigning policy definitions, evaluating machines, and displaying data in a dashboard." border="false":::

*Download a [Visio file][Visio version of VM compliance architecture diagram] of this architecture.*

1. [Cross-region replication][Cross-region replication of Azure NetApp Files volumes] provides replication for the Azure NetApp Files volumes. This storage-based replication engine is built into the Azure NetApp Files Service.
1. When you use cross-region replication, you don't have to turn on some components during normal operation. So those components don't incur any cost. When a failover occurs, you can start those components and use them with the replicated data volumes.
1. After you've recovered the primary region, the replication direction reverses. The primary region is then updated with any changes that were applied during the failover, and you can fail the service back.
1. [Azure Traffic Manager][What is Traffic Manager?] redirects users to the failover region.

### Components

- [Moodle][Moodle] is a free, open-source learning management system.

- [SQL Managed Instance][Server concepts in Azure Database for MySQL] is a fully managed, scalable cloud database service. As part of the Azure SQL service portfolio, SQL Managed Instance offers SQL Server engine compatibility.

- [Azure Cache for Redis][Azure Redis Cache] is a fully managed, in-memory data store that's based on the open-source software Redis.

- [Azure Virtual Machine Scale Sets][Virtual Machine Scale Sets] provide a way to manage a group of load-balanced VMs. The number of VM instances in a set can automatically increase or decrease in response to demand or a defined schedule.

- [Azure NetApp Files][Cost model for Azure NetApp Files] makes it easy to migrate and run file-based applications with no code changes. This shared file-storage service is a joint development from Microsoft and NetApp, a Microsoft partner.

- [Cross-region replication][Cross-region replication of Azure NetApp Files volumes] provides a way to asynchronously replicate data from an Azure NetApp Files volume in one region to another Azure NetApp Files volume in another region. This capability provides data protection during region-wide outages or disasters.

- [Azure Application Gateway][What is Azure Application Gateway?] is a load balancer that manages traffic to web applications.


- [Traffic Manager][What is Traffic Manager?] is a load balancer that distributes traffic to applications across global Azure regions. Traffic Manager also provides public endpoints with high availability and quick responsiveness.





### Alternatives

To deploy Moodle, you can use any NFS-based shared file service that meets requirements for very low latency, high IOPS, and high throughput. These conditions are especially important for high numbers of concurrent users. You can use an NFS service that's built on top of a set of Linux VMs. But this approach presents manageability, scalability and performance challenges. In contrast, ANF offers a competitive, low-latency solution that delivers excellent performance and secure access to NFS shared storage.

## Considerations

Keep the following points in mind when you implement this solution.

### Scalability considerations

This solution scales up or down as needed:

- Virtual Machine Scale Sets provides automatic scaling of resources. For more information, see [Overview of autoscale with Azure virtual machine scale sets][Overview of autoscale with Azure virtual machine scale sets].
- You can easily and non-intrusively sacle the Azure NetApp Files data storage up and down for capacity or performance reasons. For more information, see [Resize a capacity pool or a volume][Resize a capacity pool or a volume].
- You can adjust the Azure NetApp Files volume service level, which can be either Standard, Premium, or Ultra. The level that you select affects the throughput limit of volumes with automatic quality of service (QoS). For more information, see [Performance considerations for Azure NetApp Files][Performance considerations for Azure NetApp Files].

### Availability considerations

For the Azure NetApp Files availability guarantee, see [SLA for Azure NetApp Files][SLA for Azure NetApp Files].


### Security considerations

For all deployment options, you need to provide a valid Secure Shell (SSH) protocol 2 (SSH-2) RSA public-private key pair. The length should be at least 2048 bits. Azure doesn't support other key formats such as ED25519 and ECDSA. For information about Azure NetApp Files security, see [Security FAQs for Azure NetApp Files][Security FAQs for Azure NetApp Files].

### Resiliency considerations

Azure NetApp Files is built on a bare-metal fleet of redundant, solid-state hardware. The service operates without interruption, even during maintenance operations. For more information about resiliency, see [Fault Tolerance, High Availability and Resiliency in Azure NetApp Files][Fault Tolerance, High Availability and Resiliency in Azure NetApp Files].

### Disaster recovery considerations

As [Architecture][Architecture section of this article] discusses, you can make the solution more resilient by adding a secondary region and using Azure NetApp Files cross-region replication. This functionality efficiently replicates the NFS volumes to a secondary passive region. During the unlikely event of a complete region failure, the application can run in that secondary region.

## Deploy the solution

For a deployment guide for Moodle on Azure NetApp Files, see [Azure NetApp Files for NFS storage with Moodle][Azure NetApp Files for NFS storage with Moodle].

## Pricing

For a medium-sized to large-sized Moodle deployment of approximately 5,000 users with a 10 percent concurrency ratio, the recommended throughput is about 500 MBps. You can build this type of system on a Linux-based Standard_D32s_v4 VM that uses 8 TB of P60 managed disk.

## Next steps


## Related resources

[Architecture section of this article]: #architecture
[Azure NetApp Files for NFS storage with Moodle]: https://techcommunity.microsoft.com/t5/azure-architecture-blog/azure-netapp-files-for-nfs-storage-with-moodle/ba-p/2300630
[Azure Redis Cache]: https://docs.microsoft.com/en-us/rest/api/redis/
[Cost model for Azure NetApp Files]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-cost-model
[Cross-region replication of Azure NetApp Files volumes]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-introduction
[Fault Tolerance, High Availability and Resiliency in Azure NetApp Files]: https://anfcommunity.com/2020/11/05/fault-tolerance-high-availability-and-resiliency-in-azure-netapp-files/
[Moodle]: https://moodle.com/moodlecloud/
[Overview of autoscale with Azure virtual machine scale sets]: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview
[Performance considerations for Azure NetApp Files]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-performance-considerations
[Resize a capacity pool or a volume]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes
[Security FAQs for Azure NetApp Files]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/faq-security
[Server concepts in Azure Database for MySQL]: https://docs.microsoft.com/en-us/azure/mysql/concepts-servers
[SLA for Azure NetApp Files]: https://azure.microsoft.com/en-us/support/legal/sla/netapp/v1_1/
[Virtual Machine Scale Sets]: https://docs.microsoft.com/en-us/rest/api/compute/virtual-machine-scale-sets
[What is Azure Application Gateway?]: https://docs.microsoft.com/en-us/azure/application-gateway/overview
[What is Traffic Manager?]: https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview
