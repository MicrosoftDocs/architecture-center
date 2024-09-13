
Moodle is an open-source learning management system that requires high throughput, low latency access to storage. Many Moodle deployments require easy scalability to adapt to growing demand. This article explains how Moodle can be deployed using Azure Services on Azure Virtual Machine Scale Sets and store user-accessible learning data files in Azure NetApp Files. The article highlights a zonal deployments for high availability and cross-zone replication and also gives examples of a single-zone deployment and deployment with cross-region replication. 

## Architecture

For the best user experience, Moodle requires consistent low latency access to scalable shared storage to meet the demands of office and home workers using the service. Virtual Machine Scale Sets and Azure NetApp Files capacity pools and volumes can be sized up and down as the demand changes.

:::image type="complex" source="./media/azure-netapp-files-moodle-zonal.png" alt-text="Architecture diagram of Azure NetApp Files for Moodle with cross-zone replication." lightbox="./media/azure-netapp-files-moodle-zonal.png" border="false":::
    A diagram that replicates the single-region Azure NetApp Files Moodle deployment. Inside of the same Azure region box, there's a second zone that includes DR versions of the Azure NetApp Files. The Azure Traffic Manager routes students to the application in zone one or zone two.
:::image-end:::

In addition to the Moodle deployment, the architecture uses Azure Azure NetApp Files cross-zone replication to replicate the data volumes to a secondary zone. [Cross-zone replication](/azure/azure-netapp-files/cross-zone-replication-introduction) use availability zones to provide high-availability in a region and replication to a different zone in the same region. . The same benefits apply regarding the presence of compute and ancillary services which only need to be started up and scaled up in failover situations.

### Workflow

Students access the Moodle application data through an Azure Application Gateway where Virtual Machine Scale Sets can be used to build a scalable compute platform running the Moodle app to host users. Azure NetApp Files serves the content data to the Moodle app; a Redis Cache is used for user session caching, locking, and key awareness. The learning content, student progress, and internal data are stored in a MySQL database.

1. Learning content is inserted through a secure VPN gateway directly from the customer datacenter.
1. Students access the content through the application that is deployed on a [Virtual Machine Scale Set](/azure/virtual-machine-scale-sets/overview) through a secure application gateway.
1. The solution can be scaled up or down as demand dictates by adding or removing VMs in the scale set and by adjusting the Azure NetApp Files volume [service level](/azure/azure-netapp-files/azure-netapp-files-performance-considerations).

### Components

- [Moodle](https://moodle.com/moodlecloud) is one of the most popular and widely adopted free, open-source learning management systems.
- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a relational database service powered by the MySQL community edition. You can use Azure Database for MySQL - Flexible Server to host a MySQL database in Azure.
- [Azure Cache for Redis](/azure/well-architected/service-guides/azure-cache-redis/operational-excellence) is a secure data cache and messaging broker that provides high throughput and low-latency access to data for applications.
- [Azure Virtual Machine Scale Sets](/azure/well-architected/service-guides/virtual-machines) let you create and manage a group of load balanced VMs. The number of VM instances can automatically increase or decrease in response to demand or a defined schedule.
- [Azure NetApp Files](/azure/azure-netapp-files) is a first-party Azure service for migrating and running the most demanding enterprise file-workloads in the cloud: native SMB3 and NFSv3 and NFSv4.1 file shares, databases, data warehouse, and high-performance computing applications.

### Alternatives

The Moodle service can be deployed using any NFS based shared file service if requirements for very low latency, high IOPS, and throughput are met, especially for higher numbers of concurrent users. Although an NFS service built on top of a set of Linux VMs can be used, this leaves challenges in the realm of manageability, scalability, and performance. Ultimately Azure NetApp Files offers the lowest latency, best performance and scalability, and secure access to NFS shared storage.

Azure NetApp Files also offers alternative deployment methods with cross-region  replication that improve the disaster preparedness of your deployment. 

#### Alternative deployments with Azure NetApp Files

This diagram captures an example of a single-region deployment:

:::image type="complex" source="./media/azure-netapp-files-moodle-architecture.png" alt-text="Architecture diagram of Azure NetApp Files for Moodle." lightbox="./media/azure-netapp-files-moodle-architecture.png" border="false":::
    A black-lined rectangle denotes an Azure region that contains a virtual network. The virtual network has multiple three smaller rectangles inside of it: two stacked, and one to the right. The top rectangle denotes a network security group the Moodle, a PHP application, an HTTP server, as well as a Redis Cache connected to the third rectangle: the MySQL database. The network security group also includes with a DNS router connected to an application gateway for the Virtual Machine Scale Sets, which is attached to the Azure other rectangle below representing the Azure NetApp Files delegated subnet that contains three volumes and related snapshots. Student access the Moodle through the DNS, while the Azure VPN gateway securely connects the resources to the customer data center.
:::image-end:::

This single-region setup provides highly available access to the Moodle application and other components of the configuration. If you desire protection against unlikely Azure region failure, you can choose to replicate the Azure NetApp Files data volumes to a second region where only the Azure NetApp Files volumes need to be present.

The following diagram captures a setup with cross-region replication:

:::image type="complex" source="./media/azure-netapp-files-moodle-secondary-region.png" alt-text="Architecture diagram of Azure NetApp Files for Moodle with cross-region replication." lightbox="./media/azure-netapp-files-moodle-secondary-region.png" border="false":::
    A diagram that replicates the single-region Azure NetApp Files Moodle deployment. The diagram adds a second black rectangle to the right of the first one, representing a second Azure region. Azure Traffic Manager routes students to either region to access the application. The Azure NetApp Files volumes are replicated to the secondary region for data protection.
:::image-end:::

The Azure NetApp Files volumes are replicated using [cross-region replication](/azure/azure-netapp-files/cross-region-replication-introduction), a storage-based replication engine built into the Azure NetApp Files service. The destination data volumes can be hosted by a capacity pool using the Standard service level during normal operation.

With this approach, some of the components of the setup, like compute and ancillary services, don't have to be started during normal operation. They  therefore don't incur any operational cost. The Virtual Machine Scale Sets can also be scaled down to the minimum.

Only in a disaster recovery scenario do the components need be started and scaled up where required to continue the service using the replicated data volumes. At this time, the service level of the destination Azure NetApp Files volumes can be upgraded to the Premium or Ultra service level if required.

Once the primary region has been recovered, the replication direction is reversed, so the primary region is updated with the changes applied during the failover, and the service can be failed back. Users are redirected to the failover region through [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview), which operates at the DNS layer to quickly and efficiently direct incoming DNS requests based on the routing method of your choice.

## Scenario details

This solution applies to Moodle deployments. Organizations that use Moodle span industries including education, business, IT, and finance.

This article outlines a solution that meets Moodle's needs. At the core of the solution is Azure NetApp Files, a first-party storage service. You can use this service to migrate and run the most demanding enterprise-scale file workloads in the cloud:

- Native Server Message Block (SMB) version 3, NFSv3, and NFSv4.1 file shares
- Database workloads
- Data warehouse workloads
- High-performance computing applications

<!-- revisit -->

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Azure NetApp Files is built on a bare-metal fleet of redundant, solid-state hardware. The service operates without interruption, even during maintenance operations. For more information about resiliency, see [Fault Tolerance, High Availability, and Resiliency in Azure NetApp Files][Fault Tolerance, High Availability, and Resiliency in Azure NetApp Files].

Azure NetApp Files has a guaranteed availability of 99.99%. For the Azure NetApp Files availability guarantee, see the [SLA for Azure NetApp Files][SLA for Azure NetApp Files].

As the [Alternative deployments with Azure NetApp Files section](#alternative-deployments-with-azure-netapp-files) explains, you can make the solution more resilient. You can provide disaster recovery by adding a secondary region and using Azure NetApp Files cross-region replication. This functionality efficiently replicates the NFS volumes to a secondary passive region. During the unlikely event of a complete region failure, the application runs in that secondary region.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For all deployment options, you need to provide a valid Secure Shell (SSH) protocol 2 (SSH-2) RSA public–private key pair. The length should be at least 2,048 bits. Azure doesn't support other key formats such as ED25519 and ECDSA. Azure NetApp Files supports both customer- and platform-managed keys. These solutions provide unrestrained access to stored data, meet compliance requirements, and enhance data security. For information and best practices about Azure NetApp Files security, see [Security FAQs for Azure NetApp Files](/azure/azure-netapp-files/faq-security).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

For a medium-to-large sized Moodle deployment of approximately 5,000 users with a 10% concurrency ratio, the recommended throughput is approximately 500 MB/s. This deployment can be built on a Linux based Standard_D32s_v4 VM infrastructure using 8 TB of P60-managed disk.

Azure NetApp Files offers a more cost-effective solution using 4 TiB of Ultra-service level capacity. If the scale of application is larger, thus requiring more Azure NetApp Files capacity, either the Azure NetApp Files Premium or Standard service levels provide sufficient performance. Using the Premium or Standard service level improves the cost effectiveness.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs for Azure resources for your specific requirements. More information  is available in the [Azure NetApp Files cost model](/azure/azure-netapp-files/azure-netapp-files-cost-model).

For a calculator that computes the Azure NetApp Files performance and total cost of ownership (TCO), see [Azure NetApp Files Performance Calculator](https://aka.ms/anfcalc). Use this calculator to find the optimal balance between capacity, performance, and cost.

Azure NetApp Files also offers [a performance and TCO calculator](https://aka.ms/anfcalc), which you can use to find the most optimal balance between capacity, performance, and cost.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This solution scales up or down as needed:

- Virtual Machine Scale Sets provides automatic scaling of resources. For more information, see [Overview of autoscale with Azure Virtual Machine Scale Sets][Overview of autoscale with Azure virtual machine scale sets].
- You can easily and non-intrusively scale the Azure NetApp Files capacity pools and volumes up and down to meet demand. For more information, see [Resize a capacity pool or a volume][Resize a capacity pool or a volume].
- You can adjust the Azure NetApp Files volume service level, which can be either Standard, Premium, or Ultra. The level that you select affects the throughput limit of volumes with automatic quality of service (QoS). For more information, see [Performance considerations for Azure NetApp Files][Performance considerations for Azure NetApp Files].

## Deploy this scenario

For a deployment guide for Moodle on Azure NetApp Files, see [Azure NetApp Files for NFS storage with Moodle][Azure NetApp Files for NFS storage with Moodle].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Arnt de Gier](https://www.linkedin.com/in/arntdegier) | Technical Marketing Engineer

## Next steps

* [Moodle Cloud option](https://moodle.com/moodlecloud/)
* [Azure Moodle directions on GitHub](https://github.com/Azure/Moodle)

## Related resources

* [Solution architectures using Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-solution-architectures)
* [Moodle docs: Redis cache store](https://docs.moodle.org/311/en/Redis_cache_store#:~:text=Before%20Redis%20is%20available%20as%20a%20cache%20store%2C,as%20an%20application%20or%20session%20level%20cache%20store.)
* [Azure NetApp Files for NFS storage with Moodle](https://techcommunity.microsoft.com/t5/azure-architecture-blog/azure-netapp-files-for-nfs-storage-with-moodle/ba-p/2300630)
* [Automatic scaling with Azure Virtual Machine Scale Sets flexible orchestration mode](https://azure.microsoft.com/updates/automatic-scaling-for-vms-with-azure-virtual-machine-scale-sets-flexible-orchestration-mode/)